Return-Path: <kvm+bounces-15867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA088B1446
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 22:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 818021C2141E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2051143882;
	Wed, 24 Apr 2024 20:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LiBseNzM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F60142902
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 20:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713989633; cv=none; b=PfTqvIPc9Fh8ET0xMwpqYJWD4ZOsviCnNHyfZOZ+EPIbT3AAmi8cH92mK7PyfqaNvKCj5pizvZUGZTCxRw9dcgWnzMaxeeDcrfPjfQlthBtLXywdcd+MF9ItmQ+/H64nF4a7mGQHuiFKPBq9X7U6LMAvvgQt3/qvgNHSIBQB7CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713989633; c=relaxed/simple;
	bh=ASuoZZgHctVFrA5qjzXFbczbyWL4m9fk3dUFVVw8qdM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vFXA9jnWcg2j1biK5N0uzEYs3eMSwmP/or3ya3jJU/DIhYOH3Pi+Afnbgknyba0SrXI5PDQQ46OsOc7mYz4bY7feKrOry6F40340+RSjsCIkc591FTytWDPeHTzD/V/kgVCtij8x4JhZXYoqI7wSRCHCPo9XUVSkVzc80J8kES4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LiBseNzM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6150e36ca0dso4094327b3.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 13:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713989631; x=1714594431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kE8OuYsfUCESTgdrzuGuZRqCT/StXQ3hLmK/0rboegc=;
        b=LiBseNzMnYZprAfGgh/SUE+C/5LhGzxNCzrJhcu2uBhwRAzUmTOPPaLvKrXolDqHPl
         Xg+ZcooNxX5DCvSxbDN2KfU/Kexemagf7P2ni5GXJeLDav5NSa85dv7YYu/0pQ1j4dOG
         FuToY+slSObJ/MYzBzVNOubcCsFyPKSDcc9fN+tNHhaqCRuGtauAhp0oTVzZwAs16dyV
         lL2bofnk+7B+Ih/7FNFUVpIroxErw9wAJhFBe0UPa5+rPcVx6hRTuKeUlju7qtQV8Jnq
         rAdQGAxY6MwbWYDyQaA2FYIlIoEpT6zps5kIxlSXXpEjzq3GiOIFCEw0Xwqem8Q8xSLd
         eqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713989631; x=1714594431;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kE8OuYsfUCESTgdrzuGuZRqCT/StXQ3hLmK/0rboegc=;
        b=LJ8mViJfboSwiAYTAEqm1WcxwJQ1dr/xlonIvQF6r2kZLRjQBCofWhgW7iujlD96DU
         1TT6NZBfRj03GpIrYF6AswGrFP/urLL8EFh6HULsC58nykcZU+JOfD5Xrsv8GKo32Cpz
         XgGJrVDB/LCUYwJDdSlhwp3B66zn1OFUasPQ2v8p4ePWyDKBTUuZBwvK+PguybCcTctT
         7k0h443NjAJ7+i6coOmkEOVqOFTvnIDWTxRIw8pp7xeqjXkr7Zv2NiV+ed1y/ROSWg6O
         /cBD+cIbzW9FeTv8dlSaeArVUdcY+HDjDx8lIyjCbmObkbQeWL6AFN9XszlKXCkpu8If
         rkSg==
X-Forwarded-Encrypted: i=1; AJvYcCUitnAaGsS9QIKFqj2tOKBhKmC4ZXDxEwvlWPYHvC2snWi/FvIL4ozsFXYLuWVKU15SsQb7d78oH19/OTKCoavUm44C
X-Gm-Message-State: AOJu0YzRIBP/QCrRC38H3mLU2aWU34Yej/0tcEHlLwXsjSJpIGvduysS
	umvrVcscNi9ZB/Oysh5B8/6ZbNbjqeubS78iTIVLyDqDWI4hkhL8vffXre290ct73BGslCfFw9b
	YNg==
X-Google-Smtp-Source: AGHT+IFwb/d+5gTCSXFtCzoG+k7UNeHOqkw9jquiZ+7SlUexVJagTvBBymY8FJeyqRdGUC/cduQZwjBHeyE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d48c:0:b0:61a:d0d2:b31 with SMTP id
 w134-20020a0dd48c000000b0061ad0d20b31mr692742ywd.3.1713989630884; Wed, 24 Apr
 2024 13:13:50 -0700 (PDT)
Date: Wed, 24 Apr 2024 13:13:49 -0700
In-Reply-To: <ZihZOygvuDs1wIrh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240409133959.2888018-1-pgonda@google.com> <20240409133959.2888018-5-pgonda@google.com>
 <ZihZOygvuDs1wIrh@google.com>
Message-ID: <Ziln_Spd6KtgVqkr@google.com>
Subject: Re: [PATCH 4/6] Add GHCB allocations and helpers
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 23, 2024, Sean Christopherson wrote:
> Oof, and doesn't SNP support effectively *require* version 2?  I.e. shouldn't
> the KVM patch[*] that adds support for the AP reset MSR protocol bump the version?
> The GHCB spec very cleary states that that's v2+.

Ah, the SNP series does bump the max version one patch later, presumably after all
mandatory features for v2 are implemented.

