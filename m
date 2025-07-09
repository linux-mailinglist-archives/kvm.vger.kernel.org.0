Return-Path: <kvm+bounces-51964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4057AAFECB1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE76C1C45974
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0C82E8881;
	Wed,  9 Jul 2025 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HjpRMTQl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90A2D9EEF;
	Wed,  9 Jul 2025 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072751; cv=fail; b=ZTApFzGMnAWelYasB9at0WevFihDb7iRw/kFt8BVvqpN2NJpquw9zW7H0Rg2gLCBvGe1Uu/mHaGgbV8n4k8yOyT2i2537w9xFwu4BP6J8LtMUu8NCYW2b+VuCDCYYJMMbTiW6Fo6QmoU8S/hxbkS5C3Vk4xsPA/ieaSTDFyCsYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072751; c=relaxed/simple;
	bh=QFtM4Kcy/ZxCBaSeqWf0/CTk8blN/rcETL+eH8KE3es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OuWiSj5DR6y6+c8RqdCj5aDR/hzCipiLcUmptLkoWq1AUruxisfFU9Mt2pccmQ5r9ryIl1nwWWufbY/lbS16QJhKdKWzUE2Te9FPxmmPUhpYmZvesXAuuj21gSDG2sudyEQhzXl+22IazP0jWqj8X/H8nDt4BtrgmreRZol3xF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HjpRMTQl; arc=fail smtp.client-ip=40.107.102.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H98u3f6gibMqLPwobxNuXqtACxZLlOCLJRGE9hFQESP3koKc09LnmRA3I4qjJk0pAkCshY2jKkSks8GV/wesZ2oLKRTvzeIxxpidNmMOViLL3deX3qqflgjSJgZs2EFdoChvE3ZUbc0c2rUtDg5vnmyfUCBLUOOjCW9p0AJZgSEaJxv42KShHTVYIZ6OeY6JHWE5T/iSTsNd4FX5c+3mcE0S8XEo4T5U2kSi0+axG6fvFLE8Zz/5BI8nswyYIsH+4CoURYtG84RC4eO9Dg2EPjmfn5B1rIcA6FPnam8QeXzHTceyqWTBWpUmGgqAvYEE1C0rRb/u9cuabIgCmTzqhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NA+Pla8RTLCHES9T/kuSqIXeaqdDe2DweOnpyKRmn7M=;
 b=bBGkoyE30vhFqs0Zu7dSHTIA7Gb8Ilu+W6SvB7RTJrNyC4UCsgpXQYwQOz6QlfYngnpUzOjdEhUjZYR6SeaxkWlfgmOyE9Q+tnZC1kSfZDvE//whds4Mgw2smNyg9BhUfMzIlD7LiH7wTaCFuuiH4Olo+iMzwqvotFOP/yEwkWe5P7lfV+rT0pFEe0G1TnHqVFK3LRLK6dy4jHfeavWKqDm21YoZCgY3lt/mOCBjQPA3XYw6I6gdK7QmoOG0tdTc9sjiyRECIge2TX+2gdXlJAMSCso3yg1aq6Evsp2TFcmMLDix6Y+z117j4pdtngY8bOhfPJyVj6jjCNglM1F1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NA+Pla8RTLCHES9T/kuSqIXeaqdDe2DweOnpyKRmn7M=;
 b=HjpRMTQlt4WpXhJEewWl/s62as+9DCyWyLTxAk3KPk7+6Wdy42e3ueKOKzSXDiUybXxZhg1jOzO81kHlJ62LBwNMMReFzlS/UtW/f00xR+316l/QiziYFC6yEzf1dse8xPei5m56p1AUGoHzJqss+nPfbbAQyU+/nWfFcwUEe+Uz/DZIR557zl7rIH7z/7fyQKnfpG1oyVNU2J9OcUFTteHNLm33XtmpCj7T5E+ORbyGCj4L5DB3gLgL5drgjzOMaTpv3h9HMig2SFBgB7UOFF6estcrVWCqpKQzqFYClkCuRK4e6zb7/W8jv6ozewZrMUpOs4R0mpBGupTar5yYyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:24 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v2 10/16] PCI: Add pci_mfd_isolation()
