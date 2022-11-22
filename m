Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A166339B0
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 11:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiKVKSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 05:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiKVKRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 05:17:35 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C21E03B;
        Tue, 22 Nov 2022 02:17:33 -0800 (PST)
Received: from zn.tnic (p200300ea9733e79b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e79b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BD30A1EC05B0;
        Tue, 22 Nov 2022 11:17:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669112251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XW4KmeE1lzqUbSDQgw0OBkM1KYWQdDzwu91w2ZjF5TE=;
        b=DuntGKBHRGyMI+yzTr/TwqOwnXXDvqJwm7SvqoGXUYJE2lj3j59lFGw4qmF1O/GolhkxaD
        znTMJZE0D+1CNoNoXmaS8NoRZqyVqGPCi+dEqhpgxF1zpSS8HjfKxbF+sGYlPJQ0JAISRH
        NfC5xXH13XU7o0cbQWyhEwSOCcWVIZ4=
Date:   Tue, 22 Nov 2022 11:17:26 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y3yhthJTIWqjjAPK@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com>
 <Y3qdTuZQoDZxUgbw@zn.tnic>
 <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 06:37:18PM -0600, Kalra, Ashish wrote:
> I agree, but these pages are not in the right state to be released back to

Which pages exactly?

Some pages' state has really changed underneath or you've given the
wrong range?

> It might be a user/sev-guest error, but these pages are now unsafe to use.
> So is a kernel panic justified here, instead of not releasing the pages back
> to host and logging errors for the same.

Ok, there are two cases:

* kernel error: I guess a big fat warning is the least we can issue
here. Not sure about panic considering this should almost never happen
and a warning would allow for people to catch dumps and debug the issue.

* firmware error: I don't think you can know that that is really
the case on a production system without additional fw debugging
capabilities. Dumping a warning would be the least we can do here too,
to signal that something's out of the ordinary and so people can look
into it further.

So yeah, a big fat warning is a good start. And then you don't need any
memory poisoning etc gunk.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
