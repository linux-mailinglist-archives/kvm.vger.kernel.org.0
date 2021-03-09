Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C731A3331A4
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 23:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhCIWmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 17:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhCIWmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 17:42:17 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F44C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 14:42:16 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id a137so7631252qkb.20
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 14:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jqjq7puvtL0+ga0HuFQpzwZNP4hDc6vknhUQK/X+oMw=;
        b=I0eo+9L92BVeyfv6dDH7KjilCQ4pfCjUMQHAfM5t8DT+rxH8lYDLUma2uZVpo2Br97
         7p7DtEumdV6Tmo+usLGGhysXjKj6dRROfrOYx+b15g54qb42SaQqwB/wcP+eV7TFghU9
         bTM0Gura1XQVSv7L5/xTQf/u4kQyqRI+1OvG5TsLh9mhwT+fKRMYL7yxTeYZDdCgz0j2
         f8+ceYieNVEM1BMTYu2x1nAkiMGuxC8LCuoegDLlGrYbhVXz+11U6Lr66dpyiU6aR0MM
         nQah7i1eTWSkctvdaop1gcfQ7Te9gnZaQ1BBonICq2HkuEVeudCJp9JbQA7HErhb62Q9
         hzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jqjq7puvtL0+ga0HuFQpzwZNP4hDc6vknhUQK/X+oMw=;
        b=daKLNgtEt9Uyj7z7Vr3kDATKNLGodMdTzRlTv3XXeTdOJxsS4Sx+7ky2lfkkYZctL4
         8WQx8CHrqFN5VyzS1VPonXwFlEVizPNYKr5H+oj/sH6N9xJJNiVmozvj7IAiWcKyHhPT
         dmDCKIz0gifJmNVCp4ZjBX07FRlIeUmHx2SC48JlCIFCvzcEbHAni4p2J0gSZIlK0qww
         Sc1zho2h0W9PbhhUZwlQd2onU3F8fxol1Ay+Vr0k21O83Y8JAwzoxuQKTswWrG+dlNm+
         c8LKhWSK0SQ1Z4OGHQ8jsvpK+DHTZmPBY/KODlJR8nkYgA7XOsLaPEkClUOzEYWgXVOd
         afXg==
X-Gm-Message-State: AOAM5314g5Q4wOI+bvn2J9Jg80sXkAGmY1ZY2KgUXoQKBNRABIZd2h4j
        oZhAnOegKOPt490ecQYheqRjLEVPXu8=
X-Google-Smtp-Source: ABdhPJwllIw+8NYZW3YKP9LbR1K0QGHsG4bfAG2l3fxbO2x2sl1+nVYjajHPSfEmZX67pEmhYIhAz+ospwA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1744:: with SMTP id
 dc4mr351626qvb.40.1615329736032; Tue, 09 Mar 2021 14:42:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 14:42:04 -0800
In-Reply-To: <20210309224207.1218275-1-seanjc@google.com>
Message-Id: <20210309224207.1218275-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210309224207.1218275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 1/4] KVM: x86: Fixup "Get active PCID only when writing a
 CR3 value"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Fix a merge conflict gone bad.

Fixes: a16241ae56fa ("KVM: x86: Get active PCID only when writing a CR3 value")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7876ddf896b8..58f4dc0e7864 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3907,7 +3907,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long cr3;
 
-	cr3 = __sme_set(root_hpa);
+	root_hpa = __sme_set(root_hpa);
 	if (npt_enabled) {
 		svm->vmcb->control.nested_cr3 = root_hpa;
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
@@ -3916,6 +3916,12 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
 		cr3 = vcpu->arch.cr3;
+	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+		cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+	} else {
+		/* PCID in the guest should be impossible with a 32-bit MMU. */
+		WARN_ON_ONCE(kvm_get_active_pcid(vcpu));
+		cr3 = root_hpa;
 	}
 
 	svm->vmcb->save.cr3 = cr3;
-- 
2.30.1.766.gb4fecdf3b7-goog

