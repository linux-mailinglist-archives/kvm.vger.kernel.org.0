Return-Path: <kvm+bounces-9623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F82866BCA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECFD0B227CE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B161C6B8;
	Mon, 26 Feb 2024 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eSEGTv+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BA01C69A;
	Mon, 26 Feb 2024 08:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708935014; cv=none; b=ksjefhvzd7OMBzzoj2SqrHZOwhuM1DcHA3xSIB+TresgndhRR2o2znsqj/wfNdbLYOb3905ajnwo/EH5ka1ilmDmM68KIty0G+4KwRGBEeYOUhCHHgbo2TsiVOHAKz0IC+YVHQR4m3HGemdMTTLRXcH+4zXhBh2ulrxDszQqiTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708935014; c=relaxed/simple;
	bh=0rEJgdXMQFNKOG9TkEY6a7r5OzMiNPZsokrEY69bxso=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=EuVG+SyMdVxjf8jde2yzAQ0GzGJVTOS2WALb3DUfex9ZfcaCmGxzfg0jlRTdLpfbM12eWldrDyCujLyjq2Gq4BLGz1JRhGfKnajdW6ylDS+LAN8fuP7l2jN4b8UWltLWjVwzfgxFMDLWmNIAstSIJkbPLaZJnM2FoenSxUh9QyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eSEGTv+h; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dc139ed11fso17063605ad.0;
        Mon, 26 Feb 2024 00:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708935012; x=1709539812; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40CoeWlqXJhcfzeZ8GLVER1J3s3pk7Hsd4Z6LBpACw4=;
        b=eSEGTv+hQ2qV3+QAAHA1G1m3tC9NQMQhWCd19IvLNCwS1n+iXUpIuWSfSLHq99kvmk
         dmSG+HQCh39blHJFh4n/WpNee1sULTREyiBkbc/CzMnGNTKOY8GGP0yDOtyOuap7e5qx
         GD+2gll7cXSmVGIUeL2AR4pU05AXWLSySXa3Yy83XZxUllcpkvUnLeJWFkDwzAOLvYEm
         SJQyb3sXcJ/J8eL5a3NNhI1ZYBL7NTwiF48nAg1uMFEHchsYJW1HsD9TPfgd+LtjcoH2
         es/0vwUz1zPPJxGR86ztcjD5RXgLRnPZtK4OzC1QHteRhjeZ6CFz3l8nUym+z1tsPyvR
         1mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708935012; x=1709539812;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=40CoeWlqXJhcfzeZ8GLVER1J3s3pk7Hsd4Z6LBpACw4=;
        b=OMefRg42SIK1KTu+S11xybR3/jkZwmjSt3GF3BcnIM7+lLnN/85i8QQoXd07cS+NW6
         MAXU8kakLyafFbCHj1jmMjaOiCkj6JNKb44MZX8PXTtuI1cN3iTJ6CvNsY38dmsB4aWs
         1Rikl1Tlgs18LxH1o3fIxVXS9OlNWjNXb/7i469f+ZCz8E0b0HTgrtkXhEivIBXDcxvQ
         i0gzyODzwI+lTqFiMRyTRdH3NDpGO1wukVGJMPFks/4+eoh6tYsSfS7ytUsANWhMPj2a
         3fdNVMaIfqdwiLnDkXpNTYiiI2lrXrDJtu6QDyu8kS10P+nDzrJQsADctxEIrwYbsa7f
         HIMA==
X-Forwarded-Encrypted: i=1; AJvYcCWrvdAUBTin1cL3Wwv+OtS++Vszhtaj/jIpsHQzUjnHDbhgZGVipIM86+ziwnHfFcrole4oWKkoE86u0rvcFiUxQVH7XJjEF9vAhw==
X-Gm-Message-State: AOJu0YxLnmKsEO6T75sgBfltHmMHM7AmqMOBHv3CNBHb2KtjGtxaQ5ph
	10oIZcgJ1nnVOnP5ARHtIh6oBjUr1eejvoSQ4sMGZNI9f4sBdvNH
X-Google-Smtp-Source: AGHT+IGjewnhiknpGMm5HU4N8i6SJvrGSCvXNkP65jhcUFNHjZ9u6URsa8lY6wCVKeLBowpA/NdmVA==
X-Received: by 2002:a17:902:e5c7:b0:1db:fc18:2da5 with SMTP id u7-20020a170902e5c700b001dbfc182da5mr8456349plf.30.1708935012131;
        Mon, 26 Feb 2024 00:10:12 -0800 (PST)
Received: from localhost ([1.146.74.212])
        by smtp.gmail.com with ESMTPSA id mm12-20020a1709030a0c00b001d8d1a2e5fesm3348276plb.196.2024.02.26.00.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 00:10:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Feb 2024 18:10:02 +1000
Message-Id: <CZEUWE22JA80.3S73L9F5A04RK@wheely>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v5 0/8] Multi-migration support
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240221032757.454524-1-npiggin@gmail.com>
 <5383a1b2-20ca-4d07-9729-e9d5115948dc@redhat.com>
In-Reply-To: <5383a1b2-20ca-4d07-9729-e9d5115948dc@redhat.com>

On Fri Feb 23, 2024 at 5:06 PM AEST, Thomas Huth wrote:
> On 21/02/2024 04.27, Nicholas Piggin wrote:
> > Now that strange arm64 hang is found to be QEMU bug, I'll repost.
> > Since arm64 requires Thomas's uart patch and it is worse affected
> > by the QEMU bug, I will just not build it on arm. The QEMU bug
> > still affects powerpc (and presumably s390x) but it's not causing
> > so much trouble for this test case.
> >=20
> > I have another test case that can hit it reliably and doesn't
> > cause crashes but that takes some harness and common lib work so
> > I'll send that another time.
> >=20
> > Since v4:
> > - Don't build selftest-migration on arm.
> > - Reduce selftest-migration iterations from 100 to 30 to make the
> >    test run faster (it's ~0.5s per migration).
>
> Thanks, I think the series is ready to go now ... we just have to wait fo=
r=20
> your QEMU TCG migration fix to get merged first. Or should we maybe mark =
the=20
> selftest-migration with "accel =3D kvm" for now and remove that line late=
r=20
> once QEMU has been fixed?

Could we merge it? I'm juggling a bunch of different things and prone to
lose track of something :\ I'll need to drum up a bit of interest to
review the QEMU fixes from those who know the code too, so that may take
some time.

I left it out of arm unittests.cfg entirely, and s390 and powerpc seems
to work by luck enough to be useful for gitlab CI so I don't think there
is a chnage needed really unless you're paranoid.

I do have a later patch that adds a memory tester that does trigger it
right away on powerpc. I'll send that out after this series is merged...
but we do still have the issue that the gitlab CI image has the old QEMU
don't we? Until we update distro.

Thanks,
Nick


