Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9B4CC9DE
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiCCXMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiCCXM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:12:27 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F8BD2049
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:11:41 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f37so11094004lfv.8
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G+87czJa6aV4ZsER8NAEBqnFkLNa4ZkruoEuT99d2No=;
        b=VvwuyAkSkJxcEyLNOfmF+9VP8WkRqR+f+HghzIAhRtcQg/38rJsxIY/90Qcppr6xVH
         rYX9vIKzrEn3C1CJDTb50wQhgIk9HkUlOzAy6cqcOJ08yOF9j9CaxiASU+LKSivbqGP+
         H/kOpSNJdf+AkMQaLSpYUHfHASYjK4qOt65swzr8j5ZoicTPPKMOkukCoU4rOEonnj9O
         f6BNEWUcEvQoSk7lrUGkwUuIfxlvIijFV/qBFEI352qthCDu9xUuFVQ0wmCQryN0N8P6
         iCWOx6jrUO3c/HCczJy1MOeaRRZ6igAKNgcQ9DNMaaSeQZaMJ5OM23lcm6AvSONXShvV
         +OoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G+87czJa6aV4ZsER8NAEBqnFkLNa4ZkruoEuT99d2No=;
        b=v5UVv3udfkKNdnEF8zfS0wXlqNXIRdE4lmeoTwrAIFOWnA+a9vjEFI7xTx94fk+QvX
         N5XsOKcsWzZsgTZkBVUuJW/nKFPALK3YaQgF5aBXjVbVWRaFRgN9Xaz9nLtf4M7bRoVB
         QoNvC69a5E9GZIcdrXctZvmIBvAUVH2GjNZ4hmTa8JfJGWQTj32EpSzMdURqM5Dcxkit
         DLw9rrF3IBSjYINwGS2BfdYkunpYTCrzP1wGro5HMONtnSKep0d9aPEzhh2UNsBzWWOc
         lWAph/6oYrSCewIgAOyXmg9vlp/OwuYobRK8NgQpqUM5SE7ao7iCdXPTilFlJgEsBPKw
         HK3g==
X-Gm-Message-State: AOAM5304657P0h42z+ILbnkyVjbyjfeHSMRd3B8sAztvfTjU82g9/d6K
        j2FTmGa7/kI/W/RvFKEVFYz3ljsiRK0=
X-Google-Smtp-Source: ABdhPJxmcyI+tG2pu4BPghHmI9ZcG75ngkoiCU9AeXi6PQyv6LCA7/cJ1yyt89KKCQ2QuHG9l3JeSg==
X-Received: by 2002:a05:6512:4022:b0:445:65c8:2b2f with SMTP id br34-20020a056512402200b0044565c82b2fmr22885323lfb.366.1646349099237;
        Thu, 03 Mar 2022 15:11:39 -0800 (PST)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id g13-20020a2ea4ad000000b0023382d8819esm725264ljm.69.2022.03.03.15.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:11:38 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Cc:     Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Date:   Fri,  4 Mar 2022 01:10:50 +0200
Message-Id: <20220303231050.2146621-6-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303231050.2146621-1-martin.b.radev@gmail.com>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
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

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 mmio.c | 4 ++++
 1 file changed, 4 insertions(+)

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
-- 
2.25.1

