Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE00797A9B
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245341AbjIGRrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjIGRra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:47:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E83C1BF2
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 10:47:10 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5365A139F;
        Thu,  7 Sep 2023 10:17:34 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB09D3F67D;
        Thu,  7 Sep 2023 10:16:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        andre.przywara@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        jean-philippe.brucker@arm.com, apatel@ventanamicro.com
Subject: [PATCH kvmtool 1/3] Revert "virtio-net: Don't print the compat warning for the default device"
Date:   Thu,  7 Sep 2023 18:16:53 +0100
Message-Id: <20230907171655.6996-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230907171655.6996-1-alexandru.elisei@arm.com>
References: <20230907171655.6996-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 15757e8e6441d83757c39046a6cdd3e4d74200ce.

Turns out there's a way to disable the default virtio-net device: pass
--network mode=none when running a VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virtio/net.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virtio/net.c b/virtio/net.c
index 77f7c9a7a788..f09dd0a48b53 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -847,7 +847,7 @@ done:
 	return 0;
 }
 
-static int virtio_net__init_one(struct virtio_net_params *params, bool suppress_compat)
+static int virtio_net__init_one(struct virtio_net_params *params)
 {
 	enum virtio_trans trans = params->kvm->cfg.virtio_transport;
 	struct net_dev *ndev;
@@ -913,7 +913,7 @@ static int virtio_net__init_one(struct virtio_net_params *params, bool suppress_
 	if (params->vhost)
 		virtio_net__vhost_init(params->kvm, ndev);
 
-	if (compat_id == -1 && !suppress_compat)
+	if (compat_id == -1)
 		compat_id = virtio_compat_add_message("virtio-net", "CONFIG_VIRTIO_NET");
 
 	return 0;
@@ -925,7 +925,7 @@ int virtio_net__init(struct kvm *kvm)
 
 	for (i = 0; i < kvm->cfg.num_net_devices; i++) {
 		kvm->cfg.net_params[i].kvm = kvm;
-		r = virtio_net__init_one(&kvm->cfg.net_params[i], false);
+		r = virtio_net__init_one(&kvm->cfg.net_params[i]);
 		if (r < 0)
 			goto cleanup;
 	}
@@ -943,7 +943,7 @@ int virtio_net__init(struct kvm *kvm)
 		str_to_mac(kvm->cfg.guest_mac, net_params.guest_mac);
 		str_to_mac(kvm->cfg.host_mac, net_params.host_mac);
 
-		r = virtio_net__init_one(&net_params, true);
+		r = virtio_net__init_one(&net_params);
 		if (r < 0)
 			goto cleanup;
 	}
-- 
2.42.0

