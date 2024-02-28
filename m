Return-Path: <kvm+bounces-10182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CA586A65D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B98A1F239CB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5461CA7D;
	Wed, 28 Feb 2024 02:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mCcS5ZCb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC6E4A23
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709086322; cv=none; b=KEU5upLi5+T5yBhfZ1AAG+e2/yTb9QgB8qUYhBg3+su+yEz/3D7L840KvQ9w7O/hPziiSe+YkPxi/E11SEzPufRAXdZb6llWkhKCtf8YpkPCK+nj7CtP3d5k172OeLLJAuGESJsjH/uLSL1IMfcTf8EW/ov9H/higVRKu9mUiZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709086322; c=relaxed/simple;
	bh=p5Wahx7owb2D2GfVq0T01q+bfIu0ztWAQyILEnY7dQ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XfnvLNcCZwoRjKg9n2ZCrk5WEQ1iUOTE9YLeYSolsMC1+s3CFS8qTm/QESCWbm/a3Yt2CrX+MoObA3kTcdHHOXwelhScS939e64ZZm7ETqfn/RcViHluCo6weCdzmtwgqq05Od4l5Htu8v306kYQ2zoGgZK6dZF/IkM3aYOyo8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mCcS5ZCb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b5d1899eso635206276.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709086320; x=1709691120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qIJEAcQJ3yU6dJu8GmHhPj18u/c5zdDyAfCrkcskd1k=;
        b=mCcS5ZCbzG6lWSM0SFWLFzKuVbkcZG4m9mkWGwfI8F2DLX5lvsKlYk/XQYk3057FSi
         emJAr1cZinvitMYHcSimxK6AfcQ+Cbcnt4JiUQ07dWseR3/d0T95umv/M+B0wZueCUQV
         GSkaYvWOKIIEn4jKoxh+JK0dKDKdLZVFFqE1EsMRj2WRtKg2nYl38BhPEqUrCbHDlPX9
         jkTQX1wrbAkzRnG3eg6PyTJwnLUPZcVo/RuTBKs3w3qKiCFNfngQ4OjCi7u769d2Y4Fp
         Bjx+jA3gwAbqkcLeT5SmXwDS03Ivr8hdo9ZghRGisPiLDy9hwThue83Lj1vAgRVC1Ott
         SsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709086320; x=1709691120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIJEAcQJ3yU6dJu8GmHhPj18u/c5zdDyAfCrkcskd1k=;
        b=U/51Gd4dmfxObROmPYMuSWKYnIl62u9ICeLd+J3KDNaQeNEpDRO1rVc5+u1rh/hKXX
         SS7RX0YtgF5Y8g9vF6wO8AXA2HIbHBVGtOIYma6QWIyHLxfNHGBVPjBF+s759kmGLmd2
         eJPUL5FP2A+ZNPmYGRzKKsdH55mOK3I2Fvxpm7l0rYPhANiCN5sP/Z+EE5owVgLfZqbE
         6rPPDTwODOQ3LohmMQ0aYWYg9Id4Xh2BAvU3h6IngYFXbNJN4EVe1/qBHb4RQAbz/pmm
         zQEDA5xHPMoB8tz5tVNeCc8GTlRtB0dVnouzoE1B1czgORgCYZNcLUCqSFkOhlhAn86K
         AIFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOUOnvl7F0Mu5IzAI+g3gCVEkljIa8Ae3OmycFPiymT+xqQBL51c4Tg7X6X3qIvwMuWcuRRYOv2nXnbgFrqjrOHJyX
X-Gm-Message-State: AOJu0Yz0uwGn4uaGi7xx9EcEnDe1PmfvaKDwkOE+b20iF/609PEND+w8
	tgamxdnsK9udjr5rFab/yh4a+AtJFLVavzvuYu0/4bhdPvCCmfjUr3DDkod7GLDjGPp2J953Y2p
	MZw==
X-Google-Smtp-Source: AGHT+IG9qyV99NLRISr5XJdPDvROvFTOJp/ScEEahoVynilHNj3qCHl7A4oB2GK/SN7dHgEvcBggPJbH32s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc2:2e5c:a21d with SMTP id
 w4-20020a056902100400b00dc22e5ca21dmr366529ybt.6.1709086320605; Tue, 27 Feb
 2024 18:12:00 -0800 (PST)
Date: Tue, 27 Feb 2024 18:11:59 -0800
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com>
Message-ID: <Zd6Wb6eeuQ0XlSrb@google.com>
Subject: Re: [PATCH 00/21] TDX/SNP part 1 of n, for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

I would strongly prefer we taret 6.10, not 6.9.  The TDX and SNP folks don't need
any of this code to be in Linus' tree, they just need it in _a_ KVM tree so that
they can develop on top.

And I will have limited availability the rest of this week (potentially very
limited), and I obviously have strong opinions about some of this code.  But even
if I had cycles to review this properly, I just don't see a reason to rush it in.

For the guest_memfd changes in particular, they're impossible to review in this
series.  Rather than prematurely shove them into mainline, we should create a
volatile topic branch and use that to enable TDX/SNP development.  That way we
can fixup patches if things need to change.

On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> This is a first set of, hopefully non-controversial patches from the
> SNP and TDX series.  They cover mostly changes to generic code and new
> gmem APIs, and in general have already been reviewed when posted by
> Isaku and Michael.
> 
> One important change is that the gmem hook for initializing memory
> is designed to return -EEXIST if the page already exists in the
> guestmemfd filemap.  The idea is that the special case of
> KVM_SEV_SNP_LAUNCH_UPDATE, where __kvm_gmem_get_pfn() is used to
> return an uninitialized page and make it guest-owned, can be be done at
> most once per page unless the ioctl fails.
> 
> Of course these patches add a bunch of dead code.  This is intentional
> because it's the only way to trim the large TDX (and to some extent SNP)
> series to the point that it's possible to discuss them.  The next step is
> probably going to be the private<->shared page logic from the TDX series.

