Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F36394B33
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 11:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhE2JOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 05:14:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44582 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2JOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 May 2021 05:14:54 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A4B061FD30;
        Sat, 29 May 2021 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622279597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hLBajeRODOVVhWrr6yKi1f/oM4Ln7sgbWW5uEPEvTE=;
        b=0uGjpplLxqUTEB79TkM4cFa0eSNhh78ebQWWqXfjjjBzJG7UZWWwDDNQNolkYRoIp8o093
        vyEitrHyq3Eb9ZGNFYmCQRlodoOY0vtjwYion0s5764mShPmYKw9K9vxMAgH3HHLtvBE3M
        XVXarFa9M310ed5wjMgraMfxrsiuOSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622279597;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hLBajeRODOVVhWrr6yKi1f/oM4Ln7sgbWW5uEPEvTE=;
        b=vGoHCr0/TC8F6hAH+jRrWhyqtXjAdz5wTJB2EaosnveK81laxZoTtyMv3l+SNup8i06Rhx
        m70xq+E2vGI4GFBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 3369911A98;
        Sat, 29 May 2021 09:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622279596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hLBajeRODOVVhWrr6yKi1f/oM4Ln7sgbWW5uEPEvTE=;
        b=kEiKiziEswBdOkQG8HJioFXYra1faue59deYhFUwdwr8Vzee/VZIkuiDSby2y/RDO0rHxD
        4vSceUSIqKMM60Nq3VuFqYG2zfqomsGhPb7l9HzhaF41YSrPhL3ukEWIEJ1hfv/3GeeZqG
        AXs32MGy1S/D4zpxBfX7DKUyCsRr+J0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622279596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hLBajeRODOVVhWrr6yKi1f/oM4Ln7sgbWW5uEPEvTE=;
        b=zM2TaNGtJ0i6jNWmLY5MAolJi5F7/J/aLmCejfweg96pBm4j30hnCkOpTE9POWRe7XooK8
        GAu+ooWTzu/zCdBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id IK6uCqwFsmCbEwAALh3uQQ
        (envelope-from <cfontana@suse.de>); Sat, 29 May 2021 09:13:16 +0000
From:   Claudio Fontana <cfontana@suse.de>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-devel@nongnu.org
Subject: [PATCH 1/2] i386: reorder call to cpu_exec_realizefn in x86_cpu_realizefn
Date:   Sat, 29 May 2021 11:13:12 +0200
Message-Id: <20210529091313.16708-2-cfontana@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210529091313.16708-1-cfontana@suse.de>
References: <20210529091313.16708-1-cfontana@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: *
X-Spam-Score: 1.00
X-Spamd-Result: default: False [1.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLY(-4.00)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCPT_COUNT_TWELVE(0.00)[13];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

we need to expand features first, before we attempt to check them
in the accel realizefn code called by cpu_exec_realizefn().

At the same time we need checks for code_urev and host_cpuid_required,
and modifications to cpu->mwait to happen after the initial setting
of them inside the accel realizefn code.

Partial Fix.

Fixes: 48afe6e4eabf ("i386: split cpu accelerators from cpu.c, using AccelCPUClass")
Signed-off-by: Claudio Fontana <cfontana@suse.de>
---
 target/i386/cpu.c | 56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9e211ac2ce..6bcb7dbc2c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6133,34 +6133,6 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     Error *local_err = NULL;
     static bool ht_warned;
 
-    /* Process Hyper-V enlightenments */
-    x86_cpu_hyperv_realize(cpu);
-
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
-    if (xcc->host_cpuid_required && !accel_uses_host_cpuid()) {
-        g_autofree char *name = x86_cpu_class_get_model_name(xcc);
-        error_setg(&local_err, "CPU model '%s' requires KVM or HVF", name);
-        goto out;
-    }
-
-    if (cpu->ucode_rev == 0) {
-        /* The default is the same as KVM's.  */
-        if (IS_AMD_CPU(env)) {
-            cpu->ucode_rev = 0x01000065;
-        } else {
-            cpu->ucode_rev = 0x100000000ULL;
-        }
-    }
-
-    /* mwait extended info: needed for Core compatibility */
-    /* We always wake on interrupt even if host does not have the capability */
-    cpu->mwait.ecx |= CPUID_MWAIT_EMX | CPUID_MWAIT_IBE;
-
     if (cpu->apic_id == UNASSIGNED_APIC_ID) {
         error_setg(errp, "apic-id property was not initialized properly");
         return;
@@ -6190,6 +6162,34 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
            & CPUID_EXT2_AMD_ALIASES);
     }
 
+    /* Process Hyper-V enlightenments */
+    x86_cpu_hyperv_realize(cpu);
+
+    cpu_exec_realizefn(cs, &local_err);
+    if (local_err != NULL) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    if (xcc->host_cpuid_required && !accel_uses_host_cpuid()) {
+        g_autofree char *name = x86_cpu_class_get_model_name(xcc);
+        error_setg(&local_err, "CPU model '%s' requires KVM or HVF", name);
+        goto out;
+    }
+
+    if (cpu->ucode_rev == 0) {
+        /* The default is the same as KVM's.  */
+        if (IS_AMD_CPU(env)) {
+            cpu->ucode_rev = 0x01000065;
+        } else {
+            cpu->ucode_rev = 0x100000000ULL;
+        }
+    }
+
+    /* mwait extended info: needed for Core compatibility */
+    /* We always wake on interrupt even if host does not have the capability */
+    cpu->mwait.ecx |= CPUID_MWAIT_EMX | CPUID_MWAIT_IBE;
+
     /* For 64bit systems think about the number of physical bits to present.
      * ideally this should be the same as the host; anything other than matching
      * the host can cause incorrect guest behaviour.
-- 
2.26.2

