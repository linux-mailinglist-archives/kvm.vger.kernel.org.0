Return-Path: <kvm+bounces-23470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DFC949F18
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AC341C21607
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 05:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8E1191478;
	Wed,  7 Aug 2024 05:23:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7A02F5A
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 05:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723008210; cv=none; b=pjd0yq88N7HiSWACxSJwufpd6kM7xz0QitCsKnH+toTMONmJ+oZyMbuFPpfJ7MWRlVutpA1kGGEDDGraqqCXkyI8UmP9lRzwjYYBu71rXaSSI4fc/gvvsb0h5SwEgl9UHJ0Z8R0v3u2h7V0wZ8HH5RZmaJE+Hn/nOFKqrMJT4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723008210; c=relaxed/simple;
	bh=EIFWFWEFG68e6vprMLTjH7p6Sjmf4YNBus6ifj9YJtU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Xlt/gpJUJHtG3PiaKO3+mcyu9fc0bsZ5xOwtjdyd+uDQg3CjMkL6L2C9WWnHEKYnUiOn3gObuWzxJ03N+1ncg5mM7LQRUdmlUav6uukqMi1A7G9RzAFJVSFmjU+2eK7jrW+TXNYpjVKtfpHxDiUHV6y+VzRclMFUiMYA3ZG8SYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wdz9267BBzcdSm;
	Wed,  7 Aug 2024 13:23:18 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id D34FE180101;
	Wed,  7 Aug 2024 13:23:25 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 7 Aug 2024 13:23:24 +0800
Subject: Re: [PATCH v3 05/19] KVM: arm64: vgic-debug: Use an xarray mark for
 debug iterator
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, <kvmarm@lists.linux.dev>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Eric
 Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
 <20240422200158.2606761-6-oliver.upton@linux.dev>
 <d034a9b8-34ae-923e-8e68-09d2de3cf079@huawei.com>
 <178f30f7-edfd-78c5-f392-43cef1ef9baf@huawei.com>
 <3df0159d-efe8-f5fb-a99b-d53f1ed8058c@huawei.com>
 <91ac51ff-6bba-4a8b-93c1-e1534911faee@linux.dev>
 <86h6bx39m0.wl-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4794ce2f-dc60-ca10-44f4-cdff27e2cbc0@huawei.com>
Date: Wed, 7 Aug 2024 13:23:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <86h6bx39m0.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/8/7 0:21, Marc Zyngier wrote:
> On Tue, 06 Aug 2024 17:00:44 +0100,
> Zenghui Yu <zenghui.yu@linux.dev> wrote:
> >
> > On 2024/8/6 22:11, Zenghui Yu wrote:
> > > @@ -112,7 +113,7 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
> > >  	return iter->dist_id > 0 &&
> > >  		iter->vcpu_id == iter->nr_cpus &&
> > >  		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
> > > -		iter->lpi_idx > iter->nr_lpis;
> > > +		(iter->lpi_idx > iter->nr_lpis || !iter->nr_lpis);
> >
> > And this should actually be written as:
> >
> > iter->lpi_idx >= iter->nr_lpis
> >
> > even in the first commit adding the LPI status in debugfs (e294cb3a6d1a)
> > if I understand it correctly. I will give it a bit more tests tomorrow..
> 
> Yup, this looks like a long-standing bug (/me pleads guilty).
> 
> Maybe worth fixing them independently in order to facilitate the
> inevitable backports?

I'm sorry that I misread the code again (shouldn't have sent spam late
at night :-( ).

Consider the last LPI:

|vgic_debug_next() {
|	iter_next()		// get the last valid LPI intid
|	end_of_vgic()		// lpi_idx == nr_lpis
|}

We need to go ahead to print this LPI's state and go through one more
vgic_debug_next() to exit the iterator. So there's no problem in the
current implementation for LPI, it's just that the code is a bit hard to
follow.

I've sent the "easiest approach" [*] out now.

Thanks,
Zenghui

[*] 
https://lore.kernel.org/kvmarm/20240807052024.2084-1-yuzenghui@huawei.com

