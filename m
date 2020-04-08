Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E43B1A1FB5
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 13:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgDHLRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 07:17:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgDHLRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 07:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3YJqaOoM4AXHXL0XANzFtbQE1EpTeXAe0og/pFKkpCA=; b=I26DyJnGGGzpg8aW0CSl3TSO8/
        fCLcInYqjvbFiDB3N97TYX+H95E7s7uhQVs1LywnJrxvQAyQKrsXOH4HCqon7QCoisfEoaw6RVFDS
        NQOCO/S4ycVdQoxRL46SZ2UfRTHDCE0HFlkAY/BrTNmWRge1970iZq7hPoYzBfUytDGspcPrPDjhj
        lDsRcJWFs6qo8zxx5srQ71V1LToOn2jGFgto63isvIjWn9uZp/yp5qMXQVuaeLYT2wjloOAyaBt4C
        CZadKhWG7I0rpK07+OqaLbMseS8zTcP0JuX9+Fe8qNltNOQHzKTM5TMcUHTWVQtPsjS20OYk7jLcj
        W3k8stdA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jM8iL-0000RC-Gm; Wed, 08 Apr 2020 11:17:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C4D5B300130;
        Wed,  8 Apr 2020 13:17:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B0E612BA90A63; Wed,  8 Apr 2020 13:17:47 +0200 (CEST)
Date:   Wed, 8 Apr 2020 13:17:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        jpoimboe@redhat.com, namit@vmware.com, mhiramat@kernel.org,
        jgross@suse.com, bp@alien8.de, vkuznets@redhat.com,
        pbonzini@redhat.com, boris.ostrovsky@oracle.com,
        mihai.carabas@oracle.com, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 14/26] x86/alternatives: Handle native insns in
 text_poke_loc*()
Message-ID: <20200408111747.GV20713@hirez.programming.kicks-ass.net>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <20200408050323.4237-15-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408050323.4237-15-ankur.a.arora@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Tue, Apr 07, 2020 at 10:03:11PM -0700, Ankur Arora wrote:
> @@ -1071,10 +1079,13 @@ int notrace poke_int3_handler(struct pt_regs *regs)
>  			goto out_put;
>  	}
>  
> -	len = text_opcode_size(tp->opcode);
> +	if (desc->native)
> +		BUG();
> +

Subject: x86/alternatives: Handle native insns in text_poke_loc*()

That's not really handling, is it..
