Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9865A590
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 16:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiLaPdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Dec 2022 10:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLaPcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Dec 2022 10:32:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ABDC32;
        Sat, 31 Dec 2022 07:32:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEA9AB803F6;
        Sat, 31 Dec 2022 15:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2EBC433EF;
        Sat, 31 Dec 2022 15:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672500764;
        bh=biJ5OjRTz8LacHCIRhDE4EhKtGxMPJqMl2cws+KriSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wy3CUR+9dYkvysDD2MX1mxUzbtSCU/1qo0R11/dbrhUE7qsa8wF81yuG3/xCMFGjR
         FB8Fxq6+YD3el2KrtlkHXbtmFLVuRa0Z2Cfcg0s9cShsI7kUFfOhS7S1dKNWfTCcH+
         QJVr1h0R9wajCAdbrdjrha9+ESNbIlyTnPRIqs94qHVTvYmruLISpbyFQVD6eUgLvU
         UQX0sXD+UyHjOqhlWBnrlSIJAx5rNV8SLwvq7fdR9UDaHZjj67k8/uzTPAqrWulycx
         ZJnOrGgBUmTEiIP3SnCaMARWF0J7NZkLd5NPuJ0Va6hbCtWXtS0sSOvq3VRcnvS8a7
         zSQw+OnHg/f+w==
Date:   Sat, 31 Dec 2022 15:32:42 +0000
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
Message-ID: <Y7BWGvGj/Ky8RctP@kernel.org>
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
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Before SNP VMs can be launched, the platform must be appropriately
> configured and initialized. Platform initialization is accomplished via
> the SNP_INIT command. Make sure to do a WBINVD and issue DF_FLUSH
> command to prepare for the first SNP guest launch after INIT.
> 
> During the execution of SNP_INIT command, the firmware configures
> and enables SNP security policy enforcement in many system components.
> Some system components write to regions of memory reserved by early
> x86 firmware (e.g. UEFI). Other system components write to regions
> provided by the operation system, hypervisor, or x86 firmware.
> Such system components can only write to HV-fixed pages or Default
> pages. They will error when attempting to write to other page states
> after SNP_INIT enables their SNP enforcement.
> 
> Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
> system physical address ranges to convert into the HV-fixed page states
> during the RMP initialization. If INIT_RMP is 1, hypervisors should
> provide all system physical address ranges that the hypervisor will
> never assign to a guest until the next RMP re-initialization.
> For instance, the memory that UEFI reserves should be included in the
> range list. This allows system components that occasionally write to
> memory (e.g. logging to UEFI reserved regions) to not fail due to
> RMP initialization and SNP enablement.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 225 +++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   2 +
>  include/linux/psp-sev.h      |  17 +++
>  3 files changed, 244 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9d84720a41d7..af20420bd6c2 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -26,6 +26,7 @@
>  #include <linux/fs_struct.h>
>  
>  #include <asm/smp.h>
> +#include <asm/e820/types.h>
>  
>  #include "psp-dev.h"
>  #include "sev-dev.h"
> @@ -34,6 +35,10 @@
>  #define SEV_FW_FILE		"amd/sev.fw"
>  #define SEV_FW_NAME_SIZE	64
>  
> +/* Minimum firmware version required for the SEV-SNP support */
> +#define SNP_MIN_API_MAJOR	1
> +#define SNP_MIN_API_MINOR	51
> +
>  static DEFINE_MUTEX(sev_cmd_mutex);
>  static struct sev_misc_dev *misc_dev;
>  
> @@ -76,6 +81,13 @@ static void *sev_es_tmr;
>  #define NV_LENGTH (32 * 1024)
>  static void *sev_init_ex_buffer;
>  
> +/*
> + * SEV_DATA_RANGE_LIST:
> + *   Array containing range of pages that firmware transitions to HV-fixed
> + *   page state.
> + */
> +struct sev_data_range_list *snp_range_list;
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -830,6 +842,186 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> +static void snp_set_hsave_pa(void *arg)
> +{
> +	wrmsrl(MSR_VM_HSAVE_PA, 0);
> +}
> +
> +static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
> +{
> +	struct sev_data_range_list *range_list = arg;
> +	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
> +	size_t size;
> +
> +	if ((range_list->num_elements * sizeof(struct sev_data_range) +
> +	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
> +		return -E2BIG;
> +
> +	switch (rs->desc) {
> +	case E820_TYPE_RESERVED:
> +	case E820_TYPE_PMEM:
> +	case E820_TYPE_ACPI:
> +		range->base = rs->start & PAGE_MASK;
> +		size = (rs->end + 1) - rs->start;
> +		range->page_count = size >> PAGE_SHIFT;
> +		range_list->num_elements++;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __sev_snp_init_locked(int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_data_snp_init_ex data;
> +	struct sev_device *sev;
> +	int rc = 0;
> +
> +	if (!psp || !psp->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp->sev_data;
> +
> +	if (sev->snp_initialized)
> +		return 0;

Shouldn't this follow this check:

        if (sev->state == SEV_STATE_INIT) {
                /* debug printk about possible incorrect call order */
                return -ENODEV;
        }

It is game over for SNP, if SEV_CMD_INIT{_EX} got first, which means that
this should not proceed.

BR, Jarkko
