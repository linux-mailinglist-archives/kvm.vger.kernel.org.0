Return-Path: <kvm+bounces-58024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D49BB85C3F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2231A7E0EBE
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69F8315D41;
	Thu, 18 Sep 2025 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmQWrFwa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2013148C9
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 15:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210310; cv=none; b=OjVVb1z3M1i5QwsY/JoXc3NbMm57pUk8BzO6Ua5YwXOMQGdNjz7pVHBMPe9yHK0wmzzxrey22aUUkj6aevBm3jPYx+yCaUZ5hX99eokIeiZSnXe/6PcxWPaYVeF03r/8pN36qkCe+/O8z8YpdTsMtXzHu3JkekrLJZaWyEvUG3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210310; c=relaxed/simple;
	bh=fmWHKTD0HEp3v4jAbafgMjtiPh74qcGGX1DEtLNknfs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ovkaym8ohxNJcAEd7DqfoETIrA6X0mi2FbQ21ykvd3/MkvceJZtlshkMctesFFTNyGLcjeNe2Awfyi2Tp2HkHVc7v/chPGVeTRqAF1NNXxWO9kbXGZkdCGak8iPDlHx8S+L473wnmmBKHPiGFr9xNeqNx2vMboygr+rvcokhTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmQWrFwa; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b07e3a77b72so318630666b.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 08:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758210307; x=1758815107; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fmWHKTD0HEp3v4jAbafgMjtiPh74qcGGX1DEtLNknfs=;
        b=SmQWrFwa7DOmbmqdCLwoO5gF1gy5JJLlvihxkgUtQ+WbtQUm6wT31dBa4WNgM8o31G
         yKLyDm2QHBWbGND5VdcLRj02hz/ufyWiz1RZJKJW8NJuZ2RXT8JNXtNBN9ikacxd4ibR
         UIKeQOxaTZwTcKPSK8+m6Bx2XIvTsmNyZHfo6RwTSFgcFGALgUCxYpbWX9BkVJaRUmCK
         4iwxzIKZRm73JLY414z2WlQ8w7KPj7+z8ZVF+g1t5VcIr5XnxkWaJEKmkks1+dATaOX3
         ouV+R6c/ZHJj94WjUnqi+HZToKHAIVf+Nwq7yZZhZxpIFxIfZWr8vh3O1ajVMCqR479I
         jXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210307; x=1758815107;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fmWHKTD0HEp3v4jAbafgMjtiPh74qcGGX1DEtLNknfs=;
        b=umOY11ZT+OH/OilaNPHhBHMnCF9xAT+wCmfuUK16R677FKTPJ88DsYT+qHprFxvd5n
         /4IguOIdBaJN+u2N0I6B4H1jPfPwCcCnryV6MPA9I1/ma6gfLsIyuke6N5TkMQ1K41Hl
         GuHdsESLKtOwKG87RopR0hyEqcX2bzxon6G9SP3ZSrK1zsu5kHe56dgxqbzRXqe/bbxS
         I8Z/pqQK/hFMdXlFupBdnjSphnWMfrqV8h1N7/yN7Cr4jT9JWh320xsNTlJcIURotyV6
         ceIrAo9NoEA0Uzy7Il1abB6v1rwKquBchF9C/Ei90yL9NDqMCG4nxNbVSLYUt24pv+HV
         CImA==
X-Gm-Message-State: AOJu0YzTZubPt9N+NPauvW52NiU0qXFaSyTNeMRtUxbF0JjwUZu8LoTy
	WbzXbqMkQCLxyIsSQQeaxvRfD2z0FArK0es0/yAyjd4Oy3mL3OLoc5L4APSy1h4g
X-Gm-Gg: ASbGncvL+06cHQ0i1Udj5HeN+KKUA/iXsYDZMIo6Cr2muPXA+73z9ZMi/vfzpf0lQS/
	/ZGXMHYPkxBR1wV0eyH+y4gmCkDkJqB0bLRYckHP2Q03YS1Mmg14N5b340VcJrFic94lFSGcaoK
	dJBkD8mGDR89/UAL6VE2E5k5d9q+IH7YpW1Gkwz7JhT1vF3q3/XKgcK23AExX2QILf7O2Ia5zIT
	yFPwhYi87n6j9zaGYz+pTjBIRncocvAjPEAGLGxJ2aLVhhoiKeEx0oTkWJGxzPvIsMU5ZgPJtMo
	5QMniOmqD+1wu8eZCjkyFdLqxWmjCgb3+zy2Ium2xzOwMrM/X7fILJhXz/giQOneoPsbPXOENdU
	FUb7X4Niz4BERplvd1RGipSDAdmLL7IB09Kuxpoon02GPw+Ci/sslfrXLUc+G9p7vYRWB
X-Google-Smtp-Source: AGHT+IHhJpUJxm0JBqQPK1WWHMUOmGprTfN1qsQTFyUzj1uozoUmCz9sEIlUOLodf6VL0JxH0gPMWA==
X-Received: by 2002:a17:906:c150:b0:b04:3402:391c with SMTP id a640c23a62f3a-b1fac8c89d8mr401452366b.24.1758210306797;
        Thu, 18 Sep 2025 08:45:06 -0700 (PDT)
Received: from [10.192.92.112] (cgnat129.sys-data.com. [79.98.72.129])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fc890cc98sm218393066b.49.2025.09.18.08.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 08:45:06 -0700 (PDT)
Message-ID: <869d0cd1576c2ea95a87d40e6ce49b97d62237c9.camel@gmail.com>
Subject: Re: [GIT PULL v2] virtio,vhost: last minute fixes
From: Filip Hejsek <filip.hejsek@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 alok.a.tiwari@oracle.com, 	ashwini@wisig.com, hi@alyssa.is,
 maxbr@linux.ibm.com, 	zhangjiao2@cmss.chinamobile.com, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Date: Thu, 18 Sep 2025 17:45:05 +0200
In-Reply-To: <20250918110946-mutt-send-email-mst@kernel.org>
References: <20250918110946-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-09-18 at 11:09 -0400, Michael S. Tsirkin wrote:
> Most notably this reverts a virtio console
> change since we made it without considering compatibility
> sufficiently.

It seems that we are not in agreement about whether it should be
reverted or not. I think it should depend on whether the virtio spec
maintainers are willing to change it to agree with the Linux
implementation. I was under the impression that they aren't.

I will quote some conversation from the patch thread.

Maximilian Immanuel Brandtner wrote:
> On a related note, during the initial discussion of this changing the
> virtio spec was proposed as well (as can be read from the commit mgs),
> however at the time on the viritio mailing list people were resistent
> to the idea of changing the virtio spec to conform to the kernel
> implementation.
> I don't really care if this discrepancy is fixed one way or the other,
> but it should most definitely be fixed.

I wrote:
> I'm of the same opinion, but if it is fixed on the kernel side, then
> (assuming no device implementation with the wrong order exists) I think
> maybe the fix should be backported to all widely used kernels. It seems
> that the patch hasn't been backported to the longterm kernels [1],
> which I think Debian kernels are based on.
>=20
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log=
/drivers/char/virtio_console.c?h=3Dv6.12.47

Maximilian Immanuel Brandtner wrote:
> Then I guess the patch-set should be backported

After that, I sent a backport request to stable@. Maybe I should have
waited some more time before doing that.

Anyway, I don't care which way this dilemma will be resolved, but the
discussion is currently scattered among too many places and it's hard
to determine what the consensus is.

Best regards,
Filip Hejsek

