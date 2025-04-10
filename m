Return-Path: <kvm+bounces-43084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7795BA843A3
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 14:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27AE99A080F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 12:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A6828540E;
	Thu, 10 Apr 2025 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uWyi68ix"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805ED2853F8
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 12:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744289212; cv=none; b=as5U/wzxa1F46n+xLpMt9BG78g1XI+QcF3APPbZqYTZImCNPuKu8u3zWzZyhS+D7EUZKbpf1vMszBRAQuawU/ajAhzQrt2DZAt8+Gad97IeAcgZtyVfE/mw6brKgEZ/ir4rXOftPeBnMZS4Xhoajl4wxvlhXlgVr12G4ShOdjjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744289212; c=relaxed/simple;
	bh=3gSCwmtO2wNBppWSqNgk4w3LORvD7rp3e1g45ggnjPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6+0cmDuQ9n0kEm59DFg82VlGNALDUrHiAyb+i4SUrzTIfVNWKlw0L9dkFHez7VRcIqjOEoeveOPOzQN9I+/w7mMvUnLI2/+IY36Mh3lYl1WkAeck/ejkTH6AfshYf7P0fBjNREG3G5SThmM5NnIuoSe/vHD+5Pv1HutB2crUo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uWyi68ix; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so8523975e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 05:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744289209; x=1744894009; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zZXIo1fhTP6w3XfC9tv2GhzcTe3ZMQskxjXxbZzFahQ=;
        b=uWyi68ixALHouGOgGArprlsya390GAmMvT3gFf5CrJmWatWEazm/cl9mAKtniOzEb1
         GuO3seIEUj/6urjrgACTAm88KPaPMEHYx6QqaBDjzZZ8ERW9wKdReJO0EX3JO7Vku27X
         u4rU6DfHoL77pSHQ2wEIoJAWzYS7jz61zfbJc/8uFl+Jwkj0SOjNdUscrvyUYIz43PBm
         ItN0Qzred7INbBeuN54a95d3O9JGxl/Sdsk2A5E0uimWqC7APXyIOt5NFZlnrRf7CaPU
         zIvi2WD3EIZ5lx/CRMpdR7UCkqohvo+hJL2UgjQC40QrLISeHUnBb5DTT/Nlkfh9ERXl
         hMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744289209; x=1744894009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZXIo1fhTP6w3XfC9tv2GhzcTe3ZMQskxjXxbZzFahQ=;
        b=PZwk+F3TRA3vFAdZXC6qiURxcxF7XB+dH/xLc2VZeqgVsAdFLzHTuXjOBfSReZEgNQ
         x5xBlp5j7ixX9TCHxLMBtchzTbtidcFR3B0qTVMKwxAcR/RQFYjdfr3xoJi4M8XY+EIU
         DL/u1AhGMQiciikedS6F4fTXev07V2E4aCmlp72fQRBlDS4s8eLkzHg0fBNOxF431x/q
         PvAdgJH80mZeyU9BICTYQsNQyJAY6xE4kkndSkKp5kShV5N25HUjgmZDFTweMkOUTRSl
         j8WweTMJX0Vx2F5L3hdvLRaTmDDEqf5JXQ9VSIvdq/H/4ncscEpzeoKwvrtLtcA/drTd
         tZRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxHbyGgVEmYy6icN1v1fTVD1LXjBlcOLK5lMsS4sJWJVP9BUfH6RyX8FD2m8novgu29XQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWzw+jXuRD/Zg6cUuiC/Xq1opbtlyRwTImcVjSbidtaFWGrVYL
	++aqPBwIPVdPv2mOidoqZwEiffKEBaCwzHJNOTZCK5hin2IqFUSKvhR7wZWyVgc=
X-Gm-Gg: ASbGncs/x6vw6eM7FkDSwDANlnk++CNXUxS3D2lUHs83vfdeohSIrpznW4gLMrsfwtL
	+TZNuHYOW/1hHPhhzpejqh5kQTGoh/BC9h5Yi+IwaBla+BHTjO2uEspqkwJAW++cxpeZGliADdD
	IihCKoHw6K53u/1HKn1WwpTQGukagvB6Foed39bcp+lCHJOVp5QckKUE+tusaooehQtv0nA7FEY
	K838K5c9D5GmojJAA3FW0Fv3ARNGPbbLrbeHD63OxYuZrOTFEsNoFEm8g3KLn9//1kgdFlRQuja
	E7b9XygmPYDHOsLR78nQ7JXSPn1gkSYOHkNHamzmMz+JbyaEo9Zrc6VQ42iV/K3OfMMEOJuyGDw
	8tN1hFc7c14wvtg==
