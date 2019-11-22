Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B84107B8E
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 00:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVXoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 18:44:16 -0500
Received: from mail-qt1-f202.google.com ([209.85.160.202]:51660 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVXoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 18:44:16 -0500
Received: by mail-qt1-f202.google.com with SMTP id v92so5742797qtd.18
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 15:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=v33LWS5njd3HA3a4rOiy/PMZk8toCPL1wn8/Vj/DWlI=;
        b=XjCpfaOufG+9NCDsSCPsYmeBSe0jBAeqDDsJJ0vefBAwFcVfI2d4O7l9sZt/P9AEl2
         cakp/EESkTHVu4ygP330qNJF+EOA1x/n+mdGGiUNeqgYEDQ7S02mtHAZRC/Wa4lmOlZZ
         K9L/rxus47O+27XSgpY2tDrypSJaeVnVUBgeMqxgXD9NGHuYn/KM6y/FKV7Y8gamSDYE
         OXor7nGzndTi8LDR+6deywWardA/3hOtfxETEgSYo860sjxxSmKx7FrACAhqjrbXEpWp
         kMisWLQC5Gf5NJ7jY5FUIp0dcT74GfzosO1zE9lsawy0crxsxMcSJMVHgG4j1XDTIgFP
         gT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=v33LWS5njd3HA3a4rOiy/PMZk8toCPL1wn8/Vj/DWlI=;
        b=oZX+Bc4Ya0qKmwbChZlYnk9DqtiopU51N+qUvrX1wMZEjW9VG8as1e4i6UsactQ1sH
         YKZ2nu3Ok5Fa7PW6j6/g5fdhMEz0a4ezHW0WHyBo7R0DKgotgFMoxCp+vPe05UQEX3fc
         kdu6D8lyjj8+mBxFtIMUmrevipTyp2QV8/bKeAgC2XLANus4gBlWc0g2lKtfoGOGw6Pu
         6dYZEVAi7UZlO/+6OlC9DelM1sXMAGROqewCQignM0jyayP4aGgy+imNlkR1unr4Ctev
         bFFxiDVLZGjTEx30IL1CafDhMNPKvVWx2ZU2x/A/xBNyUPWnJg6L9tFF1rvaQcLSarUt
         23pw==
X-Gm-Message-State: APjAAAVEl8KI83aARMXZ0B451XZuo7b9OOAP3gqoBYTfmO8W+1FWPdA9
        YO5asC+c+KleuSE9Mu1EP8jpMAUB9HVxUQigHhYy5Q/7U+VpJ4rE9QWPMyDCDnuN84LiCDPilkW
        ob+q8umGv3r9Vv1+SPUFlm2xMyLQa7LqqasKb3JORewaDBiZyGaMBdmtEfgTo9Xs=
X-Google-Smtp-Source: APXvYqzysauZncRk/96+SceJlXO2q4nqV47mDXB7CgstiPDGWvTRAU4dvArbYbSfvczaU/bDKpm3fcqh70Cs0A==
X-Received: by 2002:a05:6214:6e3:: with SMTP id bk3mr2370192qvb.20.1574466254558;
 Fri, 22 Nov 2019 15:44:14 -0800 (PST)
Date:   Fri, 22 Nov 2019 15:43:55 -0800
Message-Id: <20191122234355.174998-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haozhong Zhang <haozhong.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 37e4c997dadf ("KVM: VMX: validate individual bits of guest
MSR_IA32_FEATURE_CONTROL") broke the KVM_SET_MSRS ABI by instituting
new constraints on the data values that kvm would accept for the guest
MSR, IA32_FEATURE_CONTROL. Perhaps these constraints should have been
opt-in via a new KVM capability, but they were applied
indiscriminately, breaking at least one existing hypervisor.

Relax the constraints to allow either or both of
FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX and
FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX to be set when nVMX is
enabled. This change is sufficient to fix the aforementioned breakage.

Fixes: 37e4c997dadf ("KVM: VMX: validate individual bits of guest MSR_IA32_FEATURE_CONTROL")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04a8212704c17..9f46023451810 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7097,10 +7097,12 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
 	if (nested_vmx_allowed(vcpu))
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
+			FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX |
 			FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
 	else
 		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits &=
-			~FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+			~(FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX |
+			  FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX);
 
 	if (nested_vmx_allowed(vcpu)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
-- 
2.24.0.432.g9d3f5f5b63-goog

