Return-Path: <kvm+bounces-35440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEBCA11169
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 20:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9054C165C59
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 19:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9DC420B1F3;
	Tue, 14 Jan 2025 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XZ969Vod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F89F20AF6F
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 19:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736884033; cv=none; b=Dj0L73kl3QySRqK9ZXkY6Z/qRi2OK3LEfTBUBWcqIZzoNB0uumG25Z6MponRctYTykGGgG39Fyv9T/xNiMmXUfvDfFLbD0R4KWox6tEKOEuu1lQkrBYB5gnzdFIESJhdorCQi+d998IItc6/2aOgicNdCrfwQKc7DUwy4JcTrug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736884033; c=relaxed/simple;
	bh=0r22/yP8EDC+GPu7ApSIg2mBAi+7oVSaXlZefWFc0Gc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lNKP04Od4vJ2/dhzjcnSuF2hZYLIIxNQ0J8w+q7GPJKXZhD4BhRnCtQ7QFFZcp8VKl2Y6u3lSS2QT844NeOsGFqcRBMZt0ZklIX7oT8KIjpzGzsWgeKvrMJmTrdCNupE1S7dzlDsE6+OmC6n6q6xi63STDKyr4/jLcr7x0bCG4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XZ969Vod; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso10247958a91.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 11:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736884031; x=1737488831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7QgeLrF1bLrbc+AIFcXOLXxQpEAwrbVqsM1G8R/4B2E=;
        b=XZ969Vod8nudVOeCHUxxz1PAF7QnyP/fxw94Ufn8dSccZsfqc20p+sWuZoRBYAzJcx
         f8z/oO4tPpbvv0493q3FHdr5+qkoAkYb30IPj5PeFtX07MGtNQQo5rbVc6MdXcnF1rz9
         Km9eZg6bya/T6vMa1W6+72h8Ktz439A6FETckb4HhnXf2MOk8nVTWLveliBSX0LTNHos
         gAXO2wFENd+JbjZMyB8Oo1qlgCgANQA/8/N2kSWNJt9R0r5aQH8gxCHCdQ/MmNutm432
         GpKWoulJJj3ewl42oydiZ6opA2ANJl+XlBmndInOzPIBdcEdBpNsdqtlXuYCSa+kjxnA
         hwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736884031; x=1737488831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7QgeLrF1bLrbc+AIFcXOLXxQpEAwrbVqsM1G8R/4B2E=;
        b=LUfkpHsDlSYY0NVzZOcXVYkrBEdmA1DGuwcNE4Cn742QfUr4JFR0cqEfIONR0qTgrX
         ouLtzPG4xWAySG5TaGy1rl6kwSfbP9OHaxn2v/yQD8lyw2sbWEFS1v4SKikkJr2MWBkb
         KTq0CeunIW1AnHTe/aPZQfRgfq+7WcYYpxTm3j9w9lhgnBaNtzk9y3Uj81X7NvS3AtBj
         OUbr9Cu3phYY7l7smGII1Yy4i1hJFtglX2PGIc80ZgSGf/Sz9uafMEbTwbbDmmig7cSD
         pJf7XfLSPxfqnEI/gF9JXryivQAyShCz2nDFl86Ct4b2ekmJj1vpAY97ZCAV8YDrTJ8i
         dxXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj2BTndoUOVDryzRaTfbU77oPwGXCG8RaQTjaREIzXKwBT2zSlL67nhxG6XQTyITMPYEU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVBBcIvj0s1BnFJiG3hHcraMX8v29IkNXQBgl7jxvFYoQfutbj
	6KMsMH7Vj0FH4VuSpnGVNJ1+QX/CrJnvJatQfUNv67Rdba2gil+sAzKLYi8KNAM9Ckbe5znYDjU
	QsA==
