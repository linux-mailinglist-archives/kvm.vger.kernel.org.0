Return-Path: <kvm+bounces-52040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D662B003EE
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 272E73BF334
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F4426A0A6;
	Thu, 10 Jul 2025 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4Rpgmm/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27785267F5C;
	Thu, 10 Jul 2025 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154917; cv=none; b=NiMJf35DlW4KnJX3kjsm0SuM/kxddX4tX+d8qGqwaxOEHn3DCycEdvd9b+6RHu45RisQrq4jaHvj3jF79rZ1h8+M+0W03aRHnDvp0emysdbTAzBfCzy7qmzIcBADK9KjW36DNa22yJIDdxbu207+S7yE40sm/MJb9+3gMdyKCEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154917; c=relaxed/simple;
	bh=R3wYP0vZ7YSmBqpNoEZUZ3lDqGlCvdsW7hEuwVuKihQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fM4bdgvwZ3cdpQp9PCYwYTA5u6e39aF0hGDjstpGSnPyC2P7H7ydjmlcveIRrqUpL9tT7tVH6ZFvHmve+oF2BDXxJZRZUmTVW4FnEFkzmHi7cVj9CvQTmGbQdvhEIPxCfPneQnEPMZB3xpEMBJ+xI4tNSF2nZOFbbn4kTzZ52HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4Rpgmm/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9FBC4CEED;
	Thu, 10 Jul 2025 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752154916;
	bh=R3wYP0vZ7YSmBqpNoEZUZ3lDqGlCvdsW7hEuwVuKihQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4Rpgmm/twVfUpYQGZNjRzqk2ZZbkdYqa9MVPVVC56OHPtCAtG2ANZPnmZXqvwDgB
	 cWeWM7bGkQiqtr8ZDlXL8b8dHU55LwAWkrT826GrHv4J98NcCJXsfRFHkCfxSlN1WD
	 CjCs/ppOK4le0TF+O0CHucdjPy5QrG8ty28wPa/U=
Date: Thu, 10 Jul 2025 15:41:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Xinyu Zheng <zhengxinyu6@huawei.com>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
	stefanha@redhat.com, virtualization@lists.linux-foundation.org,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5.10] vhost-scsi: protect vq->log_used with vq->mutex
Message-ID: <2025071002-festive-outcast-7edd@gregkh>
References: <20250702082945.4164475-1-zhengxinyu6@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702082945.4164475-1-zhengxinyu6@huawei.com>

On Wed, Jul 02, 2025 at 08:29:45AM +0000, Xinyu Zheng wrote:
> From: Dongli Zhang <dongli.zhang@oracle.com>
> 
> [ Upstream commit f591cf9fce724e5075cc67488c43c6e39e8cbe27 ]
> 
> The vhost-scsi completion path may access vq->log_base when vq->log_used is
> already set to false.
> 
>     vhost-thread                       QEMU-thread
> 
> vhost_scsi_complete_cmd_work()
> -> vhost_add_used()
>    -> vhost_add_used_n()
>       if (unlikely(vq->log_used))
>                                       QEMU disables vq->log_used
>                                       via VHOST_SET_VRING_ADDR.
>                                       mutex_lock(&vq->mutex);
>                                       vq->log_used = false now!
>                                       mutex_unlock(&vq->mutex);
> 
> 				      QEMU gfree(vq->log_base)
>         log_used()
>         -> log_write(vq->log_base)
> 
> Assuming the VMM is QEMU. The vq->log_base is from QEMU userpace and can be
> reclaimed via gfree(). As a result, this causes invalid memory writes to
> QEMU userspace.
> 
> The control queue path has the same issue.
> 
> CVE-2025-38074

This is not needed.

> Cc: stable@vger.kernel.org#5.10.x

What about 5.15.y and 6.1.y?  We can't take a patch just for 5.10 as
that would cause regressions, right?

Please provide all relevant backports and I will be glad to queue them
up then.  I'll drop this from my queue for now, thanks.

greg k-h

