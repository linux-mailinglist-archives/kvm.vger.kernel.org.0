Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7DB4BC281
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 23:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbiBRWTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 17:19:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiBRWTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 17:19:08 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08B01FA70
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:18:51 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id bj8-20020a056a02018800b0035ec8c16f0bso5399565pgb.11
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pVXJc061TtsoEtD7PMBvnKKXs8wiB3Pj+BQh/nz39ZM=;
        b=PWhchmhruRHRbpXpRMLRPHFK1XFQmqchFlS47gdcy11C7pj0SAgu1vuOk3S7M2/dhG
         fDkhDUlMuWp+bwxAFYUAgv2ApKkxxdEDzQQGsKMkcFTt4Pg1BSJeBd99+BDxC7UAoD6r
         j4MC+1BQNrKJznA5j2wh2d+gP7bg+UNEl91HHlMltRfW8tpM17N6wYqIpGvNSQEN0vYS
         HX0bdQfvsGenBUR2mXk3u3a+nf1BBPjFrVa53Y6kPC18OI/57+zxG9ViTOl16AUY9A5Z
         43PMlWfQ+UHzllEcmsnhDk4scx1pAsY79MnCH6z8VEVCGxSK8PouWYFkq2XmeVrgJSlY
         +bBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pVXJc061TtsoEtD7PMBvnKKXs8wiB3Pj+BQh/nz39ZM=;
        b=t3L/NZYu0yk6PPqIAQue9GCzaq+j0NvCBSRGzkp1KAU9IP36tF9iU8UHa4K2ddY5kN
         FHpZ4DD7DnP4rGIkqH2J0wKvP4pskjzuzJ2+hySVaQ7pkqsqpKCVkMmQW2mQAz6RiRfX
         zJhzjOgTJ3hFb3K8XBk2rgpmfNj6s/RE5DZyk0RJI7zi6QGXdwWmUtI1SrwAXhZYhpcs
         LLsnsHXUd0QRiDj4bN9BeNl6xVdUa3ZMREHWB9u6BKAHWnzsT4zUESKFUlxXHZ9ULzem
         GrbPKyETgS3B0S5/+5x2WlW9BmATenb0l5yJM5yQ5+ANiDVbJiWo5HhpQme4gquiXwa5
         Pnww==
X-Gm-Message-State: AOAM530gzJZ+Ipo27q9f2BwK8l3RqyR22tpBF5NxvywRmfhHsFA/v887
        csbU1ozkS56BoY5mATRNyGrZORuJFA==
X-Google-Smtp-Source: ABdhPJwGJGkbPMPTEtL4lszTVj6AH0AbHHyVr2JbcSJs6spkuSyd8Mab+dX/jIBFHpH5OLQj3Dy/0W4HAQ==
X-Received: from swine1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:42e])
 (user=swine job=sendgmr) by 2002:a17:90b:3a85:b0:1b9:e751:2335 with SMTP id
 om5-20020a17090b3a8500b001b9e7512335mr14644881pjb.43.1645222731098; Fri, 18
 Feb 2022 14:18:51 -0800 (PST)
Date:   Fri, 18 Feb 2022 14:18:19 -0800
Message-Id: <20220218221820.950118-1-swine@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH 1/2] kvm/x86: rename kvm's read_tsc() as kvm_read_host_tsc()
From:   Pete Swain <swine@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Pete Swain <swine@google.com>
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

Avoid clash with host driver's INDIRECT_CALLABLE_SCOPE read_tsc()

Signed-off-by: Pete Swain <swine@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 641044db415d..0424d77cd214 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2632,7 +2632,7 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 
 #ifdef CONFIG_X86_64
 
-static u64 read_tsc(void)
+static u64 kvm_read_host_tsc(void)
 {
 	u64 ret = (u64)rdtsc_ordered();
 	u64 last = pvclock_gtod_data.clock.cycle_last;
@@ -2674,7 +2674,7 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
 		break;
 	case VDSO_CLOCKMODE_TSC:
 		*mode = VDSO_CLOCKMODE_TSC;
-		*tsc_timestamp = read_tsc();
+		*tsc_timestamp = kvm_read_host_tsc();
 		v = (*tsc_timestamp - clock->cycle_last) &
 			clock->mask;
 		break;
-- 
2.35.1.473.g83b2b277ed-goog

