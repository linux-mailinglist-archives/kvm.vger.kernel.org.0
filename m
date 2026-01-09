Return-Path: <kvm+bounces-67499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8066D06EB2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A4AE3000CED
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6750B329C56;
	Fri,  9 Jan 2026 03:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sVDlQAwh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9D1328B47
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767928024; cv=none; b=JORJX9mT+AXvf0GJE5A/7Q7A3sCeoybVxqrdF+OIx/Ue3EwYM4wrN0G3Ce+pre1cT9snPZUjTx3ylZKtlWerWu8fkZ/fLBJ/EGutSdVgTdtaQM6BmxG2S7IlFcqzBBbSUN+SK4GI9Y9feKAQo9sIk465nqfWikiqucdFwirruL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767928024; c=relaxed/simple;
	bh=wrzQqcwVdCsiQ7G7vBjsiP4ekYsP46Tf3uSiaD+duHU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DP06nu3QvYvrf958CbkvssUOAmVItArQw803X1eiFcDHetg1dHsT9rfe5sutlJRfAD9H2Dh1w+Y8t1s0WP0ILml7E44G0gpTzAyHzt2/yVirFb67CZdYMgKTBqDk2oEsGpFvyvYJP2+Obhjaj9hq5QBiOQzX1o7nM4U5O8LGKtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sVDlQAwh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so3739771a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767928021; x=1768532821; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+5Tdd6kkAxxdHZ49XuLg04bl84lthaID8yMvU0opPM=;
        b=sVDlQAwh35BromRg772CBk2fjt/kDUvj34IqAPTVZUo414TbMTh7zHBx9OmJ0iHliG
         jEZght9kUXktOH49MC1aGzHXx7L0Od2e1MWHR2DR3xKZXSPRCzqfLZKwMwy9Q/geZFQk
         XWZtF+YdeAvZyZSUUzDhL/H2Ks8j4QDAQA6pnwWRWN7qpR0UbHeWzWTKY2GVw7glQo2A
         ZA75c1x8GxL1KVntvMK8He1l1fexEOyobIl84/+8UKUNcusQqcvtSiGBxwILXyPrXo2f
         y1nZxux9grjS5bqHmiHL50DutGhgNMqyQTgAHDSmMyiAdoCBv9KeaXXWKzWK3pEhIBui
         sFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767928021; x=1768532821;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+5Tdd6kkAxxdHZ49XuLg04bl84lthaID8yMvU0opPM=;
        b=GLQBxkkiY4dqGMIa8imLkjDNP1u+Mak35tPmrX65+IwHQkiFCtE3MWqewm4+0dwd0m
         0DOrlHYZuy7RUu7fBo/9EKO6CEpZYiPgN2dT+bn/rsjR1cyTzUwa4gkYaaZiAT4mq/lq
         jk8c0m5FoiZTD+3t1l0mHnyjM/VJUNwg7LrYbAcJzGE3c22nWGo9N440zt5MxjMOS1//
         Ag32o81QOFtGDDP7KE6R8ZMDA1sCAhoKjOyVbM45Kug7N3Vj8cS7ewmX65I+RhLSpyfp
         IIp3BlTbOSs6RVBHTaFHxCHxgjpq3Vvw3uMQ2tdiyJQaASuc6DK7LlPmNxyqTOyrKcPC
         ttGA==
X-Gm-Message-State: AOJu0YzaXpqj1tutWdxwHAWzCt7MABy9I2ysVAw2odgZcGUtKoq/iEfA
	Lo9st0lpzaSD22AvxtfDg40shPBorbcQdyFfcQcr80osntv+oMZABhXf+xc8fYlcNGHDLCkEM9R
	OEhy/XA==
X-Google-Smtp-Source: AGHT+IHPpIP9QlEWt5YOGDuvZqwqeWpmXJCZ4IVvAKuLgyq8v3Yd6QPHHZMoJNTtqLxviNpNzzz1gUoVXQU=
X-Received: from pjvj1.prod.google.com ([2002:a17:90a:dc81:b0:34c:84ee:67c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2883:b0:340:be4d:a718
 with SMTP id 98e67ed59e1d1-34f68b4e70emr8102737a91.7.1767928020685; Thu, 08
 Jan 2026 19:07:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:06:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109030657.994759-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alessandro Ratti <alessandro@0x65c.net>, 
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Ignore -EBUSY when checking nested events after exiting a blocking state
while L2 is active, as exiting to userspace will generate a spurious
userspace exit, usually with KVM_EXIT_UNKNOWN, and likely lead to the VM's
demise.  Continuing with the wakeup isn't perfect either, as *something*
has gone sideways if a vCPU is awakened in L2 with an injected event (or
worse, a nested run pending), but continuing on gives the VM a decent
chance of surviving without any major side effects.

As explained in the Fixes commits, it _should_ be impossible for a vCPU to
be put into a blocking state with an already-injected event (exception,
IRQ, or NMI).  Unfortunately, userspace can stuff MP_STATE and/or injected
events, and thus put the vCPU into what should be an impossible state.

Don't bother trying to preserve the WARN, e.g. with an anti-syzkaller
Kconfig, as WARNs can (hopefully) be added in paths where _KVM_ would be
violating x86 architecture, e.g. by WARNing if KVM attempts to inject an
exception or interrupt while the vCPU isn't running.

Cc: Alessandro Ratti <alessandro@0x65c.net>
Cc: stable@vger.kernel.org
Fixes: 26844fee6ade ("KVM: x86: never write to memory from kvm_vcpu_check_block()")
Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")
Link: https://syzkaller.appspot.com/text?tag=ReproC&x=10d4261a580000
Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/671bc7a7.050a0220.455e8.022a.GAE@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..4bf9be1e17a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11596,8 +11596,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		int r = kvm_check_nested_events(vcpu);
 
-		WARN_ON_ONCE(r == -EBUSY);
-		if (r < 0)
+		if (r < 0 && r != -EBUSY)
 			return 0;
 	}
 

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.457.g6b5491de43-goog


