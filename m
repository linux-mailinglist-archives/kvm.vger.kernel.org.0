Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C4AC1D0
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390220AbfIFVDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:34 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:40994 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389992AbfIFVDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:33 -0400
Received: by mail-vk1-f201.google.com with SMTP id g11so2905682vkm.8
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dD9/QUSmDVRmfW0CVBGqk/cZBNT81Sw0iddXqsAQmTY=;
        b=M5CwszVmgz+Bt5N6QVnMzVxf6VoUJJWGtB83ZktLk8efqkccfcpdXKNjHK4ZHNs3h4
         /Q4FsDolFe5e3XW71ZvtoHPoKv1lqSWqEX+AWYO//YL1sPpvaA3iHToI+kLDPcsKFzwE
         F3X1dmywF1M0Y8i32BeFXI9Mr4BwFPm1gcLHde3VN/GCeJc2dNl5OIpfOMijnWZ8xGb1
         KqRwh+Sp3ZpL9nUo+de5C681HmCp+XtaRwBj3mGJldHPXDnURlG3+hClvKQbFV4NaRNf
         Tv5zQSoZQb3CiFXkbcNqF5uy+SFpEpdNr8OEzqgNXgws77NL0Wp9nZ0hMy3cPkFsITTw
         GZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dD9/QUSmDVRmfW0CVBGqk/cZBNT81Sw0iddXqsAQmTY=;
        b=sTdCt6XPqJVhGD4WF1rd4q5BSE9VTJuc2d5/C8lcMkyp29YWgBkGU5iqhByvfuxmfy
         druKU6oFy9dopcLS4O4+cdh0FTtR76bj6Oh5z5nmmQT5+In3CD8OSQGeGpl+wTocXwdC
         iXVJhyJK4sjVdRmK8CGbVBjGq7F3DCumARr6P9wDkATHG+MCosD1L+Eu6+dhhRDhuazO
         DKMF280d8GPv2yli+Rt2SJ7l7DrStBQ8HaQopH74TPlxE2UsJZlix0vmGivgtBKcs7dk
         TAEpFIRBun8yroHP24fsR1FGUk0hMeNluznqVumchCq29e5b5r3Qsw0qz6Q0qaTk6Bck
         lWYA==
X-Gm-Message-State: APjAAAVINiCAivlQPb7bnTh8UUXBk729ll+qq4savmme7weovdDO8lrS
        coJi70lptMY/6EEyx3faXynjF8xoych5Hn5urt63pHvFL70ykw7nUQ9NI+0wyK0eRSGE0po1adO
        noN4BNiRBjG5gnJMbpocJB8vmBFifzd7TdUuMqGfmhwXCxG9RIsOLD/sIsg==
X-Google-Smtp-Source: APXvYqwfb1dirayUPI07Y7v5vtb7lFJuHxddFuQJveMdvRiQCUCpayDXnSsDHWGDYZlDcHjr2z7sbhY9C0M=
X-Received: by 2002:a1f:b994:: with SMTP id j142mr5569970vkf.62.1567803812447;
 Fri, 06 Sep 2019 14:03:32 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:09 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-6-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 5/9] KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
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

