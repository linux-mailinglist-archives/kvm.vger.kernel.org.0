Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604B8493B31
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349725AbiASNjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343938AbiASNjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 08:39:21 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001B4C061574;
        Wed, 19 Jan 2022 05:39:20 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w204so2363580pfc.7;
        Wed, 19 Jan 2022 05:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8NOXdq1kEY3pOnmXg+Zn+1SGl/zikNGQrQDpkrXSeQA=;
        b=Grw0I8Bzf3z0IHW0BPyppfRlgsOpAmqrKFVYYTprerDwmzSoS+tmFuXTp2661nCk2s
         0sdPZfeHJLIhB+PkiPaVNCvF1QRQxTNAsQ7Zig7jaMPJLOj5M1j7J9VPEw0+E60+5rZP
         ME64QZRADsy/M4/FKXSx7nBw1Lk9omFXkAn+iN4ABo78VjzUV4N9ND4MSF2kk9Mbtl+v
         JieQ7jRnuSftsO4NNb2VYpYwSSXuyuILLMcLuEQjRZDrHO9Ji4wrwjHDqeYa4PRXtpyr
         iJ86LZfzPyHPerpqy1dhKTkrhxmSZhSUrj4ktbsU1P0WrcfHvSa08of8QOklJ1AoBZ8K
         J5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8NOXdq1kEY3pOnmXg+Zn+1SGl/zikNGQrQDpkrXSeQA=;
        b=Zap0HZ+DbR2LsgXjwnc5zb7RDj3wipv6A/22IjYc7oTKi+Hs7BynHesWND2gUgkv3T
         Uh7Yeda79LlPQDxmU3lugRNtJPWKiSvtmOFvuYcaRtIclZ5VyUSBqxIKQmWg+mxq7Bmv
         mOqsBLLZWJx79/mXzXHqusttcRei5El0+pZ18jrzljTetFOP682t9t3xFIwL/LPsF74R
         i8Vr6T6FwDGVegYahWYdjJcW/1YgIMs0u3e9UbrWjgflpLhGqt+c3ORxB1cvwjMfbRWn
         Ro646x6dpf/4zvmVTjJIvumuPW97kxzKi/zdS6sYcRN0T9GsVNJbeLEt4t2uJZD5Hoyt
         CvkA==
X-Gm-Message-State: AOAM533NjWotDYqWX0rmAMxsg6wg1Iku0iWvRLL2XUnVr3h9vFZFuea2
        HFUVKlV2vjzEf+jSEE/4PLkVCn/lfrmS9Q==
X-Google-Smtp-Source: ABdhPJyL4RU+b4ur6zVEBaWRJjK+Yu7CyMHGZG9MfIb/O1kNRFEH+BmBCNgrlOzx2zEa2oQiXac5hg==
X-Received: by 2002:a62:1996:0:b0:4bb:db58:9f6d with SMTP id 144-20020a621996000000b004bbdb589f6dmr30887470pfz.31.1642599560575;
        Wed, 19 Jan 2022 05:39:20 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k8sm6308709pjj.3.2022.01.19.05.39.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jan 2022 05:39:20 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm/x86: Fix the warning in pmu_event_filter_test.c
Date:   Wed, 19 Jan 2022 21:39:10 +0800
Message-Id: <20220119133910.56285-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The following warning appears when executing
make -C tools/testing/selftests/kvm

x86_64/pmu_event_filter_test.c: In function ‘vcpu_supports_intel_br_retired’:
x86_64/pmu_event_filter_test.c:241:28: warning: variable ‘cpuid’ set but not used [-Wunused-but-set-variable]
  241 |         struct kvm_cpuid2 *cpuid;
      |                            ^~~~~
x86_64/pmu_event_filter_test.c: In function ‘vcpu_supports_amd_zen_br_retired’:
x86_64/pmu_event_filter_test.c:258:28: warning: variable ‘cpuid’ set but not used [-Wunused-but-set-variable]
  258 |         struct kvm_cpuid2 *cpuid;
      |                            ^~~~~

Just delete the unused variables to stay away from warnings.

Fixes: dc7e75b3b3ee ("selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER")
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 8ac99d4cbc73..0611a5c24bbc 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -238,9 +238,7 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 static bool vcpu_supports_intel_br_retired(void)
 {
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_cpuid2 *cpuid;
 
-	cpuid = kvm_get_supported_cpuid();
 	entry = kvm_get_supported_cpuid_index(0xa, 0);
 	return entry &&
 		(entry->eax & 0xff) &&
@@ -255,9 +253,7 @@ static bool vcpu_supports_intel_br_retired(void)
 static bool vcpu_supports_amd_zen_br_retired(void)
 {
 	struct kvm_cpuid_entry2 *entry;
-	struct kvm_cpuid2 *cpuid;
 
-	cpuid = kvm_get_supported_cpuid();
 	entry = kvm_get_supported_cpuid_index(1, 0);
 	return entry &&
 		((x86_family(entry->eax) == 0x17 &&
-- 
2.33.1

