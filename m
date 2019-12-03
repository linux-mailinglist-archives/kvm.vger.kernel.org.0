Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A392C11044F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 19:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfLCSfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 13:35:22 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:53079 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCSfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 13:35:22 -0500
Received: by mail-pf1-f201.google.com with SMTP id f20so2820732pfn.19
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 10:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M1yK6kqSKpTvb7Wty8pVnwVM+wqUB9MeH97VgIGp9/U=;
        b=j69D55AN4TGHFqbpdRfp1bluTFdRLP/XB/qiDlTPqu2D0HziOiK/GCcwrKKBi13VVB
         fuztoHP9i9J7immdBQDEfe2Oh37x5sdSUHnwfDwHgxfDOW4IksTiHLUoMJpvhE+5ik2L
         +W+ciTRonOzHVQTJZf5s81viORtMZnQTgHPQEos8fG75ODIWHlRCG4Tnl7W6sgpLX3Fq
         0OOaiNqqUm+2Fjt3O0akDgV/GqtPjJ5oREFwH8rLL0TsVvaiYYnZS7wX5Cea/6oi/Tbt
         qkv79NUs8Yyxdyx3cm0n8DhLr/PiRNpcIzLGeEaq329h8mVcnApVLyr7+5rQE5QEBAHC
         m5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M1yK6kqSKpTvb7Wty8pVnwVM+wqUB9MeH97VgIGp9/U=;
        b=UYVi6i8+V5pr94HmlOQ4LvqkoG0t7l6wSq4XrGRxt8569fmgTQQjxAYjDe6d/ceLIE
         cQJhvxFvlaM/VYJL+lJ0eyMlmJIQ4hPm5UfQ4ei5lb4ubOwUMmztH21ZOXTh9UVQ+aLm
         VpRMOll3mdhkYdeTdWZwOQ9qs4uwx8q1h+v6XCLKkz4f5Ls+3bx4bkoOzarHbR2B2Pgr
         lQi48JJxRlIpBCexnm9Yuwa4Ou+MUAAgYcpd+5J/hx8UUGPMa2mudvXG+qpvW0MCUZYf
         Smus9LQBsB4ZIlXUIvkaP/N1bGRBhIif5csPihUckA6phuie6AqIzpmzfkHYWM/GPhtD
         MEXA==
X-Gm-Message-State: APjAAAVDW3Mk8sVOuV/BmK0GxbnBWxkoBMkvMafE9nzP/dh1w/aTXyv8
        rjJyTYg3orMW2X1sFiZ8DIlSSRbMAOsV0Jk5LAGd596xubVPlfcgdsWXjPUTCWrHU/gLL67llC+
        M3bgLxe3igUk7gBw1TW6yHPxnWzlvJ1+sDI859iYdXn3RlMFyo/qGmdKhM95b8Fg=
X-Google-Smtp-Source: APXvYqyy06Xi9zE4HNDi5LLlMDDO5wISf9UXaY1EhFLIfZDQ8cL7mC8BffErVYM/soOyeg9CJUtiTIG/kC5O4w==
X-Received: by 2002:a63:2fc4:: with SMTP id v187mr6754444pgv.55.1575398121159;
 Tue, 03 Dec 2019 10:35:21 -0800 (PST)
Date:   Tue,  3 Dec 2019 10:35:12 -0800
Message-Id: <20191203183512.146618-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v2] kvm: vmx: Pass through IA32_TSC_AUX for read iff guest has RDTSCP
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the guest supports RDTSCP, it already has read access to the
hardware IA32_TSC_AUX MSR via RDTSCP, so we can allow it read access
via the RDMSR instruction as well. If the guest doesn't support
RDTSCP, intercept all accesses to the IA32_TSC_AUX MSR, so that kvm
can synthesize a #GP.  (IA32_TSC_AUX exists iff RDTSCP is supported.)

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

---
v1 -> v2: Rebased across vmx directory creation.
          Modified commit message based on Sean's comments.

 arch/x86/kvm/vmx/vmx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d175429c91b0..04a728976d96 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4070,6 +4070,10 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 
 	if (vmx_rdtscp_supported()) {
 		bool rdtscp_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP);
+
+		vmx_set_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_TSC_AUX,
+					  MSR_TYPE_R, !rdtscp_enabled);
+
 		if (!rdtscp_enabled)
 			exec_control &= ~SECONDARY_EXEC_RDTSCP;
 
-- 
2.24.0.393.g34dc348eaf-goog

