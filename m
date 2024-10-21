Return-Path: <kvm+bounces-29315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0AB9A938B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 00:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1930A1C22A69
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 22:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862641FCC54;
	Mon, 21 Oct 2024 22:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQZprm+A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97627137750
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 22:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729551075; cv=none; b=EoyZIIu2osJ+93O7Ff06Tg51Ji4lhgNzrd3O7mZYC5QCHc/RCN+ANWhXa4IIrN8dp+YLs9uC/azpZE/jC4KGqWjglRs/fGqVcEyOIN2nZajmkCHCWrqTTiVJuQIRihhh8emO0QW57GAGQlkT32/Pnp3AJ49gHhnN5hdN6aNeJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729551075; c=relaxed/simple;
	bh=lh+egOwPWiT6rlsPd8Qz6EzFrLWfAdtma57sGF21Yeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X0Go9YyhMg6k44+SWOJVI5FImtIc2aUnCIFTSntwuHql00FX7L9L4DbmLq0n5r+iyMrL7n2I3ANN+3GQya+wpuCTZSWnMwvGzJ9s2vvuQ9lOS9ybStVnd8+POvvE5mUcrlME107H9/CFF+Ft72zUn0q1jwwOmJ2QeXIcqDIQGkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQZprm+A; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9a0c40849cso778664766b.3
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 15:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729551072; x=1730155872; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AG8PzQqdiYQlkH144tEImcdVURTnmabmXi7XXqqoOAk=;
        b=eQZprm+AA5rZxZIvm8PAjb57LagZbYFCALSNtJ6YkWtEi4CMY4Up0F4CMZO1jWoR86
         tom9LZJuqLp5dmNEa7f/Sz6ZU2cKTav3bGtm/p7kNz0sVDBLkg5XQAb3fbgbfu71GrG6
         ZlfaqatTez1+507TK8zw0D1NKKWBo00isTXuw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729551072; x=1730155872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AG8PzQqdiYQlkH144tEImcdVURTnmabmXi7XXqqoOAk=;
        b=COTwfKf7RJI1v/MwB06pHWcpL56HkrbF7lba1kfksoH9yiKJx8nb6YIiivDdvY1+IR
         YER3GkMddyfAPiuFk776nMYv7oGmPQMlbYR1GnPIKYvva5IdjZ8ZCAkpmEt0TLJRz7Zw
         0Hxh1wh0Ppe42MBqmPi0Iycw9A2/xNQ0+aGrybWrQwU0Qk3xV48o4Pq9Wphj8TFctgaX
         +ZYcIA8/OGKc8HjoSMbPezoRJgePb5qBF303LcEhEsH0HGqtQCrhRzMtptTg1x4HpKH/
         dME4hESk1e4IDkfWnjAbygtAtowgppx+/ARiLp1V/P783kQLtnwCZVNZBF7cuA02ETY5
         fi1A==
X-Forwarded-Encrypted: i=1; AJvYcCXhGHui8s7jMm6w7fLRkxgQ+4Vk8Zp7nGoSz+22esXKI7SYh0J26hhfl340/MLPvlr4rR8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu9ekAu4s1PjDM/eB1weu7mKNwGFVNjNzMfsYwniBfo6i4zg69
	HJvf+7iIF5C1Ixtbj25KxYlnUsYx4rWv64eA9vwMJ7nMXm4QbzJNGfOkxrQ4RTB1AuNrLnaiUnO
	0ZF0R/g==
X-Google-Smtp-Source: AGHT+IFX0Q13KLI1MdsvFT/XGp2vk62nlhjYu2JxSYuy/tG+OKKDriA2Dcci82PbMjbtDeiOsDTCGA==
X-Received: by 2002:a17:907:3e1f:b0:a99:f0f4:463d with SMTP id a640c23a62f3a-a9aa890afd4mr116627566b.26.1729551071741;
        Mon, 21 Oct 2024 15:51:11 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d5fcesm262700366b.26.2024.10.21.15.51.11
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 15:51:11 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9a1b71d7ffso795353966b.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 15:51:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVS4U/FmYVVbGec8p15MnEEZewSwt9tasa4LSCuqcvLniswk+cCwZugtueFFH9IcKnnAvo=@vger.kernel.org
X-Received: by 2002:a17:906:7955:b0:a9a:222f:45bb with SMTP id
 a640c23a62f3a-a9aa892dba8mr141312566b.35.1729551070822; Mon, 21 Oct 2024
 15:51:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241021-kvm-build-break-v1-1-625ea60ed7df@kernel.org>
In-Reply-To: <20241021-kvm-build-break-v1-1-625ea60ed7df@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Oct 2024 15:50:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5OoS9v3h7YOPf2rMFWGfHQUgNrFRJ3NVxJLZDn3qnBQ@mail.gmail.com>
Message-ID: <CAHk-=wi5OoS9v3h7YOPf2rMFWGfHQUgNrFRJ3NVxJLZDn3qnBQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix build on on non-x86 architectures
To: Mark Brown <broonie@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Oct 2024 at 15:16, Mark Brown <broonie@kernel.org> wrote:
>
> Fix this by making the addition of this x86 specific command line flag
> conditional on building for x86.

Applied directly, just to have this silly thing done with.

Thanks,

                Linus

