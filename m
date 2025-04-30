Return-Path: <kvm+bounces-44846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F8BAA41D2
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 06:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C20F7ADC27
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 04:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2CC1DC9B0;
	Wed, 30 Apr 2025 04:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuS2oMjB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016192DC775
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 04:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745987122; cv=none; b=aX2YTJR05cnnl3yc/r5T6oYURmlha91nbKAP9onObyJSQKEoxqGFAWI29mkHrLJ10zeZAMXrGdarfZrt6Sd7jXAdkYJK1xvKWSp/QIUUHtY/v7c45P0xCFB7aOYzXk5ZgGS30+bv8ImTvccVXE9afMzpx1pFjG4wY88QaoW+NMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745987122; c=relaxed/simple;
	bh=YoINL3SCWfkae2dP2gypAqnB4AkqatXeI1a981LEJp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iFp0a7GxPGlbR4PBqHSehjWkqzfBfqRLbvQCDDLpZ49+nQ9ijMjK1wz0goUa3y0VTtCFen5QuAO5gMGZM5KXyIDcPLqVs78gjvIzJ5+orizjG1Kg1hUyf5qKimy31FwSuNltJnJee/HzPLxC474eHAg03B+3KjoiSudN4BkZBV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuS2oMjB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745987119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5/9ZIpgit3K5HEouvbiwaznyb2ZT+dyMuQHH+dHlTBs=;
	b=iuS2oMjBFFRfdYdTYxMlaXsSJ2owImV3s6OFJguaWOxRmHMGfNVCyM2GrQx1CxDa4nUmHx
	3RkI3Ssa+L98MQcH3VlhcSUM0xgnk+/mmJTDmer2tgtlOHuyutQYXPOtwokH92GTlHfnRC
	ls2hSGcpVCOeRAcWEP5jLqu+eDDXq6k=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-GtoiC36oNoGpjesh6AyRRQ-1; Wed, 30 Apr 2025 00:25:18 -0400
X-MC-Unique: GtoiC36oNoGpjesh6AyRRQ-1
X-Mimecast-MFC-AGG-ID: GtoiC36oNoGpjesh6AyRRQ_1745987117
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2241e7e3addso57851885ad.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 21:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745987112; x=1746591912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/9ZIpgit3K5HEouvbiwaznyb2ZT+dyMuQHH+dHlTBs=;
        b=d+kjA4GlXJtsf6nFgrvnoc+1zNAyPFC0j3u3VhHD7p8xrI2a+IYTwYxfpjdKine5W6
         U5vwouxPIv+VYAYUBc+aCqXdSGuWtnOYnjrYxAKaNijau9SFlx79I0SJX5UHX24dHvtZ
         tff0otsD9nnNyuEI6kXtN4w04GwpXHSXta8tgNZflddHXlqxiHUdew5NjJWwTporzU5i
         D3H1SgeG8Tlhuh1qYki6PRYtecRC/i9K87jtOuOezcSA5itQGVwwBsmurRGtCEaIhr6/
         79mhZyyVxJstiG1/5GZlWLDFfkYdLEfZpc2E5de42TvC5AMZdcd+waC2ImWS/jQoKbbR
         0zRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAFe+RrKtdbhMLNdxcg1cU2/KjMY6z4EeiOtfLHp7BEH0Om4CcX5im+4G0aqX3HvOLuvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfAXXUXoVsjvc/wJD8B0u2Di2kN4wdgAp+ye6E0Pot+bWV2K0p
	EuiOIDapU1TOAkDPiLJXi0jqjhe6SNJSN/qrF/yHfocL2fYUKWatZgH5nTyqUiSzEazxdwex7hq
	MOo4jXYjPFuUJDc8KUgaUdz1cZDcGe6f41tuYXv0Ve+zdtNPzyQ==
X-Gm-Gg: ASbGnctVbNj83mjq7bxtWAuspqwb14GzxrNQXf8GLnh3cz4g1F9f3lbU8PSstPrVG0R
	ticU1Ld7ogfymaJZj1uPlIgHCPvccPSGONRPDHxS7zWvlGvLkBHADut7gaxck9Uhox8fNwGukT3
	ehNUFo2LOjlK1WjiYlr+bir4Q5ZeJBedq4VbMH9Bu5BCdOkVlrftJNaKMKsSSrABL2O9Hgah5Xx
	+PjFlazvJxldmkLr7unBffsZBuj23cMvcb3vwq7HkYGhlYe4JURkR++QwRj7ObnTJ18v0MbBdcz
	ns5RWl1tMbSR
