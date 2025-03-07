Return-Path: <kvm+bounces-40308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E080A561B0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DFDB7A8DDB
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 07:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CDF1A2632;
	Fri,  7 Mar 2025 07:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ia3ghLI+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6A431A89
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 07:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741332112; cv=none; b=UchjszInKbxzBwmGOXy7qzNkLc/kXO+okzfhxRX02xTEWMTtuzlJxv8t7FzfbwuXtJK5+0gY4ZdlfqEa4kyJLK/2z71Bp65LG5fDlvjL20r4gLvbb9BYKjVcTJhW2613z7tc/AGiYEyHilrgfpnbGJDrNvkGabNMn3EhHOJ6EJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741332112; c=relaxed/simple;
	bh=z5G5631nTIRqDdY+F3KY6G3vbEul2mSHrm5r6NEZZy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/+q74DTFGGLqY6m4i/GYaAb1nOpsrj+E64XeVpKDKuUjtHdXg8Nr2cFELK2TlIOcoMJkhnMXk6OYBhFmIGXOydUAxwwdAF3OMaKwY8Z1D2KF0ncHpEMBNirrXA8p+1lACFMXIPkTIiHtLeieBdpN3ZkVwzFKq/dIPSSwrP6wQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ia3ghLI+; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741332110; x=1772868110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z5G5631nTIRqDdY+F3KY6G3vbEul2mSHrm5r6NEZZy4=;
  b=ia3ghLI+IHCeiNoIeLHMND/JFmKHjnbvx4nkibU+NW0b1/bzMtiGcw6E
   vrTWQKFSoGETd/gz6RwXuCPFWCUb0vjx1A0FRCypWqL1k/1x/90NbW8J9
   cs23TKvcqEj9HUOMu9yKU2u8udAlboRCncjEof0ycj32Lh7rReNc0CJQ9
   qnP2XSMQFUHMC+9u2qpQ21B1Vvqt6CcN4At6LyE7hTJi2Dsuuhu2sh+/r
   CBg7ZFZDaIaJ5PKFiGWwacuy7umpDzeffCiPw6Vw29dlmph9R+WKthxAx
   4IVA1yR/1meSsI8lTXjiViHchmPapCik9TG3QS8cSG8hVeMcAizU//pFr
   A==;
X-CSE-ConnectionGUID: 3iM5z+rtSN6S7v/y4u8hCQ==
X-CSE-MsgGUID: yCdBtX5GQ+msSiJnSH3HEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46027353"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="46027353"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 23:21:49 -0800
X-CSE-ConnectionGUID: 3vpmoA5NTg6eXzieuSHKhA==
X-CSE-MsgGUID: nI9mrnhdTuOqLaOEpmJRUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="124172995"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 06 Mar 2025 23:21:44 -0800
Date: Fri, 7 Mar 2025 15:41:53 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: dongli.zhang@oracle.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is
 configured
Message-ID: <Z8qjQVem/vqcSjhw@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-3-dongli.zhang@oracle.com>
 <Z8nSPf4bUPICgf3g@intel.com>
 <483c5783-6fb3-4793-9727-2cd4263dd92b@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483c5783-6fb3-4793-9727-2cd4263dd92b@oracle.com>

> 1. Remove "kvm_enabled() && IS_AMD_CPU(env)" since the bit is reserved by
> Intel.
> 
> 2. Add your Reviewed-by.

Yes, this is exactly what I mean!

Regards,
Zhao


