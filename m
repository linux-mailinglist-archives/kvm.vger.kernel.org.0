Return-Path: <kvm+bounces-52348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D00FB04513
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 18:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F15D7A6BD5
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4210F25EFBF;
	Mon, 14 Jul 2025 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lIqJtBKz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7832571C6
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752509316; cv=fail; b=FRnNyoi4TXHN0vEkEaZgmW0TTyhhb/bV7L9tqgC3fvP62l83pL3aDyTTvlexVfBwgIe3YYhQGzLV22PqtmJonpIXEufky2Uua7cNKZS/b0M5YhOWtt71xxT/dNI5vCI3a/Ah13fDxyuSi0fxn3isO9uFFhacTXwfJQoE2z+flqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752509316; c=relaxed/simple;
	bh=KtAHLoyLJ4HPEun9xqFXB4ahqOgHXTXoTRRDZTOJSuk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=h7CdZfwYInbxCz9a9X4xpBwtG4Hw1G+t6HsOBxkD5n1azeEDR9Q3LmZENhGUB0OX8nAYTOkYRND92dfaczKrD8PZ/1r81XUjxfqtbrmBCaKyhqN87RiRAuSUVudumieC0BORdIO+YQxLti7DGOr86RTVBSfBEjKVAirMTlroVGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lIqJtBKz; arc=fail smtp.client-ip=40.107.244.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvNzj6OWGfQTPx+iD7rYqP+ZBQFtz9F9i87a75waoGtTurbE0gH6SOBcfNjPO/FkUBIcCcey/a31F6DCgxd2LIYT9DG71Km6LC5Ky4kM69aGujnXrvpKhte6Oq3DOBsqQt3PJgrwI2nSPl+h7HHs0saP35Rq4PHLPRQuwcFajo2iD3UyW7hNY/H5ugtv+7OyZokV6JIkk8yotqtSapaVLkJE0BwXRhNidz5KSa3JS+l+Kj8J0Ib3CoOhT7XkGa3ZTh9A09SD+6I1zel9XQcVUMSN4qGtejCSkDf0MgGTgtnccSSzF+8U2rV0kNN8OqO0KYVpUSSaffM1TNA4dEOgZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YH5593dpow9WqF5gTP8KE0ivOpWmlcgXNaTdvTSA6Tg=;
 b=w5KbOZ8lE7vroGNaGRdCnC1/hb9uufYHAyWydWIWuNVUCOdsVFnGfhpHirRt+UowPVQQ2fXxbj0gFoeinNPNS7I7IUf1pK6zKoG8mdX8OJBwqdTGaFGx4s/le4YRmsBkgjTOohWVxR0KHvUyEOTAFUepib0BNYOFfvjiNPfRlg+MXZAagFMluwHd7z4H3WDHiHSnKfoEZXeBTdzUmQWItAr/4gZlPVjIlj5koaNfH+kwaqOk6U0idq0uIAWnaJk3UaHanOFSMxCyXCUhQNtcTz6nAJU5Zf2Rp+WSw78nHALMZEPfRUshwzZG6I7h1ovEWc5Zdt2vYFSc7kFWksXlAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YH5593dpow9WqF5gTP8KE0ivOpWmlcgXNaTdvTSA6Tg=;
 b=lIqJtBKzNsRLcKrNIsAYZM8voFhnwViCRu2iqVEz+1Fjj4zvS1n7OvuD6gvLZKqL2P1KNvFGJKcK9gwaqjp4ZNIZb1hJkLVoclXusY5BbkQdQZGe9VhJxGzZl/f9Q6hbvJkgw5n4gdGeH5qqbcJw55L3bQrLRs6W4L7bInWkDoZ53G5xjDTTkwDv1u7YAi2pCJWC7f+x7UoGHSDatJOysH73Vjmzn4m9VQSh3n0mTjUUWHuAFZiaV3BTRMBcr/TlLrjRkHXm460MghscoWUEqZSHgbwzHNLLPoEU0IKECQWy+s0864xGp3+ipQg7qFbHkQM5Q1AeHuKaVZzZWq4KQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ5PPF1C7838BF6.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 14 Jul
 2025 16:08:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 16:08:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	qat-linux@intel.com,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	virtualization@lists.linux.dev,
	Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Date: Mon, 14 Jul 2025 13:08:25 -0300
