Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD521225635
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 05:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgGTDmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jul 2020 23:42:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726109AbgGTDmO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jul 2020 23:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595216532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EZ6v8Qo3QLXwwkVnkRqwS4KPkViLK16pSV3DgXs46os=;
        b=CXp3F46fch5Tsfm+hvXsh9YI3RMkiCR+MpnbvWdCtSh80/3huTMp2CyxLixpVdqw3/8hCQ
        lsAXbrTfrBoMfUwXFXkozamDEJKoltFWPpi5DyU3pPk/xIzxbPTCdr4n8WUE8pXEfSbDnh
        FYU56GOrktxttGeZG6/mEq6AHb7vEjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-fHIGCciNPr2PUyvRCJqAxA-1; Sun, 19 Jul 2020 23:42:11 -0400
X-MC-Unique: fHIGCciNPr2PUyvRCJqAxA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A08B81080;
        Mon, 20 Jul 2020 03:42:08 +0000 (UTC)
Received: from [10.72.13.139] (ovpn-13-139.pek2.redhat.com [10.72.13.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E58B66842F;
        Mon, 20 Jul 2020 03:41:48 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Cc:     devel@ovirt.org, openstack-discuss@lists.openstack.org,
        libvir-list@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, berrange@redhat.com,
        smooney@redhat.com, eskultet@redhat.com, cohuck@redhat.com,
        dinechin@redhat.com, corbet@lwn.net, kwankhede@nvidia.com,
        dgilbert@redhat.com, eauger@redhat.com, jian-feng.ding@intel.com,
        hejie.xu@intel.com, kevin.tian@intel.com, zhenyuw@linux.intel.com,
        bao.yumeng@zte.com.cn, xin-ran.wang@intel.com,
        shaohe.feng@intel.com
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
 <20200716083230.GA25316@joy-OptiPlex-7040> <20200717101258.65555978@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <95c13c9b-daab-469b-f244-a0f741f1b41d@redhat.com>
Date:   Mon, 20 Jul 2020 11:41:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717101258.65555978@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/7/18 上午12:12, Alex Williamson wrote:
> On Thu, 16 Jul 2020 16:32:30 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
>
>> On Thu, Jul 16, 2020 at 12:16:26PM +0800, Jason Wang wrote:
>>> On 2020/7/14 上午7:29, Yan Zhao wrote:
>>>> hi folks,
>>>> we are defining a device migration compatibility interface that helps upper
>>>> layer stack like openstack/ovirt/libvirt to check if two devices are
>>>> live migration compatible.
>>>> The "devices" here could be MDEVs, physical devices, or hybrid of the two.
>>>> e.g. we could use it to check whether
>>>> - a src MDEV can migrate to a target MDEV,
>>>> - a src VF in SRIOV can migrate to a target VF in SRIOV,
>>>> - a src MDEV can migration to a target VF in SRIOV.
>>>>     (e.g. SIOV/SRIOV backward compatibility case)
>>>>
>>>> The upper layer stack could use this interface as the last step to check
>>>> if one device is able to migrate to another device before triggering a real
>>>> live migration procedure.
>>>> we are not sure if this interface is of value or help to you. please don't
>>>> hesitate to drop your valuable comments.
>>>>
>>>>
>>>> (1) interface definition
>>>> The interface is defined in below way:
>>>>
>>>>                __    userspace
>>>>                 /\              \
>>>>                /                 \write
>>>>               / read              \
>>>>      ________/__________       ___\|/_____________
>>>>     | migration_version |     | migration_version |-->check migration
>>>>     ---------------------     ---------------------   compatibility
>>>>        device A                    device B
>>>>
>>>>
>>>> a device attribute named migration_version is defined under each device's
>>>> sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version).
>>>
>>> Are you aware of the devlink based device management interface that is
>>> proposed upstream? I think it has many advantages over sysfs, do you
>>> consider to switch to that?
>
> Advantages, such as?


My understanding for devlink(netlink) over sysfs (some are mentioned at 
the time of vDPA sysfs mgmt API discussion) are:

- existing users (NIC, crypto, SCSI, ib), mature and stable
- much better error reporting (ext_ack other than string or errno)
- namespace aware
- do not couple with kobject

Thanks

