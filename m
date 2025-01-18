Return-Path: <kvm+bounces-35903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8955A15AA5
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22919188BB23
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4D639FD9;
	Sat, 18 Jan 2025 00:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOl8pk3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBDBFC08
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161759; cv=none; b=JpGWvDe9ycVn8iL7yrRKKlFp4IRhXr8+cWNy2mKOQiUG+EUHVYseBMAkn6tNOypGLh6T1iHOMHmUbGC6MiZv2xKy5wve6uL/ygy5B7nC6x3XiYLcw2wIA4YNWsz+nwTDKda/SaDEHFICB0ZZZU9KiZHcPYrEEm7JdF8YVTeeQIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161759; c=relaxed/simple;
	bh=3W53J50+PZqHyOi55W21xUUEtSE7zym4UMN7fIOYvUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XCwGlD2WMJ3TI3NJnqUS5mEyL781VaPT+kmoV/flJ+09S2KSmsSaOpn312CdHlzGB+BNScuLgNLlS/186K7e14eGCNhBcALkOLUdVjeYpHzOzKQyQ8G+13je+KD0CW7Jtk+DpJySKpGJvWzjGCh5+o8tA26cyzwQXF/a6lHO+Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fOl8pk3G; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2163dc0f5dbso52507715ad.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161757; x=1737766557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w3jKkxzKwjJ8beEIQ08OLVGokkXfzypP1bi1T3wcCZk=;
        b=fOl8pk3GeIhpBhmTBcUxejdcBwyvnm8a2Hw85KbH0PzW/a23oOIkq4QW7LLvYKtA1J
         dvGrMXLOowC/swIsWYXAIs4hhEQL6eQbrkuEq4gum3QeNlZ+rbr+ul32LhUhbfiaMgXR
         PTlrnNZmEmXxI7S97EJqftcCNSugoc/V22uOjhgepi6nLNIpG00zVX1k/szjd+efQkEx
         93U9iClKWDJPoiPHmdR4GNqnlCPkqCES2/Pewtb43rEjA42DAEp8v+v1gXXBW3iKdp++
         sHT/Zlj5nx15orHH0Hvj2NKSeCDn3ZX/E1VT9/9idDwp3Et3nO+LrYE/DQIH45+FFiqC
         I5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161757; x=1737766557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w3jKkxzKwjJ8beEIQ08OLVGokkXfzypP1bi1T3wcCZk=;
        b=WnX4qxlO34ondJA156pUU5nox8pBAyD+W0c3odVFs/ptAl2bjKwi59/6psQjQZrIr3
         c86TfGrNl+rqewBpYAgv+dX1xJqUv6E42mf565H0tfkRc24as4o4ddYzJEmCm6cPtptf
         YFwVLn74+GLhOR34a/GXg1PFVsf+C/k1a/9cI+qwA1uaMRjk12i3hBTLyJuNc5dDRRM8
         5vsHfQ73shEl/4zqeTQtBWPyyLQP/kkIsUDw4XZqKRfWUTjb+EkfG38s2cxa5rlQAQ7y
         7VBJPdlrlUAUYO6afHE4PbgUIzBywGBR/vAoQR/RLHZQk42XA+O5/Z/dI5D49oPRTMWq
         plUQ==
X-Gm-Message-State: AOJu0Yy2dLf0mPVCO7HJGw+6GJJKx9WFjJ1HWxadMLOYz+YP29ivs0Qx
	gNCeBhic5IY/5QrgdZjnkbPtrb2dKsjD6YXy6n8eBpkgjWTkfE3BC8qRXA7cynHzp/BcCURrqO5
	iHg==
X-Google-Smtp-Source: AGHT+IHDT9joR9cdsp+VvTozeNXaSD2eBRPEOZSTTQK4J+0dAHY/ZBseFJage8oAqq/8EXcrwND5x/Ijih8=
X-Received: from plhs6.prod.google.com ([2002:a17:903:3206:b0:216:69eb:bd08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2342:b0:216:725c:a137
 with SMTP id d9443c01a7336-21c3556b038mr70332835ad.28.1737161757140; Fri, 17
 Jan 2025 16:55:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:43 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-2-seanjc@google.com>
Subject: [PATCH 01/10] KVM: x86: Don't take kvm->lock when iterating over
 vCPUs in suspend notifier
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When queueing vCPU PVCLOCK updates in response to SUSPEND or HIBERNATE,
don't take kvm->lock as doing so can trigger a largely theoretical
deadlock, it is perfectly safe to iterate over the xarray of vCPUs without
holding kvm->lock, and kvm->lock doesn't protect kvm_set_guest_paused() in
any way (pv_time.active and pvclock_set_guest_stopped_request are
protected by vcpu->mutex, not kvm->lock).

Reported-by: syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/677c0f36.050a0220.3b3668.0014.GAE@google.com
Fixes: 7d62874f69d7 ("kvm: x86: implement KVM PM-notifier")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..26e18c9b0375 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6907,7 +6907,6 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 	unsigned long i;
 	int ret = 0;
 
-	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!vcpu->arch.pv_time.active)
 			continue;
@@ -6919,7 +6918,6 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 			break;
 		}
 	}
-	mutex_unlock(&kvm->lock);
 
 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
 }
-- 
2.48.0.rc2.279.g1de40edade-goog


