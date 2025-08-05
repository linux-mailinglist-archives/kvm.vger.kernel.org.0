Return-Path: <kvm+bounces-54008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA84AB1B54C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1644B18A52A2
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630D6274B50;
	Tue,  5 Aug 2025 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dbZ8n/qr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE3823C8A0
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754401923; cv=none; b=PQUVpsHoOZVVSE6Jbh8WXyztHNsx994c9VDN7sorUbE37tTeTqWsrzMDFTjG3+UbIx2jA4BAfVSaaQfooHsNiQyGH5NUwcFQACiCCNfT0a+clIvObMqClrCqX1LJp4z9QQd8GwQJG41Yi9RP+ltA83RY38kxkq6Rjp3t/1R/mHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754401923; c=relaxed/simple;
	bh=BAZlAyuhsxBPeTusmuo9QTFmObbBL2HmaRovu4+mPcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PeXPC2Idh1x11l+TNmpXuGljCpPAIsKgwWADPPNtLfpT8ViwuQYiFgsbxQORDxO8P7a4UjD9V7XErvrQGrb9c4AyKfcEZZXf/6GiGyZeawZGaitI2Ndmbpft6RcES3tKxXCf2asPyjS3H1WhxlljwvI65yiA4tNPw70UTAudg1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dbZ8n/qr; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-af93c3bac8fso605808766b.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1754401920; x=1755006720; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hyqP3wgPlxttWz/Mpuh+X6Lo5NUqiC58jKjpmMLgf3c=;
        b=dbZ8n/qrIDsZC1rnwrfH5dvyNOVBPoeaEr9swEaEVfb2CKR8iniTtM9dRdwUodjx8G
         je6QnoQeAZdh6FkHrqZrCE+wGdl6+SRzk/HMTogtkXnh60X5AIeEyb8aIXJ4wKGaRsTj
         oTf87ue6/pAF0DLeae0XVTq3aZj0ZuoQ9zdoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754401920; x=1755006720;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hyqP3wgPlxttWz/Mpuh+X6Lo5NUqiC58jKjpmMLgf3c=;
        b=t4uOX4WX2o5dQ+ipLXtl/AbC86O35gZh7XxtUSaFAjnha6DGbIuzWZ3/oYxR0PRhU8
         NJxQoJzFe4ZbQ6TPVRUgzw+5Q8XMSac6x3rYq/tn7OCBB2Lkzrjyht0JnioQXhUs1vCY
         KFEZpteNV3bW+aVbxufOA993L7O6oB5UFUcCFhmwEwNo9JhdEifODcjG1eRKVG3lC/U7
         UQLmihXe2jH5wbDD1it/+MFVX6seXHWhwtLIWep8reJeXjCt8SNoF4VJZ2MolXaFZMig
         Ypu1MFFfJWUBWpz+27LVoj8Sjj2EW684RPNJIry/B3BE1bUYolAe8I7NQ04gh6we/FGg
         5fVA==
X-Forwarded-Encrypted: i=1; AJvYcCVMaSxWk3NNk7ZZH9a/l4XD/pl80y4od4sCDAJfGRaYJLDBc597cd9Br9YW3LdbY3CUePw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcCl0sbu475JFaArhWB5NwWzbFiTjmYNOGFFncNDMOweYXSyMe
	hgC0MWF/AGUfC6wQzT6ihhVcKTiVH/8C/sdCTw8e3DLMkY7g+3O/BDqTu3m1uuM19fSJm3vRGHZ
	4ySyYqWCuow==
X-Gm-Gg: ASbGncuPYjoH8jwwg24BDTrOIorzvNZA289TrPzdPPEopwTMISgvrDthciurqbXY8rV
	wNEJD1QTrjpqT0aBCwksdD5J1HTN8mL+i8bzzZGjh7DY/ZYjt2JpH+GBhYCdYwPAKi7COloN6HQ
	jZqcv1M6UEEIgMn34S7e/T1iV86rlOnMCaIJWRezmU7pbXtZL6/AkUZBHHycM2dJRQVTEr+5s4u
	KomGNbgVPlXOMSpejyUoTEcVZnqEMvsLhQud2nsze6j1N8rvlR5F+RbmwzaWADJh0FVh4xGCCnv
	8GOpj0eF2sP925WlI0P4Uz0RdE27JA+ZpwNSI9/MeNFM4cIY5WYxKojiqgzgN0Cgb1FfaPLtQr0
	sUmBi6k2p7XT9xotJXy9b8GD0PwFP+ZGEu0IlGIEScan9LEchZfkEsvUonh0srolt2MrdnEJg
X-Google-Smtp-Source: AGHT+IEr17/CMAo6U4Rol9iqaRH6IlXiwfrQ6us4fz39Km3qnpixP6uoKTMU+GKFKj7vk7OcnzOXeg==
X-Received: by 2002:a17:907:3d90:b0:aec:56e0:c4a9 with SMTP id a640c23a62f3a-af94017e072mr1438650466b.28.1754401919664;
        Tue, 05 Aug 2025 06:51:59 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f245c1sm8528429a12.22.2025.08.05.06.51.59
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:51:59 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61553a028dfso5673269a12.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:51:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWvpkIqiBwsyji8CymG++v/8QWQLX8MB6jr5mLoYLfS0BNhStwqyYm3VH4ev01HvbCK8Ao=@vger.kernel.org
X-Received: by 2002:a05:6402:518d:b0:615:a2d9:61f4 with SMTP id
 4fb4d7f45d1cf-615e6ef6947mr12970613a12.15.1754401918593; Tue, 05 Aug 2025
 06:51:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com> <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com> <CAHk-=wg75QKYCCCAtbro5F7rnrwq4xYuKmKeg4hUwuedcPXuGw@mail.gmail.com>
 <4c68eb5d-1e0e-47f3-a1fc-1e063dd1fd47@redhat.com>
In-Reply-To: <4c68eb5d-1e0e-47f3-a1fc-1e063dd1fd47@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Aug 2025 16:51:41 +0300
X-Gmail-Original-Message-ID: <CAHk-=whoh31th2awzO02zA3=cv4QNTFjdYr73=eSDDFfW2OdOw@mail.gmail.com>
X-Gm-Features: Ac12FXyonuJzUBEmqvEEu6_0efeGmMOSkKZb1tbtO-JL66T9C00AtXnVqesiMVQ
Message-ID: <CAHk-=whoh31th2awzO02zA3=cv4QNTFjdYr73=eSDDFfW2OdOw@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Aug 2025 at 16:47, David Hildenbrand <david@redhat.com> wrote:
>
> arch/x86/Kconfig:       select SPARSEMEM_VMEMMAP_ENABLE if X86_64
>
> But SPARSEMEM_VMEMMAP is still user-selectable.

I think you missed this confusion on x86:

        select SPARSEMEM_VMEMMAP if X86_64

IOW, that SPARSEMEM_VMEMMAP_ENABLE is entirely historical, I think,
and it's unconditional these days.

             Linus

