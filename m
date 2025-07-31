Return-Path: <kvm+bounces-53769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F3FB16B44
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 06:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAACD7A9D0B
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 04:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D394923D2A2;
	Thu, 31 Jul 2025 04:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlO3hyai"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072CC2CA6
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 04:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753936783; cv=none; b=aj0s4r4gUHoxvQ2BqK6GEuywENbxN3qEJjx1ZK11JywigqF9yHOMdEygexplthrdrJbuVFwaupK2fHDZ9X/ZSh1YeTlG5hN362sgb7sQxl3XLVbigGQe1gonw10DNiueOBSqime1dNVQxmerEGMruVL5auY6mlPzG1KsaLVB5kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753936783; c=relaxed/simple;
	bh=HygUCSKDPb+ZfnOS2EBne71G2oaLXAz0zeSk5Ywmfag=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=D7w+bRK2Dp8YXFHz/ox7mc7BJ1h+ACMtK3/ONn+AB86WhIrhDTgUiNlkMS/Uajs1jcmY+jePlgKT2GChC1Dd9t4NRCWnGxE9Thmb7E5nzEWbgPCim1ORoExWSTGMBq/eKZgM5hOCWINbD6fO2eoe+i+y4R2u4A0n43AYChPsmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZlO3hyai; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B21DC4CEEF;
	Thu, 31 Jul 2025 04:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753936781;
	bh=HygUCSKDPb+ZfnOS2EBne71G2oaLXAz0zeSk5Ywmfag=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZlO3hyaiDuoYxiN/p0D3dEaQmqZKHdIa9Z2APxbSTC1Odiq3yBycWNcCE03fPnODi
	 eBo/blkjouKSf+qlMoCen2PiEFca/CG/5JIZIF399CRd0PkbbypFI4jt6WcTRkWh/w
	 Ru9/CmhMkm2wJpTUihm+b7jDO6ytrrGy8tXA/S6q38+4zwfc2BMQiOyvquKfU1ZQc8
	 fChZRp1LwAYl1z6kSwztvi4FdStzTHu51ie+BKBjCOy42oUcqZZ20W+A8bg7EVDKQU
	 f1Lvwrq+VUpwIYVQJUPcGXiJ1oh5/1lDbPcEm2m8Nzvy8FUgiX1HYef0723RncWVyp
	 S7nxg5ctuQVcw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
In-Reply-To: <aIoo59VdZ24F4nsB@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aIZxadj3-uxSwaUu@google.com> <yq5a8qk7bml8.fsf@kernel.org>
 <aIiXSNgqt_6xuaRD@google.com> <yq5att2u9jvi.fsf@kernel.org>
 <aIoo59VdZ24F4nsB@google.com>
Date: Thu, 31 Jul 2025 10:09:36 +0530
Message-ID: <yq5aldo59do7.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Wed, Jul 30, 2025 at 01:43:21PM +0530, Aneesh Kumar K.V wrote:
>> Mostafa Saleh <smostafa@google.com> writes:
>>=20
>> > On Tue, Jul 29, 2025 at 10:49:31AM +0530, Aneesh Kumar K.V wrote:
>> >> Mostafa Saleh <smostafa@google.com> writes:
>> >>=20
>> >> > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wr=
ote:
>> >> >> This also allocates a stage1 bypass and stage2 translate table.
>> >> >
>> >> > So this makes IOMMUFD only working with SMMUv3?
>> >> >
>> >> > I don=E2=80=99t understand what is the point of this configuration?=
 It seems to add
>> >> > extra complexity and extra hw constraints and no extra value.
>> >> >
>> >> > Not related to this patch, do you have plans to add some of the oth=
er iommufd
>> >> > features, I think things such as page faults might be useful?
>> >> >
>> >>=20
>> >> The primary goal of adding viommu/vdevice support is to enable kvmtool
>> >> to serve as the VMM for ARM CCA secure device development. This requi=
res
>> >> a viommu implementation so that a KVM file descriptor can be associat=
ed
>> >> with the corresponding viommu.
>> >>=20
>> >> The full set of related patches is available here:
>> >> https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstrea=
m-post-v1
>> >
>> > I see, but I don't understand why we need a nested setup in that case?
>> > How would having bypassed stage-1 change things?
>> >
>>=20
>> I might be misunderstanding the viommu/vdevice setup, but I was under
>> the impression that it requires an `IOMMU_HWPT_ALLOC_NEST_PARENT`-type
>> HWPT allocation.
>>=20
>> Based on that, I expected the viommu allocation to look something like t=
his:
>>=20
>> 	alloc_viommu.size =3D sizeof(alloc_viommu);
>> 	alloc_viommu.flags =3D  IOMMU_VIOMMU_KVM_FD;
>> 	alloc_viommu.type =3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
>> 	alloc_viommu.dev_id =3D vdev->bound_devid;
>> 	alloc_viommu.hwpt_id =3D alloc_hwpt.out_hwpt_id;
>> 	alloc_viommu.kvm_vm_fd =3D kvm->vm_fd;
>>=20
>> 	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
>>=20
>> Could you clarify if this is the correct usage pattern, or whether a
>> different HWPT setup is expected here?
>
> I believe that's correct, my question was why does it matter if the
> config is S1 bypass + S2 IPA -> PA as opposed to before this patch
> where it would be S1 IPA -> PA and s2 bypass.
>

Can we do a S1 IPA -> PA and s2 bypass with viommu and vdevice?=20

>
> As in this patch we manage the STE but set in bypass, so we don't
> actually use nesting.
>
>>=20
>> >
>> > Also, In case we do something like this, I'd suggest to make it clear
>> > for the command line that this is SMMUv3/CCA only, and maybe move
>> > some of the code to arm64/
>> >
>>=20
>> My intent wasn't to make this SMMUv3-specific. Ideally, we could make
>> the IOMMU type a runtime option in `lkvm`.
>
> Makes sense.
>
> Thanks,
> Mostafa
>
>>=20
>> The main requirement here is the ability to create a `vdevice` and
>> use that in the VFIO setup flow.
>>=20
>> -aneesh

-aneesh

