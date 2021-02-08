Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C60313B30
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 18:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhBHRmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 12:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbhBHRkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 12:40:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9CAC061788;
        Mon,  8 Feb 2021 09:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2LaNn/qF13ah973xAp5scg/XoCXhEtsM5ZWpiwsnd4Q=; b=hyYX+n70bqbLDJg9Sqx10LdePn
        jbkVmtfoZx7vzottT/YxNc/v0guqB0G0eHUBAtuhfQNUUlUW3m6jk6e2CvOuWw3zpIyOqOl53SQ1W
        ih2oN1FeVLsRoPrZOtiVvkuCaTg4AMNXlbQGNZjDFL1jR2kF1ibYPt5RWQVpLZlaDwD3Jf42O269r
        7VIP7AcZmCAbSYvo3wPj2uLetU/4uTgfM/gtpHZBWf4DF0DjZ0+HgpRquHFYh1MVjaDLnuD3p0up1
        2ImztteZI+qFVTakUg6I8H8jv352DUazF8XIF4cnBzuBwbYV2oqLrByIqf5g1cpTphNlYcXlZ6g2+
        W0LzlqPg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9AVc-006IA0-Vy; Mon, 08 Feb 2021 17:39:39 +0000
Date:   Mon, 8 Feb 2021 17:39:36 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@ziepe.ca,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com
Subject: Re: [PATCH 1/2] mm: provide a sane PTE walking API for modules
Message-ID: <20210208173936.GA1496438@infradead.org>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205103259.42866-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205103259.42866-2-pbonzini@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
> +			  struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
> +			  spinlock_t **ptlp);

This adds a very pointless overy long line.

> +/**
> + * follow_pte - look up PTE at a user virtual address
> + * @vma: memory mapping
> + * @address: user virtual address
> + * @ptepp: location to store found PTE
> + * @ptlp: location to store the lock for the PTE
> + *
> + * On a successful return, the pointer to the PTE is stored in @ptepp;
> + * the corresponding lock is taken and its location is stored in @ptlp.
> + * The contents of the PTE are only stable until @ptlp is released;
> + * any further use, if any, must be protected against invalidation
> + * with MMU notifiers.
> + *
> + * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
> + * should be taken for read.
> + *
> + * Return: zero on success, -ve otherwise.
> + */
> +int follow_pte(struct mm_struct *mm, unsigned long address,
> +	       pte_t **ptepp, spinlock_t **ptlp)
> +{
> +	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
> +}
> +EXPORT_SYMBOL_GPL(follow_pte);

I still don't think this is good as a general API.  Please document this
as KVM only for now, and hopefully next merge window I'll finish an
export variant restricting us to specific modules.
