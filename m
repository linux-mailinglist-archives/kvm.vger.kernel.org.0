Return-Path: <kvm+bounces-32351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE019D5CC9
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 11:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E473B26480
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 10:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888581DF27E;
	Fri, 22 Nov 2024 09:59:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A071DF251
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 09:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732269591; cv=none; b=XsTTwQ3Yp9JbndEMm4a7Ssn4txEb+ARl6KJcikbFE5cZOaqGhWi91+QJAsNOfUepQsFDatfmn322xkBHKPkiduFNJtRrjjfA6mSUV/jwmLEF7M7cWqlkWE/QferqeXQ1icRlLYv/KV5QiS7QkZ9GjDdez8esyY89A4wMv1GYb0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732269591; c=relaxed/simple;
	bh=DMGHRHG8Fmwzs3hJGiBpazbVBO2OUcExIUTx0LeyaHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BU29n8Hs5T1jt2UitOZHZC0PUX6ACh5/uPIENZE36EBCuHizBUNUVYYl4A8481+6zs5HcHTU4g71O//2OTAPUSp8RZFk1Iiopx3QvT6AWgsesD6t559r0sBNwJx822Bu8hKfK+tlwq9nJOneJG7FcjJykUeEcGJtKLGBOkHuOBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1tEQRo-002XPC-02;
	Fri, 22 Nov 2024 10:59:32 +0100
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1tEQRn-0000000GvXj-2BgV;
	Fri, 22 Nov 2024 10:59:31 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Bernhard Kauer <bk@alpico.io>
Subject: [PATCH] KVM: make uevents configurable
Date: Fri, 22 Nov 2024 10:58:02 +0100
Message-ID: <20241122095806.4034415-1-bk@alpico.io>
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

We choose a read-only module parameter here due to its simplicity and
ease of maintenance.

Signed-off-by: Bernhard Kauer <bk@alpico.io>
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 609e0bd68e8e..6139cd67a96a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -97,6 +97,9 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 bool debugfs_per_vm = true;
 module_param(debugfs_per_vm, bool, 0644);
 
+bool disable_uevent_notify;
+module_param(disable_uevent_notify, bool, 0444);
+
 /*
  * Ordering of locks:
  *
@@ -6276,7 +6279,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	struct kobj_uevent_env *env;
 	unsigned long long created, active;
 
-	if (!kvm_dev.this_device || !kvm)
+	if (!kvm_dev.this_device || !kvm || disable_uevent_notify)
 		return;
 
 	mutex_lock(&kvm_lock);
-- 
2.45.2


