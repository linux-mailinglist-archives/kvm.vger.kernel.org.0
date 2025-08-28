Return-Path: <kvm+bounces-56143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9E4B3A6BA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 18:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 448C317256D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 16:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05730326D50;
	Thu, 28 Aug 2025 16:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3OqgxH/p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9045322C89
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 16:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399437; cv=none; b=H7zq3cb9ApFJ6YnwrYzsqwE6NFNROcLQrMzutS+EGMSYkR4IPCHsQwuHrDJCWURkZrpOfwwPgvkMQEhgtBvriZCS/JyURwsOWQApWruvcrOYJzO0Oi5tMWnOiRE4Xj1AsTtdEtgjF81X1E9hk62lIrJe4Gw7vGnBNxtApk82E4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399437; c=relaxed/simple;
	bh=6Cdpiq+Zzg2lIGGkSRD5WELvl2nCdU/wD6GSA161iwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIDJcJrszedUvPXRTJ1ztKHpCI/cgbh2OzmoYO1bRVe/3ErSJhQTvyIUhj6T7WxZqTdoS0xTh412GuufCU5WFm5ZSooFekHMrYzdY7DfwF6qMrFGJ0kABAtRqSx8/h5y4UhNk8+DNxV1O/4DwqEm/S6mVUu/kW5JpTU9OKOnmyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3OqgxH/p; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-771f69fd6feso1431656b3a.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756399435; x=1757004235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8blEVa85dDyW3Z+dNJYIvBsar0sKOxqyFeme/7/E2N8=;
        b=3OqgxH/p2MzgnY18PSwphDFbRw6d6d8bEy4K7zAIqLoc6YYRceBwp/cnm6aF4KZ3eW
         X9P1F49y4/8PT8Ueymb01YZNyYtFNwLbueJAZcAG6eX6b2q0SxIQOlwC5X1Xiv0VsC1M
         mWOHj63rMzKch3tqWAVHUeFMTy5N+IcxI9zIdjCkXiocHNsre6jYjZ0qYNZ5vmpQjxmP
         AIqvN3Zr+r0Qsxrvssvr7KK7GtBgXXCsWHnULomo0HJP9+Uhs1AkSMqsKUnzS8w5LTeI
         +Pbm9kfeVBYpZUsoQGphY/tMlb8II6aSn6mETtX9//DtfjCJdyQhyadkqYQHzScaei5s
         CqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756399435; x=1757004235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8blEVa85dDyW3Z+dNJYIvBsar0sKOxqyFeme/7/E2N8=;
        b=p/AzKJuwEzKU3YzH2jOtKcW8Jyaxe1EYkJjx9gK9M6CCc1aOX5fPGj3olnGND0/X3F
         a9aJ+5DP6w5SxiE0uFIieEqBzAhYA9/3hGyzkizkjrghBSJkSzmaDuwC2zPS79A1GFT6
         OvTpAiYLgw0c0GFKrb89zN9zYrBqodosUkUAv+DbVZ6oRv6ome94htBwRFy2cY1Llxul
         m8v9NvTPqTTz2O/cscEZgpLnudc5PLfvLHBQn7gebswzd/NAVcbfxyAk/6TtIyC2rgCd
         gXKqglOvidTiF/uEkFS0DoN3XQitg4mPu2QcO9nAccDt14zLpF1aULLZOIEGcv54YClW
         5aWA==
X-Forwarded-Encrypted: i=1; AJvYcCWiwJPehVEOxqcXD8FggY8UD0nkquqjqnMMu871slTSAraD2bIAbvEFE1fVDnQKB0Fm7PE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+m2H+DfPDupmCTZ5MHEHOd/pR4ybDs3/xKnBMVvjFZadv65l4
	BEkjUc3ooQb3jGB/RfhSWKeGD9l7F1A1uMYtSUL5ptMuI6EIDfzlNy2a0ECrndlq7ZMl8xKR+Z4
	VUiVgNA==
