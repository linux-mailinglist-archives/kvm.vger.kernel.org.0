Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82311325B1E
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 02:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhBZBFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 20:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhBZBFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 20:05:06 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170ADC061797
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:47 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id r1so5453262qtu.9
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=e6eBX5arsmuvKaEXCcMohgv1CZ2IbMRSR/jmdxJbsBs=;
        b=Y/DgjEw5meqAmc3rYmAoRFfyLa9ujttNoYX0gjpaDAOvdALuUc3aWqHBmi7WMr57Ka
         KSGo3dC2CNtKbk2fNeH6tdeVKf7ZT+tI9Fr6r+0kn6EG+H/BGiHXgOgBh4OsaDt2zNzn
         Y6IwwKEVksZET6NDCsWSKe84B9xWOI0Xm0zICDOE5U/eiH09luAf+xPlj4UAHP2WW5DZ
         yZ2ysR8BZj2EgY/1nhU8akd6gSYn+/jF3VXwmg1GeVOGgrg5L4cEPQ+OnOmtytFU759Z
         e7af6XNiMkYjuqqlzrwrgaLOG8WCKQHG6hZ+lSWO0md/Y30u/OTQaASPZjgoFhT5wCFN
         SSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=e6eBX5arsmuvKaEXCcMohgv1CZ2IbMRSR/jmdxJbsBs=;
        b=QoVnl418L6/8CclzpCTvPuUW5IpV3/jt83GipnjfFEbQPoGNHliefcL7bgC7Qljd99
         PL8tHqi7K60i9BnObqUSO446u/416h8JwTnyBVAlM/0QxOVxyQ8TX9zxVUhMQGU2XmY6
         xpVHCtHHTPb96zm2bIYnXR4fxsF2bkxwpsp9f302ncV/4HRfJm1LYdUMarlcb3fyMYdH
         bC2ikySKopNqFO96ZpOyLIGsHyYKiHe0dFMzp8tUtipOlZHwkpa1HOiO+LrcAH+bTSsr
         2r5TOaYNt6HNIdWUdqkgxA8cvAt1urAkypsPFcGdUKGN2fvSEfgnunvVwDCBgfwONeEO
         CXEw==
X-Gm-Message-State: AOAM530Zn5zG/Kn4NUzEHSBsxKm0Tw6BdaKFiLrYulHsB4om6nACq9hf
        bmvX56ppfFrbAWrw1oNx93CmvoW7Pw4=
X-Google-Smtp-Source: ABdhPJwP4vEFvry4fCj958VczSglgLQSQer805zjAzOvhXuyKzXxpumXWcVQucW1d65igOwn1MFganW1ets=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2402:: with SMTP id
 fv2mr417147qvb.49.1614301426291; Thu, 25 Feb 2021 17:03:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 17:03:29 -0800
In-Reply-To: <20210226010329.1766033-1-seanjc@google.com>
Message-Id: <20210226010329.1766033-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210226010329.1766033-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 5/5] KVM: x86/mmu: Add convenience wrapper for acting on
 single hva in TDP MMU
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

Add a TDP MMU helper to handle a single HVA hook, the name is a nice
reminder that the flow in question is operating on a single HVA.

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b6f829b58e67..c0c09ec07c53 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -922,6 +922,14 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 	return ret;
 }
 
+static __always_inline int kvm_tdp_mmu_handle_hva(struct kvm *kvm,
+						  unsigned long addr,
+						  unsigned long data,
+						  tdp_handler_t handler)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, addr, addr + 1, data, handler);
+}
+
 static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     struct kvm_mmu_page *root, gfn_t start,
@@ -1009,8 +1017,7 @@ static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
-					    test_age_gfn);
+	return kvm_tdp_mmu_handle_hva(kvm, hva, 0, test_age_gfn);
 }
 
 /*
@@ -1071,9 +1078,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
 			     pte_t *host_ptep)
 {
-	return kvm_tdp_mmu_handle_hva_range(kvm, address, address + 1,
-					    (unsigned long)host_ptep,
-					    set_tdp_spte);
+	return kvm_tdp_mmu_handle_hva(kvm, address, (unsigned long)host_ptep,
+				      set_tdp_spte);
 }
 
 /*
-- 
2.30.1.766.gb4fecdf3b7-goog

