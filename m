Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583514CE86E
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 04:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiCFDUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 22:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiCFDUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 22:20:15 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CDC3335A;
        Sat,  5 Mar 2022 19:19:24 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id e2so10649961qte.12;
        Sat, 05 Mar 2022 19:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FH3A/E2W0O7IE23aSLKaPOzTxYbpDcfx+ImWb5Kh3ok=;
        b=nf/tMJjStWFiBSHv+/JkLI595GOmYrGpkTMp1B4ugTfZ1plHH3nhkz0Q3o77tiVg8z
         0f+z/JiCPv6bbBK6Z048Z/RO1k5hT3RmHzGr5JPSPErXJOPalWArYJPBJtoFgSfxxzQG
         a5B6fg8E8thptzxgUI2yWwUYV61TT0IMWrgO6oKLDNO8Wq3Z1iv6BAfW3w0tgUIo/uGS
         8JzXgoPO7PfPlO3EhSJhQhpQWChWRvpjW6Tw25ywa/DaTf0TXEmMcqaiTCYnfVpM3alv
         FW8IK4SnrcVJEW+ZrEqARk6u2GD/pgBl7ljWZvqkJQ8Aflyq3vkdILl1hgKzMQqXzoGF
         8Dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FH3A/E2W0O7IE23aSLKaPOzTxYbpDcfx+ImWb5Kh3ok=;
        b=auwlhpbIVFEQCrTFmeTcP5b6xBVvGV9kO7yVxB95gLPXbHptWwmmwvLF75bhdkXAQk
         sC/d46cdwXHXjQzUjBytb6NjgPzRShB7W7z4HqR3urJzNyzRoraPMdKMzCxSa0ICZIg+
         CUg2FVkf2irfJF4xADTFkwXx7Q6v7EAdmklnL8TJhG0HPl7o8+zRl4CtKPDw6QYPVCaB
         ZWs/1s0VaQ8KIwGA/oxK68mB5OJqxQ9B3aAPmVzwpbdjWQXv8ZDFEw/qs/y00yw5iC9F
         KUP896mPff6jcBttshaHPA+Oe0FK06Ez9aP1bcs5vzMMHQm9iXgzwPvtbs3buW/ZNiGs
         SCBQ==
X-Gm-Message-State: AOAM532OEawInBMovBFev40As+JDH0nxCOJsK7VIhBdOej5f9cq5FFF5
        CcqjK8lu31DLq0QxvSSWNp0=
X-Google-Smtp-Source: ABdhPJzuSA+jebqZTqC0s9bkkwmBksTHakOaub3cfbRjLhGy3lh9ISTmcl6MnB2BdRIdUFazW4QK2w==
X-Received: by 2002:a05:622a:1192:b0:2d1:e58e:7659 with SMTP id m18-20020a05622a119200b002d1e58e7659mr4880333qtk.41.1646536763568;
        Sat, 05 Mar 2022 19:19:23 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id f1-20020a37ad01000000b0064919f4b37csm4463183qkm.75.2022.03.05.19.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 19:19:23 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] KVM: Modified two MMIO functions to return bool
Date:   Sat,  5 Mar 2022 22:19:07 -0500
Message-Id: <20220306031907.210499-9-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306031907.210499-1-henryksloan@gmail.com>
References: <20220306031907.210499-1-henryksloan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjusted the signatures and implementations of
coalesced_mmio_in_range and coalesced_mmio_has_room to produce booleans.

Signed-off-by: Henry Sloan <henryksloan@gmail.com>
---
 virt/kvm/coalesced_mmio.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 1ff2bca6489c..e129d88a95c5 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -22,28 +22,27 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_coalesced_mmio_dev, dev);
 }
 
-static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
-				   gpa_t addr, int len)
+static bool coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
+				    gpa_t addr, int len)
 {
 	/* is it in a batchable area ?
 	 * (addr,len) is fully included in
 	 * (zone->addr, zone->size)
 	 */
 	if (len < 0)
-		return 0;
+		return false;
 	if (addr + len < addr)
-		return 0;
+		return false;
 	if (addr < dev->zone.addr)
-		return 0;
+		return false;
 	if (addr + len > dev->zone.addr + dev->zone.size)
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
+static bool coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
-	unsigned int avail;
 
 	/* Are we able to batch it ? */
 
@@ -52,13 +51,7 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 	 * there is always one unused entry in the buffer
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
-	avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
-	if (avail == 0) {
-		/* full */
-		return 0;
-	}
-
-	return 1;
+	return (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX != 0;
 }
 
 static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
-- 
2.35.1

