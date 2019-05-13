Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2391B9BE
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 17:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbfEMPQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 11:16:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56250 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfEMPQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 11:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fZCXLRK6siZkJzRThAZU41Qk9STzd0Ms+LwmndLzT4U=; b=dOoxRqeIU0IcG57wCspBazrWD
        09pvLZ3B5B5JIvlkaPW2v9wmDfMD64eHIMMM9VvHovmSQKCVTDs7AE4x5WHR7JayzOyj0JrbYDzto
        ib/qLZIhKW6+9A9vmS6HmBS/La4Q8rd9fYbZQHpxTGe4fty4HDIjEm12v3yGcwPrVPWKPQb5fN8J4
        Sb8DsdDGSKgndaqMp41piHOpX3l/9BQxCbIIi+bigL7I/3SyPyENVxM/pguzcSVXd93Vsm7UtGVx8
        wQyZBWobruR2cR6mtbgUMTPFk/d/d7NZw3IEuj7HoEUIK5wB4IyvT2P1fkqsaxnzVT2JIKk5vnAFX
        I9EMq7JEw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQCgx-00083R-0e; Mon, 13 May 2019 15:16:39 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C83E22029F877; Mon, 13 May 2019 17:16:37 +0200 (CEST)
Date:   Mon, 13 May 2019 17:16:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com
Subject: Re: [RFC KVM 25/27] kvm/isolation: implement actual KVM isolation
 enter/exit
Message-ID: <20190513151637.GA2589@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-26-git-send-email-alexandre.chartre@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557758315-12667-26-git-send-email-alexandre.chartre@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 04:38:33PM +0200, Alexandre Chartre wrote:
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index a4db7f5..7ad5ad1 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -444,6 +444,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
>  		switch_ldt(real_prev, next);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(switch_mm_irqs_off);
>  
>  /*
>   * Please ignore the name of this function.  It should be called

NAK
