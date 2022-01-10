Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DA5489846
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 13:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245235AbiAJMJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 07:09:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:32158 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236117AbiAJMJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 07:09:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641816573; x=1673352573;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bAHGK9eNZdWd+9mTtbAvP5QK/8pqTMOjwvz9yiYjb1w=;
  b=H0SbKNNHwb8bUD9AMF4kw6m9nxciefi3RzuhUFaGqO3ebCUisV4B1ET0
   Qw8E9MwSAVkO6GtD1ydb9halJELYpGmOxOBlWqGfQ8flJSOpLyaoXNee0
   8dYR4rOhcfu5rQXdnoIsxGXwTzdWqZj8zXosI/SFnWuvGWLKZoZsHfqTj
   F8k+9QO2NteRrXNEzIPtjEXM9iWahVB0e2nHzy6LvMVIYRMjBKrbFlt5y
   ZPDu5LjIh7cfpEXN0j5OtxdGK0uBzZKHVBpXrLPNuw+O32COg1ZwLcBOJ
   ASUZue2GHHYEcswffa0MkufJNgab11Y5T8bk4OflqF2uIEzM5gJfvJXCO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267537889"
X-IronPort-AV: E=Sophos;i="5.88,277,1635231600"; 
   d="scan'208";a="267537889"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 04:09:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,277,1635231600"; 
   d="scan'208";a="528246363"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.157]) ([10.249.174.157])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 04:09:28 -0800
Message-ID: <0771d5e3-c1b8-c3ad-3f3c-f117dfcc4d13@intel.com>
Date:   Mon, 10 Jan 2022 20:09:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Laszlo Ersek <lersek@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
 <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
 <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
 <20220110110120.ldjekirdzgmgex4z@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220110110120.ldjekirdzgmgex4z@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/2022 7:01 PM, Gerd Hoffmann wrote:
>>> If you go without pflash, then you likely will not have a
>>> standards-conformant UEFI variable store. (Unless you reimplement the
>>> variable arch protocols in edk2 on top of something else than the Fault
>>> Tolerant Write and Firmware Volume Block protocols.) Whether a
>>> conformant UEFI varstore matters to you (or to TDX in general) is
>>> something I can't comment on.
>>
>> Thanks for your reply! Laszlo
>>
>> regarding "standards-conformant UEFI variable store", I guess you mean the
>> change to UEFI non-volatile variables needs to be synced back to the
>> OVMF_VARS.fd file. right?
> 
> Yes.  UEFI variables are expected to be persistent, and syncing to
> OVMF_VARS.fd handles that.

Further question.

Is it achieved via read-only memslot that when UEFI variable gets 
changed, it exits to QEMU with KVM_EXIT_MMIO due to read-only memslot so 
QEMU can sync the change to OVMF_VAR.fd?

> Not fully sure whenever that expectation holds up in the CC world.  At
> least the AmdSev variant has just OVMF.fd, i.e. no CODE/VARS split.
> 
>>> Regarding pflash itself, the read-only KVM memslot is required for it.
>>> Otherwise pflash cannot work as a "ROMD device" (= you can't flip it
>>> back and forth between ROM mode and programming (MMIO) mode).
>>
>> We don't need Read-only mode for TDVF so far. If for this purpose, is it
>> acceptable that allowing a pflash without KVM readonly memslot support if
>> read-only is not required for the specific pflash device?
> 
> In case you don't want/need persistent VARS (which strictly speaking is
> a UEFI spec violation) you should be able to go for a simple "-bios
> OVMF.fd".
> 
> take care,
>    Gerd
> 

