Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995253257FF
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBYUvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbhBYUtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:49:46 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A755C0617A7
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:12 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id 4so1547477qtc.13
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JwxadR5cbtm2yzkFH/RHMCjjB7zf5B8aQ7otXkvJ48s=;
        b=C9QD1T5V1WJ4CTYWP1310gEZgpgR0plDlCVznZzCQy5Nm4/4Dow6tXbKlweqgXW3LE
         Q42BabssrlvmBtzoYJQOBJcLBEHfuicpKTT7ikL0TEVdRoTOLhlmzgM9Net7WJa+b6d5
         POmfeGzUSRdE6FLzdbYBVtXTLVcA5QZgkshb2EZhON9iET90LZDkH60qwwN6Un6C/ZQh
         GjgG9TpDFArxNuWo7HQnOb82iFECBJMvkELxHpk+ac/q0i5w+7JRAy1Wk8hV17ZtfKo9
         VQIgoalOK72b9SdUX2y2qVoT+JV57aR4//hjTVztiTVJyjMgxW9suV2mQlFci5CvxNbo
         h9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JwxadR5cbtm2yzkFH/RHMCjjB7zf5B8aQ7otXkvJ48s=;
        b=uTzw6XFoEtYC5S0sKKDmIsI9mptPrG901affSXBkoFFAfymDgc882ECJUwvj4XmKs5
         FQyosbR9y4hz4iJFuZVFgXKjEjjdLu/kDpXrEJFtz6DARuso7CSL+FyBhmYQLWHG6nqM
         1RKW7BMLMoL+lLce/Ahftzq7LaPYYmMS6wdipbTdxR+ifjxUfBPyQUY0UG78SPW6g2U+
         WYVjDuMRnrmbZtObaXq2yvc+FECJBGRt5wP5cDo/vlmFkYGxC2E5mJMDMTjhR49uR332
         fo1YOMtsRuv0uYRwHTd+P2Pn9OpHAXFOMKOanQhFGlGUzFZppUZ1kiurw7mowkwv1xZs
         wP7g==
X-Gm-Message-State: AOAM531BxF/KoLeDIdhNFWaoI30D+8NMn0RlNRfySSYoxaKYCBpQaCIm
        MJwasJ5CTDyqRAM9qpuzsb6FF+/2IKA=
X-Google-Smtp-Source: ABdhPJwfA7FGvLPKnHh7BCxREcyp8iIyRNEkE61CYXrM3B57S/ghI1+CHX4CA/vs+RwgvwpWvp0NF/dAoPA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1c45:: with SMTP id
 if5mr4682368qvb.9.1614286091253; Thu, 25 Feb 2021 12:48:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:30 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 05/24] KVM: x86/mmu: Retry page faults that hit an invalid memslot
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

Retry page faults (re-enter the guest) that hit an invalid memslot
instead of treating the memslot as not existing, i.e. handling the
page fault as an MMIO access.  When deleting a memslot, SPTEs aren't
zapped and the TLBs aren't flushed until after the memslot has been
marked invalid.

Handling the invalid slot as MMIO means there's a small window where a
page fault could replace a valid SPTE with an MMIO SPTE.  The legacy
MMU handles such a scenario cleanly, but the TDP MMU assumes such
behavior is impossible (see the BUG() in __handle_changed_spte()).
There's really no good reason why the legacy MMU should allow such a
scenario, and closing this hole allows for additional cleanups.

Fixes: 2f2fad0897cb ("kvm: x86/mmu: Add functions to handle changed TDP SPTEs")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 93b0285e8b38..9eb5ccb66e31 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3656,6 +3656,14 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
 
+	/*
+	 * Retry the page fault if the gfn hit a memslot that is being deleted
+	 * or moved.  This ensures any existing SPTEs for the old memslot will
+	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
+	 */
+	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
+		return true;
+
 	/* Don't expose private memslots to L2. */
 	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
 		*pfn = KVM_PFN_NOSLOT;
-- 
2.30.1.766.gb4fecdf3b7-goog

