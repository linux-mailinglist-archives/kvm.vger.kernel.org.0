Return-Path: <kvm+bounces-48103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06AE1AC9224
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 17:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F044A7B69BB
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 15:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708BC22F76D;
	Fri, 30 May 2025 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJNlLtDS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201E22F169
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748617922; cv=none; b=b0Ta3JXWBZpItwgaU8NXtgEgWHZgVKeLHeeswIxEV1rF1Mypm3XU65Rf3QUsS5BCTn/UzqdLdKc2KQjUL51VX+5gPm9iXnd/9I5kENPLVo9xYRaYVhwVX2lNU/5qlqon3aar2SzqGEmhL2HoRIYLIHqLP52FG9yOk5AhUuvGYuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748617922; c=relaxed/simple;
	bh=yfqZ4uwCBedZ314UKTh8R56ds3rRmx+4qFuELqIHy8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BpQbuwRvmP0J/QV6zBNoco8m1llVR/TufqGIdKAfK+lq2xJJkDIjdiV3r81QVmoW0JDviat5Y7LuC3VJsjZhARNSAtZAyranwKrWEPjNim0n8TdZCIoRHXG5gjUZqb8670WeEY9Ejb1BVYKqpnN6DGPgo3nirQMf1nGsD0O/Yd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fJNlLtDS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748617920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yfqZ4uwCBedZ314UKTh8R56ds3rRmx+4qFuELqIHy8I=;
	b=fJNlLtDSD+iA2Mci16XyJ6uj6TZG8JASMymVRBYivcyQwfPreDLILE2kdyNMMvw452RxKw
	ZG/5tGvxiOV1xOXcSre1MupOZhVmSyt+pDeSUiFlrKO7gb30oa1AGWhiMi8h+4iuhiiwfa
	PTMomS5jaS5fkURogz9MD6ev31gjeog=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-y-wdMsldMdSZ2e0QjxsClQ-1; Fri, 30 May 2025 11:11:56 -0400
X-MC-Unique: y-wdMsldMdSZ2e0QjxsClQ-1
X-Mimecast-MFC-AGG-ID: y-wdMsldMdSZ2e0QjxsClQ_1748617915
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4eb9c80deso1204900f8f.0
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 08:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748617915; x=1749222715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yfqZ4uwCBedZ314UKTh8R56ds3rRmx+4qFuELqIHy8I=;
        b=ftQOWAUh9T6sWZg1PnY3Nr8UXdgQvoVYTlXMf2PTnCcCp3GxCY0dwQn5o4k5lvr4NC
         ehVAwCetOlLhVMMGw7iHi+tC+0aGbY4+xmTJub+LRRo+q8yOIVzY+7Tb8bPuKBtSjIjg
         lYhyp4GoqDOOLzzDNybu8x/bT8fkeug+/740JIdpCV+NmiMYTCC23XaRdz/cTBvvc9x9
         ltAq2oPqG7NoYGhvuMgaeZtdUWTuW/x6+uBXv8a5OM/kYAwFoNMDRyiW27k36oP33w7c
         IEZK51LxocBbTnjQ2hngsk0x0BBUOXCCg2z0tk+KdmWLOT/vUhrZyNfxk3/egXroBc/7
         uq4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVVlT9UxChqw/UBkZMrFLuxrwUcS+MmR/CQx91iHeAAzS+SZuQ4MXAZkyJI/Mxls7Fue6w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyld07ZxziTkH5EpCq5FDIPwALbSw9ZL3BaW4Me+QUeb7+AOjmY
	Hl+q7Qeu4gUWLzxpxLD613lCMFDx8i+o34vEHCY97zg0rHUJ7Bc9nZqC1SzTITP92EcGHrmbWgY
	S70fFhfX3uMFegiKy1ueI3LIWSrs+1R62OLMVA1KZ68drNrBIMlwuiNSFhfh+WqR1QTQZ49Pn2D
	jSQM3bJ9dwv6pYV7N+2hbBGdl+LuSR
X-Gm-Gg: ASbGncsm2qCrtXv8FAxLzWgSsHTxWIS6Cx/VYux+/d5Sy9p2ifFHujhoSC2NktlZGE5
	QL26U4MCrTQDu+HAlpbLGkn5tqeNvcRRf02DNis+oVUnTbZLXJ+/J/xRiUuwBa/NdD7A=
X-Received: by 2002:a05:6000:2907:b0:3a4:f6b7:8b07 with SMTP id ffacd0b85a97d-3a4f89dd0e0mr2510019f8f.48.1748617915359;
        Fri, 30 May 2025 08:11:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0zplckeg0pZyVVtsF4Rx+t90b7lYELscoecfMN3axFdzklZzbvdq5/jQJWSDnQewmwTsExNb1LUaSwI9dMiY=
X-Received: by 2002:a05:6000:2907:b0:3a4:f6b7:8b07 with SMTP id
 ffacd0b85a97d-3a4f89dd0e0mr2509983f8f.48.1748617915000; Fri, 30 May 2025
 08:11:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530095223.1153860-1-maz@kernel.org>
In-Reply-To: <20250530095223.1153860-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 30 May 2025 17:11:42 +0200
X-Gm-Features: AX0GCFs45z1db-bj9Xqr5W0smLTP6OZ81Z8ky2sMoDqJ9qQmYN3iiueiMy14ig8
Message-ID: <CABgObfb+MeNYmRpubfqf=KHWxNcK4bR7bHSsaKERF28ATYj6yQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, D Scott Phillips <scott@os.amperecomputing.com>, 
	Jing Zhang <jingzhangos@google.com>, Mark Brown <broonie@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 11:52=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the first batch of fixes for KVM/arm64. Nothing very exciting,
> except for yet another annoying race condition in the vgic init code
> spotted by everybody's favourite backtrace generator (syzkaller).

That was fast. :) Pulled, thanks.

Paolo


