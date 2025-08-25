Return-Path: <kvm+bounces-55671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A45AB34B81
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 313E97B6EBB
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 20:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654F9245021;
	Mon, 25 Aug 2025 20:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NWmdMSd3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DA7288511
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756152391; cv=none; b=Z49DFHInmFjE4F8Gu+Qi6L/lqnhuePAF+1EDmNwjwiuclr7xt3vq0T9u6UUrTvSlwGYf/RAatvCA/PZ7oubIu3wqPNvDzueKDjKdCYh6KeikSxs4z0m4pJtzlDDLqQr8HPVB+ogzwMyNulNc0CAzKsELaW0AV6C9b+8Hlh+PIwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756152391; c=relaxed/simple;
	bh=CPxGdk0WNt19VUixP2aZz/PEan9gfYpnqsgV+WcH6LI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jwtXc7DT4rVRsBwL0mvLt3T5pWjxfFBw6fP4wkJJfLXYH1qEMbnrd0C2WWQz4DJNYBzjYpZjVCQF24GRzKWRlUdCVpopHxVow6g/UGPCUNzzxUewnrozyi3x6iVdNhAcCQAdsonM10OLZDFBemSQRJM8/d6c89NH0heZZL9jSAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NWmdMSd3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77057266cd8so1507803b3a.2
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 13:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756152389; x=1756757189; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+oyHFbNT6msf6glrd5KFIdZcOF0+oR5scj5fBrCtJpc=;
        b=NWmdMSd3Lh10JlmT2fWKv02KZDQWiuEQKdysC/tiz9kaKQ/k4A39kYJnNa2BNLKkM/
         VpttUz9ySpgSnao3Bktbskfo+UjH3o+87N8A/tCWclenpElnhwJ/rxC11zWTM/WC5Kl9
         VOV/tc2lcMAeDu6jkkFHcmHv0rMmCDlJWgYNPzcKRCMVn+7ywyg7QLfRgjWtmziNPaC9
         dq4rkucXgreYX/IiVgJWe048tjvvkJ88x/lrY5JKODFhuLDnU9iFSEtyruFaSdYb6pmx
         +SdTY5qfATYC9PJyU/uHK9omJ4W368olV7Ml76H2TxsU1+w/cBza7VntthPaigx740Ya
         39Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756152389; x=1756757189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+oyHFbNT6msf6glrd5KFIdZcOF0+oR5scj5fBrCtJpc=;
        b=Pd+9Ndm9j/vHOE9p+HLkirFCFU/DXn7fMNj5vFMxz/o+PSGo52l/y6eK5Bewwlptc6
         wMUMzp6c2qHQ7lR+zA5uEPERfLPs1RJ+mmC8L735s8s6ZEzDVybRgzH3lhXwI+OI5S+u
         JT7mXgotTuIa22uK7PZHoJFC4paL2DgfIVVEQw8/x4S/5k8U75N2xDgoco/M88OwjaJO
         +KH0Wq9TCo4uwPgztA60MOplBKyOYeE48UnUyOt7G3MjvcavYBWg81LvWEFSpy3rk1os
         xcCgZLZ/W4UKfjdtrVhAcmPdmX/1Wz2oJA0uHiL2CdDNr4FDKZKcXHtMuJ5zAI+7EX9A
         5O6g==
X-Forwarded-Encrypted: i=1; AJvYcCWCryNtPWBRSxGPCJsKFc5CnpJmRICKSGPlp+Ifzwz6Gl3KgESZu5TGR8HYiuucD12CTqU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcdrs/vcLuydJ74IYSrWtLwr6PZqrF3MVjnfx/OGJ9MvYoXhbW
	jhlYvTvL01QuVo9kY7HmQZNrOxbXiwj2wPty6IFJ+H1Bgy3MvOW1iXJWGchbSE1Ohlo4Cy6JZ/X
	NYL3FvA==
X-Google-Smtp-Source: AGHT+IHf2Zj5lnIbPMIr1AZKuHUHSE22v55RmD47MKsgM79RfmKmA7vJz/pJwEChfBNBSyo/bobLCf+GttQ=
X-Received: from pjbpq16.prod.google.com ([2002:a17:90b:3d90:b0:325:7fbe:1c64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0f:b0:243:78a:8289
 with SMTP id adf61e73a8af0-24340def606mr21242988637.48.1756152389107; Mon, 25
 Aug 2025 13:06:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 13:06:19 -0700
In-Reply-To: <20250825200622.3759571-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250825200622.3759571-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250825200622.3759571-3-seanjc@google.com>
Subject: [PATCH 2/5] Drivers: hv: Handle NEED_RESCHED_LAZY before transferring
 to guest
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Check for NEED_RESCHED_LAZY, not just NEED_RESCHED, prior to transferring
control to a guest.  Failure to check for lazy resched can unnecessarily
delay rescheduling until the next tick when using a lazy preemption model.

Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
index 1acc47c4be0d..b953b5e21110 100644
--- a/drivers/hv/mshv_common.c
+++ b/drivers/hv/mshv_common.c
@@ -151,7 +151,7 @@ static int __mshv_do_pre_guest_mode_work(ulong th_flags)
 	if (th_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		return -EINTR;
 
-	if (th_flags & _TIF_NEED_RESCHED)
+	if (th_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY))
 		schedule();
 
 	if (th_flags & _TIF_NOTIFY_RESUME)
@@ -163,7 +163,8 @@ static int __mshv_do_pre_guest_mode_work(ulong th_flags)
 int mshv_do_pre_guest_mode_work(void)
 {
 	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
-				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
+				 _TIF_NEED_RESCHED  | _TIF_NEED_RESCHED_LAZY |
+				 _TIF_NOTIFY_RESUME;
 	ulong th_flags;
 
 	th_flags = read_thread_flags();
-- 
2.51.0.261.g7ce5a0a67e-goog


