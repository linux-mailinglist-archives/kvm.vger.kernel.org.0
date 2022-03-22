Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C744C4E4493
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiCVQzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237565AbiCVQze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C0ED6555
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 09:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647968045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Jo084LvQCbcSnecQoXmq4t4lLvdLb5KzJdzYNU+3k8=;
        b=Z2OvbJMJ4kCIRD8SFP8JIeru5xkIMyOhULHEyqwmahkwEliyub/cFtxm3lP0GHOAQOhLzz
        SH4aIaWFte/hR5LVgZwaAOImMAj/8pS12+qWP3/J7Vk74V75Z06mpl5MEP9MT2tn6eK7Pp
        aB5fnEJKgZHArsEmO8g04iUftlqq7fY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-dcaFnerXNN-nPo7R73tE9g-1; Tue, 22 Mar 2022 12:54:02 -0400
X-MC-Unique: dcaFnerXNN-nPo7R73tE9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9B77801E67;
        Tue, 22 Mar 2022 16:54:01 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0CC4C15D4F;
        Tue, 22 Mar 2022 16:53:58 +0000 (UTC)
Message-ID: <956efa0f77e9a647c209c081b29a94e6c7515014.camel@redhat.com>
Subject: Re: [PATCH v3 2/7] KVM: x86: nSVM: implement nested LBR
 virtualization
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Tue, 22 Mar 2022 18:53:57 +0200
In-Reply-To: <bdbd5050-bce1-33db-20d1-b3023aec4df7@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-3-mlevitsk@redhat.com>
         <bdbd5050-bce1-33db-20d1-b3023aec4df7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 14:00 +0100, Paolo Bonzini wrote:
> On 3/1/22 15:36, Maxim Levitsky wrote:
> > @@ -565,8 +565,19 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
> >   		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
> >   	}
> >   
> > -	if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK))
> > +	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
> > +
> > +		/* Copy LBR related registers from vmcb12,
> > +		 * but make sure that we only pick LBR enable bit from the guest.
> > +		 */
> > +
> > +		svm_copy_lbrs(vmcb12, svm->vmcb);
> > +		svm->vmcb->save.dbgctl &= LBR_CTL_ENABLE_MASK;
> 
> This should be checked against DEBUGCTL_RESERVED_BITS instead in 
> __nested_vmcb_check_save; remember to add dbgctl to struct 
> vmcb_save_area_cached too.

Actually the AMD's manual doesn't specify what happens when this field contains reserved bits.

I did the following test and I see that CPU ignores the reserved bits:


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fa7366fab3bd6..6a9f41941d9ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3875,6 +3875,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
        if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
                x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
+       svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+       svm->vmcb->save.dbgctl = 0xFFFFFFFFFFFFFFFFUL;
+
        svm_vcpu_enter_exit(vcpu);
 
        /*


The VM booted fine and reading DEBUGCTL in the guest returned 0x3f.

Its true that DEBUGCTL has few more bits that are defined on AMD which
I zero here, but for practical purposes only bit that matters is BTF,
and I decided that for now to leave it alone, as currently KVM doesn't
emulate it correctly anyway when LBRs are not enabled.
(look at svm_set_msr, MSR_IA32_DEBUGCTLMSR)

In theory this bit should be passed through by setting host's DEBUGCTL,
just prior to entry to the guest, when only it is enabled,
without LBR virtualization. I'll fix this later.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > +		svm_update_lbrv(&svm->vcpu);
> > +
> > +	} else if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
> >   		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
> > +	}
> >   }




