Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09F53677B6
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhDVDGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbhDVDGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F4DC06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so18187314ybi.2
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OlwYWy4ln3T9i3QnTXhy9ZtTs4wA1cxSHpskq0tbb5I=;
        b=C9iXc1KHtB3fo2I4oYbmgciCjD/BbUril1/5piSp1ODcouThJ02hAELypt+G4UZyI6
         vpPPSMOHBz24cdctxdz9+Hv4uGo+RVzqDN+G5vE+WC0u5rBrhE6tFosv2fKA6FmSrHXW
         UM/FtWaYuCRQFp3kCZFgfneISOuKi6N/p1iufTbFQGBxGOFpabbXkNFu/6FB+DUkvMOQ
         lOxJYce7so3M/v1k2FT8CTAOtPPQm9TLggFMZiFyaLtX0eiOeKN9LASFDBhp9hpC+D8B
         DFnoPEkuXxaBj+Ihd5ATHUw4/VqT2/QRyr3reCnEgPL0lIpBpv8zPClb7U/NaA4bblpY
         45KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OlwYWy4ln3T9i3QnTXhy9ZtTs4wA1cxSHpskq0tbb5I=;
        b=KZBOJ0QdIxuIJ3XYO0TmXY7xLmkoFAC3ac05h/6Rgfyr1SgDK2iBgJ/4NkirzwPrGe
         n0hJK+Y1HA42FT1QEv5Z9xboEwEpY5nk7oYbA4rHBrYzVTnR3CavHpoSoUPNsnvIAQYi
         qq7KbKOlC98q40fnBmd4NsSkUScUrthIRaG4K6UriyfySlpSzyt+6NKbjhflUVOjS92y
         3rYMLn9cw6Xul//sAccu/5T3tqDpHzOeEozeC19JHeWU8ylcgQckpAiZRWJtVUGDX4np
         3iu1+4NvywCdUqRdMMxTxGPG9CziSpFcn3XJhZLdsVllSutYEMDlZ4ZSxO88ALERQBPo
         QjCQ==
X-Gm-Message-State: AOAM530HnbHkI/yMBrrZzgC1u0PtaOLGFxZIK60UqaNaIb08BHc24lkV
        Ze+NQRpt2FBRFFIBDW1jnAvtSdywwoE=
X-Google-Smtp-Source: ABdhPJzZOu0OVpf3PwP/Sn5vSiOPrFSSpcki2GC6manPm8qAVgYOoZe8TUBD3j/e41aM2Yt5eX7tJ9AmoDU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:8543:: with SMTP id f3mr1590886ybn.80.1619060726784;
 Wed, 21 Apr 2021 20:05:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:04:58 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 08/14] x86: msr: Use the #defined MSR indices
 in favor of open coding the values
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the #defines from msr.h in the MSR test, and tweak the SYSENTER names
to match for good measure.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index b60ca94..0fc7978 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -20,42 +20,42 @@ struct msr_info {
 
 struct msr_info msr_info[] =
 {
-	{ .index = 0x00000174, .name = "IA32_SYSENTER_CS",
+	{ .index = MSR_IA32_SYSENTER_CS, .name = "MSR_IA32_SYSENTER_CS",
 	  .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
 	},
-	{ .index = 0x00000175, .name = "MSR_IA32_SYSENTER_ESP",
+	{ .index = MSR_IA32_SYSENTER_ESP, .name = "MSR_IA32_SYSENTER_ESP",
 	  .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
 	},
-	{ .index = 0x00000176, .name = "IA32_SYSENTER_EIP",
+	{ .index = MSR_IA32_SYSENTER_EIP, .name = "MSR_IA32_SYSENTER_EIP",
 	  .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
 	},
-	{ .index = 0x000001a0, .name = "MSR_IA32_MISC_ENABLE",
+	{ .index = MSR_IA32_MISC_ENABLE, .name = "MSR_IA32_MISC_ENABLE",
 	  // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
 	  .val_pairs = {{ .valid = 1, .value = 0x400c51889, .expected = 0x400c51889}}
 	},
-	{ .index = 0x00000277, .name = "MSR_IA32_CR_PAT",
+	{ .index = MSR_IA32_CR_PAT, .name = "MSR_IA32_CR_PAT",
 	  .val_pairs = {{ .valid = 1, .value = 0x07070707, .expected = 0x07070707}}
 	},
 #ifdef __x86_64__
-	{ .index = 0xc0000100, .name = "MSR_FS_BASE",
+	{ .index = MSR_FS_BASE, .name = "MSR_FS_BASE",
 	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
 	},
-	{ .index = 0xc0000101, .name = "MSR_GS_BASE",
+	{ .index = MSR_GS_BASE, .name = "MSR_GS_BASE",
 	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
 	},
-	{ .index = 0xc0000102, .name = "MSR_KERNEL_GS_BASE",
+	{ .index = MSR_KERNEL_GS_BASE, .name = "MSR_KERNEL_GS_BASE",
 	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
 	},
-	{ .index = 0xc0000080, .name = "MSR_EFER",
+	{ .index = MSR_EFER, .name = "MSR_EFER",
 	  .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
 	},
-	{ .index = 0xc0000082, .name = "MSR_LSTAR",
+	{ .index = MSR_LSTAR, .name = "MSR_LSTAR",
 	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
 	},
-	{ .index = 0xc0000083, .name = "MSR_CSTAR",
+	{ .index = MSR_CSTAR, .name = "MSR_CSTAR",
 	  .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
 	},
-	{ .index = 0xc0000084, .name = "MSR_SYSCALL_MASK",
+	{ .index = MSR_SYSCALL_MASK, .name = "MSR_SYSCALL_MASK",
 	  .val_pairs = {{ .valid = 1, .value = 0xffffffff, .expected = 0xffffffff}}
 	},
 #endif
-- 
2.31.1.498.g6c1eba8ee3d-goog

