Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6520054BB2E
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358075AbiFNUKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357360AbiFNUJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:09:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD90F4F9CF
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u71-20020a63854a000000b004019c5cac3aso5443121pgd.19
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lCIfRU6G43lIwYqasc5Sb9W/ChPMCByn+h4LqEdr0K8=;
        b=TTCI+yuU+cTfab7HcwwHxQ6dTczkYUNTBGxGGJhQItC1oLQZv90OwxYvRvRJZo7Ji1
         mg+mJ8BywDCJIDzQ0Vc6MOd3u/0sh4ZNtSfADTTauouR1xu35i7+dOzuHNXTayzfXY4p
         yi/BPq5XwRkUf5nxVRWi/elQ4c9qog/QFYtkrUfZzXhAs0ESnknpz5Bry1fa80yF2aDZ
         K+vw8Z0OaR4KHwi0ns8il9DS7gFoG4Aj+FQhWgztivZDvv7H5p2699T544PhdBqgSPv7
         Chl8FurWlgH2uFtDKeT3Ebs+0LHICufzqzlz4p5aBY6egyRQ1RzFryEWCCemEhu8c56B
         esUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lCIfRU6G43lIwYqasc5Sb9W/ChPMCByn+h4LqEdr0K8=;
        b=oLSlSAqkQcMlnJPNmJq9MnrrnABlMNqkwpkA4GmOeGzSIuYFzL1dTksaxy8YBfDMKQ
         606QDIMO1awejCWrT5b4dX2j8dr+X2vdWWYUvU8nIt46xjnd3d5EsTB90xZNuQ/c7sHI
         f9RQcy9cJkk2Q1UIwlN23PA0DasD/u3+XbhWSi2Wy1R2SLFUG9+VBa6KLtlPuAkaT3x1
         0LW+VL6hmu2OcjVlFPnUVPnuO4K2bFk0xDtvkasWpANka8OW6iLiX5D36qJI7RPpAfE3
         l2bV1YpSkg8J2GO26MlS4NXTvDPcogr2/E+FmIe7Z6MXJg7AV9K3dMDV/VUTWQiHJR0L
         x/KQ==
X-Gm-Message-State: AJIora8TapztoOvYlpu14IgM2V+D/4v3BJPvRbTrkAwhFhzEdaiOKIKh
        za0zX1wUhHL5umdtPHJ/tCZmSuLKhXQ=
X-Google-Smtp-Source: ABdhPJzoEzevP/PwRbSKVIQ4Tz2wPS6giYd9onsycWbuCqTMli3rR7FudOBzwK21m8boKoYEtWJmsGrRtp0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:244b:b0:167:74f3:74aa with SMTP id
 l11-20020a170903244b00b0016774f374aamr5814638pls.67.1655237300483; Tue, 14
 Jun 2022 13:08:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:03 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-39-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 38/42] KVM: selftests: Check KVM's supported CPUID, not
 host CPUID, for XFD
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use kvm_cpu_has() to check for XFD supported in vm_xsave_req_perm(),
simply checking host CPUID doesn't guarantee KVM supports AMX/XFD.

Opportunistically hoist the check above the bit check; if XFD isn't
supported, it's far better to get a "not supported at all" message, as
opposed to a "feature X isn't supported" message".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/lib/x86_64/processor.c      | 19 ++-----------------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index fd0da7eb2058..b51227ccfb96 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -115,6 +115,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_XTILECFG		KVM_X86_CPU_FEATURE(0xD, 0, EAX, 17)
 #define	X86_FEATURE_XTILEDATA		KVM_X86_CPU_FEATURE(0xD, 0, EAX, 18)
 #define	X86_FEATURE_XSAVES		KVM_X86_CPU_FEATURE(0xD, 1, EAX, 3)
+#define	X86_FEATURE_XFD			KVM_X86_CPU_FEATURE(0xD, 1, EAX, 4)
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 522972e0d42c..c7fe584c71ed 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -578,21 +578,6 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
-#define CPUID_XFD_BIT (1 << 4)
-static bool is_xfd_supported(void)
-{
-	int eax, ebx, ecx, edx;
-	const int leaf = 0xd, subleaf = 0x1;
-
-	__asm__ __volatile__(
-		"cpuid"
-		: /* output */ "=a"(eax), "=b"(ebx),
-		  "=c"(ecx), "=d"(edx)
-		: /* input */ "0"(leaf), "2"(subleaf));
-
-	return !!(eax & CPUID_XFD_BIT);
-}
-
 void vm_xsave_req_perm(int bit)
 {
 	int kvm_fd;
@@ -604,6 +589,8 @@ void vm_xsave_req_perm(int bit)
 		.addr = (unsigned long) &bitmask
 	};
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
+
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
@@ -614,8 +601,6 @@ void vm_xsave_req_perm(int bit)
 
 	TEST_REQUIRE(bitmask & (1ULL << bit));
 
-	TEST_REQUIRE(is_xfd_supported());
-
 	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit);
 
 	/*
-- 
2.36.1.476.g0c4daa206d-goog

