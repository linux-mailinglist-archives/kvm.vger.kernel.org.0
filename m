Return-Path: <kvm+bounces-63523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id ADCFBC68411
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8C82D4E2280
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBAB2FE05B;
	Tue, 18 Nov 2025 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVixpDJP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6FCCcR3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF1C27703C
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763455485; cv=none; b=SfPk5On1/isvd9m0mXwzMgCzqfdWADQwi006wT1fq7Dc6337CJNBZyJ/WIil6mi/XxFoHRK1kicuSvP89JHuNOEWWL6yggbrnvi+V7qk8JC8E3MtJWsU9ckjZeQjipaL0RTsvQEgjcExoLqUPlAI7YezKNrulwd/MnduU4WFtsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763455485; c=relaxed/simple;
	bh=PHcZng0c0G2FAYCnOl4iuXKJAxMbukN84QarjiRy2PM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BxVVhTOPe09QTkiGmDU8WHMcSpZEHUYfq8dOUEK45NUrG+KncFiDcVMkoX+SrT3up3I+TpCCfxJTqzchaEqlfLEJfkd+jQxNBKmM81/ypHcAVLdjl/P+goM4NHGLno1NxGJ++QJ5yGSE5vAEZaKvnKswOsx2wYMZAkq5YTCl5Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bVixpDJP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6FCCcR3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763455482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MvBzZyeqDE0awYgcTrOUR4nEuRK4TuBA73+hSBjBlcU=;
	b=bVixpDJPDtPXFCUrXFU56glEAjFZSMX3b5sT+2nVNj+cEb/szEhf/nlwDSVrUcO7jG/Phg
	kM5NCNUPQ4cYt1hwfhHDL6Rcz4Q6cXAg2OvalqOvR7Lvg9lyo54q8ysVpfn7nI+lLO609X
	g6j6W7y3wmyiFFBk9FAhoQdyDv0SVHE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-3vGM2CMKPq2X53QsV9j-ig-1; Tue, 18 Nov 2025 03:44:41 -0500
X-MC-Unique: 3vGM2CMKPq2X53QsV9j-ig-1
X-Mimecast-MFC-AGG-ID: 3vGM2CMKPq2X53QsV9j-ig_1763455480
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b2b642287so2964751f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 00:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763455480; x=1764060280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvBzZyeqDE0awYgcTrOUR4nEuRK4TuBA73+hSBjBlcU=;
        b=Q6FCCcR3uvIU8JULUcOyGzbmcD20mPUElCBtgvJdpg8BLv5vHwK/KcTCbpdYU6lvgK
         Wdr84dy3XqBiaxWn+DEYtmVt2/BThGiGplGnqr6OEfSjhKvgaTl1fIOtm+3IpfDKuYQb
         faTMWyukuuCsmX+LM7FNU9iedLjlCXeyiQfrVeze35Gj54sd3uRSZBCnnreN6EaowttL
         LZfhmRyonRJUbKpGTD/6lB5YZHu4Trw6WPnroUFyzTaH/ahW6g/Dy7x4tW9M8Vj35jwE
         b/Adyq0IpDBoS7Y3V+a4uM2b4NHVXMwiVS4dFiXGX3OjM8Dr200dj8Ey6D9pfKSCPtVD
         8rRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763455480; x=1764060280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MvBzZyeqDE0awYgcTrOUR4nEuRK4TuBA73+hSBjBlcU=;
        b=whv9B+9fcBlaVRdoJx8CfX1+kn0gssfzaVWUYymlV37GNzBkdUv9AOw4e6SI6DRUpS
         dhnj627wUEUZvUaOFIt3fGKC1P4FaQn1HhAe/7bLLybaIMa/6lMO3RK+pLGKS+BvZzaT
         l0sf7jfo4nX56/jR0Y51clIoW85KjtGeweBPMXZYloY8lfOHjIqwE8CCVXce5vBdrkQY
         V+xWlcfcV4sMjG5cmTuy7Kyji4xNwrmvI/DJ4KL7tua87MAa5BBfAxi7d8OwF0qqJGua
         r4gEiaaETEDGsx3lwDM9h9rf5Ip15OpLGjrFtOKjYJCjmQKgQmUgWg0E90cBGCyPR/SY
         4eIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYYQwQtjtgtu9TkJFuaF4EtH9DbHaJnvU8if8SGPtZCUKpm90l8C+5nyWpIHTupJ8PIco=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKd8S3Osi97iZZNZghzgwmrxU0x/TeTeTMCH1FtIPVjVKNq7T4
	Y7wM+4Wfk8gp2vWgas06B9XlSaFQYfp5C3epl3udc+W9kn52BP/V5Ol3f6os6iRPuu6v+DLhtDL
	AGDWEM6h2B6a/vgTz4A9X+vZn0ruPsNYTSwtWe+L4I7PgHWEhh6j4AwK+9sgu7PEuzZbbFoFBIh
	peZrphSpuIXEnNYi/V/5/laVtBtcy/
