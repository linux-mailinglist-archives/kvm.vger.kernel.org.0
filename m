Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EAEA769E
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfICV6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:17 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:34163 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfICV6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:17 -0400
Received: by mail-pf1-f202.google.com with SMTP id i2so15079528pfe.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7Sol8OKiw/oCQXDixwbMZoIVJoNgDr7xxGx+BS9mMiE=;
        b=V/9Vc1xdHGogcVS6tApZhv6WLjCahUjH174W8VjpbfFUG9hWtP+1WJZSX3rsVDV/Eo
         Zjya5sSKxezh6H3gwyHSrf+Wzui8ho39Ayu2k7E6o/e7wQDQQLts5RgMUjrEs1GPPzF1
         Gcj5DMhxrjBM3exQY48C+aYWdqpDu6OtaWwnff73wXNRoVQS26SUtS7FMEQ7SgkOSd6Z
         HZ2c350ickyPWpqayFVZ9kctR5dsV+3RyhE64bRXV8hvzcn0lSFtDBYJu546TSbICHfX
         IVQ5PlfYNRKh+pofIDumvaBgQhoUzYaSeVijsJlQar9T+BlTDo+wc70AHcgxl6p2jwAy
         4Zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7Sol8OKiw/oCQXDixwbMZoIVJoNgDr7xxGx+BS9mMiE=;
        b=Q3JmOOyHmmiCKsYHgaoqoVws83keP0aqFsLJSSCR5pKZILOU/fxoa9Ae3SwjzyI2wY
         OQLwerULIF1CG58vJ9kumRTx9t7AgjmnWt35bZLtlr9T4HyVVQgRlbVcuciYuA2THXfx
         LmlNy0LGnGoLGFchmEi7xIA+3CCim4eszmtlsJXCpHoUYcb2iSzmNLwlbIxAsg5pAEJ8
         G1xBDGwxzDXul6UQfn9evzQWacuqxH+hfpgmQsYb3mFm8uyV1KffBb3YQaWeu9EGi0LR
         mcmJmS1ERuoxy1NHtHfywsHs7cbIK8cQZf0+j5mC5WF3OHvtptOhphcFRmYhKQHJgPJd
         d9Hg==
X-Gm-Message-State: APjAAAVH+AWj0lVcxQCcrH6MjdIHIxbXXV0e4p2lSl9rjeCeuz/vXQfh
        PvpQ3z9dwZdPwaZ0o5y4g1Xb/FDbMdLOeie56Xvetvc3EavJQAUtMUMsbROM3PETfufw4oH87Hi
        lLLZ4Ylimdq+cDhQYFGV2RhKHmoh1r0UopS0fs/qRRBTqZ9IseiGXKxpUoQ==
X-Google-Smtp-Source: APXvYqwFHtdiefGj+vxMUBnF3rRfClh7X4fWeIsJCQC6NfFUk2/GlTtiEIjn5aPcRayaxKjHVeFn8lvkkpk=
X-Received: by 2002:a63:fe17:: with SMTP id p23mr32165383pgh.103.1567547896259;
 Tue, 03 Sep 2019 14:58:16 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:58 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-6-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 5/8] KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
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

Add a consistency check on nested vm-entry for host's
IA32_PERF_GLOBAL_CTRL from vmcs12. Per Intel's SDM Vol 3 26.2.2:

  If the "load IA32_PERF_GLOBAL_CTRL"
  VM-exit control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL
  MSR must be 0 in the field for that register"

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6c3aa3bcede3..e2baa9ca562f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2636,6 +2636,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
 	bool ia32e;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	if (!nested_host_cr0_valid(vcpu, vmcs12->host_cr0) ||
 	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
@@ -2650,6 +2651,11 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    !kvm_pat_valid(vmcs12->host_ia32_pat))
 		return -EINVAL;
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
+	    !kvm_is_valid_perf_global_ctrl(pmu,
+					   vmcs12->host_ia32_perf_global_ctrl))
+		return -EINVAL;
+
 	ia32e = (vmcs12->vm_exit_controls &
 		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
 
-- 
2.23.0.187.g17f5b7556c-goog

