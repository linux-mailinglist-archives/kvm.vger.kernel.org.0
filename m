Return-Path: <kvm+bounces-10829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0CC870B98
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D6281C22773
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D7E7B3DE;
	Mon,  4 Mar 2024 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGsyHqRP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00C15FF0E
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709584061; cv=none; b=rmzES8lG06a/ok/c4RQjF09P8oLQuRHkUUAe/3Bi4wDFYPv+XLtG0+DpYNo0+stjic5ZXo5skh4iTHW86aX+hpMes9EGTkQO+uVZ9y0J9hSbSTH4R68ls1DOLP2DnbKlwTz64l3g3Klj7lVzAcDIl52PvABzCZBJ1ln7JBS1Kw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709584061; c=relaxed/simple;
	bh=E4Y+jYp9vWBypjxdtdA622/MXqA7JiGJ8aj/k58DLlI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVUxTONurEqGo8RvYfhZU2kQDZiAPdouYM6HuNrFi4QAxwA+X8/CHZ4BNf1ERh3wVtsKrzWm4DcXen9KC9z422Z0b2jluyZAIFxLjl9Jw/bjBspb2lQBQgldr4F5pkhCyJSP9fcIcbDKYL76Qlx/+KObyYb9fD7Bjbt7ZXmiFco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HGsyHqRP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709584057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVVcgRE/QddLe3v5WXQ240l1iFCe02aYVgi2FeEnepg=;
	b=HGsyHqRPeZlprqtpWVJ+UfyOmlpk0vBzjMUPE9ts1hVTZqqnEbAZgPy/dYG63ipfFZaNMe
	HBDszrTSVShbD3E59srrjV+7eiB2UJG0dljdEEbpXCn1VMZG2/QvcfByVcg1rObWpSmFGM
	I21Ibsb5OYWRzGitJwZem8uwBtk3F8k=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-5ZTHgDBVNLaSAsSrQM4uOQ-1; Mon, 04 Mar 2024 15:27:36 -0500
X-MC-Unique: 5ZTHgDBVNLaSAsSrQM4uOQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c84b3570cfso163991739f.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 12:27:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709584056; x=1710188856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVVcgRE/QddLe3v5WXQ240l1iFCe02aYVgi2FeEnepg=;
        b=KopAhFHdCA2plMQDw2LQ/2EqAlJcpytPczdWVYCu1aRbMSMLKP+gDSrRLnsYChbb+O
         ri1wzpyg0jIVcp5c6mNyaF7meyc4ODoNg0koIcoxEcGYO0Q3b1y+TgOz/tnZFPn+L9op
         zMM6u2wAOn9dK9w6cTjQfb7jyL9qXTTN1aXXE+l+I/UbxTSivGIzYjTUvZiUxbP3lC2N
         ehr7CDGUQszz5UzRj8BnOaBmxwYYx25yC3xsbBjbkRp4GbLmQ8imD3ia6AFiJU4MuWM4
         H7gPuJ3QCG6oOvM8FxwhIUf4CkBu39OBtpKmH9AGz7FtK1BuX1wWcp6ZGSUdKKJgMmqq
         Rm/A==
X-Forwarded-Encrypted: i=1; AJvYcCWS8rm4AOwilKI0G6PIykOcoj59Q+LOPIMb1Vxon8CvHRqMTNDlU+pxECuGRwvZrH9eccXl7bAJmIKMsBKOYyTGupq/
X-Gm-Message-State: AOJu0YxCsKTBkuh8YrkScLPmFYjoeaIiQCROdAaod1zmVC8IF3dW6Tiz
	Am+k/QZY2Sso8H/e+J++ud6n27uE24iWM/hYoHTukEWU042NCvhH4YDG9k9gmQsu0C6cfrhjaIm
	OoQtgRFMAN6O5JqsrlEpR/wgeccLUtZbZnxIgpNR00wIqo1g33A==
X-Received: by 2002:a6b:c9c2:0:b0:7c8:63b6:a0f3 with SMTP id z185-20020a6bc9c2000000b007c863b6a0f3mr736753iof.18.1709584055905;
        Mon, 04 Mar 2024 12:27:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAFPx6bbWNHpshukLWXh37C2p/Or/xC5GCj4PDWlahG/DaXcyk5s8zlICNfgiH/I6/FmYpng==
X-Received: by 2002:a6b:c9c2:0:b0:7c8:63b6:a0f3 with SMTP id z185-20020a6bc9c2000000b007c863b6a0f3mr736744iof.18.1709584055683;
        Mon, 04 Mar 2024 12:27:35 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id h21-20020a056638063500b00474dd9c2b21sm1452220jar.82.2024.03.04.12.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 12:27:35 -0800 (PST)
Date: Mon, 4 Mar 2024 13:27:33 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <bcreeley@amd.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvm@vger.kernel.org, jgg@ziepe.ca, yishaih@nvidia.com,
 kevin.tian@intel.com, linuxarm@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Message-ID: <20240304132733.2b7044ad.alex.williamson@redhat.com>
In-Reply-To: <eed5d95c-f447-4383-8163-1ce419cc0fe6@amd.com>
References: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
	<eed5d95c-f447-4383-8163-1ce419cc0fe6@amd.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Feb 2024 14:05:58 -0800
Brett Creeley <bcreeley@amd.com> wrote:

> On 2/29/2024 1:11 AM, Shameer Kolothum wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > The deferred_reset logic was added to vfio migration drivers to prevent
> > a circular locking dependency with respect to mm_lock and state mutex.
> > This is mainly because of the copy_to/from_user() functions(which takes
> > mm_lock) invoked under state mutex. But for HiSilicon driver, the only
> > place where we now hold the state mutex for copy_to_user is during the
> > PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
> > updated the data and perform copy_to_user without state mutex. By this,
> > we can get rid of the deferred_reset logic.
> > 
> > Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>  
> 
> Shameer,
> 
> Thanks for providing this example. After seeing this, it probably 
> doens't make sense to accept my 2/2 patch at 
> https://lore.kernel.org/kvm/20240228003205.47311-3-brett.creeley@amd.com/.
> 
> I have reworked that patch and am currently doing some testing with it 
> to make sure it's functional. Once I have some results I will send a v3.

Darn, somehow this thread snuck by me last week.  Currently your series
is at the top of my next branch, so I'll just rebase it to 8512ed256334
("vfio/pds: Always clear the save/restore FDs on reset") to drop your
2/2 and wait for something new relative to the reset logic.  Thanks,

Alex


