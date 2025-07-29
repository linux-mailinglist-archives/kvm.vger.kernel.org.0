Return-Path: <kvm+bounces-53598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B3CB14760
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BA0B16178D
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 05:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8970E22DA0C;
	Tue, 29 Jul 2025 05:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/F+/Aw0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59254A02
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 05:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765398; cv=none; b=QAbIAMoM1yt7Nlq12PJ7uJHIKWyyz43aYCG19mpBrPnPLCAafWpUq1SLfKVmEJE4B6cvgjDwqSNeUEPNv1tMJr2pzl9Ef4JHk0HKnXngYnB3hivmWIsV9a8O8g95Nt19nZGeNPOI97Tou7dPxFk4iZOiTeK21Juhda9McLPBo5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765398; c=relaxed/simple;
	bh=D/cz3N4KvTH2zvJcMMw/y/ERc33ud6vojHcKrX9cMK4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TvUK7FA/ebN59eNKpcceXO0DAUABXN2ORLsRM6WbSmkaqZUvW8zEviyK139ltz76lh/zC/YBTi6cUoEEHRVDGYyvySpKXp48QN/6SYT5hVLjfENjaIvmWevGfO+xi1yivVSnev0gSYs8ePZnBdHScl3v1eDogFdX4opuhHC/kkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/F+/Aw0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434AEC4CEEF;
	Tue, 29 Jul 2025 05:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753765398;
	bh=D/cz3N4KvTH2zvJcMMw/y/ERc33ud6vojHcKrX9cMK4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=g/F+/Aw0aiRpRYdKAa7H6WYwZ+jSslFVRcjvfI0f7sMIMDnm7d7a0DSnvWSqhLxrm
	 3Z1uxNBfm3zIWW3nJPjyZSGpwqbtAkhTJk0VVOmUfvsg/MuFG7ioa/liaKp3cceBDx
	 PmXRpagROn/XDDISAmvawG5gARDcyU/not7l1Y0+r9VRClAEgFzQ4tg99z1z0RUcyY
	 lg72WGksYPVCqUO6e1LAtxGdK+NXuE5YTZRhamsNqYhzcsjmHXwKOYq2tW3YTdv/0O
	 R0XfWbVqu2ae5A7TBWZwX3Fx6gocqehOwq+Un3Pa4yDRMD6IOTYkfnKpzEIl8J4jlD
	 poGOtMAkxtRcQ==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 05/10] vfio: Add dma map/unmap handlers
In-Reply-To: <aIZvElv03XftC2gw@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-5-aneesh.kumar@kernel.org>
 <aIZvElv03XftC2gw@google.com>
Date: Tue, 29 Jul 2025 10:33:12 +0530
Message-ID: <yq5ah5yvbncf.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Sun, May 25, 2025 at 01:19:11PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  include/kvm/vfio.h | 4 ++--
>>  vfio/core.c        | 7 +++++--
>>  vfio/legacy.c      | 7 +++++--
>>  3 files changed, 12 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
>> index 67a528f18d33..fed692b0f265 100644
>> --- a/include/kvm/vfio.h
>> +++ b/include/kvm/vfio.h
>> @@ -126,8 +126,8 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_=
region *region);
>>  int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
>>  void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev=
);
>>=20=20
>> -int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __=
u64 size);
>> -int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size);
>> +extern int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64=
 iova, __u64 size);
>> +extern int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 si=
ze);
>>=20=20
>>  struct kvm_mem_bank;
>>  int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void =
*data);
>> diff --git a/vfio/core.c b/vfio/core.c
>> index 2af30df3b2b9..32a8e0fe67c0 100644
>> --- a/vfio/core.c
>> +++ b/vfio/core.c
>> @@ -10,6 +10,9 @@ int kvm_vfio_device;
>>  LIST_HEAD(vfio_groups);
>>  struct vfio_device *vfio_devices;
>>=20=20
>> +int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64 iova, =
__u64 size);
>> +int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 size);
>
> I think it's better to  wrap those in an ops struct, this can be set once=
 and
> in the next patches this can be used for init/exit instead of having such=
 checks:
> =E2=80=9Cif (kvm->cfg.iommufd || kvm->cfg.iommufd_vdevice)=E2=80=9D
>

Sure. I=E2=80=99ll revise the patch to introduce the ops struct.

-aneesh

