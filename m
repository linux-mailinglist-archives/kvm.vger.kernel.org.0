Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4574515094
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 17:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfEFPqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 11:46:45 -0400
Received: from outprodmail02.cc.columbia.edu ([128.59.72.51]:39258 "EHLO
        outprodmail02.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbfEFPqp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 11:46:45 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x46Fk46h011180
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 11:46:43 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id 85DDE6D
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 11:46:43 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu [128.59.72.14])
        by hazelnut (Postfix) with ESMTP id 669FE7E
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 11:46:43 -0400 (EDT)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x46FkhcJ043439
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 11:46:43 -0400
Received: by mail-qk1-f199.google.com with SMTP id x23so14868694qka.19
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 08:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+W7cenQ0t0/So9hU47bgXjBdap+rlrWrpFiNXAt13oI=;
        b=loBCoqxbZj217rHkNoFBav7Iuw7+URoZbPLzDTcRSEijwJpzTkyzADH5GEQT+B2CyM
         bEu7O0k29s2ir1TDWnn1+XzydjfXztQsCNmqai/Ksg9BhIYG+RZcUTIrpMbYa9dmkkk/
         /KHk8fOIxCSpUbFiDDGI8Y+9pudIcixDBReaVupfKNaGNRgKTGU+sKujU4v6XRH6UY1J
         fERxSvQh/qNVplMjE7obI1+I3XSZBmLPF+atJgiE143rFjkPl0O88/uBu2F28f8FVMJr
         NwaHATj6hT+JKDE5k9c8XSFIlGWy0Q9N5Fqc64xCHlqYGO/rh16qblTOkaInJyOG3fin
         GtNw==
X-Gm-Message-State: APjAAAW65RK/GvTdPtNh++uQWwoVSwXN5iEIdd51kQAF1laCm3iXQeyH
        ojlhdEl8gOWbGW2go3mVHDSE/O/G3w61mnxgBOt4zFJ18z/qnfv7x+JmbGne55bFODxfIfywK5e
        j9uxkakzo8o8mPYthmKmM
X-Received: by 2002:a37:49ce:: with SMTP id w197mr19390215qka.330.1557157602598;
        Mon, 06 May 2019 08:46:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz8swc3aIsNVzFJ+Xm07fZ6rwZIyN+d37giVEKKPt9rPvBjDbxksH4ONqRNJZeZ18+NxQkAUQ==
X-Received: by 2002:a37:49ce:: with SMTP id w197mr19390205qka.330.1557157602458;
        Mon, 06 May 2019 08:46:42 -0700 (PDT)
Received: from hp03.ncl.cs.columbia.edu (hp03.ncl.cs.columbia.edu. [128.59.18.193])
        by smtp.gmail.com with ESMTPSA id 17sm7203534qty.79.2019.05.06.08.46.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 06 May 2019 08:46:41 -0700 (PDT)
From:   Jintack Lim <jintack@cs.columbia.edu>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH v2] KVM: nVMX: Disable intercept for *_BASE MSR in vmcs02 when possible
Date:   Mon,  6 May 2019 11:59:19 -0400
Message-Id: <1557158359-6865-1-git-send-email-jintack@cs.columbia.edu>
X-Mailer: git-send-email 1.9.1
X-No-Spam-Score: Local
X-Scanned-By: MIMEDefang 2.84 on 128.59.72.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when neither L0 nor L1 configured to trap *_BASE MSR accesses from
its own VMs, the current KVM L0 always traps *_BASE MSR accesses from
L2.  Let's check if both L0 and L1 disabled trap for *_BASE MSR for its
VMs respectively, and let L2 access to*_BASE MSR without trap if that's
the case.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

---

Changes since v1:
- Added GS_BASE and KENREL_GS_BASE (Jim, Sean)
- Changed to allow reads as well as writes (Sean)
---
 arch/x86/kvm/vmx/nested.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c601d0..d167bb6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -537,6 +537,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 */
 	bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
 	bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
+	bool fs_base = !msr_write_intercepted_l01(vcpu, MSR_FS_BASE);
+	bool gs_base = !msr_write_intercepted_l01(vcpu, MSR_GS_BASE);
+	bool kernel_gs_base = !msr_write_intercepted_l01(vcpu,
+							 MSR_KERNEL_GS_BASE);
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -544,7 +548,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
-	    !pred_cmd && !spec_ctrl)
+	    !pred_cmd && !spec_ctrl && !fs_base && !gs_base && !kernel_gs_base)
 		return false;
 
 	page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->msr_bitmap);
@@ -592,6 +596,24 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (fs_base)
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_FS_BASE,
+					MSR_TYPE_RW);
+
+	if (gs_base)
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_GS_BASE,
+					MSR_TYPE_RW);
+
+	if (kernel_gs_base)
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_KERNEL_GS_BASE,
+					MSR_TYPE_RW);
+
 	if (spec_ctrl)
 		nested_vmx_disable_intercept_for_msr(
 					msr_bitmap_l1, msr_bitmap_l0,
-- 
1.9.1


