Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69FC65D224
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbjADMMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjADMMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:12:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159542E4;
        Wed,  4 Jan 2023 04:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A496661426;
        Wed,  4 Jan 2023 12:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AF9C433D2;
        Wed,  4 Jan 2023 12:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672834364;
        bh=2LM4YgK9ZwjTNPSN2P5IZrHlicBcI8kTMt/REMjAc98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hxEg5IlT8BNPimyBbh61k0QbFTkMWB6pALC5qBmzuPUzhAdJ1O/ps1/S01t9QoWnS
         DKlg3hsfGR5luWLAzrWvAPMKOmvpI4FpujQm0KyLWz+wmdCOxGogmTuXaGRSh8i3ZE
         8FxegDtxke3qT2hG7LXmpGdVUfxh52Oy8IXMcdUCUWwN5qjmGAII4YR79t9HIyaBqP
         EZm22UrAk+EE96zWeivUQMtyd/mSynCnyKEsDOw2h3IG7YZnlpeXfAhVmyG7t7gbX5
         lO7Jv04rxaWxZXFGQwf3Qoat9E2SiOG1V+If8r7fRsnZBhtsjSWs01J8sP8hqMDf4W
         k384F7fvHfOCg==
Date:   Wed, 4 Jan 2023 12:12:41 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 25/64] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <Y7VtOQa5Hd0oMdfh@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-26-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-26-michael.roth@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:17PM -0600, Michael Roth wrote:
> +	/*
> +	 * If boot CPU supports SNP, then first attempt to initialize
> +	 * the SNP firmware.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
> +		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
> +			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
> +				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> +		} else {
> +			rc = sev_snp_init(&error, true);
> +			if (rc) {
> +				/*
> +				 * Don't abort the probe if SNP INIT failed,
> +				 * continue to initialize the legacy SEV firmware.
> +				 */
> +				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
> +			}
> +		}
> +	}

I think this is not right as there is a dep between sev init and this,
and there is about a dozen of call sites already __sev_platform_init_locked().

Instead there should be __sev_snp_init_locked() that would be called as
part of __sev_platform_init_locked() flow.

Also TMR allocation should be moved inside __sev_platform_init_locked,
given that it needs to be marked into RMP after SNP init.

BR, Jarkko

