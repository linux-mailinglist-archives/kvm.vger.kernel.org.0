Return-Path: <kvm+bounces-26163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C27C8972511
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00A0C1C21982
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1AE18DF67;
	Mon,  9 Sep 2024 22:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EK8pale8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC84918CC04
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 22:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725919903; cv=none; b=UfejAKqGMWx2H39l4XdB/4BqshpEwBr1ltWymX9+9YuK/4W+Om4csl9a9vILnaiHCDdDo41c95Srh35+6N8enGkyxpOijzk3eOG6xRtBDzMvu6ZdgVhkqBcjSbXMFoGSTJ+Sku3JGkx1cVpjeWyRHhnWNsSgayP3Ko+R8pwweoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725919903; c=relaxed/simple;
	bh=+uIaSjx7tpFHnGMRaarBn8DWXOxfz418oPiwr2T98Xo=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Uag6byR4Zpntz5HoTibQGUMhvoT74IixDYXtJz6HZRHi2hFOqUZ6O+70sDlL4VKkeylzILlo4YZ0qL0NEqwlc6UxIcdFBeobsA+nmKuTNhFA7d1OE8Cnz978vslMZyaMcV6WXDhvgZka9rf9gxuCwUvuvbpJ/Yc6VoNfuwg1c7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EK8pale8; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-82cda24c462so455848539f.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 15:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725919900; x=1726524700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c2pACaTK9nt0Rc3BheIIfZV1ckivGrvcSLjBPbKaYU4=;
        b=EK8pale8K29N4Fq1If5YBI/g2bRom/MctNtTqlpnZ2aC9TmPWilw9PJ6BL/xYS+k57
         APyN19Ur6PAKu8qtFkAiuxK5eqUdDlRXry3IqZxhzjCyTeAb+Dsr7aLQKWG62gwbLibc
         v5GbmPsNz9VAREAnOHlxPFBeXqX4wb6AiOEYC/u8W2aaz4m2VIrWfb6/0hHj0OGy6RG+
         SBhhTWv2FXWxM15NibHCdcSgLjRfT4OI0ZGY66IXTvj8Pw8DyXjBHq85RsZyqie+g5OI
         8r2iQyTXZbYT5RiKQjdWnw/a6GzXVhVjauc0+H6qhW3AwDVKrMunfGCLxeOg/ibT0gkV
         Xsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725919900; x=1726524700;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c2pACaTK9nt0Rc3BheIIfZV1ckivGrvcSLjBPbKaYU4=;
        b=Behx0C04oTZoe0uZ50qTCpuZoN0Z4NHz2YKDOaRym1TFbkOOn1DU8qfCKqcKhml0Je
         zbfqWUS4JjQ78nuTn/7L5DSUySRPx1b2sZZQFtBbWM2JS20W6o3BkFl8qKHmCDZArWcm
         9XCnls4kD0qpH02f/Kdp/n6r8laMLCsrJ3Arhri3bZNhEMl5+44Auq0xqx4oG6tzCPdT
         /gZ/FmcxALawD6lw4OHguPm4z6z+Q1Tx3sL0AZCZACxNsqqUg2G/8KzRzN72zFFKXW/d
         9d1NBycXVjsWnzNWmR0OyGii/W6kEbsy5j2GYhpdXVC+1FiBFbWjqP4L5b8v6ClPf09w
         gtXA==
X-Forwarded-Encrypted: i=1; AJvYcCViAslY1bR/QC6KPwGF1TVHaxVvrVyqWYpq3ILlrosA9Opg/p4KupAy824O4j/EK71mOk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpJMSQIAm/+5LixM6j2N2FS6fAgl6R80wv+PbXtcXv4t9q4UDh
	ev2RAzg6XJtySdln1Urn3szmfQeTof09BBHiLYu54XgnAx8hzD0RWhPr9n3C8qX0QUHvH36ccOc
	3hUu0ZNuqeIA3bOxw0uYOrw==
X-Google-Smtp-Source: AGHT+IHumdyf8RGWX3ScsIDrd53c+f7QJveB+hxSaPOpbEO5ESD9I/7HvQQf8wQXYzJAZ6+8WW7qN/Hn1QRzMOohHg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:8707:b0:4ca:7128:6c70 with
 SMTP id 8926c6da1cb9f-4d08506dd17mr722531173.6.1725919900003; Mon, 09 Sep
 2024 15:11:40 -0700 (PDT)
Date: Mon, 09 Sep 2024 22:11:39 +0000
In-Reply-To: <20240801045907.4010984-16-mizhang@google.com> (message from
 Mingwei Zhang on Thu,  1 Aug 2024 04:58:24 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt5xr4eauc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH v3 15/58] perf/x86: Support switch_interrupt interface
From: Colton Lewis <coltonlewis@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, xiong.y.zhang@intel.com, 
	dapeng1.mi@linux.intel.com, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	manali.shukla@amd.com, sandipan.das@amd.com, jmattson@google.com, 
	eranian@google.com, irogers@google.com, namhyung@kernel.org, 
	mizhang@google.com, gce-passthrou-pmu-dev@google.com, samantha.alt@intel.com, 
	zhiyuan.lv@intel.com, yanfei.xu@intel.com, like.xu.linux@gmail.com, 
	peterz@infradead.org, rananta@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Mingwei Zhang <mizhang@google.com> writes:

> From: Kan Liang <kan.liang@linux.intel.com>

> Implement switch_interrupt interface for x86 PMU, switch PMI to dedicated
> KVM_GUEST_PMI_VECTOR at perf guest enter, and switch PMI back to
> NMI at perf guest exit.

> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>   arch/x86/events/core.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 5bf78cd619bf..b17ef8b6c1a6 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2673,6 +2673,15 @@ static bool x86_pmu_filter(struct pmu *pmu, int  
> cpu)
>   	return ret;
>   }

> +static void x86_pmu_switch_interrupt(bool enter, u32 guest_lvtpc)
> +{
> +	if (enter)
> +		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
> +			   (guest_lvtpc & APIC_LVT_MASKED));
> +	else
> +		apic_write(APIC_LVTPC, APIC_DM_NMI);
> +}
> +

Similar issue I point out in an earlier patch. #define
KVM_GUEST_PMI_VECTOR is guarded by CONFIG_KVM but this code is not,
which can result in compile errors.

>   static struct pmu pmu = {
>   	.pmu_enable		= x86_pmu_enable,
>   	.pmu_disable		= x86_pmu_disable,
> @@ -2702,6 +2711,8 @@ static struct pmu pmu = {
>   	.aux_output_match	= x86_pmu_aux_output_match,

>   	.filter			= x86_pmu_filter,
> +
> +	.switch_interrupt	= x86_pmu_switch_interrupt,
>   };

>   void arch_perf_update_userpage(struct perf_event *event,

