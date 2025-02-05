Return-Path: <kvm+bounces-37375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE0FA29832
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61D9B3A294D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44151FC0F4;
	Wed,  5 Feb 2025 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBhbfydL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD8A1519AD
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778337; cv=none; b=p1sWne1OOqJsXoATxArl/SapWyWY79PGibHF80cIMLqC8czMIyNM9EdXtvFsl4lh87zLEmTifi9l7qIkLuwlaEdNZI4txPHl1Yg/wmiH1FR0NdQcHU13wQqFpdG1/Ogh+pY/Un/IexUc8eL9+OrVshB1deTu/Jp23HIpwWyDigk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778337; c=relaxed/simple;
	bh=eTmoRU2cR+lb8O0cTSSpNG+hNS9FlxsuqZkUF/fV4Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3FC594syY7moe3l46TEAfyLEWvXI/Zpary7v3UPgCYEu6on/yVNhaHssiF7mvNkck28abfW4Y0IxU1WWxWUn1wHbFpA8t0MGdwMd6jLA2R9nelHFw84nRouR+t9rDH6CJlv2ky+f32V9CngylG8NVbHqrci1pHGNRSjnLAG9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cBhbfydL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738778334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=75ymu4jpHyhbMjYieQ84OtAI2riBguf24EUxH7ex6f0=;
	b=cBhbfydL1mZLbqnyivdDtgVQH/b1EGRG9o18rYnI6xixAtaTKL3/80DhcA1r9sQGcHo14p
	03ohJq1MnW3+gT41RyuhbilTxBXIUsiljWHNIENQzuiOFDIdgWVoeJBcFyX2X7MfDJoURi
	mio2oPT7YU6U8ivJq7DTM7dEirEZM9Y=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-d8TcxbcjPnGbF9Ic22Rbgg-1; Wed, 05 Feb 2025 12:58:53 -0500
X-MC-Unique: d8TcxbcjPnGbF9Ic22Rbgg-1
X-Mimecast-MFC-AGG-ID: d8TcxbcjPnGbF9Ic22Rbgg
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-46790c5b1a5so1953071cf.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 09:58:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738778332; x=1739383132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75ymu4jpHyhbMjYieQ84OtAI2riBguf24EUxH7ex6f0=;
        b=cay/GuY7w+bmoltO5ZyGJoOhAhR/FETn8t6tzkX7uB6X0go4AVu+DpiQ6lRbDE3Vmc
         D5bOOSrUgibkp6CaqPPi5+oAnR6tty1bxqG/eSK15z2na1SOWUw+AMYGdUQaJ+xCkslB
         BjAh8WGM8ZBIqzWfDjcCOvT4r3bwd5SththrEID6jGm9RZl1sU0so47ayjndDJhVadlK
         KJHR5hFtxxBFzXg0/zsOhbIguO63byvsxAEUK4ALCS5mV+0QIu5kBmrJgzNBVK/Kjabv
         MDB6EfeX2HD/kHXBbnJapRX7Pn7cLn2SN9neIvWfXo58dhCbk/xGt2QYxDtWXBg3UJF+
         h1qw==
X-Forwarded-Encrypted: i=1; AJvYcCUuQ14vmVR6cdJ7mTxyHbWPbbQFei0rNyCMr2h3SEqhb/r5kXZf3Bac5hdczbSHlNY3dj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNnHpWAx0XjhCF+V0xFsxwr/9feGdSKqQfes8Ti1f1x+BdTQdv
	Agit5D6T1lplPIwKXsUb1kmKw+ZxQuThuKUdt2LfNdW8JwZaOpVkTZNBPLfC92h4FSr3FaLXsda
	Tf1gcXS7LEP2rgI6j9vYqRGD//kZIiKdbGmleyzzIZKcqM9+Xqg==
X-Gm-Gg: ASbGnctzH6SpNpwI6Gm7x5VsL939MrHpsXsuppSttCU5wSdYALWyUNMzCMfzQZDuXLB
	2aCzcdyMN97XLc4EG03HH/5UEcc7b0gpe5ise8Xp9v1zli2Yb2w153jYT3PcEXsvLg6hDQXJCM5
	OtnkXGL7eGNYcZlvk1O2/tWgu61bsyh1NwXQDctXSqvajfXNMq0VQe/zRmRrggiCobEdQ1ZnWkm
	wEKL7EkkB1jag3LIEJkJw+pHoXT0yzFISoFPFh4HG1+XVOlk7y3TSGYYQO7MlyWnnYZplYKma6U
	R8lcozq6LaMaZ6ocmf72+f2FRv5agdz3unP7C9UC/fB1tBxE
X-Received: by 2002:a05:622a:1807:b0:46c:728c:8862 with SMTP id d75a77b69052e-4702818fd7emr59106681cf.31.1738778332346;
        Wed, 05 Feb 2025 09:58:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcIRONPDeQ5coySu66etH/d204OSqB2SxF+etusBpuMM7ScONAqVPqWWOCnhA69AY81yo2/w==
X-Received: by 2002:a05:622a:1807:b0:46c:728c:8862 with SMTP id d75a77b69052e-4702818fd7emr59106171cf.31.1738778332012;
        Wed, 05 Feb 2025 09:58:52 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf0c62d4sm72570071cf.17.2025.02.05.09.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 09:58:51 -0800 (PST)
