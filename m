Return-Path: <kvm+bounces-56899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47278B461B5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED7AA3B7C50
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0867393DDC;
	Fri,  5 Sep 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CSKfZTk0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3140E1DED4C;
	Fri,  5 Sep 2025 18:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095598; cv=fail; b=k0pBGB9d8lypohhLCYpQMXJerd/uREgARLS0Rh66wfH44PaFD0qo3u91QvZyjSh/qi6j37pHWGwpofXAlmzmjPSOxCKdG1cX18/DHcf4okuuNJiN+pf//2XmKyX2T8qwcMAorpLtnw+bQGSlwyklGeUCzueBUTtbv6/DEQbw+0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095598; c=relaxed/simple;
	bh=LIQkM1SlpRKO7nWwTbdth7NsxsiX1Sg3QCZf1MJvZok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kLfgnWn1HzhkPrq6hX3Uu4uGrw15CfoguBWaB4g/WSiiUdHGt5WNzNP3w1M4mFmzNDKuFbWUx1zBH1oFE9DQsLFI7hp6pbITpZsilDavrWGHBfYgZMM4t2+cEGVCfWMx8bYbjqK+AS1LPnRyWS1fVm5O+3wai3RMNP+42tvuP6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CSKfZTk0; arc=fail smtp.client-ip=40.107.92.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kI2qeQ5GUPM7WmtjiGpGt81rsWOlYM1v64ATGmXQeFdKGiFvUuBhXEACV1Cc2AT6O6lHVSa5M1qWcnHBFNlhKtoF4a18w2UV+wqSJII75fs7oarXeep3IjvvUCITeF8Q2geTLoFV/ESZDro1mZMMNqCXh18QFNEJcZbxiGHZDukFgnVX9a5zQr1bZScbfrXToxx1fj41jswDEDc3tG8Z35YPTHHgSfnbH/CVvfLGNE8TxPZzOSeEJ3yddbN2t3akBsbtCIVxy06zzB794IN3ID8gVXOetuV5oB6X9vB6ak1YuiQNEfJLZbj4tBvaW2QsV3WNn/JNnB7UVsccyb0dDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3DKY4lE/yZoNj0Ssa3L8yteV0BgZgMoj5fYMQM+MsI=;
 b=vt0gtN2dEfqJt+TxRG6QY5no9mma/VThqh9uyiefSzMtZ5lK15oR6rSLEFzkb2h1VqV6TFvmQzo5/pkov+LnNGi7pbXSBXrqHFUHVfzRlpnqb8AWNzZUi/sGCidrELK9JE9DhF1etjMIUD5zOAgxgXj6AaJjz4JDIQFPoXCUWofqJ2PWbR+05khT5ovtje3H2PnMxHAq7RhmBvAJ6pSB5MVO2J/Deom03fg2TCjKFfrqFO9xGgno4ZFRgHl4ln1RqD2XMEDHCZsZXmEsQSA/ZLik5t1+mx5/WF7xzaK+AFHQtPyBgqGLIuE6sgwBkeNoFoLgfBSZbIqAlowwcrS/sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3DKY4lE/yZoNj0Ssa3L8yteV0BgZgMoj5fYMQM+MsI=;
 b=CSKfZTk0gbWdy5W5KewxD0UnKbCUwWbXO7neG9EmV3rRuRy4sgGO9dFrblmFkkil2D6OpiiUIHxx4CyZiUMDeg6eLpWdxIj37GX08niXvtKfjw1NOqv3QoDlWVuSy1AyuOT4aq/bdgHmww/P29CSR5s1/+J4w+Iq9/n/H4lKCDwFgECCJybXwq8oXHjtIArezOLmDQNc5DOfMgoHcMGccL0k3jSXESt5JArTBpnTn5a4KRTlgkHHCL8kaM/szCC+VhqDvjcaK1AqzQHvNPeA9HQpCv2RfWX+jCOwcFqAQ7Kv55OeDdjYrhRPTAs53DMpTzSVCeDJ6qGuMQRizclYXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:31 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe MFDs
