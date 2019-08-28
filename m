Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0CA0E52
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH1Xln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:43 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:47584 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfH1Xln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:43 -0400
Received: by mail-yb1-f201.google.com with SMTP id s8so1350543ybm.14
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PfmR04Nzk0Ur3U8pMUL3D5cf9UlixXRhhzJEHJF0KIM=;
        b=uPQO2yKGgS+yAZVRAiyrk1m8sxu+lkCgRxk6hhFITvNUTGxF0jPfwwQIx7SDUwVQDs
         DpW4IhDnuVb6RR0k/5V/78dItDd3NKxvATeq/n0dyD9ugnEEHdJxtZLpYZ4oPFED2qg5
         OgLaMrgyhk4CJdDld3blyD03kJJZ8cjq+uvUVx49ZrvhjBYNOYwu8vWPWz2xNDgwB6pO
         xa1yMZc/WFKkvcJoCxidpT9+D1VvY+XETEN/5yN3db+ue5ZBmJ2fOzhwXJFIdv5upSph
         yddPSH482UvuLs5ebmXwlCgYkCBm5UOzA/ciEi6FBcmnN9mhJtT0lFDedwyWgP97RMgG
         PX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PfmR04Nzk0Ur3U8pMUL3D5cf9UlixXRhhzJEHJF0KIM=;
        b=WrCEAKjwdC4fMxsBbkaMFZkAlLaSL679X7HoAfM4xi6x4RsyW2dbQFKK/bUyR9ype8
         PitJ0t3S6o/pK9wY9b7+b0Fj/X6B0Wle8JWfynUf3viuugt/UBu5qAhHLdtIW/jIbYMC
         avKAzkNRornyMtRnt1gvxbTr+aIjLdbakjmIK6qZJ+v3N5fC3yurF+MYkEjNFdI2V5Xz
         WShreuARhbKhAwFywbaFVI9Zrvc+NrQfVA7Il3OPGAIUreYrcr5E5iS1LUoNUDy3qmR+
         GlQ0WWg6rGx5BafknR9C7byRS7EyEH5CZXK7mblUieTf6jyakQchBQmKH5seb/0CJZcS
         vmGA==
X-Gm-Message-State: APjAAAUkX+QCCa6bkvVRBgDqhpAs8kf382hnfo9Ewz3coEu/INzHHcxY
        DQJDqiVDAli9TjqRpnw6NMWT39ffAVcn+hpRKnPEM9Lmngm9svMgPMesPPfoYZPZPFKb4W2Slaa
        V7FfdgCpA65zIKI+5m7wB6MYLKUAOe5LdqoO5oltGFOpjHyehAmT7b1cRqw==
X-Google-Smtp-Source: APXvYqxvHq1bhNbl0Z5wmSp+H/uDgsERC4dzm7olJ304mQ6dhp4TF6sa+XK4O4x1RHLVFtR5F54AhxHmT2A=
X-Received: by 2002:a0d:f783:: with SMTP id h125mr5049638ywf.446.1567035702774;
 Wed, 28 Aug 2019 16:41:42 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:28 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-2-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 1/7] KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL
 on vmexit
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
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

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598..b0ca34bf4d21 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12)
 {
 	struct kvm_segment seg;
+	struct msr_data msr_info;
 	u32 entry_failure_code;
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
@@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
-	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
-			vmcs12->host_ia32_perf_global_ctrl);
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		msr_info.host_initiated = false;
+		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
+		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
+		if (kvm_set_msr(vcpu, &msr_info))
+			pr_debug_ratelimited(
+				"%s cannot write MSR (0x%x, 0x%llx)\n",
+				__func__, msr_info.index, msr_info.data);
+	}
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
-- 
2.23.0.187.g17f5b7556c-goog

