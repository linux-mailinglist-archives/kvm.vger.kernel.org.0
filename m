Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C135A39C524
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 04:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhFECcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 22:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhFECcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 22:32:50 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DF7C061767
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 19:30:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id l1so9313179pgm.1
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 19:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q7TDnQb/tbypKGTD6feyyd6R2B333oHUGjeKgsqrRfc=;
        b=LUo0ki2X5FQHUkMwHa7DMwRZkw9uopi7waQEIKHxFOsjaEUAbrGdnGBeSUV8BccIBf
         6FnFE6ocMJDVImgDymGKDTeZuFM4n5DlCslrwMYEVoGZd42/V8ilyTaYj9z+SwkmNHew
         KCur9ZeMjBmNgN357HmyQTHIw0JR7t/pNF6Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q7TDnQb/tbypKGTD6feyyd6R2B333oHUGjeKgsqrRfc=;
        b=Ib2Rf0O7DYM/jvNU9s9WvIKKANA9HawfmSVoRBH+0MYv2mqkhHvMV8tUoOqYhrhahz
         If8L0+Qn0OsxQYwvO5pMSqMh1ZPAqiHUkplyEcCwgnYf7gUz9dcZTMAYhKNEYHJ5IeuW
         d1xHMINbiINl9Cfgita756zfoHL6xVbdJUCD5hB3ciLXmcb1zsV9yyVPrTmM9vijObuk
         0L5Du6Obrynt6QBgI4vEjC27shZYYBCfC8WYd6eSWUe9bnX3ftwP+C1fn0OXq2/XE+6W
         ra7PEafpRMJCsZO1c99+TCgxBYyjbqjx9KOCyWHwJXeIT2pinKdb30m4bR/3Vid9Cb2T
         fvFQ==
X-Gm-Message-State: AOAM5301Cg5NXGMQAYKjR6wU0F8axSUHUx9+4kohtdv96t1xknWVGAIU
        NX3zy928OM8Wf96dwn2b+4/OEQ==
X-Google-Smtp-Source: ABdhPJyRVcg/BBeXku5+DtIBCPnMwVpBcsRckJO/VL+Z+Rf9S8pP2dkpX0EwFcX49nauepwkU0AIlA==
X-Received: by 2002:aa7:90d9:0:b029:2e9:ac0b:b72 with SMTP id k25-20020aa790d90000b02902e9ac0b0b72mr7492649pfk.26.1622860254266;
        Fri, 04 Jun 2021 19:30:54 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:5981:261e:350c:bb45])
        by smtp.gmail.com with ESMTPSA id n23sm2754391pff.93.2021.06.04.19.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 19:30:53 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 2/2] kvm: x86: implement KVM PM-notifier
Date:   Sat,  5 Jun 2021 11:30:42 +0900
Message-Id: <20210605023042.543341-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
In-Reply-To: <20210605023042.543341-1-senozhatsky@chromium.org>
References: <20210605023042.543341-1-senozhatsky@chromium.org>
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
 arch/x86/kvm/x86.c   | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fb8efb387aff..f8e6689f490b 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -43,6 +43,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select HAVE_KVM_PM_NOTIFIER
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275d49b5..533d3d010a21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -58,6 +58,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
+#include <linux/suspend.h>
 
 #include <trace/events/kvm.h>
 
@@ -5615,6 +5616,38 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
+#if defined(CONFIG_PM) && defined(CONFIG_HAVE_KVM_PM_NOTIFIER)
+static int kvm_arch_suspend_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i, ret;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = kvm_set_guest_paused(vcpu);
+		if (ret) {
+			pr_err("Failed to pause guest VCPU%d: %d\n",
+			       vcpu->vcpu_id, ret);
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
+#endif /* CONFIG_PM && CONFIG_HAVE_KVM_PM_NOTIFIER */
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
-- 
2.32.0.rc1.229.g3e70b5a671-goog