X-Google-Smtp-Source: AGHT+IGWN1EXcp4hxYKitTkSTxEbPE6icBlOkjTlttxwOdA/3n/RHhDzlF8WrMqOV7l6tXusbzN9f2dTBG4=
X-Received: from pjbqa1.prod.google.com ([2002:a17:90b:4fc1:b0:2ef:8c7e:239b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5208:b0:2ef:33a4:ae6e
 with SMTP id 98e67ed59e1d1-2f548eba9c4mr44906337a91.12.1736884031592; Tue, 14
 Jan 2025 11:47:11 -0800 (PST)
Date: Tue, 14 Jan 2025 11:47:10 -0800
In-Reply-To: <202501141009.30c629b4-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202501141009.30c629b4-lkp@intel.com>
Message-ID: <Z4a_PmUVVmUtOd4p@google.com>
Subject: Re: [linux-next:master] [KVM]  7803339fa9: kernel-selftests.kvm.pmu_counters_test.fail
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <oliver.sang@intel.com>, g@google.com
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, xudong.hao@intel.com, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

+Dapeng

On Tue, Jan 14, 2025, kernel test robot wrote:
> we fould the test failed on a Cooper Lake, not sure if this is expected.
> below full report FYI.
> 
> 
> kernel test robot noticed "kernel-selftests.kvm.pmu_counters_test.fail" on:
> 
> commit: 7803339fa929387bbc66479532afbaf8cbebb41b ("KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 37136bf5c3a6f6b686d74f41837a6406bec6b7bc]
> 
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-7503345ac5f5-1_20241208
> with following parameters:
> 
> 	group: kvm
> 
> config: x86_64-rhel-9.4-kselftests
> compiler: gcc-12
> test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory

*sigh*

This fails on our Skylake and Cascade Lake systems, but I only tested an Emerald
Rapids.

> # Testing fixed counters, PMU version 0, perf_caps = 2000
> # Testing arch events, PMU version 1, perf_caps = 0
> # ==== Test Assertion Failure ====
> #   x86/pmu_counters_test.c:129: count >= (10 * 4 + 5)
> #   pid=6278 tid=6278 errno=4 - Interrupted system call
> #      1	0x0000000000411281: assert_on_unhandled_exception at processor.c:625
> #      2	0x00000000004075d4: _vcpu_run at kvm_util.c:1652
> #      3	 (inlined by) vcpu_run at kvm_util.c:1663
> #      4	0x0000000000402c5e: run_vcpu at pmu_counters_test.c:62
> #      5	0x0000000000402e4d: test_arch_events at pmu_counters_test.c:315
> #      6	0x0000000000402663: test_arch_events at pmu_counters_test.c:304
> #      7	 (inlined by) test_intel_counters at pmu_counters_test.c:609
> #      8	 (inlined by) main at pmu_counters_test.c:642
> #      9	0x00007f3b134f9249: ?? ??:0
> #     10	0x00007f3b134f9304: ?? ??:0
> #     11	0x0000000000402900: _start at ??:?
> #   count >= NUM_INSNS_RETIRED

The failure is on top-down slots.  I modified the assert to actually print the
count (I'll make sure to post a patch regardless of where this goes), and based
on the count for failing vs. passing, I'm pretty sure the issue is not the extra
instruction, but instead is due to changing the target of the CLFUSH from the
address of the code to the address of kvm_pmu_version.

However, I think the blame lies with the assertion itself, i.e. with commit
4a447b135e45 ("KVM: selftests: Test top-down slots event in x86's pmu_counters_test").
Either that or top-down slots is broken on the Lakes.

By my rudimentary measurements, tying the number of available slots to the number
of instructions *retired* is fundamentally flawed.  E.g. on the Lakes (SKX is more
or less identical to CLX), omitting the CLFLUSHOPT entirely results in *more*
slots being available throughout the lifetime of the measured section.

My best guess is that flushing the cache line use for the data load causes the
backend to saturate its slots with prefetching data, and as a result the number
of slots that are available goes down.

        CLFLUSHOPT .    | CLFLUSHOPT [%m]       | NOP
CLX     350-100         | 20-60[*]              | 135-150  
SPR     49000-57000     | 32500-41000           | 6760-6830

[*] CLX had a few outliers in the 200-400 range, but the majority of runs were
    in the 20-60 range.

Reading through more (and more and more) of the TMA documentation, I don't think
we can assume anything about the number of available slots, beyond a very basic
assertion that it's practically impossible for there to never be an available
slot.  IIUC, retiring an instruction does NOT require an available slot, rather
it requires the opposite: an occupied slot for the uop(s).

I'm mildly curious as to why the counts for SPR are orders of magnitude higher
that CLX (simple accounting differences?), but I don't think it changes anything
in the test itself.

Unless someone has a better idea, my plan is to post a patch to assert that the
top-down slots count is non-zero, not that it's >= instructions retired.  E.g.

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index accd7ecd3e5f..21acedcd46cd 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -123,10 +123,8 @@ static void guest_assert_event_count(uint8_t idx,
                fallthrough;
        case INTEL_ARCH_CPU_CYCLES_INDEX:
        case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
-               GUEST_ASSERT_NE(count, 0);
-               break;
        case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
-               GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+               GUEST_ASSERT_NE(count, 0);
                break;
        default:
                break;


