Return-Path: <kvm+bounces-35904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C529EA15AA8
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0181A168F1F
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49C9824A3;
	Sat, 18 Jan 2025 00:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1AKUcypY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45572AF11
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161761; cv=none; b=JDscJmvSX7aVSPOc4/ly1O1n1IsGDdZ4RzOO7tk+fj7s9TwTtS5QKWXILU2qvnPaBjkYoL2B9ykNw/vqlowNNrPQZTD0TiRK7p79y1GqiSjd+KMTaGVM2Dd60d4CRAX73azdhLxEz37g9+VFVp8leD16kPGt0MKviHikL9jYcBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161761; c=relaxed/simple;
	bh=Re6JaOfMeqW7zBx1kUqXmRuRyZAeQXxa2/azIap9LI4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DsZt22iea+P34VEqqEhvz+z8FOjSbUxVryZhnqSXanJAIeWH4nXHFYEypgUwD1ISWvtxisXNgTgkGZloZPRPrkiV+0qrvzrK+TTzxVbnyyKoSfyCXDlaEHFjZvjVF422Vd2PmMUr1mnQoziGL3MYqQpMSuD6sUrLXt9+PO2bm9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1AKUcypY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so5225219a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737161759; x=1737766559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BWg391tw9c+kOeFxLTnt1zsgTfqyDcOA+e1U4rmehPY=;
        b=1AKUcypYIc07ODfK/u0JsYMka1Ui6vfk/ecTE8uiRQoNtZEyINbfJYWS83IKhvsKWr
         +vTf6eexhB4o0W083deUmYWbXIcrP90HVQnc5xGDQiWEQrKlx/yd91xAQN28dG7OGxwg
         LoF0ZQLkvQPvANBU+VB7bXn2AZAtpsltsIdgfd7hTmRfVAKsnJV/lU40KtDtBvTh8jPc
         o5EEZ7hZr+RZDG9b4alm8dPTFAXJxu4vJFaMNiebPS4TRWY3fdQ8cLjsPToyYfWJEk0D
         y77WAC+10S7djittZP0nCQYSZqX4CDiCIUgMjoUFqdcEWPtC4hm5hDJ7DGQ1nL7yGZHo
         +dRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737161759; x=1737766559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWg391tw9c+kOeFxLTnt1zsgTfqyDcOA+e1U4rmehPY=;
        b=Bk85G2Aj6vODpcQo1U4BicZxxImwUcsRQyWxKErPoCrgkyxxR5fksclYSysrmh8+LQ
         25698Kbxp+qjtMCYQr9RpvecgYsLNQD54CJ8+Q12CcqnrZOrGGjcf7PBl28wtNzTFfXV
         DdjY2UlenVZGU6NnGVNrZhuLYnYsbYzKBQb4nC5ZPZaDvfRTpcw+SlWbAkS88bLKFKcU
         be+X43I53LNZe4oUxbdHWb3vtFOtJ4pHzYQopXzWnHzP1GzI4tjOWVADyEodq3wTGsZK
         qauI0ah6wGQ+dL78uTKJmiKz51cXRR8pHfq28oRDgmg9/FuuICdXJN+QTWyNA09Bg6nP
         X0NQ==
X-Gm-Message-State: AOJu0YwTYj0+s4HfCqk13JNYBAHXx0On2i+Euy6i3M4iSOn/CAk+eJgS
	7tyegMtkR7kNl7YRrTs8YN9oliF9nELo7ZM0AEa5B6+O6HMNQ+XtVXVZXz/0mxBbZgUpRYYGhxS
	N3A==
X-Google-Smtp-Source: AGHT+IF91N/E24CDCeKFDja0F3kfDaJYkCm4ZjErhAsLwyG21uJ4YMyaWeGoc4lBz6gpAs6skETxGTCOn1E=
X-Received: from pjvb5.prod.google.com ([2002:a17:90a:d885:b0:2ea:6b84:3849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b8e:b0:2f6:f107:faf8
 with SMTP id 98e67ed59e1d1-2f782d2e546mr7359245a91.24.1737161758948; Fri, 17
 Jan 2025 16:55:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 16:55:44 -0800
In-Reply-To: <20250118005552.2626804-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250118005552.2626804-3-seanjc@google.com>
Subject: [PATCH 02/10] KVM: x86: Eliminate "handling" of impossible errors
 during SUSPEND
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's handling of kvm_set_guest_paused() failure when reacting to a
SUSPEND notification, as kvm_set_guest_paused() only "fails" if the vCPU
isn't using kvmclock, and KVM's notifier callback pre-checks that kvmclock
is active.  I.e. barring some bizarre edge case that shouldn't be treated
as an error in the first place, kvm_arch_suspend_notifier() can't fail.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26e18c9b0375..ef21158ec6b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6905,21 +6905,15 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
-	int ret = 0;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!vcpu->arch.pv_time.active)
-			continue;
+	/*
+	 * Ignore the return, marking the guest paused only "fails" if the vCPU
+	 * isn't using kvmclock; continuing on is correct and desirable.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		(void)kvm_set_guest_paused(vcpu);
 
-		ret = kvm_set_guest_paused(vcpu);
-		if (ret) {
-			kvm_err("Failed to pause guest VCPU%d: %d\n",
-				vcpu->vcpu_id, ret);
-			break;
-		}
-	}
-
-	return ret ? NOTIFY_BAD : NOTIFY_DONE;
+	return NOTIFY_DONE;
 }
 
 int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
-- 
2.48.0.rc2.279.g1de40edade-goog


