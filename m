Return-Path: <kvm+bounces-51399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF633AF6EB1
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16F057B7AB4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7352D8764;
	Thu,  3 Jul 2025 09:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fTcv9w52"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314AF2AEFE
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 09:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751534960; cv=none; b=paLTqwsN2v3jeBcjup13iz33KEHMx8WV5AXxTD3HX0YeL5iZdl+jMJSt5FM1xFu5boYoSbbfGF2PH27Z2XsO0ZJwoLskRv7XN+7r3Uz8uPDtavJfoO+RtWRn1qCyRNfAvQ/L/A0/Fnfx6Zh8JGQ5WbdlO6zXt8Nj4T2+uGgeZ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751534960; c=relaxed/simple;
	bh=ijzOyRlzRuGT8K9zduFWb5GhLsh+3pquTSXdSyo3KXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwOx+38RixD0ft7fksHWYk5oibZaKJ/s+0vZ9RUxuTH4XNTTooZAXU+jYC43HPR6oBfhln3xZV1bSYuHQncYiGhYZOw66V61qzETp5psavYp54jSROula1aP6QpGD3NxHktMC4iN/1blQjUHBd24HUNMZQgT9YnKgsDWvRlV8zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fTcv9w52; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751534959; x=1783070959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ijzOyRlzRuGT8K9zduFWb5GhLsh+3pquTSXdSyo3KXA=;
  b=fTcv9w52s1OMvlwnjqSXe+ez0r4exnEYRbhFO38ZAiOfWu7BpCiPcl5e
   fobYmSoSMsuD3llHqqXUgXVp8DWOvUq9L1j0L/ynwgv3LRgjPwDD0+7p/
   rN4ITzFZLjuQEqYemsdfgfLjQ6HUhF/a4j5sfEw+PE9WsJfDQk0ft3l41
   Zy2BRcQli5eG/eOSL3PbyfcA+A6y3wdxZZSOMIlH0yGZivXEa4wG/173v
   JpFN3OV851FtsiZZ5Wr+hx+r8LKjwoKQTT5iA5AJ3tEBgbHgU1Mx/XfJn
   rat3+vhSIiXn4v7/tVBkPA7qDjOD5Qbtes+Nvfusr8gN56R4P103s/J9b
   A==;
X-CSE-ConnectionGUID: 2xhIwEp+TyaKE6HbWHPaHA==
X-CSE-MsgGUID: U1XfX7zNT/eBwOl4yFbX3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="52971887"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="52971887"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 02:29:18 -0700
X-CSE-ConnectionGUID: GAmz6M2bQWqgqR73+kMVsg==
X-CSE-MsgGUID: fxxOalVvTEq6W1ob+TuUzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="153748766"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2025 02:29:14 -0700
Date: Thu, 3 Jul 2025 17:50:39 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 16/16] i386/cpu: Use a unified cache_info in X86CPUState
Message-ID: <aGZSb+OM1b7k46gy@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-17-zhao1.liu@intel.com>
 <3d1f5698-1936-4fc0-af04-db900f0d1b9e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d1f5698-1936-4fc0-af04-db900f0d1b9e@linux.intel.com>

> Nice clean-up patch series. Thanks.
> 
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 

Thanks for your review and effort!

Regards,
Zhao


