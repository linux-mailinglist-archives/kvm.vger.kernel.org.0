Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46698654A4A
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiLWBA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 20:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbiLWA7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:59:48 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5B831373
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:29 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id o8-20020a6548c8000000b0047927da1501so1892354pgs.18
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Mjx7GRlicgajrB6SmeczbpFw70qPj26DS1mbjQ07FZc=;
        b=mRJ+7lpjW/92UAtWhU6FDkGto+uOUnmfSzy5jPfawwuU/F4nqZqRlRMCU74qEPj9Mb
         CdAaIXysmX7kk4CHGyfZxd5JQnG+ZCL24IJeY+z751dN9xS9z2fpULQeiKxEgoDCtOId
         TmBFxLNIjiP0AR2oqnH6WWuSs/9ijuJ8t+Qx2CBcvKEjJ3TsqJpIQjhj6uQjDbHEvMOd
         3YF9UZ1sB0jZijAgR6k9nUryyTWfEmarYoHND1SDv0JjOcBFOcDV/v48qhlbXnHvgIcL
         l59C9L5Nrp/Z9ySpcP8XnzBq9MXiXywcAXIdSM3MMeaTo1Lbw09pY3Z7FdZr4asQg5r9
         hbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mjx7GRlicgajrB6SmeczbpFw70qPj26DS1mbjQ07FZc=;
        b=Fo3yPW1/sLSjIw5PXNJrbczbyl1ptleHsv9fk+x4dJDYJ9G1G4zv/W5l2SSzIfkYrd
         7LNsQ6oQ+bpLyLNrQeq5B5sKDknKN7bNiCOo+M906IKollfEqknbfka7IdRUnEFysZFU
         LX0EWMg5t16ClGwlRizS8CFTtWPgV684IV73LhikDG1aZxn8M2FVNmnC10i2qpkq2HcW
         BRJNZEtLMY4Mb0gqFTqaEc0Gdvymi/Kx+i1SGD5cLc1SJjYVP/SjaeeVu9UnyIjDOK8i
         RKUU9KflnL2eRjAbx9Ar2So1D8HvvdaJgi21Ob2mtqjUK1YNS3UtCAY6s/nL61MptIBf
         g6bA==
X-Gm-Message-State: AFqh2kpSb2hGgXIe0uJDpCUqKCdEVXa42YIn1/rkFqWQZjfropn8/jRI
        14ICNSbyIA2EYRv4cY+6smNEyD71TO8=
X-Google-Smtp-Source: AMrXdXtXxdm8nZXuMMBo2QspLCSPRiBAN19+E0Wj2xhvcNkERfbAIsx/WwCVUN1WA4sKXACeZ4+eKJfad3s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc84:b0:191:2b76:49e8 with SMTP id
 bb4-20020a170902bc8400b001912b7649e8mr408691plb.46.1671757104914; Thu, 22 Dec
 2022 16:58:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:35 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-24-seanjc@google.com>
Subject: [PATCH 23/27] KVM: x86/mmu: Bug the VM if write-tracking is used but
 not enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

Bug the VM if something attempts to write-track a gfn, but write-tracking
isn't enabled.  The VM is doomed (and KVM has an egregious bug) if KVM or
KVMGT wants to shadow guest page tables but can't because write-tracking
isn't enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/page_track.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 209f6beba5ac..d4c3bd6642b3 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -89,7 +89,7 @@ void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
 			    srcu_read_lock_held(&kvm->srcu));
 
-	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
+	if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
 		return;
 
 	update_gfn_write_track(slot, gfn, 1);
@@ -121,7 +121,7 @@ void kvm_write_track_remove_gfn(struct kvm *kvm,
 	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
 			    srcu_read_lock_held(&kvm->srcu));
 
-	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
+	if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
 		return;
 
 	update_gfn_write_track(slot, gfn, -1);
-- 
2.39.0.314.g84b9a713c41-goog

