Return-Path: <kvm+bounces-30015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4F39B6294
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 13:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9FBF1F220FB
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 12:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DA71E7C07;
	Wed, 30 Oct 2024 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJ/DT42h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44E71D0E01
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730290105; cv=none; b=TQKvNa9vtZE06ptvz+UTgE54dMCpfFSt3z/Pv8BvR8QvMygAH4/qlA1EOyynt5ZBxoBnPQgRI4imVPZ05vf3ULpd44kIoaAkh/Bg/DQZJ6g9ZUBWnO79XABXW4chfT7B3qx97KdEG8vJy3T7N1vou8KHuP/waOpqiwwVeuHPf4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730290105; c=relaxed/simple;
	bh=7RBagzl6zEJqchOvXw42/+EX+CaiILvVv1uynxO011A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cGSRmJh32HMMEqSqAxppYCZnY0AVywFF5gTPx0hDvzUfjevwlW77xm95ie9QoNY52r3KcFIU2a24S5b54jJCA8nRGpBk2XkDjGwcoIeYjNey81rJr5JeziXDlrY/KlDKHBi9Kg9ZFGtFixJNqf3ZTFx48SYO6HMhHztHDDVMP20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJ/DT42h; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e3010478e6so5049086a91.1
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 05:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730290103; x=1730894903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/lzjFgjfESGuYlc9gXA+bSUCcZpVzEfbftBhWs1qkw=;
        b=UJ/DT42hmkTxNjeG4GjvsxfbGlODNNvs3zF4GMBqbDQ2c+hc7/Fz0Xqo3OEeyXsnwC
         Q9Y0xGCuu8C9Gw35B4lyPIhjXjTbdbSizjcJu4du5H4xBIdKtLvWNa3HJMT7QflXNQ1F
         9BHUVda1QSe1LjkJHcEdle/jlRgEw1G+X2KjBNk0UGW7ruU3BudMmHwB8LwVVHA4PaHe
         EhXjCj3OrErCR0LgVIcYNYqLDC/jWExn2HUIIlqzmbxCkpi0WmSjFXNBHyGcm+tDiC2X
         vJRFgH6HgbTqMUFw0juglJ90Hreb3pkDrapNQtqw3Kp1+0zTDNMo2+qogNtLzD5K+PPD
         /BoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730290103; x=1730894903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/lzjFgjfESGuYlc9gXA+bSUCcZpVzEfbftBhWs1qkw=;
        b=iA6wH+YeB1lhZ/P2n4hjZNmcJgbSLnP95DPxzrkIt6DjZSPacbZQGerW3S5gGKzTvu
         tsVpNnlyILK9VHppNep7W3qTY+sA4HRVoRiKYpJ2fyRJpzoWITGYNDKz1cKIFoxSroOd
         WldN2quXEDUSyQrpjm+fGJG+do9aKxTMnjj0zFF+H7EDJfbQcdqWRd+XYdTv9bF8cuvs
         2ga6D/hZ2eT+dLo3svSkwxJjGFxvaqfizLSjHIMsO2tHRUDxX8G//vg/d+lOtVwMXC9X
         0Qjg6gIL5mhQolUqNGz+ydyull4Cdb1ZXgfrnFtUqJmw+FQ98jhTDLFUyZt5wHneBNae
         RvVg==
X-Forwarded-Encrypted: i=1; AJvYcCU33fQNm1wJXrg6Rmd2dlF23PsS+y8SFTv6484bvHI3mBKa74BzCzlmnpsFJA6cs+8q+Bk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVJQ406KzNGOh9Im5vksTSWCYyA0BpdEenEMZngRxbW98FPEac
	pTeqrfsT4o7qaFPRb4wYHmNGihxjl4rt878BWxaAW9sWoyB6OpROhUoogltGmv1/sImKlczMRfk
	O+O1oslFBbOPPBtEZMx2IJd5geP0=
X-Google-Smtp-Source: AGHT+IHuuQFjVhsOyU0HSbjnT3zjynT1gDoYPEjwk3+eA+T7ZltXxQ419VSEREz71mnMBiMoX+JbpG/Yjcpkeor3owc=
X-Received: by 2002:a17:90a:a110:b0:2e2:ebbb:760c with SMTP id
 98e67ed59e1d1-2e8f105f412mr17749859a91.11.1730290103106; Wed, 30 Oct 2024
 05:08:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029031400.622854-1-alexyonghe@tencent.com>
 <20241029031400.622854-2-alexyonghe@tencent.com> <ZyDz4S0dYsRcBrTn@google.com>
In-Reply-To: <ZyDz4S0dYsRcBrTn@google.com>
From: zhuangel570 <zhuangel570@gmail.com>
Date: Wed, 30 Oct 2024 20:08:11 +0800
Message-ID: <CANZk6aS_LcKY6XcCQHo1r6Rz4QC_TB_DxNXMdLQ6tyeJ9tM4nw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: expand the LRU cache of previous CR3s
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com, junaids@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 3:44=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM: x86/mmu:
>
> On Tue, Oct 29, 2024, Yong He wrote:
> > From: Yong He <alexyonghe@tencent.com>
> >
> > Expand max number of LRU cache of previous CR3s, so that
> > we could cache more entry when needed, such as KPTI is
>
> No "we".  Documentation/process/maintainer-kvm-x86.rst
>
> And I would argue this changelog is misleading.  I was expecting that the=
 patch
> would actually change the number of roots that KVM caches, whereas this s=
imply
> increases the capacity.  The changelog should also mention that the whole=
 reason
> for doing so is to allow for a module param.
>
> Something like:
>
>   KVM: x86/mmu: Expand max capacity of per-MMU CR3/PGD caches
>
>   Expand the maximum capacity of the "previous roots" cache in kvm_mmu so
>   that a future patch can make the number of roots configurable via modul=
e
>   param, without needing to dynamically allocate the array.
>
> That said, I hope we can avoid this entirely.  More in the next patch.

Thanks for pointing out the problem, will fix in next version.

