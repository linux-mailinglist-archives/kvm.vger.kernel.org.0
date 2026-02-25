Return-Path: <kvm+bounces-71881-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKSHBxlWn2mIaQQAu9opvQ
	(envelope-from <kvm+bounces-71881-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:05:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CABC519D074
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4C9A33034CA2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B640030171A;
	Wed, 25 Feb 2026 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3IvwJ5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC092F39B9
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772049920; cv=none; b=iYm7Ds1qsjuztKZ84yroFHiBHBn9arevrPljo3znUlTCJnyfubd5zTm/hBfJ06+YMOm2tNciqYGs+hTTG9lbr6mijCzqnQx1JvAQKPtB46ePW4AjwKXreHsiDtBMPI06+AImUjlVCgYDSkhFzduhbSkjrIGIFhsfBgr6qMxryDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772049920; c=relaxed/simple;
	bh=tKRbocRq14DmTJ0Xibmw+KZElUfkj3XNWjkuRruFO5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1R/7LKNyK6wAEhugUCfG4gcgXUS6ZZnUanM6zpzDfHiXMLVDp7NUUAv4txIXJYThbEfb+xsXXWGFoffLP5zzh03qVbKlYaMfm9RO5kcqbGnOFkJoodnV8knq9fTtV2Psdp/z7QbA7WWdw+JrW5OK2ytEnUL5PjhaQSD0MDFM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3IvwJ5D; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6fd07933aaso16774a12.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772049918; x=1772654718; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=euk6pR55vngbiALkr/Ss6DCVuRl2d4R3J4RSxPrxxr8=;
        b=t3IvwJ5DzVnW8y3cYaPl8NngrIgAJOODKDco4UTexBqLyfDybofjqt/Y0QsuXdVKCu
         lXSv1gkV1TQbfU1j8AGpB738v46zazd0pUyctMiWIOPj+gTnSF1ndz5me65mBngVmSTN
         qkM78LrtT9cZemgI3PluBUgYIOKB/nuepn6L+LUHZfP0i0lhwF4N63gHnDVRhHLvrA3q
         1p4pnQxz5LALFe1y03/zMg4qfW8OH/KiAcicgiN30xszlWbeoNsSiyxpHSc6+kS/xVGG
         QFS6rSlT3Cfee1oIeWKBXPSMhevAgFfx4EdHCAPdRIReb9v6+9WQKMMEKXx/bSYBaGl1
         CJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772049918; x=1772654718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=euk6pR55vngbiALkr/Ss6DCVuRl2d4R3J4RSxPrxxr8=;
        b=ZE4ZM4CIc+aLTt07aPOQYehKBbM/lawI/rbjjAHcN3e759aK0MezI90ty0+80cqOTJ
         QPBrN4kvaahpu4ezyFBpg5/uvrs9Z9ZA9WnvdaHjXLaILD4O7B2FtD4akkjOBnnDPdJI
         mS/CVG5REZ3Rc/DM4RcS2/+txDqV9KJQzn2x1GYtgCL3dRYdhGEapA0XDI1z/d9e0IU7
         WgVZONOEwHaFlvuRi3+g6WJq96Mbg+5Jl2l7cPpARQqLtUUq1JZTWTzqegqJcVvCXrb1
         QhU449ZTYZXq3ZxjI8ZJldvzh25DYDNDHH/5d7/WKvG+ATKSZioQqwC9HREa3tDy67AA
         gAbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP+1uf7fijL4sIElvlmh89F5e1pie+7nUtELyfZxbILlGTD6l39pCEwwFUK7/qiOBnQ08=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLd3t0kPjbFhrm5Hx0nUI+rmpr7u3Gz2cD8UOfJqKkrwycqKP3
	Zu3WrV7EppzcfQ2HNUh/DhG0XgWF+mORag/3m+gnf43oenn2ujiPTPFBdp3tHKJvTXQcgymBCXn
	hfYspBg==
X-Received: from pgbda10.prod.google.com ([2002:a05:6a02:238a:b0:c6e:6f7d:a6d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6083:b0:38e:87d7:7b95
 with SMTP id adf61e73a8af0-39545e91cafmr14346518637.20.1772049917923; Wed, 25
 Feb 2026 12:05:17 -0800 (PST)
Date: Wed, 25 Feb 2026 12:05:16 -0800
In-Reply-To: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
Message-ID: <aZ9V_O5SGGKa-Vdn@google.com>
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
From: Sean Christopherson <seanjc@google.com>
To: Jethro Beekman <jethro@fortanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
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
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-71881-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: CABC519D074
X-Rspamd-Action: no action

On Mon, Jan 19, 2026, Jethro Beekman wrote:
> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in a
> kernel page fault due to RMP violation. Track SNP launch state and exit early.

What exactly trips the RMP #PF?  A backtrace would be especially helpful for
posterity.

I ask because it's basically impossible to determine if this approach is optimal
without knowing exactly what's going wrong.  Semantically it sounds reasonable,
but ideally KVM would naturally handle userspace stupidity (without exploding).

