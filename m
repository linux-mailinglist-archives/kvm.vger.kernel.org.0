Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093033E9DB6
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 06:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhHLE4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 00:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbhHLE4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 00:56:47 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC502C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 21:56:22 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id b190-20020a3767c70000b02903ca0967b842so2852464qkc.9
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 21:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=qanCpgG6K85LtNMV/pCVVA2s8D8zJvxN6mc+87zshdI=;
        b=o5zN41efKx806Jn7dtKlx4vQuz7KW0nR6lpqWhcBhYLL8JH7DK2RSoIuDgxsMa45da
         faKc9y9iEm0czZ4VgYcEAKFOO+QKCxGJRXtn2Iyo60ydQebd8xwXGs1z5JGQrFi0V/Jt
         cpzoKYeB1hFJ4/CsG+V53GYNX9nJqZKaUIACW0myQ7vpPeDF30OBW0zs57rDq0G/wn0z
         BPcNsjqj9wpKrz88IL4mBDUTSy1cADU1GpwFTVpzUo0qmo344JGtlhUm0pjJyCIT3tqd
         1h9X2/A1NJueGpanbKdKEFLqPbJ4T1q1Qbmm764qSAz06/+jEKz+Q82iOhCI/jnYZjko
         EPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=qanCpgG6K85LtNMV/pCVVA2s8D8zJvxN6mc+87zshdI=;
        b=DfrzlYeANyw4uJSQcE3J64Ijzbzrh3RYUpFhkiQptJSqGCqRsLDOYhIE0OGxJGhnEp
         e1RF8/6Num1P6ERy0jo9k6S4gDAk2EzLwuPlRIg1IJBvN8nenvI1TqYU5pJSa9y+FVw3
         e/0or8EKGoCoCLq/HjfKd1pZfXMcbPTYi7P/9xB6jCj6P2bFNM0Brn0lDTfFsq1bF2wI
         jAoycJ8jf5G1mF5GalnwET4nIgwLFOfW9FXs3pWa51esFcyFOtZK1nMfcT9YfyHi1q0N
         D1s2uK05ooCkqyXLYnfA/tMl8IKNJL53fQT5y1BYdyvc9WuL5deW0J8bcJjrv17b48Jg
         ptAA==
X-Gm-Message-State: AOAM533eBtT85Cc2jVR7iUFhMGUmNPzNB2/EtCNULpEo78ftMMeVmPR3
        CKxRepuwgIRNJpwYZa/0VbDgZ73UB1A=
X-Google-Smtp-Source: ABdhPJzkgLj6qwyYzeVoo/P1gKsjQtvMJImXKFL6Pf4wPg7ocSsPdlTAZezWiJFVjnfGiU/oEMFunsTOs+s=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a05:6214:285:: with SMTP id
 l5mr2089662qvv.24.1628744182096; Wed, 11 Aug 2021 21:56:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 Aug 2021 21:56:15 -0700
Message-Id: <20210812045615.3167686-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0
 wants a #PF
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vmx_need_pf_intercept() when determining if L0 wants to handle a #PF
in L2 or if the VM-Exit should be forwarded to L1.  The current logic fails
to account for the case where #PF is intercepted to handle
guest.MAXPHYADDR < host.MAXPHYADDR and ends up reflecting all #PFs into
L1.  At best, L1 will complain and inject the #PF back into L2.  At
worst, L1 will eat the unexpected fault and cause L2 to hang on infinite
page faults.

Note, while the bug was technically introduced by the commit that added
support for the MAXPHYADDR madness, the shame is all on commit
a0c134347baf ("KVM: VMX: introduce vmx_need_pf_intercept").

Fixes: 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT violation and misconfig")
Cc: stable@vger.kernel.org
Cc: Peter Shier <pshier@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..8bcbe57b560f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5830,7 +5830,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 		if (is_nmi(intr_info))
 			return true;
 		else if (is_page_fault(intr_info))
-			return vcpu->arch.apf.host_apf_flags || !enable_ept;
+			return vcpu->arch.apf.host_apf_flags ||
+			       vmx_need_pf_intercept(vcpu);
 		else if (is_debug(intr_info) &&
 			 vcpu->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
-- 
2.33.0.rc1.237.g0d66db33f3-goog

