Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA157CA09
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiGULyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbiGULyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97EBE8323A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oPqDFTZfHjL1Do7GOrA6Llwt7bjGNZFJXqTQGhGkkwk=;
        b=R0mqdCdmUiqKI5U7UnRkOmxGGFtPjrXFvtUk8QUarnP3UklTN6B4WTm8/OmD4lXoEFvgW4
        z7a+Kidw/P/Z6LeZ1l346hxZLep+Y8fksYdva8rsj1eXRCaxnm5XHVBAsNIoXJiMwyiSrZ
        HT4t1Ue8rs5HBLu2QTNJYdY/NHjS5X8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-zVzrVXmoPcyX0TAHe_knXw-1; Thu, 21 Jul 2022 07:54:44 -0400
X-MC-Unique: zVzrVXmoPcyX0TAHe_knXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 291DA811E7A;
        Thu, 21 Jul 2022 11:54:44 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EC0840CF916;
        Thu, 21 Jul 2022 11:54:39 +0000 (UTC)
Message-ID: <8a5984a6c85dd1cc25fb5837df3e9eba82f4e014.camel@redhat.com>
Subject: Re: [PATCH v2 10/11] KVM: x86: SVM: use smram structs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jul 2022 14:54:38 +0300
In-Reply-To: <YtibYud8NY8bgcPZ@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-11-mlevitsk@redhat.com> <YtibYud8NY8bgcPZ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 00:18 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > This removes the last user of put_smstate/GET_SMSTATE so
> > remove these functions as well.
> > 
> > Also add a sanity check that we don't attempt to enter the SMM
> > on non long mode capable guest CPU with a running nested guest.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  6 ------
> >  arch/x86/kvm/svm/svm.c          | 28 +++++++++++++++++-----------
> >  2 files changed, 17 insertions(+), 17 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 1038ccb7056a39..9e8467be96b4e6 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2057,12 +2057,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
> >  #endif
> >  }
> >  
> > -#define put_smstate(type, buf, offset, val)                      \
> > -	*(type *)((buf) + (offset) - 0x7e00) = val
> > -
> > -#define GET_SMSTATE(type, buf, offset)		\
> > -	(*(type *)((buf) + (offset) - 0x7e00))
> > -
> >  int kvm_cpu_dirty_log_size(void);
> >  
> >  int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 136298cfb3fb57..8dcbbe839bef36 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4399,6 +4399,7 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> >  
> >  static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
> >  {
> > +	struct kvm_smram_state_64 *smram = (struct kvm_smram_state_64 *)smstate;
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  	struct kvm_host_map map_save;
> >  	int ret;
> > @@ -4406,10 +4407,17 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
> >  	if (!is_guest_mode(vcpu))
> >  		return 0;
> >  
> > -	/* FED8h - SVM Guest */
> > -	put_smstate(u64, smstate, 0x7ed8, 1);
> > -	/* FEE0h - SVM Guest VMCB Physical Address */
> > -	put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
> > +	/*
> > +	 * 32 bit SMRAM format doesn't preserve EFER and SVM state.
> > +	 * SVM should not be enabled by the userspace without marking
> > +	 * the CPU as at least long mode capable.
> > +	 */
> > +
> > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> > +		return 1;
> 
> Isn't this is an independent bug fix?  I.e. should be in its own patch?

Yes to some extent, patch was small so I didn't bother, but I don't mind splitting it up.

Best regards,
	Maxim Levitsky

> 
> > +
> > +	smram->svm_guest_flag = 1;
> > +	smram->svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
> >  
> >  	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
> >  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];


