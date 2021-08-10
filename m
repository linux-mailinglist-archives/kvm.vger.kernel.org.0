Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346E83E7E1B
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhHJRU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhHJRU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 13:20:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B7C0613D3
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t101-20020a25aaee0000b0290578c0c455b2so21544186ybi.13
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KD5isecR2ayOZ7sSUv+6jIJgcoLLIi/ZTy8rQvhmOJs=;
        b=iwDUVJklIU+Ex0Ll5jbpvI1jDKGBJfV1OBz1a9FrsAIY9PMkbCLu4CK0VPZox67IzD
         zZhKkVO+d1VQrzUEPJGREuxFY7DmVoIiZQoG+R7ldW6spkNbLKkH09EBw2Ir0r/OLwUK
         HiwTtr3b+ygbZUacNV0ioNoxfGmHvj2VrIcY/u/O5l0hqkFSmBUbJlF6nrUeqSbjRbQ5
         4rmuJtO99ENwvpfv2oUflLuKtcV1vTCmA86I55MzfQMv7fL+7llOKaSKWAcrs+uvYiFD
         z7H2m7dKZOzF7LN6ZYWyEG/DLqvNxWc9CPCYkGmFSLsCpL2HPDaYfIJdP3rq48VWyKYA
         dvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KD5isecR2ayOZ7sSUv+6jIJgcoLLIi/ZTy8rQvhmOJs=;
        b=s00+rqsII/bqhAfAjNH+oOlwVlugRBb/t2IdMPo+YdeFwxZF2T/ofOfwKOzHgYDbN1
         DU4s1mxzYxh8IYlHqhpUd3Z2d8iUVU2AwSM53fTrwm7ZyhnOy8Dnk/wQSDT/wyiFUEvv
         BKOwYO9JpfWwstwtqsEJryxC08MMtCkzwCRkcLCyYn5oLAZ1wxcV7tgv2971g6TpzVGk
         BFUNnTorLD7YCvnMCn4dLfs7Y4dytKTjSUAgZOGSCObvxqQ6QBAxdYiFOE9VGgljxIVK
         pHeWor8NTPC2BPoK8EqnHbdPMDyks1Lg1DF+BCPSa3MW6kfjngfH+PE1XZ6nd6aXnkq4
         A5eQ==
X-Gm-Message-State: AOAM531Ovt7oAziJOSdSkRHHt3sNmUCRnGvROP7yhLoS0M28ndT/7MFS
        otM1ypQZF4K0obC1vXZQKgIZZyJ5KKQ=
X-Google-Smtp-Source: ABdhPJyPy2ugPjpRbfm0U1WHWPiE5cgPEbgDUjQIDOBkCtUfbHf1TCqnIhuAPlFWFGWM1nswc/dDfVwP16k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:de69:b19a:1af5:866d])
 (user=seanjc job=sendgmr) by 2002:a25:db0c:: with SMTP id g12mr37051943ybf.6.1628616004152;
 Tue, 10 Aug 2021 10:20:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 10:19:49 -0700
In-Reply-To: <20210810171952.2758100-1-seanjc@google.com>
Message-Id: <20210810171952.2758100-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210810171952.2758100-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 1/4] KVM: VMX: Use current VMCS to query WAITPKG support for
 MSR emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the secondary_exec_controls_get() accessor in vmx_has_waitpkg() to
effectively get the controls for the current VMCS, as opposed to using
vmx->secondary_exec_controls, which is the cached value of KVM's desired
controls for vmcs01 and truly not reflective of any particular VMCS.

While the waitpkg control is not dynamic, i.e. vmcs01 will always hold
the same waitpkg configuration as vmx->secondary_exec_controls, the same
does not hold true for vmcs02 if the L1 VMM hides the feature from L2.
If L1 hides the feature _and_ does not intercept MSR_IA32_UMWAIT_CONTROL,
L2 could incorrectly read/write L1's virtual MSR instead of taking a #GP.

Fixes: 6e3ba4abcea5 ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0ecc41189292..4f151175d45a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -521,7 +521,7 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
 
 static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 {
-	return vmx->secondary_exec_control &
+	return secondary_exec_controls_get(vmx) &
 		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 }
 
-- 
2.32.0.605.g8dce9f2422-goog

