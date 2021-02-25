Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D9F32580E
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBYUxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbhBYUuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:50:25 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDD0C061224
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:27 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id t5so5033166qti.5
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3dJX6PNMOpcnlHjtSKGQWdqsgIFYjgow6196OCl7MyI=;
        b=RY/+cgnBFr699vd/bgYh3VMSoW0aWmYd5U1FT3PNuuKefp5rnFrYcoUcX8rYTpRvhs
         glQbsL/36w91AWnajZorhypk/30W1X/Tkxb+ykpNSk7IqCRM9wCPbF3y7MgBoy/Usdri
         fHIQDGUfDRCskexycPUbHMo3WVZi80WW3Rn5RssXXP40un3H3H4L/WJ0PtH0jtlLvCmJ
         WAP8RbhUeRxlxI82KgYcqTludxwM7NoP2AvbLs71+PtABjc759aEWJjYAtINK0nZvQxB
         GynmqnhT1836myMc2SYzx+6hMr0btJXwnLl2xdl0JUfzxtib//nHn2yjUILucrvWi/fT
         jtkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3dJX6PNMOpcnlHjtSKGQWdqsgIFYjgow6196OCl7MyI=;
        b=EH93TAQzo5VcQi8omyxH+7W53CAHdVRYguYALlAPNHl46n8NB7zdMXM7lao1KAQLd9
         6Ntix+MWufLP3UsGggllf94l5a+EqBlFck9RmcGbvhSuRTB6cuZ0RZlG2VixbBezg1v+
         wKeOK6fd8QzTkvhHXdCgMiymI8AjAi62qiHCkKB/DFqT7cEpGkZ1RVuOqVWW/z3BDwar
         8+DsPFKVT66Fa3/OuboMfP66gLaNVoFINoaupWojdlaXc/H8XeMBLSGl5/dSJlPF50Iq
         hFbKzTOw8zllHQdb/eVY/sVwGrseZEYPojQ6bJUL2eYPVI1ybwGtvEEQ4wtiWu1YhJLZ
         V6RA==
X-Gm-Message-State: AOAM532yT31Lwyf4OQIV4xDa27MDEaVImlMp3EZqg9I71BMYtFisrUSk
        FW85Cxovcf7LdBGHdkE+z5xwHiVzt9w=
X-Google-Smtp-Source: ABdhPJzdjCcgPrgt//zVCx2hyGk4lfsR4fSPcWuIze0KimRoHEfUHafbuOkWChinNzu8YToJbTWFzAMttR4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a0c:85c2:: with SMTP id o60mr4568108qva.11.1614286107161;
 Thu, 25 Feb 2021 12:48:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:36 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 11/24] KVM: x86/mmu: Add module param to disable MMIO caching
 (for testing)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a module param to disable MMIO caching so that it's possible to test
the related flows without access to the necessary hardware.  Using shadow
paging with 64-bit KVM and 52 bits of physical address space must disable
MMIO caching as there are no reserved bits to be had.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b2379094a8c1..503dec3f8c7a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -17,6 +17,9 @@
 
 #include <asm/e820/api.h>
 
+static bool __read_mostly enable_mmio_caching = true;
+module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
+
 u64 __read_mostly shadow_nx_mask;
 u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 u64 __read_mostly shadow_user_mask;
@@ -251,6 +254,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 
+	if (!enable_mmio_caching)
+		mmio_value = 0;
+
 	/*
 	 * Disable MMIO caching if the MMIO value collides with the bits that
 	 * are used to hold the relocated GFN when the L1TF mitigation is
-- 
2.30.1.766.gb4fecdf3b7-goog

