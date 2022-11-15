Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32646629C14
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 15:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiKOO0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 09:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiKOO0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 09:26:44 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8B01208C;
        Tue, 15 Nov 2022 06:26:43 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7da329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7da:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 865261EC050D;
        Tue, 15 Nov 2022 15:26:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668522402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mSkPxqdKIqJjoCwL26RYPkRZ1rkw1woL6hZqVtjIER8=;
        b=Rk6ExyGQg6KpnHG67DqmVpaDPDRg4H6/QXSTwRysN4jwjMHW0j1f8H90Ud4rRe4XVUHICo
        KAl9r8Ns4EWBwJHHqrnr6BtRxTCdWwd8AKcARDRslAmMG4qgyJHZS2ZYypcBGzWYw8RQ28
        88jMHnryUdQFUtdIEzmJ8MUzujt8q8k=
Date:   Tue, 15 Nov 2022 15:26:38 +0100
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
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y3OhnmRxpqm6Yc8n@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic>
 <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic>
 <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic>
 <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 05:36:29PM -0600, Kalra, Ashish wrote:
> But there is still added complexity of handling hugepages as part of
> reclamation failures (both HugeTLB and transparent hugepages) and that

Why?

You want to offline pfns of 4K pages. What hugepages?

> means calling more static functions in mm/memory_failure.c
> 
> There is probably a more appropriate handler in mm/memory-failure.c:
> 
> soft_offline_page() - this will mark the page as HWPoisoned and also has
> handling for hugepages. And we can avoid adding a new page flag too.

So if some other code wants to dump the amount of all hwpoisoned pages,
it'll dump those too.

Don't you see what is wrong with this picture?

And btw, reusing the hwpoison flag

	PG_offlimits = PG_hwpoison

like previously suggested doesn't help here either.

IOW, I really don't like this lumping of semantics together. ;-\

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
