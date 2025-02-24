Return-Path: <kvm+bounces-38981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DD5A418AE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 10:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF835188D14A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F50724BBFA;
	Mon, 24 Feb 2025 09:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpzZXn8L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD86243364
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388218; cv=none; b=ggAAoJ7nAgaWUNAeR7OOrf4StR7nTI0e86qQPrrRK6YQXbVhdB4jaw84vI/Vfn77EmMyRzrLB0FJYtZvQzyhlyOPwjI+0B2W3y+G3bB/CazQXOUVSCblbr0Mhtfq0DRakKd7OAOhIJaO0zfb3b7ce+sfB3L4ImnTSAsQ5rSaKMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388218; c=relaxed/simple;
	bh=25WXkM/8rWEaoR8LFVp2KbNEahjJte6M9YZgoly96/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZKlJ2i6m0zuJpxqvy54LIsV2TeEV0skY1ef9zmOjE5QkprsYanWwcr2DG9rbSLDNnASA64/3vZwXlfbELibyn7zh/vOyQWRGeJSMse7Rfc1DbS3CYGj5NZ6oiH+Rw68JdCE1VF6wGt9RHEnoMBnRFyWH+OTyWy9VBO/2+a2WOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpzZXn8L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26196C4CED6;
	Mon, 24 Feb 2025 09:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740388218;
	bh=25WXkM/8rWEaoR8LFVp2KbNEahjJte6M9YZgoly96/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpzZXn8L1aQBqOsvb+yp/83lYCIJyb70RwcmdBiwXcxpdAg52ilg5B7wSCx8SEoZb
	 qLqxnFHjdNqS+yz2YD0r4EoNboQCFNK4SpMumjVmpQzli70bmSz8/prZV6Duebd4or
	 O3R3cClzegFyUcE9e6MEGS/PYRhHMJQ0QVjAQ8EgynerK4ambFJ+OP63pQFuRWPvyV
	 UbVk5I9YxrWA9HXB2hu+Fnzw9+ZwCa29OJZ0ZymsDz4tmr7ZtMBdVLwMr75TL2jbhM
	 93JM0+3UmG8OHrGn7eM+TFk8CVGcNTYHuJYhS3KfVY0Yo3Yoxgq2/SA88IyVy+sxVg
	 4LqgCzIwgTBWg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH kvmtool v2 2/2] cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT in KVM_RUN ioctl return
Date: Mon, 24 Feb 2025 14:40:00 +0530
Message-ID: <20250224091000.3925918-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
References: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
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

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kvm-cpu.c | 15 +++++++++++++--
 kvm.c     |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7c62bfc56679..c0b10b1534ab 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -41,8 +41,19 @@ void kvm_cpu__run(struct kvm_cpu *vcpu)
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
+			/* faullthrough */
+		default:
+			die_perror("KVM_RUN failed");
+		}
+	}
 }
 
 static void kvm_cpu_signal_handler(int signum)
diff --git a/kvm.c b/kvm.c
index 42b881217df6..172d951bfe4e 100644
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


