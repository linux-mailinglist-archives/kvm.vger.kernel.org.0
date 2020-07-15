Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39FB22118A
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgGOPtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 11:49:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgGOPtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 11:49:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FA51ABE4;
        Wed, 15 Jul 2020 15:49:02 +0000 (UTC)
Date:   Wed, 15 Jul 2020 17:48:56 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 70/75] x86/head/64: Don't call verify_cpu() on
 starting APs
Message-ID: <20200715154856.GA24822@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-71-joro@8bytes.org>
 <202007141837.2B93BBD78@keescook>
 <20200715092638.GJ16200@suse.de>
 <202007150815.A81E879@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007150815.A81E879@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kees,

as a general note: With SEV-ES the guest kernel will get #VC exceptions
for events that, without SEV-ES, would just cause a #VMEXIT to the
hypervisor.

On Wed, Jul 15, 2020 at 08:26:14AM -0700, Kees Cook wrote:
> On Wed, Jul 15, 2020 at 11:26:38AM +0200, Joerg Roedel wrote:
> > That MSR is Intel-only, right? The boot-path installed here is only used
> > for SEV-ES guests, running on AMD systems, so this MSR is not even
> > accessed during boot on those VMs.
> 
> Oh, hrm, yes, that's true. If other x86 maintainers are comfortable with
> this, then okay. My sense is that changing the early CPU startup paths
> will cause trouble down the line.

The AP startup path does not change for non SEV-ES guests. But under
SEV-ES everything that might cause a #VC exception must be avoided until
the kernel is ready to handle them. With the current patches this
happens when the AP runs in 64bit long-mode and loaded TSS and IDT.
Therefore a slightly different AP boot-path is needed for SEV-ES guests.

> So, going back to the requirements here ... what things in verify_cpu()
> can cause exceptions? AFAICT, cpuid is safely handled (i.e. it is
> detected and only run in a way to avoid exceptions and the MSR
> reads/writes are similarly bound by CPU family/id range checks). I must
> be missing something. :)

It is actually the CPUID instructions that cause #VC exceptions. The
MSRs that are accessed on AMD processors are not intercepted in the
hypervisors this code has been tested on, so these will not cause #VC
exceptions.

Regards,

	Joerg
