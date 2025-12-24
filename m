Return-Path: <kvm+bounces-66667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F25CDB331
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 03:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5999B302C4C5
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DE925783C;
	Wed, 24 Dec 2025 02:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="IdKoGFst"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967A21DD0D4
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 02:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766544645; cv=none; b=uKomWkzQKbm3N6Dc9glnFixh9PHWh7aLFH7/RFV1dnKgcjLkGf7J2JEGa+Yh75f2cgnmqOkOwNswun/QY5lEONPf7NmWgc/Z4pZlP3Z/iqr7sXHAgACUZyxWatMY1U1UzO6SxLZJTT+ei943hZKaZYVy+Kqn4iT2tsrJNQA4b7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766544645; c=relaxed/simple;
	bh=e5J9U2PBZTp+nSD5ggSqV6j/red+8U7sXfQFl+3BFFI=;
	h=Subject:Mime-Version:Content-Type:To:Message-Id:References:Cc:
	 From:Date:In-Reply-To; b=lyihpu8/Tx56/StJgo99+elicheTMJFQ0difj6fZVK5nhvPE80k4XyZNTpzoXsuloc3J2QVsDz5w6EEw0AwPHWnpmzVoNXRP6P6p/oYGlromHBwDYYZlpY9LPcLAWtlW0n680lJU1M8BEg3jC4F3ObOVmF3T5P3m1abQhLKN8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=IdKoGFst; arc=none smtp.client-ip=118.26.132.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766544636; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=XAeHn9rSAVJe+8IzICW1NXj8yb4Y0Pr455cExrwCfnA=;
 b=IdKoGFst8fW8KC/nYCjOkieCIYBhVzUKYyHhOmSPMk0Dla28+A+tCc9y5LpSe9J6LzEVvf
 zeW6+i7zAvDmjKpr91slCS9c927vc1LCHoXBl9hHZef42PjcVF9/prFqMu/1owBL38uwrv
 BLHgIMG3n6pQtd0UcaTVGf5jDjUoJVok2FgkXaXCeY4p9/m5IWntDxdLEw3gwf9j50W/sx
 bCHCtVJJ8QxhE/6bFWwM2vLVdxHb6/C/MnztkHodixsBpbw4vxUSYg2a3vK2+TkE3myf5w
 oNDrc8Hb7WxzcIZ1mcuXpGCyMznE7QjTViN1Lakhl72lB60xAY3nPQn7UvYBqA==
Subject: Re: [RESEND PATCH] vfio/pci: Skip hot reset on Link-Down
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <alex@shazbot.org>
Message-Id: <20251224025023.715-1-guojinhui.liam@bytedance.com>
References: <20251223153534.0968cc15.alex@shazbot.org>
Content-Transfer-Encoding: 7bit
Cc: <guojinhui.liam@bytedance.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Date: Wed, 24 Dec 2025 10:50:23 +0800
In-Reply-To: <20251223153534.0968cc15.alex@shazbot.org>
X-Mailer: git-send-email 2.17.1
X-Original-From: Jinhui Guo <guojinhui.liam@bytedance.com>
X-Lms-Return-Path: <lba+2694b54fa+c4d4ae+vger.kernel.org+guojinhui.liam@bytedance.com>

On Tue, 23 Dec 2025 15:35:34 -0700, Alex Williamson wrote:
> On Mon, 15 Dec 2025 20:30:29 +0800
> "Jinhui Guo" <guojinhui.liam@bytedance.com> wrote:
> 
> > On hot-pluggable ports, simultaneous surprise removal of multiple
> > PCIe endpoints whether by pulling the card, powering it off, or
> > dropping the link can trigger a system deadlock.
> 
> I think this only identifies one small aspect of the problems with
> surprise removal and vfio-pci.  It's not just the release path of the
> device that can trigger a reset, there are various user accessible
> paths as well, ex. the vfio reset and hot-reset ioctls.  I think those
> can trigger this same deadlock.
> 
> Beyond reset, CPU and DMA mappings to the device are still present after
> a surprise removal.  The latter can really only be revoked using the
> new dma-buf support for MMIO regions.
> 
> I think we should take a more comprehensive look at enabling vfio-pci to
> support surprise removal beyond this one case where a cooperative guest
> promptly released the device and encountered a deadlock.
> 
> In doing so, I think we're going to see several more cases where we
> should test for a disconnected device before reset, some of those may
> suggest that PCI-core is actually the better place for the test rather
> than the leaf caller.  Thanks,
> 
> Alex

Hi, Alex

Thank you for your time and helpful suggestions. I will follow up with
deeper research on adding surprise-removal support to vfio-pci.

Best Regards,
Jinhui

