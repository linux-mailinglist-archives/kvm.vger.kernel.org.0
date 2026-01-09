Return-Path: <kvm+bounces-67517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 146CAD0718C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 05:15:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BECC23017123
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 04:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D372DB7AF;
	Fri,  9 Jan 2026 04:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GSgoaCUi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE7209F5A
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 04:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767932140; cv=none; b=jdgkOZ3ckbhFC/bHi82aPWwOKcgS46H20ilw8tVeojf3uLuzCQ2P6YrYZeEtw93vzw5o+F1MIaqsW8W/V4Qm9IXKKqIUQhV4CzKRvel6dgKLo2T3z0VcXHk7Ekh6VZSKZuVcb6KlxSy8x7FmCbgkwABQm7aRC+mm//jEPFo4KXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767932140; c=relaxed/simple;
	bh=DZZWXNB3UFwK8BGeGJyRTp3Xu6hRuIS0kH1Hk2lrhes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PP3/UkIORKAGUgoNRaMX3kwDQ/XlxWBNZq81fwKQWT+aa2QwzhJyo8ZQAXQcunePTFaNmz92vvCK13ypO8LyMHgdsX+mf/3yP+iDHXFItIJbJWfrqS7LMFPUSWZncYHGoQ9DUgVYHOXESFY/CdOCaSqSB3NnGLKFLSQ2KB6lDwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GSgoaCUi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34aa1d06456so5454700a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 20:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767932132; x=1768536932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov/rDMP3kxGlRWYyyDh1VhkYmedXXlvI3JsrhuQsaKs=;
        b=GSgoaCUiw87ZtIV16uyAseR+M0ZCxfkQqXM6Frm55RL460mtYG+9+Oh4nHYIOH1x5/
         TJQb6rrNyyUsQkx29ArEUsKF7k/UvpCJYs/6Sed/mzfNvs7tK3ZMcTCiT0EdrZUzd5hI
         1ayVYojURnr9qJ+7rJRwLO8Tl1YY94MkQ146cjqo3poStqa8kwkv7C9MKvKO9+LEIP9/
         ux1MigM0y7c/OuxVrAqCD9zh2wszPP9bA3xcNhWavv5JIDMeOHAppD2yl4BUlzksWW1Q
         2a3PVe1gj673pMoG6BXYQAUziu1S9WiPqNnrkuWiNLl2uCNBqCrZK/9RmejNIbbMULWg
         XiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767932132; x=1768536932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ov/rDMP3kxGlRWYyyDh1VhkYmedXXlvI3JsrhuQsaKs=;
        b=Yuw1+9sF8/gkkSP2RZGpKHPKj+u/e5BayNry1h93tjYpBmbWCA2FQu8ywRJ2GcAXsT
         JnI4ERvOQIqZRuIkWbrnLRF0meAwb4MtMOrJskabc5b7a7UXbXVzMN7foPD5uBpBZciC
         wuIFAkf75zHSDAkEu/iiMQAaZ1/mZYHJFaB6YF3OlrXQx2VSUG+cyMETjBA9vdK0BhD1
         /zLosy8/xyXYRoSkntfstSSY/MrO3goy1KkIttn688e/YMkXxJcZxMwLdFCiBpUHLgrr
         03fmCUEf7rp/MVyVCVLZ3Jp4eCKpq9yayOREvqpRnRsA+vMxqp31OfjBG1MnhP4ovQr5
         /W2w==
X-Gm-Message-State: AOJu0YySrgXACS7zLfanm9VdjxeyUBZ8bnijTaZkBWb3q43UjzGOb3/o
	XvcMwclWTQtiHWgzrd7iAiONAFeOzdhXr1Fey9LxOHmsV8ZaHkJPtvpki7mF4RwzPkpCB1bU8IN
	Uufnjuw==
X-Google-Smtp-Source: AGHT+IGwhjd/Tdp+duDHCNNRqDKJScvXuyyuKTZj+2tNhsQ5tHaL89ELrFF1rUILoaCEzOilT74jxEfvxLM=
X-Received: from pjzj18.prod.google.com ([2002:a17:90a:eb12:b0:34c:c510:f186])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:340:bb51:17eb
 with SMTP id 98e67ed59e1d1-34f68c286c8mr8384781a91.15.1767932132325; Thu, 08
 Jan 2026 20:15:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 20:15:23 -0800
In-Reply-To: <20260109041523.1027323-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109041523.1027323-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109041523.1027323-5-seanjc@google.com>
Subject: [PATCH v3 4/4] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's filtering of GUEST_INTR_STATUS when generating the shadow VMCS
bitmap now that KVM drops GUEST_INTR_STATUS from the set of supported
vmcs12 fields if the field isn't supported by hardware, and initialization
of the shadow VMCS fields omits unsupported vmcs12 fields.

Note, there is technically a small functional change here, as the vmcs12
filtering only requires support for Virtual Interrupt Delivery, whereas
the shadow VMCS code being removed required "full" APICv support, i.e.
required Virtual Interrupt Delivery *and* APIC Register Virtualizaton *and*
Posted Interrupt support.

Opportunistically tweak the comment to more precisely explain why the
PML and VMX preemption timer fields need to be explicitly checked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ac7a17560c8f..3ef4d7ab5723 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -115,9 +115,10 @@ static void init_vmcs_shadow_fields(void)
 			continue;
 
 		/*
-		 * PML and the preemption timer can be emulated, but the
-		 * processor cannot vmwrite to fields that don't exist
-		 * on bare metal.
+		 * KVM emulates PML and the VMX preemption timer irrespective
+		 * of hardware support, but shadowing their related VMCS fields
+		 * requires hardware support as the CPU will reject VMWRITEs to
+		 * fields that don't exist.
 		 */
 		switch (field) {
 		case GUEST_PML_INDEX:
@@ -128,10 +129,6 @@ static void init_vmcs_shadow_fields(void)
 			if (!cpu_has_vmx_preemption_timer())
 				continue;
 			break;
-		case GUEST_INTR_STATUS:
-			if (!cpu_has_vmx_apicv())
-				continue;
-			break;
 		default:
 			break;
 		}
-- 
2.52.0.457.g6b5491de43-goog


