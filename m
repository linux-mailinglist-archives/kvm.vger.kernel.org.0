Return-Path: <kvm+bounces-24316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46BFA9538C5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C15961F25377
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F043D1B4C26;
	Thu, 15 Aug 2024 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="CmMAxUux"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AC21105
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723741758; cv=none; b=CcmTc7M6VOIPSLvZ73chu17+v0VJFboKkrunkeruA6YbJ0Qf0JBunrGirSTIVU9VQVFiOi+D0IpylGtDTd1I4IkmnnXHVeh8p2M+tD6gPX0CNns0b9jEFhwdK32HI+3rhmt/UsnciivimMO7C90BADbuHxxup7odB3i+cNj22sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723741758; c=relaxed/simple;
	bh=X5L5hwnjmA/iS+JyOjzWx8Qds/xtd74+wB99jhBeUsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YIc+tC/TO32U+BNt9QWByueXkmb5JAJ4EKldUUZfpKHuJi2lOKWysVkRrbQ+BmDyvz2xeJewLKm3i+5zfoLDcxV5+oeaBz+4oeqngNmS0DWxHfT0GCkXN611NLycPIb7hXgJi4lz68kRvJ3gdTwRhE9zINFrkZr3/cmBXj+M2Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=CmMAxUux; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-201fae21398so3884985ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723741756; x=1724346556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lVJxT5QcdO7Ui6miH35lV51PmIys+9/MJB+dZzASdvk=;
        b=CmMAxUuxB9TsXBqMO3V8lG4dOvi6Cq4OO8gfz1SzBjxxH/h7V+yVz+u2xuJt8IDDyl
         m+qPNdvsi6iPe2r6wr8s4BVSDtGMRJ25WTxVznbBX4VwhWqhKWLXD5vWwmr9vyqa99uo
         y/nQ6TAY2+gpxdr0loAVdGUBUM+E5DrUu6S2u+2NXTkslVqfU6S1JsoB3WOdr6l5DIRv
         0VpETlQMvPdFDQ5FZHMke2vBDsBLw1KVA+U+cCQDWn3pyP3/i36F2MMyLiG9A3RQyIT9
         EON+mCsTKN8e2rSOV0j6TdyTCjz2fnIYTtjqWTIopWMGVXsoKlzpjb7AfIlE71SAhNCJ
         lmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723741756; x=1724346556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lVJxT5QcdO7Ui6miH35lV51PmIys+9/MJB+dZzASdvk=;
        b=PcH4mylHovW3ASA4guaH524YLUY2DVeTbLQzA4nDq8GCqbj2vRBpS8YiV7U+kZYKKM
         FDcWvuikkihwZo0IKii7M3yTJJgFLqlWcaEV8AtX58gidi+PrgwHxFHE8vyPG1jzR1wa
         W3pD7Ri2OCx5/Mm54Z5zDN+U3skRjBDHIf+YxfOsQphl4RW/WxYNzSncgYERprU9vjVZ
         mSR0eTkDJ+sAz01bQpXokUqnpro7keGxWCCx0dm+leaI+/qWOzOtVUkDuGmOzbdJke2Z
         DxH33yKh4+5kMnhk+oJf5AXXNuHPFRrz+GTbiN8tOh0xxFlaWXJEgj4v3I1GsXbaskWt
         /ypA==
X-Forwarded-Encrypted: i=1; AJvYcCV/PS5zfiZYZRSP3BBOM78LP8VyTFWiMMPBf2pRto0D/4X4HF5u3cqtG5iJrWfISsY2IceBZmsY1w8mQMxXrddu7RGi
X-Gm-Message-State: AOJu0YwLkv/ZZsb7EAB+vNjhyxlJ5ds5YYSqwA18wW+qVZr/meiJg7U4
	Q1m/NKazsDR41qm6GX9Qus16930YmcZIxXEof+jkTHBCtSGOctkAmpsvk274AjI=
X-Google-Smtp-Source: AGHT+IEJsKSb7GMBEJwKRJb18oE3FCx/YFCHoyOQ+/rTrCh0U70ekG6XQEIGyKSA9piI909Jdbh/YA==
X-Received: by 2002:a17:903:32c8:b0:201:f44d:6f00 with SMTP id d9443c01a7336-20203f51592mr4328345ad.57.1723741755569;
        Thu, 15 Aug 2024 10:09:15 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.130.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03022d9sm12369535ad.25.2024.08.15.10.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 10:09:14 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Don't zero-out PMU snapshot area before freeing data
