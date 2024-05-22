Return-Path: <kvm+bounces-17905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B95A38CB8DF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 04:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB75D1C22A0F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10E542A94;
	Wed, 22 May 2024 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cWGZLv6x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780125776
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716344081; cv=none; b=HEHj5RnLxLFirEmy/j7+8Z5szboKbdEXJWvu8CM0cMPpH8kJDEI82Hb+4uLOsE90CfJHmY40AyZVNwEx6oNR77AahM1M0KxZSPy3j7SjUr070cqlDPj+tampNWyUYUFInWmFD1K7P98swapjzLu7IUGftSHi1NSyd6n3ng5AQQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716344081; c=relaxed/simple;
	bh=mOxTe+E++F8S2tbt0996WsV27us8k9WBI3OFKOjbFco=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ktbJat/HXlNLAHEA4X1BrkClp8+H/nC2Nk/pAOOpBldc9oObIJfihxX0ay+7usfLgvIcSDrxUqZlZl4ZjkISeDWyOB5jVN+2dA4sHllt/dU0d5tPtDPQMylZfIAEIctutoOTVvFGUMkQUsxDs1nmCHshTby9oYATTZBxEUt4c5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cWGZLv6x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1edcfcaa2a4so129250745ad.0
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 19:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716344078; x=1716948878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j01ApSzLfLWeugLvYbNfycm5kQ8LSFPTpIZ3ydjqlb4=;
        b=cWGZLv6x1pwZNUgscxUkRsppUzKeJ3wfXJSsogcii8yos5xlLvi138kiBIjSYX8YjM
         GtcA2hoFyBlHTLdx9oFfx8SQ3klwlTOAZf0n4/X1ESQkvyf1+KXIyT8Hy1aZ/3ulL6z7
         e1P77ntYVJDKQnWRKACm3jx9jo7PPBryg6YidHv07lQKQOgSBwP2c3srDOBcNcQVcTdg
         VlZ/AXEUjzzZBY1zwvoNDN+hK9wyj5dUIjpd5Pvxge+/9P5zn1Ml66pJ7tLSik73Kzer
         8jB6zexbcYOHgDwFKiZln3rrN4JYi91udOhggpYgLZPNFLhuunufs269YfS/0T3dsiHz
         +IfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716344078; x=1716948878;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j01ApSzLfLWeugLvYbNfycm5kQ8LSFPTpIZ3ydjqlb4=;
        b=a5P3uKtMjvUiKabXpcJMUYFk4tTHtSZQj+GbZjGf1z8+gi8w1/nnnSpLoxrSY09wLf
         hjRm5RIixadJZ3qJGT8WuRtMUADz1uIlSWxcXabgoJDjcQns5tjVy+46pYsbdJddlw1o
         Ujof1KZjJcfqKugoG+udlx+9t670GpMMUpkWDgHow1uPB1t45laDSoWE8nq/fK9EhNV1
         XvsoJ/7VuPk7F+GHWBqWFaMKu3oowBIsN+unPwcjw4Q7gQOm5D6xlmMgCQcruEZr5fuI
         Rueh/+NMxK9R0FIEoOWtO22rhXmTL/ypN+yj8CnYVuqJ7q2P0x1kFjOLszBwI5vxm0Qg
         vrJQ==
X-Gm-Message-State: AOJu0Yx2noMFyniwcNekHbmD1x85mXdf2WICnJ3PRAF6cyGpEQRIstTw
	lOO2LQtdpmfwn3GeDSinJxV72fViIiLNye2uiimx2TYobHWFEtd8h9kP8rMLrlkQHzEuj2ByIqz
	imA==
X-Google-Smtp-Source: AGHT+IGPAGDZRpMyhotaZ/4745P0uWuN2B/BfHgM4qU9Ete2kPvmY5A1Vp8n9S7/6Tl2UzGVsKwDBg8tHvM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea0b:b0:1f3:1a5:bbab with SMTP id
 d9443c01a7336-1f31c9cdad5mr563865ad.10.1716344078310; Tue, 21 May 2024
 19:14:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 19:14:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522021435.1684366-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: WARN on vNMI + NMI window iff NMIs are outright masked
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Santosh Shukla <Santosh.Shukla@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When requesting an NMI window, WARN on vNMI support being enabled if and
only if NMIs are actually masked, i.e. if the vCPU is already handling an
NMI.  KVM's ABI for NMIs that arrive simultanesouly (from KVM's point of
view) is to inject one NMI and pend the other.  When using vNMI, KVM pends
the second NMI simply by setting V_NMI_PENDING, and lets the CPU do the
rest (hardware automatically sets V_NMI_BLOCKING when an NMI is injected).

