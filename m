Return-Path: <kvm+bounces-34614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4211CA02CEB
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B61243A64C9
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F525145A03;
	Mon,  6 Jan 2025 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b="Y8e8CbWq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8D81728
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179041; cv=none; b=WqoxBYt8G9dFXV0bHIvKSPKWMnBGJ7M/vVUeA2kfqsbKtLGoK/J5yIo7CbNuNveL9ZVticSHsD/DXq+Yfzq/GY/7V17groxG4hB1+14flQB5C8afgIu+9OMYvuVSGVwUWDTFWUw+pfNHRQxIh1GxjYfcK9+iO4LXiQsCUgM/TwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179041; c=relaxed/simple;
	bh=tRUrB/r/tfuAL3vK8alFSNvMMIzwYjh6k3RMYJWmOB0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FqXgC+e9D5DJvTQH688Cjwsfl3K8IOi5XeeJda3qii5K8NRNlZaAoK079Hq1BRC8SZf4xFTLavJe6PnxFvHc7j5cRtFaq8PGZvmtQhIUIf98w7ryY7Hg0DODSlDG+l+Q+V0ME3zamvnF+QpXcur/NxFwYXH5lNmpk9G3iN0ZNoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sslab.ics.keio.ac.jp; spf=none smtp.mailfrom=sslab.ics.keio.ac.jp; dkim=pass (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b=Y8e8CbWq; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sslab.ics.keio.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sslab.ics.keio.ac.jp
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2163dc5155fso206347315ad.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google; t=1736179036; x=1736783836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N93vSe2DAsJuZgTNRjIV6wR3t9pWSfA7zyzPq7fk4Oo=;
        b=Y8e8CbWqpdhd6kjX8+uJBECPai7fY9m1ISKoorqYU52wAz2MI5lkQc8wMZFrYZPr+o
         3tV0z2N3PJElnNxj0aUr2cBLbFsdeQd9fRd62+NBKQJwh2zUVPQ1Jan8zlKvv0RHoZDa
         UmUPFViswByZSiX2CTG2auSWr4FdMD1mEaPcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736179036; x=1736783836;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N93vSe2DAsJuZgTNRjIV6wR3t9pWSfA7zyzPq7fk4Oo=;
        b=tqXB7c2yliLUZOrBtTy0gIEeFaXJIfQXQeogK2vcg5FU4vMKUeNvQGjSznuQwU0CQi
         e0s3EofArK8mnsOVqSPmALwdpD27yfMDqQ2ibpZXX06TRguR7WWOUGgs1MUUFSyfZOEt
         3OODWn33OBLqiN9M/wVGFBwlg2OrXSUmHaaS4NnRjjeiAikngOmPA+uYGQ5OBCGMrWMO
         fcMfpNw5a8nNTP20KgxunP5RM8+NLMOYuLG8gSaKfJCE1nX17kDr35paOte+5u1UAYxA
         juLlrBq4KJEPhK067pbZWaI3E+Fkc1rnfFHr0Y2iw4eOVSpSdKjkNMgGcfZ+ctW0p829
         If3g==
X-Forwarded-Encrypted: i=1; AJvYcCWrLvsCGtVc8JmATgdnhUrr90Qpir/TATgF6GJtLFknslwEI01QHBeqoKkkVU56YCrb/lc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx0z3Clb10Q0A9vtI8Tg/9KvR7DMByEjgj0yXVe2xdmQNFEKSg
	QHpJO1EApSgZvwDzklIHKbKyU5bdjuw4YhS1u5d33NlfbxfM9Len05K8w6jqp0o=
X-Gm-Gg: ASbGncvykYUF8PN/VdYGETAoUjv4Wqxmblo5vzpddjSiUxzjp/1+Njp8ZAd5UsV/uC6
	fKaHNp7s6SeEVFpRWivwl4Kdw3EnUgUQQO+NBU4awC0vCEJOF4w9EqhNScqoh/+X45NQU/olJ05
	ENJ5X8sjGZn7GeZgaMOGPSb+O+yjaYtgpQXq3YQHxCIpSgNhCzCiVPHqFGcoNZzVS+iHY/xxX7y
	20xQqDfjvr9qgApxvMaZ5EvCkxtyZZOTJMhfXk+VqmLKOgiuPw7gXmcbZ5T/WG4loU5tP9mJRbQ
	byUCzwg54LqnSEveAQ==
X-Google-Smtp-Source: AGHT+IG4VxobKTRMfWHkqOEB5k1ZQenI6Eqz1wsYpfOBXX86fzC91fIpukWV2YSzC8s+9RmcrhJ6JQ==
X-Received: by 2002:a17:902:e542:b0:212:1ebf:9a03 with SMTP id d9443c01a7336-219e6e8c4fdmr861763075ad.2.1736179035024;
        Mon, 06 Jan 2025 07:57:15 -0800 (PST)
Received: from saraba.tapir-shark.ts.net ([131.113.100.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca025desm294122405ad.256.2025.01.06.07.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:57:14 -0800 (PST)
From: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: vkuznets@redhat.com,
	Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Subject: [RFC] Para-virtualized TLB flush for PV-waiting vCPUs
Date: Tue,  7 Jan 2025 00:56:52 +0900
Message-Id: <20250106155652.484001-1-kentaishiguro@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In oversubscribed environments, the latency of flushing the remote TLB can
become significant when the destination virtual CPU (vCPU) is the waiter
of a para-virtualized queued spinlock that halts with interrupts disabled.
This occurs because the waiter does not respond to remote function call
requests until it releases the spinlock. As a result, the source vCPU
wastes CPU time performing busy-waiting for a response from the
destination vCPU.

To mitigate this issue, this patch extends the target of the PV TLB flush
to include vCPUs that are halting to wait on the PV qspinlock. Since the
PV qspinlock waiters voluntarily yield before being preempted by KVM,
their state does not get preempted, and the current PV TLB flush overlooks
them. This change allows vCPUs to bypass waiting for PV qspinlock waiters
during TLB shootdowns.

This enhancement improves the throughput of the ebizzy workload, which
intensively causes spinlock contention and TLB shootdowns, in
oversubscribed environments. The following experimental setup was used to
evaluate the performance impact:

Host Machine: Dell R760, Intel(R) Xeon(R) Platinum 8468 (48C/96T), 256GB
memory
VM0: ebizzy -M, 96 vCPUs, 32GB memory
VM1: busy-loop, 96 vCPUs, 32GB memory
Experiments Conducted: 10 iterations

Results:
- Without Patch: 7702.4 records/second (standard deviation: 295.5)
- With Patch: 9110.9 records/second (standard deviation: 528.6)

Signed-off-by: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kernel/kvm.c                | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..db26e167a707 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -70,6 +70,7 @@ struct kvm_steal_time {
 
 #define KVM_VCPU_PREEMPTED          (1 << 0)
 #define KVM_VCPU_FLUSH_TLB          (1 << 1)
+#define KVM_VCPU_IN_PVWAIT          (1 << 2)
 
 #define KVM_CLOCK_PAIRING_WALLCLOCK 0
 struct kvm_clock_pairing {
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21e9e4845354..f17057b7d263 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -668,7 +668,8 @@ static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
 		 */
 		src = &per_cpu(steal_time, cpu);
 		state = READ_ONCE(src->preempted);
-		if ((state & KVM_VCPU_PREEMPTED)) {
+		if ((state & KVM_VCPU_PREEMPTED) ||
+		    (state & KVM_VCPU_IN_PVWAIT)) {
 			if (try_cmpxchg(&src->preempted, &state,
 					state | KVM_VCPU_FLUSH_TLB))
 				__cpumask_clear_cpu(cpu, flushmask);
@@ -1045,6 +1046,9 @@ static void kvm_kick_cpu(int cpu)
 
 static void kvm_wait(u8 *ptr, u8 val)
 {
+	u8 state;
+	struct kvm_steal_time *src;
+
 	if (in_nmi())
 		return;
 
@@ -1054,8 +1058,13 @@ static void kvm_wait(u8 *ptr, u8 val)
 	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
 	 */
 	if (irqs_disabled()) {
-		if (READ_ONCE(*ptr) == val)
+		if (READ_ONCE(*ptr) == val) {
+			src = this_cpu_ptr(&steal_time);
+			state = READ_ONCE(src->preempted);
+			try_cmpxchg(&src->preempted, &state,
+				    state | KVM_VCPU_IN_PVWAIT);
 			halt();
+		}
 	} else {
 		local_irq_disable();
 
-- 
2.25.1


