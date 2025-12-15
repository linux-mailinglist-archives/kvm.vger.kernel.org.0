Return-Path: <kvm+bounces-65985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00765CBEC91
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0C0CD301E6C4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440DA30FC01;
	Mon, 15 Dec 2025 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wIzBbRcL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C93930F535
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814152; cv=none; b=HaM9yYd+2IEJXX+dNSNGthGh9AzJY30Wr7N/lHSbFFdvDtE/X3Uw7pXze27pDUrnuagyjmTKp5T7+aTQb+rrXRJoMwc9nYR/NqE7dzlFRISbtc1kINsm8Uab9682HaMcijtx2/5qTbI/vozJRxYPDCP6SHCLpall/GDNeo2FMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814152; c=relaxed/simple;
	bh=TWjDxQpMgkVth7jbbSyhOqWrMH5tsBTMps1o8Gffwyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ua/m22PGDGSHlEs3zaJyYJv5Z9kHVP4WVvFET/iUSn/t2owJiwNDO86Aumb4YFuAD7F3kztR1jTWBytRNvFL5oEG8VGIOT4qtPttAQXa9zcz8TuDCHHbOzfhr50Y2chi5B7BGfXsazIDYXsxPUka60qmS8sp8N/gFpNiq4Xab18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wIzBbRcL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso25425865e9.2
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 07:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814149; x=1766418949; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=wIzBbRcLEopaY/nrmgprT4MYunfJU4BPhdwnuaWsaqPpUy8KMHyWQrcisZUmFCaT32
         LTIjty7xw95So8osClmFDdHVhIlnOxmJo8ZMP7zXyBNMUMKOsiG+JHKNuru3oQRV0p0N
         zQKTt/m+T5+/F1OuZBJIKFasdT+01xy03gd0lQyBsDzGQfyzc+v5xJ1WKFyU9BrD5F6N
         ZM4Zw7zHM+YOnEo5Jy1+CchqosXryWK2wxpP4YlZXYcxsVkEUPJKznwfLUp+FVvOovKo
         t7OrNhrCmDalX/G+XBpSdDQzkmDlHQWyY5DndfdRKlAfNM3MFQwmrJFQssKFb/CEZRHl
         Jq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814149; x=1766418949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=T7KsLCz9q9hi1NCNvM9itwNh2E3aiI+7GZvbPkbNemmBTSo9kkXoqTP3yM1c0xlw6D
         ApRX+JEQAoNmlWV+yjjklzR8eNpIOt/OBpsP8NoDWgWtew/j6hMXByrWgeavFX4foWOF
         /724J1ADu49OEUAGs84mNPpd7HuQ1Ko4jHuduMHa1jN3m5kTYsbAnzMCZcxC7IOofSQf
         IZ3PS78+KrtAQ063Ltar+ZkgqIWMyELuOKa9JE8QWxwxOG3E/M08AzlTGIImKVbnNQqy
         exWWxWK+WpP2o5zm9gtBg7aphy/sgsgQar/qCYCyJ2blxKJkSQHpmbp5P6h0tb8P4Chh
         vTHQ==
X-Gm-Message-State: AOJu0YxfdfbXTIMe8yJJLZKs5xe2Ig0szEz3EPVhPzzGGN8+dAN7WEMf
	Gqt6EjM0QefbRchugb2eKt7o9eK5KYB7l4w68260AAS2LDWnXW+jFT/b2aVZpM/BSTC90SkhBRs
	22OE3ojK1hM0lEuw/1KbUFT5krjYgTJTUh9hT8q0gH6Onh2ox/BcJ2p/tZ7voLXqdnkfNM1nFtV
	yeeDCAnMH679qYomEvx92RE5t57M8=
X-Google-Smtp-Source: AGHT+IES4jG/AJJaQokwhO8mvkU4za0NFopEVHb/TmIMd0XerlweEG7bA0GQE5iiPaq784YzJOJCMBPrkw==
X-Received: from wmbdx17.prod.google.com ([2002:a05:600c:63d1:b0:47a:7874:d5d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3104:b0:46e:53cb:9e7f
 with SMTP id 5b1f17b1804b1-47a8f9071aemr108797745e9.18.1765814149007; Mon, 15
 Dec 2025 07:55:49 -0800 (PST)
Date: Mon, 15 Dec 2025 15:55:42 +0000
In-Reply-To: <20251215155542.3195173-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215155542.3195173-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215155542.3195173-6-tabba@google.com>
Subject: [PATCH v1 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: tabba@google.com
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


