Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456926760D1
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 23:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjATW5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 17:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjATW5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 17:57:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAE7EB5C;
        Fri, 20 Jan 2023 14:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76160620DC;
        Fri, 20 Jan 2023 22:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546A7C433EF;
        Fri, 20 Jan 2023 22:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674255373;
        bh=oKkf+3Q00EAO2IQpP2ByrfkTu1TC3Bz2jqgj3PZH6PQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzmNBo5pWTxCwXoH0a09URQ35CxJllJ7ZLTx0s6tk84iP9ghkbZ456e1RsoYumXPA
         0P2LRE6zdU9RuUkniD+0Zoh1jQ3DSIs22QHjfQoP1AYEAaIXuZ7vi/QD1IqciTXUO2
         +DIXG29qkSmTWTkgp5r8CVst1DlL4dpWt4Oqv+VQC28qZO/wBBbSZYQnGCWPD1WbAi
         Y7v9Z6HCAJe2NHI9c1LKhKf8OBK78NBqAltqti0fNVMJAlHI8rKswZysP4WMbtMf8M
         wO9k9noYac4ACsDgYgd9Jsu1kywyp/7BCtza+cftv2hGULqPXs87IC/zz28HA8VZKa
         59bQV8ds2AMbg==
Date:   Fri, 20 Jan 2023 22:56:11 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
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
        dgilbert@redhat.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v7 25/64] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <Y8scC4GFM6o15Adg@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-26-michael.roth@amd.com>
 <Y7VtOQa5Hd0oMdfh@kernel.org>
 <897b503e-48d1-bc4b-1e68-42792d589ddb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897b503e-48d1-bc4b-1e68-42792d589ddb@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 04:54:23PM -0600, Kalra, Ashish wrote:
> Hello Jarkko,
> 
> On 1/4/2023 6:12 AM, Jarkko Sakkinen wrote:
> > On Wed, Dec 14, 2022 at 01:40:17PM -0600, Michael Roth wrote:
> > > +	/*
> > > +	 * If boot CPU supports SNP, then first attempt to initialize
> > > +	 * the SNP firmware.
> > > +	 */
> > > +	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
> > > +		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
> > > +			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
> > > +				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> > > +		} else {
> > > +			rc = sev_snp_init(&error, true);
> > > +			if (rc) {
> > > +				/*
> > > +				 * Don't abort the probe if SNP INIT failed,
> > > +				 * continue to initialize the legacy SEV firmware.
> > > +				 */
> > > +				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
> > > +			}
> > > +		}
> > > +	}
> > 
> > I think this is not right as there is a dep between sev init and this,
> > and there is about a dozen of call sites already __sev_platform_init_locked().
> > 
> 
> sev_init ?
> 
> As this is invoked during CCP module load/initialization, shouldn't this get
> invoked before any other call sites invoking __sev_platform_init_locked() ?

Then it should not be exported because this the only working call site.

However, the benefit of __sev_platform_init_locked() addressing SNP init is
that psp_init_on_probe can also postpone SNP init without possibility to
any side effects (other call sites than sev_guest_init()).

BR, Jarkko
