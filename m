Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFD062D66C
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 10:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiKQJUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 04:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiKQJUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 04:20:47 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB087697CC
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:46 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id v18-20020a637a12000000b0046ed84b94efso968863pgc.6
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 01:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eQEPJgOPIWUDH+dZem5ml4LxCKvLr7RixU00FY0Ygmg=;
        b=DZdptiHSTqNNKB6cdBCYQaBP9VQ3BtxOoT3zvGzRFDQ+UOG8dArNuMyeg3efnG3Crv
         IOyaybFX2E/AAJKduRkrFm3r69DbsOjEQ1831JK3119s/DdXfTf5/Fxkq0c7yTTJXRBn
         n2cBFA4RCYte/PhiyUWwxqqz27IuarfmXjUq5auYWqav1LsfS8GM2Vcy5Jaste3zUy5f
         DOidUkkyFPo/JtkEPfg7qzdMlJ1TZTWupvfkdCn71h3DPapPsF44564hEj+PfJwNva3a
         MIrYPqpSyaEE1JqjIyZIVFnc/05CDIiRdWNWgS/G7agwW85gna2Skt9FUY41jTg3C/BT
         ehpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eQEPJgOPIWUDH+dZem5ml4LxCKvLr7RixU00FY0Ygmg=;
        b=jp+lh+AlGeIOfuJQ54FhMXzYJOaFFo+H5fRh+TS6r2L+dYsiwHg38lGXNKCgaxBAkD
         P92igRLk5PY07J8LFdQK74bsoWkvoe7yb/wJA45rf0FTSE/uOc4PXPiefhRX1QjAudoy
         0v1oQMzqeZrNUTHxoQ33NiujScyAVA8Yst/KKp+wGNhUH9zA0QtAwQkSNqKoLD4qxf7Y
         aq+iE+2obQwaIwkR9np15UMvXdjfZdM/zkFa+38Dx+81CHTlOrWQeqtAV6LVi7G+AEpt
         1IcK0+voTm5bXw9fKYgVb3vgk6mEunqzj0JMQkkGmJ5no0Nnj+svM2K8vCWiPT9siDvm
         7mAQ==
X-Gm-Message-State: ANoB5pkVgggdC+GHkQoZjemsD7Zxn3eYgadgMClsQg16ypH9EXFDBk1T
        3f3H73KNHd2GyGJgR8wYq1n4ZuJWU7ZIUg==
X-Google-Smtp-Source: AA0mqf4vQSuq679sNYgLdb6VQMwrpvuRWX7dWWz+R4Eu1yt+HN+ZuFvUtzX2tirIehOjtVtGGKcOtFSzp+Tu8w==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a62:402:0:b0:56e:d7f4:3c4a with SMTP id
 2-20020a620402000000b0056ed7f43c4amr2064562pfe.76.1668676846399; Thu, 17 Nov
 2022 01:20:46 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:28 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-11-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 10/34] x86/bugs: Add AMD retbleed= boot parameter
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
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

From: Alexandre Chartre <alexandre.chartre@oracle.com>

commit 7fbf47c7ce50b38a64576b150e7011ae73d54669 upstream.

Add the "retbleed=<value>" boot parameter to select a mitigation for
RETBleed. Possible values are "off", "auto" and "unret"
(JMP2RET mitigation). The default value is "auto".

Currently, "retbleed=auto" will select the unret mitigation on
AMD and Hygon and no mitigation on Intel (JMP2RET is not effective on
Intel).

  [peterz: rebase; add hygon]
  [jpoimboe: cleanups]

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: this effectively remove the UNRET mitigation as an option, so it
 has to be complemented by a later pick of the same commit later. This is
 done in order to pick retbleed_select_mitigation]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 .../admin-guide/kernel-parameters.txt         | 12 +++
 arch/x86/kernel/cpu/bugs.c                    | 74 ++++++++++++++++++-
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 500032af0192..6ff8cf136953 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4132,6 +4132,18 @@
 
 	retain_initrd	[RAM] Keep initrd memory after extraction
 
+	retbleed=	[X86] Control mitigation of RETBleed (Arbitrary
+			Speculative Code Execution with Return Instructions)
+			vulnerability.
+
+			off         - unconditionally disable
+			auto        - automatically select a migitation
+
+			Selecting 'auto' will choose a mitigation method at run
+			time according to the CPU.
+
+			Not specifying this option is equivalent to retbleed=auto.
+
 	rfkill.default_state=
 		0	"airplane mode".  All wifi, bluetooth, wimax, gps, fm,
 			etc. communication is blocked by default.
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 54b15d3a0d55..6f5e3b21c72a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -36,6 +36,7 @@
 #include "cpu.h"
 
 static void __init spectre_v1_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
@@ -111,6 +112,12 @@ void __init check_bugs(void)
 
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
+	retbleed_select_mitigation();
+	/*
+	 * spectre_v2_select_mitigation() relies on the state set by
+	 * retbleed_select_mitigation(); specifically the STIBP selection is
+	 * forced for UNRET.
+	 */
 	spectre_v2_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
@@ -705,6 +712,71 @@ static int __init nospectre_v1_cmdline(char *str)
 }
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
+#undef pr_fmt
+#define pr_fmt(fmt)     "RETBleed: " fmt
+
+enum retbleed_mitigation {
+	RETBLEED_MITIGATION_NONE,
+};
+
+enum retbleed_mitigation_cmd {
+	RETBLEED_CMD_OFF,
+	RETBLEED_CMD_AUTO,
+};
+
+const char * const retbleed_strings[] = {
+	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
+};
+
+static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
+	RETBLEED_MITIGATION_NONE;
+static enum retbleed_mitigation_cmd retbleed_cmd __ro_after_init =
+	RETBLEED_CMD_AUTO;
+
+static int __init retbleed_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off"))
+		retbleed_cmd = RETBLEED_CMD_OFF;
+	else if (!strcmp(str, "auto"))
+		retbleed_cmd = RETBLEED_CMD_AUTO;
+	else
+		pr_err("Unknown retbleed option (%s). Defaulting to 'auto'\n", str);
+
+	return 0;
+}
+early_param("retbleed", retbleed_parse_cmdline);
+
+#define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
+#define RETBLEED_COMPILER_MSG "WARNING: kernel not compiled with RETPOLINE or -mfunction-return capable compiler!\n"
+
+static void __init retbleed_select_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
+		return;
+
+	switch (retbleed_cmd) {
+	case RETBLEED_CMD_OFF:
+		return;
+
+	case RETBLEED_CMD_AUTO:
+	default:
+		if (!boot_cpu_has_bug(X86_BUG_RETBLEED))
+			break;
+
+		break;
+	}
+
+	switch (retbleed_mitigation) {
+	default:
+		break;
+	}
+
+	pr_info("%s\n", retbleed_strings[retbleed_mitigation]);
+}
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
@@ -1901,7 +1973,7 @@ static ssize_t srbds_show_state(char *buf)
 
 static ssize_t retbleed_show_state(char *buf)
 {
-	return sprintf(buf, "Vulnerable\n");
+	return sprintf(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
 }
 
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
-- 
2.38.1.431.g37b22c650d-goog

