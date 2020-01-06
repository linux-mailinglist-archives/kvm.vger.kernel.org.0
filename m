Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92404131BAB
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgAFWk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 17:40:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726742AbgAFWk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 17:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578350458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBbAbpkjrTzANgPT/NBsopjzqfAgjde8LEv/Bht0csk=;
        b=TWKv+S0+9SeN81C4FYrOCaYWCzx80v7wVUj8B86ktM4UFC9C3apusr16bNCDeP2Wrvb+m1
        Aikn6YEqyX1uvl6Q6VcmQ60XJKztw2MLGYDkpodRuHN45lHOqkrXoPic1nMYUi4RwWBmDT
        INH0B+quyj3fcgT8/GFXuxIO0tSP3rQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-mrZzEpgGOGaC8Q9ypDRg6w-1; Mon, 06 Jan 2020 17:40:56 -0500
X-MC-Unique: mrZzEpgGOGaC8Q9ypDRg6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD431189CD01;
        Mon,  6 Jan 2020 22:40:55 +0000 (UTC)
Received: from w520.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1DE15C1B2;
        Mon,  6 Jan 2020 22:40:55 +0000 (UTC)
Date:   Mon, 6 Jan 2020 15:40:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Renjun Wang <rwang@panyi.ai>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: VFIO PROBLEM: pci_alloc_irq_vectors function request 32 MSI
 interrupts vectors, but return 1 in KVM virtual machine.
Message-ID: <20200106154055.294322d0@w520.home>
In-Reply-To: <BJXPR01MB0534C845ED8D3942E95E7BC7DE250@BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn>
References: <BJXPR01MB0534C845ED8D3942E95E7BC7DE250@BJXPR01MB0534.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 28 Dec 2019 01:59:43 +0000
Renjun Wang <rwang@panyi.ai> wrote:

> Hi all:
> I have a question about PCI which troubled me for a few weeks.
> I have a virtual machine with ubuntu 16.4.03 on KVM platform. There
> is a PCIe device(Xilinx PCIe IP) plugged in the host machine, and
> passthrough to guest via VFIO feature. On the ubuntu operation
> system, I am developing the pcie driver. When I use
> pci_alloc_irq_vectors() function to allocate 32 msi vectors, but
> return 1. The command=C2=A0 `lspci -vvv` output shows MSI: Enable+
> Count=3D1/32 Maskable+ 64bit+
>=20
> there is a similar case
> https://stackoverflow.com/questions/49821599/multiple-msi-vectors-linux-p=
ci-alloc-irq-vectors-return-one-while-the-devi.
> But not working for KVM virtual machine.
>=20
> I do not known why the function=C2=A0 pci_alloc_irq_vectors() returns one=
 ?

When you say it's not working in the virtual machine with that
stackoverflow tip, does that mean your VM is running a Q35 machine type
with the intel-iommu device enabled in both QEMU and on the guest
command line?  You should see "IR-PCI-MSI" in /proc/interrupts on host
and guest for the interrupt type if the interrupt remapping is enabled.
Linux doesn't support multiple MSI vectors without some kind of
interrupt remapper support.  You probably have that on the host, but
you'll need it in the guest as well or else the guest kernel will limit
you to a single vector.

BTW, if you have any influence over the device, you really, really want
to use MSI-X for supporting multiple vectors.  Thanks,

Alex

