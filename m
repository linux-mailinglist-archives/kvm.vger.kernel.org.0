Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88E262C8C5
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 20:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiKPTJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 14:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiKPTJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 14:09:12 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBB661742;
        Wed, 16 Nov 2022 11:09:09 -0800 (PST)
Received: from zn.tnic (p200300ea9733e74b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e74b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 762D91EC04E2;
        Wed, 16 Nov 2022 20:09:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668625748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SOIA0OyfOSiWDvYJqrV7tS8xz75TZx+kpu+CyG3Fa0c=;
        b=VseLmkRx6Dyu/uNziP09w7yjbWT6xqnOh7Y+3JxTIquYLVJxQODpxlvXiXJLg7hXNPVPWH
        UHJtL7C0tGRgVum3vkvlGNPLKFhK1Q2GYQT+1tz66BINQM60Dy+WBpJipq5oq1lnaMIKMG
        fUCf1aAA5e8gzgA8z+D5RgVjdkhCPGw=
Date:   Wed, 16 Nov 2022 20:09:08 +0100
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
Message-ID: <Y3U1VJdC77CfniJj@zn.tnic>
References: <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
 <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
 <973c6f79-38ad-aa30-bfec-c2a1c7db5d70@suse.cz>
 <8692e736-7518-d6d2-ae83-720e42e7a059@amd.com>
 <41b8c83e-2a1a-1dda-945e-99329ca8e7e9@suse.cz>
 <711e6027-1b4f-4aed-47a6-305396d05893@amd.com>
 <Y3Us9wSX9DrWqCyq@zn.tnic>
 <834d41e7-44f8-53f9-a1fa-0cdb5aaff30f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <834d41e7-44f8-53f9-a1fa-0cdb5aaff30f@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 12:53:36PM -0600, Kalra, Ashish wrote:
> Actually, these host allocated pages would have already been removed from
> the kernel direct map,

And, as I said above, it would be a lot easier to handle any potential
faults resulting from the host touching them by having it raise a *RMP*
fault instead of normal *PF* fault where the latter code is a crazy mess.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
