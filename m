Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF07264411F
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiLFKQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbiLFKPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:15:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C924EC66
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 02:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670321705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D8eK2l9TcYTFl3ywtkBaS3gkGap8zKHp2k6yv3JEzzE=;
        b=QbkuNhSXIBjXOr8u4alDXMRffXeWFsYv0fjOD5Xj/kgARy5pXDiIjbBsaKclZQywb5URkQ
        6QWtL9Jny2cfEi0SunGdyJV8pFza5Ar+jj+aQc+4gJ+UEje5HoPXo7oI6G4dEFW/PreMTS
        QvhUHujL+ajy/OP9lZ6Oh6RGByKs0WU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-dAxuecrZPPGnrxRo3TeoYQ-1; Tue, 06 Dec 2022 05:15:01 -0500
X-MC-Unique: dAxuecrZPPGnrxRo3TeoYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39037380390B;
        Tue,  6 Dec 2022 10:15:01 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2DAB1121333;
        Tue,  6 Dec 2022 10:14:59 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [kvm-unit-tests PATCH] powerpc: Fix running the kvm-unit-tests with recent versions of QEMU
Date:   Tue,  6 Dec 2022 11:14:55 +0100
Message-Id: <20221206101455.145258-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 powerpc/cstart64.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 972851f9..206c518f 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -23,6 +23,12 @@
 .globl start
 start:
 	FIXUP_ENDIAN
+	/* Switch to 64-bit mode */
+	mfmsr	r1
+	li	r2,1
+	sldi	r2,r2,63
+	or	r1,r1,r2
+	mtmsrd	r1
 	/*
 	 * We were loaded at QEMU's kernel load address, but we're not
 	 * allowed to link there due to how QEMU deals with linker VMAs,
-- 
2.31.1

