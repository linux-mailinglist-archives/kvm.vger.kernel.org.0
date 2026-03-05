Return-Path: <kvm+bounces-72853-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDElAuW6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72853-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D27B2160A1
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:18:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CDB9319D292
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA113E3DB7;
	Thu,  5 Mar 2026 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wgzE1b5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63DE3E3DAD
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730651; cv=none; b=nmufjhMdISl3cpGllRGA3NchMoBXYvA849YUw7qwmtI+VW8ouFqDEAEluBH3HOYIuQiIvkpEkxCowP/XnxUmdMkiiQ2r6CEsNs91L8fMfXZxiETO20IF8704LrY8ifCbOZPuqa38N2AKmUPsiOguNctlsF23uogowGcZJ7jWM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730651; c=relaxed/simple;
	bh=AlDtxc7Bihsnc3dPHOZLblr1JaL+P3MAUHUD3Xov9Qc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d4RgRbBPxRgZC99KOHBVeCklKjqoEUl/58qG6K1pvUuVL9yw8RhgjGrmCylIzxDfOJ7xVuVvjRLAcojuRUiudlO+0BNTcI158K4pkU1t9rqwXKtc0WuSnSmEFxVRoU1dD+ap/bfl7puxymXS5eBVTzAxtDEVfZqKmAO/WadwGes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wgzE1b5L; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e7f45e2ddso29345492a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730649; x=1773335449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JgnKfLZM0W1XovRDdtNuu2zU+kanU41FEanEQ1F7nA8=;
        b=wgzE1b5Lw31pTdNVawta0vopxthUwDisukga+NsagZa6pDdAcbO2DqdZ/BoXdbiJ14
         Y6RzQNhSITQ9ZDXFqrhnEb9KW4I4J1S0sBEBHtdDxhg41OAnfAKiznH6abJ6RlyhBDSa
         aH01va8l3yoB9PTDNe5svJazM/ijAPvxe1fNFKRaMqi2wgE67jEy1xvcNl7A1IbB7+io
         F8c84Ej9Mhs1I4gxYXJa3QUH1zEQ7lLF5+F0aPB58GIawtjUK4/Hn8ijlGc94/qJKH+H
         wzLo72MQ1iCXJDs5ERlhXy6A23EzyfADG97jfIDIC2ytnE1+1juUiFlBXHjDjSdudKzc
         lmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730649; x=1773335449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JgnKfLZM0W1XovRDdtNuu2zU+kanU41FEanEQ1F7nA8=;
        b=mIa1xg9xJgc0l70mU+tnJ4N833deEiw0DJ6DRWbhVq5O9LjyrnfOZGse946jRTh44w
         e59rFyu1vTptojSsNu0uBpMF2IZ+nr+bh8xjO7Vj/Ne2WADR14a/NWLCk/7PghwKYfDd
         xU8s75dz0KG4OYRARDNu0K1zxFHMVLAlB2qm5ufjCIwrGs4aY1QCABbPqvoqIkv9fyPz
         GRbspSrtD7mWn9FrlEvIRFDih3iyZ2rLx3/moX12m04T+/EVI4A5LVFRnaUUDFTNE8ND
         ly1dchcCgfZKzPnZUIth6nNyBF6m22yuOB9SZtchCJcaqMR+71nVXfJWDdW6W0DI0JhL
         LW4w==
X-Forwarded-Encrypted: i=1; AJvYcCUXiuy7w2vuFA8e3v1FhCIGf7ifxNkbm2x2bjA6uTes/1AWlZJsFS4GX/aPPRa8Olz/kxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRZL18CJUj1l5jABDErzdPPtg9row/EGBHLK5EEKE7Ac8ak5Hs
	kKbkfx5FRJptFu7O/eVU5Vg1pt31TcZ4Kdugi1W7i0VgM6Qgxo/FVm6U/EYLxQvP/3+3ZupEVJR
	GBExB/Q==
X-Received: from pgcy13.prod.google.com ([2002:a63:7d0d:0:b0:c6d:ce4c:d0f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6182:b0:387:5daf:b302
 with SMTP id adf61e73a8af0-39854add03fmr221314637.65.1772730649120; Thu, 05
 Mar 2026 09:10:49 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:55 -0800
In-Reply-To: <20260302154249.784529-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260302154249.784529-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272514565.1531888.4887575677908302121.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Drop redundant call to kvm_deliver_exception_payload()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5D27B2160A1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72853-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 02 Mar 2026 15:42:49 +0000, Yosry Ahmed wrote:
> In kvm_check_and_inject_events(), kvm_deliver_exception_payload() is
> called for pending #DB exceptions. However, shortly after, the
> per-vendor inject_exception callbacks are made. Both
> vmx_inject_exception() and svm_inject_exception() unconditionally call
> kvm_deliver_exception_payload(), so the call in
> kvm_check_and_inject_events() is redundant.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Drop redundant call to kvm_deliver_exception_payload()
      https://github.com/kvm-x86/linux/commit/43e41846ac7e

--
https://github.com/kvm-x86/linux/tree/next

