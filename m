Return-Path: <kvm+bounces-20514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD359175EE
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 03:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67E601C2141A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 01:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D338C14F62;
	Wed, 26 Jun 2024 01:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eigubmSy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CBD1D530;
	Wed, 26 Jun 2024 01:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719367108; cv=none; b=WOz2APMI7zMXiRvm6fcchysqqdUqtXuhlLuJp4ns337+gInF2cljQ3zwok8zw3JffbxA0ArdccBLsfizc/BSDARNTIG7quFtPgfsFZVG6QDVJ7uj3uAtPNDTsxbXa0IQ0tdJmbULKJ3OgAT6zNI1jzyq5uSwGdm6W/x9uHAXfn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719367108; c=relaxed/simple;
	bh=BGJQ/NML6MG7AsyBe/Q9WpGnnYFAdXDeS+xVeOQIm78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f1awu1mrJponW9c0VVYLVK9vXGG3mVx5JYUoH3Ii82y7dGyYpCZN5i8biUrhivzvys088E2wmVKiv2FECiMVnr2vR6UlVPukrvr4V2Pakh3qpmVUd1j9lRUjHtNpX2eKhzO3K7oerAUEoV3jwsFcHeHwCciXPHvpNd8ofyZLORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eigubmSy; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719367106; x=1750903106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BGJQ/NML6MG7AsyBe/Q9WpGnnYFAdXDeS+xVeOQIm78=;
  b=eigubmSybISWNiLODzxHCxs2jEQtVlRzkR9VuarN+Sj6GAg+PXNrHCbh
   MfC8TjyeZIvc5noRJEAqvZ7di6mcxZMiLeuzjmVv46iFgdi8IQA2lK7NF
   end7ionBfRM8WRf3PFMwa3xy5QdGnS/SBqEZRFEqVwd5qeFduwtaxsPt2
   fXozeertB19lONd1VrHwHA/cqnXrQdbIpFICkdfWn2GSmHY9iM36N1+ui
   dfazOl8YcE5JEVXwo3ZtfNRl+UpY7FYGbrc7z2gZUGUuV1TiT4QKv3jFG
   ieOwYhHW0GciSja1XUOwYOOJY8GUmi0EulqbARly1jpYHc4fTYQz1DjJs
   g==;
X-CSE-ConnectionGUID: I9eqvD76T0utrZQySrihyg==
X-CSE-MsgGUID: kVpgRXM5Rde9VybSz2sSQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16562230"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16562230"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 18:58:25 -0700
X-CSE-ConnectionGUID: chjdGxvsQN+UmJeaoxT1uA==
X-CSE-MsgGUID: 9cGUqliyRFKvqz2e9fJp8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="44273252"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.232.203]) ([10.124.232.203])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 18:58:04 -0700
Message-ID: <b2824879-113a-4214-8bd0-f8f71bd18735@linux.intel.com>
Date: Wed, 26 Jun 2024 09:57:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests: kvm: Reduce verbosity of "Random seed"
 messages
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yi Lai <yi1.lai@intel.com>
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
 <20240619182128.4131355-3-dapeng1.mi@linux.intel.com>
 <ZnRxQSG_wnZma3H9@google.com>
 <ee06d465-b84b-4c75-9155-3fa5db9f3325@linux.intel.com>
 <ZnWAMqimqze1a12H@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZnWAMqimqze1a12H@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/21/2024 9:29 PM, Sean Christopherson wrote:
> On Fri, Jun 21, 2024, Dapeng Mi wrote:
>>> --
>>> From: Sean Christopherson <seanjc@google.com>
>>> Date: Thu, 20 Jun 2024 10:29:53 -0700
>>> Subject: [PATCH] KVM: selftests: Print the seed for the guest pRNG iff it has
>>>  changed
>> s/iff/if/
> "iff" is shorthand for "if and only if".  I try to write out the full "if and only
> if" when possible, but use "iff" in shortlogs when I want to squeeze in more words.

Good to know. Thanks.





