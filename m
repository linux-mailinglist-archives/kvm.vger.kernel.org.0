Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4284D4D5B4B
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346800AbiCKGFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347303AbiCKGDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:54 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952D11A907C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p8-20020a17090a74c800b001bf257861efso7287428pjl.6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xwfZh69dZOdSDjKPAanZfrcJOqRr+yQYeyh7zLSa5HM=;
        b=FmJrdIQ4nkAf2XhudiEZwKvXHoi1jC/nwpfxS6QVNMD2gPfr86NLRAre5UcUjxyqqf
         tpfui4ksu2sGfp+uQsV5yIpGapg3LBMNCt/amcsL5lmSGJ3/yIjRb0ObSWspsHGJ/ExJ
         E+UXgzwVetIbnj9tRAx5JjTRdumu1rneme2ubpOwDyXKrYlqJmUYCFAekBIiz091gpaT
         KbqliVra7ce0Y5Qk7cd6GQcxH6Z4e5SRYivMRlJAQ2vZi2+LZ8ygTB01Si4Fb5ScWXR8
         sPuDuZ7kmM3T0y2+IPlT+bqYW/pW8DCcyLD2Y81KBDrp7R1EjscglqttDJohlJ/bX+O6
         uq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xwfZh69dZOdSDjKPAanZfrcJOqRr+yQYeyh7zLSa5HM=;
        b=tq7a8CBsgEMW6cvsbJYSW2GOK6mLYsjl0EGiQ5guaSkg0z2KiperV+bHWH4AUiXSQt
         JgpaN6USrTR2b/l5LTn1Mn5B/vtozfn/v1d1weEn/gHBLsRoi52reYcOXs4Zy14IIRXX
         p6LRrndQ0xigqOQN9AzGxiDqK2dXMG6rH2cUUeHUH7VsdVavv/aDAqQ4Oi0qHG/GTEA4
         WFOP42gZ8dq4SZJghQhH7Hy8kbuTmxvRXKPOjojoI9qApk72iNjvT94JCC33UGYw67TL
         SLIGuyewaEm4wpEJ8DvlsBeZq6sFybLqUT6wj0fdLf3g9JCzJdA1aX/Fz4PSDO2oRsLa
         lB1w==
X-Gm-Message-State: AOAM533uVYDOuaqkE5ADeBx/NlsQGwKkdOyoNPaqFns2bPG3qXc0KCPw
        vRaxBpkCdLs7YWoFm69HMxG2nwsTpyJXx6S8am3DO6GHDVThH0T1ltXSngMc5tNmn51JhMAusJa
        2l5DP3T7u7qEKfRMJEj4KMdJ4YNxEN6ISnHGUfhMQWHtJfdpYIClBnljKArPF+E0=
X-Google-Smtp-Source: ABdhPJx2Dx7cNt7Ofd9w5hxmXsBiBkr6Dftp2Jiv2s6DH+Uk1zEWu8ia9W4jQ1mK6lRGzs+WWSNA8YA6bHTD5w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4a52:b0:1be:fb7c:9fef with SMTP
 id lb18-20020a17090b4a5200b001befb7c9fefmr20013275pjb.57.1646978533927; Thu,
 10 Mar 2022 22:02:13 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:01:58 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Add a library function to get the backing source FD of a memslot.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4ed6aa049a91..d6acec0858c0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d8cf851ab119..64ef245b73de 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
+/*
+ * KVM Userspace Memory Get Backing Source FD
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   memslot - KVM memory slot ID
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Backing source file descriptor, -1 if the memslot is an anonymous region.
+ *
+ * Returns the backing source fd of a memslot, so tests can use it to punch
+ * holes, or to setup permissions.
+ */
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
+{
+	struct userspace_mem_region *region;
+
+	region = memslot2region(vm, memslot);
+	return region->fd;
+}
+
 /*
  * VCPU Find
  *
-- 
2.35.1.723.g4982287a31-goog

