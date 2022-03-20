Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380084E1BED
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 14:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245199AbiCTOAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiCTOAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 10:00:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 952E51AEC8D
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 06:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647784738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gIYKIjaOECMtm4Bek+mmjhj5KdamiLQaFTROx28ngw=;
        b=MCgOP9uYtg22Bj0QRvhVh6D7gbynMCJBgLZIfqI6sx5mPwGbtCmG3z+FTpSE0VdJ7Hp83K
        M4bH+Nqs3NkR/W+R6hCpXyWoC2sHMYE/o9mLUnx8KOBzxC4K/svVvPIKQjyL607B6vsAaM
        kdPonXGlgZrbWGXjfUURhSw1Q6YWSP4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-uMsEtdMzPsChwp490qW2og-1; Sun, 20 Mar 2022 09:58:54 -0400
X-MC-Unique: uMsEtdMzPsChwp490qW2og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 733D5811E76;
        Sun, 20 Mar 2022 13:58:54 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CB5540C1421;
        Sun, 20 Mar 2022 13:58:53 +0000 (UTC)
Message-ID: <4e020c1e6431769a583e66639b51215d69b5eac9.camel@redhat.com>
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Cc:     seanjc@google.com
Date:   Sun, 20 Mar 2022 15:58:52 +0200
In-Reply-To: <1dc56110-5f1b-6140-937c-bf4a28ddbe87@redhat.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
         <20220217180831.288210-7-pbonzini@redhat.com>
         <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
         <1dc56110-5f1b-6140-937c-bf4a28ddbe87@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-18 at 17:29 +0100, Paolo Bonzini wrote:
> On 3/17/22 18:43, Maxim Levitsky wrote:
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 20f64e07e359..3388072b2e3b 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -88,7 +88,7 @@ KVM_X86_OP(deliver_interrupt)
> >   KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
> >   KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> >   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> > -KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > +KVM_X86_OP(get_mt_mask)
> >   KVM_X86_OP(load_mmu_pgd)
> >   KVM_X86_OP(has_wbinvd_exit)
> >   KVM_X86_OP(get_l2_tsc_offset)
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index a09b4f1a18f6..0c09292b0611 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4057,6 +4057,11 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
> >          return true;
> >   }
> >   
> > +static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +       return 0;
> > +}
> > +
> >   static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   {
> >          struct vcpu_svm *svm = to_svm(vcpu);
> > @@ -4718,6 +4723,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >          .check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
> >          .apicv_post_state_restore = avic_apicv_post_state_restore,
> >   
> > +       .get_mt_mask = svm_get_mt_mask,
> >          .get_exit_info = svm_get_exit_info,
> >   
> >          .vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> 
> Thanks, I'll send it as a complete patch.  Please reply there with your 
> Signed-off-by.


Honestly, I haven't meant to include this as a fix, but only as a proof of the issue,
but I don't have anything against using this until the underlying issue is fixed.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Related to this, I don't see anything in arch/x86/kernel/static_call.c 
> that limits this code to x86-64:
> 
>                  if (func == &__static_call_return0) {
>                          emulate = code;
>                          code = &xor5rax;
>                  }
> 
> 
> On 32-bit, it will be patched as "dec ax; xor eax, eax" or something 
> like that.  Fortunately it doesn't corrupt any callee-save register but 
> it is not just a bit funky, it's also not a single instruction.
> 
> Paolo
> 


