Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7931EE240
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 12:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgFDKPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 06:15:09 -0400
Received: from 8bytes.org ([81.169.241.247]:46204 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgFDKPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 06:15:05 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D9CA726F; Thu,  4 Jun 2020 12:15:03 +0200 (CEST)
Date:   Thu, 4 Jun 2020 12:15:02 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Subject: Re: [PATCH v3 25/75] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200604101502.GA20739@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-26-joro@8bytes.org>
 <20200520062055.GA17090@linux.intel.com>
 <20200603142325.GB23071@8bytes.org>
 <20200603230716.GD25606@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603230716.GD25606@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 04:07:16PM -0700, Sean Christopherson wrote:
> On Wed, Jun 03, 2020 at 04:23:25PM +0200, Joerg Roedel wrote:
> > User-space can also cause IOIO #VC exceptions, and user-space can be
> > 32-bit legacy code with segments, so es_base has to be taken into
> > account.
> 
> Is there actually a use case for this?  Exposing port IO to userspace
> doesn't exactly improve security.

Might be true, but Linux supports it and this patch-set is not the place
to challenge this feature.

> Given that i386 ABI requires EFLAGS.DF=0 upon function entry/exit, i.e. is
> the de facto default, the DF bug implies this hasn't been tested.  And I
> don't see how this could possibly have worked for SEV given that the kernel
> unrolls string I/O because the VMM can't emulate string I/O.  Presumably
> someone would have complained if they "needed" to run legacy crud.  The
> host and guest obviously need major updates, so supporting e.g. DPDK with
> legacy virtio seems rather silly.

With SEV-ES and this unrolling of string-io doesn't need to happen
anymore. It is on the list of things to improve, but this patch-set is
already pretty big.

> > True, #DBs won't be correct anymore. Currently debugging is not
> > supported in SEV-ES guests anyway, but if it is supported the #DB
> > exception would happen in the #VC handler and not on the original
> > instruction.
> 
> As in, the guest can't debug itself?  Or the host can't debug the guest?

Both, the guest can't debug itself because writes to DR7 never make it
to the hardware DR7 register. And the host obviously can't debug the
guest because it has no access to its unencrypted memory and register
state.

Regards,

	Joerg
