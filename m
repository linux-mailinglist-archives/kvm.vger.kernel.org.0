Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195487B2473
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjI1Rzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Rzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:55:39 -0400
X-Greylist: delayed 418 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Sep 2023 10:55:37 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D5CDD;
        Thu, 28 Sep 2023 10:55:37 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id E7CA51018978B;
        Thu, 28 Sep 2023 19:48:34 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id C05E860E0037;
        Thu, 28 Sep 2023 19:48:34 +0200 (CEST)
X-Mailbox-Line: From 3db7a8856833dfcbc4b122301f233828379d67db Mon Sep 17 00:00:00 2001
Message-Id: <3db7a8856833dfcbc4b122301f233828379d67db.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:32 +0200
Subject: [PATCH 04/12] certs: Create blacklist keyring earlier
To:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upcoming support for PCI device authentication with CMA-SPDM
(PCIe r6.1 sec 6.31) requires parsing X.509 certificates upon
device enumeration, which happens in a subsys_initcall().

Parsing X.509 certificates accesses the blacklist keyring:
x509_cert_parse()
  x509_get_sig_params()
    is_hash_blacklisted()
      keyring_search()

So far the keyring is created much later in a device_initcall().  Avoid
a NULL pointer dereference on access to the keyring by creating it one
initcall level earlier than PCI device enumeration, i.e. in an
arch_initcall().

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 certs/blacklist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/certs/blacklist.c b/certs/blacklist.c
index 675dd7a8f07a..34185415d451 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -311,7 +311,7 @@ static int restrict_link_for_blacklist(struct key *dest_keyring,
  * Initialise the blacklist
  *
  * The blacklist_init() function is registered as an initcall via
- * device_initcall().  As a result if the blacklist_init() function fails for
+ * arch_initcall().  As a result if the blacklist_init() function fails for
  * any reason the kernel continues to execute.  While cleanly returning -ENODEV
  * could be acceptable for some non-critical kernel parts, if the blacklist
  * keyring fails to load it defeats the certificate/key based deny list for
@@ -356,7 +356,7 @@ static int __init blacklist_init(void)
 /*
  * Must be initialised before we try and load the keys into the keyring.
  */
-device_initcall(blacklist_init);
+arch_initcall(blacklist_init);
 
 #ifdef CONFIG_SYSTEM_REVOCATION_LIST
 /*
-- 
2.40.1

