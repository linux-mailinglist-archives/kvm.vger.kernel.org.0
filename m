Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE07941FA0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406629AbfFLIt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 04:49:56 -0400
Received: from foss.arm.com ([217.140.110.172]:47638 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfFLIt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 04:49:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE6E82B;
        Wed, 12 Jun 2019 01:49:55 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BC543F246;
        Wed, 12 Jun 2019 01:49:54 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
From:   Julien Thierry <julien.thierry@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-2-marc.zyngier@arm.com>
 <54c8547a-51fb-8ae5-975f-261d3934221a@arm.com>
Message-ID: <37a7411c-e7e0-e601-b88b-c12e8ebf9861@arm.com>
Date:   Wed, 12 Jun 2019 09:49:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <54c8547a-51fb-8ae5-975f-261d3934221a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/06/2019 09:16, Julien Thierry wrote:
> Hi Marc,
> 
> On 11/06/2019 18:03, Marc Zyngier wrote:

[...]

>> +
>> +void vgic_lpi_translation_cache_init(struct kvm *kvm)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	unsigned int sz;
>> +	int i;
>> +
>> +	if (!list_empty(&dist->lpi_translation_cache))
>> +		return;
>> +
>> +	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
>> +
>> +	for (i = 0; i < sz; i++) {
>> +		struct vgic_translation_cache_entry *cte;
>> +
>> +		/* An allocation failure is not fatal */
>> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
>> +		if (WARN_ON(!cte))
>> +			break;
>> +
>> +		INIT_LIST_HEAD(&cte->entry);
>> +		list_add(&cte->entry, &dist->lpi_translation_cache);
> 
> Going through the series, it looks like this list is either empty
> (before the cache init) or has a fixed number
> (LPI_DEFAULT_PCPU_CACHE_SIZE * nr_cpus) of entries. And the list never
> grows nor shrinks throughout the series, so it seems odd to be using a
> list here.
> 
> Is there a reason for not using a dynamically allocated array instead of
> the list? (does list_move() provide a big perf advantage over swapping
> the data from one array entry to another? Or is there some other
> facility I am missing?
> 

Scratch that, I realized having the list makes it easier to implement
the LRU policy later in the series.

-- 
Julien Thierry
