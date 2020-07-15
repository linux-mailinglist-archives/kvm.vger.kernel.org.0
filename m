Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD44F220951
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgGOJ4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgGOJ4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:56:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DE2C061755;
        Wed, 15 Jul 2020 02:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=icvsh0UAC9qH2aXd5iDWHDNfzNryn9ZQFj2YeE2x3Lo=; b=aVqwxJf/YogDENWanh6k54iAGI
        9UWG/KMCQJeVdsLop0VPQ79Zr/SQfouIqOsOlLMxUwWnqkkXy4Oh6Sdw/0KZmzWZ+HycSExS2RqNy
        4dCX+oEmw4S4UUGMrF4jUES2V8rnOvJZW5gkCi41UyGni8n7w/OrL1RNO/WQxMeHqsC2fiV7h7ERZ
        78bzlQI2ze2+W5xpUlOrrCFcz/VkLV+AAj1M68CU/vKoQVKVDI+82A0HARYOp8qUjd6peTUn0XET0
        PNeM9BfgcQNefofCusAPr5QFt3rPrPGPI7BUEVpSgW60HTQaWwS/lB8IqzlYdsOcP1WPds8VPAGzb
        ri6mySkA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jve8s-0001Wv-P0; Wed, 15 Jul 2020 09:55:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E514A302753;
        Wed, 15 Jul 2020 11:55:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D1352207A6655; Wed, 15 Jul 2020 11:55:56 +0200 (CEST)
Date:   Wed, 15 Jul 2020 11:55:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 00/75] x86: SEV-ES Guest Support
Message-ID: <20200715095556.GI10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200715092456.GE10769@hirez.programming.kicks-ass.net>
 <20200715093426.GK16200@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715093426.GK16200@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 11:34:26AM +0200, Joerg Roedel wrote:
> On Wed, Jul 15, 2020 at 11:24:56AM +0200, Peter Zijlstra wrote:
> > Can we get some more words -- preferably in actual code comments, on
> > when exactly #VC happens?
> 
> Sure, will add this as a comment before the actual runtime VC handler.

Thanks!

> > Because the only thing I remember is that #VC could happen on any memop,
> > but I also have vague memories of that being a later extention.
> 
> Currently it is only raised when something happens that the hypervisor
> intercepts, for example on a couple of instructions like CPUID,
> RD/WRMSR, ..., or on MMIO/IOIO accesses.
> 
> With Secure Nested Paging (SNP), which needs additional enablement, a #VC can
> happen on any memory access. I wrote the IST handling entry code for #VC
> with that in mind, but do not actually enable it. This is the reason why
> the #VC handler just panics the system when it ends up on the fall-back
> (VC2) stack, with SNP enabled it needs to handle the SNP exit-codes in
> that path.

And recursive #VC was instant death, right? Because there's no way to
avoid IST stack corruption in that case.
