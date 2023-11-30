Return-Path: <kvm+bounces-3029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0107FFD2E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BB6DB21217
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAC455765;
	Thu, 30 Nov 2023 20:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+j0g74P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0B31708
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:58:29 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cf7ff75820so15317845ad.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701377909; x=1701982709; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hXoqZi0Opdt5hulcSJzUfmQtHjdQGGoIQ7OqSt+6EU0=;
        b=V+j0g74PD0ODQ84l26DlHziOBARg7roBNOM0AtI4tdRKkTz3hwtU/YdwVdHiYPJNBN
         Eyhh3oyDC9+EIvxJ+LHAJ5Jw4LKDdJezYYIWuA0fc3+5ekPn2MYXIpIK92fzaOHtvPe5
         qnS6HcdFN095U2zoPMq4I3GVMQY6IgJwMt/AyBXsnZm6LSgYgjtr5YvLsdy2yDUK8/LW
         LZrXlNEvo3PGc2dz7AUHz2O816Fl+ko54JxHIfwuLD0WfW/3NqwQNehw9CfYMmYPATNm
         JYZz5kWJtU++pT237klQt97c4Vhnlk4jjkBxJbYHh0uhBYE+/X8jttkybaap6AkQK3dL
         9V0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701377909; x=1701982709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXoqZi0Opdt5hulcSJzUfmQtHjdQGGoIQ7OqSt+6EU0=;
        b=AUgkkDXJWc5DVih2qpthAxbe2Hns2EuKxWGEPXXgKaLUKQyHu3OYDbJQnq3DY+2mo4
         X4xO3tTQvX9N+HgYXT05WV/8BUr5mOjzQ3KlvAUGBHElQLGCytK3VXcei6bGNCvEkd2n
         fkTHXqvo5pj8I095Paxb43ktbvnww4+K/WpXTGR13V1Hvr2ssyWMJL3H6bRMA6F29LUf
         qC9l09Anarku0b77Q7kiEfvrxBiL0pECF540y8F4lP7lGSpI8z9Qlx7ERDqfaUzpkPTY
         SCsPXjsCTyN0an4MfyYQiR+59F07hUfElrQ1aOZDv8B2JUjyu563NVhhN9pqWHvwjKVu
         Gozw==
X-Gm-Message-State: AOJu0YzuPtb/kpOOcHuUDw8X3Ph05OqzlGXbHNfli67y9ellYmbXq2u7
	vxlb8TXG1xgwRDVgmXKgHiPvGAptjFc=
X-Google-Smtp-Source: AGHT+IGhaZaUl/O4POsqTIF9WO61Qi662iNs+wuLaVenI2PWgSLD/72+KdqJ2OzhtgNad+IY/VnDGOZ93QQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e84a:b0:1cf:cd2f:b836 with SMTP id
 t10-20020a170902e84a00b001cfcd2fb836mr3364371plg.3.1701377908929; Thu, 30 Nov
 2023 12:58:28 -0800 (PST)
Date: Thu, 30 Nov 2023 12:58:27 -0800
In-Reply-To: <20231113184854.2344416-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231113184854.2344416-1-jmattson@google.com>
Message-ID: <ZWj3c1ho7CKMsHLn@google.com>
Subject: Re: [PATCH] KVM: x86: Remove IA32_PERF_GLOBAL_OVF_CTRL from KVM_GET_MSR_INDEX_LIST
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, "'Paolo Bonzini '" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 13, 2023, Jim Mattson wrote:
> This MSR reads as 0, and any host-initiated writes are ignored, so
> there's no reason to enumerate it in KVM_GET_MSR_INDEX_LIST.

This looks sane to me, but I'd like to get a thumbs up from Paolo before applying.
AFAICT, this won't cause problems for QEMU, but a sanity check from someone that
runs a different VMM than us would be nice to have.

> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c924075f6f1..54bcc197b314 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1470,7 +1470,7 @@ static const u32 msrs_to_save_pmu[] = {
>  	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
>  	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
>  	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
> -	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +	MSR_CORE_PERF_GLOBAL_CTRL,
>  	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
>  
>  	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
> -- 
> 2.43.0.rc0.421.g78406f8d94-goog
> 

