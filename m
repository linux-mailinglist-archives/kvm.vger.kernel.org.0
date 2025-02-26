Return-Path: <kvm+bounces-39359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A346BA46B10
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 991CB16E982
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7C624292C;
	Wed, 26 Feb 2025 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OjY5H8m9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DED6242913
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740598218; cv=none; b=HpPbm7SpffKhj+wgZojUe7gZXJsfiGYvtA0mmI3CGG7iwQTthalT1B5BoXK8VVpuZLGeRMRyzaTEZzpy3BCIqxKhwNXT2H5fQuqDSqXi9BmX9/3mS0lXrUVmX8fCJqat0NHYTFS2G/v0CyD5oXbP47Qg3onr58ccN5GxZayEdGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740598218; c=relaxed/simple;
	bh=T8SKnVuj5amiDvmw0Q8NP2f2aLMgczBdy+zu8tchxUc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JWi0OiAyWFJ8k2kj3+d/DI9R2NJkYhzjYCVXdI5+gI7R8/V615wtAUI3VECtxwBOfR8Ub3KVzykQGmF1I6BRbCzT31lCH1bKwzdWbj67/fk07WL/Y7zn9sL8XAi4eYwVJKDtQy3BvT66TR6aen9DsSyMUPso+4qTcscGtfmZfEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OjY5H8m9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe8fa38f6eso380362a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 11:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740598217; x=1741203017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yk9qPe36kdkp/4GjWGuolcvhbSG7j2duzScI0vfASzM=;
        b=OjY5H8m9hqxVvCzxWxb6xnv4WytqjOv9B8XsyzsjfQ88HjXKUncUQw6xybRWOmKdYd
         Wy+b0YDmUrCD+kWWanKJ/41cNL1SI9ZeK2/kPL6SeU4h1pJO7C7opn9Yq1Z4rSp2yoTw
         qmjlnDm8EEXHPXTauPTIjf/7A1981yBQO211CzwbdQqhOM0Nd/Gxw/+oMzmwFrXKh+k7
         Sk7E/2OKmHHfCkGyi9nq+B20oDUFWpgttCKZ8f0fFsHCLiHx47eeg47QyABwD2kCKeTP
         DOGEUBJRLDo5Blj2K0VxuoXLadgo/WtNoRbQl917l3dcp46BxBe5KQAV+VFFlZRgJBGD
         zE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740598217; x=1741203017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yk9qPe36kdkp/4GjWGuolcvhbSG7j2duzScI0vfASzM=;
        b=qo22OpdNDbw5/lFXG+HpNZZTl2J+u2bsyhCQDc8R0kB/Omwhi8rxw2am4JNMIcQWyA
         TXsWfZFVvUzV5ECCi6Jh98H4icsLOUQUDzhmeRCvKRN7crgfVrT7yWrM7QSp/iU5goXP
         KyBM4a7ZU4Wk5Iob8K1U/V9tvBiKB4p743j/ux+9VHvAvd8THHbVW+qqrSn1IbZm4ld0
         eEjYg1oHbtlx1dY5cseIREQZWKxkJhPevQOBrs4xUrV8cVUNOZ9JILO9BttFJzFr8T3z
         pa9Kh36qBD0KAoJRrCTWqNuqmKsxuCLufyAIt5DOeA6Mw3iKwg6nv5FgI1Lwv+XPJ2EC
         IW7w==
X-Forwarded-Encrypted: i=1; AJvYcCUDPD0KP+ZLqaQtExCbDEoz3Q1n4BlM787CEuDXQmWoKRTCUhAcKXk/mKyLZgcr/gct6oI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlb20RThD4pc/lAirPnU2htfiKjFAREG75ajEvLTr8ECAMROke
	CTASAWs4XD/3TJ7I2T5VQQ/Eo5xiycBn8W0QwwN89aFCXoNLWfHx7YMFtRDNCWFm6cmUjrUIWvc
	KYw==
