Return-Path: <kvm+bounces-72395-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DGqISuypWk8EgAAu9opvQ
	(envelope-from <kvm+bounces-72395-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:52:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E561DC2E8
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0B9F03012528
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78663FD155;
	Mon,  2 Mar 2026 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JiB3Loky"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BCC41B361
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466725; cv=none; b=JdhJSDkopKJDVd7lFItEVOh+l7AJU6ALQ25gMOUDgAVw/h4zChWoSCV5ajRzMtU8UWoWCAamQGUEkmNwsOMBtGVeLbf92AjWB9Hg33kTpfgJJ5kcagD8yAfAMK8bWuYNKF5PAT8puaowceVItQVJCIfdWyqPObxYMFtvKzxPmSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466725; c=relaxed/simple;
	bh=B+o1rsb8OmzJfPsA0gPC6Soareqf1xfasJ2vFgutzvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mx6p7exoGgv1RF3dj+cVBBKsSRBCKY7iH2QCkuw+PYmGFy9IVVb3LxsAw0l73ox5twUsbVxJ3GLrcXkC8eh7lBl+ucn0EIDew16fmPL0JJcK4267naHfJ6ihnagZl55ua2T5IgyzsJ3cNXOXT31nnzuaAOaJ5f4qz5jZp2Ki1YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JiB3Loky; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3594620fe97so24003118a91.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 07:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772466722; x=1773071522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RyUPIfgfZZduoActvTOHlc6gVP0traggxHBpX3oyJGg=;
        b=JiB3Loky2/vtrfS2kXtT+xEucbyUyOu0Nr8OwRU6mqMtz5pjmKkTqFk/W7Y7xOFKAE
         3rRMfNkD8zgpwyqSWKffEoqg7CjNALpM9MuYCffTI+I/6/C2iXzI9Yn2bD32PjJnyfe9
         fS1YV7CFKWBgNPyooUmaMSxMaiKl0p2ITPHbQSKaOY7xHL6QBP03UX4r4nheh+2Rddlz
         GpcDxtZm6EZn07QxiewcWGJ6hqytZKC2bMW4m0Q1oxWmvqI2MSNLTHcw8o8AJGrooiIX
         ktazh8MpKkxSfiEYWy6AE4wXe+5aY3awI5c5Eupa2iFXm4ZReu4kzJeVdYn/YEb59iL+
         5FfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772466722; x=1773071522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RyUPIfgfZZduoActvTOHlc6gVP0traggxHBpX3oyJGg=;
        b=MXFIJiTtUvHg7QosGhX073XCEEO0hXrjEypSO2hbM6D2h4vSscd8Fk2Dwapeg741qa
         Q4HF4IEdT0m0F/gel+kR3eLmfVwlb9acyY2mmYqop7+J/k8oktNx9TiC7sTZE3BWeIzy
         DAt72jrvlvHaxThYZyDDL5MlNeTRLML9M8z5rXP9sHOP7JCCRU8q5FpLiPyrfvmFE+Qq
         iJHlNRStkBK+CcesVkNbG0itCJxnL9LFyMOmd/1AMDEzb0xV+QyUtoUFlJVm3ZuNMlFV
         IjgOwT+rt4w+qEYNSTKxgcoz1yBTPWpvForvg2ZlLekJ0nQWhI/HJ0vRZEJQZnYN7w7t
         YmLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXu/pOysDTRJ99EcmWzo/mn2xRbhtF5HOvqyCPZMy23RAUnTmznCGPaXDwmiB4EoDyPoz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT6qhx6Yba/QohpH977DmzAqDUiP+pi9O6dg9tsq+nwV4pD/OJ
	qWdNY75DLOMQgXHZnp0FfpbTXH22KkhohtkA9rx1Sh7jeSr4zJs6kr49GS9sNjraHl5wCwumzFL
	T6mbh/Q==
X-Received: from pjbch12.prod.google.com ([2002:a17:90a:f40c:b0:359:7dba:bdec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:f950:b0:349:9d63:8511
 with SMTP id 98e67ed59e1d1-35965cc5566mr9935398a91.25.1772466721474; Mon, 02
 Mar 2026 07:52:01 -0800 (PST)
Date: Mon, 2 Mar 2026 07:51:59 -0800
In-Reply-To: <20260302154249.784529-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260302154249.784529-1-yosry@kernel.org>
Message-ID: <aaWyHyB91OolxRD7@google.com>
Subject: Re: [PATCH] KVM: x86: Drop redundant call to kvm_deliver_exception_payload()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 26E561DC2E8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72395-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> In kvm_check_and_inject_events(), kvm_deliver_exception_payload() is
> called for pending #DB exceptions. However, shortly after, the
> per-vendor inject_exception callbacks are made. Both
> vmx_inject_exception() and svm_inject_exception() unconditionally call
> kvm_deliver_exception_payload(), so the call in
> kvm_check_and_inject_events() is redundant.
> 
> Note that the extra call for pending #DB exceptions is harmless, as
> kvm_deliver_exception_payload() clears exception.has_payload after the
> first call.
> 
> The call in kvm_check_and_inject_events() was added in commit
> f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery"). At
> that point, the call was likely needed because svm_queue_exception()
> checked whether an exception for L2 is intercepted by L1 before calling
> kvm_deliver_exception_payload(), as SVM did not have a
> check_nested_events callback. Since DR6 is updated before the #DB
> intercept in SVM (unlike VMX), it was necessary to deliver the DR6
> payload before calling svm_queue_exception().
> 
> After that, commit 7c86663b68ba ("KVM: nSVM: inject exceptions via
> svm_check_nested_events") added a check_nested_events callback for SVM,
> which checked for L1 intercepts for L2's exceptions, and delivered the
> the payload appropriately before the intercept. At that point,
> svm_queue_exception() started calling kvm_deliver_exception_payload()
> unconditionally, and the call to kvm_deliver_exception_payload() from
> its caller became redundant.

Nice!  I vaguely remember staring at this code when working on 5623f751bd9c
("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)"),
but never pieced together that it was redundant.

