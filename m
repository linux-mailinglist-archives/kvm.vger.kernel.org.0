Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9BE1B8692
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 14:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgDYMtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 08:49:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:43690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgDYMtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 08:49:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08E85AD10;
        Sat, 25 Apr 2020 12:49:12 +0000 (UTC)
Date:   Sat, 25 Apr 2020 14:49:09 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>, joro@8bytes.org,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, jgross@suse.com, jslaby@suse.cz,
        keescook@chromium.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        peterz@infradead.org, thellstrom@vmware.com,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] Allow RDTSC and RDTSCP from userspace
Message-ID: <20200425124909.GO30814@suse.de>
References: <20200319091407.1481-56-joro@8bytes.org>
 <20200424210316.848878-1-mstunes@vmware.com>
 <2c49061d-eb84-032e-8dcb-dd36a891ce90@intel.com>
 <ead88d04-1756-1190-2b37-b24f86422595@amd.com>
 <4d2ac222-a896-a60e-9b3c-b35aa7e81a97@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d2ac222-a896-a60e-9b3c-b35aa7e81a97@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,

On Fri, Apr 24, 2020 at 03:53:09PM -0700, Dave Hansen wrote:
> Ahh, so any instruction that can have an instruction intercept set
> potentially needs to be able to tolerate a #VC?  Those instruction
> intercepts are under the control of the (untrusted relative to the
> guest) hypervisor, right?
> 
> >From the main sev-es series:
> 
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +idtentry vmm_communication     do_vmm_communication    has_error_code=1
> +#endif

The next version of the patch-set (which I will hopefully have ready
next week) will have this changed. The #VC exception handler uses an IST
stack and is set to paranoid=1 and shift_ist. The IST stacks for the #VC
handler are only allocated when SEV-ES is active.

> That's a fun point because it means that the (untrusted) hypervisor can
> cause endless faults.  I *guess* we have mitigation for this with our
> stack guard pages, but it's still a bit nasty that the hypervisor can
> arbitrarily land a guest in the double-fault handler.
> 
> It just all seems a bit weak for the hypervisor to be considered
> untrusted.  But, it's _certainly_ a steep in the right direction from SEV.

Yeah, a malicious hypervisor can do bad things to an SEV-ES VM, but it
can't easily steal its secrets from memory or registers. The #VC handler
does its best to just crash the VM if unexpected hypervisor behavior is
detected.


Regards,

	Joerg
