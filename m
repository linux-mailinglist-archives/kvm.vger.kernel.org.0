Return-Path: <kvm+bounces-51539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F1AAF8731
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 07:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 368F25480E6
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 05:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EF61FBEB0;
	Fri,  4 Jul 2025 05:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EUFkg7tR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957A11F8755
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 05:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751606754; cv=none; b=rbtReNNRHnymyOklE98jJ5UHUlk+ypKB8lM4TxgEbhrhNpRe0YNFda5wpJ4KzZDG6UbWXQi+FTtRBfFYNyl1g0oYBJY6bLfxivO/HzYYzXodSh8ioL/oJSvpl8hIl4xLOo2GKU2L0XUKbRNWIBmLV5urPUDfupNINWElrWSfZoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751606754; c=relaxed/simple;
	bh=Y8KLvXPonrRqtBHQQRecaJVFF8I82/dnoB5RT+uLyws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GeDovtEkq3gvkMnKY5yOTTh4q88AIWxgFc6bQBpaFvFkNBSRYHrWR5bUi0xAyfcitE3zTWLmjLkCCPLQurtNjHQwzcXHUgIFYLA/0YW+TXwVcfJ+7EJLWWOEyihu1+AvqbVGyDLz3p6ygYcM6UjvHS8S9ujlhhC9dfVUvuTMrPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EUFkg7tR; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751606753; x=1783142753;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y8KLvXPonrRqtBHQQRecaJVFF8I82/dnoB5RT+uLyws=;
  b=EUFkg7tRYfAlOLDHdKIala+0/AuBbaQwvJeIRcW1DZNYksWlUvNb5s38
   z1Ggrk9SojDZWxRA3dc0xXB1IxhCzT/FMfMX9qmoh9GCqEuUrDbkenXw5
   Td22YZL42Ozl+oHOqeRnkCRHRepACy0xGl4a+uM4VrPRruQH5MhAyRtRh
   Q46TOHC92QYmVgTTya65sVy+OlaT6qgzDlnD20rCiS66Wf7AjnX2ymcGC
   AqxhlX/+RXtBr50psouoFqVYLLHQflGaQJ+g9e77rQfV6aNfjG1GjeIE2
   fbHvJDLApJFnkOBX4ZstyzTYrD44N9wSUw7OGh938GqPB9sff1zMTiZRc
   A==;
X-CSE-ConnectionGUID: 3GudGE4ASvGrSxJ9kJnpQA==
X-CSE-MsgGUID: vsrIcV1ISo6cEuWVC9eozQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="57712969"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="57712969"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 22:25:52 -0700
X-CSE-ConnectionGUID: qTBgox/ESaKWV0DXoLhXng==
X-CSE-MsgGUID: rVgbMKKyRfylaqCgU0uQMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154921543"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 22:25:35 -0700
Message-ID: <e7e930af-8b27-4d3a-b693-b451b22ca1b0@intel.com>
Date: Fri, 4 Jul 2025 13:25:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/39] accel: Move supports_guest_debug() declaration
 to AccelClass
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Alexander Graf <agraf@csgraf.de>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-13-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703173248.44995-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
> AccelOpsClass is for methods dealing with vCPUs.
> When only dealing with AccelState, AccelClass is sufficient.
> 
> In order to have AccelClass methods instrospect their state,
> we need to pass AccelState by argument.
> 
> Restrict kvm_supports_guest_debug() scope.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


