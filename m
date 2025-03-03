Return-Path: <kvm+bounces-39896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7C5A4C765
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1008E1887DE7
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 16:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D4A2397B9;
	Mon,  3 Mar 2025 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMxruLLA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4EC238D3A;
	Mon,  3 Mar 2025 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741019429; cv=none; b=D8kjkv0iYvWRB7+hx/0l8zMGfWpK0xhRTGD3soYNjqN6qDpkFxW2sYrxBquiliAF6DAO14ll/STIs0HDEuOwd98ByCwbkj/+w9x889VoLm4anUN5KsDD+2p9/6K2RChX/gHgxFNN7hyXEpObl5rQvMzrlf6AlX4FKCae1YDKEjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741019429; c=relaxed/simple;
	bh=VO4PNxXKaKhQhc8WyvjllaRN4o+RXV2Z6WojniXYwY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HFMI9NtFAOuGYCckRrrUkZatuvhGOcW5GELSTtHaEhdZzVNQjnUr4detUpCKHyVRSLZSq86kje8PxoXQauP3bMZ+NsolZYUnHr1vMdATAzpJCrD7i5u+P9rYsQ7bLPoaITSwbSfSNxx0ZqPBY6JVu4kbos4sOCRAv1yuD4Gu73c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMxruLLA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FD8C4CEE6;
	Mon,  3 Mar 2025 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741019429;
	bh=VO4PNxXKaKhQhc8WyvjllaRN4o+RXV2Z6WojniXYwY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMxruLLAzDKnwWuDlNzB5pcWPrmqSqhUBWFIKEDrnrtzMa2CpB7QstjVzp7jckw8I
	 /tbIrLRYFeX1JtjGfh+OCDTmrhrYsn/ZV3Wvlkt7iDxHl2iKIRQrmfDTf69MbysbQS
	 ZL619hGx/QjHPIRgBGerct529D39hPNILU/mUW+Siw7GHhs9YAwuH0KCXGMif51BRm
	 nR8V4/BmVrPVbSlUGqwmH5ULf9BRiYV/qWN/noDe0ZtUibrm8/rSKN/A+z8kGqzBwF
	 rc48C6H35xdOKpf17+wo/hCB0R5jsUU+xLKaR8yzS7HCd8CdMYKg+F4DWovaL/wx3U
	 UYH4eYWDO3+jg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	seanjc@google.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.13 17/17] vhost: return task creation error instead of NULL
Date: Mon,  3 Mar 2025 11:29:49 -0500
Message-Id: <20250303162951.3763346-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250303162951.3763346-1-sashal@kernel.org>
References: <20250303162951.3763346-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.5
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit cb380909ae3b1ebf14d6a455a4f92d7916d790cb ]

Lets callers distinguish why the vhost task creation failed. No one
currently cares why it failed, so no real runtime change from this
patch, but that will not be the case for long.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Message-ID: <20250227230631.303431-2-kbusch@meta.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 drivers/vhost/vhost.c  | 2 +-
 kernel/vhost_task.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e102505735a7b..0e6bf24093f75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7435,7 +7435,7 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
 				      kvm_nx_huge_page_recovery_worker_kill,
 				      kvm, "kvm-nx-lpage-recovery");
 
-	if (!nx_thread)
+	if (IS_ERR(nx_thread))
 		return;
 
 	vhost_task_start(nx_thread);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ac25d08f473e..63612faeab727 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -666,7 +666,7 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 
 	vtsk = vhost_task_create(vhost_run_work_list, vhost_worker_killed,
 				 worker, name);
-	if (!vtsk)
+	if (IS_ERR(vtsk))
 		goto free_worker;
 
 	mutex_init(&worker->mutex);
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 8800f5acc0071..2ef2e1b800916 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -133,7 +133,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 
 	vtsk = kzalloc(sizeof(*vtsk), GFP_KERNEL);
 	if (!vtsk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	init_completion(&vtsk->exited);
 	mutex_init(&vtsk->exit_mutex);
 	vtsk->data = arg;
@@ -145,7 +145,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 	tsk = copy_process(NULL, 0, NUMA_NO_NODE, &args);
 	if (IS_ERR(tsk)) {
 		kfree(vtsk);
-		return NULL;
+		return ERR_PTR(PTR_ERR(tsk));
 	}
 
 	vtsk->task = tsk;
-- 
2.39.5


