Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35734C58B5
	for <lists+kvm@lfdr.de>; Sun, 27 Feb 2022 00:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiBZXmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Feb 2022 18:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBZXmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Feb 2022 18:42:20 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB942C3CC9
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 15:41:45 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p3-20020a17090a748300b001bcf48f00a6so1369983pjk.4
        for <kvm@vger.kernel.org>; Sat, 26 Feb 2022 15:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KL3arKjuDizr1TcjSiVEp+qlPRVqWfs9ylFvtsx81fU=;
        b=L0ZnYZTyMljGpfj7MgKNncZNv2Wdmr6RVpU7PrLIZokv/ZR8GA5jmYUY0MuKf9f1s7
         ulQcJW//p7mBrZe5q9+dH02+NQHoBK5Sx7QLwcesqnqiQ7qjp6TPkreGzLESMFomgo+h
         ca+i0QlOpgMIone6+6Yn4L+EhwFSy4e32fSaF4VdNz04FiMkSTjyfZ4M+F1s1k7NkjZe
         80kd0GDOS6KQadua0Ov2NhZ5uFX4bGOqc4aSIXAGM3hEcpXYHRb5m2easuIIMEhjcvnk
         cBxuTD6TS5r6FjJpp7Zp1REfKTapS1etinQMeUbOx2IlQChQ5esBlIDmeBROFamErNwt
         VLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KL3arKjuDizr1TcjSiVEp+qlPRVqWfs9ylFvtsx81fU=;
        b=ic/FluY45uQtP8+aYyhTb+V3iJ10yKznAmc2fOMNc6PvQIwfAFJGNRG9+xKRvHQnXk
         Il3XWAt/cu6OlGVxKnvBlsUlzNB/m7IYIdKTMq59BlLfko+jI/GLcSTmv7icf3LzggAB
         xlRt5xspilYIUQCERHxVqGzFUiMIAZ99uZuiyHxp3VSlEIRrcreBPmEbFiyrmXoMU0Qm
         S5SZXzUiDkIumHTW/nL4qhGIdATKlm0Wxuv2i/7ZhGgWSuDnEKJg1/g7TbYFg+hvIpdN
         W7dwFZm6Lrynp1KtckWiAGa028oofC3KXk6tpM+zKTnncVmWP7zlEJEbwpTXBLqFZlzB
         kp2g==
X-Gm-Message-State: AOAM531QG932j7pSQa8AYQe0W1xEBDC11uA0HZSr7Ck545y1RUnkhlrv
        mNt0CAtzJi+7qLqSBrESss7F7cIZd7L8nuUWxdfj1a+eEMVpIpLtKcZXMspqKqgsBk4X5mf4n5q
        jLXe58W0ZM3i32BJJDFTBsYFDzXh2K/LZtyR/pChhobyeSQxU+pSzQ9jpZonZ5DQ=
X-Google-Smtp-Source: ABdhPJxhumxBO5LTutvOPkdtQfLP63JLBr7mDsYlbF37yC/o73drQmOToanZjhtZuRuQQJsCmoxQOxfC+L2j1A==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a65:45c4:0:b0:375:2322:9607 with SMTP id
 m4-20020a6545c4000000b0037523229607mr11676767pgr.361.1645918905179; Sat, 26
 Feb 2022 15:41:45 -0800 (PST)
Date:   Sat, 26 Feb 2022 15:41:31 -0800
Message-Id: <20220226234131.2167175-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, likexu@tencent.com
Cc:     Jim Mattson <jmattson@google.com>, Lotus Fenn <lotusf@google.com>
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

AMD EPYC CPUs never raise a #GP for a WRMSR to a PerfEvtSeln MSR. Some
reserved bits are cleared, and some are not. Specifically, on
Zen3/Milan, bits 19 and 42 are not cleared.

When emulating such a WRMSR, KVM should not synthesize a #GP,
regardless of which bits are set. However, undocumented bits should
not be passed through to the hardware MSR. So, rather than checking
for reserved bits and synthesizing a #GP, just clear the reserved
bits.

This may seem pedantic, but since KVM currently does not support the
"Host/Guest Only" bits (41:40), it is necessary to clear these bits
rather than synthesizing #GP, because some popular guests (e.g Linux)
will set the "Host Only" bit even on CPUs that don't support
EFER.SVME, and they don't expect a #GP.

For example,

root@Ubuntu1804:~# perf stat -e r26 -a sleep 1

 Performance counter stats for 'system wide':

                 0      r26

       1.001070977 seconds time elapsed

Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379957] unchecked MSR access error: WRMSR to 0xc0010200 (tried to write 0x0000020000130026) at rIP: 0xffffffff9b276a28 (native_write_msr+0x8/0x30)
Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379958] Call Trace:
Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379963]  amd_pmu_disable_event+0x27/0x90

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Reported-by: Lotus Fenn <lotusf@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/pmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index d4de52409335..886e8ac5cfaa 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -262,12 +262,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	/* MSR_EVNTSELn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 	if (pmc) {
-		if (data == pmc->eventsel)
-			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		data &= ~pmu->reserved_bits;
+		if (data != pmc->eventsel)
 			reprogram_gp_counter(pmc, data);
-			return 0;
-		}
+		return 0;
 	}
 
 	return 1;
-- 
2.35.1.574.g5d30c73bfb-goog

