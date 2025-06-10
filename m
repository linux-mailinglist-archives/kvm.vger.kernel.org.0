Return-Path: <kvm+bounces-48779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 452F5AD2D31
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 07:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEC6116EB2F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 05:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432C625EF8F;
	Tue, 10 Jun 2025 05:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VOtvCzaJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43801D9A5F;
	Tue, 10 Jun 2025 05:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532826; cv=none; b=dg4NB/MjJwYcVmKeE3K2kYybf52sfOQ+R4MOxp6iObHIhGmev4ThX8kk8ZBufomsDlke93oN95ZTMDrISFDiiFl6EyEF7+Xp6Jv6MmsU4tmIphBNBz62bo8fddjuKe1INUwn5wbkyJV5mvyd25H0I3l+L8m0OIG7olLBIeSxOqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532826; c=relaxed/simple;
	bh=7UduM03vJniQZx0LIRBGRrRrB795yrEqhfwv6fFHnwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QCXII6v9TNvuX2tMnSBI8ejXlqSkVIJSDNBsCKHEgiZAtY4fam7EWcfNjaA0xNAv/5xQqPbT8FJQX5WX02PWM8aZaS3Jw52ibn7YDFXL29Tp4UPCf96B0/tz2QRSRSeMZ4S5E4SRm96VMNKRiopF+lSNnx/jX/+aCcrMkvHelbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VOtvCzaJ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749532825; x=1781068825;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7UduM03vJniQZx0LIRBGRrRrB795yrEqhfwv6fFHnwg=;
  b=VOtvCzaJXsyxuat/mlL4zguzfsDYyRFj8+gibqDeULN7Zli1tOVVolmi
   zWLm9IcWvyKQoDTg6n4WA/jgIcPqt2GXynWxlqoySWCpq40GOTdbTxghc
   EFkQFf94jFFpaXfbOTJWkm1BoJJqMJ/mFeMm5tt88jG1GEOkiE2M89hlW
   M3G5YS1caixoI1uAFtPOHCl0JqwxaaB02s9j0WtwZtYpO1I5dLQjfaaeD
   2vQVnsRLV2Qj5eckF6PwSfMrvQyr/YTueEQ2JQmZUtsTmcyO0/YCRmhE9
   QX0voSa7A0HSNVDHfQeb+I3asC4XVbBLcqsTgUbrUf4ZFTfFqN7jsLi0o
   g==;
X-CSE-ConnectionGUID: /l/HURq7Rbu2qCi7jLGnew==
X-CSE-MsgGUID: 3/pboYefRWOlQdQ7yh2dKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51717366"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="51717366"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 22:20:24 -0700
X-CSE-ConnectionGUID: 11QiN1ZEQJmV5AHsUIjsrA==
X-CSE-MsgGUID: zLDEvjNOR1SKdVeGzXzr1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="146701628"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 22:20:18 -0700
Message-ID: <c3fbf6ac-92b9-4a14-9505-ab9e8f30b06b@linux.intel.com>
Date: Tue, 10 Jun 2025 13:19:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
To: Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
 christian.koenig@amd.com, pbonzini@redhat.com, seanjc@google.com,
 alex.williamson@redhat.com, vivek.kasireddy@intel.com,
 dan.j.williams@intel.com, yilun.xu@intel.com, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
 daniel.vetter@ffwll.ch, leon@kernel.org, zhenzhong.duan@intel.com,
 tao1.su@intel.com
References: <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com> <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
 <20250514163339.GD382960@nvidia.com> <aCYQdDrYYZRAgsen@yilunxu-OptiPlex-7050>
 <9dea400f-a57b-43be-a2e4-24a9f51e6ba0@amd.com>
 <aDE5SPzOAU0sNIt+@yilunxu-OptiPlex-7050>
 <ae16db07-5fca-4369-aa67-cbe2e0fd60fd@amd.com>
 <aDhyC73r149syMpc@yilunxu-OptiPlex-7050>
 <79872224-4e81-446b-a451-28260f449ea9@amd.com>
 <aDnbgBbxF8IkH/cq@yilunxu-OptiPlex-7050>
 <bd0d8d69-78dd-44d8-9f32-d945bc6078c2@amd.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <bd0d8d69-78dd-44d8-9f32-d945bc6078c2@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/25 12:20, Alexey Kardashevskiy wrote:
