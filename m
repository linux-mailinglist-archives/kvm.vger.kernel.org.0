Return-Path: <kvm+bounces-14114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE51F89EFF3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FBD1B23677
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85760159568;
	Wed, 10 Apr 2024 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5yuQaOG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ECA159213;
	Wed, 10 Apr 2024 10:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712745392; cv=none; b=A6KiJ7WNSGeaEVeIEmSNWyZNRpKybqbVCe4JhVTz7vcAbNRnClXVZM7kbTAYBiV7Go25NIBghWgBR1+vPWcd6Jw47mqOPBgMD5Fod0h9eCr1jzichM7J1hF9gcJc6p6mSb762W3mqILfuihKEGA5WQux8yD2QtN7u/pvqEsudh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712745392; c=relaxed/simple;
	bh=LNEuFogkAsBqGBSDNpN3ctuq6bjd8EJGSHdvsPmHlvA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=d3QC+V2NPnJJqguQaDsxcgmSpaY6ZW/33Ss9NjcuUklwkx3J7k+vI7Ja4NW3HVLRvwYEVb6umqfsBff3AbHnncqYFS74Ry7OVTPUsJWVVYGDT/2UBAu32JCjlUvQMPPQC4TYzNQRR2WMa9nkEn/TqtItbuaUGinY/rAXISVcicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5yuQaOG; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so4369157f8f.1;
        Wed, 10 Apr 2024 03:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712745389; x=1713350189; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nyrI6h+riI7s/h5GHlOiwZCYG51Sy/IX+HigJOFB6qU=;
        b=m5yuQaOGpad437CqeN1Glpn41FxBQXFDZKJOdVIGeWDycsCDyD8HUCS2OkRDqritrp
         GYg+qLstAJMDpefnNyPE7VfpXg98M/eBugAtUFKqOuAdFO7+U5XUK5L9mPcDaHvI3Sct
         VqA2GJoebC9DBTj/0+2YdvJ0HMntWv83C3ytO0N1nlbbvBjxfbQQXyKq+YaxGdnGBZfK
         COKHxYW5NCSWZN+eYwnl4iwVMl+5j1HXBn6NvwXbG7cYm6Dx0gB5dCDPVApglSHgPH6J
         pr53OjIcblWTQ6Iq21WrVsv8x+o3vtSjBIfQ43MtX0qOc7K0RnGyyPqgf9Ds9ivhq1kC
         H1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712745389; x=1713350189;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyrI6h+riI7s/h5GHlOiwZCYG51Sy/IX+HigJOFB6qU=;
        b=k+pL6UNQAwxizxmd8XstkPGeV53QVW+UsE2klac8fZKDjtnTlwP4aFotXboPAfgWXr
         ev2M3HeBEamSKsPGbKZd0kfkmv3etUYvPiLEVaumemT6pvt7GfMHrSqqlEuSu6j//ZGw
         6dHjQmBuHp2xc5tGBaGN05EWZu4oNTZpNMqpI2mMtXIpPequ5XS71HJS7qJ3huthaJp8
         YEPCItPp1LlCPEkjIQc0VCkihlEyVnuv3hN085SVEEoW/Xv/c4n5VVevmNAPa+EH9r5j
         9dTJc/HYonyo/cGiQWV3FzAAM4UDhb+mPBp9vm0LCncmpxZ20TLK1sQOWlwP0+LHmZa6
         0HaA==
X-Forwarded-Encrypted: i=1; AJvYcCXkP87IdLf5tbXW8Zvfni0VPRleXzNxl8UJKaAApnBjxUldP0CcmK0dERKl6Sh/Nt3JliYthFaC9k3iyQuGCt17FaBiPddTZ+TuVrjH6l2hBavWAuViDTHe3AYPQw6ABPc+4muPRRp5uN7aSuHERxbGCyIoq5zco1ewkqFi
X-Gm-Message-State: AOJu0YzSZUAeAoDuHplYGCtC/sELsYMgYMzK3kSD0JJS3UvYlQyZcsgx
	svRmNqCh2kdRpiJObBnHe+BX0WM/swiE2uWj0VNAn1nr4obd4z8G
