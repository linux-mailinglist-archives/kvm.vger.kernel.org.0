Return-Path: <kvm+bounces-67846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7C8D15CD3
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8AF0030242A2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 23:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F13C283FC3;
	Mon, 12 Jan 2026 23:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WSPQicZb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554F27AC4D
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768260490; cv=none; b=tFMnJzBDxhW4dVvSqWuJ3fr+PAlXAf4sPxPqdcMxpzcJKDGIk1UIRbQCdW+JkMxDt/eyYv5jn53QTqTwjSjosMuUCF39Vs9N1/Qf6gbDioj82VfAjkuHZPG9rEfd+nAklU0CGVywIG+2M4/C7hvjxdynmhsV3hD4crhwOdlTCJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768260490; c=relaxed/simple;
	bh=i1FgT2KkBAzlGWwTWhQV19SVFPmH3tqhTRqToUB+FL0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=P9mUFECAgiOXbyZwLG8YMb5cBE6cM7nqni2FkvSq3q5lCJ+6SCQ3gPu7d/PRMYeByuXbYvCZ6w7yNufwq/LwDmnOgbo48AUQnuy9CsQ8iqQrWuwDvLBhaFuxVNnZ1yyOHe7pQtP+JaEVsmzpkHmSOGaiDcVwgRrPlhVkCpaRFMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WSPQicZb; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d058fc56so56752175ad.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 15:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768260488; x=1768865288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Al+fnSBeR94EhBCD4DhJYbBsNosAL5fZnJy+evBGpLU=;
        b=WSPQicZbCBGSVR7fEzI8HBhCArmA/xwHaZ9JhX5bTyn3wPY1Qb48wD79nM+vNsZcqk
         c85aGJmveW9NuIuxSaXXc6qjb8Jd1IHkv361P7ks3jwlIuAQlmxg1yiCnleJpxZD19wU
         r6U4kmp6RcTtQJj8/dc+HmM6pq+SPofLRfPHayPcYQjnsaiwLZWX8ohwUmBrRD5WmVQ6
         7WUeorx80Erzg/5P2Af3uqQiUelT9ysrlqFFPRAHtQp1+RfeM7+BtQTBCk5Ocf5ktRFg
         wpmC/vmhM9mY++KNU+roQgB2U8ZnLRIiYXceYeb6m8gCklRwUEAaOyG/9geybZtfGZUl
         VcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768260488; x=1768865288;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Al+fnSBeR94EhBCD4DhJYbBsNosAL5fZnJy+evBGpLU=;
        b=ESqLbH9xp37KudQcrsTpoEm6VBMAHc4XZTUYMqsGuLR01s/COUsaonjDiOqFTIuenB
         FxS2ufERWReIwfK+GIQhkS3sSRuEehiqFoC+gpRSD2uDtzKWyVehoxj9FM8ll0fLVPnp
         5h+LdovvUsMvKcpW5vs5ZPShgUY2TwksgRCKCbThOU3Z1e8MzXoDtaPKDEhyLE0y0FS3
         hbRbvgKGbixh12ZuqnpPjBIVdO5F5g36p7vKi1UnNMO1AbE+8h4DJRnTuqKGQv3klAz+
         jjuKZUbUz0UIrPmJqdRB8xENvnEFcyEBveAD++Pnjt2h8nSLDe14prqHKeb8bsFEhiNw
         QSvQ==
X-Gm-Message-State: AOJu0YzyccxaPq+bMLnifV/O8cgp18s7eWf5m18Vy8gYc73yaNhm/sEb
	eKDnxE+b46R4X9k4bYMLpARNj6+WZ1jgCexQ0oxHyUt2GpNWbXydoXRSBiPIX9vmkO0lWHqMXog
	W5IvS4Q==
X-Google-Smtp-Source: AGHT+IGOIbN80r8vWHNwzUMJvpuio0e8RSJ09Va0qih/FIvZBUT+/83z+mkvfCiT1PFbxkM+F9xoI79gr+w=
X-Received: from plaq12.prod.google.com ([2002:a17:903:204c:b0:2a0:9081:40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:388e:b0:2a2:f0cd:4351
 with SMTP id d9443c01a7336-2a3ee4e85f6mr168852835ad.37.1768260488524; Mon, 12
 Jan 2026 15:28:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 12 Jan 2026 15:28:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112232805.1512361-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Check vCPU ID against max x2AVIC ID if and only if
 x2AVIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

When allocating the AVIC backing page, only check one of the max AVIC vs.
x2AVIC ID based on whether or not x2AVIC is enabled.  Doing so fixes a bug
where KVM incorrectly inhibits AVIC if x2AVIC is _disabled_ and any vCPU
with a non-zero APIC ID is created, as x2avic_max_physical_id is left '0'
when x2AVIC is disabled.

Fixes: 940fc47cfb0d ("KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode")
Cc: stable@vger.kernel.org
Cc: Naveen N Rao (AMD) <naveen@kernel.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6b77b2033208..0f6c8596719b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -376,6 +376,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
+	u32 max_id = x2avic_enabled ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = vcpu->vcpu_id;
@@ -388,8 +389,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	 * avic_vcpu_load() expects to be called if and only if the vCPU has
 	 * fully initialized AVIC.
 	 */
-	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > x2avic_max_physical_id)) {
+	if (id > max_id) {
 		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
 		vcpu->arch.apic->apicv_active = false;
 		return 0;

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.457.g6b5491de43-goog


