Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230C64978E2
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 07:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241601AbiAXGXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 01:23:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:43096 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241551AbiAXGXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 01:23:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643005399; x=1674541399;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jSstmPNCf3s4Q1fhHwsv1snaaS9fbX221w264WxTtl0=;
  b=AmatIEmjKEn7fdPn62bFLBVLb6S78tc8s1WR+eBfwqgyOoLH7yXYusc4
   cTHd9t6+bwDYa6qNJxNRXYnMTH6YRpqbNF5F4pgJprmBrHus26x4ov+Tb
   yR8WfaYVeKdJCMxdPyCe4a15TWuqSOKCM4bdqc++9W8fxtr2feszS8ta6
   gNrBdF7UBSKjuK438sJE6emPM7vjmvfEAgQsQ2Ec3TESxXHdA4K+pWeOv
   b47f552RVyKodxPRGMqupgwhkGp9cXhSUKJGxbjXsC9JTEKFkOv3r0Nkf
   x5doo0ELGC31hYLxcq9kOPhD3bk563EJvv1hfbdJR7H7O0CTXzeOuXy3d
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="332327808"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="332327808"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 22:22:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="695306846"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.250]) ([10.249.168.250])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 22:22:51 -0800
Message-ID: <8793aa69-3416-d48e-d690-9f70b1784b46@intel.com>
Date:   Mon, 24 Jan 2022 14:22:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>, Laszlo Ersek <lersek@redhat.com>
Cc:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, seanjc@google.com, erdemaktas@google.com,
        kvm@vger.kernel.org, isaku.yamahata@intel.com,
        "Min M . Xu" <min.m.xu@intel.com>
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

Gerd and Laszlo,

First, thank you for your patient explanation of how pflash works in 
QEMU and the clarification of usage of pflash with OVMF.

Below I want to share current situation of loading TDVF.

Restrictions from TDX architecture:
- Current TDX doesn't support read-only memory, i.e., cannot trap write.

- Current TDVF spec states that "In order to simplify the design, TDVF 
does not support non-volatile variables" in chapter 8.3.3


Regarding what interface should be used to load TDVF, there are three 
options:

   1) pflash: the same as how we load OVMF.

   Suppose TDVF support will finally get into OVMF, using this
   interface, it's full compatible with normal VMs. No change required
   to QEMU command line and TDVF binary is mapped to the GPA address
   right below 4G, but they are actually mapped as RAM.

   Of course, we need several hacks (special handling) in QEMU.

   Of course, they don't work as flash, the change made to it doesn't
   persist.

   2) -bios

   exploit "-bios" parameter to load TDVF. But again, read-only is not
   supported. TDVF is mapped as RAM.

   3) generic loader

   Just like what this series does. Implement specific parser in generic
   loader to load and parse TDVF as private RAM.

I'm nor sure if 1) is acceptable from your side. If not, we will go with 
option 3, since 2) doesn't make too much sense.
