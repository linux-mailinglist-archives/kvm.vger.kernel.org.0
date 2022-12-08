Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD96474FB
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiLHR01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLHR0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:26:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040D353EEA
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 09:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670520331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E71Bhw/FO0T2S1rVc4Z9xmEAUXbwHIkJXUEVUPOidwc=;
        b=RrXzT75OA8Q9jKRJmvsy6dbhXbNyn5T2CekrH9VPdPMltCTQ2+GPsjzesJHjVzZdi8/Oeh
        txOGxj4a+yvlOEiji8WREN1ayUe+OW1KkfOrZlhreq+rnUs9EWymZZCQk6NQiW6xbE5f4W
        dpk3riu1Tt7Dwp4SjypHRiZ6trcrWpk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-8-ooXGEj7dNnej0ehsumgw5Q-1; Thu, 08 Dec 2022 12:25:29 -0500
X-MC-Unique: ooXGEj7dNnej0ehsumgw5Q-1
Received: by mail-io1-f72.google.com with SMTP id h21-20020a05660224d500b006debd7dedccso622049ioe.9
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 09:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E71Bhw/FO0T2S1rVc4Z9xmEAUXbwHIkJXUEVUPOidwc=;
        b=a0uHaeTAgf9ztkr9c6iL1rcDoNds8s4QmyWvW9FBb/N03U5NtlaoeK+9YLQ/6O2NaO
         876D3dN3LlTVpAM4/z/yNLu34IDriDN0Bw+AMVseerOycLRn3Xp7IoBJE7uY77/l3WgN
         7JbnQ5oI3fuVhRM5Hrzhw1gBi2vp+EEldNcYmJT9SaOzT9gg3pvApD9jWAk2xYM4XbjP
         lIZhASchGbb4YJKlOpMMRUUtfnN+66mGLsQVOM42GhUHi4GMtax3IiQINMl7Ntr1bLB4
         AiwjkZKNvamshTNftCh8ONmZQWL8prIa50TwtxCcVFfLGwhoou3yAvdDa/9jbwtnBwwT
         JIXQ==
X-Gm-Message-State: ANoB5plxDs+BLqW9ZVv+Y07cBnP6AYcTIrv28kaJOHvu4GjBrzUKHkJl
        m5TL3JzdC6Vxa0qziu/QGSPNP6pyvBhQ2I6aFaeQb1NXec3wWZvW1El2RrxDJPMcmku7X8NmvxI
        UlD5jZ/F+0w5/
X-Received: by 2002:a05:6602:2495:b0:6ca:d145:93 with SMTP id g21-20020a056602249500b006cad1450093mr36674285ioe.71.1670520329048;
        Thu, 08 Dec 2022 09:25:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6NWsKoYU+tBxwYj4F/NAmzAmG9ziUTJ4tCCB5/cJ6F7yZO1Fy5Ia8MSW1AfE9ico+pnmEefQ==
X-Received: by 2002:a05:6602:2495:b0:6ca:d145:93 with SMTP id g21-20020a056602249500b006cad1450093mr36674274ioe.71.1670520328816;
        Thu, 08 Dec 2022 09:25:28 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b30-20020a026f5e000000b0038a590b8cb4sm3170383jae.179.2022.12.08.09.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:25:28 -0800 (PST)
Date:   Thu, 8 Dec 2022 10:25:27 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Major Saheb <majosaheb@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: vfio-pci rejects binding to devices having same pcie vendor id
 and device id
Message-ID: <20221208102527.33917ff9.alex.williamson@redhat.com>
In-Reply-To: <20221208165008.GA1547952@bhelgaas>
References: <CANBBZXPWe56VYJtzXdimEnkFgF+A=G15TXrd8Z5kBcUOGgHeRw@mail.gmail.com>
        <20221208165008.GA1547952@bhelgaas>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Dec 2022 10:50:08 -0600
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc VFIO folks and Zhenzhong (author of the commit you mention)]
> 
> On Thu, Dec 08, 2022 at 09:24:31PM +0530, Major Saheb wrote:
> > I have a linux system running in kvm, with 6 qemu emulated NVMe
> > drives, as expected all of them have the same PCIe Vendor ID and
> > Device ID(VID: 0x1b36 DID: 0x0010).
> >
> > When I try to unbind them from the kernel NVMe driver and bind it to
> > vfio-pci one by one, I am getting "write error: File exists" when I
> > try to bind the 2nd(and other) drive to vfio-pci.
> > 
> > Kernel version
> > 
> > 5.15.0-56-generic #62-Ubuntu SMP Tue Nov 22 19:54:14 UTC 2022 x86_64
> > x86_64 x86_64 GNU/Linux
> > 
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme0n1 -> ../devices/pci0000:00/0000:00:03.0/nvme/nvme0/nvme0n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme1n1 -> ../devices/pci0000:00/0000:00:04.0/nvme/nvme1/nvme1n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme2n1 -> ../devices/pci0000:00/0000:00:05.0/nvme/nvme2/nvme2n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme3n1 -> ../devices/pci0000:00/0000:00:06.0/nvme/nvme3/nvme3n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme4n1 -> ../devices/pci0000:00/0000:00:07.0/nvme/nvme4/nvme4n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme5n1 -> ../devices/pci0000:00/0000:00:08.0/nvme/nvme5/nvme5n1
> > 
> > Steps for repro
> > ubind nvme2 from kernel NVMe driver and bind it to vfio
> > $ ls -l /sys/bus/pci/drivers/vfio-pci/
> > lrwxrwxrwx 1 root root    0 Dec  8 13:04 0000:00:05.0 -> ../../../../devices/pci0000:00/0000:00:05.0
> > --w------- 1 root root 4096 Dec  8 13:07 bind
> > lrwxrwxrwx 1 root root    0 Dec  8 13:07 module -> ../../../../module/vfio_pci
> > --w------- 1 root root 4096 Dec  8 13:04 new_id
> > --w------- 1 root root 4096 Dec  8 13:07 remove_id
> > --w------- 1 root root 4096 Dec  8 11:32 uevent
> > --w------- 1 root root 4096 Dec  8 13:07 unbind
> > 
> > Unbind nvme3 from  kernel NVMe driver
> > Try binding to vfio-pci
> > # echo "0x1b36  0x0010" >  /sys/bus/pci/drivers/vfio-pci/new_id
> > -bash: echo: write error: File exists

Presumably you already wrote this same ID to the dynamic ID table from
the first device, so yes, it's going to rightfully complain that this
ID already exists.  The new_id interface has numerous problems, which
is why we added the driver_override interface, which is used by tools
like libvirt and driverctl in place of this old interface.

I'd recommend something like:

# driverctl --nosave set-override 0000:00:03.0 vfio-pci
# driverctl --nosave set-override 0000:00:04.0 vfio-pci
# driverctl --nosave set-override 0000:00:05.0 vfio-pci
...

Or if vfio-pci is generally the preferred driver for these devices, you
could remove the --nosave option to have them automatically bound at
boot.  You could also make use of pre-filling the vfio device table
using vfio-pci.ids=1b36:0010 on the kernel command line and making sure
the vfio-pci driver is loaded before the nvme driver.  In general, for
dynamic binding of devices, driver_override is the recommended solution.
Thanks,

Alex

