Return-Path: <kvm+bounces-35911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D562CA15AB5
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34406188BD6B
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997BD1850B5;
	Sat, 18 Jan 2025 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qb4vxX3r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C85618873E
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161772; cv=none; b=ogI2mp7zNSZYo9Oa4sKtFppa5I5IaZekfc32Q9a2d/LwRUxiRFH1wYIqpIJNVUb32BsS/iw3erjNA9dVxqU2hZvoLlsnFM9iS+9nmQc08AdBl7c1Hd5/1ca5/tDV+oDUD5jgl+akHqN4a10fYyyXX31YEVVaz+tpQJJ/5+VUGJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161772; c=relaxed/simple;
	bh=txU0Sdtz7R3MmtsACbSPDEzo0mLxEJccpBB/mvDYcac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xz6IEEfUGuuDX/9uDGMfS1iiXnls8wn7vcijYIZjr0lm9lR7tjiEGdmfotqSMziLJ1cw8tavIlkJYZDp2dhK5v8i4+0Oz71P0D7G3iRAZ4hSNBzrMPLWDw+x5jRBlJNBeh8tNRGF5AUh/ITKIlTs4uzDKQNoDJ27lmReo0fovp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qb4vxX3r; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so7454113a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161770; x=1737766570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BNpJzsrfz02JUJg/g5Nzqh1wopYI8C0whV/EdhFSCqQ=;
        b=Qb4vxX3rI5wA9tiy4SGJi0Y/S1BkhVKmYzOzS4il9lb+HJpdVlb72pE6Gfi2COMtbu
         Ka/FgsBhcLE4f15koLzRRX/0jxGII6TFmrybPVLYAK8I+yshG1qBH9HgMM1rrmMbF0zV
         xjYvJbPA74HU7SIbTEcsuGXy2MirZaDlAZ50zfwKXAbdD5L148QBQE0+9H1KTgFCOHC0
         4ummBe3jy/9OUhLz1XaVZMY1YTHZcnOQkw4B5A4gaybg8u7QGiB6gCSA5MOoBXs0Ju4+
         dnxnmfVKUqWfHzvG4AI0ywDB+uyrzf7FAOTxcsOJ36tYvCN2BIUK47IyY+8HzyHibTe2
         8UKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161771; x=1737766571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BNpJzsrfz02JUJg/g5Nzqh1wopYI8C0whV/EdhFSCqQ=;
        b=bfdjDuXCNUy/UOlXigp0ObpjZVOngGS8BUPqprgDTbmfg1J7Mr0yE+lW4pGdN44bL7
         ngagYu3pibzTjeuyv7E4U9rCf3V8iH31380g740RCVQTBrDEAIQUdKICd9X0bDl/dTGa
         U4wFumcVSwgLrnQq6xr+HXLjLdL3xOnDC3MLsIYkn5yqetEqPfgO/pv5Lst9dosoMTMx
         v5nQ4nbRxX2wI0NPy+FP1VyLJs7g7Qw7Dxf0Te6+sia3zzYCr2dweKXad9uHSgkHkk/p
         zsIB6agIumU/auL+EEzXlbOmlAjqAtMcvN9V+/AgC55DWLiWNt5xkaO1G4tZ7QH6t0lh
         K0gA==
X-Gm-Message-State: AOJu0Yydc9xDg9C5RIs/e3AaqoNld0qXlkVseeCYNonQLMvtvMr1zpip
	NtQwB1yWXmepeNK0F4i+muiUB4Ab9/5ZyfvfCduD2/2s26MZ6fRH9uxagtEAG7Ty54OPT2v6cqI
	WVA==
X-Google-Smtp-Source: AGHT+IHRvX0tflrgzrkpmk1b+MjqWug+G8ZrQ8JrlQY749G6+HLxwwSomleOR6ZkhT0jJLPFBCxCbbf+MWg=
X-Received: from pjuj3.prod.google.com ([2002:a17:90a:d003:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8a:b0:2ee:f687:6acb
 with SMTP id 98e67ed59e1d1-2f782c94b50mr6683883a91.13.1737161770741; Fri, 17
 Jan 2025 16:56:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:51 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-10-seanjc@google.com>
Subject: [PATCH 09/10] KVM: x86: Setup Hyper-V TSC page before Xen PV clocks
 (during clock update)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When updating paravirtual clocks, setup the Hyper-V TSC page before
Xen PV clocks.  This will allow dropping xen_pvclock_tsc_unstable in favor
of simply clearing PVCLOCK_TSC_STABLE_BIT in the reference flags.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9eabd70891dd..c68e7f7ba69d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3280,6 +3280,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
 	}
 
+	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
+
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
@@ -3289,7 +3291,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
 					xen_pvclock_tsc_unstable);
 #endif
-	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
 	return 0;
 }
 
-- 
2.48.0.rc2.279.g1de40edade-goog


