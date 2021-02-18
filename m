Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F42D31E75A
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 09:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhBRITL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 03:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhBRIPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 03:15:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1ABC061756;
        Thu, 18 Feb 2021 00:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rFuCEDruQM3ANvsFui7zHQhN7ske9Q4pPXaIkjwguxg=; b=wOct5ZUuVs84BfzGoHAtevMAst
        U+MwPU+FwceTFebaOa/YfxTXWAlE3yYBCUa2yclPtq7j9EiLnSuhfXTTIzaBsS4IG0tyY2bSG7OMf
        ONF1GFQSMM2z4xupwsset0+VV+KUGXMmBHkkqrDidEVwMIHh3VUDJtRHUTGsm/QwoVbPCK05OvnsK
        j5ZpZUanoMV81iB88ONksrXDTSwsSGxznYijhgkbNqo6kixSzXl4Zgbdwm/MzPkujYjFGpZHXkPgr
        e9HRu8ZxBSaI+o5BItL6q7b87RBFmj9T8aL/hCXUHqmrnB74Tk7YDGjFbhXjugRVAVmMCqaDjHI9w
        KeHlarkw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lCeRs-001Pgy-9q; Thu, 18 Feb 2021 08:14:14 +0000
Date:   Thu, 18 Feb 2021 08:14:08 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH v5 4/8] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Message-ID: <20210218081408.GB335524@infradead.org>
References: <20210209221653.614098-1-namit@vmware.com>
 <20210209221653.614098-5-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209221653.614098-5-namit@vmware.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given that the last patch killed the last previously existing
user of on_each_cpu_cond_mask there are now the only users.

>  	if (info->freed_tables) {
> -		smp_call_function_many(cpumask, flush_tlb_func,
> -			       (void *)info, 1);
> +		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
> +				      cpumask);

.. 

> +		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
> +				      cpumask);

Which means the cond_func is unused, and thus on_each_cpu_cond_mask can
go away entirely in favor of on_each_cpu_cond.
