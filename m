Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FC9454167
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhKQG4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhKQG4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:33 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9526C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:35 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e4-20020a170902b78400b00143c2e300ddso554560pls.17
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ngr4hW3OQO25yW6Z4QPAPb06Z9XdAyw5TZaaZf4PQgw=;
        b=d3k4dD7DeKSt+dZdlIRs7mm6LnVHJVt6MJBZO8D+xJd0gunFXbHBYuDqyARKCcDfGh
         lPKrp5Qqr21sujBqw3NCYXc3O43g3ZYZnFgqWmbcB4gG1evEu0MvTQuF7I/6Lzlf0clV
         TRzdRmPYVy9yUTIciVPd1fE3vQ+EA6smRJ9+4HS5nnIz6N4rpcGlS1yb6+kvIsR36f54
         uaj8JsNWz14aQ5SL8POTavCae1N9dzpidU/epMp9T9i+QrevGG54XO7wmqkbd1YGLTT5
         px1AJdtDdiH9/WKiDIhjGHBLJKS375Z4uLZVXZ85mhrHMhrAW3Gl+0Ukb1ZERUVRfoeJ
         CpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ngr4hW3OQO25yW6Z4QPAPb06Z9XdAyw5TZaaZf4PQgw=;
        b=76lxkUN/UuDafLx3uZwNGKj0OXA9pignFdUh42LknzhjgXodmSvJIhvckTAXzPbQFB
         tfmpfgbcQO+oEcpFQwrOa5Igahkbghg6oujPFQzDr2j+N6EQXYI5Tvb1/PTOPrPhitZF
         KEskZQdNc2UOi8V8V42Y70WE1hGKe466hUOg5xNCOzuYgwEbYlBQUj3HoPyWgbuHyT+7
         R5hjDtmC6HugMp95MUDU6RmRXHSxH2SnZvGJJfjIIlL4UmJKMc5TvInJ2ObntoMRgHJt
         2prKvnqHugoJVZsGd/H4AHj3+hgV/to70L5BwS3M45npGq+kFfpe04lRCiM48u5jVzGu
         UvXA==
X-Gm-Message-State: AOAM531YQoS/JWWx/wl5fxRZv+RS+sESNH+DZh3fM4jT2ENIE8tSFN1r
        2SyEad5xx6Nw/Hqj+iLvnx5wxXUKtBU=
X-Google-Smtp-Source: ABdhPJzMTnMi5u59+kPQqdzefOhB/wBSglPLL+HhxruNL4kxrs/Un5EiZfa6yoeZ23QBUnLS38Laa1NvHts=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:22c4:b0:141:deda:a744 with SMTP id
 y4-20020a17090322c400b00141dedaa744mr53364712plg.25.1637132015299; Tue, 16
 Nov 2021 22:53:35 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:47 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-18-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 17/29] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE
 capability
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new capability KVM_CAP_ARM_ID_REG_CONFIGURABLE to indicate
that ID registers are writable by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 arch/arm64/kvm/arm.c           | 1 +
 include/uapi/linux/kvm.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..022effa4454d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7484,3 +7484,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_ID_REG_CONFIGURABLE
+------------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 19c4a78f931d..a54579e7ac91 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -215,6 +215,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_CONFIGURABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..9697c06a7f5b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_ARM_ID_REG_CONFIGURABLE 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