X-Google-Smtp-Source: AGHT+IFYkPxS+JwgVWraoLI7bmEmqc5FQIN4eQ5rt5c/GcOIXBPGzwbqDNoNGdpm/+fgPK1Kb+38eA==
X-Received: by 2002:a05:600c:258:b0:43d:fa59:bced with SMTP id 5b1f17b1804b1-43f3611175fmr2845515e9.32.1744289208772;
        Thu, 10 Apr 2025 05:46:48 -0700 (PDT)
Received: from [192.168.69.238] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2075fc83sm55219905e9.26.2025.04.10.05.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Apr 2025 05:46:48 -0700 (PDT)
Message-ID: <5393ff40-0e1f-4f3e-8379-8b2208301c70@linaro.org>
Date: Thu, 10 Apr 2025 14:46:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hw/ppc/spapr_hcall: Return host mitigation
 characteristics in KVM mode
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
 danielhb413@gmail.com, harshpb@linux.ibm.com, pbonzini@redhat.com,
 vaibhav@linux.ibm.com
Cc: qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250410104354.308714-1-gautam@linux.ibm.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250410104354.308714-1-gautam@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Gautam,

On 10/4/25 12:43, Gautam Menghani wrote:
> Currently, on a P10 KVM guest, the mitigations seen in the output of
> "lscpu" command are different from the host. The reason for this
> behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
> hcall, QEMU does not consider the data it received from the host via the
> KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
> spapr->eff.caps[], which in turn just contain the default values set in
> spapr_machine_class_init().
> 
> Fix this behaviour by making sure that h_get_cpu_characteristics()
> returns the data received from the KVM ioctl for a KVM guest.
> 
> Perf impact:
> With null syscall benchmark[1], ~45% improvement is observed.
> 
> 1. Vanilla QEMU
> $ ./null_syscall
> 132.19 ns     456.54 cycles
> 
> 2. With this patch
> $ ./null_syscall
> 91.18 ns     314.57 cycles
> 
> [1]: https://ozlabs.org/~anton/junkcode/null_syscall.c
> 
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>   hw/ppc/spapr_hcall.c   | 6 ++++++
>   include/hw/ppc/spapr.h | 1 +
>   target/ppc/kvm.c       | 2 ++
>   3 files changed, 9 insertions(+)
> 
> diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
> index 406aea4ecb..6aec4e22fc 100644
> --- a/hw/ppc/spapr_hcall.c
> +++ b/hw/ppc/spapr_hcall.c
> @@ -1415,6 +1415,12 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
>       uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
>                                                        SPAPR_CAP_CCF_ASSIST);
>   
> +    if (kvm_enabled()) {
> +        args[0] = spapr->chars.character;
> +        args[1] = spapr->chars.behaviour;

If kvmppc_get_cpu_characteristics() call fails, we return random data.

Can't we just call kvm_vm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR)
and kvm_vm_ioctl(s, KVM_PPC_GET_CPU_CHAR, &c) here?

> +        return H_SUCCESS;
> +    }
> +
>       switch (safe_cache) {
>       case SPAPR_CAP_WORKAROUND:
>           characteristics |= H_CPU_CHAR_L1D_FLUSH_ORI30;
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 39bd5bd5ed..b1e3ee1ae2 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -283,6 +283,7 @@ struct SpaprMachineState {
>       Error *fwnmi_migration_blocker;
>   
>       SpaprWatchdog wds[WDT_MAX_WATCHDOGS];
> +    struct kvm_ppc_cpu_char chars;
>   };
>   
>   #define H_SUCCESS         0
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 992356cb75..fee6c5d131 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2511,6 +2511,7 @@ bool kvmppc_has_cap_xive(void)
>   
>   static void kvmppc_get_cpu_characteristics(KVMState *s)
>   {
> +    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
>       struct kvm_ppc_cpu_char c;
>       int ret;
>   
> @@ -2528,6 +2529,7 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
>           return;
>       }
>   
> +    spapr->chars = c;
>       cap_ppc_safe_cache = parse_cap_ppc_safe_cache(c);
>       cap_ppc_safe_bounds_check = parse_cap_ppc_safe_bounds_check(c);
>       cap_ppc_safe_indirect_branch = parse_cap_ppc_safe_indirect_branch(c);


