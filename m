Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACED69CDCB
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfHZLKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 07:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbfHZLKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 07:10:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7C3A2A09AA;
        Mon, 26 Aug 2019 11:10:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E22F71001958;
        Mon, 26 Aug 2019 11:10:00 +0000 (UTC)
Date:   Mon, 26 Aug 2019 13:09:58 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
Message-ID: <20190826110958.lyueasf5laypkq2r@kamzik.brq.redhat.com>
References: <20190826075728.21646-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826075728.21646-1-peterx@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 26 Aug 2019 11:10:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 03:57:28PM +0800, Peter Xu wrote:
> The dirty_log_test is failing on some old machines like Xeon E3-1220
> with tripple faults when writting to the tracked memory region:
> 
>   Test iterations: 32, interval: 10 (ms)
>   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
>   guest physical test memory offset: 0x7fbffef000
>   ==== Test Assertion Failure ====
>   dirty_log_test.c:138: false
>   pid=6137 tid=6139 - Success
>      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
>      2  0x00007f3dd9e392dd: ?? ??:0
>      3  0x00007f3dd9b6a132: ?? ??:0
>   Invalid guest sync status: exit_reason=SHUTDOWN
> 
> It's because previously we moved the testing memory region from a
> static place (1G) to the top of the system's physical address space,
> meanwhile we stick to 39 bits PA for all the x86_64 machines.  That's
> not true for machines like Xeon E3-1220 where it only supports 36.
> 
> Let's unbreak this test by dynamically detect PA width from CPUID
> 0x80000008.  Meanwhile, even allow kvm_get_supported_cpuid_index() to
> fail.  I don't know whether that could be useful because I think
> 0x80000008 should be there for all x86_64 hosts, but I also think it's
> not really helpful to assert in the kvm_get_supported_cpuid_index().
> 
> Fixes: b442324b581556e
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Andrew Jones <drjones@redhat.com>
> CC: Radim Krčmář <rkrcmar@redhat.com>
> CC: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 22 +++++++++++++------
>  .../selftests/kvm/lib/x86_64/processor.c      |  3 ---
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index ceb52b952637..111592f3a1d7 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -274,18 +274,26 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
>  #ifdef __x86_64__
> -	/*
> -	 * FIXME
> -	 * The x86_64 kvm selftests framework currently only supports a
> -	 * single PML4 which restricts the number of physical address
> -	 * bits we can change to 39.
> -	 */
> -	guest_pa_bits = 39;
> +	{
> +		struct kvm_cpuid_entry2 *entry;
> +
> +		entry = kvm_get_supported_cpuid_entry(0x80000008);
> +		/*
> +		 * Supported PA width can be smaller than 52 even if
> +		 * we're with VM_MODE_P52V48_4K mode.  Fetch it from

It seems like x86_64 should create modes that actually work, rather than
always using one named 'P52', but then needing to probe for the actual
number of supported physical bits. Indeed testing all x86_64 supported
modes, like aarch64 does, would even make more sense in this test.


> +		 * the host to update the default value (SDM 4.1.4).
> +		 */
> +		if (entry)
> +			guest_pa_bits = entry->eax & 0xff;

Are we sure > 39 bits will work with this test framework? I can't
recall what led me to the FIXME above, other than things not working.
It seems I was convinced we couldn't have more bits due to how pml4's
were allocated, but maybe I misinterpreted it.

> +		else
> +			guest_pa_bits = 32;
> +	}
>  #endif
>  #ifdef __aarch64__
>  	if (guest_pa_bits != 40)
>  		type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
>  #endif
> +	printf("Supported guest physical address width: %d\n", guest_pa_bits);
>  	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
>  	guest_page_size = (1ul << guest_page_shift);
>  	/*
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 6cb34a0fa200..9de2fd310ac8 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -760,9 +760,6 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
>  			break;
>  		}
>  	}
> -
> -	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
> -		    function, index);
>  	return entry;
>  }
>  
> -- 
> 2.21.0
> 

Thanks,
drew
