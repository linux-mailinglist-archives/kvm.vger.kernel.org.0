Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83013695942
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjBNGhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBNGhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:37:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69E41CAFD;
        Mon, 13 Feb 2023 22:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676356611; x=1707892611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GO5wCrt+fZciZ28xMxkxHu29ps8guwcHSLj+nqEdp3c=;
  b=I4o8ZKIf7+gmLHfikqgfet1/epex6KyFPO8xPXGA3i2IcOSGDE5f77zO
   QiCRUtk44Aieni3NC+KQXYzbq0Umog540PNZt9BvXIcEtpHkulZOPs94V
   Relu3/AuKlg23ENmf2C7V6yeHXJ6WQK8yKd02NGwoxw9EBUVs/yvOum/n
   ftTKDO/cIT52U2NgEkWpENk9HMywQfFC7zjHSSE+0Ra46vshkMRiQG3Td
   UNNK6aorIoWfwivHVu5nlL6oRUYa2G8VzaeepZkp7J8euHnl1wSINMnHs
   RyN9M3o7Q4YiGecNDEjEeM9TTs5xSauFUaFrU2Kvu9lZLgWiTRGtoetYX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310724532"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310724532"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:36:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="618931841"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="618931841"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.2]) ([10.255.31.2])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:36:48 -0800
Message-ID: <6ede401b-292b-0434-d1b4-bb387c59e0ac@intel.com>
Date:   Tue, 14 Feb 2023 14:36:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
Subject: Re: [PATCH v2 04/21] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-5-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230210003148.2646712-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/2023 8:31 AM, Sean Christopherson wrote:
> Add VMX MSRs to the runtime list of feature MSRs by iterating over the
> range of emulated MSRs instead of manually defining each MSR in the "all"
> list.  Using the range definition reduces the cost of emulating a new VMX
> MSR, e.g. prevents forgetting to add an MSR to the list.
> 
> Extracting the VMX MSRs from the "all" list, which is a compile-time
> constant, also shrinks the list to the point where the compiler can
> heavily optimize code that iterates over the list.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
