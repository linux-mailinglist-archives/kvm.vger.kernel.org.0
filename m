Return-Path: <kvm+bounces-32950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E84FE9E2C4A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8410A282DB0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6130202F86;
	Tue,  3 Dec 2024 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IANPNmL7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8008E4A29
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733255256; cv=none; b=Zqe2Z24efNEKqSXwLCem4tGhmhfYxm8gYrUjAsfeEuXZaaJe8lTtPDlmS37mRdXofzq8U23u2qU78pr8fwoNHIMSmJa55zOmlk6AYqLD/oRsbFYDsTVIXlqvqVh5/SFQ3come1C77WCwgrRqya6FRjW/37SOZAjn/3nK0NC80mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733255256; c=relaxed/simple;
	bh=9apAbEqd89yCOoToYq3N9kvqwE07Gjr4GwNYWTI+3Kk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cgv5yXf6v16v6MaqlwtjnMTsenCEQ1ffr6F/mngI2rXsvKGHclQMOmcu/5TYoGJNNsk85C03oKb760qIlHsJsTQefyzsM3RikbFs436vX7zfQZkIc45bfYnI0ytmhft0//eH1+3V9+CruMXb/enJr447YhuWp/piYTIwrnknSG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IANPNmL7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eea74eb7e6so2987315a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 11:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733255255; x=1733860055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeI9ozHDn46Hz6cYYiawc9Sj++xFx1oN+rWsCLYaKiA=;
        b=IANPNmL71MO7H9cC0MozA2Yd/JpEOQgr45nKr1LdP890c9HewrgfAaSOSH5rHmVtV5
         3Wg5DDzZF9b0qjU1cSUF2jBDsOwhG47jejygB2hcyR15IZKFcLr4nh/SlqW+88mhDMm/
         z8mul8a1BBUt/9SzbNEE7jvedn6Yr5eYcP+xiBmv8aLP/A7BOjAU8GV/6FAF1zdMSAVh
         PsKFdsPAC2zH6EG2Tq4JhrOAZo1wCr9zYCe3sH2qdk+YkdlrWchtYtmSHWGw6icw3MGt
         InwoX8wvblpOR35Oxpf3Qz+czdk7gxU5nD7hVbgqhznWPPqvaxoQ0aktZoOf54gLeag4
         hbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733255255; x=1733860055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OeI9ozHDn46Hz6cYYiawc9Sj++xFx1oN+rWsCLYaKiA=;
        b=b2j39rV4PK5fSKX2sNpjZl0TQ4fszAsxEwk/datt1/M+Ky7K7EfZmtdkiqb4fWd3NO
         KzoCpU7qTqqiOIlv8cH/KUQREuxcvHbsqPvIgMZGSTxhupfiOTbm8CbuNaRVasdkn4a5
         hdpxsakRbDmiFIWHkTRdwlbnd7EN4jfQUpe1uIdDNJPCntMrnuajenbZG0tjuViZQzc8
         +8BcQYNouvo2ju8n+l9ciHN29G2HZrPgC/HmS/ffURBEubr0QtdivYwZ+k5V0YCgXOwA
         83qvBdSgHjG/dgm8/gLZ+XQdYy2TRzPMdn9AwrcX8lrrfdGxgl1IXgGKcRK2WAa8z7PD
         wltw==
X-Forwarded-Encrypted: i=1; AJvYcCXFWrSwLW+xd9Y4UfdFQMjEqSzRUxsOz3qDAkc17ykFnqA2K58ckqqONHo0hPbbexGBPYs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8F0xI77LeNROsPLYKXfJt53dLydBywdxN9vCHT8wqZQPNmYap
	tNgdd0K49zaFrgvOc/NSokK9sE46INSkvCxsL30mUo9IE6JVEsLNeTW5sO2Q2YpcL5L1dFrZ3WL
	Ehw==
X-Google-Smtp-Source: AGHT+IEIxTAowvsQbXBvVmwXg8xC+DTWCcjtZ15UsU+7ONR6EPrixct/B9Rl7jkKhrS6wBVafL8pEjlVIVE=
X-Received: from pjuw3.prod.google.com ([2002:a17:90a:d603:b0:2e0:52d7:183e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ecb:b0:2ee:44ec:e524
 with SMTP id 98e67ed59e1d1-2ef012701camr5194710a91.35.1733255254820; Tue, 03
 Dec 2024 11:47:34 -0800 (PST)
Date: Tue, 3 Dec 2024 11:47:33 -0800
In-Reply-To: <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-13-aaronlewis@google.com> <Z0eV4puJ39N8wOf9@google.com>
 <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local>
Message-ID: <Z09gVXxfj5YedL7V@google.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in kvm_x86_ops
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	jmattson@google.com, Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 28, 2024, Borislav Petkov wrote:
> On Wed, Nov 27, 2024 at 01:57:54PM -0800, Sean Christopherson wrote:
> > The attached patch is compile-tested only (the nested interactions in particular
> > need a bit of scrutiny) and needs to be chunked into multiple patches, but I don't
> > see any obvious blockers, and the diffstats speak volumes:
> 
> I'd like to apply this and take a closer look but I don't know what it goes
> against.

It applies cleanly on my tree (github.com/kvm-x86/linux.git next) or Paolo's
(git://git.kernel.org/pub/scm/virt/kvm/kvm.git next).

> Btw, you could point me to some documentation explaining which branches in
> the kvm tree people should use to base off work ontop.

For KVM x86, from Documentation/process/maintainer-kvm-x86.rst:

  Base Tree/Branch
  ~~~~~~~~~~~~~~~~
  Fixes that target the current release, a.k.a. mainline, should be based on
  ``git://git.kernel.org/pub/scm/virt/kvm/kvm.git master``.  Note, fixes do not
  automatically warrant inclusion in the current release.  There is no singular
  rule, but typically only fixes for bugs that are urgent, critical, and/or were
  introduced in the current release should target the current release.
  
  Everything else should be based on ``kvm-x86/next``, i.e. there is no need to
  select a specific topic branch as the base.  If there are conflicts and/or
  dependencies across topic branches, it is the maintainer's job to sort them
  out.
  
  The only exception to using ``kvm-x86/next`` as the base is if a patch/series
  is a multi-arch series, i.e. has non-trivial modifications to common KVM code
  and/or has more than superficial changes to other architectures' code.  Multi-
  arch patch/series should instead be based on a common, stable point in KVM's
  history, e.g. the release candidate upon which ``kvm-x86 next`` is based.  If
  you're unsure whether a patch/series is truly multi-arch, err on the side of
  caution and treat it as multi-arch, i.e. use a common base.

where kvm-x86 is the aforementioned github.com/kvm-x86/linux.git.