Date: Wed,  9 Jul 2025 11:52:13 -0300
Message-ID: <10-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0230.namprd04.prod.outlook.com
 (2603:10b6:806:127::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: c95cc6c3-6b90-45ab-fa51-08ddbef8369d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Df/OM1Ua3kMyl5dN35s3HQT2WmD737v5opFOLs91BGMddzXGJNzE4eTjkt/2?=
 =?us-ascii?Q?zEGewwfFyebOmvD4eUf6CyMSeoU8t5z8ptSSHIF4ZR+aJgXjX+68kytyWTOB?=
 =?us-ascii?Q?QWBoPaLv1RhcKr/2Oc7RH6myHN3dZMkQ3u6O6l7tRcWWiDK6lvWFfjP+3Q89?=
 =?us-ascii?Q?hkFGHjuDQk7Z8i2kDeFBZi1VAcgCHWBTxebNNbx1VmKKmhm7jb+KXSeX8eNh?=
 =?us-ascii?Q?aJARpsaGADnof8PVDddzgn69Vh9VuKnsJA7htLQ5WW6NuAWFCUEJa3Zcq+Xg?=
 =?us-ascii?Q?SBJcO50rI0OuLxrmYlDV5v7TJUWq90J5nIpgldO70Qx5TvIZVQFnDGeKNri0?=
 =?us-ascii?Q?d3PqYy5NmJvkIHzSFg2vzi0STYL8B+x1783/zl/4fOR7B270oI5GZTAGCBbh?=
 =?us-ascii?Q?RBLY+IdZnh+QeSLFU1eiA1z0K5fHacktVuRoihNnMIEpR1cvH4kmT4z4OOe6?=
 =?us-ascii?Q?RzvS9t5NWRwe+5LU5sFt2O9OuShh2Z1hSAx87P/3N4g1xR785V+NhdvaH4kf?=
 =?us-ascii?Q?sHCABy0sFGD5LqZeFfNsu9rTO+NQsYeBcvFwbl7qwoIPbGzZ/XeltoIY+NNH?=
 =?us-ascii?Q?T6UxSMf1BHk5XLfYRB2JaZedWYL22V1Nmhy1GoAZBEeh6lJRbq2/9qUk5LcO?=
 =?us-ascii?Q?6k5S38pQRy2iandh5waPgsAaf1ImNedFIXJOUZOVx9g0ogieYebhq8XDaC0l?=
 =?us-ascii?Q?Wieghz/8r24xol03wdGFfI+RH0eFQPVMLiBiPf0HQN/L4n3Q89iC0BSPdkGL?=
 =?us-ascii?Q?fHZTqRXX4vZwwPTZvRPzi84V5NzqmJQq26t9pbpWR/VCbGDXKglKrWkVw4/R?=
 =?us-ascii?Q?2CtI9wvGrKwQ0vrJ4+pUrG/XHGZ39Ti9cJZXo8iB93EQwzXe+9FJWxb9uRUk?=
 =?us-ascii?Q?HmEUct8BiDtqxdSgRMdFULHjxMlg2MBDymM5xe7GCX0iQMHnH3FxqfZqI2WJ?=
 =?us-ascii?Q?lsIpzT4msYOat5bhLWt+k6jwPWSJH3Pydv+e6kqwH6Xn56NswfUNHnLH2Naw?=
 =?us-ascii?Q?XYr4nVhmzDz1RfZAslTCvBEBN2UjvCEGGQDtSDvljv4jVp8hgfQNgGxC/ilg?=
 =?us-ascii?Q?19xjWy9x5C8BLrk5mupnT4x+TeEWb7cTnGUG9tK7MVtf++jltmCKc+tqJJqj?=
 =?us-ascii?Q?JsfFjBPnIN6J3OWQ1HXLosjW9LHgJLcJPv8quIEZfmn1PY/2BaZRLSPYV12T?=
 =?us-ascii?Q?3+GgpLJYXlqdwFHz0Jib1iBQ9oiOZAozmAOyiol5KAf+NFqYpI2DO1rPicH9?=
 =?us-ascii?Q?medOyu+eoc1A7D+qelWOWsBlyccqy5BgnI9kGhWWj4bfl+1I9/zFsGGRc2pR?=
 =?us-ascii?Q?chaSDZJk1O8nKX07iXQOij7G5SjD53r42CRwHfSIh3p/GbRb5lLs+G6MZqD6?=
 =?us-ascii?Q?le7gKu2MApnhVqVezhxqnjqLLTrYUWPH6k8XHBFCkPzDv+6Su8u19DU+du65?=
 =?us-ascii?Q?avHBL531Mi4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EAzGOgqPqXhvWHX10WVejEWLkFThGFxf9bhIJ3A/nw3q7KZfteFbHz0kWoqH?=
 =?us-ascii?Q?zCahLKGZv9eS4PRdbR7RPqlz3rXju71nUOdKTManzZYZZabPy5x3RrNZO73f?=
 =?us-ascii?Q?VuiqAvTvUaPYCNzVfaaL24f02LVM4s3NS8UBdqeB5witr4YSxm62a6VyiFEY?=
 =?us-ascii?Q?0b2NVqKHIMUx9eUtgXW3YkmLLr2xVrfFF2YhxfcIwgxFqqA6IldrrgPIx6Az?=
 =?us-ascii?Q?tyw4ytWzRiUXiK++KripZY9E87y7D7fxBUmGuQOQpSnoN+FNxXI0w0OV+gh6?=
 =?us-ascii?Q?odx9FLL7Dv9Yi3S6gdQfkaij2F43LjfkZhSzRPzPuETgHtSPLt+pBF4S3eem?=
 =?us-ascii?Q?YzOCz7cUOK6NZmQJtK1RcxoPbG9PI0b1xwR7vng4Z4R1DfBnClb+7M9ATeWP?=
 =?us-ascii?Q?iWVoz3AUTiQ9c+VW8HZCjNzuCGt0UNkFpf9qMwgHGoir1LmFwmFpqhFOXADM?=
 =?us-ascii?Q?xW8I7mXSVUxcSci8aCsnD7NH7L3GiVW43pnfnkFqcPb6BSgLt04ZG1EVUziL?=
 =?us-ascii?Q?XKbhrACcMvn2R28r7iS/syuqF4N537MfgLEJ9Z1IKvD2lAAYW9BuiF931fSg?=
 =?us-ascii?Q?SOny4mg2ZsSvq+7KJCB92lMnb/5HM9qoIyCcZy3WduMxAfr+jQUsaw4UzTk8?=
 =?us-ascii?Q?Ln44GV2u3ryzLMcxHq4XAXBLBl8Hv2BMI8QM6/Ir8sSxzFJHgT0NmhMyzcXA?=
 =?us-ascii?Q?10c8zx8rf0FQEw6dK+flLfhNFG1bI4nbw09NL/HJ9sUc888U6OG8+Njt8u/z?=
 =?us-ascii?Q?D6N9zrf0mnnOzlAJTrsikoiNNHAoTc7tNXFUc4ES3d6175qP2HxKv6Py1wVz?=
 =?us-ascii?Q?Byg6YYn2gT5nUKCtdJl8Fp6fr4+Re9mizADqZM2WvOljMcbA7DoWMgyn22ov?=
 =?us-ascii?Q?WuXwUpp/6hiM0TAJ77ugYOA94ddOWO3QfHhWz3y16s1fraZFtyeGx7qQaz+H?=
 =?us-ascii?Q?lBZKN+kyXMw7v/3uGRJFP7t3y+tu5UNK24FGq7ALe4AHCVM3/eheifFdRrdD?=
 =?us-ascii?Q?slJTA1QFxxKdRWJINlvCDC4Y5yYhIRKONfwZmYXXoVEEDmqcTRzGYblNo2TQ?=
 =?us-ascii?Q?qx9kjjXuTwU0qrEmHlkeRi117oaLxhXKEb9Z60UFohRkc4ZgJsSyl5Lsu1J7?=
 =?us-ascii?Q?7qjxtXtJuaLspulH+ky5CpmiFb4WGi4PimiksQNYl9aGevnIsgBu4zGq+FvN?=
 =?us-ascii?Q?dYZrWnuBmWBpM4KldMqn2eG5C5YB9JTSjsJYvStbU4nwpR/XF3xpucFxVXVX?=
 =?us-ascii?Q?HjcjjAcJ6eFm0GyYW3dwEJhrur9KKZTREkT/nHnMYExgnzPCAQs+gJp0jGGJ?=
 =?us-ascii?Q?ZTqFxoMwPT/Kdf4BYeK6ZZczuuI6jLxCU6viLgtaKlgbBnYHStiOrJLVaWD4?=
 =?us-ascii?Q?1/cZhAW4+7YNOIZ9NaRPG7y46ep62JSe7TAU/ERrimW7cIkQU3ss8B+ZoPA9?=
 =?us-ascii?Q?uIe4dUiJ9QOEgbEIgeOrtGaMw8RxaUPxk2oog87/0YF/9gHeH5mHjOgiiTRE?=
 =?us-ascii?Q?MTZecWehMvOyQs4Cu8pdS1OL2hAjufXsc6u52vL72X6IH7jvTtj8HTtukHqc?=
 =?us-ascii?Q?PzIcaDWJtRAP2qCtRjKVncBXlXyO6mK5q9ydL5yN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95cc6c3-6b90-45ab-fa51-08ddbef8369d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:23.8405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zI/ZS017QOjxxXmCsyv7e85I9wJu0a9U12k0gPWn7uI0+QTNr2bHWDxsmHnPg8+z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

Introduce a new ACS related quirk that indicates a single function in a
MFD is isolated from other functions in the MFD. In otherwords the
function has no internal loopback to other functions.

This is different from the existing ACS quirk since ACS only indicates if
the function's egress can reach other functions in the MFD for P2P, while
leaving the ingress question up to the ACS of the other
functions. pci_mfd_isolation() reports both the ingress and egress
behavior together, if both are blocked then it can return true.

This quirk matches the historical behavior of the
pci_dev_specific_acs_enabled() quirk that would allow 'adding' ACS to a
single function to force that function into its own iommu_group. Many
quirks were added on this assumption to give specific functions their own
IOMMU groups. For example some Intel systems have a NIC in a MFD with
other functions and no ACS capabilities. The NIC has been quirked, while
the rest of the MFD functions are unquirked.

Add an internal flag, PCI_ACS_QUIRK_ACS_ISOLATED, in the upper 16 bits of
the acs_flags. If the quirk implementation sees the flag and decides the
function should be isolated, then it can return success. The additional
flag automatically makes the existing quirks all return failure as it is
never masked off.

Have pci_quirk_mf_endpoint_acs() support the flag with some expectation
this will grown down the road.

Apply the MFD isolation override to a general case of host bridges inside
MFDs that match some AMD systems:

00:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        NUMA node: 3
        IOMMU group: 52

00:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Internal PCIe GPP Bridge 0 to bus[E:B] (prog-if 00 [Normal decode])
	[..]
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	[..]
        Capabilities: [2a0 v1] Access Control Services

The logic being that a host bridge with no mmio has no downstream devices
and cannot source or sink any P2P MMIO operations, thus it does not
contribute to the ACS isolation calculation for the MFD.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/pci.h    |  5 ++++
 drivers/pci/quirks.c | 58 +++++++++++++++++++++++++++++++++++---------
 drivers/pci/search.c | 30 +++++++++++++++++++++++
 include/linux/pci.h  |  4 +++
 4 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 12215ee72afb68..78651025096bcd 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -786,6 +786,7 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 int pcie_failed_link_retrain(struct pci_dev *dev);
+bool pci_dev_specific_mfd_isolated(struct pci_dev *dev);
 #else
 static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 					       u16 acs_flags)
