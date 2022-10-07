Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFBC5F80B3
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 00:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJGWQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 18:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJGWQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 18:16:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4819B847
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 15:16:53 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-352e29ff8c2so57494937b3.21
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 15:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lKdp4m7Zz0sH4tTvYYgZMu0Y+AniCJ6EdamUfVQkMQs=;
        b=fx4/EKprewfhophyNiXWrpQ1oKv2YWLlRZnjLUSoWX+U6yCg1Vxspuk1vSxtL7QEE3
         hY556mi0fO3a/NvB8jq8sLFwwxPU5B7Z3vqhJUOO8SaKGkC9DMh8c+ymcnBnipc0uNnK
         U3VwdQXS0fi1ChdoJkI6Xm0ebCPWHfDvqioh6kSvwvjsp5OPC1pta1mSx0EWAFS8Y0at
         BYhB5YFL9GXu2c075TGidscaSePkOcvT1oTfgZ2wcbXJzIHjc1pYI6+7G4T1ZBbu2fAV
         iNeJfEC0G/G+Rk8eg84cAcWaq7iNEbKeHDpezd9Kt4jRcxRbDTbPK+IhpOISV84/EICL
         AMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lKdp4m7Zz0sH4tTvYYgZMu0Y+AniCJ6EdamUfVQkMQs=;
        b=fi2SJSbBjo6M1UZW/Tx7FKakhBP2X7MSy0LMrl/vrrqgHIVO4OZaDjQVSFuixM3VMS
         KQZLqqcxfdQzNsrXFH/CEMx07uVja++YFZuCZ1WkMiDw+mgS4wKMk5Fpn8/1xZi0K9EN
         7ghwmCfARodtv30Ci03UnHEnjTPuRTr/SLVmc9EV+pxwk1g8rl5K2s8yuC2jDrt0u07/
         yb29xr+xvdE92I/iZl+pXASqbFf/uJKZgi25/D2r5fv9oVY4N5hBWQYzD193bazGlAUm
         U8OSVJfvNNoeRwvcS0FxehOTc2LRU6vJgkziC6Syo71IGjFkpRtkJ4v9+k1qUOvv+BIi
         5ZJQ==
X-Gm-Message-State: ACrzQf0ZtxiVYwyYCqXcKToE8pVOlRk4lXGJnbm3Jth1+Nu2j3lGmItI
        c5l8xoB5VIakHx885AUQRb4zdJDXv8CrfGGlwmuk8LeoFDARZcs2a8n73WIABVTxEdv4E8VSjKM
        NrPcyCUXt6cwTctbvVLwwJVylt3VGVebbr9mxJ/+Rm4m18yY0ylCv5pgJ/FLXQkM=
X-Google-Smtp-Source: AMsMyM7O0GACdN0ftUNhFS0gB9fl5hUAQN2G5R3ewXKXiBWK6QgxzBqD/yDCOdTPWP3a7lZz/GuJSdFWSsU8Qw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:bb8d:0:b0:696:340c:a672 with SMTP id
 y13-20020a25bb8d000000b00696340ca672mr7331108ybg.332.1665181012384; Fri, 07
 Oct 2022 15:16:52 -0700 (PDT)
Date:   Fri,  7 Oct 2022 15:16:44 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221007221644.138355-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Advertise that the SMM_CTL MSR is not supported
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
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

CPUID.80000021H:EAX[bit 9] indicates that the SMM_CTL MSR (0xc0010116)
is not supported. This defeature can be advertised by
KVM_GET_SUPPORTED_CPUID regardless of whether or not the host
enumerates it.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2796dde06302..b748fac2ae37 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1199,8 +1199,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * Other defined bits are for MSRs that KVM does not expose:
 		 *   EAX      3      SPCL, SMM page configuration lock
 		 *   EAX      13     PCMSR, Prefetch control MSR
+		 *
+		 * KVM doesn't support SMM_CTL.
+		 *   EAX       9     SMM_CTL MSR is not supported
 		 */
 		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		entry->eax |= BIT(9);
 		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
 			entry->eax |= BIT(2);
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-- 
2.38.0.rc1.362.ged0d419d3c-goog

