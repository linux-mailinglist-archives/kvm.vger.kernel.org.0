Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB454B76B7
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243872AbiBOUCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 15:02:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242579AbiBOUCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 15:02:00 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98F170841
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 12:01:49 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id h3-20020a628303000000b004e12f44a262so73376pfe.21
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 12:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gS/ERe3WRO4rfo0NAdQNzCh6xwJFNrVc+tXRpZc72B0=;
        b=PeEQUHkdRVE/+y9FFhq2qXiZJjgkF9eoXd/DIqSXbLxw8kxoPnfZHnsd10YSTSB5vv
         5uGymYgyzeGkuJnUZJPg+mpHLfLyXPW3Ky+jgJX0HDqSE0iSnKF2cldytE21s6IaEDOX
         Bwm6nVi+2PdjcBVTpCbGH0gB7ne1nzHGeuslRzAqtVph9Ed9IMsViF27MvakDan/9z0v
         iUKmUQWokvCUgjr925bgKHXioxgo5O9O0YR51mOmVO5OGrH2nyMj7y6F98Nw5Bb3dFJb
         8DHMaDqgvVPlvRJ7BfoiLWZJI93XX3Z80OY4YYozBmUDJJd2P1Lo8xtfAUkncRErwwBl
         mlxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gS/ERe3WRO4rfo0NAdQNzCh6xwJFNrVc+tXRpZc72B0=;
        b=gCuloqI+6N0pyTZTH/jCWJwxt1hHYpFREgMp3jAQILXwhRwmKCPcwZQHapK+Z687xD
         uKYvqdrwlLSbyt+K09hE6jekTQZYyAedeD+vgBEYAF+/nfycJ5FSA2ZvpoR5mRHINVTC
         +lhM2P6n8vUmUPEQyyUKdNbdlTuo/JvxRN0nbC3EW7QM/oFhPlzGkxpsOs0hYzDdL7/4
         a+JbVnGpASwCDDg4jXrEolV8I8omtDbmX5PP+MPYv0qI4OcyKIuNnfyWJ5DHgNbMQ6/J
         TuxSzrKG6E1p8pvqJRdr54Z1m/VbbQWhb66xDSP1cYIeMWRa6ztI2a6IsCI9bngDZgcP
         LjUA==
X-Gm-Message-State: AOAM531jF0u3RJ+Th41IoW7qNW5q9bLnPBLt0ZVMpQIixrfHnxNB3xYv
        kNwKh+bw1RMuxHtHub5+2kvi5aKaignq/hLYr4pK36iMvRLu2AtDMfuq0MSa44Wz4isC9ZfUUfa
        AF/qixRmEwlwi0JUE7jOsc8I9+TgAt80ShXQX4axfuiYfGIte96IKfLand6nwl7M=
X-Google-Smtp-Source: ABdhPJwPAIX1URlb7pELYvrTT2UZ4Dgkj0LyK3oF3vcLPQhLyP6ONx13bQ4cUN1nGBu/G8nrqCt/kd6ixjrHUQ==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:a17:902:da86:: with SMTP id
 j6mr422270plx.157.1644955309273; Tue, 15 Feb 2022 12:01:49 -0800 (PST)
Date:   Tue, 15 Feb 2022 20:01:17 +0000
Message-Id: <20220215200116.4022789-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always
 catchup mode
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     mtosatti@redhat.com, Anton Romanov <romanton@google.com>
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

If vcpu has tsc_always_catchup set each request updates pvclock data.
KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
host's side and do hypercall inside pvclock_read_retry loop leading to
infinite loop in such situation.

v2:
    Added warn

Signed-off-by: Anton Romanov <romanton@google.com>
---
 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..aaafb46a6048 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8945,6 +8945,15 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
 		return -KVM_EOPNOTSUPP;
 
+	/*
+	 * When tsc is in permanent catchup mode guests won't be able to use
+	 * pvclock_read_retry loop to get consistent view of pvclock
+	 */
+	if (vcpu->arch.tsc_always_catchup) {
+		pr_warn_ratelimited("KVM_HC_CLOCK_PAIRING not supported if vcpu is in tsc catchup mode\n");
+		return -KVM_EOPNOTSUPP;
+	}
+
 	clock_pairing.sec = ts.tv_sec;
 	clock_pairing.nsec = ts.tv_nsec;
 	clock_pairing.tsc = kvm_read_l1_tsc(vcpu, cycle);
-- 
2.35.1.265.g69c8d7142f-goog

