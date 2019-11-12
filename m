Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED90CF9C04
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfKLVWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:22:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38562 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfKLVVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:21:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so13256415wro.5;
        Tue, 12 Nov 2019 13:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references;
        bh=sxfWnb04loE+ufYyv1Wnndt+fSb262tNn1S8lwredBU=;
        b=MSXUxw78HBDlq1p7PiHOSntg0KyQhFOFyMAHC97OUWdgSAlhrN22EXMTgYNKlBZLs5
         R/pd54nxXTk6mJJ+p5lFmhqDh85P9ATLxUB7PlIkyp7UVccU2XL3DsWw0eeOzcohSsKi
         z6G4OZjnNF+HHy4Doj1yODDREsUiooUXxTtsepjz3QqAVXJLc96vxVd0f7Uk8Svl/F0e
         AwoI+B7oxMQl2NWE22xme1V8hMP/2J7Al8kHoIp004/gbLQR6525FHGlbj6GQ4m446Rd
         KGjFFHOkjQ0TkfwH+yOifNoakVSs6H0+XEAWDxUd9XRFMqVFQrPCTlzrPw3bnnJlBXqX
         jQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references;
        bh=sxfWnb04loE+ufYyv1Wnndt+fSb262tNn1S8lwredBU=;
        b=MP6POC35utP+4YznWm9RIzBXrJyrFtEOrkyJ1vTzokSWZ1FiQThnPfY9NqGeJOMkKX
         hu5gmcgx6AqpYZ24/Sd82+0M1MMTEFBwTKI2zDvtiTZY22K52PWUBo4PetZLrw0wjDaZ
         OwpaK4HdAjEAjqtHmg7FmQWVvEpx/X8FEbZw4Kegb/wv5wrecvAZkk/MACl4ZXFi5N+h
         ilY567LQxTUTPqIkfeobdaGy0lbH3wzD/PSYdjkNcWIOz3q4gtrrJtLV2gh8vcth+1tb
         5k3suqI+4jroXBgj03uSzrMdve9x3Ul2ULaYJlqG2FcpYdRemei75dWCXy1jEBfLq0hW
         Vq9g==
X-Gm-Message-State: APjAAAWW5W/oBv5O6F7JM/rIwaI/AWRyn8xJNfdOrc3eI4t3fBvJSSs+
        QnUEaMr5Py/A8FP2NWrcixAvX1am
X-Google-Smtp-Source: APXvYqxaPiuoHfSVC02lyEPNcWNd+rR6mublWqggRhF+2xWQ5wNDaEnyVR7kvUMiM043ibmf6aHU4Q==
X-Received: by 2002:adf:d18b:: with SMTP id v11mr29233145wrc.308.1573593701550;
        Tue, 12 Nov 2019 13:21:41 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm198664wra.3.2019.11.12.13.21.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:21:40 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 3/7] cpu/speculation: Uninline and export CPU mitigations helpers
Date:   Tue, 12 Nov 2019 22:21:33 +0100
Message-Id: <1573593697-25061-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

A kernel module may need to check the value of the "mitigations=" kernel
command line parameter as part of its setup when the module needs
to perform software mitigations for a CPU flaw.

Uninline and export the helper functions surrounding the cpu_mitigations
enum to allow for their usage from a module.

Lastly, privatize the enum and cpu_mitigations variable since the value of
cpu_mitigations can be checked with the exported helper functions.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h | 25 ++-----------------------
 kernel/cpu.c        | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2a093434e975..bc6c879bd110 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -218,28 +218,7 @@ static inline void cpu_smt_check_topology(void) { }
 static inline int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval) { return 0; }
 #endif
 
-/*
- * These are used for a global "mitigations=" cmdline option for toggling
- * optional CPU mitigations.
- */
-enum cpu_mitigations {
-	CPU_MITIGATIONS_OFF,
-	CPU_MITIGATIONS_AUTO,
-	CPU_MITIGATIONS_AUTO_NOSMT,
-};
-
-extern enum cpu_mitigations cpu_mitigations;
-
-/* mitigations=off */
-static inline bool cpu_mitigations_off(void)
-{
-	return cpu_mitigations == CPU_MITIGATIONS_OFF;
-}
-
-/* mitigations=auto,nosmt */
-static inline bool cpu_mitigations_auto_nosmt(void)
-{
-	return cpu_mitigations == CPU_MITIGATIONS_AUTO_NOSMT;
-}
+extern bool cpu_mitigations_off(void);
+extern bool cpu_mitigations_auto_nosmt(void);
 
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index fc28e17940e0..e2cad3ee2ead 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2373,7 +2373,18 @@ void __init boot_cpu_hotplug_init(void)
 	this_cpu_write(cpuhp_state.state, CPUHP_ONLINE);
 }
 
-enum cpu_mitigations cpu_mitigations __ro_after_init = CPU_MITIGATIONS_AUTO;
+/*
+ * These are used for a global "mitigations=" cmdline option for toggling
+ * optional CPU mitigations.
+ */
+enum cpu_mitigations {
+	CPU_MITIGATIONS_OFF,
+	CPU_MITIGATIONS_AUTO,
+	CPU_MITIGATIONS_AUTO_NOSMT,
+};
+
+static enum cpu_mitigations cpu_mitigations __ro_after_init =
+	CPU_MITIGATIONS_AUTO;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {
@@ -2390,3 +2401,17 @@ static int __init mitigations_parse_cmdline(char *arg)
 	return 0;
 }
 early_param("mitigations", mitigations_parse_cmdline);
+
+/* mitigations=off */
+bool cpu_mitigations_off(void)
+{
+	return cpu_mitigations == CPU_MITIGATIONS_OFF;
+}
+EXPORT_SYMBOL_GPL(cpu_mitigations_off);
+
+/* mitigations=auto,nosmt */
+bool cpu_mitigations_auto_nosmt(void)
+{
+	return cpu_mitigations == CPU_MITIGATIONS_AUTO_NOSMT;
+}
+EXPORT_SYMBOL_GPL(cpu_mitigations_auto_nosmt);
-- 
1.8.3.1