Date: Fri,  5 Sep 2025 15:06:21 -0300
Message-ID: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0362.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 75bc59b9-2924-421a-5442-08ddeca6f0cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pwkrnKzX/cTIERCCW/rKjTDIY/WDDNO5Np7YCBTor2Q7C5lv1J0qYC3+2OeH?=
 =?us-ascii?Q?tI1P/jvk11ZtktP1lqi38+ysgft5ljRfiQLlP5lQjAaFZPTok9imBGf8ribr?=
 =?us-ascii?Q?rmcpImK5Wvcdzcc8JVw5f8by21lKXMaIYh2cMGm1yaKAbCjGAVX1mMnJlGVn?=
 =?us-ascii?Q?rLFIVMd24rOW6gU3OgRThbGf93kguRYgnGxbj4g0ZzaKdyG02WV/DK9QQjQX?=
 =?us-ascii?Q?2O5KBe3YneR1WAbInhz2uGAaNcngLzzc24D9+L9jW61viwi74ZjafKTAhcLy?=
 =?us-ascii?Q?K0LXj5+vn1B9wNh5GLu+U5KPCS8srmiNfVI4BCkiJpdLAYgrfuWLvdei0i/7?=
 =?us-ascii?Q?LfR66XHtS+aoteIKZBCM0AGniYmk6JGwzWOsxC8WpliZ0fgaVuusVLRpo7mc?=
 =?us-ascii?Q?ghCLrsklDsu9esb8JBdRvHDc+RSjvxzMUH7iUfEc/j2eztdTjiQkGuK324HD?=
 =?us-ascii?Q?vb8RKt7deDl9WQEyLvHTa5VEfmTXtlaecrJP23UnIOq7SvufyZe3CyvJTTKm?=
 =?us-ascii?Q?wUgHkyw8vCQGqhnMfzfkg+ZCYyXkAPRzRmfwHe2GlJNXkVsHYj4EtgH7N94E?=
 =?us-ascii?Q?COgLMy/vo4ENJl5C3kzNI6ZaUhF1XxKbIz9c7Fld9W9+KyLGU3v57KABfP1x?=
 =?us-ascii?Q?8Sf/1skdpMbnMOxC+JjjOMpxiMbOHcoGB1DNAdJYLc/GyUolAcpFAAfLyEzR?=
 =?us-ascii?Q?plz0f3092b0MtgRw9XDVnUj1Edwn1HuGhAEXmfOip7xIxNp7cfItpXN9ki7v?=
 =?us-ascii?Q?nwS3czUAMmlwXtK7Awrv4QeCyxbBYkKC/i8S6XlvvsyguuZqLuksNez/i8no?=
 =?us-ascii?Q?7JMyHnaE1FszT/rljeGyLgcBRWCnGYA3BgcBxWbyWV1s4efaqCJw5mLMN1mW?=
 =?us-ascii?Q?5wdsierZhsZ3SK1os6amk8x9VG+SGAJMaNVfKazD5Ks5w0BDlE0WJgjK93iX?=
 =?us-ascii?Q?mRfSwxhCjD+M5TkSe1G+c3broSPEPbSikMo4UFsheWvgEvAFJnWv10FL588F?=
 =?us-ascii?Q?CkdUX51/d4XXVQnGKRHwUdPfoXje/hPg2JV/MTrmanuYu/ens3MhhMZ1KwW8?=
 =?us-ascii?Q?2W6F7GOwkce6SCWX6RuwggLQnXVDP/HRTb/NR37Ke8aaupHsHhlbRpja8xv0?=
 =?us-ascii?Q?a+5qACXwQp+o4hv4uDLmZpqdIk40nyYz5h4RNgyq75Vv41WaAQHxhLm1YEoN?=
 =?us-ascii?Q?YagSqswuCPqQT83d2u6b+6qHSBVjWbNpuMWKUzBNlAfCGJS+nqNU0Z5mmf7K?=
 =?us-ascii?Q?w8d/eRKNlcCRDlYZCTPYIhtU9fsB3IAQrIYpoVATXon/HusRyuh9/qgiRSN+?=
 =?us-ascii?Q?/DOqx7WvB/PDuZm5lfegXGzBtvxb7H/2Qqwy1s/eYef5AznTl6sn+16VCqPX?=
 =?us-ascii?Q?b4LmK+MZAv69ZtH9FxuDHgoKNu8CddFXPTrx0k/x51ySTN1/rgbVPFhG2AB/?=
 =?us-ascii?Q?BRAF8noVvag=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NXsnvu1I6NeHOj/fYLaxDV3yNePgw2jCVFFBG13W1yOC7BdrOOxS/LO3zQnL?=
 =?us-ascii?Q?hp7kYSMOwe1xdJoyoxbNqpsyycUxzWqaod6OyrNMq+C3dczXjDam9KWE+JUW?=
 =?us-ascii?Q?rjWhq5D1X4oltOxMcnOUgWXzJMdb5MpteqlZt1y8QSwFemGhsEacLj0tZE6r?=
 =?us-ascii?Q?bBdVX1tHA89trQZyKKb60j7FbMZ0PKzdmZU3JtKNcRp4L+Y3qF7lqk8CndVk?=
 =?us-ascii?Q?NTlz3jVL8mHMWztBseLb9xAurp0EAtvUBspkzH11MNj8udMu4dWQJ2cly0Mr?=
 =?us-ascii?Q?KmrO3f9KvJ1h396t5F5bhwJWZKQPdsXugX6MQSgs4H5urpjenyJA90bZPW3l?=
 =?us-ascii?Q?9wi4vFtb59tQi4H/GHYTIci3AXUcizOusbNcOR4yiygdVu8uQy7GgYmxlsMD?=
 =?us-ascii?Q?ayiNL3HTfQK15DxHeYRjrmcV5SZ+9wdY7MwW1P0PEIzdbnsgjsrQoN1nLLar?=
 =?us-ascii?Q?9bbg6gc6+mJSxxQJNd5Qy+bSpewTtKiDHlAh8ExMY8gxdlyoRDki/wwD2HeA?=
 =?us-ascii?Q?Oltlfq9+bPkxsVdpqUlB8j5HgeM6K33rzNtLJ4pqdK+dicwbCP3a2qhFSmrR?=
 =?us-ascii?Q?KORK7PV55ntDeCcTkxFfK+P9/1kYfTn/GdVZ23e/ceGM2q0ckh8PVjeL/I+0?=
 =?us-ascii?Q?MKjHllLm4pFAkMiYO7H886U2/Ez/mqh5EZ+/P1/kZ92AtADUXuHhJSNsktKD?=
 =?us-ascii?Q?oYtU+rK5ESl9+O1zU4+6Em63kKndFUkmCbK01hledVWXOuPP6uSXicFjxej0?=
 =?us-ascii?Q?we+dt2TsDCB2LZhD/4cWxRleKzP8Azk0N/i6gSNsPiHxnLefItisjHvDpBSc?=
 =?us-ascii?Q?M2DkVxkYDW6eLqI/hDZ4YfXHl1fqgJsfXlN+rs7nP+FQWuUwWN1w7P0ZAQ73?=
 =?us-ascii?Q?LZNUiCW9ow0Na7cyADLTqjhj+n02+i8WEstV4+DvTqZ4UE6oSOepl9GGUs+U?=
 =?us-ascii?Q?CbyIQCkmAzjQ8KkOLzGEFG47YoqHBkp9OG1lr5IIy+HB1eaCXk0Bql5fZ7Qd?=
 =?us-ascii?Q?Vu9zGsF4xfI+I1qxuPKaihWmM1ziaDydOZUSynyPlz5JYZKZXZV6kKPT9q8L?=
 =?us-ascii?Q?pxWe/OvCPqVTEOtjw6CX0z/Noqp9dMKEQsYA+8qXB3vLjUVSDjQTws2j2/z2?=
 =?us-ascii?Q?3+RJFp+06vMJmYrKSs4QBqVPPSPNRUiOF5bZ0AFg1eqXTM1jVPEL1UcABxJd?=
 =?us-ascii?Q?JIV+qCOX8s8Hn9g+m75HOR17Y+3NNefM1yIPdStV08hkApsxzBVIIwyOtdI0?=
 =?us-ascii?Q?+1nu2i6ZRPM5kn1pMZwWPdYamaSwvGFdFoU9fe5Nt1m1xBQNV2diyhaO0/Rq?=
 =?us-ascii?Q?cyAtom81PXqSqYopXSbux79elOAeAQpb2tPEKtVyv341qZGK5Dp3CQZTlgt3?=
 =?us-ascii?Q?BsnJnsrGQTqxai9kfDXdG1FCMeczhcoAbh2NUSgsncU9S7Sx12Mj0b8m7fV5?=
 =?us-ascii?Q?Ogr1+KjxkNJsrV+jKOXKfv+hEf8kHSfKoXOOPEEqQtG+hNP2iIFvZxpC6Rjn?=
 =?us-ascii?Q?UApFGRLJrHvDM455z1dHeD+dIN4FF2EcCEXzFdVR9WVWzKJJ3ikg2mxbOiwL?=
 =?us-ascii?Q?oyuGNGbP1shomNsSFkA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75bc59b9-2924-421a-5442-08ddeca6f0cb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:30.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqPRPiWUcHMt9K1+9IaqH/uwZXe5xVy/N7qP9FIuvnHdZPCtw/+XNvu09yU0yeso
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

