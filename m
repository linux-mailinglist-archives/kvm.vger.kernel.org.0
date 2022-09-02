Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91925AB346
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 16:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiIBOUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237475AbiIBOTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 10:19:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87166DCFDA
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 06:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE0E8B82AA1
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1852C433D6;
        Fri,  2 Sep 2022 13:45:30 +0000 (UTC)
Date:   Fri, 2 Sep 2022 14:45:27 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
Message-ID: <YxII905jjQz0FH4D@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-7-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-7-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 12:30:32PM -0700, Peter Collingbourne wrote:
> Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
> on being able to map guest memory as MAP_SHARED. The current restriction
> on sharing MAP_SHARED pages with the guest is preventing the use of
> those features with MTE. Now that the races between tasks concurrently
> clearing tags on the same page have been fixed, remove this restriction.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d54be80e31dd..fc65dc20655d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  
>  static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  {
> -	/*
> -	 * VM_SHARED mappings are not allowed with MTE to avoid races
> -	 * when updating the PG_mte_tagged page flag, see
> -	 * sanitise_mte_tags for more details.
> -	 */
> -	if (vma->vm_flags & VM_SHARED)
> -		return false;

I think this is fine with the locking in place (BTW, it may be worth
mentioning in the commit message that it's a relaxation of the ABI). I'd
like Steven to have a look as well when he gets the time, in case we
missed anything on the KVM+MTE side.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
