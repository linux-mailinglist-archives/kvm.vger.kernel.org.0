Return-Path: <kvm+bounces-72098-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ARjNkHMoGmlmgQAu9opvQ
	(envelope-from <kvm+bounces-72098-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:42:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 863971B07DD
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B4D43066BC6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB43943C045;
	Thu, 26 Feb 2026 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DdmsiBbu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CE93921FF
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772145713; cv=none; b=gFyYeDnTS7XgEapoS9qVllGEDHS1weeSDndG5W0BTvvwnbra/UWMilrvO9IxUJJDW6RbT7XkLHBdZ/JTIgM9KbXwCMmEQPRA71Jq5Yd3hS3acQOWS1gYuAyHnh0CXIT8G+HKVNtqWqsvAO5K0CJ8Vj9bXJRbwYMTsroPMLK56pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772145713; c=relaxed/simple;
	bh=EE6GmT8NjOpc/Q7ertjBUUmPFSaMLXg3rTkL8NF0PGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sjM3lzq0QNNztUTqRIwoV+hE3c+WPd9smtKBQ+3rVMgTjwZ6LfcZ3pm5e9QimweuEz4Svrd2C+PrGfklhsa7Hgpu2IkZnyWeU87oJUtWbpzfE8XFpGvFP0TGbxJusYIMTR44h/d0nOqPY7OSkVlCx+JB7SjJg5kXMnNkgH3QZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DdmsiBbu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae04f58b19so65775525ad.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772145711; x=1772750511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aLJt4yGqQRTkBEAc5QYieMxMLzj5mxMuDSRSfCPYdnQ=;
        b=DdmsiBbuNNAFxnlJfYuHsvOmJqK2OlFni01y4HlUDlMqSNSXrF17Sxl2UuEjcYvRsb
         BR0kNR1NUeDoXi1zwR6O3/6pViWULupqNYov3hYaSh6gVjzHs/9nTqEtGapZd1V0wSHg
         z2HYZpqDEgEKPmE7+1m/c/pdeiC1G3/OFQhjX97Jii5o/96xTT2WLMaQDzqn2P9QBB0M
         j1A8BOkdcncnQlQewffhJaApxyumlczKoIljVii65+cQ6/k3Jh8QO4S3PrGXPPOtm+0N
         AY5UC5ik1cRdgTd1rR7l9PoYxvYoXw20bM2vh288we3iapm9sY5xKNn4ew97TsEOtCJr
         6bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772145711; x=1772750511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aLJt4yGqQRTkBEAc5QYieMxMLzj5mxMuDSRSfCPYdnQ=;
        b=efY6LTEspZ0aUoHEQgoxDJ6KzGgakYTe6vAnUsfi8b3Xq6EdSXf2vVSwigatRqCldj
         S77tQF9hyKsDWXLCZKBA6SWrxJq598W64LzUgsckfEUPlKCN/QV4OGIKYrja8O+J1Q0H
         Gjy/RISzOdB7OYjDpd/ykeA5kA58ElUnDDZEEO9d6OH8wpHWAr66HFrlJ+Iit4hdL1tD
         N/F55wTa7S0AEEUETk5WmK1o5TX59ptIcG5WFT6gpDtDMVoce3GeDX1YVnFDXf7UDeJu
         WBC0QJviJGNVS14ldeLBg2C82AIYMal+bdLc/Im544M+84psKkNI3Yd3hSPexVAcsiIB
         ufng==
X-Forwarded-Encrypted: i=1; AJvYcCWsvgFKgtpgbk7wiATd/QXV75eslTHH7YNUzjEVzUJE8xyJYs5TV1mL34R6D4BAsdM467o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8l7neQCS+cSLmlybxO/IcXaePPcOSoAAmT8fYIqw5GGgTkDe4
	AVqRflumAx5KIWCEIrlGF67bj69jZNtVAt2qZNbkpqZuen7D375xicdP0ZZzW8VTjoX6lAEjabJ
	dyEiK+A==
X-Received: from plbmo13.prod.google.com ([2002:a17:903:a8d:b0:290:aaff:140b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:94d:b0:2aa:d1e1:29d5
 with SMTP id d9443c01a7336-2ae2e4e7a65mr5356825ad.50.1772145711467; Thu, 26
 Feb 2026 14:41:51 -0800 (PST)
Date: Thu, 26 Feb 2026 14:41:49 -0800
In-Reply-To: <9a196181-cde0-4c9b-b9ec-f0c18eaf9cfd@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223215118.2154194-1-bvanassche@acm.org> <20260223215118.2154194-2-bvanassche@acm.org>
 <aZ3r5_P74tUJm2oF@google.com> <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org>
 <aaCHS5ZRuW-QJkK7@google.com> <9a196181-cde0-4c9b-b9ec-f0c18eaf9cfd@acm.org>
Message-ID: <aaDMLW5cykzaSsQL@google.com>
Subject: Re: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
From: Sean Christopherson <seanjc@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72098-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 863971B07DD
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Bart Van Assche wrote:
> On 2/26/26 9:47 AM, Sean Christopherson wrote:
> > What's your timeline for enabling -Wthread-safety?  E.g. are you trying to land
> > it in 7.1?  7.2+?  I'd be happy to formally post the below and get it landed in
> > the N-1 kernel (assuming Paolo is also comfortable landing the patch in 7.0 if
> > you're targeting 7.1).
> 
> Hi Sean,
> 
> I expect that I will need two or three release cycles to get all the patches
> upstream before -Wthread-safety can be enabled. How about
> giving Marco a few weeks time to come up with an improvement for
> RELOC_HIDE()?

Works for me.  Thanks!

