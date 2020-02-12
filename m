Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A05B15AA96
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgBLN7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:59:44 -0500
Received: from 8bytes.org ([81.169.241.247]:53960 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgBLN7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 08:59:44 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id BE6EC20E; Wed, 12 Feb 2020 14:59:42 +0100 (CET)
Date:   Wed, 12 Feb 2020 14:59:34 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Juergen Gross <JGross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [RFC PATCH 00/62] Linux as SEV-ES Guest Support
Message-ID: <20200212135934.GL20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <BD48E405-8E3F-4EEE-A72A-8A7EDCB6A376@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BD48E405-8E3F-4EEE-A72A-8A7EDCB6A376@amacapital.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 07:48:12PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Feb 11, 2020, at 5:53 AM, Joerg Roedel <joro@8bytes.org> wrote:
> 
> > 
> > 
> >    * Putting some NMI-load on the guest will make it crash usually
> >      within a minute
> 
> Suppose you do CPUID or some MMIO and get #VC. You fill in the GHCB to
> ask for help. Some time between when you start filling it out and when
> you do VMGEXIT, you get NMI. If the NMI does its own GHCB access [0],
> it will clobber the outer #VC’a state, resulting in a failure when
> VMGEXIT happens. There’s a related failure mode if the NMI is after
> the VMGEXIT but before the result is read.
> 
> I suspect you can fix this by saving the GHCB at the beginning of
> do_nmi and restoring it at the end. This has the major caveat that it
> will not work if do_nmi comes from user mode and schedules, but I
> don’t believe this can happen.
> 
> [0] Due to the NMI_COMPLETE catastrophe, there is a 100% chance that
> this happens.

Very true, thank you! You probably saved me a few hours of debugging
this further :)
I will implement better handling for nested #VC exceptions, which
hopefully solves the NMI crashes.

Thanks again,

       Joerg
