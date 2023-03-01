Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F402C6A70B7
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 17:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCAQVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 11:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCAQVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 11:21:22 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BEE305FD;
        Wed,  1 Mar 2023 08:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677687680; x=1709223680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=99e5KN1R/O+8i5rO5OW9FmQOG2BY+kuQaZF2MSYyEdI=;
  b=kSTQ+90Gyh7lYHXDEcCtJqRnWelh8frjSm3LXip4dMLQ5ztkNjIIcQwr
   e9xAYMcQGpNkQx6bGM/mg9ZNZreDH/5SVbBuv+Hu+27KSJvqDvBPd0Tuw
   gQvhN3NNSy+VymZE1TL8TBtwHIBxbFZR9AourJ64yegi4lnL/W6p8wDTo
   EBMeBXXdKAMh2nPd4eomeAIQgYMzHvz+kgIrBLm6jppzJm2iKqx038XjJ
   bYyf3xFLQqpnMusG4d4SlGoja1r29T/F8EfIev/A1JG15hV6jlVhD6q2A
   JsyIx0IE6lum2ECsiQyH6BkTOSRqdQGjFytPNv6TMT8BSzr68KDX9In+w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="335942692"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="335942692"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:21:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="674623570"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="674623570"
Received: from asaha3-mobl1.amr.corp.intel.com (HELO [10.251.12.67]) ([10.251.12.67])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:21:18 -0800
Message-ID: <a15fc9a5-c136-47f7-e15e-776a511f3cdb@intel.com>
Date:   Wed, 1 Mar 2023 08:21:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 17/56] x86/fault: Add support to handle the RMP
 fault for user address
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko.sakkinen@profian.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-18-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230220183847.59159-18-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 10:38, Michael Roth wrote:
> +static int handle_split_page_fault(struct vm_fault *vmf)
> +{
> +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	return 0;
> +}
> +
>  /*
>   * By the time we get here, we already hold the mm semaphore
>   *
> @@ -5078,6 +5084,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  				pmd_migration_entry_wait(mm, vmf.pmd);
>  			return 0;
>  		}
> +
> +		if (flags & FAULT_FLAG_PAGE_SPLIT)
> +			return handle_split_page_fault(&vmf);

I asked this long ago, but how do you prevent these faults from
occurring on hugetlbfs mappings that can't be split?

