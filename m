Return-Path: <kvm+bounces-72874-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILw6FhG8qWlzDgEAu9opvQ
	(envelope-from <kvm+bounces-72874-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:23:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 986022161CB
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 430A4307E79D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836B43EBF15;
	Thu,  5 Mar 2026 17:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jFyH2sDI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14943E3DBA
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730814; cv=none; b=MLRnabGXr/Yvh0DXPhgiLPTiXTIhyOG4sysfFRo2JeWYABOH5prdZV/aHvADozpxMPWcSnTeHnEa+AHOGRZVj+yCQEdJLEANLNQNNCsfdMT8TKHR0wKBHb+8js8pymdibso+TAta67Omhf2PUJRp3USBxhwGXsIpg7lf4UBDZSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730814; c=relaxed/simple;
	bh=LRtCjvWJ4fs/JzAIsO7bEdlv0IYFR2Mv7Nm6R1NY1zQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hGiZifqXm24OL6rhBrylVy6kdZgiFLSmTvNfhdHGe7l9ADpBgpInbbqFHWLYv3db+KH8Ii1UVWW7utg5c1rUIqIXGAnYNHckYw5aA2JiejGm78GDynxqT8rXlKyKXAfRZxFUuUXD7mR+EfqMaAh4rNXu7ZxE0PQNoxK90ZzpM5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jFyH2sDI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c44bf176so7712136a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730812; x=1773335612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q6dXhRlf5LPNu5BGZXBZWpSLv//BfGY/G30VCqGGA00=;
        b=jFyH2sDIDYHF9HAjpGw8lyvQPitYHiI5r7jZsCBLDOizlBN1oIAlf6WjojA0iLeB7f
         I+7Lu94/qLfEX1fvmGBQ9f4x653uRYXyvLxEI5w9rylEqtZEIieq+eYpqXb5v46ymXlO
         Jul+juAFI91vgKPukREAamBzLxmDEZVYxllfSG3WRP0sCSdAXtBZMXk7nPhmsLM/BSa/
         dUYhQ4Nf3Mb0wTc7wKcEGVJ6HdMCIcMcurQV5zrrEVOlLdgLsWQWMX7lL8C3B5KlIqUJ
         YrYTYGAnb6PmvkoQjcuqm6KZ1E7mH74wLBrZW3JifoAaLytP2uipXTPPl3WQsm48K45r
         yQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730812; x=1773335612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6dXhRlf5LPNu5BGZXBZWpSLv//BfGY/G30VCqGGA00=;
        b=xKTYsBshae7suBNTaxKa9sdAV/OG3LEGSHnqI4f4dxyiOHCS48VHJPeqfx0GcIefZc
         1Ljbgc/fTBJ3BizlnKlS7ajI5c+v3trnv9LBn1EcIRGRfNVvoRsIihHysaWzxvl3AMTQ
         QnBk4BQBzGeM5kgF2Pg14ALfRMMWbSo4wJtABi540uCWfuv9pz8lX3elvjL4rnvEUnbS
         4f/kX3tMoaXHwXxqjyMLoQpczocq/Lp8I9joom6PUcmBO6H987B++E4G6qRZM3Gmo5XY
         7CcxxNWqodoVZtFy5astL7EBKBsALvz02xIcuxda2NxNpmqsEEOcErTuucCHUGIoP7vn
         cDmw==
X-Gm-Message-State: AOJu0YykuGTRAqkqHwei/64BRiOkwWDdAUrznIGtSXwgwevFatkX0aNL
	rdmxuqFbSaHmTLgJFeDPsORrkdvPzKpVHpiPrWr1jQ0scymxzZjiCBhL2SYJzkbF6d1mo0n8lYW
	QrNqimQ==
X-Received: from pjbls16.prod.google.com ([2002:a17:90b:3510:b0:359:91b0:3f5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c90:b0:340:bfcd:6af8
 with SMTP id 98e67ed59e1d1-359a69aaef8mr5142608a91.4.1772730812212; Thu, 05
 Mar 2026 09:13:32 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:37 -0800
In-Reply-To: <20260123224514.2509129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123224514.2509129-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272878999.1559831.7236923298052813825.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: SVM: Fix IRQ window inhibit handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 986022161CB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72874-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Fri, 23 Jan 2026 14:45:10 -0800, Sean Christopherson wrote:
> Patch 1 fixes a bugs where KVM will keep AVIC inhibit for too long when
> running a nested guest and AVIC is inhibited to open an IRQ window.
> 
> Patch 2 refcounts IRQ window inhibits so that "closing" an IRQ window on
> one vCPU doesn't clobber other vCPUs' windows when AVIC is enabled.
> 
> Patch 3 optimizes IRQ window inhibits by avoiding contention on
> apicv_update_lock when KVM wants to inhibit AVIC to open an IRQ windows
> because AVIC is _already_ inhibited.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/4] KVM: SVM: Fix clearing IRQ window inhibit with nested guests
      https://github.com/kvm-x86/linux/commit/7b402ec851cb
[2/4] KVM: SVM: Fix IRQ window inhibit handling across multiple vCPUs
      https://github.com/kvm-x86/linux/commit/6563ddadd169
[3/4] KVM: SVM: Optimize IRQ window inhibit handling
      https://github.com/kvm-x86/linux/commit/5617dddcfa30
[4/4] KVM: Isolate apicv_update_lock and apicv_nr_irq_window_req in a cacheline
      https://github.com/kvm-x86/linux/commit/fa78a514d632

--
https://github.com/kvm-x86/linux/tree/next

