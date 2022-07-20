Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A090257B3BC
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbiGTJXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbiGTJXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:23:34 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCFF47B8F
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:23:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658309012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5u8DxIika5auOHjv8RJ4zXtJxgJNuu8JJNcDfBvM/Co=;
        b=AISP9bfyTaD0EEPg3wUfzkTXLi0uk2hNeSJ0am8kEJ2jdP7gMEWwYzKq8FdvVnV3BvQDZV
        tnhrXjnF+2/BGfzdEVSWerimoZqiJSgGWFyhId1kKqHVgtZsyeBJnhcDu0HvTK3JEl1AeI
        549SEDa9nbV+e5W/Mk7eYd0RUqFfZ9U=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v3 6/6] KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)
Date:   Wed, 20 Jul 2022 09:22:52 +0000
Message-Id: <20220720092259.3491733-7-oliver.upton@linux.dev>
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

Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
author of this commit remains bitter for having been burned by the old
wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
outside of the VM directory").

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 609f49a133f8..7ac60f75cfa1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1032,6 +1032,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
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
 
@@ -1154,12 +1160,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
-	/*
-	 * Force subsequent debugfs file creations to fail if the VM directory
-	 * is not created (by kvm_create_vm_debugfs()).
-	 */
-	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
-
 	snprintf(kvm->stats_id, sizeof(kvm->stats_id), "kvm-%d",
 		 task_pid_nr(current));
 
-- 
2.37.0.170.g444d1eabd0-goog

