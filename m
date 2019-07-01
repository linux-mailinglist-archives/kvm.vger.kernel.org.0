Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F1E1B329
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 11:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfEMJqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 05:46:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37618 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbfEMJqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 05:46:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id p15so6203927pll.4;
        Mon, 13 May 2019 02:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsdiDk6Zs+VFH2JCv9rnfu5G+QrChkqRIl4npyicJBc=;
        b=sJoehUkfTIPBjdwCA842y47ItVU7i0/ozJqcI7HD7rahSFSwiOjxdqnTRMDQd1uexP
         za3Eg0f9RS6Kzy5IiE2/Nkm1DorV2mAJ8ViCldtmBh7rBAcSnVECvo89Hctg3MLkE0YK
         eKiayAvWMeIdj8VBlREE32aOwQJ1n87rjCWKH+RT8vLP37vPDoIf7NPl4CYCtHHp94Zc
         6L1u26+hHZDbmC/iqjqXTOvQXjL9GbHtHw5KOPNYs4Bz+X3SShCdO/3rWE+WayNACl5o
         N2x3LRMNlb0/R9jmXBGXUVpFBc26kjYzK8JPXOl6YKcStk5I4KegNc9VstS5vPltVn7v
         dB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsdiDk6Zs+VFH2JCv9rnfu5G+QrChkqRIl4npyicJBc=;
        b=l7AHoQ2fnTakytdumQI6jTj/yAiu9xj8lUciTAcl5WiMOQHTpt9jsKvB3zhVPaeM91
         /t46Hkt8lGX2XllLPXBmClnjFinui6FsfUpg0y4uVXgRKnM1tkRI+dezPjgk87s9jRdN
         FfTkI67kqfkni6lhc/tUvlxQtvFKsO3dmu5DDNJwNvkW+9BAuY+Eg4BMbVuG4Rs6olbK
         AW9uPkzSw3zL4Uh3zwzydAfySHz14lRZGGrwdRSnpQzV/YaHMGOqL9yuIQGYVT6KP+Sj
         SC3/xiGSEDRHpfiZxIdQIYIYqZKWvRug0ulFrXj4KQIYjLn++9d8taFWi8cPXQT3KBvm
         463Q==
X-Gm-Message-State: APjAAAUq3+BP6aChx+ewkvOLe1RCOFrIu5+jJJVg9fnrDIqE8pH9YZOa
        FkY416m3yVeEeEKV5ERn99CadRMx
X-Google-Smtp-Source: APXvYqyjKly6u6Z18VoqWMjZrdaPbwKxYzIuM4bmXIZ5zBMTRUS+DzhCU9T/OQxjUb1Yzygw0Kk3Og==
X-Received: by 2002:a17:902:f215:: with SMTP id gn21mr29293861plb.194.1557740804275;
        Mon, 13 May 2019 02:46:44 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id r64sm44584748pfa.25.2019.05.13.02.46.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 May 2019 02:46:43 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH] KVM: X86: Enable IA32_MSIC_ENABLE MONITOR bit when exposing mwait/monitor
Date:   Mon, 13 May 2019 17:46:39 +0800
Message-Id: <1557740799-5792-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

MSR IA32_MSIC_ENABLE bit 18, according to SDM:

 | When this bit is set to 0, the MONITOR feature flag is not set (CPUID.01H:ECX[bit 3] = 0). 
 | This indicates that MONITOR/MWAIT are not supported.
 | 
 | Software attempts to execute MONITOR/MWAIT will cause #UD when this bit is 0.
 | 
 | When this bit is set to 1 (default), MONITOR/MWAIT are supported (CPUID.01H:ECX[bit 3] = 1). 

This bit should be set to 1, if BIOS enables MONITOR/MWAIT support on host and 
we intend to expose mwait/monitor to the guest.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d89cb9..664449e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2723,6 +2723,13 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	return 0;
 }
 
+static inline bool kvm_can_mwait_in_guest(void)
+{
+	return boot_cpu_has(X86_FEATURE_MWAIT) &&
+		!boot_cpu_has_bug(X86_BUG_MONITOR) &&
+		boot_cpu_has(X86_FEATURE_ARAT);
+}
+
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	switch (msr_info->index) {
@@ -2801,6 +2808,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = (u64)vcpu->arch.ia32_tsc_adjust_msr;
 		break;
 	case MSR_IA32_MISC_ENABLE:
+		if (kvm_can_mwait_in_guest() && kvm_mwait_in_guest(vcpu->kvm))
+			vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_MWAIT;
 		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
 		break;
 	case MSR_IA32_SMBASE:
@@ -2984,13 +2993,6 @@ static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
 	return r;
 }
 
-static inline bool kvm_can_mwait_in_guest(void)
-{
-	return boot_cpu_has(X86_FEATURE_MWAIT) &&
-		!boot_cpu_has_bug(X86_BUG_MONITOR) &&
-		boot_cpu_has(X86_FEATURE_ARAT);
-}
-
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
-- 
2.7.4

