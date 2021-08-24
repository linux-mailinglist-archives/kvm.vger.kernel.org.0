Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CA93F6897
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbhHXSAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239356AbhHXSAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 14:00:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C014C081B1F;
        Tue, 24 Aug 2021 10:41:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a5so12682025plh.5;
        Tue, 24 Aug 2021 10:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U4DiJbbRSL9RJ86g/a4Cg/6UN5ORuG4SS/e84gNuqa0=;
        b=D0VMCcGPGgq4s04g076Ys1ZIM7vBNXlJHQc30ROohgaMz4oo0qq0UQjd6/FJ4SAH6h
         z641GNTGpqKTba1ZosjCqPpOUvvBzRTEEV4AnwGkd2FrvtoPQdjvGGtJaa6SQwdIQOPr
         EBMbYand+QAFQDoOKFwqPq2IdCpT8mh+4/f1He10ZBL/8bAlJlwazhXKWzeydKgmz2VS
         RiMqAWvO+wk/8zjKLA577kW8VkowIg+bdDKbENhmAqCP3dvtuJVpMHEctJnxlq3ujJ47
         BVcLPplzxtr21znWEigtB/BT6I6IYaLcxNWazP+p35TvmXSq8pAq7DYmc0SIiJ5hTOzc
         WgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U4DiJbbRSL9RJ86g/a4Cg/6UN5ORuG4SS/e84gNuqa0=;
        b=sNBF8IMpNcEQc3a6NjjFePoVQVyobrtSLMoyG0ex1jufgn94sxdQxRoWa2RNCJChxP
         WEvwRTv/i4yi0lGU22V0kkD2rTvXQCU1zB8ngH9vYU+0yAaMFxYzAUdTeYbxe20owEGs
         YN/lLtfcuYSDW21xmJqfHNOFHaZfV38a5LMwCIhaAif7977Z5pcs0yOrxRcpHbbLP/l9
         6dMPKa0Je5s035rivaml/oGWxbBm7i+WGQhzezcSKoLMmdJ5gZduRyBpOAc1JSpqrBb8
         Fu5I6hsCG2TnRImuDBXhc2BNXaH/QzEkNhaJYFA8kvyLXiXA/cs3CXwVA/+RqgcOIM0/
         KJdA==
X-Gm-Message-State: AOAM53144V3zaWua/N8GW4MnWsK9qBgtYFvmSvqt2yAe3y/vEPUTikrx
        hM2+kuoDDic/SCJglX+do4CwiOssBOE=
X-Google-Smtp-Source: ABdhPJym2F8WG9gPjxCYxVWnI0py9MZspka9xpAneeOayM1EFSfXUk2goHILbw1AfjsNsqTtykB4wQ==
X-Received: by 2002:a17:902:e84f:b0:12d:c616:a402 with SMTP id t15-20020a170902e84f00b0012dc616a402mr33651656plg.77.1629826869877;
        Tue, 24 Aug 2021 10:41:09 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id 15sm2987674pfu.192.2021.08.24.10.41.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:41:09 -0700 (PDT)
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
Subject: [PATCH 7/7] KVM: X86: Also prefetch the last range in __direct_pte_prefetch().
Date:   Tue, 24 Aug 2021 15:55:23 +0800
Message-Id: <20210824075524.3354-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

__direct_pte_prefetch() skips prefetching the last range.

The last range are often the whole range after the faulted spte when
guest is touching huge-page-mapped(in guest view) memory forwardly
which means prefetching them can reduce pagefault.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e5932af6f11c..ac260e01e9d8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2847,8 +2847,9 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
 	spte = sp->spt + i;
 
-	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
-		if (is_shadow_present_pte(*spte) || spte == sptep) {
+	for (i = 0; i <= PTE_PREFETCH_NUM; i++, spte++) {
+		if (i == PTE_PREFETCH_NUM ||
+		    is_shadow_present_pte(*spte) || spte == sptep) {
 			if (!start)
 				continue;
 			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
-- 
2.19.1.6.gb485710b

