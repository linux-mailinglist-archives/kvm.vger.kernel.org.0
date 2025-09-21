Return-Path: <kvm+bounces-58343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 795D4B8E646
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 23:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B97116DAE8
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 21:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3608248F66;
	Sun, 21 Sep 2025 21:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJ9+T1Pk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3C418BBAE
	for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 21:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490300; cv=none; b=n6MEaes+jT3Kg4s4JaO9rLHVV6TyAoNQiHV/IvOzl2rHUKyU+ZQNJt+IX6sNB/41DYNqiZ1tfB6tkOmiNs/+aX6B4OyVix+n8DiFc38saQZB74k53BZpgvrDMJT7FRjpy92j8MD9VaV8xZB7iogYl/3OOrd2WTawF9WS1A9ZyRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490300; c=relaxed/simple;
	bh=zqT1TnahnRM17p1/i8bRil1o0nqomS89t3+MM6Zthw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZ5LBSWsAJe+pzhgGQtjVBDEONgqIuDZGj+nGWoMg5HESJwru2xc+j+kpPGQF8MeNsqfZVMVMnrdXyC9y4WVe1RMKhzFGh7xbtZXoGJRQfO5sOZs4PSnfoVsNFCeWhT1eWfgXB4CDYw5XMw1LHbKvOusHVidye41bdeAabAbPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJ9+T1Pk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758490298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vMzJv7FtrWlT5/pOKIu9OWpMHtet5A15OykeYCUitfw=;
	b=cJ9+T1PkJBAoX5+ZxiY2mqjdupbesqD52UdfxaJ1M764Bk9LJ+pkVtQEGnVM+NSFFd7SwV
	SQSCPU325iUvSQnEXDR5MeBA63Hu4m11rynEXZoQ5/cDieHVFz6S2cB2iekgi/dpYedluZ
	t+ocY53W7HOKIy/ZY6x4RwUpyDoQa8U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-hXrECI4yMlq9-c0KvIIcRQ-1; Sun, 21 Sep 2025 17:31:30 -0400
X-MC-Unique: hXrECI4yMlq9-c0KvIIcRQ-1
X-Mimecast-MFC-AGG-ID: hXrECI4yMlq9-c0KvIIcRQ_1758490290
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so33494215e9.0
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 14:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758490289; x=1759095089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vMzJv7FtrWlT5/pOKIu9OWpMHtet5A15OykeYCUitfw=;
        b=jsfJQZA8SCWmA4R/vt816hJ9gz2zRepInzj+qgRnxOjDycTt3uUocr7VuEoepYqQdK
         WHkB4UkNSWJwU7H02Az5VKUIIgJG/F92UT/qDsdyNce78BaqEaE520/6MuDieWiNdccM
         zPRCludNprN0nt1DjzWXgVTX+3M4Rwss2HikoyxAc2GQ4/49kZRGQhlo6qDBnaQwQ5NM
         d1NOyKiemtNqUCpCeOpDutAcpd8PuaqdCjDNdt8lJn1ozGuCh3C6CIutrAfGfyh+uo6D
         ZS3ApEpC6UoPQtkY3kQ51pJ3Jh/oQ/de215OGTLSAdOZtKBsZh1GzFpzRNsNxaT1MmlK
         sS1g==
X-Forwarded-Encrypted: i=1; AJvYcCXi8Bg0JPOj6HHU2MSk/RXHqBHyRkva5uoKFW4HRkTc8nFBjiRf0mvBC+nN0x8lQoD+c8c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc96tIbQ+PWd75btJxvpokeGptHM5oZBk11CVPUhwCeMJ5CFKD
	K9nKlJ6BBDG8aqohqeRnDwOOcgAf1TEyIGB39jVTER+z9ghqwNOpvaOjs6ssJ+r9WS1wDa5tZvM
	xPCPQOam0jNkq9FpgVVZrqgV8ZfgxsJFB2jw9UNbzKApqXrQokudxJOoiG14c+g==
X-Gm-Gg: ASbGncsmKfnpwMib6F1Fi8rFhpXmsfkaT0GMc+sAUp+fRTQ5QOCPxzArC/OLD5P8ugt
	KJERIQ5swhw8cExGqUn++7C5wUhK1AHNzmQIJ5tCtoheEk5EE/LkgWhMwpnWnls8l73rLBeTSmh
	ee/ep2KY6+j8oCKWbP9tO9iRTmE6yVV8ZOAuLl5S4uqD1sFiFqUXSikbNs3wzCNE6umjEE9GetJ
	xlAybl7Ffd3yf+WuNcWwitKwBUYIg4hNim7+KMB7UN+fjAzVNe3xBw5Mw5ZKoICOEngMpUeICPo
	Mggm3fw1KvjjBN0acm4dAkBWzg2uc78sExs=
X-Received: by 2002:a05:600c:a43:b0:45d:f7cb:70f4 with SMTP id 5b1f17b1804b1-467e6f37f06mr92245425e9.13.1758490289245;
        Sun, 21 Sep 2025 14:31:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnBRTWDkC6y2pA+1GqSrUmiizkLbPjFI1ya/MytaZ7T1ocVq1gR43EQYG+wvlvwojzYCFD3w==
