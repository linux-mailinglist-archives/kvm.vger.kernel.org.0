Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486351A1FEB
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 13:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgDHLgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 07:36:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgDHLgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 07:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BmUpeBD+1tkdQ4tsE6HQqpMf3ktolc1V6p/HWEY98HY=; b=Qi5xW5e0IyX3C7czAvN4b9USKe
        Vw9AbT0hUhEsMc1N29Rjr5JF4PixkRwKoB2k7CHbQKlhhwdI1gHZDWzkIC/T4W3XpYwGK22A3OD5f
        YKOR/wZquke/IPYf/tjWI2lDstAxcpTdxYF/D0CVP6LcMHwWMxOEMFYdGFZiwekJE6baYqsYbNNdj
        VG6eu4ZlrMcD4swRR19FENQfTY/PhgNUrGXs7/3vtIkFJ8qruO7bPZyDME/fAI98LYIqRAeuyV57a
        adom5zNbI+HwxK7C/0/zE6K+9Pmygi92/oQ7XoIP89JEZTSZylxoRwf+X6weK/tFwvTqc0h2UD0Bx
        weCYpnBw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jM90T-0003t1-3O; Wed, 08 Apr 2020 11:36:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 400EE304DB2;
        Wed,  8 Apr 2020 13:36:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2C1832BA90A66; Wed,  8 Apr 2020 13:36:31 +0200 (CEST)
Date:   Wed, 8 Apr 2020 13:36:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        jpoimboe@redhat.com, namit@vmware.com, mhiramat@kernel.org,
        jgross@suse.com, bp@alien8.de, vkuznets@redhat.com,
        pbonzini@redhat.com, boris.ostrovsky@oracle.com,
        mihai.carabas@oracle.com, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 19/26] x86/alternatives: NMI safe runtime patching
Message-ID: <20200408113631.GX20713@hirez.programming.kicks-ass.net>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <20200408050323.4237-20-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408050323.4237-20-ankur.a.arora@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 10:03:16PM -0700, Ankur Arora wrote:
> @@ -1807,12 +1911,20 @@ static int __maybe_unused text_poke_late(patch_worker_t worker, void *stage)
>  	text_poke_state.state = PATCH_SYNC_DONE; /* Start state */
>  	text_poke_state.primary_cpu = smp_processor_id();
>  
> +	text_poke_state.nmi_context = nmi;
> +
> +	if (nmi)
> +		register_nmi_handler(NMI_LOCAL, text_poke_nmi,
> +				     NMI_FLAG_FIRST, "text_poke_nmi");
>  	/*
>  	 * Run the worker on all online CPUs. Don't need to do anything
>  	 * for offline CPUs as they come back online with a clean cache.
>  	 */
>  	ret = stop_machine(patch_worker, &text_poke_state, cpu_online_mask);
>  
> +	if (nmi)
> +		unregister_nmi_handler(NMI_LOCAL, "text_poke_nmi");
> +
>  	return ret;
>  }

This is completely bonghits crazy.
