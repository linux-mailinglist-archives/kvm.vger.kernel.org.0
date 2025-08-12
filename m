Return-Path: <kvm+bounces-54516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4F9B2261D
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 13:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5170A3BC647
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 11:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A072EE603;
	Tue, 12 Aug 2025 11:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BT1ARL2a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B16285CBD;
	Tue, 12 Aug 2025 11:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754999463; cv=none; b=Ou9RhdZ11cFMDEyTDMtQ53jePTAsSzwi/OdB+8aOrPMGPVnOUpLqHi40YUQQcEdV12qogTf+51EpH7muD31U0LvgJDSMGiz2lDdbGNML2Tt09VMG1ttSJ1IsBRHYz98Ks3uzzFfx5VkF4eJgV8B0wWa/QHBjJRX7caQIldq0+gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754999463; c=relaxed/simple;
	bh=cgJjO9KjOUbbD9d/ihTRaRAGDDFyZhclbxPfao5g+rU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tsQb1OjBu/LvhKVmoKj4htJugIVlNSsucRzMrK+zWcJvCvyOe4pGlfVoxwMm3l3OuqEibFUOj6Ja1RHkz9ZYAJTU1agnTQETY1PHOXS6X2Rsc96NcCMsaQllWcgvgf9dUn8zIi2BS8Oe9t0rr1LImR3mG/QIO70IK4drYKUj19Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BT1ARL2a; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-30c08969614so3607698fac.2;
        Tue, 12 Aug 2025 04:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754999461; x=1755604261; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cgJjO9KjOUbbD9d/ihTRaRAGDDFyZhclbxPfao5g+rU=;
        b=BT1ARL2aV4V4I16CVrk2b7RSIViWSNOGj/2bBqMw4X3EI78AedPfRCvbjNaOvT94xS
         Z6rP99sLZpPDms+pYiax6wautt7YfmG6cKDX3zEZSNvgjX7VaaMaMIqdk8FNisInhndo
         udix5bBwurp6dU4ARYZpcTGLNhVe+D8cgTslhi68FWq2TMygzJHTr2I7lRFAlcVtw0Yw
         enSNdsrucZ9TMc1YLi5NGTIAJ3hRnpaXC1+wcEKPhcAmk2b3MRZndIPbLNtJXEtz4WpF
         o7kUyiSQYiVIi9ij/LiYPxJUTkUch3YLAIIXvXoQdq97upV1IJHVSl5TH2QNPe2lAnA7
         Jacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754999461; x=1755604261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cgJjO9KjOUbbD9d/ihTRaRAGDDFyZhclbxPfao5g+rU=;
        b=LOWuwDb2n82+bCYjOrzkXH8MJLV61aaBNqn4OOUdILjdeHCh4VEn6HxM4yPjHBl71E
         6KnVCtZm672TXzNps327+Dmp85nusfdljeX4qYIFgn4/AZmxk+hj3hd3MV0auqmIQHX/
         U9jMMtw7QTgtrDsDVvy0ddJaXU3J5imqBhDxBUUQAJ9nHMLy1WQZ3EwVPiJ/1D32kxGe
         Rrm4W46o0zMq6OzC67d6ZClmxhSuP81DQMEmbFR5kJBzMvpd2ytcchmgN+/c3BXXNvQI
         RA/+rlmT9URtw1ApPS5qOO2zf4VC1oSCjkXQ//FYpyWajBzVpJc5VKmkO2Ey6LzQOyfr
         RAXw==
X-Forwarded-Encrypted: i=1; AJvYcCUjM3/IzRo7wLgZf/+yn0g7pOWSV6uzqt5Ah4Euh/PpoKmz+C6fQwGBg49npIuonIHoTUc=@vger.kernel.org, AJvYcCVCMgd83Dak1NL/8aW1Iv3+wwE+/R7QwPh7Sgae5VLz9VREcY8HYX0uJQxmtEP97EJNAB7eKRIv4qC2wXdD@vger.kernel.org
X-Gm-Message-State: AOJu0YwUnRDBrp+y7u8sHI21PUiEDfA1J53LkT3mVpdFuWOT/w8qY1hu
	cvypY/NCUwEngSA1bBklXOyiHa6XPLoiia+NmeA9+Entgn8tWJ4tzJ6TnBQvsOagzWrrvdfC7qe
	qAY2Cn0EG2Cf4LaXorDlXgRHpGJQvBgM=
X-Gm-Gg: ASbGncs5lTT7Sh1DxUaKJ8RDTJTfEkKWR2Ukp9OeP8qroFUW39JNjhewlyKJNxMPIaA
	mj124YgRLRlR51ubNrsxU22r9AFe+1qkKkhpYwGcZsHnBm6lIBTGrY/n0tsl/p7r6E+7YEoBYl7
	YfypDbTtxaeAm1S5dDcPylmPbU6iSKg/KyxqINuLjAzGBGZL89zbCJwmHhCvY2rgawwxUaJK1oY
	yo2oAZFGgDPSFZ2aw==
X-Google-Smtp-Source: AGHT+IFKpLjZ2xmBMbQXbAcKpHVdtGMZpoFV8+CnPQJP49Wk6dIZNmbXQb4hTyqrKV6rrzygrsoIhUkE0C02UDDWiNU=
X-Received: by 2002:a05:6871:890e:b0:2f4:da72:5689 with SMTP id
 586e51a60fabf-30c94ef06a5mr1969612fac.15.1754999461349; Tue, 12 Aug 2025
 04:51:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
 <aJTytueCqmZXtbUk@google.com> <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
 <aJobIRQ7Z4Ou1hz0@google.com> <CAAdeq_KK_eChRpPUOrw3XaKXJj+abg63rYfNc4A+dTdKKN1M6A@mail.gmail.com>
 <d3e44057beb8db40d90e838265df7f4a2752361a.camel@infradead.org>
In-Reply-To: <d3e44057beb8db40d90e838265df7f4a2752361a.camel@infradead.org>
From: hugo lee <cs.hugolee@gmail.com>
Date: Tue, 12 Aug 2025 19:50:50 +0800
X-Gm-Features: Ac12FXwNnAR41nJtZbKYqyIm9AMj8gpqXr6jgjoMSlTY7DgUuaBYNda11Atbf94
Message-ID: <CAAdeq_LmqKymD8J9tgEG5AXCXsJTQ1Z1XQan5nD-1qqUXv976w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 12, David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Tue, 2025-08-12 at 18:08 +0800, hugo lee wrote:
> >
> > On some legacy bios images using guests, they may disable PIT
> > after booting.
>
> Do you mean they may *not* disable the PIT after booting? Linux had
> that problem for a long time, until I fixed it with
> https://git.kernel.org/torvalds/c/70e6b7d9ae3
>

True, they disabled LINT0 and left PIT unaware.

> > When irqchip=split is on, qemu will keep kicking the guest and try to
> > get the Big QEMU Lock.
>
> If it's the PIT, surely QEMU will keep stealing time pointlessly unless
> we actually disable the PIT itself? Not just the IRQ delivery? Or do
> you use this to realise that the IRQ output from the PIT isn't going
> anywhere and thus disable the event in QEMU completely?
>

I'm using this to disable the PIT event in QEMU.

I'm aiming to solve the desynchronization caused by
irqchip=split, so the VM will behave more like the
physical one.
And this synchronization could eliminate the most
performance loss here.
The meaningless PIT which causes the pointless time
cost is guests' problem, and I don't
think we should disable it without clear instructions.