X-Received: by 2002:a05:600c:a43:b0:45d:f7cb:70f4 with SMTP id 5b1f17b1804b1-467e6f37f06mr92245285e9.13.1758490288758;
        Sun, 21 Sep 2025 14:31:28 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46138695223sm217767975e9.5.2025.09.21.14.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 14:31:28 -0700 (PDT)
Date: Sun, 21 Sep 2025 17:31:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org
Subject: Re: [mst-vhost:vhost 41/44] drivers/vdpa/pds/vdpa_dev.c:590:19:
 error: incompatible function pointer types initializing 's64 (*)(struct
 vdpa_device *, u16)' (aka 'long long (*)(struct vdpa_device *, unsigned
 short)') with an expression of type 'u32 (struct vdpa_device *, u16)' (aka
 ...
Message-ID: <20250921173047-mutt-send-email-mst@kernel.org>
References: <202509202256.zVt4MifB-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509202256.zVt4MifB-lkp@intel.com>

On Sat, Sep 20, 2025 at 10:41:40PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   877102ca14b3ee9b5343d71f6420f036baf8a9fc
> commit: 2951c77700c3944ecd991ede7ee77e31f47f24ab [41/44] vduse: add vq group support
> config: loongarch-randconfig-001-20250920 (https://download.01.org/0day-ci/archive/20250920/202509202256.zVt4MifB-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 7c861bcedf61607b6c087380ac711eb7ff918ca6)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250920/202509202256.zVt4MifB-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509202256.zVt4MifB-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/vdpa/pds/vdpa_dev.c:590:19: error: incompatible function pointer types initializing 's64 (*)(struct vdpa_device *, u16)' (aka 'long long (*)(struct vdpa_device *, unsigned short)') with an expression of type 'u32 (struct vdpa_device *, u16)' (aka 'unsigned int (struct vdpa_device *, unsigned short)') [-Wincompatible-function-pointer-types]
>      590 |         .get_vq_group           = pds_vdpa_get_vq_group,
>          |                                   ^~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 

Eugenio, just making sure you see this. I can not merge patches that
break build.

> vim +590 drivers/vdpa/pds/vdpa_dev.c
> 
> 151cc834f3ddafe Shannon Nelson 2023-05-19  577  
> 151cc834f3ddafe Shannon Nelson 2023-05-19  578  static const struct vdpa_config_ops pds_vdpa_ops = {
> 151cc834f3ddafe Shannon Nelson 2023-05-19  579  	.set_vq_address		= pds_vdpa_set_vq_address,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  580  	.set_vq_num		= pds_vdpa_set_vq_num,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  581  	.kick_vq		= pds_vdpa_kick_vq,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  582  	.set_vq_cb		= pds_vdpa_set_vq_cb,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  583  	.set_vq_ready		= pds_vdpa_set_vq_ready,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  584  	.get_vq_ready		= pds_vdpa_get_vq_ready,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  585  	.set_vq_state		= pds_vdpa_set_vq_state,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  586  	.get_vq_state		= pds_vdpa_get_vq_state,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  587  	.get_vq_notification	= pds_vdpa_get_vq_notification,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  588  	.get_vq_irq		= pds_vdpa_get_vq_irq,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  589  	.get_vq_align		= pds_vdpa_get_vq_align,
> 151cc834f3ddafe Shannon Nelson 2023-05-19 @590  	.get_vq_group		= pds_vdpa_get_vq_group,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  591  
> 151cc834f3ddafe Shannon Nelson 2023-05-19  592  	.get_device_features	= pds_vdpa_get_device_features,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  593  	.set_driver_features	= pds_vdpa_set_driver_features,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  594  	.get_driver_features	= pds_vdpa_get_driver_features,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  595  	.set_config_cb		= pds_vdpa_set_config_cb,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  596  	.get_vq_num_max		= pds_vdpa_get_vq_num_max,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  597  	.get_device_id		= pds_vdpa_get_device_id,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  598  	.get_vendor_id		= pds_vdpa_get_vendor_id,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  599  	.get_status		= pds_vdpa_get_status,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  600  	.set_status		= pds_vdpa_set_status,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  601  	.reset			= pds_vdpa_reset,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  602  	.get_config_size	= pds_vdpa_get_config_size,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  603  	.get_config		= pds_vdpa_get_config,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  604  	.set_config		= pds_vdpa_set_config,
> 151cc834f3ddafe Shannon Nelson 2023-05-19  605  };
> 25d1270b6e9ea89 Shannon Nelson 2023-05-19  606  static struct virtio_device_id pds_vdpa_id_table[] = {
> 25d1270b6e9ea89 Shannon Nelson 2023-05-19  607  	{VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
> 25d1270b6e9ea89 Shannon Nelson 2023-05-19  608  	{0},
> 25d1270b6e9ea89 Shannon Nelson 2023-05-19  609  };
> 25d1270b6e9ea89 Shannon Nelson 2023-05-19  610  
> 
> :::::: The code at line 590 was first introduced by commit
> :::::: 151cc834f3ddafec869269fe48036460d920d08a pds_vdpa: add support for vdpa and vdpamgmt interfaces
> 
> :::::: TO: Shannon Nelson <shannon.nelson@amd.com>
> :::::: CC: Michael S. Tsirkin <mst@redhat.com>
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


