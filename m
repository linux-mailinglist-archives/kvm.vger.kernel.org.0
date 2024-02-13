Return-Path: <kvm+bounces-8624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 018978533BB
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 15:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33EDC1C21D28
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 14:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098035F563;
	Tue, 13 Feb 2024 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js+XN5kI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089BF57873;
	Tue, 13 Feb 2024 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707836071; cv=none; b=jZMhjCXDqm18DnokOqFjW0esCJyM2UEKW2oihwIBiQMqvfqlzCGyLzsox9BLtAAseI7ktplfx0/X+hMuF/x3qDsDTQfFDiasRtPu8JMNASkj4PTPWINfCY1MyvrSYSH4w/DOApYz94dy5J8bG4VTynqcCWmu55fssTd96mTXw4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707836071; c=relaxed/simple;
	bh=G4LX9kvo4BgwHGeUq7JLs9/XHpEGSlotttquVOhu24o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nsnH/kVzFjcRqgVC09THc0CZ9vLZDDk2FI7qmIzkbmp2wWyOYHpntxJjXFtlyXQVdG+/piHVfjz4etM73yfT6N7KrxL6QOaTYTzsESodd3WmcBImoVMQnCavDvs7/aFsOXscXm+Xrm7SK4tr1vcCcLaqfHp2NH1vGEX6/RkUOWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js+XN5kI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05104C43399;
	Tue, 13 Feb 2024 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707836070;
	bh=G4LX9kvo4BgwHGeUq7JLs9/XHpEGSlotttquVOhu24o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=js+XN5kIZ2oj49KFq7EeQPD3BbeGrnnYa+LVtQvb+QaepYq6jIdyLRR7/tlQIf3W2
	 1Ij4Nqv8Ks33RuRMDmxroWfMDoOv1XgKZvCRhiDx3DeRtr6+djHMeQfUT69sVtE3nM
	 9VNTEtTUQjJIi1kgpqzOHU1uvkIOwDX/lr2NhCM8=
Date: Tue, 13 Feb 2024 15:54:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: stable@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexey.makhalov@broadcom.com, vasavi.sirnapalli@broadcom.com,
	Prathu Baronia <prathubaronia2011@gmail.com>
Subject: Re: [PATCH v6.1.y-v4.19.y] vhost: use kzalloc() instead of kmalloc()
 followed by memset()
Message-ID: <2024021348-always-splendid-c1f8@gregkh>
References: <1707110377-1483-1-git-send-email-ajay.kaher@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1707110377-1483-1-git-send-email-ajay.kaher@broadcom.com>

On Mon, Feb 05, 2024 at 10:49:37AM +0530, Ajay Kaher wrote:
> From: Prathu Baronia <prathubaronia2011@gmail.com>
> 
> From: Prathu Baronia <prathubaronia2011@gmail.com>
> 
> commit 4d8df0f5f79f747d75a7d356d9b9ea40a4e4c8a9 upstream
> 
> Use kzalloc() to allocate new zeroed out msg node instead of
> memsetting a node allocated with kmalloc().
> 
> Signed-off-by: Prathu Baronia <prathubaronia2011@gmail.com>
> Message-Id: <20230522085019.42914-1-prathubaronia2011@gmail.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> [Ajay: This is a security fix as per CVE-2024-0340]

And this is why I am so grumpy about Red Hat and CVEs, they know how to
let us know about stuff like this, but no.  Hopefully, someday soon,
they will soon not be allowed to do this anymore.

{sigh}

Now queued up, thanks.

greg k-h

