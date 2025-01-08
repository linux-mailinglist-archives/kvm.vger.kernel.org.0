Return-Path: <kvm+bounces-34770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CF1A05AF9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 13:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D61483A2A10
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 12:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988961F8F17;
	Wed,  8 Jan 2025 12:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/6/g6AX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E751A23A7
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736337874; cv=none; b=LxU7vroTc9B/VTl7ubZMPXO+C3B4HPN+nbnSjs0k1OfpB49I7Qc7MQShf/byNVvccdpdS2DFJe0auO2iBG/IkXADd/dhqmxWS9CbxqcSYSn9rwbOiV7+EcJjsQGDsJaFJ3gSKO5hNP03u7XQm1fS5VPL7jHusxEGe5Jlygkmk2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736337874; c=relaxed/simple;
	bh=113mJZlj7lrmpmGDuKQWu73sMEvYBfWYxx3E+OaCMQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POgLAUzXzBy1PityPr6CC6PABNbTmdg7A05i1TjtKyqyi8XGYDRdA4PgImj1+twMxXAqicf+CvLkgJJBD10ooAHQt29TzAgNKFhRghUelC8IbImHaTRvqRvyR4J6xMidUVZcrT5Gn+NwFxTufhER3XSi1v7C1gY9vYbtkTift5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/6/g6AX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736337872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=erQix5YBM/Y/uEtirG3GeKXgXkkPiaihYorhESefFJA=;
	b=Z/6/g6AX54ptMQMDmjIQK3YqN1Nz7W5o30nePrqHSICVzUaKtGQv6ISoP1Drxnr0+EUwDj
	7/0Qd7mo2nlBDHfNqc0a+n6VLKQNl73MmFakEarrH+z5b2EnSnFhUtlbSdBVr09bQHktV3
	KX8OJ5aF+5El25kB9EbN2QW13DFgQq8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-YJ-Y66GfOLuGLhFKR-IR8Q-1; Wed, 08 Jan 2025 07:04:30 -0500
X-MC-Unique: YJ-Y66GfOLuGLhFKR-IR8Q-1
X-Mimecast-MFC-AGG-ID: YJ-Y66GfOLuGLhFKR-IR8Q
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436328fcfeeso120671095e9.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 04:04:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736337870; x=1736942670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=erQix5YBM/Y/uEtirG3GeKXgXkkPiaihYorhESefFJA=;
        b=WE7RQidJinTbLdwND0Qx54JdvSfISHfxQfIIoa5ubRAUGWAC9axhX3/vBpL3d+Vnj9
         hUOwKOP4pkoIrXkHeBbUqTXZ76OMmxpUst4ZzUcHuAJIglyuTA9yr1QTJSrgQ3dLrXD2
         xr0HMgF9ZrvD8H1lWXGofqpHJMSu8F/PsYx4v5RfRbApkZzoKxoiR/PEdnp85IqOh5e/
         Lj5Taq0T4vjeQggoDp5BUJbyso2vk43rQCoelTW3XBdTrjKhuooCztqULpk1PL96hbee
         OcqaMfTdPa93whz8v9qbglPSEbWzRtRo8FHPH1by/tav97Zt9YnV8k/0MVYdr1kwWwzK
         Pmng==
X-Forwarded-Encrypted: i=1; AJvYcCVLKWWj5KSWEuGpQPyVcXPwWy+OnFEERngsX23IEYu10n73g4M1in9G7lJEvNbEi47z78Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQEIxmgHrfpgHHNrejIYksa593i6jvrVBhvKsHrBlNzOh3lbXP
	dMsg3CwwjumPVSGTBZGRvT4iHjeyAQD3yn1vnDKER7U/dytJtouwNi8qtaNX6bRzvluVqROhP0k
	/x/MMFohx9t6owDjdFe1m994hPxG/cK2YsTLxt7sQhLKWH1dQyQ==
X-Gm-Gg: ASbGncvumLbQe6UAE56kqQIDfGNDlHWcGSOoTfY2e7MMeTuQmAs7bYBPvqu5ogniNza
	/7Pgaqwmf3OaoNoyC3ObDpo9mFZCEqrKgA8lOPBaShRiUAV8ikLjhKI75ul6rJEJJFh9JWN3v7o
	0cgL8xEmMpkus80QgroTNy9rbi86/statbKki5xqPYrOSrgdjhQ4Mee33tBDdV4rr6JycUin7KO
	hwCDPBRi1bHDyTPcH30fkLSGq0BwqD8OmWfBXTo8zKlMLTRfdk=
X-Received: by 2002:a05:600c:5251:b0:434:f4f9:8104 with SMTP id 5b1f17b1804b1-436e2700050mr18200075e9.33.1736337869673;
        Wed, 08 Jan 2025 04:04:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUR05pl8seK2xsW/qB5D6saVHw6QWnqhWJEnho0PIwlVj0Pr14aAjP/a/iJR8rsa6d05BmGw==
X-Received: by 2002:a05:600c:5251:b0:434:f4f9:8104 with SMTP id 5b1f17b1804b1-436e2700050mr18199815e9.33.1736337869281;
        Wed, 08 Jan 2025 04:04:29 -0800 (PST)
