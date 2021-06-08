Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38E239F8AB
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhFHOOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:47 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:43741 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhFHOOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:46 -0400
Received: by mail-qv1-f73.google.com with SMTP id br4-20020ad446a40000b029021addf7b587so15580887qvb.10
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OBCO8s7Q80TfIlYuHTY4iy7nv5Rn/TiuCTrWSGUfF4U=;
        b=MoN4dps2ZTiPTKGBh1DVK9lwFJTRIyDyKRLCpLXV0gGTuXNVM5oXgyybTxV78acvH9
         fmFH2/TjUq75AWlp90FL2RzjzX9DfTOaGv2hP4i8uDJkHZYYh77M36HhqKThDgAQZ2no
         BUvyK8pOBzafiWSLbVFaEOU7hgqrIti+8IY4k2O2OYD//GtCIV1N7lAPk3t7vxb4of3i
         /YgIbP82T1qX3gK2BySKmqvaFjzvirQXKrTxDrA1lmvzTL75VTaw/2y8GmIwIeYU65wZ
         /mv0qdGNjRaNHYaY3OaHbtt0bsiGXJSLGnhG31ewUUN5eppwZQZlHWfTCT7rHFB+vGY1
         Y3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OBCO8s7Q80TfIlYuHTY4iy7nv5Rn/TiuCTrWSGUfF4U=;
        b=I090PlMsx9z5xurOLmMu8xf8iIcSb6NtAQJHd+3Kyd87DdbMNb6ZRzCAF+R55ENm+a
         QHJv6ySzR4fgzeLL/OrWtlR9oGyqoRLnIONL3KVgRh2crgrZ5oz2TXGl4k0CW81IYeEo
         VVc/riIZr+GAKp/TrrUIl0vOfhl2Zt8FAZtM558U+MaYn3mFv+fCycJnXALT5YgcOYAz
         niyoga4AAhe5AqzznYPZWfl9ecb3gL3FCz5pyKFPMtd3rHW8XOwJmzYGWb/4ivmznZ/T
         gkbYkKTG5bO3sMjiLWdyUykNCcTwdDZ1QuvN0fAOP09ItNX2+OTtilNvxLmTeZngXgqX
         8n6g==
X-Gm-Message-State: AOAM533qVCdc12sIcYU5n6BwbG18P0xa/W0DsiOXAQAC800bomIxr6Ws
        N6DdZsINwhAvft5eKjgpZI0N7pPPeQ==
X-Google-Smtp-Source: ABdhPJxpGX73Z52hJxsj2Po6OlxesU18A3epNjEVGsZ9aSHXe5Ja52uB1RBv+GOJBxo8uI4KoiZL7yHnUA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:fa4a:: with SMTP id k10mr203538qvo.18.1623161513492;
 Tue, 08 Jun 2021 07:11:53 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:33 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-6-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 05/13] KVM: arm64: Restore mdcr_el2 from vcpu
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On deactivating traps, restore the value of mdcr_el2 from the
vcpu context, rather than directly reading the hardware register.
Currently, the two values are the same, i.e., the hardware
register and the vcpu one. A future patch will be changing the
value of mdcr_el2 on activating traps, and this ensures that its
value will be restored.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..430b5bae8761 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -73,7 +73,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

