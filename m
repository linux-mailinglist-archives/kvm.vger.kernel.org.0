Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AE362888C
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 19:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiKNSsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 13:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbiKNSsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 13:48:13 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD23613F75
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 10:48:12 -0800 (PST)
Date:   Mon, 14 Nov 2022 18:48:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668451689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ql8zFw/DxEYIf4IQ7KYe8Xa1QN1s9FqjeGphu6RWQE0=;
        b=fZ0/Ii6j2iJMk+5Ifc1knRSHKvjiHHn3ogpu2jcYbK+f0t4CQJZkX/9gpvgZZYcdEMPy7v
        RCtRu/x1mWpxQxYTS19afbHKVMlExyhZrat4Ov8c4n1sLfOguH0PbCXbOEPfoRoILSq5Qf
        6AO6nic/6sRSOEy/ku4/33HGFBSVpEw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 02/12] KVM: arm64: Allow visiting block PTEs in
 post-order
Message-ID: <Y3KNZCLVqnFeg7hi@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-3-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 12, 2022 at 08:17:04AM +0000, Ricardo Koller wrote:
> The page table walker does not visit block PTEs in post-order. But there
> are some cases where doing so would be beneficial, for example: breaking a
> 1G block PTE into a full tree in post-order avoids visiting the new tree.
> 
> Allow post order visits of block PTEs. This will be used in a subsequent
> commit for eagerly breaking huge pages.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++-------------
>  3 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e2edeed462e8..d2e4a5032146 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -255,7 +255,7 @@ struct kvm_pgtable {
>   *					entries.
>   * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
>   *					children.
> - * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
> + * @KVM_PGTABLE_WALK_POST:		Visit leaf or table entries after their
>   *					children.

It is not immediately obvious from this change alone that promoting the
post-order traversal of every walker to cover leaf + table PTEs is safe.

Have you considered using a flag for just leaf post-order visits?

--
Thanks,
Oliver
