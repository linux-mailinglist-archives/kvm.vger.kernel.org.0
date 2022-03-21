Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADDE4E207D
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 07:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344550AbiCUGMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 02:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344548AbiCUGMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 02:12:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3EE673FD
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 23:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647843080; x=1679379080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YX3EtHyoc+rRobAvLm9ROpna2RtILtiVYzShu3ZinXU=;
  b=mBRRnRIhiUDWqAzNnXLMWD8nA2ogQwpxLyCw4zPHP/+VPaQ9ml+CjTpa
   Sc7tTM4XPkk/B5kfeu8ChtexOaM0YFdYYMLi5Ntipd1Io7SHFn8Wbyo5J
   9WuECLd7qXnr2fj47CA0wbBRREJdMPBAss/PwdLHcxNQADWFCEGcAnQUn
   QTSq3pnR06RGmWXjBEQYkH8R3VC+OU3KbjKSudgDJmULUFHamje0/qtIc
   hvIJCEZYPNyWlqoz1xcaKpgMilIGM2rrnhCcg6jmREKlADgL3qT3YWkin
   gKJrYnQgwt7gZB2vMjanrE+2QoZWGYtWdmYZ+UqQ4QzK0bJg74gCxDx+5
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="320681201"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="320681201"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:11:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559720521"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:11:13 -0700
Message-ID: <e3ca31cb-cd82-6214-6c5b-6293119c2098@intel.com>
Date:   Mon, 21 Mar 2022 14:11:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 18/36] i386/tdvf: Introduce function to parse TDVF
 metadata
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-19-xiaoyao.li@intel.com>
 <20220318171924.GA4050087@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318171924.GA4050087@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/2022 1:19 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:58:55PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
>> new file mode 100644
>> index 000000000000..02da1d2c12dd
>> --- /dev/null
>> +++ b/hw/i386/tdvf.c
>> @@ -0,0 +1,196 @@
>> +/*
>> + * SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> + * Copyright (c) 2020 Intel Corporation
>> + * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
>> + *                        <isaku.yamahata at intel.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> +
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> +
>> + * You should have received a copy of the GNU General Public License along
>> + * with this program; if not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "hw/i386/pc.h"
>> +#include "hw/i386/tdvf.h"
>> +#include "sysemu/kvm.h"
>> +
>> +#define TDX_METADATA_GUID "e47a6535-984a-4798-865e-4685a7bf8ec2"
>> +#define TDX_METADATA_VERSION    1
>> +#define TDVF_SIGNATURE_LE32     0x46564454 /* TDVF as little endian */
> 
> _LE32 doesn't make sense.  qemu doesn't provide macro version for byteswap.
> Let's convert at the usage point.

OK
>> +
>> +    /* Finally, verify the signature to determine if this is a TDVF image. */
>> +   if (metadata->Signature != TDVF_SIGNATURE_LE32) {
> 
> 
> metadata->Signature = le32_to_cpu(metadata->Signature);
> metadata->Signature != TDVF_SIGNATURE for consistency.
> 

