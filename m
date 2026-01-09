Return-Path: <kvm+bounces-67534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7E2D07C6D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C705306D525
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24412318ECC;
	Fri,  9 Jan 2026 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lYUfgj/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A731690E
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946952; cv=none; b=AMcTnPTXYDv6HOxIOzRIdpv7Nap6HaMyH+2mtwJ/n3fxZhqxVDKhbY5NcxNxXCwrOrP5g5DT0KSXTFxpXX53/SB6Et0rZFD+ZunV3j28FJZRTGYs/KIH71tiT6hc82bHee2wTY1MWf/SebJQmsl9SufhQShXpheTBuOVdVBUoZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946952; c=relaxed/simple;
	bh=mo9GXML61XGn4VK/rkKAhV/8Z1SqfPf2w6zAttWNXms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oek1D1UCqqL6gVBpZ7n/K25R/Cb+QLAdZcKz5aka46Eq/v7eFTRBdFFoiEtO46VqZAWMzp/pCpXQJ0LS43BaZWF0EjTTqQ7VvPzptRUAKadK2lJl4jCpYMnRzU3I8T8jrhQQEu6luf6JHSdDjbQgQAzK/e2tDb1U9+EbNKiwK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lYUfgj/M; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d3c9b8c56so41203515e9.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946944; x=1768551744; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aoza9Haxbx5GFTKXR2e7jJHN2DZHptcSpiNA0k5YVqc=;
        b=lYUfgj/Mzg96At6rupQCNGNpOgo0LshSKYrQqNUAC9EE3pFlsIkhavdusLgrnqTZSd
         isTdJUts4oufIF3BDoI/q6ghx9her/tZSYrUL/OoUEao3mjnhrsNEXGYzP0p1/lgXPDY
         LNMzTKa8ymvABF+RNJDnnBwYsGWNLfTQ8KoXh4S9nKbzvF3mij+jOCasvaguLAtnlgb9
         TTEni5nrx9zWwNEaf2z3l16sTlINfANrbiFeR3sDE27YnDgzhFV9UOgMi9Nlag2AoX9G
         wcrqn4ow52zWFsbgIMu7yV6MyFYGGf80zVS/miSCzZQILFqKKaKcUpPGt2k4bJAnO65X
         uQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946944; x=1768551744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aoza9Haxbx5GFTKXR2e7jJHN2DZHptcSpiNA0k5YVqc=;
        b=HwP/KdfBbtI6Fd/VeeBYpdLUlOmquUPuMlsGLbwskyghHDc+5tXxLsCQ+7e33rvao6
         G8gRGrmcNX/ZYZZE0cktrC44AfiT82Tn2+6/aJ7mS2PgmvUeBPGz4cilKvpOEqpfLcLj
         kHk7JX1/pu1+Cmn8x4GSjwbH7acTWnJXZLgT4w0OoWQN06e0K7GDJHqTaJY+5Izr5xvr
         +52A9Ujc7pvLlUEZcRn/QO/2RiI7ISFlnA9A8RhlgTmNPBmk6BM3dBR8oDKQ70NoQmfg
         tjFKcZFW0is/Rhg8dCXPMiUWiz5EDVi9KtBRxln9xjarndMVFXAgnC+sHU7MInDHACy6
         oscw==
X-Gm-Message-State: AOJu0YxmFNu/JTjT80VfSu7sE8tIpIMHJYk1RxQLdNFo5MqMcR0mAoP4
	5qce9Ao5skzoNs/5gorPzNBPtglH12OVBCKbfjxfpIiJv25aV+LUc3pP5xyrdSh5+tljlDEnCJ1
	Hhh0+43ioinj4aCZQcvRQU3ZYqF0KFxJfuc5lDDiTUs4JT1RE1oWeqOf4ww2DEz3uLP1qXceTi/
	84RTJ+/0yAbG5a671OR3ePDj+Ykms=
X-Google-Smtp-Source: AGHT+IHW9z0RPtuJdgNq8q1u7Cdds1c5PfbSHvpUeu/W5K7Hz57K1sxTcMubWIfqET+Z4aJyqUaOS37UlQ==
X-Received: from wmpj3.prod.google.com ([2002:a05:600c:4883:b0:477:7949:c534])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c3cd:20b0:477:af07:dd21
 with SMTP id 5b1f17b1804b1-47d8a17124bmr45924505e9.25.1767946944632; Fri, 09
 Jan 2026 00:22:24 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:18 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-6-tabba@google.com>
Subject: [PATCH v4 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 747effa614f1..97f9251eb073 100644
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
@@ -1264,7 +1264,7 @@ static inline uint64_t vm_page_align(struct kvm_vm *vm, uint64_t v)
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
2.52.0.457.g6b5491de43-goog


