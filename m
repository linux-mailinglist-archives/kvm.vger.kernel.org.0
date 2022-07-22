Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5957E2F0
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiGVOTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 10:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiGVOS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 10:18:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC946A026D
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m17so6413344wrw.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DC2JUNKZSOxMdfBfE8uIWKJNFczY8Th1lgyz9dOaayw=;
        b=N+qVtDLYKlKN8c/tu7cMDaGJ5YokDsHfmX0bekD/2j/gyJM5gZgaLdg+343hJ5Tx1X
         lJupCVv/AykVR7CwDW3aCTOppDFL+A8GDDMP+QDoY8hEsRprTlYZmGEf8a0owlRF7RUv
         /wj/CQOp3C0lm06Idb8KEZ0iGnnM7iKDZPjZFnES/44ryOaLCK88ItiZlVWnevCPVfUE
         /gWa1wMzA5PA0Mkfb/yFbDW5GRQuxe5JOYm+z9VLbAEONu7NQjnHwnhYD7KWIo+Yxayl
         J30UID2AU1aPhi3kNHkc5W2G3A69Q/6L9AICvXYyoClDUqRw+STNFkiFfTVbIP6bBvAM
         +TDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DC2JUNKZSOxMdfBfE8uIWKJNFczY8Th1lgyz9dOaayw=;
        b=xfe0sVCSHeliuXIteJywatvB4CVc1avNPRyPdPCmmJiSZOFvfuGPEtOM0Z2in8OrgY
         CiWbVW59XVKqIhXAJK90lBQLbT9Qau75H6ba5lDCrR58QAb5SnOGLp2ddND0iaxal3uG
         kWXEYoGMkE1dZMRjSVfSi8zvBrBMJZpc1jbuCZTELMkaKwU7/TZUVx8y76Knwzbf/XSM
         y2cIEKCVJZBw0Zkv8PNmifzVlNbUakkTY7PTTO7hHfW1O5mKsQf8mbZrHASmLGIIbILH
         eJf+VuiglXiVVy2wT5BPnv2uI8t2BsAD2kkCx8LYDzoiIFGsRGJ80r2hj/F3XUjGd9KV
         TMyg==
X-Gm-Message-State: AJIora/kDiEl8h7loQ9s6LE7NKFFMaVBDy8F5fenW31QwtFqCpW/3RBV
        6ncBbKYsWRdJTeHNrF7422+O5Q==
X-Google-Smtp-Source: AGRyM1tupCu9k+h+xFwgkDWdBqh0w3qrnO0TsgcoGPqoNhPjGp8dEp25eFc90vKUzzIt6WmyZpdNFw==
X-Received: by 2002:a5d:44d1:0:b0:21d:7471:2094 with SMTP id z17-20020a5d44d1000000b0021d74712094mr115868wrr.374.1658499536464;
        Fri, 22 Jul 2022 07:18:56 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id az28-20020a05600c601c00b003a325bd8517sm6379415wmb.5.2022.07.22.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 07:18:56 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     kvm@vger.kernel.org, suzuki.poulose@arm.com, sami.mujawar@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 3/4] virtio/pci: Deassert IRQ line on ISR read
Date:   Fri, 22 Jul 2022 15:17:31 +0100
Message-Id: <20220722141731.64039-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722141731.64039-1-jean-philippe@linaro.org>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 2108c86d0623 ("virtio/pci: Signal INTx interrupts as level
instead of edge"), virtio uses level-triggered IRQs. Bring the modern
device up to date, by deasserting the IRQ line when the guest reads the
interrupt status register.

Fixes: 3bf79498e6d5 ("virtio: Add support for modern virtio-pci")
Reported-by: Sami Mujawar <sami.mujawar@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/pci-modern.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
index 753e95bd..c5b4bc50 100644
--- a/virtio/pci-modern.c
+++ b/virtio/pci-modern.c
@@ -245,10 +245,7 @@ static bool virtio_pci__isr_read(struct virtio_device *vdev,
 		return false;
 
 	ioport__write8(data, vpci->isr);
-	/*
-	 * Interrupts are edge triggered (yes, going against the PCI and virtio
-	 * specs), so no need to deassert the IRQ line.
-	 */
+	kvm__irq_line(vpci->kvm, vpci->legacy_irq_line, VIRTIO_IRQ_LOW);
 	vpci->isr = 0;
 
 	return 0;
-- 
2.37.1

