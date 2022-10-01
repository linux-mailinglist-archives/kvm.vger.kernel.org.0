Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91A5F17CE
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiJABBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbiJABAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCBF72B6D
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g15-20020a25af8f000000b006bcad4bf46aso5188285ybh.19
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=f70Xbl04urcnggP1iLNXSgd90V7DfOtA4Hkw+IrGqsA=;
        b=e4uxUpUQ+QYdNoNsX4vjc6+X7Krjind/BXqDg4Mpf0wuclTuUm/UX8PJIBIpwhbdyE
         3k8hah7Cj3o8zwn0fmu/X8Whwbjv9wpqeA5/oO2tZZEjMAKFJu0o+cyN/Q4kbu9Ip4Ag
         jXO1+ddcwdndqBHIDmSaAHoVu5eHb/LZ7GOQzuFCDwsa8KtE1+TFMyWUQGGgoku9bCi5
         NLLQ+QqIHKpX7tkSXDjER5jA1BsUXfTbSmaWV8/znmQS1boXEfYGnnR8Rwu+jgt7Tac8
         lQIGYQBty3IJiYFTw1IWYFsUrcA0Qz1RRtXI9yzW9WJTlBANcJ4kXL5xfO7wIyonaZWZ
         JpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=f70Xbl04urcnggP1iLNXSgd90V7DfOtA4Hkw+IrGqsA=;
        b=IgWmOxDKZyLRX+D/XakutcelPSTT+e/Na57kSeWUrNe4ueE2bQ119kbIkeYWTSqMW4
         0IdT47syIu6tDjBi4cak1UkNKyRnsLkSjx0MwJ86PMCXz7oBjFpwSD0UixdTqS8HmfWP
         tqdkYAPfb7KrDlOAR92AjotxlOBQawEFJa+XDVdS682fxUranPKhdGPzkqYDzABFgtHB
         Qwxr6lXZgN758DEaqqq01p/OGkxfXRCRqDXh8+gVlWNW+mhSCe/6nJBdfnRl2/pTK+L5
         sWQLudJ3cGB5LQpWbgJJtoDNBthUQ61nvGVY0Vr7eOi8UVbiP33+Vq72CSLuwz1YSSTN
         3hNA==
X-Gm-Message-State: ACrzQf0VRbf6Kha9BG4pGeSIKDqpNEuefgPTCWz1n1N+nQkzTb06Ltov
        FXd89IVn4nLdyjU1l9N2XPMIV63QRBQ=
X-Google-Smtp-Source: AMsMyM4lkLby1gHEeOFWlADHcALsYEFrFQWm5GSqcMKQqTBGhNW8SUByosuBg8IDIjuQm/0NpZoRx/Lk644=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1028:b0:6b4:8d06:6b76 with SMTP id
 x8-20020a056902102800b006b48d066b76mr10610823ybt.182.1664585982678; Fri, 30
 Sep 2022 17:59:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:57 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-15-seanjc@google.com>
Subject: [PATCH v4 14/32] KVM: SVM: Fix x2APIC Logical ID calculation for avic_kick_target_vcpus_fast
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

For X2APIC ID in cluster mode, the logical ID is bit [15:0].

Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e9aab8ecce83..e35e9363e7ff 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -356,7 +356,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
-			bitmap = dest & 0xFFFF0000;
+			bitmap = dest & 0xFFFF;
 			cluster = (dest >> 16) << 4;
 		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
 			/* 8 bit dest mask*/
-- 
2.38.0.rc1.362.ged0d419d3c-goog

