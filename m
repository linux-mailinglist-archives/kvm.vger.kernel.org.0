Return-Path: <kvm+bounces-28304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 562AD9974BF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18DF028AC08
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AFC1E1C02;
	Wed,  9 Oct 2024 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ayEExf5E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F11E0E05
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497869; cv=none; b=BOyxbW6lg7ChYiDyI3+kxwZ+58oLSEBkogfyTZiKM4DLW+LnHEdrwPnNq+wxw6IOC1rvm92xLPXfkwEyGwCWJUYju9pXOTIs0cA9v9JUqyoB47lFyBm+Dv2x2xF01mABWY5q0Koe/J8bO8S1dckogBAMnNKWybFlYR4lMUr5144=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497869; c=relaxed/simple;
	bh=DDLfj0TQYGwpLkFazEuQUvzdkQZmzTYxm2iRMOY43rw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wo/uQBV7WHqnNco+axSUmX1iNfIDmlbEmstfW2sPfYOk4HUUrXqnLXNvBdqAxTTiSBHj9n+UkmiHiT1hvWMRmLIi9FR5PrjxZDyH3ZbBnDMTKNFzZNe8Ts9FdCcoDus0lmi7AAYt82N4MUKQ2E3NGGYu5yPG6IQ/SKUaMVfUZd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ayEExf5E; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e026caf8bso118676b3a.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497868; x=1729102668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2G7TjtKE6sDpC5bp0OSd5cuEOohLepXkfXg2tU0SKoY=;
        b=ayEExf5E+PPxYZ2EqowrESiE9/vonl9bHhKnQBoxjec3o0VyRLXyaOOsFUwPAZsHYJ
         b/2jPIX6BYT333jrnU6VkXvgnjd4+SJgNE0RYNhZ7HQ4qnL7O/xk2nsXgBq68Qf6Gkg8
         WteyoVnOAMvHMUeWQkjvQTngcMwvW641zrHEEokZ9lpGxnlLnS1Kg7AxetmT2LtaqH8a
         sttL1cx3wu8ECYcv1O+E1f4zF1Qz14+yVv5drGd0BpdFCd4bSiZq/Dkoc/VrC1SJWIMJ
         2uyHfcpT2msm5FzM+8AxvBPc+SbU+MZ8dRgC1hlidiI9NX/2SqZAweIKdJZxz5vXq7bL
         9B8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497868; x=1729102668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2G7TjtKE6sDpC5bp0OSd5cuEOohLepXkfXg2tU0SKoY=;
        b=HP7ruPYtkKKgCVk1eXkWNbsyRLyDeR2PY29MwcIo9NnpMWlirEzAI4+OekcM7TnzjE
         mya8ygT7bwJJVtWxrj9DHed4tIbGZLBemzpSWKSi9OpBtOPSxaM2zdm/Ew6ia+yzqVqd
         jV7KFOPHXoRMWqL66oUnnuBYVr7q5pdFE9+P7FBnCLfBMMLya92g0wfVVITF+rTs8u9f
         yZWmfRpeKBFBqDKAToyhJ4eLxa6l7j4Ra0pbxBfYMH8egfinxOteAY63yUs0h9Ad/UYv
         E9WnueVYl2XJef5i7N1SRLNXLhjf2qzZsh4VyPCyD/k5DzsHUoTQVoJTfdKhcjE6U3NM
         +dGA==
X-Gm-Message-State: AOJu0YyJCvj/AV4khDd4/aPmpbeuncUnva8LTkIldcmRJsHDIp7RwXhp
	vtxnzSNsT+e7x3xlGrdGvxdbBevncHTaHpJz0mzfCrxFHKMhs+rUfoOI3YiV5Wv8Ol3luh7pFTB
	GAA==
X-Google-Smtp-Source: AGHT+IEDBDcN5R3goI4UO9P1OG6J750Ofxm36RRfmx857Ihy1BrsZNT8kpRnKzVh5TGPa8Wq9gICpJyQfxA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3e0c:b0:71e:aa:eac9 with SMTP id
 d2e1a72fcca58-71e1db7352cmr6743b3a.2.1728497867481; Wed, 09 Oct 2024 11:17:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:36 -0700
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-3-seanjc@google.com>
Subject: [PATCH 2/7] KVM: x86: Drop superfluous kvm_lapic_set_base() call when
 setting APIC state
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that kvm_lapic_set_base() does nothing if the "new" APIC base MSR is
the same as the current value, drop the kvm_lapic_set_base() call in the
KVM_SET_LAPIC flow that passes in the current value, as it too does
nothing.

Note, the purpose of invoking kvm_lapic_set_base() was purely to set
apic->base_address (see commit 5dbc8f3fed0b ("KVM: use kvm_lapic_set_base()
to change apic_base")).  And there is no evidence that explicitly setting
apic->base_address in KVM_SET_LAPIC ever had any functional impact; even
in the original commit 96ad2cc61324 ("KVM: in-kernel LAPIC save and restore
support"), all flows that set apic_base also set apic->base_address to the
same address.  E.g. svm_create_vcpu() did open code a write to apic_base,

	svm->vcpu.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;

but it also called kvm_create_lapic() when irqchip_in_kernel() is true.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ffccd6e7e5c1..fe30f465611f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3072,7 +3072,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 
 	kvm_x86_call(apicv_pre_state_restore)(vcpu);
 
-	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
 	/* set SPIV separately to get count of SW disabled APICs right */
 	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
 
-- 
2.47.0.rc1.288.g06298d1525-goog


