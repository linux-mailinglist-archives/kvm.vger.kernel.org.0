Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75907B2481
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjI1R7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjI1R7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:59:48 -0400
X-Greylist: delayed 1627 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Sep 2023 10:59:45 PDT
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03C019E;
        Thu, 28 Sep 2023 10:59:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id EE9201019263D;
        Thu, 28 Sep 2023 19:59:43 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id C88CE60D850C;
        Thu, 28 Sep 2023 19:59:43 +0200 (CEST)
X-Mailbox-Line: From 4f98bb7ee2e660a8b4513a94ed79f4f29d1ff379 Mon Sep 17 00:00:00 2001
Message-Id: <4f98bb7ee2e660a8b4513a94ed79f4f29d1ff379.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:36 +0200
Subject: [PATCH 06/12] crypto: ecdsa - Support P1363 signature encoding
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alternatively to the X9.62 encoding of ecdsa signatures, which uses
ASN.1 and is already supported by the kernel, there's another common
encoding called P1363.  It stores r and s as the concatenation of two
big endian, unsigned integers.  The name originates from IEEE P1363.

The Security Protocol and Data Model (SPDM) specification prescribes
that ecdsa signatures are encoded according to P1363:

   "For ECDSA signatures, excluding SM2, in SPDM, the signature shall be
    the concatenation of r and s.  The size of r shall be the size of
    the selected curve.  Likewise, the size of s shall be the size of
    the selected curve.  See BaseAsymAlgo in NEGOTIATE_ALGORITHMS for
    the size of r and s.  The byte order for r and s shall be in big
    endian order.  When placing ECDSA signatures into an SPDM signature
    field, r shall come first followed by s."

    (SPDM 1.2.1 margin no 44,
    https://www.dmtf.org/sites/default/files/standards/documents/DSP0274_1.2.1.pdf)

A subsequent commit introduces an SPDM library to enable PCI device
authentication, so add support for P1363 ecdsa signature verification.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 crypto/asymmetric_keys/public_key.c |  8 ++++++--
 crypto/ecdsa.c                      | 16 +++++++++++++---
 crypto/testmgr.h                    | 15 +++++++++++++++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 7f96e8e501db..84c4ed02a270 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -105,7 +105,8 @@ software_key_determine_akcipher(const struct public_key *pkey,
 			return -EINVAL;
 		*sig = false;
 	} else if (strncmp(pkey->pkey_algo, "ecdsa", 5) == 0) {
-		if (strcmp(encoding, "x962") != 0)
+		if (strcmp(encoding, "x962") != 0 &&
+		    strcmp(encoding, "p1363") != 0)
 			return -EINVAL;
 		/*
 		 * ECDSA signatures are taken over a raw hash, so they don't
@@ -246,7 +247,10 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		 * which is actually 2 'key_size'-bit integers encoded in
 		 * ASN.1.  Account for the ASN.1 encoding overhead here.
 		 */
-		info->max_sig_size = 2 * (len + 3) + 2;
+		if (strcmp(params->encoding, "x962") == 0)
+			info->max_sig_size = 2 * (len + 3) + 2;
+		else if (strcmp(params->encoding, "p1363") == 0)
+			info->max_sig_size = 2 * len;
 	} else {
 		info->max_data_size = len;
 		info->max_sig_size = len;
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index fbd76498aba8..cc3082c6f67d 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -159,10 +159,20 @@ static int ecdsa_verify(struct akcipher_request *req)
 		sg_nents_for_len(req->src, req->src_len + req->dst_len),
 		buffer, req->src_len + req->dst_len, 0);
 
-	ret = asn1_ber_decoder(&ecdsasignature_decoder, &sig_ctx,
-			       buffer, req->src_len);
-	if (ret < 0)
+	if (strcmp(req->enc, "x962") == 0) {
+		ret = asn1_ber_decoder(&ecdsasignature_decoder, &sig_ctx,
+				       buffer, req->src_len);
+		if (ret < 0)
+			goto error;
+	} else if (strcmp(req->enc, "p1363") == 0 &&
+		   req->src_len == 2 * keylen) {
+		ecc_swap_digits(buffer, sig_ctx.r, ctx->curve->g.ndigits);
+		ecc_swap_digits(buffer + keylen,
+					sig_ctx.s, ctx->curve->g.ndigits);
+	} else {
+		ret = -EINVAL;
 		goto error;
+	}
 
 	/* if the hash is shorter then we will add leading zeros to fit to ndigits */
 	diff = keylen - req->dst_len;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index ad57e7af2e14..f12f70818147 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -674,6 +674,7 @@ static const struct akcipher_testvec ecdsa_nist_p192_tv_template[] = {
 	"\x68\x01\x9d\xba\xce\x83\x08\xef\x95\x52\x7b\xa0\x0f\xe4\x18\x86"
 	"\x80\x6f\xa5\x79\x77\xda\xd0",
 	.c_size = 55,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -698,6 +699,7 @@ static const struct akcipher_testvec ecdsa_nist_p192_tv_template[] = {
 	"\x4f\x53\x75\xc8\x02\x48\xeb\xc3\x92\x0f\x1e\x72\xee\xc4\xa3\xe3"
 	"\x5c\x99\xdb\x92\x5b\x36",
 	.c_size = 54,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -722,6 +724,7 @@ static const struct akcipher_testvec ecdsa_nist_p192_tv_template[] = {
 	"\x69\x43\xfd\x48\x19\x86\xcf\x32\xdd\x41\x74\x6a\x51\xc7\xd9\x7d"
 	"\x3a\x97\xd9\xcd\x1a\x6a\x49",
 	.c_size = 55,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -747,6 +750,7 @@ static const struct akcipher_testvec ecdsa_nist_p192_tv_template[] = {
 	"\xbc\x5a\x1f\x82\x96\x61\xd7\xd1\x01\x77\x44\x5d\x53\xa4\x7c\x93"
 	"\x12\x3b\x3b\x28\xfb\x6d\xe1",
 	.c_size = 55,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -773,6 +777,7 @@ static const struct akcipher_testvec ecdsa_nist_p192_tv_template[] = {
 	"\xb4\x22\x9a\x98\x73\x3c\x83\xa9\x14\x2a\x5e\xf5\xe5\xfb\x72\x28"
 	"\x6a\xdf\x97\xfd\x82\x76\x24",
 	.c_size = 55,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	},
@@ -803,6 +808,7 @@ static const struct akcipher_testvec ecdsa_nist_p256_tv_template[] = {
 	"\x8a\xfa\x54\x93\x29\xa7\x70\x86\xf1\x03\x03\xf3\x3b\xe2\x73\xf7"
 	"\xfb\x9d\x8b\xde\xd4\x8d\x6f\xad",
 	.c_size = 72,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -829,6 +835,7 @@ static const struct akcipher_testvec ecdsa_nist_p256_tv_template[] = {
 	"\x4a\x77\x22\xec\xc8\x66\xbf\x50\x05\x58\x39\x0e\x26\x92\xce\xd5"
 	"\x2e\x8b\xde\x5a\x04\x0e",
 	.c_size = 70,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -855,6 +862,7 @@ static const struct akcipher_testvec ecdsa_nist_p256_tv_template[] = {
 	"\xa9\x81\xac\x4a\x50\xd0\x91\x0a\x6e\x1b\xc4\xaf\xe1\x83\xc3\x4f"
 	"\x2a\x65\x35\x23\xe3\x1d\xfa",
 	.c_size = 71,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -882,6 +890,7 @@ static const struct akcipher_testvec ecdsa_nist_p256_tv_template[] = {
 	"\x19\xfb\x5f\x92\xf4\xc9\x23\x37\x69\xf4\x3b\x4f\x47\xcf\x9b\x16"
 	"\xc0\x60\x11\x92\xdc\x17\x89\x12",
 	.c_size = 72,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -910,6 +919,7 @@ static const struct akcipher_testvec ecdsa_nist_p256_tv_template[] = {
 	"\x00\xdd\xab\xd4\xc0\x2b\xe6\x5c\xad\xc3\x78\x1c\xc2\xc1\x19\x76"
 	"\x31\x79\x4a\xe9\x81\x6a\xee",
 	.c_size = 71,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	},
@@ -944,6 +954,7 @@ static const struct akcipher_testvec ecdsa_nist_p384_tv_template[] = {
 	"\x74\xa0\x0f\xbf\xaf\xc3\x36\x76\x4a\xa1\x59\xf1\x1c\xa4\x58\x26"
 	"\x79\x12\x2a\xb7\xc5\x15\x92\xc5",
 	.c_size = 104,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -974,6 +985,7 @@ static const struct akcipher_testvec ecdsa_nist_p384_tv_template[] = {
 	"\x4d\xd0\xc6\x6e\xb0\xe9\xfc\x14\x9f\x19\xd0\x42\x8b\x93\xc2\x11"
 	"\x88\x2b\x82\x26\x5e\x1c\xda\xfb",
 	.c_size = 104,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -1004,6 +1016,7 @@ static const struct akcipher_testvec ecdsa_nist_p384_tv_template[] = {
 	"\xc0\x75\x3e\x23\x5e\x36\x4f\x8d\xde\x1e\x93\x8d\x95\xbb\x10\x0e"
 	"\xf4\x1f\x39\xca\x4d\x43",
 	.c_size = 102,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -1035,6 +1048,7 @@ static const struct akcipher_testvec ecdsa_nist_p384_tv_template[] = {
 	"\x44\x92\x8c\x86\x99\x65\xb3\x97\x96\x17\x04\xc9\x05\x77\xf1\x8e"
 	"\xab\x8d\x4e\xde\xe6\x6d\x9b\x66",
 	.c_size = 104,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	}, {
@@ -1067,6 +1081,7 @@ static const struct akcipher_testvec ecdsa_nist_p384_tv_template[] = {
 	"\x5f\x8d\x7a\xf9\xfb\x34\xe4\x8b\x80\xa5\xb6\xda\x2c\x4e\x45\xcf"
 	"\x3c\x93\xff\x50\x5d",
 	.c_size = 101,
+	.enc = "x962",
 	.public_key_vec = true,
 	.siggen_sigver_test = true,
 	},
-- 
2.40.1

