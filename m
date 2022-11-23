Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D36636566
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiKWQIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbiKWQI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:08:27 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61D9413EB2
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:08:26 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 837B71FB;
        Wed, 23 Nov 2022 08:08:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EB1E3F73B;
        Wed, 23 Nov 2022 08:08:24 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:08:22 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, will@kernel.org
Subject: Re: [PATCH kvmtool v1 01/17] Initialize the return value in
 kvm__for_each_mem_bank()
Message-ID: <Y35FdsVXdZf62tLO@monolith.localdoman>
References: <20221115111549.2784927-1-tabba@google.com>
 <20221115111549.2784927-2-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115111549.2784927-2-tabba@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Nov 15, 2022 at 11:15:33AM +0000, Fuad Tabba wrote:
> If none of the bank types match, the function would return an
> uninitialized value.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kvm.c b/kvm.c
> index 42b8812..78bc0d8 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -387,7 +387,7 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
>  			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
>  			   void *data)
>  {
> -	int ret;
> +	int ret = 0;

Would you consider moving the variable declaration after the 'bank'
variable?

>  	struct kvm_mem_bank *bank;
>  
>  	list_for_each_entry(bank, &kvm->mem_banks, list) {

Shouldn't the function return an error if no memory banks matched the type
specified (initialize ret to -EINVAL instead of 0)? I'm thinking that if
the caller expects a certain type of memory bank to be present, but that
memory type is not present, then somehwere an error occured and the caller
should be made aware of it.

Case in point, kvm__for_each_mem_bank() is used vfio/core.c for
KVM_MEM_TYPE_RAM. If RAM hasn't been created by that point, then
VFIO_IOMMU_MAP_DMA will not be called for guest memory and the assigned
device will not work.

Thanks,
Alex

> -- 
> 2.38.1.431.g37b22c650d-goog
> 
