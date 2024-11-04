Return-Path: <kvm+bounces-30565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 518419BBDD8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 20:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83CD51C23555
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 19:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20F2192D7D;
	Mon,  4 Nov 2024 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UckN6poH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE8DAD2D;
	Mon,  4 Nov 2024 19:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730747719; cv=none; b=AjwTo7zVQwXYyIfziXODm4yeXAccVejMNLV2RIWqQ2BcXcCItQ7oVyYMAHa5vgbuuYNQGMx5ULdlCtHOz3/H4Catpkxq8qKBkcs5WYc+jIrwLfktXqbbZH2HMnwl0Ka5C+RFpPnC7ToHN9OPRk8e0VkF9adBzcPkZyL8JWAQsvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730747719; c=relaxed/simple;
	bh=ynCoOheYITSrvR0l1B39csTWu2Mu+AVasOWlOaMf7pE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fUEKx49SWSHf9US5wFmQ+wF2+kBox9qAvqAOhnlDgDM4mdZ0r2Fmc5VFISJFSDepdiARh2xxoi3odB/YfBQXB9dBirRmUq2T7aO/1nefXHpPtQgw33D2kAk+nVxWHxd+BnMyKZG3X4z7eCy50OmiBh32yesfWir1p0CFREXaOzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UckN6poH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A51EC4CECE;
	Mon,  4 Nov 2024 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730747718;
	bh=ynCoOheYITSrvR0l1B39csTWu2Mu+AVasOWlOaMf7pE=;
	h=From:To:Cc:Subject:Date:From;
	b=UckN6poH2bAbu2sww/PQHNDSlbChui8JoY02ti74E41RmREqtVFhEk9KW8sjW2uVB
	 gaq0mUMB6NbOeFFIfkomR3RwnCxSkrhgLetGEO2sGj+xLFA3ncO4YFCsCaNCGTZU1T
	 +Z0gS78hM3T0Njfvo9eDqJFrFso7XI7hOAsaiF3J440t7eEz+4CODWT2a75ZKLF7j5
	 EhluggIvLloouuuOp0kp/DBGjLTZ6OMrC/tU+pFChydMkzsQb5G1mzn4irrSbvbdpn
	 uRRGSvuK+xE+rJV9QKt53Yi+C5AGyMpJkH7So48HlGjLwaSnzals1PSBottuj8cc0g
	 KZJw9kQ21AYTA==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] riscv: kvm: Fix out-of-bounds array access
Date: Mon,  4 Nov 2024 20:15:01 +0100
Message-ID: <20241104191503.74725-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Björn Töpel <bjorn@rivosinc.com>

In kvm_riscv_vcpu_sbi_init() the entry->ext_idx can contain an
out-of-bound index. This is used as a special marker for the base
extensions, that cannot be disabled. However, when traversing the
extensions, that special marker is not checked prior indexing the
array.

Add an out-of-bounds check to the function.

Fixes: 56d8a385b605 ("RISC-V: KVM: Allow some SBI extensions to be disabled by default")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
Don't know if it matters, but I hit this when trying kvmtool.


Björn
---
arch/riscv/kvm/vcpu_sbi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 7de128be8db9..6e704ed86a83 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -486,19 +486,22 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
 	const struct kvm_riscv_sbi_extension_entry *entry;
 	const struct kvm_vcpu_sbi_extension *ext;
-	int i;
+	int idx, i;
 
 	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
 		entry = &sbi_ext[i];
 		ext = entry->ext_ptr;
+		idx = entry->ext_idx;
+
+		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
+			continue;
 
 		if (ext->probe && !ext->probe(vcpu)) {
-			scontext->ext_status[entry->ext_idx] =
-				KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
+			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
 			continue;
 		}
 
-		scontext->ext_status[entry->ext_idx] = ext->default_disabled ?
+		scontext->ext_status[idx] = ext->default_disabled ?
 					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
 					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
 	}

base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.43.0