Message-ID: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:208:23c::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ5PPF1C7838BF6:EE_
X-MS-Office365-Filtering-Correlation-Id: b7dc3832-3781-4bc0-1f9b-08ddc2f0aa6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s/GBPyLHVM25xoZndE5icTroiCAW71faEqq+a5Mfow88sXTYtz2EtFtL3t8q?=
 =?us-ascii?Q?h5y0ScidWP0DLzf9g14I0HomcFqkA3n9hFT8uTj4J1iD3NBkQ2YIytTQBenm?=
 =?us-ascii?Q?E44whqbpehU+KJzJ8eHE3E5RZ3GHXFy9yWlM6V0dGXJGdtFXWOUuNHfMnSi+?=
 =?us-ascii?Q?x9y+wlMookH9KeqKND1dYcsfObILgEnKfAoZ6k9alugNrPQol9etFElg9rKv?=
 =?us-ascii?Q?wPF10fMVMQsnHB3yKpreLuUhIrcybfC3yNLp7TEojjHSKNTSGlvI6zRSoT67?=
 =?us-ascii?Q?t7e+wUYQG5sZt8xD55bxoOecJySeuKCNlrL+WdEVuRifVi6dpR4jOuAIZ3Sv?=
 =?us-ascii?Q?+sKGmk5aBwMHIVQlGK6IPMspwElJ7iV1o4xX6CO9uB4tyEBEciLj6l+YEoxY?=
 =?us-ascii?Q?uLC6DStbxieym9E+1IYZerIT06WNNxd8eW3w2LTAYiT69gyZkvZrU/whj9Sn?=
 =?us-ascii?Q?FVsbb1Fx5ksdH0TxLT54hfiliCbxQ+vtNjHbfe59TFVxK6fL1KVouFjM69V1?=
 =?us-ascii?Q?0ot+SLOhcXINHv1QoHuoEbeQUsyeHII1jN1aHyXNCRLb0eE26YXl0BI4iyDq?=
 =?us-ascii?Q?/PjwG7Hcqn2al5aqlwSl+VTWaDSgY5mDRcGml4IcAGSYvR/lnTCcr8+rrzlu?=
 =?us-ascii?Q?s5uSC3YzkC65S0uREP4aQ75uiUghn2Avt98+XMJrWb7s8kYNrU1CE7HUrf+C?=
 =?us-ascii?Q?t5Lm7Xk5BTiY0Z6Ee+2CA6EMXO9rQ4gS2K5fxiVWyCTULzaXj+S+qC8JpKrQ?=
 =?us-ascii?Q?3BjLLhDRUP/qKT4vbrq2F7h3L1Rc1eXOPINp/tbe98HQpq7JckN4zZI9gYoD?=
 =?us-ascii?Q?I/vwQccvIKf4QSCJ6wBDzUdd7/Hq5AYh/Z9qeZb0cBEvUAKpvk+ApYcL9i5z?=
 =?us-ascii?Q?Ch7ysL8DYrrEdEQWLFgZ0HGPa1VCDLBSW7okh7sIJ469H9qOZ22u3pTeiS6m?=
 =?us-ascii?Q?S/jvOBC5btuXTmOqKzXkdwgBNl9EhNWiPjKz+OCTNVKDADTSZbLz+g+U+LOY?=
 =?us-ascii?Q?752hO3VZbELQiymwyYTy1wcNQcSbptbAxwx4CiwSTDPc+HmHwk/YGthDvp5F?=
 =?us-ascii?Q?fTV+weUh7+NrYGWAEBmagNZ98KtIjtAolqmPvK0cBixqhPBJURXVmVZXDX5D?=
 =?us-ascii?Q?mydEwAtyybqm3mhU93RCcuFyikGxTBDkmlVdMtwm1lUSd3G8qc35O0XUygDV?=
 =?us-ascii?Q?NK/YjnmRVcj31brBJNkygUVsQM7S09RKI18fZRxGTvpGyKcmJ+GFTaBGfSPq?=
 =?us-ascii?Q?bBKKSI2fhtmJpjcS094ilTJjKalmNvvNgRHupiIvSb66OqaULHdZ1it4etxU?=
 =?us-ascii?Q?K6OnLGqaF4e99E2laE/HTsLoQS9p6AIwRk9MHqQfP6BtG69m26SDOnpCoEkx?=
 =?us-ascii?Q?6VKk6QB3Q24LZebntnORtFVMGq8/7bfHXoc6EUHHaPgcdK34zGXB2lbvMVAQ?=
 =?us-ascii?Q?3YAQ59AK2hKC+CQzcDq86ROYoSH5lKIjuZKp6WTSnC0nAMF6eY0Z2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P6S7Yv97UWFcuxz6eX60CtcxYCWKDXjICA3cuVzTkKEIYgOjYWqrSAPo4aMk?=
 =?us-ascii?Q?mA7aESsFrn6bO7ozeEEHy5Z8iPxnsojNJC4BGVu3SOEjPNGu5EVMZhSnESbS?=
 =?us-ascii?Q?rAU3dkJnnxwbsy50igtNcpXFzBHyA26S4F+3Zn/SHi+Z7LBb9/hRz0YedtFT?=
 =?us-ascii?Q?fsADTLNOCl8KjZAu3XyFYai6KXr3RNH+zsanN87PL+M3PYRXxkvWx/9CYIml?=
 =?us-ascii?Q?58mc3K+G0om+udrkh0YEsj2zmw2IsJFe12++JGAl1XOllU6iyKd7AGL82QE/?=
 =?us-ascii?Q?pOgz8VpWY699Qo3tRV3Piu7r4L/MRFG+VUjglmYH1oH5bJJVwqG1SmrXSPEu?=
 =?us-ascii?Q?uPv5O+x1sAvnvSA3RORiPIr75QOW8ICv0EZG5kAVjU173HzRFBUZUURdED//?=
 =?us-ascii?Q?bUuBY1drH/WC2GTTdhr2aVyddUb2lZ/7ayat9dZz6sfTQvJVT79Zy+Rfk2B3?=
 =?us-ascii?Q?m1kXUs8PXEvkp0Y36V20aUrdxdN5jOjXLMFia/4Oemv3AZkeGajb38cO80Dj?=
 =?us-ascii?Q?s6s1A+xvDE+O27vO4+a1kPvIH+8J3zwahZraVdmx9OrSuPl4LeMgOgPdevfD?=
 =?us-ascii?Q?s1T4vsP1HhmFRogEGZLBFlyaUzKABfx58KmMaPqtfxmJ6FLeWoYsEXI+68rE?=
 =?us-ascii?Q?KGUx3HiWS4/m1Xs3Sl7vEGOSsOH5ifqO0pZsrQLfZnEAlOwqHExAgqvnMoHI?=
 =?us-ascii?Q?5lYT0TICbTXCwPcMtblImUzG1y4xRdCpdnZ1u7YhR99m6uzRqKVDYOjjleLn?=
 =?us-ascii?Q?3LrgamvXSO6OmyR2wz84urWBXbTHc+WnXlsFRYos/sCiZdQnwVuij6Gaq6rB?=
 =?us-ascii?Q?WlxdfLWP7n3iMfQRp/6JtM1y5Awu2BtFbJxIUdkOq9IhVtSbBWq0IvpafnLk?=
 =?us-ascii?Q?NAZolPmxoAI6CN4IDHzIHp3HfLtiZ4u6u7qSt84ZFGYPgkGQ6OA3hzUfBvpk?=
 =?us-ascii?Q?RfsKCuIH8lJCjAfGgva9hyMdOEIICiCTHgzShMijy5dZYtUWJbHopcJ3T2xH?=
 =?us-ascii?Q?QykDk/dn6Z6jo5SDR4ZGZea4rF7vv/OftWcUQIDrsHX15CR3zE/ipBRZ2EiA?=
 =?us-ascii?Q?yDLHmx+0pIsXfN1w0JrojultfkXsgPnhKlmwytbXIImxmXDkTAge3ieSfUYr?=
 =?us-ascii?Q?2J9leE8J6WCInF5StJCsXAJIv4EcljtoHqgbPTubJXy6TixQxXJVOpCGEjVT?=
 =?us-ascii?Q?e52WUerTPj/posYFnQFpvhE1CH58Mt+O6Sx9rc1YMDc82/IXpeVMfbgM85Uq?=
 =?us-ascii?Q?+G24DCeuQJhn6XHZqSBH2SPrXLWxbH6pmC/WeKZvc3D6Wj+RUkHqO0C/f3Zp?=
 =?us-ascii?Q?bzCxublEKaBwjCq/h6GUHMsJA6pUj2JGrX46IOXZ9HA1zOLcW/qCJ8PNq6Jv?=
 =?us-ascii?Q?uD99tNeKizqcNxYOSozK0TtU9vSc2b/wBSwBvF4ErLD/JDeEzUbH/x4XFliR?=
 =?us-ascii?Q?v2IoaN+ihIGr9CbXMDYzDuXMOCcsZuAlgJjiDJtUNWelmDTV9uzrcgeGtFEd?=
 =?us-ascii?Q?5B7cCgW0P+Qter4kniMSkdKgKR38ZMf7MsjiI/BucN4FMyDmyM/iyRZJMuG0?=
 =?us-ascii?Q?nl9jD3bO+8MvJBHE5r7qZTHSr7FnmAMFW089eKXS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7dc3832-3781-4bc0-1f9b-08ddc2f0aa6a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 16:08:26.6511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/8wTXZJjoWQwCTllgnh6dS6dvAfW6nhLX07CRFnRGWRCweCnfdsKM1HxpjoMl5S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1C7838BF6

