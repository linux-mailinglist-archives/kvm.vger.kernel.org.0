Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84DE29A389
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 05:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505334AbgJ0EFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 00:05:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2504368AbgJ0EFF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 00:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603771503;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z63apBRGyy3e8g8mUKeHgVcKfFAFQyjLMsXxTptfmGQ=;
        b=PkG9oujVojgOE6AhZ5MFFNt5q19iePSaYY2g7EYy8K4bx8kTJtba1MQljAZqj0ycWzZDaR
        3ZFMEvctgJmBsW5D4x5eWMUVyLwXEQRm7y1RBOIXr70OOC37/mArn2n4wYEa2W1fG62py0
        tBZl67OrXa47b9ZA11gnfhbrzfgxy/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-B0_6d6n2MFWoKYU7dRmPiA-1; Tue, 27 Oct 2020 00:04:59 -0400
X-MC-Unique: B0_6d6n2MFWoKYU7dRmPiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CAF8E9000;
        Tue, 27 Oct 2020 04:04:57 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79FBC5D9E8;
        Tue, 27 Oct 2020 04:04:54 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Correctly handle the mmio faulting
To:     Santosh Shukla <sashukla@nvidia.com>, maz@kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Cc:     mcrossley@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org
References: <1603711447-11998-1-git-send-email-sashukla@nvidia.com>
 <1603711447-11998-2-git-send-email-sashukla@nvidia.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b86a29e1-1e25-d3e7-5718-77f4a37da575@redhat.com>
Date:   Tue, 27 Oct 2020 15:04:51 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1603711447-11998-2-git-send-email-sashukla@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Santosh,

On 10/26/20 10:24 PM, Santosh Shukla wrote:
> The Commit:6d674e28 introduces a notion to detect and handle the
> device mapping. The commit checks for the VM_PFNMAP flag is set
> in vma->flags and if set then marks force_pte to true such that
> if force_pte is true then ignore the THP function check
> (/transparent_hugepage_adjust()).
> 
> There could be an issue with the VM_PFNMAP flag setting and checking.
> For example consider a case where the mdev vendor driver register's
> the vma_fault handler named vma_mmio_fault(), which maps the
> host MMIO region in-turn calls remap_pfn_range() and maps
> the MMIO's vma space. Where, remap_pfn_range implicitly sets
> the VM_PFNMAP flag into vma->flags.
> 
> Now lets assume a mmio fault handing flow where guest first access
> the MMIO region whose 2nd stage translation is not present.
> So that results to arm64-kvm hypervisor executing guest abort handler,
> like below:
> 
> kvm_handle_guest_abort() -->
>   user_mem_abort()--> {
> 
>      ...
>      0. checks the vma->flags for the VM_PFNMAP.
>      1. Since VM_PFNMAP flag is not yet set so force_pte _is_ false;
>      2. gfn_to_pfn_prot() -->
>          __gfn_to_pfn_memslot() -->
>              fixup_user_fault() -->
>                  handle_mm_fault()-->
>                      __do_fault() -->
>                         vma_mmio_fault() --> // vendor's mdev fault handler
>                          remap_pfn_range()--> // Here sets the VM_PFNMAP
>                                                  flag into vma->flags.
>      3. Now that force_pte is set to false in step-2),
>         will execute transparent_hugepage_adjust() func and
>         that lead to Oops [4].
>   }
> 
> The proposition is to set force_pte=true if kvm_is_device_pfn is true.
> 
> [4] THP Oops:
>> pc: kvm_is_transparent_hugepage+0x18/0xb0
>> ...
>> ...
>> user_mem_abort+0x340/0x9b8
>> kvm_handle_guest_abort+0x248/0x468
>> handle_exit+0x150/0x1b0
>> kvm_arch_vcpu_ioctl_run+0x4d4/0x778
>> kvm_vcpu_ioctl+0x3c0/0x858
>> ksys_ioctl+0x84/0xb8
>> __arm64_sys_ioctl+0x28/0x38
> 
> Tested on Huawei Kunpeng Taishan-200 arm64 server, Using VFIO-mdev device.
> Linux-5.10-rc1 tip: 3650b228
> 
> Fixes: 6d674e28 ("KVM: arm/arm64: Properly handle faulting of device mappings")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Santosh Shukla <sashukla@nvidia.com>
> ---
> v2:
> - Per Marc's suggestion - setting force_pte=true.
> - Rebased and tested for 5.10-rc1 commit: 3650b228
> 
> v1: https://lkml.org/lkml/2020/10/21/460
> 
> arch/arm64/kvm/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 19aacc7..d4cd253 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -839,6 +839,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   
>   	if (kvm_is_device_pfn(pfn)) {
>   		device = true;
> +		force_pte = true;
>   	} else if (logging_active && !write_fault) {
>   		/*
>   		 * Only actually map the page as writable if this was a write
> 

Cheers,
Gavin

