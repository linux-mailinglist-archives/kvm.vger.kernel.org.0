Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04771E1E36
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 11:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbgEZJTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 05:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731600AbgEZJTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 05:19:17 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CD7C03E97E;
        Tue, 26 May 2020 02:19:17 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f91004890e1585abde4e7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:9100:4890:e158:5abd:e4e7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E9AF21EC01CE;
        Tue, 26 May 2020 11:19:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590484754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3q+7t7sjlYH1ceIvNrmNgbY6YY9E6lQweSEw445KMuQ=;
        b=iKa2bVBpMQp6StjjDbQaxUSuJ6wTp1s+D5je8Zka3UYOO595HcNgIRtDL9u0hOFnuPhGDR
        MQnn6PnjduoWek/zB3TtJ35+Q0grOSS/8KmKwPz0q9/upZHz5W9p3CmZZPhGuWcO6Wb/Nn
        Y120KdDXjix8h/C8LNwg7L1XZb/LHKU=
Date:   Tue, 26 May 2020 11:19:09 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
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
Subject: Re: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
Message-ID: <20200526091909.GB28228@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-65-joro@8bytes.org>
 <20200520051637.GA16599@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200520051637.GA16599@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 10:16:37PM -0700, Sean Christopherson wrote:
> The whole cache on-demand approach seems like overkill.  The number of CPUID
> leaves that are invoked after boot with any regularity can probably be counted
> on one hand.   IIRC glibc invokes CPUID to gather TLB/cache info, XCR0-based
> features, and one or two other leafs.  A statically sized global array that's
> arbitrarily index a la x86_capability would be just as simple and more
> performant.  It would also allow fancier things like emulating CPUID 0xD in
> the guest if you want to go down that road.

And before we do any of that "caching" or whatnot, I'd like to see
numbers justifying its existence. Because if it is only a couple of
CPUID invocations and the boot delay is immeasurable, then it's not
worth the effort.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
