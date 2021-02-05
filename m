Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F322E31020D
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhBEBDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbhBEA7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:59:19 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FD8C06121C
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:58:06 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id e5so4349999qkn.2
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=FqLQqjDA5gUhIpo1ZH8vDKgFwh0BbtlwwHHYsQmx4E0=;
        b=Qbmaw8QsZ8T3vCRuI/IJGSGom3HV8px2TjIjOoxU0v7UZjfOhzP7zNI1YecuK0yA7H
         FK865RwHnb95k98R/vX8whPK611sCcQWqywhjZHyXC4VPtMNaQUlQC+w2oOLdbkcail7
         YGrg+NxETsy67gle+/1LOh1UYwI4XxW5PR/EdgJDMlH5AOaed/tND1hiCcDz01TSa+go
         lS8yFCLVncq4Ib5ZMRgaY7Eam6zsr4kgIPOKPc3CM4Y7KtpQtBRbcRhwS7DRhnGq4j5+
         uJQdOpClLXEEpjFlDTVNoATIQ6MAJH8+N6OhRrw9Eb8p9+MEdgH7pklqFJKcD2l0TRS9
         vhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=FqLQqjDA5gUhIpo1ZH8vDKgFwh0BbtlwwHHYsQmx4E0=;
        b=iCmT4BMeMbQIvrL8uZnRDeIPCKqqUBMOax1UMzHTXpSkmXtfcp1sH4A53Y4RyNlYf4
         gCWyegBxZ5zRd/MwgRYWbX65rwOkLqYJCgXWmdaQxGODrDKYkDMlEbT6Yma0UmmHamd/
         /UOflRMMH3dvrmHs4KXnuF8Jg3d6rfZjjZXp1Adg7p0N0W0FFRzZn06A/bcC71VJh6DN
         cLQba54HeXsyvV5omh7XPuKNUU8hvZ2IcS/iR9dqMUmGbmvT3kPvgIDjdTaYmbLRUFkt
         VqZzVrrmDMDP3QS3HgGt9/9Auwb0szWsJl1h076J1v8WRCnuaKGxi/wWj9brqBQMiqQW
         Yv3A==
X-Gm-Message-State: AOAM5329hStkWi7Hiro5EbPbvlHv9pNkvfEKAWBazaPVZBNufeplJ2YX
        Lg+33YQJkkdgsLXQtjDXSs8ey0xZNbg=
X-Google-Smtp-Source: ABdhPJygwq0MkjKN0Pz8vfD+uT8OsYDBk2TaftFFfA5GLfsrbHN5EWkzznw3wroXxhmAvl9iEjWa+W9yuZU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a05:6214:592:: with SMTP id
 bx18mr2025281qvb.32.1612486685919; Thu, 04 Feb 2021 16:58:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 16:57:45 -0800
In-Reply-To: <20210205005750.3841462-1-seanjc@google.com>
Message-Id: <20210205005750.3841462-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210205005750.3841462-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 4/9] KVM: nSVM: Add VMLOAD/VMSAVE helper to deduplicate code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add another helper layer for VMLOAD+VMSAVE, the code is identical except
for the one line that determines which VMCB is the source and which is
the destination.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 79 ++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0139cb259093..d8c3bb33e59c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2131,58 +2131,45 @@ static int vmmcall_interception(struct kvm_vcpu *vcpu)
 	return kvm_emulate_hypercall(vcpu);
 }
 
+static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb12;
+	struct kvm_host_map map;
+	int ret;
+
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
+	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	if (ret) {
+		if (ret == -EINVAL)
+			kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	vmcb12 = map.hva;
+
+	ret = kvm_skip_emulated_instruction(vcpu);
+
+	if (vmload)
+		nested_svm_vmloadsave(vmcb12, svm->vmcb);
+	else
+		nested_svm_vmloadsave(svm->vmcb, vmcb12);
+
+	kvm_vcpu_unmap(vcpu, &map, true);
+
+	return ret;
+}
+
 static int vmload_interception(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
-	int ret;
-
-	if (nested_svm_check_permissions(vcpu))
-		return 1;
-
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
-	if (ret) {
-		if (ret == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	vmcb12 = map.hva;
-
-	ret = kvm_skip_emulated_instruction(vcpu);
-
-	nested_svm_vmloadsave(vmcb12, svm->vmcb);
-	kvm_vcpu_unmap(vcpu, &map, true);
-
-	return ret;
+	return vmload_vmsave_interception(vcpu, true);
 }
 
 static int vmsave_interception(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
-	int ret;
-
-	if (nested_svm_check_permissions(vcpu))
-		return 1;
-
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
-	if (ret) {
-		if (ret == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	vmcb12 = map.hva;
-
-	ret = kvm_skip_emulated_instruction(vcpu);
-
-	nested_svm_vmloadsave(svm->vmcb, vmcb12);
-	kvm_vcpu_unmap(vcpu, &map, true);
-
-	return ret;
+	return vmload_vmsave_interception(vcpu, false);
 }
 
 static int vmrun_interception(struct kvm_vcpu *vcpu)
-- 
2.30.0.365.g02bc693789-goog

