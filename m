Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C723344B4EF
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 22:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244327AbhKIV4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 16:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244233AbhKIV4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 16:56:01 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C16EC061766
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 13:53:14 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id x14-20020a63cc0e000000b002a5bc462947so249738pgf.20
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 13:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+orjKM59Ip1jg3YDIyso53FFr4R86deutg9aS1RmPgU=;
        b=OoPhJmTDncIYB5udY0KMuU/k/gZGETWsIa26KBZMW9/bcpA5X897kzrHCPRWTVyRuJ
         L0tKjpaYFpQjFVgwR85GA4+DcCNr643jeuHzVi9cgeYbc2eVUTReHdLQhhYt4OTBE3HL
         eu9LG2p1UhwaIgNMBZmowzdvSWvpo6MjmLXEpw9Cr8UH15R9CE91L30ZBXcgo55NsxL8
         7oDE/iixLxGHjcCKAGagpY99Hx/tQ4wtWcXGVNKUp6T/w39cOmwSrLiswVLEfalroDEZ
         dPIS5PAfca7G7Ef0kpKiAdKRc2qfNCgBCaiTrdH8heVeXOAnbVyK7sIEb0gqBukYkgwh
         HVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+orjKM59Ip1jg3YDIyso53FFr4R86deutg9aS1RmPgU=;
        b=OkpyOq70nubJ9j8nu+3wIpp+znTJKpKBQOieS/Ag6UUX7spesdq2mIwktEa7yzulZA
         lS2qQ8Xij6a5PIa8rPXSY04UlXDAY9ukIrnmbc0TFG8Fzx9dyEg80d0udRpUkeOaIR/v
         CdVPIEx3hJXDBNAuJf5HZfyWECagndiXPF9urgygqCpRsm1ziVyzAHvVCOz15xcBcZNY
         mn2ZyXBHqimb0wNdL7qp012msGiVQWP43SwEHUjvn3jfJ6gsYpQGM8DtEm28bUemy9gL
         AFiPFpyVnGsonzXwbOI+5IRiHQUXFKY4eAMJg3ivb3x/YLCrqj1cOwYl5DwoUWAeEgsd
         Xzug==
X-Gm-Message-State: AOAM5325u16YcqJBmMDHbDUZcjGRqdBGnu+o2x2ZX1rLxQ//vOrzatB9
        yyamKdNMWDg91wX67aLJPUlumRyszok=
X-Google-Smtp-Source: ABdhPJzJHyfzMV92VSzp7DtPIHOhADA+GIEVQO4/Wv8/arTXrYXbLFCY7EloFUKfE3GXC/TAPq+gPV3EqlE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:3306:0:b0:480:f89c:c251 with SMTP id
 z6-20020a623306000000b00480f89cc251mr11901402pfz.74.1636494794010; Tue, 09
 Nov 2021 13:53:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 21:50:56 +0000
In-Reply-To: <20211109215101.2211373-1-seanjc@google.com>
Message-Id: <20211109215101.2211373-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211109215101.2211373-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 1/6] KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has
 created vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject COPY_ENC_CONTEXT_FROM if the destination VM has created vCPUs.
KVM relies on SEV activation to occur before vCPUs are created, e.g. to
set VMCB flags and intercepts correctly.

Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
Cc: stable@vger.kernel.org
Cc: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Nathan Tempelman <natet@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e2769855e51..eeec499e4372 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1775,7 +1775,12 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	mutex_unlock(&source_kvm->lock);
 	mutex_lock(&kvm->lock);
 
-	if (sev_guest(kvm)) {
+	/*
+	 * Disallow out-of-band SEV/SEV-ES init if the target is already an
+	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
+	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
+	 */
+	if (sev_guest(kvm) || kvm->created_vcpus) {
 		ret = -EINVAL;
 		goto e_mirror_unlock;
 	}
-- 
2.34.0.rc0.344.g81b53c2807-goog

