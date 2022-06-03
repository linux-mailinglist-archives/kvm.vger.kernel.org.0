Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C853C2A0
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbiFCAoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbiFCAoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507DF37A12
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:58 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g129-20020a636b87000000b003fd1deac6ebso134418pgc.23
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6TqR2TtIAFDMyHtwdQ6ENJHifFWcPp2E/NJNAkiSnxY=;
        b=rZo71jz3I3CHllW5m5dbKxPzI1pahTR9DNVlag83m6Pe4XBUeASe+SZzMU+ciNtnPB
         vRd+DaUa5qB/4JZWvhlp4awSpPgP8dAXrS+gA3hI7C94HkfWuZovsblQc6nck67ouwXu
         g2HdrIfPNqLLoCdz8GmF1dtWRcMcF5gUvArVKfC+4LeIX5187lG9KKDStS51RZqI3BCD
         tu15Q7ZB1O6xnrrqp0ed9DLJJ8F+h6/RIZq5tI1LAOblgqurGWg25wH1ZCF2Ut3IaNOO
         xGr3RL/ZGbPPbdJv+rjrIXwq/R/wQCD37vPbF3M2jvCrvP3IT5AWMZat/uT8Jl3mw+WR
         A6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6TqR2TtIAFDMyHtwdQ6ENJHifFWcPp2E/NJNAkiSnxY=;
        b=UAiUFzkaMmiElreJAZ2X0X9ePC7bTWgiWl1knHEzJqu8IFUC5qy7+3iurO9ysk+bD5
         2MMBjHExG+tob89+pZ2QXq1nGTK2XgeJrZN3NCLl1q3Uc3wFSu5wewdGos+FL5zdR8FF
         w4ewC14ugWDDGaiQoxLGj91ZW56jhy1vfLtGxp73DFEAyp3UY9DACi7/nVCHyLqzy/gd
         H3rFwYW01HHQ2O+NCSrtzBOUIJ6ShBSrl9If2zgsEFrCW9g9kx5z6TdiHg8tl1k+y96e
         K2G7sfH/eODrAtQhyR6kA2MA7zuEzqVAM1NoU5iG2IOXXqhxTFLqmyYE+zIAJag4aU9q
         GyjQ==
X-Gm-Message-State: AOAM530OLpjPDxi5UwNaudNAVb3Y82SaK7FyDZKhpb8MMON/tTP16yf1
        uWdlj3bc+nT8A7+3br9dYxGvINYT++c=
X-Google-Smtp-Source: ABdhPJz/dR2aPeg6ELGl/oGUTP9IRPOfyOKM8EWXAZUO3HGRY3QyZtgvPshueIfkhUrHPXkgdF/bWDBeMiA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:18a:b0:166:ba97:8b19 with SMTP id
 z10-20020a170903018a00b00166ba978b19mr2371326plg.62.1654217037855; Thu, 02
 Jun 2022 17:43:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:19 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 012/144] KVM: selftests: Use vcpu_access_device_attr() in
 arm64 code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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
2.36.1.255.ge46751e96f-goog

