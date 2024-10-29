Return-Path: <kvm+bounces-29950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 647C99B4C51
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4D3FB235BD
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F1520720B;
	Tue, 29 Oct 2024 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TaeOpziv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAA62071FC
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730212837; cv=none; b=M/nTUUgmLoaKR95nAKiUqgKHLQKORR9+37qU+4oaq8zEJflxccVTTQ9XH9GccYDPDCGkd/65tjU4TE/w0mJBgaVtOYfvtrsuRAXyr5h+ELAFMnftW5pdYpYenHacdpmRxtpvZSFuiNmQp4PRdy5id4t7fKMHm/8clzCijjcPrlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730212837; c=relaxed/simple;
	bh=oa+ecJWuyWFLH7ZxazuBVoefmJuASR1Rhnv7y8xKspk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e433KZM72ywrAM13MaLbJpvJq7EBw8ftnIXLlMdsxWViWHkt46Bo+1AzNMCCf8GDrezSfXgCdn1qm6J85oGTWSacQyUUapfdZD3oAV2mlR0Ii2iqHy2pZ6xuJfyTB6xYGbkx7MYlbijIHrVaYKsTNcJQmfwhc56wOTh/AcvwYhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TaeOpziv; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fc60660dso8394992276.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 07:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730212835; x=1730817635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZURPetRk0pTnbiNEOPR0W3xXFQVbNGIGyW0OrcoXvE=;
        b=TaeOpziv8p9FryNaMS8++3DWfV1DASRfPGUZAqZ5IN0OlqKRZWA/9hgSpH2gmSMblr
         l+lT7CZaIZPX041eZl4HnwSRdjV0kplnwEvkueM5zBOY/LoxTiBLIWTSG2q4REK9NXB9
         2Ik0XKLyLzhyuqTeOyWMln6+p5gtA4RrqCIuFNsDztnZ4hPdBV+iSLxAVTi9E2ICLew3
         IFkNsqR7iBuKbalXWDpSjTdyfKmR65fDCOBWdnNKoJZbSEzQI4MzNyCG7Lte51If6O3Y
         Z0crs4GPTLOJ+tKjC0X6HlIaX4EoQj6a0bemDFETxpgqn8esMY8BbhakR8Rpj2lEtV0+
         xnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730212835; x=1730817635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZURPetRk0pTnbiNEOPR0W3xXFQVbNGIGyW0OrcoXvE=;
        b=fqcHde9+6WRb/RHQOo3Ghc0xP/vdaNlwc3vXa7QOBt439VtYrDtZhFpQ4m5lD4f+7I
         fz7SXzvCGTWuXn28SHgSFlt0ri3xoJEPPJEWbp38IKT7qZjGMuXkvo+vmjIHSZdNTlHP
         jnbw2bDSgq3p2EDL6G+RzeGWdHQVoDxJ9lUK3XTJK4GTXebWtbGOi1VucfnQtA+Xz1x8
         O5qE+lcI3wUOkDX3hI04gejJ3SgNEyp13CsAiZ8h+5+yRcx1K2ahijxunuL8S8wuCR6g
         YpAzZlE/iWJEtiZosAgEArRnU7gzGlIhBZmF7cDxni5snrkgAUTdwuxJwgkASzAntkwp
         dD8A==
X-Forwarded-Encrypted: i=1; AJvYcCW9Kr+I9MYJ+bE+IhScnX2an0BUNQTADlfrgUoVE6oBHmrIR77eYfwAIHaBqFKW7uJYL8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw+JcMElijHxVWU7Mgl/xqb5PooEefnSGQneEeYOHMdyV+FbJK
	VlBCywXFoYn8fRalq/d+2VtUwBP3gNLCXtSVwQXFrnm13Imr7JZc1MeG/gsnxEfI28Z+eDK3HJb
	0dA==
X-Google-Smtp-Source: AGHT+IEEilk2EK1brP6PSC69voETQHBJTwU+IafSMkR926CjbDlA6tCqkF5Kk3FPpRGhJ4ZS56aFxwrYkDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aace:0:b0:e28:f35b:c719 with SMTP id
 3f1490d57ef6-e3087bd6066mr41479276.6.1730212834790; Tue, 29 Oct 2024 07:40:34
 -0700 (PDT)
Date: Tue, 29 Oct 2024 07:40:33 -0700
In-Reply-To: <20241029031400.622854-2-alexyonghe@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241029031400.622854-1-alexyonghe@tencent.com> <20241029031400.622854-2-alexyonghe@tencent.com>
Message-ID: <ZyDz4S0dYsRcBrTn@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: expand the LRU cache of previous CR3s
From: Sean Christopherson <seanjc@google.com>
To: Yong He <zhuangel570@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com, junaids@google.com
Content-Type: text/plain; charset="us-ascii"

KVM: x86/mmu:

On Tue, Oct 29, 2024, Yong He wrote:
> From: Yong He <alexyonghe@tencent.com>
> 
> Expand max number of LRU cache of previous CR3s, so that
> we could cache more entry when needed, such as KPTI is

No "we".  Documentation/process/maintainer-kvm-x86.rst

And I would argue this changelog is misleading.  I was expecting that the patch
would actually change the number of roots that KVM caches, whereas this simply
increases the capacity.  The changelog should also mention that the whole reason
for doing so is to allow for a module param.

Something like:

  KVM: x86/mmu: Expand max capacity of per-MMU CR3/PGD caches

  Expand the maximum capacity of the "previous roots" cache in kvm_mmu so
  that a future patch can make the number of roots configurable via module
  param, without needing to dynamically allocate the array.

That said, I hope we can avoid this entirely.  More in the next patch.

