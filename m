Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69B22093D
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgGOJvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730000AbgGOJvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:51:53 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC46FC061755;
        Wed, 15 Jul 2020 02:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B3ZNXMdtzOl2XokoISBREh8d9nxYCRmNefNrJYQQBSo=; b=oOXeAQidbZzyeFE7UCspW3f0W4
        m/ZqHaKOVyZU8GAiIVD/XTz1oC1UtT6Uct1DxIuhk+QPUKXVLxCvDYtgYxRRYvVs6QmHhBp0iexPP
        aQW5P9xuX40hne6bOHhDOckCvOT1dHZnfrmtOu8jvk8GL0CHPWwoOpDHJy7QMjliPOex2KX6XaFfb
        FQt8+A49iiYfOkZNp3ScqoSUXajHVGSPqZwYtOPnECivFAM2uMjf/iDKcQbzKM8/MMP2sDK7RaKpw
        n2LYSmhZGN7Pq8tS0xmFttoaQaO8EXQ1k+K9IOf8wshHtE36RNC6oYGijMMSpXyDHLq5NKaH5fAgq
        29Nm+15w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jve4i-0000jr-Gx; Wed, 15 Jul 2020 09:51:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B344B3028C8;
        Wed, 15 Jul 2020 11:51:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9CC92203A5F41; Wed, 15 Jul 2020 11:51:36 +0200 (CEST)
Date:   Wed, 15 Jul 2020 11:51:36 +0200
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
Subject: Re: [PATCH v4 63/75] x86/sev-es: Handle #DB Events
Message-ID: <20200715095136.GG10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-64-joro@8bytes.org>
 <20200715084752.GD10769@hirez.programming.kicks-ass.net>
 <20200715091337.GI16200@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715091337.GI16200@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 11:13:37AM +0200, Joerg Roedel wrote:
> On Wed, Jul 15, 2020 at 10:47:52AM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 14, 2020 at 02:09:05PM +0200, Joerg Roedel wrote:
> > 
> > > @@ -1028,6 +1036,16 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
> > >  	struct ghcb *ghcb;
> > >  
> > >  	lockdep_assert_irqs_disabled();
> > > +
> > > +	/*
> > > +	 * #DB is special and needs to be handled outside of the intrumentation_begin()/end().
> > > +	 * Otherwise the #VC handler could be raised recursivly.
> > > +	 */
> > > +	if (error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB) {
> > > +		vc_handle_trap_db(regs);
> > > +		return;
> > > +	}
> > > +
> > >  	instrumentation_begin();
> > 
> > Wait what?! That makes no sense what so ever.
> 
> Then my understanding of intrumentation_begin/end() is wrong, I thought
> that the kernel will forbid setting breakpoints before
> instrumentation_begin(), which is necessary here because a break-point
> in the #VC handler might cause recursive #VC-exceptions when #DB is
> intercepted.
> Maybe you can elaborate on why this makes no sense?

Kernel avoids breakpoints in any noinstr text, irrespective of
instrumentation_begin().

instrumentation_begin() merely allows one to call !noinstr functions.
