Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190987675CF
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjG1SsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjG1Srt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:47:49 -0400
Received: from out-116.mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D211D
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:47:48 -0700 (PDT)
Date:   Fri, 28 Jul 2023 18:47:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690570066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c8yvLUIK06RQnV+ryYtZxv7pPU7Be4Nu1kldUxWjnGs=;
        b=pSQ6PrxgtzAipZ6/F3I1GCMvO4QAEtJSttNGskJutWkHfocv7PXkdzqBmXO9vHFIix8WHH
        YAFgERbB4edHX9sU4STeYFJOoQqhymhRwaaY3jagO00wjR6MWTtzuLnMqpqBa5yU7/9Ppx
        f82YMEUCTg60lJBlVEbroTJwi7B+JTA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 19/26] KVM: arm64: nv: Add trap forwarding for
 HFGxTR_EL2
Message-ID: <ZMQNTKAlxQe61JUe@linux.dev>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-20-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-20-maz@kernel.org>
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

Hey Marc,

On Fri, Jul 28, 2023 at 09:29:45AM +0100, Marc Zyngier wrote:

[...]

> @@ -943,6 +1025,27 @@ void __init populate_nv_trap_config(void)
>  	kvm_info("nv: %ld coarse grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_cgt));

It might make sense to skip insertion of the FGT trap controls if the
system doesn't have FGT in the first place.

> +	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
> +		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
> +		union trap_config tc;
> +
> +		tc = get_trap_config(fgt->encoding);
> +
> +		WARN(tc.fgt,
> +		     "Duplicate FGT for sys_reg(%d, %d, %d, %d, %d)\n",
> +		     sys_reg_Op0(fgt->encoding),
> +		     sys_reg_Op1(fgt->encoding),
> +		     sys_reg_CRn(fgt->encoding),
> +		     sys_reg_CRm(fgt->encoding),
> +		     sys_reg_Op2(fgt->encoding));

Same comment here, we should just bail.

> +		tc.val |= fgt->tc.val;
> +		xa_store(&sr_forward_xa, fgt->encoding,
> +			 xa_mk_value(tc.val), GFP_KERNEL);
> +	}
> +
> +	kvm_info("nv: %ld fine grained trap handlers\n",
> +		 ARRAY_SIZE(encoding_to_fgt));
>  }

-- 
Thanks,
Oliver