However, if KVM can't immediately inject an NMI, e.g. because the vCPU is
in an STI shadow or is running with GIF=0, then KVM will request an NMI
window and trigger the WARN (but still function correctly).

Whether or not the GIF=0 case makes sense is debatable, as the intent of
KVM's behavior is to provide functionality that is as close to real
hardware as possible.  E.g. if two NMIs are sent in quick succession, the
probability of both NMIs arriving in an STI shadow is infinitesimally low
on real hardware, but significantly larger in a virtual environment, e.g.
if the vCPU is preempted in the STI shadow.  For GIF=0, the argument isn't
as clear cut, because the window where two NMIs can collide is much larger
in bare metal (though still small).

That said, KVM should not have divergent behavior for the GIF=0 case based
on whether or not vNMI support is enabled.  And KVM has allowed
simultaneous NMIs with GIF=0 for over a decade, since commit 7460fb4a3400
("KVM: Fix simultaneous NMIs").  I.e. KVM's GIF=0 handling shouldn't be
modified without a *really* good reason to do so, and if KVM's behavior
were to be modified, it should be done irrespective of vNMI support.

Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
Cc: stable@vger.kernel.org
Cc: Santosh Shukla <Santosh.Shukla@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This was kinda sorta found by inspection, and proved with a KVM-Unit-Test that
sends multiple NMIs while a different vCPU does a CLGI+STGI loop.

The WARN originally fired on an internal variant of the 6.6 kernel, which got
me looking at the code, but it's hitting something different that I haven't
fully debugged yet (the WARN still fires with this change, because KVM really
is trying to inject an NMI with vNMI enabling and NMIs masked).

 arch/x86/kvm/svm/svm.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3d0549ca246f..32cd2f53b173 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3858,16 +3858,27 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
-	 * KVM should never request an NMI window when vNMI is enabled, as KVM
-	 * allows at most one to-be-injected NMI and one pending NMI, i.e. if
-	 * two NMIs arrive simultaneously, KVM will inject one and set
-	 * V_NMI_PENDING for the other.  WARN, but continue with the standard
-	 * single-step approach to try and salvage the pending NMI.
+	 * If NMIs are outright masked, i.e. the vCPU is already handling an
+	 * NMI, and KVM has not yet intercepted an IRET, then there is nothing
+	 * more to do at this time as KVM has already enabled IRET intercepts.
+	 * If KVM has already intercepted IRET, then single-step over the IRET,
+	 * as NMIs aren't architecturally unmasked until the IRET completes.
+	 *
+	 * If vNMI is enabled, KVM should never request an NMI window if NMIs
+	 * are masked, as KVM allows at most one to-be-injected NMI and one
+	 * pending NMI.  If two NMIs arrive simultaneously, KVM will inject one
+	 * NMI and set V_NMI_PENDING for the other, but if and only if NMIs are
+	 * unmasked.  KVM _will_ request an NMI window in some situations, e.g.
+	 * if the vCPU is in an STI shadow or if GIF=0, KVM can't immediately
+	 * inject the NMI.  In those situations, KVM needs to single-step over
+	 * the STI shadow or intercept STGI.
 	 */
-	WARN_ON_ONCE(is_vnmi_enabled(svm));
+	if (svm_get_nmi_mask(vcpu)) {
+		WARN_ON_ONCE(is_vnmi_enabled(svm));
 
-	if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
-		return; /* IRET will cause a vm exit */
+		if (!svm->awaiting_iret_completion)
+			return; /* IRET will cause a vm exit */
+	}
 
 	/*
 	 * SEV-ES guests are responsible for signaling when a vCPU is ready to

base-commit: 4aad0b1893a141f114ba40ed509066f3c9bc24b0
-- 
2.45.0.215.g3402c0e53f-goog


