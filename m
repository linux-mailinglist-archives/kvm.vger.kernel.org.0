Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7E65389CF
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 04:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiEaCKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 22:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243506AbiEaCJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 22:09:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2653A880E9
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 19:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653962997; x=1685498997;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q0KO5pJ9qEbsF4xl8KTu6ajUChQfGULarXFR8H9GAvU=;
  b=du6s2KLvlhxUbQGHBldPvH1lc5lq0jrqn51uTbMcPf3KackTOthMIu03
   ePYzhSX6IXxhTsRrDRmFnYtcpD9mXHxCw/UA6xAoz/ANymBvTZGNG8apT
   kzl5vECyVMIcikfEeZZpIxVX9Rtb+P4KDVNqHyB+xrcxk1KOA1c0gICKh
   Zq3HclIr5+b5EK8Zp9Qcx99MseRLTmZD2d3b8o5uu5OSB6Ei0a6PGKyQD
   HC9hQrMEbZiLCz7yFUipXZkAWIFJm6dD8EWO+RgYi2unWaYjlQOK4bZFa
   RGbGzRpKAoGTYcunuwWPO+MgDTN6e86nZjSwhGSmH7LG3zh8xUL+wiT+5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="273921607"
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="273921607"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 19:09:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="753560675"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.170.26]) ([10.249.170.26])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 19:09:51 -0700
Message-ID: <b34bfd43-16ce-74d0-5104-6972f4977a45@intel.com>
Date:   Tue, 31 May 2022 10:09:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
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
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
 <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
 <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
 <20220526184826.GA3413287@ls.amr.corp.intel.com>
 <fa75cda1-311d-dcd7-965d-c553700c5303@intel.com>
 <20220530115908.lcb6xegu4arfsqux@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220530115908.lcb6xegu4arfsqux@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/2022 7:59 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>>> tdx_add_ram_entry() increments tdx_guest->nr_ram_entries.  I think it's worth
>>> for comments why this is safe regarding to this for-loop.
>>
>> The for-loop is to find the valid existing RAM entry (from E820 table).
>> It will update the RAM entry and increment tdx_guest->nr_ram_entries when
>> the initial RAM entry needs to be split. However, once find, the for-loop is
>> certainly stopped since it returns unconditionally.
> 
> Add a comment saying so would be good.
> 
> Or move the code block doing the update out of the loop.  That will
> likewise make clear that finding the entry which must be updated is
> the only purpose of the loop.

Good idea. I'll go this way.

> take care,
>    Gerd
> 

