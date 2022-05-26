Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34029534910
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiEZCzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 22:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239409AbiEZCzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 22:55:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000ECBDA21
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 19:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653533736; x=1685069736;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SKSXqfdXaFViFgqPYeu8IfF3uZqYneWIagraOmfAULU=;
  b=k7enkBn8TDA1i1Qxg7sagJXVuF9dz9dcAkGfGYpl9t+tKti3pevStj5H
   jQJUS/ST1YyJz6mcke+5ujIWNb3M3q82HpAD7XoZv+FxiSS4jCcHul4+f
   +rV6PcODX71S/PzRLiv+12BI0zC4XwshqjqKrPsCHGMjJU9CaA+7V92VH
   FXsa0ZNhY1XmyitcXEVuetEwdix4EwDohoCpKmPuDwocLq0R8ALfcoyXq
   8XBI1nra4I9P9sI9H6orY9LyPJhoBUyH+8q0SvaeK/vKhJaaNQtwTNVhf
   o/mB15ejphH3rOXngtxjm8ZHFoEdpexTEctzHzu2ASHI3rKqty7W0D00a
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="261621084"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="261621084"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:52:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="573642153"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.212]) ([10.255.28.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:52:28 -0700
Message-ID: <afec66bf-3fa1-b9fe-44b0-11bd32c97f51@intel.com>
Date:   Thu, 26 May 2022 10:52:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 20/36] i386/tdx: Register a machine_init_done
 callback for TD
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
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
 <20220512031803.3315890-21-xiaoyao.li@intel.com>
 <20220524070932.rmkmunar6q6brdbo@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524070932.rmkmunar6q6brdbo@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 3:09 PM, Gerd Hoffmann wrote:
> On Thu, May 12, 2022 at 11:17:47AM +0800, Xiaoyao Li wrote:
>> Before a TD can run, it needs to
>>   - setup/configure TD HOB list;
>>   - initialize TDVF into TD's private memory;
>>   - initialize TD vcpu state;
>>
>> Register a machine_init_done callback to all those stuff.
> 
>> +static void tdx_finalize_vm(Notifier *notifier, void *unused)
>> +{
>> +    /* TODO */
>> +}
> 
> I'd suggest to squash this into the patch actually implementing
> tdx_finalize_vm.

OK. I'll squash it into the next patch.

> take care,
>    Gerd
> 

