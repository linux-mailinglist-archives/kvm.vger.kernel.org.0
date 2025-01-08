Return-Path: <kvm+bounces-34780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E3AA05F3D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43A777A2FD9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C45A1FE461;
	Wed,  8 Jan 2025 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2/9EpeG2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465901FC7DF
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736347297; cv=none; b=sKI2v0eRSLYKSZMa2zlwZDbe2QsoZgeS2F7Hck98UNRe7E5M2cHXOhMT/3V7JPkwzYhe5SxprzaZlcBR2ZVZ/nk94+oY7OucgEIhfk8zlO+DOy1b3cuxe3eitB0Mq4nbJyUxwjloRPMlydJgVWrRRHjGnga8OtM06zCuxWYA/rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736347297; c=relaxed/simple;
	bh=2ZQNK22CDDsOnlzthXlIGxkPF9H21YpseKace6terSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EYwdpLPkAuCxRqSNyLp0qgulLALXYAnnj6KyR3mtQh7hy9Pkv9S32vFeDBmAU6rU/R95OqpcYDDNZIw+kscfaBz/WSAAsA+wjklDnBtTvKLc9lwgeNrDRt+ryftcB8brmvc53dvJn2Pqh1qud3wszEKFPQG/V3p8G1sAA8X21ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2/9EpeG2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so24270488a91.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 06:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736347296; x=1736952096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SQLM+LoHGnaCGsXSe5lLcsoCAmL6bhSjsazuawUJ1sE=;
        b=2/9EpeG2B+YsH0C5Rbk9Rg/zpAeGhQBOT/TUtupISOQOewTqOOhDd76jX8OthsodZr
         YCOkEgDloW//C8C644MZmXID+b01AmZIrBeaCWjax4qk5yus5ePLBpFzhA3RzY4vJugs
         yXhxbFMSIRRBZ88w+uWcz9s/mRvCh+dLqOqmGFEHwsQxvcT+TFQGgfZAXVGVdUXSsd40
         T++qOUYJHIkN/Al0WALkm/tTH4koJ4ipByFRbhbsQSqQVjgfXOAo1lbM6EfpWHUC0ZdH
         TbPOEse5K/1M24ZGlcSy+R6/WDctDm3lpT1PpwjUjzxAPqq5cdL6w/mdLBSUomLiYFG9
         fUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736347296; x=1736952096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQLM+LoHGnaCGsXSe5lLcsoCAmL6bhSjsazuawUJ1sE=;
        b=OmnuJDB0sXjok0jjU82A/s+cwBHRcYw5f+JUCs7BejWQXewJWAcer14JGGnBvFX+5b
         afxw5Gy1E+LtWoxg7qArZG3BPgwsVhCiRcVDYeDXHL+seWHlyr6efmMmQE5RRI6ye4NU
         S8ShPe3nMk6Q8BBrYoKJjrq1ZVioUUlW2blB/VJBAd1anK5Ng6TNh7HMJ8SxdnhAo34D
         3Fhu0MylTvFEB41a0ax5WwQaK6Lm0Hu9qLQPgjmIYUz6iATyxoXzYob0m8qawCuorasy
         01kHh8dPDr9oAm2GrOCAtBdkm4n+dVg9PsN52H4fBNqbpq4xyUw7JHTBJvRppbr4G9o9
         gu8g==
X-Forwarded-Encrypted: i=1; AJvYcCXKr6NhihOuc4Ohha7dN/w64V63OIqbCztQR0nD5eLOMfI9dzhq450eppMwOueRaltfFwE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxp5By38FjvdeZXpCkYpOeJA+yRQwBAZ0gIE9jElXPFaGJpPip
	Dyt8BdD2z50OT3SOMpGOq91bVJjC9YDIafn+WwpbcsZTf+kEMlT2bK5Cok1knXmHGzulUp/HYCF
	lqQ==
X-Google-Smtp-Source: AGHT+IGmkPaMq6fyPiGwNEznCVmXKv73lSbOSvpsyNn1ze2H+LKp+qpzjKZzXeZPKeZkIqzTmMcSaKGlbq8=
X-Received: from pfbbt23.prod.google.com ([2002:a05:6a00:4397:b0:727:3c81:f42a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e01:b0:725:e37d:cd35
 with SMTP id d2e1a72fcca58-72d21ff4af7mr4989790b3a.18.1736347295712; Wed, 08
 Jan 2025 06:41:35 -0800 (PST)
Date: Wed, 8 Jan 2025 06:41:34 -0800
In-Reply-To: <Z3wnsQQ67GBf1Vsb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250101064928.389504-1-pbonzini@redhat.com> <Z3wnsQQ67GBf1Vsb@google.com>
Message-ID: <Z36OnrAGOL9c7cku@google.com>
Subject: Re: [PATCH] KVM: allow NULL writable argument to __kvm_faultin_pfn
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Christian Zigotzky <chzigotzky@xenosoft.de>, linuxppc-dev@lists.ozlabs.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 06, 2025, Sean Christopherson wrote:
> On Wed, Jan 01, 2025, Paolo Bonzini wrote:
> > kvm_follow_pfn() is able to work with NULL in the .map_writable field
> > of the homonymous struct.  But __kvm_faultin_pfn() rejects the combo
> > despite KVM for e500 trying to use it.  Indeed .map_writable is not
> > particularly useful if the flags include FOLL_WRITE and readonly
> > guest memory is not supported, so add support to __kvm_faultin_pfn()
> > for this case.
> 
> I would prefer to keep the sanity check to minimize the risk of a page fault
> handler not supporting opportunistic write mappings.  e500 is definitely the
> odd one out here.

Per a quick chat at PUCK, Paolo is going to try and fix the e500 code to actually
use the @writable param as it's intended.

