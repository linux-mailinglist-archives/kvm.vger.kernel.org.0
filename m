Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2658481C
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiG1WSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiG1WSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:18:22 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD7F79697
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:09 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i63-20020a638742000000b0041b082610f7so1449000pge.14
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=RPzTmS/0r8A1CyXZM2Rci6TWGc35txpn0qeX6XuTsqs=;
        b=qHhsT9hs16IF/EHMDyGRcUT6ZEGIKVqDhn0BuFZVNej7rTgNck6aieiRMk+e3jn79j
         tdzfk/AMZvzu05J19+IxR2qC+FvHnu6AzWYspgHXLYA5QuN3v/BhEc3ZMGVNoBWqQbCY
         2gYo2Se6S8YTikr/r/lEI5p7OtL/OhMPnYSmzQe52Y7h6Ju1stuM6HVVS4h35sfrVgKW
         nLexqMIzeEa8H4Rizy3jGkbl/LcbM2CLCtj3vv6PrYLTk4JDV5MItVwmBra5vrEhBfOx
         gZTp7ubiZ2ZSn1KNAVEXBxWZ/t8GpVCMwy/nYp2IBIu0jCLosgvMB3Kl1qHgAuucx6oe
         S5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=RPzTmS/0r8A1CyXZM2Rci6TWGc35txpn0qeX6XuTsqs=;
        b=3AZuX/aTz+yksJsampnfh79HAvLp6LZDFBDEvp18q70XIi/LhNNIi9jBWqOJiAGi9I
         SDYhgtmQ6iO/E24K3+dH29UTIEdrCJNVt4KExMwFwTRMu3r5Efadf6vaVUG+b8LogmMd
         knzSEj+auCMKaTg7IQfzd0ghuB2WJm1TEIN1QJJr+nWvhQkyMY6M4nHgFMoa9sBR3gs3
         4md64ZqCCAkPKUtWqUyCjipAHLeG885CO5P68zcH0V1oKxge2xPlTJkelsX0X9xeoo+n
         +0XI5HVgfDoAYjW9Ve9+9IXdNqCpQc6tvpDOwfAvRgBZ0zqo1Nc/XH5dw7VLGjKGds6b
         tnSA==
X-Gm-Message-State: AJIora8dj4AgRBj8Pkanh98bD+eW9YBUAL9GTjx0oUbKSNPLZIyNE29d
        sVWWWiBBFNU2oehCeyfs2h70ZNWjgjQ=
X-Google-Smtp-Source: AGRyM1sIcKz8IHgdc4YVb7+rQA93yxD8RqktXwO2yoYSVwKQ/47pl+miOoDUZ1Cy3wmRrZAVPHNga7rX/k0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:fd4f:0:b0:41b:539b:ba8e with SMTP id
 m15-20020a63fd4f000000b0041b539bba8emr638124pgj.17.1659046688633; Thu, 28 Jul
 2022 15:18:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 28 Jul 2022 22:17:59 +0000
In-Reply-To: <20220728221759.3492539-1-seanjc@google.com>
Message-Id: <20220728221759.3492539-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220728221759.3492539-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 4/4] KVM: SVM: Disable SEV-ES support if MMIO caching is disable
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable SEV-ES if MMIO caching is disabled as SEV-ES relies on MMIO SPTEs
generating #NPF(RSVD), which are reflected by the CPU into the guest as
a #VC.  With SEV-ES, the untrusted host, a.k.a. KVM, doesn't have access
to the guest instruction stream or register state and so can't directly
emulate in response to a #NPF on an emulated MMIO GPA.  Disabling MMIO
caching means guest accesses to emulated MMIO ranges cause #NPF(!PRESENT),
and those flavors of #NPF cause automatic VM-Exits, not #VC.

Fixes: b09763da4dd8 ("KVM: x86/mmu: Add module param to disable MMIO caching (for testing)")
Reported-by: Michael Roth <michael.roth@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h      |  2 ++
 arch/x86/kvm/mmu/spte.c |  1 +
 arch/x86/kvm/mmu/spte.h |  2 --
 arch/x86/kvm/svm/sev.c  | 10 ++++++++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index a99acec925eb..6bdaacb6faa0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -6,6 +6,8 @@
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
 
+extern bool __read_mostly enable_mmio_caching;
+
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 66f76f5a15bd..03ca740bf721 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -22,6 +22,7 @@
 bool __read_mostly enable_mmio_caching = true;
 static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
+EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
 u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 26b144ffd146..9a9414b8d1d6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,8 +5,6 @@
 
 #include "mmu_internal.h"
 
-extern bool __read_mostly enable_mmio_caching;
-
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
  * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 309bcdb2f929..05bf6301acac 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 
+#include "mmu.h"
 #include "x86.h"
 #include "svm.h"
 #include "svm_ops.h"
@@ -2205,6 +2206,15 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled)
 		goto out;
 
+	/*
+	 * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
+	 * instruction stream, i.e. can't emulate in response to a #NPF and
+	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
+	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
+	 */
+	if (!enable_mmio_caching)
+		goto out;
+
 	/* Does the CPU support SEV-ES? */
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
-- 
2.37.1.455.g008518b4e5-goog