X-Gm-Gg: ASbGncubGZhrnaTvxX4fnCfSBkfCdxfjctun9s7RauM6BbJSAcV+yiDWG499b7/dBLr
	Iot3pEQnlFMOZP3I0pasBWlyfUZUr/lqoj5zVj3qXOfS/lhhOeoUBCFOUzWTqkMNScBxg7SQHuH
	vtvcHG7jCHraVVD7k97m5N9rpuEKhKRo06TtwIC4UfehAIpTnA9ToUQzqngVF07WZz+Nb1Y55em
	8GM/o0KRBAwAJXi00jo0i5Q4qtEM8tB87+Ma/uIpBBzmyIlBHLoKennwzheaFk1eRIroj1m3Ypq
	YrlZ89b0+Eg069tGMOMWz0ZgDkrXg1gtzslriByCRcuqwX9dJpVYac6vTsKeboJ303DEUnosabm
	GAj5Ky80ekTam9mNDPZaChjN4fC/D56rG7j5iFW9c2Kdkw4nVAlvIEuQJLpNq5dtTADvv9WVMkq
	nNfdMDzYg9ta+0SGbjY0f9
X-Google-Smtp-Source: AGHT+IFMy7ShxWIeqlyJjwrda2ndy0stFzll0/vMdsdQ1HiUhQJpb1uUs9R19cFwupqaIiTdJVYSvw==
X-Received: by 2002:a05:6a00:391a:b0:748:fcfa:8be2 with SMTP id d2e1a72fcca58-7702fa09c17mr33404597b3a.2.1756399434797;
        Thu, 28 Aug 2025 09:43:54 -0700 (PDT)
Received: from google.com (13.42.168.34.bc.googleusercontent.com. [34.168.42.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040021393sm16523940b3a.49.2025.08.28.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 09:43:53 -0700 (PDT)
Date: Thu, 28 Aug 2025 16:43:48 +0000
From: David Matlack <dmatlack@google.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [awilliam-vfio:next 5/37]
 tools/testing/selftests/vfio/.gitignore: warning: ignored by one of the
 .gitignore files
Message-ID: <aLCHRCKsPTFQfTOD@google.com>
References: <202508280918.rFRyiLEU-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508280918.rFRyiLEU-lkp@intel.com>

On 2025-08-28 09:18 AM, kernel test robot wrote:
> tree:   https://github.com/awilliam/linux-vfio.git next
> head:   9f3acb3d9a1872e2fa36af068ca2e93a8a864089
> commit: 292e9ee22b0adad49c9a6f63708988e32c007da6 [5/37] selftests: Create tools/testing/selftests/vfio
> config: i386-buildonly-randconfig-001-20250828 (https://download.01.org/0day-ci/archive/20250828/202508280918.rFRyiLEU-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250828/202508280918.rFRyiLEU-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508280918.rFRyiLEU-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> tools/testing/selftests/vfio/.gitignore: warning: ignored by one of the .gitignore files
> >> tools/testing/selftests/vfio/Makefile: warning: ignored by one of the .gitignore files

The warning is that tools/testing/selftests/vfio/.gitignore and
tools/testing/selftests/vfio/Makefile are both ignored by an existing
.gitignore file. That .gitignore file is
tools/testing/selftests/vfio/.gitignore:

  $ cat tools/testing/selftests/vfio/.gitignore
  # SPDX-License-Identifier: GPL-2.0-only
  *
  !/**/
  !*.c
  !*.h
  !*.S
  !*.sh

This .gitignore is designed to ignore everything but directories, .c,
.h. .S, and .sh files. One-off files can be added with git add --force
and then git will track any changes to those files automatically going
forward (even though they technically match the .gitignore file).

I stole this approach from the KVM selftests but it looks like they hit
the same warning and decided to add their one-off files to their
.gitignore file to squash the warnings [1].

I will send a similar patch to fix squash this warning for VFIO selftests.

e.g.

diff --git a/tools/testing/selftests/vfio/.gitignore b/tools/testing/selftests/vfio/.gitignore
index 6d9381d60172..7fadc19d3bca 100644
--- a/tools/testing/selftests/vfio/.gitignore
+++ b/tools/testing/selftests/vfio/.gitignore
@@ -5,3 +5,6 @@
 !*.h
 !*.S
 !*.sh
+!*.mk
+!.gitignore
+!Makefile

[1] https://lore.kernel.org/kvm/20240828215800.737042-1-seanjc@google.com/

