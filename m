Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618F5429CA0
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhJLEi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbhJLEio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:44 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D715C061749
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:43 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 12-20020aed208c000000b002a78b33ad97so2242034qtb.23
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W3IwbsI0k+1QwX+TAHKvccKyulobDPeUG2CVSppLk2E=;
        b=TfiizDughOv6XpmrE/B/ta2oJtWh1KOl7oRghEckpq0jtU04giMWrFXne9m7+dzkv6
         +vDn6LO6SZHnG6Q2pROAG2PQBSDXREyd22lMQG+lxRGsSADq1E+VnO1Z7WqkDHfrJlNO
         EVH0Yg/uVDi2saPJf04+wIlOaX6lLvVlRsChENQhZNP7PXPXCNlE+6otUV3bnagcPn4z
         Yx6SBV7yyfslru2sqW6hIZHTINV96lf4W7ad0FwkZXwvoj8/k7dfbQXIV11HMFzC35M9
         3BWa+zuJL4S/hTBSHGuyaF8QFy7mPEwc4ITx69ZWKUdntSI1EIJBbI4KYAjAoqtTxm/c
         HEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W3IwbsI0k+1QwX+TAHKvccKyulobDPeUG2CVSppLk2E=;
        b=vFyeo0m3R92qDJvhrLfGQ09XeUJKyS5LcuJukPl/c6AZ36LlvqmC6/J3SFG7ycsZB0
         Te9fQhyCNRWN2oqEt8stjdJtxrdYyeEdi42K5yEN4pMEKVZcl6VbsVfutBcCDLI+dl0U
         /BLRwtqsSm4ako5wGtUsW4pMcWeMedVqbIoBAUgtHuo9BrUK5lUS7fRY5Y/lUUImJ1F2
         EMARQyH+NYFcdjvRelyKJvLnhgOimnLB30Yv+58Edl2YjQFSCL/k4Glx8rv65i2GjvGG
         fnVof5v+McGS6xT17nsp0dbQ+bkdX8KuqPW+v94E0UCNdfKLl6B8GMZ6runwZSqwunm5
         fMtw==
X-Gm-Message-State: AOAM532vxszvQKz3W2bl2R05WtFzsXfCZdSV/VXAfD5mToIU1tAnuW4B
        gn3hTKy2N+Ls0q86M1uw92Npw+2A4co=
X-Google-Smtp-Source: ABdhPJzqRlxJ4C5xz9JQufFpuXIYDJjLzFExk6TNCvlIXorPpPAh6QasGboxtVmBj45EPB8PnMerC+dbHno=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:622a:1a0b:: with SMTP id
 f11mr12653018qtb.133.1634013402619; Mon, 11 Oct 2021 21:36:42 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:25 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-16-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 15/25] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_WRITABLE capability
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

Introduce a new capability KVM_CAP_ARM_ID_REG_WRITABLE to indicate
that ID registers are writable by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 arch/arm64/kvm/arm.c           | 1 +
 include/uapi/linux/kvm.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..f7dfb5127310 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7265,3 +7265,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_ID_REG_WRITABLE
+--------------------------------
+
+:Architectures: arm64
+
+This capability indicates that userspace can modify the ID registers
+via KVM_SET_ONE_REG ioctl.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 820f35051d77..29c13a32dd21 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -197,6 +197,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_ID_REG_WRITABLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..3345a57f05a6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_ARM_ID_REG_WRITABLE 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.33.0.882.g93a45727a2-goog

