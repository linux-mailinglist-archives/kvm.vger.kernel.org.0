Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7161123B4CE
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 08:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgHDGK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 02:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgHDGK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 02:10:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A483C06174A;
        Mon,  3 Aug 2020 23:10:58 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so19602724pfm.4;
        Mon, 03 Aug 2020 23:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BSDgawubjKZTjBa80whU7RPxG9HALrOtjtBrOe2a6/c=;
        b=CXXo3e4Fn//oKcVoftIyvz229kjYfndjtjhcOG7iFqjPULlGpd0vPxwhM7bfoUVD47
         A9riFUhG4SQ7YM3tA0OqqEHWX3W3LnkwJOySfvGqFgsouLtuGVov1XB6jS0tr+4r7olz
         uLdczamHmIDm1KufCksyNt58T7AZNLQ8Atf1W13AaRoMnVU753aG/sIqT34eVIuur25h
         llusk7yrHg8q61Q+c0pOoMbmynRVZdLxHq3BMWi9F3zK+oMCWTH90Q86GFUYssxXNu+M
         Lb9OCFrcC8GX6bElNdXWdIteL62oOltQsd2UGyz697AdEnF5R0l2lbog4omF9GmLFOfn
         6bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BSDgawubjKZTjBa80whU7RPxG9HALrOtjtBrOe2a6/c=;
        b=bafmtS1tT1Pee5yfj50+j/i8OZXxVPyCWoj22poBJn0KeGvwfLZKV538nTfQxy0Lqk
         mZ1SZOfX5xKBX9zxsH8FaLaIb/T9aw9u16GXYa3BaNEIwBt78gGPFGt3/GSdoC9VQbuv
         iLIvXtLR8xa/G6lK4Zt3TPzv5i0+zWf+curXOgUhya5RF3M24AnzmgioHZRUXwZlAp4f
         yF8asYohmeQvf9I2gf6b6tWDoc9dkS+5E2abch9/g9UuL3vTYpvCm7B+qXRtW3Wy64K3
         E3rufvU9NV95b+5MaU3t53JPsSu7TXmJjFvNTU34Qpy7twKKBqxcsPiUc2lz9CIrUo8p
         hVTw==
X-Gm-Message-State: AOAM531T7DNqRzIk9NdS5d58TCl9eTL1zWwtsCzB3IK2EOEhUnRRWiKo
        Rt4MyPqTTT1qvHwIEHPIydaH0KVC
X-Google-Smtp-Source: ABdhPJwjhVkCBOwIfQJd1BbYy7VJqkKlx4vZhImER3qR1wPDWN2a6Jq0LA2IPbi6RHnOzxrmLKuPlQ==
X-Received: by 2002:a63:e114:: with SMTP id z20mr15925406pgh.300.1596521457625;
        Mon, 03 Aug 2020 23:10:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id s8sm22093069pfc.122.2020.08.03.23.10.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 23:10:57 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] KVM: LAPIC: Return 0 when getting the tscdeadline timer if the lapic is hw disabled
Date:   Tue,  4 Aug 2020 14:10:47 +0800
Message-Id: <1596521448-4010-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Return 0 when getting the tscdeadline timer if the lapic is hw disabled

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cfb8504..d89ab48 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2182,7 +2182,7 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!lapic_in_kernel(vcpu) ||
+	if (!kvm_apic_present(vcpu) ||
 		!apic_lvtt_tscdeadline(apic))
 		return 0;
 
-- 
2.7.4

