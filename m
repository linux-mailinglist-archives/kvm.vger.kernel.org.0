Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4952208B3
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgGOJ0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:26:42 -0400
Received: from [195.135.220.15] ([195.135.220.15]:36262 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbgGOJ0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:26:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D1F0AF6F;
        Wed, 15 Jul 2020 09:26:44 +0000 (UTC)
Date:   Wed, 15 Jul 2020 11:26:38 +0200
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
Message-ID: <20200715092638.GJ16200@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-71-joro@8bytes.org>
 <202007141837.2B93BBD78@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007141837.2B93BBD78@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kees,

thanks for your reviews!

On Tue, Jul 14, 2020 at 06:40:30PM -0700, Kees Cook wrote:
> Eek, no. MSR_IA32_MISC_ENABLE_XD_DISABLE needs to be cleared very early
> during CPU startup; this can't just be skipped.

That MSR is Intel-only, right? The boot-path installed here is only used
for SEV-ES guests, running on AMD systems, so this MSR is not even
accessed during boot on those VMs.

The alternative is to set up exception handling prior to calling
verify_cpu, including segments, stack and IDT. Given that verify_cpu()
does not add much value to SEV-ES guests, I'd like to avoid adding this
complexity.

> Also, is UNWIND_HINT_EMPTY needed for the new target?

Yes, I think it is, will add it in the next version.

Regards,

	Joerg