Received: from redhat.com ([2a02:14f:175:d62d:93ef:d7e2:e7da:ed72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e8bea5sm18342805e9.31.2025.01.08.04.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 04:04:28 -0800 (PST)
Date: Wed, 8 Jan 2025 07:04:23 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kexec@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 00/12] fs/proc/vmcore: kdump support for virtio-mem on
 s390
Message-ID: <20250108070407-mutt-send-email-mst@kernel.org>
References: <20241204125444.1734652-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241204125444.1734652-1-david@redhat.com>

On Wed, Dec 04, 2024 at 01:54:31PM +0100, David Hildenbrand wrote:
> The only "different than everything else" thing about virtio-mem on s390
> is kdump: The crash (2nd) kernel allocates+prepares the elfcore hdr
> during fs_init()->vmcore_init()->elfcorehdr_alloc(). Consequently, the
> kdump kernel must detect memory ranges of the crashed kernel to
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
> My testing when creating+analyzing crash dumps with hotplugged virtio-mem
> memory (incl. holes) did not reveal any surprises.
> 
> Patch #1 -- #7 are vmcore preparations and cleanups
> Patch #8 adds the infrastructure for drivers to report device RAM
> Patch #9 + #10 are virtio-mem preparations
> Patch #11 implements virtio-mem support to report device RAM
> Patch #12 activates it for s390, implementing a new function to fill
>           PT_LOAD entry for device RAM

Who is merging this?
virtio parts:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> v1 -> v2:
> * "fs/proc/vmcore: convert vmcore_cb_lock into vmcore_mutex"
>  -> Extend patch description
> * "fs/proc/vmcore: replace vmcoredd_mutex by vmcore_mutex"
>  -> Extend patch description
> * "fs/proc/vmcore: disallow vmcore modifications while the vmcore is open"
>  -> Disallow modifications only if it is currently open, but warn if it
>     was already open and got closed again.
>  -> Track vmcore_open vs. vmcore_opened
>  -> Extend patch description
> * "fs/proc/vmcore: prefix all pr_* with "vmcore:""
>  -> Added
> * "fs/proc/vmcore: move vmcore definitions out if kcore.h"
>  -> Call it "vmcore_range"
>  -> Place vmcoredd_node into vmcore.c
>  -> Adjust patch subject + description
> * "fs/proc/vmcore: factor out allocating a vmcore range and adding it to a
>    list"
>  -> Adjust to "vmcore_range"
> * "fs/proc/vmcore: factor out freeing a list of vmcore ranges"
>  -> Adjust to "vmcore_range"
> * "fs/proc/vmcore: introduce PROC_VMCORE_DEVICE_RAM to detect device RAM
>    ranges in 2nd kernel"
>  -> Drop PROVIDE_PROC_VMCORE_DEVICE_RAM for now
>  -> Simplify Kconfig a bit
>  -> Drop "Kdump:" from warnings/errors
>  -> Perform Elf64 check first
>  -> Add regions also if the vmcore was opened, but got closed again. But
>     warn in any case, because it is unexpected.
>  -> Adjust patch description
> * "virtio-mem: support CONFIG_PROC_VMCORE_DEVICE_RAM"
>  -> "depends on VIRTIO_MEM" for PROC_VMCORE_DEVICE_RAM
> 
> 
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: "Eugenio Pérez" <eperezma@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> David Hildenbrand (12):
>   fs/proc/vmcore: convert vmcore_cb_lock into vmcore_mutex
>   fs/proc/vmcore: replace vmcoredd_mutex by vmcore_mutex
>   fs/proc/vmcore: disallow vmcore modifications while the vmcore is open
>   fs/proc/vmcore: prefix all pr_* with "vmcore:"
>   fs/proc/vmcore: move vmcore definitions out of kcore.h
>   fs/proc/vmcore: factor out allocating a vmcore range and adding it to
>     a list
>   fs/proc/vmcore: factor out freeing a list of vmcore ranges
>   fs/proc/vmcore: introduce PROC_VMCORE_DEVICE_RAM to detect device RAM
>     ranges in 2nd kernel
>   virtio-mem: mark device ready before registering callbacks in kdump
>     mode
>   virtio-mem: remember usable region size
>   virtio-mem: support CONFIG_PROC_VMCORE_DEVICE_RAM
>   s390/kdump: virtio-mem kdump support (CONFIG_PROC_VMCORE_DEVICE_RAM)
> 
>  arch/s390/Kconfig             |   1 +
>  arch/s390/kernel/crash_dump.c |  39 ++++-
>  drivers/virtio/virtio_mem.c   | 103 ++++++++++++-
>  fs/proc/Kconfig               |  19 +++
>  fs/proc/vmcore.c              | 283 ++++++++++++++++++++++++++--------
>  include/linux/crash_dump.h    |  41 +++++
>  include/linux/kcore.h         |  13 --
>  7 files changed, 407 insertions(+), 92 deletions(-)
> 
> 
> base-commit: feffde684ac29a3b7aec82d2df850fbdbdee55e4
> -- 
> 2.47.1


