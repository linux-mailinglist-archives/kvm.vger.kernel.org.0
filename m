Return-Path: <kvm+bounces-62819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E20FFC4F8F8
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 20:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6FBFB34D3A3
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 19:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04D9325498;
	Tue, 11 Nov 2025 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfQpeiJp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F0F261B8D
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 19:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762888583; cv=none; b=ldRexR1uXsfNYfswatsKLG4iFv1FsVS8J7UonOUeWAwrlif/McugrCdLvwO9duPf+VzISFrZIswPIr5Jprwe8RmsCj+Gk91gZWqBSYKLqqOiHoZvbEM14YBL3lFmJ7+aQONq14e9w6JdJFr0EK35uKAo9am5hC5tyrXSBdjZa+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762888583; c=relaxed/simple;
	bh=80BdFIZCX/Ki5YJrxpdlffy4WVqbtfvYTmjHy4innFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HUkPwth2JItp2nciT8Z02a4wcHTEENwXLPvzSwks1WALDiPRKKHptU78OhgfnHol9Gs8N97t1G/4jZ/Fe5quwe2F58u69RscFNcGccB71gellXUEl8qbdCJBnlN/pLqaksRj/eggc/9bEYZsI5QmgNZ0v/o0qpV/9WtqyUU/bXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfQpeiJp; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-591c98ebe90so33357e87.3
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 11:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762888579; x=1763493379; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80BdFIZCX/Ki5YJrxpdlffy4WVqbtfvYTmjHy4innFw=;
        b=mfQpeiJpvXVxGXxZp6HrwIz11czsZThVXawxzb0SJ8QFTeQsSUYkgMTafgwbxnbeWZ
         /Oj6NwMq1PS4AO9QNKBiW8Yt/RDjMOT4QvoC/CvtR0jGXfYeh/sZ9biYV0DSzoC86/8n
         +XJJA2cDosXWf+AqYAVZMDC9N3E3MiyKVWrHsq2N+lqYCRrn3Fz0cMesoW9jZWrPJamK
         I4/anel0gThkrNyfdM8TlaxmLAsN9Rq6yEVIJxzgfarn8lClQZFXeoE45hGGywHWeJ/a
         H8rO8VFUscZrAmL+8eOiEox4qC5o9ymHDBrNkVQG4V2jlKxnRQCZIq9h8T1O8NrT4mDK
         qgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762888579; x=1763493379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=80BdFIZCX/Ki5YJrxpdlffy4WVqbtfvYTmjHy4innFw=;
        b=Sg/ps1Fi6eAtzk9wVaVm7tHASoaoxvohk/Dyryi1cM1m4dbDA3G8pVGWUyRleGP/k5
         gJ5rV6/oz40Q8ssnbdmUhgCWKuEw6PiS/3s5XfzV6+e5pJWzYz8ysQHnQRXbkN74cxKN
         i3IzsYutY3A1+GqmQOvUkPAAjG3ybKUawLjNBjpN7fTed7wZyEVqsZcFdge1+cVt3gZp
         41kn27HkOya7Jon3C4tu4AT0ZRQO58uMK1W+ci65eUpPAO+oM+aLL3WEdp3qMMZ5ILIc
         Y0bOt9sA2StKPx1Y4scA7YoXOZk+XExS87e5xTlzc549I3Wy8JP6xAcIDra4THFnUlye
         ocoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG9g18Oc2j4sYhmUIWbtppLCsZZqYnBQ8BlT61xz4nDPXJRMVag2bvjlYDdLsn6ISe+gY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaIL1OzpN/pcxhwvXfBXimW5ZlP4T5yFlKWQ6LiRBMi/lMYwfE
	umfFbRdYXWZ4Z3D+UU16xH0xbM8bzlSaY3gQ2EfRF47i4oDK9HhrgIFyUJKNFns5UQBGTvrPIay
	ey/3DYYbqgJsrkJoXy1JUsTzxcm/bTbrWAdjFW0FE
X-Gm-Gg: ASbGnculXvYhgnEV8+d3lZOYhxGp+Al4CIJ7kitqWh4f3xSpRUuAxImlb312NWRPMv5
	Pc7MK/c9sDnS/TaPtp0/OQcUNXgGd4n9aB7ylMTgdOCdWMO8oPlkBqotCjShHwnZsv3YqVjfMhg
	ucWbOyb69asJlc30GZx1usz5DojomNRZMaoEoBrrmdc42nZ+m/we94Q3tjBlLLMI0DlLpNJ9x5p
	2Q6QYz+acOVXQUEv92QBff4XsfcU5bOXmV5T0y72ayV4vTV5qsTyKfsJY557N4B8m5GIk0=
X-Google-Smtp-Source: AGHT+IEfUooUtARmY5RbLRHvk+8vMoq0ZHORJSMW+6rEU4tWb33g8X0C3UE6Mtd74+wf2jJ25PQD8czLv2JmcqYfKjg=
X-Received: by 2002:a05:6512:3ba0:b0:594:27eb:e130 with SMTP id
 2adb3069b0e04-59576e3add5mr141912e87.46.1762888579231; Tue, 11 Nov 2025
 11:16:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com> <aQ1A_XQAyFqD5s77@google.com>
 <aQ5xmwPOAzG4b_vm@google.com> <aQ6Qmrzf7X0EP9aJ@devgpu015.cco6.facebook.com>
In-Reply-To: <aQ6Qmrzf7X0EP9aJ@devgpu015.cco6.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 11 Nov 2025 11:15:50 -0800
X-Gm-Features: AWmQ_blx19T1nIePJX2Mp264v8PUGfcIhqfsMzZn25t7rUocwejd4J798irQbmU
Message-ID: <CALzav=eDfqU9aPx5MEkgQMYRf7ZVfd7wycNcWpPJCUw+dxkgSA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] vfio: handle DMA map/unmap up to the addressable limit
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 4:36=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote:
>
> On Fri, Nov 07, 2025 at 10:24:27PM +0000, David Matlack wrote:
> > On 2025-11-07 12:44 AM, David Matlack wrote:
> > > On 2025-10-28 09:14 AM, Alex Mastro wrote:
> > For type1, I tracked down -EINVAL as coming from
> > vfio_iommu_iova_dma_valid() returning false.
> >
> > The system I tested on only supports IOVAs up through
> > 0x00ffffffffffffff.
> >
> > Do you know what systems supports up to 0xffffffffffffffff? I would lik=
e
> > to try to make sure I am getting test coverage there when running these
> > tests.
>
> I observed this on an AMD EPYC 9654 server.

Thanks. I was able to find a similar server to that that supports iova
0xffffffffffffffff and have added that to my test workflow.

