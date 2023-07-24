Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBD75ECAC
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 09:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjGXHlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 03:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjGXHk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 03:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E76185
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 00:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690184412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srOmzIHLYH7sG4fdwIUEFzHAKc6dDK0gB0lU9LxMWn0=;
        b=CfZobVb8QVSBJJaKQP4yye1bbFUqg3es7IhhbI6ECAsL/OmBQwHWbysRHoLkZ3YRuykrS6
        I7B/bJseDhX5wKRI/fjjs3Qa/XhaQI7yK6F2G3YgQ3LvGqkOxfICoHaQG0zie4qtUkZHCJ
        0H9IF/1F1IlFZFfMynY0EdXJOR+xURQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-7P2_INjIPbqXTpEogdE6ZQ-1; Mon, 24 Jul 2023 03:40:08 -0400
X-MC-Unique: 7P2_INjIPbqXTpEogdE6ZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3D0E3801BEA;
        Mon, 24 Jul 2023 07:40:07 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4E2B200BA63;
        Mon, 24 Jul 2023 07:40:07 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     andrew.jones@linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/2] arm64: Use _BITULL() to define SCTLR_EL1 bit fields
Date:   Mon, 24 Jul 2023 03:39:47 -0400
Message-Id: <20230724073949.1297331-2-shahuang@redhat.com>
In-Reply-To: <20230724073949.1297331-1-shahuang@redhat.com>
References: <20230724073949.1297331-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the SCTLR_EL1_* is defined by (1 << x), all of them can be
replaced by the _BITULL() macro to make the format consistent with the
SCTLR_EL1_RES1 definition.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm64/asm/sysreg.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 18c4ed3..09ef5f5 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -80,17 +80,17 @@ asm(
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
 /* System Control Register (SCTLR_EL1) bits */
-#define SCTLR_EL1_EE	(1 << 25)
-#define SCTLR_EL1_WXN	(1 << 19)
-#define SCTLR_EL1_I	(1 << 12)
-#define SCTLR_EL1_SA0	(1 << 4)
-#define SCTLR_EL1_SA	(1 << 3)
-#define SCTLR_EL1_C	(1 << 2)
-#define SCTLR_EL1_A	(1 << 1)
-#define SCTLR_EL1_M	(1 << 0)
-
-#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
-			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
+#define SCTLR_EL1_EE		_BITULL(25)
+#define SCTLR_EL1_WXN		_BITULL(19)
+#define SCTLR_EL1_I		_BITULL(12)
+#define SCTLR_EL1_SA0		_BITULL(4)
+#define SCTLR_EL1_SA		_BITULL(3)
+#define SCTLR_EL1_C		_BITULL(2)
+#define SCTLR_EL1_A		_BITULL(1)
+#define SCTLR_EL1_M		_BITULL(0)
+
+#define SCTLR_EL1_RES1	(_BITULL(7) | _BITULL(8) | _BITULL(11) | _BITULL(20) | \
+			 _BITULL(22) | _BITULL(23) | _BITULL(28) | _BITULL(29))
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			SCTLR_EL1_RES1
 
-- 
2.39.1

