Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC14E20B4
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 07:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbiCUGxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 02:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbiCUGx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 02:53:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3022927E
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 23:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647845525; x=1679381525;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M5dH+/DenWqwLY/1sakEHfMvcCZ74F02Alh0NIVWiI4=;
  b=BB8NRXuumIVXT3MHGPRqwDspgTIwsVNFPVwhhQnCVQsHTQGiCYCfeXpi
   xu7VPX685wFAjGqP/EhGrzgTuUsaGZrgRldjYcDX6vcHmX5YTZ+SiBCjl
   8ZKQ6GGozTAEBTLVdE4Qmk6byPrTtYJMFAdCHxI5+o4wIR86DLNbrMb5s
   eDf47NBH+mHB6mK2d0CEwVcT4rZIoQG6QZQjZ9/xI95JRYNyxKIuGayPu
   pCORyWgbOqBjF216SxQNAFw0BiMPZ3vKAwtCsGXeDDHdFm4CHsDsb8ytV
   jQ+ezOxwg7fd11o9iuRajtigbIfYFCD5gJDhOoxKyh8FV403IvBbVn7XC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="256300634"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="256300634"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:52:04 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559732794"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:52:00 -0700
Message-ID: <1032f754-03e9-6745-fb0b-0850a8d1e7c8@intel.com>
Date:   Mon, 21 Mar 2022 14:51:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 27/36] i386/tdx: Disable SMM for TDX VMs
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-28-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220317135913.2166202-28-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/2022 9:59 PM, Xiaoyao Li wrote:
> TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
> VMM cannot manipulate TDX VM's memory.
> 
> Disable SMM for TDX VMs and error out if user requests to enable SMM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/kvm/tdx.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index deb9634b27dc..ec6f5d7a2e48 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -302,12 +302,25 @@ static Notifier tdx_machine_done_notify = {
>   
>   int tdx_kvm_init(MachineState *ms, Error **errp)
>   {
> +    X86MachineState *x86ms = X86_MACHINE(ms);
>       TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
>                                                       TYPE_TDX_GUEST);
>       if (!tdx) {
>           return -EINVAL;
>       }
>   
> +    if (!kvm_enable_x2apic()) {
> +        error_setg(errp, "Failed to enable x2apic in KVM");
> +        return -EINVAL;
> +    }

above change is not relevant to this patch, will remove it in next version.

> +
> +    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
> +        x86ms->smm = ON_OFF_AUTO_OFF;
> +    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
> +        error_setg(errp, "TDX VM doesn't support SMM");
> +        return -EINVAL;
> +    }
> +
>       if (!tdx_caps) {
>           get_tdx_capabilities();
>       }

