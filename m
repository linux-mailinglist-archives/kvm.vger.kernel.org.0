Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3462EFC59
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbhAIAs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbhAIAs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:48:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6638C061799
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:47:50 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id o9so17248933yba.4
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=d4pr2++w40O0CLns88f/iirKEVNPW2czC2n8QXn3KSs=;
        b=jOYGQisjm9xhAXR+CLMMyJg7LdjSdq9yi0HPO1bF6wAKQ1S7bheGPmquyLr2unxV0i
         Z/GUQBpPxP0mtbaANOzCBQKkFoy3XLHtGui971CsN2lIon9nV0kJC6PdCjXTbKMWGMsS
         bGg4C6ztOfSm3OdTjJnOBjkwVV6EWXSmm/9skbaRspNARSCewKDPS8xFb4SxjTPqiERL
         TO/Ml7hd71+URP+m8JdvZWHhOF3+3tHpGoE0biUtDFojYQgKFZzgL7jubpKjIpzWvJ2G
         Q1tYaGoZQJgxUGpty5T/RMnqFrRDHPjLI7GaxRPkPMou56tSjCJrgihNqJNCKbFFjG+s
         E2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=d4pr2++w40O0CLns88f/iirKEVNPW2czC2n8QXn3KSs=;
        b=JU3kBwU1q1a0efQi9IHGKLbOPNAGYsrF5VR84pUgH9Jqz+7ZpGpQTrWMyFzN90DAW9
         ZQfpk1ZRPozfVO31Gph29NICL79fXzRsh15ydZ9ap331PJtBsO5Fy/Oy9tCIaZJdq0Ks
         ntmZ8cJn3/FYmG8tFEJ1Vez1MbAj1BXZS0nm9tJOob/dCsSpmlrSqlgg7lMyrWm86vJ/
         rgWpf/tbRzfYtd1Mf6/u6L5ej56fWoT7IXVltY8EA2WiMIWqM0SJEeZ11yaH00sdQL0L
         3bHYyyGebn0qY+B/P9q0xdzKuoUeMMW9kVNbwrVwK1xz0ulyAlOFNqHEN+eFV+XF4b7H
         jusA==
X-Gm-Message-State: AOAM532qYrSDnvTgoiyXGR1oKmMfPzPQ0gF6E01MYnBcdCbBDvO6/sEl
        wQyCtwDz/ZvhIsqlpQAjoktNUi95liE=
X-Google-Smtp-Source: ABdhPJxM39JuPDl5IOydMdQW3d2GaPMtqTBVSEufrjpujCuiHWOYifsHOltB/A/6IgqsOGYr4Vw3IoAvxU0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:743:: with SMTP id 64mr8822114ybh.333.1610153269944;
 Fri, 08 Jan 2021 16:47:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:07 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 06/13] x86/sev: Rename global "sev_enabled" flag to "sev_guest"
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
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use "guest" instead of "enabled" for the global "running as an SEV guest"
flag to avoid confusion over whether "sev_enabled" refers to the guest or
the host.  This will also allow KVM to usurp "sev_enabled" for its own
purposes.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/mem_encrypt.h | 2 +-
 arch/x86/mm/mem_encrypt.c          | 4 ++--
 arch/x86/mm/mem_encrypt_identity.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 2f62bbdd9d12..9b3990928674 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -20,7 +20,7 @@
 
 extern u64 sme_me_mask;
 extern u64 sev_status;
-extern bool sev_enabled;
+extern bool sev_guest;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index bc0833713be9..0f798355de03 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(sme_me_mask);
 DEFINE_STATIC_KEY_FALSE(sev_enable_key);
 EXPORT_SYMBOL_GPL(sev_enable_key);
 
-bool sev_enabled __section(".data");
+bool sev_guest __section(".data");
 
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
@@ -344,7 +344,7 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
  */
 bool sme_active(void)
 {
-	return sme_me_mask && !sev_enabled;
+	return sme_me_mask && !sev_guest;
 }
 
 bool sev_active(void)
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 6c5eb6f3f14f..91b6b899c02b 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -545,7 +545,7 @@ void __init sme_enable(struct boot_params *bp)
 
 		/* SEV state cannot be controlled by a command line option */
 		sme_me_mask = me_mask;
-		sev_enabled = true;
+		sev_guest = true;
 		physical_mask &= ~sme_me_mask;
 		return;
 	}
-- 
2.30.0.284.gd98b1dd5eaa7-goog

