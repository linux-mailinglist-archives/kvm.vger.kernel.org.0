Return-Path: <kvm+bounces-18794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D79928FB795
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 17:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB09CB22412
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 15:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38FF148FE1;
	Tue,  4 Jun 2024 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jacq7ET1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3150143C7B
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717515054; cv=none; b=FDF7dtSSXbBGdrH1CSiVOBpRmSEIrVaLJDhrB/eYVHJWh/E8Jfmc0dwhKYFznAxfcqr0OjoXmYp7itjwTe5tu6O1SeUTn/H5Nq1SZHOlOU9kK8JfeWYNDcDGQFKKNTPpm3OgJwoI7cK9oU+uwK66oNLdtU4OAPc5vwLmqGYNTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717515054; c=relaxed/simple;
	bh=2lWMKqsHItwhHTzuVJ/0FS6TZogDUllZ/+2lC0bCC1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pQlfJfQZVjV8jYosuTZvVdnCwdmMkYwZWmu9pIAjnI40hVWjjETqpnwZjUKelRg2emKSLMN6o4/8CS2RTremXxZCClHFMkvkvFPQBKKPvwyjlORYkW8e+GfTKOh6Upy/jB6fMeNody3oSZxAAFyqxRgJGtTwP8eTAkCZM8twsBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jacq7ET1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c2093beba8so2373084a91.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 08:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717515052; x=1718119852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lvsnC3tNwAIKV52NgJ9GA/qBx6iHWNynLL2JkVVL2Lc=;
        b=jacq7ET1w0T5KqTvs+jaxl9hSvCuKtfGo4kpU28Ovqm7eRqZmqAhYk0Hbgmozay9ap
         y5vN/+NuADKMUq2JXn57xPtAGEN2D5sdlsaacQN0QMx/zY309rlBco6XGF6cW5kiEbe9
         mb9c14opxYHv8p2+kHOnrwqWmwpEQowUnpnBrr5bl4B1ho0z60o7KkN+ywRuFlsx5A1o
         diNTFiPIy89Dn1uQTNH1PVhvmOaK5Pu8Ixx8m7SM3jVsHnBASAWMYBNC9xWB2ODSabpQ
         uP+RMZTi4AVIgqEMY1ATHgkeSSmjxpiyqI6UI+8pOJaMWHHzncmBddw4zVVl+VuNrTBc
         PREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717515052; x=1718119852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lvsnC3tNwAIKV52NgJ9GA/qBx6iHWNynLL2JkVVL2Lc=;
        b=Gb3DsChnCaV0x++hEZAuOWoue22uimNraYDAnevlbXlbQfcVjDScFXiCLW1KkcX9M7
         nSeH3h16PH3322Fpv/tcLqa4qRcK1hpQ3sI43dcr5oqb3uHlKPbVZlY/DrJ04UKN1Pef
         wrtzrOFzM+5DlF9bDiFoWHl3UsUZRqcq/zqg1OL5a9YYVK39RdLZmfuTabb9TzYM1Hw3
         PxnrEjnVCeO4Wh+51ZMWr4/BuRFikcF/+pzYKx/YFxOfsvW7K1ayqEDzz06uMewpw0MI
         2V5Brv3sgVWpzH32yfLBpB1vGgC83ZAfCyCSgiiom/mf7yQXznzvuJEX0G07DnkH4Vl4
         ewdQ==
X-Gm-Message-State: AOJu0YxhEi1ZDFFXwh/hQcRZjl/O7xnOyRM7gNNdpGdmDnfmWxfYFVQ2
	w8PnVGFpZn6JtUF08zLwKjV69QIoUlGuugDi7UgmCwy4aNb2HzTqz1l8NsHv8fstjrOuskVrbD/
	PCw==
X-Google-Smtp-Source: AGHT+IG55CsdKvJLqIt2DP2Sho4C8gykfvO7tuxsdpp3dLgoXFdlHLWqrpf8vh9e8qa4+WyBBCEnJkhDaws=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:354:b0:2bd:6abb:e9f7 with SMTP id
 98e67ed59e1d1-2c1dc4b118cmr36083a91.0.1717515051411; Tue, 04 Jun 2024
 08:30:51 -0700 (PDT)
Date: Tue, 4 Jun 2024 08:30:49 -0700
In-Reply-To: <20240604-e11569f6e3aa7675774628ed@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240603122045.323064-2-ajones@ventanamicro.com> <20240604-e11569f6e3aa7675774628ed@orel>
Message-ID: <Zl8zKYynz1rgg1OX@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix RISC-V compilation
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, atishp@atishpatra.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 04, 2024, Andrew Jones wrote:
> On Mon, Jun 03, 2024 at 02:20:46PM GMT, Andrew Jones wrote:
> > Due to commit 2b7deea3ec7c ("Revert "kvm: selftests: move base
> > kvm_util.h declarations to kvm_util_base.h"") kvm selftests now
> > requires implicitly including ucall_common.h when needed. The commit
>            ^ of course I meant 'explicitly' here. Gota love brain inversions
> and not reviewing commit messages closely until after posting... Should I
> post a v2 or just promise to buy a beer in exchange for a fixup-on-merge?

LOL, what kind of question is that?  Beer must be a lot cheaper in your neck of
the woods :-)

I'll grab this if no one jumps on it by tomorrow.

