Return-Path: <kvm+bounces-37819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C13B1A304A9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 858593A5A6E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF221EDA18;
	Tue, 11 Feb 2025 07:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0fN9WZv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E3A1E3DF7
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 07:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739259559; cv=none; b=i+6y2FleTUJJlL25kq8csbiaNeCA/eAaln+NgfzkU1MqYKpEVh6zT3o9gk0za+9E8TIz9DqXpDZBqnbYhobR0PngnAGKf+LcRdNTkQY7Bot0SvrfV4p8hN6347J3NAS5J45JZL9I2p/mn68yl9StjBDzspRKmfA5W3+OkVzouFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739259559; c=relaxed/simple;
	bh=gR66WKwXquY3P4hJ2/qAS/d9cRt+fUhpHJrGfvKW5Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mwwXQBIBGlKnDDmUEh9H2KOHaf9mXh9tLlSR4KOqZ13D+PHsGrTeIhkOhi+Hy3L5ABJ1+Yz91HH+AtM/sz/wya0pyXB/tOWvjIgLAiwk+SJ2aHBbUCS4P/p42gRmQbMPLJfE2SvN8+kvoia56x8/Qs14UUXhWbUEigXWMnFxwXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0fN9WZv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9533C4CEDD;
	Tue, 11 Feb 2025 07:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739259558;
	bh=gR66WKwXquY3P4hJ2/qAS/d9cRt+fUhpHJrGfvKW5Hk=;
	h=From:To:Cc:Subject:Date:From;
	b=R0fN9WZvmkCcDKIqMS8OS6CItxZV8UB/OZohx5OtiRr5n0lqtFmF022D+zixIgQBY
	 A1NSH6TbulfC8GTFqUpF2Pi0N8TStfZW3EdVy339ONQDVSObnmxPdACd+8q5gbjzq/
	 WsJbJZvtEqp5fY+REKNMoSoTsEBvpyz1Fo5EgbqD5wZQgA6c/O/N3xfuBuHe+tEOL/
	 vXd0UHDUZr2SWsm7NeIHDon4PHNGMLb43cH8IyhwpcV0448Zjvt/JRyoLyoDiNfGsv
	 IbNtoCF+XAVcO+G/MePKPrqC9ngUADIiQt9iYM8AcItmOSMf5UPYOdNlE9a9ErjsGD
	 9rJiVskRkE5oA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH kvmtool 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit reason correctly
Date: Tue, 11 Feb 2025 13:08:51 +0530
Message-ID: <20250211073852.571625-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value for the KVM_RUN ioctl is confusing and has led to
errors in different kernel exit handlers. A return value of 0 indicates
a return to the VMM, whereas a return value of 1 indicates resuming
execution in the guest. Some handlers mistakenly return 0 to force a
return to the guest.

This worked in kvmtool because the exit_reason defaulted to
0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
reason. However, forcing a KVM panic on an unknown exit reason would
help catch these bugs early.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kvm-cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index f66dcd07220c..66e30ba54e26 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -170,6 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 
 		switch (cpu->kvm_run->exit_reason) {
 		case KVM_EXIT_UNKNOWN:
+			goto panic_kvm;
 			break;
 		case KVM_EXIT_DEBUG:
 			kvm_cpu__show_registers(cpu);

base-commit: 6d754d01fe2cb366f3b636d8a530f46ccf3b10d8
-- 
2.43.0