Like with switches the current MFD algorithm does not consider asymmetric
ACS within a MFD. If any MFD function has ACS that permits P2P the spec
says it can reach through the MFD internal loopback any other function in
the device.

For discussion let's consider a simple MFD topology like the below:

                      -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
      Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
                      |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

This asymmetric ACS could be created using the config_acs kernel command
line parameter, from quirks, or from a poorly thought out device that has
ACS flags only on some functions.

Since ACS is an egress property the asymmetric flags allow for 00:1f.0 to
do memory acesses into 00:1f.6's BARs, but 00:1f.6 cannot reach any other
function. Thus we expect an iommu_group to contain all three
devices. Instead the current algorithm gives a group of [1f.0, 1f.2] and a
single device group of 1f.6.

The current algorithm sees the good ACS flags on 00:1f.6 and does not
consider ACS on any other MFD functions.

For path properties the ACS flags say that 00:1f.6 is safe to use with
PASID and supports SVA as it will not have any portions of its address
space routed away from the IOMMU, this part of the ACS system is working
correctly.

Further, if one of the MFD functions is a bridge, eg like 1f.2:

                      -- MFD 00:1f.0
      Root 00:00.00 --|- MFD 00:1f.2 Root Port --- 01:01.0
                      |- MFD 00:1f.6

