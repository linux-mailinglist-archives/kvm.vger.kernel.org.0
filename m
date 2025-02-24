Return-Path: <kvm+bounces-38980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB19A418AC
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 10:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5604163012
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F2E24BBEE;
	Mon, 24 Feb 2025 09:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD9/klwW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803D924BBE4
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388214; cv=none; b=qaQOibX7C5NVo6oG3tTAU/ykAaiw4PMXIkRQ5umdaNjiJjZDvGrrOkK4uId/dPu1+g7RELPCT9mlDhrfR2JrUkUZDQqRHg6ij+B9j/RJmV0gekdwQv2+4VisUNSheb1RFHRUE/QMlowQQUtmy9FDSbJ36+y8Esn2gCmGESoEWTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388214; c=relaxed/simple;
	bh=d89GjCOAb8v1g8rv/GObFnQoi4giK3ojT0tAF8KaSkM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gy14Cndi5MV6iFTHV0OuZ7eWQp9nq2sHlKxO2smOi20sekWzGp5xKI9QIh05XoL3ctOO39uTKpcGcfk73VM2bLa5gaFrztiQdFsftbx5mvs5LeStk/EBe4WED4k0KQj4s2On1IQMqrDhYX91zoNZgUoggr2dqa+mbmye3+wrex4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD9/klwW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2CDC4CEDD;
	Mon, 24 Feb 2025 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740388214;
	bh=d89GjCOAb8v1g8rv/GObFnQoi4giK3ojT0tAF8KaSkM=;
	h=From:To:Cc:Subject:Date:From;
	b=GD9/klwWJcjF7oPGb8bOec5XsGUAPU5bFsNXX1X/rRGqJZveSgIe6r6vLdbIbXfu8
	 N1hXaXmopqi7EhUw8T7NodmBcltwxkGJFzgNIb72rV67edLEyJY49zYf0anp0huEEh
	 XVJji0CSx/nOdjGRDi6q/iCL5xk6AwYGHqWhFUdiA/JF+1y1i//U/35FAqjLEsA/B3
	 GujlEOHLA3ys8RVDqVRTobigzuBCHGJ/APbonXmoHP0TWy3U1ywsXqJP+lhwqS25Ml
	 vE3b7Jqz6LnoWMHad1zBJrhPypEzFRWwWV2PTfsjkD0X9I66T11A2YvroOyMKi2i1y
	 dSnbgecDp3V9w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH kvmtool v2 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit reason correctly
Date: Mon, 24 Feb 2025 14:39:59 +0530
Message-ID: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value for kernel VM exit handlers is confusing and has led to
errors in different kernel exit handlers. A return value of 0 indicates
a return to the VMM, whereas a return value of 1 indicates resuming
execution in the guest. Some handlers mistakenly return 0 to force a
return to the guest.

This worked in kvmtool because the exit_reason defaulted to
0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
reason. However, forcing a VMM exit with error on KVM_EXIT_UNKNOWN
exit_reson would help catch these bugs early.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kvm-cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index f66dcd07220c..7c62bfc56679 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -170,7 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 
 		switch (cpu->kvm_run->exit_reason) {
 		case KVM_EXIT_UNKNOWN:
-			break;
+			goto panic_kvm;
 		case KVM_EXIT_DEBUG:
 			kvm_cpu__show_registers(cpu);
 			kvm_cpu__show_code(cpu);
-- 
2.43.0


