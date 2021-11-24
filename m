Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F645C3DB
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348547AbhKXNo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350380AbhKXNmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF68C0698CA;
        Wed, 24 Nov 2021 04:21:24 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso4945564pji.0;
        Wed, 24 Nov 2021 04:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i9V4Yvz1w6hXJCTJPzmC+m66wFQ/GQ8zbRs/udK4i6o=;
        b=IpjGHsoraNKAijhHmYeTjdAq5Jpm/SaJ2j2xp3JzpAW0/POUu4Stlj21Ylqg1k/tsl
         SY/9wuPuYUnUzE3B5gOuOfxe/8bx6ktxKGiSK65zQFlmfhcdn6o3UTHKTkeVIcb3FNcL
         g8L5k7F/I7y3Mfwe8RyvARz9o9kDSRiDq53aqsiAJ1QI0pIjEOYQVUGEcuI5WbwwcFvA
         Lj7eF8cKKQeKnJ/rF31td1MyuZ95UTPcdSx1kqIQDd2BZNYjTwDDFAWK1qRlfKL+hXZr
         hhhYiTv3FcUrFWbcNP3p19BtoVJNS+wLzRNGpDdFj2YuWBgWTw/xuo1nmVni8Ww6t5on
         RIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i9V4Yvz1w6hXJCTJPzmC+m66wFQ/GQ8zbRs/udK4i6o=;
        b=PPTbsA8tVSqKrhDa1Y1v6oeweTzdRTEixQB8FYBh4DQ20ugPfKrCYgH4y0APacHy65
         aXn/6N515dFXYX67cmWlARJtKDSVxYRXXs8ZVLcwi3gbvcfdPGB+7vSf254jUHAzh1+5
         pk8QzUzGDI2B8bBSvE/jkS6CfpaCLldd185pANVXOuM80TDVCYPPMXKX5o9Rg/KNbJ4N
         lXmEKbFd9f3CZaPZVcwKoXa8WALtyTtcmX4xHrli+29dShE+8IW9oM/k7SNA0HxbBBvc
         CyM/zGKfYBEN0FilJlrgh0XWxlr7+8aFIZ8sCGoazNXBx/YtZya2RTIJ8waKSXcPku3K
         yJCg==
X-Gm-Message-State: AOAM533qgVbimgvm9DcV2f5i3wqPgiFCm7qCTooCrfpFHTQnXtjr27EB
        pcFEREt1dElvBVqtnw477E5559D+YzI=
X-Google-Smtp-Source: ABdhPJyoaEFIkIIQq/1l/gdL81QGlS8vFVOYQfjxMxyf2iJ1jYH/jRjqjZQHyhcs+8b3tiwcgHEF2Q==
X-Received: by 2002:a17:90b:4d86:: with SMTP id oj6mr8263437pjb.101.1637756484383;
        Wed, 24 Nov 2021 04:21:24 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id np1sm4777841pjb.22.2021.11.24.04.21.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:24 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 04/12] KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()
Date:   Wed, 24 Nov 2021 20:20:46 +0800
Message-Id: <20211124122055.64424-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In design, the guest virtuall address is only make sense for
vcpu->arch.walk_mmu which is often the same as vcpu->arch.mmu.  But
they are different semantic by design, so vcpu->arch.walk_mmu should be
used instead like other call site of kvm_mmu_invalidate_gva().

In theory, if L2's invlpg is being emulated by L0 (in practice, it
hardly happen) when nTDP is used, ->tlb_flush_gva() should be called
to flush hwTLB, but using vcpu->arch.mmu causes it incorrectly skept.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f3aa91db4a7e..72ce0d78435e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5353,7 +5353,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.mmu, gva, INVALID_PAGE);
+	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.walk_mmu, gva, INVALID_PAGE);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
-- 
2.19.1.6.gb485710b

