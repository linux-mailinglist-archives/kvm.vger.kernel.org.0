Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6D6129C7
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 10:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfECITM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 04:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbfECITL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 04:19:11 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35BEF330247;
        Fri,  3 May 2019 08:19:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DF825C23A;
        Fri,  3 May 2019 08:19:07 +0000 (UTC)
Date:   Fri, 3 May 2019 10:19:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     nadav.amit@gmail.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/alloc_page: Zero allocated pages
Message-ID: <20190503081905.ua4htmjpqrhsqgn3@kamzik.brq.redhat.com>
References: <20190502154038.8267-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502154038.8267-1-nadav.amit@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 03 May 2019 08:19:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 08:40:38AM -0700, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> One of the most important properties of tests is reproducibility. For
> tests to be reproducible, the same environment should be set on each
> test invocation.
> 
> When it comes to memory content, this is not exactly the case in
> kvm-unit-tests. The tests might, mistakenly or intentionally, assume
> that memory is zeroed, which apparently is the case after seabios runs.
> However, failures might not be reproducible if this assumption is
> broken.
> 
> As an example, consider x86 do_iret(), which mistakenly does not push
> SS:RSP onto the stack on 64-bit mode, although they are popped
> unconditionally.
> 
> Do not assume that memory is zeroed. Clear it once it is allocated to
> allow tests to easily be reproducible.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/alloc_page.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 730f2b5..b0f4515 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -65,6 +65,7 @@ void *alloc_page()
>  	freelist = *(void **)freelist;
>  	spin_unlock(&lock);
>  
> +	memset(p, 0, PAGE_SIZE);
>  	return p;
>  }
>  
> -- 
> 2.17.1
>

I think this is reasonable, but if we make this change then we should
remove the now redundant page zeroing too. A quick grep shows 20
instances

 $ git grep -A1 alloc_page | grep memset | grep 0, | wc -l
 20

There may be more.

Thanks,
drew
