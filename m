Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B3FABDB1
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 18:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388768AbfIFQ11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 12:27:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:8671 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfIFQ11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 12:27:27 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 09:27:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="174325372"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Sep 2019 09:27:26 -0700
Date:   Fri, 6 Sep 2019 09:27:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Evgeny Yakovlev <eyakovlev3@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        yc-core@yandex-team.ru, wrfsh@yandex-team.ru
Subject: Re: [kvm-unit-tests RESEND PATCH] x86: Fix id_map buffer overflow
 and PT corruption
Message-ID: <20190906162726.GC29496@linux.intel.com>
References: <1567756159-512600-1-git-send-email-wrfsh@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567756159-512600-1-git-send-email-wrfsh@yandex-team.ru>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 10:49:19AM +0300, Evgeny Yakovlev wrote:
> Commit 18a34cce introduced init_apic_map. It iterates over
> sizeof(online_cpus) * 8 items and sets APIC ids in id_map.
> However, online_cpus is defined (in x86/cstart[64].S) as a 64-bit
> variable. After i >= 64, init_apic_map begins to read out of bounds of
> online_cpus. If it finds a non-zero value there enough times,
> it then proceeds to potentially overflow id_map in assignment.
> 
> In our test case id_map was linked close to pg_base. As a result page
> table was corrupted and we've seen sporadic failures of ioapic test.
> 
> Signed-off-by: Evgeny Yakovlev <wrfsh@yandex-team.ru>
> ---
>  lib/x86/apic.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index 504299e..1ed8bab 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -228,14 +228,17 @@ void mask_pic_interrupts(void)
>      outb(0xff, 0xa1);
>  }
>  
> -extern unsigned char online_cpus[256 / 8];

The immediate issue can be resolved simply by fixing this definition.

> +/* Should hold MAX_TEST_CPUS bits */
> +extern uint64_t online_cpus;
>  
>  void init_apic_map(void)
>  {
>  	unsigned int i, j = 0;
>  
> -	for (i = 0; i < sizeof(online_cpus) * 8; i++) {
> -		if ((1ul << (i % 8)) & (online_cpus[i / 8]))
> +	assert(MAX_TEST_CPUS <= sizeof(online_cpus) * 8);
> +
> +	for (i = 0; i < MAX_TEST_CPUS; i++) {
> +		if (online_cpus & ((uint64_t)1 << i))

This is functionally correct, but it's just as easy to have online_cpus
sized based on MAX_TEST_CPUS, i.e. to allow MAX_TEST_CPUS to be changed
at will (within reason).  I'll send patches.

>  			id_map[j++] = i;
>  	}
>  }
> -- 
> 2.7.4
> 
