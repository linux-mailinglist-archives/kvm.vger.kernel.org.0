Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578AE613FBA
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 22:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiJaVPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 17:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiJaVPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 17:15:47 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6DBF02;
        Mon, 31 Oct 2022 14:15:46 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e7f5329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7f5:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFF1F1EC0430;
        Mon, 31 Oct 2022 22:15:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1667250944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=DgU+XgOhdBAORYCQvXhnNLYByJbTFJfkVBopLrqf9iI=;
        b=UBchbjp0cXfAYDiw9MvIMfTMohAQvNHSEOqD0qqH300draA9eAuqTP3tB0n+GzdafOpSSF
        Wn3qr3VbpZy/af3JUemdiT8IjltBlnFK4Jwa7BMsG/jgkXRWcGI5AozcGEKCyqA4ThKP5g
        w59EfXwJZcbCayMtLfvJao65kEkVlNU=
Date:   Mon, 31 Oct 2022 22:15:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     vbabka@suse.cz, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, michael.roth@amd.com,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y2A6/ZwvKhpNBTMP@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic>
 <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 03:10:16PM -0500, Kalra, Ashish wrote:
> Just to add here, writing to any of these pages from the Host
> will trigger a RMP #PF which will cause the RMP page fault handler
> to send a SIGBUS to the current process, as this page is not owned
> by Host.

And kill the host process?

So this is another "policy" which sounds iffy. If we kill the process,
we should at least say why. Are we doing that currently?

> So calling memory_failure() is proactively doing the same, marking the
> page as poisoned and probably also killing the current process.

But the page is not suffering a memory failure - it cannot be reclaimed
for whatever reason. Btw, how can that reclaim failure ever happen? Any
real scenarios?

Anyway, memory failure just happens to fit what you wanna do but you
can't just reuse that - that's hacky. What is the problem with writing
your own function which does that?

Also, btw, please do not top-post.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
