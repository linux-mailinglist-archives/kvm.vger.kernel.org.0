Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4656323525
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 02:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhBXBTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 20:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhBXBFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 20:05:11 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF38BC06178A
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 16:56:31 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id l1so482650qtv.2
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 16:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=qPqWTKGBtiXgew3PhU0N/4Jj0Q0xiKY6q8BL4BwzsAU=;
        b=HunJVjKbKYQ5+XtdKimDZXAv30Guhr4IP7oIEdJc7r2ZY8T9q1TUL/oYbgxHvoizNY
         vVaw1gzKdcN61vKj+zzI4R6vjvUWlc4kq/PEuq24S22oLK7OYKNTlTgvh69hULpZaCWp
         9hi14vlflVmxyWK+peWu78muWleYnJ1efDkxVY24A2Y+eqvqUrh30D4+Q0Js1dhFb88s
         RLeWbzv0rw2i1wKgwjrZrP+ZN66NbrV+4HBSLGivZ1JM0ZFlwv4RVFR+Z3FxQJcVkgJD
         Fqa+4OPHLFDG4RCmRqcpmDHSNxWXq5XaVW5+tqrhUlWI7jp40/Xw9/bA4sOYc4+JAat6
         2f2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=qPqWTKGBtiXgew3PhU0N/4Jj0Q0xiKY6q8BL4BwzsAU=;
        b=fgWY+ULTMuhH0d0cpKzToz4jdTNdUCtD5GNih/3avgOoRPTX+/f7T7u+exCwseBU3L
         3v/LnX4PawvlsutYmDnW3Dnwkc1R/86Hzrgw9VgqojHQHskpR6eEn9tmGqkylQihHpaD
         d+CO/xG9e8u7+lhZO2db4Xt//g1yZQw8Y8W6eT2NXPdYV3Tk78EUtT4sLi+g5Guk8b0h
         qFxiWWsD/qCvqVf+FG9zQq+BksZuogT06sFeCOHWJqhREslYZ1HlLEoAPX7+oxwCZ2HO
         C8fdt+cSsccuXxaSaL2BQZCVrGOK651/Yu1rIs+5nHzoq1472GFZDAFdGAwtq89QksJ9
         KKPQ==
X-Gm-Message-State: AOAM530BQ+uAmzXu105KL93leUxLd+QCtyzM713Zea8HWeuqlrcXWQSS
        bxLmE120E/NE7yl+NxYZlPLuPoMRTiQ=
X-Google-Smtp-Source: ABdhPJzH3hAGs0FwoUemhwbym6SDVcEwG16rcuwMXwz97fmv4n8V/0SYC1Yl3E1PbNjpcyLrGYK8r924QTg=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:cad:: with SMTP id
 s13mr27824910qvs.53.1614128190725; Tue, 23 Feb 2021 16:56:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 23 Feb 2021 16:56:26 -0800
Message-Id: <20210224005627.657028-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH] KVM: SVM: Fix nested VM-Exit on #GP interception handling
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
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

Fix the interpreation of nested_svm_vmexit()'s return value when
synthesizing a nested VM-Exit after intercepting an SVM instruction while
L2 was running.  The helper returns '0' on success, whereas a return
value of '0' in the exit handler path means "exit to userspace".  The
incorrect return value causes KVM to exit to userspace without filling
the run state, e.g. QEMU logs "KVM: unknown exit, hardware reason 0".

Fixes: 14c2bf81fcd2 ("KVM: SVM: Fix #GP handling for doubly-nested virtualization")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 14e41dddc7eb..c4f2f2f6b945 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2200,13 +2200,18 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 		[SVM_INSTR_VMSAVE] = vmsave_interception,
 	};
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
 
 	if (is_guest_mode(vcpu)) {
 		svm->vmcb->control.exit_code = guest_mode_exit_codes[opcode];
 		svm->vmcb->control.exit_info_1 = 0;
 		svm->vmcb->control.exit_info_2 = 0;
 
-		return nested_svm_vmexit(svm);
+		/* Returns '1' or -errno on failure, '0' on success. */
+		ret = nested_svm_vmexit(svm);
+		if (ret)
+			return ret;
+		return 1;
 	}
 	return svm_instr_handlers[opcode](vcpu);
 }
-- 
2.30.0.617.g56c4b15f3c-goog

