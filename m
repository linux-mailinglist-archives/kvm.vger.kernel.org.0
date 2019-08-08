Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF5286816
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404438AbfHHRbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:31:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35529 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404424AbfHHRbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:31:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so3217396wmg.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TTZm60GAsSP4uZ7ke7WjjVtBxVOkdxgjVOUbmfjlSFM=;
        b=P9HSDiC3JoF24U+k5fy5vaMCD0prcMr5rEVDXi6n43J7tG66c9d+H56tDoie2EiqZf
         JvAV8QtI+AiyBb4nrQr7Ir6nGYKP8qaGPKS8WfoMtseyhdHgdsq248ZZR4P4ds+UnSFN
         VVqMO6LxSw9QiFPZkE7Y034MW29rJOFXtFbsJglEE6d8rLNhb6HI14uBoOEq5cHmOsMe
         8J8lOfc47evnM71MK9P1bDJ5fA0/t9LMaR/ERx1+EfUd30Xlr/GSWqr9zl7kbvsntfNS
         g3ri+DLEU49HW2KgxhhZMY/siqstQ8e0buzeos/B4I1mL/2/340oRh27D5UaEUtPToYH
         DjQQ==
X-Gm-Message-State: APjAAAXcD7WBmLntVHRoze6gQeS8KXLvNhCN1CYuipbgGuQE8Qv+QRMB
        Hnlxe7OeJuOAyt5yTx/lGhLCZPktvew=
X-Google-Smtp-Source: APXvYqw/0dqnfvUwk64IA5doLWsFAskTaRC0hLIdWmbQw5k+mt5FEgsb9eej1mt7vLafyfq5Guz+Nw==
X-Received: by 2002:a1c:8185:: with SMTP id c127mr5653513wmd.126.1565285466244;
        Thu, 08 Aug 2019 10:31:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.31.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:31:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 7/7] x86: KVM: svm: eliminate hardcoded RIP advancement from vmrun_interception()
Date:   Thu,  8 Aug 2019 19:30:51 +0200
Message-Id: <20190808173051.6359-8-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808173051.6359-1-vkuznets@redhat.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like we do with other intercepts, in vmrun_interception() we should be
doing kvm_skip_emulated_instruction() and not just RIP += 3. Also, it is
wrong to increment RIP before nested_svm_vmrun() as it can result in
kvm_inject_gp().

We can't call kvm_skip_emulated_instruction() after nested_svm_vmrun() so
move it inside. To preserve the return value from it nested_svm_vmrun()
needs to start returning an int.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 43bc4a5e4948..6c4046eb26b3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3586,9 +3586,9 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	mark_all_dirty(svm->vmcb);
 }
 
-static bool nested_svm_vmrun(struct vcpu_svm *svm)
+static int nested_svm_vmrun(struct vcpu_svm *svm)
 {
-	int rc;
+	int rc, ret;
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
@@ -3598,12 +3598,15 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	vmcb_gpa = svm->vmcb->save.rax;
 
 	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
-		return false;
+	if (rc == -EINVAL) {
+		kvm_inject_gp(&svm->vcpu, 0);
+		return 1;
 	}
 
+	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+	if (rc)
+		return ret;
+
 	nested_vmcb = map.hva;
 
 	if (!nested_vmcb_checks(nested_vmcb)) {
@@ -3614,7 +3617,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
-		return false;
+		return ret;
 	}
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
@@ -3667,7 +3670,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_svm_vmexit(svm);
 	}
 
-	return true;
+	return ret;
 }
 
 static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
@@ -3743,13 +3746,7 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	/* Save rip after vmrun instruction */
-	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
-
-	if (!nested_svm_vmrun(svm))
-		return 1;
-
-	return 1;
+	return nested_svm_vmrun(svm);
 }
 
 static int stgi_interception(struct vcpu_svm *svm)
-- 
2.20.1

