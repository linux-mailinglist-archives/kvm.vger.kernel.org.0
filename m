Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2A60F797
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbiJ0MkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbiJ0MkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:40:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594ED24952;
        Thu, 27 Oct 2022 05:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666874415; x=1698410415;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gCO0Gi7jBp04JaT6Hozi8Zx3cpn252rR5ReZxqs5hCY=;
  b=KOM1BCNT7d0j35P3H9WmFQhEc6CWmXUKKJUkrS1fwuf7fImwaTeDIGXe
   /+s4HuW6q/RkYY8TYpH8kpSjree/rSwdRrr+brrDQI3xa0TeyL33FRZHk
   S/H2g3iRpnLgxBHNa3pvXitg72pi03jSQQhZajfzV/LtVNwEidqrV49fS
   mFXso0ny0KjL0u0NSd9Wv3dYIk4B9HElbARz0O6lMUhkUqR0MnQzepFBK
   Vws2wBmzoY+1zFwNywDQE7MROZwDUgGpDSRbhnBucfKf3BC0xRm1mzGUj
   v3FSIiXTf34zevm34qx88v8i1G3J1GR3CCOXnjW/XB1ITQBCWlbh+ULr6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309907166"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="309907166"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:40:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="632392902"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="632392902"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.251.5.115]) ([10.251.5.115])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:40:14 -0700
Message-ID: <85531c8e-e708-c76a-2d66-30ad7a3f8471@linux.intel.com>
Date:   Thu, 27 Oct 2022 05:40:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v6 16/21] x86/virt/tdx: Reserve TDX module global KeyID
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <7558961d3dff6311c7872f57ac5bd6727f21e140.1666824663.git.kai.huang@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
In-Reply-To: <7558961d3dff6311c7872f57ac5bd6727f21e140.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/26/2022 4:16 PM, Kai Huang wrote:
> TDX module initialization requires to use one TDX private KeyID as the
> global KeyID to protect the TDX module metadata.  The global KeyID is
> configured to the TDX module along with TDMRs.
>
> Just reserve the first TDX private KeyID as the global KeyID.  Keep the
> global KeyID as a static variable as KVM will need to use it too.
>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 5d74ada072ca..0820ba781f97 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -62,6 +62,9 @@ static struct tdsysinfo_struct tdx_sysinfo;
>   static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
>   static int tdx_cmr_num;
>   
> +/* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
> +static u32 tdx_global_keyid;


Comment how this is serialized (or doesn't need it)



