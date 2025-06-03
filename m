Return-Path: <kvm+bounces-48316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCAEACCB09
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 380C83A873B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29D523D29A;
	Tue,  3 Jun 2025 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OU1gqu/X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337B231833
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748967145; cv=none; b=AkW5u+B6SJ6YF3JEdOozLZT6cNFxL8eOFp9pU/uYp6rLIxCSYcJqyk+gQMtE1Wfzbg5582EHjT2m5nbgGpiejUN6kkeDdaKg5DR7J8w60h4V5AePrm0A9X/fV3ehsqxHG7QvxPmCuodGXC/zY2v5vhKNfaniRLgIpSPFUvhnxgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748967145; c=relaxed/simple;
	bh=WOKLrG800JsNYDuenjSSGG1iYsq0yhwwkhv7Zpy4AB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mrpx0B7b27ZAH/riIRThpOD1JoJdUO7CnwpRtpuTXEY6+d7UfhBrKMZI4qUqbS1uXnuadQjpY3NDbB/XaQSpllyTOKowZgvFs8c3jJAGiI979bDpa4Yr4xTSJ9LQsHxaQ0jBefQbtlVtY/fbUEsykNcOrrLeAHbtwM/SvMYYHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OU1gqu/X; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748967144; x=1780503144;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WOKLrG800JsNYDuenjSSGG1iYsq0yhwwkhv7Zpy4AB0=;
  b=OU1gqu/XsbRemwaogyiKgEMDnp8yvc75U2SlUdnGCM1d+3qKWqydmicc
   62q2CJCeny7sDrQaGM8DCtIerQkrl6883wiCeLk0soHo14v2FQh1shRqC
   fLYNAq2JLcJpJFQVvWzky2R4NzSvv4vrPW7/faic5eUkZHHFMBOZiQer1
   jAoqrBR1j3Uxk/ATuX6yrWKqAKOecOA8L3V4NkiDapn+nnxsVefj6f3fC
   jMnFWiDd7Ln3ygPp5zZUBCpNTHCR8w8MIlCCVc6+zioBLgXXt3MQZjykt
   xxYoBhEqXfr44Ca9MjOdpyRXHPMyQOeU1d83quEmep9sBdz1i8gBJKKb9
   w==;
X-CSE-ConnectionGUID: z7TmrasuQF22/cP+bZ8PVA==
X-CSE-MsgGUID: nM/xqSdbRCOL1TH3yDfH0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61677741"
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="61677741"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 09:12:22 -0700
X-CSE-ConnectionGUID: 3jX03g1PRp2jMHqq3bZA9w==
X-CSE-MsgGUID: qrbiEWqZQAmxVHi+a8m/5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,206,1744095600"; 
   d="scan'208";a="150191559"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 09:12:20 -0700
Message-ID: <e8a4148d-9e3e-4884-8b3c-e49bb7a4cdf5@intel.com>
Date: Wed, 4 Jun 2025 00:12:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
To: Paolo Bonzini <pbonzini@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Michael Roth <michael.roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
 <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
 <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
 <d0983ba3-383b-4c81-9cfd-b5b0d26a5d17@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <d0983ba3-383b-4c81-9cfd-b5b0d26a5d17@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/3/2025 11:00 PM, Paolo Bonzini wrote:
> I'm applying Tom's patch to get it out of his queue, but will delay sending
> a pull request until the Linux-side fix is accepted.

BTW, for the patch itself.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>

