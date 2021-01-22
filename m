Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F031300EDD
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbhAVV0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731111AbhAVUXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:23:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13527C0617AA
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id r1so6523969ybd.23
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EACBA81rA48HC0vzvM1sNbOzKQYdPtj86guoyyxTvpA=;
        b=Dn7VxB4Wu8BKwcmnIMhYUsZP2+EyurOkh4VCWdD44I6yVacVSSx/420Qfc+l6YAil4
         B6+jxiTByvIGgVJoDQbxjAxjrrVrm6QpsnnUlITsS/rTYLLNJDEyxQ/ovhExCZRgPcYf
         pZV+bPPMR/l6agFFNKO405M5A29A4mhUKYEMOC1x65eUtZsYniLCuk4yjte4dTGcb8RO
         7p4vmkHf2dbxbkxdnQMGnrpxijse5SUMOIpZ8MlFn9nL+XNqXvXqUrQiowV3pKlpg5m9
         Ta1jaZk4EnKCYcUUl1j+BuX40wHKjH4sJfu1YpsFV21WaiVeacWeEz2wWibZGgH+aSrQ
         NWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EACBA81rA48HC0vzvM1sNbOzKQYdPtj86guoyyxTvpA=;
        b=XC4K78yUGEBnGEZHIKgdIGVE/dJ5OFvEXRdTbKx/c8xmkKnR/0Tz0ShPszoMaOcn4L
         BmXH9Kb3OtDHfTQCZ2QceDAPLbyHUzNnksLswj721mSrtcRb7S0mBXG9AVijfAHIBRNB
         OJCM8lESlz00mJNit+PgUtLLFkINAxZBhiuNSiKLBPkEAEoYGdCkjyfAabJNFCojpFI/
         yRrm27PwKVqeNwPauRC1bGAJE8kziG3T9CY+PLug13+PlUz4LLPxzXkAiTC0HVoE1FuV
         HHC9umcaFDRLU6Ibo/mYPnWvh3lqMqzH0S7o0dhNXHNGjE4isPHtyE4E8CX7Ai7k1u+j
         eXPA==
X-Gm-Message-State: AOAM532NXiAqNTozdf5EWQuynA7NK/+LcO6tgf0yALQIQsGNyZfv/PXR
        66KaqJcTHgLeeMlVBgKS2opw5qJqUYM=
X-Google-Smtp-Source: ABdhPJxEYTwBxrAhhJ7dDR5evCT/f0oqAZB9IAlB9LE9xBS7xvN1iZ85LdDhRCReEj7VC4QSeU7B1IMedo0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:a183:: with SMTP id a3mr8567872ybi.459.1611346921346;
 Fri, 22 Jan 2021 12:22:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:35 -0800
In-Reply-To: <20210122202144.2756381-1-seanjc@google.com>
Message-Id: <20210122202144.2756381-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210122202144.2756381-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 04/13] x86/sev: Drop redundant and potentially misleading 'sev_enabled'
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
index c79e5736ab2b..bcca8f8f27a7 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -44,8 +44,6 @@ EXPORT_SYMBOL(sme_me_mask);
 DEFINE_STATIC_KEY_FALSE(sev_enable_key);
 EXPORT_SYMBOL_GPL(sev_enable_key);
 
-bool sev_enabled __section(".data");
-
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -373,16 +371,16 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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
2.30.0.280.ga3ce27912f-goog