Date: Thu, 15 Aug 2024 22:39:07 +0530
Message-Id: <20240815170907.2792229-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the latest Linux-6.11-rc3, the below NULL pointer crash is observed
when SBI PMU snapshot is enabled for the guest and the guest is forcefully
powered-off.

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000508
  Oops [#1]
  Modules linked in: kvm
  CPU: 0 UID: 0 PID: 61 Comm: term-poll Not tainted 6.11.0-rc3-00018-g44d7178dd77a #3
  Hardware name: riscv-virtio,qemu (DT)
  epc : __kvm_write_guest_page+0x94/0xa6 [kvm]
   ra : __kvm_write_guest_page+0x54/0xa6 [kvm]
  epc : ffffffff01590e98 ra : ffffffff01590e58 sp : ffff8f80001f39b0
   gp : ffffffff81512a60 tp : ffffaf80024872c0 t0 : ffffaf800247e000
   t1 : 00000000000007e0 t2 : 0000000000000000 s0 : ffff8f80001f39f0
   s1 : 00007fff89ac4000 a0 : ffffffff015dd7e8 a1 : 0000000000000086
   a2 : 0000000000000000 a3 : ffffaf8000000000 a4 : ffffaf80024882c0
   a5 : 0000000000000000 a6 : ffffaf800328d780 a7 : 00000000000001cc
   s2 : ffffaf800197bd00 s3 : 00000000000828c4 s4 : ffffaf800248c000
   s5 : ffffaf800247d000 s6 : 0000000000001000 s7 : 0000000000001000
   s8 : 0000000000000000 s9 : 00007fff861fd500 s10: 0000000000000001
   s11: 0000000000800000 t3 : 00000000000004d3 t4 : 00000000000004d3
   t5 : ffffffff814126e0 t6 : ffffffff81412700
  status: 0000000200000120 badaddr: 0000000000000508 cause: 000000000000000d
  [<ffffffff01590e98>] __kvm_write_guest_page+0x94/0xa6 [kvm]
  [<ffffffff015943a6>] kvm_vcpu_write_guest+0x56/0x90 [kvm]
  [<ffffffff015a175c>] kvm_pmu_clear_snapshot_area+0x42/0x7e [kvm]
  [<ffffffff015a1972>] kvm_riscv_vcpu_pmu_deinit.part.0+0xe0/0x14e [kvm]
  [<ffffffff015a2ad0>] kvm_riscv_vcpu_pmu_deinit+0x1a/0x24 [kvm]
  [<ffffffff0159b344>] kvm_arch_vcpu_destroy+0x28/0x4c [kvm]
  [<ffffffff0158e420>] kvm_destroy_vcpus+0x5a/0xda [kvm]
  [<ffffffff0159930c>] kvm_arch_destroy_vm+0x14/0x28 [kvm]
  [<ffffffff01593260>] kvm_destroy_vm+0x168/0x2a0 [kvm]
  [<ffffffff015933d4>] kvm_put_kvm+0x3c/0x58 [kvm]
  [<ffffffff01593412>] kvm_vm_release+0x22/0x2e [kvm]

Clearly, the kvm_vcpu_write_guest() function is crashing because it is
being called from kvm_pmu_clear_snapshot_area() upon guest tear down.

To address the above issue, simplify the kvm_pmu_clear_snapshot_area() to
not zero-out PMU snapshot area from kvm_pmu_clear_snapshot_area() because
the guest is anyway being tore down.

The kvm_pmu_clear_snapshot_area() is also called when guest changes
PMU snapshot area of a VCPU but even in this case the previous PMU
snaphsot area must not be zeroed-out because the guest might have
reclaimed the pervious PMU snapshot area for some other purpose.

Fixes: c2f41ddbcdd7 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index bcf41d6e0df0..2707a51b082c 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -391,19 +391,9 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
-	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
 
-	if (kvpmu->sdata) {
-		if (kvpmu->snapshot_addr != INVALID_GPA) {
-			memset(kvpmu->sdata, 0, snapshot_area_size);
-			kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
-					     kvpmu->sdata, snapshot_area_size);
-		} else {
-			pr_warn("snapshot address invalid\n");
-		}
-		kfree(kvpmu->sdata);
-		kvpmu->sdata = NULL;
-	}
+	kfree(kvpmu->sdata);
+	kvpmu->sdata = NULL;
 	kvpmu->snapshot_addr = INVALID_GPA;
 }
 
-- 
2.34.1


