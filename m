Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843B16F620C
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjECXZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjECXZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:25:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5215C86B5
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 16:25:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-55a04468981so102029127b3.0
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 16:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683156350; x=1685748350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YfYVgm4V22KIRH92REoFmnqd0qb4XCUf2GX84sOfe6w=;
        b=OmZq6gmWvj0FIdFE45aTXILn/94QK8EbGzv+YyaCcMvs9mesrYXEvGLBIhT6vj7IDa
         MzVghvdOlN2xIIChmHQNvxd4GFCU8gOHVeOlNTboedQuvPyihRjuCTvTjnqgwZanjn1s
         uwJSEYdVFlVY7pgEJH+TkOk4mqdGbEm0kVsrjOWj9rJ7b2RxrW0NimB3iYpc2iZa3HsG
         X9iZlKyMwHdcr4YM7BtZanbVTYc9H8oZay9/axmdJegv+yTbxvv5ueAdDN4e8S5FgGol
         3aj7pHHeyQjh9eCRBRoR4fipNlhtMlhHvHUwzzK0HVTSlf3wt9s//AuMJPaNCt5lLMN0
         CuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683156350; x=1685748350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YfYVgm4V22KIRH92REoFmnqd0qb4XCUf2GX84sOfe6w=;
        b=TebeMVPPWtXGjNDZCivAUwSKsJj85loUvZIb9ulcmVb1u1LimTdXizeuhOfgdds0kB
         PiF3vhC9ceFV1HjLX32rwZLhJL0EYFJl9jrIUvYOsBJPJb+OqYv6CCEUBxmISXWMneeA
         mjccC5TlsToEm455WD+LOhloBFDCRYWuBSgbxkgv0skF0GaTMqTH1XDtU7XFknwGDm3V
         m6FeDUp1LRYxU3i/MHpt9Z0pnMxfB94XxQhM7/JnVCylr/EsQJPiviQb3d/GATTMc5Hz
         fwbAkFKjZJPwz6rYqp+aR6YH6ZG55xqJSDABYcu+936/rhHHad24HYWxM3nGIPm2tYPl
         2J/A==
X-Gm-Message-State: AC+VfDybmbBvTcVkzs3c8LAUw11Ps1q5gU6/mekIHNsJj+2kJQ6L8dgC
        2gZ+me5FWoZNx3VQiZ34OyHvnbei/yw=
X-Google-Smtp-Source: ACHHUZ45lladU/lC3ZOTRb4KKsIWxC7RPUoLGPPo/y+io7gdVsjr+OO40Dfh4Ce2jwlN2leI9DNgF6kbFd0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e904:0:b0:544:cd0e:2f80 with SMTP id
 d4-20020a81e904000000b00544cd0e2f80mr122436ywm.8.1683156350572; Wed, 03 May
 2023 16:25:50 -0700 (PDT)
Date:   Wed, 3 May 2023 16:25:48 -0700
In-Reply-To: <56fa0da83203b20c9945e7c82a0eed11f3d31ea5.camel@intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-2-seanjc@google.com>
 <56fa0da83203b20c9945e7c82a0eed11f3d31ea5.camel@intel.com>
Message-ID: <ZFLtfFjAvuL0JSQj@google.com>
Subject: Re: [PATCH 1/5] KVM: VMX: Open code writing vCPU's PAT in VMX's MSR handler
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Kai Huang wrote:
> On Wed, 2023-05-03 at 11:28 -0700, Sean Christopherson wrote:
> > From: Wenyao Hai <haiwenyao@uniontech.com>
> > 
> > Open code setting "vcpu->arch.pat" in vmx_set_msr() instead of bouncing
> > through kvm_set_msr_common() to get to the same code in kvm_mtrr_set_msr().
> 
> What's the value of doing so, besides saving a function of kvm_set_msr_common()?

To avoid complicating a very simple operation (writing vcpu->arch.pat), and to
align with SVM.

> PAT change shouldn't be something frequent so shouldn't in a performance
> critical path.  Given the PAT logic on Intel and AMD are basically the same ,
> isn't it better to do in kvm_set_msr_common()?

I could go either way on calling into kvm_set_msr_common().  I agree that
performance isn't a concern.  Hmm, and kvm_set_msr_common() still has a case
statement for MSR_IA32_CR_PAT, so handling the write fully in vendor code won't
impact the code generation for other MSRs.

Though I am leaning towards saying we should either handle loads and stores to
vcpu->arch.pat in common code _or_ vendor code, i.e. either teach VMX and SVM to
handle reads of PAT, or have their write paths call kvm_set_msr_common().  A mix
of both is definitely odd.

I don't have strong preference on which of those two we choose.  I dislike duplicating
logic across VMX and SVM, but on the other hands it's so little code.  I think
I'd vote for handling everything in vendor code, mostly because this gives the
appearance that the write can fail, which is silly and misleading.

		ret = kvm_set_msr_common(vcpu, msr_info);

> For instance, given mtrr code is also in common x86, if we ever want to add some
> additional logic to, i.e. calculate effective memtype, isn't better to do handle
> pat in common code too?

FWIW, I highly doubt we'll ever have code like that.  The truly effective memtype
calculations are too different between Intel and AMD, and doing anything useful
with the guest's effective memtype is likely a fool's errand.

> > Note, MSR_IA32_CR_PAT is 0x277, and is very subtly handled by
> > 
> > 	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> > 
> > in kvm_set_msr_common().
> > 
> > Signed-off-by: Wenyao Hai <haiwenyao@uniontech.com>
> > [sean: massage changelog]
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 44fb619803b8..53e249109483 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2294,12 +2294,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
> >  			get_vmcs12(vcpu)->guest_ia32_pat = data;
> >  
> > -		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
> > +		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
> >  			vmcs_write64(GUEST_IA32_PAT, data);
> > -			vcpu->arch.pat = data;
> > -			break;
> > -		}
> > -		ret = kvm_set_msr_common(vcpu, msr_info);
> > +
> > +		vcpu->arch.pat = data;
> >  		break;
> >  	case MSR_IA32_MCG_EXT_CTL:
> >  		if ((!msr_info->host_initiated &&
