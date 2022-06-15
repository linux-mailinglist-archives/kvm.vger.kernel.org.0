Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24DC54CB42
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbiFOO0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiFOO0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:26:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907E138DBB
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:26:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so2270915pjl.4
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qB8AcXg/PxEC/cUAdUagdguJMmCygQ7WZVfOSedDdss=;
        b=ctRJ2nN7r6oxfv7MoQvj22wgZ3LiXE7oNwbVkCZIzJ1lRjqtirLDOHMhaTrj2m7BuS
         o7H+FUGtt/aLHQH2J2SAJu31qcBFlEXbrv/3dOmGpHZ/cUxpO6qQdIDUP2Ee4C/cUOWh
         DSrnKwdKX8au6tec5NvHWIJ7mNFH5RGcuzxoV0ZWHOSOwCUItA/wCreqM7KSfdgdtLxn
         IdqCvc7sHPXO2ubIZpcPFaT4U91N+ATBZkyBt2vhOgnGsyx9ohDrwVcdarhAJn5/YrUY
         ariE4V01SVoWXDW8y6wg/KzD5Ne86yFgBQe7oW9c1CaDdFHAZhUv6VHxhoD2yNeHuvtd
         z55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qB8AcXg/PxEC/cUAdUagdguJMmCygQ7WZVfOSedDdss=;
        b=3C3hH/u+1XCycN2zd1vFx9w1TDagmCFtTfCf9Hi8iXL/rs8wJuHks22NwwpFDt6+mg
         5Pr0tELE/VBeU7xvYXvFPuAWf+tOhVXLoveGA72WWNiNuBbxGP/Ql+WpGpvVKxKBOm+Q
         Os32bajwhmqAudwW6Wuc7/UvbGIxZ0WyXdFYINofz4CxAgIAvWWCiCwi0SrduN0PcOdo
         b3zpHIdgPwdBtHxUwz4n69QEElR/iMxSK8CVFT6GnIv8XtKPKLIK72jjqrB33HRXyqn/
         I9cC2zqyFmA68IOLI0t+tRq5h6zetTBJCSn9DSgWXuekKEYLYbsj1qeG29/xwqbRE8tf
         SpVw==
X-Gm-Message-State: AJIora8ZvY8jkxTmiXziFzWPP3JViaRWAYjYDVJMe2rAYBnMwW2MgLsi
        aWMtmzmCzT98zAa8NCQo+6Md8g==
X-Google-Smtp-Source: AGRyM1vSXp/DX78MiZUWevdRXHKoUuMgN0XH/wsQBE5ApqwZVKMWUZmmlCJjimO/EjxvqUsYaIdqeA==
X-Received: by 2002:a17:902:e951:b0:168:b530:135b with SMTP id b17-20020a170902e95100b00168b530135bmr9652483pll.93.1655303172795;
        Wed, 15 Jun 2022 07:26:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b0016362da9a03sm9264943pli.245.2022.06.15.07.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 07:26:12 -0700 (PDT)
Date:   Wed, 15 Jun 2022 14:26:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH v2 5/8] KVM: x86/mmu: Use separate namespaces for guest
 PTEs and shadow PTEs
Message-ID: <YqnsAIKxQniAsb1d@google.com>
References: <20220614233328.3896033-1-seanjc@google.com>
 <20220614233328.3896033-6-seanjc@google.com>
 <090e701d-6893-ea25-1237-233ff3dd01ee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <090e701d-6893-ea25-1237-233ff3dd01ee@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022, Paolo Bonzini wrote:
> On 6/15/22 01:33, Sean Christopherson wrote:
> > Separate the macros for KVM's shadow PTEs (SPTE) from guest 64-bit PTEs
> > (PT64).  SPTE and PT64 are _mostly_ the same, but the few differences are
> > quite critical, e.g. *_BASE_ADDR_MASK must differentiate between host and
> > guest physical address spaces, and SPTE_PERM_MASK (was PT64_PERM_MASK) is
> > very much specific to SPTEs.
> > 
> > Opportunistically (and temporarily) move most guest macros into paging.h
> > to clearly associate them with shadow paging, and to ensure that they're
> > not used as of this commit.  A future patch will eliminate them entirely.
> > 
> > Sadly, PT32_LEVEL_BITS is left behind in mmu_internal.h because it's
> > needed for the quadrant calculation in kvm_mmu_get_page().  The quadrant
> > calculation is hot enough (when using shadow paging with 32-bit guests)
> > that adding a per-context helper is undesirable, and burying the
> > computation in paging_tmpl.h with a forward declaration isn't exactly an
> > improvement.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> A better try:

Very nice!  It's obvious once someone else writes the code.  :-)

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 54b3e39d07b3..cd561b49cc84 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2011,8 +2011,21 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	role.direct = direct;
>  	role.access = access;
>  	if (role.has_4_byte_gpte) {
> +		/*
> +		 * The "quadrant" value corresponds to those bits of the address
> +		 * that have already been used by the 8-byte shadow page table
> +		 * lookup, but not yet in the 4-byte guest page tables.  Having
> +		 * the quadrant as part of the role ensures that each upper sPTE
> +		 * points to the the correct portion of the guest page table
> +		 * structure.
> +		 *
> +		 * For example, a 4-byte PDE consumes bits 31:22 and an 8-byte PDE
> +		 * consumes bits 29:21.  Each guest PD must be expanded into four
> +		 * shadow PDs, one for each value of bits 31:30, and the PDPEs
> +		 * will use the four quadrants in round-robin fashion.

It's not round-robin, that would imply KVM rotates through each quadrant on its
own.  FWIW, I like David's comment from his patch that simplifies this mess in a
similar way.

https://lore.kernel.org/all/20220516232138.1783324-5-dmatlack@google.com
> +		 */
>  		quadrant = gaddr >> (PAGE_SHIFT + (SPTE_LEVEL_BITS * level));
> -		quadrant &= (1 << ((PT32_LEVEL_BITS - SPTE_LEVEL_BITS) * level)) - 1;
> +		quadrant &= (1 << level) - 1;
>  		role.quadrant = quadrant;
>  	}
>  	if (level <= vcpu->arch.mmu->cpu_role.base.level)
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index cb9d4d358335..5e1e3c8f8aaa 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -20,9 +20,6 @@ extern bool dbg;
>  #define MMU_WARN_ON(x) do { } while (0)
>  #endif
> -/* The number of bits for 32-bit PTEs is to needed compute the quandrant. */

Heh, and it gets rid of my typo.

> -#define PT32_LEVEL_BITS 10
> -
>  /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
>  #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
>  	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 6c29aef4092b..e4655056e651 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -38,7 +38,7 @@
>  	#define pt_element_t u32
>  	#define guest_walker guest_walker32
>  	#define FNAME(name) paging##32_##name
> -	#define PT_LEVEL_BITS PT32_LEVEL_BITS
> +	#define PT_LEVEL_BITS 10
>  	#define PT_MAX_FULL_LEVELS 2
>  	#define PT_GUEST_DIRTY_SHIFT PT_DIRTY_SHIFT
>  	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
> 
> Paolo
> 
