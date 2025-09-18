Return-Path: <kvm+bounces-57962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E4720B82A7B
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 04:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B395E7AFA39
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 02:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0237238C03;
	Thu, 18 Sep 2025 02:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GApQrjC5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308ED25761;
	Thu, 18 Sep 2025 02:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758162476; cv=none; b=Cn/sV+VopHM322FXiK7xkf7kg4xK8jUyJDaev2VI4dmqxn52aDVQ20Bd6qCC52oQV9FeS2aX9ZMz5KC7dvZ7icvRs59nc6nGW+7GBKKpo9WrnS3XLpr8o5MCzo8XHcxaZhVvJV1Y06y8Gcxy5RInd/XaTcgbMeOm2ZHtAVvckzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758162476; c=relaxed/simple;
	bh=py1ye7UcWQnNNC2kBpDm+JZuVxmAhYWxWDYmxnXr1OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZYEfWbtz9BVwbd/DHva/XVoevqnAiRajT7an4o/i9rISnK1GZ0k0EoQLarvNM7eaAjmwMk5Ts3zi1s7ZsBYslsGDV4ffga5zAReVYmVug0Mh8bVTPaZnrRGAYBFsvqChDX3aVJxd//DRODV7YMBhIIumrzRXFi/Q/BqGoptufc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GApQrjC5; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758162475; x=1789698475;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=py1ye7UcWQnNNC2kBpDm+JZuVxmAhYWxWDYmxnXr1OE=;
  b=GApQrjC5wOs96UMn2VB3S5a9p17Q1TK74jy4eUOVHlFrSH057jPmr0uJ
   E2XCc3p1SlZ6WbaMQts9MGwLeyPhOs6P5o+LpTaYr3yRQlngzyxYvJNzb
   Wq5Atq3Cd0j8HpP+Y3tmFA7YqOfl5s1/KW0HYGLdHfJqn/T+CXX5hVuSR
   ImVFznQ9jB16Hdv325nkE7jI92f/GLIdkp6Rgas+hvD9oGry7h6/pyxp2
   C2BDEQgANuAXF8Gvd0WLlt8V3H4IotinpHbk7+JyvW7pNu3vQiw6Cn5OJ
   RPqo/+TnnWugjIWC/ZeHSfsgTeiXnty1lWaUQsvT8D5k5h9P89UVXWPJL
   A==;
X-CSE-ConnectionGUID: l5d6DpvGQj6MRVXiTQ8izw==
X-CSE-MsgGUID: akx+3pSCRh+nDHBsMlio7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60369209"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="60369209"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:27:55 -0700
X-CSE-ConnectionGUID: 0mbqQlEjSS2qwe0/PSTsWg==
X-CSE-MsgGUID: VKbBcGukR5e1wzaUw2Fp1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="180690148"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:27:51 -0700
Message-ID: <22b922ba-c1ec-46c8-94f4-c65fc84ee9fe@linux.intel.com>
Date: Thu, 18 Sep 2025 10:27:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 20/41] KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for
 L1 event injection to L2
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-21-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Per SDM description(Vol.3D, Appendix A.1):
> "If bit 56 is read as 1, software can use VM entry to deliver a hardware
> exception with or without an error code, regardless of vector"
>
> Modify has_error_code check before inject events to nested guest. Only
                                       ^
                                    injecting
> enforce the check when guest is in real mode, the exception is not hard
> exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
> other case ignore the check to make the logic consistent with SDM.
        ^
       cases
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


