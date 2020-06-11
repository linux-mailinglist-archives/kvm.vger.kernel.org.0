Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83AF1F6CE6
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 19:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgFKRiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 13:38:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:26022 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgFKRiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 13:38:50 -0400
IronPort-SDR: 3ZMK9pZhqO18Qaheu3/vQuDhayNGWrmmzn9A2/NNrvi5etOv/KzhPguJsE+XxwrdKezzomYRIs
 SLZYOBKhphhg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 10:38:49 -0700
IronPort-SDR: zIXZk1x7swvBXnIsc/AiNUfO/vkCBXoLCKBqY2ZiI1nI4gO/aKwjk7q+8TG3rKNcSjvUQvNDdy
 MFzRBY+uHppg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,500,1583222400"; 
   d="scan'208";a="296669214"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2020 10:38:48 -0700
Date:   Thu, 11 Jun 2020 10:38:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
Subject: Re: [PATCH v3 47/75] x86/sev-es: Add Runtime #VC Exception Handler
Message-ID: <20200611173848.GK29918@linux.intel.com>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-48-joro@8bytes.org>
 <20200523075924.GB27431@zn.tnic>
 <20200611114831.GA11924@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611114831.GA11924@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 01:48:31PM +0200, Joerg Roedel wrote:
> On Sat, May 23, 2020 at 09:59:24AM +0200, Borislav Petkov wrote:
> > On Tue, Apr 28, 2020 at 05:16:57PM +0200, Joerg Roedel wrote:
> > > +	/*
> > > +	 * Mark the per-cpu GHCBs as in-use to detect nested #VC exceptions.
> > > +	 * There is no need for it to be atomic, because nothing is written to
> > > +	 * the GHCB between the read and the write of ghcb_active. So it is safe
> > > +	 * to use it when a nested #VC exception happens before the write.
> > > +	 */
> > 
> > Looks liks that is that text... support for nested #VC exceptions.
> > I'm sure this has come up already but why do we even want to support
> > nested #VCs? IOW, can we do without them first or are they absolutely
> > necessary?
> > 
> > I'm guessing VC exceptions inside the VC handler but what are the
> > sensible use cases?
> 
> The most important use-case is #VC->NMI->#VC. When an NMI hits while the
> #VC handler uses the GHCB and the NMI handler causes another #VC, then
> the contents of the GHCB needs to be backed up, so that it doesn't
> destroy the GHCB contents of the first #VC handling path.

Isn't it possible for the #VC handler to hit a #PF, e.g. on copy_from_user()
in insn_fetch_from_user()?  If that happens, what prevents the #PF handler
from hitting a #VC?  AIUI, do_vmm_communication() panics if the backup GHCB
is already in use, e.g. #VC->#PF->#VC->NMI->#VC would be fatal.
