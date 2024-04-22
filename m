Return-Path: <kvm+bounces-15463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F748AC558
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 09:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B626E282777
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDDA5029C;
	Mon, 22 Apr 2024 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fj6WlN+y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6608950289;
	Mon, 22 Apr 2024 07:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713770363; cv=none; b=PvqBWvjHfdFl5lXm5s3+giL1tEqpxab2hvczOC3C7TyvVLSIzDXGjqVJBd6Wjvgdtsj488F/rnizQf56pBBe6QNRnIGpzujtw6uHv96HlQ6GCFv0LiImymq0L8OSMeXhjOF7VniIygSwGkOpaT9Gere1lrV8Fo0lo9RsfCHjcTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713770363; c=relaxed/simple;
	bh=K5qc5KwmgiaYBZB47h7cAsEG6GuyX+Syw0Fptk1NJis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W39ZgaR3xsKhssKH2YIimi2HYNg/JUfwWegtCq1g0InjmQBK3px7/q84UoeJb0buv1aKd2tgbt2djbVskI9ZJBOISnWj4akDJ/lUX7U/S7HeTYX3dKbd4rNNpLZSTr6ugOuRt+HSxQBJwjpeV/lok7wXXgYWedJKxuhtUKgDwKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fj6WlN+y; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713770362; x=1745306362;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K5qc5KwmgiaYBZB47h7cAsEG6GuyX+Syw0Fptk1NJis=;
  b=fj6WlN+yMXA5tj/El+E0wYHZ1MqhrQsVu7UF+rsBVK5w5ooWMlD34S8l
   lQF7yC3eo2cX/+r+YCgWtLWMiNHsPgu9ZoLtXQN/iWJ9SWYnjzH3Fkhab
   0kak6LaWl6PdLvLJ9Weu8p7lOWGUrgFALAVfweuzovvHlbpEfOwXHvSSs
   ajKRdNslOJ5WaGoWC1kF5sdBcE344rvVaikMcVUKeYw9EMZMYxIO3EULq
   rKTW+/CXdQi3/kb+GtltqesB/2F+xc+NttzkZhap8SP712G4mswzEbida
   Qvi0SPtK/kdYTJBbeY+fJNxUMvD/UHoiCmoJK3REEG5TmGk5zheC9aw7M
   A==;
X-CSE-ConnectionGUID: JeIsJehlTEaoc3Dp6cVpMQ==
X-CSE-MsgGUID: SSUa4L8sR9mxXmHU1DBeTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="9123028"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="9123028"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:19:22 -0700
X-CSE-ConnectionGUID: y/nCEZqcTo68O969u14zvg==
X-CSE-MsgGUID: vvnVggrHRZenlShJvHMRKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="24371493"
Received: from unknown (HELO [10.238.8.201]) ([10.238.8.201])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:19:19 -0700
Message-ID: <b4bb3773-f7a6-46a2-9be2-6ac98bb2930c@linux.intel.com>
Date: Mon, 22 Apr 2024 15:19:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, seanjc@google.com,
 rick.p.edgecombe@intel.com
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-3-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240419085927.3648704-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add a new ioctl KVM_PRE_FAULT_MEMORY in the KVM common code. It iterates on the
> memory range and calls the arch-specific function.  Add stub arch function
> as a weak symbol.

The description is stale. The weak symbol was removed since v3.


