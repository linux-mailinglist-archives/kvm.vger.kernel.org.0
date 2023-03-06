Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C6F6AD1E7
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCFWnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCFWmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:42:46 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6A286DD0
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:42:12 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id t11-20020a170902e84b00b0019e399b2efaso6663355plg.11
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QF0YVo49bCSm6bcyFWH7OqAKf22akzrbGA/pGOKX2s4=;
        b=j70Rx6ona9KIAnQ4HWSz5x9GD68BX0x1weHZP2/r+WzR2h1/SSUiCMoGT0/LMn8Krl
         hDwgLLwODSiQraOXzkU5foUjHwl43UOCrK1AKg2uMA8DJsB9kMN/FpRAawq/Jm/VX/cJ
         LD8cxRl72IW9wCnhEe3Tet/54wvO6hOSZMHRw53rLydqkVnq/i9RrbKZqXUkjhisFLgo
         MwQy/8x+BSK/8fCADVgj6wpzAz8cfMGDyyHWx55HQAg+EUJ4PFbAHSh2HUhxjhsnfQjL
         g901dK4CRZerMpvmU1+ZNo/lW5rSjLY+I7K/GMlMMlDpjMd2e9OzGaB7LM7xYGdRwzrT
         ePNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QF0YVo49bCSm6bcyFWH7OqAKf22akzrbGA/pGOKX2s4=;
        b=YUNHpUhl9BE1tnT/CXl4QxPY/ULAo0CZavDjhc6d02ix+MRRceqXgUdgIKawIzMaZG
         IY3Mz285cpBALsauKWkuuo99nwOjo7NBABj3fE3dAwkFqfcbSKKCQNb9qKWCsKOvYWzY
         3Vw2Ay4pZ4W5a3Qm/UWWdpkVcZXUSRyGk/BeoRiDoDkorx45udPPi/a5Ri8+v7AajL62
         QkS0faQTv2ZXPdoSuV2nCuOUhs7W3atii6WByK+B178krNVlXnjyltU8uRwGZlx9hqNe
         qmuV/GJonY4XPFolfU6rNuqlMKYu44Xbk4zCYldeN1mxqfRenjn7GT7JlTZJdyPOzb3L
         +Tnw==
X-Gm-Message-State: AO0yUKWSrR+LrFrlJMcYsHI2ahA69ww4RJQutn/4yMbbpUrP9nMUXDC8
        hceRG1PB3j7UHssJ2ysO2DjP9WxVvD4I
X-Google-Smtp-Source: AK7set9V/EfuOapXLc/xwlEXZ52sVooC/583kWWlWB81qUshsgV2Atlufd/VpVQMEq1cD94C2YRFlFJFN9P5
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:3747:0:b0:503:2d50:5bf1 with SMTP id
 g7-20020a633747000000b005032d505bf1mr4047163pgn.7.1678142520704; Mon, 06 Mar
 2023 14:42:00 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:24 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-16-vipinsh@google.com>
Subject: [Patch v4 15/18] KVM: mmu: Add NUMA node support in struct kvm_mmu_memory_cache{}
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Add NUMA node id variable in struct kvm_mmu_memory_cache{}. This
variable denotes preferable NUMA node from which memory will be
allocated under this memory cache.

Set this variable to NUMA_NO_NODE if there is no preferred node.

MIPS doesn't do any sort of initializatino of struct
kvm_mmu_memory_cache{}. Keep things similar in MIPS by setting gfp_zero
to 0 as INIT_KVM_MMU_MEMORY_CACHE() will initialize it to __GFP_ZERO.

"node" cannot be left as 0, as 0 is a valid NUMA node value.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/mips/kvm/mips.c      | 3 +++
 include/linux/kvm_types.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 36c8991b5d39..5ec5ce919918 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -294,6 +294,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		     HRTIMER_MODE_REL);
 	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
 
+	INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache);
+	vcpu->arch.mmu_page_cache.gfp_zero = 0;
+
 	/*
 	 * Allocate space for host mode exception handlers that handle
 	 * guest mode exits
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 5da7953532ce..b2a405c8e629 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -97,10 +97,13 @@ struct kvm_mmu_memory_cache {
 	struct kmem_cache *kmem_cache;
 	int capacity;
 	void **objects;
+	/* Preferred NUMA node of memory allocation. */
+	int node;
 };
 
 #define KVM_MMU_MEMORY_CACHE_INIT() {	\
 	.gfp_zero = __GFP_ZERO,		\
+	.node = NUMA_NO_NODE,		\
 }
 
 #define KVM_MMU_MEMORY_CACHE(_name) \
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

