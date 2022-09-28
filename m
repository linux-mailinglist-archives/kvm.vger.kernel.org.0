Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED925EE054
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiI1P1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 11:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiI1P0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 11:26:40 -0400
Received: from smtp1.irit.fr (smtp1.irit.fr [141.115.24.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4197EA8333
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 08:26:12 -0700 (PDT)
From:   dinhngoc.tu@irit.fr
To:     kvm@vger.kernel.org
Cc:     Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
Subject: [PATCH kvmtool] mmio: Fix wrong PIO tree search size
Date:   Wed, 28 Sep 2022 17:16:51 +0200
Message-Id: <20220928151651.1846-1-dinhngoc.tu@irit.fr>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tu Dinh Ngoc <dinhngoc.tu@irit.fr>

The `len' parameter of kvm__register_pio specifies a range of I/O ports
to be registered for the same handler. However, the `size' parameter of
PIO events specifies the number of bytes read/written to a single I/O
port.

kvm__emulate_io confuses the two and uses the number of bytes
read/written in its I/O handler search, meaning reads/writes with a size
larger than the registered range length will be silently dropped.

Fix this issue by specifying a MMIO tree search range of 1 port.
---
 mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mmio.c b/mmio.c
index 5a114e9..212e979 100644
--- a/mmio.c
+++ b/mmio.c
@@ -222,7 +222,7 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
 	struct mmio_mapping *mmio;
 	bool is_write = direction == KVM_EXIT_IO_OUT;
 
-	mmio = mmio_get(&pio_tree, port, size);
+	mmio = mmio_get(&pio_tree, port, 1);
 	if (!mmio) {
 		if (vcpu->kvm->cfg.ioport_debug) {
 			fprintf(stderr, "IO error: %s port=%x, size=%d, count=%u\n",
-- 
2.25.1

