Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839EA5449A9
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbiFILER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 07:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243426AbiFILEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 07:04:14 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA7E3A5C1
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 04:04:08 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id i29so20662906lfp.3
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 04:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GBcVSj5vK9dnDN8lJcczVx8WGj5ZJQzjsNKoow4IHFc=;
        b=i4UDE1ossfnZsiVa66qgLmEidmWOd/unHV8zwBFzNn9+UbYaQivgqK3oVO82HEZM5e
         Hpu7e1SDgBTH6enOnjI5cEHK0Vy8DUVNCPby6SqzCZKzIuckbceW6Mrh3VSvcvcuYMOn
         AMqaDsDQO/WQntETGXP1Y3M0yHxodxgwhbwD9tVVTvUh6x35uEUJ4uETd0bDDjYlKSwH
         ZVPdDA8Dk1Cc4CWz87IYyFRVv7Etx2p8+To7zkyh+DrxFZR8z8C84iO9rbA8UnOQ2RYD
         lz1QVUqf9AUOvJ3Wn5wPVZ9RWAOWKChJae8UM2RkLiMmt1FQGX6blYg5PD/BIbZxMSix
         WXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBcVSj5vK9dnDN8lJcczVx8WGj5ZJQzjsNKoow4IHFc=;
        b=OkvHxExKxOqHx7xpJrOt9BOkD9acTwfWWfbucev5fZRNnzlBCbepXne0/t6XGNk4PX
         X4AJuotk2bD76fXrNL9B6UJfnkK8zWJNX67n2Xf0WmCr6xIbU785AjkZyhPNWXBtX3/S
         27/qYaSkeJ9+l0epEtaGVtNgR1vr8ajgrzdXEayvl+1XVl6IyM97gLyQPIFtTdtMtnFQ
         o/QCtaan3/Nh3ed7DFRzayTDIJ/SVMKNBtRBnGbiBqh+9ROi0Vd2zOUuJnE4vJQdFKSW
         n0tXli7/dNo3EbF1E06pb98o5NjYveOJWTaC74DOC3GTlBihTB3wGGa/QoFCTrAK/ho3
         Vl5Q==
X-Gm-Message-State: AOAM531LCKC+jnIFCGR5w38faF7OG0KVCZmcg1NwwU4e1509YI/tW4Fv
        J1pXQk2UQsfawpGlHZqzcJ4ZOw==
X-Google-Smtp-Source: ABdhPJxRYrFR6v6a5u7fHrq0mO1LFNycP0dnjq7nnT44DZJU9DMhLOM/vS0hTdVkj8jD7vbXplyMQg==
X-Received: by 2002:a05:6512:16aa:b0:479:7df:cb68 with SMTP id bu42-20020a05651216aa00b0047907dfcb68mr17553534lfb.666.1654772646184;
        Thu, 09 Jun 2022 04:04:06 -0700 (PDT)
Received: from jazctssd.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id a10-20020a194f4a000000b004793605e59dsm2116674lfk.245.2022.06.09.04.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 04:04:05 -0700 (PDT)
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
To:     linux-kernel@vger.kernel.org
Cc:     jaz@semihalf.com, dmy@semihalf.com,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-acpi@vger.kernel.org (open list:ACPI),
        linux-pm@vger.kernel.org (open list:HIBERNATION (aka Software Suspend,
        aka swsusp))
Subject: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle state
Date:   Thu,  9 Jun 2022 11:03:27 +0000
Message-Id: <20220609110337.1238762-2-jaz@semihalf.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220609110337.1238762-1-jaz@semihalf.com>
References: <20220609110337.1238762-1-jaz@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zide Chen <zide.chen@intel.corp-partner.google.com>

Implement a new "system s2idle" hypercall allowing to notify the
hypervisor that the guest is entering s2idle power state.

Without introducing this hypercall, hypervisor can not trap on any
register write or any other VM exit while the guest is entering s2idle
state.

Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
Co-developed-by: Tomasz Nowicki <tn@semihalf.com>
Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
---
 Documentation/virt/kvm/x86/hypercalls.rst | 7 +++++++
 arch/x86/kvm/x86.c                        | 3 +++
 drivers/acpi/x86/s2idle.c                 | 8 ++++++++
 include/linux/suspend.h                   | 1 +
 include/uapi/linux/kvm_para.h             | 1 +
 kernel/power/suspend.c                    | 4 ++++
 6 files changed, 24 insertions(+)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index e56fa8b9cfca..9d1836c837e3 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -190,3 +190,10 @@ the KVM_CAP_EXIT_HYPERCALL capability. Userspace must enable that capability
 before advertising KVM_FEATURE_HC_MAP_GPA_RANGE in the guest CPUID.  In
 addition, if the guest supports KVM_FEATURE_MIGRATION_CONTROL, userspace
 must also set up an MSR filter to process writes to MSR_KVM_MIGRATION_CONTROL.
+
+9. KVM_HC_SYSTEM_S2IDLE
+------------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Notify the hypervisor that the guest is entering s2idle state.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9473c7c7390..6ed4bd6e762b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9306,6 +9306,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		return 0;
 	}
+	case KVM_HC_SYSTEM_S2IDLE:
+		ret = 0;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 2963229062f8..0ae5e11380d2 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -18,6 +18,7 @@
 #include <linux/acpi.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
+#include <uapi/linux/kvm_para.h>
 
 #include "../sleep.h"
 
@@ -520,10 +521,17 @@ void acpi_s2idle_restore_early(void)
 					lps0_dsm_func_mask, lps0_dsm_guid);
 }
 
+static void s2idle_hypervisor_notify(void)
+{
+	if (static_cpu_has(X86_FEATURE_HYPERVISOR))
+		kvm_hypercall0(KVM_HC_SYSTEM_S2IDLE);
+}
+
 static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 = {
 	.begin = acpi_s2idle_begin,
 	.prepare = acpi_s2idle_prepare,
 	.prepare_late = acpi_s2idle_prepare_late,
+	.hypervisor_notify = s2idle_hypervisor_notify,
 	.wake = acpi_s2idle_wake,
 	.restore_early = acpi_s2idle_restore_early,
 	.restore = acpi_s2idle_restore,
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 70f2921e2e70..42e04e0fe8b1 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -191,6 +191,7 @@ struct platform_s2idle_ops {
 	int (*begin)(void);
 	int (*prepare)(void);
 	int (*prepare_late)(void);
+	void (*hypervisor_notify)(void);
 	bool (*wake)(void);
 	void (*restore_early)(void);
 	void (*restore)(void);
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..072e77e40f89 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_SYSTEM_S2IDLE		13
 
 /*
  * hypercalls use architecture specific
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 827075944d28..c641c643290b 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -100,6 +100,10 @@ static void s2idle_enter(void)
 
 	/* Push all the CPUs into the idle loop. */
 	wake_up_all_idle_cpus();
+
+	if (s2idle_ops && s2idle_ops->hypervisor_notify)
+		s2idle_ops->hypervisor_notify();
+
 	/* Make the current CPU wait so it can enter the idle loop too. */
 	swait_event_exclusive(s2idle_wait_head,
 		    s2idle_state == S2IDLE_STATE_WAKE);
-- 
2.36.1.476.g0c4daa206d-goog

