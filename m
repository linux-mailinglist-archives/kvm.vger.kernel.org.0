Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8258A828
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 10:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiHEIiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 04:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiHEIiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 04:38:04 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CB1B2B;
        Fri,  5 Aug 2022 01:38:03 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f30so1290525pfq.4;
        Fri, 05 Aug 2022 01:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=yAcw6WHysBHdbzS3p6yPzUqgaV+Ou/Bsh0qiTnO7eVg=;
        b=dpkwBfBgMoQf6OOcfrgVnoCrrCrYJRFRcUCeLLsERj6zMoviBnjieIo0BEOBYAO3J5
         sOnVGuiPCDuNadFwcddIkxOQiCF6hUa7E0FFti+Mlxx1GfgYe0t6Myro0BLBQwRSd6bA
         wYH48vt2jA5LAvETV9WmEXZKKiGaYJFckHf0TO6jfKGYJ2TiTEmSz465+Y7u7gB40YFp
         15xMQzUzQXa8kLL88qw5ntVgtJFI4c/M0La5SO9V3zyQ2OUZtfLUIJXsV/8Osl3sVx43
         DyHd4wtebtAOY2LmLkf0HgK4BFM9oZcOBR/MLEGTEDf9Uc98HbLM5kzW/0mrPHy8xtEW
         A8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=yAcw6WHysBHdbzS3p6yPzUqgaV+Ou/Bsh0qiTnO7eVg=;
        b=4/OELlzZOOA+ZmlcoylQagfxOow5NNM+Ujg2eD1EZyqlZdYfnCt0ILiYIdmu7J6g0W
         zSngvyrsGQkZkTv6OE0j+p9VS3dxhkJXwzAEfL9qIolB2O/XIH+3VxRPxU2wYyY49FwM
         zyhbGJhId8F+KfSowFnMZPay2bzQ75ncXb6bxCx3lFTXRRSXzsJ1qKah3zsbuVeGlVkN
         ejHiJwS4ngtr04CxdVOm3OLbUlNfZh+c1QP78RmVJS7Bdt1MD2G/pXJcXVYW1CGquhqR
         ceGzKKXwJgNvYJkRlHJzBOd/AOQnC9AKVJnd1owcOQSAQIi0YHA07s3kMvnugzuIdcNn
         ISLg==
X-Gm-Message-State: ACgBeo2RjC4GamY86GEtkKoPGGA9mFdrBVNlFu8uKx4KKKLPnTg5NqEa
        9ql5HVFcuoJlEvtgKirB6Nk=
X-Google-Smtp-Source: AA6agR4CkBMkrL/Xf2KWLR3pQ0xcwlNp5C/WZ/cSDR53XtnVqFjJYfFa52RoB2hfLaNxNOa8nSLmWQ==
X-Received: by 2002:a05:6a00:1946:b0:52a:e551:2241 with SMTP id s6-20020a056a00194600b0052ae5512241mr5883037pfk.29.1659688682747;
        Fri, 05 Aug 2022 01:38:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005289627ae6asm2347686pfc.187.2022.08.05.01.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 01:38:02 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: [PATCH v2 1/3] KVM: selftests: Test all possible "invalid" PERF_CAPABILITIES.LBR_FMT vals
Date:   Fri,  5 Aug 2022 16:37:42 +0800
Message-Id: <20220805083744.78767-1-likexu@tencent.com>
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

From: Sean Christopherson <seanjc@google.com>

Test all possible input values to verify that KVM rejects all values
except the exact host value.  Due to the LBR format affecting the core
functionality of LBRs, KVM can't emulate "other" formats, so even though
there are a variety of legal values, KVM should reject anything but an
exact host match.

Suggested-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
v1: https://lore.kernel.org/kvm/20220804073819.76460-1-likexu@tencent.com/
v1 -> v2 Changelog:
- Replace testcase #3 with fully exhaustive approach; (Sean)

 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c    | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6ec901dab61e..928c10e520c7 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -59,6 +59,7 @@ int main(int argc, char *argv[])
 	int ret;
 	union cpuid10_eax eax;
 	union perf_capabilities host_cap;
+	uint64_t val;
 
 	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
 	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
@@ -91,11 +92,17 @@ int main(int argc, char *argv[])
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
 
-	/* testcase 3, check invalid LBR format is rejected */
-	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
-	 * to avoid the failure, use a true invalid format 0x30 for the test. */
-	ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0x30);
-	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+	/*
+	 * Testcase 3, check that an "invalid" LBR format is rejected.  Only an
+	 * exact match of the host's format (and 0/disabled) is allowed.
+	 */
+	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
+		if (val == host_cap.lbr_format)
+			continue;
+
+		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
+		TEST_ASSERT(!ret, "Bad LBR FMT = 0x%lx didn't fail", val);
+	}
 
 	printf("Completed perf capability tests.\n");
 	kvm_vm_free(vm);
-- 
2.37.1

