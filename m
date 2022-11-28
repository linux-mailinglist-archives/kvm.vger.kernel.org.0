Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F64A63B50F
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiK1W5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbiK1W5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:57:46 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195FF1D30E
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:57:45 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id v16-20020a62a510000000b005745a58c197so9577120pfm.23
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xELzf4EoZMDlLUFpchpTMdst44hVrjj4VfJq2w9Ep4g=;
        b=tfGq1I9Ag4TRomwGArbD/e7Y8OTucyzeGIBpiuBA8HCvwovRyzZMr0jL1essdKJxRl
         AsLiTHBqMnFPfYFL6W6Gg7mrjwghkx+mm5CkL9sermoxxif5geNncKOnzhv9WJMna7+6
         EPztlMnA0Oomg6EENpjW8lYY6HTV4pMsV6RsBaky6LIIuYQSC81VQlR7T/MBuaYTWxpQ
         f5UDgsfX+NOHM+75d9ZexrzlpgZuMggqW0WB5v/Wh074p4fD/QcK7Gu/EJn7qY53pFPB
         GawhLmEMkaB82ICjvMdzs3LpOgwabZXU5VPUQVxNfTlONzJDpAGPE3cFsxOXcyO0tlwn
         4clQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xELzf4EoZMDlLUFpchpTMdst44hVrjj4VfJq2w9Ep4g=;
        b=g9HG6NH9i15hm26EMLqaPIO+xHYmsj1bdrW3wOTd8iRaHucqzA7je/6cNyrVperN1i
         eeCUWdVSQJnyVhQ7bFTx11pi3eZyVreBV3iVf6DeuJGf3n0uCG3No8hWuOQxciSwvaCJ
         udbXJnsPrwmb3FX/7DnHsqX38BhW34vjCaP0bQSEqUDKH9wa1LqBAbaiWS905b++DADr
         08MwFYaNU05dqVqGuZ/YGFyv7wz2xzEX6048Up/HTfwGzOEMd6tmxKP1qPaC8Lf1JYaF
         RyK4cRApFu9gKVvI8Ol/VYZVDsVji18V2U8vEaMwaBY1/bHlT6SWSeQ/dRPS/GH9cv/k
         1rww==
X-Gm-Message-State: ANoB5pk9TM/zEXITQFvZVANxANnRHAn97URBqWWMxVkjtWGufGUTRAak
        jS9TPWCIXI6lq7/Yb83Xc/Wl6jcWy9o=
X-Google-Smtp-Source: AA0mqf7XlYSOiBUAPxiV1JPp5qojEVpBxwXB4xMCDPs7V/2pUAuGBNrlhEa8A1+VJ8AZPriNzHDsDb7tf1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:820c:b0:189:505b:73dd with SMTP id
 x12-20020a170902820c00b00189505b73ddmr26974391pln.143.1669676264666; Mon, 28
 Nov 2022 14:57:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 28 Nov 2022 22:57:34 +0000
In-Reply-To: <20221128225735.3291648-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221128225735.3291648-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221128225735.3291648-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: selftests: Disallow "get supported CPUID" before REQ_XCOMP_GUEST_PERM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lei Wang <lei4.wang@intel.com>,
        Sean Christopherson <seanjc@google.com>
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

Disallow using kvm_get_supported_cpuid() and thus caching KVM's supported
CPUID info before enabling XSAVE-managed features that are off-by-default
and must be enabled by ARCH_REQ_XCOMP_GUEST_PERM.  Caching the supported
CPUID before all XSAVE features are enabled can result in false negatives
due to testing features that were cached before they were enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c       | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 23067465c035..1d3829e652e6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -601,21 +601,24 @@ void vcpu_arch_free(struct kvm_vcpu *vcpu)
 		free(vcpu->cpuid);
 }
 
+/* Do not use kvm_supported_cpuid directly except for validity checks. */
+static void *kvm_supported_cpuid;
+
 const struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 {
-	static struct kvm_cpuid2 *cpuid;
 	int kvm_fd;
 
-	if (cpuid)
-		return cpuid;
+	if (kvm_supported_cpuid)
+		return kvm_supported_cpuid;
 
-	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+	kvm_supported_cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	kvm_fd = open_kvm_dev_path_or_exit();
 
-	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
+	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID,
+		  (struct kvm_cpuid2 *)kvm_supported_cpuid);
 
 	close(kvm_fd);
-	return cpuid;
+	return kvm_supported_cpuid;
 }
 
 static uint32_t __kvm_cpu_has(const struct kvm_cpuid2 *cpuid,
@@ -684,6 +687,9 @@ void __vm_xsave_require_permission(int bit, const char *name)
 		.addr = (unsigned long) &bitmask
 	};
 
+	TEST_ASSERT(!kvm_supported_cpuid,
+		    "kvm_get_supported_cpuid() cannot be used before ARCH_REQ_XCOMP_GUEST_PERM");
+
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
-- 
2.38.1.584.g0f3c55d4c2-goog

