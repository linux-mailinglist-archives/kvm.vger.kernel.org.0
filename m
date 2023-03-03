Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1492B6A9012
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 05:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjCCELv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 23:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCELt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 23:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6852615CB7
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 20:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677816668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQDG9bBnmtTidc0/cVUSCHHDYfaWH9vQxXRTGpMW+rY=;
        b=asLxugIfOJbx5+F/aIzxpvNdQm6n6KLztWxb4u1db2DJ1wTrBDDoNRWqdZTfcvxrT3wFhW
        X/+yU/uPqxqqg3rYPYU5j92xw7lfOO9i/uKRVJFSsCBtstCGxGTZFmx4hXq4Or64xh5p3R
        OsAtg+LdcFgsVKpFVgHNxWAodWOpPW8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-estBNyw-NWCdXU_GC3avMg-1; Thu, 02 Mar 2023 23:11:00 -0500
X-MC-Unique: estBNyw-NWCdXU_GC3avMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9275C101A52E;
        Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE2A140EBF6;
        Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/2] arm: Replace the obsolete qemu script
Date:   Thu,  2 Mar 2023 23:10:51 -0500
Message-Id: <20230303041052.176745-2-shahuang@redhat.com>
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

The qemu script used to detect the testdev is obsoleted, replace it
with the modern way to detect if testdev exists which was first
introduced at QEMU v2.7.50 by:
517b3d4016 (chardev: Add 'help' option to print all available chardev backend types).

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/run | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index 1284891..b918029 100755
--- a/arm/run
+++ b/arm/run
@@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
 	exit 2
 fi
 
-if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
-		| grep backend > /dev/null; then
+if ! $qemu $M -chardev '?' | grep -q testdev; then
 	echo "$qemu doesn't support chr-testdev. Exiting."
 	exit 2
 fi
-- 
2.39.1

