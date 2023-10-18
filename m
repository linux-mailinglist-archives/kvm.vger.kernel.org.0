Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F3B7CDFD2
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 16:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345736AbjJROaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 10:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbjJROaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 10:30:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427EE10F0;
        Wed, 18 Oct 2023 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697638666; x=1729174666;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E+Z9XZNAGrfXl1gnv1lM2ourrNoPoA1sbsAn5sGZg3o=;
  b=YzOJDgUgxKP2GM1QcLZbEwy75LNE8Y4GQz1uN0Qi4IaSn63ujQSmkixd
   j0v7VovSEDiA55GU542wDpB+ReYsIy6TkiiUK8NRmGSccgPZX5W7N14QO
   EPRYsWD6hNhqwYyoxM1JBTiNIfD9s7osCpQHyX4h38WZwNqIMj61UsFlE
   kuwYHv+qcOKnRx54bzJKbzBpMhvyP/uaCRsTMYZxx87aVUCVHdg0uxqzw
   PbDBN+eo9Z0U8QYjWXtuIqURtxvcasAR1BOljjEO8lJ5JstyKgU7OQUGm
   xrmWJOnajF1cVF6Tpvdl532h6jBKw1Bcl3KPLPJVM8uhuCIZMqfkCLiF8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="450245500"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="450245500"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 07:17:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="733187064"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="733187064"
Received: from npokhrel-mobl1.amr.corp.intel.com (HELO [10.212.172.232]) ([10.212.172.232])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 07:17:12 -0700
Message-ID: <19f8e93e-62c4-485c-a7c3-f29740fc3eca@linux.intel.com>
Date:   Wed, 18 Oct 2023 07:17:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/23] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        nik.borisov@suse.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <58c44258cb5b1009f0ddfe6b07ac986b9614b8b3.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/17/2023 3:14 AM, Kai Huang wrote:
> The SEAMCALLs involved during the TDX module initialization are not
> expected to fail.  In fact, they are not expected to return any non-zero
> code (except the "running out of entropy error", which can be handled
> internally already).
> 
> Add yet another set of SEAMCALL wrappers, which treats all non-zero
> return code as error, to support printing SEAMCALL error upon failure
> for module initialization.  Note the TDX module initialization doesn't
> use the _saved_ret() variant thus no wrapper is added for it.
> 
> SEAMCALL assembly can also return kernel-defined error codes for three
> special cases: 1) TDX isn't enabled by the BIOS; 2) TDX module isn't
> loaded; 3) CPU isn't in VMX operation.  Whether they can legally happen
> depends on the caller, so leave to the caller to print error message
> when desired.
> 
> Also convert the SEAMCALL error codes to the kernel error codes in the
> new wrappers so that each SEAMCALL caller doesn't have to repeat the
> conversion.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
> 
> v13 -> v14:
>  - Use real functions to replace macros. (Dave)
>  - Moved printing error message for special error code to the caller
>    (internal)
>  - Added Kirill's tag
> 
> v12 -> v13:
>  - New implementation due to TDCALL assembly series.
> 
> ---

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
