Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294CB45C417
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbhKXNp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350772AbhKXNmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E5BC0698C5;
        Wed, 24 Nov 2021 04:21:06 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso2560751pjb.0;
        Wed, 24 Nov 2021 04:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AEdqjK4o16EGLSk6JO6HF5Tgz4hVCtbgs2lA50oCK6g=;
        b=EsylvIa6Gpn3m2ZXaJQlOQMttlasMarVx7+tOAP/h1b5Sg4ffnlTAQIl/gKLVjnDHL
         YMkTwAZuaD7UIDCPG9GsDA9ArdDM65KIZj8X4fcLj/UFemAzH/FIfDKwWA03hTlr8xII
         scM+GnDHOyp9uLmwaYg0G5bq9oQ72luE3g38/fLEbF9YshdSeM3G2Lo4ky+lS3QOPm4N
         fRgG/2Lu1aiZTAddbK0ktvLyl/OZ7XX30Tezyw1snZtjm3SbePkG4EXv7uGDRfEDXLfw
         aVSEZuG8wDoIe05ia9AjHdfbQS0OFDBevporn0iHpP2D8/1qFDfUQW7nB5fWr8N2fRP5
         fDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AEdqjK4o16EGLSk6JO6HF5Tgz4hVCtbgs2lA50oCK6g=;
        b=5VAmcO0vtyLsow+o54Sv8wuRLkspl4Va8ZEuLuOPnPjBKy14blCawaGA/ei/0j+ZNf
         CDZczyMVhTZ2TW2My3tQqBCN364CAoqiE+WlxEuU4k3MwwAQkL5NlLTaABNmTe7tz9GA
         a4bhO9m1hzbmKJF9Iyi0K9El7lacHgtD3bbJ54veYtzB4PWddpzBfsJIR9PiBQV20tf1
         0zsjzcuzAucF/H6THrEsy8nFLL45ktQih5g8+B7zreb2NqpbIHPHOJoOu4lftbddPWLX
         XrU2AXVr2rs77GhxclTm2Iv5t703tqOkuuxj6u+KzjxCfY7UAg4x8aEpbJWy59U2Yoo0
         3khw==
X-Gm-Message-State: AOAM532CwxO20c/qFsMCy//gDs7MRY1mxlOh/mZUSzjvgJDPlQf1Fuw4
        2fRI4yLzFR1UoiNqjpzyaLrIn4zQlm0=
X-Google-Smtp-Source: ABdhPJyI7qlzd1CFleVPx388vWONmPdD5I72tP5aJSGc5nveoHSEINgbfO7jMLHBwLTTwsNsh3x/tw==
X-Received: by 2002:a17:90b:1c02:: with SMTP id oc2mr8202258pjb.65.1637756466275;
        Wed, 24 Nov 2021 04:21:06 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id j13sm4285647pgm.35.2021.11.24.04.21.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:06 -0800 (PST)
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
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 01/12] KVM: X86: Fix when shadow_root_level=5 && guest root_level<4
Date:   Wed, 24 Nov 2021 20:20:43 +0800
Message-Id: <20211124122055.64424-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If the is an L1 with nNPT in 32bit, the shadow walk starts with
pae_root.

Fixes: a717a780fc4e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host)
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6948f2d696c3..701c67c55239 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2171,10 +2171,10 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->shadow_addr = root;
 	iterator->level = vcpu->arch.mmu->shadow_root_level;
 
-	if (iterator->level == PT64_ROOT_4LEVEL &&
+	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
 	    !vcpu->arch.mmu->direct_map)
-		--iterator->level;
+		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
 		/*
-- 
2.19.1.6.gb485710b

