Return-Path: <kvm+bounces-11474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D688776D9
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 13:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 330F01F2135E
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 12:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23EB28383;
	Sun, 10 Mar 2024 12:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h4NmWHIa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793043224
	for <kvm@vger.kernel.org>; Sun, 10 Mar 2024 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710075189; cv=none; b=TwBpkxB6NU6rj8pjGTz++033ijLX9okev5/69rE6MgjqB+CLFDXh1AwDQJ+jMtH2KXaxa7fEwGcOx5iQ0sfvp3tScfclMVK7xsL82lBNt4P6Di7LvYNclMCAZxptMqkf9Y/S6yhc6F8vKmCwBo0o2l28jUQhEOr/ILdZbdTc3ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710075189; c=relaxed/simple;
	bh=TYTcQj1A/fM7oNSSxxcY/WHjT95T4Jq6+zVNKfGrpZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkB+8aav3kQ6VckS3iDgm9wrlyE2TVae5zmpg8dDxWV2KoQMZ4VHfIkeExmbuK/uH8tMp9DhtzoGpXVN/rCYP1WBmgb4APaXXMvquy0JqQELxh7ZWWnceMyqYxITegOcVFBb0/xmqveEsnIC2WZ+fRgXnob+iXi0UaPuOUbflqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h4NmWHIa; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710075189; x=1741611189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TYTcQj1A/fM7oNSSxxcY/WHjT95T4Jq6+zVNKfGrpZw=;
  b=h4NmWHIaPy6u2+z1FIB9DYP10VBixkT7vr0CplehmkHnkstXejkTnBRO
   4B16xTkkDyDsVUh9Fgylf8bpGN5YT/GN5x6MsymUY9WiLXEENP41HVtLq
   jukQV6A2d9yHd9nd3eZnVdDIMJew92F66COqBoaITcVdal2RV/i5yTqYe
   YaldEAZlko/8dEiBuJP7OXCegx6uhYJeDke4zMIVuTO6u9ON9tDXb72Xx
   D6A4MSqTlmiGOsmKrQbEbvSmf+q7fAThetYeFmaqYZsPgyC9Cavktdoak
   83WJuOHDh+eNsLvNPYAGrAzkoWHaO0E1t2VH6c/ycXvZxBRtW9tfzZVw+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11008"; a="16151831"
X-IronPort-AV: E=Sophos;i="6.07,114,1708416000"; 
   d="scan'208";a="16151831"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 05:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,114,1708416000"; 
   d="scan'208";a="11348901"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 10 Mar 2024 05:53:03 -0700
Date: Sun, 10 Mar 2024 21:06:51 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
Message-ID: <Ze2wa7YH+eVRyaTL@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <17444096-9602-43e1-9042-2a7ce02b5e79@linaro.org>
 <ZeuyN8Eacq1Twsvg@intel.com>
 <d58b22bb-43b4-42aa-8ed2-1975beb1f31c@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d58b22bb-43b4-42aa-8ed2-1975beb1f31c@linaro.org>

> I dropped this 4 patches in favor of "Cleanup on SMP and its test"
> v2 (https://lore.kernel.org/qemu-devel/20240308160148.3130837-1-zhao1.liu@linux.intel.com/)
> which seems more important, to get the "parameter=0" deprecation
> in the next release. (Patch 2 diverged).
>

Thanks! This series will continue to be refreshed and rebased on the new
master code base.

Regards,
Zhao


