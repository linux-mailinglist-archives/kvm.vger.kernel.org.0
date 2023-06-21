Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06E1737E99
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 11:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjFUI5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 04:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjFUI4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 04:56:37 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF76A1BFF;
        Wed, 21 Jun 2023 01:55:06 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A60A11EC0645;
        Wed, 21 Jun 2023 10:54:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687337688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PaijKeZv9hHzPlRW8nV/FYz8UIKd1karlQoSdFTK9HU=;
        b=bXvV0+pxKiaymh6RMR5E7TymGBtOIKsJQRSEXl6ZgJlqDLoxmRN+EbYq53nMqpeSm8Fqcv
        juvqXqCN6U9D1PMExuQT2nUWstu0UHyTHq6SadvJ6vqMCjyKTvbQpFF+6xoNHNbK+zgcXd
        lMHc57oV4O1RNKyc122eH/G4HXSD12g=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J9iqJbrA_r02; Wed, 21 Jun 2023 08:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687337685; bh=PaijKeZv9hHzPlRW8nV/FYz8UIKd1karlQoSdFTK9HU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZyPtAM5/IdcCmMCgT07D/cKwY5LISGmi08sReq8DvsGMAJg7TbmGflxm2e4+nhW1
         iM8n4szOWC7EJktdC7OieNP3tV1U+8A8rGXnToElYLW9jG7PFYvhP/pxB/hG0gD0A5
         NvgkTVHjWBzSaTC2PTYLrnb6dis6w/coleE3KJ7P5U4ueUijT+AY6Mw3eGKF/rpJOl
         1+3U94yuoOb95xXewS808ymG8YphUWenlYBtwW1c59lKr3Bn5mSbiJLdjGiWnMxfIB
         W+IDhNs+64UGOO9sJmxs2+Qm445XqPoUuR7pqJpjx3DHGjK3Sb1pCewY4sVibZX3LX
         s0vVMDCE250TdXfAao/7fr9iTE2uU5U4fkvPZCZ/++dVp9/vBPEzvVJVSkfoDw/TWW
         ZGorHZa3NrTRAsNHRifAqR6/OV6uq7uqOwZBVdsra6/+Zymo6cXFgzqIHTwbQglT1Q
         hoZ6+C2USb20l9LItSwWGf+id6/NME+lQMm/ZGG7Pn5D7CdZT2epathV3G9ZpzgMUS
         BVC8P2MDBpL967kRs++EckTvrNYXIAi4Hml4Y9d6RNE+WHkqH5egbll7z0yZUR68ja
         XBymJ9aKqhJAMgYgsL9YnDigIu5FZeZfinbP/8kBa0FRKJS+OrU5iqj2Lar4z2aNqy
         5dmKsESs5nfxY7bHbIvYwrqA=
Received: from zn.tnic (p200300ea971Dc592329c23FffEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c592:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED59740E019B;
        Wed, 21 Jun 2023 08:54:04 +0000 (UTC)
Date:   Wed, 21 Jun 2023 10:54:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH RFC v9 05/51] x86/coco: move CONFIG_HAS_CC_PLATFORM check
 down into coco/Makefile
Message-ID: <20230621085400.GDZJK6qMeOU2monJDv@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-6-michael.roth@amd.com>
 <20230620120920.GAZJGW8B6XHrsoLGCJ@fat_crate.local>
 <20230620204315.xr7wtcrowc7oprka@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230620204315.xr7wtcrowc7oprka@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 03:43:15PM -0500, Michael Roth wrote:
> Basically, arch/x86/coco/Makefile is never processed if arch/x86/Kbuild
> indicates that CONFIG_HAS_CC_PLATFORM is not set. So if we want to have
> stuff in arch/x86/coco/Makefile that build for !CONFIG_HAS_CC_PLATFORM,
> like SNP host support, which does not rely on CONFIG_HAS_CC_PLATFORM
> being set, that check needs to be moved down into arch/x86/coco/Makefile.

Ok, so if you put SNP host support into arch/x86/virt/svm/sev.c, that
should work too and won't have any relation to CONFIG_HAS_CC_PLATFORM,
right?

The CC_PLATFORM thing is a way to check for confidential computing guest
features by abstracting the capabilities so that you don't have to check
*each* and *every* conf guest type in the conditionals and thus go nuts.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
