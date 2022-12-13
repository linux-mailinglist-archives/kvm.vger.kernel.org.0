Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BB464B0B4
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 09:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiLMICw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 03:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiLMICp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 03:02:45 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D6DB1128;
        Tue, 13 Dec 2022 00:02:42 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 173ED1E80D9B;
        Tue, 13 Dec 2022 15:58:03 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rfiRxksORkZZ; Tue, 13 Dec 2022 15:58:00 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 25CDF1E80D56;
        Tue, 13 Dec 2022 15:58:00 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] kvm: kvm_main: Remove unnecessary (void*) conversions
Date:   Tue, 13 Dec 2022 16:02:36 +0800
Message-Id: <20221213080236.3969-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

void * pointer assignment does not require a forced replacement.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 virt/kvm/kvm_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fab4d3790578..1682b269ad4a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3861,7 +3861,7 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
 static int vcpu_get_pid(void *data, u64 *val)
 {
-	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	struct kvm_vcpu *vcpu = data;
 	*val = pid_nr(rcu_access_pointer(vcpu->pid));
 	return 0;
 }
@@ -5445,8 +5445,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 			   const char *fmt)
 {
 	int ret;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
-					  inode->i_private;
+	struct kvm_stat_data *stat_data = inode->i_private;
 
 	/*
 	 * The debugfs files are a reference to the kvm struct which
@@ -5467,8 +5466,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 
 static int kvm_debugfs_release(struct inode *inode, struct file *file)
 {
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
-					  inode->i_private;
+	struct kvm_stat_data *stat_data = inode->i_private;
 
 	simple_attr_release(inode, file);
 	kvm_put_kvm(stat_data->kvm);
@@ -5517,7 +5515,7 @@ static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
 static int kvm_stat_data_get(void *data, u64 *val)
 {
 	int r = -EFAULT;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
+	struct kvm_stat_data *stat_data = data;
 
 	switch (stat_data->kind) {
 	case KVM_STAT_VM:
@@ -5536,7 +5534,7 @@ static int kvm_stat_data_get(void *data, u64 *val)
 static int kvm_stat_data_clear(void *data, u64 val)
 {
 	int r = -EFAULT;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
+	struct kvm_stat_data *stat_data = data;
 
 	if (val)
 		return -EINVAL;
-- 
2.18.2

