Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91545F16A3
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiI3XZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiI3XZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:25:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81660C80F1
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:09 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w14-20020a170902e88e00b00177ab7a12f6so4068274plg.16
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=nL/lfFme3jtjL6Ze3CyERsb/LSTZ5YkGYrnD4NBE2Hw=;
        b=V/SjIoKmXFbrqT/binJvKHwdo3qdjqQCerJbBH/12Uc0FFc89bANMUmDqoGbfTRK5U
         L7yOtqX1cogO1+gHiLwAe/CBdRYReBpcOxpTbzQEGWoUveubNHmHsXNGIbVA8ox2webe
         n8zLcyeySOTHUeHaT928bcvRQncEqXHPN3tBuVEQZRCGfzxX9bBZe0nRlnNw6AYQkHK7
         dlpXp8cwBBsGQ5E8zi40OQUc3N9y2LQRPSmCJ2Y7h9jXK0nQ6jiTxtRYmwnxu7GFieyi
         n/0aYKRGTUD48PkYQQyXYdJU+jGfX6RO2yAgXvitjdNa6ooUVRfv7foO1GMv/sUmyK63
         J94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=nL/lfFme3jtjL6Ze3CyERsb/LSTZ5YkGYrnD4NBE2Hw=;
        b=BIa6xoQEDaKvOGnxVq2RuckOv6laBBUiL4djD+DcC8LZq38eX7TT0/PpwyN7917XtB
         HkXV1uPzEmtSOCmBrfNa7ITiyiVS+zFgDIJA/lvdD00dbDcrMV7azI3lybAOU6sIE4sI
         0VaAiK4EQ4oNfTETXHGaeRdq/o17r2Q2sDJjXcayc78UNwBImALunszKpWIjpMH0t+Xa
         PQajAVj8ZY/2P6mG+mZ7HlsTH77ZWBh2WsLAsuD8kTYO6RyAWCIWlfjIymlDpLnPwcQj
         F8a1WlJE+M7eaGdtmMQblfasDRMbiS6Ptur9pgYojb94DKJrQSOKdfqdXFN4FSQCpkMh
         h+9A==
X-Gm-Message-State: ACrzQf2TRxeEDmKA49UAoUf502woU3GuTLud+CH7WcN6/kvS1vC139WU
        dqUjdg+CHyneIEQyoB76n5w1s0oNb8g=
X-Google-Smtp-Source: AMsMyM7O3dnQbXaA7lnqaczL9ag44xopYssk6pKMbWEK5nOMoCVeThtSOfQ91nWw/nDBPo4RNcxEneddvBU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b085:b0:178:3af4:31b2 with SMTP id
 p5-20020a170902b08500b001783af431b2mr11378613plr.122.1664580296930; Fri, 30
 Sep 2022 16:24:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:24:50 +0000
In-Reply-To: <20220930232450.1677811-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220930232450.1677811-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930232450.1677811-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] nVMX: Dedup the bulk of the VMREAD/VMWRITE
 #PF tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dedup most of the VMREAD/VMWRITE #PF/flags tests, they are identical
except for literally VMREAD vs. VMRITE.  Don't bother adding a macro to
emit VMREAD vs. VMWRITE, the macro required isn't any better than copy
and paste.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 119 ++++++++++++++++++++----------------------------------
 1 file changed, 43 insertions(+), 76 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 0ae134d..e28507c 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -387,102 +387,69 @@ static void test_vmwrite_vmread(void)
 	free_page(vmcs);
 }
 
