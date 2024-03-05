Return-Path: <kvm+bounces-10971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 287D6871DC2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 586A21C22BC1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB905D75D;
	Tue,  5 Mar 2024 11:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6ssC5xC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C6B5A796;
	Tue,  5 Mar 2024 11:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638059; cv=none; b=WK/XVkOaRTHNwSrV0jG+H/PBB8yqHljVAt7eRHrp6p25dsxGYZXCHWvZPCKtRrZC8idbduSuJnhs6CpciHdl/pFCo1OhBF+HztSFHVCE6t/YYcJLTqXnuwfZnljaX7sSYrThwTX+ci3kGwZPZthhjZu94I9gLyz4ywKd5GMSynM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638059; c=relaxed/simple;
	bh=71g9qi5Belzj0Qm+IHK6UQxAPbvhY2FQyghQGiogSW8=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gwpnmiY9di4bWbwF1RLEL6hn5tjh1sClFYHFjzRg134C+mx1ZMV2o/kwQ1Yhd51zkkFEHgFyeBP3EwIBRzNPX8ipNjf4A00aL7ZD5L8HVCGFoLnBzccnli6CQRTslK7aFt5f5ylnW1PdGRsajQS3XYqRz+qhdwvVXCD2VaTjxbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6ssC5xC; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709638058; x=1741174058;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=71g9qi5Belzj0Qm+IHK6UQxAPbvhY2FQyghQGiogSW8=;
  b=R6ssC5xCrZmPr6U4+SEsIOFlQ38uiiPuY+j+WRm5OVdFDkS67lk5QAvq
   gkMQZnRDrscHRT7rnTy4Ic7os0Yu52/znz7sU8GUdZ9fXfJ7JQz9TDl0f
   gyAb0K0m3bTBDTGCn9HeEKsI2NIHOFBhyaRlvz3/wryDF0XOLK8oJ7B1b
   o7XOhvUcIjcWf8cuf5xCrcnXVrOHP/p5+lisWk7XFYOwru8DGlFdtBmVZ
   DhQswR6xIlOvdGop6mJPTXVm6TDZex6IFwxdiqjk0BjZ9GlN9URCY7Z0w
   aImMTLsAe+OtSicash5Q3Jk7LYiV6WtuXifWIIJD0oIMSuSuF51CYM2Iq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4109498"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4109498"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 03:27:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14007135"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.246.51.37])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 03:27:30 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 5 Mar 2024 13:27:25 +0200 (EET)
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Johannes Berg <johannes@sipsolutions.net>, 
    Hans de Goede <hdegoede@redhat.com>, Vadim Pasternak <vadimp@nvidia.com>, 
    Bjorn Andersson <andersson@kernel.org>, 
    Mathieu Poirier <mathieu.poirier@linaro.org>, 
    Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
    Vasily Gorbik <gor@linux.ibm.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
    Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org, 
    platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
    linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH vhost 3/4] virtio: vring_new_virtqueue(): pass struct
 instead of multi parameters
In-Reply-To: <20240304114719.3710-4-xuanzhuo@linux.alibaba.com>
Message-ID: <0cbf4910-ec0c-4b06-681e-aafae3720455@linux.intel.com>
References: <20240304114719.3710-1-xuanzhuo@linux.alibaba.com> <20240304114719.3710-4-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Mar 2024, Xuan Zhuo wrote:

> Just like find_vqs(), it is time to refactor the
> vring_new_virtqueue(). We pass the similar struct to
> vring_new_virtqueue.

Please write a proper commit message here and do not just refer to 
some other commit to describe what's going on here.

-- 
 i.


