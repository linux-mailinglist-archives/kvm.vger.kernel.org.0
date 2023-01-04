Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F0065D1F9
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbjADMBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbjADMBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:01:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9511EEF0;
        Wed,  4 Jan 2023 04:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FA1561426;
        Wed,  4 Jan 2023 12:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3F7C433EF;
        Wed,  4 Jan 2023 12:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672833668;
        bh=AdBBHs+vk1+ihc9nifYgy4qWtVZl+0uaE+N5wIA1lqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkDX3AW3ufOyf1t0bKZaO2Gtqi7D7Wz54W2mFvnJH9m8ej+laXvXn9GSBlgHIICxm
         w0U56pDRDj0LdPBkcOArbb+3lN+0IV/Sk3I/EXEPtlZqWN+7XIdrxcuFbQ/No61WEj
         62FOq83Fp+bXKmRWVaSVIKFApzZdWcirAFHKVfLVTVK7eaL7Wk0BAtpBg3a3wgDG8t
         O4Z4yfA9JIUGiWo5d77UocfLCSxCov/XUKloGPNhriB6Fkl/WmmJkbRNcslivZI2eg
         UPHeUy+YcAAikJyhIDvoCVN7MDFvYG2xARtJwPEdQp3HylEuFaYbaswDsXg5DbcH6r
         xydmzduMxp9GQ==
Date:   Wed, 4 Jan 2023 12:01:05 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for
 large page
Message-ID: <Y7VqgbTE34/Sxupw@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-2-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-2-michael.roth@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:53PM -0600, Michael Roth wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> Aligned end boundary causes a kvm crash, handle the case.
> 

Link: https://lore.kernel.org/kvm/20221202061347.1070246-8-chao.p.peng@linux.intel.com/

Chao, are you aware of this issue already?

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b1953ebc012e..b3ffc61c668c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7159,6 +7159,9 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
>  		for (gfn = first + pages; gfn < last; gfn += pages)
>  			linfo_set_mixed(gfn, slot, level, false);
>  
> +		if (gfn == last)
> +			goto out;
> +
>  		gfn = last;
>  		gfn_end = min(last + pages, slot->base_gfn + slot->npages);
>  		mixed = mem_attrs_mixed(kvm, slot, level, attrs, gfn, gfn_end);
> -- 
> 2.25.1
> 


BR, Jarkko
