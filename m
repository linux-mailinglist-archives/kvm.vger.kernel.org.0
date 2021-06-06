Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7701F39CC35
	for <lists+kvm@lfdr.de>; Sun,  6 Jun 2021 04:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhFFCOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 22:14:00 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:41763 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhFFCN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 22:13:59 -0400
Received: by mail-pj1-f47.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso8253601pji.0
        for <kvm@vger.kernel.org>; Sat, 05 Jun 2021 19:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dEHi0nLGv5PfBaxyr6DdBRy0QUGk/obWt0c36R9kJV8=;
        b=EJy8zAGmJkYV43CiZRUYsGQFoP605zrn/Ann+QB5tZGDLciBJIhh7RLqXjXilWC5o1
         54HFislHjIwa2sLCN69oTR9sOKZXYxJiWh3Vx7kbP/gtfiGh26MHEPBhsuvMJiNfh7s6
         gXbGyZ6gcCB/B4UKfY5JQuCb1aOhv70MZn6yA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dEHi0nLGv5PfBaxyr6DdBRy0QUGk/obWt0c36R9kJV8=;
        b=UI5rp0NzPUvf4ZpQRE5cEeLQr+lh0EF66SBJXpnjqDYXudAolUNu/ginCu/m6uV55J
         Q/02Gz0llwqM+sh3oJGxePHV8LmznNl/4d6pLQYmnzlm9dEFEHqI8OTauCrwOAY2lL++
         1F/JJSa6iuEdrVpftjb/IhCPI3Xjs4gtWJyuih9mSuFlrPSN52mP7LBGNHRANQv+mBoi
         WxZA2EDZwtkb980Z6uZwnFnkLQgoXshgyw88x8n845nnYC1RSS4PsqXnnd32GPxyt7hp
         fs+wxQxWu1x5F10xVPPULF1U2wEdvXfl6Xbr7Hhx/Wr7elj2VR18J+0iaOIrxdaNC8nd
         090Q==
X-Gm-Message-State: AOAM530gAQSeZi9NUa69jCa7jr3T0Ld7k+qwZKaPAIpQ51oxAfSPkCde
        XGBCyRzvWNqOK63ydy2DyKNtYQ==
X-Google-Smtp-Source: ABdhPJzRznPqp1FH5GFT4MorUkuBHJ6PF3pdo16Sw5uSMHWrRpmmlQmpTJXS2XKoUpDhLfMQzXyfEw==
X-Received: by 2002:a17:902:548:b029:10f:30af:7d5f with SMTP id 66-20020a1709020548b029010f30af7d5fmr10598403plf.22.1622945454788;
        Sat, 05 Jun 2021 19:10:54 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:c87a:995:bf9d:93bb])
        by smtp.gmail.com with ESMTPSA id v15sm5586327pgf.26.2021.06.05.19.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 19:10:54 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv3 2/2] kvm: x86: implement KVM PM-notifier
Date:   Sun,  6 Jun 2021 11:10:45 +0900
Message-Id: <20210606021045.14159-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
In-Reply-To: <20210606021045.14159-1-senozhatsky@chromium.org>
References: <20210606021045.14159-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement PM hibernation/suspend prepare notifiers so that KVM
can reliably set PVCLOCK_GUEST_STOPPED on VCPUs and properly
suspend VMs.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 arch/x86/kvm/Kconfig |  1 +
 arch/x86/kvm/x86.c   | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fb8efb387aff..ac69894eab88 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -43,6 +43,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select HAVE_KVM_PM_NOTIFIER if PM
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275d49b5..af1ab527a0cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -58,6 +58,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
+#include <linux/suspend.h>
 
 #include <trace/events/kvm.h>
 
@@ -5615,6 +5616,41 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
+static int kvm_arch_suspend_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i, ret = 0;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!vcpu->arch.pv_time_enabled)
+			continue;
+
+		ret = kvm_set_guest_paused(vcpu);
+		if (ret) {
+			kvm_err("Failed to pause guest VCPU%d: %d\n",
+				vcpu->vcpu_id, ret);
+			break;
+		}
+	}
+	mutex_unlock(&kvm->lock);
+
+	return ret ? NOTIFY_BAD : NOTIFY_DONE;
+}
+
+int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
+{
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return kvm_arch_suspend_notifier(kvm);
+	}
+
+	return NOTIFY_DONE;
+}
+#endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
-- 
2.32.0.rc1.229.g3e70b5a671-goog

