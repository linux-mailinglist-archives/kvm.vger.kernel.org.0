Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F422443D37
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhKCGbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhKCGbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B81C06120C
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t62-20020a625f41000000b004807e0ed462so807732pfb.22
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LPEo6E0odusyrNggBByLPHmUhPl/zAKGlEQeNEdskuA=;
        b=bUNM+pxcYjjNldjizqCPZrdfmrJ570sn9wZ2+V56DnjdvPvtesjhdX/PSW+VQDoFfO
         4yc25e1h0xFAlZIhbOGpVQZrhoK267T/BxRH6QH3HLqV/1XTLHt0bmLoDFG2mBLwR2n5
         4qjERrwJ999xwEgl++TYoXgA9t9wDvO8RsuGQMJaJ5XEvCaVXN3vs4Fn3idvHHMy8lzJ
         eIuynnNTqqXtqERgV/dwYp/hbLg3cZOLT2Hz/eodY1pJ69D1yTMVzvEJPhuK+3Cgtg/n
         7U3CmnMjBBgBG4VlAeldkwlh/C5NaaZXwcCDPKbztqhLXOUTFjDOyPzZXSoH329hztzx
         1ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LPEo6E0odusyrNggBByLPHmUhPl/zAKGlEQeNEdskuA=;
        b=mEaTqPfjqs+GCfFm5jt0ySpuRTJg+pdxez9xZiEk8Ax6zWy8cm2DKaAAdQg4sx58Es
         8KxG0URzqwya6SQY/mso+BfNSfSqCR+a/JK/Y1ihdoyuwdmJQ+D98zKPPVvHIKSy0wiz
         GNRN4Tain6X//ORdOAozPLZZqO7ev5CkxvtrGG+D3hj/izT7eCuje/VwSIS9LvQi+/tp
         HyFbovmBP6nMfS+5AU+6YyvNA38zVaSLMCc6sct7vU1k53fYe5ViUaJW4yc9eD7fVrWj
         1eTAGyd6QRLCKxTbGCHSjqDsC8IMMRF9NOmS2M4YkW2/w0Jh2DUoE/V8p7NO07EmBehm
         geFA==
X-Gm-Message-State: AOAM530tuBZCtcYk1rNLZvnb6r7zamHRjTk/eoxctxtiDmIDHEmQA6j9
        iOI8mmT7S3q0SaFVPkCds4w80e5Ianc=
X-Google-Smtp-Source: ABdhPJxPQlTZgemwz/ej9COOHQof1/L/+yDn2lMn62bmlzOf2+lYhTzbKkH4dxYFVrp4EA9bFyTluvTF1D0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:1904:0:b0:480:816c:1d3e with SMTP id
 4-20020a621904000000b00480816c1d3emr27606490pfz.83.1635920904536; Tue, 02 Nov
 2021 23:28:24 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:10 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-19-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 18/28] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_WRITABLE
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
index 528058920b64..87b8432f5719 100644
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
2.33.1.1089.g2158813163f-goog

