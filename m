Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C150144A4D5
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbhKICmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241508AbhKICmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:05 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD8CC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:19 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id w4-20020a1709029a8400b00138e222b06aso7685937plp.12
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uniPEnuX0gk6QJKFukwf5b6AeT8wkhedLb4e6yWrmRE=;
        b=cG46+tLyMfC8E+1FJHQpqSu4Vbj+OiIbfEpy5p1NQAa+m49AfuMrjXaxrgO6GHL0aY
         TeOOBhzqqxWrm8iHjdug9No4pC+oTadJGj+iziMUuNt2Myh2dR0jb/Eykriurjpu4lBk
         9kdjPokVXRh/shl9/6okG7g3U4+pd1ukU09oNuQB6vFrB00cQXNzuYMQ60yTL46wa0co
         +BPaT52cPC1eD4cQBBvE+UT2U36X+J6uBTYEONmYRYtRKQ3GGlJZ48KlVjurtTPg0yNb
         K77of8S0UO8HCuEur5bB2c90AaHve/TCp/NZMuDjeIawRFQAGKBhlE2ImpiMnv0gDG2U
         fcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uniPEnuX0gk6QJKFukwf5b6AeT8wkhedLb4e6yWrmRE=;
        b=7/YiAcFIFhFDHTFFN3V+jMSJ+3wMwqWqUnSk1tBu+zBUxaMR5uODSxz2yJSuGOMog5
         qH7jGoQxQuwlvcOmv4i8BFsk+zbOwWBKjrWNd6c/S5PBzpF2VSVGOqetG7YuQL9i7uno
         twiTMBYidHTzsAiGXPrKD96ycP8XuKFyKwqx1X5Y81YBcBNK6T+h3zBPvoVDFCT135fh
         IgrESvPhiE5z2H5v/0aiMfxWvX4zjtwy19jA7DWKDhL1+87kL4gXY2QORjO5dSZRlknd
         WosRSaqsYj2dEaqAGZzKReYS6FEJ6ITUdrtb666A/4CC6n+vX6TSHPPlPw8ruZCw4lJX
         bEpg==
X-Gm-Message-State: AOAM532p3SYL3VKfOud/NxaFv8HErspeahXv7I90Om74hWz1BvXncep7
        y0XYwRHuTl+NvYy15Q8AotvH6uzCupjrGiE125gBGQun2kzIhYLcZuIR2f4jWTCwR54syHtyUEC
        cmkTY+Z/P12OkD+2FLov/pIJIUUBPX0LAy2gcHznxfFfcaAi8WB3XFw4NZYFgY9I=
X-Google-Smtp-Source: ABdhPJzM2HDlpLCFeVGD1I8VKS6/Hls1yIJys+w+uzA32rZ+hWXRKhQTWiwEtpYWa+gIZZ+AndDlQYxnlSUrKw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4ad0:: with SMTP id
 mh16mr3376599pjb.176.1636425559349; Mon, 08 Nov 2021 18:39:19 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:53 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 04/17] KVM: selftests: add kvm_irq_line library function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an architecture independent wrapper function for the KVM_IRQ_LINE
ioctl.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index f6b3794f306b..c6831fd8aea7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -239,6 +239,8 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		      void *val, bool write);
+void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
+int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 
 int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 041004c0fda7..7d9cb8358702 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2078,6 +2078,27 @@ int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 	return ret;
 }
 
+/*
+ * IRQ related functions.
+ */
+
+int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
+{
+	struct kvm_irq_level irq_level = {
+		.irq    = irq,
+		.level  = level,
+	};
+
+	return _vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
+}
+
+void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
+{
+	int ret = _kvm_irq_line(vm, irq, level);
+
+	TEST_ASSERT(ret >= 0, "KVM_IRQ_LINE failed, rc: %i errno: %i", ret, errno);
+}
+
 /*
  * VM Dump
  *
-- 
2.34.0.rc0.344.g81b53c2807-goog

