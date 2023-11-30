Return-Path: <kvm+bounces-2849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F36757FE9C1
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C27FB20E33
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 07:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C135200B9;
	Thu, 30 Nov 2023 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j5WBXzog"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D7B9
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 23:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701329537; x=1732865537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MhyNAN59jGiFlQny5EFhPJfUBE5/214AnRgM0gfUD0o=;
  b=j5WBXzogVcAUxHRRcH2/AhTUzMVGU+i0SPm+4yr52BDLohVxOCVtNbcy
   n13OrWzKR5HXcp/rKhD0GdgQEeBNVgRKE2CgHEJf+Pk+Q1bmPwzz+7D97
   Y+nPdkmSpJNDaqG/i48dIfWO7tyixrFxCA8WYuEGr27O6gxd0hdz5USzs
   do57LInADPDq3s+dM2BvjrRfQpM+ObmLVBXMVNggVNy6lADrSejokr7xm
   3cmQqitIEZ7EZu81vZ8lVit7HRWgLR3l5tzPbmMdQer8Av9MpHJJrLLgR
   GPYBGpSGf6bCRcjktWEuuE4OIFn+kXhrtmfGHyZN1ChRrLcHcv71CIZw4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="479484332"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="479484332"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:32:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="769202097"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="769202097"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 23:32:10 -0800
Message-ID: <4708c33a-bb8d-484e-ac7b-b7e8d3ed445a@intel.com>
Date: Thu, 30 Nov 2023 15:32:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
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
 <20231115071519.2864957-4-xiaoyao.li@intel.com>
 <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
 <05f0e440-36a2-4d3a-8caa-842b34e50dce@intel.com>
 <0fbfc413-7c74-4b2a-bade-6f3f04ca82c2@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <0fbfc413-7c74-4b2a-bade-6f3f04ca82c2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/2023 5:26 PM, David Hildenbrand wrote:
> 
>>> ... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)
>>
>> Get caught.
>>
>>> This should be factored out into a common helper.
>>
>> Sure, will do it in next version.
> 
> Factor it out in a separate patch. Then, this patch is get small that 
> you can just squash it into #2.
> 
> And my comment regarding "flags = 0" to patch #2 does no longer apply :)
> 

I see.

But it depends on if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE will appear together 
with initial guest memfd in linux (hopefully 6.8)
https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com/

If like Paolo committed, no KVM_GUEST_MEMFD_ALLOW_HUGEPAGE in initial 
merge, I will go simplify Patch #2. Otherwise factor out a common 
function to get hugepage size as you suggested.

Thanks!