> 
> 
> On 31/5/25 02:23, Xu Yilun wrote:
>> On Fri, May 30, 2025 at 12:29:30PM +1000, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 30/5/25 00:41, Xu Yilun wrote:
>>>>>>>>
>>>>>>>> FLR to a bound device is absolutely fine, just break the CC state.
>>>>>>>> Sometimes it is exactly what host need to stop CC immediately.
>>>>>>>> The problem is in VFIO's pre-FLR handling so we need to patch 
>>>>>>>> VFIO, not
>>>>>>>> PCI core.
>>>>>>>
>>>>>>> What is a problem here exactly?
>>>>>>> FLR by the host which equals to any other PCI error? The guest 
>>>>>>> may or may not be able to handle it, afaik it does not handle any 
>>>>>>> errors now, QEMU just stops the guest.
>>>>>>
>>>>>> It is about TDX Connect.
>>>>>>
>>>>>> According to the dmabuf patchset, the dmabuf needs to be revoked 
>>>>>> before
>>>>>> FLR. That means KVM unmaps MMIOs when the device is in LOCKED/RUN 
>>>>>> state.
>>>>>> That is forbidden by TDX Module and will crash KVM.
>>>>>
>>>>>
>>>>> FLR is something you tell the device to do, how/why would TDX know 
>>>>> about it?
>>>>
>>>> I'm talking about FLR in VFIO driver. The VFIO driver would zap bar
>>>> before FLR. The zapping would trigger KVM unmap MMIOs. See
>>>> vfio_pci_zap_bars() for legacy case, and see [1] for dmabuf case.
>>>
>>> oh I did not know that we do this zapping, thanks for the pointer.
>>>> [1] https://lore.kernel.org/kvm/20250307052248.405803-4- 
>>>> vivek.kasireddy@intel.com/
>>>>
>>>> A pure FLR without zapping bar is absolutely OK.
>>>>
>>>>> Or it check the TDI state on every map/unmap (unlikely)?
>>>>
>>>> Yeah, TDX Module would check TDI state on every unmapping.
>>>
>>> _every_? Reading the state from DOE mailbox is not cheap enough 
>>> (imho) to do on every unmap.
>>
>> Sorry for confusing. TDX firmware just checks if STOP TDI firmware call
>> is executed, will not check the real device state via DOE. That means
>> even if device has physically exited to UNLOCKED, TDX host should still
>> call STOP TDI fwcall first, then MMIO unmap.
>>
>>>
>>>>>
>>>>>> So the safer way is
>>>>>> to unbind the TDI first, then revoke MMIOs, then do FLR.
>>>>>>
>>>>>> I'm not sure when p2p dma is involved AMD will have the same issue.
>>>>>
>>>>> On AMD, the host can "revoke" at any time, at worst it'll see RMP 
>>>>> events from IOMMU. Thanks,
>>>>
>>>> Is the RMP event firstly detected by host or guest? If by host,
>>>
>>> Host.
>>>
>>>> host could fool guest by just suppress the event. Guest thought the
>>>> DMA writting is successful but it is not and may cause security issue.
>>>
>>> An RMP event on the host is an indication that RMP check has failed 
>>> and DMA to the guest did not complete so the guest won't see new 
>>> data. Same as other PCI errors really. RMP acts like a firewall, 
>>> things behind it do not need to know if something was dropped. Thanks,
>>
>> Not really, guest thought the data is changed but it actually doesn't.
>> I.e. data integrity is broken.
> 
> I am not following, sorry. Integrity is broken when something untrusted 
> (== other than the SNP guest and the trusted device) manages to write to 
> the guest encrypted memory successfully. If nothing is written - the 
> guest can easily see this and do... nothing? Devices have bugs or 
> spurious interrupts happen, the guest driver should be able to cope with 
> that.

Data integrity might not be the most accurate way to describe the
situation here. If I understand correctly, the MMIO mapping was
destroyed before the device was unbound (meaning the guest still sees
the device). When the guest issues a P2P write to the device's MMIO, it
will definitely fail, but the guest won't be aware of this failure.

Imagine this on a bare-metal system: if a P2P access targets a device's
MMIO but the device or platform considers it an illegal access, there
should be a bus error or machine check exception. Alternatively, if the
device supports out-of-band AER, the AER driver should then catch and
process these errors.

Therefore, unbinding the device before MMIO invalidation could generally
avoid this.

Thanks,
baolu

