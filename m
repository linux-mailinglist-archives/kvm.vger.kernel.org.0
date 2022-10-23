Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2943F609673
	for <lists+kvm@lfdr.de>; Sun, 23 Oct 2022 23:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiJWVRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 17:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJWVRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 17:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53147DFD3;
        Sun, 23 Oct 2022 14:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B070E60F5A;
        Sun, 23 Oct 2022 21:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82492C433D6;
        Sun, 23 Oct 2022 21:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666559854;
        bh=eww41udNaMuXD4PMpBks27BJLoB4EyHOihBbydaDgtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+6zZQfAIp1iaUxFxyNJAVYls4dVrhMQvzQHdfcTDPdBn5omPfL1g/MV+VEstmGX+
         TyhPT4XDoSkylEW3mt9g5y/sNjg+NVGGxPQmyz/xSeTkpIdCJeclplweDa0n1xJeQG
         jh2rOZuuhqR42zLANPnwmHOpXISgE+h/jGpkLFUGRrRMXU8/A8dj1lR+JNAKTssnmw
         cTKH4YPSQNCxY8YEviveP11uRO9o4IX2xte5ta2RAWVcZvGWl6iEyZybjlGvJOmEUV
         WcQd+lnGwabwrk3ejl9S08tWuMUI6g4ilm0sWdXFFr6AoDMpU93xZHlmoIrdv9MYC1
         szA9tsjpkiOhQ==
Date:   Mon, 24 Oct 2022 00:17:27 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize
 the AMD-SP for SEV-SNP
Message-ID: <Y1WvZ0lLDAmrweXs@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic>
 <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
 <d3ab29c8-8f22-28eb-dfe3-6100a8f16e4b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3ab29c8-8f22-28eb-dfe3-6100a8f16e4b@amd.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 01:48:48PM -0500, Kalra, Ashish wrote:
> Another follow up:
> 
> > > >   int sev_platform_init(int *error);
> > > > +/**
> > > > + * sev_snp_init - perform SEV SNP_INIT command
> > > > + *
> > > > + * @error: SEV command return code
> > > > + *
> > > > + * Returns:
> > > > + * 0 if the SEV successfully processed the command
> > > > + * -%ENODEV    if the SEV device is not available
> > > > + * -%ENOTSUPP  if the SEV does not support SEV
> > > > + * -%ETIMEDOUT if the SEV command timed out
> > > > + * -%EIO       if the SEV returned a non-zero return code
> > > 
> > > Something's weird with those args. I think it should be
> > > 
> > >     %-ENODEV
> > > 
> > > and so on...
> > > 
> > 
> > Yes, off course %-<errno>
> > 
> 
> I see that other drivers are also using the same convention:
> 
> include/linux/regset.h:
> ..
> /**
>  * user_regset_set_fn - type of @set function in &struct user_regset
>  * @target:     thread being examined
>  * @regset:     regset being examined
>  * @pos:        offset into the regset data to access, in bytes
>  * @count:      amount of data to copy, in bytes
>  * @kbuf:       if not %NULL, a kernel-space pointer to copy from
>  * @ubuf:       if @kbuf is %NULL, a user-space pointer to copy from
>  *
>  * Store register values.  Return %0 on success; -%EIO or -%ENODEV
>  * are usual failure returns.  The @pos and @count values are in
> ...
> 
> include/linux/psp-tee.h:
> ..
> /**
>  * psp_tee_process_cmd() - Process command in Trusted Execution Environment
>  * @cmd_id:     TEE command ID (&enum tee_cmd_id)
>  * @buf:        Command buffer for TEE processing. On success, is updated
>  *              with the response
>  * @len:        Length of command buffer in bytes
>  * @status:     On success, holds the TEE command execution status
>  *
>  * This function submits a command to the Trusted OS for processing in the
>  * TEE environment and waits for a response or until the command times out.
>  *
>  * Returns:
>  * 0 if TEE successfully processed the command
>  * -%ENODEV    if PSP device not available
>  * -%EINVAL    if invalid input
>  * -%ETIMEDOUT if TEE command timed out
>  * -%EBUSY     if PSP device is not responsive
>  */
> ...
> 
> Thanks,
> Ashis

In SGX driver the convention is:

* Return:
* - -ENODEV  ...
* - -EINVAL  ...

"Return:" because this is what kernel-nanodoc-HOWTO.txt suggests.

The dashes are recognized by Sphinx as list so each return code
gets a newline when processed through "make htmldocs". Otherwise,
you get a mess because newlines will be removed.

I don't actually have idea of '%' and neither see it in the kernel
documenation.

BR, Jarkko
