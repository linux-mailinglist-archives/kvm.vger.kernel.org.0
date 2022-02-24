Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9284C2D5C
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 14:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiBXNkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 08:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBXNj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 08:39:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAE126499E;
        Thu, 24 Feb 2022 05:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B319561A97;
        Thu, 24 Feb 2022 13:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D31C340E9;
        Thu, 24 Feb 2022 13:39:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OBkhNZ+u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645709964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pLZQWdHZ8lpp8TrT2AHt2rKbsHEeRqBQfQFSJqzrY8E=;
        b=OBkhNZ+uMvd78P2oRT7NxwjwEr+PYhqcJwHUQqt5K75dEo1gIq3vq5xsa25GTvs1vjpkLf
        BO7LAEOmd2wr0w5/w5+h6XBc6xiubOUTwFoGiQgdNJ5VaImu6Q7Vhdi2/ypFX2rCdQv4Uo
        PjJYMjSP6xSjmZ5UXklxzYUmHh9e1N4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3e2bbf8d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 24 Feb 2022 13:39:24 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, adrian@parity.io,
        dwmw@amazon.co.uk, graf@amazon.com, colmmacc@amazon.com,
        raduweis@amazon.com, berrange@redhat.com, lersek@redhat.com,
        imammedo@redhat.com, ehabkost@redhat.com, ben@skyportsystems.com,
        mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        linux@dominikbrodowski.net, ebiggers@kernel.org, ardb@kernel.org,
        jannh@google.com, gregkh@linuxfoundation.org, tytso@mit.edu,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v3 1/2] random: add mechanism for VM forks to reinitialize crng
Date:   Thu, 24 Feb 2022 14:39:05 +0100
Message-Id: <20220224133906.751587-2-Jason@zx2c4.com>
In-Reply-To: <20220224133906.751587-1-Jason@zx2c4.com>
References: <20220224133906.751587-1-Jason@zx2c4.com>
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
randomness(), for that, by force reseeding the crng.

This has the added benefit of also draining the entropy pool and setting
its timer back, so that any old entropy that was there prior -- which
could have already been used by a different fork, or generally gone
stale -- does not contribute to the accounting of the next 256 bits.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jann Horn <jannh@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 50 +++++++++++++++++++++++++++++-------------
 include/linux/random.h |  1 +
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9fb06fc298d3..e8b84791cefe 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -289,14 +289,14 @@ static DEFINE_PER_CPU(struct crng, crngs) = {
 };
 
 /* Used by crng_reseed() to extract a new seed from the input pool. */
-static bool drain_entropy(void *buf, size_t nbytes);
+static bool drain_entropy(void *buf, size_t nbytes, bool force);
 
 /*
  * This extracts a new crng key from the input pool, but only if there is a
- * sufficient amount of entropy available, in order to mitigate bruteforcing
- * of newly added bits.
+ * sufficient amount of entropy available or force is true, in order to
+ * mitigate bruteforcing of newly added bits.
  */
-static void crng_reseed(void)
+static void crng_reseed(bool force)
 {
 	unsigned long flags;
 	unsigned long next_gen;
@@ -304,7 +304,7 @@ static void crng_reseed(void)
 	bool finalize_init = false;
 
 	/* Only reseed if we can, to prevent brute forcing a small amount of new bits. */
-	if (!drain_entropy(key, sizeof(key)))
+	if (!drain_entropy(key, sizeof(key), force))
 		return;
 
 	/*
@@ -406,7 +406,7 @@ static void crng_make_state(u32 chacha_state[CHACHA_STATE_WORDS],
 	 * in turn bumps the generation counter that we check below.
 	 */
 	if (unlikely(time_after(jiffies, READ_ONCE(base_crng.birth) + CRNG_RESEED_INTERVAL)))
-		crng_reseed();
+		crng_reseed(false);
 
 	local_lock_irqsave(&crngs.lock, flags);
 	crng = raw_cpu_ptr(&crngs);
@@ -771,10 +771,10 @@ EXPORT_SYMBOL(get_random_bytes_arch);
  *
  * Finally, extract entropy via these two, with the latter one
  * setting the entropy count to zero and extracting only if there
- * is POOL_MIN_BITS entropy credited prior:
+ * is POOL_MIN_BITS entropy credited prior or force is true:
  *
  *     static void extract_entropy(void *buf, size_t nbytes)
- *     static bool drain_entropy(void *buf, size_t nbytes)
+ *     static bool drain_entropy(void *buf, size_t nbytes, bool force)
  *
  **********************************************************************/
 
@@ -832,7 +832,7 @@ static void credit_entropy_bits(size_t nbits)
 	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
 
 	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
-		crng_reseed();
+		crng_reseed(false);
 }
 
 /*
@@ -882,16 +882,16 @@ static void extract_entropy(void *buf, size_t nbytes)
 }
 
 /*
- * First we make sure we have POOL_MIN_BITS of entropy in the pool, and then we
- * set the entropy count to zero (but don't actually touch any data). Only then
- * can we extract a new key with extract_entropy().
+ * First we make sure we have POOL_MIN_BITS of entropy in the pool unless force
+ * is true, and then we set the entropy count to zero (but don't actually touch
+ * any data). Only then can we extract a new key with extract_entropy().
  */
-static bool drain_entropy(void *buf, size_t nbytes)
+static bool drain_entropy(void *buf, size_t nbytes, bool force)
 {
 	unsigned int entropy_count;
 	do {
 		entropy_count = READ_ONCE(input_pool.entropy_count);
-		if (entropy_count < POOL_MIN_BITS)
+		if (!force && entropy_count < POOL_MIN_BITS)
 			return false;
 	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
 	extract_entropy(buf, nbytes);
@@ -915,6 +915,7 @@ static bool drain_entropy(void *buf, size_t nbytes)
  *	void add_hwgenerator_randomness(const void *buffer, size_t count,
  *					size_t entropy);
  *	void add_bootloader_randomness(const void *buf, size_t size);
+ *	void add_vmfork_randomness(const void *unique_vm_id, size_t size);
  *	void add_interrupt_randomness(int irq);
  *
  * add_device_randomness() adds data to the input pool that
@@ -946,6 +947,10 @@ static bool drain_entropy(void *buf, size_t nbytes)
  * add_device_randomness(), depending on whether or not the configuration
  * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  *
+ * add_vmfork_randomness() adds a unique (but not necessarily secret) ID
+ * representing the current instance of a VM to the pool, without crediting,
+ * and then force-reseeds the crng so that it takes effect immediately.
+ *
  * add_interrupt_randomness() uses the interrupt timing as random
  * inputs to the entropy pool. Using the cycle counters and the irq source
  * as inputs, it feeds the input pool roughly once a second or after 64
@@ -1175,6 +1180,21 @@ void add_bootloader_randomness(const void *buf, size_t size)
 }
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
+/*
+ * Handle a new unique VM ID, which is unique, not secret, so we
+ * don't credit it, but we do immediately force a reseed after so
+ * that it's used by the crng posthaste.
+ */
+void add_vmfork_randomness(const void *unique_vm_id, size_t size)
+{
+	add_device_randomness(unique_vm_id, size);
+	if (crng_ready()) {
+		crng_reseed(true);
+		pr_notice("crng reseeded due to virtual machine fork\n");
+	}
+}
+EXPORT_SYMBOL_GPL(add_vmfork_randomness);
+
 struct fast_pool {
 	union {
 		u32 pool32[4];
@@ -1564,7 +1584,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed();
+		crng_reseed(false);
 		return 0;
 	default:
 		return -EINVAL;
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

