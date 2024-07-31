Return-Path: <kvm+bounces-22759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90564942D1F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 13:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3DB01C23175
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 11:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49631AD41A;
	Wed, 31 Jul 2024 11:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PxFCTaCq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815B11AD3FD
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722424782; cv=none; b=c/xNQAfyhkbJe9b+141by63jO61KNtSjz7hQ84qIyG93WSwXaXjLeNZ9fEYcI5oSkG4Zaa1dDbpfMBLlsuXl2imO7SS1U1Mnvtf12wD+pYFPo7GOSU2TNRrQ3MCOX43v6Ee7Sr4BKwAVEOPJn1/7va5jJE0GsWS6AdKmTND3zVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722424782; c=relaxed/simple;
	bh=oSPMeUj42FGi9WvP3sddnZLCN+2Boz0MM9HS0iA2LnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gTZVKSk8m+ekpS3x5KSGhA9Agd2zmfwCVSWZO7Vj+JB/3wioI9YOVDePAQ+i6ov7DHmxeJCGPT/Kr4+pu5FItKCX3Wv3/Sc8rl3eTm2dlE5pULhTLSaHr+BrTzDkNu1q3pPrANINFMpu6aPylmFu00qQtaxBrYVrRzZu/LtT/Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PxFCTaCq; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3684eb5be64so3034142f8f.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 04:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722424779; x=1723029579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuzFXMDtAcIapz+5vLfMazjtW7hNx/Z1JTP7GQBewnk=;
        b=PxFCTaCq4ozzvGKGUUx+2wCGS34ET0k38CkwxFEBkDgaSgI9k1uHjiS6ci+BmJtcPz
         7F1Fy0pqqQNJpmuyTJzZHfyU8BWaHKO7PKX5zmvBX95G0WnyNwt/jr65K8vTE2fzYwyH
         NWxkiVkifnLx7/CePhPV85H53+qDw5lTSFIESKFcl6IEZLOCXSBwYrV9l6MiDBey3I0A
         w77oIi5oCBfo9mcxP5T83lHKDKjOxHDvbI3CFOdhVawWm4YAGWJfSLkQme8CYkHvMc8g
         7vjTwEUagp9mG+w0Tea8gSll+ZWArNbpxdnsPHHraUpPbTpb2I4b1jHH3ATAvuq/voo5
         ia1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722424779; x=1723029579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NuzFXMDtAcIapz+5vLfMazjtW7hNx/Z1JTP7GQBewnk=;
        b=remEVXieEASXP8QSWOxr4iYZ6l8S+jh652pFru7MYh5M4826KufxFlq1aMNlFW9EOs
         UFccwXaOLaH4/1C5LdeCMOSCAe/NrlCKi3YIzWumvGgw6Aw3M5NYVk4Wmifv2C3I5k8B
         oVLOaKxxv/O6tOSkKCH1ranVdySimfhW02YypoV4JMRwF+e8Q1gwh82MJx2t/0vga8Hu
         272xx1LIsBCJwH1LBGyeM8zmw76QCheLmm5/Fqg73s3y2ZteRUnaXR01Z7CC21iMl0PP
         /RlEJ3Fu8WKnixBgm6j9wjs7Wt1PSU3KkFusBfIYqVxKUUWdivKeFSMrHzD+uQA+iFcj
         K7WQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0MqpQCrxo4notsYYvyl1WXD0C/8Bsna5raYEUUxNvijKeVXJz2x+f8j2dHoKkcDGFyl3FxW918YU+Ur4kYfDF8EvP
X-Gm-Message-State: AOJu0YzvNm/2kIUKpnsHuJ1NKJTyFkR3MT1gu2YX2T5GXlmNImAi/ZIW
	7mXcY8O9wOQQZaEn1Zr1+1Ga+sSdhJ6eO/XlHJ9A2TnN3iH14pdRU82yrnsfbcJpHlArj6RnESX
	sa4WDoARJusAACjTX2cOFDdYsx0g=
X-Google-Smtp-Source: AGHT+IHIuxV0g/09GGRshSWjho+32TIONK/aAU9RMzch4PyAO79bqOeb49VX80jME+sszo/JQnyZRmOqUWhtTDjdY8c=
X-Received: by 2002:a5d:50c4:0:b0:368:4c54:ae27 with SMTP id
 ffacd0b85a97d-36b5cf20053mr8625870f8f.36.1722424778453; Wed, 31 Jul 2024
 04:19:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730053215.33768-1-flyingpeng@tencent.com>
 <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com> <ZqlMob2o-97KsB8t@google.com>
 <CAPm50aLGRrK12ZSJzYadqO7Z7hM25NyXPdCD1sg_dTPCKKhJ-w@mail.gmail.com> <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com>
In-Reply-To: <2e66f368-4502-4604-a98f-d8afb43413eb@redhat.com>
From: Hao Peng <flyingpenghao@gmail.com>
Date: Wed, 31 Jul 2024 19:19:26 +0800
Message-ID: <CAPm50aJ2RtxM4bQE9Mq5Fz1tQy85K_eVW7cyKX3-n4o7H07YvQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 6:01=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 7/31/24 11:09, Hao Peng wrote:
> >> Yep.  And kvm_zap_obsolete_pages() is a relatively cheap nop if there =
are no
> >> pages on active_mmu_pages.  E.g. we could check kvm_memslots_have_rmap=
s(), but I
> >> don't see any point in doing so, as the existing code should be blazin=
g fast
> >> relative to the total cost of the zap.
> > Here can be optimized by judging whether active_mmu_pages is empty,
> > just like kvm_zap_obsolete_pages.
> > Regardless of L0 kvm or L1 kvm, when tdp_mmu is enabled, the
> > active_mmu_pages list will not be used.
> > When ept=3D0 , the probability that active_mmu_pages is empty is also
> > high, not every time
> > kvm_zap_obsolete_pages is called.
>
> So if anything you could check list_empty(&kvm->arch.active_mmu_pages)
> before the loop of kvm_zap_obsolete_pages(), similar to what is done in
> kvm_mmu_zap_oldest_mmu_pages().  I doubt it can have any practical
> benefit, though.
>
> Paolo
>
I did some tests, when ept=3D0,  kvm_zap_obsolete_pages was called 42
times, and only 17 times
active_mmu_page list was not empty. When tdp_mmu was enabled,
active_mmu_page list
was always empty.