This was missed during the initial implementation. The VFIO PCI encodes
the vf_token inside the device name when opening the device from the group
FD, something like:

  "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"

This is used to control access to a VF unless there is co-ordination with
the owner of the PF.

Since we no longer have a device name in the cdev path, pass the token
directly through VFIO_DEVICE_BIND_IOMMUFD using an optional field
indicated by VFIO_DEVICE_BIND_FLAG_TOKEN.

Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/device_cdev.c                    | 38 +++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  1 +
 drivers/vfio/pci/mlx5/main.c                  |  1 +
 drivers/vfio/pci/nvgrace-gpu/main.c           |  2 +
 drivers/vfio/pci/pds/vfio_dev.c               |  1 +
 drivers/vfio/pci/qat/main.c                   |  1 +
 drivers/vfio/pci/vfio_pci.c                   |  1 +
 drivers/vfio/pci/vfio_pci_core.c              | 22 +++++++----
 drivers/vfio/pci/virtio/main.c                |  3 ++
 include/linux/vfio.h                          |  4 ++
 include/linux/vfio_pci_core.h                 |  2 +
 include/uapi/linux/vfio.h                     | 12 +++++-
 12 files changed, 76 insertions(+), 12 deletions(-)

v3:
 - Fix user_size check
v2: https://lore.kernel.org/all/0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com
 - Revise VFIO_DEVICE_BIND_TOKEN -> VFIO_DEVICE_BIND_FLAG_TOKEN
 - Call the match_token_uuid through ops instead of directly
 - update comments/style
