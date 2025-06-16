Return-Path: <kvm+bounces-49586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF01CADAA80
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F42916AE32
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 08:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701C626D4D5;
	Mon, 16 Jun 2025 08:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lf96xJkg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C20F1BF33F;
	Mon, 16 Jun 2025 08:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750061816; cv=none; b=Ez8teZRAUuvf6xSVR9aRBztrzsxhK77fINuQsIEPw/ovblxSPkAwytbHMdFytRcdc8PZpokgU6TtztAmNQrhPgamw8FQ3U6bAA58dvkVl1IVqWsg3xozv9mpVom+G/+r1ZelNYFLeX4PaGfgdUewvFwoxKOpdbkrC0F7z4DzWY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750061816; c=relaxed/simple;
	bh=ly1IWPhnZ1mdLMMMt0ZwbtlmSqYG5wNvS1Mp/mjCGh8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=jpqDDyN1FLTSd4OvPPgmp4CMadj9JKcslBXknKR+x6l3Yfo2b4QbA+ihHNI2hSXLsUeGIka7I1lPIqi3sktRXh7jWzIYz4B/ATbbSwbe5dHgpq6AJGE1qeJBwljHNNrPz3B/cbvGgIk8BullHqdtPeXBjRKcAdehqRvYpTmh8HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lf96xJkg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7A2C4CEEF;
	Mon, 16 Jun 2025 08:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750061816;
	bh=ly1IWPhnZ1mdLMMMt0ZwbtlmSqYG5wNvS1Mp/mjCGh8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=lf96xJkgz6KBIDKXutGdJKHWBKiiYSI3P6IV8Rt4Ezx881d0N/1Wijd5CsuRIrmEH
	 iO0ucq0zXsVTGRDCftXbROmy1p+s47E4JpV7ohXYepO9R7fK74pYfzjnB9FPr2Dlx+
	 D9NmY1kqgsg4kqDo/WT/NtXgtFSN2gwawJtsZ8RQTdBYPsqQTV/Q6+/FKiJNkmFfpH
	 38ON4HibYUOxRIYYPLb0P68B7/oMeIWR9jxB6ugZJYqrpWHcs86OBbGakdHQuLjjdL
	 QV9OSCvZIdRlCd+8xO5J6YwfLV78gsg+hBMUxv6kqHIlfm5xqRf9CiuRuve6uXlEVF
	 3uekUV373Yc3w==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
In-Reply-To: <aEFmPaYorqaYCKBY@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5aplfn210z.fsf@kernel.org> <aD24r44v0g1NgeZs@yilunxu-OptiPlex-7050>
 <yq5ajz5r8w6p.fsf@kernel.org> <aEFmPaYorqaYCKBY@yilunxu-OptiPlex-7050>
Date: Mon, 16 Jun 2025 13:46:42 +0530
Message-ID: <yq5a5xgwt82d.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xu Yilun <yilun.xu@linux.intel.com> writes:

> On Wed, Jun 04, 2025 at 07:07:18PM +0530, Aneesh Kumar K.V wrote:
>> Xu Yilun <yilun.xu@linux.intel.com> writes:
>> 
>> > On Sun, Jun 01, 2025 at 04:15:32PM +0530, Aneesh Kumar K.V wrote:
>> >> Xu Yilun <yilun.xu@linux.intel.com> writes:
>> >> 
>> >> > Add new IOCTLs to do TSM based TDI bind/unbind. These IOCTLs are
>> >> > expected to be called by userspace when CoCo VM issues TDI bind/unbind
>> >> > command to VMM. Specifically for TDX Connect, these commands are some
>> >> > secure Hypervisor call named GHCI (Guest-Hypervisor Communication
>> >> > Interface).
>> >> >
>> >> > The TSM TDI bind/unbind operations are expected to be initiated by a
>> >> > running CoCo VM, which already have the legacy assigned device in place.
>> >> > The TSM bind operation is to request VMM make all secure configurations
>> >> > to support device work as a TDI, and then issue TDISP messages to move
>> >> > the TDI to CONFIG_LOCKED or RUN state, waiting for guest's attestation.
>> >> >
>> >> > Do TSM Unbind before vfio_pci_core_disable(), otherwise will lead
>> >> > device to TDISP ERROR state.
>> >> >
>> >> 
>> >> Any reason these need to be a vfio ioctl instead of iommufd ioctl?
>> >> For ex: https://lore.kernel.org/all/20250529133757.462088-3-aneesh.kumar@kernel.org/
>> >
>> > A general reason is, the device driver - VFIO should be aware of the
>> > bound state, and some operations break the bound state. VFIO should also
>> > know some operations on bound may crash kernel because of platform TSM
>> > firmware's enforcement. E.g. zapping MMIO, because private MMIO mapping
>> > in secure page tables cannot be unmapped before TDI STOP [1].
>> >
>> > Specifically, for TDX Connect, the firmware enforces MMIO unmapping in
>> > S-EPT would fail if TDI is bound. For AMD there seems also some
>> > requirement about this but I need Alexey's confirmation.
>> >
>> > [1] https://lore.kernel.org/all/aDnXxk46kwrOcl0i@yilunxu-OptiPlex-7050/
>> >
>> 
>> According to the TDISP specification (Section 11.2.6), clearing either
>> the Bus Master Enable (BME) or Memory Space Enable (MSE) bits will cause
>> the TDI to transition to an error state. To handle this gracefully, it
>> seems necessary to unbind the TDI before modifying the BME or MSE bits.
>
> Yes. But now the suggestion is never let VFIO do unbind, instead VFIO
> should block these operations when device is bound.
>
>> 
>> If I understand correctly, we also need to unmap the Stage-2 mapping due
>> to the issue described in commit
>> abafbc551fddede3e0a08dee1dcde08fc0eb8476. Are there any additional
>> reasons we would want to unmap the Stage-2 mapping for the BAR (as done
>> in vfio_pci_zap_and_down_write_memory_lock)?
>
> I think no more reason. 
>
>> 
>> Additionally, with TDX, it appears that before unmapping the Stage-2
>> mapping for the BAR, we should first unbind the TDI (ie, move it to the
>> "unlock" state?) Is this step related Section 11.2.6 of the TDISP spec,
>> or is it driven by a different requirement?
>
> No, this is not device side TDISP requirement. It is host side
> requirement to fix DMA silent drop issue. TDX enforces CPU S2 PT share
> with IOMMU S2 PT (does ARM do the same?), so unmap CPU S2 PT in KVM equals
> unmap IOMMU S2 PT.
>
> If we allow IOMMU S2 PT unmapped when TDI is running, host could fool
> guest by just unmap some PT entry and suppress the fault event. Guest
> thought a DMA writting is successful but it is not and may cause
> data integrity issue.
>

I am still trying to find more details here. How did the guest conclude
DMA writing is successful? Guest would timeout waiting for DMA to complete
if the host hides the interrupt delivery of failed DMA transfer?

>
> This is not a TDX specific problem, but different vendors has different
> mechanisms for this. For TDX, firmware fails the MMIO unmap for S2. For
> AMD, will trigger some HW protection called "ASID fence" [1]. Not sure
> how ARM handles this?
>
> https://lore.kernel.org/all/aDnXxk46kwrOcl0i@yilunxu-OptiPlex-7050/
>
> Thanks,
> Yilun
>

-aneesh

