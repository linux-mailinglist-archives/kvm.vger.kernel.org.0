Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8372CB75
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 18:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbjFLQ1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 12:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbjFLQ1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 12:27:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A3598;
        Mon, 12 Jun 2023 09:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686587220; x=1718123220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Uat8NMUncmqciNyRT9NRmiG7E1sO/Fvnt3OOx8fsnxw=;
  b=dlvAq7Gtsz/y/mRHYTw1kzu+xyxA9XKOH63k9qcZ3wSeMZI7VMGpyNcG
   UF3lhzm9RC80DuNbdf0ndwe5TT+0l/5fN/3adjRAIbtPQKPL/vMzD3O9h
   prm4Tf/HdVC7LT4Y5npUREk9DK7dNIU4/WVcNGrEdn04jfrNIM0R5/uh3
   q2vbHSjnWYU8oHtO4fbQQ+asF/HBwbed9a298vcQSsddaveatanxlUeU+
   WUBiW6ID3knvyq/Z5JpJKoyxuhJSOlF5Tuizjxtan0Ski8qppCMhmJuvc
   eTacdynFG6Xmx069Peqa12hm2eQDQMJlOXDv3t0xtsai4qZ8WFHjLzY5g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="358089513"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="358089513"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:26:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="661638856"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="661638856"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:26:58 -0700
Message-ID: <7bf4b9a6-d75b-8e96-14cf-79df2fae8694@intel.com>
Date:   Mon, 12 Jun 2023 09:26:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 11/51] x86/traps: Define RMP violation #PF error
 code
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
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-12-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230612042559.375660-12-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/23 21:25, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Bit 31 in the page fault-error bit will be set when processor encounters
> an RMP violation.
> 
> While at it, use the BIT_ULL() macro.
...
>  enum x86_pf_error_code {
> -	X86_PF_PROT	=		1 << 0,
> -	X86_PF_WRITE	=		1 << 1,
> -	X86_PF_USER	=		1 << 2,
> -	X86_PF_RSVD	=		1 << 3,
> -	X86_PF_INSTR	=		1 << 4,
> -	X86_PF_PK	=		1 << 5,
> -	X86_PF_SGX	=		1 << 15,
> +	X86_PF_PROT	=		BIT(0),
> +	X86_PF_WRITE	=		BIT(1),
> +	X86_PF_USER	=		BIT(2),
> +	X86_PF_RSVD	=		BIT(3),
> +	X86_PF_INSTR	=		BIT(4),
> +	X86_PF_PK	=		BIT(5),
> +	X86_PF_SGX	=		BIT(15),
> +	X86_PF_RMP	=		BIT(31),
>  };

It would be nice if the changelog "BIT_ULL()" matched the code "BIT()".  :)

With that fixed,

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

