Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272B9532CEB
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiEXPGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiEXPGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:06:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC51C63DF
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:06:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 692571042;
        Tue, 24 May 2022 08:06:21 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 047B23F70D;
        Tue, 24 May 2022 08:06:19 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Keir Fraser <keirf@google.com>
Subject: [PATCH kvmtool 2/4] util: include virtio UAPI headers in sync
Date:   Tue, 24 May 2022 16:06:09 +0100
Message-Id: <20220524150611.523910-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524150611.523910-1-andre.przywara@arm.com>
References: <20220524150611.523910-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have an update_headers.sh sync script, where we occasionally
update the KVM interface UAPI kernel headers into our tree.
So far this covered only the generic kvm.h, plus each architecture's
version of that file.
Commit  bc77bf49df6e ("stat: Add descriptions for new virtio_balloon
stat types") used newer virtio symbols, which some older distros do not
include in their kernel headers package. To help fixing this and to
avoid similar problems in the future, add the virtio headers to our sync
script, so that we can get the same, up-to-date versions of the headers
easily.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 util/update_headers.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 5f9cd32d..789e2a42 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -9,6 +9,11 @@
 
 set -ue
 
+VIRTIO_LIST="virtio_9p.h virtio_balloon.h virtio_blk.h virtio_config.h \
+	     virtio_console.h virtio_ids.h virtio_mmio.h virtio_net.h \
+	     virtio_pci.h virtio_ring.h virtio_rng.h virtio_scsi.h \
+	     virtio_vsock.h"
+
 if [ "$#" -ge 1 ]
 then
 	LINUX_ROOT="$1"
@@ -25,6 +30,11 @@ fi
 
 cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
 
+for header in $VIRTIO_LIST
+do
+	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
+done
+
 unset KVMTOOL_PATH
 
 copy_optional_arch () {
-- 
2.25.1

