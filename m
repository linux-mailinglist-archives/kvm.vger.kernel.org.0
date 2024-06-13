Return-Path: <kvm+bounces-19555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 605FF90648E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 09:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0275BB21031
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 07:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F518136E13;
	Thu, 13 Jun 2024 07:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z3uacQFK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59A9622
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 07:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718262099; cv=none; b=AZ0AyXI8QQnfsRHeIM43S/h2a4Jnl1OiPX6XJvXPXqyNqgZ5yqhBmBtkcOtf1VAwTgguaoOETqaHai2lXjOnIX7dhUQmQIJYteqbu0QGj3uFg7IEVnF2wuVG92dP3Tjg2SfAC25ARdODteFkKAAOBr+phLLYVvby1f7gTfxXvHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718262099; c=relaxed/simple;
	bh=nGflPj+S5UvQccF2IZArInW/ao7c5S61HaAnPLdJnxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=px5J2TibCPZ6fMEw7QPDSz+dL9KkHGIwxBFQzwfe3a3AlQsOZuUIJ7lJZsUJa1B+vD3F1OdLuETfldakwbe6zFGI656aLTOQhms4v8HPz/nYbUmmdzxWGia695hNkD8BIXQbCK5TZkwPH4k7DjHNySjpPaJfnRJEoa1fp+/u2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z3uacQFK; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718262097; x=1749798097;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nGflPj+S5UvQccF2IZArInW/ao7c5S61HaAnPLdJnxE=;
  b=Z3uacQFKrGzblpi9gxPmerL1G0Y3CpjLDHPjFXN2q1cZvjg89N7ZaO5W
   jhM4qvzc7u6ugeq4m+qGthw5N5btJroAuZfOVltdcRpJwIgnV1RQj8e3c
   DIgpHsy7gATSg1A3khAiTmX+AaQMaBBTrF6iyE+Y+VQS8iYtGF8n+ZkeY
   /4vj0vSCpbLgQkJKmH9pbVn4e4idpHMiIp9CsYyViww5QG1uvWLA+2oG/
   AytdDeerNl0NMCiuh21Jhtc/0uH/rvS9bePnDBteAVsu6fZcR0iVw8Euh
   c8ZMaL+ecuSd2GsTHh2BrotmbfsVPPFMTU1M6HOD+EoN57YZyikg1XWfI
   A==;
X-CSE-ConnectionGUID: 5c+RWc+cTfKioPN8acl+Rw==
X-CSE-MsgGUID: k4/WIrKFQ5CEHSOnan3whg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="15290737"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="15290737"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 00:01:36 -0700
X-CSE-ConnectionGUID: m7uUozA2QJaigpRY+VqlnQ==
X-CSE-MsgGUID: TrREHAvaTV6AvTb8sn2Y3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="45173204"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 13 Jun 2024 00:01:36 -0700
Date: Thu, 13 Jun 2024 15:17:05 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] i386/cpu: Add support for EPYC-Turin model
Message-ID: <Zmqc8SjlgRlpgoBw@intel.com>
References: <cover.1718218999.git.babu.moger@amd.com>
 <a4d4eaafb69d855a5c5d7dec98be68b3e948cefb.1718218999.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d4eaafb69d855a5c5d7dec98be68b3e948cefb.1718218999.git.babu.moger@amd.com>

On Wed, Jun 12, 2024 at 02:12:20PM -0500, Babu Moger wrote:
> Date: Wed, 12 Jun 2024 14:12:20 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH 4/4] i386/cpu: Add support for EPYC-Turin model
> X-Mailer: git-send-email 2.34.1
> 
> Adds the support for AMD EPYC zen 5 processors(EPYC-Turin).

nit s/Adds/Add

> Adds the following new feature bits on top of the feature bits from

s/Adds/Add/

> the previous generation EPYC models.
> 
> movdiri            : Move Doubleword as Direct Store Instruction
> movdir64b          : Move 64 Bytes as Direct Store Instruction
> avx512-vp2intersect: AVX512 Vector Pair Intersection to a Pair
>                      of Mask Register
> avx-vnni           : AVX VNNI Instruction
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  target/i386/cpu.c | 131 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 131 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


