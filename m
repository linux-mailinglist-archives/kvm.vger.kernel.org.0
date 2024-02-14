Return-Path: <kvm+bounces-8701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B50588551B3
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 19:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 542A41F26457
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDDE12EBDC;
	Wed, 14 Feb 2024 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ciKuD/+/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BF48527F
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707933952; cv=none; b=Xaz/zFfdzaa7RPURnzNvl7JGlXCLLU/HHY/QJZO1u2HIb9KlPRAwemUTImQjg2EXAOBeHn9atSfm4kIgAmWAhlh8RJpbln+TawUK2XwPH3ej3HDfywwj6WC73osnhcI9u/52o9hmvGZow27RVIjSsHAKlDcFjD3taUpVOfk1Jng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707933952; c=relaxed/simple;
	bh=AwVbXaFBlYV5w6g5LE/04GL9OTsTqYN4NTJVHwEHaoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ae4VM/3Nkdl8mEa+lw2dFaxLcdgLtZyDLfCgYvj6sS69dPK6SaVkn6wtXFuneYhs0JbAMahJYdfhXDq2Qj6BEJ5lS2Tca5X6YQNEBvpuZ3XxLRuJbdULVHqjG9nehUZokPtHeSE4J1E62jRNOOIRAnieEg8l4r36e1GWvBOc4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ciKuD/+/; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so5771946276.2
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 10:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707933950; x=1708538750; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ArtE4zOnpIf0P01rQhXMtK9cH9/K2c3IZaOGScbal4w=;
        b=ciKuD/+/Zb99whorLKxcxHcDYKMjVnliLGl4B3x1UQvu4Vz+TDLc/yHhJOgxUVbNLg
         6G4/WytOGomdjMh8kCLDAsQWi42z4gJDihR5RHaPgTi4XwpgULB+V0LGJtXngk8ss4JU
         R1l1kyTi+h4xs7srn9DPQasYyccMCFUupTR9ix0CjiA/xK+8ZfxK43WncOwilcYID+bW
         xL6GcHMkxjJCTI6C20MrsEbc949mDzMzKV3tF32x/fViYS5DuTtYJowuM92UwsKKeCgO
         6j9z27ip3ujJMQUu3n8/ALlRCGFqKKca+ps79QNIZ9vdPk0O0Vn8fukEIoUo9asuf1yP
         cuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707933950; x=1708538750;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ArtE4zOnpIf0P01rQhXMtK9cH9/K2c3IZaOGScbal4w=;
        b=n7GH2HjS2KxtGGw02NbAFEsTxA1/GyOmBr9PYKew47q5ucWQqZnqgeWSkY/qzSf28q
         yzos0jQ9vnj1CQ238J5nYd+xiN4kmj17dQoanhqaXXr6tSLKgxh0yAXRrGcENnL74RII
         PBqAzv1q1TlFAl2LFsI9Rk+msK7KqS3OJcvYwyNPX1BSSwvn2ez1phT+WCBJxHvdEDL0
         1KvBLMFscea7Ok0PsFC+bkDA05Ln2ocTX6+TMHXOVZeSOsUlY9LOfdtACp3nRqgorHRY
         1V8xu84RKc4Z2xYE82iwb5J5Bm6WxsHYnKD5XcRj1VngZ2nF5jAuarCjpDu1zkG4FBuC
         Y/uw==
X-Gm-Message-State: AOJu0YzcGyDlU0aYTtUPh7w878WzOI4Ew63OyrUTqIZhUyraCq1suxrN
	b3j3AcGpgI/Iy3cFEQJIZvS6StqaFBfinAfLFcBiEI5sv1uxVb4dZ9NmxbdsDUXao3B+ggbHYHF
	CRA==
X-Google-Smtp-Source: AGHT+IEC4vgJ4kb2o+P7AcYnlgforBsvYsuwZp8pUOr/KeyBfZgInskg/4q1DnpbHkls7YzSjPBV67rGqJ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8011:0:b0:dc6:cafd:dce5 with SMTP id
 m17-20020a258011000000b00dc6cafddce5mr722903ybk.12.1707933950309; Wed, 14 Feb
 2024 10:05:50 -0800 (PST)
Date: Wed, 14 Feb 2024 10:05:47 -0800
In-Reply-To: <CABgObfbQqVOsH0imHWc938n48TdkD8xFPO4CnwS0EM4oQZAxog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240213005710.672448-1-seanjc@google.com> <CABgObfbQqVOsH0imHWc938n48TdkD8xFPO4CnwS0EM4oQZAxog@mail.gmail.com>
Message-ID: <Zc0A--vYHG77-dYn@google.com>
Subject: Re: [GIT PULL (sort of)] KVM: x86: fixes and selftests fixes/cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2024, Paolo Bonzini wrote:
> On Tue, Feb 13, 2024 at 1:57=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > I have two pull requests for 6.8, but I goofed (or maybe raced with you
> > pushing to kvm/master), and based everything on 6.8-rc2 instead of 6.8-=
rc1 as
> > you did.  And so of course the pull requests would bring in waaaaay mor=
e than
> > just the intended KVM changes.
> >
> > Can I bribe you to do a back merge of 6.8-rc2, so that my pull requests=
 don't
> > make me look like a complete idiot?
>=20
> Ignoring the fact that kvm/master is currently a subset of Linus's
> tree (so I can just fast forward to -rc4 before merging your stuff),
> that's absolutely not a problem and it happens all the time during the
> merge window. The way to handle that is to forge the diffstat in the
> pull request, replacing it with the diffstat of the test merge commit
> that I do anyway. It's a known issue with git-request-pull and pretty
> much all maintainers do it.

Heh, I did that locally, but sending out a forged diffstat felt dirty.  Tho=
ugh I
guess it all works out, so long as I make it clear that the base isn't kvm/=
master.

Thanks!

