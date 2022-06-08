Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765C754402A
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiFHXvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiFHXvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:51:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5822419F969
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b15-20020a170902d50f00b00167501814edso8144707plg.8
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=loIh+icgosiuHAaVYSsd4ahzxIETNbfQmypPZ98xKDs=;
        b=pANv/empjn3tuKy82hELlZ23kZom9LHo0rwlL04rla/8NiyLKtluTCRzvOBm0cJaAc
         c/asFIA+l3Hjo1c0A9lA50Dq8zN4Zrt/wLesyTddhofFiU35bwP2LDSoJnhM4OIWkBVx
         gvVo+OGW3x5BmgCuUycMR1lTcIg7Pnt5J069DLngrswX/VWO4UwsQ/y3GspMa1Ut9LlP
         xdT/1u3H/+acqEL17YPxWoQR/U+CC+KO8KxCQ4L4gUwvTqJI5kl++4je95dW3ssS0mNo
         w55jD+hwutqDD+LYBbjxiMs/pOb4NkJqKIjZYc38jwIvuZUCs0rrUVj+KXWbCUkoJ0d2
         wJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=loIh+icgosiuHAaVYSsd4ahzxIETNbfQmypPZ98xKDs=;
        b=s2jHjAqJh0qAk9uy9bNphdZv6HjWMJv68YuYnvxZ48Ige9NkDRiufFlUpry7l3Inxj
         6yRNhlkVR42mwPgKWMqrEBAWJLH5LHI/tyCRQCGKZY2uP72Rc/ht9bwSHuS7qi0fazo8
         xu67h4BNoeT1mGau9k2B+pvgEPqJLPAUJnad6TXHmMLMFD4M5J5yRpuzrUbi3jLs6k5q
         e69w7N/QSZbTtrmiS/nGUXx4sFe7yPIvU5KrdBXSKTK25rskWRhSSq3apQM4HNuNay1y
         HQ8MXyHJnMX4/aB8dXOj/GXlTZVQeljI1CPi9WqZ4erJhOY3JrFdAcBI5Eb0XeAyv5i6
         qbQg==
X-Gm-Message-State: AOAM531fTaEqzzVnVz+XR9K/0pF4f1VoQe2mf8zFZ+0Jtevz9Ypsimuw
        rKwtTwXEHZQtb1HO96KYcYYq3oxIIBg=
X-Google-Smtp-Source: ABdhPJy3IL3FeRQx3IxPOK+kB9oZUOnrC4t4gCoEm+81Qa93TNJOjgnpbYYdoEKI0HG5BlLpePaiV25X7AU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:158e:b0:51c:2a89:3845 with SMTP id
 u14-20020a056a00158e00b0051c2a893845mr14424470pfk.64.1654732378505; Wed, 08
 Jun 2022 16:52:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:38 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 10/10] nVMX: Add subtest to verify VMXON
 succeeds/#UDs on good/bad CR0/CR4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that VMXON #UDs on CR0 and CR4 bits that are either fixed-0 or
fixed-1, and toggle flexible CR0/CR4 bits for the final, successful VMXON
to gain some amount of coverage for VMXON with variable CR0/CR4 values.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 4562e91f..fd845d7e 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1453,12 +1453,101 @@ static int test_vmx_feature_control(void)
 	return !vmx_enabled;
 }
 
+
+static void write_cr(int cr_number, unsigned long val)
+{
+	if (!cr_number)
+		write_cr0(val);
+	else
+		write_cr4(val);
+}
+
+static int write_cr_safe(int cr_number, unsigned long val)
+{
+	if (!cr_number)
+		return write_cr0_safe(val);
+	else
+		return write_cr4_safe(val);
+}
+
+static int test_vmxon_bad_cr(int cr_number, unsigned long orig_cr,
+			     unsigned long *flexible_bits)
+{
+	unsigned long required1, disallowed1, val, bit;
+	int ret, i;
+
+	if (!cr_number) {
+		required1 =  rdmsr(MSR_IA32_VMX_CR0_FIXED0);
+		disallowed1 = ~rdmsr(MSR_IA32_VMX_CR0_FIXED1);
+	} else {
+		required1 =  rdmsr(MSR_IA32_VMX_CR4_FIXED0);
+		disallowed1 = ~rdmsr(MSR_IA32_VMX_CR4_FIXED1);
+	}
+
+	*flexible_bits = 0;
+
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		bit = BIT(i);
+
+		/*
+		 * Don't touch bits that will affect the current paging mode,
+		 * toggling them will send the test into the weeds before it
+		 * gets to VMXON.  nVMX tests are 64-bit only, so CR4.PAE is
+		 * guaranteed to be '1', i.e. PSE is fair game.  PKU/PKS are
+		 * also fair game as KVM doesn't configure any keys.  SMAP and
+		 * SMEP are off limits because the page tables have the USER
+		 * bit set at all levels.
+		 */
+		if ((cr_number == 0 && (bit == X86_CR0_PE || bit == X86_CR0_PG)) ||
+		    (cr_number == 4 && (bit == X86_CR4_PAE || bit == X86_CR4_SMAP || X86_CR4_SMEP)))
+			continue;
+
+		if (!(bit & required1) && !(bit & disallowed1)) {
+			if (!write_cr_safe(cr_number, orig_cr ^ bit)) {
+				*flexible_bits |= bit;
+				write_cr(cr_number, orig_cr);
+			}
+			continue;
+		}
+
+		assert(!(required1 & disallowed1));
+
+		if (required1 & bit)
+			val = orig_cr & ~bit;
+		else
+			val = orig_cr | bit;
+
+		if (write_cr_safe(cr_number, val))
+			continue;
+
+		ret = vmx_on();
+		report(ret == UD_VECTOR,
+		       "VMXON with CR%d bit %d %s should #UD, got '%d'",
+		       cr_number, i, (required1 & bit) ? "cleared" : "set", ret);
+
+		write_cr(cr_number, orig_cr);
+
+		if (ret <= 0)
+			return 1;
+	}
+	return 0;
+}
+
 static int test_vmxon(void)
 {
+	unsigned long orig_cr0, flexible_cr0, orig_cr4, flexible_cr4;
+	int width = cpuid_maxphyaddr();
 	u64 *vmxon_region;
-	int width = cpuid_maxphyaddr();
 	int ret;
 
+	orig_cr0 = read_cr0();
+	if (test_vmxon_bad_cr(0, orig_cr0, &flexible_cr0))
+		return 1;
+
+	orig_cr4 = read_cr4();
+	if (test_vmxon_bad_cr(4, orig_cr4, &flexible_cr4))
+		return 1;
+
 	/* Unaligned page access */
 	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region + 1);
 	ret = __vmxon_safe(vmxon_region);
@@ -1480,10 +1569,14 @@ static int test_vmxon(void)
 	if (ret >= 0)
 		return 1;
 
-	/* and finally a valid region */
+	/* and finally a valid region, with valid-but-tweaked cr0/cr4 */
+	write_cr0(orig_cr0 ^ flexible_cr0);
+	write_cr4(orig_cr4 ^ flexible_cr4);
 	*bsp_vmxon_region = basic.revision;
 	ret = vmxon_safe();
 	report(!ret, "test vmxon with valid vmxon region");
+	write_cr0(orig_cr0);
+	write_cr4(orig_cr4);
 	return ret;
 }
 
-- 
2.36.1.255.ge46751e96f-goog

