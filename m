Return-Path: <kvm+bounces-33133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D94409E5578
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 969EF282887
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6F7218EB1;
	Thu,  5 Dec 2024 12:28:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B657F2185A0
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733401697; cv=none; b=iTsh3UFSBazF0ZBUfiJ+K/YwyseIJ40v3GhaSJdis6ZbLIIQ9WGMrTDJF/XIYqj2eVAZx2Ju+e5sBiaMGIdKtWA7+ujaKpbZCVlIqhvrMxy74fMQReOToIxP1WicKwqwTPflV4LHSNfReV5Bu6c0fO10uhXjVeTH6eM6LqB38mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733401697; c=relaxed/simple;
	bh=b1L/zjilopM5ckIj/BBz/KfeSiLylHLs9mxg4wRUY6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oHtMPeMLy5oh5/+VgbmcqJpBkFhUauS43ubiXw8y5o+xSPC750FQc5u+Iw9qK83NT2FImvs2VtYhxZu9/s92Y7bFyX8GpZGPY7FtHBm1I5wtlzuGlvdGTQy4FXclpveUWfWsODXz23bfMMpcmHaI0NhWuIsYS/wU99Ye6BUelbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1tJAxY-00HLvF-1f;
	Thu, 05 Dec 2024 13:27:56 +0100
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1tJAxY-00000001y5A-0HrY;
	Thu, 05 Dec 2024 13:27:56 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Bernhard Kauer <bk@alpico.io>
Subject: [PATCH v3] KVM: make uevents configurable
Date: Thu,  5 Dec 2024 13:27:36 +0100
Message-ID: <20241205122736.469276-1-bk@alpico.io>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handling of uevents in userlevel is a bottleneck for tiny VMs.

Running 10_000 VMs keeps one and a half cores busy for 5.4 seconds to let
systemd-udevd handle all messages.  That is roughly 27x longer than
the 0.2 seconds needed for running the VMs without them.

We choose a module parameter here due to its simplicity and ease of
maintenance.

Signed-off-by: Bernhard Kauer <bk@alpico.io>
---

v1->v2: read-write parameter to avoid killing all running VMs to toggle it
v2->v3: invert the logic, add documentation

 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 virt/kvm/kvm_main.c                             | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d401577b5a6a..8ae3dc4f2392 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2723,6 +2723,10 @@
 			If the value is 0 (the default), KVM will pick a period based
 			on the ratio, such that a page is zapped after 1 hour on average.
 
+	kvm.uevent_notify=
+			[KVM] Send a uevent message to udev whenever a VM is
+			created or destroyed. Default is true.
+
 	kvm-amd.nested=	[KVM,AMD] Control nested virtualization feature in
 			KVM/SVM. Default is 1 (enabled).
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 609e0bd68e8e..276c98e2c37d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -97,6 +97,9 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 bool debugfs_per_vm = true;
 module_param(debugfs_per_vm, bool, 0644);
 
+static bool uevent_notify = true;
+module_param(uevent_notify, bool, 0644);
+
 /*
  * Ordering of locks:
  *
@@ -6276,7 +6279,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	struct kobj_uevent_env *env;
 	unsigned long long created, active;
 
-	if (!kvm_dev.this_device || !kvm)
+	if (!kvm_dev.this_device || !kvm || !uevent_notify)
 		return;
 
 	mutex_lock(&kvm_lock);
-- 
2.45.2


