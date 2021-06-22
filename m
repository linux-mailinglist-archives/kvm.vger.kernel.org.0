Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250313B0BF7
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhFVSAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbhFVSAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:21 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9964EC061767
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:03 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id a12-20020ac8108c0000b029023c90fba3dcso91114qtj.7
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=w16oYt0iKSKWOMspUVtVlE9oFeOTkC9A/TBUaesRgr0=;
        b=wCOY/2V6r5LJo6VUNy2t44U0CjXGUf3gp6SBDvliT/3aYksK7+5EpnjfV9JSvomODP
         PWWEKUodU01x8l/Vvcph3qX209E0sO2Er0XB2uhDIJamudunocqSTJLI6Xpjl4bsWwDs
         MyIDrG0HlvNBZmPuqCT+D8pGut1jyt33Pltp2xkYpwAWfxnNyFbX5Xd8Ake35zHAFuri
         KeGgu+iC6tX8yKIKY9uUPKrTSDAa0B8HTEtI7dAIkvW1NNBikB5TecyW9aChHYvWollr
         5MWTYG6E5bRRagwBcZueQPspSBil5B/Rlgs9CA22GODgovTWQA+WrDkZl6G2DK/8jsoH
         970Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=w16oYt0iKSKWOMspUVtVlE9oFeOTkC9A/TBUaesRgr0=;
        b=VAxWj5mLtDGuZjVGpe6k9fAqkPAo7+jA3v0ObVQBfXWuO5fFhtrLWuyABjubu8ieFb
         6tGjk1smMvlPlm64GIAuYboU3Vje0/+qZcdm7MTbYuqoFJeqXdeNGpdvYWKtPJ6sT6Ds
         OEpMj7p8JpKhIunOyQLobRLcHrPKj9jefalK6ZB2DYLKhZ85PJKOyFhBMYoQP2sfyFtg
         ZeTzOkHdr+Xj2rVGSKUsc/NR67op976K2yT8p3vSv1pn4t2jBNEmoVvIl1sy8I4Ed5EM
         2Oz5H9Xxz9FCRxxVVa9oNicMMFw/HN+0wEnVTiodU2M3ORoWGmp3c7DfWj+umVHDCSAw
         mxLw==
X-Gm-Message-State: AOAM533UEknacXhnKvUXeVIttEUNDYCZuxF976/UJLtvioTrlNuaMklQ
        hX/lt6J90cUtdbVyCEFjTksyPFM0PQc=
X-Google-Smtp-Source: ABdhPJzhjd9weDitq99P+aWf5UUwgjWeiPEDbkdiLCgMwTr/Xsn4umcE0nX1tvL+mom4QsYOUvRMv1sS6PY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:ab6b:: with SMTP id u98mr6473219ybi.98.1624384682743;
 Tue, 22 Jun 2021 10:58:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:48 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 03/54] KVM: x86: Properly reset MMU context at vCPU RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset the MMU context at vCPU INIT (and RESET for good measure) if CR0.PG
was set prior to INIT.  Simply re-initializing the current MMU is not
sufficient as the current root HPA may not be usable in the new context.
E.g. if TDP is disabled and INIT arrives while the vCPU is in long mode,
KVM will fail to switch to the 32-bit pae_root and bomb on the next
VM-Enter due to running with a 64-bit CR3 in 32-bit mode.

This bug was papered over in both VMX and SVM, but still managed to rear
its head in the MMU role on VMX.  Because EFER.LMA=1 requires CR0.PG=1,
kvm_calc_shadow_mmu_root_page_role() checks for EFER.LMA without first
checking CR0.PG.  VMX's RESET/INIT flow writes CR0 before EFER, and so
an INIT with the vCPU in 64-bit mode will cause the hack-a-fix to
generate the wrong MMU role.

In VMX, the INIT issue is specific to running without unrestricted guest
since unrestricted guest is available if and only if EPT is enabled.
Commit 8668a3c468ed ("KVM: VMX: Reset mmu context when entering real
mode") resolved the issue by forcing a reset when entering emulated real
mode.

In SVM, commit ebae871a509d ("kvm: svm: reset mmu on VCPU reset") forced
a MMU reset on every INIT to workaround the flaw in common x86.  Note, at
the time the bug was fixed, the SVM problem was exacerbated by a complete
lack of a CR4 update.

The vendor resets will be reverted in future patches, primarily to aid
bisection in case there are non-INIT flows that rely on the existing VMX
logic.

Because CR0.PG is unconditionally cleared on INIT, and because CR0.WP and
all CR4/EFER paging bits are ignored if CR0.PG=0, simply checking that
CR0.PG was '1' prior to INIT/RESET is sufficient to detect a required MMU
context reset.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76dae88cf524..42608b515ce4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10735,6 +10735,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
+	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
 	vcpu->arch.hflags = 0;
@@ -10803,6 +10805,17 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.ia32_xss = 0;
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
+
+	/*
+	 * Reset the MMU context if paging was enabled prior to INIT (which is
+	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
+	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
+	 * checked because it is unconditionally cleared on INIT and all other
+	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
+	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
+	 */
+	if (old_cr0 & X86_CR0_PG)
+		kvm_mmu_reset_context(vcpu);
 }
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
-- 
2.32.0.288.g62a8d224e6-goog

