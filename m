Return-Path: <kvm+bounces-29471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2BD9AC1B9
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 10:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C8FC282CC1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 08:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B32159565;
	Wed, 23 Oct 2024 08:33:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B2214C5BD
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729672382; cv=none; b=O+QcoctclMSvICpgv3XD7O5gHab2MVTGK7N1EMDNMMdNOqw7ZiHuhHmB6ItOJuYIn1JPEeYjJTNinAErooAhixMItMLB4dP63tF5KyNCFYnTmupZi4/9U2cKj183jYiFSOoMKXLWIkX53ysZ7JfALeGOV2zmFGTH3iYUebpE+MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729672382; c=relaxed/simple;
	bh=xwGuJzfALxPVvt8gbuxlVFurhyYv7fDZgKFHrX4X2xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IOZhRyjvC7NctFQJnHUjg5fG1X+nxP4BJDckpz33RpkNHsjW1V5jQruwawOzdo3diOA+PhZgIURGwSDyNLxubZpqAwVKm0gaTixxSaQFFCSIpdioO8NDSxrq5k+afYYF2A6SitlwslxvcENqZ+HfgD+iOYUP/G6NMHgV1xX/4mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t3WnN-004Rot-2X;
	Wed, 23 Oct 2024 10:32:45 +0200
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t3WnN-00000000lxm-0fAn;
	Wed, 23 Oct 2024 10:32:45 +0200
From: Bernhard Kauer <bk@alpico.io>
To: kvm@vger.kernel.org
Cc: Bernhard Kauer <bk@alpico.io>
Subject: [PATCH] KVM: x86: Make the debugfs per VM optional
Date: Wed, 23 Oct 2024 10:32:05 +0200
Message-ID: <20241023083237.184359-1-bk@alpico.io>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creating a debugfs directory for each virtual machine is a suprisingly
costly operation as one has to synchronize multiple cores. However, short
living VMs seldom benefit from it.

Since there are valid use-cases we make this feature optional via a
module parameter. Disabling it saves 150us in the hello microbenchmark.

Signed-off-by: Bernhard Kauer <bk@alpico.io>
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a48861363649..760e39cf86a8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -94,6 +94,9 @@ unsigned int halt_poll_ns_shrink = 2;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+bool debugfs_per_vm = true;
+module_param(debugfs_per_vm, bool, 0644);
+
 /*
  * Ordering of locks:
  *
@@ -1050,7 +1053,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	if (!debugfs_initialized())
+	if (!debugfs_initialized() || !debugfs_per_vm)
 		return 0;
 
 	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
-- 
2.45.2


