Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CE0138CB6
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 09:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgAMIRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 03:17:13 -0500
Received: from mga14.intel.com ([192.55.52.115]:33732 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbgAMIRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 03:17:13 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 00:17:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="272968134"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2020 00:17:11 -0800
Date:   Mon, 13 Jan 2020 16:21:32 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 05/10] x86: spp: Introduce user-space SPP
 IOCTLs
Message-ID: <20200113082132.GG12253@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-6-weijiang.yang@intel.com>
 <20200110181053.GH21485@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110181053.GH21485@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 10:10:53AM -0800, Sean Christopherson wrote:
> On Thu, Jan 02, 2020 at 02:13:14PM +0800, Yang Weijiang wrote:
> > User application, e.g., QEMU or VMI, must initialize SPP
> > before gets/sets SPP subpages, the dynamic initialization is to
> > reduce the extra storage cost if the SPP feature is not not used.
> > 
> > Co-developed-by: He Chen <he.chen@linux.intel.com>
> > Signed-off-by: He Chen <he.chen@linux.intel.com>
> > Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++
> >  arch/x86/kvm/mmu/spp.c          | 44 +++++++++++++++
> >  arch/x86/kvm/mmu/spp.h          |  9 ++++
> >  arch/x86/kvm/vmx/vmx.c          | 15 ++++++
> >  arch/x86/kvm/x86.c              | 95 ++++++++++++++++++++++++++++++++-
> >  include/uapi/linux/kvm.h        |  3 ++
> >  6 files changed, 169 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f5145b86d620..c7a9f03f39a7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1238,6 +1238,10 @@ struct kvm_x86_ops {
> >  
> >  	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
> >  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> > +
> > +	int (*init_spp)(struct kvm *kvm);
> > +	int (*flush_subpages)(struct kvm *kvm, u64 gfn, u32 npages);
> > +	int (*get_inst_len)(struct kvm_vcpu *vcpu);
> 
> If this is necessary, which hopefully it isn't, then get_insn_len() to be
> consistent with other KVM nomenclature.
>
Yep, will change it.

> A comment for the series overall, it needs a lot of work to properly order
> code between patches.  E.g. this patch introduces get_inst_len() without
> any justification in the changelog and without a user.  At best it's
> confusing, at worst this series will be impossible to bisect.

I'll double check the patch and add more comments on some confusing
points. Meanwhile, will re-order some code to make the serial testable,
thanks a lot for your careful review!

