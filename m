Return-Path: <kvm+bounces-67-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B442E7DBB96
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 15:17:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54BF0B20CBE
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 14:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2AB179AA;
	Mon, 30 Oct 2023 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Wjl2lgZq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A0D171DD
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 14:17:34 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C9BC0;
	Mon, 30 Oct 2023 07:17:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B59E521906;
	Mon, 30 Oct 2023 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698675451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JL0o6ejOmiqyX7RlEJrZ7RAI8Gjvf0EzzlogCece80k=;
	b=Wjl2lgZqWUg/a9AE3QuJHK6+NDQzHMDQTy31U33Llwff6vIw9Uw3qZJEK6BBLQK7obO/sZ
	t2Mtq/tO6UUvCOg2E8yhcLo1TzdTXF2lTFc0SzApsN+9MC+1pLb4PGPjwQK+Xh8b3RevrF
	dn4G3KmXXo2GEKtZOC/O72raxnLbkZw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66803138F8;
	Mon, 30 Oct 2023 14:17:31 +0000 (UTC)
Received: from dovecot-director1.suse.de ([192.168.254.64])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id jifVFvu6P2VsOgAAMHmgww
	(envelope-from <nik.borisov@suse.com>); Mon, 30 Oct 2023 14:17:31 +0000
From: Nikolay Borisov <nik.borisov@suse.com>
To: seanjc@google.com
Cc: pbonzini@redhat.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH] KVM: x86: User mutex guards to eliminate __kvm_x86_vendor_init()
Date: Mon, 30 Oct 2023 16:17:28 +0200
Message-Id: <20231030141728.1406118-1-nik.borisov@suse.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current separation between (__){0,1}kvm_x86_vendor_init() is superfluos as
the the underscore version doesn't have any other callers.

Instead, use the newly added cleanup infrastructure to ensure that
kvm_x86_vendor_init() holds the vendor_module_lock throughout its
exectuion and that in case of error in the middle it's released. No
functional changes.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
---
 arch/x86/kvm/x86.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41cce5031126..cd7c2d0f88cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9446,11 +9446,13 @@ static void kvm_x86_check_cpu_compat(void *ret)
 	*(int *)ret = kvm_x86_check_processor_compatibility();
 }
 
-static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
+int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
 	u64 host_pat;
 	int r, cpu;
 
+	guard(mutex)(&vendor_module_lock);
+
 	if (kvm_x86_ops.hardware_enable) {
 		pr_err("already loaded vendor module '%s'\n", kvm_x86_ops.name);
 		return -EEXIST;
@@ -9580,17 +9582,6 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
 }
-
-int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
-{
-	int r;
-
-	mutex_lock(&vendor_module_lock);
-	r = __kvm_x86_vendor_init(ops);
-	mutex_unlock(&vendor_module_lock);
-
-	return r;
-}
 EXPORT_SYMBOL_GPL(kvm_x86_vendor_init);
 
 void kvm_x86_vendor_exit(void)
-- 
2.34.1


