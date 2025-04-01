Return-Path: <kvm+bounces-42373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC5BA780BF
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 814D13A4E3E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45F221127D;
	Tue,  1 Apr 2025 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="myq5/FO5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F25E20F060
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525800; cv=none; b=KqG7HAZ5FUWQ3a4mWKXPctWHguywxOzpLMqA0gfudHiftg/QZgvL0/Q94TA00T9ROzamxCu4unTZTZ2OOAkG0v6hvB8MvWwxvQgFHOu+GYsL1u3phQ0Ye9fdQChFWsZTzdYK4FBl7CfYT1Jb6qvA6PI9B1BWvGuMxV82ZlRZNpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525800; c=relaxed/simple;
	bh=68XUd7R1fyxPr0p6LhY6RzrECfMFspwxL2oY+XxMEXg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ir48YSfUqEgprWTwVpvy7/lcktLIi476a3lRad8evuvoq9auiHg2Bw2XnOmzMT/Cx5mfhK7TB+oEHhKerQRmSTAVHuQ2bIW+gw6f0CKxgYnhH2vg/UFd1yRzjW2iYxKLbveYf5TWojNro29HtBbu22m1smkXuswd1udKyiZbdb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=myq5/FO5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22647ff3cf5so93725665ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743525799; x=1744130599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ENuRHHo4buatmc9xHBzqgn6lL1J28WBga1j/Fc+SdOU=;
        b=myq5/FO5y+daJ8IlBfsRl2hkMwC9QXPl6TRhHGULZ6f3dgUcLpSRWKIqyWp7vaRV6O
         cE3mSpbyXhn7oWMlcZ2EbxrxGxzPFj5VywLL7VPbCYvVJs8wE983pHbHmRjguXjOqXGw
         EjJdozdFdi8MbTqH8AQ9CvBwcM9/rPfvMfBHyQXgvRhNO4SMd5UP1Q97THSGb7KMrCMW
         IeGlfQyImZ4DWpWM1Na4wvU9ghcWDH6XqZpckVcCaY6JOeHNRm7ys5iUKQnRlXl93Rc3
         kn9lpocnTNnHEOp465RkPMCi8k/j8E4aiwERj+uPnVxOV465aKEePy2YuPFgrveSlO20
         VttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743525799; x=1744130599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ENuRHHo4buatmc9xHBzqgn6lL1J28WBga1j/Fc+SdOU=;
        b=lEFO3w/tBwKoDDvO2RzPKnGSlqDSQKnsnDaA6s1sYz8hOR/4EHYMhRG7E22MVdtGcE
         CjJAliJrl1H2G86c5TiGM8hLXI64vNw/+7Pa7EoYMe41pL8b6QwPYRN689O/5bP5AoqV
         oyQQ+imI5jHslJ3uCfQ/YbxCZgisH0G0DX/+eSXjsJ6Ajyj5RyOyPz6yR4u+ZMcU/pgB
         Z1yfQIPKZieIKPK7+1n85kk42PWKMeGU0wnOqoU5Ark8icHLIQm+jE9uxackGYW6/9Mu
         rdRs+U/acZUuQ3GffJO7UsBhT93tJdH6+mNQzaTNbynDvaBXAN/Ejr0zdEeCrNW0fxpj
         YzAA==
X-Forwarded-Encrypted: i=1; AJvYcCWwbrNgebhLgmlTieJMg63/iEZg9KaI7k9wge/dTzx5nuJiGYNsGqNlJaGBJv9pOX30o6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzywBcp2O4sTlaU7/MWndoDBNRvpyO4KlpxXYnvhQQXc+NcnHU2
	MFyhaLm8JBVoad7sIuURsYLmiYc/dg1vTvlilwsvA1PujualnvLfdVoX4Gc3JZ8e7L3ETzbJsLO
	vWQ==
X-Google-Smtp-Source: AGHT+IG7uPldPi4KrDzTQHRm25erUUAd10L5t443gFis5z6W+qmvlaB54rM8wSKwHj0ezPMBh17NInSp4ik=
X-Received: from plbm1.prod.google.com ([2002:a17:902:d181:b0:223:2747:3d22])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c7:b0:224:78e:4ebe
 with SMTP id d9443c01a7336-2292f9e62cbmr194250575ad.33.1743525798682; Tue, 01
 Apr 2025 09:43:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:34:42 -0700
In-Reply-To: <20250401163447.846608-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401163447.846608-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401163447.846608-4-seanjc@google.com>
Subject: [PATCH v2 3/8] KVM: VMX: Ensure vIRR isn't reloaded at odd times when
 sync'ing PIR
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Read each vIRR exactly once when shuffling IRQs from the PIR to the vAPIC
to ensure getting the highest priority IRQ from the chunk doesn't reload
from the vIRR.  In practice, a reload is functionally benign as vcpu->mutex
is held and so IRQs can be consumed, i.e. new IRQs can appear, but existing
IRQs can't disappear.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dbc0f5d9865..cb4aeab914eb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -667,7 +667,7 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
 		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
 
-		irr_val = *p_irr;
+		irr_val = READ_ONCE(*p_irr);
 		pir_val = READ_ONCE(pir[i]);
 
 		if (pir_val) {
-- 
2.49.0.472.ge94155a9ec-goog