@@ -804,6 +805,10 @@ static inline int pcie_failed_link_retrain(struct pci_dev *dev)
 {
 	return -ENOTTY;
 }
+static inline bool pci_dev_specific_mfd_isolated(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 /* PCI error reporting and recovery */
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 71b9550e46eb06..85c786d66646a8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4616,6 +4616,8 @@ static void quirk_chelsio_T5_disable_root_port_attributes(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
 			 quirk_chelsio_T5_disable_root_port_attributes);
 
+#define PCI_ACS_QUIRK_ACS_ISOLATED BIT(16)
+
 /*
  * pci_acs_ctrl_enabled - compare desired ACS controls with those provided
  *			  by a device
@@ -4948,6 +4950,13 @@ static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u32 acs_flags)
 
 static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u32 acs_flags)
 {
+	/*
+	 * The function cannot get P2P MMIO from the other functions in the MFD
+	 * either even if the other functions do not have ACS or ACS quirks.
+	 */
+	if (acs_flags & PCI_ACS_QUIRK_ACS_ISOLATED)
+		return 1;
+
 	/*
 	 * SV, TB, and UF are not relevant to multifunction endpoints.
 	 *
@@ -5186,18 +5195,7 @@ static const struct pci_dev_acs_enabled {
 	{ 0 }
 };
 
-/*
- * pci_dev_specific_acs_enabled - check whether device provides ACS controls
- * @dev:	PCI device
- * @acs_flags:	Bitmask of desired ACS controls
- *
- * Returns:
- *   -ENOTTY:	No quirk applies to this device; we can't tell whether the
- *		device provides the desired controls
- *   0:		Device does not provide all the desired controls
- *   >0:	Device provides all the controls in @acs_flags
- */
-int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
+static int pci_dev_call_acs_enabled(struct pci_dev *dev, u32 acs_flags)
 {
 	const struct pci_dev_acs_enabled *i;
 	int ret;
@@ -5222,6 +5220,42 @@ int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
 	return -ENOTTY;
 }
 
+/*
+ * pci_dev_specific_acs_enabled - check whether device provides ACS controls
+ * @dev:	PCI device
+ * @acs_flags:	Bitmask of desired ACS controls
+ *
+ * Returns:
+ *   -ENOTTY:	No quirk applies to this device; we can't tell whether the
+ *		device provides the desired controls
+ *   0:		Device does not provide all the desired controls
+ *   >0:	Device provides all the controls in @acs_flags
+ */
+int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags)
+{
+	return pci_dev_call_acs_enabled(dev, acs_flags);
+}
+
+/*
+ * pci_dev_specific_mfd_isolated- check whether a MFD function is isolated
+ * @dev:	PCI device
+ *
+ * pci_dev_specific_acs_enabled() emulates the ACS flags using a quirk however
+ * historically Linux has not quirked every function in a MFD.
+ * pci_dev_specific_mfd_isolated() overrides the other function MFD checks and
+ * can consider a single function fully isolated from all other functions both
+ * for egress and ingress directions.
+ *
+ * Returns:
+ *   false:	No override, use normal PCI defined mechanisms
+ *   true:	Function is isolated from P2P to other functions in the device
+ */
+bool pci_dev_specific_mfd_isolated(struct pci_dev *dev)
+{
+	return pci_dev_call_acs_enabled(dev, PCI_ACS_QUIRK_ACS_ISOLATED |
+						     PCI_ACS_ISOLATED) > 0;
+}
+
 /* Config space offset of Root Complex Base Address register */
 #define INTEL_LPC_RCBA_REG 0xf0
 /* 31:14 RCBA address */
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index dc816dc4505c6d..2be6881087b335 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -277,6 +277,36 @@ enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 	}
 }
 
