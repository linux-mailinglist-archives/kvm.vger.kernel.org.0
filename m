Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28008BAD8
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfHMNx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:53:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46353 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbfHMNxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so107846103wru.13
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYlHN4JVME6q9nUPfct82Z5v9HJ8xQJ6H/P1ku2ts7g=;
        b=aQBeBToPraDnyHjNHWWWa6gx4uBEZpmrHBM5ne9fYPop+RA+Vq6gAOElmS1UQBQmXO
         PiMwUby2+5um1exJdT2H65YNXQc6usO6F6SCPr+YFtbkswba64tzcY0BaxdQLZBmaS2S
         dPFbFW6uxdS7FzsDbRjgQQARnvrdPcrLn/LNcJL6xiWj1c5umI4fJhTi8GJYIbqJfudk
         cPWyEs4NxthcPVsmHnRtMmDYjM3wBBA388DdJeN5Yowygse9Vbep1tKREzDcOieOjZ+J
         MU2a4v1GXHRTDuMy5d7+3XiDb0WpBdScBptLhxb+KHIcQkMxx7r5UwGuTQEnTNfdGcwh
         jAkQ==
X-Gm-Message-State: APjAAAXOwRfVwmumN54lPYP+vCGoeKH166vgrZ/xkXQjent8+ZmHekGV
        soCjOO7it9yd+VDIUncwPmzFz/cYnAo=
X-Google-Smtp-Source: APXvYqwV8ku5H3v9v805OHgWqH2cJ4Gi6IW1ctkPJ92w1fnejqYyTGi7CVad8ViPXuYezi1WY5Bcog==
X-Received: by 2002:a5d:560a:: with SMTP id l10mr9214460wrv.101.1565704425712;
        Tue, 13 Aug 2019 06:53:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 6/7] x86: KVM: svm: eliminate weird goto from vmrun_interception()
Date:   Tue, 13 Aug 2019 15:53:34 +0200
Message-Id: <20190813135335.25197-7-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Regardless of whether or not nested_svm_vmrun_msrpm() fails, we return 1
from vmrun_interception() so there's no point in doing goto. Also,
nested_svm_vmrun_msrpm() call can be made from nested_svm_vmrun() where
other nested launch issues are handled.

nested_svm_vmrun() returns a bool, however, its result is ignored in
vmrun_interception() as we always return '1'. As a preparatory change
to putting kvm_skip_emulated_instruction() inside nested_svm_vmrun()
make nested_svm_vmrun() return an int (always '1' for now).

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6d16d1898810..51c39b608ef7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3586,7 +3586,7 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	mark_all_dirty(svm->vmcb);
 }
 
-static bool nested_svm_vmrun(struct vcpu_svm *svm)
+static int nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	int rc;
 	struct vmcb *nested_vmcb;
@@ -3601,7 +3601,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
-		return false;
+		return 1;
 	}
 
 	nested_vmcb = map.hva;
@@ -3614,7 +3614,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
-		return false;
+		return 1;
 	}
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
@@ -3658,7 +3658,16 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
 
-	return true;
+	if (!nested_svm_vmrun_msrpm(svm)) {
+		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+		svm->vmcb->control.exit_code_hi = 0;
+		svm->vmcb->control.exit_info_1  = 0;
+		svm->vmcb->control.exit_info_2  = 0;
+
+		nested_svm_vmexit(svm);
+	}
+
+	return 1;
 }
 
 static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
@@ -3737,24 +3746,7 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	/* Save rip after vmrun instruction */
 	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
 
-	if (!nested_svm_vmrun(svm))
-		return 1;
-
-	if (!nested_svm_vmrun_msrpm(svm))
-		goto failed;
-
-	return 1;
-
-failed:
-
-	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_code_hi = 0;
-	svm->vmcb->control.exit_info_1  = 0;
-	svm->vmcb->control.exit_info_2  = 0;
-
-	nested_svm_vmexit(svm);
-
-	return 1;
+	return nested_svm_vmrun(svm);
 }
 
 static int stgi_interception(struct vcpu_svm *svm)
-- 
2.20.1