Then the correct grouping will include 01:01.0, 00:1f.0/2/6 together in a
group if there is any internal loopback within the MFD 00:1f. The current
algorithm does not understand this and gives 01:01.0 it's own group even
if it thinks there is an internal loopback in the MFD.

Unfortunately this detail makes it hard to fix. Currently the code assumes
that any MFD without an ACS cap has an internal loopback which will cause
a large number of modern real systems to group in a pessimistic way.

However, the PCI spec does not really support this:

   PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function
   Devices

    ACS P2P Request Redirect: must be implemented by Functions that
    support peer-to-peer traffic with other Functions.

Meaning from a spec perspective the absence of ACS indicates the absence
of internal loopback. Granted I think we are aware of older real devices
that ignore this, but it seems to be the only way forward.

So, rely on 6.12.1.2 and assume functions without ACS do not have internal
loopback. This resolves the common issue with modern systems and MFD root
ports, but it makes the ACS quirks system less used. Instead we'd want
quirks that say self-loopback is actually present, not like today's quirks
that say it is absent. This is surely negative for older hardware, but
positive for new HW that complies with the spec.

Use pci_reachable_set() in pci_device_group() to make the resulting
algorithm faster and easier to understand.

Add pci_mfds_are_same_group() which specifically looks pair-wise at all
functions in the MFDs. Any function with ACS capabilities and non-isolated
aCS flags will become reachable to all other functions.

