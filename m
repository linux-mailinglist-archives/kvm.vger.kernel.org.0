Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586B460C7AF
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 11:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJYJOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiJYJNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 05:13:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D13176B88;
        Tue, 25 Oct 2022 02:07:19 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e753329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e753:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 560641EC0138;
        Tue, 25 Oct 2022 11:07:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666688828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RpZt/ekhm97/GCrxTm62WjrwmkfB+Hl6PYEoWkmLcSs=;
        b=cJSawZk/4f1kVEpXP4DnaqZQDZCWU4J9ov+SV+016eVWeC8LfSqUNPn/mqfTwrdFMdHY41
        NVlCjUdHw55zGKATrjh+CCmZY5qM1WeQeEJ6UX55CYy5aACwbF6dxJ+yRGmqVH6e82zKve
        d1WhLf8YwB22RIEdI4LVqnlyjQjqDRQ=
Date:   Tue, 25 Oct 2022 11:07:04 +0200
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
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize
 the AMD-SP for SEV-SNP
Message-ID: <Y1enOIfS3nnlcyyc@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic>
 <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
 <d3ab29c8-8f22-28eb-dfe3-6100a8f16e4b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d3ab29c8-8f22-28eb-dfe3-6100a8f16e4b@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 01:48:48PM -0500, Kalra, Ashish wrote:
> I see that other drivers are also using the same convention:

It is only convention. Look at the .rst output:

0 if the SEV successfully processed the command
-``ENODEV``    if the SEV device is not available
-``ENOTSUPP``  if the SEV does not support SEV
-``ETIMEDOUT`` if the SEV command timed out
-``EIO``       if the SEV returned a non-zero return code

vs

0 if the SEV successfully processed the command
``-ENODEV``    if the SEV device is not available
``-ENOTSUPP``  if the SEV does not support SEV
``-ETIMEDOUT`` if the SEV command timed out
``-EIO``       if the SEV returned a non-zero return code

so in the html output of this, the minus sign will be displayed either
with text font or with monospaced font as part of the error type.

I wanna say the second is better as the '-' is part of the error code
but won't waste too much time debating this. :)

Btw

$ ./scripts/kernel-doc include/linux/psp-sev.h

complains a lot. Might wanna fix those up when bored or someone else
who's reading this and feels bored too. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
