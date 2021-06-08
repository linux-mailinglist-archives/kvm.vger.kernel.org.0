Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543FE39F5E4
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhFHMCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhFHMCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:02:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D391C061574;
        Tue,  8 Jun 2021 05:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DycXleRZZakhNiWk5mkor9tyBuVnVqL3f4nz52Lyagk=; b=irluC+5RhkL+SPw7n56VFsnUa3
        A6KF3/s55ZYxA0h5WQdhlc9VxpnlqkRu8nOP51S/dNz3A31rBJK6S9oxeXGYaBp6omXkVTaJtnaPw
        sA1CuBszTSMZ3el0Og5AtmMUvXw9lHXRA54lx5KW7ZWSbHHNWG26SdVzjtdysBJ8qwWorblycsHxN
        KhZg4ubvQ5PehEEmgLmsFlvxhCaqrZc9CbL+PnsrR/1+U96Fd3vRr5MZ1qfG9jrGeGPfTFHGnjecO
        zmVJFh+nFBQ4uPBzaNuwZQj30AOVpu0rSVoXC11jIOWeScueEcUp1GtrrMROKzQ31brpts3R0AhuL
        +n5P3vXg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lqaNc-00Gu7t-CN; Tue, 08 Jun 2021 11:58:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 34544300258;
        Tue,  8 Jun 2021 13:58:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1DF2722B9AE15; Tue,  8 Jun 2021 13:58:47 +0200 (CEST)
Date:   Tue, 8 Jun 2021 13:58:47 +0200
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
Subject: Re: [PATCH v3 4/7] x86/sev-es: Run #VC handler in plain IRQ state
Message-ID: <YL9bd2hx/y9oD6x/@hirez.programming.kicks-ass.net>
References: <20210608095439.12668-1-joro@8bytes.org>
 <20210608095439.12668-5-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608095439.12668-5-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 11:54:36AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Use irqentry_enter() and irqentry_exit() to track the runtime state of
> the #VC handler. The reason it ran in NMI mode was solely to make sure
> nothing interrupts the handler while the GHCB is in use.
> 
> This is handled now in sev_es_get/put_ghcb() directly, so there is no
> reason the #VC handler can not run in normal IRQ mode and enjoy the
> benefits like being able to send signals.

You sure?

So #VC cannot happen with IRQs disabled?

	raw_spin_lock_irq(&my_lock);
	<#VC>
		raw_spin_lock_irqsave(&my_lock); // whoopsie

Every exception that can happen with IRQs disabled must be NMI like.

Again, what you seem to want is to split the handler in a from-user and
from-kernel way, just like we did with #DB and MCE. See how
exc_debug_user() is IRQ-like and can send signals, while
exc_debug_kernel() is NMI like and can not.


