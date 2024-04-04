Return-Path: <kvm+bounces-13566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E71A8988E9
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E3981C273E3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236BA128398;
	Thu,  4 Apr 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pFYYT5nb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448BA127B5D;
	Thu,  4 Apr 2024 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712237859; cv=none; b=Eq3O4xUWWsZUUaqHlPXG7/07QVA1nrsHHiEbqNQPkZAtOew9ygPP9A1nf00RlUmBiw2Za0SiAtOjZiG/zZNMel6ksOcg/P7EG9tctbXj/zKC0vjWJzFoIHdJkQohAiTz0SHJVbptYBkJcjS4xHbJDTPT6Zui9w2phflIva3M4lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712237859; c=relaxed/simple;
	bh=XJ/AMY2DWTceaUOcRP9f+7wePkVMTYDk/hfBtPXF6yI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvE+x2/2rN64dFvGtaYl8XvD4FqfnfY80ifMi0G3F3/Vxs5nXykFJFozirrCg3ZM6IVQ1rsVnCO8vo7puMpaIGeHo2+00pchZgDxSrzyboj1U2hVIO5XijHt3RQpV3nuUbEAakSL/pdMJvyF/YWh3znDMoxgLB8awD+RwxEhwz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pFYYT5nb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD93C433C7;
	Thu,  4 Apr 2024 13:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712237858;
	bh=XJ/AMY2DWTceaUOcRP9f+7wePkVMTYDk/hfBtPXF6yI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pFYYT5nbp8FMIPyNzhEyyj6RZ1rDRnBNN+g73m2yLVrsu8yGJu8Z8xOLNCilHUEyp
	 IACqH7U03WC+o4LYHHjJ+0ttHPgqBBThc8A7/yW9H5wGSNOxSDtKpO7Y78roBjVdrl
	 VxXvucr7gCQacH0Wx4xCxjYQTL7YcN1vMoNf67KxacPunKGfBIleXT+ompLTSE5boX
	 j7Iy7GHs1q9L/WSzlpWylb2R4zFRLUhnSKkeVNM5quiLDZQqAx5IUk2mQ0sstkcRf4
	 enbrSXQpyP5jNwTYjh+jaihQ43mMGQSXyVHHdzeZDB0HKiCFZ/6ccxCd1TfqVvged1
	 c9BkCskDH3uSQ==
Date: Thu, 4 Apr 2024 06:37:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: Jason Wang <jasowang@redhat.com>, Igor Raits <igor@gooddata.com>, Stefan
 Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org, Stefano Garzarella
 <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
Message-ID: <20240404063737.7b6e3843@kernel.org>
In-Reply-To: <CAK8fFZ6P6e+6V6NUkc-H5SdkXqgHdZ-GEMEPp4hKZSJVaGbBYQ@mail.gmail.com>
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
	<20240319131207.GB1096131@fedora>
	<CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
	<CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com>
	<CA+9S74g5fR=hBxWk1U2TyvW1uPmU3XgJnjw4Owov8LNwLiiOZw@mail.gmail.com>
	<CACGkMEt4MbyDgdqDGUqQ+0gV-1kmp6CWASDgwMpZnRU8dfPd2Q@mail.gmail.com>
	<CA+9S74hUt_aZCrgN3Yx9Y2OZtwHNan7gmbBa1TzBafW6=YLULQ@mail.gmail.com>
	<CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com>
	<CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com>
	<CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com>
	<CAK8fFZ6P6e+6V6NUkc-H5SdkXqgHdZ-GEMEPp4hKZSJVaGbBYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Apr 2024 07:42:45 +0200 Jaroslav Pulchart wrote:
> We do not have much progress

Random thought - do you have KFENCE enabled?
It's sufficiently low overhead to run in production and maybe it could
help catch the bug? You also hit some inexplicable bug in the Intel
driver, IIRC, there may be something odd going on.. (it's not all
happening on a single machine, right?)

