Return-Path: <kvm+bounces-27706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46AB298AE1D
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 22:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5EFBB24FC1
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 20:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548591A0BCE;
	Mon, 30 Sep 2024 20:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bsKOHMEA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3A1A0B0E
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727646; cv=none; b=jhvsn4ueEHct1T8ape/fGdr0jAtu1dZlU68PWR8z3+ymot3NKwSk3PLcrYSrt15djJAEMxTIS49SV+sKBwUgxvETjE8GqCIhw2Oysrev7uIwkG0TtZyrW997X4cWAp/mObERS0S2I66lo8mFDZY1WPpfCyPsWaKF9R+VOroFkaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727646; c=relaxed/simple;
	bh=bOMPmIHvBV79RsdCMJ/twS2JSTbXpQa08SrYHL+koc0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gofj0diIr0hSxg/vDqMWup2hwCs8G80KiRFJ8ZIOUZkv96rdHarZWxPSQFQ17VaMYMdP+u2aNEIVIo9GQgUAQE1lC0xthHJH5/zLF7iiMzbSeiPkv9o1m0tWbR2VRp7P9OzSQSLI+lygHXsEDR0kQ1n+lfWxN8ChDjH5pNWwXgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bsKOHMEA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xkcw94t3j20WRs3mHwczBVeXMbfcHgmN6neJP9J08Ek=;
	b=bsKOHMEAMwMmC3XQqRmw6hq4KUft7csLhVjXfzMnetNm+2hMcdOmalAGNGppBcLAf/5E4o
	l8ZN/7gq2w19jg5sDbiCv2pIIlHHaA4bzhMX3QUJgQvBJ7Ss7tI+d3r27On0YYssMWwQuu
	GmrReQXNqXh/ksGUfHaCXxAITy47xBg=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-aTBYXRd2PlmPZaun4JWDbg-1; Mon, 30 Sep 2024 16:20:41 -0400
X-MC-Unique: aTBYXRd2PlmPZaun4JWDbg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82be60b9809so39341839f.3
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 13:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727727641; x=1728332441;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xkcw94t3j20WRs3mHwczBVeXMbfcHgmN6neJP9J08Ek=;
        b=NLWaaSW3AgGrI+61tdyIVgPohDvr3xfPlPcHFyYf/aQiJI9qbFotFX3ftQW+jjhSoZ
         ToYiPYHDmAeXciEilRutrErE3E4h3GrF6HGj/4uXRVtAX682iw2mfiP/yPL40BbU3su1
         MyJyEyAPOduuCVlfWQHb1L7uIt5GoEFd22MXu2kakrqufRCHBn8lF6PO8apSCnrRyQCn
         7+Ouwx0rnqrr05APQcCNEAlBeb5F61DCwejoxY2838y6eLhtfcCYLUZKJqQw2FYYQeQj
         U7gaSOdlys4SF9nXV+4Vjp3smKlJi60Cvg4KwasjBN+reh5GLEWo7IwoUVeIKRX5H5Zr
         D2TA==
X-Gm-Message-State: AOJu0YzHJdStCsmb/tDl0+mnGz5uYO19YQvIo1jmIvi80WonwX41tEDm
	q9Gvh4G1shJfKu0OKXGQGZtB+aO4y2k8kEPyI1ya6se2ezPxJbb+hSAzfYJWP5QHyU5ikqEn48E
	faQR6qf7f7T3LZD9dh/WpVolEmxJRqXUp7ZaBrxBxKTGfaWDw5w==
X-Received: by 2002:a05:6e02:13a3:b0:3a0:8fb0:7a2a with SMTP id e9e14a558f8ab-3a34b4ac126mr20193195ab.3.1727727641231;
        Mon, 30 Sep 2024 13:20:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAWJbz5K/I4awdXoMsoaDT8ZQs4FT9DHSRQe2Ntp91u4IjmmGZXHmuHgqFOMNjHzd3W/bUUQ==
X-Received: by 2002:a05:6e02:13a3:b0:3a0:8fb0:7a2a with SMTP id e9e14a558f8ab-3a34b4ac126mr20193145ab.3.1727727640925;
        Mon, 30 Sep 2024 13:20:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d82ac7sm26731865ab.23.2024.09.30.13.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:20:40 -0700 (PDT)
Date: Mon, 30 Sep 2024 14:20:38 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: kvm@vger.kernel.org, Laine Stump <laine@redhat.com>, Kirti Wankhede
 <kwankhede@nvidia.com>
Subject: Re: Can class_compat usage in vfio/mdev be removed?
Message-ID: <20240930142038.11e428cb.alex.williamson@redhat.com>
In-Reply-To: <8c55ce81-6b0a-42f5-8e05-5557933ca3b8@gmail.com>
References: <8c55ce81-6b0a-42f5-8e05-5557933ca3b8@gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Sep 2024 09:57:23 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> After 7e722083fcc3 ("i2c: Remove I2C_COMPAT config symbol and related code")
> vfio/mdev is that last user of class_compat. This compatibility functionality
> is meant to be used temporarily, and it has been in vfio/mdev since 2016.
> Can it be removed? Or is there any userspace tool which hasn't been updated
> to use the bus interface instead?
> If class_compat can be removed in vfio/mdev, then we may be able to remove
> this functionality completely.
> 

Hi Heiner,

I'm afraid we have active userspace tools dependent on
/sys/class/mdev_bus currently, libvirt for one.  We link mdev parent
devices here and I believe it's the only way for userspace to find
those parent devices registered for creating mdev devices.  If there's a
desire to remove class_compat, we might need to add some mdev
infrastructure to register the class ourselves to maintain the parent
links.  Thanks,

Alex


