Return-Path: <kvm+bounces-62572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D62C4895E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA893A3732
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC72F32C31D;
	Mon, 10 Nov 2025 18:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GN4yE0M8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382A032C336
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799339; cv=none; b=OALY4nt3TCi099JFVKFZF7rT6hGFS7ynkaJOtNDWQccHMl/cWkA0iklXJ53CB9S4cN7DCk/QXLSkLvVfWCvPSJyIntwT4xpfNalqcE1OAmas5K5xWkLaFcFb3MaxQuB7t1XjPulkWZ1IPSY+pZzoIi7Doyiz6FuwlUnA2a0UI4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799339; c=relaxed/simple;
	bh=fJV/RtlEridQLN78C7ptYM1qw13Wglr7XvHzt88UOiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+brUInUqQADkPim5FW2akJxWbJ5eZXc9P9xlP9qFuuWXgA7d8zgI9kmFzhtg8OT9ArWKE+I4N9PfRGj/h/XVvFmzppJ5Nlv/T0no2+ZajwkFzFrEaJ3Co1KmBIpvTW+z09WzMrQ5y8NSqC2297V1cXRXh0d8bRroFmAy/ppiqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GN4yE0M8; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b18c6cc278so3354690b3a.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762799336; x=1763404136; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PI3PxyMvV2B0xV3gp+ziEDLShaFZbpMva22kJCv4VyE=;
        b=GN4yE0M8RWla7rRC73HC04yTiULuR688keH0YM34VFGaiormiR8YZcmBIV6OXVkNH7
         Ca2vtaHpYt1hWx4p01wJUox1DhqSae0itpyhzsPvuz4yGEkjcuv5Zdqp8BuJGZKTjGjN
         wkKxOQtHoBDYFFjgQTKvBAz3GU/OW1lwsrRqkKTLpbTCWGAVBEmxx1pDyWV2BPXC0INR
         NXphMQamABUhlbKlAhINQ97WVo0+eGMzQIFXfzBkanSF00CZS0HLKN09IdnYZ8YDkDdr
         NAlyEmXCmmAO1arkwX7LDwzsS0Fkqjoh8SkAebb/sAgbyPTqwAcjJN5crWJlOt8Eou2X
         GDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762799336; x=1763404136;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PI3PxyMvV2B0xV3gp+ziEDLShaFZbpMva22kJCv4VyE=;
        b=oycXfXPxltUqY6zFLhmuOIlXtsQwYcfS7NqlFTfzdVtMqAKd34I8QcGL/PSc2Ar8ih
         SQOEkbEP+dJr7MOx6mxp0RRhFafplgROpXey8ghmwy7QOd+g2/JpPQFQcHIzCf7Z1zzW
         SA6xfFJ3mPAm0qFatKeITPTGgmsrIFESlkNr6uieC3LrdtURJWNwjDVscogQHjcfAAVE
         s+StgMY1vts5D+N1skcMqtW59NjryotjXRv6hcefK36wFRRJ/N6/PbMZ1PaiX7fiK1hP
         pkkQCItuzbx3BVLRk0Xa1yJt8wcZ7hsILn9GTQobaNV3gRRPyxROkqULO8AhLC5UTTPZ
         PlIw==
X-Forwarded-Encrypted: i=1; AJvYcCU9x5fclOkvefq+wP+L5RDfSGSi8gY43CHhE8knfa3mPLUwekwWqXZep8PQVgy8NzrSKDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS+5PEgsqCd3RkQiaXXbEkwJvxFj01nro9yQgORRnBrpDxuQsz
	kqaOyZUyfkx0u/NbOtQb82ka4cFyYE+h+10PExvxkfitSNZ0ce6HNk3eDSPlxcOXtQ==
X-Gm-Gg: ASbGncvwSvHv6h8k3Gx6tzOExFJA4MNYcHGbfPN1RHbuPxV/tOZDCkFNxWo491NUM9t
	xquKssX7qaWKkLvhr7XLuFzy5rXfk0UIJrsEIABuhcjp34bRLSMQ5pctGqkND44Fgl6EOdhJ5lg
	KXNDQvpUazWrhSvma5lv9HLWirUiroL6lWk89YTyvrE0IWy7V+1oSXi8YzMtiaJafqKMBzrTasM
	VDV29Wp6h3DnvAv0FfNEIyu5ls1gqSnekiaMa89ksHd6qVIcByJBx/7KIbqbuQCPbQ+/+bi9RE2
	zTiZL1/kEdr2K3PqnMPhmsu6nCacDvMgellY4DGM7PkGo/dMwjv2lIHg2M61J5CATrGMgrUb/wh
	ObojFGSqIIXm7gdMv1k+/tsa65nV+hhfhytj6b+YYdCTPtxG5O1fvu/R8B3qFoZbvbA3BouU70a
	u1XjShQODYln7jXZMmxVDsJKFwiri4AIYM7q6fV5no0QqELkAQ9RkKEO1Krm35kaM=
X-Google-Smtp-Source: AGHT+IEuJ+xbZqmpIvt54pycTa/bJt4HbP+wihthd82hIgSEgNxkl0MwreNvzp4qbKAt5Jp8AdaxTQ==
X-Received: by 2002:a05:6a21:6d9a:b0:33b:bce3:31c2 with SMTP id adf61e73a8af0-353a0465d35mr11833866637.20.1762799336047;
        Mon, 10 Nov 2025 10:28:56 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f9ed21e9sm13952396a12.14.2025.11.10.10.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 10:28:55 -0800 (PST)
Date: Mon, 10 Nov 2025 18:28:51 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>,
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 07/12] vfio: selftests: Prefix logs with device BDF where
 relevant
Message-ID: <aRIu49aeGUS3OJS7@google.com>
References: <20251008232531.1152035-1-dmatlack@google.com>
 <20251008232531.1152035-8-dmatlack@google.com>
 <CAJHc60zH4x98uCDEveGf3Lr+b0RaiBUC+r9ZdwpNxu9wTAPptQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60zH4x98uCDEveGf3Lr+b0RaiBUC+r9ZdwpNxu9wTAPptQ@mail.gmail.com>

On 2025-11-10 10:24 AM, Raghavendra Rao Ananta wrote:
> On Thu, Oct 9, 2025 at 4:56 AM David Matlack <dmatlack@google.com> wrote:
> > +#define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
> > +#define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
> > +
> nit: For all the dev_info() replacements in this patch, the messages
> sound like something went bad/wrong. Shouldn't they be dev_err()
> instead, or were you just aiming for a 1:1 conversion?

Yeah I just wanted to do a 1:1 conversion in this patch:

  printf(...) -> dev_info(...)
  fprintf(stderr, ...) -> dev_err(...)

I can upgrade them in a separate patch in v2.

