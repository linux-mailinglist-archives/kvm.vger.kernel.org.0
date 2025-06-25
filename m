Return-Path: <kvm+bounces-50605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75157AE74D5
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 04:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CE13189BD9A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 02:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149561B042E;
	Wed, 25 Jun 2025 02:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="FaEtC4PR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C8E156F45
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 02:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750818592; cv=none; b=ITahdfFhiUU4Fv6yBq7HMMRrDV0e/Zthi7gxW4VR6eLnXjw8Ofsd8Sf7DCF0mIEY4K8+NjthmMZna2X6GIZbn4Z/sk0fFTC38TylQ46CooNh9haBsJkhsqkyGiXkRSUOaKosz2BW0VAK31dwNk817Z3aa2fYBSZuxZg0g/vhd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750818592; c=relaxed/simple;
	bh=Ackd6oL4QEZhNsdWFDsaCVzCrTRV/Pf/z7DouQ0Gs5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYz0a3XgsPFXtTzDL6mMrSn8vplruZP++fBwCBzlHZeq/TwIBS8i5Z/w8sBDgF7Ec/pkKvHGoMVJALp2lWVPeTVAUOrSkuZINv9+3/QQVEfaPva7A6jeAX4d78+K5IDG3JN5n19SotTP/b9tV7Pqs1chep6TlrkIsFJ4iN7nIPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=FaEtC4PR; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7490702fc7cso554622b3a.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750818590; x=1751423390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRoBVr301Z32U1U+wNWEV8kI1I28cFbSqrPbaNR/5yE=;
        b=FaEtC4PR0e/+kCEZrQqIngn7iPIeonQIqX4lHfs8Ia4lG4Fl4FJKylBFFHvynwJ26q
         rrNZVbzMpcdkCTlMPFo/HlbEF36fytlifbMBut6luG0v0MW5dqFZr4hObsfLPN3Uoiyq
         BpPJfm1LGX8eiyVZPM5i5VsoPuq2mKMDRNVZHSsIZAvFwUW0WAnI6ypPSv/j9C6NmkhO
         jk7zMZaltA3c9AEVAn/eEHfsjfuYPIPJEUi7p769DohOEh/xkESlYyufb3qGwUp+Kiy4
         fERTIZZcwJAlbaA6PElj4VjT58nS1cZE6+6iQq2VC+DXIwMUqQy+cZZr7rPg+RAv/z2r
         H/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750818590; x=1751423390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRoBVr301Z32U1U+wNWEV8kI1I28cFbSqrPbaNR/5yE=;
        b=iaNKG0zOaxWTth3qmzlo6lm1FQtSIPVGe5z6Y1mwm5PlVjK4ECv8C4BkYWQ1nyndyj
         /DLOxwNBlH0wmhpS/1J28Db8OXsLQY85f918DH1hkvNK+OTsdKWvUMJbJPGdZexAP/Hk
         QataTFAAGflwLoPlVgXRJvC5kk3hru2d+Xfr1fhLm1eCCju3J2vn+b6wLZIbZ8WJxdm0
         pxCqEx3xs3b5HJqWKfRjgv8YzgGEcMYC+VgJ5d1dfczBxq25FYi/H14FAZuWTbJ/n3Of
         /h39M5AjZ4+yayks6+xitYtQTSowT3RjqyuDQ79smCmqtoaTwlFuEAhBDhp834VviNJO
         ZNPw==
X-Forwarded-Encrypted: i=1; AJvYcCXb/eF6PjwFqp3tem6bPgofkh/4gBrimIs3vl9EopmT6ErHAhmsckC6s9fDGLQ/lfFGA18=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMTM/WD8VOuqKPuyMN/M5nqb0Ckis6AeNaThFZg60ny3ffOT5I
	wBu0dZa0NxZq0D0VwsD3K+KAWIo7rqBRBfIoJSR9WoCjlOSF7EW8PjcU+n9WImzgyS0=
X-Gm-Gg: ASbGnctSF5mjeGoRbbVhOdsmAP/gaOjiKpswxxzaJzNTJujfzJcK705IV3MA2Vv8cUF
	bt9WvNUeTQE1Swvru4atM4kasbTeso/rkD6tlUtJ+hEqNx/hm4/LkLGoG/MCgS6LNp0rUvTWpGz
	jTCgtegf0UHVHf+6z6rHTy8H1lSAV/qlP2YtW7JZgGo+V5rBNoFx7aZfTyECKGTgfpiUtdUva3G
	e2CVAMxzOmbaNDQO/k6bOZq0YMVZtDjHOvo9TgvzYxoXz6rnjjTYRFCNvTnTaBFQydOWzMOz9qZ
	H7H4OtftPM4yRaklOpUcYy60UBdLf+oPDV6OG8jYdbAHBH1uoEvPV7tNv6X9xP22lYzbezJNpAG
	zx4auuSkzT6Td
X-Google-Smtp-Source: AGHT+IGDhzovgW8mfz1TgwEtDPLzMaEOkE7E5An9/EYwotB65YMux34Z99Rx+rpB+eyQKTmSPq1Cmg==
X-Received: by 2002:a05:6a00:2290:b0:736:5e28:cfba with SMTP id d2e1a72fcca58-74ad44d861dmr2057195b3a.18.1750818589640;
        Tue, 24 Jun 2025 19:29:49 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e08caesm3190947b3a.4.2025.06.24.19.29.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Jun 2025 19:29:49 -0700 (PDT)
From: lizhe.67@bytedance.com
To: lkp@intel.com
Cc: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	oe-kbuild-all@lists.linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v5 1/3] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Wed, 25 Jun 2025 10:29:42 +0800
Message-ID: <20250625022942.76489-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <202506250037.VfdBAPP3-lkp@intel.com>
References: <202506250037.VfdBAPP3-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 25 Jun 2025 00:23:03 +0800,
kernel test robot <lkp@intel.com> wrote:

> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on awilliam-vfio/next]
> [also build test ERROR on awilliam-vfio/for-linus linus/master v6.16-rc3 next-20250624]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/lizhe-67-bytedance-com/vfio-type1-batch-vfio_find_vpfn-in-function-vfio_unpin_pages_remote/20250620-112605
> base:   https://github.com/awilliam/linux-vfio.git next
> patch link:    https://lore.kernel.org/r/20250620032344.13382-2-lizhe.67%40bytedance.com
> patch subject: [PATCH v5 1/3] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
> config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250625/202506250037.VfdBAPP3-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250625/202506250037.VfdBAPP3-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202506250037.VfdBAPP3-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/vfio/vfio_iommu_type1.c: In function 'vfio_unpin_pages_remote':
> >> drivers/vfio/vfio_iommu_type1.c:738:37: error: implicit declaration of function 'vpfn_pages'; did you mean 'vma_pages'? [-Werror=implicit-function-declaration]
>      738 |         long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>          |                                     ^~~~~~~~~~
>          |                                     vma_pages
>    cc1: some warnings being treated as errors

Perhaps we need to compile with this patch[1] included to avoid build
errors.

Thanks,
Zhe

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/

