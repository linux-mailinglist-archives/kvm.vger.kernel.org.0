Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDB62F55A5
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 01:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbhANAmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 19:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbhANAjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:39:54 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A52C0617B9
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:50 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id 189so3043706qko.1
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DDUHIUBA8SLHvStbYmjdJVTHYjMXIrwXrhEB8ai7MVY=;
        b=qkzN5/B31jy88ZpNpPR+BBPPcUB8nL0++4Spb8fCnQwaLGL/YbByi7M3SGS4Z/n0+s
         C1xB4mFr1fLgRi3PzFzYfk7OKY8HYlsFDgN9x/UfTJAOxU7O7mj8rnd1+B8tsBm5tpk1
         qAH+JQRCZ7bpI06i1Cr5Se4FUewwXp3t+JkMnGESZFaV58c66zw2AXq5onH850wcGBBL
         nVYEQ06OYzdxeR6eWL7YgpStup3OB5WFL5coXbCvYhGP9u/Rfk+8ddoOsL2yL/gh5hW1
         qXTYRfVA7vJuSxCKmAcq7AsJw1FEsZnU10U1JoTcyGS/ugOgRT5iwn73LcJK7BIV5PCE
         tm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DDUHIUBA8SLHvStbYmjdJVTHYjMXIrwXrhEB8ai7MVY=;
        b=Pwams/ZABcVcGgYqGWlToTZt4qEm8VqTCUKzEn/HGylHwQP6PBpdlnpZolhex5VJ1F
         dfHsvmaINnCPwRxpyYQOl10ZqvHSdPR1o6AZFXOOm4vLtakAMRYq1cZ0J/TZW/j27sIp
         Xe8OyIVHKjYaivapEyaFJvt6AOlTTy7HnKhuLHcMWrceGoYaEzvuvkjKtCBV2XXZ2l4z
         uvpfZ/n9LTSfw8az7p+MStP4yuIUCoyXtsBkI5u9gsYlRISyDmge9r6Cn6pwrPg3NiHq
         axa+kz6LdhJwSph2TB/1rmVIqkf044EUw7/5TxTOWXPj/SywD4l61mDusz6gKLadBKhg
         viFQ==
X-Gm-Message-State: AOAM530+hkkEfr4H5VlWvFWyTgPlfuOAKJWWJsaW2h8VQY/M6zhBRR33
        m5DgwF0pXIh2wGgi0ptxvonTtmz5DCU=
X-Google-Smtp-Source: ABdhPJxyDhm3M2JAmEWge+qYJWZw2joo4TnBbgEXhE0VgsY14p15rC2IBck+hLLI1HjzlM8vifZUP1PsJbU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a5b:482:: with SMTP id n2mr6421468ybp.25.1610584669838;
 Wed, 13 Jan 2021 16:37:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:00 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 06/14] x86/sev: Drop redundant and potentially misleading 'sev_enabled'
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/mem_encrypt.h |  1 -
 arch/x86/mm/mem_encrypt.c          | 12 +++++-------
 arch/x86/mm/mem_encrypt_identity.c |  1 -
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 2f62bbdd9d12..88d624499411 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -20,7 +20,6 @@
 
 extern u64 sme_me_mask;
 extern u64 sev_status;
-extern bool sev_enabled;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index bc0833713be9..b89bc03c63a2 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -44,8 +44,6 @@ EXPORT_SYMBOL(sme_me_mask);
 DEFINE_STATIC_KEY_FALSE(sev_enable_key);
 EXPORT_SYMBOL_GPL(sev_enable_key);
 
-bool sev_enabled __section(".data");
-
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -342,16 +340,16 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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
 
+bool sme_active(void)
+{
+	return sme_me_mask && !sev_active();
+}
+
 /* Needs to be called from non-instrumentable code */
 bool noinstr sev_es_active(void)
 {
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
2.30.0.284.gd98b1dd5eaa7-goog