X-Gm-Gg: ASbGncvRcEmY0JIFSbF6rd9aJXsau73b3mJvRF3Y8C9qF2VK9btwQYTEEsN3XqflI4d
	fVsvwEZx23Y/YchPjtri9HJdvvXNg5xK+6t1+maoEQcU0/m4hQm5AFh3Q0pdwNBPRwOnKtQ5aE2
	0pZ6vX5tsltLpCikgUttYyEz9dIGVkUcvJK8VMbBIqxHIwQK7ZlccsVHMSwM/vIpZwNOLOsNp5u
	Sb9Lv0SAyVFFEyTpGuFJD6c0fx7gvxWwYSYHnDoZ65lseA/PPZq1e3mGLHbExkQnOg8vkg=
X-Received: by 2002:a5d:5d03:0:b0:429:d391:642e with SMTP id ffacd0b85a97d-42b593742fdmr14123767f8f.30.1763455479771;
        Tue, 18 Nov 2025 00:44:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYBb00NPR0bwpQ1prqZMlD2GHOrxd4d6LK2fUEYGRJHPeSHEmV6Fh9YUM2WG7hzJ3/VvempdJLJBRnq/VNfeg=
X-Received: by 2002:a5d:5d03:0:b0:429:d391:642e with SMTP id
 ffacd0b85a97d-42b593742fdmr14123749f8f.30.1763455479411; Tue, 18 Nov 2025
 00:44:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118065817.835017-1-zhao1.liu@intel.com> <20251118065817.835017-5-zhao1.liu@intel.com>
In-Reply-To: <20251118065817.835017-5-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 18 Nov 2025 09:44:26 +0100
X-Gm-Features: AWmQ_bkN5pSjhIhl1KBHBuy1-lXcrkuRFvZ19o-iJjMH1c5og9fONsT5dCVU14g
Message-ID: <CABgObfZfGrx3TvT7iR=JGDvMcLzkEDndj7jb5ZVV3G3rK54Feg@mail.gmail.com>
Subject: Re: [PATCH 4/5] i386/cpu: Support APX CPUIDs
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	"Chang S . Bae" <chang.seok.bae@intel.com>, Zide Chen <zide.chen@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>, Peter Fang <peter.fang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 7:36=E2=80=AFAM Zhao Liu <zhao1.liu@intel.com> wrot=
e:
>
> APX is enumerated by CPUID.(EAX=3D0x7, ECX=3D1).EDX[21]. And this feature
> bit also indicates the existence of dedicated CPUID leaf 0x29, called
> the Intel APX Advanced Performance Extensions Leaf.
>
> This new CPUID leaf now is populated with enumerations for a select
> set of Intel APX sub-features.
>
> CPUID.(EAX=3D0x29, ECX=3D0)
>  - EAX
>    * Maximum Subleaf CPUID.(EAX=3D0x29, ECX=3D0).EAX[31:0] =3D 0
>  - EBX
>    * Reserved CPUID.(EAX=3D0x29, ECX=3D0).EBX[31:1] =3D 0
>    * APX_NCI_NDD_NF CPUID.(EAX=3D0x29, ECX=3D0).EBX[0:0] =3D 1, which
>      enumerates the presence of New Conditional Instructions (NCIs),
>      explicit New Data Destination (NDD) controls, and explicit Flags
>      Suppression (NF) controls for select sets of EVEX-encoded Intel
>      APX instructions (present in EVEX map=3D4, and EVEX map=3D2 0x0F38).
>  - ECX
>    * Reserved CPUID.(EAX=3D0x29, ECX=3D0).ECX[31:0] =3D 0
>  - EDX
>    * Reserved CPUID.(EAX=3D0x29, ECX=3D0).EDX[31:0] =3D 0
>
> Note, APX_NCI_NDD_NF is documented as always enabled for Intel
> processors since APX spec (revision v7.0). Now any Intel processor
> that enumerates support for APX_F (CPUID.(EAX=3D0x7, ECX=3D1).EDX[21])
> will also enumerate support for APX_NCI_NDD_NF.

Please just make the new leaf have constant values based on just
APX_F. We'll add the optional NCI/NDD/NF support if needed, i.e.
never. :)

Paolo


