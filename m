Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF996616DD5
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 20:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiKBTa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 15:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKBTaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 15:30:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6BC659D
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 12:30:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so9565118pff.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 12:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4mfNKilwFmWrqa2spYtO5Tj25NqUdCGG8fx/ELXfW3g=;
        b=hhK6C71gMmgCuhyKE25DVYTKUHSUUpT5xEYkm1oWFozn/GMGCDvp3A4t4RmXNVxaaV
         YWZdMzV2pCTe90Zn/na6/OD8hPoDn73YxV4ek+H8NFrId8pLGs9gB15H/I13eQBbfx03
         Zq6aRH94hVD2SytAxjwfY+Ri/baAKSJ3od+LHlYlOX9tmS6OfREqelFSknh3W5pxgFBQ
         qh6aafaql1y7CMtxFYjFwYw+YXOq7TNxfstUffyK70SfuaA5n68E6m6wAQ3ojftVQnMk
         EbYETIW/CyYkeJyEUoUKENpYhHAVRBVMKCmzAJZQIkUpXXbjG7IGT+BspHKzZoRUyKbw
         QGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4mfNKilwFmWrqa2spYtO5Tj25NqUdCGG8fx/ELXfW3g=;
        b=XEwYegVFrvassvgcCTBHosrggtSw2nTubj+3N9aUC24IZi2HS6nHPRB8BBIN2YgTfa
         +yoETpzbhOcgmUjDWHGdWFDslLu7N2fSGQbMKBYbgdMeIexlc+RtztLUpxZmKT9Sfl2l
         0F+sdIdjTkhyw07MBUxxAfiOVXF1S7RoG7lKk/Adc+u/vq7NPC1ykp5ytGllzHNp5Wxv
         y1EpR9/9iZsKQrp8uPu3AHXL7mVsQgP4HZYM48efQizxFBNdOLCp+FTeSDZJnnA38lWz
         34tqYRvFq0LVepltzJ5b0GWfKkR+hSKG2rZIXPzFTTtsFS0uUMSDum0OZr9G1if5oYjM
         6NAg==
X-Gm-Message-State: ACrzQf35k+YNKoavtUpcown290J7WnHZfmVDixMMI+BvjGSeTZHfF1TR
        xmYj+Uh3t8p0uNZ2DVxgJFvWc4LF6Pr3
X-Google-Smtp-Source: AMsMyM6Jl6QZZ8lvOVzndcSJfSzMoMifS9JXraVtV/8BvsFPPKWh2/05r04l+hviMGWLAssl3ix1QT/J950k
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:aa7:9099:0:b0:56a:d3f0:a013 with SMTP id
 i25-20020aa79099000000b0056ad3f0a013mr26991991pfa.26.1667417424554; Wed, 02
 Nov 2022 12:30:24 -0700 (PDT)
Date:   Wed,  2 Nov 2022 19:30:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102193020.1091939-1-bgardon@google.com>
Subject: [PATCH] KVM: x86: Use SRCU to protect zap in __kvm_set_or_clear_apicv_inhibit
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_zap_gfn_range must be called in an SRCU read-critical section, but
there is no SRCU annotation in __kvm_set_or_clear_apicv_inhibit.
Add the needed SRCU annotation.

Tested: ran tools/testing/selftests/kvm/x86_64/debug_regs on a DBG
	build. This patch causes the suspicious RCU warning to disappear.
	Note that the warning is hit in __kvm_zap_rmaps, so
	kvm_memslots_have_rmaps must return true in order for this to
	repro (i.e. the TDP MMU must be off or nesting in use.)

Fixes: 36222b117e36 ("KVM: x86: don't disable APICv memslot when inhibited")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd9eb13e2ed7..6d853e5f683d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10091,7 +10091,10 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		kvm->arch.apicv_inhibit_reasons = new;
 		if (new) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
+			int idx = srcu_read_lock(&kvm->srcu);
+
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
+			srcu_read_unlock(&kvm->srcu, idx);
 		}
 	} else {
 		kvm->arch.apicv_inhibit_reasons = new;
-- 
2.38.1.431.g37b22c650d-goog

