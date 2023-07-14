Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD99C753ED9
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 17:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbjGNP32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 11:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbjGNP31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 11:29:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49E2C1BE3
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 08:29:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A3981570;
        Fri, 14 Jul 2023 08:30:08 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A8563F740;
        Fri, 14 Jul 2023 08:29:24 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: [PATCH kvmtool] virtio-net: Don't print the compat warning for the default device
Date:   Fri, 14 Jul 2023 16:29:09 +0100
Message-ID: <20230714152909.31723-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compat messages are there to print a warning when the user creates a virtio
device for the VM, but the guest doesn't initialize it.

This generally works great, except that kvmtool will always create a
virtio-net device, even if the user hasn't specified one, which means that
each time kvmtool loads a guest that doesn't probe the network interface,
the user will get the compat warning. This can get particularly annoying
when running kvm-unit-tests, which doesn't need to use a network interface,
and the virtio-net warning is displayed after each test.

Let's fix this by skipping the compat message in the case of the
automatically created virtio-net device. This lets kvmtool keep the compat
warnings as they are, but removes the false positive.

Even if the user is relying on kvmtool creating the default virtio-net
device, a missing network interface in the guest is very easy to
discover.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 virtio/net.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virtio/net.c b/virtio/net.c
index f09dd0a48b53..77f7c9a7a788 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -847,7 +847,7 @@ done:
 	return 0;
 }
 
-static int virtio_net__init_one(struct virtio_net_params *params)
+static int virtio_net__init_one(struct virtio_net_params *params, bool suppress_compat)
 {
 	enum virtio_trans trans = params->kvm->cfg.virtio_transport;
 	struct net_dev *ndev;
@@ -913,7 +913,7 @@ static int virtio_net__init_one(struct virtio_net_params *params)
 	if (params->vhost)
 		virtio_net__vhost_init(params->kvm, ndev);
 
-	if (compat_id == -1)
+	if (compat_id == -1 && !suppress_compat)
 		compat_id = virtio_compat_add_message("virtio-net", "CONFIG_VIRTIO_NET");
 
 	return 0;
@@ -925,7 +925,7 @@ int virtio_net__init(struct kvm *kvm)
 
 	for (i = 0; i < kvm->cfg.num_net_devices; i++) {
 		kvm->cfg.net_params[i].kvm = kvm;
-		r = virtio_net__init_one(&kvm->cfg.net_params[i]);
+		r = virtio_net__init_one(&kvm->cfg.net_params[i], false);
 		if (r < 0)
 			goto cleanup;
 	}
@@ -943,7 +943,7 @@ int virtio_net__init(struct kvm *kvm)
 		str_to_mac(kvm->cfg.guest_mac, net_params.guest_mac);
 		str_to_mac(kvm->cfg.host_mac, net_params.host_mac);
 
-		r = virtio_net__init_one(&net_params);
+		r = virtio_net__init_one(&net_params, true);
 		if (r < 0)
 			goto cleanup;
 	}
-- 
2.41.0

