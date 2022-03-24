Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0754E69E9
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 21:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiCXUlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 16:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239357AbiCXUly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 16:41:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 057BC972D5
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 13:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648154421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YcqkWAtIoHhKaWHguuTSHckFy2uV+KOK7nFBpa+JxJo=;
        b=edyc0AxSXd8NLDHyCBrRSZkqpxYDlY2ZSnHi/mP8s7PwYG8MOOzaSGcPk+egg0i+6lx8qx
        NZMswZh3DZt0WsRVtRMh4dAYHeLcbcD2PKBPCznqspLVLWToVVjyWHQi10Iqikefe+GlTC
        9z656H5e3lalYuALxt4MyavzKltSZh8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-Ip1NUAW7M8Kue-YtAecCaQ-1; Thu, 24 Mar 2022 16:40:19 -0400
X-MC-Unique: Ip1NUAW7M8Kue-YtAecCaQ-1
Received: by mail-il1-f200.google.com with SMTP id u15-20020a92da8f000000b002c863d2f21dso2979400iln.15
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 13:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YcqkWAtIoHhKaWHguuTSHckFy2uV+KOK7nFBpa+JxJo=;
        b=M+4+GZnePdB78W6UGWqs9ERy/N189gqbK2mYoFD202WBfjkaotiIKHKL4iBxv2N30I
         374xmz5dIepL0fQEpeMWLUre1TkLXTt1V0YKkXZK6bjvKJ6ujbxwGhyzzd+Joy5rUIZf
         AnYxRs61NjbyKAlsGq0WxKxqXimLu/gdIyP4Od3NKcxY8fedueWJ0C/MUmZDnSMiUsYu
         FhoLsxweRmDpmf7wiP1bk3GR2IJmhsE6hdfMRe4VeiavlZetytzQi2KACnvhcdxG4iPC
         aWE55bPsbJb5pEu/ucVktn/pmGMKDNj7U6v/UlKL1cTRfnvJFkQg2s8eGxLCeo5VOcum
         aNwg==
X-Gm-Message-State: AOAM532My/VKpcheCLUoB0Kh0jniS+acAZODOC/Snd4j2t6noMH8vRh9
        hh8O53FfEvdfSsuqRNe1hZVsLzhe1vtALkcC16vcUmGNNQEj8wN5+zol8Xchjr0c4TgU+Ke1zMR
        x2nudj13NEu5p
X-Received: by 2002:a5d:9da0:0:b0:646:4297:19de with SMTP id ay32-20020a5d9da0000000b00646429719demr3763034iob.192.1648154418994;
        Thu, 24 Mar 2022 13:40:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwopmqoCIMeyEsE8B56txeb229eqdmXoF3CZI0belX8dei6vqWnikSzyfxA9iLbrgAEVuuhIw==
X-Received: by 2002:a5d:9da0:0:b0:646:4297:19de with SMTP id ay32-20020a5d9da0000000b00646429719demr3763023iob.192.1648154418710;
        Thu, 24 Mar 2022 13:40:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q4-20020a056e0215c400b002c5fdff3087sm2320928ilu.29.2022.03.24.13.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 13:40:18 -0700 (PDT)
Date:   Thu, 24 Mar 2022 14:40:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe via iommu <iommu@lists.linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220324144015.031ca277.alex.williamson@redhat.com>
In-Reply-To: <20220322161521.GJ11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
        <20220322145741.GH11336@nvidia.com>
        <20220322092923.5bc79861.alex.williamson@redhat.com>
        <20220322161521.GJ11336@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Mar 2022 13:15:21 -0300
Jason Gunthorpe via iommu <iommu@lists.linux-foundation.org> wrote:

> On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:
> 
> > I'm still picking my way through the series, but the later compat
> > interface doesn't mention this difference as an outstanding issue.
> > Doesn't this difference need to be accounted in how libvirt manages VM
> > resource limits?    
> 
> AFACIT, no, but it should be checked.
> 
> > AIUI libvirt uses some form of prlimit(2) to set process locked
> > memory limits.  
> 
> Yes, and ulimit does work fully. prlimit adjusts the value:
> 
> int do_prlimit(struct task_struct *tsk, unsigned int resource,
> 		struct rlimit *new_rlim, struct rlimit *old_rlim)
> {
> 	rlim = tsk->signal->rlim + resource;
> [..]
> 		if (new_rlim)
> 			*rlim = *new_rlim;
> 
> Which vfio reads back here:
> 
> drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> drivers/vfio/vfio_iommu_type1.c:        unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> 
> And iommufd does the same read back:
> 
> 	lock_limit =
> 		task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> 	npages = pages->npinned - pages->last_npinned;
> 	do {
> 		cur_pages = atomic_long_read(&pages->source_user->locked_vm);
> 		new_pages = cur_pages + npages;
> 		if (new_pages > lock_limit)
> 			return -ENOMEM;
> 	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm, cur_pages,
> 				     new_pages) != cur_pages);
> 
> So it does work essentially the same.

Well, except for the part about vfio updating mm->locked_vm and iommufd
updating user->locked_vm, a per-process counter versus a per-user
counter.  prlimit specifically sets process resource limits, which get
reflected in task_rlimit.

For example, let's say a user has two 4GB VMs and they're hot-adding
vfio devices to each of them, so libvirt needs to dynamically modify
the locked memory limit for each VM.  AIUI, libvirt would look at the
VM size and call prlimit to set that value.  If libvirt does this to
both VMs, then each has a task_rlimit of 4GB.  In vfio we add pinned
pages to mm->locked_vm, so this works well.  In the iommufd loop above,
we're comparing a per-task/process limit to a per-user counter.  So I'm
a bit lost how both VMs can pin their pages here.

Am I missing some assumption about how libvirt users prlimit or
sandboxes users?

> The difference is more subtle, iouring/etc puts the charge in the user
> so it is additive with things like iouring and additively spans all
> the users processes.
> 
> However vfio is accounting only per-process and only for itself - no
> other subsystem uses locked as the charge variable for DMA pins.
> 
> The user visible difference will be that a limit X that worked with
> VFIO may start to fail after a kernel upgrade as the charge accounting
> is now cross user and additive with things like iommufd.

And that's exactly the concern.
 
> This whole area is a bit peculiar (eg mlock itself works differently),
> IMHO, but with most of the places doing pins voting to use
> user->locked_vm as the charge it seems the right path in today's
> kernel.

The philosophy of whether it's ultimately a better choice for the
kernel aside, if userspace breaks because we're accounting in a
per-user pool rather than a per-process pool, then our compatibility
layer ain't so transparent.

> Ceratinly having qemu concurrently using three different subsystems
> (vfio, rdma, iouring) issuing FOLL_LONGTERM and all accounting for
> RLIMIT_MEMLOCK differently cannot be sane or correct.

I think everyone would agree with that, but it also seems there are
real differences between task_rlimits and per-user vs per-process
accounting buckets and I'm confused how that's not a blocker for trying
to implement transparent compatibility.  Thanks,

Alex