-static void prep_flags_test_env(void **vpage, struct vmcs **vmcs)
-{
-	/*
-	 * get an unbacked address that will cause a #PF
-	 */
-	*vpage = alloc_vpage();
-
-	/*
-	 * set up VMCS so we have something to read from
-	 */
-	*vmcs = alloc_page();
-
-	memset(*vmcs, 0, PAGE_SIZE);
-	(*vmcs)->hdr.revision_id = basic.revision;
-	assert(!vmcs_clear(*vmcs));
-	assert(!make_vmcs_current(*vmcs));
-}
-
-static void test_read_sentinel(u8 sentinel)
+static void __test_vmread_vmwrite_pf(bool vmread, u64 *val, u8 sentinel)
 {
 	unsigned long flags = sentinel;
 	unsigned int vector;
-	struct vmcs *vmcs;
-	void *vpage;
-
-	prep_flags_test_env(&vpage, &vmcs);
 
 	/*
-	 * Execute VMREAD with a not-PRESENT memory operand, and verify a #PF
-	 * occurred and RFLAGS were not modified.
+	 * Execute VMREAD/VMWRITE with a not-PRESENT memory operand, and verify
+	 * a #PF occurred and RFLAGS were not modified.
 	 */
-	asm volatile ("sahf\n\t"
-		      ASM_TRY("1f")
-		      "vmread %[enc], %[val]\n\t"
-		      "1: lahf"
-		      : [val] "=m" (*(u64 *)vpage),
-			[flags] "+a" (flags)
-		      : [enc] "r" ((u64)GUEST_SEL_SS)
-		      : "cc");
+	if (vmread)
+		asm volatile ("sahf\n\t"
+			      ASM_TRY("1f")
+			      "vmread %[enc], %[val]\n\t"
+			      "1: lahf"
+			      : [val] "=m" (*val),
+			        [flags] "+a" (flags)
+			      : [enc] "r" ((u64)GUEST_SEL_SS)
+			      : "cc");
+	else
+		asm volatile ("sahf\n\t"
+			      ASM_TRY("1f")
+			      "vmwrite %[val], %[enc]\n\t"
+			      "1: lahf"
+			      : [val] "=m" (*val),
+			        [flags] "+a" (flags)
+			      : [enc] "r" ((u64)GUEST_SEL_SS)
+			      : "cc");
 
 	vector = exception_vector();
 	report(vector == PF_VECTOR,
-	       "Expected #PF on VMREAD, got exception 0x%x", vector);
+	       "Expected #PF on %s, got exception '0x%x'\n",
+	       vmread ? "VMREAD" : "VMWRITE", vector);
 
 	report((u8)flags == sentinel,
 	       "Expected RFLAGS 0x%x, got 0x%x", sentinel, (u8)flags);
 }
 
+static void test_vmread_vmwrite_pf(bool vmread)
+{
+	struct vmcs *vmcs = alloc_page();
+	void *vpage = alloc_vpage();
+
+	memset(vmcs, 0, PAGE_SIZE);
+	vmcs->hdr.revision_id = basic.revision;
+	assert(!vmcs_clear(vmcs));
+	assert(!make_vmcs_current(vmcs));
+
+	/*
+	 * Test with two values to candy-stripe the 5 flags stored/loaded by
+	 * SAHF/LAHF.
+	 */
+	__test_vmread_vmwrite_pf(vmread, vpage, 0x91);
+	__test_vmread_vmwrite_pf(vmread, vpage, 0x45);
+}
+
 static void test_vmread_flags_touch(void)
 {
-	/*
-	 * Test with two values to candy-stripe the 5 flags stored/loaded by
-	 * SAHF/LAHF.
-	 */
-	test_read_sentinel(0x91);
-	test_read_sentinel(0x45);
-}
-
-static void test_write_sentinel(u8 sentinel)
-{
-	unsigned long flags = sentinel;
-	unsigned int vector;
-	struct vmcs *vmcs;
-	void *vpage;
-
-	prep_flags_test_env(&vpage, &vmcs);
-
-	/*
-	 * Execute VMWRITE with a not-PRESENT memory operand, and verify a #PF
-	 * occurred and RFLAGS were not modified.
-	 */
-	asm volatile ("sahf\n\t"
-		      ASM_TRY("1f")
-		      "vmwrite %[val], %[enc]\n\t"
-		      "1: lahf"
-		      : [val] "=m" (*(u64 *)vpage),
-			[flags] "+a" (flags)
-		      : [enc] "r" ((u64)GUEST_SEL_SS)
-		      : "cc");
-
-	vector = exception_vector();
-	report(vector == PF_VECTOR,
-	       "Expected #PF on VMWRITE, got exception '0x%x'\n", vector);
-
-	report((u8)flags == sentinel,
-	       "Expected RFLAGS 0x%x, got 0x%x", sentinel, (u8)flags);
+	test_vmread_vmwrite_pf(true);
 }
 
 static void test_vmwrite_flags_touch(void)
 {
-	/*
-	 * Test with two values to candy-stripe the 5 flags stored/loaded by
-	 * SAHF/LAHF.
-	 */
-	test_write_sentinel(0x91);
-	test_write_sentinel(0x45);
+	test_vmread_vmwrite_pf(false);
 }
 
 static void test_vmcs_high(void)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

