Return-Path: <kvm+bounces-31991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCABE9D0366
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 13:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A2391F23297
	for <lists+kvm@lfdr.de>; Sun, 17 Nov 2024 12:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3963B1885BF;
	Sun, 17 Nov 2024 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="NB4RgANg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72E514A617;
	Sun, 17 Nov 2024 12:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731845063; cv=none; b=Lc10JFp5A+T0hzJ0USfnET4xRKCeHAOd2eCPl1wURfo/hFaaLlnCy/+zvqUmd8+hoBt2V+CPqmqUdtpgIzniSlAvNSZXVgqe9/uUnHBPYiN+ThkyvFWW0KKqtPecymfSpePkRqUokLcC16kzLBPhDJj9RNwt7XftaRNl7Q+jRGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731845063; c=relaxed/simple;
	bh=mO4Mmat2cwJJIXfC/T9tygSyJo4FAhAoeoiCT5IPM3w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uA57L6jqqHPwLOQbgVzxiH4vs2iAwPubYxaYH5m4LvYZsd9Ugi8hGJ5a7UW5YSCOccbnOidth9JJ7OrfY3VPBOJRapospm5Uwk5BvLuMYnoC0yay47yW/GZj8pETMcb5XH5IaUYs+jE+NAOB08FjWOi6D/50xy/XRiFxWwzeJwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=NB4RgANg; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1731845055;
	bh=ZjP95IJGwmeLHgHQzxXL+JxzJejZMHgkGif9iRHizLk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=NB4RgANg1E582fTLRZTFf1d/OmbfljMvX5BWOnX2VH6LC6sVQbfbOdqLFSzJOzCd9
	 RSrUQYQZFdnEVLERVCpwUrbdk12XQtkk/XQMrg4OtYUWu4R9RfbfznBygC1qohu3Qh
	 SnPchaAiYjGFjPMM2i9y5MhKEXsFRfIcTBSW9biurEb5KNhhl8Gb0MFUl2jfWFWSs8
	 a2AK3HyD73H5N8SgmH7dUi8EHOBlh68g0d5aXyWGSxG3dQAAx1NgChyhnzPzTVQjwn
	 Nu7RVpkEkGHmQu8pTHH/iO+eUdGnLK5QZQxXtbDqX7mQiEHF+NVkm0hi0kjdqgOD70
	 l/AJFlE20QlOw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XrqDb1yprz4xcw;
	Sun, 17 Nov 2024 23:04:15 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Amit Machhiwal <amachhiw@linux.ibm.com>
Cc: kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Vaibhav Jain <vaibhav@linux.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20241028101622.741573-1-amachhiw@linux.ibm.com>
References: <20241028101622.741573-1-amachhiw@linux.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Add Power11 capability support for Nested PAPR guests
Message-Id: <173184457525.887714.6106755723297073390.b4-ty@ellerman.id.au>
Date: Sun, 17 Nov 2024 22:56:15 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 28 Oct 2024 15:46:22 +0530, Amit Machhiwal wrote:
> The Power11 architected and raw mode support in Linux was merged via [1]
> and the corresponding support in QEMU is pending in [2], which is
> currently in its V6.
> 
> Currently, booting a KVM guest inside a pseries LPAR (Logical Partition)
> on a kernel without [1] results the guest boot in a Power10
> compatibility mode (i.e., with logical PVR of Power10). However, booting
> a KVM guest on a kernel with [1] causes the following boot crash.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Add Power11 capability support for Nested PAPR guests
      https://git.kernel.org/powerpc/c/96e266e3bcd6ed03f0be62c2fcf92bf1e3dc8a6a

cheers

