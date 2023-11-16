Return-Path: <kvm+bounces-1860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECCC77ED9B5
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214871C209E8
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B7263D8;
	Thu, 16 Nov 2023 02:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ONYt42tL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE59199
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 18:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700102752; x=1731638752;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=USgPVJryTN/nazjsm6bRr8SP6B/qY4QF0GRbSH7gwH8=;
  b=ONYt42tLQGnXwrhPXfZj4gTiZpGPJvG7eORGQUzmx442ASV7iHavGI43
   Bv6VvolkSWSnpoP/NbBkdVri/QW/QQ11+IqqNViPCwn31PNprkH/joDgC
   BmN0uxcmW2WgUPNCtdA2VxvVeSw8tVXIVZinEJ2o8hWzCZ5ccH/BqmfqE
   bJEcxwI6D92Hn8GNbfpQ4dMPsYOvC6LLpdO7rN/Fsfvdq0lYM2iR7PMDS
   VTaTWrqmYp7ijQpHDGphF7KwLolVieb9cS2vn40XP/4tXp5+9Wh/a8K5m
   u6PumiIH+hDBCmX35/24LiiWhRDpF4WPX4wTwJcSP+A9/+/z3jny2Qotq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="9641428"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="9641428"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:45:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="800039868"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="800039868"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:45:45 -0800
Message-ID: <37b5ba85-021a-418b-8eda-8a716b7b7fb3@intel.com>
Date: Thu, 16 Nov 2023 10:45:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-3-xiaoyao.li@intel.com>
 <ed599765-65b7-4253-8de2-61afba178e2d@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ed599765-65b7-4253-8de2-61afba178e2d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/2023 1:54 AM, David Hildenbrand wrote:
> On 15.11.23 08:14, Xiaoyao Li wrote:
>> Add KVM guest_memfd support to RAMBlock so both normal hva based memory
>> and kvm guest memfd based private memory can be associated in one 
>> RAMBlock.
>>
>> Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM ioctl to
>> create private guest_memfd during RAMBlock setup.
>>
>> Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
>> confidential guests, such as TDX VM. How and when to set it for memory
>> backends will be implemented in the following patches.
> 
> Can you elaborate (and add to the patch description if there is good 
> reason) why we need that flag and why we cannot simply rely on the VM 
> type instead to decide whether to allocate a guest_memfd or not?
> 

The reason is, relying on the VM type is sort of hack that we need to 
get the MachineState instance and retrieve the vm type info. I think 
it's better not to couple them.

More importantly, it's not flexible and extensible for future case that 
not all the memory need guest memfd.

