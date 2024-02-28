Return-Path: <kvm+bounces-10297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB6686B7B3
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67548B26B5E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 18:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C817442F;
	Wed, 28 Feb 2024 18:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uROGQocm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59C47441D
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146289; cv=none; b=BtkCQfVlF0VWvvIO62yANit9nQftYWT+01DrMkO+5CskEQFStfDD170V0nDTPT1dfzcS4+GXfKLkuJ1J3R8iQFqHdEROIsE9+04uoyvHs0eagKkamBz54Tc7MkaQlOWHa8bRsNsVuIYvPLTYyKxRh7IHTWuOxhp9fCZxs8ZTlRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146289; c=relaxed/simple;
	bh=6go1uFX/ECmvisL3eZbr0bUKItvAvKbzmZG0fMG4mRA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nl+RIAkRDUgDlSWn8ZFxAWIjfXPS6N/fMbBNkAG9lM6wwjbAUX5T/9a4UVA022ypKC61oX+e5DPkyVK2NTJKWTT8kcjefeahcACseuWPsyZroUToP7VeC5NrTUVFFADitv7E1gbfDCv7h+LNrCUsPvWK3jzXYUcUvpuicHTeJng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uROGQocm; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55f50cf2021so206461a12.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 10:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709146286; x=1709751086; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8bUU9vxL3EbRpjfcwEhLlqzq55NSyMMv6BZETnIth48=;
        b=uROGQocmbwXRj5Ox/37M6Wpt34ffmxdovEUMRClfMcswYqW5U3h6u+B2GRDCiaAgpR
         2UinRn/IepilEXZr2+ANbIkCgAO19aKExV3bKG+vCxiaxNjDz6kKbrj1Itq3hS3jvnLA
         xRmtPkr6dWYH6oYfObMHFnsj00cJNGg6xF++NJhI92lLndBCkFrr1SWFOso26JE2hj7K
         ncCYun0VjYKB3fh2WM2A1IDkRWwKn2TJpRYpWQa+rEAKKj9hvGKIA6d82Dp/qGgqbMJL
         5EWhy5Uo6MQXGTxeYl5tBlOLw+EQ3Xz0rZF5YvJHiPdghmg7xaf2vk+T/PsySJiz+Mi/
         wDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709146286; x=1709751086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bUU9vxL3EbRpjfcwEhLlqzq55NSyMMv6BZETnIth48=;
        b=F6J4RrDc6eoT+P5VEfmKGQMI2+whXIkpJSUPnO93O7MBPzl36TlPETx6IEBw/FARm2
         zPA8GKPsZpUmO6cK72Lav6K53uy/8enBWqZhwCTj3eT2zKSEbtog2N3s+eNvaeedG8pm
         wj+diqDdJvBrGxJZt0IoZmQP1CI/X5tbMmPxF4pp0CrBZQWFmS4OiG7j4ItltSa/eXSO
         NYaBdwZV/3ydQlKUMcwUi3F11yo/hEjHnQbcVbfxCdBoVgYMIfCWAiYgZYp5Wjg+L1EI
         vA2YrvFVjajRX4pWy1CMf/VL2aIRI2QINAY2b9XMMEttoG2uTf9Ln5rY1it7Fv0doYYY
         p1ew==
X-Forwarded-Encrypted: i=1; AJvYcCXhnBjuWWQ7LHh4x81G2XjzeWghPts9wj1oumZn9rdBG/fi4AO6kaxE5+BCr8ygf7uJku7iuu2rX+4fJZapXe5XsT6l
X-Gm-Message-State: AOJu0Yyfx+FXzJ7Y9O9gQb6IsEuROZJplB9kpTFMvN+nLi8WZ/PwSI8j
	ydTSO9FBDdwgGPNvUkBKYhMVZoHPXtxpFRCdj1EUgg8V/AIxtrzTBUwujh1HAg==
X-Google-Smtp-Source: AGHT+IEtwSf3qPuOOfonBBPDQ2VrRKKhizXIywYMnMruTb0VkmhsBu5Qhusi2AHAlbz6PjN7AH2IWA==
X-Received: by 2002:a17:906:d8b2:b0:a44:17c6:a54a with SMTP id qc18-20020a170906d8b200b00a4417c6a54amr389666ejb.35.1709146285996;
        Wed, 28 Feb 2024 10:51:25 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id tk7-20020a170907c28700b00a43aa27b5f2sm2003321ejc.94.2024.02.28.10.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 10:51:25 -0800 (PST)
Date: Wed, 28 Feb 2024 18:51:22 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: Re: folio_mmapped
Message-ID: <Zd-AqqCUKq3XB8Qs@google.com>
References: <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <20240228103842643-0800.eberman@hu-eberman-lv.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228103842643-0800.eberman@hu-eberman-lv.qualcomm.com>

On Wednesday 28 Feb 2024 at 10:43:27 (-0800), Elliot Berman wrote:
> On Wed, Feb 28, 2024 at 01:34:15PM +0000, Quentin Perret wrote:
> > Alternatively, the shared->private conversion happens in the KVM vcpu
> > run loop, so we'd be in a good position to exit the VCPU_RUN ioctl with a
> > new exit reason saying "can't donate that page while it's shared" and
> > have userspace use MADVISE_DONTNEED or munmap, or whatever on the back
> > of that. But I tend to prefer the rmap option if it's workable as that
> > avoids adding new KVM userspace ABI.
> > 
> 
> You'll still probably need the new exit reason saying "can't donate that
> page while it's shared" if the refcount tests fail. Can use David's
> iouring as example of some other part of the kernel has a reference to
> the page. I can't think of anything to do other than exiting to
> userspace because we don't know how to drop that extra ref.

Ack, I realized that later on. I guess there may be cases where
userspace doesn't know how to drop that pin, but that's not the kernel's
fault and it can't do anything about it, so a userspace exit is our best
chance...

Thanks,
Quentin

