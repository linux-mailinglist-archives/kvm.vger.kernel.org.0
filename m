Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F4369DA7F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 06:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjBUFsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 00:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjBUFsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 00:48:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C197EDD
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 21:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676958481; x=1708494481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NoLsaYA/hjqrEZC+X1mP79xiOvXQ2uPePKVtsFGLnEg=;
  b=VdVI5w6/CNQN7oQWDAzZrdSP9AoB6+G4+rdwn2M3JokpMUG9YJxFUPkh
   BpU2Wtuz/rduuN2SS8NH7SZ7VcFTU+yirYCaGkKdTulMFnJMVjl8i49Fy
   s9nRmnNJMrF5PJM6WN/NaI7UPSgQB4XfNpCaJwkE+SytiXG0HbZfkTfma
   uTXcj4Uv3JFbO1bOqIgkX9vG0v5c6ABeslYdgeWKs/0z+8S/5dCMwIBMk
   FM//3gPls0udRDQqZY10EHGuYVdjZlgcey/ovPZCxGp/sRj9wAf9ldMxD
   21lRpyJzod1bqFknXrE06Bam+fh/w7oFmE4RCVqlc2KbdbLqQeBa7Ngrg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="330270095"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="330270095"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 21:48:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="740280164"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="740280164"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.94]) ([10.238.10.94])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 21:47:58 -0800
Message-ID: <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
Date:   Tue, 21 Feb 2023 13:47:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-10-robert.hu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230209024022.3371768-10-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2023 10:40 AM, Robert Hoo wrote:
> LAM feature is enumerated by (EAX=07H, ECX=01H):EAX.LAM[bit26].
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b14653b61470..79f45cbe587e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -664,7 +664,7 @@ void kvm_set_cpu_caps(void)
>   
>   	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>   		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
> -		F(AVX_IFMA)
> +		F(AVX_IFMA) | F(LAM)

Do we allow to expose the LAM capability to guest when host kernel 
disabled LAM feature (e.g. via clearcpuid)?

May be it should be handled similarly as LA57.


>   	);
>   
>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
