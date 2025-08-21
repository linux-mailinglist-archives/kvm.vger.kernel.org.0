Return-Path: <kvm+bounces-55316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C530B2FD05
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E7961CC61C4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B472D543E;
	Thu, 21 Aug 2025 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqBcBWXi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993D2279791;
	Thu, 21 Aug 2025 14:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786363; cv=none; b=IHR+yEWoS7Vc4bANomUFZ7UZfkB2zhBwsALmkj7jE3/D6lvh0/tE4G7ePSrNWCSk3Cm9JOfhtuPlFrIlKulFoK44aXhaSFMGA3mmeI/VNgZNNpIj1PJ/nQI9pwe32cbAw07y3XricniFMC5+wDP6+0dB1+1UmzG/+WWRyGSFidU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786363; c=relaxed/simple;
	bh=vf5Fi2dD1hhyyDWhuRPa6MLAXnOLAHxSyHEh1kLOyk8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vowouz86gWSs/2FmP1FK3bwy4IYYFa0cJ5dr6OQuX7SXgXayrrUOBWs1og1g0s54y/oE8oCQaVAwv860uBxk3+Z/GtrmfG6ekSeFoHW1s4qa8UuMGUqDhf8Dk0h3ahPjTLMwTZD/J9keNZKdB3RopMByVCXXbaO0Qwk3CuSscxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqBcBWXi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F3AC4CEEB;
	Thu, 21 Aug 2025 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755786363;
	bh=vf5Fi2dD1hhyyDWhuRPa6MLAXnOLAHxSyHEh1kLOyk8=;
	h=From:To:Cc:Subject:Date:From;
	b=jqBcBWXif+fIThL2sAHLO6P+dezcJUD6B52uyjHEhlGr4G2F3sudhSN7uIWye1M4F
	 mrwuL1Yyarc1DGE5SuyKM0Pq2xOfSzMT1BbQZL9OWHjwlrJvTRSMGe65mxyaCn7zck
	 ICYuQ7jaay+7UeUdQiSrERxZH50CFVgAh83mhcgZRsev0oUaYncD4XqaQwOUYYivMl
	 P5FxSILMXi8HpKYDy6z/JdrUzYAd2UaufXHKE4ULD1M3OjrK9PnwTf/cnsL/R28Y7d
	 OUppzyuTbuuURCsHkqxKvxmSfdaUFU9Y5mM4tQThNIm6d8eQKB8bHje65F5YU5I7kB
	 mNNuFXp94m/sA==
From: guoren@kernel.org
To: guoren@kernel.org,
	troy.mitchell@linux.dev
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com
Subject: [PATCH V4 RESEND 0/3] Fixup & optimize hgatp mode & vmid detect functions
Date: Thu, 21 Aug 2025 10:25:39 -0400
Message-Id: <20250821142542.2472079-1-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

Here are serval fixup & optmizitions for hgatp detect according
to the RISC-V Privileged Architecture Spec.

---
Changes in v4:
 - Involve ("RISC-V: KVM: Prevent HGATP_MODE_BARE passed"), which
   explain why gstage_mode_detect needs reset HGATP to zero.
 - RESEND for wrong mailing thread.
 
Changes in v3:
 - Add "Fixes" tag.
 - Involve("RISC-V: KVM: Remove unnecessary HGATP csr_read"), which
   depends on patch 1.

Changes in v2:
 - Fixed build error since kvm_riscv_gstage_mode() has been modified.
---

Fangyu Yu (1):
  RISC-V: KVM: Write hgatp register with valid mode bits

Guo Ren (Alibaba DAMO Academy) (2):
  RISC-V: KVM: Remove unnecessary HGATP csr_read
  RISC-V: KVM: Prevent HGATP_MODE_BARE passed

 arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
 arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
 arch/riscv/kvm/vmid.c   |  8 +++-----
 3 files changed, 44 insertions(+), 26 deletions(-)

-- 
2.40.1


