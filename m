Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6231ED331
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 17:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFCPVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 11:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCPVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 11:21:11 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E784C08C5C0;
        Wed,  3 Jun 2020 08:21:11 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 9CA3B28B; Wed,  3 Jun 2020 17:21:09 +0200 (CEST)
Date:   Wed, 3 Jun 2020 17:21:08 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 35/75] x86/head/64: Build k/head64.c with
 -fno-stack-protector
Message-ID: <20200603152108.GD23071@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-36-joro@8bytes.org>
 <20200519091526.GB444@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519091526.GB444@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 11:15:26AM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:45PM +0200, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > The code inserted by the stack protector does not work in the early
> > boot environment because it uses the GS segment, at least with memory
> > encryption enabled.
> 
> Can you elaborate on why is that a problem?
> 
> The stack cookie is not generated that early yet so it should be
> comparing %gs:40 to 0.

Yes, and when GS_BASE is 0 it will dereference NULL pointer, which
generates a page-fault before the kernel is able to handle it.


	Joerg
