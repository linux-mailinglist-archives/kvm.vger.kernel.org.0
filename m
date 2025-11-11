Return-Path: <kvm+bounces-62805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D31C4F578
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:58:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B4AA3A88AE
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE3D3A1CF3;
	Tue, 11 Nov 2025 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZQIINRPz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D4F2FCBEF
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883875; cv=none; b=p5kASypo05E/ZWgCbgQyvwGXQRmdmpJVDPXqgy40ZYYOFRC8VS7HtNfD2StyL4AKRwl3c4tNWO2U3pmW54PyhRMUbZ+Xkeo0pFeCA17WB1KR+lzzcW8+ajq8cQoym4fl7Ht2JnXdd07CPeNBSgSEPcnwMaOvu29fKTFSaFEhdSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883875; c=relaxed/simple;
	bh=Ua18poE0n61krzU4ifKvt7+6Dr5IAwrjucPZPapN7G8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpYroV5Xm9VhLSplYsXgtxjbVZZ4b1p+LZn9OrL2QeM+js/0q7ibkx8S2eSGe5XzL3yihTmHNrX9PbdPAtiXqL5MMOSOVJszvd4sLlR/pE/IWN42xnptgJDXOQ3MlJNE9Zfh3Tk2Sbo0+YvviLB+BAyizwY8okHd7EUTfqTKslI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZQIINRPz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762883872;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lgu0Ck5YyznAWG1i65dblATGVHtQNlg1aO/WGnU5EJc=;
	b=ZQIINRPzpIl8H9x2cP1WLbKzWfeSS6rauNmQn3wi8k6TrfANSdr3FxvR62QWFrcb4lOD46
	mSFZ4xb1v1z/WxDwqLrS/fAE7AooVCq+ZLmSWo4YzfvpOB5/WoqE7GxABKAusbFaG6jYAR
	qqtym1rE9H1GMvq+7ZCOgIIYtSpi8pA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-24MV3GCFMvWoE0-F-Wt6dA-1; Tue, 11 Nov 2025 12:57:51 -0500
X-MC-Unique: 24MV3GCFMvWoE0-F-Wt6dA-1
X-Mimecast-MFC-AGG-ID: 24MV3GCFMvWoE0-F-Wt6dA_1762883871
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4edb84fc9bbso33455561cf.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 09:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883871; x=1763488671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lgu0Ck5YyznAWG1i65dblATGVHtQNlg1aO/WGnU5EJc=;
        b=Alf57ibo8b0p066ctptUZ8HkmUryg7Wi/LrjLAzPmArlm6RnjhF/ykJbmo1ddaHBae
         ca6pF/hvUoXzNMunC6ne8euBoIrr93bqRB9RDuvSBn98+uC5SQUOEpmEzH9as93dWd0B
         HQVw/idlrNbhirWTPfdyww3ll+qwRqhTPUHFVhTZwISUD0btft6PPAgCJAIsn5QIdiwX
         msCW9VS5ZJn7WsU+OSzSMiAvJn1JmdaESfvNnkKB5v/OKVVjaxGqMlONI8wgjv9rGmw7
         p5cW3FfQNgCgLnmTmTsk35NxjyHWg4elbdJLCat4G5VgyaMu9wFFLpjNOGOMmjyOa0Q5
         SiIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxB9vrRcVQDAdmCC3HFRZQCmuyeP7fd5z3aUho4UlFZeikkbdnxNbeWPnmur56Y14oTcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCMw5NsJGbUUkT87YgsYd0WKAV/wFOpE+aR3kFPu1WTbNmb+HA
	Z3/qMBvUjuD0my2DpyJRvK6ekDRwjr71SXr2yZl5LX7NzClC3hW2lpr5TcayCELQcmR24pqXua9
	fwJwhCbIegk3GN7BLHeimZcUZ3aoXcx3Km6Dm1hhBrGXM7IZSU6hHPw==
X-Gm-Gg: ASbGncvmDIqVeDXXQdHBwcIgFpDKvjYbOMb+Nv/xLSJbB8lPB1Ot7bqZ4GyQf63C8fU
	TlhWZKF+tfYVRu5sOlo8WjYrruAgPnCYTAqncDt9FkOLC+26qPboASmMIhuBX1TTh8hZSNwJdx+
	PO8MvVElk6n3VLzIhu4uVNElul8gz4GwOZIBYeDnd3Ztjh2FiK3zDTMGcvAqhD+8NPUMtk1qjsl
	H0F8yaho//Rj+rj+z7RU/ATcRuy6tAaC9ySTOH23VLYejMEqSdL1tpTXL7iC7/zfMtBcI/BkZBY
	gyPb/u4ZObocpndxRVIPr/8xmTM+KiYtMQl4wVDAOXlOAKytDzX2s4HFK+ARyDO+Lwz7G9q7SLW
	oodBxuZSTpTCUYGZV7jM6h3Sx/YCxyvHTfBlv3zKif7y64e0qzWTrTGdM
