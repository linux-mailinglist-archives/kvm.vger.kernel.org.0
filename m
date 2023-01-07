Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DC660B4A
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbjAGBKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 20:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbjAGBKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 20:10:38 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30A78790E
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 17:10:37 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r22-20020a63ce56000000b00478f1cfb0fbso1720038pgi.0
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 17:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c0SSOcQu2zhzJ01e85sXxoYY5PANxVarOWlxFmDNqkI=;
        b=FOxWr0FdI7ce2VAR/21uWjYEfDuNof6aYDMhw9giM6kcXoN7ECDdJNwDoGu9ZtWPQC
         RDSorCGNi5eD82znXTMpxkx18rCdX6HsHKVSuiWSgfVqbYM8EJt11iXzi2mcuFbIjls4
         TjdMiKyvkaso0o8lhY7BgBWfsvRoHaIbDS6vCQ54sHGB3rtX29EG/5f3jywA2EAW3MAi
         5iaOCgvDf/fsqhre4iBphnDIDf09ifAzIFoxFjMLjydCo1JVnwEV0R/4WNPLFVNCKYPI
         Eb1rThvH5UNHO0rRTv1NlBaPdBBTSUej2nY+cYLJpt1o62ixzT9lW4Lx6Dk1bvooG74L
         QmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c0SSOcQu2zhzJ01e85sXxoYY5PANxVarOWlxFmDNqkI=;
        b=jW6zKrZnRz0cGpfiv8yzPDNFudcXGyFZ8VD9pDyjfNiEDV5mKcaf5r4aB7BtGKlOrV
         l257TQ1JWMQ/YFs3PASndzeXhbt7Ebu1D5PxhZYc9jIvF2UBzCNV1BosT8EC+VyG5H15
         +Z8QqOwIx3VBiQirea7/d1Rqqkf0s1A0cePqMuOgpB71vvdYpkUrcA17+nvz0vyqQXvE
         EXa4rac/usHhl8jvfPBZIbbeDPCfwfXKH3hBiX79A4/LpSgDfHUsyr6QYJV8Fjj6Vv7Y
         sOTCrhLnhTnhn5UsQtaLnFuarlNHOIdQ6w9UfY8sAZcw5Qkjgdsha/tdrWdPGm+Cokn8
         tpfA==
X-Gm-Message-State: AFqh2krXmCDLHnwlIgohn+8l8j1WcKwO4vJO5qPKnQbV5b7qA7n2gdmA
        QriD29pNB6IOCw8nuLNflKhSIyYx5hs=
X-Google-Smtp-Source: AMrXdXtyjoX+x/17LwxnbsB21BKNI8ZcvTiAQjsZyAbWV/HGLW+GV/lpWMKjZuFG9ghnQhnZWQmQHV/D6Cs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7889:b0:193:16d9:e4c6 with SMTP id
 q9-20020a170902788900b0019316d9e4c6mr142021pll.95.1673053837208; Fri, 06 Jan
 2023 17:10:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  7 Jan 2023 01:10:24 +0000
In-Reply-To: <20230107011025.565472-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230107011025.565472-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230107011025.565472-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: VMX: Always intercept accesses to unsupported
 "extended" x2APIC regs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
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

Don't clear the "read" bits for x2APIC registers above SELF_IPI (APIC regs
0x400 - 0xff0, MSRs 0x840 - 0x8ff).  KVM doesn't emulate registers in that
space (there are a smattering of AMD-only extensions) and so should
intercept reads in order to inject #GP.  When APICv is fully enabled,
Intel hardware doesn't validate the registers on RDMSR and instead blindly
retrieves data from the vAPIC page, i.e. it's software's responsibility to
intercept reads to non-existent MSRs.

Fixes: 8d14695f9542 ("x86, apicv: add virtual x2apic support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..82c61c16f8f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4018,26 +4018,17 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
-static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
-{
-	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
-	unsigned long read_intercept;
-	int msr;
-
-	read_intercept = (mode & MSR_BITMAP_MODE_X2APIC_APICV) ? 0 : ~0;
-
-	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
-		unsigned int read_idx = msr / BITS_PER_LONG;
-		unsigned int write_idx = read_idx + (0x800 / sizeof(long));
-
-		msr_bitmap[read_idx] = read_intercept;
-		msr_bitmap[write_idx] = ~0ul;
-	}
-}
-
 static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * x2APIC indices for 64-bit accesses into the RDMSR and WRMSR halves
+	 * of the MSR bitmap.  KVM emulates APIC registers up through 0x3f0,
+	 * i.e. MSR 0x83f, and so only needs to dynamically manipulate 64 bits.
+	 */
+	const int read_idx = APIC_BASE_MSR / BITS_PER_LONG_LONG;
+	const int write_idx = read_idx + (0x800 / sizeof(u64));
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 *msr_bitmap = (u64 *)vmx->vmcs01.msr_bitmap;
 	u8 mode;
 
 	if (!cpu_has_vmx_msr_bitmap())
@@ -4058,7 +4049,18 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
 
 	vmx->x2apic_msr_bitmap_mode = mode;
 
-	vmx_reset_x2apic_msrs(vcpu, mode);
+	/*
+	 * Reset the bitmap for MSRs 0x800 - 0x83f.  Leave AMD's uber-extended
+	 * registers (0x840 and above) intercepted, KVM doesn't support them.
+	 * Intercept all writes by default and poke holes as needed.  Pass
+	 * through all reads by default in x2APIC+APICv mode, as all registers
+	 * except the current timer count are passed through for read.
+	 */
+	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
+		msr_bitmap[read_idx] = 0;
+	else
+		msr_bitmap[read_idx] = ~0ull;
+	msr_bitmap[write_idx] = ~0ull;
 
 	/*
 	 * TPR reads and writes can be virtualized even if virtual interrupt
-- 
2.39.0.314.g84b9a713c41-goog

