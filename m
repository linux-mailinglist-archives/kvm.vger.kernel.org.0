Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDBAD816
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 13:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404286AbfIILlu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Sep 2019 07:41:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:15678 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404284AbfIILlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 07:41:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 04:41:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,484,1559545200"; 
   d="scan'208";a="359463132"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga005.jf.intel.com with ESMTP; 09 Sep 2019 04:41:48 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Sep 2019 04:41:47 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Sep 2019 04:41:47 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.92]) with mapi id 14.03.0439.000;
 Mon, 9 Sep 2019 19:41:45 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: mdev live migration support with vfio-mdev-pci
Thread-Topic: mdev live migration support with vfio-mdev-pci
Thread-Index: AdVnA09V4FzczbJgRN2UKw0Ev4Ijjg==
Date:   Mon, 9 Sep 2019 11:41:45 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A08FC3F@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjNkNzYxNDgtZmE5Yy00M2EyLWE4ZjMtOTk1M2YzNTNmNDNlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibmd5QWZRMVdldVwva285aWpkYVliYjhkcWwwbzVJYXdBQ2hWUVpuZmlGN3Q0UnU4d0g3emJBTzNoYzBEb2NtWlUifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Recently, we had an internal discussion on mdev live migration support
for SR-IOV. The usage is to wrap VF as mdev and make it migrate-able
when passthru to VMs. It is very alike with the vfio-mdev-pci sample
driver work which also wraps PF/VF as mdev. But there is gap. Current
vfio-mdev-pci driver is a generic driver which has no ability to support
customized regions. e.g. state save/restore or dirty page region which is
important in live migration. To support the usage, there are two directions:

1) extend vfio-mdev-pci driver to expose interface, let vendor specific
in-kernel module (not driver) to register some ops for live migration.
Thus to support customized regions. In this direction, vfio-mdev-pci
driver will be in charge of the hardware. The in-kernel vendor specific
module is just to provide customized region emulation.
- Pros: it will be helpful if we want to expose some user-space ABI in
        future since it is a generic driver.
- Cons: no apparent cons per me, may keep me honest, my folks.

2) further abstract out the generic parts in vfio-mdev-driver to be a library
and let vendor driver to call the interfaces exposed by this library. e.g.
provides APIs to wrap a VF as mdev and make a non-singleton iommu
group to be vfio viable when a vendor driver wants to wrap a VF as a
mdev. In this direction, device driver still in charge of hardware.
- Pros: devices driver still owns the device, which looks to be more
        "reasonable".
- Cons: no apparent cons, may be unable to have unified user space ABI if
        it's needed in future.

Any thoughts on the above usage and the two directions? Also, Kevin, Yan,
Shaopeng could keep me honest if anything missed.

Best Wishes,
Yi Liu
