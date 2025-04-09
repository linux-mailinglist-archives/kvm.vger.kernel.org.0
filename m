Return-Path: <kvm+bounces-43012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3F0A82456
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 14:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 736C44C1839
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 12:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A037225F7A2;
	Wed,  9 Apr 2025 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPn8yJv2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68D125E47E
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744200457; cv=none; b=qsh7Wx3mtd0xWcriZF404gHqRdaRi13Ntw9tb6dO03DZNkU0FUtpt55MmCo0plYrubaJLgpvIL3ScUaoKyXF0TmT+TG7DC2UAKXxLkwnxr5LjcQB8VuxHv3dsO2pEqFw+dBLsRT6/v5OjZtUUIPEHfvni/gbC+vDBf8s5Ewjrno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744200457; c=relaxed/simple;
	bh=b8JlKxfWsW1Q1FUlQniB4qLGZUd/o9jlhbIFjs404XU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nN9ZGdUMFJ22ZlHBZB8YpAz+G+oebvP6lMrMnRiVVz5OqfH9w7Ge0QM6g7uEalqjJc0hI/TXNj88qyb9DAqHS/yZ52lL0My66dLrJf7N+ltOj8ncAVY5R+cQ/16I59lkwSWRXdjZT97rLhgtu/F/ABOHIThYm4B827aZj2Dw180=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPn8yJv2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744200454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=93G2Nz5v0VWYsyTUc29spHX3l7oxT61r/O1+sjmvXx0=;
	b=YPn8yJv2fCX/cl5qhxpmWtoHCaDhKTNAQ5jayOT+6oWOJTbaxW3uMFZIwSsDognrY+Nv81
	5o7ASho3MbDHcmuLt/97/JgIvtePOyNx0yignUryU6uPKTcO3uuFQlj3xNrJ/F0JpojRMY
	vEpX3P8OL3s4FL8V+HHHMUtThFhyoSM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-iZKOwCHIOOmXuapFnrOKMA-1; Wed, 09 Apr 2025 08:07:33 -0400
X-MC-Unique: iZKOwCHIOOmXuapFnrOKMA-1
X-Mimecast-MFC-AGG-ID: iZKOwCHIOOmXuapFnrOKMA_1744200452
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cf446681cso46710995e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 05:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744200452; x=1744805252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93G2Nz5v0VWYsyTUc29spHX3l7oxT61r/O1+sjmvXx0=;
        b=xG4ID0Uuz51BogqTmEZqjtSkDDCr7RVm4IoEGhMDDIyUAzCt3AwIp1Cey7IVmAOUM+
         NngRX8I9L2amXdCqK6Xq80tLrT6H1lIB0G2CX/2SwaR6PUx2io6suIBhwOuWi74zVEiT
         vtwnSiXgm0bgS8ruxLOk3aN8Js35bRJFKgvZMjBrNR49IU9xjiCxcwa2LOLyfsyF6MhZ
         DBI4Xq+E2pMEeFeZkbDpsejb1JGZgncHz3AhYzb+nxs28r+k5CB+6Q3ipy0yw1sD2zBy
         L4G932rFB8XJvj77d939K4G2GbKyq3HDYdN3ch8Zo2n2IH9kqoNz+kc96h6YuTGq4w7c
         U8JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFCU6huN1DNqqROqT7IHfKEliPrQS2Z03xq9vgqQ5HsbDYTwrJEvWnV5zzcDLKG4sCoNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQjLjKrbXyBk0W4YAMC3rqNlQvnDUtdpfIJQ8QEX7z0iaTklNC
	VZ4Mqd70sZ/mE2xVHPQWdTGiHGj/kuiJsfkVFyNxI2QNQIWU+Q7QY1WJgAjaQyKeKCFyWOr7sRR
	+KCx2q2BFBl2arbKhVJdC9X1CE9B2Uj5BQ6/oQKeRjxbtbhvvsw==
