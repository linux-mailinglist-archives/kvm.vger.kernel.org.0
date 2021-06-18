Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB113AC93E
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 12:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhFRK5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 06:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhFRK5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 06:57:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E098C061574;
        Fri, 18 Jun 2021 03:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WXE8AGIvrigHAr3bWkiTQ8lrgYlIfDElqocU4mw+Hqk=; b=DBRrSrmnwX8IhMiypDyD/kXhC7
        +boU6L8ETBEcjztGRQxBjSlCAbA0dNg+PYtDCa9zkXGFl9+6xm7LV524fQHHUqQnkDWzrM8FqdDjk
        JdRZJ7WUVY76TE1Kz5ykIqdg1rDwG0YFzK0qwfj7hpejRnN0r+WC/tEcTo8MzAEfkzgtuS0Q5kxU6
        jrgt0fnGeAbRQhWAQ6AGQsnErqOtDZNrPkzdcC0CJlqp2fZyh5pOzrj5Y689ksfCS33EhcPTfJBLl
        kS3udIaHPKp7tXH3iYPKg/nhK/ix+2GMxD3rQ/AvsSAawuMlYlzL5+kCvt5gefxG79tasJ4B+EblB
        2bdHZdbg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luC7v-00AAwD-3g; Fri, 18 Jun 2021 10:53:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 21546300204;
        Fri, 18 Jun 2021 12:53:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 063ED21BD53A7; Fri, 18 Jun 2021 12:53:29 +0200 (CEST)
Date:   Fri, 18 Jun 2021 12:53:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
Message-ID: <YMx7KDtf7S0W8oxy@hirez.programming.kicks-ass.net>
References: <20210616184913.13064-1-joro@8bytes.org>
 <20210616184913.13064-2-joro@8bytes.org>
 <YMtshtgEbiQ993Zk@hirez.programming.kicks-ass.net>
 <YMxWsjZcudaorPgV@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMxWsjZcudaorPgV@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 10:17:54AM +0200, Joerg Roedel wrote:
> On Thu, Jun 17, 2021 at 05:38:46PM +0200, Peter Zijlstra wrote:
> > I'm getting (with all of v6.1 applied):
> > 
> > vmlinux.o: warning: objtool: __sev_es_nmi_complete()+0x1bf: call to panic() leaves .noinstr.text section
> > 
> > $ ./scripts/faddr2line defconfig-build/vmlinux __sev_es_nmi_complete+0x1bf
> > __sev_es_nmi_complete+0x1bf/0x1d0:
> > __sev_get_ghcb at arch/x86/kernel/sev.c:223
> > (inlined by) __sev_es_nmi_complete at arch/x86/kernel/sev.c:519
> 
> I see where this is coming from, but can't create the same warning. I
> did run 'objtool check -n vmlinux'. Is there more to do to get the full
> check?

You get those when you enable CONFIG_DEBUG_ENTRY=y (make sure to have
PARAVIRT=n, I so need to go fix that :/).
