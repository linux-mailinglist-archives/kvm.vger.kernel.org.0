Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C6915AA85
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgBLN47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:56:59 -0500
Received: from 8bytes.org ([81.169.241.247]:53924 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbgBLN47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 08:56:59 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 44D5E20E; Wed, 12 Feb 2020 14:56:57 +0100 (CET)
Date:   Wed, 12 Feb 2020 14:56:45 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 62/62] x86/sev-es: Add NMI state tracking
Message-ID: <20200212135645.GK20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-63-joro@8bytes.org>
 <CALCETrWV15+YTGsEwUHBSjT2MYappLANw4fQHjgZgei2UyV1JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWV15+YTGsEwUHBSjT2MYappLANw4fQHjgZgei2UyV1JQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:50:29PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> This patch is overcomplicated IMO.  Just do the magic incantation in C
> from do_nmi or from here:
> 
>         /*
>          * For ease of testing, unmask NMIs right away.  Disabled by
>          * default because IRET is very expensive.
> 
> If you do the latter, you'll need to handle the case where the NMI
> came from user mode.
> 
> The ideal solution is do_nmi, I think.
> 
> if (static_cpu_has(X86_BUG_AMD_FORGOT_ABOUT_NMI))
>   sev_es_unmask_nmi();
> 
> Feel free to use X86_FEATURE_SEV_ES instead :)

Yeah, I also had that implemented once, but then changed it because I
thought that nested NMIs do not necessarily call into do_nmi(), which
would cause NMIs to stay blocked forever. I need to read through the NMI
entry code again to check if that can really happen.

Regards,

	Joerg
