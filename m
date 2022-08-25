Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1BB5A10DD
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 14:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbiHYMow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 08:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbiHYMov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 08:44:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663AB1039
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 05:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661431486; x=1692967486;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j2Ya427lxj0NqFGjYYioE6S+hxmpBGrcOkVCVJDXqkA=;
  b=G4gdvhqS/nk4f+Eb+tXHF8Rrd1RAttTklcOsCpn20mRmoECadDQ6vf34
   g5XKELkY/561ZClUdtgoiITioXmdW8z/yYj2v0+Sm6ikOZ2KpiUJOGB9j
   3C2TEzqyZXWSkTZeVZaCpNubv8TqDO8KwzCCqINachdU/BIhcQnghcbFH
   Wq3KdyMIHkLYhBEWf67HxevNEjlwk7hV113RzEljKSSzBl8/3SUlHGkPC
   pYUe+U/HAODJkQffypRP0ZozMGV16BOzIIFULl3TiTSN+O3Am7KYZtn9e
   k4CoLKZE2WTabhyl8M3kFdBTyEjexu+8EoEe8ih8KgSF4r169r9r9a7cg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="281196416"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="281196416"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 05:44:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="670964154"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.55]) ([10.255.29.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 05:44:41 -0700
Message-ID: <146cad27-e263-7882-6469-981f5166f42c@intel.com>
Date:   Thu, 25 Aug 2022 20:44:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH v1 08/40] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
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
 <20220802074750.2581308-9-xiaoyao.li@intel.com>
 <20220825112647.xmtvkoiffyk7aigr@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220825112647.xmtvkoiffyk7aigr@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 7:26 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> between VMM and TDs. Adjust supported CPUID for TDs based on TDX
>> restrictions.
> 
> Automatic adjustment depending on hardware capabilities isn't going to
> fly long-term, you'll run into compatibility problems sooner or later,
> for example when different hardware with diverging capabilities (first
> vs. second TDX generation) leads to different CPUID capsets in a
> otherwise identical configuration.
> 
> Verification should happen of course, but I think qemu should just throw
> an error in case the tdx can't support a given cpu configuration.

I think you misunderstand this patch.

It's to adjust the supported feature set of the platform, not the 
feature set of the given VM/TD. I.e, the adjusted supported feature set 
will be used to *verify* the VM's setting that specified by user. Of 
course, if user requires unsupported feature, QEMU will throw an error.

> (see also Daniels reply to the cover letter).
> 
> take care,
>    Gerd
> 

