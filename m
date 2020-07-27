Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9935722ECF5
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgG0NQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 09:16:43 -0400
Received: from 4.mo173.mail-out.ovh.net ([46.105.34.219]:47765 "EHLO
        4.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgG0NQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 09:16:42 -0400
X-Greylist: delayed 8409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2020 09:16:41 EDT
Received: from player695.ha.ovh.net (unknown [10.110.171.227])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 3B64D1487A6
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 11:38:40 +0200 (CEST)
Received: from kaod.org (bad36-1-78-202-132-1.fbx.proxad.net [78.202.132.1])
        (Authenticated sender: clg@kaod.org)
        by player695.ha.ovh.net (Postfix) with ESMTPSA id 8891A14979797;
        Mon, 27 Jul 2020 09:38:33 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-101G0045a1d8947-986f-459b-a880-f86db548c305,F8FE5446E6A712E1B8ADD27A8D09714C92F8C0F3) smtp.auth=clg@kaod.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: increase KVMPPC_NR_LPIDS on POWER8
 and POWER9
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20200608115714.1139735-1-clg@kaod.org>
 <20200723062016.GE213782@thinks.paulus.ozlabs.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <848f132c-eb13-fa80-6637-e52f90296b99@kaod.org>
Date:   Mon, 27 Jul 2020 11:38:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200723062016.GE213782@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11573969568935545789
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepfeffvddtudegieefudeugffhjefgieegieegleettdehgfeiieevueeihfegfefgnecukfhppedtrddtrddtrddtpdejkedrvddtvddrudefvddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileehrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/20 8:20 AM, Paul Mackerras wrote:
> On Mon, Jun 08, 2020 at 01:57:14PM +0200, Cédric Le Goater wrote:
>> POWER8 and POWER9 have 12-bit LPIDs. Change LPID_RSVD to support up to
>> (4096 - 2) guests on these processors. POWER7 is kept the same with a
>> limitation of (1024 - 2), but it might be time to drop KVM support for
>> POWER7.
>>
>> Tested with 2048 guests * 4 vCPUs on a witherspoon system with 512G
>> RAM and a bit of swap.
>>
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> 
> Thanks, patch applied to my kvm-ppc-next branch.

We have pushed the limits further on a 1TB system and reached the limit
of 4094 guests with 16 vCPUs. 

With more vCPUs, the system starts to check-stop. We believe that the 
pages used by the interrupt controller for the backing store of the 
XIVE internal tables (END and NVT) allocated with GFP_KERNEL are 
reclaimable.

I am thinking of changing the allocation flags with :  
 
	__GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC

because XIVE should be able to fail gracefully if the system is 
low on mem. Is that correct ? 

Thanks,  

C.
