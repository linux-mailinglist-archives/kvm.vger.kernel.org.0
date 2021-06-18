Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6B3AC603
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhFRI1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 04:27:24 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59296 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhFRI1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 04:27:20 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A08591FDF6;
        Fri, 18 Jun 2021 08:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624004708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6MJAIsLVgqXfW5lwfZV7HOLJW17Cm0NEkHH1qVZkSE=;
        b=e2K8BVdia2rtzCx8g9U0y0K5QFEUTW6+tRBPdUKB1/9rUgIoHo69R4uqIfzkQYeVzE5Vnp
        qHZ+KH7deAYpjZj5NgxCopEAM7/qSVz8W26Yrcjik7+6jfSLnq2Ilc8w8Obg3edPP7I0ia
        sp+YXzpmdkpkG/3juEFrbxx70lq/rX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624004708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6MJAIsLVgqXfW5lwfZV7HOLJW17Cm0NEkHH1qVZkSE=;
        b=05L887bTpKMQfMGEUgoeZ0S9x5jtN6qake3lq4t7r92HDvG2EfnO3sp26PCC6HgXQlFqw5
        l1RrDidk2KmJJzBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D3D7C118DD;
        Fri, 18 Jun 2021 08:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624004708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6MJAIsLVgqXfW5lwfZV7HOLJW17Cm0NEkHH1qVZkSE=;
        b=e2K8BVdia2rtzCx8g9U0y0K5QFEUTW6+tRBPdUKB1/9rUgIoHo69R4uqIfzkQYeVzE5Vnp
        qHZ+KH7deAYpjZj5NgxCopEAM7/qSVz8W26Yrcjik7+6jfSLnq2Ilc8w8Obg3edPP7I0ia
        sp+YXzpmdkpkG/3juEFrbxx70lq/rX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624004708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6MJAIsLVgqXfW5lwfZV7HOLJW17Cm0NEkHH1qVZkSE=;
        b=05L887bTpKMQfMGEUgoeZ0S9x5jtN6qake3lq4t7r92HDvG2EfnO3sp26PCC6HgXQlFqw5
        l1RrDidk2KmJJzBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id mnUcMmNYzGCmfgAALh3uQQ
        (envelope-from <jroedel@suse.de>); Fri, 18 Jun 2021 08:25:07 +0000
Date:   Fri, 18 Jun 2021 10:25:06 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 1/2] x86/sev: Make sure IRQs are disabled while GHCB
 is active
Message-ID: <YMxYYkawXh1kZ/jf@suse.de>
References: <20210616184913.13064-1-joro@8bytes.org>
 <20210616184913.13064-2-joro@8bytes.org>
 <YMtjoLLQpKyveVlS@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMtjoLLQpKyveVlS@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 05:00:48PM +0200, Peter Zijlstra wrote:
> I think this is broken, at this point RCU is quite dead on this CPU and
> local_irq_save/restore include tracing and all sorts.
> 
> Also, shouldn't IRQs already be disabled by the time we get here?

Yes it is, I removed these calls, made __sev_get/put_ghcb() noinstr
instead of __always_inline and put instrumentation_begin()/end() around
the panic() call in __sev_get_ghcb().

Regards,

	Joerg
