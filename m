Return-Path: <kvm+bounces-14064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9237F89E8E1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AAAB287AAB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6219B9468;
	Wed, 10 Apr 2024 04:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQn2qGJt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36537A32;
	Wed, 10 Apr 2024 04:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723420; cv=none; b=BRspZF0Wq3AdkRGyL19ZTSUpdDoq7y1p2PMIxQom+e/Wy7XlZ+g9C6efn0II3CSq1ugU9G8UjNcP2FRcF9uHA8874vmi7mocLeVklDOeLOR1Zz7MudtlUCGAqSXnsDVlvCA30LBFy2t+ZjXPAEShUJeJJOiMBI4b2YrWP9mtli8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723420; c=relaxed/simple;
	bh=0Z7assce/3I12gYPPiGPO4kSljCAX8pzDC5GmLlI8Qw=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=eAkmxE6TrmYvL0yCZN8qOVaYO6idWJ349Sg/Bq3XosQ/8HypFHmTQ7c9obZTyyk0jD8czvjMl+Ts40fvq/xf8tUpZGobsACsL6WicRs/FNan7TnLe+PslBja4QQY8lzoMQD+MiGXKxJpMDncvSN3oXclIw9q+Zhf0WFTJCejPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQn2qGJt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e3ca4fe4cfso26654725ad.2;
        Tue, 09 Apr 2024 21:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712723418; x=1713328218; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Csxyj22wIzJdfuKfBsOG2KZ1/xHCIZLSCJ4TL2dEF78=;
        b=WQn2qGJtXnOA8puMpI4aZSLlyyyvfbnHjiY637JdjDGC+gLlOm57xrOIJsKOUDSsTy
         ntWwGhMjsEgghVVJVMzy2X0aVP9qiIsGRAHTm9SeI3Ah3gDotWfc9F3rK0/h2/awNnii
         5jBXdb8NXwzFP0z02q9Gq6EHrffBa5cai+csWDN8WL+LzF2+Jqu46vUZnQjPEGh1vbvM
         8+oKT2wS2Pe1xgZcYfXtTU6nu0ycchomGU1ccGGqNIE41sskxpsOJgs36b4qPn4U3qaO
         YpHbewmCdvo8yFKOV0rB8zyZOaeKtrbKzg8sC7t63l2v35ua5kDzFkiHCVK4Z0OHGsdd
         KTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712723418; x=1713328218;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Csxyj22wIzJdfuKfBsOG2KZ1/xHCIZLSCJ4TL2dEF78=;
        b=tO2y2YHDqslSDVhZ+1lcOWWqWkBM3amhDdqTnSviLH3QoeuTyu6MHv9gnfuocfl6WB
         G9NDfA8pXUvhxWgVpvlu0IKFUSBbOZF4IPkCt+mQAq2pehXEre0Uf/Vq/5a4fRes7nO1
         lGG0h2df3L+JTaT/TOuXL1E7RVD4bLcEyWqruvJjplaZUqFcNrO34EcDIpqWwo8t7HY8
         CgKPUdwrTDbiIqwQbEcw5lgxDA1svW2c4jE9q+PmsinRQQyEyYN9b9dpyb7aHqnrbkRZ
         EtNfZr1qvmrJCUTCg8u3xuNhHR4IxjU4GxpY7RgI7kOkIJnvFHHkRwnhP5n18h+dObyT
         lu+g==
X-Forwarded-Encrypted: i=1; AJvYcCVBSb+WoDahTCXCKXF8OxO44a6drs0BFOqkeArbTzgW+CUYxrQ2q8iMnzrRhadiMqRgPlSFqL1HKWYyrHMcSUdtiscTX55MATlzsqTcRBWU5tCwVh07Qv5IZF3b9mlfcQ==
X-Gm-Message-State: AOJu0YyaEI7dBclBUyWjwrLFkvTkxncTlUU/mwAR3/96ZZaZTpdzMTvt
	ZkYEPoq1fiF5zoSYiO76IwriKmPc/kPgGC37qyvpqRUXBxTJ1KZdrniAk1Uu
X-Google-Smtp-Source: AGHT+IGdR4rPr8TUXSWQaLrOeaK8mYg5Q5R6NaSSX/xdgpewKjFBLWqlZ6z5OnIo3xmO1MqeuZvX9A==
X-Received: by 2002:a17:902:6503:b0:1e2:d4da:6c72 with SMTP id b3-20020a170902650300b001e2d4da6c72mr1669964plk.0.1712723418347;
        Tue, 09 Apr 2024 21:30:18 -0700 (PDT)
Received: from localhost ([1.146.50.27])
        by smtp.gmail.com with ESMTPSA id l10-20020a170903244a00b001e29833ada6sm9760884pls.140.2024.04.09.21.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 21:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Apr 2024 14:29:40 +1000
Message-Id: <D0G5RMOPNMCI.3HVFHWC8KQWBC@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "David Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller"
 <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan"
 <gshan@redhat.com>, "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean
 Christopherson" <seanjc@google.com>, <kvm@vger.kernel.org>,
 <kvmarm@lists.linux.dev>, <kvm-riscv@lists.infradead.org>,
 <linux-s390@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH v2 08/14] shellcheck: Fix SC2013
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-9-npiggin@gmail.com>
 <20240408-840ece34e7b407365a18227d@orel>
In-Reply-To: <20240408-840ece34e7b407365a18227d@orel>

On Mon Apr 8, 2024 at 5:34 PM AEST, Andrew Jones wrote:
> On Sat, Apr 06, 2024 at 10:38:17PM +1000, Nicholas Piggin wrote:
> >   SC2013 (info): To read lines rather than words, pipe/redirect to a
> >   'while read' loop.
> >=20
> > Not a bug.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  scripts/arch-run.bash | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index cd75405c8..45ec8f57d 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -487,7 +487,7 @@ env_file ()
> > =20
> >  	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
> > =20
> > -	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=3D' "$K=
VM_UNIT_TESTS_ENV_OLD"); do
> > +	grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=3D' "$KVM_UNIT_TESTS_=
ENV_OLD" | while IFS=3D read -r line ; do
> >  		var=3D${line%%=3D*}
> >  		if ! grep -q "^$var=3D" $KVM_UNIT_TESTS_ENV; then
> >  			eval export "$line"
> > --=20
> > 2.43.0
> >
>
> I already gave an r-b on this one. Here it is again,
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Yeah I realised just after sending. Thank you.

Thanks,
Nick

