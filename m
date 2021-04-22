Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53560367755
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhDVCWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhDVCWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:22:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6D0C06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u3-20020a2509430000b02904e7f1a30cffso18210430ybm.8
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mOGXDXzhpmjx3GQXAE3F8jbPyKEywOEsLX4Y9QabnGA=;
        b=GU+uTAsFDPr0l/vq7k1GGUfFG0HY63xcX5Yc3k+1WVkUkhlV2oO5V1JwVX8bEE0aBS
         mQndo+u+3ZaNchbjRiiF39LSRsv0my7vXosl7viM9rYXMSXfOZQBFzSd3S1x2aSDNnRK
         IUv6ZDjZxwHZNRNH0rGz3IxcW/JQrdgrhrZUz0mfN47Jzwfd6t/AiR9LR+X3E+JPRVl9
         h2oNFcwWD3p7tlB12ls6LLJ9kL24gUvlbuml5QTtbdoqKnhK0O1mRRWb8RB33UiQaKSu
         BLV7RQhh19lOJwYLvKPpQv8TtmI4DDzoXyP8uUx7OnBZu/K22M+Dyk6WMgyaFdgYtyZa
         XGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mOGXDXzhpmjx3GQXAE3F8jbPyKEywOEsLX4Y9QabnGA=;
        b=hRIe2hyv5SJ0mY4AB3fqVuFjDEUbF14Yq1YRrk/12/kGkt3BQCJA47ByjJc6YT5PMW
         slt7S5+AcVaGtpMKR+gQg4KSKqFnxzZ6m78Drk43iJzXY/PBtQEdEIdCpw8GyntHKCPz
         GpZwHZF2H+gVHCS7tzQ8vq/kKs2Oht/UQGaOwfjDJrfEEYYcytk4vMnbeVWRTKC/EjfD
         w2MjLMWelsIP77qDV14fjFNjvoPhQdkH5OX89fjEyVjoiPxXWnFTNe/Zi+TuS25+WF4X
         PJCDwsuND0f4SpkvB9yUUT4O4UVHaA92t7YMQxVdmbBpL9J9uBsM0ZsKg8ybIjkvLlWi
         fGSg==
X-Gm-Message-State: AOAM531FkdkA7xGEPq7Z/McL+rA8I0hAgDhLloUB+wNfQ5PwBYYN5fEd
        ElAn+NUiKI9eQTlgmWPgrcSSr/Uc83U=
X-Google-Smtp-Source: ABdhPJzk1VEX5RsnrgizC3w7WKpIWyjE7FzekhwM/pl5AX/kpTpBb+6bgSoManqeL0KyEcHO4He2vZribeE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:e04b:: with SMTP id x72mr1418298ybg.337.1619058092969;
 Wed, 21 Apr 2021 19:21:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:21:20 -0700
In-Reply-To: <20210422022128.3464144-1-seanjc@google.com>
Message-Id: <20210422022128.3464144-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210422022128.3464144-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 1/9] KVM: x86: Remove emulator's broken checks on
 CR0/CR3/CR4 loads
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the emulator's checks for illegal CR0, CR3, and CR4 values, as
the checks are redundant, outdated, and in the case of SEV's C-bit,
broken.  The emulator manually calculates MAXPHYADDR from CPUID and
neglects to mask off the C-bit.  For all other checks, kvm_set_cr*() are
a superset of the emulator checks, e.g. see CR4.LA57.

Fixes: a780a3ea6282 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 68 +-----------------------------------------
 1 file changed, 1 insertion(+), 67 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f7970ba6219f..f4273b8e31fa 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4230,75 +4230,9 @@ static int check_cr_read(struct x86_emulate_ctxt *ctxt)
 
 static int check_cr_write(struct x86_emulate_ctxt *ctxt)
 {
-	u64 new_val = ctxt->src.val64;
-	int cr = ctxt->modrm_reg;
-	u64 efer = 0;
-
-	static u64 cr_reserved_bits[] = {
-		0xffffffff00000000ULL,
-		0, 0, 0, /* CR3 checked later */
-		CR4_RESERVED_BITS,
-		0, 0, 0,
-		CR8_RESERVED_BITS,
-	};
-
-	if (!valid_cr(cr))
+	if (!valid_cr(ctxt->modrm_reg))
 		return emulate_ud(ctxt);
 
-	if (new_val & cr_reserved_bits[cr])
-		return emulate_gp(ctxt, 0);
-
-	switch (cr) {
-	case 0: {
-		u64 cr4;
-		if (((new_val & X86_CR0_PG) && !(new_val & X86_CR0_PE)) ||
-		    ((new_val & X86_CR0_NW) && !(new_val & X86_CR0_CD)))
-			return emulate_gp(ctxt, 0);
-
-		cr4 = ctxt->ops->get_cr(ctxt, 4);
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-
-		if ((new_val & X86_CR0_PG) && (efer & EFER_LME) &&
-		    !(cr4 & X86_CR4_PAE))
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	case 3: {
-		u64 rsvd = 0;
-
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-		if (efer & EFER_LMA) {
-			u64 maxphyaddr;
-			u32 eax, ebx, ecx, edx;
-
-			eax = 0x80000008;
-			ecx = 0;
-			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
-						 &edx, true))
-				maxphyaddr = eax & 0xff;
-			else
-				maxphyaddr = 36;
-			rsvd = rsvd_bits(maxphyaddr, 63);
-			if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PCIDE)
-				rsvd &= ~X86_CR3_PCID_NOFLUSH;
-		}
-
-		if (new_val & rsvd)
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	case 4: {
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-
-		if ((efer & EFER_LMA) && !(new_val & X86_CR4_PAE))
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	}
-
 	return X86EMUL_CONTINUE;
 }
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

