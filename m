Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8004F86814
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbfHHRbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:31:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33961 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404405AbfHHRbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:31:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so95767759wrm.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNGY5/pIZwYc1y8jKoUSUwTNZVrPC80kmGzCCKEMhvY=;
        b=DCXgiAOqex43id3pxVNhhSDGRTSNyT7f3P0RWeACYy7DmYk5l3jlHmpji4DqhKCmQ8
         q8Be4FvDpyDldn26hrpDUA9BhrAn55n4wF6TyhjSTkR26HZViAgjxNfvbEZ0ZhHHwtNw
         q8Q9f2Empa+z1H2FQeTs4IFfzFiUQUb5FqBixwtPVC0mpwh9qrFpKrl8Pis600moXuuM
         eMOQjazLNg70k1znUjr6XPpARA+hmRmoZE5rkY7nnXoXv99SbVCCfxzzDQ4Bc8RfKFDO
         V47neDkkTiltqRJl4T2WbT7TnhWMnLwGL92/AjE2AUryx8GFIQYvJcqeOmWFOWM05cC0
         U94w==
X-Gm-Message-State: APjAAAVPW/Y4IF7E6+EkaHgFf79er2aznaY2qRPIvQN/qsXK8aIl2Ua7
        sC/ceqIAMMDuVf1R9Bzg28SQoaR9h4U=
X-Google-Smtp-Source: APXvYqxRX19w+HZSpjqnjk2q8yQX1DrW5vAe9o12bNsY6Qp/kzsU3+vGBWL86JUiplgXB2BU6bdQcQ==
X-Received: by 2002:adf:f204:: with SMTP id p4mr19188140wro.317.1565285464694;
        Thu, 08 Aug 2019 10:31:04 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.31.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:31:03 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 6/7] x86: KVM: svm: eliminate weird goto from vmrun_interception()
Date:   Thu,  8 Aug 2019 19:30:50 +0200
Message-Id: <20190808173051.6359-7-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808173051.6359-1-vkuznets@redhat.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
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

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6d16d1898810..43bc4a5e4948 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3658,6 +3658,15 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
 
+	if (!nested_svm_vmrun_msrpm(svm)) {
+		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+		svm->vmcb->control.exit_code_hi = 0;
+		svm->vmcb->control.exit_info_1  = 0;
+		svm->vmcb->control.exit_info_2  = 0;
+
+		nested_svm_vmexit(svm);
+	}
+
 	return true;
 }
 
@@ -3740,20 +3749,6 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	if (!nested_svm_vmrun(svm))
 		return 1;
 
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
 	return 1;
 }
 
-- 
2.20.1

