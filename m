Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F9C7371BB
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjFTQef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjFTQeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:34:18 -0400
Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AE91991
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 09:34:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687278853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mvp/mFxFyvb35RdjE1h0fvpetbuou1NsaTCoVuUvxG8=;
        b=TdaNnNgwfsuCGKVZ62YRSHUk7cvlUwaCf5SaahkFa5BWeKEW5smsJzxp41ve7FOiqiBsCw
        TpmHh9EUQAty37LvsNmeigvXbPUpWKskS1fGAuJSxeaU+lFJbA9gzDDxCgKGJlR3lZFCZN
        8CFLl009CYrchadYthK77dFjgdDAL5s=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 01/20] update_headers: Use a list for arch-generic headers
Date:   Tue, 20 Jun 2023 11:33:34 -0500
Message-ID: <20230620163353.2688567-2-oliver.upton@linux.dev>
In-Reply-To: <20230620163353.2688567-1-oliver.upton@linux.dev>
References: <20230620163353.2688567-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until now, all of the virtio header names are stuffed in a list and
iteratively copied from the kernel directory. Repurpose this as a list
of arch-generic headers, adding kvm.h to the bunch.

While at it, spread out the definition to have a single element per
line, making it easier to insert elements alphabetically in the future.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 util/update_headers.sh | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 789e2a4..4c1be7e 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -9,10 +9,20 @@
 
 set -ue
 
-VIRTIO_LIST="virtio_9p.h virtio_balloon.h virtio_blk.h virtio_config.h \
-	     virtio_console.h virtio_ids.h virtio_mmio.h virtio_net.h \
-	     virtio_pci.h virtio_ring.h virtio_rng.h virtio_scsi.h \
-	     virtio_vsock.h"
+GENERIC_LIST="kvm.h \
+	      virtio_9p.h \
+	      virtio_balloon.h \
+	      virtio_blk.h \
+	      virtio_config.h \
+	      virtio_console.h \
+	      virtio_ids.h \
+	      virtio_mmio.h \
+	      virtio_net.h \
+	      virtio_pci.h \
+	      virtio_ring.h \
+	      virtio_rng.h \
+	      virtio_scsi.h \
+	      virtio_vsock.h"
 
 if [ "$#" -ge 1 ]
 then
@@ -28,9 +38,7 @@ then
 	exit 1
 fi
 
-cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
-
-for header in $VIRTIO_LIST
+for header in $GENERIC_LIST
 do
 	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
 done
-- 
2.41.0.162.gfafddb0af9-goog

