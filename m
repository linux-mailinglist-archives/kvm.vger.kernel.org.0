Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20F8588EAE
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbiHCO3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 10:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHCO3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 10:29:44 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657AF595;
        Wed,  3 Aug 2022 07:29:43 -0700 (PDT)
Date:   Wed, 3 Aug 2022 16:29:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659536981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=srnNRiym+Gwv1SNk6jv/2f+umKJnkZFoWq/vPcHryts=;
        b=bvuEZ1H6ZOfmcpDSy05vq+508ycnN8MhKvcgE6RFyi39+Mx4avt/tLvRUEkdcNGDoGAsBT
        fFOx3xc8gPBH9gVi468nKC0Ix7314HT4o3DD/sFEyS6kL42xY0LqyS3Rh0kO6jvHzOYl6e
        Qus6owgdFts9+sh5kc0v7YR7NVR/gHc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 28/40] KVM: selftests: Fill in vm->vpages_mapped
 bitmap in virt_map() too
Message-ID: <20220803142940.65gbhx7ae7mcmfk4@kamzik>
References: <20220803134110.397885-1-vkuznets@redhat.com>
 <20220803134635.399448-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803134635.399448-1-vkuznets@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 03:46:35PM +0200, Vitaly Kuznetsov wrote:
> Similar to vm_vaddr_alloc(), virt_map() needs to reflect the mapping
> in vm->vpages_mapped.
> 
> While on it, remove unneeded code wraping in vm_vaddr_alloc().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9889fe0d8919..ad9e15d4c6a9 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1214,8 +1214,7 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
>  
>  		virt_pg_map(vm, vaddr, paddr);
>  
> -		sparsebit_set(vm->vpages_mapped,
> -			vaddr >> vm->page_shift);
> +		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
>  	}
>  
>  	return vaddr_start;
> @@ -1288,6 +1287,8 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  		virt_pg_map(vm, vaddr, paddr);
>  		vaddr += page_size;
>  		paddr += page_size;
> +
> +		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
>  	}
>  }
>  
> -- 
> 2.35.3
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
