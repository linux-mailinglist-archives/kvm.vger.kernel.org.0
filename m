Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFD63A43F4
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhFKOWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhFKOWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:22:37 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CC3C0617AF;
        Fri, 11 Jun 2021 07:20:39 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4D7A52FA; Fri, 11 Jun 2021 16:20:37 +0200 (CEST)
Date:   Fri, 11 Jun 2021 16:20:36 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v4 2/6] x86/sev-es: Disable IRQs while GHCB is active
Message-ID: <YMNxNEb/T3iF4TG8@8bytes.org>
References: <20210610091141.30322-1-joro@8bytes.org>
 <20210610091141.30322-3-joro@8bytes.org>
 <YMNtmz6W1apXL5q+@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMNtmz6W1apXL5q+@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 04:05:15PM +0200, Borislav Petkov wrote:
> On Thu, Jun 10, 2021 at 11:11:37AM +0200, Joerg Roedel wrote:
> Why not simply "sandwich" them:
> 
> 	local_irq_save()
> 	sev_es_get_ghcb()
> 
> 	...blablabla
> 
> 	sev_es_put_ghcb()
> 	local_irq_restore();
> 
> in every call site?

I am not a fan of this, because its easily forgotten to add
local_irq_save()/local_irq_restore() calls around those. Yes, we can add
irqs_disabled() assertions to the functions, but we can as well just
disable/enable IRQs in them. Only the previous value of EFLAGS.IF needs
to be carried from one function to the other.

> Hmm, so why aren't you accessing/setting data->ghcb_active and
> data->backup_ghcb_active safely using cmpxchg() if this path can be
> interrupted by an NMI?

Using cmpxchg is not necessary here. It is all per-cpu data, so local to
the current cpu. If an NMI happens anywhere in sev_es_get_ghcb() it can
still use the GHCB, because the interrupted #VC handler will not start
writing to it before sev_es_get_ghcb() returned.

Problems only come up when one path starts writing to the GHCB, but that
happens long after it is marked active.

Regards,

	Joerg
