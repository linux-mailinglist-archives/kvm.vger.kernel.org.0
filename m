Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE52061121C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 15:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiJ1NBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 09:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJ1NB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 09:01:26 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD681C843A
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 06:01:24 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so2549493pge.0
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 06:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cQWkgAS/kAsZneVDkQ0rxEB1PW/u8LB1bPfXtiPf7pA=;
        b=rUaHJ1oVbQkRKMsgIAaolCQKje4eXBmWy1CYFR970wFLVNfI03tFEZy3D29OTddh9k
         mjvgniP6fXFG5efpA2VBgdcoXKE3kSjP47UXLiKO5jACvrQb1TC7zydK85Br/pk63IKz
         GH6GPhYK2gS6+kzZTApfFD/eh1+4AlZCOJyK3/2YCKp/QxyBlOpYWwpRE3KHC/+czb8n
         IVXz9LMStT1Oll9TPw2jy44nc8PPRWSgGTzIKcOUMVSLegctDpLxP30zvKG53R7GM30A
         XOdcpUB288LbJZW4o7OgxaiTV7dMFTKbvR62LQ25LnFk6d1ux3cyHYqcW6C01dzTLnaJ
         fGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cQWkgAS/kAsZneVDkQ0rxEB1PW/u8LB1bPfXtiPf7pA=;
        b=bz5N5LLM+pJylfXV9/lX5o9lcIIHm6sqEuOyUvd5mTHUceOPDAbu/EdCcLe4TaIO1x
         Cyrd/u9kcvdE7SELfY+BUczM9zj2DQ85bbP8sFWkyAURIaRv0wwZpNwIXFdkvWXWo0Fz
         OuKnGQ8s7RSenqL9L/ZvAtc+V7o5lZgQ8hsbkNjWni4nV3nhaLSttMjCOAL2gbWEAnIX
         cSgcySp3phH2OObgecsS9nKUQUc8GEDTzLfONq1srNKr9h3wXi0Yji/YWtoWFEtxqYkK
         /3kL8qXOTgGTTW/yGf4SCw2gWiPLizD2iwuLFXEdcUp6cjEdRqxlhE+8dU30a1Yx7nhj
         s2Xg==
X-Gm-Message-State: ACrzQf3hF9Ij01Ivnd7MRLrsil2Cak3lRaL7+lBSFNGT8itcCiY+F34f
        aNyZuTM7OQR52SYDxPMcfF3/QE4aAbVmgQ9NjIVuT9Q0qtZjGf7yGVZVpeO/4zBV5hf5PVT7xZC
        OukvDvoWhmTxmzAcxXigGIDdMNlxUZCIZ3mmPKm+4pyrqbvsZumLTA6QIAvQP0VWY47XA
X-Google-Smtp-Source: AMsMyM6y48cKJ1efL+oYy4GdE94peVL5GoyDXsaBQnFv48+3YxOIE2DodOznp69AwobxpG+3LlnnMQwZMbjWxt3h
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:f710:b0:178:a692:b1f7 with SMTP
 id h16-20020a170902f71000b00178a692b1f7mr55126530plo.112.1666962072962; Fri,
 28 Oct 2022 06:01:12 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:00:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221028130035.1550068-1-aaronlewis@google.com>
Subject: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the pmu counters
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

When the host initiates a wrmsr through KVM_SET_MSRS don't print an
error if the PMU is disabled, doing so can cause a noticeable stall
while printing the error message.

The profile below was taken while calling KVM_SET_MSRS on the pmu
counters while the PMU was disabled in KVM.  Even though the print is
rate limited it still manages to consume by far the majority of the
time.

-   99.75%     0.00%  [.] __ioctl
   - __ioctl
      - 99.74% entry_SYSCALL_64_after_hwframe
           do_syscall_64
           sys_ioctl
         - do_vfs_ioctl
            - 92.48% kvm_vcpu_ioctl
               - kvm_arch_vcpu_ioctl
                  - 85.12% kvm_set_msr_ignored_check
                       svm_set_msr
                       kvm_set_msr_common
                       printk
                       vprintk_func
                       vprintk_default
                       vprintk_emit
                       console_unlock
                       call_console_drivers
                       univ8250_console_write
                       serial8250_console_write
                       uart_console_write

A stall in this situation could have an impact on live migration.  So,
to avoid that disable the print if the write is initiated by the host.

Fixes: 5753785fa977 ("KVM: do not #GP on perf MSR writes when vPMU is disabled")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cf1ba865562..a3b842467bd2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3778,7 +3778,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-		pr = true;
+		pr = !msr_info->host_initiated;
 		fallthrough;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-- 
2.38.1.273.g43a17bfeac-goog