v1: https://patch.msgid.link/r/0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 281a8dc3ed4974..53a602563f002d 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -60,22 +60,50 @@ static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 	spin_unlock(&df->kvm_ref_lock);
 }
 
+static int vfio_df_check_token(struct vfio_device *device,
+			       const struct vfio_device_bind_iommufd *bind)
+{
+	uuid_t uuid;
+
+	if (!device->ops->match_token_uuid) {
+		if (bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN)
+			return -EINVAL;
+		return 0;
+	}
+
+	if (!(bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN))
+		return device->ops->match_token_uuid(device, NULL);
+
+	if (copy_from_user(&uuid, u64_to_user_ptr(bind->token_uuid_ptr),
+			   sizeof(uuid)))
+		return -EFAULT;
+	return device->ops->match_token_uuid(device, &uuid);
+}
+
 long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 				struct vfio_device_bind_iommufd __user *arg)
 {
+	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN;
 	struct vfio_device *device = df->device;
 	struct vfio_device_bind_iommufd bind;
 	unsigned long minsz;
+	u32 user_size;
 	int ret;
 
 	static_assert(__same_type(arg->out_devid, df->devid));
 
 	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
 
-	if (copy_from_user(&bind, arg, minsz))
-		return -EFAULT;
+	ret = get_user(user_size, &arg->argsz);
+	if (ret)
+		return ret;
+	if (user_size < minsz)
+		return -EINVAL;
+	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
+	if (ret)
+		return ret;
 
-	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
+	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
 		return -EINVAL;
 
 	/* BIND_IOMMUFD only allowed for cdev fds */
@@ -93,6 +121,10 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 		goto out_unlock;
 	}
 