+/*
+ * pci_mfd_isolated- check whether a MFD function is isolated
+ * @dev:	PCI device
+ *
+ * True if the dev function on a MFD should be considered isolated from all
+ * other functions in the MFD. This is used to override ACS checks that might
+ * otherwise indicate the MFD function participates in an internal loopback.
+ *
+ * Returns:
+ *   false:	No override, use normal PCI defined mechanisms
+ *   true:	Function is isolated from P2P to other functions in the device
+ */
+bool pci_mfd_isolated(struct pci_dev *dev)
+{
+	/*
+	 * For some reason AMD likes to put "dummy functions" in their PCI
+	 * hierarchy as part of a multi function device. These are notable
+	 * because they can't do anything. No BARs and no downstream bus. Since
+	 * they cannot accept P2P or initiate any MMIO we consider them to be
+	 * isolated from the rest of MFD. Since they often accompany a real PCI
+	 * bridge with downstream devices it is important that the MFD be
+	 * considered isolated. Annoyingly there is no ACS capability reported
+	 * so we assume that a host bridge in a MFD with no MMIO has the special
+	 * property of never accepting or initiating P2P operations.
+	 */
+	if (dev->class >> 8 == PCI_CLASS_BRIDGE_HOST && !pci_has_mmio(dev))
+		return true;
+	return pci_dev_specific_mfd_isolated(dev);
+}
+
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
 	struct pci_bus *child;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2e629087539101..d95a983c835666 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1256,6 +1256,7 @@ void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
 		       bool (*reachable)(struct pci_dev *deva,
 					 struct pci_dev *devb));
 enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
+bool pci_mfd_isolated(struct pci_dev *dev);
 
 int pci_dev_present(const struct pci_device_id *ids);
 
@@ -2078,6 +2079,9 @@ pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
 static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 { return PCIE_NON_ISOLATED; }
 
+bool pci_mfd_isolated(struct pci_dev *dev)
+{ return false; }
+
 static inline int pci_dev_present(const struct pci_device_id *ids)
 { return 0; }
 
-- 
2.43.0


