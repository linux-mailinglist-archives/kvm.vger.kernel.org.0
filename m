Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B5C4D95D8
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 09:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345754AbiCOIDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 04:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345807AbiCOIDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 04:03:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 618D94BBAF
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647331319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/tURFiAb+syl9b/OzqHzCooVvPgsFgRn6oKitexyDEY=;
        b=cjh6l3hkWS+EBISwdGuPW9aDlLmOLYi19eW0yH71a8LAzQCAhAIfInkhlJpmSwSMMQT0v4
        Uscehq/lQBSLBGM8o+6IQN21u0PHtagLiU4HXY/8AE0N8Qd3nVeTLkyzGsR8kUORjFrkFX
        PNjIBgOAgSkNgFiGSKc6/Y8MADkEICA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-2ZY7at7tOja_bAXmSqGo3w-1; Tue, 15 Mar 2022 04:01:56 -0400
X-MC-Unique: 2ZY7at7tOja_bAXmSqGo3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E33C81C05AFA;
        Tue, 15 Mar 2022 08:01:55 +0000 (UTC)
Received: from gator.home (unknown [10.40.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B0F32156A2E;
        Tue, 15 Mar 2022 08:01:53 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, thuth@redhat.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Date:   Tue, 15 Mar 2022 09:01:52 +0100
Message-Id: <20220315080152.224606-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add QEMU_ARCH, which allows run scripts to specify which architecture
of QEMU should be used. This is useful on AArch64 when running with
KVM and running AArch32 tests. For those tests, we *don't* want to
select the 'arm' QEMU, as would have been selected, but rather the
$HOST ('aarch64') QEMU.

To use this new variable, simply ensure it's set prior to calling
search_qemu_binary().

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/run               | 4 ++++
 scripts/arch-run.bash | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arm/run b/arm/run
index 0629b69a117c..28a0b4ad2729 100755
--- a/arm/run
+++ b/arm/run
@@ -13,6 +13,10 @@ processor="$PROCESSOR"
 ACCEL=$(get_qemu_accelerator) ||
 	exit $?
 
+if [ "$ACCEL" = "kvm" ]; then
+	QEMU_ARCH=$HOST
+fi
+
 qemu=$(search_qemu_binary) ||
 	exit $?
 
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index aae552321f9b..0dfaf017db0a 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -176,8 +176,10 @@ search_qemu_binary ()
 	local save_path=$PATH
 	local qemucmd qemu
 
+	: "${QEMU_ARCH:=$ARCH_NAME}"
+
 	export PATH=$PATH:/usr/libexec
-	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
+	for qemucmd in ${QEMU:-qemu-system-$QEMU_ARCH qemu-kvm}; do
 		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
 			qemu="$qemucmd"
 			break
-- 
2.34.1

