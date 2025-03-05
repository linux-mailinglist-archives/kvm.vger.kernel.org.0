Return-Path: <kvm+bounces-40154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1ECA4FDE4
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 12:42:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A411A17122D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 11:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1DA23ED7B;
	Wed,  5 Mar 2025 11:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="E/cL0O/4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7C51F416D
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741174927; cv=none; b=m1wQW5rjwPBKYf++86TRCSLvHs0EZXXV12ZNOyBs7fGEDVGjdkSLRuzooGqQVAD0KbUF/yu0IiwL0YIJ6+7wdk7bHbh/w1aX9tRS5AvMSKe38j019i3lQgYEIeEagC0Rf5tizuLPMwQdhtQ/i04U9Yd5gQ22VKksi13VprlnjfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741174927; c=relaxed/simple;
	bh=M6MtRH+jyCB/SI0MJTDHuc6oQ0dYWoxtMpSeRPso9t4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=WhgNW86/LCa3tk0Rqs80BvSDduq69iRibS186qgQNCWV5NtHj+lBjd/7gqQ9Tu2IvIT16peO0ZWYnfEHdp0WJ/Fuo1unM2O3cEz4wKDjc8mg5R2j9hfp3KKIM0gNMYJi+p+pTdHiqQya8LZqt6Vu1olIIF3GmxahRR1d/ZEEb+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=E/cL0O/4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4394036c0efso42569865e9.2
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 03:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1741174921; x=1741779721; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7qoMFHP18t1+aynNKa+ZBE66AWj0AVEE7ajzAxyRuQk=;
        b=E/cL0O/4WUq2VHgYoG679rbNrzJJwcX/efHA8gjMYAKjN8JQZb6oSzip3WFZktqbFA
         SxAUbzTVKk+C4dknjYxwZZIS9fzrym6wbcxJCS/6ZkTXHcXXuPXVS8y7UB2j4448vsCb
         IPl4Y9F36pKnAIrm4d9r3s1BJfepDYyklErLlMFE/eCvv3RHurmeCnMM2PCAb7WpI2NF
         diKn0d9QyWiQxqAN2dz8puCZLEVwjs3abar+D7KRqO5cDQEkaywFeGj8PYRp4fGpNv4C
         YUDEidIAoNXDM0pQAEyuFgL0T8MtZSr43iBL51iClzp+qiDyaXmbjwPQGA/0tfZtAuPU
         Xz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741174921; x=1741779721;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7qoMFHP18t1+aynNKa+ZBE66AWj0AVEE7ajzAxyRuQk=;
        b=AmeH5NRWvVCpEsnuprM3CQR8NE0rFjI45oO1WgKVG+Owm3fYspE8luxjCt7Ts/U8NB
         U/ufGtuMx/QzwGIihP1KnKyXo/WbOre854vWvd9fjPYtXYmhNnTaVZhMNjs/bLo41ojx
         g8S6N2CEXDqFb8AgiBosv4YvTN8qegaDXX7QhMl3glGAPyGiES0DyZlIoCAz7bBuFhN5
         MSkII2LhR7DfprF9SvEJk2wXWbMEy6D0A+ApzvOSEq+gdSwvSOXbfcjQwJsJttMAQBDc
         VZUthpzMlUrPITyhp5cWzwLLbTJWVZyIUiCSUwRZmwmWpgXMMEhfj4mxdz2kCYbmo42l
         F5Fw==
X-Forwarded-Encrypted: i=1; AJvYcCWoFr+sHARdiwi7Gx5azlY6+T2FAYkp5HT4sNy0aD6ThpWHneeCANW+sicSBZ+g7nw4q+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNeuVAe0n9BakU+zHvfOeUm85U+Tvz5GblZu3LCbX9UPjB8601
	aohGajd+/QHkqBjZcdknwIPvFbxgyc81Zc10/FsxxMF0zhpJLs4hvsXNTcxafdE=