X-Received: by 2002:a05:622a:188d:b0:4ed:1ccb:e604 with SMTP id d75a77b69052e-4eddb82b388mr2963261cf.11.1762883871009;
        Tue, 11 Nov 2025 09:57:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgy8Y2ETN6jhMS8VG62OyFcw269nFSuIGAcybI6nZ8cge2kSlujkUzY+J9XzGPpFYAEfeCTQ==
X-Received: by 2002:a05:622a:188d:b0:4ed:1ccb:e604 with SMTP id d75a77b69052e-4eddb82b388mr2962891cf.11.1762883870608;
        Tue, 11 Nov 2025 09:57:50 -0800 (PST)
Received: from [10.188.251.182] (cust-east-par-46-193-65-163.cust.wifirst.net. [46.193.65.163])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda5956968sm71729391cf.6.2025.11.11.09.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:57:50 -0800 (PST)
Message-ID: <0795ff4a-50d1-4b2d-84bf-e1bc9da11ba6@redhat.com>
Date: Tue, 11 Nov 2025 18:57:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251030165905.73295-1-sebott@redhat.com>
 <20251030165905.73295-3-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251030165905.73295-3-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/30/25 5:59 PM, Sebastian Ott wrote:
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 ++++
>  target/arm/kvm.c                 | 60 +++++++++++++++++++++++++++++++-
>  3 files changed, 70 insertions(+), 1 deletion(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b..1d32ce0fee 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>  
> +``kvm-psci-version``
> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
> +  PSCI version emulated by the kernel. Current valid values are:
> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> +
>  TCG VCPU Features
>  =================
>  
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 39f2b2e54d..c2032070b7 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -981,6 +981,12 @@ struct ArchCPU {
>       */
>      uint32_t psci_version;
>  
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t prop_psci_version;
> +
>      /* Current power state, access guarded by BQL */
>      ARMPSCIState power_state;
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..c53b307b76 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>  
> +struct psci_version {
> +    uint32_t number;
> +    const char *str;
> +};
> +
> +static const struct psci_version psci_versions[] = {
> +    { QEMU_PSCI_VERSION_0_1, "0.1" },
> +    { QEMU_PSCI_VERSION_0_2, "0.2" },
> +    { QEMU_PSCI_VERSION_1_0, "1.0" },
> +    { QEMU_PSCI_VERSION_1_1, "1.1" },
> +    { QEMU_PSCI_VERSION_1_2, "1.2" },
> +    { QEMU_PSCI_VERSION_1_3, "1.3" },
> +    { -1, NULL },
> +};
> +
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (ver->number == cpu->prop_psci_version)
I still have the same question/comment as on v1. In case the end user
does not override the psci version I think you want to return the
default value, retrieved from KVM through KVM_REG_ARM_PSCI_VERSION and
which populates cpu->psci_version. So to me you should use
cpu->psci_version instead

> +            return g_strdup(ver->str);
> +    }
> +
> +    g_assert_not_reached();
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (!strcmp(value, ver->str)) {
> +            cpu->prop_psci_version = ver->number;
> +            return;
> +        }
> +    }
> +
> +    error_setg(errp, "Invalid PSCI-version value");
> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                               kvm_steal_time_set);
>      object_property_set_description(obj, "kvm-steal-time",
>                                      "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
> +                            kvm_set_psci_version);
> +    object_property_set_description(obj, "kvm-psci-version",
> +                                    "Set PSCI version. "
> +                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
>  }
>  
>  bool kvm_arm_pmu_supported(void)
> @@ -1959,7 +2008,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (cs->start_powered_off) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>      }
> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
I don't understand what this change stands for. Please document it
through both a comment and a commit msg explanation

Thanks

Eric
> +        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> @@ -1998,6 +2048,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>  
> +    if (cpu->prop_psci_version) {
> +        psciver = cpu->prop_psci_version;
> +        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
> +        if (ret) {
> +            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);
> +            return ret;
> +        }
> +    }
>      /*
>       * KVM reports the exact PSCI version it is implementing via a
>       * special sysreg. If it is present, use its contents to determine


