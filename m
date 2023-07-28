Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34022767277
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 18:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbjG1QyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 12:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbjG1Qxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 12:53:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037884C01
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 09:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690563077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVxtwXqYr8lrv0pmMCjil7p6P48PJ9MKO6jsFNT5N+o=;
        b=fXbsfKFixTtlBAtU38YooLz7HvNe///nds07ELEGCsFP/c6fuNvY9F1KfEwYfKCrb7qiBf
        dvZkLUovFpLr+YnyYgcm0N0TCkn5l5lxQlmoj6enwxjFSyFL+kyJritTX0s4KxbbOma7xm
        1KHNoCBlXyu/xoUcTyIxKayjVpUn3fM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-LuCB8J1nNh6Imyt8_c1wUA-1; Fri, 28 Jul 2023 12:51:15 -0400
X-MC-Unique: LuCB8J1nNh6Imyt8_c1wUA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-786a1843eedso160407139f.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 09:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690563074; x=1691167874;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KVxtwXqYr8lrv0pmMCjil7p6P48PJ9MKO6jsFNT5N+o=;
        b=LdxxvRc7JmreDsIXMPthxomfrOZxIKHonUwqfU43/0r+yOy73SIwgsja1tPlp9TgL8
         UPrq3qZ7km7wXaN5DfS5oPLvwdO3xjvyaqlxVpO5KSJjtoEI830FCyVhxei9Wrd+kVn0
         /ry+OzAcBkS48j58FufPV4pMQ8f3s7DzGcCn0VTrgj7VXxLhXQDivZGhc9xdQ0Bir0up
         j3fWQclFQlFJI6khFpD9iDJrBekUVcnrMXNUSJqMG16RvguwpBo75fKOXmXS+K+9CzFc
         uvbGVdGr6n83JfxmFqvU+m9HL6QX3290YpCqHG/zv9yQSdEhJQzwHsj/zy0Oyb9qNnJi
         CwEA==
X-Gm-Message-State: ABy/qLbpbFTSd9EK6H74tKqTHAg8SkEEsk62xo5kVDaE0h5kqpkJ2yCa
        9pGY+j5CWGJ5R+O7fUI0E4LXRJJ+YdvXngVyJlcMeZG13JW2l1r2Qh1lyPG3dt9vtVYQ/nL/Caq
        roBnm8wDBftPqtOvpGizs
X-Received: by 2002:a05:6e02:1211:b0:348:db55:290d with SMTP id a17-20020a056e02121100b00348db55290dmr76795ilq.29.1690563074270;
        Fri, 28 Jul 2023 09:51:14 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHx8OkN9zaqxrtONmiknfLTK+wDzrvGE+O4rEMNsPsKok21alG7LNji9XT0sUKq+vkOMsdwMw==
X-Received: by 2002:a05:6e02:1211:b0:348:db55:290d with SMTP id a17-20020a056e02121100b00348db55290dmr76784ilq.29.1690563074012;
        Fri, 28 Jul 2023 09:51:14 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id b5-20020a92db05000000b00345ffd35a29sm1277309iln.68.2023.07.28.09.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:51:13 -0700 (PDT)
Date:   Fri, 28 Jul 2023 10:51:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Normand Leclerc <leclercnorm@sympatico.ca>
Cc:     kvm@vger.kernel.org
Subject: Re: KVM PCI Passthrough IRQ issues
Message-ID: <20230728105111.3b0f89ac.alex.williamson@redhat.com>
In-Reply-To: <BA42560B-B6B1-44B6-994E-AA9B48E9F5E0@sympatico.ca>
References: <BA42560B-B6B1-44B6-994E-AA9B48E9F5E0@sympatico.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 06:20:36 -0400
Normand Leclerc <leclercnorm@sympatico.ca> wrote:

> Hi,
>=20
> I have a CameraLink capture card of which I do not have Linux
> drivers.  I wanted to used it in Windows 11 under KVM.
>=20
> I have managed to have the card recognized in the OS, installed
> drivers and the system does see the clock and data valid; great!  But
> this doesn=E2=80=99t happen without hickups; KVM has to be started twice.
> The first time KVM starts, the driver tells me that there is not
> enough ressources for the API.
>=20
> Even though the card seems to be working well, I cannot capture
> anything.  The software is not able to fully use the card.
>=20
> The system is:
> AMD Ryzen 7950x3d
> ASROCK Steel Legend x670e
> Teledyne XTIUM-CL MX4 (capture card)
> Archlinux system (Linux omega 6.4.6-artix1-1 #1 SMP PREEMPT_DYNAMIC
> Wed, 26 Jul 2023 13:47:50 +0000 x86_64 GNU/Linux)
>=20
> lspci after boot for the card:
>=20
> 01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
>         Flags: fast devsel, IRQ 255, IOMMU group 12
>         Memory at fb000000 (32-bit, non-prefetchable) [disabled]
> [size=3D16M] Capabilities: [80] Power Management version 3
>         Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit+
>         Capabilities: [c0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [150] Device Serial Number
> 00-00-00-00-00-00-00-00 Capabilities: [300] Secondary PCI Express
>=20
>=20
> After vfio driver assignment:
>=20
> 01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
>         Flags: fast devsel, IRQ 255, IOMMU group 12
>         Memory at fb000000 (32-bit, non-prefetchable) [disabled]
> [size=3D16M] Capabilities: [80] Power Management version 3
>         Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit+
>         Capabilities: [c0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [150] Device Serial Number
> 00-00-00-00-00-00-00-00 Capabilities: [300] Secondary PCI Express
>         Kernel driver in use: vfio-pci
>=20
> Starting KVM first time (second time is the same):
>=20
> 01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
>         Flags: fast devsel, IRQ 135, IOMMU group 12
>         Memory at fb000000 (32-bit, non-prefetchable) [disabled]
> [size=3D16M] Capabilities: [80] Power Management version 3
>         Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit+
>         Capabilities: [c0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [150] Device Serial Number
> 00-00-00-00-00-00-00-00 Capabilities: [300] Secondary PCI Express
>         Kernel driver in use: vfio-pci
>=20
> First time KVM starts, lsirq does not show IRQ 135; second time, it
> does.
>=20
> If kernel has not been started with irqpoll, I get the infamous
> =E2=80=9Cnobody cared=E2=80=9D message and irq135 gets disabled.  Running=
 kernel with
> irqpoll, lsirq shows a whole bunch on interrupts (probably at each
> frame the grabber sees).
>=20
> It is as if the interrupt assigned to the card is not what KVM is
> using to pass down to the guest Windows machine.  The interrupt does
> not get to the capture card=E2=80=99s software and it fails.

The "irqpoll" option the kernel suggests for spurious interrupts really
doesn't work with device assignment.  It sounds like INTx disable
and/or status reporting is broken on this device.  The device supports
MSI, but clearly doesn't seem to be using it.  You can read a bit about
how vfio interrupts work and how you might make Windows use MSI here:

http://vfio.blogspot.com/2014/09/vfio-interrupts-and-how-to-coax-windows.ht=
ml

Another option is to use the nointxmask=3D1 option of the vfio-pci module
which will register the legacy INTx interrupt of the device as
exclusive.  This removes our dependency on working INTx disable and
status reporting, but it comes at the cost of sometimes being very
difficult to configure.  You might need to install the card into a
different slot or potentially even disable other drivers for devices
that try to share the interrupt line with this device.  Thanks,

Alex