X-Gm-Gg: ASbGncsG+smcRn75AUEfUqIpiwFiODxWGtsJNV8vdc14g5FCmGH8Mh71gmEPNqDXNZC
	zR//s68xSvFLum7SIvGF2gtkiOxqVq7C4JgKtMr41CYJvtj2qhXL9f2XFVwYvG75+RL/Xi2lOlS
	SCKXEbZ9KZph2gG7VfDutPXTobXm2ZPrPK+GMB7QV1bzh3bqVcwpsump8g1uTlbaBhI5dfmBtB6
	op8zIKb83cdvYh5EDwy16Lwq3GQ+z8SPjwpppzPjqHGdHsNg9kSk8YLEtz6paqEjrsTrws8MjIv
	qIspNBm07gkQubSeakYVGuajvwbv5xtxn+SZwEwIdlMum5GyA99WnRBzeA6bYdKaM0H3O4SgOSM
	v0ZugchALJUKKzV8=
X-Google-Smtp-Source: AGHT+IHwLYR3lnUxszBmLur7bdGwk3/lJLpgLsJrp2K853h/x9C1br2a7PT9mDMKqILEqmvul7BYyg==
X-Received: by 2002:a05:600c:4f86:b0:439:96b2:e8f with SMTP id 5b1f17b1804b1-43bd29d040dmr17232515e9.28.1741174921322;
        Wed, 05 Mar 2025 03:42:01 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:252a:6e70:c18a:67bc? ([2001:b07:5d29:f42d:252a:6e70:c18a:67bc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bcbcc0c39sm38145415e9.0.2025.03.05.03.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 03:42:01 -0800 (PST)
Message-ID: <7d6f5d9ce0f23a550aa95bba9bb04425a7a5b9ec.camel@baylibre.com>
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers
 during VM reset
From: Francesco Lavra <flavra@baylibre.com>
To: dongli.zhang@oracle.com
Cc: alexander.ivanov@virtuozzo.com, babu.moger@amd.com, 
 dapeng1.mi@linux.intel.com, davydov-max@yandex-team.ru, den@virtuozzo.com, 
 groug@kaod.org, joe.jin@oracle.com, khorenko@virtuozzo.com,
 kvm@vger.kernel.org,  like.xu.linux@gmail.com, likexu@tencent.com,
 mtosatti@redhat.com,  pbonzini@redhat.com, qemu-devel@nongnu.org,
 sandipan.das@amd.com,  xiaoyao.li@intel.com, zhao1.liu@intel.com,
 zhenyuw@linux.intel.com
Date: Wed, 05 Mar 2025 12:41:59 +0100
In-Reply-To: <20250302220112.17653-9-dongli.zhang@oracle.com>
Organization: BayLibre
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2025-03-02 at 22:00, Dongli Zhang wrote:
> +static bool is_same_vendor(CPUX86State *env)
> +{
> +    static uint32_t host_cpuid_vendor1;
> +    static uint32_t host_cpuid_vendor2;
> +    static uint32_t host_cpuid_vendor3;

What's the purpose of making these variables static?

> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1,
> &host_cpuid_vendor3,
> +               &host_cpuid_vendor2);
> +
> +    return env->cpuid_vendor1 =3D=3D host_cpuid_vendor1 &&
> +           env->cpuid_vendor2 =3D=3D host_cpuid_vendor2 &&
> +           env->cpuid_vendor3 =3D=3D host_cpuid_vendor3;
> +}
> +
> +static void kvm_init_pmu_info(CPUState *cs)
> +{
> +    X86CPU *cpu =3D X86_CPU(cs);
> +    CPUX86State *env =3D &cpu->env;
> +
> +    /*
> +     * The PMU virtualization is disabled by kvm.enable_pmu=3DN.
> +     */
> +    if (kvm_pmu_disabled) {
> +        return;
> +    }
> +
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD
> processors.
> +     */
> +    if (!is_same_vendor(env)) {
> +        return;
> +    }
> +
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way
> to
> +     * disable the AMD pmu virtualization.

s/pmu/PMU/

