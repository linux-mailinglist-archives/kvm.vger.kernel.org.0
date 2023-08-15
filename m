Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7677C893
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 09:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbjHOHbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 03:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbjHOHau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 03:30:50 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC5A19B5;
        Tue, 15 Aug 2023 00:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692084645;
        bh=XiXX9eU/s/AkSjfJm9DwVrwntmLvwo4y7VDo0VRqfqw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=cpr2h286rbQ9ZWA7sIJpieEEunosIMnHIlpuAHRa9sZE8MabuVXAmlJlUtBRr1yar
         IOyhe1OBFhP8Pi60NS60najNtcw9Sgyfrt6gBpX/YisA9UK7cfOXuy0/pQX9w6s8As
         r5sR07G+emd4A9HK+8h1Nh6FsveFmjVmpqxUP0orFHTqdRoLatEzucsXjPmv2Jw628
         aM8/xb6e5beQ4RTtnkfEszZCHauoBHz5drU74sVo0G/im0RywT3ncWqdiN//qhTISa
         jLIH5smjeKm2+e0N0MLLa7zAAnDnDEWhMGL74bOiDj1IT9D35NOz73L89+1wZ3gkZl
         qfW7n4aWihFyw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RQ2xK3MyFz4wqX;
        Tue, 15 Aug 2023 17:30:45 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
In-Reply-To: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
Date:   Tue, 15 Aug 2023 17:30:45 +1000
Message-ID: <87y1icdaoq.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> Making virt_to_pfn() a static inline taking a strongly typed
> (const void *) makes the contract of a passing a pointer of that
> type to the function explicit and exposes any misuse of the
> macro virt_to_pfn() acting polymorphic and accepting many types
> such as (void *), (unitptr_t) or (unsigned long) as arguments
> without warnings.
>
> Move the virt_to_pfn() and related functions below the
> declaration of __pa() so it compiles.
>
> For symmetry do the same with pfn_to_kaddr().
>
> As the file is included right into the linker file, we need
> to surround the functions with ifndef __ASSEMBLY__ so we
> don't cause compilation errors.
>
> The conversion moreover exposes the fact that pmd_page_vaddr()
> was returning an unsigned long rather than a const void * as
> could be expected, so all the sites defining pmd_page_vaddr()
> had to be augmented as well.
...
> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
> index 6a88bfdaa69b..a9515d3d7831 100644
> --- a/arch/powerpc/include/asm/pgtable.h
> +++ b/arch/powerpc/include/asm/pgtable.h
> @@ -60,9 +60,9 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>  }
>  
>  #ifndef pmd_page_vaddr
> -static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> +static inline const void *pmd_page_vaddr(pmd_t pmd)
>  {
> -	return ((unsigned long)__va(pmd_val(pmd) & ~PMD_MASKED_BITS));
> +	return (const void *)((unsigned long)__va(pmd_val(pmd) & ~PMD_MASKED_BITS));

This can also just be:

	return __va(pmd_val(pmd) & ~PMD_MASKED_BITS);

I've squashed that in.

cheers
