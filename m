Return-Path: <kvm+bounces-62366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D3463C41D13
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 23:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C41FB4E21C9
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 22:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AB431354E;
	Fri,  7 Nov 2025 22:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E9Vroep0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76CF24BBE4
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 22:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762554275; cv=none; b=EiiODBqaGx4r3AQSfEYmjSqojxEQrY0a0VtpsXxNwHH9kFbSCqi9m0SNGF58yDOppHLDIB3tjCVyfwn6tP2U/d0EJ2QC5fbm0iOu7dCbwHnA0o+uUrTvEC0Ys4WHrHujLrFCBRQkpDu42kX0OhtRvLQi4bVbKKsb7zrn2anLnOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762554275; c=relaxed/simple;
	bh=lx0NS/E/qPZSD31v0pm/DRx9c5hlgx+ZtrjvCPWzNgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REquErVhC+0/9rR9Nd3Qo0JWsRhhteFv6m2j1g4x3iH0tFhbYfBJceeiTVCg7hMsIx6at2eDEZ/EMVMqozCynmbbh+H39Nhj6Zu3b1M+2fOLmToUbTZ7kZ3+IExKmjmb5tVLQYN7m/RU0LbVTDZBAjnKzK8xtF7Br+7yFlffHlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E9Vroep0; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-780fc3b181aso1018361b3a.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 14:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762554273; x=1763159073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHTANTm1RsTB9JrdKMuaQrXECKg/gqfsbPDedt+nZd8=;
        b=E9Vroep0C/w8Yrt1BtZ1TtdVzmuGaPKwZNwCVzhttXZdZzQRLLEGVE9b0kUAc4kYbL
         3XijXKP6DaTTyWqsEYS9tW0Qh13yuIfkwXiECe19I0HjfHdce6wj91lJbCkCaqXTNEz3
         7Sl6tTLxlYZwOABBiMXLfy2b+MmlTjEwfFobZ3NR/ls0lBdJk7CuiNzLPciNuqHCh6yr
         1qbD1/E8NFTe2wh/GYGOWT3jTOj2WywyywAocalDKvuSL2Xh7RL29s5N7GzEI+QLNG2Z
         NfsXpwQt4D1vqw8Sii3UN6om1pT317m2jVe5LSbw0/2irNLljUwAdnt+8B9/rwr67u5/
         GtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762554273; x=1763159073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHTANTm1RsTB9JrdKMuaQrXECKg/gqfsbPDedt+nZd8=;
        b=W7LrZH6Bwwav/3Xex6hXj9xJyzcxOXCOvvy4eLa9dKly9ubZGM0d8f0ARXgNfZ9NV3
         j47xF6VdftIzDJTmFnLowmEaW5loJt5F/xjvYs/hlFnVARDTpXYANfdV9oo++J1tD3eE
         pJaYusvjWVpTTyMgogKQ5Z0aX0xhZ33cWFwpELcDiYuHlkDioHOG+ugB+Qd/RF26bhN9
         XrgtDKU63e/3KXKmngfJr/2G2ibD/p4SjcTGvtLWRIsTOw2UwGpALGix+tuSaWjQ6S4l
         daCQLuq26FSANgCoPU6VOsDFQinX9Fl8YocnXvTC5O+TnImy13Bi4v1htNOsdZgtQ30X
         Ieiw==
X-Forwarded-Encrypted: i=1; AJvYcCWxJ1kZDiWF9HP7DJ4Zl7IMorkF3os0oksOOfKo3yPKY1PIP3EnzsOzWs31OGuR6IiezCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRtUXT+xpChqDeuMF3031+n9GLDk8GkL4Nkk6JWjsMezWaK8HV
	UJqiBIQbBx3eJDF+i/ZrQEjcaMrATdQ5yW4XVypbGHhtM2nYwm4vaHmf7Gxr1JFtZJHT7BwOR6G
	4Da0UBg==
X-Gm-Gg: ASbGncuLTm7gdjYVTWHqAF+1nnmm4vddR+BEjmAEK3v51NLrWv71IgYnn59WDGoQx6u
	ner29tBUMngYMp4B2/cZEpvzX5CNsZvC8fSDQczBWRxOGVMbF6gmRkqaZ7wKxbW9iLAtDg62S/o
	Nu7Agpzm+ayZ/URssH0cTLGbh3K9CLzl2pAjs6gsyyvPcpL4EAHtpQGZ+r8Y33s/8gq5Xuzepmx
	cfvqHbLaSbRSv4BuY6r9wAVWAkHeICZi53IdcyFs+K9h1hdg1s03oMbMy/oK0bBaYZaTvTpAeiV
	RQXlbhEK753MDLx+GEHnhdZDKRIVFxqf4K4Mr904oOhy8q6jXLprOL7Mp+ulS1e7UfXeJyvbtbb
	ZNAboXvi8q5F5JrtvJJ2ULDXebIh5fZyy7/EPOgkreceDAP8gAOVYPqji8E32tkzl4dQKSfCH7z
	DqcxWjeGOC+YXFBF/MTljaCWDrjETSSuIOClc8/AKFDg==
X-Google-Smtp-Source: AGHT+IGJ7vPSosIOeWbbYNUyS0fjI1cnGQJX71au6Zi2Ah/itUQP/vl6gTmU5zvS7QHx5XPyRUQeXg==
X-Received: by 2002:a17:90a:da8b:b0:33b:dec9:d9aa with SMTP id 98e67ed59e1d1-3436cbb171cmr666287a91.25.1762554272824;
        Fri, 07 Nov 2025 14:24:32 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341d1347db0sm3465853a91.4.2025.11.07.14.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:24:32 -0800 (PST)
Date: Fri, 7 Nov 2025 22:24:27 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aQ5xmwPOAzG4b_vm@google.com>
References: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
 <aQ1A_XQAyFqD5s77@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ1A_XQAyFqD5s77@google.com>

On 2025-11-07 12:44 AM, David Matlack wrote:
> On 2025-10-28 09:14 AM, Alex Mastro wrote:
> 
> > This series spends the first couple commits making mechanical
> > preparations before the fix lands in the third commit. Selftests are
> > added in the last two commits.
> 
> The new unmap_range and unmap_all selftests are failing for me. They all fail
> when attempting to map in region at the top of the IOVA address space.
>
> #  RUN           vfio_dma_map_limit_test.iommufd.unmap_range ...
> Driver found: dsa
> tools/testing/selftests/vfio/lib/include/vfio_util.h:219: Assertion Failure
> 
>   Expression: __vfio_pci_dma_map(device, region) == 0
>   Observed: 0xffffffffffffffea == 0
>   [errno: 22 - Invalid argument]

For type1, I tracked down -EINVAL as coming from
vfio_iommu_iova_dma_valid() returning false.

The system I tested on only supports IOVAs up through
0x00ffffffffffffff.

Do you know what systems supports up to 0xffffffffffffffff? I would like
to try to make sure I am getting test coverage there when running these
tests.

In the meantime, I sent out a fix to skip this test instead of failing:

  https://lore.kernel.org/kvm/20251107222058.2009244-1-dmatlack@google.com/

