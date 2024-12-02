Return-Path: <kvm+bounces-32812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 977BB9DFCC7
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 10:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25727B216C2
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 09:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62231FA14F;
	Mon,  2 Dec 2024 09:07:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AF11F9ECD
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 09:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733130432; cv=none; b=gg92JMLMnhgyKDxWH8JRVoUf9vzsU5k+GTStm90b4Cu+w2M1XUT058rxWWiq4j6d6sbnjAPPePDQTOyfdEgn2yj8A5+NWz5EBDIpaB/HJWO2WXH2GFzLSRoePCLPBdELfRT2KeLD22Q8kXeM/XlMkX3rJie5NqwakZ0Xj5lPgUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733130432; c=relaxed/simple;
	bh=FMEO83NTZBlOJZlZZ4Dl1lPei+wUOgh/kkpVG5fuvTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NolH4ISIq8SA/gEcYkdEeytUt4Zj8jk1T1PUAbLLVF5LObpBqljd7AbKPpF3G/3YtREJNJosz23FJx7D9PZUn7bv26eCEWpXmlBozGx2CsVErsmOzCOz6G9nKsVHzHnqCnix74ugWJk25CO8298u2pgO6BKOksnG5TLApf2mj6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1tI2OO-00DwlN-0s;
	Mon, 02 Dec 2024 10:06:56 +0100
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1tI2ON-00000000Hfe-3X0n;
	Mon, 02 Dec 2024 10:06:55 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org,
	Bernhard Kauer <bk@alpico.io>
Subject: [PATCH v2] KVM: make uevents configurable
Date: Mon,  2 Dec 2024 10:06:28 +0100
Message-ID: <20241202090628.67919-1-bk@alpico.io>
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

v1->v2:  make the parameter read-write to avoid reboots on ARM

Signed-off-by: Bernhard Kauer <bk@alpico.io>
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 38620c16739b..9e714cf45617 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -97,6 +97,9 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 bool debugfs_per_vm = true;
 module_param(debugfs_per_vm, bool, 0644);
 
+bool disable_uevent_notify;
+module_param(disable_uevent_notify, bool, 0644);
+
 /*
  * Allow direct access (from KVM or the CPU) without MMU notifier protection
  * to unpinned pages.
@@ -6141,7 +6144,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	struct kobj_uevent_env *env;
 	unsigned long long created, active;
 
-	if (!kvm_dev.this_device || !kvm)
+	if (!kvm_dev.this_device || !kvm || disable_uevent_notify)
 		return;
 
 	mutex_lock(&kvm_lock);
-- 
2.45.2


