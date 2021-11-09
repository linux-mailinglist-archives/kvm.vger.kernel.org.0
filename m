Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2B244A4EB
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241969AbhKICmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbhKICmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:21 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765E4C061764
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:36 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 76-20020a63054f000000b002c9284978aaso11274797pgf.10
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GES34y6vW0ebb/dfUgRINMRJKHYQGjmRo+EZqwaIueY=;
        b=jiXduLdnJkx6DErFWp2JDCOijv3TFXCxT3uZujtWXXxgyB0fFpmQtlBLiuqtzy3PDT
         YYZN5cL67RDOi6oDxCE5BZLUArXl0lyIA1BJYSiB6uqXr8qLJivYMihA1DPwK6IhlCFj
         +J1mOK6flPI7qR7JOEU/+m/RbmnFRTFFDSuG3SuCy3uCJTtbA4fv/EnFzgc6fr4NELZ3
         PUgWnrLGaRB6RL5UYEyQ+0/8s+bjQboyZVYPM5iAlVNd1pCtNCUrhXOlNY0uzPqaqy1/
         429atQDcnFcqKzC7WEd12/4fFQ0CUhpuwLU1V0fY0WMojtWx26SgM3zxoSHncuJDP/r3
         AVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GES34y6vW0ebb/dfUgRINMRJKHYQGjmRo+EZqwaIueY=;
        b=gdUTggG0xhTaDjC1JCg7huRDOaF5HMmR1UetpcA76FijolUY1FeTDGHrqsBp6ZNAIL
         1lxQlqQtezogq7PNbBBj18+8bYG2Q4yT/g6ZrUF9fsMcBHzhRby8qUiOhzf24/FuKz1J
         G/BSzAvLp54uroKPvGWxtfhXAYCQYMdr4UTcxUk6rQ1WSsTriBxj8uC9XY+iuBeVbdQ7
         DXPIPwY6+5MDrHFtDP0dSmM8gUIuwjMcrApdnq3dT4w+8CTro7F4A7UDE3/jq3piWMD/
         5anUA/J2UgPBRHMS4YSFUw194gJVLwKht/mHilmEEzgn5L+uNA0dCeuLbEIWN8jtUv8t
         jhlg==
X-Gm-Message-State: AOAM533VosIG8hoA6SIOwVOv+ZwDFy5uyQrLzsca19b9Z23oR/f40JcG
        SPoduXl2REVEKeIkbCCLZE/wc6jfUCav4QoOlqsX41bYE0ZxLSDGsQfp2NIIQynbSnjabZDf7zs
        1aUiWf+YIXtYFR6C+fGZA5Q6Po4PHVveECQBGpctSAWbd2dIkFZyO00Fkm0vII8k=
X-Google-Smtp-Source: ABdhPJzO1D1+Dk2URw44WZn2b3SSBgPjATtGTsr+/7avX/ccU6voQidUrVDPgjRDV2e/RzeBE1FF4OFi9Upaqw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr137518pjf.1.1636425575183; Mon, 08 Nov 2021 18:39:35 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:39:03 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-15-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 14/17] KVM: selftests: add IRQ GSI routing library functions
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

Add an architecture independent wrapper function for creating and
writing IRQ GSI routing tables. Also add a function to add irqchip
entries.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  8 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 51 +++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c6831fd8aea7..26c0722d7f77 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -251,6 +251,14 @@ int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			 uint64_t attr, void *val, bool write);
 
+#define KVM_MAX_IRQ_ROUTES		4096
+
+struct kvm_irq_routing *kvm_gsi_routing_create(void);
+void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
+		uint32_t gsi, uint32_t pin);
+int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
+void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7d9cb8358702..2a38d717bc67 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2099,6 +2099,57 @@ void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
 	TEST_ASSERT(ret >= 0, "KVM_IRQ_LINE failed, rc: %i errno: %i", ret, errno);
 }
 
+struct kvm_irq_routing *kvm_gsi_routing_create(void)
+{
+	struct kvm_irq_routing *routing;
+	size_t size;
+
+	size = sizeof(struct kvm_irq_routing);
+	/* Allocate space for the max number of entries: this wastes 196 KBs. */
+	size += KVM_MAX_IRQ_ROUTES * sizeof(struct kvm_irq_routing_entry);
+	routing = calloc(1, size);
+	assert(routing);
+
+	return routing;
+}
+
+void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
+		uint32_t gsi, uint32_t pin)
+{
+	int i;
+
+	assert(routing);
+	assert(routing->nr < KVM_MAX_IRQ_ROUTES);
+
+	i = routing->nr;
+	routing->entries[i].gsi = gsi;
+	routing->entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
+	routing->entries[i].flags = 0;
+	routing->entries[i].u.irqchip.irqchip = 0;
+	routing->entries[i].u.irqchip.pin = pin;
+	routing->nr++;
+}
+
+int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
+{
+	int ret;
+
+	assert(routing);
+	ret = ioctl(vm_get_fd(vm), KVM_SET_GSI_ROUTING, routing);
+	free(routing);
+
+	return ret;
+}
+
+void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
+{
+	int ret;
+
+	ret = _kvm_gsi_routing_write(vm, routing);
+	TEST_ASSERT(ret == 0, "KVM_SET_GSI_ROUTING failed, rc: %i errno: %i",
+				ret, errno);
+}
+
 /*
  * VM Dump
  *
-- 
2.34.0.rc0.344.g81b53c2807-goog

