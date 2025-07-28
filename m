Return-Path: <kvm+bounces-53572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE1BB14171
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 19:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 211973BAA51
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6A3275B02;
	Mon, 28 Jul 2025 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mlNE8HDq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3019270EA3
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725117; cv=none; b=CXyK8L1iIKuonR739nV5e5Occ/hrPwBJfQSp9pobTSsBnh2ofODiBqHUutk99J7/oozLrH46uTxSpzG+yiFRusADm5NbywxpIxSf6f1L9UHPQ7hYkzURGu+Ww1rmTNodNSgOrC92W2+CPTe5koprwFik5Uv/eZ5rEpZa7c2n+n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725117; c=relaxed/simple;
	bh=TJi4GOB4EeT9H5uJD808QEtaaGwyl01PFC/2eTlYmV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YhFGVaisFB9U4K1igdN2IHhb0qaTf+AjvGoN5ffXFaajbvouSS4OXrQzHK5NeYFnpxP8MUQNgNoWKDEzXGwrlOz2XWwr9LHfmq05ZM5eT755np8JmLggJBErS18NasJm3mhEQDLm9GEGL3ED4tQfHylcmxTBU36mAL0ArxgiUNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mlNE8HDq; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e8b3cc12dceso3335485276.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 10:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725115; x=1754329915; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2r29EAEWFlw/l/EgL4Ua3Lklyccw8yEpLgB6QQXTkI=;
        b=mlNE8HDqFd5yi+fxjCQ+AHttqRotcw9SJX05cII9K4ebjlngZi6UI/xlcqDcnMAncF
         agkvyrINfOigI66DSq6YkmvzCedOu7JlnkTyKkcKkYD7eD86fR5fE/MDVwzN6E5ujwT7
         r9j9epKb59Z+YrOpwaDjaPuNY97XNOPNol+qR7kZzgWSeOjHGch3yKUKIMhn/Wna8Rcg
         hTCiKBBouAFO5dH8ab+chYmlU3ItHT2iDbCe7qw5MLg2WdtvV+l0S1g7ULfay+aYx6mf
         33/KNMRSenJ9a6as43uzpSbXMihvpwArLmdR25SWQLCdCfqkQWbJOhuSkopGvjtSp9fN
         60Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725115; x=1754329915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j2r29EAEWFlw/l/EgL4Ua3Lklyccw8yEpLgB6QQXTkI=;
        b=lu2EkE0b+f4cK8bC483Ny5d+JPfYJnxSU+hw5hS2DfjnZT01IKsjRv79K6wsPVCdwN
         vfZz5GaIAjye9ee0MYvCiQsHaw218poJ6f5/ONydyLj+g3X+vn/u8us5G5yyJJ7N5XBT
         fkk6CrQ8MmPTfq4ggCkB4dSlBqPrJrbaVzwMCFmnDE+noqfaOjrV3q2f5Px147+V2Mlh
         6HKxvbvXg57J5yaZMOggRhZmo8NSzUGkmEddQ05FIiCaVsAoGcYN2bHhiuKn+pZrTMm+
         xpSfAb3jOOFE5XDWsrhZDo6TFKm81S9E06GZXR8kC3GSBE1bBl8shjXwR37SIv84y36O
         LcAw==
X-Forwarded-Encrypted: i=1; AJvYcCVz2XNaAPOnZ35bV9nB728shVT8WW+RNCkcmGvsjfyRGXWia6yLDbC9iM1SkWEbiaJJrOo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+gubojAMPK2lyqzfzfUv4Is/JCY+yrwMKvKTklqdqphosRg4i
	mcCjCe9FmSU3iokCOSqEglCiH6jl6VSpciJ2uggUMr8a7njsxI5/Afv3Eq2FO9KJT0qyMyb3oQP
	QDFySXUs957Ua/0TR9GzItrhb+Pvn1/IRmC2LO/cx
X-Gm-Gg: ASbGncsX8VEJ/vkUkCrzQe18bvwrtQNJ+LqrYaQtBxiapikCMKQdy/mpbs3H5FonjXB
	Y7fgj4f+pI0ACPNMJ8pz7x0ziSMFcdaTQYfesJW4+eA5xomlEbZ8hcVOZLKfFvWQHEKHiyt3y2P
	EEg1Xbv/rwwbVAWRDPZlgQSVrzVHsmarMXdRj7Si+9Vk6X0JxcZlmpZdB/X5R6NgklKlhi2JmrO
	0uuhh106H03xMBoZJQOjBCxU+GCGeSdsxZB
X-Google-Smtp-Source: AGHT+IFEXJWe8zNqy1Et2HKzb/9JPYRLQ2U4/5pPfu2NNHlcUwdpLBK5JpoQYc+dlXychoDupsm34AZdy6dcmmu5maI=
X-Received: by 2002:a05:6902:2d04:b0:e8b:a52e:5c83 with SMTP id
 3f1490d57ef6-e8df13c1321mr13649633276.37.1753725114121; Mon, 28 Jul 2025
 10:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-5-jthoughton@google.com> <aIFIPm5zENeKlgkw@google.com>
In-Reply-To: <aIFIPm5zENeKlgkw@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Jul 2025 10:51:18 -0700
X-Gm-Features: Ac12FXy3wtVmUaMe5OGRUj9egCVeeNJ1mGFEDMoqTON0HprHOrR0fLwV6y-LoGQ
Message-ID: <CADrL8HVAcWFO3Nv3Ox4k6VdcON=8k+YrOFgqoFojOW=eWJOzaw@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] KVM: x86/mmu: Only grab RCU lock for nx hugepage
 recovery for TDP MMU
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 1:38=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 07, 2025, James Houghton wrote:
> > Now that we have separate paths for the TDP MMU, it is trivial to only
> > grab rcu_read_lock() for the TDP MMU case.
>
> Yeah, but it's also a largely pointless change.  For the overwhelming maj=
ority of
> deployments, rcu_read_{un}lock() does literally nothing.  And when it doe=
s do
> something, the cost is a single atomic.
>
> I'm leaning quite strongly toward skipping this patch, as I find the code=
 to be
> much more readable if KVM grabs RCU unconditionally.

That's fine with me, thanks Sean.

