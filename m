Return-Path: <kvm+bounces-72663-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0O3HEB7wp2mWlwAAu9opvQ
	(envelope-from <kvm+bounces-72663-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:41:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A43561FCC1B
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AAFD03115ACC
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 08:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF532391845;
	Wed,  4 Mar 2026 08:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCVY7PVv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQd0P/uh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3675E375AD9
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 08:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772613385; cv=none; b=Fe/b/Gg6Wfokv/Fy58crsEtYyhEvt9saR0c3vqrtpn4Yn6uz87j+K1gR0N26ylxnVEA0ICKx0pH0ScsookcS+8Gs/Iw1Iiwn4tNab4s/RqaLnt6zuIPbFE0XBPmJ8fuD0SRsa5rE8oCe7TeAMEX3DjQ23XWPqPxpEp24QUnI5Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772613385; c=relaxed/simple;
	bh=Jd1aaV467fk1kqAGA4F9wKW75W9/mq7tq7aMFmhVX0Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mequ3RXM1NzF1UQxGDxcpiGXMcLcO8niGNvweKqc2b9AO9Qy9TJ7oHq9J/YAq5Wp05qReEs8JSgrgZF0xjxcMGt/gbswn08BxFh329R92155JZO4ddXyi4pnPj8PCKZSHYszOCtrHApKFPFkaCn+D2yUq38IM3Cb75xXcigwvu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCVY7PVv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQd0P/uh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772613383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgQ4/WuIi2IMDLFjnCM3cSYg+YpvYB+CaxzfN9HB8CY=;
	b=VCVY7PVv2ZU82QY0c3nVPwRcvINpwEiklECniHkcE1MaX2h2lkEwzA4WsGq86oxGUZYkcT
	0kyotcsAum9Q8TPoFgwUqEjj2MGB9xoW18mB+Fd+W9SBqONo7lpxOWyFAA6jRdi+vj3+IF
	QrGA4VDp2odOsewkI5haTn2PXEaLkHg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-m7i4iRaHPRixatUQVHcXHg-1; Wed, 04 Mar 2026 03:36:21 -0500
X-MC-Unique: m7i4iRaHPRixatUQVHcXHg-1
X-Mimecast-MFC-AGG-ID: m7i4iRaHPRixatUQVHcXHg_1772613381
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4837246211bso78186985e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 00:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772613380; x=1773218180; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgQ4/WuIi2IMDLFjnCM3cSYg+YpvYB+CaxzfN9HB8CY=;
        b=IQd0P/uhRacXNWGo/V6ihGhCpym1wHxejTcRAL1Gm6ychQ5GqGIVgIOVpuVMByQg/y
         2HgMIFP9MeC4T2a0XsO7bBt/grSihZz6bt7otAFj2B35KzjQIh86XATBQFn1gpXFV2BW
         tilC3eAR1VisL4Aw0o+AS8xs3SG0rPpK7HT1qpDTdM4k5nZb5P2WEXpKFsamv23P+0nY
         0rvy5D0KAQ1sTeExCUJT5/i/wKyHCIgoU/r9KYSUdz+1TuFTWiWZNMBJjgq57b2PX+gr
         hIsHvtYcdDsg2w9YvR0fb3tHmcfCk75llhVEftwAtZ8uHySd9vU8/vGexJ2RHeUDZd7m
         dsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772613380; x=1773218180;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZgQ4/WuIi2IMDLFjnCM3cSYg+YpvYB+CaxzfN9HB8CY=;
        b=ejAnzepCMQb4iuoX+VS4VqSnEr6EYsg4JjTVoMZKuZgkHRTwwhgNN+QWIUZu7yympc
         axo4X6kQhNBUPnI11ZaTV4Krq4JFkqz15MpCKERfRqwgwS+Q1NJwxDWZBKAe2ps/iwkm
         8UfDfVV+CweF6jFVM7yCZxwICTMgrLfGGK9DuOs3vk5DpE/dDR/UMRmX0B9znUZOGKIu
         iAw73OvPxCsvunX0gLt9Cx0MacsHIbzEX6TbJ64jWxpilLjtgdk+TSzD73pwSlh87WPM
         Fe9FbD8vl8+fGzw12Q28jJRPerZC3I5pVijtaQYtTHGoFXIuE0owX8MaBlSCrLiznq75
         zlmg==
X-Gm-Message-State: AOJu0YyO+NV0fSLmiMKVPCXSd666D45rE2+teuaGJQ2qq08WjFK32JfR
	Q6zUvm5alc4csy7/z86Lw9hrWwY0dHu9w3HhIQLf3Ooz2AykXKKWpBGFWpnIssYRTBVtHofCHsl
	SDXduIvWMzI3aMiMbz6S/fVapjn8MXhSIJX979LBWf0jAlb/JLtEg8JJiaEFSUw==
X-Gm-Gg: ATEYQzx3/a45jErfG+O4LL3WdlDVze6cYNlSjDE3OqoQnn0S60bYZd4i6vaIneqRybJ
	TFmcnY2+x2goPaFM8w8HrrexKcS5I0rKKp12QOHxq+tlf44NU4k2OUPjgfEEb1RN0K8t5d+js+e
	gbqugg/AgWJ8z1L50So2ZwuWBdqqe3asBiJTQe3SCS73780FkqlMDLzqa8xb2SUOkXvLGfyyHXY
	kcozI2MLeJBJrTByKeNO+lZhO16Qf+t6i5tXz/yoQMnOwrldQS3CpbeM9GoaJ4dZLwUeBHHYBdE
	fBTDyZtBI83BwPU21VeuSnfSRlF0Xwlw4mrzNypy4u4R/aPBqNIH9tiiLwyBm+HKOonas0zwKZC
	evr/RaHC86vyV4bWc8Q==
X-Received: by 2002:a05:600c:45c6:b0:483:c12b:fe4b with SMTP id 5b1f17b1804b1-4851984953emr17559315e9.9.1772613380415;
        Wed, 04 Mar 2026 00:36:20 -0800 (PST)
X-Received: by 2002:a05:600c:45c6:b0:483:c12b:fe4b with SMTP id 5b1f17b1804b1-4851984953emr17558675e9.9.1772613379272;
        Wed, 04 Mar 2026 00:36:19 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485187c2ef2sm36649635e9.5.2026.03.04.00.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 00:36:18 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Cheng
 <chengkev@google.com>
Subject: Re: [PATCH v5 1/2] KVM: nSVM: Raise #UD if unhandled VMMCALL isn't
 intercepted by L1
In-Reply-To: <20260304002223.1105129-2-seanjc@google.com>
References: <20260304002223.1105129-1-seanjc@google.com>
 <20260304002223.1105129-2-seanjc@google.com>
Date: Wed, 04 Mar 2026 09:36:17 +0100
Message-ID: <87bjh4f0u6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: A43561FCC1B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72663-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[vkuznets@redhat.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,msgid.link:url]
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> From: Kevin Cheng <chengkev@google.com>
>
> Explicitly synthesize a #UD for VMMCALL if L2 is active, L1 does NOT want
> to intercept VMMCALL, nested_svm_l2_tlb_flush_enabled() is true, and the
> hypercall is something other than one of the supported Hyper-V hypercalls.
> When all of the above conditions are met, KVM will intercept VMMCALL but
> never forward it to L1, i.e. will let L2 make hypercalls as if it were L1.
>
> The TLFS says a whole lot of nothing about this scenario, so go with the
> architectural behavior, which says that VMMCALL #UDs if it's not
> intercepted.
>
> Opportunistically do a 2-for-1 stub trade by stub-ifying the new API
> instead of the helpers it uses.  The last remaining "single" stub will
> soon be dropped as well.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Fixes: 3f4a812edf5c ("KVM: nSVM: hyper-v: Enable L2 TLB flush")
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> Link: https://patch.msgid.link/20260228033328.2285047-5-chengkev@google.com
> [sean: rewrite changelog and comment, tag for stable, remove defunct stubs]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.h     |  8 --------
>  arch/x86/kvm/svm/hyperv.h | 11 +++++++++++
>  arch/x86/kvm/svm/nested.c |  4 +---
>  arch/x86/kvm/svm/svm.c    | 19 ++++++++++++++++++-
>  4 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 6ce160ffa678..6301f79fcbae 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -305,14 +305,6 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>  {
>  	return false;
>  }
> -static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
> -{
> -	return false;
> -}
> -static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
> -{
> -	return false;
> -}
>  static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
>  {
>  	return 0;
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index d3f8bfc05832..9af03970d40c 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -41,6 +41,13 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
>  	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
>  }
>  
> +static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
> +{
> +	return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
> +	       nested_svm_l2_tlb_flush_enabled(vcpu) &&
> +	       kvm_hv_is_tlb_flush_hcall(vcpu);
> +}
> +
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else /* CONFIG_KVM_HYPERV */
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
> @@ -48,6 +55,10 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
>  {
>  	return false;
>  }
> +static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
>  static inline void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu) {}
>  #endif /* CONFIG_KVM_HYPERV */
>  
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 53ab6ce3cc26..750bf93c5341 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1674,9 +1674,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
>  	}
>  	case SVM_EXIT_VMMCALL:
>  		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
> -		if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
> -		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
> -		    kvm_hv_is_tlb_flush_hcall(vcpu))
> +		if (nested_svm_is_l2_tlb_flush_hcall(vcpu))
>  			return NESTED_EXIT_HOST;
>  		break;
>  	default:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8f8bc863e214..38a2fad81ad8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -52,6 +52,7 @@
>  #include "svm.h"
>  #include "svm_ops.h"
>  
> +#include "hyperv.h"
>  #include "kvm_onhyperv.h"
>  #include "svm_onhyperv.h"
>  
> @@ -3228,6 +3229,22 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Inject a #UD if L2 is active and the VMMCALL isn't a Hyper-V TLB
> +	 * hypercall, as VMMCALL #UDs if it's not intercepted, and this path is
> +	 * reachable if and only if L1 doesn't want to intercept VMMCALL or has
> +	 * enabled L0 (KVM) handling of Hyper-V L2 TLB flush hypercalls.
> +	 */
> +	if (is_guest_mode(vcpu) && !nested_svm_is_l2_tlb_flush_hcall(vcpu)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
> +	}
> +
> +	return kvm_emulate_hypercall(vcpu);
> +}
> +
>  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3278,7 +3295,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
>  	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
>  	[SVM_EXIT_VMRUN]			= vmrun_interception,
> -	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
> +	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
>  	[SVM_EXIT_VMLOAD]			= vmload_interception,
>  	[SVM_EXIT_VMSAVE]			= vmsave_interception,
>  	[SVM_EXIT_STGI]				= stgi_interception,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


