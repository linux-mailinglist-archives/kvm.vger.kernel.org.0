Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811953677BA
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 05:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhDVDGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 23:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbhDVDGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 23:06:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF952C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k5-20020a2524050000b02904e716d0d7b1so18190666ybk.0
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 20:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ePlwClNSozxsM4hkTmvffDCYGXRwrtXezElqBmwEyv8=;
        b=V2Vlo+gMyAyvVHrK24Nhep6dCSAZ0xJqIM8pEwozjlQk+9bUsWh5msEzicvxY96GWV
         Wpl9La74mcWzsInbh6VBO5WeNkkv6XjoxXfzUd7fjf6z3MNZQ2W5lOFOfL37jXzFoPH2
         jkKomUy2Amhas+lzWtnNl+qXwiF6+lYGBkBwGDiW7/sZ7WZEUvFhWapPEkdyO6IRTNvs
         gmV+p+xbFNMov0lEXp12vkz1QgF3tqo/UR4KGy8aMdTaLD5TCDRCs0KoyIzPTcyMUmud
         nMXmu+3H6CPzZHWu4wztDCY5NC5T7+7qFtEMcDlRo7bQjJq//jrvltRHkjn0bzu6ULdM
         J/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ePlwClNSozxsM4hkTmvffDCYGXRwrtXezElqBmwEyv8=;
        b=PavXNz5Wx39qK/hH0h2VDIP/wvXW6XjoVf/kfT2G2xu3DSelnyb2xlgsA9iQ+eGLKN
         SXSMIUaucHW8jP3gCD0LAnlHVBr18quJEgd3T0dDbNTx0cpk67shtlB6fVWUwGHRxWfk
         4faFiPLEhIuXYRKIBCdVjDc1+D747YNNdcNXOqKL3JfUvOcL/eExYF+p0tW3RNzpphou
         MtzRygEqtLvoWKTflVrOQoF0ihpI85kPbjh5q66f63gecgwKRRrKocPsc/pPz5z065+I
         npIll3ShSxjNF0rc90bkDU3RQsTvXoAzcqxNHIDD8h6tvI6MgopTIYNyMuIe9lmUPWx4
         gKwg==
X-Gm-Message-State: AOAM531tHvc5LdlAq9A1ALRA3eEeQ+hGUGyQPhc47l/2d26xQIi9spob
        A0paKECBTFgEJhP8uIEFXpT3uoB8UEE=
X-Google-Smtp-Source: ABdhPJz2XJkQSsU0xPvS6yPvnqB1MTA6sy3Wd0TC8kAuKCDsc9BTiBGHNZWsTyvd27+kCviBKk8mT01DxY0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:8884:: with SMTP id d4mr1657363ybl.410.1619060738001;
 Wed, 21 Apr 2021 20:05:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 20:05:03 -0700
In-Reply-To: <20210422030504.3488253-1-seanjc@google.com>
Message-Id: <20210422030504.3488253-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210422030504.3488253-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH 13/14] x86: msr: Test that always-canonical
 MSRs #GP on non-canonical value
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that WRMSR takes a #GP when writing a non-canonical value to a
MSR that always takes a 64-bit address.  Specifically, AMD doesn't
enforce a canonical address for the SYSENTER MSRs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 2 ++
 x86/msr.c           | 8 ++++++++
 x86/vmx_tests.c     | 2 --
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index dfe96d0..abc04b0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -6,6 +6,8 @@
 #include "msr.h"
 #include <stdint.h>
 
+#define NONCANONICAL            0xaaaaaaaaaaaaaaaaull
+
 #ifdef __x86_64__
 #  define R "r"
 #  define W "q"
diff --git a/x86/msr.c b/x86/msr.c
index e7ebe8b..8a1b0b2 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -80,6 +80,14 @@ int main(int ac, char **av)
 	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
 		if (is_64bit_host || !msr_info[i].is_64bit_only) {
 			test_msr_rw(&msr_info[i], msr_info[i].value);
+
+			/*
+			 * The 64-bit only MSRs that take an address always perform
+			 * canonical checks on both Intel and AMD.
+			 */
+			if (msr_info[i].is_64bit_only &&
+			    msr_info[i].value == addr_64)
+				test_wrmsr_fault(&msr_info[i], NONCANONICAL);
 		} else {
 			test_wrmsr_fault(&msr_info[i], msr_info[i].value);
 			test_rdmsr_fault(&msr_info[i]);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index bbb006a..2eb5962 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -21,8 +21,6 @@
 #include "smp.h"
 #include "delay.h"
 
-#define NONCANONICAL            0xaaaaaaaaaaaaaaaaull
-
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
 u64 ia32_pat;
-- 
2.31.1.498.g6c1eba8ee3d-goog