X-Received: by 2002:a17:903:1a6f:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22df3590ef6mr30860985ad.38.1745987112439;
        Tue, 29 Apr 2025 21:25:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyXj2p77AmMx3N+ITVW1jQFy+1LPquQePsvvxXex3oWiwLfzusXWyW1Gs0Qv4M8sW36jIdYA==
X-Received: by 2002:a17:903:1a6f:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22df3590ef6mr30860675ad.38.1745987112018;
        Tue, 29 Apr 2025 21:25:12 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c13sm112249685ad.162.2025.04.29.21.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 21:25:11 -0700 (PDT)
Message-ID: <dac9f2c6-d46e-4232-abbd-8aa097f012a5@redhat.com>
Date: Wed, 30 Apr 2025 14:25:02 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/43] arm64: RME: Define the user ABI
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-7-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> There is one (multiplexed) CAP which can be used to create, populate and
> then activate the realm.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Add documentation of new ioctls
>   * Bump the magic numbers to avoid conflicts
> Changes since v6:
>   * Rename some of the symbols to make their usage clearer and avoid
>     repetition.
> Changes from v5:
>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> ---
>   Documentation/virt/kvm/api.rst    | 70 +++++++++++++++++++++++++++++++
>   arch/arm64/include/uapi/asm/kvm.h | 49 ++++++++++++++++++++++
>   include/uapi/linux/kvm.h          | 10 +++++
>   3 files changed, 129 insertions(+)
> 

With below comment addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1f8625b7646a..99ba6c82cf37 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3527,6 +3527,11 @@ Possible features:
>   	      - the KVM_REG_ARM64_SVE_VLS pseudo-register is immutable, and can
>   	        no longer be written using KVM_SET_ONE_REG.
>   
> +	- KVM_ARM_VCPU_REC: Allocate a REC (Realm Execution Context) for this
> +	  VCPU. This must be specified on all VCPUs created in a Realm VM.
> +	  Depends on KVM_CAP_ARM_RME.
> +	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_REC).
> +
>   4.83 KVM_ARM_PREFERRED_TARGET
>   -----------------------------
>   
> @@ -5098,6 +5103,7 @@ Recognised values for feature:
>   
>     =====      ===========================================
>     arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>     =====      ===========================================
>   
>   Finalizes the configuration of the specified vcpu feature.
> @@ -6452,6 +6458,30 @@ the capability to be present.
>   
>   `flags` must currently be zero.
>   
> +4.144 KVM_ARM_VCPU_RMM_PSCI_COMPLETE
> +------------------------------------
> +
> +:Capability: KVM_CAP_ARM_RME
> +:Architectures: arm64
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_arm_rmm_psci_complete (in)
> +:Returns: 0 if successful, < 0 on error
> +
> +::
> +
> +  struct kvm_arm_rmm_psci_complete {
> +	__u64 target_mpidr;
> +	__u32 psci_status;
> +	__u32 padding[3];
> +  };
> +
> +Where PSCI functions are handled by user space, the RMM needs to be informed of
> +the target of the operation using `target_mpidr`, along with the status
> +(`psci_status`). The RMM v1.0 specification defines two functions that require
> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
> +
> +If the kernel is handling PSCI then this is done automatically and the VMM
> +doesn't need to call this ioctl.
>   
>   .. _kvm_run:
>   
> @@ -8280,6 +8310,46 @@ aforementioned registers before the first KVM_RUN. These registers are VM
>   scoped, meaning that the same set of values are presented on all vCPUs in a
>   given VM.
>   
> +7.38 KVM_CAP_ARM_RME
> +--------------------
> +
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: args[0] provides an action, args[1] points to a structure in
> +	     memory for some actions.
> +:Returns: 0 on success, negative value on error
> +
> +Used to configure and set up the memory for a Realm. The available actions are:
> +
> +================================= =============================================
> + KVM_CAP_ARM_RME_CONFIG_REALM     Takes struct arm_rme_config as args[1] and
> +                                  configures realm parameters prior to it being
> +                                  created.
> +
> +                                  Options are ARM_RME_CONFIG_RPV to set the
> +                                  "Realm Personalization Value" and
> +                                  ARM_RME_CONFIG_HASH_ALGO to set the hash
> +                                  algorithm.
> +
> + KVM_CAP_ARM_RME_CREATE_REALM     Request the RMM create the realm. The realm's
> +                                  configuration parameters must be set first.
> +
> + KVM_CAP_ARM_RME_INIT_RIPAS_REALM Takes struct arm_rme_init_ripas as args[1]
> +                                  and sets the RIPAS (Realm IPA State) to
> +                                  RIPAS_RAM of a specified area of the realm's
> +                                  IPA.
> +
> + KVM_CAP_ARM_RME_POPULATE_REALM   Takes struct arm_rme_init_ripas as args[1]
> +                                  and populates a region of protected address
> +                                  space by copying the data from the shared
> +                                  alias.
> +
> + KVM_CAP_ARM_RME_ACTIVATE_REALM   Request the RMM activate the realm. No
> +                                  further changes can be made to the realm's
> +                                  configuration, and VCPUs are not permitted to
> +                                  enter the realm until it has been activated.
                                                               ^^^^^^^^^^^^^^^^^^
