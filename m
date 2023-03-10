Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54496B5305
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjCJVnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjCJVnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:43:04 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9EA138F64
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:52 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a4eba107so67488607b3.19
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UrFhrRLgy4Dg7VovQ+m+3/2rGjIGNfnIAOJyLCSFf1Q=;
        b=qQ+4AyQAna687GJeq1zGtgOyFtmS1w3jtYz4FxMhBtg0lbNygd8Mtb2g/rxO2C94As
         0EKxHnLe54GiTzuuwahCZJK/rPIGfBhgh8AYes4+mkcHguNyymDZuqgWf8baRgONgwL1
         wfjX09kHm5e5++W9qSH2agNbrp3nafdyYIjTOJqT6EBKmMEyhZoAcJXuqXP1avhhkzMh
         i3Oy4Ls1L2pp31NVom87D1//vSRgAROsc4pJlhAg29jfi8xT31pLTM8b3ql45VMt7TIe
         OkCHMGoOIExz8wmDzriKley7k5NsXPgw4tZxEDEGtaKlC/M3L61MSSGig4WEQaf5y9ap
         dHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrFhrRLgy4Dg7VovQ+m+3/2rGjIGNfnIAOJyLCSFf1Q=;
        b=nNv0z6JOdrx/8kiwPkgUOeRW5mUet1SU5Vtd9wcTpt+bq0XVedakq6ETOHhIsPzmn3
         ts7n5Ig37KkT89PUgx0oEZvRsQZmsWgEYupwy6WEEyR0je87R7B49jaqDzBzVS2xlMxY
         fj8WqEzlBoztaASbdHIaMxCjOplQ7E1oML/0kViq1b8y+kOnis4mrcM+/Fi6GWQcsgCP
         zYUgax+sURvrlsY48D0fcMrbFa7hwpansy3sEfKHskEkaJLNu0TjQnT4fv3w156lkiWQ
         ZN/jK3kvzGefljJdP/Rwg/hlyvpvfmyTD8f+c39apVTKxojvV+9g1lGX/7grWXTopWRq
         Syjw==
X-Gm-Message-State: AO0yUKXt5S95HbCtCz28AJK73jNcTKTCqXYrh/Vnlv4WaDcU6Yyldb3v
        dSzI/JZZNlnewWjQ2+wvC+t7xEwQ4H4=
X-Google-Smtp-Source: AK7set9TFEc3oTesArKh9Ws9c6BUZ+TSGo/LrZDYAyFGB2o2J1VOe93sFXt1Bj5IPfDy7vgejDyqooqjrdw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10e:b0:98e:6280:74ca with SMTP id
 o14-20020a056902010e00b0098e628074camr14382907ybh.1.1678484570964; Fri, 10
 Mar 2023 13:42:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:21 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-8-seanjc@google.com>
Subject: [PATCH v2 07/18] x86/reboot: Disable virtualization during reboot iff
 callback is registered
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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

Attempt to disable virtualization during an emergency reboot if and only
if there is a registered virt callback, i.e. iff a hypervisor (KVM) is
active.  If there's no active hypervisor, then the CPU can't be operating
with VMX or SVM enabled (barring an egregious bug).

Note, IRQs are disabled, which prevents KVM from coming along and enabling
virtualization after the fact.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/reboot.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index cb268ec7ce85..dd7def3d4144 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -22,7 +22,6 @@
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
 #include <asm/pci_x86.h>
-#include <asm/virtext.h>
 #include <asm/cpu.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
@@ -568,7 +567,6 @@ void cpu_emergency_disable_virtualization(void)
 		callback();
 	rcu_read_unlock();
 }
-#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
 
 static void emergency_reboot_disable_virtualization(void)
 {
@@ -585,7 +583,7 @@ static void emergency_reboot_disable_virtualization(void)
 	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
 	 * other CPUs may have virtualization enabled.
 	 */
-	if (cpu_has_vmx() || cpu_has_svm(NULL)) {
+	if (rcu_access_pointer(cpu_emergency_virt_callback)) {
 		/* Safely force _this_ CPU out of VMX/SVM operation. */
 		cpu_emergency_disable_virtualization();
 
@@ -593,6 +591,9 @@ static void emergency_reboot_disable_virtualization(void)
 		nmi_shootdown_cpus_on_restart();
 	}
 }
+#else
+static void emergency_reboot_disable_virtualization(void) { }
+#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
 
 
 void __attribute__((weak)) mach_reboot_fixups(void)
-- 
2.40.0.rc1.284.g88254d51c5-goog

