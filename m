Return-Path: <kvm+bounces-55751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F42B3691C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F3E11C83756
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 14:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43083352FFF;
	Tue, 26 Aug 2025 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nAPUFENF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98013343D63
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217628; cv=none; b=aDB9OA32ZTekeh9nxsWSwfT9eQSPKvJpRQEwBhuZP9AWobMS00q2LaJk05ToeCj0VBYVPxnImPzs4WkT4aK9z8gMCLL7OaHnK5YYtXwYFqlX02ZlaCm6T9ufH82QOqo9p8cL2CtfHIgasF5i9AiueyjzOMU5FFWvlVjsNksqDxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217628; c=relaxed/simple;
	bh=XUMwyANYoN9LqU5IRvdqCPCHLe1EThn+0cki44O6i8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRHvlruEVMEF2dq1QO5j1Rc+ECboT/bhYQCmo2F6QZR2xNM+6XzTZ6zSU6qO2PA5SXQwjyV6oBKjqtk9zEKaWZeY7Z5oAX7e4900wgfxj2TFrIHcQuOIua2ChrTTV8iW358vVND2Y5ZGh6m1THlg2G2AZXfhSkwMHjopUPwppUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nAPUFENF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756217627; x=1787753627;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XUMwyANYoN9LqU5IRvdqCPCHLe1EThn+0cki44O6i8E=;
  b=nAPUFENFi5wQbdA6MZkkQUb1r4K6zk/h47KcuAd5nD4TLbmrKoppa3l2
   o0wfRZM9MJ0gwlYtl+qVfe0wlo1QFZ4nmamHsX9O+v9B/daU5zBFfYoBL
   ljt6ZFnMxTpKyYmX37vnuxqrlPT9JZAbWLJqn+Mc5RHQfmuanGBJ1vEcp
   5zmpDImF0/qdcFWOmTeUIup6Sqy0GoK7NeT39zf4jP4GFCbro7RhjVzms
   kbPJK4oYRZpcUPN0vPl1uvxGWIp48VjZ8bTGnuhrq/vQUzYVUzNJDxqkc
   N7F54e4qH+6gH1PbesBFgEqqfS57mXzYOv6nZ1haQnQmVEgK63IWZBoiy
   Q==;
X-CSE-ConnectionGUID: tRVcgkSDTLaf1Vhh9lMi/w==
X-CSE-MsgGUID: clAHoCvRRUGzqoysU+KH0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="68725305"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68725305"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 07:13:18 -0700
X-CSE-ConnectionGUID: fkmkoWmdQxWzwXBvKrPNZw==
X-CSE-MsgGUID: TdnUtjC3Qo2ip6ZvO42CCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="173753410"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 26 Aug 2025 07:13:16 -0700
Date: Tue, 26 Aug 2025 22:35:02 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, richard.henderson@linaro.org,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to
 kvm-all.c
Message-ID: <aK3GFpAxCuTWfjEn@intel.com>
References: <20250815065445.8978-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815065445.8978-1-anisinha@redhat.com>

On Fri, Aug 15, 2025 at 12:24:45PM +0530, Ani Sinha wrote:
> Date: Fri, 15 Aug 2025 12:24:45 +0530
> From: Ani Sinha <anisinha@redhat.com>
> Subject: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to
>  kvm-all.c
> X-Mailer: git-send-email 2.50.1
> 
> kvm_park_vcpu() and kvm_unpark_vcpu() is only used in kvm-all.c. Declare it
> static, remove it from common header file and make it local to kvm-all.c
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c  |  4 ++--
>  include/system/kvm.h | 17 -----------------
>  2 files changed, 2 insertions(+), 19 deletions(-)
> 
> changelog:
> unexport  kvm_unpark_vcpu() as well and remove unnecessary forward
> declarations.

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