pci_reachable_set() does the calculations for figuring out the set of
devices under the pci_bus_sem, which is better than repeatedly searching
across all PCI devices.

Once the set of devices is determined and the set has more than one device
use pci_get_slot() to search for any existing groups in the reachable set.

Fixes: 104a1c13ac66 ("iommu/core: Create central IOMMU group lookup/creation interface")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 189 +++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 102 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 543d6347c0e5e3..fc3c71b243a850 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1413,85 +1413,6 @@ int iommu_group_id(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_id);
 
-static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
-					       unsigned long *devfns);
-
-/*
- * For multifunction devices which are not isolated from each other, find
- * all the other non-isolated functions and look for existing groups.  For
- * each function, we also need to look for aliases to or from other devices
- * that may already have a group.
- */
-static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
-							unsigned long *devfns)
-{
-	struct pci_dev *tmp = NULL;
-	struct iommu_group *group;
-
-	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
-		return NULL;
-
-	for_each_pci_dev(tmp) {
-		if (tmp == pdev || tmp->bus != pdev->bus ||
-		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
-		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
-			continue;
-
-		group = get_pci_alias_group(tmp, devfns);
-		if (group) {
-			pci_dev_put(tmp);
-			return group;
-		}
-	}
-
-	return NULL;
-}
-
-/*
- * Look for aliases to or from the given device for existing groups. DMA
- * aliases are only supported on the same bus, therefore the search
- * space is quite small (especially since we're really only looking at pcie
- * device, and therefore only expect multiple slots on the root complex or
- * downstream switch ports).  It's conceivable though that a pair of
- * multifunction devices could have aliases between them that would cause a
- * loop.  To prevent this, we use a bitmap to track where we've been.
- */
-static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
-					       unsigned long *devfns)
-{
-	struct pci_dev *tmp = NULL;
-	struct iommu_group *group;
-
-	if (test_and_set_bit(pdev->devfn & 0xff, devfns))
-		return NULL;
-
-	group = iommu_group_get(&pdev->dev);
-	if (group)
-		return group;
-
-	for_each_pci_dev(tmp) {
-		if (tmp == pdev || tmp->bus != pdev->bus)
-			continue;
-
-		/* We alias them or they alias us */
-		if (pci_devs_are_dma_aliases(pdev, tmp)) {
-			group = get_pci_alias_group(tmp, devfns);
-			if (group) {
-				pci_dev_put(tmp);
-				return group;
-			}
-
-			group = get_pci_function_alias_group(tmp, devfns);
-			if (group) {
-				pci_dev_put(tmp);
-				return group;
-			}
-		}
-	}
-
-	return NULL;
-}
-
 /*
  * Generic device_group call-back function. It just allocates one
  * iommu-group per device.
@@ -1534,44 +1455,108 @@ static struct iommu_group *pci_group_alloc_non_isolated(void)
 	return group;
 }
 
+/*
+ * All functions in the MFD need to be isolated from each other and get their
+ * own groups, otherwise the whole MFD will share a group.
+ */
+static bool pci_mfds_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
+{
+	/*
+	 * SRIOV VFs will use the group of the PF if it has
+	 * BUS_DATA_PCI_NON_ISOLATED. We don't support VFs that also have ACS
+	 * that are set to non-isolating.
+	 */
+	if (deva->is_virtfn || devb->is_virtfn)
+		return false;
+
+	/* Are deva/devb functions in the same MFD? */
+	if (PCI_SLOT(deva->devfn) != PCI_SLOT(devb->devfn))
+		return false;
+	/* Don't understand what is happening, be conservative */
+	if (deva->multifunction != devb->multifunction)
+		return true;
+	if (!deva->multifunction)
+		return false;
+
+	/*
+	 * PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and
+	 * Multi-Function Devices
+	 *   ...
+	 *   ACS P2P Request Redirect: must be implemented by Functions that
+	 *   support peer-to-peer traffic with other Functions.
+	 *
+	 * Therefore assume if a MFD has no ACS capability then it does not
+	 * support a loopback. This is the reverse of what Linux <= v6.16
+	 * assumed - that any MFD was capable of P2P and used quirks identify
+	 * devices that complied with the above.
+	 */
+	if (deva->acs_cap && !pci_acs_enabled(deva, PCI_ACS_ISOLATED))
+		return true;
+	if (devb->acs_cap && !pci_acs_enabled(devb, PCI_ACS_ISOLATED))
+		return true;
+	return false;
+}
+
+static bool pci_devs_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
+{
+	/*
+	 * This is allowed to return cycles: a,b -> b,c -> c,a can be aliases.
+	 */
+	if (pci_devs_are_dma_aliases(deva, devb))
+		return true;
+
+	return pci_mfds_are_same_group(deva, devb);
+}
+
 /*
  * Return a group if the function has isolation restrictions related to
  * aliases or MFD ACS.
  */
 static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
 {
-	struct iommu_group *group;
-	DECLARE_BITMAP(devfns, 256) = {};
+	struct pci_reachable_set devfns;
+	const unsigned int NR_DEVFNS = sizeof(devfns.devfns) * BITS_PER_BYTE;
+	unsigned int devfn;
 
 	/*
-	 * Look for existing groups on device aliases.  If we alias another
-	 * device or another device aliases us, use the same group.
+	 * Look for existing groups on device aliases and multi-function ACS. If
+	 * we alias another device or another device aliases us, use the same
+	 * group.
+	 *
+	 * pci_reachable_set() should return the same bitmap if called for any
+	 * device in the set and we want all devices in the set to have the same
+	 * group.
 	 */
-	group = get_pci_alias_group(pdev, devfns);
-	if (group)
-		return group;
+	pci_reachable_set(pdev, &devfns, pci_devs_are_same_group);
+	/* start is known to have iommu_group_get() == NULL */
+	__clear_bit(pdev->devfn, devfns.devfns);
 
 	/*
-	 * Look for existing groups on non-isolated functions on the same
-	 * slot and aliases of those funcions, if any.  No need to clear
-	 * the search bitmap, the tested devfns are still valid.
-	 */
-	group = get_pci_function_alias_group(pdev, devfns);
-	if (group)
-		return group;
-
-	/*
-	 * When MFD's are included in the set due to ACS we assume that if ACS
-	 * permits an internal loopback between functions it also permits the
-	 * loopback to go downstream if a function is a bridge.
+	 * When MFD functions are included in the set due to ACS we assume that
+	 * if ACS permits an internal loopback between functions it also permits
+	 * the loopback to go downstream if any function is a bridge.
 	 *
 	 * It is less clear what aliases mean when applied to a bridge. For now
 	 * be conservative and also propagate the group downstream.
 	 */
-	__clear_bit(pdev->devfn & 0xFF, devfns);
-	if (!bitmap_empty(devfns, sizeof(devfns) * BITS_PER_BYTE))
-		return pci_group_alloc_non_isolated();
-	return NULL;
+	if (bitmap_empty(devfns.devfns, NR_DEVFNS))
+		return NULL;
+
+	for_each_set_bit(devfn, devfns.devfns, NR_DEVFNS) {
+		struct iommu_group *group;
+		struct pci_dev *pdev_slot;
+
+		pdev_slot = pci_get_slot(pdev->bus, devfn);
+		group = iommu_group_get(&pdev_slot->dev);
+		pci_dev_put(pdev_slot);
+		if (group) {
+			if (WARN_ON(!(group->bus_data &
+				      BUS_DATA_PCI_NON_ISOLATED)))
+				group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
+			return group;
+		}
+	}
+	return pci_group_alloc_non_isolated();
 }
 
 /* Return a group if the upstream hierarchy has isolation restrictions. */
-- 
2.43.0