X-Google-Smtp-Source: AGHT+IG0fFY67hx1BZCYCb0da576odWQTmUCzdkL8ylK9+s6wsEAJLv3b9w7ccoUc9xpK8y9zLyhMA==
X-Received: by 2002:a5d:47a7:0:b0:343:bb25:82f0 with SMTP id 7-20020a5d47a7000000b00343bb2582f0mr1948412wrb.11.1712745388929;
        Wed, 10 Apr 2024 03:36:28 -0700 (PDT)
Received: from [192.168.12.203] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id e16-20020adff350000000b00343ca138924sm13406593wrp.39.2024.04.10.03.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 03:36:28 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <aefc6c8e-0c50-478c-afab-dd6ae9830dfc@xen.org>
Date: Wed, 10 Apr 2024 11:36:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 2/2] KVM: selftests: Add KVM/PV clock selftest to prove
 timer correction
To: Jack Allister <jalliste@amazon.com>
Cc: bp@alien8.de, corbet@lwn.net, dave.hansen@linux.intel.com,
 dwmw2@infradead.org, hpa@zytor.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 Dongli Zhang <dongli.zhang@oracle.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240410095244.77109-1-jalliste@amazon.com>
 <20240410095244.77109-3-jalliste@amazon.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240410095244.77109-3-jalliste@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/04/2024 10:52, Jack Allister wrote:
