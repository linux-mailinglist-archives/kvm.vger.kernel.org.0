Return-Path: <kvm+bounces-59737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEF8BCB19A
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0F601A65084
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F218A28726D;
	Thu,  9 Oct 2025 22:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKtQKp1a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713D285061
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049172; cv=none; b=uE3mEsgobV3mVd7sSBAQXtbZJNpNLTBGZqoFnRRwyFnVUnM6kktpHHU4SSofooejKNyiQyV7wWlXpGbHR/I0/HbkSpup/YphoHHMHCyFGdDnqtydYNc/fnb9YOZT1RI9F8jU+hlnXvd8+Eah1o3yzfvG3APjL5X9yYp0kS5Q+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049172; c=relaxed/simple;
	bh=VtLJFFSBsGEHPc/6nZToj9iBxiDlOtSi55iPHG6UVBo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IR3VXe9CVILrkkA9QOW1B2vedy+PsmUB3HunOZ91g50by31yygT3PGLepHDmjvMflzTv8H+GDslW2nm4NYanECgM4F3sBfIuKLDyhlW4ECVYnTje9XwftFEAqUa1xL7wVDCO0Y5S2fgF7Xals/ADZzs3b0wOsOp5Q+5WNYG6mIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKtQKp1a; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27eca7298d9so60914205ad.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049170; x=1760653970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VolBEqp3kNIS0KUhEVEbJzPvWMYFE2OXa+eVlj2/DUs=;
        b=NKtQKp1aEO0mCihXC8Oq6oMZiqRnjMOPe8R3rkiBKhbFt8sRA0ifX0flXF7h/jgxGx
         +Cn0f3iXCdNI+m4rr46yI11Zfq44kxbx9bLHQHs8RvQF1qyMFD3p+pB04h+AOU1sws+3
         npS7Oosxb3Y9q29V9vhPV74yl1iMkTD1ALkmK+vgpM0vNOyUNgJRSU5xRJpe7wFZ7KPn
         7nSyp+nzNJP3cc1qILV848ZVSPgUxplHa8eMQwMVbFgFhUcUckymDMV8SLWinGFX2DeE
         HXPygPOa+050L0MzF7I50ePb6OL3UOVPZu+FyDlb1RRCXHmQ1temxm/ZSusNSeybIoD9
         BLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049170; x=1760653970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VolBEqp3kNIS0KUhEVEbJzPvWMYFE2OXa+eVlj2/DUs=;
        b=lDh4iVhVOjnYwAuN0v/9TjBD3SK7AR1i0VkYILaE/DA1Px+3vgMeFTdQqSvOF8h4Df
         dMAy+Dq26MDnonZpE02caYb3/GW9NqDoybCTzOYDR343f4GFEIfFhEvc5eZANtCM8aj3
         yCMTk4nzVrVVNFuSiLJmq5VXOXQ1IqZwNP+0FbofJqTpZHfaoYSejakoF0BuEDcqMQcg
         nExwvS4cL5yLPJ1mf3wPGrJimMK40rSH2V1EfxcF0tJAz0p6gItRr8e+//u9yhMtDLWq
         uGnvb4gku72JKp2s8VTfpNWX4IzsgC8r4ncAz2pK/w/t6Pty+enrzF09a83mloWSHKen
         6Fyg==
X-Forwarded-Encrypted: i=1; AJvYcCWiOd5yldeUPVj+V3/FRFoobR+yvrAGmdWe+XURbAHKR9disaUuftxflqekxDnNaJqq/7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl3N6jqDiNuApseRPz1cXoygEdTuLdXnmm4buhALAzJs6VY8RN
	emCLUdsC4YQGb1syhUJBTAgndH5cFKDJue/WAmJ0qUtGxjjCPN/TbgXS18Q7m9i9wjJQITK6W3h
	c/y/vSkE5x5rgYQ==
X-Google-Smtp-Source: AGHT+IELbBqE7i135KN/NlmZgFhQHlBvbcQE5JsT4YnZrBp8eZXQD7fSGQ+imNWV5jZRB4o4fyygUIQfBPzu8g==
X-Received: from plco2.prod.google.com ([2002:a17:902:e282:b0:24c:7829:4af6])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ccc8:b0:271:49f:eaf5 with SMTP id d9443c01a7336-290273ecb42mr114457065ad.30.1760049169925;
 Thu, 09 Oct 2025 15:32:49 -0700 (PDT)
Date: Thu,  9 Oct 2025 15:31:33 -0700
In-Reply-To: <20251009223153.3344555-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251009223153.3344555-2-jmattson@google.com>
Subject: [PATCH v2 1/2] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0
From: Jim Mattson <jmattson@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

GIF==0 together with EFER.SVME==0 is a valid architectural
state. Don't return -EINVAL for KVM_SET_NESTED_STATE when this
combination is specified.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6443feab252..db0d4f2b128c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1798,8 +1798,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
 	 */
 	if (!(vcpu->arch.efer & EFER_SVME)) {
-		/* GIF=1 and no guest mode are required if SVME=0.  */
-		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
+		/* GUEST_MODE must be clear when SVME==0 */
+		if (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)
 			return -EINVAL;
 	}
 
-- 
2.51.0.740.g6adb054d12-goog


