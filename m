Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D0544B221
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 18:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbhKIRr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 12:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbhKIRrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 12:47:24 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C7EC061764
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 09:44:38 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e10-20020a17090301ca00b00141fbe2569dso9382837plh.14
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 09:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3dSOMYowFmLGHL/9NT4zbRgDO3sEDt3CzFQDAO9NWgk=;
        b=SObRjv/OhHv0ur9cwKHlMrW4qPTrppoQnwfJzoOSb+z5vBnzFs24Qo4WHK0N5B/D1f
         0jr+e59SrrS2GpYHgQr2UhsUXkVtUD3fUNKKtStgYmE62BgETzYJVZgn+nGM4EUQW5Tk
         nT7w9cKsVRwkxV3vVhtBYa65QUs+uUE9FQyWeS5Ru5e/l1GNtMoc8NnU1xbOlghpw5Vp
         yQ9GzjlmSJJRflFIDh3uJFls5gFN5pGMZMxXzhtvTwSBQfKmi0+21K6Dg22NHZtQ4epd
         saQKLParOtNg87FdMLaCP/zT7D/LgcCAKJNgI76AJ+1sIX5O97ZldhuodjRIkw1VMQBV
         G2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3dSOMYowFmLGHL/9NT4zbRgDO3sEDt3CzFQDAO9NWgk=;
        b=fIQZ5PZjk2D/DJ0Ymsuc6iuhoqK7Nihesmr0fuITNOGDhKE9JTqUeWeWAIJYM7dE+j
         tE/d+Cy/wMCpgnRkPotQZu1bg8vIgU7k5JK61Jl++dhdYtLylkQwyQiy8He4+9ThgXGq
         RDpzK0m3VUTzO/mSz0m1lANLgZC3E2mJmd3bKRwMgV6vv9d9JcQ/pKh5gjbYVFQoZRqs
         cH+3Gn13UB9sh4Zrc7XTZERgPcJrXS01dAu8wSA0deKwTlBHTSFZnypkPe794phKRYx8
         kBut19Kq7O9ELFTAd4ZmoojWKa4B01tX58pgPczQVjNY14Me6+IuxrTY/r91jikxbns7
         lNrQ==
X-Gm-Message-State: AOAM533Zr6Yau7dg3Kds3rFi96tpAirqooT8zI1VfQHNPPz6EP6m6tag
        YUW9nWGCF/cs9b1Rr8Jkfysf/RciqaFJ
X-Google-Smtp-Source: ABdhPJyE5IYejljYQWvewvDju+mOIcTWCplOjKcPhZmhCnDPFJOZ2vkepEEZAEdcspVGrpHnJGbjN1oo5GIK
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a17:902:c407:b0:142:28fe:668e with SMTP id
 k7-20020a170902c40700b0014228fe668emr8947697plk.31.1636479877545; Tue, 09 Nov
 2021 09:44:37 -0800 (PST)
Date:   Tue,  9 Nov 2021 17:44:26 +0000
In-Reply-To: <20211109174426.2350547-1-vipinsh@google.com>
Message-Id: <20211109174426.2350547-3-vipinsh@google.com>
Mime-Version: 1.0
References: <20211109174426.2350547-1-vipinsh@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 2/2] KVM: Move INVPCID type check from vmx and svm to the
 common kvm_handle_invpcid()
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle #GP on INVPCID due to an invalid type in the common switch
statement instead of relying on the callers (VMX and SVM) to manually
validate the type.

Unlike INVVPID and INVEPT, INVPCID is not explicitly documented to check
the type before reading the operand from memory, so deferring the
type validity check until after that point is architecturally allowed.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 -----
 arch/x86/kvm/vmx/vmx.c | 5 -----
 arch/x86/kvm/x86.c     | 3 ++-
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..ccbf96876ec6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3119,11 +3119,6 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
 	type = svm->vmcb->control.exit_info_2;
 	gva = svm->vmcb->control.exit_info_1;
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
 	return kvm_handle_invpcid(vcpu, type, gva);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e41d207e3298..a3bb9854f4d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5505,11 +5505,6 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
 	type = kvm_register_read(vcpu, gpr_index);
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
 	 */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..134585027e92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12443,7 +12443,8 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:
-		BUG(); /* We have already checked above that type <= 3 */
+		kvm_inject_gp(vcpu, 0);
+		return 1;
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
-- 
2.34.0.rc0.344.g81b53c2807-goog

