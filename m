Return-Path: <kvm+bounces-44565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B49CA9F021
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD6BC5A119B
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 12:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1083C2673A2;
	Mon, 28 Apr 2025 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9u52b4X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D94726C3AE
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 11:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841477; cv=none; b=B6sbKKOQ5KGsJD1jg3iqrH7zyNid1NA12q2wRbhJx4MrrqnQAD17eZVWCCjp1wsR8jQDgDX77fcFByD2DKfA9/39d9/zGdNh+/WCnJL+2n1zXlLyZZOrroiRJD2+JTfK1EWknGo5RYD1b7s42STr1eEzOHTIhsyq22F7085M6VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841477; c=relaxed/simple;
	bh=RfZin90kUqqU1HpghidM+AHb1+8BQ8idqiaMyyS/Tw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGULJPzX4JW1Y/R/Td3rgZCBOlIdcNhGZORfwTfgWaRDXGy/cQD8CurynoghGaSIs1xjsRLgIzrowCo0e2hz7iw64GlbrTkeUzIGs8yoSjhwt84XXv4wS2VoSJ+tZUva8xBTn/WHRtDVYdao8LtkFGCs9OQ2++x7XMpJPyOwXDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9u52b4X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E4C4CEED;
	Mon, 28 Apr 2025 11:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745841477;
	bh=RfZin90kUqqU1HpghidM+AHb1+8BQ8idqiaMyyS/Tw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9u52b4XBa0H/OGbViMHHh5sNGukBr86AyFltRP7Z0ZDz3g+u5ElFQ6SE3CZ5WNP9
	 NuDfbmDQrIJpUiccEOYiaQ98dLB78CRkK7Tz4XsNXeuM/+4zy1u1JAxefNvct3bc3Z
	 yVSEnuv30SGJZ8SMeEwSz6SF0QxPbbVVhngB87yaoGM1cNQ0ikLLWSu//dWIwgUSOB
	 C6ELTz/U4BynmqMqtrc/3DvzKsSGtoSiSvTn9OUU/6Ckw0eBgrY8MiATCVpq41dbz2
	 ux+igCPQBlH8FaN6lEOLClSRu2xJ8DNxpdrG7SrIpoPCf2esCQZANh6DI+pOw8ydRB
	 rL9uB3vabMksw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v3 1/3] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT in KVM_RUN ioctl return
Date: Mon, 28 Apr 2025 17:27:43 +0530
Message-ID: <20250428115745.70832-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428115745.70832-1-aneesh.kumar@kernel.org>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux kernel documentation states:

"Note! KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in
that it accompanies a return code of '-1', not '0'! errno will always be
set to EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT,
userspace should assume kvm_run.exit_reason is stale/undefined for all
other error numbers." "

Update KVM_RUN ioctl error handling to correctly handle
KVM_EXIT_MEMORY_FAULT. This enables the memory fault exit handlers in
the kernel to return -EFAULT as the return value. VMM support is
still required to handle these memory fault exits, but that is not
included in this change

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kvm-cpu.c | 15 +++++++++++++--
 kvm.c     |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7362f2e99261..40041a22b3fe 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -43,8 +43,19 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
 		return;
 
 	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
-	if (err < 0 && (errno != EINTR && errno != EAGAIN))
-		die_perror("KVM_RUN failed");
+	if (err < 0) {
+		switch (errno) {
+		case EINTR:
+		case EAGAIN:
+			return;
+		case EFAULT:
+			if (vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
+				return;
+			/* fallthrough */
+		default:
+			die_perror("KVM_RUN failed");
+		}
+	}
 }
 
 static void kvm_cpu_signal_handler(int signum)
diff --git a/kvm.c b/kvm.c
index 07089cf1b332..b6375a114d11 100644
--- a/kvm.c
+++ b/kvm.c
@@ -55,6 +55,7 @@ const char *kvm_exit_reasons[] = {
 #ifdef CONFIG_PPC64
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_PAPR_HCALL),
 #endif
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_MEMORY_FAULT),
 };
 
 static int pause_event;
-- 
2.43.0


