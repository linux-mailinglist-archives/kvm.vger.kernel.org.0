Return-Path: <kvm+bounces-17439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E438C6947
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91E12284AF3
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB2B155756;
	Wed, 15 May 2024 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEkraM2V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5A215573D;
	Wed, 15 May 2024 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785689; cv=none; b=qCFLfsdsuCDFwazeDoKUVrM70NhKEXpRyWYLgMRpgwRjy14h0pDvAG0PSMkWW1otXSvwz1V5tW9LcwpLWL2fipjhlwvMJEIo0NFcrMM1hRZjx7TK+iP8Csj/RYzaaqW4D1oHeaDuatXhj/twL4wpQGvAMkatIgs0g7Td1McmJzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785689; c=relaxed/simple;
	bh=J6MPXBTlWKwxGO96Tz96YxtwSODWhWwkjd44N0B7Qz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CfnQ00ZCKWcn1OUdkM4p/UP46vn/A7rEbzyR+THxaykUqY7Jn28ch7VcTc4BUr9GGsWc2RzjxnhmlreD8XC3vsCzZN/ONmY9M+7wtwegG5OLDLHwwwQ4FX3wTUUaMhrUGnKShOjnkyv3Er8qFo33EGTDS3ZJb1P/6EgqJzbTwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEkraM2V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E368C116B1;
	Wed, 15 May 2024 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715785689;
	bh=J6MPXBTlWKwxGO96Tz96YxtwSODWhWwkjd44N0B7Qz4=;
	h=From:To:Cc:Subject:Date:From;
	b=ZEkraM2VY2lnWkM5470A9PJIsWMVF2+t5KtDIOkU/Z4ZPqeEHP8qG6kSknFc56Ver
	 q2Kw7CV5UVmUdgq2L0iSTPMWJDiH6ZK/gBuzMWbZep4YpmhyLCCP3i9NoMbxMMwLzc
	 KsZs4DWUCCOGWREjW2OSeKjcaluJffWvpZOwrOuhYw9qvuPc3ygrI+24B1qNoXKiJh
	 nAbeUAzr8brSC5BTs87Q5JKuyZsP5vM0xjJkZKXUe7hwdXdybf8l4k7kncFcypucQ/
	 BQeMesu90MVB1AqY2qC3RueXeMwfN2ty0+TFiChF0JzzN7KPHDMF3XwJzLlUDdrtnn
	 wLyMVabTfQhwA==
From: Borislav Petkov <bp@kernel.org>
To: KVM <kvm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH] KVM: Unexport kvm_debugfs_dir
Date: Wed, 15 May 2024 17:08:04 +0200
Message-ID: <20240515150804.9354-1-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

After

  faf01aef0570 ("KVM: PPC: Merge powerpc's debugfs entry content into generic entry")

kvm_debugfs_dir is not used anywhere else outside of kvm_main.c

Unexport it and make it static.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 include/linux/kvm_host.h | 2 --
 virt/kvm/kvm_main.c      | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..c8bc33aab26a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1959,8 +1959,6 @@ struct _kvm_stats_desc {
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_IBOOLEAN(VCPU_GENERIC, blocking)
 
-extern struct dentry *kvm_debugfs_dir;
-
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 		       const struct _kvm_stats_desc *desc,
 		       void *stats, size_t size_stats,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff0a20565f90..382e2ab14137 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -110,8 +110,7 @@ static struct kmem_cache *kvm_vcpu_cache;
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
 
-struct dentry *kvm_debugfs_dir;
-EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
+static struct dentry *kvm_debugfs_dir;
 
 static const struct file_operations stat_fops_per_vm;
 
-- 
2.43.0


