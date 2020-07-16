Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74ED221B26
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 06:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgGPEQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 00:16:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44457 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725268AbgGPEQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 00:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594873016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Ws/bvBlPrSHgiEMY4ZGTUiU0N5vWtniAdnm87i3Ezo=;
        b=WwnSeZeRu+rbp9GiCrQOqnR8LcPJjf8iHKIOZyTKZdfnZBiWF7E+/NI+Zd7RUWHbL+yi9m
        iUgNsReUhjGGYEOohYEHIrPDCo9ysef1hHucLVLf+eOzmVA5FXEa5MLXQPapO1qlda4hC8
        2/CMY0Z8zB1/lhze4kpOsirHsHCngwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-nE8jI9fqMB-unS_d3M1xSA-1; Thu, 16 Jul 2020 00:16:50 -0400
X-MC-Unique: nE8jI9fqMB-unS_d3M1xSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 523AE18A1DE9;
        Thu, 16 Jul 2020 04:16:47 +0000 (UTC)
Received: from [10.72.12.131] (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2B3160C84;
        Thu, 16 Jul 2020 04:16:28 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Yan Zhao <yan.y.zhao@intel.com>, devel@ovirt.org,
        openstack-discuss@lists.openstack.org, libvir-list@redhat.com
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, berrange@redhat.com, smooney@redhat.com,
        eskultet@redhat.com, alex.williamson@redhat.com, cohuck@redhat.com,
        dinechin@redhat.com, corbet@lwn.net, kwankhede@nvidia.com,
        dgilbert@redhat.com, eauger@redhat.com, jian-feng.ding@intel.com,
        hejie.xu@intel.com, kevin.tian@intel.com, zhenyuw@linux.intel.com,
        bao.yumeng@zte.com.cn, xin-ran.wang@intel.com,
        shaohe.feng@intel.com
References: <20200713232957.GD5955@joy-OptiPlex-7040>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
Date:   Thu, 16 Jul 2020 12:16:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713232957.GD5955@joy-OptiPlex-7040>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/7/14 上午7:29, Yan Zhao wrote:
> hi folks,
> we are defining a device migration compatibility interface that helps upper
> layer stack like openstack/ovirt/libvirt to check if two devices are
> live migration compatible.
> The "devices" here could be MDEVs, physical devices, or hybrid of the two.
> e.g. we could use it to check whether
> - a src MDEV can migrate to a target MDEV,
> - a src VF in SRIOV can migrate to a target VF in SRIOV,
> - a src MDEV can migration to a target VF in SRIOV.
>    (e.g. SIOV/SRIOV backward compatibility case)
>
> The upper layer stack could use this interface as the last step to check
> if one device is able to migrate to another device before triggering a real
> live migration procedure.
> we are not sure if this interface is of value or help to you. please don't
> hesitate to drop your valuable comments.
>
>
> (1) interface definition
> The interface is defined in below way:
>
>               __    userspace
>                /\              \
>               /                 \write
>              / read              \
>     ________/__________       ___\|/_____________
>    | migration_version |     | migration_version |-->check migration
>    ---------------------     ---------------------   compatibility
>       device A                    device B
>
>
> a device attribute named migration_version is defined under each device's
> sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version).


Are you aware of the devlink based device management interface that is 
proposed upstream? I think it has many advantages over sysfs, do you 
consider to switch to that?


> userspace tools read the migration_version as a string from the source device,
> and write it to the migration_version sysfs attribute in the target device.
>
> The userspace should treat ANY of below conditions as two devices not compatible:
> - any one of the two devices does not have a migration_version attribute
> - error when reading from migration_version attribute of one device
> - error when writing migration_version string of one device to
>    migration_version attribute of the other device
>
> The string read from migration_version attribute is defined by device vendor
> driver and is completely opaque to the userspace.


My understanding is that something opaque to userspace is not the 
philosophy of Linux. Instead of having a generic API but opaque value, 
why not do in a vendor specific way like:

1) exposing the device capability in a vendor specific way via 
sysfs/devlink or other API
2) management read capability in both src and dst and determine whether 
we can do the migration

This is the way we plan to do with vDPA.

Thanks


> for a Intel vGPU, string format can be defined like
> "parent device PCI ID" + "version of gvt driver" + "mdev type" + "aggregator count".
>
> for an NVMe VF connecting to a remote storage. it could be
> "PCI ID" + "driver version" + "configured remote storage URL"
>
> for a QAT VF, it may be
> "PCI ID" + "driver version" + "supported encryption set".
>
> (to avoid namespace confliction from each vendor, we may prefix a driver name to
> each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_8-1)
>
>
> (2) backgrounds
>
> The reason we hope the migration_version string is opaque to the userspace
> is that it is hard to generalize standard comparing fields and comparing
> methods for different devices from different vendors.
> Though userspace now could still do a simple string compare to check if
> two devices are compatible, and result should also be right, it's still
> too limited as it excludes the possible candidate whose migration_version
> string fails to be equal.
> e.g. an MDEV with mdev_type_1, aggregator count 3 is probably compatible
> with another MDEV with mdev_type_3, aggregator count 1, even their
> migration_version strings are not equal.
> (assumed mdev_type_3 is of 3 times equal resources of mdev_type_1).
>
> besides that, driver version + configured resources are all elements demanding
> to take into account.
>
> So, we hope leaving the freedom to vendor driver and let it make the final decision
> in a simple reading from source side and writing for test in the target side way.
>
>
> we then think the device compatibility issues for live migration with assigned
> devices can be divided into two steps:
> a. management tools filter out possible migration target devices.
>     Tags could be created according to info from product specification.
>     we think openstack/ovirt may have vendor proprietary components to create
>     those customized tags for each product from each vendor.
>     e.g.
>     for Intel vGPU, with a vGPU(a MDEV device) in source side, the tags to
>     search target vGPU are like:
>     a tag for compatible parent PCI IDs,
>     a tag for a range of gvt driver versions,
>     a tag for a range of mdev type + aggregator count
>
>     for NVMe VF, the tags to search target VF may be like:
>     a tag for compatible PCI IDs,
>     a tag for a range of driver versions,
>     a tag for URL of configured remote storage.
>
> b. with the output from step a, openstack/ovirt/libvirt could use our proposed
>     device migration compatibility interface to make sure the two devices are
>     indeed live migration compatible before launching the real live migration
>     process to start stream copying, src device stopping and target device
>     resuming.
>     It is supposed that this step would not bring any performance penalty as
>     -in kernel it's just a simple string decoding and comparing
>     -in openstack/ovirt, it could be done by extending current function
>      check_can_live_migrate_destination, along side claiming target resources.[1]
>
>
> [1] https://specs.openstack.org/openstack/nova-specs/specs/stein/approved/libvirt-neutron-sriov-livemigration.html
>
> Thanks
> Yan
>

