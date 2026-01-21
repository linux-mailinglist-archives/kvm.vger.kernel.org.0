Return-Path: <kvm+bounces-68708-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EF4/Lx+9cGkRZgAAu9opvQ
	(envelope-from <kvm+bounces-68708-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 12:48:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCB656400
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 12:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7F96196C883
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 11:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B033D5226;
	Wed, 21 Jan 2026 11:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EW8vWctv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9TfZbxW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BD11E2606
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768995369; cv=pass; b=gmc+tz5vq5GWIW1WSxgQGo2ZYP60WLf2gJIBKCQihNwp8kaAEAhWyqwfGahIFfV+SdGibS0V5cJXFH4pbnetZwgwfMBYTY08sbkEAFVGdrBefLrMEMDCx/CttzZvLiXTgaTzo78Ca0NGiP5SQhQeTTVrpJudoYQDYereH2NSSd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768995369; c=relaxed/simple;
	bh=4elGJ1g09HoCf2Z0FQ5IfzSKu0Kf1tvJId2dchj3ILI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fd2vlilLYWe/N+YUY+Jh0Smp7ukSEC8Csurg7OfNKk/6cLT9+Wo4M2i1lLdJ6nHUTyG/4H3utuVNFmDMWm40r1tYHb2qrwK9spt9Gh48FCBUDiiGkKIVWnNe1rhj+E5Jy4G0wCZ9ku03uq1Xz7HhpBKAr/43Ta3s+oksDuB+QWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EW8vWctv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9TfZbxW; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768995366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4elGJ1g09HoCf2Z0FQ5IfzSKu0Kf1tvJId2dchj3ILI=;
	b=EW8vWctvfrKqP80+AOo2Hvw22s5pCM1ZF2GRBAE4IKDDehJ/7fHBYjLqH2L6+8R4WowMeL
	HsHcl1uGlowefQBAAzICcpTND8l5TSVSG7WAoj5u+xoqwYn+3wilFayWU/oaGH5wo91zhG
	qU2OIyHzdph6K49IoP/fW93L522+PvI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-_4vWMw0KPUObpuMm2CGFJQ-1; Wed, 21 Jan 2026 06:36:05 -0500
X-MC-Unique: _4vWMw0KPUObpuMm2CGFJQ-1
X-Mimecast-MFC-AGG-ID: _4vWMw0KPUObpuMm2CGFJQ_1768995364
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-432a9ef3d86so3034236f8f.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 03:36:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768995364; cv=none;
        d=google.com; s=arc-20240605;
        b=ZY08OGv6bijfjBfy2D31Y98aPBhi5mbaFUYMgOAi42OYXLqg/6WlwiSVkv68ToUsC4
         O559SQGroO81hIMCZ0Q8bFA3YpJ56GFVghjdPWdPiDN0lhrQIB5FrTTvNzDRH9SoUUpT
         txSfQl1Wgl39R2v+KHVKtgt0dB9JTWQDgC3PFY//A46u5OqeP/xEaFMNmHzqyw32JCeN
         +iFMRYMvd/wM7OyBofv3BuhZKAzy8LR7lU4ZN36tQpez4+rjbzxsOvq5cgtnxEI40G/z
         ti9+uO5NYaDmnHZw49/HuoaIzRw70lxYDakCyL8yvttge91rHIldQ/lGYNWvlkU972G5
         gu6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4elGJ1g09HoCf2Z0FQ5IfzSKu0Kf1tvJId2dchj3ILI=;
        fh=iqlIA7GEZoOszE7AcdXGIdO+pglr5pnMKdCJCq0qyNs=;
        b=iStC8Wm0qizF/+6O1+5+Vmt6HQ2mjW9OAGkgOPYWXj1b63ubNm4EJaB0uc4hJukBNB
         /akLKrmN8CTpaMduhyn9pQFfBinSEwGSGuOWyW/8Ciz+fP4gdXV1fjOYN187Wr0muClS
         M21fllhlPDIGXyQaVbLOlVGhRS2r3662ZzP1XE0GaAYFU7Ir01leq8MMXcOWin0UMQ4Y
         l18K6sHgug8QvUpz6dAXQiOX8udauhPOMB00SRiCgZy36XJxQMbPqzvE+Mbf7re692S5
         2uquQCbcv/TPzob+ErRCgjKejbl27mb5KzuGCesnZ7SgTEd0bNru4hNURnAprX+XFVDC
         V1fA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768995364; x=1769600164; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4elGJ1g09HoCf2Z0FQ5IfzSKu0Kf1tvJId2dchj3ILI=;
        b=a9TfZbxWrrDTRg7mqtNyOhc5AD+9aG0gEngwXETM7YEDVbmuVg2k3wSmXZIBSupNTt
         vl0vScyj4Ke/x7OhibYMslvz65VDdJ8OogX6SWdYcbu+GUtQlM9Y9nsneluMkVO+qguX
         KrMPIrrFYXt1ngYEZv4ld+42YMiLMHB3fv/nyvSg2rLecYjanyqank1NCJJmQGtMdNWN
         hAiMIGrGst8+h1BUy9Zg6to7vLF1/XCjhS1M3KNRKNVT2B5/O16suds/9N4qmz2ZrVhY
         oErn79te1eGLncLc7q0D+GONa3RTjygoJu2rf/nGz5s4NyJmHPa3Xwllz8ggzpLaqp0j
         1Clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768995364; x=1769600164;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4elGJ1g09HoCf2Z0FQ5IfzSKu0Kf1tvJId2dchj3ILI=;
        b=NuW7H9+okvO/wnb91QlBJIfiDKIow+SnFA2CNuro3h9tL5kOhAikl1bgS7qIngSxJp
         9nhwF3+EM+n2QGBIziDUaNUM8ynYP2JV4DEnIaPbMErX5hUrShhpd/uyE0BZXtiws3Kp
         dIHNyB3AS4WNua9TQd4ZnTLQ8IUTKtioeIK0SwNJctPd1Gm1fKrCJASHYs4RTj3grEkr
         kLA54AQ8zd++xW4qz2tfl67NVZWvSpO+ohdrZT7ZLM5keE4pGHditSRS48E6ZjFFz4j2
         PbcB6bG2dxc+ITU/59hPM+Rwb/Ga2Q9ALBY2u4+qhkMFLLoPI2EE2EQAQAzq07HaDb0C
         9aag==
X-Forwarded-Encrypted: i=1; AJvYcCUG7SE5BLKkMZJZN3UZsx/mkDMJlIramYHR7sqdsfC4BrDfeu8JEHziy9+PlT4kOetRlLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKe2pQwrspQCK9xs7fExcqLgKGYMslxmPoKXy3OMnEJOcqx797
	9gnTfTWwDQi3oD2kCSFd+3vjGCuVVq+XGwHx26nrKWccEHHh/3pwg0xqgwbX/CpQEr4aNlnn+8n
	n2JglzYcztpxOMJnPj/gMz8Nd8eFqpH1S4r/jfmIiXp4/sNTOMM4QSy97qDFhLSZ+OH1Kd7I3WS
	N7nlQMstGN8mJTbFgyNKXEN1DgSvpy
X-Gm-Gg: AZuq6aKGKQ1oyYxwwAaQOLh0z6oYxAhzdlbYzKY5o7NNivU1FMwZzKHp7/nEOmY4dZC
	HCPPvhIbS03sUPaASHaYrQtP5e9Jx6NIosRD9Y/YLdUbPzQ3HvQJi7IvAht78Dzt6et+2BXqb6m
	G9K+NOTPGJK5vFvLLtnByqullYkoiX9KWLJBiyEY4Zk18CLbE6j0JOokpb8NsA3YVrIuEnENUIs
	Czqa6eSE/csIK92wRsq51Jx2JJn1vjaErRFK+NpX75pPTSos/UdL6PfQhWWBJPOeRoLkg==
X-Received: by 2002:a05:600c:6489:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-4801eac331bmr227482425e9.13.1768995363722;
        Wed, 21 Jan 2026 03:36:03 -0800 (PST)
X-Received: by 2002:a05:600c:6489:b0:459:db7b:988e with SMTP id
 5b1f17b1804b1-4801eac331bmr227481985e9.13.1768995363355; Wed, 21 Jan 2026
 03:36:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260116122246.GBaWotlmNRCkKFA-MU@fat_crate.local>
In-Reply-To: <20260116122246.GBaWotlmNRCkKFA-MU@fat_crate.local>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 21 Jan 2026 12:35:50 +0100
X-Gm-Features: AZwV_Qhkoa8ButwNDz50Ghbrqok69YMH1ExZP2tj8hRPrYpgaC-BHPfz7pFUlxg
Message-ID: <CABgObfaxsOA301j1hb1jSEZie3v3bzsW=03PcjqQ5RWynSN1aQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
To: Borislav Petkov <bp@alien8.de>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68708-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:email,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3BCB656400
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Il ven 16 gen 2026, 13:23 Borislav Petkov <bp@alien8.de> ha scritto:
>
> On Thu, Jan 01, 2026 at 10:05:12AM +0100, Paolo Bonzini wrote:
> > Tested on a Sapphire Rapids machine, reviews and acks are welcome so
> > that I can submit it to Linus via the KVM tree.
>
> So I wanted to give this a thorough review after yesterday's discussion and
> tried to apply the patch but it wouldn't apply. So I took a look at the code
> it touches just to find out that the patch is already in Linus' tree!
>
> Why?
>
> Can you folks please explain to me how is this the process we've all agreed
> upon?

It's a fix for a host crash that literally adds a single AND to a
function that's called fpu_update_*guest*_xfd. The patch doesn't have
any effect unless KVM is in use, and on any task that isn't the task
currently in KVM_RUN (other than by not crashing the system). So,
because of the effect of the bug and the small size/impact of the
patch, and the fact that there are really just two approaches and both
had been discussed extensively on list, I accepted the small
possibility that the patches would be rejected and would have to be
reverted.

If I really wanted to sneak something in, I could have written this
patch entirely in arch/x86/kvm. It would be possible, though the code
would be worse and inefficient. Sean wouldn't have let me :) but
anyway that didn't even cross my mind of course, because sneaking
something past you guys wasn't something I had in mind either. In fact
I instead plan to make that impossible, by making fpregs_lock() not
public and reducing the API exposed to KVM. I certainly will not send
that change to Linus without acks, even though it would also affect
only KVM in practice.

> By that logic, we can just as well sneak KVM patches behind your back and
> you're supposed to be fine with it. Right?

I would be ok with a Cc and sending the patch to Linus after a couple
weeks, yes, for a patch of similarly small and well-defined impact.
For example I didn't have a problem when commit b1e1296d7c6a ("kvm:
explicitly set FOLL_HONOR_NUMA_FAULT in hva_to_pfn_slow()",
2023-08-21) was sent without my ack.

Paolo


>
> Or should we try to adhere to the development rules we all have agreed upon
> and work together in a fair and correct way?
>
> I'd probably vote for latter, after we all sit down and agree upon something.
>
> What I don't want is sneaking patches behind our backs and I'm sure you won't
> like this either so let's please stop this.


