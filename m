Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40F2215B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 10:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfEQIt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 04:49:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43617 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfEQIt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 04:49:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id t22so2977662pgi.10;
        Fri, 17 May 2019 01:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9I+lX7qkOYzggWtQec+1m6I5euArD7SEmoWKuSnERRI=;
        b=PaW707s8aG5UEv/PL/RpVgZMRPo/yXTGiv/I0BSmqeqLzCCzlveC2OIIVi79sHPSaH
         tM6P+W5oVQbCKsTjX7CL1gOk0fCIzCjO0CacoL6mzR9QT7ueQj4pg5Ump9BZkwbbl+1t
         a2D8p/tXSYhyJZOtIlID2Tcwng1SolxVJgCEdwq0nBCbJw7DNcuS/UMGL8C0TUb6BFPl
         LjRI3LcYt84a5Uq48zn4KXpI2K6mVMi+4OmRwzEs4nslVmHKWJF8rshg+U3YcMDXs7ZF
         FQW2zgzMck7acr9+tPQnwsuDEUkYYT/lQdJ8NxiFG6Scpx006rXv3N9CtaHICpVIf7EV
         /arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9I+lX7qkOYzggWtQec+1m6I5euArD7SEmoWKuSnERRI=;
        b=oyFooB4UPaqNbv2DyjQlIDAmTwxkD6D2ALjSuK06s4QBSCPASCaKz0/yDBFQj8IWC0
         hrJ23izyFH5QB6kGpRXrH+5x8VXxkuCbjJX0whKUv6Ltm7ZH00iaXnnYlgCWvyIWQE22
         wfpWoG3Q4VWMjHgCPESvXJP7DqYmmU05pSMg+v6TC0/YOVwbvAfaeRysClHfXvtTxtJb
         Nv7h2N0mcK/oPLAgaDTnbFvkdWRK5LRUfJQBZRm8uuIVHcwc16y/Xfvx3TvxIqt/UmjZ
         RyaFj36j0EMQycM8qa0SeqoF1VPQGj8DQxVxDP0PMse0V2OVc/Xy8YyvV4WA/O+r1BhH
         pSNg==
X-Gm-Message-State: APjAAAVz7phDLUMsVckfa8g/QCoo3Oyx45dOykr9hH8EhvT0dP3Rvqxg
        R3QmqXOmf4Y30rDj1sCfw+5ZeIgI
X-Google-Smtp-Source: APXvYqwFYB1b7T68JzkdwK3+oTP4wh54dJfjJWuzNZcQtn+5UzG7e3oluVqdg4LO8ooo1ku5XcM3Ug==
X-Received: by 2002:a63:e408:: with SMTP id a8mr55686792pgi.146.1558082995724;
        Fri, 17 May 2019 01:49:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 63sm10417127pfu.95.2019.05.17.01.49.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 May 2019 01:49:54 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 1/4] KVM: x86: Disable intercept for CORE cstate read
Date:   Fri, 17 May 2019 16:49:47 +0800
Message-Id: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Allow guest reads CORE cstate when exposing host CPU power management capabilities 
to the guest. PKG cstate is restricted to avoid a guest to get the whole package 
information in multi-tenant scenario.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 771d3bf..b0d6be5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6615,6 +6615,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	if (kvm_mwait_in_guest(kvm)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	}
 	vmx->msr_bitmap_mode = 0;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
-- 
2.7.4

