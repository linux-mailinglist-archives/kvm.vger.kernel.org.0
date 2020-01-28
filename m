Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45F514B1A7
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgA1JSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:18:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgA1JSj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 04:18:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580203118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ey0MsIeFmyzpawSGgwopK9Syi8SizcNQrb3ID79L2OA=;
        b=Q6m/8nnzjeC6cotuTgDopKIBigaobeCPdm3IahzFNq8V1HrBRWYNHzGEyNrzddShjovNNR
        I40hk2BsYQkg8YlwThTE7ieeBGJSaVP8KNPSUuVxZOrNMu2Muo0u6zvoxMw0WKuwPjsz3W
        Sc4PtSvomQU/M71Y0t3EnxjrNX+xuhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-YfQ9pnZRMoWGlsEIFqxGvg-1; Tue, 28 Jan 2020 04:18:34 -0500
X-MC-Unique: YfQ9pnZRMoWGlsEIFqxGvg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A19F9100550E;
        Tue, 28 Jan 2020 09:18:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A61C519C58;
        Tue, 28 Jan 2020 09:18:32 +0000 (UTC)
Date:   Tue, 28 Jan 2020 10:18:30 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, bgardon@google.com
Subject: Re: [PATCH] kvm: selftests: Introduce num-pages conversion utilities
Message-ID: <20200128091830.sbcba2ybu6hgrkv2@kamzik.brq.redhat.com>
References: <20200127170405.17503-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127170405.17503-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 06:04:05PM +0100, Andrew Jones wrote:
> Guests and hosts don't have to have the same page size. This means
> calculations are necessary when selecting the number of guest pages
> to allocate in order to ensure the number is compatible with the
> host. Provide utilities to help with those calculations.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  |  3 +--
>  .../testing/selftests/kvm/include/kvm_util.h  |  3 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++++++
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 5614222a6628..c2bc4e4c91ec 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -295,8 +295,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
>  #endif
>  	host_page_size = getpagesize();
> -	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
> -			 !!((guest_num_pages * guest_page_size) % host_page_size);
> +	host_num_pages = vm_num_host_pages(vm, guest_num_pages);
>  
>  	if (!phys_offset) {
>  		guest_test_phys_mem = (vm_get_max_gfn(vm) -
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 29cccaf96baf..0d05ade3022c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -158,6 +158,9 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
>  unsigned int vm_get_page_shift(struct kvm_vm *vm);
>  unsigned int vm_get_max_gfn(struct kvm_vm *vm);
>  
> +unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest_pages);
> +unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host_pages);
> +
>  struct kvm_userspace_memory_region *
>  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  				 uint64_t end);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 41cf45416060..5af9d7b1b7fc 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1667,3 +1667,29 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
>  {
>  	return vm->max_gfn;
>  }
> +
> +static unsigned int vm_calc_num_pages(unsigned int num_pages,
> +				      unsigned int page_shift,
> +				      unsigned int new_page_shift)
> +{
> +	unsigned int n = 1 << (new_page_shift - page_shift);
> +
> +	if (page_shift >= new_page_shift)
> +		return num_pages * (1 << (page_shift - new_page_shift));
> +
> +	return num_pages / n + !!(num_pages % n);
> +}
> +
> +unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest_pages)
> +{
> +	return vm_calc_num_pages(num_guest_pages,
> +				 vm_get_page_shift(vm),
> +				 __builtin_ffs(getpagesize()) - 1);
> +}
> +
> +unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host_pages)
> +{
> +	return vm_calc_num_pages(num_host_pages,
> +				 __builtin_ffs(getpagesize()) - 1,
> +				 vm_get_page_shift(vm));
> +}
> -- 
> 2.21.1
>

I'm going to send a v2 because there's another place in dirty_log_test.c
that I can apply this new utility. I'm also going to wrap the
'__builtin_ffs(getpagesize()) - 1' into a new getpageshift() macro.

Thanks,
drew

