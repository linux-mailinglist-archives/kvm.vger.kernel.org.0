Return-Path: <kvm+bounces-53391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C236B1115A
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83C115A73C4
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A14B23F41F;
	Thu, 24 Jul 2025 19:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gt+5XrEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA04F1F4C99
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753383863; cv=none; b=SNqOToFWbRLZZ5USELzyUjIpbVe/lp/tAeUntrZhxgB7Fq60yOahBx7EAT4heh+9z7Jh0GqHBLzyU6EgP3QDruAeKtNN0D1g6PqRR7FDz8Sux1WD9T2BzveOTkvIpTzauvpzJh+Rs4l7uhasQuBF6+NrF/zN+JnQvkjoVvUCvqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753383863; c=relaxed/simple;
	bh=77VL7y4orPyPDwVVBdslEyUFCNhMKPh1m2rvHd+AdTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OMbTmQ1ggLukz0BKLMWvrSnap2cHJce79gKFO9gyWaXTwBasSiW/StMR4aJePLCEr1iyLgIL07BDfsDlHxDoE/FCmUQD+aNR3QuLfIXP6QaJbrICR2j9uC51eap6i1qNmUqkSCoR20jY8lRxvQ0rZaQTj3blFAeu1Ho6UTpRMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gt+5XrEP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311d670ad35so1199597a91.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753383857; x=1753988657; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zJyCIzUqeve9JsPqtXqjY52deoOozt0NyyCd1G6236M=;
        b=Gt+5XrEPfD6TO6AHBecksXOl6q7HkNp55JhtBwl0fNgxe+uAMspIgszMMhVXMZQiIg
         CTFJ8rEH0zdfHGbWZ7RXm9TYN+M2VYwMqbJeRCPJ5R5BbKxmF7XHSEERkK6XstPiP6/w
         oqSYHttx/nKwEZFogJ/tu/y2gCSJoB2WDUbwhPCnyr0VmMjphhDUKEP6JztfHJ6cejji
         iEtKgQxAumME9xNRmUNWQdici9khSE0kc9gB5LxyH90XWGELh8s3g+xy4ToN283adUJI
         cDvCT0ZpMrDk6yUjmC99q2O1btvpaxkudFen2xMfr5vvMQvFUIJkFQlBvJhiGmJJCGix
         hpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753383857; x=1753988657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJyCIzUqeve9JsPqtXqjY52deoOozt0NyyCd1G6236M=;
        b=gwVi49qSpKWI80C53U8C3jgBBMD5IjpThD19n3dThjJyIpo+ku6DFwXYd34c0RPpCK
         ywq+BjqUkuYVKPiGl0geUAi7dOXryNj/iJWfaduqF7vJ6tzNbdMQu4mkqWWG9K6dNTsR
         mDZJQ/wlsTqz5v2QaCO11+KtNpc54o2YbjjbtQlNQBx4O1AiL9RAOlH6tuscygGW0pdQ
         3TsYJZfF7QVv8H6L08rjbazGCyGQLBd2LaMrPNGH6W134eZYnk7IquDtrr6T2Y6rrUem
         FBF0O57JjOj8k3kNmOwQh2iKLMYGSJ12hXL0eu+DN3/0BmOAG26yX9E/GDSAuiA1NCzH
         7tcg==
X-Forwarded-Encrypted: i=1; AJvYcCVhwPCT0G6wpTxkUfOAPubAYsfkdziJrM1hQlnQSu04B189EzTjo/GxAOjvPOTAxyyHezo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/U01yducE/fe6aQDhoLYd67MAftpIDRBaWkKw+0o3NheiHLxR
	rtIun/3DetCQvnrUpwxxt4TTFtPVVXhloVFud+NbGawKshBNygnsTpY7Nv+i3NZ5KqUj/bpYYhs
	DKlfH+w==
X-Google-Smtp-Source: AGHT+IEe6+6fR9gO5Nl0Xt/yeEjity2RKdtTyWI1KTrUYedXflcE9z6fhLr5gE2QJHjWu7/9QdOuheoivLE=
X-Received: from pjd16.prod.google.com ([2002:a17:90b:54d0:b0:315:b7f8:7ff])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582e:b0:313:14b5:2538
 with SMTP id 98e67ed59e1d1-31e50859d80mr10487542a91.35.1753383857192; Thu, 24
 Jul 2025 12:04:17 -0700 (PDT)
Date: Thu, 24 Jul 2025 12:04:15 -0700
In-Reply-To: <2025072441-degrease-skipping-bbc8@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aII3WuhvJb3sY8HG@google.com> <20250724142227.61337-1-thijs@raymakers.nl>
 <2025072441-degrease-skipping-bbc8@gregkh>
Message-ID: <aIKDr_kVpUjC8924@google.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
From: Sean Christopherson <seanjc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
> On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
> > min and dest_id are guest-controlled indices. Using array_index_nospec()
> > after the bounds checks clamps these values to mitigate speculative execution
> > side-channels.
> > 
> > Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> > Cc: stable <stable@kernel.org>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Nit, you shouldn't have added my signed off on a new version, but that's
> ok, I'm fine with it.

Want me to keep your SoB when applying, or drop it?

> > ---
> >  arch/x86/kvm/lapic.c | 2 ++
> >  arch/x86/kvm/x86.c   | 7 +++++--
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> You also forgot to say what changed down here.
> 
> Don't know how strict the KVM maintainers are, I know I require these
> things fixed up...

I require the same things, but I also don't mind doing fixup when applying if
that's the path of least resistance (and it's not a recurring problem).

I also strongly dislike using In-Reply-To for new versions, as it tends to confuse
b4, and often confuses me as well.

But for this, I don't see any reason to send a v3.

