Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE62105B2A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 21:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKUUe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 15:34:28 -0500
Received: from mail-vs1-f73.google.com ([209.85.217.73]:53381 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKUUe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 15:34:28 -0500
Received: by mail-vs1-f73.google.com with SMTP id q189so880834vsb.20
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 12:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Kacb+BmwjoTjHjJ+F3FWP7jSRbu4MID2mm6obnvWS8M=;
        b=S0cH232JJ4hnmeZeWNy53Q74IRYxRZKfSBOqFwAMBF/Rs+q99lYAwJA5uG7lGy+/Ch
         ZbPv7LCIlFWNWoZfv9Mtvu/bM298j6NTTe98gjG/GuYzjkunlpdtVJtK0IZssBipbEUY
         xvoqzgNa4Z2aUEgoOs4K3GjOkAoNmKZHR6R2+jdMCpzTbGScu7Ou6Wu/aE0Q65JtteYH
         y6s8vqlH2WC3hVc1Vgnd1xuGMCV+OFKxtC/sotRjbDxZSWgO4Vzi/bFY0OO8XjBVvEVS
         4XsMdcbcsoeC7L9ei7qBroDE3IlHI/6Ne/e8Y2bG7/DsLQBejsmH50uHal7Mrw4aBkCy
         SX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kacb+BmwjoTjHjJ+F3FWP7jSRbu4MID2mm6obnvWS8M=;
        b=kI7oQpmhlLhdptpdJl5Fp2B6vsTKujYVW/bFr3zNK2eiFPl6BuXLSBmc8Bc9oT+wLi
         4JkHdKWrk4jr2wh9HLtaT4YKwFf5Wj29u3V1KWchJ3VMzPTi9WKRUqJmL/uoknI2yB/m
         lceXEZ3rzjyOHa7qy4jOI0T0NDbkMv99GZjOMH0I/bAgdEpcm0OxbsEW0jSsfunm8+y5
         lvhxdo/2N4mPnerDUUtp6/yWUGqWoC/foL+u4NSnumLEUkRzQTnU42vMGT5ucej4gGqC
         sTSulpkt68u8kFapYxClfnsBRphGfeU5lL9GWxbQm2e2jtecPEUZaUNh4i11NoD9432P
         D0cg==
X-Gm-Message-State: APjAAAUtY1Zb/Emrm2A5S7iht8NYutWuMB6HpPSp72Fm9dyt8xmOP9qL
        kBqjTIntyjUhJrcYsK1UrTbDNMQAf7s=
X-Google-Smtp-Source: APXvYqzidnQxmrDfDCZgWfLuJrT1LoiPmUVXOL90CRBRhKlXVLajyUx2gn5KG2H90Aymz9QSn4bS7mIX9Q0=
X-Received: by 2002:a67:e3a3:: with SMTP id j3mr7162107vsm.133.1574368467060;
 Thu, 21 Nov 2019 12:34:27 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:33:43 -0800
In-Reply-To: <20191121203344.156835-1-pgonda@google.com>
Message-Id: <20191121203344.156835-2-pgonda@google.com>
Mime-Version: 1.0
References: <20191121203344.156835-1-pgonda@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH 1/2] KVM x86: Move kvm cpuid support out of svm
From:   Peter Gonda <pgonda@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Memory encryption support does not have module parameter dependencies
and can be moved into the general x86 cpuid __do_cpuid_ent function.
This changes maintains current behavior of passing through all of
CPUID.8000001F.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 5 +++++
 arch/x86/kvm/svm.c   | 7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f68c0c753c38..946fa9cb9dd6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -778,6 +778,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 0x8000001a:
 	case 0x8000001e:
 		break;
+	/* Support memory encryption cpuid if host supports it */
+	case 0x8000001F:
+		if (!boot_cpu_has(X86_FEATURE_SEV))
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c5673bda4b66..79842329ebcd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5936,13 +5936,6 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 		if (npt_enabled)
 			entry->edx |= F(NPT);
 
-		break;
-	case 0x8000001F:
-		/* Support memory encryption cpuid if host supports it */
-		if (boot_cpu_has(X86_FEATURE_SEV))
-			cpuid(0x8000001f, &entry->eax, &entry->ebx,
-				&entry->ecx, &entry->edx);
-
 	}
 }
 
-- 
2.24.0.432.g9d3f5f5b63-goog

