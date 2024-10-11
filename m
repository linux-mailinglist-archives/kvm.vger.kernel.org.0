Return-Path: <kvm+bounces-28599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F22999B87
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 06:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 597FB1C22529
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393FC1F8F0E;
	Fri, 11 Oct 2024 04:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TQCgUruZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54D71F7066
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 04:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728619839; cv=none; b=CRBo2q7Y91/mayMPzEUI+xT/MmEB6H4HqtGfocZ9enJOFnbi2kguQrIJF4nZttGvreEsUQsV63OUW0pU1VYFtY/b9iSgfaQY+kHMNdFxu52n7JW5znTXt9AKHFYRBaM7sO/4J4P4Ur3qVe+xePlcCuwcafGD8CTsCvF+T9DkpjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728619839; c=relaxed/simple;
	bh=1/9IbvcCKr/LtNuIs/Iznb4k26xfPWBZPLg3lqDiGcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1x/w8jkGY08meypGijDjax6f6DAjw0adfzk/bjTBelUNT5C+QgeNqAdj+n6UGgNqkcnI9JD6B5eJFqLAB6fP3ko9RDODEYFC/4SjBPhb1Z7M49Pl0GxyHjH4GnUcsOlog07X6ugh6oxnXi+PsvcxBQQrveC7NNB7rndUcW8pQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TQCgUruZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728619838; x=1760155838;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1/9IbvcCKr/LtNuIs/Iznb4k26xfPWBZPLg3lqDiGcM=;
  b=TQCgUruZIjRPiW3e7zVM8aKxBgu8xaLHqJ+E7u6kP2ldxPrl78cZ9Yuq
   QbxdFJ4ODDBBRAIBiClLLcSJPvozN0UOsQo5ydZAUz96/SR6Nowv3wKpT
   PYfrZIbztOE0cq+NQSmhhaD0tPddbSGELgx2XIGwmXOz2+gVL2DBVpQ7W
   lOJ3rq2VIydOZyaWXcBqzICSCCQup+LvEvkSsVdoPSFDqCi5chca74g38
   nURhlG7E1NBgnh6gt5IOMvzoucppjDt7ow3zL4qmH7pyZFIS6+0HibrZZ
   atpgeQP2cn41cmztM7LGi963SzzypuYmCFt0+PJtAYfW6wbCPA5w9l3xL
   Q==;
X-CSE-ConnectionGUID: 17E7gouSTeCYb5yBASnrMw==
X-CSE-MsgGUID: vWMD7oG8QGK9Qv67GibGfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="28139369"
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="28139369"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 21:10:38 -0700
X-CSE-ConnectionGUID: 7JHGESgXTF+n5Br4daG9FQ==
X-CSE-MsgGUID: fJKpLolVRP6j4OTd2wvn4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="76443078"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 10 Oct 2024 21:10:35 -0700
Date: Fri, 11 Oct 2024 12:26:48 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Gao Shiyuan <gaoshiyuan@baidu.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, wangliang44@baidu.com
Subject: Re: [PATCH v2 1/1] x86: Add support save/load HWCR MSR
Message-ID: <ZwipCPXYcyUHm8k9@intel.com>
References: <20241009095109.66843-1-gaoshiyuan@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009095109.66843-1-gaoshiyuan@baidu.com>

On Wed, Oct 09, 2024 at 05:51:09PM +0800, Gao Shiyuan wrote:
> Date: Wed, 9 Oct 2024 17:51:09 +0800
> From: Gao Shiyuan <gaoshiyuan@baidu.com>
> Subject: [PATCH v2 1/1] x86: Add support save/load HWCR MSR
> X-Mailer: git-send-email 2.39.3 (Apple Git-146)
> 
> KVM commit 191c8137a939 ("x86/kvm: Implement HWCR support")
> introduced support for emulating HWCR MSR.
> 
> Add support for QEMU to save/load this MSR for migration purposes.
> 
> Signed-off-by: Gao Shiyuan <gaoshiyuan@baidu.com>
> Signed-off-by: Wang Liang <wangliang44@baidu.com>
> ---
>  target/i386/cpu.h     |  5 +++++
>  target/i386/kvm/kvm.c | 12 ++++++++++++
>  target/i386/machine.c | 20 ++++++++++++++++++++
>  3 files changed, 37 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


