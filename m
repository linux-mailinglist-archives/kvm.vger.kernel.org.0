Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0738C2FF057
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 17:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbhAUQay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 11:30:54 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:35694 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733264AbhAUQ3z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 11:29:55 -0500
X-Greylist: delayed 1183 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2021 11:29:53 EST
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10LG3LsP028599;
        Thu, 21 Jan 2021 08:09:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Zjiqr8nfwvucEVZPHEElIOOdN7ztxYkwPFaaTBI3e9M=;
 b=IUUZWTBWIwvkdO96EtZjGzN2jpp1Z9cdf2fqslPHl3NBuUwAZvYzm1J5E1rDIwSkZpHu
 7PN9IdY7YozxKa6zgJeXR2CveC1j7i88LRXb/dn/chJVuS4EgykyR9eCuAzToTdPvO9E
 76kGkZNw6kTjAhyO8++kcisM3telHux+3ZyYx2k1kcX+FHIZFLxMDyZqE9iDmzmWQEV2
 3il/YhEjfCplmw3pDD0RFhwKiGQE+9n1eC7C8L3ov8cC0ZXPObmZVF625EC5TK/4jzjf
 fKxS+Sm0IQAOXuRearm4nx6uIFjnA+SXLms33Rl0hUufDvuuoUBBqleefkFW4o7k3REf fw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3668p9vqc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:09:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzathp+sArlEIPN1+ntnWuHaRX5kVEzLkwdwNi9J8kTRejOXgZv9l2eU0vwRz3Do0BVDDhz7P1HgKgY+4o50pgcRo+yrQQMDP26Ki85eEPxfRTUAfn0Qfc9bl2h5DxdUOVV8f9KFghWuPAx72YARWcEdNnbxABdGQeKPnO6SYoUJnlQzmvebh+hcDUVF18yXmvU0vG0RH9GxCGNJI9Raj9TSE5D25VOryitcGZCX/vRjFb8q1hVqplJKR0QeXguP7K3b2X+MgNIHH/WLqDtLcH4twyq9ogldnAxQo7gLz2zDAH+ZZ9YgXkmmHg0KsVyoQvVPe9lVA4UGHn5fR6tNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zjiqr8nfwvucEVZPHEElIOOdN7ztxYkwPFaaTBI3e9M=;
 b=cZH+Z1GhYJ3CjnN6hH7cgSqiwX6DGyyZ7EdND75/ZlrK9kwv/CSmfVg2dK4HPfm+Tbqgu8hc/U+HGzoJULzcx/9pRgptbWvGDj2AkWr8WVBVXcx6GDQ+FxH7+Sqg0StWbYcPuNeWY3tWNON4QIHwWfMtBhkR1VZ6qT0FEPnQCI5EKS/FR0r/316sRn2vRpxcYFUeKOm6r1PUdb9scTxXF0jICL55nRc1fWVK5cbBEqLMWVEKreZgmz9xRspZYI0kiRAEVPInuJtpIYw9HwPQNKaupVurDtkmDe8hTZt5brtWjtdk0+KH3cxO6zRxv+++K4jzTC09VF4/x1B9uO5btg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4580.namprd02.prod.outlook.com (2603:10b6:208:40::27)
 by BL0PR02MB3745.namprd02.prod.outlook.com (2603:10b6:207:43::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 16:09:09 +0000
Received: from BL0PR02MB4580.namprd02.prod.outlook.com
 ([fe80::d853:efb7:2d8b:f191]) by BL0PR02MB4580.namprd02.prod.outlook.com
 ([fe80::d853:efb7:2d8b:f191%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 16:09:09 +0000
From:   John Levon <john.levon@nutanix.com>
To:     "libvfio-user-devel@nongnu.org" <libvfio-user-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: [DRAFT RFC] ioeventfd/ioregionfd support in vfio-user
Thread-Topic: [DRAFT RFC] ioeventfd/ioregionfd support in vfio-user
Thread-Index: AQHW8A/A4RU7AycUJk25Cn4pd6oBpg==
Date:   Thu, 21 Jan 2021 16:09:09 +0000
Message-ID: <20210121160905.GA314820@sent>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [88.98.93.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e4607d1-0576-4932-d710-08d8be26e292
x-ms-traffictypediagnostic: BL0PR02MB3745:
x-microsoft-antispam-prvs: <BL0PR02MB3745DD868834FF6E7826334997A19@BL0PR02MB3745.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BLj0Llqr6M7zxX8kX8KaHee5PInjWng9jie2ZJOZuoTBEHdMa40XYS3sJLa+n49Stp95Tx2yafcS5CgOngJjMtKkgt9W4+Pf7f6fx+gS/vBp0deT5rPfJjc90kPhAycNKDnrtsT0ZCZ1Mis+kthLEZAO/iMPfMbNCfxv/QZXH9AFTFSHGaRG4pFlFtGQrlgqLux3HeLILUo5c3kP9blPptmJpltdYaZE40guPUb695MCkFh1TBvjUdS+yamVRw5ssN26Jh+DpKbftpAXy+B425LFfeGCKgeAaNL1OlhvAO/ty1bIVuXnfxhSKCfr9/DkeSI3tzY1JCtzn43pQ++20TIt2u3fY70BuEIyAyyfYLE5uFa3nuXVvkFbGNtgqFoV4FszHxYwxcOiaXzGvQFC+Ml6XTfTb8ZTTFu368m7JLQOn48HUl+7OEGicvpLP5f67/d3nibvdnZsUI3jbrI3vRZZESupgTsQwIl+in79AesXK8ji8sa+kvCKROMCrJXMnFq82VbTi0jNcQcn/aRef1FPaSbz/xgjkJjDZJ9GThIRzrpbB1FYzsSWbFa2gSWx6hvpgKtFIL8NNq7AF0nvNhEu0MzT1jD0+2mOawNdaRw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4580.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(396003)(136003)(346002)(376002)(366004)(39860400002)(110136005)(83380400001)(8676002)(30864003)(316002)(5660300002)(33716001)(86362001)(8936002)(44832011)(76116006)(64756008)(186003)(26005)(91956017)(66556008)(66946007)(66476007)(66446008)(9686003)(478600001)(6486002)(2906002)(6512007)(1076003)(966005)(71200400001)(33656002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3Xve7U7bYFgy+oPTp5rCLlpnqKIy2banJZ+XJKboVw0HTn5RFyDWEgd6h9io?=
 =?us-ascii?Q?yJkYK5tFb55eyzseqkgn/NHeEeqr/uaVh57RXEPGQVzzeTdNrShAjxZ+YJDP?=
 =?us-ascii?Q?e9B7k1qP42eg5uT4aF40wDeQ1ZN8VKsIbiatgd/+j+W/0hFhRSLaF+id/GUB?=
 =?us-ascii?Q?cRympfis/mgHHSBRiRm/u33kYwNYzNBrO80+74qqrPUWSyXlToURXSjwbcMr?=
 =?us-ascii?Q?vwJDaNt3oN2ESw18u7jc7xyuNKyyZRYVFDvDvSbRLv1GJfPi1hXPxed09mBV?=
 =?us-ascii?Q?VXAxkqdptqWOCZnlQkydP6Hj6lP7TYL/+466r4YzJTdn3dzxkC4JbtS2Y2lg?=
 =?us-ascii?Q?ozaDyCrofb8eSSaUlihMNMMwF0puPLTZft1rZLR2U3vCuTLbUysNrTYX6iQe?=
 =?us-ascii?Q?dPEanv7AzWH7U23SBvD5cbHzPd4Dhoob8XgXIq02Fals4ueDonh4UAxu0jfg?=
 =?us-ascii?Q?6Jl16QBkgTly3+/dNuiPPGxaKzScn/6pcskzQVMtaBQ34NP+Jn8CXuEsMT+U?=
 =?us-ascii?Q?Ip/SroIyiudkOUoCCnCvhzdbGMeU4xaCsMG+puRQCiTpbx3m7pWoC2PuxEr0?=
 =?us-ascii?Q?hyyPylozcwBhoKtmZwup8s/kcVLjw3DOTZcZBPs2DGXB/9df/XtAUEhHF8pw?=
 =?us-ascii?Q?ZMzJ8w+zxdVjlsUVGUjWujgv0V3NLVPzbO1f+nKkgNKym5oUbch2fFw9oXjB?=
 =?us-ascii?Q?VLHXksX7mcXI4OJnZkfLNUBYAxiKysnuubgBrqGeC4KcMn9yPgo/hhSYdeLL?=
 =?us-ascii?Q?lV54urMepcz1IBNQynDQQGs4Rferrha9+xNR2R54Mzar+kdcx6/C+1gzTEvC?=
 =?us-ascii?Q?z0C/p1t0mjU/kMEBogUNsKjg3fcRG55if5dPpJQnpknKNCJA4WIMuU3nN/O/?=
 =?us-ascii?Q?O+aTHRZRJeS2z6jr6P6DxKUgeFfZ3gJpKGJ5mujrt3sjT9Wxv2cK96lsNQDg?=
 =?us-ascii?Q?dyh8HFBLkQVpV43tSdgUA2O3zIHRTDkLrEJGqUC2u6pC5Nkf8snXU3RCeH+m?=
 =?us-ascii?Q?UmZA7ZgbNdhtcAYIT2IzPJftTwWXDHQrzNhp99ylwk/ALABm+e3c/3WayblE?=
 =?us-ascii?Q?9hwNPaBG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E18E53B5570D2644AB65B224EA875FB7@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4580.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4607d1-0576-4932-d710-08d8be26e292
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 16:09:09.0804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aD9a8YYdk0zp8TxtuyGccYOd7rNB7sXCACBCSXTvY7cD/hk9FYCxVjAt8hOzm5s4VXQddmaxeYgCJlRKRD83wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3745
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi, please take a look. For context, this addition is against the current
https://github.com/nutanix/libvfio-user/blob/master/docs/vfio-user.rst
specification.

kvm@ readers: Stefan suggested this may be of interest from a VFIO point of
view, in case there is any potential cross-over in defining how to wire up =
these
fds.

Note that this is a new message instead of adding a new region capability t=
o
VFIO_USER_DEVICE_GET_REGION_INFO: with a new capability, there's no way for=
 the
server to know if ioeventfd/ioregionfd is actually used/requested by the cl=
ient
(the client would just have to close those fds if it didn't want to use FDs=
). An
explicit new call is much clearer for this.

The ioregionfd feature itself is at proposal stage, so there's a good chanc=
e of
further changes depending on that.

I also have these pending issues so far:

1) I'm not familiar with CCW bus, so don't know if
KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY flag makes sense or is supportable in
vfio-user context

2) if ioregionfd subsumes all ioeventfd use cases, we can remove the distin=
ction
from this API, and the client caller can translate to ioregionfd or ioevent=
fd as
needed

3) is it neccessary for the client to indicate support (e.g. lacking ioregi=
onfd
support) ?

4) (ioregionfd issue) region_id is 4 bytes, which seems a little awkward fr=
om
the server side: this has to encode both the region ID as well as the offse=
t of
the sub-region within that region. Can this be 64 bits wide?

thanks
john

(NB: I edited the diff so the new sections are more readable.)

diff --git a/docs/vfio-user.rst b/docs/vfio-user.rst
index e3adc7a..e7274a2 100644
--- a/docs/vfio-user.rst
+++ b/docs/vfio-user.rst
@@ -161,6 +161,17 @@ in the region info reply of a device-specific region. =
Such regions are reflected
 in ``struct vfio_device_info.num_regions``. Thus, for PCI devices this val=
ue can
 be equal to, or higher than, VFIO_PCI_NUM_REGIONS.
=20
+Region I/O via file descriptors
+-------------------------------
+
+For unmapped regions, region I/O from the client is done via
+VFIO_USER_REGION_READ/WRITE.  As an optimization, ioeventfds or ioregionfd=
s may
+be configured for sub-regions of some regions. A client may request inform=
ation
+on these sub-regions via VFIO_USER_DEVICE_GET_REGION_IO_FDS; by configurin=
g the
+returned file descriptors as ioeventfds or ioregionfds, the server can be
+directly notified of I/O (for example, by KVM) without taking a trip throu=
gh the
+client.
+
 Interrupts
 ^^^^^^^^^^
 The client uses VFIO_USER_DEVICE_GET_IRQ_INFO messages to query the server=
 for
@@ -293,37 +304,39 @@ Commands
 The following table lists the VFIO message command IDs, and whether the
 message command is sent from the client or the server.
=20
-+----------------------------------+---------+-------------------+
-| Name                             | Command | Request Direction |
-+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
-| VFIO_USER_VERSION                | 1       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DMA_MAP                | 2       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DMA_UNMAP              | 3       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DEVICE_GET_INFO        | 4       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DEVICE_GET_REGION_INFO | 5       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DEVICE_GET_IRQ_INFO    | 6       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DEVICE_SET_IRQS        | 7       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_REGION_READ            | 8       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_REGION_WRITE           | 9       | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DMA_READ               | 10      | server -> client  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DMA_WRITE              | 11      | server -> client  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_VM_INTERRUPT           | 12      | server -> client  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DEVICE_RESET           | 13      | client -> server  |
-+----------------------------------+---------+-------------------+
-| VFIO_USER_DIRTY_PAGES            | 14      | client -> server  |
-+----------------------------------+---------+-------------------+
++------------------------------------+---------+-------------------+
+| Name                               | Command | Request Direction |
++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
+| VFIO_USER_VERSION                  | 1       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DMA_MAP                  | 2       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DMA_UNMAP                | 3       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DEVICE_GET_INFO          | 4       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DEVICE_GET_REGION_INFO   | 5       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DEVICE_GET_REGION_IO_FDS | 6       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DEVICE_GET_IRQ_INFO      | 7       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DEVICE_SET_IRQS          | 8       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_REGION_READ              | 9       | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_REGION_WRITE             | 10      | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DMA_READ                 | 11      | server -> client  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DMA_WRITE                | 12      | server -> client  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_VM_INTERRUPT             | 13      | server -> client  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DEVICE_RESET             | 14      | client -> server  |
++------------------------------------+---------+-------------------+
+| VFIO_USER_DIRTY_PAGES              | 15      | client -> server  |
++------------------------------------+---------+-------------------+
=20
=20
 .. Note:: Some VFIO defines cannot be reused since their values are
@@ -1130,6 +1143,161 @@ client must write data on the same order and transc=
tion size as read.
 If an error occurs then the server must fail the read or write operation. =
It is
 an implementation detail of the client how to handle errors.
=20
VFIO_USER_DEVICE_GET_REGION_IO_FDS
----------------------------------

Message format
^^^^^^^^^^^^^^

+--------------+------------------------+
| Name         | Value                  |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
| Message ID   | <ID>                   |
+--------------+------------------------+
| Command      | 6                      |
+--------------+------------------------+
| Message size | 32 + subregion info    |
+--------------+------------------------+
| Flags        | Reply bit set in reply |
+--------------+------------------------+
| Error        | 0/errno                |
+--------------+------------------------+
| Region info  | Region IO FD info      |
+--------------+------------------------+

Clients can access regions via VFIO_USER_REGION_READ/WRITE or, if provided,=
 by
mmap()ing a file descriptor provided by the server.

VFIO_USER_DEVICE_GET_REGION_IO_FDS provides an alternative access mechanism=
 via
file descriptors. This is an optional feature intended for performance
improvements where an underlying sub-system (such as KVM) supports communic=
ation
across such file descriptors to the vfio-user server, without needing to
round-trip through the client.

The server returns an array describing sub-regions of the given region alon=
g
with the server specifies a set of sub-regions and the requested file descr=
iptor
notification mechanism to use for that sub-region.  Each sub-region in the
response message may choose to use a different method, as defined below.  T=
he
two mechanisms supported in this specification are ioeventfds and ioregionf=
ds.

A client should then hook up the returned file descriptors with the notific=
ation
method requested.

Region IO FD info format
^^^^^^^^^^^^^^^^^^^^^^^^

+------------+--------+------+
| Name       | Offset | Size |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D+
| argsz      | 16     | 4    |
+------------+--------+------+
| flags      | 20     | 4    |
+------------+--------+------+
| index      | 24     | 4    |
+------------+--------+------+
| count      | 28     | 4    |
+------------+--------+------+
| subregions | 32     | ...  |
+------------+--------+------+

* *argsz* is the size of the region IO FD info structure plus the
  total size of the subregion array. Thus, each array entry "i" is at offse=
t
    i * ((argsz - 32) / count)
* *flags* must be zero
* *index* is the index of memory region being queried
* *count* is the number of sub-regions in the array
* *subregions* is the array of Sub-Region IO FD info structures

The client must set ``flags`` to zero and specify the region being queried =
in
the ``index``.

The client sets the ``argsz`` field to indicate the maximum size of the res=
ponse
that the server can send, which must be at least the size of the response h=
eader
plus space for the subregion array. If the full response size exceeds ``arg=
sz``,
then the server must respond only with the response header and the Region I=
O FD
info structure, setting in ``argsz`` the buffer size required to store the =
full
response. In this case, no file descriptors are passed back.  The client th=
en
retries the operation with a larger receive buffer.

The reply message will additionally include at least one file descriptor in=
 the
ancillary data. Note that more than one subregion may share the same file
descriptor.

Each sub-region given in the response has one of two possible structures,
depending whether *type* is `VFIO_USER_IO_FD_TYPE_IOEVENTFD` or
`VFIO_USER_IO_FD_TYPE_IOREGIONFD`:

Sub-Region IO FD info format (ioeventfd)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

+-----------+--------+------+
| Name      | Offset | Size |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D+
| offset    | 0      | 8    |
+-----------+--------+------+
| size      | 8      | 8    |
+-----------+--------+------+
| fd_index  | 16     | 4    |
+-----------+--------+------+
| type      | 20     | 4    |
+-----------+--------+------+
| flags     | 24     | 4    |
+-----------+--------+------+
| padding   | 28     | 4    |
+-----------+--------+------+
| datamatch | 32     | 8    |
+-----------+--------+------+

* *offset* is the offset of the start of the sub-region within the region
  requested ("physical address offset" for the region)
* *size* is the length of the sub-region. This may be zero if the access si=
ze is
  not relevant, which may allow for optimizations
* *fd_index* is the index in the ancillary data of the FD to use for ioeven=
tfd
  notification; it may be shared.
* *type* is `VFIO_USER_IO_FD_TYPE_IOEVENTFD`
* *flags* is any of:
  * `KVM_IOEVENTFD_FLAG_DATAMATCH`
  * `KVM_IOEVENTFD_FLAG_PIO`
  * `KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY` (FIXME: makes sense?)
* *datamatch* is the datamatch value if needed

See https://www.kernel.org/doc/Documentation/virtual/kvm/api.txt 4.59
KVM_IOEVENTFD for further context on the ioeventfd-specific fields.

Sub-Region IO FD info format (ioregionfd)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

+-----------+--------+------+
| Name      | Offset | Size |
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=
=3D+
| offset    | 0      | 8    |
+-----------+--------+------+
| size      | 8      | 8    |
+-----------+--------+------+
| fd_index  | 16     | 4    |
+-----------+--------+------+
| type      | 20     | 4    |
+-----------+--------+------+
| flags     | 24     | 4    |
+-----------+--------+------+
| region_id | 28     | 4    |
+-----------+--------+------+

* *offset* is the offset of the start of the sub-region within the region
  requested ("physical address offset" for the region)
* *size* is the length of the sub-region. FIXME: may allow zero?
* *fd_index* is the index in the ancillary data of the FD to use for ioregi=
onfd
  messages; it may be shared
* *type* is `VFIO_USER_IO_FD_TYPE_IOREGIONFD`
* *flags* is any of:
  * `KVM_IOREGIONFD_FLAG_PIO`
  * `KVM_IOREGIONFD_FLAG_POSTED_WRITES`
* *region_id* is an opaque value passed back to the server via a message on=
 the
  file descriptor

See https://www.spinics.net/lists/kvm/msg208139.html (FIXME) for further co=
ntext
on the ioregionfd-specific fields.

 VFIO_USER_DEVICE_GET_IRQ_INFO
 -----------------------------
=20
@@ -1141,7 +1309,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 6                      |
+| Command      | 7                      |
 +--------------+------------------------+
 | Message size | 32                     |
 +--------------+------------------------+
@@ -1212,7 +1380,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 7                      |
+| Command      | 8                      |
 +--------------+------------------------+
 | Message size | 36 + any data          |
 +--------------+------------------------+
@@ -1370,7 +1538,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 8                      |
+| Command      | 9                      |
 +--------------+------------------------+
 | Message size | 32 + data size         |
 +--------------+------------------------+
@@ -1397,7 +1565,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 9                      |
+| Command      | 10                     |
 +--------------+------------------------+
 | Message size | 32 + data size         |
 +--------------+------------------------+
@@ -1424,7 +1592,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 10                     |
+| Command      | 11                     |
 +--------------+------------------------+
 | Message size | 28 + data size         |
 +--------------+------------------------+
@@ -1451,7 +1619,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 11                     |
+| Command      | 12                     |
 +--------------+------------------------+
 | Message size | 28 + data size         |
 +--------------+------------------------+
@@ -1478,7 +1646,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID     | <ID>                   |
 +----------------+------------------------+
-| Command        | 12                     |
+| Command        | 13                     |
 +----------------+------------------------+
 | Message size   | 20                     |
 +----------------+------------------------+
@@ -1515,7 +1683,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID   | <ID>                   |
 +--------------+------------------------+
-| Command      | 13                     |
+| Command      | 14                     |
 +--------------+------------------------+
 | Message size | 16                     |
 +--------------+------------------------+
@@ -1537,7 +1705,7 @@ Message format
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
 | Message ID         | <ID>                   |
 +--------------------+------------------------+
-| Command            | 14                     |
+| Command            | 15                     |
 +--------------------+------------------------+
 | Message size       | 16                     |
 +--------------------+------------------------+=
