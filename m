Return-Path: <kvm+bounces-49200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC57AD6378
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACCD3AF680
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B690A2ECEA4;
	Wed, 11 Jun 2025 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LEtc4+G7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196F02D8790
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682111; cv=none; b=qfbuif8NK98M8QjYVD1Te2VojvvWig3rd/XO6rzDtiFz1YFrpom1jtdtXuLwljBzfDUrCKZS8FVmr3g8UP/77/IfhACKxtaJjDiTeAXwuNyBP6jacGk511nQzEoQZ8M60TcjbKUlnL9gvEHOd2rlkPSu8h0sFp9SP8qhPKKu4K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682111; c=relaxed/simple;
	bh=SRc1h3FwDFlhAZX/NxnbRZt+oZFY+JZk+gHWHS2GeKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QotzZbjmZjUacFGxrfyRcdwXfiwc+N6p/3Y3kzFnV27BKfbRR0PR949NVplVM1hqKVBsOJ7+IJeE5HEkcZkfJkjVVEtRtVK7sO5d79rMFVPJPlF0mseETuxnan70KrrGtA57MweAlJdK+9SnlWNet4g43alBd/uslSt9jgxtxzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LEtc4+G7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31171a736b2so438219a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682109; x=1750286909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DHIf+c90E7y3SFrSqtGUpe0CRM2cdrMuvDnBkk7f4PY=;
        b=LEtc4+G7nR/gN2QCjpYEn9p5OJDgGFr5RLGw0BcC6mGdBdRVl3b7glEywsbvU7/m1U
         eMSfdZBZBcGycTviuUhMizxXKUBFH0JAqIZ4lD+ewMHJVAtAAlp7ShWZmtN3cQ4SThjX
         P6yNl6g3x2amLeBG0Iz8/MAbKSonJAmqg3qAqe91uIdwf3lzSBOC75TsjPDRL4415I9M
         iDzER0661vDRFNAkNVb7ziRt2po1CHHLx+6ex0g86wJodKRUS7b8u7jB35A635KSa/WG
         fAnt1XuLz6dmQYmrPSsZVtrQvBXrAdByiltCn7Doo3F3pyuMDPALJ7gQPXYGr7fskJAq
         JaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682109; x=1750286909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DHIf+c90E7y3SFrSqtGUpe0CRM2cdrMuvDnBkk7f4PY=;
        b=gikvqns1+nwrIGGUL5hCEHNsmgeoppsueeqE3iMW1zNV1DO6rnw6fXyZjXgPtvWtvH
         9bD89ydJcd+W7SVdMuft7Gg+df4xAlJFr/c6qHfxVp4xJIm3lPsswUvMnv0mtJDVNxui
         X9VpXkqKvNAvR7FF/caIIArbpmRLZ2GLeAP7lLCzGP3nk4eZLUhFHkP+NUgy/XJy4hNx
         RMaFk5E0sA083Enp4oWDbLogLSRxVfEnJn/efKMoD8cv29yx8TFlntD9ipsLDfHyxsnQ
         ed8mHgeYqYKdLO/Odk+G42mCvA2Cwyqlc3q5sz+kLfhWtqyDswn/Nu+cPbVlxPFUa7i9
         SdHw==
X-Forwarded-Encrypted: i=1; AJvYcCX8HioN/UUzqm+87DEfg26Wc2qRt6oawCgI7lc1a/m+veDu3W1umCOVI5jfsHmMNkSqXuU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLG605ZCo9YjidSSadQB9IC7RojMtWrZzWTKYM0wRktcjSRHH2
	avRkx+jGVmRWDJZLHRBB89dz5GyRQ+F90kEI1MbjMBC7lH1+l9ClbGudl7P8pArUY+3biLFYpBz
	3KSaVMA==
X-Google-Smtp-Source: AGHT+IFtBQrCrRoK6BL9Dz+IQ2aeYDyw9D2RNz8zXlEmSFnG0/dQfadG1s0WIBiR2YE1o9tnTCGC7rDXtkk=
X-Received: from pjbpq18.prod.google.com ([2002:a17:90b:3d92:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c08:b0:312:db8:dbd1
 with SMTP id 98e67ed59e1d1-313c0667c29mr974887a91.5.1749682109408; Wed, 11
 Jun 2025 15:48:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:57 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-56-seanjc@google.com>
Subject: [PATCH v3 54/62] KVM: VMX: WARN if VT-d Posted IRQs aren't possible
 when starting IRQ bypass
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if KVM attempts to "start" IRQ bypass when VT-d Posted IRQs are
disabled, to make it obvious that the logic is a sanity check, and so that
a bug related to nr_possible_bypass_irqs is more like to cause noisy
failures, e.g. so that KVM doesn't silently fail to wake blocking vCPUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5671d59a6b6d..4a6d9a17da23 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -296,7 +296,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  */
 void vmx_pi_start_bypass(struct kvm *kvm)
 {
-	if (!kvm_arch_has_irq_bypass())
+	if (WARN_ON_ONCE(!vmx_can_use_vtd_pi(kvm)))
 		return;
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
-- 
2.50.0.rc1.591.g9c95f17f64-goog


