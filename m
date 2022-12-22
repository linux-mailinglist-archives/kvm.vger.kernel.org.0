Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF59E6540E2
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 13:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiLVMRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 07:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiLVMR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 07:17:28 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14B512D05;
        Thu, 22 Dec 2022 04:16:11 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 55D831EC0715;
        Thu, 22 Dec 2022 13:16:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1671711370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/VXYlruW2xooSsXWnWYyMCr5jlbGKrzKBa2cG6Y2Ww=;
        b=XjXW5Z8oYRDLihGMfhUQO8kyU/QX/4pvN9dV0v1Cbyb493Z8bynjeUG11y+TBLchroJzlt
        VoGxu2Y+sifUYuL4UyuR2V1uyTCWlmVn5DzYni+p08sQRqsFXqgEsVzXToa9qqwUh5n8rm
        k8g04qR1xN0LQsSA70L2TEiGH9YC8Fw=
Date:   Thu, 22 Dec 2022 13:16:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for
 large page
Message-ID: <Y6RKhDVaeqVZwMCZ@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-2-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221214194056.161492-2-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

I'm guessing this was supposed to be "return;" here:

arch/x86/kvm/mmu/mmu.c: In function ‘kvm_update_lpage_private_shared_mixed’:
arch/x86/kvm/mmu/mmu.c:7090:25: error: label ‘out’ used but not defined
 7090 |                         goto out;
      |                         ^~~~

/me goes and digs deeper.

Aha, it was a "return" but you reordered the patches and the one adding
the out label:

KVM: x86: Add 'update_mem_attr' x86 op

went further down and this became the first but it didn't have the label
anymore.

Yeah, each patch needs to build successfully for bisection reasons, ofc.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
