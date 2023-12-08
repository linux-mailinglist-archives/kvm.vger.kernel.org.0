Return-Path: <kvm+bounces-3940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D2980ABB1
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C27931C209BC
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB7A47A40;
	Fri,  8 Dec 2023 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C6swujZf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76DCE9
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 10:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702059141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TkwU2denrfJVnTiAIr/mTvHxt1y7el//yhAIkwpoKI=;
	b=C6swujZfzGnO4fN8AoSREX7AwhM/8Y73R2AqSOigIj6NsOywZFuQHeUSxOWy/nbK6kBbqD
	VfceVzl9Up6qMqnECeLzpD1lKzXlSdagZzg/6q+MPocLFmL/xEei4cjdrMj+1cRypgRFD0
	IZhSgple59Dfj0GhSW82eZ9tHRjZXyQ=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-m6EYqw7VMhqFLym5PjIW7g-1; Fri, 08 Dec 2023 13:12:19 -0500
X-MC-Unique: m6EYqw7VMhqFLym5PjIW7g-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1fb3db72d92so4028225fac.0
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 10:12:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702059138; x=1702663938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TkwU2denrfJVnTiAIr/mTvHxt1y7el//yhAIkwpoKI=;
        b=Y7I9TzE4iVOZ6a+pA9HjW+v2rTKGAD23DrR8m7QSLnZWSi51SuGXe7YknzzYRVurE1
         2C90cV86jZ/RXJ1Ft5po3lSZeF7cdZUlfQoGGToIk4DMIIw889W3V0ZQe5QOb71/4DWq
         lc2ldRFdmB0ROC0/SoHTv6T+wHR/CiZmMLlqWC7+3FWz1l3i8T0uK3qlzVbZ8a0FEUT2
         VARRBf2MLIuqICg/tSJJoN+92HCpZpZjOaTk7BL3caCamQyewP8v6OcOgXFLT+6BegOT
         ls3VQG+zl8d+bwV3pLka2ZgFcgupqRAuvgXmjJgTQH2TvCUUeMOq1xuI15eyFVoMph9r
         236A==
X-Gm-Message-State: AOJu0YyPJuay77H1x5DOSPKQn4uJsw/bJcQIt7VKmwhRRaFIBHRMVkE8
	NDAPDozV0+PEurcajd4IttBGglEY9fLVXw267tcnl6qWKHfPuIuSRw9aN2W5EKTeZmir/B2BeiK
	E17KPNlwJ65oRnaXvtlEuAo2R5kLJh4pxVs0d
X-Received: by 2002:a05:6870:4728:b0:1fb:75a:de78 with SMTP id b40-20020a056870472800b001fb075ade78mr583897oaq.102.1702059138561;
        Fri, 08 Dec 2023 10:12:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1dBdgMfiuSi5uz+rVRXvKDkpoT9HYByD4Nc2YMvjQiYfF5kVpiZ92tDqJoUOJ4qc/qdT3rZOFMba0vNgZ4z4=
X-Received: by 2002:a05:6870:4728:b0:1fb:75a:de78 with SMTP id
 b40-20020a056870472800b001fb075ade78mr583887oaq.102.1702059138295; Fri, 08
 Dec 2023 10:12:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZWufQneeJiBJLnPb@thinky-boi>
In-Reply-To: <ZWufQneeJiBJLnPb@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Dec 2023 19:12:05 +0100
Message-ID: <CABgObfbCy-9VpN+tOvXtS3RcA-M67Vwm7GmoBGmaG+0wrs1Eeg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, take #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 2, 2023 at 10:19=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Here's the first set of fixes for 6.7. There hasn't been very many
> interesting issues that have come up this cycle, so it is only a single
> patch this time around.
>
> Please pull :)

Pulled, thanks.

Paolo

> --
> Thanks,
> Oliver
>
> The following changes since commit b85ea95d086471afb4ad062012a4d73cd328fa=
86:
>
>   Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.7-1
>
> for you to fetch changes up to 8e4ece6889a5b1836b6a135827ac831a5350602a:
>
>   KVM: arm64: GICv4: Do not perform a map to a mapped vLPI (2023-11-20 19=
:13:32 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.7, take #1
>
>  - Avoid mapping vLPIs that have already been mapped
>
> ----------------------------------------------------------------
> Kunkun Jiang (1):
>       KVM: arm64: GICv4: Do not perform a map to a mapped vLPI
>
>  arch/arm64/kvm/vgic/vgic-v4.c | 4 ++++
>  1 file changed, 4 insertions(+)
>


