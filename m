Return-Path: <kvm+bounces-28876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCA799E4D4
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695852831F2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92DB1E7C33;
	Tue, 15 Oct 2024 10:57:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05F51E04BD;
	Tue, 15 Oct 2024 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728989848; cv=none; b=OOUGYe7Uv+snpw15v5JCsmWgr3p2FkXukICSci/dcBTtqqHUX2xyffDU4hTQ3Hrjt0bHf9YHlOUs8k6jsZtLUkaJ6dR3EmHX8FvyPz/ruf7lOpJQgJiq9AbsgO0o7L2yhEm84u03UkinyUnZExYublDfGW56iRGMMReMjD/FuNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728989848; c=relaxed/simple;
	bh=oL/7xt4Yqvn+9Rro4TMVQYhXaWG/t1gVhjh4J2cuoJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9Ehszijs4T1gkdod1A8W5Ua1ofSgRvMe2cecmSTkpQp6iimA/HNOWFpe/oA3s/fZaCaMQ4EdTRJl/aPSRaUIZ9lQFOvAyrjGFf9WecTtg65Itbwn26lleJ+Ruy3LZ4dcGq5Vd1xU9mUU4RVfAfuFxZH8g56P/zsFUa+YuOerKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE54D1007;
	Tue, 15 Oct 2024 03:57:55 -0700 (PDT)
Received: from [10.57.86.207] (unknown [10.57.86.207])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 020BA3F51B;
	Tue, 15 Oct 2024 03:57:22 -0700 (PDT)
Message-ID: <ba0ddcf0-c251-46a0-8354-587e49c81399@arm.com>
Date: Tue, 15 Oct 2024 11:57:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 17/57] kvm: Remove PAGE_SIZE compile-time constant
 assumption
Content-Language: en-GB
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, Greg Marsden
 <greg.marsden@oracle.com>, Ivan Ivanov <ivan.ivanov@suse.com>,
 Kalesh Singh <kaleshsingh@google.com>, Marc Zyngier <maz@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Matthias Brugger <mbrugger@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, Will Deacon <will@kernel.org>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
 <20241014105912.3207374-17-ryan.roberts@arm.com>
 <Zw2PBJsC99L4y_7c@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <Zw2PBJsC99L4y_7c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/10/2024 22:37, Sean Christopherson wrote:
> Nit, "KVM:" for the scope.

Thanks, will fix.

> 
> On Mon, Oct 14, 2024, Ryan Roberts wrote:
>> To prepare for supporting boot-time page size selection, refactor code
>> to remove assumptions about PAGE_SIZE being compile-time constant. Code
>> intended to be equivalent when compile-time page size is active.
>>
>> Modify BUILD_BUG_ON() to compare with page size limit.
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>
>> ***NOTE***
>> Any confused maintainers may want to read the cover note here for context:
>> https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/
> 
> The patch should still stand on its own.  Most people can probably suss out what
> PAGE_SIZE_MIN is, but at the same time, it's quite easy to provide a more verbose
> changelog that's tailored to the actual patch.  E.g.
> 
>   To prepare for supporting boot-time page size selection, refactor KVM's
>   check on the size of the kvm_run structure to assert that the size is less
>   than the smallest possible page size, i.e. that kvm_run won't overflow its
>   page regardless of what page size is chosen at boot time.
> 
> With something like the above,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks! I'll update this for the next version.


