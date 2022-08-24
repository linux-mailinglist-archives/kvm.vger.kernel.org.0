Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7559F1C3
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiHXDEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbiHXDDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601CE8286D
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-333f0d49585so267543847b3.9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ZsqH6DVEBbg1jPMid5iFhYVXrPJ4Q7ry0blNjc4uPxs=;
        b=OoyykDVYLpsPaKtp8ynRBoLA4uNgr2U/YifsjIi8UA0x3HQ91SKjue+9sykNqtmyhj
         FOe8dCXSJbICIOn3rNnfATWFH/OopZX6Ut2E5Sus5J5xiODOaCPrnT1QLnApGKhyXUDu
         6z1ug3UYPo3IMrMEl5/G7aIciGOD0Digrs3u/GySuX8k5frPcfY2PrxsUE0WjEDvLGgi
         xw3cl6Ecmq/kyhpLnwANce5AwGcUThwqas25qJf6OcCF59n7QDCfzIWSvOpglAl1QV4/
         20GPBCq6+TmcY887qHYUqkAa7kPSQwrAFFNA5+wkjG0j595mXmwtpjRPV8KDQz69Wpwo
         2bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ZsqH6DVEBbg1jPMid5iFhYVXrPJ4Q7ry0blNjc4uPxs=;
        b=GLSSvo6AOb/HUIwBDwkNgU1vbFBC0XNZ1/M4cXFDNe3aewtsALpS6fMcJLe/4/bCit
         xzE7+Ew87Y2gCWiR9BGlR+ejfGyVgT6GikuWWuCAv+t/N+Xr+V6vnVgTc4qKQ9Y6QqZ7
         AllYCeax51Cv+ZLmBRC1dMfCIZyTYh17h4THgCruc/swaLDgRHPUOou44O5WoJoa5mqo
         SjBFXo8vnppwRd/Ud/PBbp78mMEaHlQEypiSvBckaoHjodebqy5MiGU05UOlyv2WU29d
         RAQs7ZqmtRk6Z4DUwXUz95ucZY36Co9aPFGVr+nw6i0O9kop9KSbRtOoSxhChWJtuUnr
         iq+Q==
X-Gm-Message-State: ACgBeo0oLfQKttS0XIrc9TAvffoaI1GFCYIVo26u7LrQeOxldPDywJhj
        WrR/ip5Kt9wnyyAr+snjQas/bWxoKxE=
X-Google-Smtp-Source: AA6agR7P6CN6KGKKJPkE12ijVFDjERcQx5l0bFe+SPljcUw4FRwVblp1lNU7Gf2vFbpLmoO3eQvMU5L4R28=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ed0c:0:b0:68e:e337:8d6c with SMTP id
 k12-20020a25ed0c000000b0068ee3378d6cmr28274617ybh.198.1661310142947; Tue, 23
 Aug 2022 20:02:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:27 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-26-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 25/36] KVM: VMX: Don't toggle VM_ENTRY_IA32E_MODE for
 32-bit kernels/KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

Don't toggle VM_ENTRY_IA32E_MODE in 32-bit kernels/KVM and instead bug
the VM if KVM attempts to run the guest with EFER.LMA=1. KVM doesn't
support running 64-bit guests with 32-bit hosts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e694eb2190f3..cbb88d1fd55d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3035,10 +3035,15 @@ int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		return 0;
 
 	vcpu->arch.efer = efer;
+#ifdef CONFIG_X86_64
 	if (efer & EFER_LMA)
 		vm_entry_controls_setbit(vmx, VM_ENTRY_IA32E_MODE);
 	else
 		vm_entry_controls_clearbit(vmx, VM_ENTRY_IA32E_MODE);
+#else
+	if (KVM_BUG_ON(efer & EFER_LMA, vcpu->kvm))
+		return 1;
+#endif
 
 	vmx_setup_uret_msrs(vmx);
 	return 0;
-- 
2.37.1.595.g718a3a8f04-goog

