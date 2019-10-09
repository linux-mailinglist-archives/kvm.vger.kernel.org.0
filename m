Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18FAD04D6
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfJIAlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:41:52 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48800 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIAlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:41:52 -0400
Received: by mail-pg1-f202.google.com with SMTP id w13so407421pge.15
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wWhaKBFj4UiHiDF8QMpQfVJuRDyfgZlQAJc5UeHTyGw=;
        b=alhNQlCiZcCGVsOc18cQxP8bYopfg76Av1c5PWFkFC3RF8ynOL5it2+fSmLDK/lOzV
         kqoQrvA2fTiCfBpPSw+6GPHMr5uVznBbp7sbv1dLvJZEUdjgzW/8secBRVOKUXQ//Wmk
         V7Am2s6UNYfcrN/dJKBHuv6/xGEW4FzUa4/iKH9TAXmq/aPfo3Z+sxQrQWqdPBTSk/g8
         /TYaKxCcOKHJVKbE/LbCQtxaxKsxLV/pnkwEqjrYrRG8Mw9AGDRv4mkBH+vGPOWOXIxC
         fTq+JGTxbKZKLdVB0B1z8c6716m+HA6FWA3Ped3sLsOWlnhz0eAJDURRPYouZ+g05u4R
         ADpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wWhaKBFj4UiHiDF8QMpQfVJuRDyfgZlQAJc5UeHTyGw=;
        b=nyZUAukO8Gob/cgS+0EupkBzNTvs9UB1eRXUr5vGxD9g7sTUGeoEJJWLDibB1fYKBJ
         SPJiHw0R9YcV+PpxXaqVeRNnOFqWHDfMB40a6DxZGgPbKyR+mhS4lBk1xBMsS08M6X/E
         HvVtRf3NBKuqOPTsdz3Mskg4aEghNLlwz9gV3cGhw7VxvZyqFOuNQQfyd38hsK6ELfAM
         Vi4UYxiqFtfOcTUVUoNCvTqz+ItcHZjWF8bQxzrrC8rKNDsn5TiyoUkpwgYUBwtbP7r2
         YDMVyU8G1qh5d4MbeRhEeAQbJf39KXtDJ9U3igba4ETSOXD4UfJb7Wou3AiyO+rubs4l
         8NfQ==
X-Gm-Message-State: APjAAAXQa+v+qzt9K7QT8oLuQLy6dvCDYhc7BaSuvY/mgXh93Tf/xBXu
        46LPNCGio+kfxwGmyfY6xe9lPu2ygFfNUrpb
X-Google-Smtp-Source: APXvYqx++oqr1N+AhdY23zFbXUWyOaXjXSiG9uPy0Ogz6IIpU1bltJc8Wadde9WPfYZatsUfPb08BeztYBLqb68a
X-Received: by 2002:a65:6910:: with SMTP id s16mr1356164pgq.284.1570581710065;
 Tue, 08 Oct 2019 17:41:50 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:41:37 -0700
Message-Id: <20191009004142.225377-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [Patch 1/6] KVM: VMX: Remove unneeded check for X86_FEATURE_XSAVE
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SDM says that IA32_XSS is supported "If(CPUID.(0DH, 1):EAX.[3] = 1",
so only the X86_FEATURE_XSAVES check is necessary.

Fixes: 4d763b168e9c5 ("KVM: VMX: check CPUID before allowing read/write of IA32_XSS")
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae..409e9a7323f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1823,8 +1823,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!vmx_xsaves_supported() ||
 		    (!msr_info->host_initiated &&
-		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
+		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -2066,8 +2065,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!vmx_xsaves_supported() ||
 		    (!msr_info->host_initiated &&
-		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
-		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
+		     !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
 			return 1;
 		/*
 		 * The only supported bit as of Skylake is bit 8, but
-- 
2.23.0.581.g78d2f28ef7-goog

