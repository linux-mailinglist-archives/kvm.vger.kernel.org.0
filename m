Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C36B570C
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCKAtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjCKAsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:48:21 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996BF1409C0
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:27 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pl10-20020a17090b268a00b00239ed042afcso5069768pjb.4
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TM0EcdyR+iQodypxNgMstja1NjDzbXCLluws31y0Y4g=;
        b=ZBbk159wt5l6UBv4QH5eTyNTwkgV+nu/eqBcq3NcB0T7RFO2GZtpHZUTjmYUjMH5NW
         tje2qxq7wXS5nMEPgdA1LytSLK9RAg8l3IKFaf47KMKlQfMJoRAnIMn6I+pI3euB4ZJH
         a1URbCQyyajHpNEYUBYxqpHZEUKP80ZOcWVxo9EvF459FPRMX2NN22gVpGDUxwNigRif
         w/Ph0rKREQscznfR3Dw3a/xF2Xly6rwwYYzvkZNUsRaAdCNOKsNYgdkGrI+RWDS3jNsT
         gla4sR8Zlmh9REIVmirpUBpFrNOrEEwo7qqKx5Y57G54xHqzmkRpSQHPmTpPyt3Q6VKE
         Qc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TM0EcdyR+iQodypxNgMstja1NjDzbXCLluws31y0Y4g=;
        b=hCzcTOcufunH3VS/0KL4Rr3dAtYNKZRcfgoFXXze8XX8B4z4FIthTArRCOwou7UUjU
         whmDLTryJ6ivjQ7t7QCXCI6JLgqThNgEqADh6B7A/VN0Iy4aiuPKEUGR7YWEWFli811E
         KIPbaOE+cgG3O1BBxiv6Qzf24AIpWpGFjpXt5hTFxnM4MJF9aBaXPeaOlZhV//VqtOjg
         bZBzdEQ7BKNg43ymybHDnJ3otxi61DPi9119MNUaSb9QVyj959isFW9yGPua2ZrBmhUU
         yTkUMljkHMOlWqQCHDf3DF2LX3yZhlFXy0FDkofzZuEQMqSDlqfJlpH4UzvmmVJpog69
         ZnNQ==
X-Gm-Message-State: AO0yUKUe8WV+mPOG0sPuz2uaWL7mhiguuARy5+VyboTBbCi8Af9jUqAW
        PutwxrFlEdxNdpWoRCTQPqFyhClLOV0=
X-Google-Smtp-Source: AK7set9LXxplb54jbkGT2IEAHEj02At0I5VKSYv6GzL1BF9jwSJ68N7YOkkOuNPUw6tYdY73po0vJfaLDTU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:69c4:b0:233:bc72:1c69 with SMTP id
 s62-20020a17090a69c400b00233bc721c69mr9581314pjj.9.1678495619325; Fri, 10 Mar
 2023 16:46:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:17 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-21-seanjc@google.com>
Subject: [PATCH v3 20/21] KVM: selftests: Add negative testcase for PEBS
 format in PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Expand the immutable features sub-test for PERF_CAPABILITIES to verify
KVM rejects any attempt to use a PEBS format other than the host's.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 38aec88d733b..29aaa0419294 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -191,6 +191,16 @@ static void test_immutable_perf_capabilities(union perf_capabilities host_cap)
 			    val.lbr_format, host_cap.lbr_format);
 	}
 
+	/* Ditto for the PEBS format. */
+	for (val.pebs_format = 1; val.pebs_format; val.pebs_format++) {
+		if (val.pebs_format == host_cap.pebs_format)
+			continue;
+
+		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val.capabilities);
+		TEST_ASSERT(!r, "Bad PEBS FMT = 0x%x didn't fail, host = 0x%x",
+			    val.pebs_format, host_cap.pebs_format);
+	}
+
 	kvm_vm_free(vm);
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

