Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0A2632A79
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 18:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiKURMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 12:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiKURMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 12:12:19 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B6CEB81
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:12:15 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id w4so2375089plp.1
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mWrsUVH7dB6OSSMZm6MOoJV9MHEspgOy930qIPoKKBU=;
        b=nHp+7HQ7Hr+KZQIQsMsn4/3cncaHAMY8Ki9hQ2xw2SxkZxV69l+PCAhgXFVwmgiNcM
         XzAn5pLa5L6/i8pR5KBaiADZaAVH7eF4HWxsbK0INyDgNbC6AUVspDoUTOfwPbIjiXK7
         RN/FoaUMoOgTzrZJjIO83cbPFcd5VsUOOr0Tn0dzmkwhFns80JI++azwSpx/wR1rkLRb
         izv5/HBebWCjSg48U45Sfk09fvoyoCvZ4b+4up5A3KBo9rTpIxcbgtkW7tvAaOVeiawC
         cmGYidS0yK6uSi5KBxtgFsctkeAYneIvKPRZzAPpz1gsPhQ8plJg0CqGbTyNPztY2o9C
         0rVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWrsUVH7dB6OSSMZm6MOoJV9MHEspgOy930qIPoKKBU=;
        b=RH9wxRI/iBEXEPvXFIZBjBjtqmDfrzXgHP9tyiD7E2mGnfvEeVXLLmRrU5/odUdjOQ
         xDscAhSipB225yiQNXUg0GDrNASSrqR4cKh+FBYC5I12J2WFtAwm4SjbTQFKNJsB4rOf
         jriDkUlHoePvcX+/A0gOd2Pll0dvwp+qL5KYj7hkbEkHEQR0uO7ENXt60h6sAdlw691v
         TXQNvAGc37129UOD7b1A7dHtmdyBSEPE2uokBVdI8XXH/oraM5mNcHIK9xMQa++XBYNC
         Hr0LbzlOOJsn11BydZ1JnZ97wt6Kfg4SKMSFULMTJb+5xSpYdR9X+LksuzD+pFRK2khA
         TiSA==
X-Gm-Message-State: ANoB5pm9jXMVcp57kaLaa2OFfpwD2MB5jGf1QJgD8IKfzMwuSc/BlM1o
        UPqshhwASKG7ywL5r//0+39BCA==
X-Google-Smtp-Source: AA0mqf6Ioi1CJekynbdlPwx6GlnejsWldK1j3vkzo+1CxAM/E78HDtXyDPw56G4NFYskwpjburptYw==
X-Received: by 2002:a17:90b:48c8:b0:20b:16bc:8493 with SMTP id li8-20020a17090b48c800b0020b16bc8493mr21644639pjb.210.1669050735117;
        Mon, 21 Nov 2022 09:12:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y15-20020aa79e0f000000b005672daedc8fsm8913951pfq.81.2022.11.21.09.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 09:12:14 -0800 (PST)
Date:   Mon, 21 Nov 2022 17:12:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 10/13] KVM: SVM: Add VNMI support in inject_nmi
Message-ID: <Y3uxayZrhvahkzJt@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-11-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-11-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
> will clear V_NMI to acknowledge processing has started and will keep the
> V_NMI_MASK set until the processor is done with processing the NMI event.
> 
> Also, handle the nmi_l1_to_l2 case such that when it is true then
> NMI to be injected originally comes from L1's VMCB12 EVENTINJ field.
> So adding a check for that case.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index eaa30f8ace518d..9ebfbd0d4b467e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb *vmcb = NULL;

As written, no need to initialize vmcb.  Might be a moot point depending on the
final form of the code.
  
> +	if (is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2) {

Checking nmi_l1_to_l2 is wrong.  KVM should directly re-inject any NMI that was
already recognized by hardware, not just those that were originally injected by
L1.

If another event comes along, e.g. SMI, because an event (NMI) is already injected,
KVM will send a hardware IRQ to interrupt the guest and forcea a VM-Exit so that
the SMI can be injected.  If hardware does the (IMO) sane thing and prioritizes
"real" IRQs over virtual NMIs, the IRQ VM-Exit will occur before the virtual NMI
is processed and KVM will incorrectly service the SMI before the NMI.

I believe the correct way to handle this is to add a @reinjected param to
->inject_nmi(), a la ->inject_irq().  That would also allow adding a sanity check
that KVM never attempts to inject an NMI into L2 if NMIs are supposed to trigger
VM-Exit.

This is the least ugly code I could come up with.  Note, if vNMI is enabled,
hardare sets V_NMI_MASKED if an NMI is injected through event_inj.

static void svm_inject_nmi(struct kvm_vcpu *vcpu, bool reinjected)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	/*
	 * Except for re-injection, KVM should never inject an NMI into L2 if
	 * NMIs are supposed to exit from L2 to L1.
	 */
	WARN_ON_ONCE(!reinjected && is_guest_mode(vcpu) && nested_exit_on_nmi(svm));

	if (is_vnmi_enabled(svm)) {
		if (!reinjected)
			svm->vmcb->control.int_ctl |= V_NMI_PENDING;
		else
			svm->vmcb->control.event_inj = SVM_EVTINJ_VALID |
						       SVM_EVTINJ_TYPE_NMI;
		++vcpu->stat.nmi_injections;
		return;
	}

	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;

	if (svm->nmi_l1_to_l2)
		return;

	vcpu->arch.hflags |= HF_NMI_MASK;
	if (!sev_es_guest(vcpu->kvm))
		svm_set_intercept(svm, INTERCEPT_IRET);
	++vcpu->stat.nmi_injections;
}
