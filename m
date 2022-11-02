Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33676161A9
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 12:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiKBLWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 07:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiKBLWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 07:22:34 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4ED13FA6;
        Wed,  2 Nov 2022 04:22:28 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e741329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e741:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D08081EC0567;
        Wed,  2 Nov 2022 12:22:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1667388146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=stsEyPM3yshEwkVJFTjMEf1n3jksEvxwTfKS4NKFQ3M=;
        b=bicSDEWqpmnYKra+kbGFh+j8MDU2fk8a81eXZBfoDvBd+piFoqJo7Zv/4XE6hgDQX1Kmi9
        v7PXwWK8cAJrg2sSoRzHUsSxDumVASpNo323yy/TwAmtZGL7Zojtyj57cLIicAfpzlK84g
        53QASmyBfQKtIAUiHL83CfI0vJvHUfk=
Date:   Wed, 2 Nov 2022 12:22:22 +0100
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
Message-ID: <Y2JS7kn8Q9P4rXso@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic>
 <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic>
 <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>      if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>             do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>             return RMP_PF_RETRY;

Does this issue some halfway understandable error message why the
process got killed?

> Will look at adding our own recovery function for the same, but that will
> again mark the pages as poisoned, right ?

Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
Semantically, it'll be handled the same way, ofc.

> Still waiting for some/more feedback from mm folks on the same.

Just send the patch and they'll give it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
