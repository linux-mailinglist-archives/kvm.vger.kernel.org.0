Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90D3E13D5
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhHEL1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 07:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241017AbhHEL1A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 07:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628162806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DjMNCHMyDCy1jfhKIOW9ACx2HA3RpxUNEcWNfn6GUuE=;
        b=IQS+m5rKcVnMjxmUeGkU/MHNwPbSbtd9TfoUT8TPnzMDozC7nOxtaQ8dxi/v2VPsQr5rO8
        Ecfnm1CAMphnJWBJgA+yxsmt9JReSgtwG/86mXWBx+Wj4pf0zIGFkjKpja1oCRhPdVKEAY
        Yrgueq4UHmPkgS3ZeMl1P8zWiD/31gI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-xGV4-VKZPp-6CLV0ThoiMA-1; Thu, 05 Aug 2021 07:26:44 -0400
X-MC-Unique: xGV4-VKZPp-6CLV0ThoiMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 664D01084F4C;
        Thu,  5 Aug 2021 11:26:42 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0029060BD9;
        Thu,  5 Aug 2021 11:26:39 +0000 (UTC)
Message-ID: <63b556880ceaf9a9455eca9517d47c7b33e7260d.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix per-cpu counter corruption on 32-bit
 builds
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Date:   Thu, 05 Aug 2021 14:26:38 +0300
In-Reply-To: <20210804214609.1096003-1-seanjc@google.com>
References: <20210804214609.1096003-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-04 at 14:46 -0700, Sean Christopherson wrote:
> Take a signed 'long' instead of an 'unsigned long' for the number of
> pages to add/subtract to the total number of pages used by the MMU.  This
> fixes a zero-extension bug on 32-bit kernels that effectively corrupts
> the per-cpu counter used by the shrinker.
> 
> Per-cpu counters take a signed 64-bit value on both 32-bit and 64-bit
> kernels, whereas kvm_mod_used_mmu_pages() takes an unsigned long and thus
> an unsigned 32-bit value on 32-bit kernels.  As a result, the value used
> to adjust the per-cpu counter is zero-extended (unsigned -> signed), not
> sign-extended (signed -> signed), and so KVM's intended -1 gets morphed to
> 4294967295 and effectively corrupts the counter.
> 
> This was found by a staggering amount of sheer dumb luck when running
> kvm-unit-tests on a 32-bit KVM build.  The shrinker just happened to kick
> in while running tests and do_shrink_slab() logged an error about trying
> to free a negative number of objects.  The truly lucky part is that the
> kernel just happened to be a slightly stale build, as the shrinker no
> longer yells about negative objects as of commit 18bb473e5031 ("mm:
> vmscan: shrink deferred objects proportional to priority").
> 
>  vmscan: shrink_slab: mmu_shrink_scan+0x0/0x210 [kvm] negative objects to delete nr=-858993460
> 
> Fixes: bc8a3d8925a8 ("kvm: mmu: Fix overflow on kvm mmu page limit calculation")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b4b65c21b2ca..082a0ba79edd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1700,7 +1700,7 @@ static int is_empty_shadow_page(u64 *spt)
>   * aggregate version in order to make the slab shrinker
>   * faster
>   */
> -static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
> +static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
>  {
>  	kvm->arch.n_used_mmu_pages += nr;
>  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);

I am almost sure that I seen this bug as well (I do test 32 bit KVM hosts,
even with nested 32 bit guests once in a while), but I didn't dare to investigate
it due to the fact the 32 bit KVM host is a very rare thing these days.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

