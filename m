Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690E7D4895
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfJKTlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 15:41:01 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:55832 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbfJKTlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 15:41:01 -0400
Received: by mail-pf1-f202.google.com with SMTP id u21so5360778pfm.22
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 12:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tFjCmwHNkWY/vtXdDAhqblK0COAto8NjIyTqKF2VaKg=;
        b=nrQWGXscB36hvzb/+9K7jjA9//3BNp4/XJGUu1wTuOMnB7lrh4qC+jT+4ACc6E3HEw
         PpIpv5zEFkKw4aPtu41WtWD/MRlfLLGzspdERee1zFBGNT00N6BtPHfi89d4Q20AGPBg
         Tg9OOzbzAWd1TLmnYMcnsh9omH7dlSa5FA8Uv/p3WCt1Izo26VR2tpdxJSxK/so+9wbF
         /Wf8HARNhZk+go8Q0D3UA4szvNF8rNMUCzz6C4n008782d+DAzaLKe8og1B1SLJHgB+q
         8guZgwBKuW0MRzZmc1qotHwsUk/qQFVAmH+oFs8x2goep8wkeigl6tq/XNokyJw8dvBF
         CkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tFjCmwHNkWY/vtXdDAhqblK0COAto8NjIyTqKF2VaKg=;
        b=hs+o5XUmmJMc6qEg8JUTcLTdWoVG8unUrlAVbD7sl4PiDspmF8or221CeESrTxwPHJ
         7CgonJvspLp2KqUJSmXXW8dBKBP9ECx2FopueCClPqcUITTu9zf/uPTI2mdWfhgAvhzT
         d7sBuOyRic4ro1et6xWZefiCLW9zMijgGENHYrNcl59VpPFy8ToFQIsmnhcQNnRmztUW
         lR7ZtB4G1R/XeT+HIlyf1E0oHgjGPOM5s6CZDytgW+39t+bPEAQuj4r37idwKbn5NLLK
         b36M49P2nhjcDWDNZno5olmszG/zxEaG42wEsEkj7aZsgk8Vv8K97wEqcxFE3puHu9Fa
         vJiw==
X-Gm-Message-State: APjAAAXzhkLlC2sgRTZr316BeOsTpGIyTZXHKF8yK1ab1FYZnVauFWkt
        sdAlK52WVFDsMLt8z4aSMJ7vsvrplTw9ysMV
X-Google-Smtp-Source: APXvYqxbt6TWtw0vLChkx71/BWcvtD1Nqihu/gC69YYt5qoaXWdLbuWCfCe7D+OUsa/4juRCdj35oFZzX5PoNRSi
X-Received: by 2002:a65:450c:: with SMTP id n12mr13571848pgq.394.1570822859060;
 Fri, 11 Oct 2019 12:40:59 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:40:28 -0700
In-Reply-To: <20191011194032.240572-1-aaronlewis@google.com>
Message-Id: <20191011194032.240572-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191011194032.240572-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH v2 1/5] KVM: VMX: Remove unneeded check for X86_FEATURE_XSAVE
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Volume 4 of the SDM says that IA32_XSS is supported
"If(CPUID.(0DH, 1):EAX.[3] = 1", so only the X86_FEATURE_XSAVES check is
necessary.

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
2.23.0.700.g56cf767bdb-goog

