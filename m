Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A36D3C74E5
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhGMQid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhGMQiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5856C0613B8
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:41 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x15-20020a25ce0f0000b029055bb0981111so27838099ybe.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vIWc55IJyEVoNC9ov84IeWMlOnEp9DjAfbK1wsM0Yas=;
        b=EHc24xcXcaRLUjqC/SA/M1jyyqgnl7dGPNghNeAJo0E8DqPiCbfriPxhy3OM70O3wi
         b81ZekWmOvgC2OLvhY4OmkiUxUqGhMlM4Z7mrJoknSobg/b/DU5ks4sxiwwRaq7cN3Gs
         6WS2YVOAU0Z32iJccqc2e/9cTiahvi6lpKHnkEoPIy/j0Y+8gRXRYMnGIBosd946LE3S
         sfgYQIalCI+kyt04wGn1isr9y/6HMebU/Sjs/nrDtLPHAdDsygLgR5yipsoOYKoSt8Js
         rHQhIp9br2v/hoB6vYN46MnTpECYYWqYHaXxkAyayCvMU+TrvSGU3ObdRW0HZy+dvILY
         NKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vIWc55IJyEVoNC9ov84IeWMlOnEp9DjAfbK1wsM0Yas=;
        b=UxTJJmm2snBvgx5qUjn3kpjbOR+pMVDKvPdFZ80Wbg1D8zu2J8zbqd9w0Th0zaRcLZ
         KNIEXwK/rmWLJCI9YYypnzoBbIs1suF94C7LwROYnymTGgBXJ7ZFnL0vbpqTzwr92Lq0
         /nnews72v6gML3bxOh//nZGU/T+b0oNPV3aXzL1vREwM63EN3YvgzyQ24Ww9/zqGmy0F
         hW19jS/fvePpr6HlpVg2iW9Lr0nctD996GQXYUIBB4rWJsVzqoZZJmuvtziokbB3e7FF
         fbjT2+6v1u3FPAUBQ7L4ALoMxmAnieaOWSO1VasrVj9AJaQdXjTiDChi/wTn2VtJnAk9
         hljQ==
X-Gm-Message-State: AOAM533JbPlMEOkm0rV45qA5KPiCZif9ubEH6E1QqwYipzl4QFI74OcZ
        KNFqaDa5CkrjD5mYASS6S5AlFFtdFSQ=
X-Google-Smtp-Source: ABdhPJxqtfpMYERsHaOr+5vEs9x2n03DLrMc9aG60KPKlR/Yj/1lPr/5wO9Qd4ZHkQ90BdZUtkmmGF4rChc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:d97:: with SMTP id 145mr7293842ybn.276.1626194081024;
 Tue, 13 Jul 2021 09:34:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:13 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-36-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 35/46] KVM: VMX: Don't _explicitly_ reconfigure user return
 MSRs on vCPU INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When emulating vCPU INIT, do not unconditionally refresh the list of user
return MSRs that need to be loaded into hardware when running the guest.
Unconditionally refreshing the list is confusing, as the vast majority of
MSRs are not modified on INIT.  The real motivation is to handle the case
where an INIT during long mode obviates the need to load the SYSCALL MSRs,
and that is handled as needed by vmx_set_efer().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3045daa3ec30..555235d6c17e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4406,6 +4406,8 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->pt_desc.guest.output_mask = 0x7F;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
+
+	vmx_setup_uret_msrs(vmx);
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -4467,8 +4469,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	vmx_setup_uret_msrs(vmx);
-
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
 
-- 
2.32.0.93.g670b81a890-goog