X-Google-Smtp-Source: AGHT+IHBKYGn/gl8hziMmDxNGUh/uHXjoq+aD6OtmP7y0wfSfIPRlFBItqTtqbmEp+G/L2qNVWF+MTW8bww=
X-Received: from pjbsf13.prod.google.com ([2002:a17:90b:51cd:b0:2fc:e37d:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56ce:b0:2eb:140d:f6df
 with SMTP id 98e67ed59e1d1-2fe68ac9543mr12810336a91.1.1740598216741; Wed, 26
 Feb 2025 11:30:16 -0800 (PST)
Date: Wed, 26 Feb 2025 11:30:15 -0800
In-Reply-To: <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250208105318.16861-1-yan.y.zhao@intel.com> <Z75y90KM_fE6H1cJ@google.com>
 <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com>
Message-ID: <Z79rx0H1aByewj5X@google.com>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Yan Zhao wrote:
> On Tue, Feb 25, 2025 at 05:48:39PM -0800, Sean Christopherson wrote:
> > On Sat, Feb 08, 2025, Yan Zhao wrote:
> > > In the read-only mprotect() phase of mmu_stress_test, ensure that
> > > mprotect(PROT_READ) has completed before the guest starts writing to the
> > > read-only mprotect() memory.
> > > 
> > > Without waiting for mprotect_ro_done before the guest starts writing in
> > > stage 3 (the stage for read-only mprotect()), the host's assertion of stage
> > > 3 could fail if mprotect_ro_done is set to true in the window between the
> > > guest finishing writes to all GPAs and executing GUEST_SYNC(3).
> > > 
> > > This scenario is easy to occur especially when there are hundred of vCPUs.
> > > 
> > > CPU 0                  CPU 1 guest     CPU 1 host
> > >                                        enter stage 3's 1st loop
> > >                        //in stage 3
> > >                        write all GPAs
> > >                        @rip 0x4025f0
> > > 
> > > mprotect(PROT_READ)
> > > mprotect_ro_done=true
> > >                        GUEST_SYNC(3)
> > >                                        r=0, continue stage 3's 1st loop
> > > 
> > >                        //in stage 4
> > >                        write GPA
> > >                        @rip 0x402635
> > > 
> > >                                        -EFAULT, jump out stage 3's 1st loop
> > >                                        enter stage 3's 2nd loop
> > >                        write GPA
> > >                        @rip 0x402635
> > >                                        -EFAULT, continue stage 3's 2nd loop
> > >                                        guest rip += 3
> > > 
> > > The test then fails and reports "Unhandled exception '0xe' at guest RIP
> > > '0x402638'", since the next valid guest rip address is 0x402639, i.e. the
> > > "(mem) = val" in vcpu_arch_put_guest() is compiled into a mov instruction
> > > of length 4.
> > 
> > This shouldn't happen.  On x86, stage 3 is a hand-coded "mov %rax, (%rax)", not
> > vcpu_arch_put_guest().  Either something else is going on, or __x86_64__ isn't
> > defined?
> stage 3 is hand-coded "mov %rax, (%rax)", but stage 4 is with
> vcpu_arch_put_guest().
> 
> The original code expects that "mov %rax, (%rax)" in stage 3 can produce
> -EFAULT, so that in the host thread can jump out of stage 3's 1st vcpu_run()
> loop.

Ugh, I forgot that there are two loops in stage-3.  I tried to prevent this race,
but violated my own rule of not using arbitrary delays to avoid races.

Completely untested, but I think this should address the problem (I'll test
later today; you already did the hard work of debugging).  The only thing I'm
not positive is correct is making the first _vcpu_run() a one-off instead of a
loop.

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index d9c76b4c0d88..9ac1800bb770 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -18,6 +18,7 @@
 #include "ucall_common.h"
 
 static bool mprotect_ro_done;
+static bool vcpu_hit_ro_fault;
 
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
@@ -36,9 +37,9 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
        /*
         * Write to the region while mprotect(PROT_READ) is underway.  Keep
-        * looping until the memory is guaranteed to be read-only, otherwise
-        * vCPUs may complete their writes and advance to the next stage
-        * prematurely.
+        * looping until the memory is guaranteed to be read-only and a fault
+        * has occured, otherwise vCPUs may complete their writes and advance
+        * to the next stage prematurely.
         *
         * For architectures that support skipping the faulting instruction,
         * generate the store via inline assembly to ensure the exact length
@@ -56,7 +57,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 #else
                        vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 #endif
-       } while (!READ_ONCE(mprotect_ro_done));
+       } while (!READ_ONCE(mprotect_ro_done) && !READ_ONCE(vcpu_hit_ro_fault));
 
        /*
         * Only architectures that write the entire range can explicitly sync,
@@ -148,12 +149,13 @@ static void *vcpu_worker(void *data)
         * be stuck on the faulting instruction for other architectures.  Go to
         * stage 3 without a rendezvous
         */
-       do {
-               r = _vcpu_run(vcpu);
-       } while (!r);
+       r = _vcpu_run(vcpu);
        TEST_ASSERT(r == -1 && errno == EFAULT,
                    "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);
 
+       /* Tell the vCPU it hit a RO fault. */
+       WRITE_ONCE(vcpu_hit_ro_fault, true);
+
 #if defined(__x86_64__) || defined(__aarch64__)
        /*
         * Verify *all* writes from the guest hit EFAULT due to the VMA now
@@ -378,7 +380,6 @@ int main(int argc, char *argv[])
        rendezvous_with_vcpus(&time_run2, "run 2");
 
        mprotect(mem, slot_size, PROT_READ);
-       usleep(10);
        mprotect_ro_done = true;
        sync_global_to_guest(vm, mprotect_ro_done);


