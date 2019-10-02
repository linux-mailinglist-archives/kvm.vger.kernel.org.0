Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C295C93E4
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 23:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfJBV5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 17:57:48 -0400
Received: from alpha.anastas.io ([104.248.188.109]:34097 "EHLO
        alpha.anastas.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfJBV5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 17:57:48 -0400
Received: from authenticated-user (alpha.anastas.io [104.248.188.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by alpha.anastas.io (Postfix) with ESMTPSA id D71817EB12;
        Wed,  2 Oct 2019 16:57:46 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=anastas.io; s=mail;
        t=1570053467; bh=y3OBjlDVg2FJ0yEN3zcnKsGCFNiMul3cWckup+8voJE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OkiJU5ys+qIY0qOH+7XmamXUWwglbCZTE7DryCLTRZUrNYj47xJzve8GqJC1JghCV
         hqgOKLwkuDAJeLpE+7WVfUOfcwMImWwvUAQ2Mnob2Tj+t4kiJF1qOxZWvWxNRWyO2S
         jiF0e5/57/IqXGsQRhXlCgq4MkqIN5AhVG0lnQdcnKVhZna4ivgRXCf9JCy66n+4N4
         a2zTMTjnXxeAJavXJ7j/wziGssZeEOpBb8YLlhiCAtKdESje3r+KliDNNxPVn+s00p
         sC1DRWlCPNGv0swlZPFHoHO3FB5YPT2ku/BPgFXMs4B2apHlsDW1I2K1ZWVydvJhYq
         vXTSGGFcOBzRw==
Subject: Re: [PATCH RFC 0/1] VFIO: Region-specific file descriptors
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, Donald Dutile <ddutile@redhat.com>
References: <20190930235533.2759-1-shawn@anastas.io>
 <20191001093852.5c1d9c7c@x1.home>
From:   Shawn Anastasio <shawn@anastas.io>
Message-ID: <7b953e86-82a4-cf58-24d5-b8f9b5ae8d55@anastas.io>
Date:   Wed, 2 Oct 2019 16:57:45 -0500
MIME-Version: 1.0
In-Reply-To: <20191001093852.5c1d9c7c@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/19 10:38 AM, Alex Williamson wrote:
> On Mon, 30 Sep 2019 18:55:32 -0500 Shawn Anastasio <shawn@anastas.io>
> wrote:
> 
>> This patch adds region file descriptors to VFIO, a simple file
>> descriptor type that allows read/write/mmap operations on a single
>> region of a VFIO device.
>> 
>> This feature is particularly useful for privileged applications
>> that use VFIO and wish to share file descriptors with unprivileged
>> applications without handing over full control of the device.
> 
> Such as?  How do we defined "privileged"?  VFIO already allows 
> "unprivileged applications" to own a device, only file permissions
> are necessary for the VFIO group.  Does region level granularity
> really allow us to claim that the consumer of this fd doesn't have
> full control of the device?  Clearly device ioctls, including
> interrupts, and DMA mappings are not granted with only access to a
> region, but said unprivileged application may have absolute full
> control of the device itself via that region.

Yes, that's true - determining whether any control was restricted will
depend on the specifics of the device and region shared.

The use case I had in mind when implementing this was QEMU's ivshmem
device. I'm writing a daemon that uses VFIO to establish a shared
memory channel with the host via ivshmem devices and then passes
the shared memory region to unprivileged clients over unix domain
sockets. In this case, it is beneficial to have a way to only share
BAR 2 of the ivshmem device (the shared memory region) without giving
control over device configuration and interrupts.

It would also perhaps be useful to restrict the read/write/mmap
abilities of a region fd at time of creation, though the patch
as-is doesn't implement that.

>> It also allows applications to use regular offsets in
>> read/write/mmap instead of the region index + offset that must be
>> used with device file descriptors.
> 
> How is this actually an issue that needs a solution?

It allows applications that expect memfd/shm style semantics to
work without modification. In the use case I mentioned, it allows
the unprivileged clients to use any received shared memory fds without
knowledge of VFIO-specific semantics. This means that the code paths for
the host, where regular memfds are passed, and the guest, where VFIO
region fds are passed can be the same.

>> The current implementation is very raw (PCI only, no reference
>> counting which is probably wrong), but I wanted to get a sense to
>> see if this feature is desired. If it is, tips on how to implement
>> this more correctly are appreciated.
> 
> Handling the ownership and life cycle of the region fds is the more 
> complicated problem.  If an unprivileged user has an mmap to a
> device owned by a privileged user, how does it get revoked by the
> privileged part of this equation?

Yes, this is something that I've been thinking about. IIUC, the current
patch results in all region fds being invalidated when the privileged
process drops the device fd, but this may not be the best solution.

Perhaps having region fds bump the device struct reference counts
so that region fds can outlive device fds makes more sense. This
wouldn't allow the privileged process to revoke region access, though.

> How do we decide which regions merit this support, for instance a
> device specific region could have just as viable a use case as a BAR.
> Why does this code limit support to regions supporting mmap but then
> support read/write as well?

This was an arbitrary decision I made while testing and not necessarily
the behavior I wish to keep. Perhaps it would make sense to allow
region fd creation for regions that support any of r, w, mmap.

> Technically, isn't the extent of functionality provided in this RFC 
> already available via the PCI resource files in sysfs?

That's a good point, though having the functionality within the
VFIO framework would be nice as well. There's plenty of functionality
already duplicated between sysfs, UIO, and VFIO.

> Without a concrete use case, this looks like a solution in search of
> a problem.  Thanks,

Hopefully the use case I described above makes sense. This is my first
time writing a PCI driver, so I don't know if this use case is a bit
contrived and not applicable outside my specific application.

I don't think it's too unreasonable to think that there are some
other applications where restricting access to specific regions
would be useful, though.

Thanks,
Shawn
