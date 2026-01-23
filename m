Return-Path: <kvm+bounces-69028-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8IPaC376c2mf0gAAu9opvQ
	(envelope-from <kvm+bounces-69028-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:47:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B13F7B3CB
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73CBA307974F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A803D2E8B97;
	Fri, 23 Jan 2026 22:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CplhEJpb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625202DB78A
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208327; cv=none; b=XKcDVxMrbAS+bwn9jOwxoMEZA/sGGswzlpMsgb/YufdzoIqHcAcq0tF2j/Zxiah5LPxGsvgJJOyfbqfY6Q8NUzC2jmkd8JDzCPm1qxLuZiQn0umjZFGpRMhKzXdXjkOOAteY2pJi+6hXp7EJPMLG6PH6FfHAkoYvfIXDVMKIjqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208327; c=relaxed/simple;
	bh=Ccvg+AYwTTpgd358fTNaOhaa4kNk7pNmtPUuSx54YI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IcOGLy2VpMgF8KCBHcO5FDLQ5hVZIs7dB83TGIDkyy8yEhzXKo/k3aG6lj1mz0ty5KswNYEip/3Gma0K/Ru7KyVOOi73CfNyL+aF6Al5nlzMdmROB6oMBoksaj02+bNu7jEnCnwexE52PlOqSp0NJBg8eYASOOk0BdpswnSCDrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CplhEJpb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a78c094ad6so24386995ad.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208326; x=1769813126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Na3qF+OZinsVySntYS5W+c40/G1z3qAxcjUlnhMcrIQ=;
        b=CplhEJpbs/vQQlqQIyhUpnxr/sWGsnF57+S3Yf4J1PaY9tvkfn3IixgRPqZ5kn+XeK
         bGXJ7hmLfkyr9Ft4eyVk89ZApPujIkD3KsEvVAGvpjwM66bVLlx/CA2h3nCsdURA9XiU
         qjMbqj43xa6ed0K7P+ZwOWYcN/OxG0NMyP/FSBTZ2tO1741DI5eBt2XJdghcWA+QonHC
         YIt5dsXP+UNjwQnKADFw6HVGycj7X1TquVd81eIfrGw50547C3rGJ7T0mBapVt25u4L0
         cMK9PieDGU6ExXGuehcbpIkN/L9FvP+Gwm9h0uko8tUmKqscQ7O5a3TOYN9chLfIspt4
         3PBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208326; x=1769813126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Na3qF+OZinsVySntYS5W+c40/G1z3qAxcjUlnhMcrIQ=;
        b=GYgosjeNm8BDqIddav/tt06KWTag5AqQ1W1TO8mygsAuzwuFRP5ifFZRqtBTtUP845
         xZ6JnSPOIcoaIyR2uMv7WHNWfhK84bigGU4SMtBUICl1Fn9sHMxuCgGpP4RXWQXEMsIs
         Bhoj1zsy6lSbXnsIa0PM9s40cTR532LWNSecpP6yImCZd/AX54KpqRybX6MBUC7A19XR
         HxJY5tj6d/LQpg0eRENICzcd3jDxy27zLkDQa9KlRi0aVactGAJY7maZkB/7XrVz4Yy7
         aWZ8Zc9IaY5HrfZc9BBhZMoVrmUEZWx4mi7SqR114CLU3aONsaxCxICo8APVd1N/uxBu
         D+4w==
X-Gm-Message-State: AOJu0Yyy0/BjFKJVkjWQQrtWr0Lc/qp80Q41Ej240PVOayCffvEnX61C
	tjrJYhslF1ZS1O8/y21ngH3DllP+wag1bLrH7ccBlho9guM7Il50OUFdiozy59XGJEs1QkozcZ/
	vXcDBrg==
X-Received: from plhy12.prod.google.com ([2002:a17:902:d64c:b0:29f:26e9:4ade])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:98b:b0:295:b46f:a6c2
 with SMTP id d9443c01a7336-2a7fe625074mr37894025ad.37.1769208325807; Fri, 23
 Jan 2026 14:45:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:45:14 -0800
In-Reply-To: <20260123224514.2509129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123224514.2509129-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123224514.2509129-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: Isolate apicv_update_lock and apicv_nr_irq_window_req
 in a cacheline
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69028-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9B13F7B3CB
X-Rspamd-Action: no action

Force apicv_update_lock and apicv_nr_irq_window_req to reside in their own
cacheline to avoid generating significant contention due to false sharing
when KVM is contantly creating IRQ windows.  E.g. apicv_inhibit_reasons is
read on every VM-Enter; disabled_exits is read on page faults, on PAUSE
exits, if a vCPU is scheduled out, etc.; kvmclock_offset is read every time
a vCPU needs to refresh kvmclock, and so on and so forth.

Isolating the write-mostly fields from all other (read-mostly) fields
improves performance by 7-8% when running netperf TCP_RR between two guests
on the same physical host when using an in-kernel PIT in re-inject mode.

Reported-by: Naveen N Rao (AMD) <naveen@kernel.org>
Closes: https://lore.kernel.org/all/yrxhngndj37edud6tj5y3vunaf7nirwor4n63yf4275wdocnd3@c77ujgialc6r
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b08baeff98b2..8a9f797b6a68 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1435,13 +1435,23 @@ struct kvm_arch {
 	bool apic_access_memslot_enabled;
 	bool apic_access_memslot_inhibited;
 
+	/*
+	 * Force apicv_update_lock and apicv_nr_irq_window_req to reside in a
+	 * dedicated cacheline.  They are write-mostly, whereas most everything
+	 * else in kvm_arch is read-mostly.  Note that apicv_inhibit_reasons is
+	 * read-mostly: toggling VM-wide inhibits is rare; _checking_ for
+	 * inhibits is common.
+	 */
+	____cacheline_aligned
 	/*
 	 * Protects apicv_inhibit_reasons and apicv_nr_irq_window_req (with an
 	 * asterisk, see kvm_inc_or_dec_irq_window_inhibit() for details).
 	 */
 	struct rw_semaphore apicv_update_lock;
-	unsigned long apicv_inhibit_reasons;
 	atomic_t apicv_nr_irq_window_req;
+	____cacheline_aligned
+
+	unsigned long apicv_inhibit_reasons;
 
 	gpa_t wall_clock;
 
-- 
2.52.0.457.g6b5491de43-goog


