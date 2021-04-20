Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D183655C2
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 11:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhDTJvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 05:51:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:38524 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229937AbhDTJvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 05:51:45 -0400
Received: from zn.tnic (p200300ec2f0e52003145dfcc247b909a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:5200:3145:dfcc:247b:909a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFCE01EC0103;
        Tue, 20 Apr 2021 11:51:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618912273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nu9NnhXo+DMKJ3rvwlbMifnQjVrpaKGMWoTrw6zuu30=;
        b=fD2V4XGGukrvb+aMl/SUZbaqnmeF+f1AJBhnO35x+YlEOUEd+pt5qKbhpTcyFoQa1rtztW
        jAd7o2oVbz0ciA/NXOwfrOoE7uYONxrhmJOPcwbfk0iwRx7neBH9qi+b+4fDEsCzS92NK7
        glFwpdjvYi2mGQkiO/xepxxLOL6Z7h0=
Date:   Tue, 20 Apr 2021 11:51:15 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding
 the page in RMP table
Message-ID: <20210420095115.GE5029@zn.tnic>
References: <61596c4c-3849-99d5-b0aa-6ad6b415dff9@intel.com>
 <B17112AE-8848-48B0-997D-E1A3D79BD395@amacapital.net>
 <535400b4-0593-a7ca-1548-532ee1fefbd7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <535400b4-0593-a7ca-1548-532ee1fefbd7@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 11:33:08AM -0700, Dave Hansen wrote:
> My point was just that you can't _easily_ do the 2M->4k kernel mapping
> demotion in a page fault handler, like I think Borislav was suggesting.

Yeah, see my reply to Brijesh. Not in the #PF handler but when the guest
does update the RMP table on page allocation, we should split the kernel
mapping too, so that it corresponds to what's being changed in the RMP
table.

Dunno how useful it would be if we also do coalescing of 4K pages into
their corresponding 2M pages... I haven't looked at set_memory.c for a
long time and have forgotten about all details...

In any case, my main goal here is to keep the tables in sync so that we
don't have to do crazy splitting in unsafe contexts like #PF. I hope I'm
making sense...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
