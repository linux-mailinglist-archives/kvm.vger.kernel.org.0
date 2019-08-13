Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA78BAD5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfHMNxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:53:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53102 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729350AbfHMNxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id o4so1470933wmh.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nCHf5t+smj+/MDbcCuVPNgK/OsWIUKLyWUiDOFrtLtU=;
        b=W7WZzJ5ppL8IuX/ZQDRyG/79DySf4if5HXIx37DTqyBDf923oJo3x5FY9MwA5vQA6X
         kXMArOD1DRlILDOHd6myJW3yoFDc7A2QlQXOL991gfYGOu2jU7ZQPN+eXkftkH2DHp1A
         Uk8WftQSQLm62q5fkN7B0OAY1kA/5pn1r1AByrc+hkY0uNoqs6aey4RAbhmNziiYAoc6
         Ttyq8FhlymOmfGCGwdjFfSCpakq0DbOmyH8ez3wJwCxA9YijjK3EftNGGMlkhFX/Qbf5
         wz+ARwEuYLLKDgOWJnmSMZY1I1nNxr64MmWlsyT/EYg5UiL+yXdGvgF8PWbfDOa10eno
         89qw==
X-Gm-Message-State: APjAAAUv4zqIgtIiTcnKTgMWPcld+FFj512aSGH7RboCiUpLFUOa/BTi
        GhpJyjnmXCojeyFNlIuxtYA/0HLB6dU=
X-Google-Smtp-Source: APXvYqwwbjx6HehIQwKISH00/Hji0I4JRkndO+nCLUekpySx2CNpHKLHhWjcndRwSCLW92rmdjJdZw==
X-Received: by 2002:a1c:cb01:: with SMTP id b1mr3362214wmg.69.1565704426865;
        Tue, 13 Aug 2019 06:53:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 7/7] x86: KVM: svm: eliminate hardcoded RIP advancement from vmrun_interception()
Date:   Tue, 13 Aug 2019 15:53:35 +0200
Message-Id: <20190813135335.25197-8-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
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
move it inside.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 51c39b608ef7..8473cbea7e8b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3588,7 +3588,7 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 
 static int nested_svm_vmrun(struct vcpu_svm *svm)
 {
-	int rc;
+	int ret;
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
@@ -3597,13 +3597,16 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	vmcb_gpa = svm->vmcb->save.rax;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
+	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
+	if (ret == EINVAL) {
+		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
+	} else if (ret) {
+		return kvm_skip_emulated_instruction(&svm->vcpu);
 	}
 
+	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+
 	nested_vmcb = map.hva;
 
 	if (!nested_vmcb_checks(nested_vmcb)) {
@@ -3614,7 +3617,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
 
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
-		return 1;
+		return ret;
 	}
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
@@ -3667,7 +3670,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_svm_vmexit(svm);
 	}
 
-	return 1;
+	return ret;
 }
 
 static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
@@ -3743,9 +3746,6 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	/* Save rip after vmrun instruction */
-	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
-
 	return nested_svm_vmrun(svm);
 }
 
-- 
2.20.1

