Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7184D3F688A
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239623AbhHXSAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbhHXR77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 13:59:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFA9C0E56A0;
        Tue, 24 Aug 2021 10:40:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m4so1636039pll.0;
        Tue, 24 Aug 2021 10:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HEn0Id8jewcjHef7bTOMTnX15Pf7THVZ4hwtDc/gbQc=;
        b=SGOQMhG+lLXSOYynPJIMSzV0IjW2y87va+qmXM9QFlnstFrpuhOvzO4yfkQVlIjtxo
         ROxBrgAvviJ9titRCCQepQYhAIILiLuivsV6JJ6gHi0iq2ReR1aF69jZKgbGroFdR/Em
         f3rODccVDhP9VpSTFQlwXLG8q7xSI9kcZjMqsTteQFilAUcqeiwJJ1VeBNbuSd3wrxS0
         vEda56xJaxSr0E695gxcOxf4s2ujs1SrZ6kUYpDREbGAUbN6lGYs+MH4ceRYSSa8En+p
         d2DxuEV2wp0noxE/kdXpxqOeksTMdNRe+QA8NdFh/hgxwUkn2rBg6EKN9MFNY5QIUrZn
         Yd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HEn0Id8jewcjHef7bTOMTnX15Pf7THVZ4hwtDc/gbQc=;
        b=QS774jbXPcQ/cjht/aEURpijFiNDxnUlP7FC4f/82OzDaNCiOpP/IZwzHqcokNQiPW
         kQs//X6HW4Ek4e1kPIVW3BeE8Ua4mBx36rgVYEsLcr+QKDUuQOYHlGiuaTauHcp9ZPwS
         qe2oX9lgZi6MLyaBDwpXzw0qVY/3u1LOlQ9i9NbfYkAdc7TpSV/4NkB6IrevFKkkYWQD
         gwms+yiMSNGrrZd8J74GP2+t8exEM0TOaz7f+KJbsF3nXXblmDBTcUkUR3m957KhfEod
         vwl/XCO65hXJzJH373KZtGHc2Ad8Kd6aYqiNDlC6JTZfBFPYaz3AL9qlrEqZrAxKxl3i
         dlRQ==
X-Gm-Message-State: AOAM5327pz7aybfmOzWlEpyCGTXqKUIjkQeu6jktUVJVfcySobSHv1v+
        hAXscdOVoCE8ONnTiSO7dVciv/YCzr0=
X-Google-Smtp-Source: ABdhPJzZcR3aOHLJ8VoDN+6iQuLKvkzFrcBdBQ8/mNnig7f1E8sPxr07p0IkV+lEEpRyPm5pKI76sw==
X-Received: by 2002:a17:90a:f289:: with SMTP id fs9mr5572327pjb.43.1629826843246;
        Tue, 24 Aug 2021 10:40:43 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id n22sm19861089pff.57.2021.08.24.10.40.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:40:42 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 3/7] KVM: X86: Zap the invalid list after remote tlb flushing
Date:   Tue, 24 Aug 2021 15:55:19 +0800
Message-Id: <20210824075524.3354-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In mmu_sync_children(), it can zap the invalid list after remote tlb flushing.
Emptifying the invalid list ASAP might help reduce a remote tlb flushing
in some cases.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 987953a901d2..a165eb8713bc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2050,7 +2050,7 @@ static bool mmu_sync_children(struct kvm_vcpu *vcpu,
 			protected |= rmap_write_protect(vcpu, sp->gfn);
 
 		if (protected) {
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			kvm_mmu_flush_or_zap(vcpu, &invalid_list, true, flush);
 			flush = false;
 		}
 
-- 
2.19.1.6.gb485710b

