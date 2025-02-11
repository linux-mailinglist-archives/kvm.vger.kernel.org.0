Return-Path: <kvm+bounces-37820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 374ACA304AA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAA8E188A268
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7BA1EE001;
	Tue, 11 Feb 2025 07:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+LlErX5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997FB1E3DF7
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739259561; cv=none; b=tUHtVWNs+rtrF0PpBfwx/R8Rt1bG2tW6CTSH8/IEhwSDVIcbXvDqx1ftVLB55Svlwl4MHeqMUbUJP9l+nFLVsbDq798AAIxTwQ2qrsOIFDxPBPoQxGIkvuN048ENYkEHntzeToiCNCF7roDyJxU58FTpZXd+dU0dMjfZt3etbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739259561; c=relaxed/simple;
	bh=plMMkduv0ZvGwS/5ylyV0jdc4BYwhmtmmWjE218aJlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0kEYsF9hNIz0AAkHPpD/jnST69S37jMrAXAMsShSIX310ZJ3o+HHH7tJxs2sWsp/rj/gcuMA+yp4nuRA6CPfk4v7zILvTR6UF4K27QTaYNzlyG1s3MaZwRtxiVjnqL6QXtGxKr4Z84JGTH+JOPIPqfEZ3XdHgs30j0ZXStrCD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r+LlErX5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AEFC4CEE6;
	Tue, 11 Feb 2025 07:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739259561;
	bh=plMMkduv0ZvGwS/5ylyV0jdc4BYwhmtmmWjE218aJlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+LlErX5VIR+dAzpYT8Exj8Jjrf8Tjf0G7md9P+zpjDMfYMdjduOzt38H6sopvC2E
	 sRGmURwdYlEvG1gUgjwEcf2ZbszIyBdynb0nKXryvOQgYtLJDF24xz/+x8QGUpm0Ik
	 6u0ilqdDzM3rqG1MvDjgJVqvWgoCu6fdEw2Wp21OobDa4GKj4JZMi42blGrbhft8KM
	 OYuMc0jEKctqkx5Xjt5ADLkKMKJsPxHZ0b1N5jVDqQqymdLng3GfQOAFx5t8dZvvtO
	 WnTjmElteOe2I7y6ZkBmevJeljgUiNrfhccfmgJTBZjnn5/yDZPsXN6QnVaKiRHxI2
	 fnBi0aa7LfL6w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH kvmtool 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT correctly
Date: Tue, 11 Feb 2025 13:08:52 +0530
Message-ID: <20250211073852.571625-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250211073852.571625-1-aneesh.kumar@kernel.org>
References: <20250211073852.571625-1-aneesh.kumar@kernel.org>
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

Update the KVM_RUN ioctl error handling to correctly handle
KVM_EXIT_MEMORY_FAULT.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kvm-cpu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 66e30ba54e26..40e4efc33a1d 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -41,8 +41,15 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
 		return;
 
 	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
-	if (err < 0 && (errno != EINTR && errno != EAGAIN))
-		die_perror("KVM_RUN failed");
+	if (err < 0) {
+		if (errno == EINTR || errno == EAGAIN)
+			return;
+		else if (errno == EFAULT &&
+			 vcpu->kvm_run->exit_reason == KVM_EXIT_MEMORY_FAULT)
+			return;
+		else
+			die_perror("KVM_RUN failed");
+	}
 }
 
 static void kvm_cpu_signal_handler(int signum)
-- 
2.43.0


