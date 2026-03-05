Return-Path: <kvm+bounces-72850-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CH/dDoC5qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72850-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:12:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 574D5215EDE
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EDE49302B741
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262503E5562;
	Thu,  5 Mar 2026 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TKTS0hDw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C99F3CE4A0
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730627; cv=none; b=T/doZjRyQi4yK37fqh9Jz5rxlc7ang1kriZ7SBw2RxuGIRBd72+iHCaRiBkIDrYMHt8qP2wuqWWR0pG4Tm8aXuaiembwcfGOfDSoEur5c1njAwITaDXJAx+ozyZL98esLr+LsaShYLdQjH0qya2wkMTTRO5+2PNoDmm7IM9VKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730627; c=relaxed/simple;
	bh=X0md63byT501RHUj1lioKqQW9yTEX1AyB+HzFd8OGOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=Gc02cwS3QmH91ulzSh85VfoGVf6G5kMWF2QA6iw31lAcmH73aRS973vO94FUIC8NTFb9yEA2iySSJpaggTb2+dweD77GEWy5PGxIdcSo+ggqAYjp2fBoLgpoagmbwv6nuG6TukSfyBEOsyU0A4gMCWPgBO3QlSiFXQVwpSJQicU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TKTS0hDw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso7658460a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730625; x=1773335425; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dUsMeyLQ2UY3LWiFVo8pb6h/K8U2JaXxnAh0XjBCYdw=;
        b=TKTS0hDw/5T/F130KNA8CqEeHuzjTVffPOXNDpY+cGa0RpUjF9TqG4nmZPqG9MsM44
         JNYtt3JGiIZuP4Su+pXgYsX4BAwYSwB3Vs1QasPT2u3N1xp2KkaAqlS5FHUI6oiVC9Oz
         BMGT+DPfywRL/J/brn51iIZs9tYATSa7VRLYK4eHlnlYrEzkF/2poLKu6PEXNrpACDyN
         AVAgV6hc9qFPkl2wvZ3kZG/0P8sk56g8+j6w6+jyLzEzQ9hctJ/fcw3ADlo+uE9ZV1n6
         X3D+5/TTUlvsju2xpa2KSR+adZnBsHhAKZOZonCkTKDzAhZPeQBzJnltwVGC+X9r3fj0
         Dn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730625; x=1773335425;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dUsMeyLQ2UY3LWiFVo8pb6h/K8U2JaXxnAh0XjBCYdw=;
        b=I+VY/1nwfvJ9PZK8HNxm6skzGHW6FUcqbOe931U55ge0ldNbcMqziE/dCzxN1CIeBX
         hFRmZZlBLQAYHJb9DQXfZ8VBJeDCuNDL4XEY32YLblHQfGyZgvi0lx6patWyLsck68rN
         QJmpqGppWglSkssFzT2LIuL3OS5oVccihDZV2ZiUZdTd5X/OqWTIo0qIusaJt3x3gZw+
         8kDkHacYUCbyZUPiZ8qKptoeTxS0RzdEqK0WHCh8UqVoRS5qpLU1mDXQ8SEy2YTBbqbf
         W82PCS7e0U7pgmte0pGxEJlykoMrhW3M/UVBS9KQyQAXoZQMwQzxszudGaq5Uc7iS6Xi
         yuHg==
X-Forwarded-Encrypted: i=1; AJvYcCUWN7FIIVmd5pWu9DusVo+ZS7X/d0xmsqjU0ONsEW4pyB6MM82hRjhWng4lnEGRIOXjr14=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtLQuSjY09nf0YFDUzdwpVzFQqg8ixSfO2IAbhI0Igf8RsLXRq
	Bl8hrn/iPUmBowYJNCgCyyCHkVBzrb2KP470Se2lE/eToHoG6hOG+xBL/SRS0HI3ZsLhrGrwtNt
	qFNsNyA==
X-Received: from plan1.prod.google.com ([2002:a17:903:4041:b0:2ae:41f3:1614])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fa5:b0:2ae:5848:bada
 with SMTP id d9443c01a7336-2ae8012e5dfmr3270845ad.10.1772730625238; Thu, 05
 Mar 2026 09:10:25 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:49 -0800
In-Reply-To: <20260210234613.1383279-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210234613.1383279-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272951368.1564818.13503975701518727580.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Ignore cpuid faulting in SMM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jamie Liu <jamieliu@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 574D5215EDE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72850-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 10 Feb 2026 15:45:42 -0800, Jim Mattson wrote:
> The Intel Virtualization Technology FlexMigration Application Note says,
> "When CPUID faulting is enabled, all executions of the CPUID instruction
> outside system-management mode (SMM) cause a general-protection exception
> (#GP(0)) if the current privilege level (CPL) is greater than 0."
> 
> Always allow the execution of CPUID in SMM.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Ignore cpuid faulting in SMM
      https://github.com/kvm-x86/linux/commit/690dc03859e7

--
https://github.com/kvm-x86/linux/tree/next

