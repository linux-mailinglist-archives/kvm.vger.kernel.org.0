Return-Path: <kvm+bounces-48795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFB4AD2E64
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 09:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E69333B2A34
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 07:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD9C27FB18;
	Tue, 10 Jun 2025 07:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCWmOjcu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CBC27A904;
	Tue, 10 Jun 2025 07:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749539362; cv=none; b=lQbz7Ic05cYcEqnQG4JH7pRzItw6qLJm3ElSjXl59EH9M6mqYpZwbi6EJagy6VuAALgNMOwCh1KlDZ0T9CH6ojIzq6oY6qEt1fKF7IlRH0py9N6EjBe448aE0y6z6IODa6XgV2q63On4dYRl8EiQdEmYWr9SLJkhUF8HYFn1PsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749539362; c=relaxed/simple;
	bh=rBhGfRjbXGJT1L0cBkib0dMcBkiLujV0EA5TXcGUHJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3g8L34wUqDDsCO2UzE7xv/88+Y9tqx+fwGKWC8Y7E+kSaernUb+OnTsODDTNzT9eq2BLqmG4SDRJ94Z5S5hth0BbOAn5v7+mXHAbnj8CdHDF9y2ObhHkIcurYgb5haU0FjL/fqQBy5fobSditwJHHvrapQOPSCrzjf/B+FeeFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCWmOjcu; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749539360; x=1781075360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rBhGfRjbXGJT1L0cBkib0dMcBkiLujV0EA5TXcGUHJg=;
  b=WCWmOjcuMs4hjWJ9oy1Jdf0fFIA92km3U6hqRkcQe8/Jcg9x2zfzwiGc
   kXxYqZL1s9Hxr24acQZdStHqZVlMjrzsw5OGUuJGXSKeAu2v4t3kn08t1
   jAIyp1bV1f2fKK0j3Wic3r1cS61aOP4Anhhab9SVnUZwOkIrIC27QRSKy
   8WKN6cPEjyXcl/tbfH7tDToxr+GJcQK1eSgZz9gftIHOCXWdPO8UrfkXO
   1ijo6YDv0/6oEuyzmILUw3vhQRGSvgZEI2+Q0xy+6luiugHUL12Vhsmm/
   pwdtheghzrGFcV1HF9QipWjbnOXUYKcldNaFNxpVhlU169uwEP19VrimO
   A==;
X-CSE-ConnectionGUID: m1JYpVqDSHSco6uLZCHCmQ==
X-CSE-MsgGUID: 24DOZnKZSAWaVLEgGPOngA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="50742024"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="50742024"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:09:19 -0700
X-CSE-ConnectionGUID: FTuat8K7SFevwHdRdynsCQ==
X-CSE-MsgGUID: 9MkNzKruSzKyGhID0rxevQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="147312166"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:09:17 -0700
Message-ID: <ffb5e853-dedc-45bb-acd8-c58ff2fc0b71@linux.intel.com>
Date: Tue, 10 Jun 2025 15:09:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 07/16] x86/pmu: Rename
 pmu_gp_counter_is_available() to pmu_arch_event_is_available()
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-8-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Rename pmu_gp_counter_is_available() to pmu_arch_event_is_available() to
> reflect what the field and helper actually track.  The availablity of
> architectural events has nothing to do with the GP counters themselves.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 4 ++--
>  lib/x86/pmu.h | 6 +++---
>  x86/pmu.c     | 6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index d06e9455..599168ac 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -21,7 +21,7 @@ void pmu_init(void)
>  		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
>  
>  		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */

We need to modify the comment as well.


> -		pmu.gp_counter_available = ~cpuid_10.b;
> +		pmu.arch_event_available = ~cpuid_10.b;
>  
>  		if (this_cpu_has(X86_FEATURE_PDCM))
>  			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> @@ -51,7 +51,7 @@ void pmu_init(void)
>  		}
>  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
>  		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> -		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
> +		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;

"available architectural events" and "available GP counters" are two
different things. I know this would be changed in later patch 09/16, but
it's really confusing. Could we merge the later patch 09/16 into this patch?


>  
>  		if (this_cpu_has_perf_global_status()) {
>  			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
> diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
> index f07fbd93..d0ad280a 100644
> --- a/lib/x86/pmu.h
> +++ b/lib/x86/pmu.h
> @@ -64,7 +64,7 @@ struct pmu_caps {
>  	u8 nr_gp_counters;
>  	u8 gp_counter_width;
>  	u8 gp_counter_mask_length;
> -	u32 gp_counter_available;
> +	u32 arch_event_available;
>  	u32 msr_gp_counter_base;
>  	u32 msr_gp_event_select_base;
>  
> @@ -110,9 +110,9 @@ static inline bool this_cpu_has_perf_global_status(void)
>  	return pmu.version > 1;
>  }
>  
> -static inline bool pmu_gp_counter_is_available(int i)
> +static inline bool pmu_arch_event_is_available(int i)
>  {
> -	return pmu.gp_counter_available & BIT(i);
> +	return pmu.arch_event_available & BIT(i);
>  }
>  
>  static inline u64 pmu_lbr_version(void)
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 8cf26b12..0ce34433 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -436,7 +436,7 @@ static void check_gp_counters(void)
>  	int i;
>  
>  	for (i = 0; i < gp_events_size; i++)
> -		if (pmu_gp_counter_is_available(i))
> +		if (pmu_arch_event_is_available(i))
>  			check_gp_counter(&gp_events[i]);
>  		else
>  			printf("GP event '%s' is disabled\n",
> @@ -463,7 +463,7 @@ static void check_counters_many(void)
>  	int i, n;
>  
>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> -		if (!pmu_gp_counter_is_available(i))
> +		if (!pmu_arch_event_is_available(i))
>  			continue;

The intent of check_counters_many() is to verify all available GP and fixed
counters can count correctly at the same time. So we should select another
available event to verify the counter instead of skipping the counter if an
event is not available.

Maybe like this.

diff --git a/x86/pmu.c b/x86/pmu.c
index 63eae3db..013fdfce 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -457,18 +457,34 @@ static void check_fixed_counters(void)
        }
 }

+static struct pmu_event *get_one_event(int idx)
+{
+       int i;
+
+       if (pmu_arch_event_is_available(idx))
+               return &gp_events[idx % gp_events_size];
+
+       for (i = 0; i < gp_events_size; i++) {
+               if (pmu_arch_event_is_available(i))
+                       return &gp_events[i];
+       }
+
+       return NULL;
+}
+
 static void check_counters_many(void)
 {
+       struct pmu_event *evt;
        pmu_counter_t cnt[48];
        int i, n;

        for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-               if (!pmu_arch_event_is_available(i))
+               evt = get_one_event(i);
+               if (!evt)
                        continue;

                cnt[n].ctr = MSR_GP_COUNTERx(n);
-               cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
-                       gp_events[i % gp_events_size].unit_sel;
+               cnt[n].config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel;
                n++;
        }
        for (i = 0; i < fixed_counters_num; i++) {


>  
>  		cnt[n].ctr = MSR_GP_COUNTERx(n);
> @@ -902,7 +902,7 @@ static void set_ref_cycle_expectations(void)
>  	uint64_t t0, t1, t2, t3;
>  
>  	/* Bit 2 enumerates the availability of reference cycles events. */
> -	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
> +	if (!pmu.nr_gp_counters || !pmu_arch_event_is_available(2))
>  		return;
>  
>  	if (this_cpu_has_perf_global_ctrl())

