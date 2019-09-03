Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD3A7638
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfICVbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:17 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35394 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfICVbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:17 -0400
Received: by mail-pg1-f202.google.com with SMTP id q1so11801625pgt.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7Sol8OKiw/oCQXDixwbMZoIVJoNgDr7xxGx+BS9mMiE=;
        b=u7FFmwjGU5n4N8BbF8Nr2a9GqP/C2DCxBGGJQOxISAFRxFVufyb8UhfGER4xQPK+dM
         psYMsY5l2F5ogGR7ENSBSzM2DzDzru/MFTfh4bSyc6SAe4BUfBopul1ZUIsflSsU55vr
         seNg9hTALIRZtl6D5ryX2lad6P1Dj9fdB8nvBs9KyvImzfFjvWcooxFZ7wdxbQu1mQVz
         ag1m9mkyoWGoZciTA3FnO50q1RxuWF73uWaVM9m/7nlj/ZDXQKugm8WJxqym13+BaBj4
         P13dUzB/MpYpVIvy9o0en/uaey852gPYSOpx469HRwBzV1vEclq9QAcyv0/QdtZ0g22s
         sQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7Sol8OKiw/oCQXDixwbMZoIVJoNgDr7xxGx+BS9mMiE=;
        b=WFMinaFLwZ2cv1IMUvo69ulfRIKGBgUsp+Ndpj9Ww411KZy7ebwim5/LJ2Qk6RRfF9
         6kwMCUWn9qkJpTESlyxICu532YomY2T2ezD8uEkpY4tH3RZJzTvLQaBP4dzsMj7p/uoW
         UrN0+auIEv5a8h5Eai5zrXDIXthqer/PYLUflxY0Gb8XhDi7+75+8W2u8F7cnYe9xwPk
         lu81EYZLBoYO4yBAN/kh1vlNOprqPsGUzrzwSoA2lDfvbpbK1Z+acbP7iKUPi4yW1hAd
         4/X87suEZK396kXsNXNMnDG9WaQwt2sfDiqBEfsnP0yiJM7Z7Gq0bRCQwQ9TDppDYI4O
         Vd8A==
X-Gm-Message-State: APjAAAWvJgl3bN2FhyIkeqOgp8mqydw8dccbm1f+MTcUqs5eoAnh3N54
        FyCtdarROm75WOT/q6eGh327e+UF16gD+eDyMHJL1VK51k71HT0PMCoWipCmX6pN5Cod/L5DB3h
        Kbul+F4wmzwhSFDgS4zSr4GNF6NAqcQ313B3VPbbVdVVlbMCWY14Wgd+PMg==
X-Google-Smtp-Source: APXvYqwaMJoqjgYZHuxggInLrMs6YPH369RP2SrDb1/gZEVdBrOXaZVl+UmlsBlAEqg8x2omtaEY1u0bVhs=
X-Received: by 2002:a65:518a:: with SMTP id h10mr31683570pgq.117.1567546275706;
 Tue, 03 Sep 2019 14:31:15 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:41 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-6-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 5/8] KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
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

