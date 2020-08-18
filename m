Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA022248CE7
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 19:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgHRRYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 13:24:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:53640 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgHRRYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 13:24:32 -0400
IronPort-SDR: 3iyLtd/KTSNEyvLbYaIRjFX/9Xy52JcewiX7dEUUInuVCriM4W2sFONChmbhpS7cvKE7d6xyPu
 wIHjkMuN5/4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="154221887"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="154221887"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 10:24:31 -0700
IronPort-SDR: gPhLTQ2LfWXMaqMvNOjB+IUaHQOUbQkR4N2YSZSVJeTVYVHOAm/4Rx0mX+JtBY9dmu2ezxPYEL
 SqXRX2svw03w==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="334428544"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 10:24:31 -0700
Date:   Tue, 18 Aug 2020 10:24:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Peter Shier <pshier@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates
 detected
Message-ID: <20200818172429.GG15390@linux.intel.com>
References: <20200818004314.216856-1-pshier@google.com>
 <20200818152048.GA15390@linux.intel.com>
 <CALMp9eS5UOPGF0v2vt9aMPEZT7_a6ruJx9n_DLKkjiEb_kCWag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS5UOPGF0v2vt9aMPEZT7_a6ruJx9n_DLKkjiEb_kCWag@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 10:14:39AM -0700, Jim Mattson wrote:
> On Tue, Aug 18, 2020 at 8:20 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > I'd prefer to handle this on the switch from L2->L1.  It avoids adding a
> > kvm_x86_ops and yet another sequence of four VMWRITEs, e.g. I think this
> > will do the trick.
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9c74a732b08d..67465f0ca1b9 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4356,6 +4356,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> >         if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> >                 kvm_vcpu_flush_tlb_current(vcpu);
> >
> > +       if (enable_ept && is_pae_paging(vcpu))
> > +               ept_load_pdptrs(vcpu);
> > +
> 
> Are the mmu->pdptrs[] guaranteed to be valid at this point? If L2 has
> PAE paging enabled, and it has modified CR3 without a VM-exit, where
> are the current PDPTE values read from the vmcs02 into mmu->pdptrs[]?

ept_load_pdptrs() checks kvm_register_is_dirty(vcpu, VCPU_EXREG_PDPTR).  The
idea is basically the same as the above TLB_FLUSH_CURRENT; process pending
requests and/or dirty state for L2 before switching to L1.