> A VM's KVM/PV clock has an inherent relationship to it's TSC (guest). When
> either the host system live-updates or the VM is live-migrated this pairing
> of the two clock sources should stay the same.
> 
> In reality this is not the case without some correction taking place. Two
> new IOCTLs (KVM_GET_CLOCK_GUEST/KVM_SET_CLOCK_GUEST) can be utilized to
> perform a correction on the PVTI (PV time information) structure held by
> KVM to effectively fixup the kvmclock_offset prior to the guest VM resuming
> in either a live-update/migration scenario.
> 
> This test proves that without the necessary fixup there is a perceived
> change in the guest TSC & KVM/PV clock relationship before and after a LU/
> LM takes place.
> 
> The following steps are made to verify there is a delta in the relationship
> and that it can be corrected:
> 
> 1. PVTI is sampled by guest at boot (let's call this PVTI0).
> 2. Induce a change in PVTI data (KVM_REQ_MASTERCLOCK_UPDATE).
> 3. PVTI is sampled by guest after change (PVTI1).
> 4. Correction is requested by usermode to KVM using PVTI0.
> 5. PVTI is sampled by guest after correction (PVTI2).
> 
> The guest the records a singular TSC reference point in time and uses it to
> calculate 3 KVM clock values utilizing the 3 recorded PVTI prior. Let's
> call each clock value CLK[0-2].
> 
> In a perfect world CLK[0-2] should all be the same value if the KVM clock
> & TSC relationship is preserved across the LU/LM (or faked in this test),
> however it is not.
> 
> A delta can be observed between CLK0-CLK1 due to KVM recalculating the PVTI
> (and the inaccuracies associated with that). A delta of ~3500ns can be
> observed if guest TSC scaling to half host TSC frequency is also enabled,
> where as without scaling this is observed at ~180ns.
> 
> With the correction it should be possible to achieve a delta of ±1ns.
> 
> An option to enable guest TSC scaling is available via invoking the tester
> with -s/--scale-tsc.
> 
> Example of the test output below:
> * selftests: kvm: pvclock_test
> * scaling tsc from 2999999KHz to 1499999KHz
> * before=5038374946 uncorrected=5038371437 corrected=5038374945
> * delta_uncorrected=3509 delta_corrected=1
> 
> Signed-off-by: Jack Allister <jalliste@amazon.com>
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: Paul Durrant <paul@xen.org>
> CC: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/x86_64/pvclock_test.c       | 192 ++++++++++++++++++
>   2 files changed, 193 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/pvclock_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 741c7dc16afc..02ee1205bbed 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -87,6 +87,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
>   TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
>   TEST_GEN_PROGS_x86_64 += x86_64/private_mem_conversions_test
>   TEST_GEN_PROGS_x86_64 += x86_64/private_mem_kvm_exits_test
> +TEST_GEN_PROGS_x86_64 += x86_64/pvclock_test
>   TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
>   TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
> diff --git a/tools/testing/selftests/kvm/x86_64/pvclock_test.c b/tools/testing/selftests/kvm/x86_64/pvclock_test.c
> new file mode 100644
> index 000000000000..376ffb730a53
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/pvclock_test.c
> @@ -0,0 +1,192 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright © 2024, Amazon.com, Inc. or its affiliates.
> + *
> + * Tests for pvclock API
> + * KVM_SET_CLOCK_GUEST/KVM_GET_CLOCK_GUEST
> + */
> +#include <asm/pvclock.h>
> +#include <asm/pvclock-abi.h>
> +#include <sys/stat.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +enum {
> +	STAGE_FIRST_BOOT,
> +	STAGE_UNCORRECTED,
> +	STAGE_CORRECTED
> +};
> +
> +#define KVMCLOCK_GPA 0xc0000000ull
> +#define KVMCLOCK_SIZE sizeof(struct pvclock_vcpu_time_info)
> +
> +static void trigger_pvti_update(vm_paddr_t pvti_pa)
> +{
> +	/*
> +	 * We need a way to trigger KVM to update the fields
> +	 * in the PV time info. The easiest way to do this is
> +	 * to temporarily switch to the old KVM system time
> +	 * method and then switch back to the new one.
> +	 */
> +	wrmsr(MSR_KVM_SYSTEM_TIME, pvti_pa | KVM_MSR_ENABLED);
> +	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
> +}
> +
> +static void guest_code(vm_paddr_t pvti_pa)
> +{
> +	struct pvclock_vcpu_time_info *pvti_va =
> +		(struct pvclock_vcpu_time_info *)pvti_pa;
> +
> +	struct pvclock_vcpu_time_info pvti_boot;
> +	struct pvclock_vcpu_time_info pvti_uncorrected;
> +	struct pvclock_vcpu_time_info pvti_corrected;
> +	uint64_t cycles_boot;
> +	uint64_t cycles_uncorrected;
> +	uint64_t cycles_corrected;
> +	uint64_t tsc_guest;
> +
> +	/*
> +	 * Setup the KVMCLOCK in the guest & store the original
> +	 * PV time structure that is used.
> +	 */
> +	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
> +	pvti_boot = *pvti_va;
> +	GUEST_SYNC(STAGE_FIRST_BOOT);
> +
> +	/*
> +	 * Trigger an update of the PVTI, if we calculate
> +	 * the KVM clock using this structure we'll see
> +	 * a delta from the TSC.
> +	 */
> +	trigger_pvti_update(pvti_pa);
> +	pvti_uncorrected = *pvti_va;
> +	GUEST_SYNC(STAGE_UNCORRECTED);
> +
> +	/*
> +	 * The test should have triggered the correction by this
> +	 * point in time. We have a copy of each of the PVTI structs
> +	 * at each stage now.
> +	 *
> +	 * Let's sample the timestamp at a SINGLE point in time and
> +	 * then calculate what the KVM clock would be using the PVTI
> +	 * from each stage.
> +	 *
> +	 * Then return each of these values to the tester.
> +	 */
> +	pvti_corrected = *pvti_va;
> +	tsc_guest = rdtsc();
> +
> +	cycles_boot = __pvclock_read_cycles(&pvti_boot, tsc_guest);
> +	cycles_uncorrected = __pvclock_read_cycles(&pvti_uncorrected, tsc_guest);
> +	cycles_corrected = __pvclock_read_cycles(&pvti_corrected, tsc_guest);
> +
> +	GUEST_SYNC_ARGS(STAGE_CORRECTED, cycles_boot, cycles_uncorrected,
> +			cycles_corrected, 0);
> +}
> +
> +static void run_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_vcpu_time_info pvti_before;
> +	uint64_t before, uncorrected, corrected;
> +	int64_t delta_uncorrected, delta_corrected;
> +	struct ucall uc;
> +	uint64_t ucall_reason;
> +
> +	/* Loop through each stage of the test. */
> +	while (true) {
> +

Unnecessary blank line. Otherwise LGTM so with that fixed...

Reviewed-by: Paul Durrant <paul@xen.org>



