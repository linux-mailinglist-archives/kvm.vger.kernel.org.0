Return-Path: <kvm+bounces-10181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D13286A65E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9320AB2575A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BB61AAC9;
	Wed, 28 Feb 2024 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uiqoy951"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCBB6FC2;
	Wed, 28 Feb 2024 02:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709086159; cv=none; b=KLvMHpFPBVspRa2fliaUZoC7mcb9PzPyeyiKIiI1z5dddpSA/CSWMxxCm2deWHgl4Euvg9iVy33Z6jd2i4FkdQxcNGSDr/bVqq6c/mzbtkp54804KFguOui8V6OOAcies/XeoBVbj53W09GODhaVy9SmeUi33npKhqRMX38hQ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709086159; c=relaxed/simple;
	bh=0DQmT55dUdZ8tiOQrwKl5y2K39m88JTMIB8bGRpyc04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XNgmss0VONYSeTMxVE5c/5l6G3buSML1HesQxHMXSfUna50Glqer+QL18H7mn63GSiC7pVkmSq0zZL85yGpjC8xOHcCu/g6ahiL2mO+sIvubHd9hvaE0LESBK1tNtTbSAjKpukkYZznfuqxuTtdmrmd/jY4d+9zTRkLlFJQACbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uiqoy951; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709086158; x=1740622158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0DQmT55dUdZ8tiOQrwKl5y2K39m88JTMIB8bGRpyc04=;
  b=Uiqoy951XWsU+/DDFxqx9qkPNJAlw9kPJVTpPEnTBfQeExAMNihTc1NS
   +YbsbVyi4jIXUL3KFV3/EJe1WCaIpyY7H4iEqPe8mNaCV8GNEmzLROCtI
   xdBZkGOc5nTfD1/QEugdkcHnHhnz2auIjem8aTWTsvL4OOghK7vsTbI3m
   85gh68nkRzPkJ5BhQ8nFjOhWxdxum2keDXuslysKNpbdTmuHUFkqwiMh7
   sTmT7G2Dh1TYGEu/fTV2V3ucuDmWYOcp30q/RuEjKuKwpXbXwLMZHg4WE
   +ckPR4ud6W9qKqKh47z6v6Rm5oiN219uQc/3nic5Fj6F37bgnHnexqXi9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="20918577"
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="20918577"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 18:09:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="7623520"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 18:09:14 -0800
Message-ID: <32d54391-c29b-440d-a90a-ed39d6795fd9@intel.com>
Date: Wed, 28 Feb 2024 10:09:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/21] KVM: x86: Split core of hypercall emulation to
 helper function
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-2-pbonzini@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227232100.478238-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> By necessity, TDX will use a different register ABI for hypercalls.
> Break out the core functionality so that it may be reused for TDX.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <5134caa55ac3dec33fb2addb5545b52b3b52db02.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

