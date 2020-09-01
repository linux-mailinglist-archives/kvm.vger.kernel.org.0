Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0697C258FDC
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgIAOIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 10:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728296AbgIANzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 09:55:49 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619BAC061244;
        Tue,  1 Sep 2020 06:55:48 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 9D02D391; Tue,  1 Sep 2020 15:55:46 +0200 (CEST)
Date:   Tue, 1 Sep 2020 15:55:45 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH v6 69/76] x86/realmode: Setup AP jump table
Message-ID: <20200901135545.GE22385@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-70-joro@8bytes.org>
 <20200831170937.GK27517@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831170937.GK27517@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 31, 2020 at 07:09:37PM +0200, Borislav Petkov wrote:
> On Mon, Aug 24, 2020 at 10:55:04AM +0200, Joerg Roedel wrote:
> > +	/* Check if AP Jump Table is non-zero and page-aligned */
> > +	if (!jump_table_addr || jump_table_addr & ~PAGE_MASK)
> > +		return 0;
> 
> I think you need to return !0 here so that the panic() below fires with
> a modified message:
> 
> 	panic("Failed to get/update SEV-ES AP Jump Table");
> 
> or are we gonna boot an UP guest still?

Right, this needs a !0 return value. This code runs once on the boot CPU
before the kernel starts the secondary CPUs, so a panic() is the right
thing to do if this fails.

Regards,

	Joerg
