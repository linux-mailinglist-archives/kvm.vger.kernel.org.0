Return-Path: <kvm+bounces-1862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EE17ED9C7
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:53:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 678FD1F236A2
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038258F6B;
	Thu, 16 Nov 2023 02:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="agyZMvc5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A75B199
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 18:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700103221; x=1731639221;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7YQsp0BB0MmC5NMWVPrWH3O7XPeWtRCU9nNABC8pwXk=;
  b=agyZMvc5kKpdsdHhZGVwJC8zyxgf7RPAMyCDjWQ7j0sBUoorDb4cvp+t
   fvvI3x9BGfEu4SmE4BnCcV2zDeBiDSdkvS98pKKWisib6vSDih2bU6VXj
   yOBKKAbfsr3zMshQ6oOe5RPY4VZp8HSo6jPJuDXBc9U5QsZZ1NdrlbjA9
   V+QISoi4l3+wHeVpjsHKJf9qfJrdj30Vr/HeGXfJyezsEh13RyHLuzYME
   dGXEfczSVXBpOMgGUY5PHjnGNaCdg6aJw/lrx0tjgGeF2HJ2AgK5kuX7+
   3kaAo5AWL/KeByFkGt2IZDpsqLoSghqUr/T22aACBok+TcQRlaEx3327y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="422092961"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="422092961"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:53:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="6603847"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 18:53:35 -0800
Message-ID: <6674dc2c-f1ed-496e-bc17-256869bdeae9@intel.com>
Date: Thu, 16 Nov 2023 10:53:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/70] HostMem: Add mechanism to opt in kvm guest memfd
 via MachineState
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
 <20231115071519.2864957-5-xiaoyao.li@intel.com>
 <af2a5b80-f259-45b1-9d92-812e3c4bc06c@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <af2a5b80-f259-45b1-9d92-812e3c4bc06c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/2023 2:14 AM, David Hildenbrand wrote:
> On 15.11.23 08:14, Xiaoyao Li wrote:
>> Add a new member "require_guest_memfd" to memory backends. When it's set
>> to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
>> guest_memfd will be allocated during RAMBlock allocation.
>>
>> Memory backend's @require_guest_memfd is wired with @require_guest_memfd
>> field of MachineState. MachineState::require_guest_memfd is supposed to
>> be set by any VMs that requires KVM guest memfd as private memory, e.g.,
>> TDX VM.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> I'm confused, why do we need this if it's going to be the same for all 
> memory backends right now?
> 

I want to provide a elegant (in my sense) way to configure "the need of 
guest memfd" instead of checking x86machinestate->vm_type in physmem.c

