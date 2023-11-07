Return-Path: <kvm+bounces-868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 260447E3AC7
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFBC6B20C1D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 11:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CCE2D05A;
	Tue,  7 Nov 2023 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7j5GpFs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5F12D039
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 11:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A274AC433C7;
	Tue,  7 Nov 2023 11:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699355343;
	bh=B9djLOgzbLHtAye+WL69/suJmB3RyX0AdrJPBdZI8Eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L7j5GpFsx8fnY8wNDHcYCWXQi+Na+jaOB5KrVLCRGp4e/whbdwyUE7H8G1qiJOyns
	 dGSVjTNldvTRCPnrGehZNPWLqWSZGsRFeidqN7M7Ybl//Ps61AOGRUyDQi20RxUM5H
	 mbz/ITsbcuOs9BBZ7DYulYF4YpQUv7d//dXrb3zeO6yO2adTE4/48ZGXUk1eO5zV7v
	 TODamxmW1DxatiD/iLTv6kS37OTwg2SzLrairGVaEsOL7rS9kr5WPNSyWtpPUNifyz
	 I6axdw0QWQlazwoSmy2nxdSJcGJxXyetAKT12tviMAJNmDi+DCiQ3YSF9ImHsuiB12
	 x2s39YzOwKUjQ==
Date: Tue, 7 Nov 2023 11:08:59 +0000
From: Will Deacon <will@kernel.org>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Eduardo Bart <edub4rt@gmail.com>, kvm@vger.kernel.org,
	alex@mikhalevich.com
Subject: Re: [PATCH kvmtool] virtio: Cancel and join threads when exiting
 devices
Message-ID: <20231107110858.GA19219@willie-the-truck>
References: <CABqCASLWAZ5aq27GuQftWsXSf7yLFCKwrJxWMUF-fiV7Bc4LUA@mail.gmail.com>
 <20231016115259.GA835650@myrica>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016115259.GA835650@myrica>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Oct 16, 2023 at 12:52:59PM +0100, Jean-Philippe Brucker wrote:
> On Wed, Oct 04, 2023 at 05:49:45PM -0300, Eduardo Bart wrote:
> > I'm experiencing a segmentation fault in lkvm where it may crash after
> > powering off a guest machine that uses a virtio network device.
> > The crash is hard to reproduce, because looks like it only happens
> > when the guest machine is powering off while extra virtio threads is
> > doing some work,
> > when it happens lkvm crashes in the function virtio_net_rx_thread
> > while attempting to read invalid guest physical memory,
> > because guest physical memory was unmapped.
> > 
> > I've isolated the problem and looks like when lkvm exits it unmaps the
> > guest memory while virtio device extra threads may still be executing.
> > I noticed most virtio devices are not executing pthread_cancel +
> > pthread_join to synchronize extra threads when exiting,
> > to make sure this happens I added explicit calls to the virtio device
> > exit function to all virtio devices,
> > which should cancel and join all threads before unmapping guest
> > physical memory, fixing the crash for me.
> > 
> > Below I'm attaching a patch to fix the issue, feel free to apply or
> > fix the issue some other way.
> > 
> > Signed-off-by: Eduardo Bart <edub4rt@gmail.com>
> 
> The patch doesn't apply for some reason, there seems to be whitespace
> issues, tabs replaced by spaces.

Eduardo -- please can you send a properly formatted patch addressing
Jean-Philippe's comments so that I can apply it?

Thanks,

Will

