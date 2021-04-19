Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD4036488F
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhDSQwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbhDSQwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:52:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1528C06174A;
        Mon, 19 Apr 2021 09:52:13 -0700 (PDT)
Received: from zn.tnic (p200300ec2f078100273c47da03104508.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:8100:273c:47da:310:4508])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 035A11EC041D;
        Mon, 19 Apr 2021 18:52:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618851132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=94jXjkCt4HauK1DHA2hJxZxCvyT2mVtOvxDhPFq6mJk=;
        b=SajxfRz88h7tnP2EE+35J7TXUdbrYgNJky9mCSvetZSZl30JHJ+RqVsFrg8oue6sgESzKK
        x25uCP4mC7T4Zn+Zed8wWRQzYkC1U/5gylfGFEaB7yJoi4INErOmt/+zCeJdriAv2vHaA8
        W7qLpJFuGje+uRPF8rWC3MH0HRAEFMY=
Date:   Mon, 19 Apr 2021 18:52:14 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding
 the page in RMP table
Message-ID: <20210419165214.GF9093@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-5-brijesh.singh@amd.com>
 <20210419123226.GC9093@zn.tnic>
 <befbe586-1c45-ebf7-709a-00150365e7ec@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <befbe586-1c45-ebf7-709a-00150365e7ec@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 10:25:01AM -0500, Brijesh Singh wrote:
> To my understanding, we don't group 512 4K entries into a 2M for the
> kernel address range. We do this for the userspace address through
> khugepage daemon. If page tables get out of sync then it will cause an
> RMP violation, the Patch #7 adds support to split the pages on demand.

Ok. So I haven't reviewed the whole thing but, is it possible to keep
the RMP table in sync so that you don't have to split the physmap like
you do in this patch?

I.e., if the physmap page is 2M, then you have a corresponding RMP entry
of 2M so that you don't have to split. And if you have 4K, then the
corresponding RMP entry is 4K. You get the idea...

IOW, when does that happen: "During the page table walk, we may get into
the situation where one of the pages within the large page is owned by
the guest (i.e assigned bit is set in RMP)." In which case is a 4K page
- as part of a 2M physmap mapping - owned by a guest?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