X-Gm-Gg: ASbGncsUZ1vwZDfpYnejnXMnAcq9zUIOQPolH7tSTMGX9w/KhEDXV2Te7DmetqnNeeX
	m6JSm/RnmBr/or/h+M9U/gbPzsKh80r+3un3HqspUWXjJpPThO8Kex46/Hb5lR5BPy8yuuUF09w
	/12dhMDQ6yFMQZMtnqYO3NvZQ47oTptYRbow+tDnE3jCJucA1pwBm9pFoFA5NKzZTmCUj0eFHI7
	3xTx/g1TLjtSWrP5UrtIHTF2cWPIpUef3O5lCeNyY3pSo7wf9zt/UEZAjBTaci+2LW0VP4eV+WD
	MMAcDA==
X-Received: by 2002:a05:600c:4f06:b0:43c:eec7:eabb with SMTP id 5b1f17b1804b1-43f1eca7d49mr25281705e9.8.1744200451998;
        Wed, 09 Apr 2025 05:07:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgSZUF2eaDFJtZf7ycuhgCh7uKezx7J6gwsxBt6Ke0ZQtqogJFzTU/28nf3axU595G1MOTHA==
X-Received: by 2002:a05:600c:4f06:b0:43c:eec7:eabb with SMTP id 5b1f17b1804b1-43f1eca7d49mr25281355e9.8.1744200451567;
        Wed, 09 Apr 2025 05:07:31 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2066d26bsm18374765e9.22.2025.04.09.05.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 05:07:30 -0700 (PDT)
Date: Wed, 9 Apr 2025 08:07:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>,
	Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
	Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250409073652-mutt-send-email-mst@kernel.org>
References: <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
 <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
 <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
 <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
 <3bbad51d-d7d8-46f7-a28c-11cc3af6ef76@redhat.com>
 <20250407170239-mutt-send-email-mst@kernel.org>
 <440de313-e470-4afa-9f8a-59598fe8dc21@redhat.com>
 <20250409065216-mutt-send-email-mst@kernel.org>
 <4ad4b12e-b474-48bb-a665-6c1dc843cd51@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ad4b12e-b474-48bb-a665-6c1dc843cd51@redhat.com>

On Wed, Apr 09, 2025 at 01:12:19PM +0200, David Hildenbrand wrote:
> On 09.04.25 12:56, Michael S. Tsirkin wrote:
> > On Wed, Apr 09, 2025 at 12:46:41PM +0200, David Hildenbrand wrote:
> > > On 07.04.25 23:20, Michael S. Tsirkin wrote:
> > > > On Mon, Apr 07, 2025 at 08:47:05PM +0200, David Hildenbrand wrote:
> > > > > > In my opinion, it makes the most sense to keep the spec as it is and
> > > > > > change QEMU and the kernel to match, but obviously that's not trivial
> > > > > > to do in a way that doesn't break existing devices and drivers.
> > > > > 
> > > > > If only it would be limited to QEMU and Linux ... :)
> > > > > 
> > > > > Out of curiosity, assuming we'd make the spec match the current QEMU/Linux
> > > > > implementation at least for the 3 involved features only, would there be a
> > > > > way to adjust crossvm without any disruption?
> > > > > 
> > > > > I still have the feeling that it will be rather hard to get that all
> > > > > implementations match the spec ... For new features+queues it will be easy
> > > > > to force the usage of fixed virtqueue numbers, but for free-page-hinting and
> > > > > reporting, it's a mess :(
> > > > 
> > > > 
> > > > Still thinking about a way to fix drivers... We can discuss this
> > > > theoretically, maybe?
> > > 
> > > Yes, absolutely. I took the time to do some more digging; regarding drivers
> > > only Linux seems to be problematic.
> > > 
> > > virtio-win, FreeBSD, NetBSD and OpenBSD and don't seem to support
> > > problematic features (free page hinting, free page reporting) in their
> > > virtio-balloon implementations.
> > > 
> > > So from the known drivers, only Linux is applicable.
> > > 
> > > reporting_vq is either at idx 4/3/2
> > > free_page_vq is either at idx 3/2
> > > statsq is at idx2 (only relevant if the feature is offered)
> > > 
> > > So if we could test for the existence of a virtqueue at an idx easily, we
> > > could test from highest-to-smallest idx.
> > > 
> > > But I recall that testing for the existance of a virtqueue on s390x resulted
> > > in the problem/deadlock in the first place ...
> > > 
> > > -- 
> > > Cheers,
> > > 
> > > David / dhildenb
> > 
> > So let's talk about a new feature bit?
> 
> Are you thinking about a new feature that switches between "fixed queue
> indices" and "compressed queue indices", whereby the latter would be the
> legacy default and we would expect all devices to switch to the new
> fixed-queue-indices layout?
> 
> We could make all new features require "fixed-queue-indices".

