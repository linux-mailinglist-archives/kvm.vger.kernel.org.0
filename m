Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71D2CD8B2
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgLCONP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:13:15 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9371 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLCONP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:13:15 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CmySw6GMnz786l;
        Thu,  3 Dec 2020 22:12:00 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 22:12:19 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC] vfio/migration: The way we start dirty tracking for the VFIO
 container?
To:     <qemu-devel@nongnu.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <kvm@vger.kernel.org>
Message-ID: <9ccefa79-72d3-1612-1627-3bfdf5e32f9e@huawei.com>
Date:   Thu, 3 Dec 2020 22:12:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

I'm looking at the way we start dirty tracking for the vfio container
(we start it at the save_setup stage of a device) and have a few
questions about it.  Please fix me up if I had missed something obvious.


- We may end up with the situation where we try to get dirty bitmap of
   the vfio container whilst the dirty tracking hasn't yet been enabled.

     ram_save_setup
         ram_init_bitmaps
             migration_bitmap_sync_precopy (i.e., vfio_listener_log_sync)
     vfio_save_setup
         vfio_migration_set_state += _SAVING
         vfio_set_dirty_page_tracking(true)

   Practically there is no problem since in vfio_listener_log_sync(), we
   will check that if all devices are having the _SAVING state *before*
   actually syncing dirty bitmap.  As we add _SAVING to the device state
   exactly before starting dirty tracking, we'll actually do nothing in
   the first run of vfio_listener_log_sync().

   But I'm wondering what prevents us from starting dirty tracking via
   the "standard" log_start() callback of the vfio container.


- Before start dirty tracking, we will check and ensure that the device
   is at _SAVING state and return error otherwise.  But the question is
   that what is the rationale?  Why does the VFIO_IOMMU_DIRTY_PAGES ioctl
   have something to do with the device state?

   VFIO_IOMMU_DIRTY_PAGES is clearly designed as a API for type1 VFIO
   IOMMU.  Is it possible that the *device* itself becomes the actual
   dirty bitmap provider of this ioctl (e.g., the device is smart enough
   to track its own dirty pages during migration)?  This is the only case
   I can think out where we may have to set the device to pre-copy state
   before starting dirty tracking, so that device can report dirty pages
   properly in response to the GET_BITMAP ioctl.  But afaict it isn't
   covered by the existing documentation [1][2]...

   Btw, it isn't clear that what possible dirty bitmap providers will be
   (IOMMU, devices, etc) behind the back of the VFIO_IOMMU_DIRTY_PAGES
   ioctl.  Although userspace can be unaware of any of this, it'd be
   appreciated if someone can clarify it.


- If there is indeed some dependency between the device state and the
   VFIO_IOMMU_DIRTY_PAGES_FLAG_START operation, shouldn't we check that
   *all* devices are now having the _SAVING state before START, rather
   than just checking the *given* device in its (per-device) save_setup
   stage?

[1] https://git.kernel.org/torvalds/c/a8a24f3f6e38
[2] https://git.kernel.org/torvalds/c/b704fd14a06f


Thanks,
Zenghui
