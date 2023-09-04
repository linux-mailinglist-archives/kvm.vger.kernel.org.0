Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3387F791763
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbjIDMo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbjIDMo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDACCD7
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:46 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-52a3ff5f0abso1861558a12.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831485; x=1694436285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgUPYLmjXf0NM9VXdRKjm+MRqu9ErWeVIsJU5m+yYDU=;
        b=BAr++xpX006+SazRw+fzDmZRM9mSjW/zL4TZ+dkLqVcadP55q/stMuB8iZpN+2Lxix
         JZw1yczewe3D+NsShIAw4/GlUqYST/+fsY43mDfz6c2pOpk9EJiQPszBKlqRX9dGOvz6
         plVOs/l6t+4XFCf4/Qfgy3aEHjxzvYpm+JW9pNUeBP3LvbtYmFKkjXfM7o3nr0yFqLJl
         XlwygUeqwyjzjAa50qiau5wW4K8fQcwIJqpk3ZGJtm+Zm27oepPa9Abh2U4JUe0zZrth
         UnXVVPp56XpJfOa60OJhKet41K+S8iHLo8aU0cgT2cPg+j4ZlxmPhbloIJL+niaJS9jL
         g+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831485; x=1694436285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QgUPYLmjXf0NM9VXdRKjm+MRqu9ErWeVIsJU5m+yYDU=;
        b=CoHzyjowqZo5D7nuoHcH1FgobuROJayCaP4FqDgZF3bJtY6/1aNvM8MLKzqqkUAb3/
         xfK7I1DpMQw0Kx0A9drFGhvdjqso9SsH6sqtIWVbsxVi2rZpv+gyDV3+hc9uXdnuDs2/
         wKFr2TvcG+BmHWGmlisiY+COAstdpF12LTJ4VGXgP19BA/9nLgtmo2he9WPwKhUJeaeU
         I1U6DC8ztkwtEZq80Fdu6Z565tiFAWQvHYJ+/9VCX2a2yvShZXph1DS/y9wVy305lPuN
         MC9B4BBwqGM7shiIdCywyXqWmwllidPzHllhvEK5VowLc2SDCZQH/Vb3MU3d674rmtI9
         WQrA==
X-Gm-Message-State: AOJu0Yy6F0v8VXet+BC5NfL+Rhklns5OwrkWYRgRA3vsW/KFWSRocO/7
        MnhGSGUC2aDcbioK420+GhCi6Q==
X-Google-Smtp-Source: AGHT+IGpqxvPFHv+7iL7JBf8coc8ir/WyqX6mJSQUkJ8wn20F+l+BdUJBcSdl1rEC9tKrnU3giCDUw==
X-Received: by 2002:aa7:c393:0:b0:525:570c:566b with SMTP id k19-20020aa7c393000000b00525570c566bmr6829285edq.22.1693831484850;
        Mon, 04 Sep 2023 05:44:44 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id d4-20020a50ea84000000b00521d2f7459fsm5753793edo.49.2023.09.04.05.44.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:44 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH 13/13] sysemu/kvm: Restrict kvm_pc_setup_irq_routing() to x86 targets
Date:   Mon,  4 Sep 2023 14:43:24 +0200
Message-ID: <20230904124325.79040-14-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_pc_setup_irq_routing() is only defined for x86 targets (in
hw/i386/kvm/apic.c). Its declaration is pointless on all
other targets.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h       | 1 -
 target/i386/kvm/kvm_i386.h | 2 ++
 hw/i386/kvm/ioapic.c       | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 147967422f..ee9025f8e9 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -514,7 +514,6 @@ int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
 int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
                                       qemu_irq irq);
 void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
-void kvm_pc_setup_irq_routing(bool pci_enabled);
 void kvm_init_irq_routing(KVMState *s);
 
 bool kvm_kernel_irqchip_allowed(void);
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 76e8f952e5..55d4e68c34 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -78,4 +78,6 @@ bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
 
 #endif /* CONFIG_KVM */
 
+void kvm_pc_setup_irq_routing(bool pci_enabled);
+
 #endif
diff --git a/hw/i386/kvm/ioapic.c b/hw/i386/kvm/ioapic.c
index cd5ea5d60b..409d0c8c76 100644
--- a/hw/i386/kvm/ioapic.c
+++ b/hw/i386/kvm/ioapic.c
@@ -16,6 +16,7 @@
 #include "hw/intc/ioapic_internal.h"
 #include "hw/intc/kvm_irqcount.h"
 #include "sysemu/kvm.h"
+#include "kvm/kvm_i386.h"
 
 /* PC Utility function */
 void kvm_pc_setup_irq_routing(bool pci_enabled)
-- 
2.41.0

