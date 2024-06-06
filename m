Return-Path: <kvm+bounces-18990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0248FDD17
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 05:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8C41C22240
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 03:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382281E893;
	Thu,  6 Jun 2024 03:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5HwNvyt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1426F17C68;
	Thu,  6 Jun 2024 03:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717642829; cv=none; b=oXpHVCX4iqeTYjO10N1C9hS9beX+6LIVjR+gf+Ye/bmDAII0Gn7IXjFUngPCsmmzx/Yd2sjs75nMyRNQe7zVsduYS2kR0K/6WSMBBoM3JYdkvGuvOQiQNkHFOXYYOBSzOlccO2oiTxF65lAaDMIhOGakbH3W3OVQaIJ6z+DO8Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717642829; c=relaxed/simple;
	bh=13zMeLIVd4+RgfMY41lwQyVfbYR6qBJ+QUYp/aU0PQw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=vFx9X6LUFfSMB82lViujo8Y1iB/HjjiPmNSKs5VTOoUkP1H9JpZNhYEWiy7ITR3KeDzY8iU03p3V0iyV691JaF7/7h4L59nM2rzyZa1Tlr8HzBMz6tVEYg9L9EyaIguHCgkxA5KjrWDLKKnux7q2EdzvH3HhJHrDobYWaInsNOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5HwNvyt; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7025b253f64so402203b3a.3;
        Wed, 05 Jun 2024 20:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717642827; x=1718247627; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULW+2oU3rQhVwjAM90zTIQPs8hm5yJ6yXFIdCR2GhYU=;
        b=M5HwNvyt7VD54858rOxQIclK/dGPsFFj1VBVbxG95auAnTXXRrHq5Gq/xSavBPSc18
         D5XPyeGyovknLN6rq7/GlQm1cIo1LdfGBwWVoWUNqvTO+iOP51RVOaS9ro5kXmsBQOKI
         Ka+jD7kqj1LxZNZUm3Uc+5R9zYNPkH4nirrSmSwq+iFSL/0LPIM/iYhuacMAcO7LLGwi
         jwwNWZMOiMc4s04sRdoSdSojXpkd/SwcRbiAE6B3PJU6Bewv5kQoFSVjlybfpOB2XMPP
         kGK8kqvaUqgt8Y6//QyERV9Rpu81CgsuSbe99kmrBsATIAMJu5uD4VPI9QuY6nDeRFN8
         xUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717642827; x=1718247627;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ULW+2oU3rQhVwjAM90zTIQPs8hm5yJ6yXFIdCR2GhYU=;
        b=mRWWXmMhVGfb/dzLXQCZgN/1Rr8W36VdNQcuBgyWKEF+807YH0K+ygNtR+ExABIfKo
         iQqPNG5bj+1S1BX7LOiPu3YfqKplBkC6yv9qVpZMPi9flBxBH1v8tNioDo61VukLXrMG
         Of7pfZN2iRb99iKCIFr8b5wlylAf3HsoSwEKpShnhOVOzSibS91xphK7+EgM8F0BaAS/
         RWAV3pDO9TrXP0xDimTVEIXpI0woasvNqiLbr1grpwMZJsjH6Z6L0IbMRdhjFVB1Hjs/
         vHqzG3+VVm7llszOjNaHQ7ikt+PBPnxNg2iOLSa97MV1Z0kW+3HgLd6DzPCPoCulgBkg
         7pMA==
X-Forwarded-Encrypted: i=1; AJvYcCXybnEbmcwKAza2i1ohyW4ppzC53Ff753kM2YYZyAqOb3Lghxq1Uk4v+ZZALNw/V2azAR5v5+wdVbT1lCWuHoy25hdBIQnRaZF8zCzh1noihG5D67KFRzI1hBH5WQ8u21CYLB1eqJ8fE/3hr3bgjT8hPuveKo039Jx0ps9UShHfrHEyuB3tLu4FLTKbUvsa5n1zyIS3
X-Gm-Message-State: AOJu0Yy33ydwazUpm8WGRLFZxVv+TCfaa0KppPoWkhg7BE5dnA5NWHri
	+ckPVfXXu7WaIbSUgQrs5nBNUlvG4F6igE2f3BRvsUGoGP2/cQnl
X-Google-Smtp-Source: AGHT+IFwZO9iXZrSZ7eiieLv2g0azsGpXlp5ks3oSLXWkKXxnEw8h9uCN3zGrnxcvFbRPe9VPVGm/Q==
X-Received: by 2002:a05:6a20:6a26:b0:1b0:1a02:4131 with SMTP id adf61e73a8af0-1b2b6e59824mr5312544637.2.1717642827073;
        Wed, 05 Jun 2024 20:00:27 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7cd7f6sm2642725ad.122.2024.06.05.20.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 20:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 06 Jun 2024 13:00:19 +1000
Message-Id: <D1SLK9T4ODZO.11N6J5D94530R@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <aneesh.kumar@kernel.org>,
 <naveen.n.rao@linux.ibm.com>, <corbet@lwn.net>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <stable@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Fix doorbell emulation for v2 API on PPC
X-Mailer: aerc 0.17.0
References: <20240605113913.83715-1-gautam@linux.ibm.com>
In-Reply-To: <20240605113913.83715-1-gautam@linux.ibm.com>

On Wed Jun 5, 2024 at 9:39 PM AEST, Gautam Menghani wrote:
> Doorbell emulation for KVM on PAPR guests is broken as support for DPDES
> was not added in initial patch series [1].
> Add DPDES support and doorbell handling support for V2 API.=20

Looks good, thanks. So fix for v1 doorbells is coming?

Thanks,
Nick

>
> [1] lore.kernel.org/linuxppc-dev/20230914030600.16993-1-jniethe5@gmail.co=
m
>
> Changes in v2:
> 1. Split DPDES support into its own patch
>
> Gautam Menghani (2):
>   arch/powerpc/kvm: Add DPDES support in helper library for Guest state
>     buffer
>   arch/powerpc/kvm: Fix doorbell emulation for v2 API
>
>  Documentation/arch/powerpc/kvm-nested.rst     | 4 +++-
>  arch/powerpc/include/asm/guest-state-buffer.h | 3 ++-
>  arch/powerpc/include/asm/kvm_book3s.h         | 1 +
>  arch/powerpc/kvm/book3s_hv.c                  | 5 +++++
>  arch/powerpc/kvm/book3s_hv_nestedv2.c         | 7 +++++++
>  arch/powerpc/kvm/test-guest-state-buffer.c    | 2 +-
>  6 files changed, 19 insertions(+), 3 deletions(-)


