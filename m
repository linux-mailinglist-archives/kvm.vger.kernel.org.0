Return-Path: <kvm+bounces-20665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C88EB91BC0C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87606285870
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD81415443B;
	Fri, 28 Jun 2024 09:59:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CC8153810;
	Fri, 28 Jun 2024 09:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719568776; cv=none; b=hD6ql1+I069Kw2I3MLuOljJKqwOQQ2wwBdrSJSB2XCfgwOuJaqUotsB2Tak2DYKovvXV7uKyQtDOIAtD+fBRo7sv5plW4Lp09E82BMCYQH4y5qd/2LTsJwh750rwz+5XyFHyofPq65jmRrhqCP04ppVMtyDEwtsiMUAwY5zxwto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719568776; c=relaxed/simple;
	bh=apYPCiCCBhhW47PGckaJryPnErPTII7yZQmGkZShW+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ucs9N9QMrOOarKRs2XZ779a+W4rdkdx6My+QVfuyoUbJFkyNQugzY1Jcn738beWxlxpvOxtVQ+DfHYrJuC0mo+r9PWXCI5tTttwb3q5TtkVvlkeiyQIf0ja/ke41bNo3asHp3s4itR4vSqEHncdEampGPajplo8U6ut6vNCM7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4C1B106F;
	Fri, 28 Jun 2024 02:59:56 -0700 (PDT)
Received: from [10.1.29.17] (e122027.cambridge.arm.com [10.1.29.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 571CF3F6A8;
	Fri, 28 Jun 2024 02:59:28 -0700 (PDT)
Message-ID: <01b48dc0-8f69-435c-86c5-bc22ea148e3a@arm.com>
Date: Fri, 28 Jun 2024 10:59:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
To: Michael Kelley <mhklinux@outlook.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <SN6PR02MB415702A53E8516F1BEEC7EDAD4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <SN6PR02MB415702A53E8516F1BEEC7EDAD4CD2@SN6PR02MB4157.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/06/2024 04:54, Michael Kelley wrote:
> From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:30 AM
>>
>> Within a realm guest the ITS is emulated by the host. This means the
>> allocations must have been made available to the host by a call to
>> set_memory_decrypted(). Introduce an allocation function which performs
>> this extra call.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>  * Drop 'shared' from the new its_xxx function names as they are used
>>    for non-realm guests too.
>>  * Don't handle the NUMA_NO_NODE case specially - alloc_pages_node()
>>    should do the right thing.
>>  * Drop a pointless (void *) cast.
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c | 90 ++++++++++++++++++++++++--------
>>  1 file changed, 67 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 40ebf1726393..ca72f830f4cc 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/irqdomain.h>
>>  #include <linux/list.h>
>>  #include <linux/log2.h>
>> +#include <linux/mem_encrypt.h>
>>  #include <linux/memblock.h>
>>  #include <linux/mm.h>
>>  #include <linux/msi.h>
>> @@ -27,6 +28,7 @@
>>  #include <linux/of_pci.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/percpu.h>
>> +#include <linux/set_memory.h>
>>  #include <linux/slab.h>
>>  #include <linux/syscore_ops.h>
>>
>> @@ -163,6 +165,7 @@ struct its_device {
>>  	struct its_node		*its;
>>  	struct event_lpi_map	event_map;
>>  	void			*itt;
>> +	u32			itt_order;
>>  	u32			nr_ites;
>>  	u32			device_id;
>>  	bool			shared;
>> @@ -198,6 +201,30 @@ static DEFINE_IDA(its_vpeid_ida);
>>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>>  #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>>
>> +static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>> +					 unsigned int order)
>> +{
>> +	struct page *page;
>> +
>> +	page = alloc_pages_node(node, gfp, order);
>> +
>> +	if (page)
>> +		set_memory_decrypted((unsigned long)page_address(page),
>> +				     1 << order);
> 
> There's been considerable discussion on the x86 side about
> what to do when set_memory_decrypted() or set_memory_encrypted()
> fails. The conclusions are:
> 
> 1) set_memory_decrypted()/encrypted() *could* fail due to a
> compromised/malicious host, due to a bug somewhere in the
> software stack, or due to resource constraints (x86 might need to
> split a large page mapping, and need to allocate additional page
> table pages, which could fail).
> 
> 2) The guest memory that was the target of such a failed call could
> be left in an indeterminate state that the guest could not reliably
> undo or correct. The guest's view of the page's decrypted/encrypted
> state might not match the host's view. Therefore, any such guest
> memory must be leaked rather than being used or put back on the
> free list.
> 
> 3) After some discussion, we decided not to panic in such a case.
> Instead, set_memory_decrypted()/encrypted() generates a WARN,
> as well as returns a failure result. The most security conscious
> users could set panic_on_warn=1 in their VMs, and thereby stop
> further operation if there any indication that the transition between
> encrypted and decrypt is suspect. The caller of these functions
> also can take explicit action in the case of a failure.
> 
> It seems like the same guidelines should apply here. On the x86
> side we've also cleaned up cases where the return value isn't
> checked, like here and the use of set_memory_encrypted() below.

Very good points - this code was lacking error handling. I think you are
also right that the correct situation when set_memory_{en,de}crypted()
fails is to WARN() and leak the page. It's something that shouldn't
happen with a well behaving host and it's unclear how to safely recover
the page - so leaking the page is the safest result. And the WARN()
approach gives the user the option as to whether this is fatal via
panic_on_warn.

Thanks,
Steve


