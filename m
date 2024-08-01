Return-Path: <kvm+bounces-22832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6467594423F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 06:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED799B223EE
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 04:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70B713D511;
	Thu,  1 Aug 2024 04:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iENrUYXl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B9F5FEED
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722486854; cv=none; b=MLMWcVLObIbynlXCUExrFsPxnmJoOVYx3/fFoyUCbQyMxzng4MPHIxerdf7BFc0/dr+yEp57LhWAfyA6HUvTk/s4t3534cr8OAW2CCCuOWRiAPhjRiD5mdmT2ScFo2en/LvzhgCIZhDgD0YgrXPDVaUT/cBRDTjB1dPtfVCfivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722486854; c=relaxed/simple;
	bh=Qg3KLbjpl0UxtYDGbUYottI8ryXXex5+WzWO5Y1EMPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RNUFUIUKU8FDtLKz/mfgi1bg4bR2TdGoqdKek4rV/6Gro5J+xFLWjIU9Av1F7zXN02lFHdDnoEBcqLI/XeedlnrjxkDpowg73eYZXR2cxnGQorY0CkhX2jHI6JTGi131YLFUrOlaEBV7545QiyfqUgjwFctenXoPQW+QS1CyZTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iENrUYXl; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3687f91af40so3577410f8f.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722486851; x=1723091651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGZpnYP4EfQ60xPmQeFDF5gCZVSkW8TEfCy2z7E1Hi8=;
        b=iENrUYXltSRg4fgHaPlr6Q/HE0ro0XR6TnCXJu+qcBI0ickBkPthoToPpYsHw8mQBI
         op6MzPuTniEfID4KpoFtD4BhdUkhTwNMCXceYaH62g/2oWGkiVGE6rieJ9l4Q6VwgqcK
         pwpGdLPGuJx9kCi2jjy5vcNYaoArNLMsY2wTXmiUHkjKpz4pvGpXoJUOwLJuoonLTbx5
         p7WQ/sCMzvKb+pe1m7a6Jhnq+0ueF2sCxXDwQZLkxr1nibBxfRRQpvggepWcvuawdOdB
         BbjzlW0LGh9zdBUaUw0o7AZDDANwF+atDq7cXgh1XimtiCU9BAHo2pSTNQQMmDcUpUoS
         rUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722486851; x=1723091651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGZpnYP4EfQ60xPmQeFDF5gCZVSkW8TEfCy2z7E1Hi8=;
        b=H6uxqCXFuDQCCYnVFhcKj00tje03FgyWvMBxEVhnH4ICek7Jr2x7ZQkDSKrEsNslNO
         F/7vLk3ZGbKnoIbfrsDnqbQVo+cgNDCmmbl4l5GFTK4umcpMJ1PgNAIDOfmlrTvRu3rC
         rKYywXn6u3WbwVk3x4MOHOvfSZ4vu9jFMnf/fdqHHWjBuk+9fUAw3mQiq1YJW9gT98ig
         H+4Z4PVS5WyAM+yhIwX6zw6s3I6chgEXt3x2/9M903hVaQZT94kfOl47voYcXbofjVtX
         Wz2g6xQx3hhL4FB7wMUCJH7KsRTxhkQiGBjE7uNjmLghVk8QQlg4VG5rs+6jIySLruKI
         Rutw==
X-Forwarded-Encrypted: i=1; AJvYcCUA3rqYW40cSLHr47Xlrzz9YxANVMfgxxIIHZnTMNLsX+1ZD4s0clGAtFfpW02x049hSekNppJecQVQY76K2GYVp38E
X-Gm-Message-State: AOJu0YwBKIfUCzLMf0Rxn8w6QrFCTrq7QOrhYXUhX8V310gs7eubSnfG
	nlzfzS+vz28FTw6A2A881BGB76Fel4ZK/SESNgVORgvkDwDhBoBlTstBW89K/XzZP7194i7eNW/
	ac5nq3lCo2qkBSa4q6ljAfp6HRVE=
X-Google-Smtp-Source: AGHT+IGhDeba37g9uG8nUhdB3rcgm5MnCnQapsDtFa8kwxJpHsWM8RDhaORDzngsUNB0aHdFahMppn1c0KQD66nV0/A=
X-Received: by 2002:adf:fd8b:0:b0:368:4e38:790c with SMTP id
 ffacd0b85a97d-36baacd1c74mr843459f8f.14.1722486850440; Wed, 31 Jul 2024
 21:34:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com> <ZqlMob2o-97KsB8t@google.com>
 <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
 <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com> <CAPm50aJ2RtxM4bQE9Mq5Fz1tQy85K_eVW7cyKX3-n4o7H07YvQ@mail.gmail.com>
 <CABgObfb2MX_ZAX3Mz=2E0PwMp2p9XK+BrHXQ-tN0=MS+1BGsHg@mail.gmail.com>
In-Reply-To: <CABgObfb2MX_ZAX3Mz=2E0PwMp2p9XK+BrHXQ-tN0=MS+1BGsHg@mail.gmail.com>
From: Hao Peng <flyingpenghao@gmail.com>
Date: Thu, 1 Aug 2024 12:33:58 +0800
Message-ID: <CAPm50aJLrGfsVvaavPGZ_u0pwfFWEDGsaOx7sgXDOycJWTzyOg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 11:00=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Wed, Jul 31, 2024 at 1:19=E2=80=AFPM Hao Peng <flyingpenghao@gmail.com=
> wrote:
> > > So if anything you could check list_empty(&kvm->arch.active_mmu_pages=
)
> > > before the loop of kvm_zap_obsolete_pages(), similar to what is done =
in
> > > kvm_mmu_zap_oldest_mmu_pages().  I doubt it can have any practical
> > > benefit, though.
> >
> > I did some tests, when ept=3D0,  kvm_zap_obsolete_pages was called 42
> > times, and only 17 times
> > active_mmu_page list was not empty. When tdp_mmu was enabled,
> > active_mmu_page list
> > was always empty.
>
> Did you also test with nested virtual machines running?
>
yes, have similar results.

> In any case, we're talking of a difference of about 100 instructions
> at most, so it's irrelevant.
>
> Paolo
>

