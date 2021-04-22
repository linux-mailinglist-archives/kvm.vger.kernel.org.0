Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03DD367730
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhDVCMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbhDVCMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436DDC06138F
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f7-20020a5b0c070000b02904e9a56ee7e7so18148942ybq.9
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j2n81J9a4jJKEUp0Y3hcOM8LEO2kCL/9wUVifJR5WM4=;
        b=QrS0Itr2o8faau0sUVq1Ev7I5yCrHDh6NOGnnrAetiQhh0ZYDEsqDydGjkyI2aCs7x
         GCfAolaCA4d1lugTu4SnTrP6K6mFHKnBmV8H4jJ2L6iZr9BHNZGjUYydyTBJM0wIFCgy
         15FNugOqDsvhxj2bhWM1RVi0LAmCAmZurD6lspvH0rIsVJ5iGNcpT0/A3aooWyMJEy4g
         FzPdsdVSf4aeU2dGfIIdKds/ds/Hbat6s6vW9zHlYqD+7DauODCnGEuywoaHpraBYuY8
         WNIoidVlSoymBV52UxLCgGwlEAAfJ5zJYZjqs2BwyZceM3/pjPGSMyvudAx6Vd2rcWH5
         eXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j2n81J9a4jJKEUp0Y3hcOM8LEO2kCL/9wUVifJR5WM4=;
        b=lF/FnpGzmtBG+E3UWYc06rEnVUPUi9npqvACC+On2id+r7MWbjjKp/yrUFevrGeb+d
         FJQq+KttodQ4twUgHwhVNEkQPhlQaQsQFLZ+lYHkxc3aTmL+VF8rSlXXS4OtoQFzb3ql
         +zZeqTU4+hCC9PbNuesECaGQTPiOe1EjEJefnDTQHGLtCChD5EaqVY0xmRlVDY02dgti
         mI43mA2y0UDdyLFGnJtD0dzlqyhHIPrqQcT+pa0E6pfpzb2aOBUm+MOOsajsuDeVSezm
         hpbNEFf0Fa2lOjeDK5M8VhDfif18SUCVvt6CNk5konAHe/ypJCkouVwTBBezEzCj7bqp
         H8Cw==
X-Gm-Message-State: AOAM530qTjle/W8M1dC2dbPvG07J/xghZu98dRL80eAhv0/mYqjXCdFF
        jXCSu3UwiIUwIy2rWhe1JiAvMcmWTfs=
X-Google-Smtp-Source: ABdhPJwGnz9AMKpq65nlp/dakd+2NEl6jzEALsuM2hT7nQNpincQXA5xmDRA6ogCA8mWx6s+TF9m54whds0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:b88a:: with SMTP id w10mr1323117ybj.392.1619057501562;
 Wed, 21 Apr 2021 19:11:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:16 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 06/15] x86/sev: Drop redundant and potentially misleading 'sev_enabled'
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
2.31.1.498.g6c1eba8ee3d-goog

