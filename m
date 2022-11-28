Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0442B63B509
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 23:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiK1W5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 17:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiK1W5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 17:57:42 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64DC17889
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:57:41 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id mn20-20020a17090b189400b0021941492f66so65595pjb.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 14:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xbF3GtKExTV4CBXx46DHT6EYJ+r9IUebdLWn8AinFs4=;
        b=jkF4pjyASAuV8OAvihGrz8X5YmXhQoqnwhE1kAeHK3REfDhlgq34FlevBK6WvzVwcS
         qmT91ayRYpbkT9sJTz5/uK72CTH/RAfWLB+n8+rC7xyeMdiup12BPnNhLBfZZ0bfL8cT
         v+CesiynWJFujgAjsecgvS7HIQSVVH5nr2e/tq4hxcHx3dZWjHlbpnOlkQiG8Qx6DZuJ
         VmI1z04hiOnaCXKJfWQ5yd7UgoLRW/jJLWYtL1w8xJ9pEuNn5T2Qofk6aY+ldRnyScCr
         P9rAk8N1kEaAovNgewZkw/Ej/fGDWIarmcJ3OcIdxkVn/e524+LGGXZUGZ90jhfJPEwr
         79Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xbF3GtKExTV4CBXx46DHT6EYJ+r9IUebdLWn8AinFs4=;
        b=nnwTeG+SMY2RUFHRIE8bka7kBCPhZm5rv80WS8wV2ZAIxqlChSvf6wZL2cWqoJqnws
         qaxIbzPFSYhh/9UUBHPMz27WrwAk0I0agh5xtuWjrM31q+xm+2E5m4p/LH9CZVamAjHI
         8Ee8yXPm8pzbdV18+pEWCuNg26trJcqy8+APxHBHb4MlFIY0aCrPzonfNeYuoROd+tNj
         ht2i3z/Dc1szGesynKNUktKSp8IqQDlRtOL2znRhWmGc7RNqknpC0wCEyGsWAYeOLd7J
         HjzY2qMKTMfb09MMNQSOb/zHCaYUv9uTOds6rfu0oowzNrfyij0kDtPqokMw3hXKs8QH
         z8lg==
X-Gm-Message-State: ANoB5pmDznt2RBb0e6vOqVSPFul4pcbOrImpYXTfgK3QEBT4/shJrttE
        LsHbGRSyg9q9C/+O60Us0Qse4NChC94=
X-Google-Smtp-Source: AA0mqf40KtgfnF2nI/LoyPseNNxPo1ZShvrHoEC5JR1GArSXiBxcKQIu6PMYL3PoDb8qQOEk1FpwZbiNuRQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc86:b0:187:282c:9b95 with SMTP id
 bb6-20020a170902bc8600b00187282c9b95mr34477380plb.41.1669676261240; Mon, 28
 Nov 2022 14:57:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 28 Nov 2022 22:57:32 +0000
In-Reply-To: <20221128225735.3291648-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221128225735.3291648-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221128225735.3291648-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: selftests: Move XFD CPUID checking out of __vm_xsave_require_permission()
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

From: Lei Wang <lei4.wang@intel.com>

Move the kvm_cpu_has() check on X86_FEATURE_XFD out of the helper to
enable off-by-default XSAVE-managed features and into the one test that
currenty requires XFD (XFeature Disable) support.   kvm_cpu_has() uses
kvm_get_supported_cpuid() and thus caches KVM_GET_SUPPORTED_CPUID, and so
using kvm_cpu_has() before ARCH_REQ_XCOMP_GUEST_PERM effectively results
in the test caching stale values, e.g. subsequent checks on AMX_TILE will
get false negatives.

Although off-by-default features are nonsensical without XFD, checking
for XFD virtualization prior to enabling such features isn't strictly
required.

Signed-off-by: Lei Wang <lei4.wang@intel.com>
Fixes: 7fbb653e01fd ("KVM: selftests: Check KVM's supported CPUID, not host CPUID, for XFD")
Link: https://lore.kernel.org/r/20221125023839.315207-1-lei4.wang@intel.com
[sean: add Fixes, reword changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 --
 tools/testing/selftests/kvm/x86_64/amx_test.c      | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d532c20c74fd..aac7b32a794b 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -563,8 +563,6 @@ void __vm_xsave_require_permission(int bit, const char *name)
 		.addr = (unsigned long) &bitmask
 	};
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
-
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 21de6ae42086..1256c7faadd3 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -254,6 +254,7 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_AMX_TILE));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));
-- 
2.38.1.584.g0f3c55d4c2-goog

