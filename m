Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEF374B138
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjGGMn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 08:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjGGMn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 08:43:57 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9217911B;
        Fri,  7 Jul 2023 05:43:56 -0700 (PDT)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
        id 1qHkoV-000250-00; Fri, 07 Jul 2023 14:43:55 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 654CAC01C1; Fri,  7 Jul 2023 14:43:44 +0200 (CEST)
Date:   Fri, 7 Jul 2023 14:43:44 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: kvm: Fix build error with
 KVM_MIPS_DEBUG_COP0_COUNTERS enabled
Message-ID: <ZKgIgIXLrznMTkzg@alpha.franken.de>
References: <20230706163610.106938-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706163610.106938-1-tsbogend@alpha.franken.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 06:36:10PM +0200, Thomas Bogendoerfer wrote:
> Commit e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference") missed
> converting one place accessing cop0 registers, which results in a build
> error, if KVM_MIPS_DEBUG_COP0_COUNTERS is enabled.
> 
> Fixes: e4de20576986 ("MIPS: KVM: Fix NULL pointer dereference")
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  arch/mips/kvm/stats.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/stats.c b/arch/mips/kvm/stats.c
> index 53f851a61554..3e6682018fbe 100644
> --- a/arch/mips/kvm/stats.c
> +++ b/arch/mips/kvm/stats.c
> @@ -54,9 +54,9 @@ void kvm_mips_dump_stats(struct kvm_vcpu *vcpu)
>  	kvm_info("\nKVM VCPU[%d] COP0 Access Profile:\n", vcpu->vcpu_id);
>  	for (i = 0; i < N_MIPS_COPROC_REGS; i++) {
>  		for (j = 0; j < N_MIPS_COPROC_SEL; j++) {
> -			if (vcpu->arch.cop0->stat[i][j])
> +			if (vcpu->arch.cop0.stat[i][j])
>  				kvm_info("%s[%d]: %lu\n", kvm_cop0_str[i], j,
> -					 vcpu->arch.cop0->stat[i][j]);
> +					 vcpu->arch.cop0.stat[i][j]);
>  		}
>  	}
>  #endif
> -- 
> 2.35.3

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
