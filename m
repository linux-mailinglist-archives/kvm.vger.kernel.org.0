Return-Path: <kvm+bounces-37026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C929A24645
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAC671884921
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40EC13FD86;
	Sat,  1 Feb 2025 01:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kb7PG6ND"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D27E12A177
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373919; cv=none; b=qxmOK/g9lAkprZ+w9mMmF5DoXaOf9p2LqPV5oZEiaXYZg63XR+myZtqHpaXzBuSu1AmFF9ktoGUWxwN1It2Nth5vzOhxp8FXMQ7/8mdYn0t6UhK2dv0CrnQjgj7CJOsjqYhHmfttfR+bOCxAvWUWkhj+CoxqFYAIx6NmIKWfcjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373919; c=relaxed/simple;
	bh=UUzVxW+A0LbHvQamjiSSU35WtkGq3vbu9aNxHkZpIfs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ADtZg/86ogHtZrsGfHUdFmY9kSrER3luQPZiTS7aJ3Ib1DwagJivgrCmVCTMOwX5ksR+sZEZkCk0NeT9PSjo/rVVMc+xBQ1KPJZq26fn7LOVJGmldxYH7WoA/5p/NTx87KFMhMcwb8psz6pQECjKXPJ3bWC68bk39f3RlfcHhdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kb7PG6ND; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2161d185f04so37799525ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373918; x=1738978718; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P0Rg1qN67xtOrW9/3acldXp82KHWRVyhcuyhp0qB1L0=;
        b=Kb7PG6NDBXebuirdoki52DwwkYmWRLS5NQ8FznNZkZeXvDJZ0shaltjsow8Jqo/lGx
         cLrVWJu+8bin4NZZZpgfpIbJag2boYx6PzYJE2eosU9pGXyhq95Kc3cuTmBohSA7BZkG
         ogvnQ81TLMOBejkAlJu7+I3qtp4pU4GC3EEhZKFODt71LoYaj+Tfwnp+/Dy2zU97iQef
         docm99OHbcAQ0kAcO5MeDvThYXpe8xqHnRslhBEHOknLStx/lBI5GDYPLsZ941Up5dOP
         1cOXS4ECCdAewkWRuTBwAM1sQtEIr8I+gR9Cm0Bx8e1U901fQlHnLOciUH37gnuuSRon
         Kuwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373918; x=1738978718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P0Rg1qN67xtOrW9/3acldXp82KHWRVyhcuyhp0qB1L0=;
        b=UYCFANwnqjTK1XIVIXjVKB5y4K2Q3to88qxo2UAlHRW2pMUgtotWKA/Tm214wokyRt
         7YVu93xsso+CqYglKqSpGK2hp7noPRvnuj1NssdoAx+3EP1mztH/n3aSpiwt+J+vfkuL
         IzigiReBcP+/jlpvkQb8QBbxvEjG64mGldoCI311AIXt1ToK/2gvAmePE8vu0+S0/RqJ
         nJTHw9ayz33QHYNEbVrHYCvQQdxVFDqAnOsxBF8FScoYKYkrtDm1JvtE7NBGZZUNAf8R
         fHRjxXPc5yWV2BFDBWFgTvUxkWAQAJSipCaI41tUA6D2Vx6yQfgtxx18eV52z61Qa5MP
         chvA==
X-Gm-Message-State: AOJu0Yxhg72It253XNmpBc3qnR8MBNpci4guan7Il27Pb7y74r/iU/fY
	J1nHQAf54L2chWxDZYmJKscsQNZu4ALp9/OPu+AWtOT3EqpcD0ZvwWJwmBU9TwpDGNklItmaK5F
	Mnw==
X-Google-Smtp-Source: AGHT+IHzrvrAtIazL7DuI5S6zMGK5azT035sFwOHSFpiw0QSUrMFD83Pit1/KumxCWsWadgyJWwokGOlwp0=
X-Received: from pgc25.prod.google.com ([2002:a05:6a02:2f99:b0:7fd:40dd:86a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d049:b0:1e0:cf9a:87b1
 with SMTP id adf61e73a8af0-1ed7a49a2d8mr21514926637.6.1738373917669; Fri, 31
 Jan 2025 17:38:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:20 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-5-seanjc@google.com>
Subject: [PATCH v2 04/11] KVM: x86: Process "guest stopped request" once per
 guest time update
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Handle "guest stopped" requests once per guest time update in preparation
of restoring KVM's historical behavior of setting PVCLOCK_GUEST_STOPPED
for kvmclock and only kvmclock.  For now, simply move the code to minimize
the probability of an unintentional change in functionally.

Note, in practice, all clocks are guaranteed to see the request (or not)
even though each PV clock processes the request individual, as KVM holds
vcpu->mutex (blocks KVM_KVMCLOCK_CTRL) and it should be impossible for
KVM's suspend notifier to run while KVM is handling requests.  And because
the helper updates the reference flags, all subsequent PV clock updates
will pick up PVCLOCK_GUEST_STOPPED.

Note #2, once PVCLOCK_GUEST_STOPPED is restricted to kvmclock, the
horrific #ifdef will go away.

Cc: Paul Durrant <pdurrant@amazon.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8ee37dd2b57..de281c328cb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3150,11 +3150,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
 	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
 
-	if (vcpu->pvclock_set_guest_stopped_request) {
-		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
-		vcpu->pvclock_set_guest_stopped_request = false;
-	}
-
 	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
 
 	if (force_tsc_unstable)
@@ -3264,6 +3259,18 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (use_master_clock)
 		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
 
+	if (vcpu->pv_time.active
+#ifdef CONFIG_KVM_XEN
+	 || vcpu->xen.vcpu_info_cache.active
+	 || vcpu->xen.vcpu_time_info_cache.active
+#endif
+	    ) {
+		if (vcpu->pvclock_set_guest_stopped_request) {
+			vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
+			vcpu->pvclock_set_guest_stopped_request = false;
+		}
+	}
+
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
 #ifdef CONFIG_KVM_XEN
-- 
2.48.1.362.g079036d154-goog


