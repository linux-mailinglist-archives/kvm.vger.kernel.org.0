Return-Path: <kvm+bounces-52270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B07B037CA
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADE44189AA79
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 07:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623CD233D88;
	Mon, 14 Jul 2025 07:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="TQbptem9"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-37.ptr.blmpb.com (sg-1-37.ptr.blmpb.com [118.26.132.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4453423183B
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 07:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752477716; cv=none; b=XkM2ZPDvzQl+PaAXuzXlAHi/MEcPHnZ4oXaM+Zqks2jNqRunluVtp8aUeR56JghA6FdBxx7UKZlNEH5iD3TM3SBwUJJ5Q1mgsnX6fA2Hnp2hr3pKdrddHsHzfgLPGMOFIhnC82nKLqucJsImG1Nuq7dGlP5iZEl8oK7FxDFPszw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752477716; c=relaxed/simple;
	bh=8TKl3yLRC0POZJ/KtJYzRQk9Py3Nfj2pZnvc4CgRKj4=;
	h=Date:Message-Id:Subject:From:Mime-Version:To:Cc:Content-Type; b=mNpzR5kSnix5361FPOHw6IfJWDQWVCDaFEq1G8LaxM4HYbqdl/UJGrXENb1qrQ1hZutX+3HLQh15IHgJF6i3In1XyPl4HFTNJw92YdQfckJCZ/j+B788YsHQIcpBzeoMFPzezYj9o8UCSYtCN29eUhebGefEqLH5mv0CNkyCdj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=TQbptem9; arc=none smtp.client-ip=118.26.132.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1752477700;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=y271lZtuVJ/3OzGRBrxJUOZ72ijQbIdeHDFq98NdTcY=;
 b=TQbptem9p1NN+oU0ah1gVy0ynUC8I0w5xnA5fSTTHOMh18supbPsVMvc2VReRvlae278A1
 /I44kffO9A2y/1I7KNLhARnDXmS9OzCWkiq8LaoN4b/jUnJ4agIWdC0UMpUbhOxpqiuaVj
 KFMTIh+FqUA9gZJr8Fjb3HnjCu+WLKsLxe7+4oYIu5IMY79KwIW2TuDqPLgjS4Img2umPG
 gWK2YiyzFs62UoXAEduLwvux5rajcZkqNspwNxCvnPGW6Pg3/hgVHHqdaGCzsSXZrr/7gP
 vQiQxtRe8LcPkVTVIX4N+cULZ3uM6OzN3VJhVh3oZlgqD/Arpoqk0j3p6CyBdw==
Content-Transfer-Encoding: quoted-printable
X-Original-From: BillXiang <xiangwencheng@lanxincomputing.com>
Date: Mon, 14 Jul 2025 15:20:50 +0800
Message-Id: <20250714072051.1928-1-xiangwencheng@lanxincomputing.com>
Subject: [PATCH] RISC-V: KVM: Introduce KVM_EXIT_FAIL_ENTRY_NO_VSFILE
From: "BillXiang" <xiangwencheng@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26874b002+0cdc43+vger.kernel.org+xiangwencheng@lanxincomputing.com>
Received: from localhost.localdomain ([222.128.9.250]) by smtp.feishu.cn with ESMTP; Mon, 14 Jul 2025 15:21:37 +0800
To: <anup@brainfault.org>
Cc: <atish.patra@linux.dev>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>, 
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>, 
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, 
	<xiangwencheng@lanxincomputing.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.46.2.windows.1

Consider a system with 8 harts, where each hart supports 5
Guest Interrupt Files (GIFs), yielding 40 total GIFs.
If we launch a QEMU guest with over 5 vCPUs using
"-M virt,aia=3D'aplic-imsic' -accel kvm,riscv-aia=3Dhwaccel" =E2=80=93 whic=
h
relies solely on VS-files (not SW-files) for higher performance =E2=80=93 t=
he
guest requires more than 5 GIFs. However, the current Linux scheduler
lacks GIF awareness, potentially scheduling >5 vCPUs to a single hart.
This triggers VS-file allocation failure, and since no handler exists
for this error, the QEMU guest becomes corrupted.

To address this, we introduce KVM_EXIT_FAIL_ENTRY_NO_VSFILE upon
VS-file allocation failure. This provides an opportunity for graceful
error handling instead of corruption. For example, QEMU can handle
this exit by rescheduling vCPUs to alternative harts when VS-file
allocation fails on the current hart [1].

[1] https://github.com/BillXiang/qemu/tree/riscv-vsfile-alloc/

Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 2 ++
 arch/riscv/kvm/aia_imsic.c        | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
index 5f59fd226cc5..be29c3502fe4 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -22,6 +22,8 @@
 #define KVM_INTERRUPT_SET	-1U
 #define KVM_INTERRUPT_UNSET	-2U
=20
+#define KVM_EXIT_FAIL_ENTRY_NO_VSFILE	(1ULL << 0)
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 };
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 29ef9c2133a9..69b0ab651389 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -760,7 +760,7 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vc=
pu)
 		/* For HW acceleration mode, we can't continue */
 		if (kvm->arch.aia.mode =3D=3D KVM_DEV_RISCV_AIA_MODE_HWACCEL) {
 			run->fail_entry.hardware_entry_failure_reason =3D
-								CSR_HSTATUS;
+								KVM_EXIT_FAIL_ENTRY_NO_VSFILE;
 			run->fail_entry.cpu =3D vcpu->cpu;
 			run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
 			return 0;
--=20
2.46.2.windows.1

