Return-Path: <kvm+bounces-40160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD71A501CD
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C89A3B2EDD
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6850C24EF70;
	Wed,  5 Mar 2025 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BXhOeUp0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D090724EAB3
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741184506; cv=none; b=LZNaVPXym1i92rm/kBOx9BjuOaZzPoHXdB0YzM1ceBdP+NPbaqxiSG8LOMz9bIEpdPKk1NDqjDxME51w94diUB2E7JC8Musml78o7ojV8s8vJJsS9iI5HZhkn1RhkF7TWwbhgt5TKlmQLn9AoWrOyK3HSaP49bdVQ0N3GTeNT4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741184506; c=relaxed/simple;
	bh=bnMfchWzPl1XtUrU0nbIzpEbDv6J0UZh8/s9tPzJ42w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQQI6JqDdZtAHYJcN/+fha3HpUg/ehBuDd5PIgAamRAkS2cjCV+KP84zp5eVPr2G9kcvB3hJIT+qUxpWVbTixBtD4l48HWeMEyAdkjyiNTG9DfdFZrAPvZiD7fynz4mXCG3TD+uhAf2zx3C9oCpZ1d7cekC3GxJvtd8rHZ0dyV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BXhOeUp0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741184505; x=1772720505;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bnMfchWzPl1XtUrU0nbIzpEbDv6J0UZh8/s9tPzJ42w=;
  b=BXhOeUp0yRksht3u+UsSLuJXBBpKjOMD7n6HB+A/MWAkLd6OL3GhRT4X
   tQupWtjFNOnqXKcts4XHMphKx36e/b0HgV92B63fzGXgW87mghqEv1Dko
   5csMV83/iojn6E4D8pVMlsJtytW3FOynUBjePMsGOo0kiXqiCYdGCKVWr
   +I/DMhECjJjC1wBjeNiJg8cQuzmFSM/Xc0llhFoiycmJrtMAHR7kMIOLB
   afU28OPSHRNdZ98gRcBX5+GgYP6kpUSIK5ndQ7XxN8GOyanYTmm6nS1Mi
   1zqxrCrhKe/SyUCTdYbzi2r0wtU7Z7VrOYaYX/AHDd3+UVuGBWs8A1EBG
   Q==;
X-CSE-ConnectionGUID: 3+DdYLX4SROl6zilkBaMFQ==
X-CSE-MsgGUID: JigxCbw6RiymqHLou2Eq5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42277008"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42277008"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 06:21:44 -0800
X-CSE-ConnectionGUID: efI84FRRROWbVW0d+MOEfA==
X-CSE-MsgGUID: NvbSPA3CQ7mmchWuqvw1/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118623962"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 05 Mar 2025 06:21:40 -0800
Date: Wed, 5 Mar 2025 22:41:47 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, pbonzini@redhat.com, mtosatti@redhat.com,
	sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
	like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, davydov-max@yandex-team.ru,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
 "-pmu" is configured
Message-ID: <Z8hiqwz4ExgWfRFR@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-5-dongli.zhang@oracle.com>
 <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com>

> > +        if (has_pmu_cap && !X86_CPU(cpu)->enable_pmu) {
> 
> One nit, it's safer to use
> 
> 	(has_pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu
> 
> Maybe we can rename has_pmu_cap to pmu_cap as well.

Yes, I agree.

Regards,
Zhao