+	ret = vfio_df_check_token(device, &bind);
+	if (ret)
+		return ret;
+
 	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
 	if (IS_ERR(df->iommufd)) {
 		ret = PTR_ERR(df->iommufd);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 2149f49aeec7f8..397f5e44513639 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1583,6 +1583,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 93f894fe60d221..7ec47e736a8e5a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1372,6 +1372,7 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e5ac39c4cc6b6f..d95761dcdd58c4 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -696,6 +696,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.mmap		= nvgrace_gpu_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
@@ -715,6 +716,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
 	.mmap		= vfio_pci_core_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 76a80ae7087b51..5731e6856deaf1 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -201,6 +201,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index 845ed15b67718c..5cce6b0b8d2f3e 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -614,6 +614,7 @@ static const struct vfio_device_ops qat_vf_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5ba39f7623bb76..ac10f14417f2f3 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -138,6 +138,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.mmap		= vfio_pci_core_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcdd4..d39b0201d910fd 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1821,9 +1821,13 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
-static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
-				      bool vf_token, uuid_t *uuid)
+int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
+				   const uuid_t *uuid)
+
 {
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
 	/*
 	 * There's always some degree of trust or collaboration between SR-IOV
 	 * PF and VFs, even if just that the PF hosts the SR-IOV capability and
@@ -1854,7 +1858,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		bool match;
 
 		if (!pf_vdev) {
-			if (!vf_token)
+			if (!uuid)
 				return 0; /* PF is not vfio-pci, no VF token */
 
 			pci_info_ratelimited(vdev->pdev,
@@ -1862,7 +1866,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 			return -EINVAL;
 		}
 
-		if (!vf_token) {
+		if (!uuid) {
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1880,7 +1884,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 	} else if (vdev->vf_token) {
 		mutex_lock(&vdev->vf_token->lock);
 		if (vdev->vf_token->users) {
-			if (!vf_token) {
+			if (!uuid) {
 				mutex_unlock(&vdev->vf_token->lock);
 				pci_info_ratelimited(vdev->pdev,
 					"VF token required to access device\n");
@@ -1893,12 +1897,12 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 					"Incorrect VF token provided for device\n");
 				return -EACCES;
 			}
-		} else if (vf_token) {
+		} else if (uuid) {
 			uuid_copy(&vdev->vf_token->uuid, uuid);
 		}
 
 		mutex_unlock(&vdev->vf_token->lock);
-	} else if (vf_token) {
+	} else if (uuid) {
 		pci_info_ratelimited(vdev->pdev,
 			"VF token incorrectly provided, not a PF or VF\n");
 		return -EINVAL;
@@ -1906,6 +1910,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_match_token_uuid);
 
 #define VF_TOKEN_ARG "vf_token="
 
@@ -1952,7 +1957,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 		}
 	}
 
-	ret = vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
+	ret = core_vdev->ops->match_token_uuid(core_vdev,
+					       vf_token ? &uuid : NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index 515fe1b9f94d80..8084f3e36a9f70 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -94,6 +94,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
@@ -114,6 +115,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
@@ -134,6 +136,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
 	.mmap = vfio_pci_core_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 707b00772ce1ff..eb563f538dee51 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -105,6 +105,9 @@ struct vfio_device {
  * @match: Optional device name match callback (return: 0 for no-match, >0 for
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
+ * @match_token_uuid: Optional device token match/validation. Return 0
+ *         if the uuid is valid for the device, -errno otherwise. uuid is NULL
+ *         if none was provided.
  * @dma_unmap: Called when userspace unmaps IOVA from the container
  *             this device is attached to.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
@@ -132,6 +135,7 @@ struct vfio_device_ops {
 	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
 	void	(*request)(struct vfio_device *vdev, unsigned int count);
 	int	(*match)(struct vfio_device *vdev, char *buf);
+	int	(*match_token_uuid)(struct vfio_device *vdev, const uuid_t *uuid);
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b361..f541044e42a2ad 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -122,6 +122,8 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
+int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
+				   const uuid_t *uuid);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 5764f315137f99..75100bf009baf5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -905,10 +905,12 @@ struct vfio_device_feature {
  * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
  *				   struct vfio_device_bind_iommufd)
  * @argsz:	 User filled size of this data.
- * @flags:	 Must be 0.
+ * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
  * @iommufd:	 iommufd to bind.
  * @out_devid:	 The device id generated by this bind. devid is a handle for
  *		 this device/iommufd bond and can be used in IOMMUFD commands.
+ * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_FLAG_TOKEN. Points to a 16 byte
+ *                  UUID in the same format as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
  *
  * Bind a vfio_device to the specified iommufd.
  *
@@ -917,13 +919,21 @@ struct vfio_device_feature {
  *
  * Unbind is automatically conducted when device fd is closed.
  *
+ * A token is sometimes required to open the device, unless this is known to be
+ * needed VFIO_DEVICE_BIND_FLAG_TOKEN should not be set and token_uuid_ptr is
+ * ignored. The only case today is a PF/VF relationship where the VF bind must
+ * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
+ * the PF.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_bind_iommufd {
 	__u32		argsz;
 	__u32		flags;
+#define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
 	__s32		iommufd;
 	__u32		out_devid;
+	__aligned_u64	token_uuid_ptr;
 };
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)

base-commit: 32b2d3a57e26804ca96d82a222667ac0fa226cb7
-- 
2.43.0


