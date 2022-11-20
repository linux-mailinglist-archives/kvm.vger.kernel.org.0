Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C061631699
	for <lists+kvm@lfdr.de>; Sun, 20 Nov 2022 22:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKTVeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 16:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiKTVeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 16:34:16 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F87927FED;
        Sun, 20 Nov 2022 13:34:13 -0800 (PST)
Received: from zn.tnic (p200300ea9733e725329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e725:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C6D581EC02FE;
        Sun, 20 Nov 2022 22:34:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668980051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=MU/mPOtQaxPIEiXZaqef4n2ESApESPnWFV9ksNgEQU0=;
        b=gFsAknCC944e+v3lSc/yaLPJAy9TZ++t5KLypK6/QtbQQV1+nSewg1M/XPNPbe7udjUoKY
        XkJYWm7M3S2B55bQ82gf5JmgRLTzx9o51DwMSbzF90QR2CE4t51TA++ITub8kM89vDlwYj
        WqVsyvDAGl5XDyti2GFZL3qEqoO94ZU=
Date:   Sun, 20 Nov 2022 22:34:06 +0100
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
Message-ID: <Y3qdTuZQoDZxUgbw@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b712bc81-4446-9be4-fd59-d08981d13475@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 02:56:47PM -0600, Kalra, Ashish wrote:
> So we need to be able to reclaim all the pages or none.

/me goes and looks at SNP_PAGE_RECLAIM's retvals:

- INVALID_PLATFORM_STATE - platform is not in INIT state. That's
certainly not a reason to leak pages.

- INVALID_ADDRESS - PAGE_PADDR is not a valid system physical address.
That's botched command buffer but not a broken page so no reason to leak
them either.

- INVALID_PAGE_STATE - the page is neither of those types: metadata,
firmware, pre-guest nor pre-swap. So if you issue page reclaim on the
wrong range of pages that looks again like a user error but no need to
leak pages.

- INVALID_PAGE_SIZE - a size mismatch. Still sounds to me like a user
error of sev-guest instead of anything wrong deeper in the FW or HW.

So in all those, if you end up supplying the wrong range of addresses,
you most certainly will end up leaking the wrong pages.

So it sounds to me like you wanna say: "Error reclaiming range, check
your driver" instead of punishing any innocent pages.

Now, if the retval from the fw were FIRMWARE_INTERNAL_ERROR or so, then
sure, by all means. But not for the above. All the error conditions
above sound like the kernel has supplied the wrong range/botched command
buffer to the firmware so there's no need to leak pages.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
