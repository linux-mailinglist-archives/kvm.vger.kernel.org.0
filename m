Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2375073E434
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjFZQH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjFZQHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F631B1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687795613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJPNo+/LgG0KXsCyIerMFPAI/JqqDRK/rvfGQLVSbrI=;
        b=goQ7bT2lZVq1FtgxGDisSKw8WLZHUrceKYiRpW1BXn9ReYsf5qy5LBvetZh9mZ5MGRvvyu
        MBhPzQQIeolDgaV8aO5kKAvoj6yqJ6mLuZ2C8q9pEafD2kHICuabAmVVwnrDh3z7lxs7p3
        NcykmBTNuHbLVYLBtT182P8SHmHTvaQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-pEhkPEJVMbGVdMd9AOC9Ww-1; Mon, 26 Jun 2023 12:06:46 -0400
X-MC-Unique: pEhkPEJVMbGVdMd9AOC9Ww-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7836080abf0so48583639f.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687795592; x=1690387592;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RJPNo+/LgG0KXsCyIerMFPAI/JqqDRK/rvfGQLVSbrI=;
        b=bqY5lpw+JjZZHwiW7ok7VGW+6rhUaQTnUOJhEgwvs+0A4YnuAXgh4PW27EXYJQsLzR
         QvBLG4Zzguue9hFWx6rRyOsvP8mqWCmlVJfbOLbzmvcweQyY2M7yjXAwRD+VyCbY42rs
         kYqTHdKUlyjH/UQwyWhmPqhj9e0UZKWOhtEo8HjkAcOD5SFRir+tBETVB28te4aLf2Eq
         Gw5SkbBPm/9XkaFpT7oG2K04p7id/helERlkjNaVOWjRvpo0mP3m52kxhcgTADvLvner
         CVIKnpoIfuFdHXXrWvKLESbPfFNvob/NhxZ3V0MeCsOxsNeqWO+dwYT16l1wMI8W5eUo
         WdEw==
X-Gm-Message-State: AC+VfDwCrNt89er3ccrc8BuEC+SsyZlJlVn9uWFR6jNQZqPg5siNCFak
        /P+GzotYpzL0vMjfjTcR2kSsaVsw+7Uf87hitboHF8Wcr7ZIerWfbBIiU67kvlBclxNYNcqPlO8
        5VZ5j5XH8vSMX
X-Received: by 2002:a6b:f417:0:b0:777:b4af:32a3 with SMTP id i23-20020a6bf417000000b00777b4af32a3mr24592666iog.14.1687795592670;
        Mon, 26 Jun 2023 09:06:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ53FUa3LHmQBZC6LWteROXsScIosACWPyU08IRlkyg3/dKKqdkS4z/oGdbp+hN7l0kO2tLOkw==
X-Received: by 2002:a6b:f417:0:b0:777:b4af:32a3 with SMTP id i23-20020a6bf417000000b00777b4af32a3mr24592636iog.14.1687795592402;
        Mon, 26 Jun 2023 09:06:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h21-20020a02b615000000b004231ee0fed4sm1831402jam.78.2023.06.26.09.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:06:31 -0700 (PDT)
Date:   Mon, 26 Jun 2023 10:06:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230626100629.3c318922.alex.williamson@redhat.com>
In-Reply-To: <ZJWdbbNESp1+6GVN@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
        <ZJWdbbNESp1+6GVN@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Jun 2023 10:26:05 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 21, 2023 at 08:07:20PM -0700, ankita@nvidia.com wrote:
> > +			if (caps.size) {
> > +				info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> > +				if (info.argsz < sizeof(info) + caps.size) {
> > +					info.argsz = sizeof(info) + caps.size;
> > +					info.cap_offset = 0;  
> 
> Shouldn't this be an error if we can't fit the caps into the response?
> Silently discarding the caps seems wrong..

It's required for backwards compatibility.  If a userspace doesn't
support the info ioctl capabilities chain, it gets the basic
information successfully, while an enlightened userspace makes use of
the flags to know that a capability chain is available but unreported
due to an insufficient buffer size, with the required size being
provided in the return structure.
 
> > +static ssize_t nvgpu_vfio_pci_read(struct vfio_device *core_vdev,
> > +		char __user *buf, size_t count, loff_t *ppos)
> > +{
> > +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> > +
> > +	/*
> > +	 * Only the device memory present on the hardware is mapped, which may
> > +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> > +	 * access outside the available device memory on the hardware.
> > +	 */
> > +	if (index == VFIO_PCI_BAR2_REGION_INDEX)
> > +		return -EINVAL;  
> 
> What does the qemu do in this case? Crash the VM?

Yes, I don't think return -errno matches what we discussed for
returning -1 on read and dropping writes outside of the device memory.
Also see comments in my review that read/write should handle the
coherent memory area as well, the device should work with x-no-mmap=on.
Thanks,

Alex

