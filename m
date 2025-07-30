Return-Path: <kvm+bounces-53723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23EB3B15A3B
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A14C18A56CE
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AAD266562;
	Wed, 30 Jul 2025 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfEHtQL1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED24254AFF
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 08:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753863207; cv=none; b=CZli0dWZ2JHTrWyRznXct4fnwEGpuuuTTztfXignHFU/KJhifRVEYqmInADUe5TqFHkv8XTkyiAP9DYVeA3EdNf2Y3BIjMDE88tOUasDUuc1l+7eNn50g0d9gAodCNF5fR5rKZKfuibwgotv4RJ/YEIkd1OK1lG/HQFWzkIM6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753863207; c=relaxed/simple;
	bh=MTTcGAXRTNeaHSC151RfymyIZmswy6i7R45PGyWGpdc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EWSCIXUuUKN8VTU1m3DiusL7RNGi7b3TfVHHXshPFkYEcAMU0uDt6sql5q2UmwZfZK9F16Gn3SvBDZGi6ycpUyiho5LiUkSpAfu5vtT2NkmvNTglLHWUOXuTaEObnRS2hp2qyh2nsWBXmaIpeONsJDgiHxUSz3iEOvMy42nYoTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfEHtQL1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28C1C4CEE7;
	Wed, 30 Jul 2025 08:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753863206;
	bh=MTTcGAXRTNeaHSC151RfymyIZmswy6i7R45PGyWGpdc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=HfEHtQL1I/F+jO6vRRGeFUZcUz5q/PwmN/K+hplmuSDlMEAfZha5UUWDknyHHqQ8a
	 ubjE1LrV00sQz76ppcPeRWSfxz76CWj1sdJCuhRNAXouo4pb6tb7LFdSGyTv5YHOMx
	 lXY/iSY15AYsNsQlePdygem6N93521h9zPcvJ74hSvUBdsOEjSw7gEiEo76RMoZ4gy
	 GvIAVTS0fE0Fba9a/MJmV9Ot2VhR+u5V2/MsaJ/C3ECEgsalRMKuif/fpUPrvf6JBS
	 1VmlSevGpKxw9HjCq4ar5gKeT2JdRhSiIIGh4Po6j57byiOx3vYtinqxtEGlhoAdvO
	 FIIpGaJzUXhkA==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
In-Reply-To: <aIiXSNgqt_6xuaRD@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aIZxadj3-uxSwaUu@google.com> <yq5a8qk7bml8.fsf@kernel.org>
 <aIiXSNgqt_6xuaRD@google.com>
Date: Wed, 30 Jul 2025 13:43:21 +0530
Message-ID: <yq5att2u9jvi.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Tue, Jul 29, 2025 at 10:49:31AM +0530, Aneesh Kumar K.V wrote:
>> Mostafa Saleh <smostafa@google.com> writes:
>>=20
>> > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> >> This also allocates a stage1 bypass and stage2 translate table.
>> >
>> > So this makes IOMMUFD only working with SMMUv3?
>> >
>> > I don=E2=80=99t understand what is the point of this configuration? It=
 seems to add
>> > extra complexity and extra hw constraints and no extra value.
>> >
>> > Not related to this patch, do you have plans to add some of the other =
iommufd
>> > features, I think things such as page faults might be useful?
>> >
>>=20
>> The primary goal of adding viommu/vdevice support is to enable kvmtool
>> to serve as the VMM for ARM CCA secure device development. This requires
>> a viommu implementation so that a KVM file descriptor can be associated
>> with the corresponding viommu.
>>=20
>> The full set of related patches is available here:
>> https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstream-p=
ost-v1
>
> I see, but I don't understand why we need a nested setup in that case?
> How would having bypassed stage-1 change things?
>

I might be misunderstanding the viommu/vdevice setup, but I was under
the impression that it requires an `IOMMU_HWPT_ALLOC_NEST_PARENT`-type
HWPT allocation.

Based on that, I expected the viommu allocation to look something like this:

	alloc_viommu.size =3D sizeof(alloc_viommu);
	alloc_viommu.flags =3D  IOMMU_VIOMMU_KVM_FD;
	alloc_viommu.type =3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
	alloc_viommu.dev_id =3D vdev->bound_devid;
	alloc_viommu.hwpt_id =3D alloc_hwpt.out_hwpt_id;
	alloc_viommu.kvm_vm_fd =3D kvm->vm_fd;

	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {

Could you clarify if this is the correct usage pattern, or whether a
different HWPT setup is expected here?

>
> Also, In case we do something like this, I'd suggest to make it clear
> for the command line that this is SMMUv3/CCA only, and maybe move
> some of the code to arm64/
>

My intent wasn't to make this SMMUv3-specific. Ideally, we could make
the IOMMU type a runtime option in `lkvm`.

The main requirement here is the ability to create a `vdevice` and
use that in the VFIO setup flow.

-aneesh

