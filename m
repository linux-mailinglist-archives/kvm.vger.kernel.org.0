Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA3C3B0C49
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhFVSFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhFVSEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:04:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8749CC0698CC
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:33 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id x13-20020a0cfe0d0000b0290264540cb5d3so2302980qvr.17
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Xji9fO4ehtc0Wp4cFa9JaLWH4nQL37UEYpVVFmvSfJU=;
        b=AxJMpsex3fYOX1nMA8b9tdJxRYNwNCcSCTuNbsqSOTVJSpkkmbua2i2Dxl0Eb74I8L
         sarHxA6nG7prRgVLBMDnQAkdj8LGYGKA8tFdp3ywyK0afvGy7fjTCfE6vku7XB4EiJmk
         YymVMUay9N+/kC1Rtvo8jPSVi/B36ZhXOQpCAiL/bWPit5WLC0WUc08uYt2NydVTwL2Z
         CMFvbcHqVItyfXsSUZKPtuPRxPMl2tkfh6ikJk/Mgqyug8JrL+pftYHj0iqRbh3AtPIl
         nabJanoremtM2SsdrJqJYaSidrEOaEoJgbW3Rv25T9FnH9ydD1gLFq5MmYiNN/NKi8Kx
         TOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Xji9fO4ehtc0Wp4cFa9JaLWH4nQL37UEYpVVFmvSfJU=;
        b=ZS9zDdwDEvmvlN8EAJbjkig13p/MnbviI5RnQn0Y6UqSo6V/uP2lrTdcH7qGTg1m0T
         cO7cu7Y6GhrEzZzGoViTFOt5DeTMODHfx/e6uy2HU5Gb2bfwA6zCjXLtLtOMK4/gNgOR
         QgW8/0nqdLdLtglhKAAQ7SZT9tXQ+WaIad+qkX2da7jd/a322Jc1StANEzxhPXTgTtB6
         22L2CI/J6/0NM9qrWzmsYluaoodE+i80qWslmNaQOWm3CtoabGSk9iEe1Vn+aayCUhQB
         RFejZmxAmVHEmS5jdtjr2v1bTigauV1iG7VY9wU7u/lr55IK3/tD5CRbSxy1kLiaIDgf
         sjcQ==
X-Gm-Message-State: AOAM533DrzF9IoitrY4vSeFKh3H9a6Q8Z+6CKjnz/lRx4Y7YpvNPrhCy
        PFL0j0JY0wsGZX3SvFoUmvbjcT1Gogw=
X-Google-Smtp-Source: ABdhPJxQzACrK0zNjJinF7ycCFJ7NecdMn71Qkrrv2vbBGO8p+CehT7DcHTwOV/qi8H/R7/5hy0T/fXe/R8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2c5:: with SMTP id
 g5mr1645qvu.4.1624384772667; Tue, 22 Jun 2021 10:59:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:27 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-43-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 42/54] KVM: x86/mmu: Don't update nested guest's paging
 bitmasks if CR0.PG=0
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't bother updating the bitmasks and last-leaf information if paging is
disabled as the metadata will never be used.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52311c2efd5d..30eb1364fc20 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4646,12 +4646,12 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = paging32_gva_to_gpa;
 	}
 
-	if (is_cr0_pg(context))
+	if (is_cr0_pg(context)) {
 		reset_rsvds_bits_mask(vcpu, context);
-
-	update_permission_bitmask(context, false);
-	update_pkru_bitmask(context);
-	update_last_nonleaf_level(context);
+		update_permission_bitmask(context, false);
+		update_pkru_bitmask(context);
+		update_last_nonleaf_level(context);
+	}
 	reset_tdp_shadow_zero_bits_mask(vcpu, context);
 }
 
@@ -4899,12 +4899,12 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	else
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
 
-	if (is_cr0_pg(g_context))
+	if (is_cr0_pg(g_context)) {
 		reset_rsvds_bits_mask(vcpu, g_context);
-
-	update_permission_bitmask(g_context, false);
-	update_pkru_bitmask(g_context);
-	update_last_nonleaf_level(g_context);
+		update_permission_bitmask(g_context, false);
+		update_pkru_bitmask(g_context);
+		update_last_nonleaf_level(g_context);
+	}
 }
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
-- 
2.32.0.288.g62a8d224e6-goog

