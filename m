Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB35B9679
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 10:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiIOIgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 04:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiIOIgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 04:36:03 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3603B550A5
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 01:36:01 -0700 (PDT)
Date:   Thu, 15 Sep 2022 09:35:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663230959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=os9IwzMucLgvaJoFDfZwUuHXyNMsYUbmD+UZT0aPk50=;
        b=E/tahtjhO+Blv3iPVh0DxXR5+zb1T97qHYNma9aXxibWOSflrt9ii0ORnnylzqS95STLGn
        Gh7oKiN3KOeCQIoh0ZfJlrIdL1p5P1FHPH7PfI8p5/7KX7mI3kzN0fevcLDPdQo2cm/wYR
        YUqtx80pvv6k24UTJFIyckf3Eb1J3Qw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/25] KVM: arm64: Move hyp refcount manipulation
 helpers to common header file
Message-ID: <YyLj69OheXbXZLRw@google.com>
References: <20220914083500.5118-1-will@kernel.org>
 <20220914083500.5118-2-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914083500.5118-2-will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Wed, Sep 14, 2022 at 09:34:36AM +0100, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> We will soon need to manipulate 'struct hyp_page' refcounts from outside
> page_alloc.c, so move the helpers to a common header file to allow them
> to be reused easily.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 ++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 19 -------------------
>  2 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 592b7edb3edb..418b66a82a50 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -45,4 +45,22 @@ static inline int hyp_page_count(void *addr)
>  	return p->refcount;
>  }
>  
> +static inline void hyp_page_ref_inc(struct hyp_page *p)
> +{
> +	BUG_ON(p->refcount == USHRT_MAX);
> +	p->refcount++;
> +}
> +
> +static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
> +{
> +	BUG_ON(!p->refcount);
> +	p->refcount--;
> +	return (p->refcount == 0);
> +}
> +
> +static inline void hyp_set_page_refcounted(struct hyp_page *p)
> +{
> +	BUG_ON(p->refcount);
> +	p->refcount = 1;
> +}

It might be good to add a comment mentioning the hyp_pool::lock must
be held to update refcounts, as that part is slightly less clear when
the helpers are hoisted out of page_alloc.c

With that:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
