Return-Path: <kvm+bounces-46350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1C0AB5521
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 14:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B89F816AA2F
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6D91D130E;
	Tue, 13 May 2025 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E9Eu7nhe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5406617597
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747140326; cv=none; b=BTZ/pU2ID8EjdwxAbUTHyHHOhdYyPNSz+2FzGT43BJBl1LmiBtr2sU6qXVGZYzYkX0/z23RgLo3QWE9DAYkiLYSPFj/DUFGkovGcBC6nX0j4lte/cT0X2N8CKQTnpim7kCUDgQAEe/Bgq70nsLn+wzFmoke/QbkZoreKz/hvl/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747140326; c=relaxed/simple;
	bh=e3VlcZ/2FBdH1yUgjkq/EwjBQEnGlwBXOfnuCwhVqtA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n0bCssfI1uJzdmvg/cMPo/4Pb+SYEo/sS8myxJw5q4s3pFVNnKgzj1Ggq+UmYsrnu99i20FbVPZ+Ej7GTWtzMfL2AdrvznAf6HWB+cJjhdpxCcrR6qH/0uMG4qI6GKHbYXe3vAuaru2z9DazjosVnVex8WIrYIMwtzwbWqcknoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E9Eu7nhe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747140323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qbzKwIrC2/FHuWNCqW2F1uNvDxrKnayEbn3X40B/pY=;
	b=E9Eu7nhe6vk83gFci4pADcgdF88Ou0jEFd9lgr5kAEPSHwH8ImHfasebd84QTg8YEO+iV7
	D2Q4zNrgO4F07nzvsGHfwg2TCh3t4HFjLGcTvTEGGay7P8eDk2Nl7J4MLPDWKC37flNCIA
	/iqQNhZnT9EBOMrbSITdFQxFjfLQjh8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-a9TrJx1aNji9Tcho5cztNQ-1; Tue, 13 May 2025 08:45:20 -0400
X-MC-Unique: a9TrJx1aNji9Tcho5cztNQ-1
X-Mimecast-MFC-AGG-ID: a9TrJx1aNji9Tcho5cztNQ_1747140319
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43f251dc364so34411125e9.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 05:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747140319; x=1747745119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qbzKwIrC2/FHuWNCqW2F1uNvDxrKnayEbn3X40B/pY=;
        b=d51G05siJPgvIe9aXucTmQ7jvSOgpnxU5vE4/CJn2o0T9ozbUU2XFlGb6Pl3IXSRQp
         eTsNSavMdXCSeVWuQGWBzrk10uGAQhC2BTdxAj5Y/Es4hU+D9SMWV3Pl94e+4QUT19Tu
         yqms1kWsP9qBlRDYrZKk61V0S6CF9Web60z7UJMkMW6FdVvamsjbYMdIs3nnFQx7FAoW
         5HtE1bDF0JYB5Ote4Bbf/kR7+8BXlPF6bKpKTO/PgJJRrseWNN3wUX3GwLVJhSX8Y5vF
         6DsJemLg+XkX2Vaf9Kl6UlBg6HIQLlV4NQ4pM4mWTylUod349u7v8WggMKiT8vuByxLg
         jIrg==
X-Forwarded-Encrypted: i=1; AJvYcCVLYBNk+9xRFgXfnpYE+oxwGjLDQM6Rr6ysq1RAs1ZZ1ZXihluFoEpnn6YHjIK3iH8SXr8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHdIDRrRRpJ1x1GkwwCMs4xkNJToQoFSbOZfyfrWUHHvA7tjOE
	7M68VRBBByAKwH0sdcEuFTG2kNUNcPsyIi015TDOc3GKVZJ9Ta4D8dQ8vhnMo1U7G5H6q+alGG2
	FP6g92hz4jBZjTwW/ofDwhuaHkL7FmkPclMTtw7pVWlBluZf8ag==
X-Gm-Gg: ASbGnctOQLVi244MDHSomm6GOqje5/hvA5PiBp43xJyHmA5n/y16RFuvJhIkTlZOdfe
	ZBvoR7ebdAewoPycqVIrCU8HExXFmTHYFwZD4xgY5HxrHMJSN30Cv6Y3S4M5F6GWin9ZQCbO6BI
	6bKJG9yIeTHypap2GyxjbTBhh7Qeo34BGF8WV8cLsurcl0CW8H+L5LWL4KPVJ2fVdPhRl8pIU/p
	6tnRYVC8b+m4/8Mo/Sy1o1CCVWLoz9WaVGvUaUGPXjTv3Oo5XGtGJN7NIoD3EdeKgFeS5bxl0Gt
	1dGkmqKosTs8yesRumevDXzUQeo3fzeg
