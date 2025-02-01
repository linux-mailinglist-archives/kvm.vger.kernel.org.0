Return-Path: <kvm+bounces-37017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CA1A24615
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B670E18899E9
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096F261FCE;
	Sat,  1 Feb 2025 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmLuxJA4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DA321364
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738372449; cv=none; b=fTHk1u+v1zWRZ8qCLOpntw6MK3ZckfPwr1A42LdyNp6Ic5A4j72jYGR3bj0xeo+vWD4xuIxYQgjtf5i/pLJ6YTy/nF+lzSi1+GSPFlop+2msvjiWflthRMTmb2Yiuo6Y6afkmZl9+gs+dgijaNVmyOOEZUNAueo9bFHCXKidQhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738372449; c=relaxed/simple;
	bh=Tg8GhNLpPA34vQJNweaMVYaIAHTcnBOATqkxrRePjzk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rp+wrZ52HbaKFOQzBBMxQaZ4OWe3kInX1EAmUh6PuK4Vb+scLUNp9V5DqHBs0n4cnDhelt+eSTp0ULmXXgfFkGA02y+a1/LGjR2W4mePYhJmMk48Gm36pK0jNxYpdqgNlLPTtgnJ5ZLupcCGcAVpVLkYhgqqaUUNDoWhNyTlnkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lmLuxJA4; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216387ddda8so54658145ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738372447; x=1738977247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8BJ4lYogToOhLZ7GzltFe2z01ZGXRRujJHAawRGlx94=;
        b=lmLuxJA4T+03nwub+046KPHLq8suX77ujRsOzsS7TQeDMEossCYNNtJh76lPdkR5cn
         bjiOFuyY299Q7+OWDjBKxkhWc0ah54ftu9s/U6rqxMcoQs2+48bTg/VJXwp6CCxhdb59
         KsGUtr8bG1t2xQyhnNRxQ8f+SLThnSSbf5zQYMcVmWKZ+51HQpyxkYziDyLOoMyto8uG
         E7SMTbmREK8QAuIPC6w/kuNLtRcUVSxYMvOpCCyDC+51vO5XJ7rlsuQD1xz9fV6zzjrC
         wZ9+cJ9fX/LYadqf86+7RD38vgdWMvOlpO0MDylXsXykpV5HVfVAENakcXMkvFdq2+CK
         gqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738372447; x=1738977247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8BJ4lYogToOhLZ7GzltFe2z01ZGXRRujJHAawRGlx94=;
        b=nR5JSBW/ZElgci4UAZGKGTqU2O/4p0kbrBZcI9LyLtcn7EuJ/KSUcYcrXLe3BlkxbL
         DNo3PODbWgbmi36siZ+PogWOoytwDocbNZPgh2f/F/l8IRtfs7OTYr5i6iGwe7vGFLyM
         bsbK0uJl3h6Qy/fo/GldX7bf9h+tt9QH36hNhUKhINlcd8MfAsK2W0zaw7GsrFIZMZoj
         p/qB/6bkpE5Pb7fes1JDPVjtjqiYCOiyKanH8NMB4IwCEELIyNPydymmLKkWwACZ+K+S
         L7CgUiByyCOOgmCGUhM+cMEEDrIrRS6bjaHcETFTjrQ8pHO2wCwKQoi2JXbfP4aKWFaC
         b0UQ==
X-Gm-Message-State: AOJu0Yw6kmBegPoNCsEqAi+vYNPyrGvixRwiWZrFkrI/P7LFJnjDqI0f
	Xr8+Ld6EWMemod2Ugyr72rGD998WJNJR3d55Voz6gSJTgCn1KUqauKH+IgUoDlXnpH+4jpJa3eU
	62g==
X-Google-Smtp-Source: AGHT+IHtd/xn8X4/ZTBhWNwmLHwRcrXbBlCFmDpoSEG9bkywbg9XeRZ2Td6Ob3lUwcyyzNaiLUtTD89OvYA=
X-Received: from pgjz10.prod.google.com ([2002:a63:e54a:0:b0:7fd:50ab:dc45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7343:b0:1e1:ab8b:dda1
 with SMTP id adf61e73a8af0-1ed7a6e0999mr25109821637.35.1738372446922; Fri, 31
 Jan 2025 17:14:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:13:57 -0800
In-Reply-To: <20250201011400.669483-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201011400.669483-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: x86/xen: Add an #ifdef'd helper to detect writes to
 Xen MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Add a helper to detect writes to the Xen hypercall page MSR, and provide a
stub for CONFIG_KVM_XEN=n to optimize out the check for kernels built
without Xen support.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c |  2 +-
 arch/x86/kvm/xen.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..f13d9d3f7c60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3733,7 +3733,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
-	if (msr && msr == vcpu->kvm->arch.xen_hvm_config.msr)
+	if (kvm_xen_is_hypercall_page_msr(vcpu->kvm, msr))
 		return kvm_xen_write_hypercall_page(vcpu, data);
 
 	switch (msr) {
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f5841d9000ae..e92e06926f76 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -56,6 +56,11 @@ static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 		kvm->arch.xen_hvm_config.msr;
 }
 
+static inline bool kvm_xen_is_hypercall_page_msr(struct kvm *kvm, u32 msr)
+{
+	return msr && msr == kvm->arch.xen_hvm_config.msr;
+}
+
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -124,6 +129,11 @@ static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 	return false;
 }
 
+static inline bool kvm_xen_is_hypercall_page_msr(struct kvm *kvm, u32 msr)
+{
+	return false;
+}
+
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
 	return false;
-- 
2.48.1.362.g079036d154-goog


