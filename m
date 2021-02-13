Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BC231A90D
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhBMAxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhBMAw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:28 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07CCC06121C
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u1so1523879ybu.14
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qgHHy11/Gmg7Kjm2oa98mzp3zSXXJwJ1MHurK3QurWI=;
        b=JzER6/A4WcR1Yxht+KX+/Ie2lNSUt4QDexn+mTaBXkA3mUuSs4eh+qma7hs8FCrhX9
         a9I98dy32xEYCSrwTkDbadFnZmBsAvDRXPreGzmTPDzI+orEI3qKKMoQCqZrjCZYaFzQ
         ZX9qU1Qc3D3y3vWrxxbTo0GMSfTBQDPJkm3Xg4rrVmifiiu3rpbeYzAGZfUx/wZFYAOt
         pGsIfZQFJe+yFQzjKJCfQNMnBMNNVaxP/iY4lWZNItq6y10vYPBYxA2U28WcfVOnchbv
         hCL6a1w9X8EeRIMsP5yVhf6s+o0YxVuA3x45+RgbRo2wmMaETBELL+eM/OJB0ixMaYw5
         CPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qgHHy11/Gmg7Kjm2oa98mzp3zSXXJwJ1MHurK3QurWI=;
        b=BPijwuW2mJtvRoZue42IEH3xezpTnr6AHScr5dIkE9WBQXEZ4JD/mlQAUpZWbhZwf3
         t3s9Jt7UXmVHvA0ugo3tmWlkMUESOD369B9XFkq0giiAYEZlM65HmMdD5Cv31FhP5VJh
         8Co8bgfC8Bdq0WpzEVNtTGx42erARAudsV0lTWtGE32Z3V3vifW3c/T/H6+ZCs4+0sB8
         IVavyznDEpOIFhhwUyyKXL98a4gywzSNK74GdJ+iz6rX5OL3zNzHyizAnvxvCblD2B/t
         tdMkvUjorKKpad9L459LBgLXPUzSgZUTncDMFDLV3SAGQdNkMZ7aKDgNRnOWZnGLxLYN
         ibJw==
X-Gm-Message-State: AOAM531DSirDbfLIowiniEWz7osqXVmWMxEo+lTVBL2H6kJqB3mpHKId
        ZFc4c851dtal6B3TgdiF7edflQQ7XkI=
X-Google-Smtp-Source: ABdhPJz1CJdQJZRt8FQ7rL9sa+SP7EuA2BCPuYyVPIm2ReE/REHoc291v+SKPS1vg/Ta3l+cxKlaFs0Ntx4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1d2:: with SMTP id
 u18mr7581074ybh.103.1613177437917; Fri, 12 Feb 2021 16:50:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:08 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 07/14] KVM: x86/mmu: Expand on the comment in kvm_vcpu_ad_need_write_protect()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand the comment about need to use write-protection for nested EPT
when PML is enabled to clarify that the tagging is a nop when PML is
_not_ enabled.  Without the clarification, omitting the PML check looks
wrong at first^Wfifth glance.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0b55aa561ec8..72b0928f2b2d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -84,7 +84,10 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	 * When using the EPT page-modification log, the GPAs in the log
 	 * would come from L2 rather than L1.  Therefore, we need to rely
 	 * on write protection to record dirty pages.  This also bypasses
-	 * PML, since writes now result in a vmexit.
+	 * PML, since writes now result in a vmexit.  Note, this helper will
+	 * tag SPTEs as needing write-protection even if PML is disabled or
+	 * unsupported, but that's ok because the tag is consumed if and only
+	 * if PML is enabled.  Omit the PML check to save a few uops.
 	 */
 	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
 }
-- 
2.30.0.478.g8a0d178c01-goog

