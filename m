Return-Path: <kvm+bounces-30828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3B29BDB75
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7958C284BFE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 01:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F392E18C03D;
	Wed,  6 Nov 2024 01:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ys5ScLeg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C118B463
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730857900; cv=none; b=Pi+og0o8gJhyCRz1fNmQYou0SAHhsRI74Z/3dF4aVpPGqTiCGB87mFj+9zNtqLJmBhtlqruSssu2Nu6MKh4tXANGN9H7ESpHHAkQbWX9QSzwGeyAUO/7fxgd/4nY1kXR+Gd47Tjyg1hlqRBPNPL1Hma43Sl/IHpeM/ofl8GpeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730857900; c=relaxed/simple;
	bh=0cfREXYBv/O6QXSpQyDtQ6EZkt8ICo8sWJAbzDYUgA4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qqdi5LFSTnQ4hfPlvdRIlPMwVVjmKIZdiJCamKCpC3/f4MF6LKjYRVwzVv2Dkdu6rTkmU8VqE4/Izpu3c1Nl0FQd+5XBtPfuYHchCncBjJWPiVfvJ3QOCeLoEqHowmtJpeuRUMMriy5dNMfvhWYDiN3bLZIyU7Hn1wqcJzAOAAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ys5ScLeg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e59dc7df64so5239447b3.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 17:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730857897; x=1731462697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsVWtySqNFgTVWgHXk6f3n0Xscm8CdqH5W1OuzF+xZg=;
        b=Ys5ScLegXytCfTIyxOHU6c0NqGJlq5OBzFLvKvwYFGEa7kvZe5l3CWVNeKfbtx5+y4
         iUTF0xZOFboOHe3Ol+MpfZnt+gPJHVwwmI3kH9CHtpp6SOHlMfQtfac5QpSo8XBS+eoa
         OVkVIY9s7J+/z3sQ8mg3/WkWcwWp6wdVJu2F2xkKIonvPPUQBmxcpITxu8dPixAUUYUl
         Ob0sXG3PaGMgx+Q9akH6M/8C5QtmLXkCXJrqauhaUzDm/yBEAthlx9X+ecJPuCHxMn7E
         /u4tS3DdaG3nfPtH5ECEp/yKdp4/eJgI7lfWG+YS07pIug0CQwByqkU9J0sNHgTiJGBQ
         i3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730857897; x=1731462697;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsVWtySqNFgTVWgHXk6f3n0Xscm8CdqH5W1OuzF+xZg=;
        b=cZZb4C7Zcx4/zIVvMl+Dqj+ZJnkYHHQlDYfOmmPRuLQ0Z3VnCKznoov9v7EAWV5+5l
         nU5ZvOpXNWxkLu1MvcFW2ySiDVZGC6B08WauCOvGQ9Zbw1ZoJlAbW35nECyRhCxo26jz
         if1blUuIxurJ0ZB1plLfLbwizx9Oz1KmsY7AxbuA5VuBgY/kd4P6iusI9VjA9FXjXy3x
         qi6GLtWN9A6E1t1YGOxv2XizMrBoTp55RePX4cYMNAawjeiSgajsYr4hpwAwyQhzEsxt
         fGLGDvu54WLlOEDDVPMsANt3Eqon9IqObNOSMcPKSPZmnrwIMXyIgONHirWQMh0EnXLP
         zIlA==
X-Gm-Message-State: AOJu0YyOcLdQGBDytDdK4qqJGRFCuEzSk2M3yqoK8Ozl0J2auSr9LQY2
	Oy3gxSvxVISKGT460KNBM5qJZm7YGLbQqU7UcNJEJ8aL3GNMbN1LRXinlVKf0qZwodgHgQ5hWdn
	H+g==
X-Google-Smtp-Source: AGHT+IGazWVeu0FiUgVNQ3537CJxZulfvjKMPsuJVlG1YN0Q7hnoVT4PImyk2lCO7WXJSsE83WQ9+k4BJSU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a81:8d0c:0:b0:6d9:d865:46c7 with SMTP id
 00721157ae682-6eabed866b9mr123877b3.2.1730857897571; Tue, 05 Nov 2024
 17:51:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Nov 2024 17:51:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241106015135.2462147-1-seanjc@google.com>
Subject: [PATCH v2] KVM: x86: Unconditionally set irr_pending when updating
 APICv state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Yong He <zhuangel570@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Always set irr_pending (to true) when updating APICv status to fix a bug
