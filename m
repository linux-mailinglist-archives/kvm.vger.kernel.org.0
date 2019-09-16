Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB73B36B4
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 10:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbfIPIz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 04:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfIPIz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 04:55:29 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E26584ACA7;
        Mon, 16 Sep 2019 08:55:28 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03084196B2;
        Mon, 16 Sep 2019 08:55:20 +0000 (UTC)
Subject: Re: mdev live migration support with vfio-mdev-pci
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Cindy Lu <lulu@redhat.com>, lingshan.zhu@intel.com
References: <A2975661238FB949B60364EF0F2C25743A08FC3F@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5a21100f-6242-72f4-5ce7-94e13e1f3a5c@redhat.com>
Date:   Mon, 16 Sep 2019 16:55:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A08FC3F@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 16 Sep 2019 08:55:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/9/9 下午7:41, Liu, Yi L wrote:
> Hi Alex,
>
> Recently, we had an internal discussion on mdev live migration support
> for SR-IOV. The usage is to wrap VF as mdev and make it migrate-able
> when passthru to VMs. It is very alike with the vfio-mdev-pci sample
> driver work which also wraps PF/VF as mdev. But there is gap. Current
> vfio-mdev-pci driver is a generic driver which has no ability to support
> customized regions. e.g. state save/restore or dirty page region which is
> important in live migration. To support the usage, there are two directions:
>
> 1) extend vfio-mdev-pci driver to expose interface, let vendor specific
> in-kernel module (not driver) to register some ops for live migration.
> Thus to support customized regions. In this direction, vfio-mdev-pci
> driver will be in charge of the hardware. The in-kernel vendor specific
> module is just to provide customized region emulation.
> - Pros: it will be helpful if we want to expose some user-space ABI in
>          future since it is a generic driver.
> - Cons: no apparent cons per me, may keep me honest, my folks.
>
> 2) further abstract out the generic parts in vfio-mdev-driver to be a library
> and let vendor driver to call the interfaces exposed by this library. e.g.
> provides APIs to wrap a VF as mdev and make a non-singleton iommu
> group to be vfio viable when a vendor driver wants to wrap a VF as a
> mdev. In this direction, device driver still in charge of hardware.
> - Pros: devices driver still owns the device, which looks to be more
>          "reasonable".
> - Cons: no apparent cons, may be unable to have unified user space ABI if
>          it's needed in future.
>
> Any thoughts on the above usage and the two directions? Also, Kevin, Yan,
> Shaopeng could keep me honest if anything missed.
>
> Best Wishes,
> Yi Liu


Actually, we had option 3:

3) High level abstraction of the device instead of a bus specific one 
(e.g PCI). For hardware that can do virtio on its datapath, we want to 
go this way. This means, we won't expose a pci device for userspace, 
instead, we will expose a vhost device for userspace which already had 
API for e.g dirty page logging and vring state set/get etc.

Thanks

