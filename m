Return-Path: <kvm+bounces-48891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 215D6AD4637
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38FC73A6F8F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62B82BE7AA;
	Tue, 10 Jun 2025 22:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PUKOaA55"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B5229CB4F
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596275; cv=none; b=QggSi5TgmuUQNP39/NLliQc/JQmTlkpVKgbxPThUkh8/BSlxEbq70BGct3lHurEyztnhV+aaF7Jj9kDHxpOKINfoFgiv7Xf2qeisskOAqKHOoQLLW3JVymMNaFTk7VdGF4pFgKATNNSgW1FK7phnoVDQy5NMIMk9gJwoH46hvGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596275; c=relaxed/simple;
	bh=IrLy/Df3wu3wMxRH1r5QDaoeLkis8ef7ilxDGxyhByY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=naM47DGrXYjdelO/PGSo1ZxyiA7SUVN6+4EZjGVhkzDLNitu5gK3Mnolmp9WeLU9Oeoo4CIJUUXY4yIkv2ZjgcYqo3B9YgTVP+OZSi3RmgSNEN4NgOcORxSl9jz9lyiDdxFBfmRnOv6+9GGjz7Lvg4mn1eEdQ7FSpBDX8tosW3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PUKOaA55; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2323bd7f873so50428635ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596273; x=1750201073; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TPKLATaGLc00m7kXvQ3la9x8CEEHoqYxndz/QonAUuw=;
        b=PUKOaA55UUrMe/zaVvtx3DCCb3CcNfPkA0AdHZrF7E87XRInnkMuH3qC0Yy1wQvoKJ
         I0v+2lxobFPs3mFn8U3iTTH90xt7nwwPLYs81H9SvoLr19QUmZ1fP8U5wTzhLmUMPl1D
         fktg/Yvc5HuTvKAM1vIQNk8DSUFUt3X7sLDhGDV5VUjm3PMwVsOoIJqFSXF5X1uRO3Ql
         eT6mar0AGPnPs3FUGlgRGwKZUTYr2Gey/fUyT9rj2klhl917aJLCl8INJcMlREQHF+VV
         jnz4PvKFM17PjK4mY4nvuv6lxVlceFF9gpZ9GjetqAyO7aH1lQgrQdQOptp8cmRabGj7
         PuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596273; x=1750201073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPKLATaGLc00m7kXvQ3la9x8CEEHoqYxndz/QonAUuw=;
        b=aEdo+LmqAg21eThPmee6SS5a5MSdtW2F0FuAX5GJvW6TumQGGwDZ2r17daFqVSPYjd
         0ZKDpCG9+Vjl0TKzkdSGeixPOU/oogSm+YQsilRpDvu6Y105vPcvBgvaAw8r+dnSXLDg
         /gU8iBJsqsBQ4i+riSph0pqfNuzjpHMMSHXe9wgzt56Y1laQp3CcAn9eTdftb0zd94A0
         eD9M0L21eQP/qGqPnchg4CGTHLWZt90ej/BLPaFrFxNZwGmovzTPxcJcZinsb5R+lY4j
         2XUXuF8uSlESRsC/N+75rhQLgM4NNH4CqaeW6s2oG6aKlgS0x4mz5UPzpIdFtg4u3D1d
         i3fA==
X-Gm-Message-State: AOJu0YxrTtW4hr9nz3z0GNWEplfspRmi4jyR31+zJP07Z8zHXnxFIFCK
	hooma+oltnuK07lB8nOXpElXMabXeqn9qZ23PtDyROBRtIEMeqUTcX9hHiKei/gpI7p4IZYapOW
	fOE+ngg==
X-Google-Smtp-Source: AGHT+IFHmWkw5WMiuFEFFkIcQA8B9UzGjXdAO5xpW5JgeQVVsN57Lc31dpZTMJm+3EEUe76E0nIN8Hgi7Xo=
X-Received: from plsc8.prod.google.com ([2002:a17:902:b688:b0:235:f4e3:ba29])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e548:b0:224:910:23f6
 with SMTP id d9443c01a7336-23641b29b81mr12563265ad.45.1749596272908; Tue, 10
 Jun 2025 15:57:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:12 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-8-seanjc@google.com>
Subject: [PATCH v2 07/32] KVM: x86: Use non-atomic bit ops to manipulate
 "shadow" MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Manipulate the MSR bitmaps using non-atomic bit ops APIs (two underscores),
as the bitmaps are per-vCPU and are only ever accessed while vcpu->mutex is
held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e39b9df61f1..ec97ea1d7b38 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -789,14 +789,14 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
 
 	/* Set the shadow bitmaps to the desired intercept states */
 	if (read)
-		set_bit(slot, svm->shadow_msr_intercept.read);
+		__set_bit(slot, svm->shadow_msr_intercept.read);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.read);
+		__clear_bit(slot, svm->shadow_msr_intercept.read);
 
 	if (write)
-		set_bit(slot, svm->shadow_msr_intercept.write);
+		__set_bit(slot, svm->shadow_msr_intercept.write);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.write);
+		__clear_bit(slot, svm->shadow_msr_intercept.write);
 }
 
 static bool valid_msr_intercept(u32 index)
@@ -862,8 +862,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	bit_write = 2 * (msr & 0x0f) + 1;
 	tmp       = msrpm[offset];
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
+	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ff00ae9f05a..8f7fe04a1998 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4029,9 +4029,9 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			clear_bit(idx, vmx->shadow_msr_intercept.read);
+			__clear_bit(idx, vmx->shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			clear_bit(idx, vmx->shadow_msr_intercept.write);
+			__clear_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -4071,9 +4071,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			set_bit(idx, vmx->shadow_msr_intercept.read);
+			__set_bit(idx, vmx->shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			set_bit(idx, vmx->shadow_msr_intercept.write);
+			__set_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
-- 
2.50.0.rc0.642.g800a2b2222-goog


