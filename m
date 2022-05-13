Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8D15258EC
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 02:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352872AbiEMAQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 20:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241086AbiEMAP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 20:15:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3022AC64
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 17:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652400957; x=1683936957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1btgLcVFaoIL4FwmxtQ2dsqUiIPJhTN5EsOsNLdNOPI=;
  b=kZNgP+Y10mHfLrXTybq9/qVVQWT3H0WlEX8E9blviqIajk/Ao5RMAHT+
   xfnIVdXTzX6INnJBuorJjptQ26sPiTLqEWd0JP1nWCPe1ojTd11cMh6wp
   we/7FvZHnY4/HqnXw+C9s7/GQ306+qzIJNyQm+6yazrdd510Yoaqcy01O
   BG/Bwb7SlZrUAom/IPAeuzReb3l4FUhXkHNqSJDH3menwQjaQS8846TH1
   d8mmOMOhIgC2QwtryxZSMlIA0SPENtztQtx2rlNAmK0J/r3ErceGjYqFX
   pFj1fWwD5190JfMduzTh3rKrf15nQwWePGsu4TCDFNgrS8kCGLnrnW8PG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270105818"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270105818"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:15:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="594944859"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.214]) ([10.249.175.214])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:15:52 -0700
Message-ID: <7b941ee5-f4cb-bcc7-5f8a-f9469f977b52@intel.com>
Date:   Fri, 13 May 2022 08:15:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v4 09/36] KVM: Introduce kvm_arch_pre_create_vcpu()
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>, g@ls.amr.corp.intel.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Gerd Hoffmann <kraxel@redhat.com>,
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
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-10-xiaoyao.li@intel.com>
 <20220512175059.GF2789321@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220512175059.GF2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/2022 1:50 AM, Isaku Yamahata wrote:
> On Thu, May 12, 2022 at 11:17:36AM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
>> work prior to create any vcpu. This is for i386 TDX because it needs
>> call TDX_INIT_VM before creating any vcpu.
> 
> Because "11/36 i386/tdx: Initialize TDX before creating TD vcpus" uses
> kvm_arch_pre_create_vcpu() (and 10/36 doesn't use it), please move this patch
> right before 11/36. (swap 09/36 and 10/36).
> 

OK.

I will change the order.


