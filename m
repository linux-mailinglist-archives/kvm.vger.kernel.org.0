Return-Path: <kvm+bounces-56743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35900B4325D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C30CA568338
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77820264F9C;
	Thu,  4 Sep 2025 06:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTDyjq3J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B4125A328;
	Thu,  4 Sep 2025 06:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756967139; cv=none; b=U9xuQHmcoBjA87TWk3LK9RWEUEBQAOfj2MnmjmRvQjqLXJnv8+TotCS0hPe06ANVkinQXbbczeJ4SwNqJO/EwdD426wn6pjn13PXGA7ARcnP26XOO12RESNkiIIgIR6HMXf9idgmC8zH84drTfJdEalwJNKQqW89Se/2ImJqNp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756967139; c=relaxed/simple;
	bh=OiyQg+RIct2VcV7DDl+1YPRlSTFJG6extkQc30EN9eE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ilo3dNl1Itk15T1da0DbiqlSJh6VLQMstnj2UvGhHdZeJXXSP5bTlZJ+kjIUaRNNoV8s/N9qMvwNxhT5Gj906Qi88k3Poz0QniufFi50lP71dKHSKn5o6lXwPyKLVMDHISKuYSCJGA7r9rvtpprdTZvdMLyXWaJxjRE6q6lec4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTDyjq3J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DE3C4CEF1;
	Thu,  4 Sep 2025 06:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756967139;
	bh=OiyQg+RIct2VcV7DDl+1YPRlSTFJG6extkQc30EN9eE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tTDyjq3JdIVLxtQmDTLKhtZFQhY5ZpPAWyuaGNg4HsT3tkkTzggq+ooI4yyb2N4ER
	 VWz+BoBXpPZOKOi27m0Qr4bAnA4b6RdGnUjf9iJqCXSdxx21+1OCRX4gByuvpjnUwb
	 FIgjt+NcvPHeU/lMRLispT2DkaiMQyU0JN1T9x7G5UZ9Kr51Os9P5k3HjDpXYK73JC
	 oIC3BwVJSuunFD9uX0QJ7srIh/um13Zd2HHw0YWmLUVAbzJYoPMOLgjmYkZjCFJumW
	 GMxDQvnpZopxpyM0QH7D419sBYA097IwWmKkMBFdx+73hrqS4EUg6k+Q/8Q+MYjfro
	 QJt8Mx2xChuMA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b046f6fb2a9so99244666b.2;
        Wed, 03 Sep 2025 23:25:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW4TusYm9uaj3IsNJ0zxoORTNjnbWxTVey/gRM3Q35tz80laGU9IbjKr+FiKjGE9i64FEA=@vger.kernel.org, AJvYcCXgm9WWUupGFugim/nKCNl6r49wSfv7R6hogOzXQ85yNQy3VpH63+iZyp+kTWsPA7kXQl6HQ7rhrEbArZjO@vger.kernel.org
X-Gm-Message-State: AOJu0YyER+BEotv17E/1lv/NERYsPpq2/FVVo64yTgt34Ls5YOiCd84g
	TxAlQaIZTLpHpkdTnBirFady0CGs7JGeBJw2BfomL22PhH2Ph9ksvIf4WvitZhw/htydKJ2jwmV
	+HnzHNa9iSmEF+h8ZkrxHI8351pqA8Xo=
X-Google-Smtp-Source: AGHT+IEuSgUEojFL2lGX5tP7lxrB3EtHth4NYh/l+8QCJ5MmWsFTsME71131TAohVLCemezrMPb56TXZN5B5xjH98S8=
X-Received: by 2002:a17:907:6e8f:b0:b04:67f3:890f with SMTP id
 a640c23a62f3a-b0467f38cfdmr562352066b.33.1756967137680; Wed, 03 Sep 2025
 23:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904042622.1291085-1-cuitao@kylinos.cn> <c70e595e-c1ab-2c8a-3f46-3862ecd6e0b8@loongson.cn>
In-Reply-To: <c70e595e-c1ab-2c8a-3f46-3862ecd6e0b8@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 4 Sep 2025 14:25:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7j=7RSsyNFkfT_t0GuhzNL1kX1XaWhk3uU=VqYWtRiow@mail.gmail.com>
X-Gm-Features: Ac12FXyz1ygNs0gFRYev90sVCFlGP3Iehi__0o2aVnlYycpoWG1QGUYC90zfJwg
Message-ID: <CAAhV-H7j=7RSsyNFkfT_t0GuhzNL1kX1XaWhk3uU=VqYWtRiow@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: remove unused returns.
To: Bibo Mao <maobibo@loongson.cn>
Cc: cuitao <cuitao@kylinos.cn>, zhaotianrui@loongson.cn, loongarch@lists.linux.dev, 
	kernel@xen0n.name, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 2:17=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2025/9/4 =E4=B8=8B=E5=8D=8812:26, cuitao wrote:
> > The default branch has already handled all undefined cases,
> > so the final return statement is redundant.
> >
> > Signed-off-by: cuitao <cuitao@kylinos.cn>
> > ---
> >   arch/loongarch/kvm/exit.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> > index 2ce41f93b2a4..e501867740b1 100644
> > --- a/arch/loongarch/kvm/exit.c
> > +++ b/arch/loongarch/kvm/exit.c
> > @@ -778,9 +778,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
> >               return 0;
> >       default:
> >               return KVM_HCALL_INVALID_CODE;
> > -     };
> > -
> > -     return KVM_HCALL_INVALID_CODE;
> > +     }
> >   };
> >
> >   /*
> >
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Applied, thanks.

Huacai

>
>

