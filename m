Return-Path: <kvm+bounces-65058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 870C3C99D35
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 03:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D2C174E2EDF
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 02:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765712153D3;
	Tue,  2 Dec 2025 02:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cw8FeHeb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B87C221F1F
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 02:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641022; cv=none; b=qVu0x8c3Z8LFNz76IwCv4yCXhC0kyxL+zYWq26jsDQmybBhiol75g1liFQpn6Zy4uhiA+wP6R9dwmu1MGrf2Rturl7DQaqn6YNHbJdmewsyiXfUyKGjPD0RqMLdDijr0CE0R2bXR3gSAO757Gto5Fg8fUT+lYVOqESpX7Se6aQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641022; c=relaxed/simple;
	bh=kb+WfV9Q7rFZLXc2r0KPnkY0aTdLtzVPJWe+u5PyP1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P/AYCOW7EaQl6roarfvCSIxiIWhxzmYjnhWomq9FzFJ3QDdSyzQF68YRWU6sON1cCpmbxqkQgG1w/vPYPwNkpqnT6yxOMOWB4r+KHEpAqaHGwDt+NNnyNnK6/riAE/GaTTITov91LOSAO78p0JH7o+cGUZgp5egvL5bR2bsoyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cw8FeHeb; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-299ddb0269eso58653175ad.0
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 18:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764641020; x=1765245820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QRLg7QRwKtVVIRI8XsoliW/N9ravr7XFCmLVC3DKNm8=;
        b=cw8FeHebOiHuHlTK6wiANg3yvped4bwP5YcyCs8rHDN/aMFZKau9rVjRAdI2Qz3fTt
         EX/do5aJlTVYDJ7/NNKH3gdZKOVsIHWEGVqSRl1x7IW2iLGJCaaU4IuWcsTmrilISlwY
         73hJ1TL1Gul6Hw/ADqyZ78OS00TQFXyF+gZqKH2DA33RNYtT5IfnQjVqEwIIY3VChUKw
         A3saWh0JSBylDbjUVu9AQFOGty/mC273gw6RVS7PKRxy/tCqm1yQbqlvwObBNx4QnB8g
         O0oShSlx7osKPUMBLJFJX0kuWQHWxqnX6PlbmO4Rh989OpcWqSxSu+tvNgLKlqP+dhki
         1w7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641020; x=1765245820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRLg7QRwKtVVIRI8XsoliW/N9ravr7XFCmLVC3DKNm8=;
        b=qzi1tBhHNyw7WdHguqq9WhEa/NmqZk28oJXNW9VaT1C49B0+SsMaYTTGc2FFYpDlIn
         3z5JNnbdAQ0nTGCRN5EShoQzd+gbt3CbhsAe5iYKpJCNLwSkxE0j29Z3eaxHoqoeRQRa
         5fVpwCcqLW3Ztu2znMMvIMqrygrMo8cPqLztoQ9KTOpbWrfkhv1CzqElscE24BvMAyRK
         mWULYOX13duedYPT87krV8xJqsEmGtfhKUsxW956hHX9MjcVHeM0lZA+lmgQSrj4if4c
         sP0+SED8xlXevVrZ1HmAIXm5PnHFukSmhgbi/m4axvlzIOg/IKs6hI/0WW9NW832jWot
         kHEA==
X-Gm-Message-State: AOJu0YxgVocbogh//UysjHWEv/dJgnypWb4W41UOFxT/XtavrbPbXygS
	l0UDvAMEHHaqhY22jLfBs1BZWF3rdG0WAS45nMWhIk2MNFs9Ru97NaIAD00hRg47oXHUu7tYoXY
	JgZDVZw==
X-Google-Smtp-Source: AGHT+IHDbeeIz8Rdl49NrVuNa4lLNFb3bX31rGFPJ0FFXz94HdMk5/TUzcG5pTPETwwLtkwl+b1ivaovCZQ=
X-Received: from plrs22.prod.google.com ([2002:a17:902:b196:b0:292:a8c8:e414])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da82:b0:269:82a5:f9e9
 with SMTP id d9443c01a7336-29bab148972mr313593735ad.29.1764641019996; Mon, 01
 Dec 2025 18:03:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 18:03:34 -0800
In-Reply-To: <20251202020334.1171351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202020334.1171351-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202020334.1171351-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: Harden and prepare for modifying existing
 guest_memfd memslots
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Unbind guest_memfd memslots if KVM commits a MOVE or FLAGS_ONLY memslot
change to harden against use-after-free, and to prepare for eventually
supporting dirty logging on guest_memfd memslots, at which point
FLAGS_ONLY changes will be expected/supported.

Add two separate WARNs, once to yell if a guest_memfd memslot is moved
(which KVM is never expected to allow/support), and again if the unbind()
is triggered, to help detect uAPI goofs prior to deliberately allowing
FLAGS_ONLY changes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8891df136416..f822d3e389b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1748,6 +1748,12 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		kvm_free_memslot(kvm, old);
 		break;
 	case KVM_MR_MOVE:
+		/*
+		 * Moving a guest_memfd memslot isn't supported, and will never
+		 * be supported.
+		 */
+		WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD);
+		fallthrough;
 	case KVM_MR_FLAGS_ONLY:
 		/*
 		 * Free the dirty bitmap as needed; the below check encompasses
@@ -1756,6 +1762,15 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		if (old->dirty_bitmap && !new->dirty_bitmap)
 			kvm_destroy_dirty_bitmap(old);
 
+		/*
+		 * Unbind the guest_memfd instance as needed; the @new slot has
+		 * already created its own binding.  TODO: Drop the WARN when
+		 * dirty logging guest_memfd memslots is supported.  Until then,
+		 * flags-only changes on guest_memfd slots should be impossible.
+		 */
+		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
+			kvm_gmem_unbind(old);
+
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
 		 * memory, not any metadata.  Metadata, including arch specific
-- 
2.52.0.107.ga0afd4fd5b-goog


