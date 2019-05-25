Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81A72A727
	for <lists+kvm@lfdr.de>; Sat, 25 May 2019 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfEYVvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 May 2019 17:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfEYVvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 May 2019 17:51:21 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7150B20717;
        Sat, 25 May 2019 21:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558821080;
        bh=9GojVzJw4LUT0FwL1uJ2uxQz/GR22xKEGuM8E5lF4U4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yeCoL/9YBkEk1sCDuZGtqcOLLhjEc3XPpvmQxhmXpl1ivii7ueziKdgVyPiry9ByA
         ADOT2OgdVR0DYv4LRRgW5QSfW6vt2A05lzKc6kYMl7/+P1G4g6y87rsbUW7KSF+/pj
         wELWVZx/6l9yaDm7Gysp2a6pdP0M1R6mJkI2X3yI=
Date:   Sat, 25 May 2019 14:51:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, Alan Tull <atull@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Moritz Fischer <mdf@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Steve Sistare <steven.sistare@oracle.com>,
        Wu Hao <hao.wu@intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: add account_locked_vm utility function
Message-Id: <20190525145118.bfda2d75a14db05a001e49ad@linux-foundation.org>
In-Reply-To: <20190524175045.26897-1-daniel.m.jordan@oracle.com>
References: <de375582-2c35-8e8a-4737-c816052a8e58@ozlabs.ru>
        <20190524175045.26897-1-daniel.m.jordan@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 May 2019 13:50:45 -0400 Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> locked_vm accounting is done roughly the same way in five places, so
> unify them in a helper.  Standardize the debug prints, which vary
> slightly, but include the helper's caller to disambiguate between
> callsites.
> 
> Error codes stay the same, so user-visible behavior does too.  The one
> exception is that the -EPERM case in tce_account_locked_vm is removed
> because Alexey has never seen it triggered.
> 
> ...
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1564,6 +1564,25 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  int get_user_pages_fast(unsigned long start, int nr_pages,
>  			unsigned int gup_flags, struct page **pages);
>  
> +int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
> +			struct task_struct *task, bool bypass_rlim);
> +
> +static inline int account_locked_vm(struct mm_struct *mm, unsigned long pages,
> +				    bool inc)
> +{
> +	int ret;
> +
> +	if (pages == 0 || !mm)
> +		return 0;
> +
> +	down_write(&mm->mmap_sem);
> +	ret = __account_locked_vm(mm, pages, inc, current,
> +				  capable(CAP_IPC_LOCK));
> +	up_write(&mm->mmap_sem);
> +
> +	return ret;
> +}

That's quite a mouthful for an inlined function.  How about uninlining
the whole thing and fiddling drivers/vfio/vfio_iommu_type1.c to suit. 
I wonder why it does down_write_killable and whether it really needs
to...

