Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765F716643B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 18:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgBTRUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 12:20:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:11467 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbgBTRUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 12:20:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 09:20:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="236307882"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 20 Feb 2020 09:20:38 -0800
Date:   Thu, 20 Feb 2020 09:20:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linmiaohe <linmiaohe@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: avoid calculating pending eoi from an
 uninitialized val
Message-ID: <20200220172038.GB3972@linux.intel.com>
References: <1582213006-488-1-git-send-email-linmiaohe@huawei.com>
 <8736b56wxe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736b56wxe.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 05:33:17PM +0100, Vitaly Kuznetsov wrote:
> linmiaohe <linmiaohe@huawei.com> writes:
> 
> > From: Miaohe Lin <linmiaohe@huawei.com>
> >
> > When get user eoi value failed, var val would be uninitialized and result
> > in calculating pending eoi from an uninitialized val. Initialize var val
> > to 0 to fix this case.
> 
> Let me try to suggest an alternative wording,
> 
> "When pv_eoi_get_user() fails, 'val' may remain uninitialized and the
> return value of pv_eoi_get_pending() becomes random. Fix the issue by
> initializing the variable."
> 
> >
> > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> > ---
> >  arch/x86/kvm/lapic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 4f14ec7525f6..7e77e94f3176 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -626,7 +626,7 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
> >  
> >  static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
> >  {
> > -	u8 val;
> > +	u8 val = 0;

Rather than initialize @val, I'd prefer to explicitly handle the error,
similar to pv_eoi_clr_pending() and pv_eoi_set_pending(), e.g.

	u8 val;

	if (pv_eoi_get_user(vcpu, &val) < 0) {
		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
		return false;
	}
	return val & 0x1;

> >  	if (pv_eoi_get_user(vcpu, &val) < 0)
> >  		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
> >  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> But why compilers don't complain?

Clang might?
