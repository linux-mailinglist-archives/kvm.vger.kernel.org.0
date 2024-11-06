Return-Path: <kvm+bounces-31001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1CA9BF334
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02C2B281E6B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A48C205143;
	Wed,  6 Nov 2024 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yeiDOyOs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6350E204086
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730910470; cv=none; b=B996elhHx1UJ+BJwd++KaiJ2wT0mU2gEWsHIG2k1nPeP6pg9UR4CD3n6HvJ+RJVzeOQsdKH2VJnqJx0MUj+MOzNZkpumS1uilWKiWmAatClQcWfHBy7oThoHLJn3QxxSevRTNK6Fh7V2zjkETnSeCGx/bYVUg+Ox7DlN3AxNQPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730910470; c=relaxed/simple;
	bh=ph8WgCziHmWfyswsDBnx5qg6csF9c5Z6bkRrBHlPhds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rTQwQMDJlsZr0ibFWSexacMp0yYCpdE4BcOjeIeLMw90MIR9o/9q1P5tEn0FbkOR8JB2BIYKUtfQGfsCiw6vLzZBW/dEQhqLZIFcHsr/xFbXI6Pr5RwM6MT7Zwssf7DnPSXJ0G24JP1WNXfbRb3emJFnPVICoZYwKK1PSvmMML4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yeiDOyOs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea0069a8b0so29575a12.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 08:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730910469; x=1731515269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FCXUf644XlkJphA6SVk+8Af9SxQm8DuQmfcSkYLayzs=;
        b=yeiDOyOs/fY4CnfqJW/K33m2cWdqxFCjYyVgWvNMl0Omo9Q45D1uvrVNdpfqZiE8uY
         jhWulJNAcfZNi4p+XEi3/MFO1gfJezFOVf4UpwjLlOgc0DlGtuSAyY4rRjB4fNdlZC29
         KOmUTjpxfxnFcR9rvoxK9Pwqd2NECLdr2Qgb/+QF2u4tevMS7EXjm9iwwl3CHze+omz6
         Ie/2FACHH6CUk3WDddUbrXZzXPXvz0EbHl7a9KglaJeKTU0jGbKJEbETcAFssmly4iJD
         8k7fA0SxH3jXiXEvguj/kqEtrBjUuWBBrsyqFtL2dD79DEJVDh6+UJC4hxB0pIDaJbw2
         RCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730910469; x=1731515269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCXUf644XlkJphA6SVk+8Af9SxQm8DuQmfcSkYLayzs=;
        b=w0rMv39Nhup3VFYtCJloaEmkPHGwB9MYb7L37JNo5LrYdoa0ZW+B801Dij+BnJG+Rc
         9Dqu+DFJvDbDW+0VUHOD2E/sQ5ufz7GHdrL/VHydgQ7oIlgTw0+DdqepwYrQxV8hbAbn
         2HEAzjFOcmpAy1xgOEenIVvN3ZI0mSb5JPaCbd4kZsRvHKMQ47TJ3WsYpGMBtNAN3thX
         1vZVNL7aUol1wMtQ5PCPhg6PEvY2HamRT5ZvV/4Jcr5M0Jp3wymAhO+mS8lGfWBsr9HG
         ffsX35K2UdD2zES5kVc1A4DiyO72rsn0u7MvX2ntaWHKeSLvKi7IfXc40ljeHjbdmDuv
         +oBA==
X-Forwarded-Encrypted: i=1; AJvYcCVJXTaurEYXv+X1GiaEWoZmK8mFcuZNEHHTEdUU+VJGmbEpHYQ2AfQ4s18G40dkovLKa6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5mmUChVuKmFIYNt7XGP1CVdS70pnnYVNo2u8VTB3iVPKAsvwU
	FoSzpwj2a92svBdr0U0cseE/Ipj9TOQdQbvFk/DtWki15Pm3bdkutG8X6/Ns+sn3dQQZj8y57s1
	u2w==
X-Google-Smtp-Source: AGHT+IG3df/kZk2fCqxxe+LGQm+PfVIDi52PzJ3ZNYNOJoCeWKyXHryfz8LDsbPSuUIbUhymUD1+KWX23yo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:1a0e:0:b0:7e6:b3ab:697 with SMTP id
 41be03b00d2f7-7ee2908a4e4mr46438a12.5.1730910468750; Wed, 06 Nov 2024
 08:27:48 -0800 (PST)
Date: Wed, 6 Nov 2024 08:27:47 -0800
In-Reply-To: <20241106162525.GHZyuYdWswAoGAUEUM@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZypfjFjk5XVL-Grv@google.com> <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com> <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
 <ZyuJQlZqLS6K8zN2@google.com> <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
 <ZyuMsz5p26h_XbRR@google.com> <20241106161323.GGZyuVo2Vwg8CCIpxR@fat_crate.local>
 <ZyuWoiUf2ghGvj7s@google.com> <20241106162525.GHZyuYdWswAoGAUEUM@fat_crate.local>
Message-ID: <ZyuZAzqQIXudhbxi@google.com>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, kvm@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Borislav Petkov wrote:
> On Wed, Nov 06, 2024 at 08:17:38AM -0800, Sean Christopherson wrote:
> > I do subscribe to kvm@, but it's a mailing list, not at alias like x86@.  AFAIK,
> > x86@ is unique in that regard.  In other words, I don't see a need to document
> > the kvm@ behavior, because that's the behavior for every L: entry in MAINTAINERS
> > except the few "L:	x86@kernel.org" cases.
> 
> I have had maintainers in the past not like to be CCed directly as long as the
> corresponding mailing list is CCed.

LOL, doesn't that kind of defeat the purpose of MAINTAINERS?