where KVM fails to set irr_pending when userspace sets APIC state and
APICv is disabled, which ultimate results in KVM failing to inject the
pending interrupt(s) that userspace stuffed into the vIRR, until another
interrupt happens to be emulated by KVM.

Only the APICv-disabled case is flawed, as KVM forces apic->irr_pending to
be true if APICv is enabled, because not all vIRR updates will be visible
to KVM.

Hit the bug with a big hammer, even though strictly speaking KVM can scan
the vIRR and set/clear irr_pending as appropriate for this specific case.
The bug was introduced by commit 755c2bf87860 ("KVM: x86: lapic: don't
touch irr_pending in kvm_apic_update_apicv when inhibiting it"), which as
the shortlog suggests, deleted code that updated irr_pending.

Before that commit, kvm_apic_update_apicv() did indeed scan the vIRR, with
with the crucial difference that kvm_apic_update_apicv() did the scan even
when APICv was being *disabled*, e.g. due to an AVIC inhibition.

        struct kvm_lapic *apic = vcpu->arch.apic;

        if (vcpu->arch.apicv_active) {
                /* irr_pending is always true when apicv is activated. */
                apic->irr_pending = true;
                apic->isr_count = 1;
        } else {
                apic->irr_pending = (apic_search_irr(apic) != -1);
                apic->isr_count = count_vectors(apic->regs + APIC_ISR);
        }

And _that_ bug (clearing irr_pending) was introduced by commit b26a695a1d78
("kvm: lapic: Introduce APICv update helper function"), prior to which KVM
unconditionally set irr_pending to true in kvm_apic_set_state(), i.e.
assumed that the new virtual APIC state could have a pending IRQ.

Furthermore, in addition to introducing this issue, commit 755c2bf87860
also papered over the underlying bug: KVM doesn't ensure CPUs and devices
see APICv as disabled prior to searching the IRR.  Waiting until KVM
emulates an EOI to update irr_pending "works", but only because KVM won't
emulate EOI until after refresh_apicv_exec_ctrl(), and there are plenty of
memory barriers in between.  I.e. leaving irr_pending set is basically
hacking around bad ordering.

So, effectively revert to the pre-b26a695a1d78 behavior for state restore,
even though it's sub-optimal if no IRQs are pending, in order to provide a
minimal fix, but leave behind a FIXME to document the ugliness.  With luck,
the ordering issue will be fixed and the mess will be cleaned up in the
not-too-distant future.

Fixes: 755c2bf87860 ("KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when inhibiting it")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reported-by: Yong He <zhuangel570@gmail.com>
Closes: https://lkml.kernel.org/r/20241023124527.1092810-1-alexyonghe%40tencent.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2: Go with a big hammer fix, and plan on scanning the vIRR for all cases
    once the ordering bug has been resolved, i.e. once KVM guarantees the
    scan happens after CPUs and devices see the new APICv state.

v1: https://lore.kernel.org/all/20241101193532.1817004-1-seanjc@google.com

 arch/x86/kvm/lapic.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65412640cfc7..e470061b744a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2629,19 +2629,26 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (apic->apicv_active) {
-		/* irr_pending is always true when apicv is activated. */
-		apic->irr_pending = true;
+	/*
+	 * When APICv is enabled, KVM must always search the IRR for a pending
+	 * IRQ, as other vCPUs and devices can set IRR bits even if the vCPU
+	 * isn't running.  If APICv is disabled, KVM _should_ search the IRR
+	 * for a pending IRQ.  But KVM currently doesn't ensure *all* hardware,
+	 * e.g. CPUs and IOMMUs, has seen the change in state, i.e. searching
+	 * the IRR at this time could race with IRQ delivery from hardware that
+	 * still sees APICv as being enabled.
+	 *
+	 * FIXME: Ensure other vCPUs and devices observe the change in APICv
+	 *        state prior to updating KVM's metadata caches, so that KVM
+	 *        can safely search the IRR and set irr_pending accordingly.
+	 */
+	apic->irr_pending = true;
+
+	if (apic->apicv_active)
 		apic->isr_count = 1;
-	} else {
-		/*
-		 * Don't clear irr_pending, searching the IRR can race with
-		 * updates from the CPU as APICv is still active from hardware's
-		 * perspective.  The flag will be cleared as appropriate when
-		 * KVM injects the interrupt.
-		 */
+	else
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
-	}
+
 	apic->highest_isr_cache = -1;
 }
 

base-commit: 5cb1659f412041e4780f2e8ee49b2e03728a2ba6
-- 
2.47.0.199.ga7371fff76-goog


