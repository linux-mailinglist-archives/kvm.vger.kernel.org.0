Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8757A535B8A
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 10:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349810AbiE0Ig4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 04:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349806AbiE0Igc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 04:36:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F1A104C92
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 01:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653640569; x=1685176569;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=j+qDmfMloNVfY5RJn64MHRfjzIc6MOmQuO7M/jmSDS4=;
  b=iy/syMzOlq+roDMVnmXflu3F8GhlIaEM5R6npMZ+nPOOHVlC2ms0f670
   H72AL/bWvxG4oW4vwRESX5Zvb3FnwkHglCdHI08gkz30qQCs/pQFHGcw1
   yv3DzPJeTpwp6fw1GzjnDaJAeTd45UeztiOi+oyhiWuS+aCgROgCXQK2X
   8dPnatyg9zs55CaFE/U6rn3Litud1lE5w+Fqex9rxzWwCfJ1ZIUoo+uPm
   zPtoePEx5AWCnUIkBfJnOjgvWUfobhT/6YvAdzxxAuvcW1OLHPClzjpRp
   AqCkLnZjCp0eXdZrwNnDQWxVjY080+RZ+D+mEdmWsSKwH/azZDT2mxOsc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="254297069"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="254297069"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 01:36:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="574443778"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.41]) ([10.255.28.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 01:36:02 -0700
Message-ID: <322922f2-53d5-ef4a-e0db-1f5636f9dea5@intel.com>
Date:   Fri, 27 May 2022 16:36:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
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
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
 <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
 <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
In-Reply-To: <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/2022 3:33 PM, Xiaoyao Li wrote:
> On 5/24/2022 3:37 PM, Gerd Hoffmann wrote:

>>> +        if (e->address == address && e->length == length) {
>>> +            e->type = TDX_RAM_ADDED;
>>> +        } else if (e->address == address) {
>>> +            e->address += length;
>>> +            e->length -= length;
>>> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
>>> +        } else if (e->address + e->length == address + length) {
>>> +            e->length -= length;
>>> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
>>> +        } else {
>>> +            TdxRamEntry tmp = {
>>> +                .address = e->address,
>>> +                .length = e->length,
>>> +            };
>>> +            e->length = address - tmp.address;
>>> +
>>> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
>>> +            tdx_add_ram_entry(address + length,
>>> +                              tmp.address + tmp.length - (address + 
>>> length),
>>> +                              TDX_RAM_UNACCEPTED);
>>> +        }
>>
>> I think all this can be simplified, by
>>    (1) Change the existing entry to cover the accepted ram range.
>>    (2) If there is room before the accepted ram range add a
>>        TDX_RAM_UNACCEPTED entry for that.
>>    (3) If there is room after the accepted ram range add a
>>        TDX_RAM_UNACCEPTED entry for that.
> 
> I implement as below. Please help review.
> 
> +static int tdx_accept_ram_range(uint64_t address, uint64_t length)
> +{
> +    uint64_t head_start, tail_start, head_length, tail_length;
> +    uint64_t tmp_address, tmp_length;
> +    TdxRamEntry *e;
> +    int i;
> +
> +    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
> +        e = &tdx_guest->ram_entries[i];
> +
> +        if (address + length < e->address ||
> +            e->address + e->length < address) {
> +                continue;
> +        }
> +
> +        /*
> +         * The to-be-accepted ram range must be fully contained by one
> +         * RAM entries
> +         */
> +        if (e->address > address ||
> +            e->address + e->length < address + length) {
> +            return -EINVAL;
> +        }
> +
> +        if (e->type == TDX_RAM_ADDED) {
> +            return -EINVAL;
> +        }
> +
> +        tmp_address = e->address;
> +        tmp_length = e->length;
> +
> +        e->address = address;
> +        e->length = length;
> +        e->type = TDX_RAM_ADDED;
> +
> +        head_length = address - tmp_address;
> +        if (head_length > 0) {
> +            head_start = e->address;
> +            tdx_add_ram_entry(head_start, head_length, 
> TDX_RAM_UNACCEPTED);
> +        }
> +
> +        tail_start = address + length;
> +        if (tail_start < tmp_address + tmp_length) {
> +            tail_length = e->address + e->length - tail_start;
> +            tdx_add_ram_entry(tail_start, tail_length, 
> TDX_RAM_UNACCEPTED);
> +        }
> +
> +        return 0;
> +    }
> +
> +    return -1;
> +}

above is incorrect. I implement fixed one:

+static int tdx_accept_ram_range(uint64_t address, uint64_t length)
+{
+    uint64_t head_start, tail_start, head_length, tail_length;
+    uint64_t tmp_address, tmp_length;
+    TdxRamEntry *e;
+    int i;
+
+    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
+        e = &tdx_guest->ram_entries[i];
+
+        if (address + length < e->address ||
+            e->address + e->length < address) {
+                continue;
+        }
+
+        /*
+         * The to-be-accepted ram range must be fully contained by one
+         * RAM entries
+         */
+        if (e->address > address ||
+            e->address + e->length < address + length) {
+            return -EINVAL;
+        }
+
+        if (e->type == TDX_RAM_ADDED) {
+            return -EINVAL;
+        }
+
+        tmp_address = e->address;
+        tmp_length = e->length;
+
+        e->address = address;
+        e->length = length;
+        e->type = TDX_RAM_ADDED;
+
+        head_length = address - tmp_address;
+        if (head_length > 0) {
+            head_start = tmp_address;
+            tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);
+        }
+
+        tail_start = address + length;
+        if (tail_start < tmp_address + tmp_length) {
+            tail_length = tmp_address + tmp_length - tail_start;
+            tdx_add_ram_entry(tail_start, tail_length, TDX_RAM_UNACCEPTED);
+        }
+
+        return 0;
+    }
+
+    return -1;
+}


> 
> 
>> take care,
>>    Gerd
>>
> 

