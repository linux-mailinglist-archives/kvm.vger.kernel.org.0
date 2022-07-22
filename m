Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD257E845
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 22:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiGVUXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 16:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiGVUXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 16:23:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85979AF879
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:15 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b10-20020a170902d50a00b0016c56d1f90fso3186953plg.21
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+uSPjeBy32prO/kd4CgiXHIgmNfiXDDHshRM1XOIqvc=;
        b=Inym1xb4Zxz3J2YBwVCgNHWSYq3a/KDLbh6rfRZO45WKSUC5qIM48bWdNRg49W6Ftp
         2ZmVTpP6JmfQPT6mqEt8m3+Y5hANJ+2wIRAfkRwDGdyAeccUGUMLrP/dbMVdvXOtHlxK
         ukTtTVzOIjpRnG86JBOOHQ8P6347eqgjIDmWdPWLB/wj7LS8lLodQSt7AQKqlCc/c+y3
         oKFOU/HtYSsCq+L0kbbJUMI/jwne2fK8+VLUXSXHfEV6k9rsq9iGCZ5fqyY1slf+Uarp
         TxqHvhrCpUwEHv0xREfNPMrusn8NhvHWvARHKM2+zPZYrlDUN8NYG+dJDHWJZpa/3/re
         QYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+uSPjeBy32prO/kd4CgiXHIgmNfiXDDHshRM1XOIqvc=;
        b=sVQ8OBNVw8YoCDsqtJgVMgmxodaL8d4sdx1RLAlWPMLkaSDYXrbzpDymukIs5WOqhL
         tnkroAHTJEo4Dam+ScJFIiwaZ/5qN6yfd4qYLj4VkCtu1dXSivgVziRCGJf3Riu21s02
         xF4AacY8zF+NPrw7ldvd/q8J+9GVR1nTOiaJepHeK5T6tLGUlYpz71aU5sGC8Yb3KuLJ
         5ZsmZ1FmP2GdinlaKg3fP+ZP2UWaedHMqzug90d43X5cNxuI7B9rMNFQjO3sGNS5CP1S
         XtkZzc1FD+FE8I/Mvfe9p1DbMBqj7KqIS7WiQRmf//y4LtnC3VtnsPB44ImbW1VK5uml
         isPg==
X-Gm-Message-State: AJIora+ypMXbie1oNOCNea3JI7AdgurXpRKKbyVTeKqy2tumT0TGLeBq
        qNhpBzZJbP43n9iFRU58wp9xV6Y5H6w+LyaVGThooi3c4XTHQhr2OhL8ZZtWZo8bgjZdICHxrHD
        rd6zAYud9pRDmciTHBM/uut0BPw5udtGbu1FeybnrePcbGjBpjb3lox3SHdAVMAYRyGBC
X-Google-Smtp-Source: AGRyM1ssh0uvM63qtbZWLpl79kHqWpEeyfXQKtrbbOiPQJeLiSNfrZW9wZNrQIkrf/Dvgg9SJUpY1yDF9Bjbwu3n
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:da83:b0:16b:fea2:c84f with SMTP
 id j3-20020a170902da8300b0016bfea2c84fmr1238544plx.28.1658521394918; Fri, 22
 Jul 2022 13:23:14 -0700 (PDT)
Date:   Fri, 22 Jul 2022 20:23:01 +0000
In-Reply-To: <20220722202303.391709-1-aaronlewis@google.com>
Message-Id: <20220722202303.391709-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220722202303.391709-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH v3 2/4] KVM: x86: Protect the unused bits in the MSR
 filtering / exiting flags
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The flags used in KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
have no protection for their unused bits.  Without protection, future
development for these features will be difficult.  Add the protection
needed to make it possible to extend these features in the future.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 6 ++++++
 include/uapi/linux/kvm.h        | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e6dd76c94d47..404b031f78ae 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -226,6 +226,7 @@ struct kvm_msr_filter {
 #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
 #endif
 #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+#define KVM_MSR_FILTER_VALID_MASK (KVM_MSR_FILTER_DEFAULT_DENY)
 	__u32 flags;
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 031678eff28e..adaec8d07a25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6171,6 +6171,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK)
+			break;
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
 		break;
@@ -6384,6 +6387,9 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
+	if (filter.flags & ~KVM_MSR_FILTER_VALID_MASK)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
 		empty &= !filter.ranges[i].nmsrs;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a36e78710382..236b8e09eef1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -484,6 +484,9 @@ struct kvm_run {
 #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
 #define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
 #define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+#define KVM_MSR_EXIT_REASON_VALID_MASK	(KVM_MSR_EXIT_REASON_INVAL   |	\
+					 KVM_MSR_EXIT_REASON_UNKNOWN |	\
+					 KVM_MSR_EXIT_REASON_FILTER)
 			__u32 reason; /* kernel -> user */
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
-- 
2.37.1.359.gd136c6c3e2-goog

