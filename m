Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D17D496827
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiAUXTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiAUXS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:18:59 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE28CC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:18:58 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f12-20020a056902038c00b006116df1190aso21990070ybs.20
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=k9+02H/b9cZWfXU040BIEraMHF94xseyGasouD/ukXE=;
        b=akN1N8v3J1R5e+e+MMpXo+xEXm/oMaDhCiVSSEEf5fDi/KpKvzPJmGIfhC6+JqWc9w
         g/Bz7TdVbtmUKfMMcSaaWQlF91+p4sf0xYJXZ2UDzWVE5Hhn8+qfpZrmi1F1RsVZPJb3
         fTuvQuZ8AEAyShANFdVumRUlmkWMSQTg1Bt2Wh/oxwkZyd3yxvWBFqKs67UlAgFOq/0Y
         +JXlxA4/VT1ukxTKcBB33yguBMY2p06xxEv1sXxVN1dbFNvLYkf2hbraSWf2+BBt0LmE
         dFZwyah0z36IlHL2jNDyIGzhl1ntSJumiwPTIBUb0xNq8bmWU7i2enETWnHYR4aQs8hq
         NvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=k9+02H/b9cZWfXU040BIEraMHF94xseyGasouD/ukXE=;
        b=SvE7txsUuWnSlGzkqKYK03Ei6xURH4VaMg4oU1Gl8ZpmpWfFEkF/d2i/91zBQ3i4Fc
         MIcKqnpEyGkBLxfkFeQCbtTuMOYkVnrMYtybueogpAgMSWeu0mE19brb24Q3LG/dmYCv
         dn3Nb8ZPCV9zsmEF1b7FIrldUWCbNI3pJ7LNvm6/JW1/HUl/rpk6os6mDEdOrzh25b68
         57h/6fkIf9tU8cK7mVXw8l0jQz3TAZf6lZJNjirZwdgkqhpadT+A1b/Tmyq+D4xik7o/
         RGUDE9zTz1YtoP/bZRXeNIwm8PGfLlZRUifQwYdREVoDNIHYGP3RaLRPpE4u6dmI5OKm
         gbJQ==
X-Gm-Message-State: AOAM533sZ2nsmbb146CEWpfhbMHOscx/ib6T/w4ag117PpdidlCG3B4t
        rUBzx55OhDRhyqdelunxk/2EMiJcpnY=
X-Google-Smtp-Source: ABdhPJySJZzr0zce/lrZssJog+NrRSGREVpJiqnXxrviDqzZVTsKW9KU4GgTrOMK2NlBT8QY7LlaIPVi19k=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:34d0:: with SMTP id b199mr9400071yba.307.1642807138215;
 Fri, 21 Jan 2022 15:18:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:45 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 1/8] x86: Always use legacy xAPIC to get APIC
 ID during TSS setup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Force use of xAPIC to retrieve the APIC ID during TSS setup to fix an
issue where an AP can switch apic_ops to point at x2apic_ops before
setup_tss() completes, leading to a #GP and triple fault due to trying
to read an x2APIC MSR without x2APIC being enabled.

A future patch will make apic_ops a per-cpu pointer, but that's not of
any help for 32-bit, which uses the APIC ID to determine the GS selector,
i.e. 32-bit KUT has a chicken-and-egg problem.  All setup_tss() callers
ensure the local APIC is in xAPIC mode, so just force use of xAPIC in
this case.

Fixes: 7e33895 ("x86: Move 32-bit GDT and TSS to desc.c")
Fixes: dbd3800 ("x86: Move 64-bit GDT and TSS to desc.c")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.c  | 5 +++++
 lib/x86/apic.h  | 2 ++
 lib/x86/setup.c | 4 ++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index da8f3013..b404d580 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -48,6 +48,11 @@ static uint32_t xapic_id(void)
     return xapic_read(APIC_ID) >> 24;
 }
 
+uint32_t pre_boot_apic_id(void)
+{
+	return xapic_id();
+}
+
 static const struct apic_ops xapic_ops = {
     .reg_read = xapic_read,
     .reg_write = xapic_write,
diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index c4821716..7844324b 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -53,6 +53,8 @@ bool apic_read_bit(unsigned reg, int n);
 void apic_write(unsigned reg, uint32_t val);
 void apic_icr_write(uint32_t val, uint32_t dest);
 uint32_t apic_id(void);
+uint32_t pre_boot_apic_id(void);
+
 
 int enable_x2apic(void);
 void disable_apic(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index bbd34682..64217add 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -109,7 +109,7 @@ unsigned long setup_tss(u8 *stacktop)
 	u32 id;
 	tss64_t *tss_entry;
 
-	id = apic_id();
+	id = pre_boot_apic_id();
 
 	/* Runtime address of current TSS */
 	tss_entry = &tss[id];
@@ -129,7 +129,7 @@ unsigned long setup_tss(u8 *stacktop)
 	u32 id;
 	tss32_t *tss_entry;
 
-	id = apic_id();
+	id = pre_boot_apic_id();
 
 	/* Runtime address of current TSS */
 	tss_entry = &tss[id];
-- 
2.35.0.rc0.227.g00780c9af4-goog

