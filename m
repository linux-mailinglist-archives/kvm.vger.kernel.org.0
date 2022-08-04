Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8A658988A
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 09:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbiHDHip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 03:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239056AbiHDHim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 03:38:42 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14FD56BBD;
        Thu,  4 Aug 2022 00:38:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w10so18632700plq.0;
        Thu, 04 Aug 2022 00:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=az7WEft7Sc4VxW/LA8uRMUGhN50YXVj2wsFEmSNbwI0=;
        b=h0zSFS6uH0vCgxTmF8cF89TYwWQJxdnOVHmR7BohpAqY5YufgaVpHKSzbD77CaVusq
         QMt/bgVtdLGi5IxWW1OFmUEGlZ8dN1s/r9p/gpbeAUkuSX7dyDKki7z5M4lnWUgBVO4f
         vgEz8DuxBG3g78WK4iu99y0cgfsJZCNFh3PC73OTA7M7XDi3i667MCsOEBwQoc8AAlW7
         33jgSB7whMXVoNVE2pJ1RsBT+gPLxSq9uP3cWaWxgfgrTJaRMtHotYWWW+yXF+kGO2Ja
         48yryQNBuL8blZx4WMaIR9jfo74A7wVIRohIBnCiBRpQito6oBJVUcMbwQNj+nIxGKjY
         ez6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=az7WEft7Sc4VxW/LA8uRMUGhN50YXVj2wsFEmSNbwI0=;
        b=sewiGGVLeCN5b6/uHl3XrqkWjH1Z7KBOHlyyBRLz1VC3qwX2VYAxDlsQB16kWhXePj
         FeCflX5tXE/lDMRNfDo5ZPpRUiKmuaenBd2r1GnQHGCWaBIYbAzBwsHWVwIWHgpln1RJ
         SQ06acklt3JZE5Fa6FSnAtHP8vBa9A4vTisqkleaCoc25geyLnHHxc0o9NHV4rgQVgDY
         z23CrK+nCYo7VBBGFCru6uzRnyuMdH8ul2cBsGNcAi/q5S9hnHVA7RLUgVADgMMSuq9z
         AhWhiS9A3wt6nXMFhfq0LOkk2kKHHWxNSAyyMAUogbSb1KCcxCaWK8kkNk97q7VtEra3
         zKPg==
X-Gm-Message-State: ACgBeo0uyxv8/U8D+id4sS+uKtdoW02Lx1qqptsJsdamz2c3MqhMh8n7
        TC18FegVPy2nqk6schojrko=
X-Google-Smtp-Source: AA6agR5HjKkbWfhVRJdYtWXLHBqJVjeFK9L9Gw6l6MBsKAAvTPO+da1RezAp5CdL271RyeBZoct95w==
X-Received: by 2002:a17:90b:1bd2:b0:1f5:313a:de64 with SMTP id oa18-20020a17090b1bd200b001f5313ade64mr727237pjb.116.1659598720030;
        Thu, 04 Aug 2022 00:38:40 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k20-20020a170902761400b0016f1ef2cd44sm116556pll.154.2022.08.04.00.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 00:38:39 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm/x86: test if it checks all the bits in the LBR_FMT bit-field
Date:   Thu,  4 Aug 2022 15:38:19 +0800
Message-Id: <20220804073819.76460-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

User space only enable guest LBR feature when the exactly supported
LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES.
The input is also invalid if only partially supported bits are set.

Note for PEBS feature, the PEBS_FORMAT bit field is the primary concern,
thus if the PEBS_FORMAT input is empty, the other bits check about PEBS
(like PEBS_TRAP or ARCH_REG) will be ignored.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6ec901dab61e..98483947f921 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -13,6 +13,7 @@
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/ioctl.h>
+#include <linux/bitmap.h>
 
 #include "kvm_util.h"
 #include "vmx.h"
@@ -56,7 +57,7 @@ int main(int argc, char *argv[])
 	const struct kvm_cpuid_entry2 *entry_a_0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	int ret;
+	int ret, bit;
 	union cpuid10_eax eax;
 	union perf_capabilities host_cap;
 
@@ -97,6 +98,12 @@ int main(int argc, char *argv[])
 	ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0x30);
 	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
 
+	/* testcase 4, reject LBR_FMT if only partially supported bits are set */
+	for_each_set_bit(bit, (unsigned long *)&host_cap.capabilities, 6) {
+		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, BIT_ULL(bit));
+		TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+	}
+
 	printf("Completed perf capability tests.\n");
 	kvm_vm_free(vm);
 }
-- 
2.37.1

