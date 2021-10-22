Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB0436F06
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhJVAvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhJVAvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 20:51:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194FBC061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e189-20020a2569c6000000b005be95530997so2230837ybc.6
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ObE9PuOmjSiDyzo6kRsoMECD2ta83fBf8p/lt2vHSmw=;
        b=HlqJoa7hbPaECClswzrdEKmhgYjMLv+FQfzpMD/C6bQmgC/kX+7RAjSgHgvYbrBnBt
         2fW3dccn+7ID+VXOboWNYiNHfoQ159W6NJpnIHPVDidpzLJKpwYLXJoVltSoiDNiHIZy
         ZoEKvtGbSGUfmqvVkBGB0PP7hTAdsL0XnzCDFuDqISSdGhTPSLr9BTOcttymuokUm3GL
         taJDHAzQQfDWih1xSylQNA1SsGJe/017WNtC3XiJlUjJahwgnpeBPqD6yBUbQzNdxG37
         9yEQogrlb7rBq63a7gM7pBbEx33gyq5tASEbFCQbWVyAHa0d22t0n4F5WRyLt7Gr3eNH
         42Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ObE9PuOmjSiDyzo6kRsoMECD2ta83fBf8p/lt2vHSmw=;
        b=Fns9JgeKfrjKLQsaN2xn+ESFVDgL3MCEOQsbSLXuWxXgpPXYAn9bsOcg4RV0orVquj
         xN6yyQ5Qdjk5E8F6WIdw3hbHXU+SFIMFFbLJffcmV4FsHbb2+vSEr0QBTj8D5joD+e23
         fp0jtiWYV6bSQKEPPx/271VhjOUmeR9yST/WlYWVysOjxiiS/CrZahqq98CxPlhRv56F
         bfGRJSMjzcg1rh1jvnPkVodYp2X9mFtEidGLtcKhw5UANtUyknE9Q6JgTNgCvhfNQ/FO
         B4/eP/At1yG4dAG4ZGlJldMaRx10+0kqgRnGjqJ3kWYtW0dIV2wXMNtM/ya8ymRs9+Jw
         5ong==
X-Gm-Message-State: AOAM532aA+EjjlJzxTc71VOhFW5ZyZav0+WTSZfTR7xkXYZTt1v3icCd
        evIWNXplU8L3G0or5oMCOxhN4YqwNkE=
X-Google-Smtp-Source: ABdhPJxQ+vCxZUT2x7thcuE/qbEwbVOROwt2rWXO8yA8WQC69sk9rUC1vGkD3f7XRr96TsLUS27fHGHHDis=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a25:ae8c:: with SMTP id b12mr4099105ybj.527.1634863774368;
 Thu, 21 Oct 2021 17:49:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 17:49:25 -0700
In-Reply-To: <20211022004927.1448382-1-seanjc@google.com>
Message-Id: <20211022004927.1448382-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211022004927.1448382-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 2/4] KVM: x86: Move SVM's APICv sanity check to common x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move SVM's assertion that vCPU's APICv state is consistent with its VM's
state out of svm_vcpu_run() and into x86's common inner run loop.  The
assertion and underlying logic is not unique to SVM, it's just that SVM
has more inhibiting conditions and thus is more likely to run headfirst
into any KVM bugs.

Add relevant comments to document exactly why the update path has unusual
ordering between the update the kick, why said ordering is safe, and also
the basic rules behind the assertion in the run loop.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 --
 arch/x86/kvm/x86.c     | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cee4915d2ce3..a2a4e9b42750 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3864,8 +3864,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pre_svm_run(vcpu);
 
-	WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
-
 	sync_lapic_to_cr8(vcpu);
 
 	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f55654158836..8b9c06a6b2a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9445,6 +9445,18 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 
 	if (!!old != !!new) {
 		trace_kvm_apicv_update_request(activate, bit);
+		/*
+		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
+		 * false positives in the sanity check WARN in svm_vcpu_run().
+		 * This task will wait for all vCPUs to ack the kick IRQ before
+		 * updating apicv_inhibit_reasons, and all other vCPUs will
+		 * block on acquiring apicv_update_lock so that vCPUs can't
+		 * redo svm_vcpu_run() without seeing the new inhibit state.
+		 *
+		 * Note, holding apicv_update_lock and taking it in the read
+		 * side (handling the request) also prevents other vCPUs from
+		 * servicing the request with a stale apicv_inhibit_reasons.
+		 */
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 		kvm->arch.apicv_inhibit_reasons = new;
 		if (new) {
@@ -9779,6 +9791,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	for (;;) {
+		/*
+		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
+		 * update must kick and wait for all vCPUs before toggling the
+		 * per-VM state, and responsing vCPUs must wait for the update
+		 * to complete before servicing KVM_REQ_APICV_UPDATE.
+		 */
+		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
+
 		exit_fastpath = static_call(kvm_x86_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
-- 
2.33.0.1079.g6e70778dc9-goog

