Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9905F181B
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiJABO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiJABNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C245DB7CD
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:18 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oc9-20020a17090b1c0900b00202843f7057so5118659pjb.1
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=6LeoLx+siWNuiV22hQNpi4t4jY/oE2NYBDm2S2o/zFM=;
        b=W/rO87my6AaX5UFmoZ8BW4m6SgD43VQFLRaBiBXAkokhiG4lq6k7ggP/dWhKTNcEKF
         W2m5dfnBqAqu/az4Sje2dcQzToTuCu6Jd0tvUFq0EoTJ0IjzMC5rX4tZdUwiAG6ID75Z
         SdETrRc+MgpWU/QZeo/1ibe6AgD+xf96lfkHX78dtq2b7V2yhpeF0jHWcnosRG38aPqL
         6NPDcSDZH5hicql4MSviwIwnU1cevklbE7vCaWSChDgQ7YyY+TdgMlVWuLqw5u8w6Msk
         SZhX4YoxCegwozlejBX7X+kkkZxbvH/H2xmLb2Manufvt9Zd3S0B0yTkSgho4qThu8Ll
         EjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=6LeoLx+siWNuiV22hQNpi4t4jY/oE2NYBDm2S2o/zFM=;
        b=65p9L//VLuiQ3btQM1LHg6GptS3gbkicKv1qPSqdlj1p95NjbD5Ug8XeQcViDoN/By
         5oaEtSwW7lFsQHaljuw5js7J0AkTzeWsrr55Gy6UZACuQjscxSeCmliaXAm03F0c4gcy
         EM2EY/8oMiuKSYdwEXFBkhnIDZatoqzQJfjYSOKQ7aR0LDt6cefxtWEg88s6PTWnUiWz
         m9codH9+97yB5j3RlwQRXUnkvFfpWwDKcox9ctzDllXrFB6LLE/qVD4hO0Z8qYVxLoAA
         KiB16TwAuQHGXANuFjDTJ6w2Ufr9Hwg5zFx1Bx8qoeOonFjkOEl7d1KybYTUSsdbktyN
         H11A==
X-Gm-Message-State: ACrzQf2YjQBYLJyg5zHAFLDr5DAtaIfcXJpErLnHSIfThefy0ZjNHkPr
        24OFtPTHzHMkwmIFhynznjOOo35G6AA=
X-Google-Smtp-Source: AMsMyM7toVwt0BMTYLihyJGEGrj97RclVMxwMf1/k76+zed8aKup0dA2kHNMQ/B9o7ruU3jCcN20SJ0pNlo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:198e:b0:541:f85a:6c27 with SMTP id
 d14-20020a056a00198e00b00541f85a6c27mr11819622pfl.81.1664586798335; Fri, 30
 Sep 2022 18:13:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:13:01 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 9/9] x86/apic: Add test to verify aliased xAPIC
 IDs both receive IPI
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
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

Verify that multiple vCPUs with the same physical xAPIC ID receive an
IPI sent to said ID.  Note, on_cpu() maintains its own CPU=>ID map and
is effectively unusuable after changing the xAPIC ID.  Update each vCPU's
xAPIC ID from within the IRQ handler so as to avoid having to send
yet another IPI from vCPU0 to tell vCPU1 to update its ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h |  1 +
 x86/apic.c          | 67 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 0324220..280821e 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -219,6 +219,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
 #define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))
 #define	X86_FEATURE_PCID		(CPUID(0x1, 0, ECX, 17))
+#define X86_FEATURE_X2APIC		(CPUID(0x1, 0, ECX, 21))
 #define	X86_FEATURE_MOVBE		(CPUID(0x1, 0, ECX, 22))
 #define	X86_FEATURE_TSC_DEADLINE_TIMER	(CPUID(0x1, 0, ECX, 24))
 #define	X86_FEATURE_XSAVE		(CPUID(0x1, 0, ECX, 26))
diff --git a/x86/apic.c b/x86/apic.c
index 1cc61d3..20c3a1a 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -847,6 +847,72 @@ static void test_logical_ipi_xapic(void)
 	report(!f, "IPI to multiple targets using logical cluster mode");
 }
 
+static void set_xapic_physical_id(void *apic_id)
+{
+	apic_write(APIC_ID, (unsigned long)apic_id << 24);
+}
+
+static void handle_aliased_ipi(isr_regs_t *regs)
+{
+	u32 apic_id = apic_read(APIC_ID) >> 24;
+
+	if (apic_id == 0xff)
+		apic_id = smp_id();
+	else
+		apic_id++;
+	apic_write(APIC_ID, (unsigned long)apic_id << 24);
+
+	/*
+	 * Handle the IPI after updating the APIC ID, as the IPI count acts as
+	 * synchronization barrier before vCPU0 sends the next IPI.
+	 */
+	handle_ipi(regs);
+}
+
+static void test_aliased_xapic_physical_ipi(void)
+{
+	u8 vector = 0xf1;
+	int i, f;
+
+	if (cpu_count() < 2)
+		return;
+
+	/*
+	 * All vCPUs must be in xAPIC mode, i.e. simply resetting this vCPUs
+	 * APIC is not sufficient.
+	 */
+	if (is_x2apic_enabled())
+		return;
+
+	/*
+	 * By default, KVM doesn't follow the x86 APIC architecture for aliased
+	 * APIC IDs if userspace has enabled KVM_X2APIC_API_USE_32BIT_IDS.
+	 * If x2APIC is supported, assume the userspace VMM has enabled 32-bit
+	 * IDs and thus activated KVM's quirk.  Delete this code to run the
+	 * aliasing test on x2APIC CPUs, e.g. to run it on bare metal.
+	 */
+	if (this_cpu_has(X86_FEATURE_X2APIC))
+		return;
+
+	handle_irq(vector, handle_aliased_ipi);
+
+	/*
+	 * Set both vCPU0 and vCPU1's APIC IDs to 0, then start the chain
+	 * reaction of IPIs from APIC ID 0..255.  Each vCPU will increment its
+	 * APIC ID in the handler, and then "reset" to its original ID (using
+	 * smp_id()) after the last IPI.  Using on_cpu() to set vCPU1's ID
+	 * after this point won't work due to on_cpu() using physical mode.
+	 */
+	on_cpu(1, set_xapic_physical_id, (void *)0ul);
+	set_xapic_physical_id((void *)0ul);
+
+	f = 0;
+	for (i = 0; i < 0x100; i++)
+		f += test_fixed_ipi(APIC_DEST_PHYSICAL, i, vector, 2, "physical");
+
+	report(!f, "IPI to aliased xAPIC physical IDs");
+}
+
 typedef void (*apic_test_fn)(void);
 
 int main(void)
@@ -883,6 +949,7 @@ int main(void)
 		 */
 		test_apic_id,
 		test_apicbase,
+		test_aliased_xapic_physical_ipi,
 	};
 
 	assert_msg(is_apic_hw_enabled() && is_apic_sw_enabled(),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

