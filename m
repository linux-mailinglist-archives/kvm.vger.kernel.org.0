Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457244F6EDE
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbiDFX6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiDFX6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:58:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B5EBF331
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:56:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso2951066ybs.20
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UE8U10PWA5ODRXn2/uykVggaoFMEeuBNkjbyKzrUnCc=;
        b=StweytVoVyZbt90ESUuB2VGZmpz69UiQywLFR+/3fhQYHNUTdQZloEgP4cirg0Kkhd
         ureLULbzCXKzEuVeyccV7zNNedLEQpO4ayhcybXsVmgxDbgKCBrnsMt4KcoGFXliCiDL
         p0yS3x603eqH2cuF0Jfgeumy6ZZXE4/Odao00WPCwWYzuYVheUOvU/y7PhYbkklz5J8P
         spP+ZBEnX4drhVit+1wCy6T9N9UoRJEFMu/pj0F3D0FqfNpLHeAMKkavfelwlloXm8Ki
         mtOpj9fHSSXtZbEZUujQ5kBOBV5TtTSNk278FllAny6hV6Rytjamf7Z1WSwRNnqUdxFb
         gBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UE8U10PWA5ODRXn2/uykVggaoFMEeuBNkjbyKzrUnCc=;
        b=kYEin2Jb2Uq8N+OpkdmJHyHAZkMAcwXsRO0jMDpk4wce/aL40Vf3BfEc5Dg3zydpaa
         +hSXY+6cMihRXWYT+pzBZO79epFBCQ/BFSD6O6Q0NtBqOsGTxup/93+H9oBiGGmOWb6e
         TASj23nd30V0oIAt9cLQC7v04qAQOM36HDUY+cbp6CzAJ9WOdBxezkVQQ8Lq/vofo/0j
         U82liy0NBIo6tMGd28fgSoB6LD0aLg/R2VSM64eRHOV9pnYxxYAYT9inwq145uU8hJ4S
         lMUhrG+CqdN0Llkdo2EvZcUyznFmiOe6eHDAarVXsKqWU8OIWmpS7Xkek69EcNt/4zC/
         B6aA==
X-Gm-Message-State: AOAM532dXlTeSLg4M/OnYu5MVu6aEqUwTQdbjOG52qELMUEwqAUMxAmA
        WfQl4yYhba0+C7E29kihXMhItY/ybj8=
X-Google-Smtp-Source: ABdhPJydvJQ9YWsazIPz0K7K9LDxhja6MJh+d1QgvhsxpSx1I3YpvuashAMC5XHLhA33/FRzcSzrmPBE1A8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:100e:b0:637:7536:6582 with SMTP id
 w14-20020a056902100e00b0063775366582mr8357978ybt.355.1649289383593; Wed, 06
 Apr 2022 16:56:23 -0700 (PDT)
Date:   Wed,  6 Apr 2022 23:56:13 +0000
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
Message-Id: <20220406235615.1447180-2-oupton@google.com>
Mime-Version: 1.0
References: <20220406235615.1447180-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 1/3] KVM: Don't create VM debugfs files outside of the VM directory
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
index 70e05af5ebea..e39a6f56fc47 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -932,7 +932,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	if (!kvm->debugfs_dentry)
+	if (IS_ERR(kvm->debugfs_dentry))
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

