Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC37B610250
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbiJ0UD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiJ0UDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:03:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A446495CD
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:03:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36fde8f2cdcso23269247b3.23
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b3K11rzBWUrVKqwdCSRAQP1ffARxvzU99Wf31co2VLM=;
        b=cw9ojMxMLNa7IyHdxeknDZVaOvYohozTGlU/Tq7jBM+1jHcVKBYCaOCaFrBBYSPkQ2
         k8z0bwhGTQoC2OQN7HhZYAkwI9hkP5wi83cKvDVuUlP99GfRps/6pxHS5IyJ/V7k3Vxl
         AxW1hjjnji1lzbeMN0dVr464+QDiFoQLbWUyqigM2c5JhYKEQlD/bh/z3EyOfyUl88sf
         lTePeQb0B5E6kvEeYzZFie6v1dt5HPbr1kvcbweqcZ+LKytTU9EVLcY5NXf8bRi/Hv6q
         BPQd3RbZSUhMX/DhxbaFmkb7q2+PyioXPKNBtepNLFb1ch1zr4MvQO7qO0HHZTVRbjgS
         YzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b3K11rzBWUrVKqwdCSRAQP1ffARxvzU99Wf31co2VLM=;
        b=hsRUNzxWGX62rufz1nGIqf081UZNJ6GuQ/2urG5GTMqIWENi2L6CfpGB/Gh6rofh2C
         MUuKz0qHOn6MP0hp2hxlfTJzV+uRKV6eFdeavtqCyf38A6XD+1X9VYCLrCYCF6V58O5/
         bDVCyZ8h+giDDrgNJXILq72P8YciZWqaE4nK+yeH1dijMq/31ZAbIyGQyckpAhPu1cqd
         55/mho+uP87He5pzAK/UeJWnx59+qnWR7TCwetmCIBqAKGd7Gy653wfODHxLdXxivYc7
         5r+UMXr4zNUm7S8cJ0d2Ie0aitf9o18s+bawZbMppswuQ5nYV4wWsQiHTSlZONV1gPmK
         3S6w==
X-Gm-Message-State: ACrzQf3hXUsAQc/Q/jybJyzcN6Kf5klCkKmOUUbS9clHdAihnKedRP2q
        GnXE85XFeca9QmV0CvClH/BnPAIp3EuRDQ==
X-Google-Smtp-Source: AMsMyM5k7PZQYuEU1EEkPiWtBfNGQ9LpBG9A/jHf61OlbavbBjc+sglJ8euNi+YrMcKRPl+dAk2DyOlfkM483w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:c704:0:b0:6c1:9494:f584 with SMTP id
 w4-20020a25c704000000b006c19494f584mr46340692ybe.98.1666901003291; Thu, 27
 Oct 2022 13:03:23 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:03:15 -0700
In-Reply-To: <20221027200316.2221027-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221027200316.2221027-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200316.2221027-2-dmatlack@google.com>
Subject: [PATCH 1/2] KVM: Keep track of the number of memslots with dirty
 logging enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new field to struct kvm that keeps track of the number of memslots
with dirty logging enabled. This will be used in a future commit to
cheaply check if any memslot is doing dirty logging.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32f259fa5801..25ed8c1725ff 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -709,6 +709,8 @@ struct kvm {
 	struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
 	/* The current active memslot set for each address space */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
+	/* The number of memslots with dirty logging enabled. */
+	int nr_memslots_dirty_logging;
 	struct xarray vcpu_array;
 
 	/* Used to wait for completion of MMU notifiers.  */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4ecfa5..57e4406005cd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1641,6 +1641,9 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change)
 {
+	int old_flags = old ? old->flags : 0;
+	int new_flags = new ? new->flags : 0;
+
 	/*
 	 * Update the total number of memslot pages before calling the arch
 	 * hook so that architectures can consume the result directly.
@@ -1650,6 +1653,13 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 	else if (change == KVM_MR_CREATE)
 		kvm->nr_memslot_pages += new->npages;
 
+	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
+		if (new_flags & KVM_MEM_LOG_DIRTY_PAGES)
+			kvm->nr_memslots_dirty_logging++;
+		else
+			kvm->nr_memslots_dirty_logging--;
+	}
+
 	kvm_arch_commit_memory_region(kvm, old, new, change);
 
 	switch (change) {
-- 
2.38.1.273.g43a17bfeac-goog

