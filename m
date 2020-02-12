Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9753715A9DF
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBLNRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:17:06 -0500
Received: from 8bytes.org ([81.169.241.247]:53838 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgBLNRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 08:17:06 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id AAF1F20E; Wed, 12 Feb 2020 14:17:04 +0100 (CET)
Date:   Wed, 12 Feb 2020 14:16:53 +0100
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
Subject: Re: [PATCH 39/62] x86/sev-es: Harden runtime #VC handler for
 exceptions from user-space
Message-ID: <20200212131652.GH20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-40-joro@8bytes.org>
 <CALCETrXnFr47OEDk8OYrHHW=1XNAQMUB=wPevhLM6ROnO6_Rog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXnFr47OEDk8OYrHHW=1XNAQMUB=wPevhLM6ROnO6_Rog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:47:05PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > From: Joerg Roedel <jroedel@suse.de>
> >
> > Send SIGBUS to the user-space process that caused the #VC exception
> > instead of killing the machine. Also ratelimit the error messages so
> > that user-space can't flood the kernel log.
> 
> What would cause this?  CPUID?  Something else?

Yes, CPUID, RDTSC(P) and, most importantly, user-space mapping some IO
space an accessing it, causing MMIO #VC exceptions.

Especially the MMIO case has so many implications that it will not be
supported at the moment. Imagine for example MMIO accesses by 32bit
user-space with non-standard, non-zero based code and data segments. Or
user-space changing the instruction bytes between when the #VC exception
is raised and when the handler parses the instruction. Lots of checks
are needed to make this work securely, and the complexity of this is not
worth it at this time.


Regards,

	Joerg

