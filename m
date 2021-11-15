Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959B3452860
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244686AbhKPDTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbhKPDSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A3FC03AA07
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pg9-20020a17090b1e0900b001a689204b52so378113pjb.0
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Eou8FVkVRfjkrBKWxyUmSpsbt55EFqh+Bt08zRm2Nu4=;
        b=Kp6wEABwVLjiNcfFda7/xbF7oFTu5ebXV5fAdQXWlwtsWLAL3JoTKS49Kp711b6Lv+
         Rz7X6n19co0IA9785SV/PbRsr882CNMdjUIBdoH+UVbjd8R/JQHcTxh0JCe3kA13V5wi
         QmNxwgUWaO0g5jrJ0SboF6QCeatudbZw6gyx0miSWKQTaytyNwHV+uRUddy6wDi1u9C1
         2l7i2AyBni1r8U5rkdTJW41ZLF+M7GRc0f1PbZTpdgh4+SJGoJjW/xpa0Okt5QI4FR0Y
         E4tMN+iZyYHa9hKAz3bI+N5qnhGg0KdTy45o1e3XMp13edLbTjVXovZX1oZBrM3fwvym
         EFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Eou8FVkVRfjkrBKWxyUmSpsbt55EFqh+Bt08zRm2Nu4=;
        b=XsatMaru+oOcKZs0XbiF+bViqA0TnD7nWtBFJUP7lf/T3rfEUv1SQzY8reFW1PO/hW
         u6a7CbeK4SDkg12/ZCF2axQcYRLUroawtc7FrPPJygoDCBC6U7eFttFUanH8vvwr4PXr
         ebrrEpzXDu68pMrM0NSUEbpTujAki3hNq5eCcWZEs783AAj3tycJt5fG48j0Sbr4Rp5U
         clevKfgdC2T+yaYlnpmZtFih+j7QDbvh1xNP2cTJitnlyte9aNbwTX4xbCM+v5GmSeoH
         RMJzyY/og1AAEschLkrFSrXhsV9GPoHXyIUVdQfXK5rCqyCDTOYSF4GMcMb3ESaEpArx
         Hrzg==
X-Gm-Message-State: AOAM532tV7Kf1RP4Rj7nRe4395tAJ1tZo6K6hfd4W8uqFDxucSYCRiE8
        GgNi/mRlVKrotZ2axLDvstW1+q1Qote+
X-Google-Smtp-Source: ABdhPJxNckKj+qaFC4ScHZjUXYA8ufJdstZxTBvxY/76m/ltYcoxzqKLcKP6l75EiC/6sTO60ZflB4iWFP2A
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:90b:3ec2:: with SMTP id
 rm2mr69184267pjb.1.1637019975780; Mon, 15 Nov 2021 15:46:15 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:45:53 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-6-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 05/15] KVM: x86/mmu: Remove need for a vcpu from kvm_slot_page_track_is_active
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_slot_page_track_is_active only uses its vCPU argument to get a
pointer to the assoicated struct kvm, so just pass in the struct KVM to
remove the need for a vCPU pointer.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/mmu.c                | 4 ++--
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 9d4a3b1b25b9..e99a30a4d38b 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -63,7 +63,7 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
 				     enum kvm_page_track_mode mode);
-bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
+bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ada6dee920a..7d0da79668c0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2587,7 +2587,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(vcpu, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
 	/*
@@ -3884,7 +3884,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index cc4eb5b7fb76..35c221d5f6ce 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -173,7 +173,7 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 /*
  * check if the corresponding access on the specified guest page is tracked.
  */
-bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
+bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode)
 {
@@ -186,7 +186,7 @@ bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (mode == KVM_PAGE_TRACK_WRITE &&
-	    !kvm_page_track_write_tracking_enabled(vcpu->kvm))
+	    !kvm_page_track_write_tracking_enabled(kvm))
 		return false;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-- 
2.34.0.rc1.387.gb447b232ab-goog

