Return-Path: <kvm+bounces-35827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD68A1546C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B69F7A3AD7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7B01A262A;
	Fri, 17 Jan 2025 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnLSyCEa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC4819E960
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131515; cv=none; b=qtoxj43vfyfY1t3Q4dLwp+fGzBqR0GAtBunUgvoALD/EKlT5O6VoYLyJUSVx+AYzEisSC4mwZSVet5ntYEp6QXpq0F3rLt+BwqgGFtMpnJ5iJXZElsCxbIBVghVPlAMhzxZBHx1rQkQ/vkViy4H+iJXtVqob2nSCvyjXOkwPV1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131515; c=relaxed/simple;
	bh=ZVrz94ojaJmLXz+8nwfYBAJnNmKW7701sqR/sQfBv1Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WLa8PS+KYpOPR/7ITVM9AzE7QE18lT/vPA7qIRHqTSe9JwgtlFW1rzZGCqWbIol66y7ZOEMg6tzRQxKqW99SEzF8sUE/OTWGfYfm+yO7oFn9/6uCohTie3WJCrAFlJC2F6raK4/Md/HJ29fqGW0chsfNI7OFRvTMljFp6VTWpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnLSyCEa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737131512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hv0KW7fYMSSagLfysL2TBJIcCa2tSdsq/WH2GzhmHMw=;
	b=JnLSyCEaQLYylxvWvyX22XMtBOD8NOT0A8dwo36FfVv1KgxuhEIlp75EFCi5ivQrOqoPal
	0Sa/USr3WCB3W+yqmPeIzd/qMD6twzwowYAygq0mKt+4SEueOTT0OQ7bCitsBKcln8cslE
	ksmLLq35omaAtNaiG3nz3RAU/M4mTUM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-6mRSgkLEPTG6Cqw9VhquMw-1; Fri, 17 Jan 2025 11:31:49 -0500
X-MC-Unique: 6mRSgkLEPTG6Cqw9VhquMw-1
X-Mimecast-MFC-AGG-ID: 6mRSgkLEPTG6Cqw9VhquMw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361ecebc5bso11660915e9.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131508; x=1737736308;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hv0KW7fYMSSagLfysL2TBJIcCa2tSdsq/WH2GzhmHMw=;
        b=cI2meEIIATihEo1giDfoIi1xSxbHIapwBROxbOqWQFDc/1L73N47edNSs9a7tjAGBw
         A+jgR+0Z5b1hHDU7jjHldQbRU+guOLEtEox96Oh5pIpDHg+F8RTQBwpsKoIgK7EtuBal
         tzJthhkr7z3dlsrhpILXGm0BPQWyq+BA2g5LXdROAXfpd5HV+XMu6YnG2z1S0ijRUtdm
         v85KAA7DgnmnWvWKB/GV6HWCdl7LvNls0+I0xYb4r4fITCaoOAqTUrssZmfs13LARZsf
         LQo4JfG+gk+2vRLdS1tgPnj2hzBDzcamJKveUYpJ69oBlJx4Kg41fhfdeDzk8krBMlk1
         iSaA==
X-Gm-Message-State: AOJu0YynkwQQizOcGPumfA6KwuHouiDrvSLnPSBcQg8+EjxshoRKgoo4
	4JXjAI73owG1M18uj+Lw0Y8TcBmWd6pAOBqIAzHdcwTwP5z2GlO4jC0MCwm17VEiNw3ouxxMd82
	hKaAcNIv7vy19DJnm27UXOskkcoJydcr2ykFhVkuvpy9fAPfTxg==
X-Gm-Gg: ASbGncu6W3zxQ22LZ0JfTed5W4xI2EdxKZLijfafmpGaaChx0FeFEwXiccg65nE2kpK
	P2TVxysbNN2HuiJyB/LNchv8Ns+4ryzxJvolYd0IYii1sZPqidSmJwGcyWtTov01p4wCtzI+qe6
	8NWT51LqURmKZ1fqWefls9LPJgQLP3D0D6NPJCFzi5H1+J4x/JOFZSywNayDodwvFM62Sy5hglM
	U+VU4lPumyy6OghsE7sLSNB11NWZQPScAxNfmyupehNeigdBlU=
