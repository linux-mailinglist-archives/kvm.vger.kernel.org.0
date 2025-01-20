Return-Path: <kvm+bounces-35989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C58D4A16BEE
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EF7D1881BA9
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2518D1DF987;
	Mon, 20 Jan 2025 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K2PEmxiC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07FD19CD1E
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737374514; cv=none; b=D1DnNlak7QZSkYCGs13wB3MiWBKC3Bmu1bdU3aWuNJJHRhDdKmvCK213XicPrfv9xLbpteOeE3DWUHBeiwrEE5Ua8PpufJAnEJFaIZJP6m7Us3HalXlcjWLJyUM0vviNcVHV2UkKnrEUZB52OZ1z2bEQQm+hwYeGyxccQHHqt8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737374514; c=relaxed/simple;
	bh=SYKfxNFYxhC5tp+ktcnepFGyB0OkMabGlnwkvsEEmFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TuzgJY19tP5MhyYSsETFkaFieSsuos7M6dADaIuia8rqUdI1fPD9XTPJWLYey13j1Yjh062NPFHVRXg/rmk7JVsJJmUQxJSGhxAyXbfNRUyIhOrBEwQtKU5JXNrK7dE/MyWPi42yK2+ET5WTgrnxK/81g45D1oM3xJuvk21cVlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K2PEmxiC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737374511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SYKfxNFYxhC5tp+ktcnepFGyB0OkMabGlnwkvsEEmFw=;
	b=K2PEmxiCdeGns8wIPrO3DTuy2taCT5/Lrnd4jITsK53B1DyVnOG6HTFi+T6u9mGYugTSrw
	uQB8vI0/DpvkACPGldiEykdTfa2YbqPzrZ0lHo6Z/RQskpt5QTFDkQgCOtnDJBCuVebZS1
	V+ATiVbpaNsPxydgrBsi6pOnonZt4aU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-1TbK1WIYOEuJInMVr-9PQQ-1; Mon, 20 Jan 2025 07:01:50 -0500
X-MC-Unique: 1TbK1WIYOEuJInMVr-9PQQ-1
X-Mimecast-MFC-AGG-ID: 1TbK1WIYOEuJInMVr-9PQQ
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so12466958a91.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 04:01:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737374509; x=1737979309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SYKfxNFYxhC5tp+ktcnepFGyB0OkMabGlnwkvsEEmFw=;
        b=am7njgCyGUxFRns8TIeRnb+TyOIWe1KIdd3wyVZx4ExJ7eDicz+RX1STlU0Oe8a1Qa
         i3ItP/pcS2pOpX/l1XBkHthW+HXHHV0T0veyVAtJBVIVpIioMQBDrQlIhfxkGJqnUfrk
         9PCtCYrcpkGyGqrUvQumns3CFEJ1imynWbXastTXmj2XW8d2v4SboAULjMYIzyz8j5KY
         nE1aKtXZDgMDeX49/FD5X0jgmeDmfyZldzjz670DNBi0d/7SNq9v5ovK7891MToQjF4w
         /9wBZsmCbOO/Ie9x2oAQQUIgbwh8B6MdMz1z/3HOm5/FIC5yc8dFvcKChEgo7XJ/gJpO
         ENKA==
X-Forwarded-Encrypted: i=1; AJvYcCVxKTW8lpwepDk3nehp1CR8or3ZAdx5H5RZTA5/1T3dR9gqpRoWoY/hjW7EZLWDfGxYEck=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlUIhK+BtUUMqICvmA5oMMX7WgbqHFGOUOGl/kBA/q/6W9SAsp
	t6ajeb0gxVc0RKH3SgZkbQyzwvbx9damtpg8nAbkJxff/fnne6Gi24r/2siWetRLs4JbIhJwZHt
	uYZ97pezVfuznIAtddS5f6iKqu48l3N77l3NMuVQF0IMvfC8+CgdWu+lHXOri23p1JO9VNee07+
	/eyRqN42D38sntWnUC4KfW26M3
X-Gm-Gg: ASbGncs11kF5b73VR2YMQOKDxDMhugzW0lJViX974pONbsDKEA5wRsWcK7CIW0+qL06
	Gzj5wL1/e3DglooiW9lYPMW3EiDmE0AN5NNwaE8ebxSmFOh5gEIje
X-Received: by 2002:a17:90b:2cc3:b0:2ee:d193:f3d5 with SMTP id 98e67ed59e1d1-2f782c628ddmr20773377a91.7.1737374509056;
        Mon, 20 Jan 2025 04:01:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1LRLBhFZRWB2znAXBn4FAGacB6x+A2zIQjytthY1v4NzuLkQgTJ16dSmn9MOSylm4ule4XauLDBusH8m7pTM=
X-Received: by 2002:a17:90b:2cc3:b0:2ee:d193:f3d5 with SMTP id
 98e67ed59e1d1-2f782c628ddmr20773345a91.7.1737374508813; Mon, 20 Jan 2025
 04:01:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1ekLq08nByCh9E-ZZsMcm7rCpkA+FyAPwvQctEgjwFZA@mail.gmail.com>
In-Reply-To: <CAAhSdy1ekLq08nByCh9E-ZZsMcm7rCpkA+FyAPwvQctEgjwFZA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 20 Jan 2025 13:01:35 +0100
X-Gm-Features: AbW1kvbcdodU2ZG1R0TokIdouSIf64beyJoIpVpvZuIpYKLq0Y8X83srGMtTqWM
Message-ID: <CABgObfZr6txxPVKB=tDvhFbFORCbP4rHmuQJUjVJ6hi2c9kMsQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.14
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 8:06=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.14:
> 1) Svvptc, Zabha, and Ziccrse extension support
> 2) Virtualize SBI system suspend extension
> 3) Trap related exit statistics as SBI PMU firmware counters

Pulled, thanks.

Paolo


