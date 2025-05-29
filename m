Return-Path: <kvm+bounces-48064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13299AC8545
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1ADB4E6534
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DAC26D4D8;
	Thu, 29 May 2025 23:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sWtxPjhy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A284C26B94E
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562067; cv=none; b=TzHSfv0XO/XVVjV/t4HqWDYUBvgdk/M+zC0rolBL93WtW9Ej1DQuu7toBI0LBXrvpNXSYwaZejxiA7gSdRHI/SwS8xGPKqBadQr8i4NFdj46dJqmhBuGeXZWML+zA/x7Bg/uHlbkRTLgRAxIrEXqykVG87eFdRavCG3eO1khbCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562067; c=relaxed/simple;
	bh=oPSfAtIATZQ8+qjKJYNi2UiBRx/9GSId3SQECpQ3XcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kYlxqlJl+3B7cF1yz3UG4oY0IWTpr0IokgmB+DZv4PURUyKc4dN+X/+wUCPkKfxsBOcMQnd8Y0NmKsTR5d8wzEiSATil/vpIrtNm7Zx3/ew3l0ypqSaHTCTuTKF1lPUn6aMKnSjnijphUX+6pgBoeha4knwkt8OyrgvLt6N9Uno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sWtxPjhy; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so1619065a12.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562065; x=1749166865; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D1w9eruoa/+h1y+kxAKN4nRm8YX18Xo+mwrCh9wmFfY=;
        b=sWtxPjhy+90GwC16Zi7TyRC/+NOdShGwJDbqSiycPijQN7kEL+nMbh/1QD6cE9Tymd
         qsYwesgvbwpzU6V8SMTtdU3HIMtfxaHSZaHJ7TUYSOt0/pes1bg2eV4DvhfzMoEhKKvh
         8vN0TAJOT8LcO/tP+QfhrxqaxqCBdWry1/Eyou8EaOAWghG+Qn8vYylLvAPOE0OoqJZr
         pXQZfH1mXN38LZQqF7rNChTuSKJC8g1aW91dac15Duvo9Fh/7Rw0Gw/Bm2FJsI12AE9Q
         xCaGD5pso/2cO0pLJvfFeUOoRWS7ar8i5KL0aCjeS4SLBOfar8/Ld+JCrKqpsaluj9H8
         C11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562065; x=1749166865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1w9eruoa/+h1y+kxAKN4nRm8YX18Xo+mwrCh9wmFfY=;
        b=ROXBC00LNlwyJzpNzaAl3mkT7qawgncmvyuqyvCEW33UrgiNotT/ohghntvPy9QdbI
         6hHbSzXxdcLHMTtMqDejds13tQPEfIko5j3GwETkLcJcg+ufEuIWKIfF6hCXTYEU3BMS
         KpbLeUhYUJRaEIEjejzo5ErDkC3pGd/DNf/1UeSwt2c0HJe0UpgsH38zHlv0/CQFUrNQ
         uzV/9PUyRkHJq0NOfnTjUG/GH57jQcxtqHQBn0ayQ1/TZ1uGdyjQYF1T0fb3nnuEWNJ9
         +YL6ZauwnIIlkqkoofRo5CAM6GcFv0CpZIgn3sOP+4TLtbq2ee7pQXkaBUVcU59qUSrx
         RLvA==
X-Gm-Message-State: AOJu0YyxBoPdT5y/TYLp+ELluTzrw7bCkDeU0NwjfOJYhWucilwPeU/Y
	GDLOMNLCcP2ZCHh5YnlE4loPkZHODmvdtEpfsG9Q4xH+cdFglyg6xx3lNvSQbFofWVRCkncAUak
	hBh39Sg==
X-Google-Smtp-Source: AGHT+IHW019t6bOh5r2+n8eqSR6m7pMK/T98B2/buD8Ya8XZUgrDevK8/xH/YgciZlXidl8e6363cIkMFQE=
X-Received: from pgbcs3.prod.google.com ([2002:a05:6a02:4183:b0:b2e:b47d:8dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c3:b0:215:f519:e2dc
 with SMTP id adf61e73a8af0-21adff8a5famr337694637.14.1748562064661; Thu, 29
 May 2025 16:41:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:13 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-29-seanjc@google.com>
Subject: [PATCH 28/28] KVM: selftests: Verify KVM disable interception (for
 userspace) on filter change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Re-read MSR_{FS,GS}_BASE after restoring the "allow everything" userspace
MSR filter to verify that KVM stops forwarding exits to userspace.  This
can also be used in conjunction with manual verification (e.g. printk) to
ensure KVM is correctly updating the MSR bitmaps consumed by hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
index 32b2794b78fe..8463a9956410 100644
--- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
@@ -343,6 +343,12 @@ static void guest_code_permission_bitmap(void)
 	data = test_rdmsr(MSR_GS_BASE);
 	GUEST_ASSERT(data == MSR_GS_BASE);
 
+	/* Access the MSRs again to ensure KVM has disabled interception.*/
+	data = test_rdmsr(MSR_FS_BASE);
+	GUEST_ASSERT(data != MSR_FS_BASE);
+	data = test_rdmsr(MSR_GS_BASE);
+	GUEST_ASSERT(data != MSR_GS_BASE);
+
 	GUEST_DONE();
 }
 
@@ -682,6 +688,8 @@ KVM_ONE_VCPU_TEST(user_msr, msr_permission_bitmap, guest_code_permission_bitmap)
 		    "Expected ucall state to be UCALL_SYNC.");
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_gs);
 	run_guest_then_process_rdmsr(vcpu, MSR_GS_BASE);
+
+	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_allow);
 	run_guest_then_process_ucall_done(vcpu);
 }
 
-- 
2.49.0.1204.g71687c7c1d-goog


