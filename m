Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A4C325823
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhBYU4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbhBYUwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:54 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6172C0610CC
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:49:04 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id p27so5487296qkp.8
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l9F4DorkP8gKSgQry0nnCoDwWHQFJ/Yd6axivFAM3KI=;
        b=BXGXxUgQwzbVMrMVuXoL6Bp+6pkXFq5rQ7HKLURvABsuJOVvgcdCTRaHjGRq8tVrj7
         GOr+wqSc/eYIT8EltXKfXDeQyc/uVLVlDH/H/BpvBT7eZgxUSiCI2ZQhgMg0sTltcJPs
         7fwR8SgK8tUT9zG08ZUotGyxO6ac0acL8/4e77/odr2ucncR/3QwkGITyC1b4auIBz3n
         OqBkeMO8c5JsIh/UJiMp7NQJq0hd8eIcvhNVEYR0IdUp4DC2riVaJ9S3IaS54dqOON8E
         m2NT/ivmdMW1e5dLtYIN7xfhqpWkbGtlOy94Wy1F5eggDQxyKAfIvBCI9pjLZi8VWcWu
         WTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l9F4DorkP8gKSgQry0nnCoDwWHQFJ/Yd6axivFAM3KI=;
        b=rrLgkxVrMoeXHtQuv0iTCHgX2Fe/KUDdFDb4uCv0K7IU0RY6mg7VWEl73F+8VJjIVP
         RG6wTZv/I44McqwQhTh4F9/JRS98f7ncctMC8rM+Xfi0aMu3lCEgPv/RfDAv7FrBCzo9
         kKsDM45DzNamCksHJ3+o9BRW/2WBsdU3nciKuZj5x0RWIeMIKxKfEPhC1IduYISPE2e9
         vBYzcylDMBqLZFAfr/T2hPaZlOkDqogHFRMsjG8MEBDqAGsliJIoG5d6lcfLUiW85/6M
         v+VeRVK145NBJ0qtVCTNXPwJ8O3hPt+0mRyMbfIwoyYVz+W2y/y0jti+fmTyiw77Lrir
         XZxQ==
X-Gm-Message-State: AOAM532ejAjYxRJ3Ymz5+S6rfhwbUfHnzFMEMUKvywNVvANSi3LObEKn
        ZTm8D1sFw9FMczIeBvqMt2mNO9ySbwo=
X-Google-Smtp-Source: ABdhPJxZysNY09Fn0/MqcmMOKBvO+oahfT8mzibqA2JJ3M8rPKMWbd+I3ciJ3VpHGVUfIxoxY98OO/RZSQI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:ad4:59c7:: with SMTP id el7mr4534210qvb.16.1614286143847;
 Thu, 25 Feb 2021 12:49:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:49 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-25-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 24/24] KVM: x86/mmu: Dump reserved bits if they're detected on
 non-MMIO SPTE
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

Debugging unexpected reserved bit page faults sucks.  Dump the reserved
bits that (likely) caused the page fault to make debugging suck a little
less.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e636fcd529d2..dab0e950a54e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3555,11 +3555,12 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
 
 	if (reserved) {
-		pr_err("%s: detect reserved bits on spte, addr 0x%llx, dump hierarchy:\n",
+		pr_err("%s: reserved bits set on MMU-present spte, addr 0x%llx, hierarchy:\n",
 		       __func__, addr);
 		for (level = root; level >= leaf; level--)
-			pr_err("------ spte 0x%llx level %d.\n",
-			       sptes[level], level);
+			pr_err("------ spte = 0x%llx level = %d, rsvd bits = 0x%llx",
+			       sptes[level], level,
+			       rsvd_check->rsvd_bits_mask[(sptes[level] >> 7) & 1][level-1]);
 	}
 
 	return reserved;
-- 
2.30.1.766.gb4fecdf3b7-goog

