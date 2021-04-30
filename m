Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7075A36FC72
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhD3Oag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 10:30:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhD3Oae (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Apr 2021 10:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619792985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FPEELsSGx4cLbmxHKF7dTq3mC1Xpq1F0QvtZc08MVK4=;
        b=eU8pU6YWtyzMvQAJmcdsD0F9MT9F9kK/xE4oQbrGs8xo/Q3WNsTrDVxQL/xInzXzPyDECB
        gOVRt2LSD2/eoU1H8ZpqyY+vzcaDwErtDwj8GRAjftBIO8+zyKTyATouftUEe7RuvuP/p3
        qUY1vHeqNpcOvasAgAzNDYhWaiMt+d8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-y0KmsgpjO0yM5DYo73n47Q-1; Fri, 30 Apr 2021 10:29:43 -0400
X-MC-Unique: y0KmsgpjO0yM5DYo73n47Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 146AC107ACCD;
        Fri, 30 Apr 2021 14:29:42 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86B66100763C;
        Fri, 30 Apr 2021 14:29:41 +0000 (UTC)
Date:   Fri, 30 Apr 2021 08:29:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yicong Yang <yangyicong@hisilicon.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [Question] Indefinitely block in the host when remove the PF
 driver
Message-ID: <20210430082940.4b0e0397@redhat.com>
In-Reply-To: <c9466e2c-385d-8298-d03c-80dcfc359f52@hisilicon.com>
References: <c9466e2c-385d-8298-d03c-80dcfc359f52@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Apr 2021 15:57:47 +0800
Yicong Yang <yangyicong@hisilicon.com> wrote:

> When I try to remove the PF driver in the host, the process will be blocked
> if the related VF of the device is added in the Qemu as an iEP.
> 
> here's what I got in the host:
> 
> [root@localhost 0000:75:00.0]# rmmod hisi_zip
> [99760.571352] vfio-pci 0000:75:00.1: Relaying device request to user (#0)
> [99862.992099] vfio-pci 0000:75:00.1: Relaying device request to user (#10)
> [...]
> 
> and in the Qemu:
> 
> estuary:/$ lspci -tv
> -[0000:00]-+-00.0  Device 1b36:0008
>            +-01.0  Device 1af4:1000
>            +-02.0  Device 1af4:1009
>            \-03.0  Device 19e5:a251 <----- the related VF device
> estuary:/$ qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
> qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
> qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
> qemu-system-aarch64: warning: vfio 0000:75:00.1: Bus 'pcie.0' does not support hotplugging
> [...]
> 
> The rmmod process will be blocked until I kill the Qemu process. That's the only way if I
> want to end the rmmod.
> 
> So my question is: is such block reasonable? If the VF devcie is occupied or doesn't
> support hotplug in the Qemu, shouldn't we fail the rmmod and return something like -EBUSY
> rather than make the host blocked indefinitely?

Where would we return -EBUSY?  pci_driver.remove() returns void.
Without blocking, I think our only option would be to kill the user
process.
 
> Add the VF under a pcie root port will avoid this. Is it encouraged to always
> add the VF under a pcie root port rather than directly add it as an iEP?

Releasing a device via the vfio request interrupt is always a
cooperative process currently, the VM needs to be configured such that
the device is capable of being unplugged and the guest needs to respond
to the ejection request.  Thanks,

Alex