Date: Wed, 5 Feb 2025 12:58:48 -0500
From: Peter Xu <peterx@redhat.com>
To: William Roche <william.roche@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
	richard.henderson@linaro.org, philmd@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
	eduardo@habkost.net, marcel.apfelbaum@gmail.com,
	wangyanan55@huawei.com, zhao1.liu@intel.com,
	joao.m.martins@oracle.com
Subject: Re: [PATCH v7 6/6] hostmem: Handle remapping of RAM
Message-ID: <Z6Om2CiOEnbKzNEk@x1.local>
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-7-william.roche@oracle.com>
 <7a899f00-833e-4472-abc5-b2b9173eb133@redhat.com>
 <Z6JVQYDXI2h8Krph@x1.local>
 <a6f08213-e4a3-41af-9625-a88417a9d527@redhat.com>
 <Z6J1hFuAvpA78Ram@x1.local>
 <a3d7a8cc-aad8-4d98-a5ba-79fad20b9df6@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3d7a8cc-aad8-4d98-a5ba-79fad20b9df6@oracle.com>

On Wed, Feb 05, 2025 at 05:27:50PM +0100, William Roche wrote:
> On 2/4/25 21:16, Peter Xu wrote:
> > On Tue, Feb 04, 2025 at 07:55:52PM +0100, David Hildenbrand wrote:
> > > Ah, and now I remember where these 3 patches originate from: virtio-mem
> > > handling.
> > > 
> > > For virtio-mem I want to register also a remap handler, for example, to
> > > perform the custom preallocation handling.
> > > 
> > > So there will be at least two instances getting notified (memory backend,
> > > virtio-mem), and the per-ramblock one would have only allowed to trigger one
> > > (at least with a simple callback as we have today for ->resize).
> > 
> > I see, we can put something into commit log with such on decisions, then
> > we'll remember.
> > 
> > Said that, this still sounds like a per-ramblock thing, so instead of one
> > hook function we can also have per-ramblock notifier lists.
> > 
> > But I agree the perf issue isn't some immediate concern, so I'll leave that
> > to you and William.  If so I think we should discuss that in the commit log
> > too, so we decide to not care about perf until necessary (or we just make
> > it per-ramblock..).
> > 
> > Thanks,
> > 
> 
> 
> I agree that we could split this fix in 2 parts: The one fixing the
> hugetlbfs (ignoring the preallocation setting for the moment), and the
> notification mechanism as a second set of patches.
> 
> The first part would be the 3 first patches (including a corrected version
> of patch 2)  and the second part could be an adaptation of the next 3
> patches, with their notification implementation dealing with merging, dump
> *and* preallocation setup.
> 
> 
> But I'd be happy to help with the implementation of this 2nd aspect too:
> 
> In order to apply settings like preallocation to a RAMBLock we need to find
> its associated HostMemoryBackend (where we have the 'prealloc' flag).
> To do so, we record a RAMBlockNotifier in the HostMemoryBackend struct, so
> that the notification triggered by the remap action:
>    ram_block_notify_remap(block->host, offset, page_size);
> will go through the list of notifiers ram_list.ramblock_notifiers to run the
> not NULL ram_block_remapped entries on all of them.
> 
> For each of them, we know the associated HostMemoryBackend (as it contains
> the RAMBlockNotifier), and we verify which one corresponds to the host
> address given, so that we can apply the appropriate settings.
> 
> IIUC, my proposal (with David's code) currently has a per-HostMemoryBackend
> notification.
> 
> Now if I want to implement a per-RAMBlock notification, would you suggest to
> consider that the 'mr' attibute of a RAMBlock always points to a
> HostMemoryBackend.mr, so that we could get the HostMemoryBackend associated
> to the block from a
>     container_of(block->mr, HostMemoryBackend, mr) ?
> 
> If this is valid, than we could apply the appropriate settings from there,
> but can't we have RAMBlocks not pointing to a HostMemoryBackend.mr ?

Yes, QEMU definitely has ramblocks that are not backed by memory backends.
However each memory backend must have its ramblock.

IIUC what we need to do is let host_memory_backend_memory_complete()
register a per-ramblock notifier on top of its ramblock, which can be
referenced by backend->mr.ramblock.

> 
> 
> I'm probably confused about what you are referring to.
> So how would you suggest that I make the notification per-ramblock ?
> Thanks in advance for your feedback.
> 
> 
> I'll send a corrected version of the first 3 patches, unless you want to go
> with the current version of the patches 4/6, 5/6 and 6/6, so that we can
> deal with preallocation.

I don't feel strongly, but I can explain how the per-ramblock can be done.

One thing interesting I found is we actually have such notifier list
already in ramblocks.. see:

struct RAMBlock {
    ...
    QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
    ...
}

I guess that's some leftover from the global ramblock notifier.. e.g. I
tried remove that line and qemu compiles all fine.

Then instead of removing it, we could make that the per-ramblock list.

One way to do this is:

  - Patch 1: refactor current code, let RAMBlock.resized() to be a notifier
    instead of a fn() pointer passed over from
    memory_region_init_resizeable_ram().  It means we can remove
    RAMBlock.resized() but make fw_cfg_resized() becomes a notifier, taking
    RAM_BLOCK_RESIZED event instead.

  - Patch 2: introduce another RAM_BLOCK_REMAPPED event, then host backends
    (probably, host_memory_backend_memory_complete() after alloc() done so
    that the ramblock will always be available..) can register a notifier
    only looking for REMAPPED.

Then in the future virtio-mem can register similarly to specific ramblock
on REMAPPED only.

Thanks,

-- 
Peter Xu


