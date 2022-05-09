Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C913C520610
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiEIUoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiEIUoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:14 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE580285AF1
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:19 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id y32so25867255lfa.6
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7in66Hxa7xF6G324NONizG1evPnalg16tcQ9vYyChO0=;
        b=b+kpeGiF9qCklr+WEpDD2W9fOKZnb7Kl9Vzg+9XQpu7H32FQaxeDR2s/d7FKK/a5Wc
         sMihT4ya28QARlXFu22Wls2B3gA7O+UenIoSIZqswSlXZscxfMWBBp5GXHxhyxtY+9XH
         ybwJnMR/pMp2FdKSiufF2shcCkN1u0vaZg/m5hwDCbtuD+HMVwjH2Byya3f061Ntmg/Q
         YKiYzvqktai1qJhc9r1s7Elk8beH7hChy5oIaU4ce5YL3Kbx4yonAugYPqkcvbplyYI5
         dCbBSGpPRppzoigMGTsSBiejAjT7kr2Fpdby+g814fySvazjxwpYlNaglx8Ivg63NYm8
         cvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7in66Hxa7xF6G324NONizG1evPnalg16tcQ9vYyChO0=;
        b=gbd1xDhNCVTlGND+ltuXT7P0/U33gzvueBY/noZRfrQCVBsVkb44ol1eVNcM4+PpQS
         qjxjXmb9u5jNJMBCWZr0J9AVhA4mO08e/MSA/yv9mAtY8QAQUJJm4PTR2kQ3uT+lW5kx
         qiinsh18ln8kjiBi4WRjGGCnzyftEX8dtD27gGIN8K64X+eBxO3mEIeY2ggwIIyUb/ln
         Sc/1fSFaBznE43HTeZH1SPFk3p1LKCzxXM+6OY1o7Ls6aYF4t3RADrTo3zDDE1x+toes
         MN714C7gYxoVYSA9Q5n2RsFnXxnyfx08JrKRNostq1ffGdbIDPjmSNSl1Hz9WyhI+GtZ
         zBvQ==
X-Gm-Message-State: AOAM531+dCNSlfZdGvYfzRQ+cf+3JtzNJTDhTJ3ebN5cKinTCbc9q8Ae
        rdedjPJFf5cyAlorO4GA0WyIn+7+SD4=
X-Google-Smtp-Source: ABdhPJzlNKEfyPfyyGT0+vaKFzUYrWegiLn0F33tq8/+6fMiCIZPZJrrYL1F8ThMNsiY+AQCW7wmnA==
X-Received: by 2002:ac2:4c55:0:b0:473:a651:942a with SMTP id o21-20020ac24c55000000b00473a651942amr13620720lfk.678.1652128817668;
        Mon, 09 May 2022 13:40:17 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:17 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 2/6] mmio: Sanitize addr and len
Date:   Mon,  9 May 2022 23:39:36 +0300
Message-Id: <20220509203940.754644-3-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509203940.754644-1-martin.b.radev@gmail.com>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch verifies that adding the addr and length arguments
from an MMIO op do not overflow. This is necessary because the
arguments are controlled by the VM. The length may be set to
an arbitrary value by using the rep prefix.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 mmio.c        | 4 ++++
 virtio/mmio.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/mmio.c b/mmio.c
index a6dd3aa..5a114e9 100644
--- a/mmio.c
+++ b/mmio.c
@@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
 {
 	struct rb_int_node *node;
 
+	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
+	if (addr + len <= addr)
+		return NULL;
+
 	node = rb_int_search_range(root, addr, addr + len);
 	if (node == NULL)
 		return NULL;
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 875a288..979fa8c 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -105,6 +105,12 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 	struct virtio_mmio *vmmio = vdev->virtio;
 	u32 i;
 
+	/* Check for wrap-around and zero length. */
+	if (addr + len <= addr) {
+		WARN_ONCE(1, "addr (%llu) + length (%u) wraps-around.\n", addr, len);
+		return;
+	}
+
 	for (i = 0; i < len; i++) {
 		if (is_write)
 			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
-- 
2.25.1

