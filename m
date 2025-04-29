Return-Path: <kvm+bounces-44632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1912A9FF06
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46599189AB69
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF0A19E826;
	Tue, 29 Apr 2025 01:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XqVd/DnK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F7142900
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 01:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890001; cv=none; b=giRZNz3ptPe+uEUu+u5FPt6UgPqPq0f17bD/gxwd70WZAwiYnVBeQX+cdixZBNENdvUhc8RRA4EyKdyjagnL1yGlUBdv2Dw5RhucL7sF1ZvZWCc6LB1/tn7uWGK51K3Ipqiq5x0XfEkjYElyHlw/rU9t5mtv4Cwt4Exu8xOEKiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890001; c=relaxed/simple;
	bh=dUG2oOsPfvtlcbD7bd1owP0P2jOP6U4HVZnFVbTYyZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BlA7ivq1ZHHXQXtbV7+yZFRlQlgjZJNk0dy6Ezuz+y+75ZMXWZFyUgy885o1o3aH7blnf96pQwixyB31dylh30gOGwanMFRBIUZ+3QX8MbB/xIcY6QiTjQ/lhhMyIZIYTNZGqKSFTJuP/ki4pvY0z6hj/VgvBlXmCDiM12wsZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XqVd/DnK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736abba8c5cso6507039b3a.2
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 18:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745889999; x=1746494799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FzPz83nCmaRFrzD6Tg7DFnNEEe/hxmIWREdWcgNx64I=;
        b=XqVd/DnKZ7JtlIbKipaJO/z15DY4h12+SQgkzzOF/jO6UklDy40GZg+FXoLLS+Osql
         mMovP7Wo5s+7IiGSdR16h3Lbj31velgtm9plXcpckNMgqxV2Qk5FEOktxfqZE3MQpZ0p
         kDNAhPvRNEPLHRU5eLasnZtpiG26sZdW44fC/8iNGlHIqdTM4KcPBfAro1O9qrBtptEC
         8k/QQrtrStV5Ieuv+AnecRGnG+7G6+jySuQ7DKwzOLoOkSRt1Fm25z0mAmSmpjXa6etv
         EaYQt57ohUAzcGk8rZ3Yxf2TKxB0WgsEjfN87+l3yfPVYT5hmAptv9IP6+5M/ovO5ofU
         ZZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745889999; x=1746494799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzPz83nCmaRFrzD6Tg7DFnNEEe/hxmIWREdWcgNx64I=;
        b=jX3Zco89bscg+S+FiWRzEZDSvRlPLDVFzKqT9CIDi/Gg0641Q3NsB20TNxxIAKBzKO
         KoZvepyJMBL059fuwN+fy0XwPfX7TZo3ympGTboVEjZt13+0KV+fXYK3DJ2zz0+9Kfil
         aLeXRwzwOiMY43+0qzJF/swl1Y83dvgNKXnbv8ZY9wtAU0hXlLFxCv9+rENwrtQ3r4JP
         FRicA3kazZczUMaJwZuJIwtAdZKcd3bc84Th+8IsH2F0PjanCvdf14147MU1xR1C3T6S
         EDVwF8vQ7lcE9rfD6etZifCVqmMnTiGCYS9ajb4JhyBDs3e1ulaRTszLEF9XWxfv+BWz
         HFaA==
X-Forwarded-Encrypted: i=1; AJvYcCWA2WCZRyZ6lQDAL5XMZBokqHALBgjpCH1YA6X+wr215nAVdrGMjLZKXWampHVacaa4ZIM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo3y2ydlnliouO4H9GFyghPSSpo6ai2jVQKwulmsju+H1cpenM
	FQ+VQeb2qIEu+bm7FNGMvnbejeHYHsfLGxSG6s2N1dhsbk0YSZrg2gvT5CTzq7KArLCZWdTaaln
	ZUg==
X-Google-Smtp-Source: AGHT+IFdAplx6Pc4h2/lcjb7odRL/b7FVo7qZsribFp1E+q08dxdOEn3s5HY2PVYghN3RsMron55exH2JbE=
X-Received: from pfjj8.prod.google.com ([2002:a05:6a00:2348:b0:73e:b69:b0de])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e1d:b0:73f:f816:dd78
 with SMTP id d2e1a72fcca58-740271deb7emr2383676b3a.15.1745889999255; Mon, 28
 Apr 2025 18:26:39 -0700 (PDT)
