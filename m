Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965A06441DC
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 12:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiLFLJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 06:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiLFLJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 06:09:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934CD22B14
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 03:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670324940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H502nmi1sOIOQOURTv4B1Hn859XzXZDjna8dvAjwxcU=;
        b=MtR5O1H5qZzxrU10Lr4sgJpNN44uStGmWI391OCb3sxxuJQxnvW5QK2rbSotWa5yfMlRCn
        9gOCxx011zpZMewW8oJPexDn5SYFxqWwbSXjJeui21/xNxrrRDi/5hpRbxb57KNwbXa72+
        06mnSB+uNzrs0H6dHJP17fNXmnoVAJY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-YnxxbR8SNgGdwo6Q6XNw6A-1; Tue, 06 Dec 2022 06:08:57 -0500
X-MC-Unique: YnxxbR8SNgGdwo6Q6XNw6A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 179702999B5A;
        Tue,  6 Dec 2022 11:08:57 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBD4C492B07;
        Tue,  6 Dec 2022 11:08:55 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [kvm-unit-tests v2 PATCH] powerpc: Fix running the kvm-unit-tests with recent versions of QEMU
Date:   Tue,  6 Dec 2022 12:08:51 +0100
Message-Id: <20221206110851.154297-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting with version 7.0, QEMU starts the pseries guests in 32-bit mode
instead of 64-bit (see QEMU commit 6e3f09c28a - "spapr: Force 32bit when
resetting a core"). This causes our test_64bit() in powerpc/emulator.c
to fail. Let's switch to 64-bit in our startup code instead to fix the
issue.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/powerpc/asm/ppc_asm.h | 3 +++
 powerpc/cstart64.S        | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 39620a39..1b85f6bb 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -35,4 +35,7 @@
 
 #endif /* __BYTE_ORDER__ */
 
+/* Machine State Register definitions: */
+#define MSR_SF_BIT	63			/* 64-bit mode */
+
 #endif /* _ASMPOWERPC_PPC_ASM_H */
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 972851f9..34e39341 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -23,6 +23,12 @@
 .globl start
 start:
 	FIXUP_ENDIAN
+	/* Switch to 64-bit mode */
+	mfmsr	r1
+	li	r2,1
+	sldi	r2,r2,MSR_SF_BIT
+	or	r1,r1,r2
+	mtmsrd	r1
 	/*
 	 * We were loaded at QEMU's kernel load address, but we're not
 	 * allowed to link there due to how QEMU deals with linker VMAs,
-- 
2.31.1

