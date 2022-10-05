Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D495F5D63
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJEXy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJEXy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:54:26 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5392586803
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:54:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-35813c409cbso3516037b3.5
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WuMhGRBQfJ+v5adgFv9CGHyazfwgEv9CuQJ/Cfhf22Q=;
        b=RcN87O6UvQH/tGKDx0TUX6YKvKRheaKftygRlZmXKuJDAA1edXw6KwFRU9OfcDeJCM
         deVltYrV2WD2dblMffD+8fgPS7dNgEuUy/T62EIvBQ8POf+K56xMl/ABEkuRnoHowdmg
         XD4y28RGIcPNmDpz3DHTdbohexLbHUKX10wZoP/4k6u9K4IWg2kkopan6HzoP8cCzpOM
         II3F8aVu7i6W/BovBF8mdky4BOpzoXXWbKQUBsgNaDRQ0cYyYHNJ6gysPfTZrNh6a2yb
         cLpbZ5irrqAdO242m4qS0tkL7fI62kNX2PvjvuBdI5rEyyFd6GDKPhTZAXHRuDqQWb9S
         VvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WuMhGRBQfJ+v5adgFv9CGHyazfwgEv9CuQJ/Cfhf22Q=;
        b=GXW55b9hnc6fUk5xyrBycfL68LDlofa0wt401isqmT+jjNROO1g39Y5cVyWNSYr5wr
         HjK6zXOLytdxLrS13G75XNACKzfsHQZtNEiqcHGibXHhnH8aqlu2aorRjIiP9OO3rcGq
         7OJq6KMCp/w5ZrI9ILd3zyZEXMwEpQKf9LP6vzpSEWs7tz1jWcgeCVhZizTUzCre0amD
         uVO2t59TQcoKziwNhAGh/vJWogrXaSeykDPubtfwbCQf6yMpvEr2CsnyhADO9oDk84qu
         nmU7bEN3tcnm1qyuwDpRcYu4MP/CRS8iCSWZSkm1qaYmlQ66CAPh5xFkE9ZmYF3nlO04
         bqcg==
X-Gm-Message-State: ACrzQf0JfTooX/FP+SGHTe0d8ieydSLcWmLuwVGqdMGA+6/pqyhWNFYl
        in1ljBn68DtEQyusRFKNQF2E9uvCh+8=
X-Google-Smtp-Source: AMsMyM5rvyItBt2ojFgn4LjwkEnL61c7MgTEXYwsnK2rFk7wR2JdZ687+hDcUmxiD0LBBoT4qCluMQIYhJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3b46:0:b0:69c:a60e:2e57 with SMTP id
 i67-20020a253b46000000b0069ca60e2e57mr2271546yba.364.1665014064611; Wed, 05
 Oct 2022 16:54:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:54:22 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235422.64897-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] nVMX: Expect #GP on VMXON with "generic"
 invalid CR0/CR4 bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        Sean Christopherson <seanjc@google.com>
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

Expect #GP, not #UD, when executing with "generic" invalid CR0/CR4 bits,
i.e. with invalid bits other than CR0.PE or CR4.VMXE.  The PE and VMXE
checks are special pre-conditions to VM-Exit and thus #UD, all other
CR0/CR4 checks are performed if and only if the CPU isn't already in
VMX mode and so #GP.

Reported-by: Eric Li <ercli@ucdavis.edu>
Fixes: f7b730bc ("nVMX: Add subtest to verify VMXON succeeds/#UDs on good/bad CR0/CR4")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index a13f2c9..2071cc0 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1474,7 +1474,7 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
 			     unsigned long *flexible_bits)
 {
 	unsigned long required1, disallowed1, val, bit;
-	int ret, i;
+	int ret, i, expected;
 
 	if (!cr_number) {
 		required1 =  rdmsr(MSR_IA32_VMX_CR0_FIXED0);
@@ -1521,10 +1521,22 @@ static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
 		if (write_cr_safe(cr_number, val))
 			continue;
 
+		/*
+		 * CR0.PE==0 and CR4.VMXE==0 result in #UD, all other invalid
+		 * CR0/CR4 bits result in #GP.  Include CR0.PE even though it's
+		 * dead code (see above) for completeness.
+		 */
+		if ((cr_number == 0 && bit == X86_CR0_PE) ||
+		    (cr_number == 4 && bit == X86_CR4_VMXE))
+			expected = UD_VECTOR;
+		else
+			expected = GP_VECTOR;
+
 		ret = vmx_on();
-		report(ret == UD_VECTOR,
-		       "VMXON with CR%d bit %d %s should #UD, got '%d'",
-		       cr_number, i, (required1 & bit) ? "cleared" : "set", ret);
+		report(ret == expected,
+		       "VMXON with CR%d bit %d %s should %s, got '%d'",
+		       cr_number, i, (required1 & bit) ? "cleared" : "set",
+		       expected == UD_VECTOR ? "UD" : "#GP", ret);
 
 		write_cr(cr_number, orig_cr);
 

base-commit: d8a4f9e5e8d69d4ef257b40d6cd666bd2f63494e
-- 
2.38.0.rc1.362.ged0d419d3c-goog

