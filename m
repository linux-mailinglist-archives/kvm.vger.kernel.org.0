Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC015A72BC
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiHaAh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiHaAgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:52 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F60A74E1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 125-20020a621483000000b0053814ac4b8bso3529676pfu.16
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=08A/F7QHFvdlbnKklqADdddOKG9On7dolttTZc9ut/0=;
        b=CkX2HuJEwn2lrV3MfDjQU7bSjgXyWBqH1zLOhoXEALnjWvgnh9NnoXVN3W8W2Yiabx
         8Xh0QTllzSGgDxYS/zmh7UMnqFS8gOaI/RAXjl4mzy0Ejd7hST5Tmd5hnq7dK1vCmlup
         5xGMpyQHyV+sZMw8vLXbnTFOtU1DX3moFs6DahywnQfnNozyD3jmeJ/wCV+LUVv9mCLX
         1ipFPq78hArYCly/jtVv/Q4NDHnLwdOw4/RLyzHla5Joj2WPCz/xYhvaThEFqxbJ+SSh
         NjKLj4SrpMc1BAGIgnbRUZedkIsMBCm3T66SZFvstg01GTohs/Y4bOTllL3WP3M6aXXJ
         k9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=08A/F7QHFvdlbnKklqADdddOKG9On7dolttTZc9ut/0=;
        b=Y/amvZJtps/PPyaSVQqwIPlWrH8VrVYCbMmMVRkgqWjxTmPt/M2MIdvl0WQzOlhwyA
         PSLDRu686QyLz53Vaz3Rn+mKCN7OnqL8FXcvbW4xlkP7fR13Chvlfe6Mz3cdVPVaZ4tY
         eWphEtXxr8IJD2xPa/H13TVqFASlmmJWAKbbTyhV2nLI28n9ZuyJDRsxI40OgU9FoDeU
         kqFKSNO0g1rL4LUvBZUYK6cPWTwOMGvGFksmMJD761i6MOE2b048+G55sdezYMiXv6rH
         O79DBDu1GNDZtehTRRWByb3aEIYBvg915ID8kk3KVIZrjSS8YnRbw84ON/vO41A0dZLi
         knpA==
X-Gm-Message-State: ACgBeo20MekazdrZ9FrFPeJfk15p3tmx7oSbX20fIdvSDf80iaLJFJb8
        3MfvwjxUJB2bk6S0Bs8Wa9Jq+eTTDvI=
X-Google-Smtp-Source: AA6agR7hbcOraGRxxAHcuZ5giMtcBel+k20eBMC4aqh6XQFuibRrMfc16BSRALwulHnNm7n29kP7LixwI8E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:804c:0:b0:536:80bb:8270 with SMTP id
 y12-20020aa7804c000000b0053680bb8270mr23509612pfm.13.1661906119769; Tue, 30
 Aug 2022 17:35:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:53 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-7-seanjc@google.com>
Subject: [PATCH 06/19] KVM: SVM: Get x2APIC logical dest bitmap from
 ICRH[15:0], not ICHR[31:16]
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

When attempting a fast kick for x2AVIC, get the destination bitmap from
ICR[15:0], not ICHR[31:16].  The upper 16 bits contain the cluster, the
lower 16 bits hold the bitmap.

Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3ace0f2f52f0..3c333cd2e752 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -368,7 +368,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
-			bitmap = dest & 0xFFFF0000;
+			bitmap = dest & 0xFFFF;
 			cluster = (dest >> 16) << 4;
 		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
 			/* 8 bit dest mask*/
-- 
2.37.2.672.g94769d06f0-goog

