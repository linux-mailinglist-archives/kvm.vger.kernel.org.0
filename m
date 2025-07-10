Return-Path: <kvm+bounces-52004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B04B0AFF598
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 02:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F6351AA8A61
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 00:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9090DBE4A;
	Thu, 10 Jul 2025 00:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l2DfO4zl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5F28F1
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752106720; cv=none; b=ETXs5boka2KZYnIGXB0ZRf1HzhEOCcFoKNVsUQLZ8FtMtIdqX0do9FKHpIbrxQlkGgA2uP1uE4piynmNmJQqhimMQD4CP26kAiBTLSd5RyFK//QMm9Z9RrGH+NCujgjZgM8rEgdHf3zGDpGrcUkIAbafbiqjPcIyonDMGDegL5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752106720; c=relaxed/simple;
	bh=BQebAgANFg1hqKPLZOiEHD3Q58LbSUoyhCK9r/Rhen0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kiDrebhUrAnuFxrEg+FLbRqA1SgIm/TTgotr1PM3LaCfea1MAj/XCv/RqWQsx4heSSyHH5X5bsiKR8FcHm+4KejGrK0QM/7t/lSKbtJBjfo90Yjh8CIJf34v7mnGdH191/CRCQlQ+dZTiRYc0Yb8UKS2vkjPyin88vwP/Olc2To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l2DfO4zl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74ea83a6c1bso157548b3a.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 17:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752106717; x=1752711517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OLzig2qiNR2jhkyqAnMUWUMLsoL1y25Rwtu/Ci6IzXQ=;
        b=l2DfO4zloM1sK2UT2S6mJjUiEJ96dqx60pYazbzLBDKgbczc513S1/ZmA0Q1oogirB
         uL6T+ahMdnPX6ro6rH8MRv3DbqTWHqg1uGp1i9zk/jyoGyAZppq6vCOnRenVUdonU/ch
         Fy2NMqGoeDQC5I82P2Ilic1ugPxzYubwma/VIOvTtm5cUqvJkeH69BFPxwIaCjkqi9nL
         SRtySISi5reUuGaGcYfSjL19NQMM4pUQsr5JijYbbT2dYMXFZ67P2Zl/RX68fKrVi0Jf
         8d1S0YbrHc8O/Fr9lfnIvnhfnQc3XoNLWf5/en+QPaIhnf8Sifz1p0XSKfhll/9hJbcc
         HS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752106717; x=1752711517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLzig2qiNR2jhkyqAnMUWUMLsoL1y25Rwtu/Ci6IzXQ=;
        b=VA2bu+O7ZTRUxhDuRWfjOdi2e9FQ32B2eIPl4gMxSXCHuhO4yKHEStVye8K3n6s+gQ
         GnZOOu5fe+32iGRwf/5gOGEVgsxUAomXJ7UfI/j3+IISg0acouBMXX9djOD1GXjZ4WRw
         JGAqH7XEqCXr7CBfP22tG3nnLZMpIwauqcLF4PipDnL3NZebRthJcsQSzqTYoZWuCAdZ
         YamM6rBrRa+BMU8FppEmdhpGKauO9Z5MhOxMpx2gKKlGdFJxcFYuqtpPGIPoIKWZ4+uO
         uvkMfPytHL4IF4SLaBsAShn8W/Em0kIJ3jbGgb7diKGpcGSBZ0PE5MesqHWMu4Omj6Cf
         3xDw==
X-Forwarded-Encrypted: i=1; AJvYcCVH5AVdQVz4ZorM7Z+rDS9tVwEqj/I+ok/7yTr4Fjhn+T+FgaS+bQgPHWP7l8CZlsMQvZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXRvtSsM2/AiNydCbIDtdGG79g8815ZkjaFmpuB7eFf1/L00H4
	7HtpERfsq4u3QJDgIxSMGTLTGd9yyqIWR+oa84Hp2yZ1/Djr1hz9COEwq4XODvVUtC3EXbWdqDS
	fSi5f1w==
X-Google-Smtp-Source: AGHT+IGmcLB52wz+0J/dhZKKbkmNXvfa8dV1v82Mgkyx1EZoNNqGtWbyrclr+1fJ90IPY76axoD2ssci7/I=
X-Received: from pfme10.prod.google.com ([2002:aa7:98ca:0:b0:748:55b9:ffbe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1795:b0:742:3fb4:f992
 with SMTP id d2e1a72fcca58-74ea64572dcmr6278110b3a.10.1752106717633; Wed, 09
 Jul 2025 17:18:37 -0700 (PDT)
Date: Wed, 9 Jul 2025 17:18:36 -0700
In-Reply-To: <aG71_sKK3jzIs0vt@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-12-vipinsh@google.com>
 <aG71_sKK3jzIs0vt@linux.dev>
Message-ID: <aG8G3GNi_PlqgvnB@google.com>
Subject: Re: [PATCH v2 11/15] KVM: selftests: Auto generate default tests for
 KVM Selftests Runner
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	pbonzini@redhat.com, anup@brainfault.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, maz@kernel.org, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Oliver Upton wrote:
> On Fri, Jun 06, 2025 at 04:56:15PM -0700, Vipin Sharma wrote:
> > Add logic in Makefile.kvm to auto generate default test files for KVM
> > Selftests Runner. Preserve the hierarchy of test executables for
> > autogenerated files.
> > 
> > Autogeneration of default test files guards against missing these files
> > for new tests cases or rename of existing ones. These autogenerated
> > files will be checked in so that during git-diff one can easily identify
> > if the existing test files for the same test binary also needs an
> > update. It also add new tests automatically in the default coverage.
> 
> I'm not sure I'm sold on the merits of committing these to the tree. My
> preference would be to prioritize signal to noise and just commit the
> 'interesting' test configurations and generate the defaults from
> $(TEST_PROGS) somewhere they're gitignored.

Yeah, I don't love it either, even though I suggested it.

> There's no amount of foolproofing that'll prevent folks from renaming a
> test name w/o updating the 'interesting' test configurations that depend
> upon it. Seriously -- I'm sure I'll manage to break it at least once :)

I was more worried about clobbering someone's (poorly named) default.test, e.g.
if the user modifies or creates their own default.test and the building selftests
overwrites their file.

The main reason I pushed for committing the default testcases is to avoid having
to figure out when and where to generate the testcases.  I don't like the idea
of generating testcase on *every* build; it's not slow, but ugh it seem beyond
wasteful, and it feels weird to dump files into the output directory that the
user might not want.

The obvious alternative would be to add a dedicated make command.  The more I
think about it, the more I think that's probably the way to go.  We already have
to `make headers_install`, so having to do `make testcases_install` or whatever
doesn't seem too onerous.  The biggest conundrum is probably what to put in a
.gitignore for folks that do in-tree builds.  I guess maybe we could add
default.test to the .gitignore?  That'd "document" that that name is reserved,
i.e. would help prevent people from trying to create their own default.test
files.

And since the runner supports listing multiple testcase directories, it'd be
quite easy to "install" the defaults to a dedicated directory while also pulling
testcases that are commited to the repo.

> On top of that, there's a lot of selftests that take no arguments. Not
> sure what we gain having a duplicated definition for these ones outside
> of $(TEST_PROGS).

The defaults are purely a way to communicate the existence of the tests to the
runner.  My hacky bash scripts for running selftests copies all binaries into a
directly and then runs everything in the "output" directory, but that has obvious
flaws :-)

