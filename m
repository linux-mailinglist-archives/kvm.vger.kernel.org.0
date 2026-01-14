Return-Path: <kvm+bounces-68083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 513EDD2111E
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 20:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 017BF30386F6
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 19:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488BC34E761;
	Wed, 14 Jan 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t6aTq1O3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C433346AC6
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 19:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768419768; cv=none; b=oKgUOYUA08qqHlrJTuB2n6vbx4/8ethsPsxG93IosKBy1bB9CMryHbN9f1BlbL1RKgpj9KUhDvWffnu3s6k6WswPXu/VPRPe0K9nGf5+xKVT1byRWcZXADbK/Ly+w+fB4ZSrTIlZxPZfKV/00AyBvcrKAtfjL57go3xut3encTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768419768; c=relaxed/simple;
	bh=tJLM3EVPIjwolJnxGvjBiFwtKxPitpUwshSr1wSuMyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISHC1t06zGO7CmqxxukGINDhKNKZyJbdkGA9kid2LWZFcoMdpwd4+4FYBDULLvqUHPSJrS+gcQGidYcvmtqPXSbG/387SvOjRKwtXjoklr+hj9L9atYfWHkPyFAfzO81jxBc9Dqqm0SEnlDlDat3/T68PHk189aiVS98NFxhjqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t6aTq1O3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34aa6655510so79340a91.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768419767; x=1769024567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qi7dt3Dd/aVuAS5ol/gIpMZCnZnmJVwzmEj9I8BYxY=;
        b=t6aTq1O3lawodb3Y9hM79sXGSqUZk/3obql0wTVJXaxGVBJaBsvD3FK3Abc7SQyhbd
         gXjMAR9pwN8ZmF7/PJ85kRsaeTVNAjNjuuRZ3ZZxB6QeZYIps4ue/GHQhea0Hw+voiH/
         Z0X3qtCKcCZo+7e/H6A0ttvG/iyEoMGjXOkAPldg4XFPap/8dDHzgR+kNVPGFnKlJA5O
         I9sgVNHHwOczkTSPzTYGZu/sm186TsEP4u/8p+9OCcuHPAOSneVe8cy3OBLVW0XatXV6
         45K3xtYIyrogGATQaZ5iU6nOmSwIBWyilJ5/aKjgMEtyV2UAqRoPAdYClUZaVgR7WcyB
         3+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768419767; x=1769024567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qi7dt3Dd/aVuAS5ol/gIpMZCnZnmJVwzmEj9I8BYxY=;
        b=ZLeSV5EOYDRU7nUq01E++QvA26GtI9WNAg+twjbcUjMZEvdgleRs/keAaNWphqYlS4
         iVL1AlTCb6VEjViNPPbL8TGZ0kGm4Y32CZd/xROmg5y9nJZUi141pjE5M+f/2ZKCvMPX
         iOZGK46PuLS8Ko3hu1y82WX979YpyWRo29Icy8OOtzdb3U19XDCME6uq5GpAGkgiw8Cx
         fwcKgqS5tuw6wyh+uA5AXpYIzYMVe6Oryomt40JkdkI7VG6N9GjB0+9pBzGc7+J4IvHs
         pWFd6zEAArorJ2m+pKPBkiDN+O2zCb1yM/6R20Jce+ZOjge0n8wNruLtfgNsjJt5uDsy
         LyiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrByiSmitc3qQU6D2Ghp/8FSSWF4R9EnlsDHNgXZuyNHk1FGhvDMVGmDz1P6sC2ujkHZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlAjbPsHKUPGEjl0WLcGszoYtKtY+mEBu2gk6o3HO+N+F8kQSS
	KOwh+iXqqXy6xDIqe/LqaZxgxmLt+WHJvql/xQEbKdCjsS2fwqXcyv1Ak55Cqki4aTdBH3aJo8F
	LvKBw1Q==
X-Received: from pjbkb14.prod.google.com ([2002:a17:90a:e7ce:b0:34c:cc12:1613])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c1:b0:343:d70e:bef0
 with SMTP id 98e67ed59e1d1-3510911fba8mr3604743a91.21.1768419766622; Wed, 14
 Jan 2026 11:42:46 -0800 (PST)
Date: Wed, 14 Jan 2026 11:42:44 -0800
In-Reply-To: <aWfOY7v3T_SRdHMp@blrnaveerao1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112232805.1512361-1-seanjc@google.com> <aWfOY7v3T_SRdHMp@blrnaveerao1>
Message-ID: <aWfxtLLz5STAF-iY@google.com>
Subject: Re: [PATCH] KVM: SVM: Check vCPU ID against max x2AVIC ID if and only
 if x2AVIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 14, 2026, Naveen N Rao wrote:
> On Mon, Jan 12, 2026 at 03:28:05PM -0800, Sean Christopherson wrote:
> > When allocating the AVIC backing page, only check one of the max AVIC vs.
> > x2AVIC ID based on whether or not x2AVIC is enabled.  Doing so fixes a bug
> > where KVM incorrectly inhibits AVIC if x2AVIC is _disabled_ and any vCPU
> > with a non-zero APIC ID is created, as x2avic_max_physical_id is left '0'
> > when x2AVIC is disabled.
> > 
> > Fixes: 940fc47cfb0d ("KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode")
> > Cc: stable@vger.kernel.org
> > Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> > Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> I think the bad commit is:
> f628a34a9d52 ("KVM: SVM: Replace "avic_mode" enum with "x2avic_enabled" boolean")
> 
> ... which introduced x2avic_enabled.

No.  That commit definitely set a trap for 4k vCPUs support, but there was no
functional bug as of that commit.  KVM would unnecessarily check @id against
X2AVIC_MAX_PHYSICAL_ID, but it's a non-issue because X2AVIC_MAX_PHYSICAL_ID is
a constant and greater than AVIC_MAX_PHYSICAL_ID.

        if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
            (id > X2AVIC_MAX_PHYSICAL_ID))
                return -EINVAL;

So from a "what LTS commits need this fix" perspective, it's just the ones with
940fc47cfb0d.

