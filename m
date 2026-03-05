Return-Path: <kvm+bounces-72858-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKN8DRO6qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72858-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:14:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9A9215F8A
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E43AA303548D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 597AB3E5EC9;
	Thu,  5 Mar 2026 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XoztsY7y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6AA3E120F
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730702; cv=none; b=EZjXTUmmrl2d3mqWvF94ypV8rmEfRNwFumcEunh1KGIGkKyHaayLGDcRwxuhM45WF/i1TaovAeNYZILVVypRQ2F7IhM/9ED67K2dR2ElFhxdsBAlwhpQ3gVZd7TImWZtY5UcThjQAszJ8msmh9djVuw97H9Xnt6JrKuAfoEOJoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730702; c=relaxed/simple;
	bh=JtB1Di2OtPr4RpGwFobdQOCEjgH0gFWOmeB1J37Y9+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tGsI7n8OpZmHEI3XwQSj5//7aVegj1K6j/tdMrxITI5WMMUotE6AIH7yFNRYLplUcFZ0vgjJAO2HAIi6AWCCq4v3kijgvx9AH0g7AUZPaf2CdKFkVQrqoquKviFrEUPMxa9QqEYuo+UNzURXMu5CTImYdBKM9Zy6ZWjStcXzZSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XoztsY7y; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70f19f0f37so4605425a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730701; x=1773335501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1yNmc6rFmiW4AMKph+yivOb17prqvxn1o0vEMrDAJo=;
        b=XoztsY7yg6MwCWfrWX1a/r61s/KN+FaMR1Bsv5QGfXi2CHf2ppWRUwKeBzAa2UlqK6
         zZVMasHkzVTy3dBSLBqZj6tTcgTZb5CQqnJZDd5xi5RXoRqjwml6HcVuIS7GNS1nb/XD
         zQGlHBgmclK9kYFDWiPd3g5Y+WDkjd4W7C7mNAcEw3Tf81QbgwBE8PmWHXE1FT0yKC36
         Qvv1I4vdrpWJelfwUkR7HZjq5f7n8H0ISfsMVB/BgRL7gmJvWdc45epzaAQySV6u4BTy
         fzGAljKLLsrttQAMCF+TD2uTuPpYT+Rf1NgtEBTFhUbmUGCXrufoDz2fE1/YOuYu+uDC
         l3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730701; x=1773335501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+1yNmc6rFmiW4AMKph+yivOb17prqvxn1o0vEMrDAJo=;
        b=FJQqRK+WW+48gJkkFWoWC15z5orCIf8mOHMLGX+WXEV5lzwCH/gP/vDb7PyUEyuAPe
         oJlyz4C0jmTiNXBEgBKbBLCrsO8kiF+EDe9RZcg0HElhHbTZ/Rzwz9h87l5RUqHFnGWs
         buFqa2s21FMPzj6tH4eAU1yNMhnZ2aVcJc3wFn6EX2ykF2aEuyR+VVfcoIVYHGZrh1UC
         kqCAu27GOFjnnCSfcSTPzHb+HuwEIH83CJkoYCwLaqAuPJl4G4uX8rUNMya5xTUXJ/P9
         pcttahOBN8nUGihwkAcgkwdrqzh0LNanBnQD6Daxynk3VinVtE4Hj6eY8Y2h3+0gwasF
         h8CQ==
X-Gm-Message-State: AOJu0YyUnZ5YF+TrXC1ODSDxEPOh6hNlKu31gTFchnepUl0OjNjsb7w/
	WzvAkghlwCBqeIwfnRtMsh7a4TRzSl2VeEmDJDnzSbwb8WDC/cO4DKnWlEwKoMXkhKsJRL8J5/3
	InQm1Iw==
X-Received: from pgq23.prod.google.com ([2002:a63:1057:0:b0:c70:e97f:35fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d8a:b0:394:f617:b418
 with SMTP id adf61e73a8af0-3984234e102mr2939456637.4.1772730700686; Thu, 05
 Mar 2026 09:11:40 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:05 -0800
In-Reply-To: <20260218005438.2619063-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218005438.2619063-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273034095.1571234.9266729763779276819.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Defer non-architectural deliver of exception
 payload to userspace read
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 1B9A9215F8A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72858-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 17 Feb 2026 16:54:38 -0800, Sean Christopherson wrote:
> When attempting to play nice with userspace that hasn't enabled
> KVM_CAP_EXCEPTION_PAYLOAD, defer KVM's non-architectural delivery of the
> payload until userspace actually reads relevant vCPU state, and more
> importantly, force delivery of the payload in *all* paths where userspace
> saves relevant vCPU state, not just KVM_GET_VCPU_EVENTS.
> 
> Ignoring userspace save/restore for the moment, delivering the payload
> before the exception is injected is wrong regardless of whether L1 or L2
> is running.  To make matters even more confusing, the flaw *currently*
> being papered over by the !is_guest_mode() check isn't even the same bug
> that commit da998b46d244 ("kvm: x86: Defer setting of CR2 until #PF
> delivery") was trying to avoid.
> 
> [...]

Applied to kvm-x86 nested, thanks!

[1/1] KVM: x86: Defer non-architectural deliver of exception payload to userspace read
      https://github.com/kvm-x86/linux/commit/d0ad1b05bbe6

--
https://github.com/kvm-x86/linux/tree/next

