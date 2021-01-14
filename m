Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F102F567B
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbhANBsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbhANAjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:39:44 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0815C0617BC
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:55 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id y187so3017792qke.20
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Eex86gs96hXZoQkhC7w4R41A1RqEr+1bAqfy74t/uNE=;
        b=sNbbozuRHglAPmDNM3t2ZBQKhdBPsyzcxyC0flAsMj+J3jsbYRvq3Wr3TvUCV/XREN
         bMI3C+ufPzudYBYmTGBZ5/BZB6AHF9fms/jbQ7GEzHpXv61YjON5uHQ3VXpIY5OVaFZO
         sApoLda/kV4sTXxEIupOGGDN/gQ+AFqPpkSMFiMKVPN8SDfnntmbt60bjFPINYWX3PJD
         560Gs4wOoNZwKAsh7FEI25Ydsk9TZvWvbE25DwB7ISB4QiazsN3C6oDq2f0JUuE4MG8v
         RkUIyuv5zH4M2OHZEDQqy9YS0VmvYcvW6zFvzoQUvQeFezEtltf9e8eOipjg2l3q+VEE
         FOxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Eex86gs96hXZoQkhC7w4R41A1RqEr+1bAqfy74t/uNE=;
        b=Ci/q9vQ9Loj+qmfWBi34mtHBCapFNC3mECXPJQFsyf4DiR1XGxETYyGcDraaHy8BZF
         Gg3rlr4vChpqI70jvCBcpOoSkHN8CHg2ExCIEP7IZeWhg13O03nJ+ozyev6RG4fOv7A5
         YuWNaX6et+0u1aBOFfTHLX5H/n7B/fnkeVTmYFqJg5x8XDaNo7wryu1Xi6Ak3PAHUaCa
         zvt2WYFs2uJL5ESjun1Zm9Ffo30fxQ03jqsPnOes0StbQuepNGhX8g98gCXpzAqH3gni
         l8pV8vRCWToPHKdcsNMVKSFvpKVM5EQf+ekmuWX3Wbx98WTYax1xmPIPGdi3ObQOleMm
         /OQg==
X-Gm-Message-State: AOAM533snTQoJRD6UX3JkDb1uI0S6ojMfxCTmOP8yrorV+MD+eGpkzXq
        SBK2YnOqIiB2BXihvHx2vRzFCkhW4e0=
X-Google-Smtp-Source: ABdhPJwxLJFIcGZAW1SDEzJekpBS1zpkc/ptjpzUb3ZhOdP4HHSylaa/lyrgMl3PsCTZHSmE0euTzijUicw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:500c:: with SMTP id e12mr7458603ybb.129.1610584675025;
 Wed, 13 Jan 2021 16:37:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:02 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 08/14] KVM: SVM: Condition sev_enabled and sev_es_enabled
 on CONFIG_KVM_AMD_SEV=y
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define sev_enabled and sev_es_enabled as 'false' and explicitly #ifdef
out all of sev_hardware_setup() if CONFIG_KVM_AMD_SEV=n.  This kills
three birds at once:

  - Makes sev_enabled and sev_es_enabled off by default if
    CONFIG_KVM_AMD_SEV=n.  Previously, they could be on by default if
    CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y, regardless of KVM SEV
    support.

  - Hides the sev and sev_es module params when CONFIG_KVM_AMD_SEV=n.

  - Resolves a false positive -Wnonnull in __sev_recycle_asids() that is
    currently masked by the equivalent IS_ENABLED(CONFIG_KVM_AMD_SEV)
    check in svm_sev_enabled(), which will be dropped in a future patch.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a024edabaca5..02a66008e9b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,12 +28,17 @@
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 /* enable/disable SEV support */
+#ifdef CONFIG_KVM_AMD_SEV
 static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev, sev_enabled, bool, 0444);
 
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+#else
+#define sev_enabled false
+#define sev_es_enabled false
+#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
@@ -1253,11 +1258,12 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_hardware_setup(void)
 {
+#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled)
+	if (!sev_enabled)
 		goto out;
 
 	/* Does the CPU support SEV? */
@@ -1311,6 +1317,7 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+#endif
 }
 
 void sev_hardware_teardown(void)
-- 
2.30.0.284.gd98b1dd5eaa7-goog

