Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7934F1BD9
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379687AbiDDVUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379927AbiDDSXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:23:25 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E4B22B37
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:21:29 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id h14-20020a05660208ce00b00645c339411bso6837789ioz.8
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9C6w1rezdQTRbXbtrJY1SOnX+wuE5x8FHrvORNXkiH4=;
        b=ntCvfuIdi9xMnMJP+WEKYAhtFIzNV0vgJkusexYCHVXmFsHxjRL0ss7NhSk+fRH55U
         IOVUf2f/dRvRvNUW8QStwvlNrurraZnMphm1VQ5851zbUGzrqT8d4cFxbhOP8vn/G+8w
         fYDJB9Rxyhu+dtkt733HYqDqzN0cNBBuG/RDzaBHjtz1lf8He19cAQunaA+tgo0ZkWqj
         nHmF5lg/twg67wMwdeQKzJW2OZCiSL+/Gp9K+7ik47gg7kTJlOLrCUwmO42RVRKax3/6
         WKnNSA2mnNTHeyQVF4+axB8WRxkGTfeRQFfs7yonAUtqLzbwxah4SnDga35oAG2BGmbE
         8fKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9C6w1rezdQTRbXbtrJY1SOnX+wuE5x8FHrvORNXkiH4=;
        b=k7pwygE+2f+mHP9aNVW6e362bgCFY+sQ8CnmJpmPUm7XMhmE3RNEUjRvw1sRHNb3Q9
         evDxnRc/7QCbmaIh0Wzo3smQ1x21xPCXq27GQ81RDPCV0SmdQrAtDrRNgeZNIb962VPd
         o6dR2TGKSsLT7X6axNGqW2m53iNCGpr5CdSBGluOwAM8oIHMdtSIDJM8gB8iP+y663fn
         JO/I0jOeNeUf5SQIN5frAn8xNsj0tUmiZ83paskuGGr0YY5s82TByeFJqOAh3kc5XJFC
         aY03QKvTxThx7d4S5DugC7xtMePC/Wg0veBl1mlZrov+pbIFIYxgzLlActpj77pSzAxB
         xvAw==
X-Gm-Message-State: AOAM532RAQFlp9ZEty3P9xhHB59U4K4ON1dbzgxjwyXUxnf9LXLnOM6W
        XE4vsTM4jp/V8urnb86f47V3ts9IWbk=
X-Google-Smtp-Source: ABdhPJw742AYzEqFaE6euki5t9MMfZCGGI9PjjeQy1BTQ6eXyn3wAYraEjyHb6JW9iO7D2ml2hNsob2+TpA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:17ca:b0:2ca:42d8:81d with SMTP id
 z10-20020a056e0217ca00b002ca42d8081dmr510403ilu.249.1649096488828; Mon, 04
 Apr 2022 11:21:28 -0700 (PDT)
Date:   Mon,  4 Apr 2022 18:21:17 +0000
In-Reply-To: <20220404182119.3561025-1-oupton@google.com>
Message-Id: <20220404182119.3561025-2-oupton@google.com>
Mime-Version: 1.0
References: <20220404182119.3561025-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 1/3] KVM: Don't create VM debugfs files outside of the VM directory
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unfortunately, there is no guarantee that KVM was able to instantiate a
debugfs directory for a particular VM. To that end, KVM shouldn't even
attempt to create new debugfs files in this case. If the specified
parent dentry is NULL, debugfs_create_file() will instantiate files at
the root of debugfs.

For arm64, it is possible to create the vgic-state file outside of a
VM directory, the file is not cleaned up when a VM is destroyed.
Nonetheless, the corresponding struct kvm is freed when the VM is
destroyed.

Nip the problem in the bud for all possible errant debugfs file
creations by initializing kvm->debugfs_dentry to -ENOENT. In so doing,
debugfs_create_file() will fail instead of creating the file in the root
directory.

Cc: stable@kernel.org
Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..04a426e65cb8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -932,7 +932,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	if (!kvm->debugfs_dentry)
+	if (!IS_ERR(kvm->debugfs_dentry))
 		return;
 
 	debugfs_remove_recursive(kvm->debugfs_dentry);
@@ -955,6 +955,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created.
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (!debugfs_initialized())
 		return 0;
 
@@ -5479,7 +5485,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (kvm->debugfs_dentry) {
+	if (!IS_ERR(kvm->debugfs_dentry)) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {
-- 
2.35.1.1094.g7c7d902a7c-goog