X-Received: by 2002:a7b:cb43:0:b0:434:fafe:edb with SMTP id 5b1f17b1804b1-43891427757mr30485315e9.24.1737131508207;
        Fri, 17 Jan 2025 08:31:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdkkSoearKHukxLVKa45YV654jbVJEa7PrWOicfUo/lMNkFhGcyWsAIFQN1iT8OWx+VmtDSg==
X-Received: by 2002:a7b:cb43:0:b0:434:fafe:edb with SMTP id 5b1f17b1804b1-43891427757mr30484935e9.24.1737131507817;
        Fri, 17 Jan 2025 08:31:47 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3214fbdsm2960096f8f.19.2025.01.17.08.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:31:47 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongjie Zou
 <zoudongjie@huawei.com>, stable@vger.kernel
Subject: Re: [PATCH 1/5] KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if
 local APIC isn't in-kernel
In-Reply-To: <20250113222740.1481934-2-seanjc@google.com>
References: <20250113222740.1481934-1-seanjc@google.com>
 <20250113222740.1481934-2-seanjc@google.com>
Date: Fri, 17 Jan 2025 17:31:46 +0100
Message-ID: <87ed118kr1.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Advertise support for Hyper-V's SEND_IPI and SEND_IPI_EX hypercalls if and
> only if the local API is emulated/virtualized by KVM, and explicitly reject
> said hypercalls if the local APIC is emulated in userspace, i.e. don't rely
> on userspace to opt-in to KVM_CAP_HYPERV_ENFORCE_CPUID.
>
> Rejecting SEND_IPI and SEND_IPI_EX fixes a NULL-pointer dereference if
> Hyper-V enlightenments are exposed to the guest without an in-kernel local
> APIC:
>
>   dump_stack+0xbe/0xfd
>   __kasan_report.cold+0x34/0x84
>   kasan_report+0x3a/0x50
>   __apic_accept_irq+0x3a/0x5c0
>   kvm_hv_send_ipi.isra.0+0x34e/0x820
>   kvm_hv_hypercall+0x8d9/0x9d0
>   kvm_emulate_hypercall+0x506/0x7e0
>   __vmx_handle_exit+0x283/0xb60
>   vmx_handle_exit+0x1d/0xd0
>   vcpu_enter_guest+0x16b0/0x24c0
>   vcpu_run+0xc0/0x550
>   kvm_arch_vcpu_ioctl_run+0x170/0x6d0
>   kvm_vcpu_ioctl+0x413/0xb20
>   __se_sys_ioctl+0x111/0x160
>   do_syscal1_64+0x30/0x40
>   entry_SYSCALL_64_after_hwframe+0x67/0xd1
>
> Note, checking the sending vCPU is sufficient, as the per-VM irqchip_mode
> can't be modified after vCPUs are created, i.e. if one vCPU has an
> in-kernel local APIC, then all vCPUs have an in-kernel local APIC.
>
> Reported-by: Dongjie Zou <zoudongjie@huawei.com>
> Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
> Fixes: 2bc39970e932 ("x86/kvm/hyper-v: Introduce KVM_GET_SUPPORTED_HV_CPUID")
> Cc: stable@vger.kernel

.org, as mentioned already

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 4f0a94346d00..44c88537448c 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2226,6 +2226,9 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	u32 vector;
>  	bool all_cpus;
>  
> +	if (!lapic_in_kernel(vcpu))
> +		return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +
>  	if (hc->code == HVCALL_SEND_IPI) {
>  		if (!hc->fast) {
>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
> @@ -2852,7 +2855,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->eax |= HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED;
>  			ent->eax |= HV_X64_APIC_ACCESS_RECOMMENDED;
>  			ent->eax |= HV_X64_RELAXED_TIMING_RECOMMENDED;
> -			ent->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
> +			if (!vcpu || lapic_in_kernel(vcpu))
> +				ent->eax |= HV_X64_CLUSTER_IPI_RECOMMENDED;
>  			ent->eax |= HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED;
>  			if (evmcs_ver)
>  				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