I see two ways:
1. we make driver behave correctly with in spec and out of spec devices
   and we make qemu behave correctly with in spec and out of spec devices
2. a new feature bit

I prefer 1, and when we add a new feature we can also
document that it should be in spec if negotiated.

My question is if 1 is practical.





> > 
> > Since vqs are probed after feature negotiation, it looks like
> > we could have a feature bit trigger sane behaviour, right?
> 
> In the Linux driver, yes. In QEMU (devices), we add the queues when
> realizing, so we'd need some mechanism to adjust the queue indices based on
> feature negotiation I guess?

Well we can add queues later, nothing prevents that.


> For virtio-balloon it might be doable to simply always create+indicate
> free-page hinting to resolve the issue easily.


OK, so
- for devices, we suggest that basically VIRTIO_BALLOON_F_REPORTING
  only created with VIRTIO_BALLOON_F_FREE_PAGE_HINT and 
  VIRTIO_BALLOON_F_FREE_PAGE_HINT only created with VIRTIO_BALLOON_F_STATS_VQ

I got that.


Now, for drivers.

If the dependency is satisfied as above, no difference.

What should drivers do if not?



I think the thing to do would be to first probe spec compliant
vq numbers? If not there, try with the non compliant version?


However,  you wrote:
> > > But I recall that testing for the existance of a virtqueue on s390x resulted
> > > in the problem/deadlock in the first place ...

I think the deadlock was if trying to *use* a non-existent virtqueue?

This is qemu code:

    case CCW_CMD_READ_VQ_CONF:
        if (check_len) {
            if (ccw.count != sizeof(vq_config)) {
                ret = -EINVAL;
                break;
            }
        } else if (ccw.count < sizeof(vq_config)) {
            /* Can't execute command. */
            ret = -EINVAL;
            break;
        }
        if (!ccw.cda) {
            ret = -EFAULT;
        } else {
            ret = ccw_dstream_read(&sch->cds, vq_config.index);
            if (ret) {
                break;
            }
            vq_config.index = be16_to_cpu(vq_config.index);
            if (vq_config.index >= VIRTIO_QUEUE_MAX) {
                ret = -EINVAL;
                break;
            }
            vq_config.num_max = virtio_queue_get_num(vdev,
                                                     vq_config.index);
            vq_config.num_max = cpu_to_be16(vq_config.num_max);
            ret = ccw_dstream_write(&sch->cds, vq_config.num_max);
            if (!ret) {
                sch->curr_status.scsw.count = ccw.count - sizeof(vq_config);
            }
        }

and

            
int virtio_queue_get_num(VirtIODevice *vdev, int n)
{               
    return vdev->vq[n].vring.num;
}           
            


it seems to happily return vq size with no issues?




> For virtio-fs it might not be that easy.

virtio fs? But it has no features?

> > 
> > I kind of dislike it that we have a feature bit for bugs though.
> > What would be a minimal new feature to add so it does not
> > feel wrong?
> 
> Probably as above: fixed vs. compressed virtqueue indices?
> 
> -- 
> Cheers,
> 
> David / dhildenb


