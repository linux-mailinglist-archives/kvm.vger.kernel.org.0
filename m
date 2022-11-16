Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8F62C7B2
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbiKPSdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 13:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKPSdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 13:33:37 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E0D115F;
        Wed, 16 Nov 2022 10:33:34 -0800 (PST)
Received: from zn.tnic (p200300ea9733e74b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e74b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 22CA91EC0138;
        Wed, 16 Nov 2022 19:33:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668623613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Ms5H47kTpr48KRWEJSYgNO3SJlSnLGzl1g2kZ6eGJmc=;
        b=ZvkX+n9jOMsxQsBufShjvTUDKX6y1XF7McZHTcsLjyFgqo04Ix83CRkbmiA3mCbdMiOAGt
        0wuDhCO9kMb8aXQkzWvWJtgBz0O1pvo4l3RRkziC4O6DSODhtg9ae9GGVcTY4fxs3IJLiQ
        EmRuHlwmOO7hZDcZ/p5j+28F3Pv3bas=
Date:   Wed, 16 Nov 2022 19:33:27 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y3Us9wSX9DrWqCyq@zn.tnic>
References: <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic>
 <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
 <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
 <711e6027-1b4f-4aed-47a6-305396d05893@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <711e6027-1b4f-4aed-47a6-305396d05893@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 12:01:11PM -0600, Kalra, Ashish wrote:
> Ok, so i will work on implementing this leaked pages list and put it on a
> sev/snp associated structure.

See __sgx_sanitize_pages() and the poison list there, for an example.

> Also to add here, we will actually get a not-present #PF instead of the RMP
> violation #PF on writing to these leaked pages, as these pages would have
> been removed from the kernel direct map.

So if you do the list and still have the kernel raise a RMP fault for
those pages, traversing that list in the RMP handler to check whether
the page is there on it, should be a lot faster operation than doing the
#PF thing and removing them from the direct map.

And sorry for misleading you about UPM - we were thinking wrong
yesterday.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
