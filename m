Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4602F45B560
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 08:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbhKXHep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 02:34:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:27076 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhKXHeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 02:34:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235169426"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="235169426"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 23:31:20 -0800
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="509771296"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.159]) ([10.255.29.159])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 23:31:16 -0800
Message-ID: <03aaab8b-0a50-6b56-2891-ccd58235ad83@intel.com>
Date:   Wed, 24 Nov 2021 15:31:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.1
Subject: Re: [RFC PATCH v2 06/44] hw/i386: Introduce kvm-type for TDX guest
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
 <20210826102212.gykq2z4fb2iszb2k@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20210826102212.gykq2z4fb2iszb2k@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2021 6:22 PM, Gerd Hoffmann wrote:
> On Wed, Jul 07, 2021 at 05:54:36PM -0700, isaku.yamahata@gmail.com wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Introduce a machine property, kvm-type, to allow the user to create a
>> Trusted Domain eXtensions (TDX) VM, a.k.a. a Trusted Domain (TD), e.g.:
>>
>>   # $QEMU \
>> 	-machine ...,kvm-type=tdx \
>> 	...

Sorry for the very late reply.

> Can we align sev and tdx better than that?
> 
> SEV is enabled this way:
> 
> qemu -machine ...,confidential-guest-support=sev0 \
>       -object sev-guest,id=sev0,...
> 
> (see docs/amd-memory-encryption.txt for details).
> 
> tdx could likewise use a tdx-guest object (and both sev-guest and
> tdx-guest should probably have a common parent object type) to enable
> and configure tdx support.

yes, sev only introduced a new object and passed it to 
confidential-guest-support. This is because SEV doesn't require the new 
type of VM.
However, TDX does require a new type of VM.

If we read KVM code, there is a parameter of CREATE_VM to pass the 
vm_type, though x86 doesn't use this field so far. On QEMU side, it also 
has the codes to pass/configure vm-type in command line. Of cousre, x86 
arch doesn't implement it. With upcoming TDX, it will implement and use 
vm type for TDX. That's the reason we wrote this patch to implement 
kvm-type for x86, similar to other arches.

yes, of course we can infer the vm_type from "-object tdx-guest". But I 
prefer to just use vm_type. Let's see others opinion.

thanks,
-Xiaoyao

> take care,
>    Gerd
> 

