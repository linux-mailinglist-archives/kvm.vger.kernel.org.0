Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D7AA00F5
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfH1Lsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 07:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfH1Lsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 07:48:47 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B790F30014C6;
        Wed, 28 Aug 2019 11:48:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45B3B5D772;
        Wed, 28 Aug 2019 11:48:40 +0000 (UTC)
Date:   Wed, 28 Aug 2019 13:48:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Create VM earlier for dirty log test
Message-ID: <20190828114837.2dx5lj6pen2mq2lh@kamzik.brq.redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827131015.21691-3-peterx@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 28 Aug 2019 11:48:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 09:10:13PM +0800, Peter Xu wrote:
> Since we've just removed the dependency of vm type in previous patch,
> now we can create the vm much earlier.  Note that to move it earlier
> we used an approximation of number of extra pages but it should be
> fine.
> 
> This prepares for the follow up patches to finally remove the
> duplication of guest mode parsings.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 424efcf8c734..040952f3d4ad 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -264,6 +264,9 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
>  	return vm;
>  }
>  
> +#define DIRTY_MEM_BITS 30 /* 1G */
> +#define PAGE_SHIFT_4K  12
> +
>  static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  		     unsigned long interval, uint64_t phys_offset)
>  {
> @@ -273,6 +276,18 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	uint64_t max_gfn;
>  	unsigned long *bmap;
>  
> +	/*
> +	 * We reserve page table for 2 times of extra dirty mem which
> +	 * will definitely cover the original (1G+) test range.  Here
> +	 * we do the calculation with 4K page size which is the
> +	 * smallest so the page number will be enough for all archs
> +	 * (e.g., 64K page size guest will need even less memory for
> +	 * page tables).
> +	 */
> +	vm = create_vm(mode, VCPU_ID,
> +		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
> +		       guest_code);
> +
>  	switch (mode) {
>  	case VM_MODE_P52V48_4K:
>  		guest_pa_bits = 52;
> @@ -319,7 +334,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	 * A little more than 1G of guest page sized pages.  Cover the
>  	 * case where the size is not aligned to 64 pages.
>  	 */
> -	guest_num_pages = (1ul << (30 - guest_page_shift)) + 16;
> +	guest_num_pages = (1ul << (DIRTY_MEM_BITS - guest_page_shift)) + 16;
>  #ifdef __s390x__
>  	/* Round up to multiple of 1M (segment size) */
>  	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
> @@ -345,8 +360,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	bmap = bitmap_alloc(host_num_pages);
>  	host_bmap_track = bitmap_alloc(host_num_pages);
>  
> -	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
> -
>  #ifdef USE_CLEAR_DIRTY_LOG
>  	struct kvm_enable_cap cap = {};
>  
> -- 
> 2.21.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

