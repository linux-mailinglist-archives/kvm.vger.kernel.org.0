Return-Path: <kvm+bounces-44782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A178AA0E5C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC6A17AEC7F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FEEA2D4B70;
	Tue, 29 Apr 2025 14:10:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B5D2D29B1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745935800; cv=none; b=mnSSMizTkVXx9xAN+4GezFKZ1kC7PN1KGH10TIOQ6NtT6BV9tRt2Ztg5eCOcbfmRHonaWeDdYvJigrXLASejEsnp5PGVVYq/dZFIJyiqVMUZZP3fu2QDwOIIgtI7AJD55E2s8PIKI/4RXgJidSs+qMRpbqIroKHlu2Cc6TSYfPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745935800; c=relaxed/simple;
	bh=7ilE6Mulu69YDl0t29ldX0rUe0mYNOb23tG+PTX5YIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MxMX26d42/fLEhhaqe0rvc0yCllJQkfcAv+X/XxPcuy+CtQZnie35Zhp+cYU3Aq8rb4pRbiwrSXd0he9yWI4CUy+esgOCAlJVfyCr1ylMp1wNzj6uZe3lXbGwkgOGh1V/pAKegXqaBtN1uiuEXtDy2oyM9MuGguJ8AdeYHrVBVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00A291515;
	Tue, 29 Apr 2025 07:09:51 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5E293F66E;
	Tue, 29 Apr 2025 07:09:55 -0700 (PDT)
Message-ID: <69211539-5ffa-45ad-bd19-25e8bcd6eccc@arm.com>
Date: Tue, 29 Apr 2025 15:09:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/42] KVM: arm64: Unconditionally configure fine-grain
 traps
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-25-maz@kernel.org>
 <363383a2-c05e-458c-82b7-acc6e5d73939@arm.com> <86h627hyby.wl-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <86h627hyby.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 14:49, Marc Zyngier wrote:
> On Tue, 29 Apr 2025 14:08:27 +0100,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>>    -	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR_EL2);
>>> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>> Don't we need to continue considering the ampere errata here? Or, at
>> least worth a mention in the commit message.
> 
> The FGT registers are always context switched, so whatever was saved
> *before* the workaround was applied in __activate_traps_hfgxtr() is
> blindly restored...
> 
>>> -		write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
> 
> ... and this write always happens.
Thanks for the explanation. I now agree this code is correct.
> 
> 	M.
> 

Thanks,

Ben


