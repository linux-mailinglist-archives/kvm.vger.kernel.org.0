Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFDD5F974F
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 06:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiJJEKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 00:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiJJEKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 00:10:32 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1833325FB;
        Sun,  9 Oct 2022 21:10:29 -0700 (PDT)
Date:   Mon, 10 Oct 2022 04:10:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665375028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cmx7UC5ERbZvs6NltikBKO+6xKGttyQo1AEh/wBpODM=;
        b=mWnNl9esZ4y1R7iZLuV38Ia7gZTlaSRQxos7LCRu9JrUofDzcFj4pgoUkfZa9sSZtDlTEx
        u1tilWLnPq16Hnl1a0BT5mPphvQ9yAzQe3k7kzjl1eNBcFcSqnXYXeDgFNYSa0RM55JLGO
        RHyqL7uUKo6dN+egY/xOYyt/ETSk4GY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org,
        andrew.jones@linux.dev, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        pbonzini@redhat.com, seanjc@google.com, wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: selftests: Fix multiple versions of GIC
 creation
Message-ID: <Y0ObL7C7/93Q8d5T@google.com>
References: <20221009033131.365-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009033131.365-1-yuzenghui@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 09, 2022 at 11:31:31AM +0800, Zenghui Yu wrote:
> Commit 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to
> separate helper") wrongly converted a "real" GIC device creation to
> __kvm_test_create_device() and caused the test failure on my D05 (which
> supports v2 emulation). Fix it.
> 
> Fixes: 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index e05ecb31823f..9c131d977a1b 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -662,8 +662,8 @@ int test_kvm_device(uint32_t gic_dev_type)
>  					     : KVM_DEV_TYPE_ARM_VGIC_V2;
>  
>  	if (!__kvm_test_create_device(v.vm, other)) {
> -		ret = __kvm_test_create_device(v.vm, other);
> -		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
> +		ret = __kvm_create_device(v.vm, other);
> +		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
>  				"create GIC device while other version exists");
>  	}
>  
> -- 
> 2.33.0
> 
> 
