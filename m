Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E854BE19
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357810AbiFNXFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242908AbiFNXFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:05:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13254FC5A
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u6-20020a63d346000000b00407d7652203so3708488pgi.18
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3d7tD77H5O2xlb02j7y43iDUfTOkQ/XeZFOmeDGAico=;
        b=tR5DLGM9/pa1X/VPkRpGjyP5Rnk93Bm7RSfQjLOY2sNbFAo4+DUaz+VhvYZeMv15+l
         ZMimhzuqcXRgXz1jmiLiyGAPdYLgvUT9AZRNWYSojENt4OH8Ir7O8632yquqN7j5OGpF
         UVDHGhnmxG69JwO74Q940WYXAHK52i9UA9N4f7CemEYZ2TWpxckxki/9n5NOaOKItMMO
         Be5B++qiW36YDr3SUpquYrUQwJRG5EUW8QPW/21fca1JPEt2QVlTjuQj8gWTiDoFThPL
         ConxYO/fY73tlZP6GfjZOM2rczcqOMOENFX5uGvuqoA6PVzMLG/3y1Ni9/q5OOXq4bNj
         9cpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3d7tD77H5O2xlb02j7y43iDUfTOkQ/XeZFOmeDGAico=;
        b=u+gY2XvKnUBrjXBKXpYJuazGPCVWyxSzpzuNx7AIOm2/8MFHzd5YqQ/lUpl91+Xv2t
         5SPGvK1ajjw9zkZGyoaJEAUnMjoG2WFUIBDGjuZyjvmxHgu6hKc0x+OPAm1eGr7A4ku5
         NDOXYHj23J+T+AsQJhdrqgtZmQr5RQxDgb3jrwSeuiIkEe7tDSFd5/LfalD+AkX9mZg0
         qJ6yWkVfTWqw2B0X7HCkX/Ij/cF0/FyqIGkJA3vkXj7DqKOb2wAUmjxv8dTJLrRliTdB
         e2PUotYffT9RQSb7zX3F7a715yzhz5DhJvvvt4cdtwt7SNkxHyDcJdqBPMVL+mK4HE2n
         tcVQ==
X-Gm-Message-State: AJIora95yO0JGrSfyREnzheFho7k+JmqA1+0Ck4wXHuUJINKpyckPdPV
        nmQcUp+KaxyqODn/m3tPEnSa2fC4+mk=
X-Google-Smtp-Source: AGRyM1tnSW/muwqIZhXYnOKJRS3lRWAomzqILjlJIGjgy36gfPaXSzFNyMBMb/S1SX6iVfNJDsd8fuf8hhY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:db0a:b0:165:1299:29ea with SMTP id
 m10-20020a170902db0a00b00165129929eamr6314130plx.15.1655247952491; Tue, 14
 Jun 2022 16:05:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:05:44 +0000
In-Reply-To: <20220614230548.3852141-1-seanjc@google.com>
Message-Id: <20220614230548.3852141-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220614230548.3852141-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/5] KVM: SVM: Drop unused AVIC / kvm_x86_ops declarations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop a handful of unused AVIC function declarations whose implementations
were removed during the conversion to optional static calls.

No functional change intended.

Fixes: abb6d479e226 ("KVM: x86: make several APIC virtualization callbacks optional")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 128993feb4c6..d51de3c9264a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -617,12 +617,8 @@ int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
-void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
-void avic_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
-void avic_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
-bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 			uint32_t guest_irq, bool set);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
-- 
2.36.1.476.g0c4daa206d-goog

