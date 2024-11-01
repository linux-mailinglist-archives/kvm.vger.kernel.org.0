Return-Path: <kvm+bounces-30356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 827899B97ED
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 209EC28257E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7C81CF7A4;
	Fri,  1 Nov 2024 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gllua3GO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1CD1CF5C9
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730487041; cv=none; b=eee36M5Nvm514/6ZcojIIitNKPuuAo50V4NlkIEWPsTQGJV8mh9e6cLUE1tZcQZDWqMCl/BOKdebX7FXC46UXX3Wsv4MdwE09gIgyL9y5MSNsNia12KQUuSKIFh0+yhyYB2so8ZxLj+jB9yR58c28qm/xXkLnj9ygoXcUx+zWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730487041; c=relaxed/simple;
	bh=oi7IAoQcOg5WfTGxiROoCwhtHXzWHhv4zXEZRSmtMbg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sMelCr/85gjfLQWKrAoabISB9LxFZBIdXJafW6ijzSB/d8gqU+RL3tT2a3jHEECq8gE16Si90LmX57h5/N7XKKUz8Ka83spXeOjshi/+Byb9p9FKr9h/s2QtqgODIAaznqKNzN2nhBdVGZaUEz+/bWvS6Lq9i6yuMkIGfRR0vDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gllua3GO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea7cfb6e0fso15177b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730487037; x=1731091837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ic6iDoLfcVDucJrkqYdRqza1krMbj5qI/J1lxJLbkd4=;
        b=gllua3GOOhHB96Fv/9bZdu1DrGEWYSS0Nw0EuHAgJXWU0gOHyn3Pi6bKglCKdZtcPV
         gNmYGfpsi78MiXiifMs4j60E5OU3/MglNJCFX7nO+5xp9OvQlmWI80zsbpTJOrYQq0rp
         N+Ps9foJFLJejjt6GFMweymipa3FIVZ/nkswhqthBMgTJ7aMW11fonkNysl3wkUDOkAB
         XSggxV3jqk3Ktm8lG41GXYPvZHNyvGJrAFvnLOwi0qiBY5gwr+fFAdMQohtRClsMEaJM
         Hq/qMzBH4bzQN5Kw0fRLLWuTA1tJXxWFvFk8jWgqv/V7bGKrxc636GOGNBr2YZtfG2uj
         rZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730487037; x=1731091837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ic6iDoLfcVDucJrkqYdRqza1krMbj5qI/J1lxJLbkd4=;
        b=jYPLQ4qGCBJgFKiRFMWjXKPYDGsTjGaB6C2mW9WrgeC8Rw4PxFwjwu5eCjD4jgNNc4
         2VVgUXSKRDpTXirQUGN7WRN+3JMRx0wVeovx++DGpAcQ0D7LTDZ0KqKOB/90AsBuUJxi
         GHGoGcSJt0EToD96ScF2Tm31i7p5d88q5XJ3bDfBo3h0yDGRVU5q3gywbs5qPgs56/TQ
         jcSdHKWZKGvL8CkaUOc+oM0Dms6zeT/iNpFxcNsiL2XcxP1hBEVe0pqpNBVL609AEt26
         KA3+PQZV3lIEQOPvIODI9UIq15ZAjM5XMGT2/1ofYe02rC7KyY74qcaB2Y2SBYbU2Vgq
         ob1A==
X-Gm-Message-State: AOJu0Yx3h7SJEh3VxmESOaOp+ZJHFT0baI+diOgW6Lh1b8h1hFPFa6DK
	smVPA3kwXL/hY/kNg6epTAzI3X2dceKGTXyQ/PzkOdsBaOEc4lhOOKAWWJbsA43JSh93/4jjRny
	GGw==
X-Google-Smtp-Source: AGHT+IEkbu95UQw2snU5iSNbl4n19k2Z+fSaBb2BzWzjzl50JWCCUeeSuI9IPN5ygRD+4oHb1XeSOOZPLwk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:23c8:b0:6e6:38:8567 with SMTP id
 00721157ae682-6e9d8b296demr2263367b3.8.1730487037504; Fri, 01 Nov 2024
 11:50:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:50:31 -0700
In-Reply-To: <20241101185031.1799556-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101185031.1799556-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101185031.1799556-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: VMX: Allow toggling bits in MSR_IA32_RTIT_CTL when
 enable bit is cleared
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Adrian Hunter <adrian.hunter@intel.com>

Allow toggling other bits in MSR_IA32_RTIT_CTL if the enable bit is being
cleared, the existing logic simply ignores the enable bit.  E.g. KVM will
incorrectly reject a write of '0' to stop tracing.

Fixes: bf8c55d8dc09 ("KVM: x86: Implement Intel PT MSRs read/write emulation")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
[sean: rework changelog, drop stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 087504fb1589..9b9d115c4824 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1636,7 +1636,8 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	 * result in a #GP unless the same write also clears TraceEn.
 	 */
 	if ((vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) &&
-		((vmx->pt_desc.guest.ctl ^ data) & ~RTIT_CTL_TRACEEN))
+	    (data & RTIT_CTL_TRACEEN) &&
+	    data != vmx->pt_desc.guest.ctl)
 		return 1;
 
 	/*
-- 
2.47.0.163.g1226f6d8fa-goog


