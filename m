Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75A5729EF9
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 17:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbjFIPp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 11:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbjFIPo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 11:44:59 -0400
Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01903358C
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 08:44:55 -0700 (PDT)
Date:   Fri, 9 Jun 2023 08:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686325494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vPnlIRVGxj8AeQiaq3bAFwvGduBuAp2E7TLGSfDQuEY=;
        b=kCvdF6x5Ui7p2uYuAw8e0+ZOCZ9jdiuTfejEV/+f9FynBFrrivqpYS+WgpldF4ADxknz7n
        EnUpapJPqGOr4cWrWST9aM/SroIqLJ7rNerE/Kv1NsLUi4P0U9F92hSfAzcjdykt0K8vtP
        MSOED852Q/+yMxfDpf0O/bS5SQ8UZ34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/3] KVM: arm64: Clear possible conflict aborts
Message-ID: <ZINI8KpQsrSOW0I5@linux.dev>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602170147.1541355-3-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:01:46PM +0000, Colton Lewis wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7a68398517c95..96b950f20c8d0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1591,6 +1591,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		return 1;
>  	}
> 
> +	if (fault_status == ESR_ELx_FSC_CONFLICT) {
> +		/* We could be at any level. 0 covers all levels. */
> +		__kvm_tlb_flush_vmid_ipa(vcpu->arch.hw_mmu, fault_ipa, 0);
> +		return 1;
> +	}
> +

This does not match the architecture. Please read DDI0487J D8.14.3
"TLB maintenance due to TLB conflict", which tells you exactly how to
resolve the conflict. TL; DR: TLBI by address is _not_ guaranteed to
invalidate duplicate TLB entries. vmalls12e1 is your friend.

The conflicting TLB entries are local to the CPU that took the abort, so
you don't need to do any broadcast.

--
Thanks,
Oliver
