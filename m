Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A56A9013
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 05:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjCCEL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 23:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCELx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 23:11:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5936166D9
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 20:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677816669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ofXBqMRFaLDwBIweNpr/a3sSGv/P/h/HGrL9mEZalZg=;
        b=XvK6lYv7Ph77rd7xkoKesEzE8HQXthFVrZsrwZt4S/8LAIMtu1UicS0gQxzQNBUTtDZC6p
        pf5jPP4UW7DHqWqy3DvetRyW6vHKqsQLYpYwGdBH8pMlokyBCk2SLtSKwyE9V/bjHxueYZ
        +bQi2mRymB9tIxkMsF2KxlFuUHd5mSw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-nAljj7KEOsaFQVN2pvPqeQ-1; Thu, 02 Mar 2023 23:11:01 -0500
X-MC-Unique: nAljj7KEOsaFQVN2pvPqeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7A79830F82;
        Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1634140EBF6;
        Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] arm: Clean up the run script
Date:   Thu,  2 Mar 2023 23:10:52 -0500
Message-Id: <20230303041052.176745-3-shahuang@redhat.com>
In-Reply-To: <20230303041052.176745-1-shahuang@redhat.com>
References: <20230303041052.176745-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using more simple bash command to clean up the run script.

No functional change intended.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/run | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/run b/arm/run
index b918029..c6f25b8 100755
--- a/arm/run
+++ b/arm/run
@@ -28,7 +28,7 @@ fi
 
 ACCEL=$accel
 
-if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
+if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
 	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
 	exit 2
 fi
@@ -36,7 +36,7 @@ fi
 M='-machine virt'
 
 if [ "$ACCEL" = "kvm" ]; then
-	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
+	if $qemu $M,\? | grep -q gic-version; then
 		M+=',gic-version=host'
 	fi
 fi
@@ -54,7 +54,7 @@ if [ "$ARCH" = "arm" ]; then
 	M+=",highmem=off"
 fi
 
-if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
+if ! $qemu $M -device '?' | grep -q virtconsole; then
 	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 	exit 2
 fi
@@ -68,7 +68,7 @@ chr_testdev='-device virtio-serial-device'
 chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
 
 pci_testdev=
-if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
+if $qemu $M -device '?' | grep -q pci-testdev; then
 	pci_testdev="-device pci-testdev"
 fi
 
-- 
2.39.1

