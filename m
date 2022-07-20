Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2481B57B3BB
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbiGTJXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbiGTJXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:23:36 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D065447BA1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:23:35 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658309014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x9H1B0qp5vV2SXCFJBDuseXpKkjoj0nJpiEMWlXy/Qk=;
        b=WRqXdu5bYrPkFxW0Gvk9tWp5xP/WkwoGkM+snufGlZ0zijt5RPWEtbyWLSk0hV7oA9/Utp
        KXCxcvnCIdfManuQZQkHCBgMGARefJwRtdDU4yVDUyfjQrWXtWJVi2mHotFJVv9zR4HdJs
        WZpoD/9TWRF6o9vR3KJNkfJB9gu9J9Y=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v3 1/6] KVM: Shove vm stats_id init into kvm_create_vm()
Date:   Wed, 20 Jul 2022 09:22:54 +0000
Message-Id: <20220720092259.3491733-9-oliver.upton@linux.dev>
In-Reply-To: <20220720092259.3491733-1-oliver.upton@linux.dev>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

Initialize stats_id alongside the other struct kvm fields to futureproof
against possible initialization order mistakes in KVM. While at it, move
the format string to the first line of the call and fix the indentation
of the second line.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index da263c370d00..cc760ebcd390 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1155,6 +1155,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	 */
 	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
 
+	snprintf(kvm->stats_id, sizeof(kvm->stats_id), "kvm-%d",
+		 task_pid_nr(current));
+
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
@@ -4902,9 +4905,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (r < 0)
 		goto put_kvm;
 
-	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
-			"kvm-%d", task_pid_nr(current));
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
 		put_unused_fd(r);
-- 
2.37.0.170.g444d1eabd0-goog

