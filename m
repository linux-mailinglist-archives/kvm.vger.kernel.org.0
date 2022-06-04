Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B589D53D490
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350231AbiFDBYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350225AbiFDBXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:25 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9CF2EA2B
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:17 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 206-20020a6218d7000000b0051893ee2888so2881880pfy.16
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=EAmGvaProE4PEjXpsn+IRdGnIMemtg0iePn8LC3Ji8I=;
        b=QK6UdgjffKn9rdPMund/0BPWiiPZ/3DtkvFH12wlU5ohRrxdqTx9WqhPbVlSFfAo+y
         O5LDEdYHi2rmGlJTWaelmfNTL37GekLMLfFGW+DjiRSC8DynEX2C+ATYugd8FiTdxodU
         zoap6iCEBZ2bIB8TluaCBI4QRrM+F3c7O35VAvMa/OcitnFcE0KojOB6TZsFr1wkCmjs
         ubxFCARGeNujPV/7wmqQazJXFqcxn5bEydhJ0pQ1X2Li3ZuAVBL7+T8unc5NjYuSTX6N
         nzw7tuwxFzobdMxcb6dIfypTjultnX60Roy68GghyW9off9ElriXu+K/ZqhHpa2sw0tU
         ycrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=EAmGvaProE4PEjXpsn+IRdGnIMemtg0iePn8LC3Ji8I=;
        b=HZsJEDqTtdbXnELKHUf0/V6fotQ4XBWY/RnT2MkO9762Xn42Z5bQEWi5Xq3xXiG9QG
         ZH8JqECocVTpftq5nHTS0DcHpxy5y9U/DqxH4Ex+c5jvfNB1AwUcPkIJ+YcomLRUgRT1
         7f57fjmPusIXwGkJ9AhblWILYSXb94uYcaRlp6iJkprRIkOT68rsn7IIVaAZv1tNBrod
         DRwV+p9FCDHzuFCTR/joysJS6NUlOnzA5j8lzDYpQYRjKjiYJ+03Q3fAnehD09ZTalV1
         hbnrAtrYtQuOyD2rywA9V84777oV8xZHxcoo9AoEfk9tyaquQ+HIMa1d+OTaTK3bOyuJ
         8Yog==
X-Gm-Message-State: AOAM531x2p17+rRuwSZAK4cIpLGLyUS6qIPMHEZaeOO7cWRRq8F2xcvQ
        ramQtblYil3Cw2hfF7077+rL+f8L08g=
X-Google-Smtp-Source: ABdhPJwAssVlPRuoRdBIUw3WgLM8FNQmwoB8X3XgmYMb4uyqAlmhzCw8s3VryspK6lEVoqihYJQwR7Xg9Wc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:21cd:b0:4e1:5008:adcc with SMTP id
 t13-20020a056a0021cd00b004e15008adccmr12578140pfj.35.1654305727650; Fri, 03
 Jun 2022 18:22:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:54 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-39-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 38/42] KVM: selftests: Check KVM's supported CPUID, not host
 CPUID, for XFD
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 473501e5776e..e97b7c4ce367 100644
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
index 0f36f8ac7e9d..f1290540210d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -579,21 +579,6 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
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
@@ -605,6 +590,8 @@ void vm_xsave_req_perm(int bit)
 		.addr = (unsigned long) &bitmask
 	};
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
+
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
@@ -615,8 +602,6 @@ void vm_xsave_req_perm(int bit)
 
 	TEST_REQUIRE(bitmask & (1ULL << bit));
 
-	TEST_REQUIRE(is_xfd_supported());
-
 	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit);
 
 	/*
-- 
2.36.1.255.ge46751e96f-goog

