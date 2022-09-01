Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2BE5A9A8F
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 16:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiIAOhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 10:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiIAOhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 10:37:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC007A538
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 07:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662043017; x=1693579017;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ktGPYfNA6db6xHQ+4uPDPGDhnlph/zXCKNK37wk/avg=;
  b=UScggoP9rL6hYdtLDg0ca6/yNXbkPdeZ8Pv46k3dwWVp1FE2TIoYtoWU
   fIS9c+/JyjABXbEX031Fggb+YCYSiGltTLBS9yh2VzRcCz5C0pQeURNFa
   tmBu1AMVelOnsmysTt0WdthB5taXoNzU237oOZ9LHl/S9x4fcTmurQm18
   unCFMH0LvuzF002WrqAMHL+dPtyHL2e/qaWMn7Dl6UOtHcSXN95dpYbid
   bN86W6dUk7iz3z/1xdni9Zxvxnxo1dMBiRACPH5IHi+DfYyy+oF+BSrLV
   OiCCotuee9+W3SREFPo5vvhyETzjEsT2jrTzzI+Gps6ZCEAVSPPOdpf57
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297014029"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297014029"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 07:36:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="754841985"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.114]) ([10.255.28.114])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 07:36:22 -0700
Message-ID: <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
Date:   Thu, 1 Sep 2022 22:36:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/2022 9:58 PM, Gerd Hoffmann wrote:

>> Anyway, IMO, guest including guest firmware, should always consult from
>> CPUID leaf 0x80000008 for physical address length.
> 
> It simply can't for the reason outlined above.  Even if we fix qemu
> today that doesn't solve the problem for the firmware because we want
> backward compatibility with older qemu versions.  Thats why I want the
> extra bit which essentially says "CPUID leaf 0x80000008 actually works".

I don't understand how it backward compatible with older qemu version. 
Old QEMU won't set the extra bit you introduced in this series, and all 
the guest created with old QEMU will become untrusted on CPUID leaf 
0x80000008 ?

> take care,
>    Gerd
> 

