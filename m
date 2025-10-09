Return-Path: <kvm+bounces-59738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D83BCB1A0
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37EBF484634
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD042877DF;
	Thu,  9 Oct 2025 22:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gjxrYPYz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B5563CB
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049173; cv=none; b=jqdKgFV0I2V6lmRXbdW9C4KpYISk45fLnKUVPiGoRgb5OoM9BKJT2E355GNs26YoRGDZ8N/LCUdRwjouNd2F44v+nlNwo3Wewt+bHyIXD+Zckuhwv22sUaUj1MIpc6cH0iKfrBywPtjEsdRd/KMVpvWIIJIgnwTNtVHBJEDEEM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049173; c=relaxed/simple;
	bh=vO3VcY4Mey2uMctJTZMoPagF4nx4IJ2GM52UySZ8Zf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A9VA96DyPxKe5UrWVpjuGvvegCTqcp1ucjCJsT+N8P30GCELtV0Q0F+aN9OZ7dKUYSdSyWnI5a4RQGa4TSc0S5MIrFpsJXTXBwe1lM/Dg8IpySzrbb9lkSO3bUeZoHwevCLsvR/ly1/evFqTaS4a8+SgsMMCUmbbl7hPqfhwXjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gjxrYPYz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso2756052a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049171; x=1760653971; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bzxaen3LvmXKcFizl4LeLbe+SVxImNGo859qacf3xPU=;
        b=gjxrYPYzh7RZsZw49TEDdjllO1KI2RJAs+nW8A1IzxhME+xBIIjYX76aXMDPI67qOu
         ZHkjU/O+ytU3BSvDrvKT0W28b9PxbVsYNHYwsAh3mC3Dit9y+aFQqfss7X7ih7HcqLK4
         dqQIYjDt37m0zR0sUsnvyiruqUpu5jVHXLR711++hsJU671IITSv5a2yF7xzK2uTD2wT
         wDa8xvmqEh+yRqhZZlkCRQxHKI23huLAXl2NnjgSi1qZIXpgeVr0cCOXAUDaXRD3GeU1
         umoZ+uLHDOoFzAOaSohoQqFY/o8XWUKf31pD3urwjG2MWZLJOb8GlufljLIvi9EI7Qp+
         83Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049171; x=1760653971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzxaen3LvmXKcFizl4LeLbe+SVxImNGo859qacf3xPU=;
        b=Q/ODl0CyEKMzyq+gcw+Stvh8fY4btjAMHYkC7vj7Pe+BcJBKfoFssCKzKArDxH59LG
         L+79cggW7Wlr//9BWSrZDyENfZWmc3sGsNPlB+3n2WwCIPN02S3jKl1/xVhnZ+USOgDv
         DRHJlE5jZZ2PUX2B9orIDxJMJ7j1nerPJExIdVqQ6U93IpDGuRNauO1f6Vr+bakF1uOM
         O/ePW+RhDPG6Dvf1qS6S2YO1nTd1B6esAcLVw0dGOMpk+n8F4uhghmdSTYlNLs39IyZD
         CRWVKh6JikuIr1czsbGtjiPzmAXrlb8bBjxKCPxAKzGTufl4ftUkOpGqr0SmqjWRgpjV
         DQtA==
X-Forwarded-Encrypted: i=1; AJvYcCWvSD4z18H8VbBepA28kSeY9UqeNd2vgpkoCV3jpkZR+jSKuI7pNSuaAA3n5uoFzt/8/Fk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP7BCmjBFTbmyDdQpDG6U1uev3f+Q0X2n5Sa5jfSktK4i/BJ2d
	SnU33CEysBLcgg51EaaL8WPsOkeXyCx8Olm/rO3kAVfnGRvz+w0cgBCoHbxsclkXw82czlceRd0
	2uQrhlwK2evF5Zw==
X-Google-Smtp-Source: AGHT+IHk1hBTwXGvc/IYeBTX/VTIxFTOQhBx2eiOsk6iO5H066u3cdjiSUsOMOWCu4n3mGnCr+SkijXapbWNtg==
X-Received: from pjblt3.prod.google.com ([2002:a17:90b:3543:b0:33b:51fe:1a7e])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ac9:b0:336:b563:993f with SMTP id 98e67ed59e1d1-33b513a2456mr10758336a91.34.1760049171392;
 Thu, 09 Oct 2025 15:32:51 -0700 (PDT)
Date: Thu,  9 Oct 2025 15:31:34 -0700
In-Reply-To: <20251009223153.3344555-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251009223153.3344555-3-jmattson@google.com>
Subject: [PATCH v2 2/2] KVM: SVM: Don't set GIF when clearing EFER.SVME
From: Jim Mattson <jmattson@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Clearing EFER.SVME is not architected to set GIF. Don't set GIF when
emulating a change to EFER that clears EFER.SVME.

Fixes: c513f484c558 ("KVM: nSVM: leave guest mode when clearing EFER.SVME")
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..96177758d778 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -215,7 +215,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
 			svm_leave_nested(vcpu);
-			svm_set_gif(svm, true);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)
 				clr_exception_intercept(svm, GP_VECTOR);
-- 
2.51.0.740.g6adb054d12-goog


