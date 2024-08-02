Return-Path: <kvm+bounces-23140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEEA94647B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB3152828A3
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E3E13632B;
	Fri,  2 Aug 2024 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WSU7wFT7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9903912AAE2
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631151; cv=none; b=nMeIzrNcHXM5DOgbr3Ri3IV8D1VRLE+o/WOqFopUW38mZ5WuYa0sOoJq2S4z2Gwz+8iosjubX3mZW2bvKMLQ0MLpgfqxpqHuvcImQ4ZHfDR/AcXTku9ydzdZKr2Rgbe10GVs/gqLFgrEgj3X7ISn9+CxxVxrfm7WR3XS0iMo0CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631151; c=relaxed/simple;
	bh=ul3I8jtNfEVe2uxdPBcvEuYLJaZMuXyRTYdE99HTjQY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DqrH7wea2U7j1cRjQMJoyHoQs55c32A7DTeYW7zjp3BbUN94dOhFSIj6jSRs96LPm9lFhKOip65a4OklP6TfGkz/hjs3i+ZlTSLwWzVwDTJALJ3rHjdedO0areTh7mK1z34BQgI58cP/Q94nSUnehX9P+t7eivhBHx2XYi5CgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WSU7wFT7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664fc7c4e51so165288437b3.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631148; x=1723235948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UjvdKHX5XmbdhKLTWlXN2ri3L77fxrqJCXnnfCjoJs8=;
        b=WSU7wFT7U36UARGVoVUTZUcunD+twpI4AKK76AqUPiys9it226ott+xEmVe7CHivdx
         IXDlp7TFucZK8OvRnzA2Vnso9wBzaHKVz1zs9LafIosw5NZ9nscV7yRcuH5FARh23VUp
         Jpw5CHYXpd/zzMBTBqCWWCB71g3pNixI8FpMmfXgbsjJSNPb5wuUv+bLXKjuHDUpTg81
         6j14Q63GQIg53L1aka8rItRQew9p0DihLyKEn7VbTyUBMEUEk5Do+Cn0hEKyEoxz7qc0
         2Ws7mVMIAI17sTSgglmTmDZUQgKYSOF5tOsofoN4+Ixob6LRIk+s6rMo+EczdQZrKUC/
         XDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631149; x=1723235949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UjvdKHX5XmbdhKLTWlXN2ri3L77fxrqJCXnnfCjoJs8=;
        b=SyH5lq76aEEl38TvBxkFUc7DD64HEDV+TFYbRNkyVqa1pGlBpxkChVfsSQTmaDlrn+
         8SmJoWa6IFMS1U1ETT8x2w90lYIrC8X4KIOyRFCrNglf66rvXdpgtqDGcnwxPaZIgIJb
         Mf2gAvQPBAktcnF7WxWYWrdLZy0D2PqYA00XT9xT+/44qDnjQiWjtnxGTPXRQnHZXBqM
         m1hibvwpvZL0+E/0x3AU1pwNNvfX7BJI9TlVUsmeoTc6DMxldvFn+EdrLqEinqSXLtZu
         kx6cVVyMK/yGq8Rz/ttpeBXG80Yp2Q6sfSTslhw81K2MMG1LYgwD049r66krMMvuZHPx
         l/og==
X-Gm-Message-State: AOJu0YzIYQYTID+wY9/nL9pldCSTzqN78TRm/+s3HTTH9ds9pb6isX7d
	FjnhMuhMnCMZSLPLYDb/0LTkTlrfEw2Tc572yfpL92yRpG0RwpoFUIHu6eEwecArfSd2m5eYy64
	07Q==
X-Google-Smtp-Source: AGHT+IEPSQRTx7gBHRSttp+7gITI0epwEssMzt1KPQLzKi+lHEKLoj+vlFZlHc60M8o1PIdYF4z2PAULIsM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10:b0:64a:8aec:617c with SMTP id
 00721157ae682-68959efadcfmr3215337b3.0.1722631148748; Fri, 02 Aug 2024
 13:39:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:39:00 -0700
In-Reply-To: <20240802203900.348808-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802203900.348808-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802203900.348808-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Reword a misleading comment about checking gpte_changed()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rewrite the comment in FNAME(fetch) to explain why KVM needs to check that
the gPTE is still fresh before continuing the shadow page walk, even if
KVM already has a linked shadow page for the gPTE in question.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 480c54122991..405bd7ceee2a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -695,8 +695,14 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			return RET_PF_RETRY;
 
 		/*
-		 * Verify that the gpte in the page we've just write
-		 * protected is still there.
+		 * Verify that the gpte in the page, which is now either
+		 * write-protected or unsync, wasn't modified between the fault
+		 * and acquiring mmu_lock.  This needs to be done even when
+		 * reusing an existing shadow page to ensure the information
+		 * gathered by the walker matches the information stored in the
+		 * shadow page (which could have been modified by a different
+		 * vCPU even if the page was already linked).  Holding mmu_lock
+		 * prevents the shadow page from changing after this point.
 		 */
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			return RET_PF_RETRY;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


