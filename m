Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7034C1E30
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 23:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243226AbiBWWFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 17:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243209AbiBWWFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 17:05:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA274DF62;
        Wed, 23 Feb 2022 14:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9C246190C;
        Wed, 23 Feb 2022 22:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06768C340E7;
        Wed, 23 Feb 2022 22:05:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="awY7NnOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645653917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4ovfwdUD1X2Y5KbzB3Em8ah+UEym9W3EkRSqF247no=;
        b=awY7NnOuzpNXi126ohYHv/dK0AEGJosLdDAfK5B8W8GsL75iQnM7JBOPyYyRcN/ZCqs0r8
        sik75qGnqWecorYLRCnHp4iKtGBl/YRO+ppF0bsEyRMs+4+vJumbmwx8oxKpIeo29D5p41
        doFEFyydCqOGCkSSdVQwi3A6pgpsGsw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5794f5a0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 22:05:17 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, adrian@parity.io,
        dwmw@amazon.co.uk, graf@amazon.com, colmmacc@amazon.com,
        raduweis@amazon.com, imammedo@redhat.com, ehabkost@redhat.com,
        ben@skyportsystems.com, mst@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, linux@dominikbrodowski.net, ardb@kernel.org,
        jannh@google.com, gregkh@linuxfoundation.org, tytso@mit.edu
Subject: [PATCH v2 1/2] random: add mechanism for VM forks to reinitialize crng
Date:   Wed, 23 Feb 2022 23:04:55 +0100
Message-Id: <20220223220456.666193-2-Jason@zx2c4.com>
In-Reply-To: <20220223220456.666193-1-Jason@zx2c4.com>
References: <20220223220456.666193-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a VM forks, we must immediately mix in additional information to
the stream of random output so that two forks or a rollback don't
produce the same stream of random numbers, which could have catastrophic
cryptographic consequences. This commit adds a simple API, add_vmfork_
randomness(), for that.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 53 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |  1 +
 2 files changed, 54 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 536237a0f073..95584f6646f9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -508,6 +508,40 @@ static size_t crng_pre_init_inject(const void *input, size_t len,
 	return len;
 }
 
+/*
+ * This mixes unique_vm_id directly into the base_crng key as soon as
+ * possible, similarly to crng_pre_init_inject(), even if the crng is
+ * already running, in order to immediately branch streams from prior
+ * VM instances.
+ */
+static void crng_vmfork_inject(const void *unique_vm_id, size_t len)
+{
+	unsigned long flags, next_gen;
+	struct blake2s_state hash;
+
+	spin_lock_irqsave(&base_crng.lock, flags);
+
+	/*
+	 * Update the generation, while locked, as early as possible
+	 * This will mean unlocked reads of the generation will
+	 * cause a reseeding of per-cpu crngs, and those will spin
+	 * on the base_crng lock waiting for the rest of this function
+	 * to complete, which achieves the goal of blocking the
+	 * production of new output until this is done.
+	 */
+	next_gen = base_crng.generation + 1;
+	if (next_gen == ULONG_MAX)
+		++next_gen;
+	WRITE_ONCE(base_crng.generation, next_gen);
+
+	blake2s_init(&hash, sizeof(base_crng.key));
+	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
+	blake2s_update(&hash, unique_vm_id, len);
+	blake2s_final(&hash, base_crng.key);
+
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+}
+
 static void _get_random_bytes(void *buf, size_t nbytes)
 {
 	u32 chacha_state[CHACHA_STATE_WORDS];
@@ -935,6 +969,7 @@ static bool drain_entropy(void *buf, size_t nbytes)
  *	void add_hwgenerator_randomness(const void *buffer, size_t count,
  *					size_t entropy);
  *	void add_bootloader_randomness(const void *buf, size_t size);
+ *	void add_vmfork_randomness(const void *unique_vm_id, size_t size);
  *	void add_interrupt_randomness(int irq);
  *
  * add_device_randomness() adds data to the input pool that
@@ -966,6 +1001,11 @@ static bool drain_entropy(void *buf, size_t nbytes)
  * add_device_randomness(), depending on whether or not the configuration
  * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  *
+ * add_vmfork_randomness() adds a unique (but not neccessarily secret) ID
+ * representing the current instance of a VM to the pool, without crediting,
+ * and then immediately mixes that ID into the current base_crng key, so
+ * that it takes effect prior to a reseeding.
+ *
  * add_interrupt_randomness() uses the interrupt timing as random
  * inputs to the entropy pool. Using the cycle counters and the irq source
  * as inputs, it feeds the input pool roughly once a second or after 64
@@ -1195,6 +1235,19 @@ void add_bootloader_randomness(const void *buf, size_t size)
 }
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
+/*
+ * Handle a new unique VM ID, which is unique, not secret, so we
+ * don't credit it, but we do mix it into the entropy pool and
+ * inject it into the crng.
+ */
+void add_vmfork_randomness(const void *unique_vm_id, size_t size)
+{
+	add_device_randomness(unique_vm_id, size);
+	if (crng_ready())
+		crng_vmfork_inject(unique_vm_id, size);
+}
+EXPORT_SYMBOL_GPL(add_vmfork_randomness);
+
 struct fast_pool {
 	union {
 		u32 pool32[4];
diff --git a/include/linux/random.h b/include/linux/random.h
index 6148b8d1ccf3..51b8ed797732 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -34,6 +34,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq) __latent_entropy;
 extern void add_hwgenerator_randomness(const void *buffer, size_t count,
 				       size_t entropy);
+extern void add_vmfork_randomness(const void *unique_vm_id, size_t size);
 
 extern void get_random_bytes(void *buf, size_t nbytes);
 extern int wait_for_random_bytes(void);
-- 
2.35.1