Date: Mon, 28 Apr 2025 18:26:37 -0700
In-Reply-To: <20250321221444.2449974-3-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-3-jmattson@google.com>
Message-ID: <aBAqzZOiCCYWgOrM@google.com>
Subject: Re: [PATCH v3 2/2] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 21, 2025, Jim Mattson wrote:
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <pthread.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +#include <asm/msr-index.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +#define NUM_ITERATIONS 100
> +
> +static void pin_thread(int cpu)
> +{
> +	cpu_set_t cpuset;
> +	int rc;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(cpu, &cpuset);
> +
> +	rc = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> +	TEST_ASSERT(rc == 0, "%s: Can't set thread affinity", __func__);

Heh, you copy-pasted this from hardware_disable_test.c, didn't you?  :-)

Would it make sense to turn this into a generic API that takes care of the entire
sched_getcpu() => pthread_setaffinity_np()?  E.g. kvm_pin_task_to_current_cpu().
I suspect there are other (potential) tests that don't care about what CPU they
run on, so long as the test is pinned.

> +}
> +
> +static int open_dev_msr(int cpu)
> +{
> +	char path[PATH_MAX];
> +	int msr_fd;
> +
> +	snprintf(path, sizeof(path), "/dev/cpu/%d/msr", cpu);
> +	msr_fd = open(path, O_RDONLY);
> +	__TEST_REQUIRE(msr_fd >= 0, "Can't open %s for read", path);

Please use open_path_or_exit().

Hmm, and I'm planning on posting a small series to add a variant that takes an
ENOENT message, and spits out a (hopefully) helpful message for the EACCES case.
It would be nice to have this one spit out something like "Is msk.ko loaded?",
but I would say don't worry about trying to coordinate anything.  Worst case
scenario we can add a help message when the dust settles.

> +	return msr_fd;
> +}
> +
> +static uint64_t read_dev_msr(int msr_fd, uint32_t msr)
> +{
> +	uint64_t data;
> +	ssize_t rc;
> +
> +	rc = pread(msr_fd, &data, sizeof(data), msr);
> +	TEST_ASSERT(rc == sizeof(data), "Read of MSR 0x%x failed", msr);
> +
> +	return data;
> +}
> +
> +static void guest_code(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < NUM_ITERATIONS; i++) {
> +		uint64_t aperf = rdmsr(MSR_IA32_APERF);
> +		uint64_t mperf = rdmsr(MSR_IA32_MPERF);
> +
> +		GUEST_SYNC2(aperf, mperf);

Does the test generate multiple RDMSR per MSR if you do:

		GUEST_SYNC2(rdmsr(MSR_IA32_APERF), rdmsr(MSR_IA32_MPERF));

If the code generation comes out


> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static bool kvm_can_disable_aperfmperf_exits(struct kvm_vm *vm)
> +{
> +	int flags = vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS);
> +
> +	return flags & KVM_X86_DISABLE_EXITS_APERFMPERF;
> +}

Please don't add one-off helpers like this, especially when they're the condition
for TEST_REQUIRE().  I *want* the gory details if the test is skipped, so that I
don't have to go look at the source code to figure out what's missing.

And it's literally more code.

> +
> +int main(int argc, char *argv[])
> +{
> +	uint64_t host_aperf_before, host_mperf_before;
> +	int cpu = sched_getcpu();
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int msr_fd;
> +	int i;
> +
> +	pin_thread(cpu);
> +
> +	msr_fd = open_dev_msr(cpu);
> +
> +	/*
> +	 * This test requires a non-standard VM initialization, because
> +	 * KVM_ENABLE_CAP cannot be used on a VM file descriptor after
> +	 * a VCPU has been created.

Hrm, we should really sort this out.  Every test that needs to enable a capability
is having to copy+paste this pattern.  I don't love the idea of expanding
__vm_create_with_one_vcpu(), but there's gotta be a solution that isn't horrible,
and anything is better than endly copy paste.

> +	 */
> +	vm = vm_create(1);
> +
> +	TEST_REQUIRE(kvm_can_disable_aperfmperf_exits(vm));

	TEST_REQUIRE(vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS) &
		     KVM_X86_DISABLE_EXITS_APERFMPERF);
> +
> +	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> +		      KVM_X86_DISABLE_EXITS_APERFMPERF);
> +
> +	vcpu = vm_vcpu_add(vm, 0, guest_code);
> +
> +	host_aperf_before = read_dev_msr(msr_fd, MSR_IA32_APERF);
> +	host_mperf_before = read_dev_msr(msr_fd, MSR_IA32_MPERF);
> +
> +	for (i = 0; i < NUM_ITERATIONS; i++) {
> +		uint64_t host_aperf_after, host_mperf_after;
> +		uint64_t guest_aperf, guest_mperf;
> +		struct ucall uc;
> +
> +		vcpu_run(vcpu);
> +		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_DONE:
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +		case UCALL_SYNC:
> +			guest_aperf = uc.args[0];
> +			guest_mperf = uc.args[1];
> +
> +			host_aperf_after = read_dev_msr(msr_fd, MSR_IA32_APERF);
> +			host_mperf_after = read_dev_msr(msr_fd, MSR_IA32_MPERF);
> +
> +			TEST_ASSERT(host_aperf_before < guest_aperf,
> +				    "APERF: host_before (%lu) >= guest (%lu)",
> +				    host_aperf_before, guest_aperf);

Honest question, is decimal really better than hex for these?

> +			TEST_ASSERT(guest_aperf < host_aperf_after,
> +				    "APERF: guest (%lu) >= host_after (%lu)",
> +				    guest_aperf, host_aperf_after);
> +			TEST_ASSERT(host_mperf_before < guest_mperf,
> +				    "MPERF: host_before (%lu) >= guest (%lu)",
> +				    host_mperf_before, guest_mperf);
> +			TEST_ASSERT(guest_mperf < host_mperf_after,
> +				    "MPERF: guest (%lu) >= host_after (%lu)",
> +				    guest_mperf, host_mperf_after);
> +
> +			host_aperf_before = host_aperf_after;
> +			host_mperf_before = host_mperf_after;
> +
> +			break;
> +		}
> +	}
> +
> +	TEST_ASSERT_EQ(i, NUM_ITERATIONS);

Why?

