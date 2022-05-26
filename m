Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694FC534AD4
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 09:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbiEZHdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 03:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346420AbiEZHdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 03:33:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E2398085
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 00:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653550397; x=1685086397;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UlmE2CbAigQduNsC3UCgDYAE8v3FN2weR/9B9g11T8Q=;
  b=GQuUyL1GeoP/Pv2Njj02uFm+cQcJ4117ZyXmo/ijPIhm2foUO7T603fS
   E21qotLpJI1NbBqQAA7TdKpUWS0v7zB6oOl2uiTxu3rm/xDIpXs+IAmXH
   u4/BWvEcOsgSMbkuV6SA8VefRT+xmwCGWSijyjq5l0MUaiEECmC6ZSi8j
   QCabB+7q6wsWwVzsQdpm8AGmpiofPrqJt+L+sROo+KP3pzl4mmWRcuDfO
   DYlikHXVQsEr7bHqLSt/sSCl9AwFY4vDVHs7XR79VI+w9AYylWRRWfQgb
   nyTHXuP9HoCbKTI5uWx0Mnql2lY4NQX5LZUEbdVRyvibtk7e1WIq7kh5K
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="334709444"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="334709444"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 00:33:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="573742571"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.212]) ([10.255.28.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 00:33:12 -0700
Message-ID: <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
Date:   Thu, 26 May 2022 15:33:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
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
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
 <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 3:37 PM, Gerd Hoffmann wrote:
>> +static int tdx_accept_ram_range(uint64_t address, uint64_t length)
>> +{
>> +    TdxRamEntry *e;
>> +    int i;
>> +
>> +    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
>> +        e = &tdx_guest->ram_entries[i];
>> +
>> +        if (address + length < e->address ||
>> +            e->address + e->length < address) {
>> +                continue;
>> +        }
>> +
>> +        if (e->address > address ||
>> +            e->address + e->length < address + length) {
>> +            return -EINVAL;
>> +        }
> 
> if (e->type == TDX_RAM_ADDED)
> 	return -EINVAL
> 
>> +        if (e->address == address && e->length == length) {
>> +            e->type = TDX_RAM_ADDED;
>> +        } else if (e->address == address) {
>> +            e->address += length;
>> +            e->length -= length;
>> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
>> +        } else if (e->address + e->length == address + length) {
>> +            e->length -= length;
>> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
>> +        } else {
>> +            TdxRamEntry tmp = {
>> +                .address = e->address,
>> +                .length = e->length,
>> +            };
>> +            e->length = address - tmp.address;
>> +
>> +            tdx_add_ram_entry(address, length, TDX_RAM_ADDED);
>> +            tdx_add_ram_entry(address + length,
>> +                              tmp.address + tmp.length - (address + length),
>> +                              TDX_RAM_UNACCEPTED);
>> +        }
> 
> I think all this can be simplified, by
>    (1) Change the existing entry to cover the accepted ram range.
>    (2) If there is room before the accepted ram range add a
>        TDX_RAM_UNACCEPTED entry for that.
>    (3) If there is room after the accepted ram range add a
>        TDX_RAM_UNACCEPTED entry for that.

I implement as below. Please help review.

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
+            head_start = e->address;
+            tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);
+        }
+
+        tail_start = address + length;
+        if (tail_start < tmp_address + tmp_length) {
+            tail_length = e->address + e->length - tail_start;
+            tdx_add_ram_entry(tail_start, tail_length, TDX_RAM_UNACCEPTED);
+        }
+
+        return 0;
+    }
+
+    return -1;
+}



> take care,
>    Gerd
> 

