Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E505759C386
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 17:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiHVPzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 11:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiHVPzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 11:55:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C272B625
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:55:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id c16-20020a17090aa61000b001fb3286d9f7so2042799pjq.1
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uvOjvk5/JKpMUdid2qTKTpTlRDvjI4C3kJclOnnPOWU=;
        b=hmBTH3GmURqPsBXekxu7uRrt/53hS3AqzTzmCxJTHg9b7NsYKsfRQb5xMje4t6WGS6
         RZHX2OLkGnt3p+FCYS7RpRJmNQhjqa/7MIkXuwRDT+EMKnV6t1W9UGaPqNsOoPs30rFa
         lUmBWpu+yNYxqta56jmDUGvSMKp1HoJgl90x3kCnJAdOohocNe8y7jui+eGLk2vY58hh
         I9om++sLFjyZvdj9VpdkfqxUrVahO6jrlcNgWKHL6E992708UG08bIg3nlWQjQALi8uU
         ZNeBE0BM2WnXcblW3YbiNaRmW9Gjqwt3XEr3IIYhKDUPQvTyJc5vzP/n5jrdogToXyez
         Nosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uvOjvk5/JKpMUdid2qTKTpTlRDvjI4C3kJclOnnPOWU=;
        b=WdxxOI6HR9qRExb1k6F2+ceWiehvBA/cMvd9ecnGQuqWaOkcCgo9X3wqSdOnqchSA8
         KdrAstsMikBOECLdMI+iFsuWiP38tiAoGhWsU5Gl5atluUgYdTskZdO51tuvmPLG0XqR
         19aPYcfysV/L97e9gpem2/z2S3YNL0n3KZEtztu4GGJDlBRS6jyVEu4v/l2xJWwM1mZv
         nOmI/Ged/OjWutNPZN0zQgFqNFDnIdXFEsHW0DH35WyRdz76iUXq9u01MWZnG7urE9Xn
         ncien8NGjv5+Fs48p3e9Z7GU1BAzLWeUAJ0Nn7hPSFMPbmrL7MFU2W4retKTxYKpGl7K
         yRcA==
X-Gm-Message-State: ACgBeo3NkV2ViNeKDDtFIX8+8IGRIWaqzO2Al8ZkLvFnFDtz3E3EndWJ
        EH6QEcskMLlJkRPInXgU5jjKTA==
X-Google-Smtp-Source: AA6agR5CO1iiLQFd/Z4KgqSR8JMfAz667L9PjZAzFjAneq50mboqRPUGHRGSDH4zqWlhhM96X1J94Q==
X-Received: by 2002:a17:902:9006:b0:172:927e:c19a with SMTP id a6-20020a170902900600b00172927ec19amr20904281plp.162.1661183728778;
        Mon, 22 Aug 2022 08:55:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f26-20020aa79d9a000000b0053602e1d6fcsm2168164pfq.105.2022.08.22.08.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 08:55:28 -0700 (PDT)
Date:   Mon, 22 Aug 2022 15:55:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <YwOm7Ph54vIYAllm@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com>
 <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com>
 <87czcsskkj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czcsskkj.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Aug 18, 2022, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> >> >> + * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
> >> >> + * published TLFS version. When the bit is set, nested hypervisor can use
> >> >> + * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
> >> >> + * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
> >> >> + * specification).
> >> >> + */
> >> >> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)
> >> >
> >> > This bit is now defined[*], but the docs says it's only for perf_global_ctrl.  Are
> >> > we expecting an update to the TLFS?
> >> >
> >> > 	Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl fields
> >> > 	in the enlightened VMCS.
> >> >
> >> > [*] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#hypervisor-nested-virtualization-features---0x4000000a
> >> >
> >> 
> >> Oh well, better this than nothing. I'll ping the people who told me
> >> about this bit that their description is incomplete.
> >
> > Not that it changes anything, but I'd rather have no documentation.  I'd much rather
> > KVM say "this is the undocumented behavior" than "the document behavior is wrong".
> >
> 
> So I reached out to Microsoft and their answer was that for all these new
> eVMCS fields (including *PerfGlobalCtrl) observing architectural VMX
> MSRs should be enough. *PerfGlobalCtrl case is special because of Win11
> bug (if we expose the feature in VMX feature MSRs but don't set
> CPUID.0x4000000A.EBX BIT(0) it just doesn't boot).

I.e. TSC_SCALING shouldn't be gated on the flag?  If so, then the 2-D array approach
is overkill since (a) the CPUID flag only controls PERF_GLOBAL_CTRL and (b) we aren't
expecting any more flags in the future.

What about this for an implementation?

static bool evmcs_has_perf_global_ctrl(struct kvm_vcpu *vcpu)
{
	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);

	/*
	 * Filtering VMX controls for eVMCS compatibility should only be done
	 * for guest accesses, and all such accesses should be gated on Hyper-V
	 * being enabled and initialized.
	 */
	if (WARN_ON_ONCE(!hv_vcpu))
		return false;

	return hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
}

static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu, u32 msr_index)
{
	u32 unsupported_ctrls;

	switch (msr_index) {
	case MSR_IA32_VMX_EXIT_CTLS:
	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
		unsupported_ctrls = EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
		if (!evmcs_has_perf_global_ctrl(vcpu))
			unsupported_ctrls |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
		return unsupported_ctrls;
	case MSR_IA32_VMX_ENTRY_CTLS:
	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
		unsupported_ctrls = EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
		if (!evmcs_has_perf_global_ctrl(vcpu))
			unsupported_ctrls |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
		return unsupported_ctrls;
	case MSR_IA32_VMX_PROCBASED_CTLS2:
		return EVMCS1_UNSUPPORTED_2NDEXEC;
	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
	case MSR_IA32_VMX_PINBASED_CTLS:
		return EVMCS1_UNSUPPORTED_PINCTRL;
	case MSR_IA32_VMX_VMFUNC:
		return EVMCS1_UNSUPPORTED_VMFUNC;
	default:
		KVM_BUG_ON(1, vcpu->kvm);
		return 0;
	}
}

void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
{
	u64 unsupported_ctrls = evmcs_get_unsupported_ctls(vcpu, msr_index);

	if (msr_index == MSR_IA32_VMX_VMFUNC)
		*pdata &= ~unsupported_ctrls;
	else
		*pdata &= ~(unsupported_ctrls << 32);
}


> What I'm still concerned about is future proofing KVM for new
> features. When something is getting added to KVM for which no eVMCS
> field is currently defined, both Hyper-V-on-KVM and KVM-on-Hyper-V cases
> should be taken care of. It would probably be better to reverse our
> filtering, explicitly listing features supported in eVMCS. The lists are
> going to be fairly long but at least we won't have to take care of any
> new architectural feature added to KVM.

Having the filtering be opt-in crossed my mind as well.  Reversing the filtering
can be done after this series though, correct?
