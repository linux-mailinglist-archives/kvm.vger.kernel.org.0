Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA06249682F
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiAUXTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiAUXTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:09 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F7AC06173D
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:08 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id w15-20020a17090aea0f00b001b53b829d6bso1921407pjy.5
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=n+WOoUCw6GIgZHHaZg7LKmL44X/JvWPSQfloYrEyIDg=;
        b=Uhn97sFJ9LTUSquO/Q+Ia3Jgdfc7EaXrXrNbiC2sU19PB3PufQm4JSqfnu8lrNi+Qn
         gpSg4SRf7adgMTtFh/3SVZuA+X0KTw45YJRSRQwbBMoHdeE0/Y009R6bsgJPL8JYREmK
         noYVGKubudgNQCxba/fr71Wd7CsM5Lz+caq5ZacEeCsmY8rMg/cPGS2gSs1nBIJZ9qjf
         y2/z3A1awR3PXpSxvfkKxZTl3Cf5uYBXnAe93aLs6B0WAzFz0xYiAl9Bz4vfHHdGnpDb
         BRk5LZgIr6WiYGc9TwV6SSApM4GLcIx2C7cxdcOOw60c8lnhSL7+MTSfo/JOCA2kuV0p
         g9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=n+WOoUCw6GIgZHHaZg7LKmL44X/JvWPSQfloYrEyIDg=;
        b=3Z5XB5kV4+xw5yfiEi1AuQUY0C/5THPAcOjOpBjnjZhrQAcZ0Z/6jLX2i2WzNR3ZzK
         pFthMc0THCMGIVd48PcgeDBk+5zwY5pFwlsn1WS12GZdqnEh+/AKtfh4KPqSiqJiVctJ
         dw99iiX7pHGE0GQlcc8DVjiz7qmJ3DUbVF6G6YFfJETY9F7wLgZJ9PiWuopD7ryX6sEp
         qt7CZ18dYW3HpKtPdqeF1qvlbpmpABJFnFayGBNMTn1WOSrolJBgeRVkQTUO3zXzcOWS
         H0rmy9+KYrH3MhUm8kMnaD0tflPIblMZmPvOF+CR1sV3iahH5r7aSTrXdlDBEMRGCQ57
         cAGg==
X-Gm-Message-State: AOAM531wr3SKwFW4EI7IzDjJ0kHwHRv4IrF8zS7vN3kisWEssLTptreg
        pJG03MZX2kUCUmNQV/s90pOPQgY9FQw=
X-Google-Smtp-Source: ABdhPJy2T0zBJ1cu61nSaTsBvCl/20crJQADsrDnVUTg1w5bc/Pj2jPPMxsSVBHzyk0zhEUf4agYkm4gWBE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9802:0:b0:4bf:f7a0:83b6 with SMTP id
 e2-20020aa79802000000b004bff7a083b6mr5738180pfl.17.1642807147684; Fri, 21 Jan
 2022 15:19:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:51 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 7/8] x86: apic: Track APIC ops on a per-cpu basis
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the virtual function table to handle xAPIC vs. x2APIC on a per-cpu
basis.  Using a common global is racy as nothing in KUT synchronizes
CPUs when switching to/from x2APIC.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/apic.c | 20 ++++++++++++--------
 lib/x86/smp.h  |  2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 44a6ad38..d7137b61 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -2,6 +2,7 @@
 #include "apic.h"
 #include "msr.h"
 #include "processor.h"
+#include "smp.h"
 #include "asm/barrier.h"
 
 void *g_apic = (void *)0xfee00000;
@@ -15,6 +16,11 @@ struct apic_ops {
 	u32 (*id)(void);
 };
 
+static struct apic_ops *get_apic_ops(void)
+{
+	return this_cpu_read_apic_ops();
+}
+
 static void outb(unsigned char data, unsigned short port)
 {
 	asm volatile ("out %0, %1" : : "a"(data), "d"(port));
@@ -60,8 +66,6 @@ static const struct apic_ops xapic_ops = {
 	.id = xapic_id,
 };
 
-static const struct apic_ops *apic_ops = &xapic_ops;
-
 static u32 x2apic_read(unsigned reg)
 {
 	unsigned a, d;
@@ -96,12 +100,12 @@ static const struct apic_ops x2apic_ops = {
 
 u32 apic_read(unsigned reg)
 {
-	return apic_ops->reg_read(reg);
+	return get_apic_ops()->reg_read(reg);
 }
 
 void apic_write(unsigned reg, u32 val)
 {
-	apic_ops->reg_write(reg, val);
+	get_apic_ops()->reg_write(reg, val);
 }
 
 bool apic_read_bit(unsigned reg, int n)
@@ -113,12 +117,12 @@ bool apic_read_bit(unsigned reg, int n)
 
 void apic_icr_write(u32 val, u32 dest)
 {
-	apic_ops->icr_write(val, dest);
+	get_apic_ops()->icr_write(val, dest);
 }
 
 uint32_t apic_id(void)
 {
-	return apic_ops->id();
+	return get_apic_ops()->id();
 }
 
 uint8_t apic_get_tpr(void)
@@ -152,7 +156,7 @@ int enable_x2apic(void)
 		asm ("rdmsr" : "=a"(a), "=d"(d) : "c"(MSR_IA32_APICBASE));
 		a |= 1 << 10;
 		asm ("wrmsr" : : "a"(a), "d"(d), "c"(MSR_IA32_APICBASE));
-		apic_ops = &x2apic_ops;
+		this_cpu_write_apic_ops((void *)&x2apic_ops);
 		return 1;
 	} else {
 		return 0;
@@ -162,7 +166,7 @@ int enable_x2apic(void)
 void disable_apic(void)
 {
 	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) & ~(APIC_EN | APIC_EXTD));
-	apic_ops = &xapic_ops;
+	this_cpu_write_apic_ops((void *)&xapic_ops);
 }
 
 void reset_apic(void)
diff --git a/lib/x86/smp.h b/lib/x86/smp.h
index eb037a46..bd303c28 100644
--- a/lib/x86/smp.h
+++ b/lib/x86/smp.h
@@ -15,6 +15,7 @@ struct percpu_data {
 		};
 		uint32_t exception_data;
 	};
+	void *apic_ops;
 };
 
 #define typeof_percpu(name) typeof(((struct percpu_data *)0)->name)
@@ -66,6 +67,7 @@ BUILD_PERCPU_OP(smp_id);
 BUILD_PERCPU_OP(exception_vector);
 BUILD_PERCPU_OP(exception_rflags_rf);
 BUILD_PERCPU_OP(exception_error_code);
+BUILD_PERCPU_OP(apic_ops);
 
 void smp_init(void);
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

