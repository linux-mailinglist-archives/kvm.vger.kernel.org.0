Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C9249B11C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbiAYKCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiAYJ7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:30 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A451C061751;
        Tue, 25 Jan 2022 01:59:30 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id k17so1215266plk.0;
        Tue, 25 Jan 2022 01:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYvl3LXfq2Z7qoIfNjZ5GsgYEqtM3wk9CuvlXSIi+kA=;
        b=Wlj/sKZXZpqy/o1WYQu+xr6CjK2FGzWSNz5NdVM4P9zzuRB0zxYaBgxFZONutu7xka
         EmdMealNBliAlnARYU4X5e6CkhJYajhepYqoI/N0tdLPXuG81BbVram+8k1pL562Bw84
         /pfACoBuVGEaOyOjBS/beEz03XCBvTQyz3hfFvn64B/FazsZMojNICTOrYx5mO/ms9TE
         1Rs7hASxXb9SIZ7nOcfUbIHyn30T1nVeX3J0OEbRER3UKskVCVh4giP6/CFH8yvW2Tjw
         8GDcaO4i1nIIK0NXIb4rp9SOBIZ+J5Q1BEc2TnD7wOTzZ+cHs36X9AURRpOy7TQp3XTH
         sFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYvl3LXfq2Z7qoIfNjZ5GsgYEqtM3wk9CuvlXSIi+kA=;
        b=WwFSA6+RsA6RSnKIkgnaX6VhNF4aOmYDx0053rM7TFCm34JTR4kC//eVBt9hFkhW7A
         XESk8+HyxGvLaPrAlxuN9qvpAYkXByioxVx8NcACAUMonuP/CbEX/k0bdtIYC3TEGE8+
         dszG8wup8C+dP8iSFiWD8q9IiDqs99F2G2u/Z3QZginczrYH/ssn+VE/uL791eapksKZ
         2r5TDvLyHDpgzcQNDYYPyDN6ZoibGUc3SpDjqTQD2OV4DPHs847xdTTaer0YtSDKOPIF
         FOgtmo3JpH+FL0f7QUiWoiCIx+M4diXE+MZ33qEBbU2XphqKECl2agnJZGVRNz1h96gH
         yB3g==
X-Gm-Message-State: AOAM5339MvZeS5uag/5qp1NsVaWrvOVN+GRWmocZQ6D5F6csEXzsgeco
        zdVNJo4dfpP2glTwHB9zu6M=
X-Google-Smtp-Source: ABdhPJwu6Vdz0Bw1KltVyRagJh0tG49h6WEICpjQ7NHc6M397SQTTLplnau8Wgr6EO6lb4bOPLePwg==
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr2716352pjb.245.1643104769736;
        Tue, 25 Jan 2022 01:59:29 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:29 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/19] KVM: x86/mmu_audit: Remove unused "level" of audit_spte_after_sync()
Date:   Tue, 25 Jan 2022 17:58:55 +0800
Message-Id: <20220125095909.38122-6-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "int level" parameter of audit_spte_after_sync() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/mmu/mmu_audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index 9e7dcf999f08..f31fdb874f1f 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -163,7 +163,7 @@ static void audit_sptes_have_rmaps(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 		inspect_spte_has_rmap(vcpu->kvm, sptep);
 }
 
-static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep, int level)
+static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
 
@@ -225,7 +225,7 @@ static void audit_spte(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
 	audit_sptes_have_rmaps(vcpu, sptep, level);
 	audit_mappings(vcpu, sptep, level);
-	audit_spte_after_sync(vcpu, sptep, level);
+	audit_spte_after_sync(vcpu, sptep);
 }
 
 static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
-- 
2.33.1

