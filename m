Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD68558C65
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 02:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiFXAqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 20:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFXAqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 20:46:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1FF4FC6F
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:46:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 65so1111139pfw.11
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 17:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uk4RcAkJ2iHz5FftlK5Anuz4Mp+lFEGCK1mbqyMleKM=;
        b=V70GTP6LuazSLZENGZhir7UBvmeZ6RXSpfkpjOF+mwXTeTXmOrCx+eWyZIjxftrtE7
         8nY278CwnnKMQgGkV1g9f0tQf/xWpCUrlvQjBn++nap/hje9l9yRRqfMBiKWiXMx66ny
         ekYLGxK4H+9o6HXM6EWEvNOi6DriPKFG7d6kx4Ewns8qH4Yy8sIwNyd/Eu0gGWEkwU/Q
         oVPtzmDpgpF05uxq0eZnIm00QxQVfGzxVNAH72LZMPR5lxfWFX4XL5A9qCtZwdLiz66p
         i9dj0t93tFwKuZ/FqoqPWA4EImh4+c2GsMFpazTxsaV0jN5H3KyChEsxxaVmpR65OK72
         YF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uk4RcAkJ2iHz5FftlK5Anuz4Mp+lFEGCK1mbqyMleKM=;
        b=AXwPqvUIHAaYr2BRyvm+aOpE3PTlUgQa249qq2yDYVqhC9EsfwXm8Qzsfulc6vB7cj
         5qk2gAuHd7O9uCu2wCZmsy5Z4rkxO24rb/6sUcDhVrVmFA/JWUmbtVFUErMRV58SoLq3
         33lzZErAoVnVkHAB8k4BsdXPVg4BCEBBLO8Vedi/M+4k2g57B4YIdqZ7xonYanUyucXi
         uSp5XWeHxyAa6nb1yhIs/g+UzkTPMXDfXJ7WhPrTxOPrfEm/glacDISWXOlLRfRTa8CD
         B2fHleDKjTMXIJKfVWqwjKNJJt9OHT/0TZusKyKvMqe0FwvLgnN8unArVwYExUmFzdf1
         IWZQ==
X-Gm-Message-State: AJIora/4rq27EAuH0QfFm410SZnHxniP7IopmtYXd99NcH+djzw7apSH
        X1H3Vb/ahD/eWQ8gZwa27eQtHg==
X-Google-Smtp-Source: AGRyM1u3c2BZpFtsdffygFS9wDzKZ1PQNih23PPvAsqc1grUfpDsA8VOwZmZK92i46iH8tH+Riscsw==
X-Received: by 2002:a63:ba07:0:b0:40d:77fd:9429 with SMTP id k7-20020a63ba07000000b0040d77fd9429mr1986334pgf.110.1656031571245;
        Thu, 23 Jun 2022 17:46:11 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d90400b0016767ff327dsm398476plz.129.2022.06.23.17.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 17:46:10 -0700 (PDT)
Date:   Fri, 24 Jun 2022 00:46:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Shukla, Manali" <mashukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 4/8] x86: Improve set_mmu_range() to
 implement npt
Message-ID: <YrUJTt1wfMPotyvW@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-5-manali.shukla@amd.com>
 <YqpyC1HmsFBSXedh@google.com>
 <YqpzjMY+w5MZfb81@google.com>
 <aed29a6c-5e59-d924-f3ed-a3cef91aac79@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed29a6c-5e59-d924-f3ed-a3cef91aac79@amd.com>
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

On Wed, Jun 22, 2022, Shukla, Manali wrote:
> 
> On 6/16/2022 5:34 AM, Sean Christopherson wrote:
> > void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
> > {
> >         u64 orig_opt_mask = pte_opt_mask;
> > 	u64 max = (u64)len + (u64)start;
> > 	u64 phys = start;
> > 
> > 	/* comment goes here. */
> > 	pte_opt_mask |= PT_USER_MASK;
> > 
> >         if (use_hugepages) {
> >                 while (phys + LARGE_PAGE_SIZE <= max) {
> >                         install_large_page(cr3, phys, (void *)(ulong)phys);
> > 		        phys += LARGE_PAGE_SIZE;
> > 	        }
> > 	}
> > 	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> > 
> > 	pte_opt_mask = orig_opt_mask;
> > }
> 
> Hi Sean,
> 
> Thank you so much for reviewing my changes.
> 
> RSVD bit test case will start failing with above implementation as we will be
> setting PT_USER_MASK bit for all host PTEs (in order to toggle CR4.SMEP)
> which will defeat one of the purpose of this patch. 

/facepalm

> Right now, pte_opt_mask value which is set from setup_vm(), is overwritten in
> setup_mmu_range() for all the conditions.  How about setting PT_USER_MASK
> only for nested mmu in setup_mmu_range()?  It will retain the same value of
> pte_opt_mask which is set from setup_vm() in all the other cases.

Ya, that should work.

> #define IS_NESTED_MMU 1ULL
> #define USE_HUGEPAGES 2ULL

Use BIT().  And not the ULL single the param is an unsigned long, not a u64.

> void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, unsigned long mmu_flags) {

Brace goes on its own line.

>         u64 orig_opt_mask = pte_opt_mask;
>         u64 max = (u64)len + (u64)start;
>         u64 phys = start;
> 
>         /* Allocate 4k pages only for nested page table, PT_USER_MASK needs to
	
	/*
	 * Multi-line comments look like this.
	 * Line 2.
	 */

>          * be enabled for nested page.
>          */
>         if (mmu_flags & IS_NESTED_MMU)
>                 pte_opt_mask |= PT_USER_MASK;
> 
>         if (mmu_flags & USE_HUGEPAGES) {
>                 while (phys + LARGE_PAGE_SIZE <= max) {
>                         install_large_page(cr3, phys, (void *)(ulong)phys);
>                         phys += LARGE_PAGE_SIZE;
>                 }
>         }
>         install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> 
>         pte_opt_mask = orig_opt_mask;
> }
> 
> static inline void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len) {
>         __setup_mmu_range(cr3, start, len, USE_HUGEPAGES);
> }
> 
> Thank you,
> Manali
