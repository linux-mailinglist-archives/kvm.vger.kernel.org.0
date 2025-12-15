Return-Path: <kvm+bounces-65994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA56FCBF171
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D01DF301F3C7
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB4334216B;
	Mon, 15 Dec 2025 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UeW0GTGb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F985341AAF
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817524; cv=none; b=R4SNONGtvKvBLA39J0nH+Zw53oa+pVpcqf0KtJ6XgKVRXLqqMEvPHAln3AK+3cupAg3chFKmAhyQStuEm9AFIFX6U6KJwPBR/YrRBScGzVevHe600QHEqVT3rD9uCaL8hg2PChQtycRy86/eDZk51rE66xzsn5bwUrBWcd9Oqmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817524; c=relaxed/simple;
	bh=TWjDxQpMgkVth7jbbSyhOqWrMH5tsBTMps1o8Gffwyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eQILQ38Wddl3O6Wx5c/YVJIQSgEgZJA/yHgRZneVifgkbLLDPLOuYIoytAa4hroPfbdPpTeYuwtMAfvwo6yMzurIjC561xwBl1/fWyTt6bIfcYs22jL7hMHaipzc2E67daVsbyjEXpWOKyMijzdbTdkZBwrF6+d2TO/l4pwzo+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UeW0GTGb; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cabba65dso24707075e9.2
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817521; x=1766422321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=UeW0GTGbq9nicjq4G+f3adV5EmpV1bJ+QiNqwu1pq/46dGpT7gzNHaymQOIkMQeyjb
         OnDkwZ1uuzufsAb/6VNyjPnunCLM6HKZ68+j5HJCnEUv8ZmETkJlxh/5aWAo56IGlGJn
         rhRX2OJcuJvs73gq3aY3IPQotBxq2mZQbifd/uRDlV8D9hP4omFvmzSZTOJYSu2Tki5w
         TBxIHXZqO8CupQW+PyciT1pfIbftyeBsSFpDL90P1cFWyfi5G4vFjcfMEBBZ4kuBKavl
         dn9dlb8R9N6uExqMaeFZyh0GpPfYVQJQVUoAZcicLdemlDQAVgckouLNArqTug11C0kl
         RlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817521; x=1766422321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=Br7Q7qQJrjeKy4j7XxRF9Ef2TlUlXp7iqodG4OosVsw7HBBH9yWqzDTQTKT5WH9/Rp
         4ZDs+w50NRD2w87R0JLY5ynrx31H/c7vb9gZ8EZU0xuULVLKjzLzUdUJH2Cge2qSOnWQ
         ch+QVXg/mMTYsJqJJ4oOOzeS7OIKOUHVSLywwjQOnJ5s3pvbGRyhu1ZyPxUVGvvLJQqF
         MwR/mm021+t9r9iM98A8VPJI1FnMuog2NPiflNMmgZ9hx7PRgW5YlvECnj3mx5qfO51x
         LZ3IC+NyHQOo4rRyT+SOqm6+Hf2HObo7SwpYyuZUPIKiRqgTQ5DotPWtLCquzrxTpgup
         7IwA==
X-Gm-Message-State: AOJu0YwG6LHQ94rXQLz5MoSgvEk9DAAn4LJgvv0lzMlnxd/IM1O55DdF
	lh3wRpXBbgGmcvpo0oJYocmQbr/u/6jqld9zfw/VtdXXkCMriYWJQKOXPc3qMUF/87nwy9c1E8e
	stlmPXo9WkS64FtYCiD/FlhAr63JFYbUWrqtDT0ypZEmqABZI3E533pr7p8p78UHhUUfj6Dughc
	iXIiSGP8AGE4bOv/KcAhhAhSrIs5A=
X-Google-Smtp-Source: AGHT+IEtLqdqM2TCcz8tE6+Rp1QAj2pRxjGKZNUndLMFxKWF31WsAS2y+R/nz+ivNRonRnxHnhbxUpbtug==
X-Received: from wmxb4-n1.prod.google.com ([2002:a05:600d:8444:10b0:477:9bcb:dd8b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8288:b0:477:a1a2:d829
 with SMTP id 5b1f17b1804b1-47a8f8c0caamr110913215e9.13.1765817520904; Mon, 15
 Dec 2025 08:52:00 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:55 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-6-tabba@google.com>
Subject: [PATCH v2 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fix minor documentation errors in `kvm_util.h` and `kvm_util.c`.

- Correct the argument description for `vcpu_args_set` in `kvm_util.h`,
  which incorrectly listed `vm` instead of `vcpu`.
- Fix a typo in the comment for `kvm_selftest_arch_init` ("exeucting" ->
  "executing").
- Correct the return value description for `vm_vaddr_unused_gap` in
  `kvm_util.c` to match the implementation, which returns an address "at
  or above" `vaddr_min`, not "at or below".

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index dabbe4c3b93f..e29b2cbcb82b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -939,7 +939,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
  * VM VCPU Args Set
  *
  * Input Args:
- *   vm - Virtual Machine
+ *   vcpu - vCPU
  *   num - number of arguments
  *   ... - arguments, each of type uint64_t
  *
@@ -1264,7 +1264,7 @@ static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 }
 
 /*
- * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
+ * Arch hook that is invoked via a constructor, i.e. before executing main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
  * the default guest "mode".
  */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8279b6ced8d2..fab6b62d7810 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1351,7 +1351,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * Output Args: None
  *
  * Return:
- *   Lowest virtual address at or below vaddr_min, with at least
+ *   Lowest virtual address at or above vaddr_min, with at least
  *   sz unused bytes.  TEST_ASSERT failure if no area of at least
  *   size sz is available.
  *
-- 
2.52.0.239.gd5f0c6e74e-goog


