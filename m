Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE11C5A15E4
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242147AbiHYPfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiHYPfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:35:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A293DB6D53
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661441740; x=1692977740;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ALe3W9UVzuJwVIm95wO5987ELsrUxm8mx+BiX6s41OY=;
  b=mp1GWPRWFtUm86ohuxIJaly/oWo+/rCxMc1vGSfbd8UxL0mWvQ6Q/Rdw
   m5Hun5EX+5Tkvvm4cRykJltbi3NF8SZdOEL10Ua/QUVA1nMmTrVEY/aN7
   VQNgBDY9a6900xMYVcIdrLhkg+tKYQdlUjvsHNItpT5Rb660HLyi1hlSb
   t/CBikrzKxYmF1ffTN6TV0duy6Y+rTveVxdM9pKh4+GZ7p9twRWkRWEOD
   1XMpBM3MvftA6cSvvF23ikcUlPR45uWBsUbLcj2wAa3zyDFB+aHT4ezij
   5HfzvHSSeW4pYukb6Q9FASs60V/PRDghjnBIPAQn7YoIit85a3m3NjLTp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="355990408"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="355990408"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:35:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="671034879"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.55]) ([10.255.29.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:35:02 -0700
Message-ID: <00b93d50-ca34-a3e1-6a32-48cf93edfa88@intel.com>
Date:   Thu, 25 Aug 2022 23:35:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH v1 06/40] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-7-xiaoyao.li@intel.com>
 <20220825101203.vpgwzbyqc677snjt@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220825101203.vpgwzbyqc677snjt@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 6:12 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> +        r = tdx_platform_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
>> +        if (r == -E2BIG) {
>> +            g_free(caps);
>> +            nr_cpuid_configs *= 2;
>> +            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
>> +                error_report("KVM TDX seems broken");
> 
> Maybe, but IMHO this should still report what exactly the problem is
> (number of cpuid entries exceeds limit).

Will update it to

	error_report(KVM TDX seems broken that number of CPUID entries in 
kvm_tdx_capabilities exceeds limit)

> take care,
>    Gerd
> 
> 

