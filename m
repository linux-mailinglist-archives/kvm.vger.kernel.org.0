Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F6C1EAD3
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfEOJSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 05:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfEOJSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 05:18:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6E06356DF;
        Wed, 15 May 2019 09:18:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD5195D706;
        Wed, 15 May 2019 09:18:51 +0000 (UTC)
Date:   Wed, 15 May 2019 11:18:49 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/4] lib/alloc_page: Zero allocated
 pages
Message-ID: <20190515091849.v3zsdb2cxodn7ky3@kamzik.brq.redhat.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
 <20190509200558.12347-2-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509200558.12347-2-nadav.amit@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 15 May 2019 09:18:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 01:05:55PM -0700, Nadav Amit wrote:
> One of the most important properties of tests is reproducibility. For
> tests to be reproducible, the same environment should be set on each
> test invocation.
> 
> When it comes to memory content, this is not exactly the case in
> kvm-unit-tests. The tests might, mistakenly or intentionally, assume
> that memory is zeroed (by the BIOS or KVM).  However, failures might not
> be reproducible if this assumption is broken.
> 
> As an example, consider x86 do_iret(), which mistakenly does not push
> SS:RSP onto the stack on 64-bit mode, although they are popped
> unconditionally on iret.
> 
> Do not assume that memory is zeroed. Clear it once it is allocated to
> allow tests to easily be reproduced.
> 
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/alloc_page.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 730f2b5..97d1339 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -65,6 +65,8 @@ void *alloc_page()
>  	freelist = *(void **)freelist;
>  	spin_unlock(&lock);
>  
> +	if (p)
> +		memset(p, 0, PAGE_SIZE);
>  	return p;
>  }
>  
> @@ -126,6 +128,8 @@ void *alloc_pages(unsigned long order)
>  		}
>  	}
>  	spin_unlock(&lock);
> +	if (run_start)
> +		memset(run_start, 0, n * PAGE_SIZE);
>  	return run_start;
>  }
>  
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
