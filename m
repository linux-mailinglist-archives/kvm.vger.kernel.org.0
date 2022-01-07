Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CB6487349
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 08:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiAGHGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 02:06:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:43503 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229560AbiAGHGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 02:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641539164; x=1673075164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dcir3Ffal0vUADpdNEqrL/soZai/8Aq4FsqiXQdZrkw=;
  b=Ib6Hy+lFiZ8TIwejMn1nNaExqPd9f2MZKB52W78rlx3O73GoxkKjV8WM
   EixOfRYCPjuWpTJ28Yxv+fbADo7TYnlbGTL0uhp+IBzgCsNfr+j/MEyac
   ZQLWaquwcVtUKCYYSQ6E7VY3OH7d/M6Tng5S2wv3WObF5TMbgMQ1TJCTg
   aYLfq6oMzAu4Oa+IUs7N4ZsQjQGLJaW5nHf5V6/muJAElfYVdpR+prm5x
   3AC4yMid2Cqx50ZDXP55yq7Shdbh7d4e+r3RJyK4N7N0yv4AJxNDGPQR+
   CkFWz/HK2xSsOKP5Bkj11i9ANtfF15hzgwd1SdfbDnqJOHq0piZ7akGYR
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="241636836"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="241636836"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 23:06:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="621813370"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.145]) ([10.255.31.145])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 23:05:59 -0800
Message-ID: <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
Date:   Fri, 7 Jan 2022 15:05:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Content-Language: en-US
To:     Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
 <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/2022 12:06 AM, Laszlo Ersek wrote:
> On 01/04/22 14:08, Xiaoyao Li wrote:
> 
>> + Laszlo,
>>
>> Regarding laoding TDVF as pflash, I have some questions:
>>
>> - pflash requires KVM to support readonly mmeory. However, for TDX, it
>> doesn't support readonly memory. Is it a must? or we can make an
>> exception for TDX?
>>
>> - I saw from
>> https://lists.gnu.org/archive/html/qemu-discuss/2018-04/msg00045.html,
>> you said when load OVMF as pflash, it's MMIO. But for TDVF, it's treated
>> as private memory. I'm not sure whether it will cause some potential
>> problem if loading TDVF with pflash.
>>
>> Anyway I tried changing the existing pflash approach to load TDVF. It
>> can boot a TDX VM and no issue.
> 
> I have no comments on whether TDX should or should not use pflash.
> 
> If you go without pflash, then you likely will not have a
> standards-conformant UEFI variable store. (Unless you reimplement the
> variable arch protocols in edk2 on top of something else than the Fault
> Tolerant Write and Firmware Volume Block protocols.) Whether a
> conformant UEFI varstore matters to you (or to TDX in general) is
> something I can't comment on.

Thanks for your reply! Laszlo

regarding "standards-conformant UEFI variable store", I guess you mean 
the change to UEFI non-volatile variables needs to be synced back to the 
OVMF_VARS.fd file. right?

If so, I need to sync with internal folks who are upstreaming TDVF 
support into OVMF.

> (I've generally stopped commenting on confidential computing topics, but
> this message allows for comments on just pflash, and how it impacts OVMF.)
> 
> Regarding pflash itself, the read-only KVM memslot is required for it.
> Otherwise pflash cannot work as a "ROMD device" (= you can't flip it
> back and forth between ROM mode and programming (MMIO) mode).

We don't need Read-only mode for TDVF so far. If for this purpose, is it 
acceptable that allowing a pflash without KVM readonly memslot support 
if read-only is not required for the specific pflash device?

We are trying to follow the existing usage of OVMF for TDX, since TDVF 
support will be landed in OVMF instead of a new separate binary.

> Thanks
> Laszlo
> 

