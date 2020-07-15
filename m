Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785D62208E8
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgGOJea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:34:30 -0400
Received: from [195.135.220.15] ([195.135.220.15]:41518 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgGOJea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:34:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 99D8CAC2D;
        Wed, 15 Jul 2020 09:34:31 +0000 (UTC)
Date:   Wed, 15 Jul 2020 11:34:26 +0200
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 00/75] x86: SEV-ES Guest Support
Message-ID: <20200715093426.GK16200@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200715092456.GE10769@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715092456.GE10769@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 11:24:56AM +0200, Peter Zijlstra wrote:
> Can we get some more words -- preferably in actual code comments, on
> when exactly #VC happens?

Sure, will add this as a comment before the actual runtime VC handler.

> Because the only thing I remember is that #VC could happen on any memop,
> but I also have vague memories of that being a later extention.

Currently it is only raised when something happens that the hypervisor
intercepts, for example on a couple of instructions like CPUID,
RD/WRMSR, ..., or on MMIO/IOIO accesses.

With Secure Nested Paging (SNP), which needs additional enablement, a #VC can
happen on any memory access. I wrote the IST handling entry code for #VC
with that in mind, but do not actually enable it. This is the reason why
the #VC handler just panics the system when it ends up on the fall-back
(VC2) stack, with SNP enabled it needs to handle the SNP exit-codes in
that path.

Regards,

	Joerg
