Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C977301162
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 01:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbhAWAHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 19:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbhAWAF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 19:05:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1B3C0617A7
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 16:03:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i82so7078574yba.18
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 16:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=x5xkXxx84p9RzI8TFc1X+Kwfm7V0NmvnOTKFNhy6a6c=;
        b=hNELuhTUjCVTl1K3vgCXtv2OmygDlXZZMIHBXiF4NSWReX9YgiLK9QGt/C2KY8KcPP
         aZPPtbcse9xlLMo3T0yJ8DY2sm9vOgvGzbsptq2caDtMJMgYACqJQMWyUXQfp4qhp6pL
         z74M0ZW82+QabmOxRReAGtzgSupkxJeZc4sPGgsATF06bEcwm+TF6AvKpMJix4tkty9E
         Wwss1QQhyXT+EslO28LYZJLI3b4gWGtsxtMp24EeV2ZwzObOBlXxhwR1svg0xE3SGwOB
         hrLb2mvyKxeWOhPM35/mE0mfmhSraAUHYMirq6P0uQZRmPxkQY4jHBh4bj8mwW8cwIZZ
         NKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=x5xkXxx84p9RzI8TFc1X+Kwfm7V0NmvnOTKFNhy6a6c=;
        b=FYWshYKTF35K5axEkYgRG6UqjUim3IWDCnTQZX9QVXFWRQAeuN3TiKATNCEfilMAVY
         C7QKWSgD2w+ag4pXLQrMUo04iA1LIGOeIb/1hY1JRqrBXuce8qaVj/EFf6QktUJLooXq
         sbDVcf4ZgHociai7pkeGNinyLvF0YwHDESCd8PitQr3CK8PU1S1mPhJ5ZhKtTR4B/9oa
         qc7GPpEaYovi6lOB0aml37pOAF2nMMHQOmrpOuHW60rzEaRaqlFVuujlXUEvKCzB7PG6
         zjunGQ4Knsv6+nfWDDeTDAEg78TFVoZGgVDOotBel6u6V4Kqan2IrjxxltVIoprEp8SF
         7u0Q==
X-Gm-Message-State: AOAM531lR6R9mRUTHgCK55q+c8qGXyrbRmA9s2iPRDFUHEcd9cVUZvwi
        oGND/++AbsvLrXjO5JUZh1T+DdpsOu8=
X-Google-Smtp-Source: ABdhPJx9gAT03BywYIvsAG5zPAl13fqtU0y68UjtDee/aUsIAdLkeTaznS+Sv/hzWYgpcdJJ8go6OvhsEG8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a5b:987:: with SMTP id c7mr10173174ybq.303.1611360222571;
 Fri, 22 Jan 2021 16:03:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 16:03:34 -0800
In-Reply-To: <20210123000334.3123628-1-seanjc@google.com>
Message-Id: <20210123000334.3123628-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210123000334.3123628-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 2/2] KVM: x86: Take KVM's SRCU lock only if steal time update
 is needed
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enter a SRCU critical section for a memslots lookup during steal time
update if and only if a steal time update is actually needed.  Taking
the lock can be avoided if steal time is disabled by the guest, or if
KVM knows it has already flagged the vCPU as being preempted.

Reword the comment to be more precise as to exactly why memslots will
be queried.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f4b09d9f25b..4efaa858a8bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4005,6 +4005,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
+	int idx;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
@@ -4012,9 +4013,15 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
+	/*
+	 * Take the srcu lock as memslots will be accessed to check the gfn
+	 * cache generation against the memslots generation.
+	 */
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
 	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
 			&vcpu->arch.st.cache, true))
-		return;
+		goto out;
 
 	st = map.hva +
 		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
@@ -4022,22 +4029,17 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	int idx;
-
 	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
-	/*
-	 * kvm_memslots() will be called by
-	 * kvm_write_guest_offset_cached() so take the srcu lock.
-	 */
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_steal_time_set_preempted(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	kvm_x86_ops.vcpu_put(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
-- 
2.30.0.280.ga3ce27912f-goog

