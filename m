Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474D64D5BFC
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347063AbiCKHEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347050AbiCKHEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EA2A9A76;
        Thu, 10 Mar 2022 23:03:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p17so6969217plo.9;
        Thu, 10 Mar 2022 23:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iy67NItp+GEC8UykPY0qxJon7huk/5WIMi5uX5I8nDo=;
        b=ZV415Q4ZLugJt8Rh2xnuSE2f5W9YfzjcqfA6GrNxgYDEUpUWH5wW83QKXhCrMuRZSe
         mRWqtAVJSi0VWPrbayJRpc9wdmUGM7fpsVOBOvGh7V/mSaqxXW6FMd4JHDph6FpttxsX
         T59H/2KCjTCPDREnagOXn25I04nOAioi3jdB4L654BW0+oJn4IF/ygtby5A/AWdp70YR
         Lcj3gL4EL/7duzq6N56Sm+HET0hN4rVynv/C0GrCdKe+DeMfoJ1qRzaedM7iDroidu1P
         IsTHaKudg5FheURQvTaP2bjJseREkikbr4dBW+wI6pKkIESFABpj07k9VgAOkkHpacZv
         oHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iy67NItp+GEC8UykPY0qxJon7huk/5WIMi5uX5I8nDo=;
        b=MJEhOsidRlbGNOgjODcrFPJONHQZN71SH2wNHuLb7a23u8KvhNKkZmS5+ksaXpEHHn
         xZab3KmZr/AqWN2cWWurW0ry5HPOQG/wTC3ZUYWXW4B7j8RtI2sCiOJM+htoh9ewKKT8
         eY8KsSJWATA87W8kMTYtfM+GEG4wHwD9NcFrdHlewtqYPA9jENnwtbmSQrDRi+qQvm16
         ioB3pLvkUhARIOwgMAAeHOc2BjgL7cV1+rr3YVN2vPUUsIKmkvWiIpiodrpN9dcKP/9R
         8Mw/7cNu9gkhd009cj1FYdJKabHFrvnh8qK/sWGbp7vz0jJM8qAK+95DPPcK/9jhI/n/
         BV9A==
X-Gm-Message-State: AOAM531uJLklRrSIvHznoM9kFZrlcK/a0Mrh6bhCa0RprDOksyaDeAFD
        PQt0onaqaDs0T6tH+y2Wzmog2bWT944=
X-Google-Smtp-Source: ABdhPJzV4EKUrFLGMRxwYzqpwYtgez54ARNd2Fmvdf8wIwxD5QmH3Jyc5W3AiFofwiN7hnc94ZPEXw==
X-Received: by 2002:a17:90a:6c01:b0:1bf:1e67:b532 with SMTP id x1-20020a17090a6c0100b001bf1e67b532mr20339718pjj.138.1646982221886;
        Thu, 10 Mar 2022 23:03:41 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id u10-20020a056a00124a00b004f783abfa0esm3147517pfi.28.2022.03.10.23.03.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:41 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 5/5] KVM: X86: Only get rflags when needed in permission_fault()
Date:   Fri, 11 Mar 2022 15:03:45 +0800
Message-Id: <20220311070346.45023-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The SMAP checking and rflags are only needed in permission_fault()
when it is supervisor access and SMAP is enabled.  These information is
already encoded in the combination of mmu->permissions[] and the index.

So we can use the encoded information to see if we need the SMAP checking
instead of getting the rflags unconditionally.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu.h | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 4cb7a39ecd51..ceac1e9e21e9 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -218,13 +218,12 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 {
 	/* strip nested paging fault error codes */
 	unsigned int pfec = access;
-	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 
 	/*
 	 * For explicit supervisor accesses, SMAP is disabled if EFLAGS.AC = 1.
 	 * For implicit supervisor accesses, SMAP cannot be overridden.
 	 *
-	 * SMAP works on supervisor accesses only, and not_smap can
+	 * SMAP works on supervisor accesses only, and the SMAP checking bit can
 	 * be set or not set when user access with neither has any bearing
 	 * on the result.
 	 *
@@ -233,11 +232,30 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	 * if SMAP checks are being disabled.
 	 */
 	bool explicit_access = !(access & PFERR_IMPLICIT_ACCESS);
-	bool not_smap = (rflags & X86_EFLAGS_AC) && explicit_access;
-	int index = (pfec + (!!not_smap << PFERR_RSVD_BIT)) >> 1;
-	bool fault = (mmu->permissions[index] >> pte_access) & 1;
+	bool fault = (mmu->permissions[pfec >> 1] >> pte_access) & 1;
+	int index = (pfec + PFERR_RSVD_MASK) >> 1;
+	bool fault_not_smap = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
 
+	/*
+	 * The value of fault has included SMAP checking if it is supervisor
+	 * access and SMAP is enabled and encoded in mmu->permissions.
+	 *
+	 * fault	fault_not_smap
+	 * 0		0		not fault due to UWX nor SMAP
+	 * 0		1		impossible combination
+	 * 1		1		fault due to UWX
+	 * 1		0		fault due to SMAP, need to check if
+	 * 				SMAP is prevented
+	 *
+	 * SMAP is prevented only when X86_EFLAGS_AC is set on explicit
+	 * supervisor access.
+	 */
+	if (unlikely(fault && !fault_not_smap && explicit_access)) {
+		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
+		fault = !(rflags & X86_EFLAGS_AC);
+	}
+
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
 		u32 pkru_bits, offset;
-- 
2.19.1.6.gb485710b

