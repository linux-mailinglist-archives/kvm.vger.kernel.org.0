Return-Path: <kvm+bounces-23399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A467E949520
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D41DC1C2182B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4995B3FE55;
	Tue,  6 Aug 2024 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gs3WFVbb"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC183D967
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722960059; cv=none; b=TKGpxOxW1GkKah0pQ+2DiTQR6mQUwjnwmQTUcALMJPNVqVEruH1Jbg8R53FD+AfmaJuegZCcJelOHK255cTS+WTwqYnXViOaL9+JPqeliu7a+wAn0+QfvNbCjD8SMaAeedtcd038wnsTRwSBJFVrqZVVqe9ksGOpujGn1ub0wfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722960059; c=relaxed/simple;
	bh=MuSFzd2gz2MGU5lWXj5uAOg5Ekswq6739w5tTDuCQDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHoIQ6mFD+kpgOaDxovN3J9+7KwhTJZLhi+b7Z4C3g9+uDoTgbzDKCNK2iyc7V62Jc1NVlDKZp+NuD0n9SR5pI43km7BXgCFmat94Vo5sKu2lTdSJqH3Y3CjsnGVvRcbd87Ir9Gp2h0zDZrpv+fnfbUsjJ9vEekQklWRCJ+yge8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gs3WFVbb; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <91ac51ff-6bba-4a8b-93c1-e1534911faee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722960055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eDe/zCvoncz0vd6vk1ajyYGjxPA5a/HaUHlqKh5qrGM=;
	b=gs3WFVbbNUtuqucFRYq+J8MfA18n4BJkD7SDLEeSFAntr+lO9yHP9IYlbgekYzWlOevHzp
	W3p2cNCPrJ5+k3OB3nR7JvnBleT96rvqI/SubhDyfZV8S/5cVBLlCOZmnXzwgyR8b3KrQx
	Q1uAilhJ5xuLwVDneKO6erPRZ4MbkwE=
Date: Wed, 7 Aug 2024 00:00:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 05/19] KVM: arm64: vgic-debug: Use an xarray mark for
 debug iterator
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Eric Auger <eric.auger@redhat.com>,
 kvm@vger.kernel.org
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
 <20240422200158.2606761-6-oliver.upton@linux.dev>
 <d034a9b8-34ae-923e-8e68-09d2de3cf079@huawei.com>
 <178f30f7-edfd-78c5-f392-43cef1ef9baf@huawei.com>
 <3df0159d-efe8-f5fb-a99b-d53f1ed8058c@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <3df0159d-efe8-f5fb-a99b-d53f1ed8058c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/8/6 22:11, Zenghui Yu wrote:
> @@ -112,7 +113,7 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
>  	return iter->dist_id > 0 &&
>  		iter->vcpu_id == iter->nr_cpus &&
>  		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
> -		iter->lpi_idx > iter->nr_lpis;
> +		(iter->lpi_idx > iter->nr_lpis || !iter->nr_lpis);

And this should actually be written as:

iter->lpi_idx >= iter->nr_lpis

even in the first commit adding the LPI status in debugfs (e294cb3a6d1a)
if I understand it correctly. I will give it a bit more tests tomorrow..

