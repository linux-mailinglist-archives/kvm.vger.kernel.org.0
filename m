Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C04B1C28
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 03:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347287AbiBKCY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 21:24:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347284AbiBKCY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 21:24:28 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F39BBEE
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 18:24:28 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e18-20020aa78252000000b004df7a13daeaso5591962pfn.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 18:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=e+TdAUTj5nl7IcrsqQNTuKh7LPXa2QsMTEVi/4wG26E=;
        b=F43JQI49JOVEbs9TYXF3+AaCG8pazIm+NFOxOFbc6HQqf+5eO/qaSUnDgPj6FtttpF
         5QOpwRXMtBBFZxMBGnVQz31t0dIq3o78wbBvwFTnSJVgtbOD8yElh8ezEzlHz+Q5bCtx
         DrNk8/faIO+32go1rk0LcCAp/eO95YlQkHgnRq96SQbmBb+feC6zffAGY6d0+0yhETi+
         ZKVhBxubOvYyknAo0O0WqUMHVJVZ0m/5KnFk6Gr4xhRvLxMMxxvfyjdcoMauGLJRvWem
         rmrheWn/CkYS2nh5ATPLCOeBGYn+IcWUe1pj6Ym7nJDqQHK0rgiG8vEfTOdp5DJBCXj1
         RDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=e+TdAUTj5nl7IcrsqQNTuKh7LPXa2QsMTEVi/4wG26E=;
        b=em3/u57DaUeMfxeWqr3IhvSbXljlM5jr5+3ep0J0BTBBqFpomNffJxhtyTTtfTS4Hp
         5Erzapkmqxl9Yj7naLRiQwlGGalD+eqyuzaCY21ownBiE8gbtxF5aI6ZdZQuEkl/cFYF
         7501XhBuXAq5hKbkhI1EA9yIBbaJP3jzEznY779W0GtXiFPRxjzFiAmVMabgdLEPpXHt
         /J9wHeEuyoFrVkyHtEnwJx1Oy/TxiR2IUhj/J39HIiIrH+8lIwr85C16mHZS0WmZqTLJ
         QXj6hJL9kQndv5dHN8W9PEdGrN0G+veQW8ii78d7VLzOxT0y5wUccyRijEjVn+iVOLWI
         QSTQ==
X-Gm-Message-State: AOAM531fhfobebH2NZbjgFugCiacOPe+HiSvkNAr6Jw2KaUjwbvetL5T
        nj35+yixDabjVJr+2KE6rhKZLOZvp32obwfd1BGUvQ2UJatgetiDzNaf7VKHEntXjUS+P3BzL6f
        6CVoUWQQG65CgsYrHHuB1Y/DhX13CBDxEEHmhpdyNCnIpqvJgkRhRz0pFtEi1CuY=
X-Google-Smtp-Source: ABdhPJzUzVdF/rwjcQqGvAQRSycThl+7GD5kJ21lBBIVSNMwjp5AF2T8PBywpBu8j+SB2QYHJm3gj8BhlfI+bw==
X-Received: from romanton.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:43ef])
 (user=romanton job=sendgmr) by 2002:a05:6a00:b83:: with SMTP id
 g3mr10326213pfj.58.1644546267454; Thu, 10 Feb 2022 18:24:27 -0800 (PST)
Date:   Fri, 11 Feb 2022 02:24:24 +0000
Message-Id: <20220211022424.1949138-1-romanton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] Disable KVM_HC_CLOCK_PAIRING if tsc is in always catchup mode
From:   Anton Romanov <romanton@google.com>
To:     kvm@vger.kernel.org
Cc:     Anton Romanov <romanton@google.com>
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

Signed-off-by: Anton Romanov <romanton@google.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..2fd6335bff4c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8945,6 +8945,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
 		return -KVM_EOPNOTSUPP;
 
+	/*
+	 * When tsc is in permanent catchup mode guests won't be able to use
+	 * pvclock_read_retry loop to get consistent view of pvclock
+	 */
+	if (vcpu->arch.tsc_always_catchup)
+		return -KVM_EOPNOTSUPP;
+
 	clock_pairing.sec = ts.tv_sec;
 	clock_pairing.nsec = ts.tv_nsec;
 	clock_pairing.tsc = kvm_read_l1_tsc(vcpu, cycle);
-- 
2.35.1.265.g69c8d7142f-goog

