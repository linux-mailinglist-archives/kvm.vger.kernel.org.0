Return-Path: <kvm+bounces-31551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B019C4DB1
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 05:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D47DE1F22482
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 04:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D735208224;
	Tue, 12 Nov 2024 04:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfQok9uP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED24916CD29;
	Tue, 12 Nov 2024 04:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731385069; cv=none; b=ogdMOZ6yyoWESG/5mIJE+rULMAv/jNfh/g+BZnB4LTEsF5KEwlDi6GNfe5vxzurplE/xNs2px3cqMU+YPo9Yh4r6EJ5InmS4vmMS/zzQiziaEnFshmy0h0mX//qMcHp8Hr2+Cy4gQa+5KKocJp70U5TrVqfXBCEzGT8AjqtN0UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731385069; c=relaxed/simple;
	bh=k7LOEk6gN7fAxmNF5JGDqcFsEqmqT0pIXJXZw8FwpQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a07ej2e0wY+9pjl80pENk0h86b1ZAtNx/hfvkzss4QZnvTCVVMLQB0kPEYBIsVUP8VLrnkAT41Lr2D/NAzF4Y2KCGWhWUOau1HW3cLmz8+fbfNrnb9vNfPxgfdvUqME09n70KOknnhzUb+DOUpVoAzr2z84+2TwF5zcdsigYnXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfQok9uP; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb443746b8so38425021fa.0;
        Mon, 11 Nov 2024 20:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731385066; x=1731989866; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U+FWR8JB3iGygzW+0LDvSj1bu2cDbdfDQXwliSvtrpE=;
        b=dfQok9uPktXJ9SFik1ZqnJLgNUObwMcsJiV5KKHPXmVTekXfdHqHv8O1TIGjlfhcTh
         H6aPojIjh/xv4mNWS8lRjyvBJEiG60zDCZfEA7qvpV8Vy4XOvuTEI6XHtH3ZgEfg2zN8
         KXY5RBHcL5Ie+aow14cFno/P+f22J1VL1Idh8+J1syk9YvEfFTfm2163BSxrOOIgZGV+
         ypGQ9yaA/Ii9dzg163IrT1S3KD1pLh70PEFB9Gl8f+fmCq9Kpwilo++Sa/LYAKViokg5
         7m9qf3asrsAADmYC84BcmEmJgqFapQ614ALZcKIhmQeGmKMFBtop31Vg1og2Jb0eoS5X
         C8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731385066; x=1731989866;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+FWR8JB3iGygzW+0LDvSj1bu2cDbdfDQXwliSvtrpE=;
        b=AlaPXKzH33sqe6YJLj7aFYw602xWwwk6uFVahD5k2QyLyLR9r4xE8eab2Ox19ezMcW
         irKQCjIpWTEEAc4sB5n7nXzWxHvFK6VhBHiXjp1c/giH8+XvhfR0ZXvbV/gKQq0RFrHm
         bKB5vOfD0NKC7E209H7ymESyhKfwdWogzMR9VWZGBN471JobxkudTa2M5xgWUQp+XzNC
         ON8pbfpTvR5Vd8cxDdn8gp+kSLzgYFX436GjDrz/ips2iemKNPM1moO5HVeEL8KespZB
         cwIJ+X39z5wLzYyq0JrAClw3cKGHOTsY5cvAKD25uLkLACBUEEvvbE58RoQKp9JSr2+o
         a8Eg==
X-Forwarded-Encrypted: i=1; AJvYcCV1Ef+iaZMmEomGN6LQD45QJjIEbTlANRO5B+6kdRjaHbokvn7Tn1S9ba/e/HD+y3pszDs=@vger.kernel.org, AJvYcCXtaz4eUe4DPBtKgOh92fCt6CAeTVlWrw7kJ2yYnki1/ttAbWvU4tnTZW+2hFRsZsmkrJzjIG4EoyEmhNDQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzmNxYUhW3N9M8aaqlYYCg0L4/3ePKzHLwG8o3xRgkD7fd9I/b5
	IVOTeBrzLgbF0J+D5EHjBFt6YzeTxR+xkBmc22RIb6wJ8XfWW+DIq3TKM4UeOi2csFu7ydArM29
	xuCS/kSeg72UdiBTIxjglxgR7TwE=
X-Google-Smtp-Source: AGHT+IHT0dx6NKcn5LUY8JdYpFouaPR00H/LE7FPbnyQclXlUaA2k4a06gnhIhUhftncjxxNq4suP/vS3gIcpBXszdY=
X-Received: by 2002:a2e:b8d5:0:b0:2f9:cc40:6afe with SMTP id
 38308e7fff4ca-2ff2021ed1dmr59250361fa.14.1731385065753; Mon, 11 Nov 2024
 20:17:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111183935.8550-1-advaitdhamorikar@gmail.com> <ZzJTPx1ca4JF8FU-@google.com>
In-Reply-To: <ZzJTPx1ca4JF8FU-@google.com>
From: Advait Dhamorikar <advaitdhamorikar@gmail.com>
Date: Tue, 12 Nov 2024 09:47:34 +0530
Message-ID: <CAJ7bepLzHYypiNiqyfbSba4hRBMf0OFekVa--9Nm0nuW4D=jDg@mail.gmail.com>
Subject: Re: [PATCH-next] KVM: x86/tdp_mmu: Fix redundant u16 compared to 0
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	anupnewsmail@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hello Sean,

> NAK, the comparison is necessary as kvm_tdp_mmu_zap_leafs() deliberately invokes
> for_each_valid_tdp_mmu_root_yi
> eld_safe() => __for_each_tdp_mmu_root_yield_safe()
>with -1 to iterate over all address spaces.

> And I don't want to drop the check for __for_each_tdp_mmu_root(), even though
> there aren't any _current_ users that pass -1, as I want to keep the iterators
> symmetrical.

Understood, thanks for the feedback.

Best regards,
Advait

On Tue, 12 Nov 2024 at 00:26, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 12, 2024, Advait Dhamorikar wrote:
> > An unsigned value can never be negative,
> > so this test will always evaluate the same way.
> > `_as_id` a u16 is compared to 0.
>
> Please wrap changelogs at ~75 characters.
>
> > Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4508d868f1cd..b4e7b6a264d6 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -153,7 +153,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> >       for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);                \
> >            ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;              \
> >            _root = tdp_mmu_next_root(_kvm, _root, _only_valid))               \
> > -             if (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {       \
> > +             if (kvm_mmu_page_as_id(_root) != _as_id) {      \
>
> NAK, the comparison is necessary as kvm_tdp_mmu_zap_leafs() deliberately invokes
> for_each_valid_tdp_mmu_root_yield_safe() => __for_each_tdp_mmu_root_yield_safe()
> with -1 to iterate over all address spaces.
>
> And I don't want to drop the check for __for_each_tdp_mmu_root(), even though
> there aren't any _current_ users that pass -1, as I want to keep the iterators
> symmetrical.

