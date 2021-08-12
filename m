Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3085E3EA671
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbhHLOWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbhHLOWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 10:22:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E464CC0613D9;
        Thu, 12 Aug 2021 07:21:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n12so6814772plf.4;
        Thu, 12 Aug 2021 07:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csFOusVLJbr+QwATacvMZAXfEPfUH2cDcHQVoTGE5vE=;
        b=JkEWtiTyDNnJ+BzIN7Gz4qDf9wicTiI7ILdP/I+xMvTXTscedD/r/rSItHK+lfLr0z
         0OtLaO69EGsib16m8EQWcCZpgB8SPH0upDGSu4NxUrfhBlgrnfyTkf1+yiTgPxSatpH9
         17L45Is8Dp2uwQstt+csUVSpQBzigZP1KR8nmBMnFFqqDLSA51/KSBzuQpqN78eARQ6n
         hwDDchcyVUhJmebAjxPf4opcS6nCJYJUmorP/vgUJmu+TeYiobJcWIRTCPfz/bl6HKeg
         d8U7Etb1zaRQsS0uVQktLHvt6yy9puI3MLSRFIDkdc/ROeq234enJPc2yKkDh2zChW4B
         AJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csFOusVLJbr+QwATacvMZAXfEPfUH2cDcHQVoTGE5vE=;
        b=rLybaxMonuxstrOXBp3hPIvNgaRmzFJamNivL6LE3h6+XTlV+ypWbNvADW2wsjVe7a
         vwyalu7n7uhu0ona99SyxfXar8C00y99XCOWR9oXyz9C8GRAXPuLZV/AwkdOfKaRE8JC
         juyPieZ4NSCpi9gctRfw+Vb9axuWgxx6uc0nEPPtikbbZg0iizjCtuHRwInIUQ2guT+V
         IANMC7lHkLV6SkaTIuE/vdMXNhU0QzrvXLngDhZ43/mO7Zwr1Xr1g83pLv3DKInp0T9S
         cWLjfTBBphdrJoUXaeUThY+SD+Ttdh3dCFLN/BVA+WIJs1GzIgI5+bJn1VAKH+H10oCS
         S1uQ==
X-Gm-Message-State: AOAM532ocHQeZ0VR8DGtOf8Uq1n3Z/UpdyMHyQx8WpJ0azzehhg5NRWF
        kN/JcvrYAQbzX3ymF1i0NFqHUFrBQIE=
X-Google-Smtp-Source: ABdhPJxDz2GetmVfJp2EYNCcDHh9bJawwgY+Rv+RN1HTpSpXhkjBHc6aQr/V0Lw0d/St2Uq1V1Mk2A==
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr16100202pjb.149.1628778094275;
        Thu, 12 Aug 2021 07:21:34 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id x19sm4129996pgk.37.2021.08.12.07.21.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Aug 2021 07:21:34 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: X86: Check pte present first in __shadow_walk_next()
Date:   Thu, 12 Aug 2021 12:36:29 +0800
Message-Id: <20210812043630.2686-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

So far, the loop bodies already ensure the pte is present before calling
__shadow_walk_next().  But checking pte present in __shadow_walk_next()
is a more prudent way of programing and loop bodies will not need
to always check it.  It allows us removing is_shadow_present_pte()
in the loop bodies.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a272ccbddfa1..c48ecb25d5f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2231,7 +2231,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 			       u64 spte)
 {
-	if (is_last_spte(spte, iterator->level)) {
+	if (!is_shadow_present_pte(spte) || is_last_spte(spte, iterator->level)) {
 		iterator->level = 0;
 		return;
 	}
-- 
2.19.1.6.gb485710b

