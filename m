Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFF522A97D
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 09:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGWHVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 03:21:06 -0400
Received: from 8bytes.org ([81.169.241.247]:58794 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgGWHVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 03:21:05 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E2EE4346; Thu, 23 Jul 2020 09:21:03 +0200 (CEST)
Date:   Thu, 23 Jul 2020 09:21:02 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Mike Stunes <mstunes@vmware.com>
Cc:     Joerg Roedel <jroedel@suse.de>, "x86@kernel.org" <x86@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Message-ID: <20200723072102.GN27672@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-52-joro@8bytes.org>
 <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
 <20200722080530.GH6132@suse.de>
 <7020C1D2-5900-4AD8-ADCD-04A571DF2EA7@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7020C1D2-5900-4AD8-ADCD-04A571DF2EA7@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On Wed, Jul 22, 2020 at 10:53:02PM +0000, Mike Stunes wrote:
> Thanks Joerg! With that change in place, this kernel boots normally.
> What was the problem?

The problem was that the code got its page-table from
current->active_mm. But these pointers are not set up during early boot,
so that the #VC handler can't walk the page-table and propagates a
page-fault every time. This loops forever.

Getting the page-table from CR3 instead works at all stages of the
systems runtime.

Regards,

	Joerg
