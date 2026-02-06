Return-Path: <kvm+bounces-70508-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDCRCaw/hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70508-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:23:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AA80D102AD3
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4FCB130419A7
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714F23093DE;
	Fri,  6 Feb 2026 19:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z+rgQ8gm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F032FF161
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770405481; cv=none; b=p8viEQyBWIhml5mDE/dbjX9qqFfIVyPtbWlG29HotaU/iUltdo1P1ESrZllmWeNFnpsYlN8JDRNmbI5088xY1ys0dOwNh6t5bBNORNadTPeptLkYNtqcyl3GFjlKQzb1qJSQN4+aGez4KtV8OOf7Y/fZsRa3R1zIZApzMY20feU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770405481; c=relaxed/simple;
	bh=tNneEUSRpNgvU++qw3Ls81TMA3bi+XNQ+D4Ph9I27dc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mJy0MlXhIPn5rhrD0pTqTnyHRCLFjssspr0T1UC+8Dm0GzdyHix/ewmgQ71+MqsjRHf5O6musFMNQJeTDm1wSNKlqQ4teZw0nYZ6peEqh3QKs6OcvMLkavQIbKLJADXVgYrDpJF346p6+aGEE+41qh6WGRbzptShn2jGlewf4bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z+rgQ8gm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c65d08b623aso1766518a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 11:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770405481; x=1771010281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HocNkdNaDiGeWVOi6/l+5YPl1rtto8z6MkmTCj9sFOI=;
        b=Z+rgQ8gmnUY4bxH9TYCyBqibIPpY6mDPcPZGUjHglb/k+Ylr1v1SbNzJ4igSUpo+Jk
         F0D46uiyRoSxwrVQ8PaMVvFL32m9iclmLX3rIjsTVUaeM8nGls2aQVvkceBv0f5BQKaF
         OL7KBynL5Lahs5hWIFkHI2EJNGVNTWDx1+5M5+FKBii6YShD7yAtYP9Gh1HqNJ1+IIcq
         hy6eWqU8xIrZ29MBEGtZUjBqUsyZjMpLnPe3cTOEdhBzo0s5lBNdPBVkhPzSUZ+t5YI4
         xr5ciQytw55B0A+YYdnohlfLb1n5PctmmWHSnE3GxLqUCEqwDuHbeqSxV5WUJ8iQbTRr
         7tVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405481; x=1771010281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HocNkdNaDiGeWVOi6/l+5YPl1rtto8z6MkmTCj9sFOI=;
        b=FAfkk4C6x6AZPZZvK19+8/DO9NP+OHa9KZvom/82IW3DWm7xmVEOPkTIzJis+0YZv9
         cm6vl+8OwkAo/22SfY7Hl3lTt7JHOyuJ9yaIJbCNPPizlEIZX8KNZgCHmFrhCeiYz5Yj
         nQJZy0tb7vjAnWMZbPW/hhrsX0bfDmAXekhl5KI00Fhr0h3BqTtYhbiAJMV5ANxC64D/
         rrxnHYKBl7eK6ZmSkcKtiTmcvpvomD8RqrImeaQfKlGa++XoDnKDm+Pq1AlYkqwjH3zD
         I3ia7fo6Xt6ehq+c32JSv6bVJ7NPidLIQKlHYzi9KAsvYDsczYpBk9aYOlNZigST21g0
         7WhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiW0/vpXweFhyz9+qWF5YfHLuRCAAYtry3i52yfZABwcFuCxCEd9bp6bHdF8pPOMdu6a8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+BUnckrXhrteK3okrTf0Y3eLazABwQ5J2MkBGDyc9r//BD7Bd
	45htB0RaG9Cxk13Ujg8fkVvZhALU3DG5VvxfCkVaK1BS33nCUZQGPT+Q/0QUhCyTVBApaApQZRB
	+xEAD6w==
X-Received: from pghp20.prod.google.com ([2002:a63:fe14:0:b0:c66:f3a8:71ce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5499:b0:375:9d1c:1b29
 with SMTP id adf61e73a8af0-3938fc274a0mr7086263637.32.1770405480857; Fri, 06
 Feb 2026 11:18:00 -0800 (PST)
Date: Fri, 6 Feb 2026 11:17:59 -0800
In-Reply-To: <20260205214326.1029278-8-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-8-jmattson@google.com>
Message-ID: <aYY-ZwjEnHbY5J-T@google.com>
Subject: Re: [PATCH v3 7/8] KVM: x86: nSVM: Handle restore of legacy nested state
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70508-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA80D102AD3
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Jim Mattson wrote:
> When nested NPT is enabled and KVM_SET_NESTED_STATE is used to restore an
> old checkpoint (without a valid gPAT), the current IA32_PAT value must be
> used as L2's gPAT.
> 
> The current IA32_PAT value may be restored by KVM_SET_MSRS after
> KVM_SET_NESTED_STATE. Furthermore, there may be a KVM_GET_NESTED_STATE
> before the first KVM_RUN.
> 
> Introduce a new boolean, svm->nested.legacy_gpat_semantics. When set, hPAT
> updates are also applied to gPAT, preserving the old behavior where L2
> shared L1's PAT. svm_vcpu_pre_run() clears this boolean at the first
> KVM_RUN.

State this last point as a command and explain why.  E.g. I think this is why?

  Clear legacy_gpat_semantics on KVM_RUN so that the legacy semantics are
  scoped to a single restore (inasmuch as possible).  E.g. to support
  restoring a snapshot from an old KVM, and then later restoring a snapshot
  from a new KVM.

