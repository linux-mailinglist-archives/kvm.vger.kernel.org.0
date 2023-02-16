Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321AF698F78
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 10:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBPJOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 04:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjBPJOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 04:14:34 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60F5513D61;
        Thu, 16 Feb 2023 01:14:32 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id E19042010BA9; Thu, 16 Feb 2023 01:14:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E19042010BA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676538871;
        bh=su4MyopmGks9+XinlO9URPSoTj3r37ukK0Z6205Xb1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MOPEOVjogcXLnxi9sng4dFKrUjv46A0s7xGOc+WhSNTPdmmosBJiPV6WGUQF0Olk3
         oDxHAgDyt4slQZvQDiNxdBDRG+Jnrc1TT6b35SFonXvu78z5kyXha6VCDxZIsznVBb
         0NjNlp1WeNqZoUnA1d7rcpSLNqVhxwNHfoBEfGb8=
Date:   Thu, 16 Feb 2023 01:14:31 -0800
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "sandipan.das@amd.com" <sandipan.das@amd.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        "ray.huang@amd.com" <ray.huang@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Message-ID: <20230216091431.GA10166@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 04:40:14AM +0000, Dexuan Cui wrote:
> Hi all,
> With the earlyprintk=ttyS0 kernel parameter, a C-bit mode Linux SNP guest
> on Hyper-V always decides to crash via sev_es_terminate() in
> do_boot_stage2_vc(), because early_setup_ghcb() fails:
> 
> early_setup_ghcb() ->
>   set_page_decrypted() ->
>     set_clr_page_flags() ->
>       split_large_pmd() ->
>         alloc_pgt_page() fails to allocate memory.
> 
> static void *alloc_pgt_page(void *context)
> {
> ...
>         /* Validate there is space available for a new page. */
>         if (pages->pgt_buf_offset >= pages->pgt_buf_size) {
>   ...
>               return NULL;
>         }
> ...
> }
> 
> alloc_pgt_page() fails to allocate memory because both
> pages->pgt_buf_offset and pages->pgt_buf_size are zero.
> 
> 
> pgt_data.pgt_buf_size is zero because of this line in
> initialize_identity_maps()
>      pgt_data.pgt_buf_size = BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;
> 
> void initialize_identity_maps(void *rmode)
> {
> ...
>         top_level_pgt = read_cr3_pa();
>         if (p4d_offset((pgd_t *)top_level_pgt, 0) == (p4d_t *)_pgtable) {
>                 pgt_data.pgt_buf = _pgtable + BOOT_INIT_PGT_SIZE;
>                 pgt_data.pgt_buf_size = BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;
>                 memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
>         } else {
>                 pgt_data.pgt_buf = _pgtable;
>                 pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
>                 memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
>                 top_level_pgt = (unsigned long)alloc_pgt_page(&pgt_data);

I just tested an SNP guest on KVM with and without CONFIG_RANDOMIZE_BASE.
In both cases we end up in the else() branch.
With CONFIG_RANDOMIZE_BASE BOOT_PGT_SIZE=0x13000
Without CONFIG_RANDOMMIZE_BASE BOOT_PGT_SIZE=0x6000.

So in both cases pgt_data.pgt_buf_size != 0. 

Getting into that first branch would require having 5-level paging supported
(CONFIG_X86_5LEVEL=y) and enabled inside the guest, I don't have that on any
hardware I have access to.

Jeremi

>         }
> 
> In arch/x86/include/asm/boot.h, BOOT_PGT_SIZE equals
> BOOT_INIT_PGT_SIZE if CONFIG_RANDOMIZE_BASE is not defined 
> (which is my case):
>  
> # define BOOT_INIT_PGT_SIZE     (6*4096)
> 
> # ifdef CONFIG_RANDOMIZE_BASE
> ...
> #  ifdef CONFIG_X86_VERBOSE_BOOTUP
> #   define BOOT_PGT_SIZE        (19*4096)
> #  else /* !CONFIG_X86_VERBOSE_BOOTUP */
> #   define BOOT_PGT_SIZE        (17*4096)
> #  endif
> # else /* !CONFIG_RANDOMIZE_BASE */
> #  define BOOT_PGT_SIZE         BOOT_INIT_PGT_SIZE
> # endif
> 
> I think this means: if CONFIG_RANDOMIZE_BASE is not defined,
> earlyprintk=ttyS0 also doesn't work for an SNP guest on KVM? 
> Sorry I don't have a KVM environment at hand to test it.
> 
> If I define CONFIG_RANDOMIZE_BASE, my C-bit mode SNP guest crashes
> even ealier -- it looks like CONFIG_RANDOMIZE_BASE is incompatible
> with my guest on Hyper-V due to some reason I don't know.
> 
> Do you always use CONFIG_RANDOMIZE_BASE for a SNP guest on KVM
> and does earlyprintk=ttyS0 work for you?
> 
> Can you please share your thoughts? Thanks!
> 
> Thanks,
> -- Dexuan
