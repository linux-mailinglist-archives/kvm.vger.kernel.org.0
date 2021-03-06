Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6879F32F7A6
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhCFB7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCFB73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:29 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6397BC061760
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:29 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n10so4552207ybb.12
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=erTc+Y0pENbjog4sK1UscwxpK+OyCX6EbKLiihdV5ms=;
        b=bdKAXPakwfpRG5gErpaS9lhAcAk5LKm7JnBzB0LPddluuRIapvesrGhOTlvx4I7Rcz
         dBwGlJQ4DGpRFJdOMm9CPdIyyfpmUOfU4H4AhhJx3eJdM7c0YU/EB0FXAHmKYM3hNeWd
         HQ4oRuP8D/eQrW2nDfZFDhTUhrN33GBCXxIdqDxIjhweyL8CsdNzQk0VczBrjC3JOtQd
         1TncCLqdl5zwQXdJHh4fAAZESKeDoHt1w0kwQa4wVHCP8Q34LbjhaYq4kCAyjJoUOnZT
         L4mBWs5KLkuqWx6zjtQ6iUI2sFjKi4Ih5cT9elze+aRX6ImV2JpWnN4zjW8BG14a3yPc
         RJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=erTc+Y0pENbjog4sK1UscwxpK+OyCX6EbKLiihdV5ms=;
        b=WPgwGBuQOpbHwvhYM4c8oGH/VelMi/SymwQHmFU3iifl+kcb9DqNwWZ3L1aop/cmH/
         n5ZHoNRdFdD1DThnvB8zH5MLWagps5eFGxn+3bipeyD9/n58a0Luh3gT75XWTZAZgDYz
         y5HGxrCvcoLBBtFQNmuYoRglboP0k7TEYdEck/4OUIq8MVk8eqtobbXMk9HVzLldFeG9
         pfhaME8/He2qmmM1Z4s14bFWFVwPn9RAxiCBe/ExT+gK3MQlOPiPZQVLoi+oMy1UP6sI
         00CGYg1r2Vb5Rc8PuDghWvDadxzc9iI7QYK4xFrdTgPvDkRUK4DbO2335dYuI4h9okLH
         g1vw==
X-Gm-Message-State: AOAM531/ZAzmkIoVhI/noiCMJf8zqHPgwZ/nm/xLzt2gfRDB0Vp/bQqB
        UAPe3UbfivV89xV6dmJfLYya4c04His=
X-Google-Smtp-Source: ABdhPJwcz3i6hvaLxWLUUYBOmhghhlsk2nbIlO81RY5plRGPB9FBvR77ZFDqPThk50G08KXZ3lV6FYwpnKk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a25:cc43:: with SMTP id l64mr18609790ybf.283.1614995968623;
 Fri, 05 Mar 2021 17:59:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:58:56 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 05/14] x86/sev: Drop redundant and potentially misleading 'sev_enabled'
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

Drop the sev_enabled flag and switch its one user over to sev_active().
sev_enabled was made redundant with the introduction of sev_status in
commit b57de6cd1639 ("x86/sev-es: Add SEV-ES Feature Detection").
sev_enabled and sev_active() are guaranteed to be equivalent, as each is
true iff 'sev_status & MSR_AMD64_SEV_ENABLED' is true, and are only ever
written in tandem (ignoring compressed boot's version of sev_status).

Removing sev_enabled avoids confusion over whether it refers to the guest
or the host, and will also allow KVM to usurp "sev_enabled" for its own
purposes.

No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/mem_encrypt.h |  1 -
 arch/x86/mm/mem_encrypt.c          | 12 +++++-------
 arch/x86/mm/mem_encrypt_identity.c |  1 -
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 31c4df123aa0..9c80c68d75b5 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -20,7 +20,6 @@
 
 extern u64 sme_me_mask;
 extern u64 sev_status;
-extern bool sev_enabled;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 4b01f7dbaf30..be384d8d0543 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -44,8 +44,6 @@ EXPORT_SYMBOL(sme_me_mask);
 DEFINE_STATIC_KEY_FALSE(sev_enable_key);
 EXPORT_SYMBOL_GPL(sev_enable_key);
 
-bool sev_enabled __section(".data");
-
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -373,15 +371,15 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
  * up under SME the trampoline area cannot be encrypted, whereas under SEV
  * the trampoline area must be encrypted.
  */
-bool sme_active(void)
-{
-	return sme_me_mask && !sev_enabled;
-}
-
 bool sev_active(void)
 {
 	return sev_status & MSR_AMD64_SEV_ENABLED;
 }
+
+bool sme_active(void)
+{
+	return sme_me_mask && !sev_active();
+}
 EXPORT_SYMBOL_GPL(sev_active);
 
 /* Needs to be called from non-instrumentable code */
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 6c5eb6f3f14f..0c2759b7f03a 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -545,7 +545,6 @@ void __init sme_enable(struct boot_params *bp)
 
 		/* SEV state cannot be controlled by a command line option */
 		sme_me_mask = me_mask;
-		sev_enabled = true;
 		physical_mask &= ~sme_me_mask;
 		return;
 	}
-- 
2.30.1.766.gb4fecdf3b7-goog

