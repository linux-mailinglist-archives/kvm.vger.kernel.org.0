Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6449FBCED
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKNARm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:42 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:48850 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfKNARl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:41 -0500
Received: by mail-pf1-f202.google.com with SMTP id g186so3030968pfb.15
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=j+sbbYAmUYfGQI9q2XqqN18XKNQPBGrU7X7l37kJkKc=;
        b=grLiIb+MWw2SV176nL6BzEymQNc2B3VppfpDBj31mNIJqcsQjFOzh/5H4lzlG9KFq5
         IrucCn5i9iFP4LfbDofhCfNx0+wpL91CH3pvEkJqc4ks1fBRgEnI4UX8c6I9AYjPj4f7
         yu1Yrs081oSpM0Ir8YE5UBnJ8kL6BFL0SE/+J+iVE1pFHpohhFTtxrk6Ks3n4ArjxeeX
         yWfdx6Sm9dju52zz5xw2maY+W/yh7PP7a2UqmEHOUMupNCcQEfRc/wquVQkPt2G35hq5
         UufJiDpAM0GKu9AP6adJOVORVStx7HupABl9cXM1UCJPIKRyEQ5iaRgsNWmjh5e2L6/u
         125w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j+sbbYAmUYfGQI9q2XqqN18XKNQPBGrU7X7l37kJkKc=;
        b=Cj4JyL0r/OnRy0jx3vpnHRu0oede4dwtWCPrg++0DQ/521f/gL3/0DLwIJlBRoBlnc
         0MBnL2hcDhsE9+ry9vzVfLv3TT9wCieSlaH6v/UuftlRR6Q3JuekQuhJEA+xh3mF2iuC
         OhPDAjUXLIL0d0MwPNW18Ok3mFZ47me1oJW1/Yrb3SzTbxKlyayx4VzqyBpDpllzX7C7
         0ijrAD0NwmSKid5QAVTG9/VHRbRImdMBcuLsHHe3ZqH4LFEdsg2kCaIjOgEUgxVgeU96
         7EjDlaa5FBzHnHrXcZ+s9oXUmrNxp4sSSm2g7U+8Pm3wW9SCddSnQuNOUvQYqwzbfvft
         qREQ==
X-Gm-Message-State: APjAAAUXBqj0K0cMoDHIF34+lybSSAQcu1GYNdR5QPRCoCvyZB3BLc7Z
        hQw15NWL7ThV8LzwMFgtaYwfX+Kx6GyWoklsWAjnRl/ikcNpApTAa3kjK1JupE4b+FERZZ31F+B
        szckJ27E58Edhtsw+tuJxlkShGfLQtNrlUhTy7U0NOjgDuEqoR1TAWCednQ==
X-Google-Smtp-Source: APXvYqxVVmPzt3Sv1YNKo6a3iyg/nndi2rfozTLDRLNRE6XuLn7vIZmDxwOq8qeEuTqu6CxTZgOKpx6j8Fw=
X-Received: by 2002:a65:66c5:: with SMTP id c5mr7014502pgw.12.1573690660413;
 Wed, 13 Nov 2019 16:17:40 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:18 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-5-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 4/8] KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL
 on VM-Exit
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
could cause this value to be overwritten. Instead, call kvm_set_msr()
which will allow atomic_switch_perf_msrs() to correctly set the values.

Define a macro, SET_MSR_OR_WARN(), to set the MSR with kvm_set_msr()
and WARN on failure.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f9ae7bc0a421..ecdc706f171b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -28,6 +28,16 @@ module_param(nested_early_check, bool, S_IRUGO);
 	failed;								\
 })
 
+#define SET_MSR_OR_WARN(vcpu, idx, data)				\
+({									\
+	bool failed = kvm_set_msr(vcpu, idx, data);			\
+	if (failed)							\
+		pr_warn_ratelimited(					\
+				"%s cannot write MSR (0x%x, 0x%llx)\n",	\
+				__func__, idx, data);			\
+	failed;								\
+})
+
 /*
  * Hyper-V requires all of these, so mark them as supported even though
  * they are just treated the same as all-context.
@@ -3867,8 +3877,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
-			vmcs12->host_ia32_perf_global_ctrl);
+		SET_MSR_OR_WARN(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+				vmcs12->host_ia32_perf_global_ctrl);
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

