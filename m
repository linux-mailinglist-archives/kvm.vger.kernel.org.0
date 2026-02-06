Return-Path: <kvm+bounces-70387-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COyBAgA9hWlY+gMAu9opvQ
	(envelope-from <kvm+bounces-70387-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 01:59:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52750F8C88
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 01:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CC313020A58
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 00:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE40230270;
	Fri,  6 Feb 2026 00:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UCs/SgG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0F1D5CFE
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770339567; cv=none; b=ec7hibo0LZ2UWsX6+6zPBSAlzJaLcoSyH56qAco9wFGW506AHMcGZ+/vFS9l4yi3fKRzT5kpcIMFGb8szOyWP6jQvRCn5Cprq0Fm7i6+c5KR30i3ltYhHYfEUYM2QLlYPUOi3xm0SElTV9rWKXdytZPiLM/9NyCj7MK5/Vg25AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770339567; c=relaxed/simple;
	bh=Z22E8Z/xOghP60bXDHWrbjG32oKG5M1OjVbLTZohHJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nNWadEC0Rb7NVqxHeU+B2uF9ZOjSpLu9ptPtBQv4tjxeuD/UrmDohTf044d1WxAAkY70qAzTOJ+CX+IT0QF/HAmI8WdAsknqT8FIcIslhfEaXvo9F7ekO1H5X14ExpZWKGITYXm/+IqZzGsnuEjbamnyLW3AYPY8DOk02/U4e5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UCs/SgG8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a13cd9a784so1281285ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 16:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770339567; x=1770944367; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a/Tid1mYhZU5lXa7L9EYLX8oTkVKGe9BZFcSs1D+TSU=;
        b=UCs/SgG8Ap/yPaEETn5YmJMt5b0rTtbjyB8ej7F54i7cKLIdqAN13bM8tWV02vQM7S
         BZgSQ7icuJreWb4qwWfIcLrmS1FLD943NHvFgbmK6p5WcByBDyf7DjnhBUnc4oygZjYs
         B5RAP1Ki+SX7cFlgIXULiJfttbbU2aBPrML/swcAMk3eCgXKtM6v/Lf6GBXdh3wwU5UX
         Ca2aIRhFg5QjZAbt//ZnVkCZvkamHYDRf/R5TjKhffmFDIKYFvpwe7j3NRQzahOrFk1I
         ycPEIuQf1JlqcDTedSWeI/JNxZTdh+26505JR6SFzI5GQXO68rSVhnQ3t/j/Qg6X1ZGE
         210A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770339567; x=1770944367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a/Tid1mYhZU5lXa7L9EYLX8oTkVKGe9BZFcSs1D+TSU=;
        b=hoOD6BJeniiw+aMq8nq5Hy4XwmVs9yluOQGPsoleSiOdqhlMaoub+AZjlkPrlYdBC4
         V+bBJiJ1hGLL9JCzkwjfPxJJ1wG2VXivRXamsv0HUZm9v0A7e9njZwqWf891By93LNOj
         oRl4tKnOWIC3TjZPeQhC+BEwcUxB4UGC8mya9t9aCeZiSbvl6kZjUh7UtPLBXJ+SIJH2
         8N0XCE0LiqlHVEGkgxx11+bFlIk6D1E4yQNJ87VhA+Arxrw2Ew52oGeGlFUFYnDH224m
         QLFHC1xGJ4d/EKFmFzPVzUqapfkj5yVu2pR7ywMt9L9vs2m2Qki988PGn6sxCsOV9eCn
         R+Tg==
X-Forwarded-Encrypted: i=1; AJvYcCVDpqYtZ3Dq8kPVmVMzYcFv/NTdVcMaOxjZDQMACTVV6lWtjBzCFTmGJY7I2OPVIaK78eQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMHLa6R/ZvyQzNGcKdwwF3Z6u3rdpzoza2hy5Qa9mDEfVKpGkj
	ZMP9Vms1MVB+Q5islHANTvTkVmCpKgrz7shCFCaDMXWw9MWSoU2TXvzRGf0GbgEd5DhoGWplnUG
	CGryvpA==
X-Received: from plbmj7.prod.google.com ([2002:a17:903:2b87:b0:29f:25b4:4dc4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e746:b0:2a1:3ee7:cc7a
 with SMTP id d9443c01a7336-2a951666792mr10607745ad.17.1770339566983; Thu, 05
 Feb 2026 16:59:26 -0800 (PST)
Date: Thu, 5 Feb 2026 16:59:25 -0800
In-Reply-To: <20260115011312.3675857-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev> <20260115011312.3675857-2-yosry.ahmed@linux.dev>
Message-ID: <aYU87QeMg8_kTM-G@google.com>
Subject: Re: [PATCH v4 01/26] KVM: SVM: Switch svm_copy_lbrs() to a macro
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-70387-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 52750F8C88
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> In preparation for using svm_copy_lbrs() with 'struct vmcb_save_area'
> without a containing 'struct vmcb', and later even 'struct
> vmcb_save_area_cached', make it a macro. Pull the call to
> vmcb_mark_dirty() out to the callers.
> 
> Macros are generally not preferred compared to functions, mainly due to
> type-safety. However, in this case it seems like having a simple macro
> copying a few fields is better than copy-pasting the same 5 lines of
> code in different places.
> 
> On the bright side, pulling vmcb_mark_dirty() calls to the callers makes
> it clear that in one case, vmcb_mark_dirty() was being called on VMCB12.
> It is not architecturally defined for the CPU to clear arbitrary clean
> bits, and it is not needed, so drop that one call.
> 
> Technically fixes the non-architectural behavior of setting the dirty
> bit on VMCB12.

Stop. Bundling. Things. Together.

/shakes fist angrily

I was absolutely not expecting a patch titled "KVM: SVM: Switch svm_copy_lbrs()
to a macro" to end with a Fixes tag, and I was *really* not expecting it to also
be Cc'd for stable.

At a glance, I genuinely can't tell if you added a Fixes to scope the backport,
or because of the dirty vmcb12 bits thing.

First fix the dirty behavior (and probably tag it for stable to avoid creating
an unnecessary backport conflict), then in a separate patch macrofy the helper.
Yeah, checkpatch will "suggest" that the stable@ patch should have Fixes, but
for us humans, that's _useful_ information, because it says "hey you, this is a
dependency for an upcoming fix!".  As written, I look at this patch and go "huh?".
(and then I look at the next patch and it all makes sense).

