Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952DF699A4
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbfGORVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 13:21:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:12424 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbfGORVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 13:21:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 10:21:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="250892999"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2019 10:21:39 -0700
Date:   Mon, 15 Jul 2019 10:21:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, max@m00nbsd.net,
        Joao Martins <joao.m.martins@oracle.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Ignore segment base for VMX memory operand
 when segment not FS or GS
Message-ID: <20190715172139.GB789@linux.intel.com>
References: <20190715154744.36134-1-liran.alon@oracle.com>
 <87r26rw9lv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r26rw9lv.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 06:22:52PM +0200, Vitaly Kuznetsov wrote:
> Liran Alon <liran.alon@oracle.com> writes:
> 
> > As reported by Maxime at
> > https://bugzilla.kernel.org/show_bug.cgi?id=204175:
> >
> > In vmx/nested.c::get_vmx_mem_address(), when the guest runs in long mode,
> > the base address of the memory operand is computed with a simple:
> >     *ret = s.base + off;
> >
> > This is incorrect, the base applies only to FS and GS, not to the others.
> > Because of that, if the guest uses a VMX instruction based on DS and has
> > a DS.base that is non-zero, KVM wrongfully adds the base to the
> > resulting address.
> >
> > Reported-by: Maxime Villard <max@m00nbsd.net>
> > Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> > Signed-off-by: Liran Alon <liran.alon@oracle.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 18efb338ed8a..e01e1b6b8167 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4068,6 +4068,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
> >  		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
> >  		 * address when using FS/GS with a non-zero base.
> >  		 */
> > +		if ((seg_reg != VCPU_SREG_FS) && (seg_reg != VCPU_SREG_GS))

I'm pretty sure the internal parantheses are unnecessary.

> > +			s.base = 0;
> 
> (personal preference)
>  
>  I'd rather write this as
> 
>     /* In long mode only FS and GS bases are considered */
>     if (seg_reg == VCPU_SREG_FS || seg_reg == VCPU_SREG_GS)
>        *ret = s.base + off;
>     else 
>        *ret = off;
> 
> >  		*ret = s.base + off;
> >  
> >  		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
> 
> As-is or rewritten with my suggestion,

Likewise,

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
