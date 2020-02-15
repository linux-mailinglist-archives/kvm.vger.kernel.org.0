Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA7915FE85
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 13:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgBOMpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 07:45:44 -0500
Received: from 8bytes.org ([81.169.241.247]:54346 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgBOMpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 07:45:43 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5FA122C2; Sat, 15 Feb 2020 13:45:42 +0100 (CET)
Date:   Sat, 15 Feb 2020 13:45:41 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 41/62] x86/sev-es: Handle MSR events
Message-ID: <20200215124540.GG22063@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-42-joro@8bytes.org>
 <b688b4ad-5a64-d2df-6dd8-e23fac75a6b9@intel.com>
 <20200214072324.GE22063@8bytes.org>
 <d43a1cc5-4229-e1fb-2a7a-d701d7b12ea9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d43a1cc5-4229-e1fb-2a7a-d701d7b12ea9@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 08:59:39AM -0800, Dave Hansen wrote:
> On 2/13/20 11:23 PM, Joerg Roedel wrote:
> > Yes, investigating this is on the list for future optimizations (besides
> > caching CPUID results). My idea is to use alternatives patching for
> > this. But the exception handling is needed anyway because #VC
> > exceptions happen very early already, basically the first thing after
> > setting up a stack is calling verify_cpu(), which uses CPUID.
> 
> Ahh, bummer.  How does a guest know that it's running under SEV-ES?
> What's the enumeration mechanism if CPUID doesn't "work"?

There are two ways a guest can find out:

	1) Read the SEV_STATUS_MSR and check for the SEV-ES bit
	2) If a #VC exception is raised it also knows it runs as an
	   SEV-ES guest

This patch-set implements both ways at the appropriate stages of the
boot process. Very early it just installs a #VC handler without checking
whether it is running under SEV-ES and handles the exceptions when they
are raised.

Later in the boot process it also reads the SEV_STATUS_MSR and sets a
cpu_feature flag to do alternative patching based on its value.

> > The other reason is that things like MMIO and IOIO instructions can't be
> > easily patched by alternatives. Those would work with the runtime
> > checking you showed above, though.
> 
> Is there a reason we can't make a rule that you *must* do MMIO through
> an accessor function so we *can* patch them?  I know random drivers
> might break the rule, but are SEV-ES guests going to be running random
> drivers?  I would think that they mostly if not all want to use
> virtio.

Yeah, there are already defined accessor functions for MMIO, like
read/write[bwlq] and memcpy_toio/memcpy_fromio. It is probably worth
testing what performance overhead is involved in overloading these to
call directly into the paravirt path when SEV-ES is enabled. With
alternatives patching it would still add a couple of NOPS for the
non-SEV-ES case.

But all that does not remove the need for the #VC exception handler, as
#VC exceptions can also be triggered by user-space, and the instruction
emulation for MMIO will be needed to allow MMIO in user-space (the
patch-set currently does not allow that, but it could be needed in the
future).

Regards,

	Joerg

