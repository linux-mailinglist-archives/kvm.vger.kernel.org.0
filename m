Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E6B57B93A
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 17:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbiGTPLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 11:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiGTPLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 11:11:13 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8658064F1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 08:11:11 -0700 (PDT)
Date:   Wed, 20 Jul 2022 15:11:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658329869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vFnDRJW8SXwUP1HZqonS92uu/YoL0Hk0zC9PiQKiK7Y=;
        b=t8HCSRCOircfKNTjXQPibLbkf3dGU8b1N/fhA1M+gEhIcEuOgZmaGt+wpUGulo4ywjeCfR
        CfOExbN2WW4kIQqeSx1m9WLPXSJyiTTWXFPeiJDwqnDhmqqqYIY4XZt7ATi+kssHAlQbJN
        uqeHqdXLh54XRJ759q3mn8x7G1ih978=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
        kernel-team@android.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/24] KVM: arm64: Unify identifiers used to
 distinguish host and hypervisor
Message-ID: <YtgbCEOMze8N4TPW@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-7-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-7-will@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Jun 30, 2022 at 02:57:29PM +0100, Will Deacon wrote:
> The 'pkvm_component_id' enum type provides constants to refer to the
> host and the hypervisor, yet this information is duplicated by the
> 'pkvm_hyp_id' constant.
> 
> Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
> type definition to 'mem_protect.h' so that it can be used outside of
> the memory protection code.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
>  arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
>  3 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 80e99836eac7..f5705a1e972f 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -51,7 +51,11 @@ struct host_kvm {
>  };
>  extern struct host_kvm host_kvm;
>  
> -extern const u8 pkvm_hyp_id;
> +/* This corresponds to page-table locking order */
> +enum pkvm_component_id {
> +	PKVM_ID_HOST,
> +	PKVM_ID_HYP,
> +};

Since we have the concept of PTE ownership in pgtable.c, WDYT about
moving the owner ID enumeration there? KVM_MAX_OWNER_ID should be
incorporated in the enum too.

--
Thanks,
Oliver
