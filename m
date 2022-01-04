Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC1848421D
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 14:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiADNIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 08:08:36 -0500
Received: from mga17.intel.com ([192.55.52.151]:11541 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbiADNIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 08:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641301715; x=1672837715;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eTosNZWN1zAzfnx/zcKL1qsuRrbXMmlQcyS8hm7dCaw=;
  b=RvlZVEVvggBAkrGerE1xdzEa/3CJesia6USHTWQZ4urfmxTol2cU9Zdr
   D8h7aYIDTcWFCAmnisTGFGVD6TJotoWLdFzg1SyOtNcuKVRRQsCqofbVG
   j1Ph9GU28n/MhEMwBlAaqlHupP2arPGJJN42umVuuRVFSKWKk7vE3WHcB
   QRTMl9zh48mG2qtI9ymi3B2OTD8eGfzRYNtNpjKnTXAUiOQf99dNsue1a
   K1X68HQYMcjVv38MucSyPgDpOUXsnubZpS38bbgawpYTErM9MjDwCKrNd
   P3sXhMMx8zZwavB0tGhmfFnZmpa4Bm5hClRLx8ax9EAWD/wmBryqdprrf
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222892962"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="222892962"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 05:08:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="472058377"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.18]) ([10.255.30.18])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 05:08:31 -0800
Message-ID: <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
Date:   Tue, 4 Jan 2022 21:08:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com,
        Laszlo Ersek <lersek@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2021 7:18 PM, Gerd Hoffmann wrote:
>> +int load_tdvf(const char *filename)
>> +{
> 
>> +    for_each_fw_entry(fw, entry) {
>> +        if (entry->address < x86ms->below_4g_mem_size ||
>> +            entry->address > 4 * GiB) {
>> +            tdvf_init_ram_memory(ms, entry);
>> +        } else {
>> +            tdvf_init_bios_memory(fd, filename, entry);
>> +        }
>> +    }
> 
> Why there are two different ways to load the firmware?

because there are two different parts in TDVF:
  a) one is firmware volume (BFV and CFV, i.e., OVMF_CODE.fd and 
OVMF_VAR.fd). Those are ROMs;

  b) the other is some RAM regions, e.g., temp memory for BFV early 
running and TD HOB to pass info to TDVF; Those are RAMs which is already 
added to TDX VM;

> Also: why is all this firmware volume parsing needed?  The normal ovmf
> firmware can simply be mapped just below 4G, why can't tdvf work the
> same way?

Ideally, the firmware (part a above) can be mapped just below 4G like 
what we do for OVMF.

But it needs additional when map part a) to parse the metadata and get 
location of part b) and initialize the RAM of part b). Yes, the 
additional work can be added in existing OVMF laoding flow as pflash.


+ Laszlo,

Regarding laoding TDVF as pflash, I have some questions:

- pflash requires KVM to support readonly mmeory. However, for TDX, it 
doesn't support readonly memory. Is it a must? or we can make an 
exception for TDX?

- I saw from 
https://lists.gnu.org/archive/html/qemu-discuss/2018-04/msg00045.html, 
you said when load OVMF as pflash, it's MMIO. But for TDVF, it's treated 
as private memory. I'm not sure whether it will cause some potential 
problem if loading TDVF with pflash.

Anyway I tried changing the existing pflash approach to load TDVF. It 
can boot a TDX VM and no issue.

> thanks,
>    Gerd
> 

