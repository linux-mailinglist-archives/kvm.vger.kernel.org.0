Return-Path: <kvm+bounces-32140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 710909D3832
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 11:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2D54B293C5
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 10:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E4919E980;
	Wed, 20 Nov 2024 10:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B0mWPH6H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EA619C561
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 10:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732097658; cv=none; b=QcCWYVCXfZyUyGRs7/1iGiS/oCFX8uSWefo/97F3aAJB6dNMyyEBqJUaYRiqiSrBRsS6JOrFKIP1elEDAc947YnyE7DCrZAfl1pMxsmR6dryRP2D6bvCOEhP7PiS1W53Qxuic9HsaS5KIyqWaFvrmm0uC4HQ2Zegu3TDTfDI5nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732097658; c=relaxed/simple;
	bh=zQgyQ6rNld1w2hnJ6qmdnxM16RiQKDlHkw2A9ntziQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axkxJ+YXRVhARMqH+ukHPt5/vcs9oRW1Dswq5Q+btF0Dc8LbzaHqssyQqkjHsz5ycfMFp35trGmLXZIvXybqCdfnrYrLpzMlEmJyb7nEejIxCM+hUFjTTS+9ypBdmB5wT4pv3llQTDwhmUBnCiLu7s1A7O7ZHIBl0BJXpLj6Mys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B0mWPH6H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732097654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=av9p20SWAfgWwb8vDSscvDluM5JyD7bnVlvqWBtouv0=;
	b=B0mWPH6H10Q+YYmXpGdpuNjO+/T0R3YQqVZmXG2JnHFvJdgtKkLfEcOx/B78esYlIUfz+P
	2mcmE4pVGlZ/etWXpSMcgiV0u8monM0nDseHYwrbG1xcA0TmJFVjUURjPKuf6bedbStB0O
	d3Rj63ob6tO19u0T/7Zbebp/qT3g8f8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-2gTn_xmFMWW1-mAo5do5Ig-1; Wed,
 20 Nov 2024 05:14:09 -0500
X-MC-Unique: 2gTn_xmFMWW1-mAo5do5Ig-1
X-Mimecast-MFC-AGG-ID: 2gTn_xmFMWW1-mAo5do5Ig
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29FB91955D62;
	Wed, 20 Nov 2024 10:14:07 +0000 (UTC)
Received: from localhost (unknown [10.72.113.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51DC019560A3;
	Wed, 20 Nov 2024 10:14:04 +0000 (UTC)
Date: Wed, 20 Nov 2024 18:13:58 +0800
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
Subject: Re: [PATCH v1 07/11] fs/proc/vmcore: introduce
 PROC_VMCORE_DEVICE_RAM to detect device RAM ranges in 2nd kernel
Message-ID: <Zz22ZidsMqkafYeg@MiWiFi-R3L-srv>
References: <20241025151134.1275575-1-david@redhat.com>
 <20241025151134.1275575-8-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025151134.1275575-8-david@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 10/25/24 at 05:11pm, David Hildenbrand wrote:
> s390 allocates+prepares the elfcore hdr in the dump (2nd) kernel, not in
> the crashed kernel.
> 
> RAM provided by memory devices such as virtio-mem can only be detected
> using the device driver; when vmcore_init() is called, these device
> drivers are usually not loaded yet, or the devices did not get probed
> yet. Consequently, on s390 these RAM ranges will not be included in
> the crash dump, which makes the dump partially corrupt and is
> unfortunate.
> 
> Instead of deferring the vmcore_init() call, to an (unclear?) later point,
> let's reuse the vmcore_cb infrastructure to obtain device RAM ranges as
> the device drivers probe the device and get access to this information.
> 
> Then, we'll add these ranges to the vmcore, adding more PT_LOAD
> entries and updating the offsets+vmcore size.
> 
> Use Kconfig tricks to include this code automatically only if (a) there is
> a device driver compiled that implements the callback
> (PROVIDE_PROC_VMCORE_DEVICE_RAM) and; (b) the architecture actually needs
> this information (NEED_PROC_VMCORE_DEVICE_RAM).
> 
> The current target use case is s390, which only creates an elf64
> elfcore, so focusing on elf64 is sufficient.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  fs/proc/Kconfig            |  25 ++++++
>  fs/proc/vmcore.c           | 156 +++++++++++++++++++++++++++++++++++++
>  include/linux/crash_dump.h |   9 +++
>  3 files changed, 190 insertions(+)
> 
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index d80a1431ef7b..1e11de5f9380 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -61,6 +61,31 @@ config PROC_VMCORE_DEVICE_DUMP
>  	  as ELF notes to /proc/vmcore. You can still disable device
>  	  dump using the kernel command line option 'novmcoredd'.
>  
> +config PROVIDE_PROC_VMCORE_DEVICE_RAM
> +	def_bool n
> +
> +config NEED_PROC_VMCORE_DEVICE_RAM
> +	def_bool n
> +
> +config PROC_VMCORE_DEVICE_RAM
> +	def_bool y
> +	depends on PROC_VMCORE
> +	depends on NEED_PROC_VMCORE_DEVICE_RAM
> +	depends on PROVIDE_PROC_VMCORE_DEVICE_RAM

Kconfig item is always a thing I need learn to master. When I checked
this part, I have to write them down to deliberate. I am wondering if 
below 'simple version' works too and more understandable. Please help
point out what I have missed.

===========simple version======
config PROC_VMCORE_DEVICE_RAM
        def_bool y
        depends on PROC_VMCORE && VIRTIO_MEM
        depends on NEED_PROC_VMCORE_DEVICE_RAM

config S390
        select NEED_PROC_VMCORE_DEVICE_RAM
============


======= config items extracted from this patchset====
config PROVIDE_PROC_VMCORE_DEVICE_RAM
        def_bool n

config NEED_PROC_VMCORE_DEVICE_RAM
        def_bool n

config PROC_VMCORE_DEVICE_RAM
        def_bool y
        depends on PROC_VMCORE
        depends on NEED_PROC_VMCORE_DEVICE_RAM
        depends on PROVIDE_PROC_VMCORE_DEVICE_RAM

config VIRTIO_MEM
	depends on X86_64 || ARM64 || RISCV
         ~~~~~ I don't get why VIRTIO_MEM dones't depend on S390 if
               s390 need PROC_VMCORE_DEVICE_RAM. 
        ......
        select PROVIDE_PROC_VMCORE_DEVICE_RAM if PROC_VMCORE

config S390
        select NEED_PROC_VMCORE_DEVICE_RAM if PROC_VMCORE
=================================================


