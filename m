Return-Path: <kvm+bounces-30221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F789B82DA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE51C2831D1
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 18:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69571B6555;
	Thu, 31 Oct 2024 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d4Rqvyvx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F131113A865
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400537; cv=none; b=MbQ/WQsmkZUv289vuSY0UjVLnNBIdk0Iur+A0IaXSAxC1ISE/zGNCe9U06O2PPtKrzmOJ5fUj3ETP6UosA3frloES0qEHSd4+c0bl3DsYb8GGJ0WCF7eOA/fVj3UqVZ93k3Iks52ol/01T/JhCrb6gWIPkvFOKkb2fn5nJJFUVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400537; c=relaxed/simple;
	bh=StOX3VJgeeCcGydnHoV/ppcMTS/dD8CMc3Z15gN5Oj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bocm0weFxcPCn3AdDdYb4Twx/afaTWOXsQjyFy8xGpGiCymxhOr8nBIgkfJuuLTX8Sv7pkJgOVjFNWi9hDqQIVngFXa5BKz+S1uIeOkZqhKa4uJ6QViXZRuKcaWDJwxoLoLf+DOouRP5R7B5GGT5NjxYvfM+3wClA2kpoaqwgsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d4Rqvyvx; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e29687f4cc6so1047096276.2
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 11:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730400535; x=1731005335; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjxTbYK0rVm6SzwGaJPD8zRt8ZyPc2ZbH6hoVthyGCw=;
        b=d4Rqvyvxay5R2gRXg6RdQ6Ml4zs1/HkVBQLW/NojLBRaRDR+bwWfCY7EV8NP4C5toi
         W/vtQSpZA4DN2nj3gyz6FrSsEdUnywT8LVMki7tw7Y7wmHBN6u7Pf+ZcFR6FUTZSLhEX
         +ifYolEMDLb8Xe0FpR4xQ0EOpP7fgVUIjQoDlzlbSguHTgrRMPxJ+QTWZy15F5kFktvO
         7QsnaxHJDNMzrUBWSuWtWKaEWHmgI4wiYR2Clfqi42tuj6lkiHfbHdVQuGPY2Xc5tQPw
         NeteMzxD06H4L9VkU16zVpHjDWWX5JOf27B1x8OnCd2qdwwNVYDjPcSKBfaoSOouBRUW
         OUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730400535; x=1731005335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjxTbYK0rVm6SzwGaJPD8zRt8ZyPc2ZbH6hoVthyGCw=;
        b=P6tiDvAQrylaNgIoW5nvJD+dc/6Vmc9Dd0uCuMfouVBgZebAt3Fi04squ+BAQanwPo
         un9Gjnzr8zwhjtkF5trVLIa4OpIU/PtROQJvh7FiREzohkKhYc/BUq3KzCNP2+uPy3Y2
         E93dIAwFvpjoQNCmH2QgcZReBhniLw6mPcAgtPtZfwD1uxVhqzGusjq72FkIy4VAlbaJ
         8mj96rqOiUHwsD4Rg9XpoMkdDIZe3UWXU7uOm+4w++DOW1GeU2lRF6FYYLty1pEK8An2
         7MOJNpdQGqiVQZl7IlGLpAExOKcpKTzNL+5Q3uzQCjKHTxyd9DObpiGKtyYFC95TNQci
         BtTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWadiYlzlmF6daSzgxK49o8oxK7gRMBpS+KqxvaUxCmNzSr1XDJpivZpiIPtUaUuT9M8HI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY9EcGOpVISEN6R719GXWBG1514VtGIbTcsqyUprwCLvtD8jMJ
	bRV82hDK2Kz7OHRsHcTW28to5p9rUrhTb18DQOBdKKY8LZdz/UqYVdkFKdb9/Vp+jn8KWPHiJ5+
	vWpseAOUbdbTeqrMBKnZPs0oYKhhkt5j7qiuI
X-Google-Smtp-Source: AGHT+IFvoa808z3zzct+NFJ13//TLpJPqCF6MpauRdMB2NX4h5McifZkHrW3H7AFthX58R6c+y4oF0AERWAfPfAcGPw=
X-Received: by 2002:a05:6902:2501:b0:e24:cae9:4e39 with SMTP id
 3f1490d57ef6-e330269669amr898774276.51.1730400534880; Thu, 31 Oct 2024
 11:48:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031170633.1502783-1-seanjc@google.com> <20241031170633.1502783-2-seanjc@google.com>
In-Reply-To: <20241031170633.1502783-2-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 31 Oct 2024 11:48:18 -0700
Message-ID: <CADrL8HUwkxGmud5hVYPC6ibsA=ee8SePbzz23Vrqrex+AOtmTQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Check yielded_gfn for forward progress
 iff resched is needed
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024 at 10:07=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Swap the order of the checks in tdp_mmu_iter_cond_resched() so that KVM
> checks to see if a resched is needed _before_ checking to see if yielding
> must be disallowed to guarantee forward progress.  Iterating over TDP MMU
> SPTEs is a hot path, e.g. tearing down a root can touch millions of SPTEs=
,
> and not needing to reschedule is by far the common case.  On the other
> hand, disallowing yielding because forward progress has not been made is =
a
> very rare case.
>
> Returning early for the common case (no resched), effectively reduces the
> number of checks from 2 to 1 for the common case, and should make the cod=
e
> slightly more predictable for the CPU.
>
> To resolve a weird conundrum where the forward progress check currently
> returns false, but the need resched check subtly returns iter->yielded,
> which _should_ be false (enforced by a WARN), return false unconditionall=
y
> (which might also help make the sequence more predictable).  If KVM has a
> bug where iter->yielded is left danging, continuing to yield is neither
> right nor wrong, it was simply an artifact of how the original code was
> written.
>
> Unconditionally returning false when yielding is unnecessary or unwanted
> will also allow extracting the "should resched" logic to a separate helpe=
r
> in a future patch.
>
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

