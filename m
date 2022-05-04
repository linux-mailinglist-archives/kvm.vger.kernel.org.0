Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E778B51B302
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379578AbiEDW4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379244AbiEDWxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCBC53B7C
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 23-20020a630117000000b003c5ea4365a1so1343546pgb.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RSDJ745FCphTNvqXw5uFQREWtoioB/PaIos9DDppyWw=;
        b=oZ/X9DlVHgrCDxUpGT4sgQW8stjbvmGDtc8TWZWTAgjt8ks3kbmWV6duE6LmBa8I6G
         2nKsESB6OCm++OL8zzx2XtRt8vbE3sTkYlMSDEoJhDXCM+9edXSl3UD2DuQO/rX1Pdy/
         k8RvNOdMdItWFiKuFYVRvL3frS11egfJltj55lza18KWSOtC2OEO2Mx4OFT+Io4KuT2b
         kpB+rVw1yXoJ/aVUi516ES6yWrBbajMbDy5b9CgLQuJVGSYJVIetGfY4yMp1KqDlWumT
         FTqcxzCMVKw6V8C4pHl/0SftLGXBjXFQYtbBf1KuTQH0kTpV7hhyscxuSumIauT8b/4s
         EC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RSDJ745FCphTNvqXw5uFQREWtoioB/PaIos9DDppyWw=;
        b=oPrY0HPEsJrspHo9PlwuZrWf5xyQ3/HKVcJ2jH8bZyi6RTdV5hXtHVl3sTpu+xXBXL
         coWOshNHFrRlDS1raxKSRWlPCFxsAKpuoUTXucRNe1m/+MkcdkDM7IcJWyT7P70Fk+OL
         Hf5C7FrxNFhTfV5H1ZopYmrU5ff3PaFQTRksxHzkf1skN0WaFnx1wbSBXV17ztsRJaKo
         LQX98hKp3VT708e4NVywWWyTK/iDx0uyzZscGP2An9PFSSmBQjmpHzQrb+5DUDM/xhcE
         vlN8JUyKVYyeLRfTZAFqdKsXDG9CCeniA392/YrRWKpNha+6OU99FTVRiQ+TnPQkJqXy
         y/bw==
X-Gm-Message-State: AOAM532iNvzkSXuc8Wrx3t6c9G0vyXD8zlBAwVqoYp0q0az6Fml+7Zs2
        8J8uqzoc/YhUH/uKpGWg3KJAJhfHcCw=
X-Google-Smtp-Source: ABdhPJxBI1IzjPiVO4Es15vna+ytUi3AjeD9zbHHoabY6Z8o7u8NsyabMQ7V/VC75TepWxFO/1w9hT8+6yY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:244d:b0:15e:a3a2:5a75 with SMTP id
 l13-20020a170903244d00b0015ea3a25a75mr17783647pls.89.1651704591007; Wed, 04
 May 2022 15:49:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:17 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 011/128] KVM: selftests: Use vcpu_access_device_attr() in
 arm64 code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Use vcpu_access_device_attr() in arm's arch_timer test instead of
manually retrieving the vCPU's fd.  This will allow dropping vcpu_get_fd()
in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 3b940a101bc0..f55c4c20d8b3 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -349,12 +349,10 @@ static void test_run(struct kvm_vm *vm)
 static void test_init_timer_irq(struct kvm_vm *vm)
 {
 	/* Timer initid should be same for all the vCPUs, so query only vCPU-0 */
-	int vcpu0_fd = vcpu_get_fd(vm, 0);
-
-	kvm_device_access(vcpu0_fd, KVM_ARM_VCPU_TIMER_CTRL,
-			KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
-	kvm_device_access(vcpu0_fd, KVM_ARM_VCPU_TIMER_CTRL,
-			KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
+	vcpu_access_device_attr(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
+	vcpu_access_device_attr(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
 
 	sync_global_to_guest(vm, ptimer_irq);
 	sync_global_to_guest(vm, vtimer_irq);
-- 
2.36.0.464.gb9c8b46e94-goog

