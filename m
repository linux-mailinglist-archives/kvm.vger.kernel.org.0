Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22636658F62
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 18:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiL2RJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 12:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiL2RJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 12:09:44 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF365FF;
        Thu, 29 Dec 2022 09:09:41 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 36C1E1EC01CE;
        Thu, 29 Dec 2022 18:09:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672333780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+OOhnZUur7/65XYNN5FmieX2LDevIBg+5FobdbkM0V4=;
        b=ZZ5a6aHw8mkatXdcTQjTIBD0qcmeQny18h0PJgtL3SDF/M34eLTxnFU2ln362VqwAnk9cW
        HmuFwJeKmNCRp8KTd2O86F+ZNQ7Zb2KrYhShQl84Tbw1xAmuPzmUh3VGZhvASwYz38MQrL
        lWkFhXIbJA9GKPkwwHAxZXMwVNKAGuE=
Date:   Thu, 29 Dec 2022 18:09:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Michael Roth <michael.roth@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Message-ID: <Y63Jz01c7zLx03gQ@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic>
 <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic>
 <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 03:49:39PM -0600, Kalra, Ashish wrote:
> Milan onward,

And before ML there's no SNP, right?

> there is H/W support for coherency between mappings of the
> same physical page with different encryption keys, so AFAIK, there should be
> no need to flush during page state transitions, where we invoke these direct
> map interface functions for re-mapping/invalidating pages.

Yah, that rings a bell.

In any case, the fact that flushing is not needed should be stated
somewhere in text so that it is clear why.

> I don't know if there is any other reason to flush after modifying
> the direct map ?

There's

        /*
         * No need to flush, when we did not set any of the caching
         * attributes:
         */
        cache = !!pgprot2cachemode(mask_set);


Does the above HW cover this case too?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
