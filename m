Return-Path: <kvm+bounces-22740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 708669429F0
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19CBE1F230C7
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9FF41A8C15;
	Wed, 31 Jul 2024 09:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRxxkJPI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8641CF93
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722416978; cv=none; b=MJp1tGWlgyy1eRI90yOPIv0xHMm31Gkot8oyV4FUlIyPo4U0eMArLIjMWZ2Nh6vHggsBdFGIQQeSh54gWF6oQhMHDm7YZp0bsUZVv0rfXikWe8lk7FvMtm/w+t7XoXxrOdswSKGLd7CKzWEaFktI+BJtpetPgWrNF6ozJnzkolk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722416978; c=relaxed/simple;
	bh=jTjMQkHPYf5VCtzPxx0NiYPDQ/mPsKYrTuOakLDMMl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wo5xvB0BkVS98w7GRKteIHF+NmXNJlb510rpMiECHI1OA6xEPDMSzQhvGDoQbmAvB138PYeuuqtJ0ydZDyymjC7moAm0zHO7Xj+2075imjv/pXDACdEbFfEmWrsLes1igfgEIr0QROPJ/1R4ziu8D3+D/4fMLbyUYH/AJKAmXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRxxkJPI; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52f01ec08d6so8352219e87.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 02:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722416974; x=1723021774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nSOSWcjsJMRfByaAd0f8E/sqq6Gxnp/EVzKyteMWkiE=;
        b=PRxxkJPIFf0j9HLZSm7amcVLpdLf+/ekgY4tlQLqE6acNJKZJIyi3n+soz+FAkP7wX
         CyiNM6YlxYbxt5IK22JAujeBwnFF2/Kf2FNJOS0VfpXwwohhHEMrEZuACYmSxUef7Xif
         im6l+dRhe7lUbpConFqLVBacRglHvQ+s9vEaQbi9HIjMvsMxB1o3wPBXEKwzWJaVK4nS
         XP7TxqDi+YeC8WALDEvVetgNU7Y1E1pl8lHzEr1HZh8ipmOr9AUPlrMjIfWNO6zEUQ2u
         IEV0OJjo7BYpjd98iSQX5ISbRYj+wWkVwTUHFymIRTTx5q5h7L/8HhN6zyo3ePvVA5jh
         CObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722416974; x=1723021774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nSOSWcjsJMRfByaAd0f8E/sqq6Gxnp/EVzKyteMWkiE=;
        b=e6My+GyT/tlEI6cDH42M86xrRhvlDB46w/c+2mS4atF0aLyuZxJzkCQyhUpRkSL8UL
         b31t2Gh2NeshaAMF0948fjN3fyR7pxU57uQnDvW0G/UpWKwQUsAPZqj76K31ktgSv0Nb
         qwXuptdxcJb5ssoOzKtlezFrw9eiKiTlpP17gLiWwZ4M+2J/G8gwxrl9YWDajL0iC+C9
         Lo0aGjDeMXUaZO3XbD15lznFbPaK4GewOMlbzZjp3m766YM2PZljlE5ZztKDgISbuhHL
         IWVXL33pqbFrI/JVTNoFk4w/18ufNhP/JNqOEzoLtQYq8DkQ1VP3WtUIOIRujE/K9h4r
         R3Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVhiNF/RopCqxs55xGDABqM4nchM5OplAUABAbIocIx6PvJxJRa12+iMMUMbk5mRbJxDTcijYj7/gpf93+dpNPIlob7
X-Gm-Message-State: AOJu0YwawE5UgPkuWXgV/WtDaJgEYC76ICmV+OjsFusU4lAa/6rqz/1E
	cV2uCj63n0iru8DJE+l/2ey2XJGZ+3l0zxitoN+HjbWthevcsHahBk0NzCryp62fvMCuvQMhSzg
	49cO7aaT1UGeR7UNMWV3zE3ev9ZB5a8yB
X-Google-Smtp-Source: AGHT+IEBqqXX2IOyrSS+NE1k0TjfrfTptqbO9Mhdf4x5JMeIFLrixWbi5nSl8YmJu/HSUcbd4Yl9Pesifn7lPxGijII=
X-Received: by 2002:ac2:5b0f:0:b0:52f:c10d:21f0 with SMTP id
 2adb3069b0e04-5309b2d8ac3mr7928025e87.54.1722416974021; Wed, 31 Jul 2024
 02:09:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com> <ZqlMob2o-97KsB8t@google.com>
In-Reply-To: <ZqlMob2o-97KsB8t@google.com>
From: Hao Peng <flyingpenghao@gmail.com>
Date: Wed, 31 Jul 2024 17:09:22 +0800
Message-ID: <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 4:27=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> > On 7/30/24 07:32, flyingpenghao@gmail.com wrote:
> > >
> > > When tdp_mmu is enabled, invalid root calls kvm_tdp_mmu_zap_invalidat=
ed_roots
> > > to implement it, and kvm_zap_obsolete_pages is not used.
> > >
> > > Signed-off-by: Peng Hao<flyingpeng@tencent.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 901be9e420a4..e91586c2ef87 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -6447,7 +6447,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kv=
m)
> > >      */
> > >     kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
> > > -   kvm_zap_obsolete_pages(kvm);
> > > +   if (!tdp_mmu_enabled)
> > > +           kvm_zap_obsolete_pages(kvm);
> >
> > Can't you have obsolete pages from the shadow MMU that's used for neste=
d
> > (nGPA->HPA) virtualization?
>
> Yep.  And kvm_zap_obsolete_pages() is a relatively cheap nop if there are=
 no
> pages on active_mmu_pages.  E.g. we could check kvm_memslots_have_rmaps()=
, but I
> don't see any point in doing so, as the existing code should be blazing f=
ast
> relative to the total cost of the zap.
Here can be optimized by judging whether active_mmu_pages is empty,
just like kvm_zap_obsolete_pages.
Regardless of L0 kvm or L1 kvm, when tdp_mmu is enabled, the
active_mmu_pages list will not be used.
When ept=3D0 , the probability that active_mmu_pages is empty is also
high, not every time
kvm_zap_obsolete_pages is called.

Thanks.

