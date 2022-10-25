Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7CE60C674
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiJYIbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiJYIbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:31:05 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F86541A6;
        Tue, 25 Oct 2022 01:31:01 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e753329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e753:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 457331EC064C;
        Tue, 25 Oct 2022 10:31:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666686660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SsCnaY6vsw/dlWcb5dAlVwUs2sKUOOm4xMSiV3vNbVc=;
        b=erN1LR4tBXE7W+2GQ21IylqAaTg3ibHJFZBzxlPhJR2N+B40rgmHY8IbEnrxZgvdUnmZ7l
        2UrDoeUh/cI1b94V/yzn43xMsPQmRb0CJ3ZlOSF+QMqruxwiiwQZQ1KUHCYTUNrZjImCG+
        Mjw1VpelZAdMyy4Xjpx0d5aG9UwNN0c=
Date:   Tue, 25 Oct 2022 10:30:56 +0200
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
Message-ID: <Y1eewE4wj7MwXpFz@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic>
 <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 04:09:11PM -0500, Kalra, Ashish wrote:
> Yes, we need to do:
> 
> wbinvd_on_all_cpus();
> SNP_DF_FLUSH
> 
> Need to ensure all the caches are clear before launching the first guest and
> this has to be a combination of WBINVD and SNP_DF_FLUSH command.

Ok.

> > Why isn't this retval checked?
> 
> From the SNP FW ABI specs, for the SNP_SHUTDOWN command:
> 
> Firmware checks for every encryption capable ASID that the ASID is not in
> use by a guest and a DF_FLUSH is not required. If a DF_FLUSH is required,
> the firmware returns DFFLUSH_REQUIRED.
>
> Considering that SNP_SHUTDOWN command will check if DF_FLUSH was
> required and if so, and not invoked before that command, returns
> an error indicating that DFFLUSH is required.
> 
> This way, we can cleverly avoid taking the error code path for
> DF_FLUSH command here and instead let the SNP_SHUTDOWN command
> failure below indicate if DF_FLUSH command failed.
> 
> This also ensures that we always invoke SNP_SHUTDOWN command,
> irrespective of SNP_DF_FLUSH command failure as SNP_DF_FLUSH may
> actually not be required by the SHUTDOWN command.

This all sounds just silly. The proper way to do this is:

retry:
        ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN, NULL, error);
        if (ret == DFFLUSH_REQUIRED) {
		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
		if (ret)
			"... DF_FLUSH failed...";

		goto retry;
	}

I'm assuming here the firmware is smart enough to not keep returning
DFFLUSH_REQUIRED constantly and cause an endless loop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
