Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EA35A1F93
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 06:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiHZEAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 00:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHZEAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 00:00:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8D022BCC
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 21:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661486413; x=1693022413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LYpXOeGCv0D8LEuZ5rlYMSsbSL41VeqEWm/6QNHip1A=;
  b=fCsdUEKXMpq9hQJ7GAkvOXgZIMFjfQPlzQGDwPgsTNuogYo7z+eP7Hf9
   UgPvjqC1DAr/Yfcw6p1PbgmpERraBoBUGPGMfBdkZhQ3QHOK/uDq1vtVs
   FDYXlfNEb54bCptQpQe6c1EUtwktYA4ZKtB9S0avdGCE+y2rslKYYfLFX
   W4RU+CCtf/UTA7l4gBfdMFSrW+77ni1mfWWxQ1CsS444CHtbEW1GJnrGs
   fITzb+Vx4XcADzdPHEu9O3m8DhAb6QAvvtR1MhpwPzsHO6M+s4nJZ4klS
   tb8hGV09ezZ5J4lRoHUeEMpHt1xgJoWXYcrVbEyePvkTbHQIAqjHIctqy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="293157247"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="293157247"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 21:00:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="671294986"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.246]) ([10.255.29.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 21:00:09 -0700
Message-ID: <45f5c26a-4ed6-3364-304e-b91060dd608a@intel.com>
Date:   Fri, 26 Aug 2022 12:00:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH v1 08/40] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-9-xiaoyao.li@intel.com>
 <200d5aa2-f1e3-2b8b-7963-e605f9a5731e@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <200d5aa2-f1e3-2b8b-7963-e605f9a5731e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2022 3:33 PM, Chenyi Qiang wrote:
> 
> 
> On 8/2/2022 3:47 PM, Xiaoyao Li wrote:
>> According to Chapter "CPUID Virtualization" in TDX module spec, CPUID
>> bits of TD can be classified into 6 types:
>>
>> ------------------------------------------------------------------------
>> 1 | As configured | configurable by VMM, independent of native value;
>> ------------------------------------------------------------------------
>> 2 | As configured | configurable by VMM if the bit is supported natively
>>      (if native)   | Otherwise it equals as native(0).
>> ------------------------------------------------------------------------
>> 3 | Fixed         | fixed to 0/1
>> ------------------------------------------------------------------------
>> 4 | Native        | reflect the native value
>> ------------------------------------------------------------------------
>> 5 | Calculated    | calculated by TDX module.
>> ------------------------------------------------------------------------
>> 6 | Inducing #VE  | get #VE exception
>> ------------------------------------------------------------------------
>>
>> Note:
>> 1. All the configurable XFAM related features and TD attributes related
>>     features fall into type #2. And fixed0/1 bits of XFAM and TD
>>     attributes fall into type #3.
>>
>> 2. For CPUID leaves not listed in "CPUID virtualization Overview" table
>>     in TDX module spec. When they are queried, TDX module injects #VE to
>>     TDs. For this case, TDs can request CPUID emulation from VMM via
>>     TDVMCALL and the values are fully controlled by VMM.
>>
>> Due to TDX module has its own virtualization policy on CPUID bits, it 
>> leads
>> to what reported via KVM_GET_SUPPORTED_CPUID diverges from the supported
>> CPUID bits for TDS. In order to keep a consistent CPUID configuration
>> between VMM and TDs. Adjust supported CPUID for TDs based on TDX
>> restrictions.
>>
>> Currently only focus on the CPUID leaves recognized by QEMU's
>> feature_word_info[] that are indexed by a FeatureWord.
>>
>> Introduce a TDX CPUID lookup table, which maintains 1 entry for each
>> FeatureWord. Each entry has below fields:
>>
>>   - tdx_fixed0/1: The bits that are fixed as 0/1;
>>
>>   - vmm_fixup:   The bits that are configurable from the view of TDX 
>> module.
>>                  But they requires emulation of VMM when they are 
>> configured
>>             as enabled. For those, they are not supported if VMM doesn't
>>         report them as supported. So they need be fixed up by
>>         checking if VMM supports them.
>>
>>   - inducing_ve: TD gets #VE when querying this CPUID leaf. The result is
>>                  totally configurable by VMM.
>>
>>   - supported_on_ve: It's valid only when @inducing_ve is true. It 
>> represents
>>             the maximum feature set supported that be emulated
>>             for TDs.
>>
>> By applying TDX CPUID lookup table and TDX capabilities reported from
>> TDX module, the supported CPUID for TDs can be obtained from following
>> steps:
>>
>> - get the base of VMM supported feature set;
>>
>> - if the leaf is not a FeatureWord just return VMM's value without
>>    modification;
>>
>> - if the leaf is an inducing_ve type, applying supported_on_ve mask and
>>    return;
>>
>> - include all native bits, it covers type #2, #4, and parts of type #1.
>>    (it also includes some unsupported bits. The following step will
>>     correct it.)
>>
>> - apply fixed0/1 to it (it covers #3, and rectifies the previous step);
>>
>> - add configurable bits (it covers the other part of type #1);
>>
>> - fix the ones in vmm_fixup;
>>
>> - filter the one has valid .supported field;
> 
> What does .supported field filter mean here?
> 

Sorry I missed this comment before.

Above statement is the leftover during internal development. It needs to 
be removed actually.
