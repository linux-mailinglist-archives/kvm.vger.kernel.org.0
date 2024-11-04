Return-Path: <kvm+bounces-30439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4C89BAC74
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 159E3281F00
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB4418C351;
	Mon,  4 Nov 2024 06:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OzdG9/bV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90891E552
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730701282; cv=none; b=temQL5KdGZe1GtXVc+kcPlnlkVa7hQnZsTO2yzM8BVMOlyqSWSEnEAbW1iZoEX2XqhEl2hc2dsGzpIOcIe+VlrI0Q68NCtXPhOOm42iP6SqFcKGlWLacgLNLGcLyO7V412LmdXe6/2qyoJ3Qd/ewVGqk26/F+ULg/1jRXzx8tYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730701282; c=relaxed/simple;
	bh=lDpSsq7UijUNAks9mue3LanPLcT5oA2uO4ieCjRuamc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTLlZiYeBpj1RkgfosJEMxxQsWTulDjqzDfHlQjSd8u7rL92RxqeH/N37C16+/ZtPTElQdiVJHOgzMdtmYhmVQ1ePJQhklvnLdpsIiybQYYawsDM3lFTASRAQtbXJL6P/A3HZYK2/PQA7ADCXcshP6h7/1C5C3tYqZ2KaAwhFHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OzdG9/bV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730701279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Yt6e01JiHs6xDUFc4KUXQd8i1elq2u0nXKuucFyQGQ=;
	b=OzdG9/bV+LSBHOtUrflneOfFBYwqFzLuBiHU7HKZGYdNHSwGJcItWNZOjmLvDSQsICeZzh
	qxkXM0ucCCQU95aGZgsx7InuvZIiDM9XPEcAZ40o+Nkx8Tlxm8SsRXxL71ZdV9XPmSlpal
	CiPbIIXQq4xq+Mhi1xquLk3pf6Zmb4w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-b2Wj_TLPNE6Ox6N8IQMnvg-1; Mon,
 04 Nov 2024 01:21:16 -0500
X-MC-Unique: b2Wj_TLPNE6Ox6N8IQMnvg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A026619560B4;
	Mon,  4 Nov 2024 06:21:13 +0000 (UTC)
Received: from localhost (unknown [10.72.112.78])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA7C11956052;
	Mon,  4 Nov 2024 06:21:10 +0000 (UTC)
Date: Mon, 4 Nov 2024 14:21:06 +0800
From: Baoquan He <bhe@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kexec@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 00/11] fs/proc/vmcore: kdump support for virtio-mem on
 s390
Message-ID: <Zyhn0oz+ze0xY2AR@MiWiFi-R3L-srv>
References: <20241025151134.1275575-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025151134.1275575-1-david@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 10/25/24 at 05:11pm, David Hildenbrand wrote:
> This is based on "[PATCH v3 0/7] virtio-mem: s390 support" [1], which adds
> virtio-mem support on s390.
> 
> The only "different than everything else" thing about virtio-mem on s390
> is kdump: The crash (2nd) kernel allocates+prepares the elfcore hdr
> during fs_init()->vmcore_init()->elfcorehdr_alloc(). Consequently, the
> crash kernel must detect memory ranges of the crashed/panicked kernel to
> include via PT_LOAD in the vmcore.
> 
> On other architectures, all RAM regions (boot + hotplugged) can easily be
> observed on the old (to crash) kernel (e.g., using /proc/iomem) to create
> the elfcore hdr.
> 
> On s390, information about "ordinary" memory (heh, "storage") can be
> obtained by querying the hypervisor/ultravisor via SCLP/diag260, and
> that information is stored early during boot in the "physmem" memblock
> data structure.
> 
> But virtio-mem memory is always detected by as device driver, which is
> usually build as a module. So in the crash kernel, this memory can only be
> properly detected once the virtio-mem driver started up.
> 
> The virtio-mem driver already supports the "kdump mode", where it won't
> hotplug any memory but instead queries the device to implement the
> pfn_is_ram() callback, to avoid reading unplugged memory holes when reading
> the vmcore.
> 
> With this series, if the virtio-mem driver is included in the kdump
> initrd -- which dracut already takes care of under Fedora/RHEL -- it will
> now detect the device RAM ranges on s390 once it probes the devices, to add
> them to the vmcore using the same callback mechanism we already have for
> pfn_is_ram().
> 
> To add these device RAM ranges to the vmcore ("patch the vmcore"), we will
> add new PT_LOAD entries that describe these memory ranges, and update
> all offsets vmcore size so it is all consistent.
> 
> Note that makedumfile is shaky with v6.12-rcX, I made the "obvious" things
> (e.g., free page detection) work again while testing as documented in [2].
> 
> Creating the dumps using makedumpfile seems to work fine, and the
> dump regions (PT_LOAD) are as expected. I yet have to check in more detail
> if the created dumps are good (IOW, the right memory was dumped, but it
> looks like makedumpfile reads the right memory when interpreting the
> kernel data structures, which is promising).
> 
> Patch #1 -- #6 are vmcore preparations and cleanups

Thanks for CC-ing me, I will review the patch 1-6, vmcore part next
week.