X-Received: by 2002:a05:600c:6819:b0:442:cab1:e092 with SMTP id 5b1f17b1804b1-442d6d1fadamr135825285e9.11.1747140318797;
        Tue, 13 May 2025 05:45:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwUzWUPASx2NiQ1Kn3uuvcgEdnOm17Ak4ZkvlCvpTjzcgN+0pD9VaNQeoqRZ/ENeDLe7VIdA==
X-Received: by 2002:a05:600c:6819:b0:442:cab1:e092 with SMTP id 5b1f17b1804b1-442d6d1fadamr135824865e9.11.1747140318428;
        Tue, 13 May 2025 05:45:18 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58eb91bsm16387897f8f.33.2025.05.13.05.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 05:45:18 -0700 (PDT)
Date: Tue, 13 May 2025 14:45:15 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Babu Moger <babu.moger@amd.com>, Ewan Hai
 <ewanhai-oc@zhaoxin.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Tejus GK
 <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>, Manish Mishra
 <manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC 06/10] i386/cpu: Introduce enable_cpuid_0x1f to force
 exposing CPUID 0x1f
Message-ID: <20250513144515.37615651@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250423114702.1529340-7-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
	<20250423114702.1529340-7-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Apr 2025 19:46:58 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Currently, QEMU exposes CPUID 0x1f to guest only when necessary, i.e.,
> when topology level that cannot be enumerated by leaf 0xB, e.g., die or
> module level, are configured for the guest, e.g., -smp xx,dies=2.
> 
> However, TDX architecture forces to require CPUID 0x1f to configure CPU
> topology.
> 
> Introduce a bool flag, enable_cpuid_0x1f, in CPU for the case that
> requires CPUID leaf 0x1f to be exposed to guest.
> 
> Introduce a new function x86_has_cpuid_0x1f(), which is the warpper of
> cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
> to enable cpuid leaf 0x1f for the guest.

that reminds me about recent attempt to remove enable_cpuid_0xb,

So is enable_cpuid_0x1f inteded to be used by external users or
it's internal only knob for TDX sake?

I'd push for it being marked as internal|unstable with the means
we currently have (i.e. adding 'x-' prefix)

and also enable_ is not right here, the leaf is enabled when
topology requires it.
perhaps s/enable_/force_/
 
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c     | 4 ++--
>  target/i386/cpu.h     | 9 +++++++++
>  target/i386/kvm/kvm.c | 2 +-
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index d90e048d48f2..e0716dbe5934 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7292,7 +7292,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          break;
>      case 0x1F:
>          /* V2 Extended Topology Enumeration Leaf */
> -        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
> +        if (!x86_has_cpuid_0x1f(cpu)) {
>              *eax = *ebx = *ecx = *edx = 0;
>              break;
>          }
> @@ -8178,7 +8178,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>           * cpu->vendor_cpuid_only has been unset for compatibility with older
>           * machine types.
>           */
> -        if (x86_has_extended_topo(env->avail_cpu_topo) &&
> +        if (x86_has_cpuid_0x1f(cpu) &&
>              (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
>              x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
>          }
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 76f24446a55d..3910b488f775 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2251,6 +2251,9 @@ struct ArchCPU {
>      /* Compatibility bits for old machine types: */
>      bool enable_cpuid_0xb;
>  
> +    /* Force to enable cpuid 0x1f */
> +    bool enable_cpuid_0x1f;
> +
>      /* Enable auto level-increase for all CPUID leaves */
>      bool full_cpuid_auto_level;
>  
> @@ -2513,6 +2516,12 @@ void host_cpuid(uint32_t function, uint32_t count,
>                  uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
>  bool cpu_has_x2apic_feature(CPUX86State *env);
>  
> +static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
> +{
> +    return cpu->enable_cpuid_0x1f ||
> +           x86_has_extended_topo(cpu->env.avail_cpu_topo);
> +}
> +
>  /* helper.c */
>  void x86_cpu_set_a20(X86CPU *cpu, int a20_state);
>  void cpu_sync_avx_hflag(CPUX86State *env);
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6c749d4ee812..23b8de308525 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1863,7 +1863,7 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
>              break;
>          }
>          case 0x1f:
> -            if (!x86_has_extended_topo(env->avail_cpu_topo)) {
> +            if (!x86_has_cpuid_0x1f(env_archcpu(env))) {
>                  cpuid_i--;
>                  break;
>              }


