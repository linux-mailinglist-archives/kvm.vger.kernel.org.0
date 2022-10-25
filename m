Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3095860CA08
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 12:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiJYK1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 06:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiJYK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 06:27:12 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2C6160ECF;
        Tue, 25 Oct 2022 03:25:42 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e753329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e753:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C44E21EC03B9;
        Tue, 25 Oct 2022 12:25:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666693540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+geCwvxqT0myxZwE/PtJNWuF3ki1qM+58+9jGmk0+NA=;
        b=QQmmBLsxaQ8Bj0ngcqs073Mv4GhGx8R/7EvI2yQ0oTRpnmgVXmmIW5JbwdhSXX6kTn5NXf
        YXO+eYDiY/vhREBTWCVEionVrdwyNaIdtQO9FxHa5VrfMUThQoc9PY6PFOZslR+/E5H1aT
        zYI89obq143eoU/a5IKjcDtSKRUzWJ4=
Date:   Tue, 25 Oct 2022 12:25:36 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>, vbabka@suse.cz
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y1e5oC9QyDlKpxZ9@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 03:00:09PM -0500, Kalra, Ashish wrote:
> If it is "still" accessed/touched then it can cause RMP #PF.
> On the other hand,
> 
>  * PG_hwpoison... Accessing is
>  * not safe since it may cause another machine check. Don't touch!
> 
> That sounds exactly the state we want these page(s) to be in ?
> 
> Another possibility is PG_error.

Something like this:

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e66f7aa3191d..baffa9c0dc30 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -186,6 +186,7 @@ enum pageflags {
 	 * THP.
 	 */
 	PG_has_hwpoisoned = PG_error,
+	PG_offlimits = PG_hwpoison,
 #endif
 
 	/* non-lru isolated movable page */

and SNP will have to depend on CONFIG_MEMORY_FAILURE.

But I'd let mm folks correct me here on the details.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
