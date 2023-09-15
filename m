Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67537A2A38
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 00:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbjIOWGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 18:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjIOWFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 18:05:45 -0400
Received: from out-213.mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D925E1FD0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 15:05:40 -0700 (PDT)
Date:   Fri, 15 Sep 2023 22:05:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694815539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nyE4OiRbYG9EbFXNkk64LoCgnlBLw/RwLs8vt956zVY=;
        b=oSwgRQ5loxpve75EPP8dm+vhouR6+tNUX66KK5FT98J82+qt9gRWQctoRoIkFKRse2n8Vc
        +9ZxMKf8KFJp1GeIYS+9Bjv+oBd6ey8yy0ukBl6UOLHxx1WEwitOWOT5Ryg/t6by7GF7KN
        jbbMjWvYSlGwFSZB2Hx8t98+ThlhVws=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        zhukeqian1@huawei.com, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 2/8] KVM: arm64: Add KVM_PGTABLE_WALK_HW_DBM for
 HW DBM support
Message-ID: <ZQTVLiFK2dGBd87v@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-3-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825093528.1637-3-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On Fri, Aug 25, 2023 at 10:35:22AM +0100, Shameer Kolothum wrote:
> KVM_PGTABLE_WALK_HW_DBM - Indicates page table walk is for HW DBM
>  related updates.
> 
> No functional changes here. Only apply any HW DBM bit updates to last
> level only. These will be used by a future commit where we will add
> support for HW DBM.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  3 +++
>  arch/arm64/kvm/hyp/pgtable.c         | 10 ++++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index d3e354bb8351..3f96bdd2086f 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -219,6 +219,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>   * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
>   *					without Cache maintenance
>   *					operations required.
> + * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute update is
> + *					HW DBM related.
>   */
>  enum kvm_pgtable_walk_flags {
>  	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> @@ -228,6 +230,7 @@ enum kvm_pgtable_walk_flags {
>  	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
>  	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
>  	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
> +	KVM_PGTABLE_WALK_HW_DBM			= BIT(7),
>  };

Rather than making this DBM specific, call it KVM_PGTABLE_WALK_FORCE_PTE
and get rid of stage2_map_data::force_pte. Then it becomes immediately
obvious what this flag implies.

-- 
Thanks,
Oliver