s/has been activated/is deactivated

I don't see where the guard is applied to prevent vCPU is added after realm
has been activated. I may missed that. Otherwise, it's something to be improved
n the subsequent patch where a vCPU is created and added to the realm.


> +================================= =============================================
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index af9d9acaf997..b57712880605 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -106,6 +106,7 @@ struct kvm_regs {
>   #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>   #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
>   #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
> +#define KVM_ARM_VCPU_REC		9 /* VCPU REC state as part of Realm */
>   
>   struct kvm_vcpu_init {
>   	__u32 target;
> @@ -429,6 +430,54 @@ enum {
>   #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>   #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>   
> +/* KVM_CAP_ARM_RME on VM fd */
> +#define KVM_CAP_ARM_RME_CONFIG_REALM		0
> +#define KVM_CAP_ARM_RME_CREATE_REALM		1
> +#define KVM_CAP_ARM_RME_INIT_RIPAS_REALM	2
> +#define KVM_CAP_ARM_RME_POPULATE_REALM		3
> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
> +
> +/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
> +#define ARM_RME_CONFIG_RPV			0
> +#define ARM_RME_CONFIG_HASH_ALGO		1
> +
> +#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA256		0
> +#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA512		1
> +
> +#define ARM_RME_CONFIG_RPV_SIZE 64
> +
> +struct arm_rme_config {
> +	__u32 cfg;
> +	union {
> +		/* cfg == ARM_RME_CONFIG_RPV */
> +		struct {
> +			__u8	rpv[ARM_RME_CONFIG_RPV_SIZE];
> +		};
> +
> +		/* cfg == ARM_RME_CONFIG_HASH_ALGO */
> +		struct {
> +			__u32	hash_algo;
> +		};
> +
> +		/* Fix the size of the union */
> +		__u8	reserved[256];
> +	};
> +};
> +
> +#define KVM_ARM_RME_POPULATE_FLAGS_MEASURE	(1 << 0)
> +struct arm_rme_populate_realm {
> +	__u64 base;
> +	__u64 size;
> +	__u32 flags;
> +	__u32 reserved[3];
> +};
> +
> +struct arm_rme_init_ripas {
> +	__u64 base;
> +	__u64 size;
> +	__u64 reserved[2];
> +};
> +
>   /* Device Control API on vcpu fd */
>   #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>   #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..0b8479985581 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -930,6 +930,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
>   #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> +#define KVM_CAP_ARM_RME 240
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
> @@ -1582,4 +1583,13 @@ struct kvm_pre_fault_memory {
>   	__u64 padding[5];
>   };
>   
> +/* Available with KVM_CAP_ARM_RME, only for VMs with KVM_VM_TYPE_ARM_REALM  */
> +struct kvm_arm_rmm_psci_complete {
> +	__u64 target_mpidr;
> +	__u32 psci_status;
> +	__u32 padding[3];
> +};
> +
> +#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd6, struct kvm_arm_rmm_psci_complete)
> +
>   #endif /* __LINUX_KVM_H */

Thanks,
Gavin


