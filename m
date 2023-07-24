Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A703B75ECAD
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 09:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjGXHlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 03:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjGXHk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 03:40:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EB4180
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 00:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690184412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lI2MO6Jb3XyVogqmu+UMDZ8RMmOzM0JwpxQZPWVPeJU=;
        b=fojDfSe8v6/JQEK3wviF78gUFskShjbjp4d/Razq+GS2bA601S37YzM/NtfgkFbyOr9nvJ
        5RQDeVfHbMIBgFz2IbfLo+GgYXqPxCQWAh+85uKULLfbB0tEF5c4Fuz6RujnbgTcu8fGxq
        Ucr/cVRcv4VrQXhXDrQ7V7SknGoqdp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-AFWEylP-MbmUiWRLbT-jzw-1; Mon, 24 Jul 2023 03:40:08 -0400
X-MC-Unique: AFWEylP-MbmUiWRLbT-jzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24E07800B35;
        Mon, 24 Jul 2023 07:40:08 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17287200BA63;
        Mon, 24 Jul 2023 07:40:08 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     andrew.jones@linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] arm64: Define name for these bits used in SCTLR_EL1
Date:   Mon, 24 Jul 2023 03:39:48 -0400
Message-Id: <20230724073949.1297331-3-shahuang@redhat.com>
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

Currently some fields in SCTLR_EL1 don't define a name and directly used
in the SCTLR_EL1_RES1, that's not good now since these fields have been
functional and have a name.

Delete the SCTLR_EL1_RES1 since these bits are not RES1 if the related
feature has been implemented, it's wired to define these bits as RES1.
So simply delete the SCTLR_EL1_RES1 and unwind its definition to
INIT_SCTLR_MMU_OFF.

According to the ARM DDI 0487J.a, define the name related to these
fields.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm64/asm/sysreg.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 09ef5f5..6cae8b8 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -80,18 +80,26 @@ asm(
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
 /* System Control Register (SCTLR_EL1) bits */
+#define SCTLR_EL1_LSMAOE	_BITULL(29)
+#define SCTLR_EL1_NTLSMD	_BITULL(28)
 #define SCTLR_EL1_EE		_BITULL(25)
+#define SCTLR_EL1_SPAN		_BITULL(23)
+#define SCTLR_EL1_EIS		_BITULL(22)
+#define SCTLR_EL1_TSCXT		_BITULL(20)
 #define SCTLR_EL1_WXN		_BITULL(19)
 #define SCTLR_EL1_I		_BITULL(12)
+#define SCTLR_EL1_EOS		_BITULL(11)
+#define SCTLR_EL1_SED		_BITULL(8)
+#define SCTLR_EL1_ITD		_BITULL(7)
 #define SCTLR_EL1_SA0		_BITULL(4)
 #define SCTLR_EL1_SA		_BITULL(3)
 #define SCTLR_EL1_C		_BITULL(2)
 #define SCTLR_EL1_A		_BITULL(1)
 #define SCTLR_EL1_M		_BITULL(0)
 
-#define SCTLR_EL1_RES1	(_BITULL(7) | _BITULL(8) | _BITULL(11) | _BITULL(20) | \
-			 _BITULL(22) | _BITULL(23) | _BITULL(28) | _BITULL(29))
 #define INIT_SCTLR_EL1_MMU_OFF	\
-			SCTLR_EL1_RES1
+			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
+			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
+			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
 
 #endif /* _ASMARM64_SYSREG_H_ */
-- 
2.39.1

