Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE9629D3F
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 16:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiKOPWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 10:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiKOPWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 10:22:40 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D90F18374;
        Tue, 15 Nov 2022 07:22:39 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7da329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7da:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AFEEB1EC02F2;
        Tue, 15 Nov 2022 16:22:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668525757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=B64mdOFdT9uTOfYjl9ll3tHMRZvvBJ1CeVd454LiI/w=;
        b=pFcmHugbADL2DSRItZt5Vs6GYiAwP5C4H7GwzbzykfoflNfCHtY31ltt1srrkXZ8fdm5CM
        qCtoY3uier2iX7TxnpLGBJO3tX/QDKE70/Wc34RhyUpm6UC0WfS6wgMW5ahFVGVMMa+DnH
        NpK0pB/JVpKsAKoozrLB9VdwGTq4fEU=
Date:   Tue, 15 Nov 2022 16:22:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     "Kalra, Ashish" <ashish.kalra@amd.com>, x86@kernel.org,
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
Message-ID: <Y3OuvXCjttfFh++w@zn.tnic>
References: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic>
 <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic>
 <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic>
 <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 04:14:42PM +0100, Vlastimil Babka wrote:
>  but maybe we could just put the pages on some leaked lists without
> special page? The only thing that should matter is not to free the
> pages to the page allocator so they would be reused by something else.

As said on IRC, I like this a *lot*. This perfectly represents what
those leaked pages are: leaked, cannot be used and lost. Certainly not
hwpoisoned.

Yeah, that's much better.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
