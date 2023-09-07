Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3AA797A01
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243575AbjIGR2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 13:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244661AbjIGR2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 13:28:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB3E71BF7
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 10:27:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01FBF153B;
        Thu,  7 Sep 2023 10:17:38 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78BBC3F67D;
        Thu,  7 Sep 2023 10:16:58 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        andre.przywara@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        jean-philippe.brucker@arm.com, apatel@ventanamicro.com
Subject: [PATCH RFC kvmtool 3/3] builtin-run: Have --nodefaults disable the default virtio-net device
Date:   Thu,  7 Sep 2023 18:16:55 +0100
Message-Id: <20230907171655.6996-4-alexandru.elisei@arm.com>
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

Knowing which configuration options can only be disabled via --nodefaults
requires the user to have knowlegde of the code. Asking that from someone
who just wants to run a VM isn't completely fair, so just change what
--nodefaults does to disable all the configuration that kvmtool does
without being explicitely instructed to do so.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

I'm not 100% sure about this one, when first looking at this it was
surprising to me that --nodefaults doesn't disable all the defaults (and I
was the one that added the command line parameter!), but I don't if
we should be changing the semantics of a command line parameter. So this is
more for people to talk it over.

Also, if we're changing what --nodefaults does, did I miss other default
behaviour that the option should be disabling?

 builtin-run.c | 3 +--
 virtio/net.c  | 3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index c26184ea7fc0..50f1ae02f8f9 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -207,8 +207,7 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
 	OPT_BOOLEAN('\0', "rng", &(cfg)->virtio_rng, "Enable virtio"	\
 			" Random Number Generator"),			\
 	OPT_BOOLEAN('\0', "nodefaults", &(cfg)->nodefaults, "Disable"   \
-			" implicit configuration that cannot be"	\
-			" disabled otherwise"),				\
+			" implicit configuration options"),		\
 	OPT_CALLBACK('\0', "9p", NULL, "dir_to_share,tag_name",		\
 		     "Enable virtio 9p to share files between host and"	\
 		     " guest", virtio_9p_rootdir_parser, kvm),		\
diff --git a/virtio/net.c b/virtio/net.c
index f09dd0a48b53..651344bd7710 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -930,7 +930,8 @@ int virtio_net__init(struct kvm *kvm)
 			goto cleanup;
 	}
 
-	if (kvm->cfg.num_net_devices == 0 && kvm->cfg.no_net == 0) {
+	if (kvm->cfg.num_net_devices == 0 && kvm->cfg.no_net == 0 &&
+	    !kvm->cfg.nodefaults) {
 		static struct virtio_net_params net_params;
 
 		net_params = (struct virtio_net_params) {
-- 
2.42.0

