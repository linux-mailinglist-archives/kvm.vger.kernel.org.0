Return-Path: <kvm+bounces-56898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8461DB461B4
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 261333B64AE
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC33393DC5;
	Fri,  5 Sep 2025 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ut2rLNVh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0FD37289D;
	Fri,  5 Sep 2025 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095598; cv=fail; b=O0MANH+Q/c2Rci2oKI17VISwmmgOROgNG723CzpJsaRYH0pWk9YkICCMLk4l1J8QT9eFZxnwYETi+TDij+ciT85O7SPhLMjsfZfJ9cJL9vKOadnIzp/5X85p6m+mYZ31WmQyNaw8/VSrwc06HWvRC8Pm6KLyQW+ssQNpKyGFeSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095598; c=relaxed/simple;
	bh=J8j0hyobKGjpEzfUJkM1po1tHD5Y0kortsJrp3hNUZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UW9rD2vBAyb7yW2ONGkuI4UoDbtFpws0tckfX+lpika9h8CZTTlB/6Zqgp0zgtDDaSDfhb2TvZ6FouIrsTQEbM0YokY1KUBb5O+XFI0i0b2ieFm4AHxqFFibJjrZQFpPD5bvgf+eUeUZEqCN1moMtsZaJ/2T3PtM3jYwJMWUy/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ut2rLNVh; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nq/bwRKGfk0PNEJtXy+aQWrJ2LpcMC+D/V0dx8PHzJ8s1llTPmEAYJPEl0TcU0y/tc2JbzBQh0dubTLDQLTNedYhrutyDE4iXQuQ79dx1mUoYUdfwigRpIfnzhvhpIx+jTUBdqxUVC67tIaQkyMV9qWo2QDHs1+Qme1ywXlnhBRyhWRXieEKm/eTDH547z1fJabtxlO6JVL6246D5NyvXN7fCU5D0JADlfHQAohvSWkZ3s+5M1uhlV3zyclAuj4fDR4lWXRJWhibMUbjnIeiMe/hNqwDYDOP7RJdIr596zkCRq+ZXw8Kwt930L9h4gcWKS2E8oNaoDwsa5mULzkeiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ns5YRS3pjSixFQUoprRq4zIPic3IzEtiJRvda8t/FFE=;
 b=PYxrEzhRByrJgzhLQPRcu3jfpbmzX6/BfoynoWX/228PIC/IjirUhh+4BGxEfY0ZqAq20wvVaLwjog5C0JbT8V5IrBpsaedQyJQvNFyrjB2zUHJ/kVw1E8ebbH46V2AJ0MzVJTQi0Rv4MYZFQ2uO6QZRuo0qrEzh4mJjXKu1YPqS1E4xjQLbEg3HdU39W+45lWsFoN7AjEihxfORJhNs3Ut/6M3VI/nTtrTqFljZ6Y1xgrpMchPROrFemqlF8FCFwAiDW/sIPH5BuLEImeLupvax+SwIpBvx8fKhWCk2e1FkEQUnsOE0RaQhpRWe4ODXHSz0dVOXSujDQfzgNfOgCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ns5YRS3pjSixFQUoprRq4zIPic3IzEtiJRvda8t/FFE=;
 b=Ut2rLNVhPDasmrJc413vxDrpLywqeK/AOoBmGy/csblbsUUfl7EfWgVPmyGvB1fq8g/f8JGJSsMPKNBEuVDzjOMeUXMC3ug3/4vf9JVh8oU2l41ahRtbmGDZzL2a1i2r+gfpSc1e8OWLtLFVDne5HAmB426nbQot2Lw9+ijI/ygoHjNPJx//097YtC7YRTyuNowEITJX4VNzDakwEC8w3OHbDEkkBu6AQ22eEhSJ41F+O8n+BaVMu5i+IRq541oB1hQzat0XE/1kKbHlYd3ULY5sN55WmJbXOLpboM+6uOPrKcDUGy/5yYQ70EQPum+Gjm+FXTTstsEkNzPTyVhqKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
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
Subject: [PATCH v3 00/11] Fix incorrect iommu_groups with PCIe ACS
Date: Fri,  5 Sep 2025 15:06:15 -0300
Message-ID: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::15) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: f3afc60d-268f-43b2-d301-08ddeca6f0b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iuWomNZdNxaYmN9yB82Mcr6Mk/MpWtfRSNgQsoOxPw94yu/dkxET2GKOT+rA?=
 =?us-ascii?Q?uhg6X4pzhg7pbu42Ekiozj62No7GCyE4HgYaZ4PBIPTdnTvmjlKMF+deJkiv?=
 =?us-ascii?Q?QQZ+B4k9yCGaxBs5X6W1diuDNUNgYhBFwyVOujoPm+xY21wAathxtzFzvyW4?=
 =?us-ascii?Q?Y/Rn7XJP9WYhMzff9/DjA9wVNVxIFmClmA3jNyCOWgdIoSWxia7As/z94vuB?=
 =?us-ascii?Q?UQ7VuOG83+7TGQeA2LgMaqyhPq9TOISYs8TFDzZrtbVRgyDaiF1sjGSZfM3G?=
 =?us-ascii?Q?XtGW6yhZ7zWhtQy4hiu7WDi+gEZGDVaE8RFyEHrbkzeCQ+SrTEcLHxuwK7Vu?=
 =?us-ascii?Q?Sr6gfcr2l6V5qIJaMs2Cw8PnsmmIsOUeLa4F+DVVjfu9gRax58GW6eY6EEeX?=
 =?us-ascii?Q?o4HmEO9PPQ2Jp2c/OU+qbXlL0mgoV0Exq3JXuiMntVa0oeortANDdsSAL6sC?=
 =?us-ascii?Q?dOiZpMbGCALPXTBhaBVGiA0OZvH7f1vjWfI/itXRBz7/0lhnM+rDcWWjFwmP?=
 =?us-ascii?Q?umSyiPn2hxL4IwUPwP1LzwcrIXhoGy3ksvHBUcXncHRa0kXbgHPFfU8DhrFN?=
 =?us-ascii?Q?btQxyr//SPKUbPg/Pmesnudls9Zv0thbSO8vKzd3oS8NvBnExcwlQr+FFgwk?=
 =?us-ascii?Q?mJ2O2azhQp66L9PJ6MeMylgr6tEonn3XS+aWogfkipCPDG7Q9O61HaoNy9nV?=
 =?us-ascii?Q?xoXfU5AZ3qJ36Sa+0KJBMWD9i2q8ZfhOIKxEisX5HZbHtJhoEZGT2eFm5USW?=
 =?us-ascii?Q?kp5Dz7+WT4mCyoCyE+QPRLwH6grrJKqaw1lh/WRtMbC+4N/EsPJS/DIUtKC0?=
 =?us-ascii?Q?EU1LfE1idUvSK0L9RkNhSGEEV9Sh0kRXGcyuF+ma/U+J76XLV1zsgrftJ4Bu?=
 =?us-ascii?Q?jQzq9kHffRSGFC0cRt9fo0rsHaQvmjavS1unZIWrReO2CsZROByGB5Sq8P1K?=
 =?us-ascii?Q?1/Ah8yCosnKKVC4ppAiA0lsS3b381B9oFbk2hEAW//jNMz3KnIlaHhlm7o9G?=
 =?us-ascii?Q?IKawTetDLKpQi1YmUAwL0IG5aubvArAVn5LTyM2sc1zhW5Guq6NiZCh+6eAT?=
 =?us-ascii?Q?E2aY+B5LSWJhUxDqbQB6xk9tO0hs7ODVgPeoRvMSdEsMwP8H51Gf4Teowi26?=
 =?us-ascii?Q?5QJC50GCMymJOsrWQKopZYuK4ZwIH/IxpP0TKaXEVvybezksWgsWiOBw2H3x?=
 =?us-ascii?Q?BX90aT1wZWO5WA6TsCZSYgWXOD6T4EGEZ1RE5/bnrZf/FRE3Tdba3drPvEMx?=
 =?us-ascii?Q?k2+rFwEl159MgApSbwu32bw7/oMiQGjtn2/dO6vN+lCg68kVWck8QfXevaJO?=
 =?us-ascii?Q?PzIiMfkLRbqgr2uIfLYntH9RD0axf0xpO4Ho7uO/7Y2bn4obRCaHy6daP7o4?=
 =?us-ascii?Q?0W+7C3NeKIcRqvREeuv9iTdcYmqzgcHZUmDiOUjUedSYC6PYawtD36ZOGOfs?=
 =?us-ascii?Q?qynBhXaAdis=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lmiuZ05gugLXZFlbMvyICFgNv/nIoMzuM19uEp8IHwpc2LKIbcoL7pPtDMyB?=
 =?us-ascii?Q?5HQFYkrmgDJG53G4AJ6oe4BnWX1z/Uq1ATN6I9bJu95JIUt62bAT553y0HPF?=
 =?us-ascii?Q?yR/6omhxkWNB6NhVNBO+P5gleVPC6Bmu7KyuPEjdfp4t2ZdU81MCNyIYAnd6?=
 =?us-ascii?Q?pJ8vv25PFGmbvUE9EPi+l1+SZKOD+gbqAw/Fg4rcXOX60J4xMXfC08I5fbRB?=
 =?us-ascii?Q?X5UToe9m/03KjIzW3sitgQHl5ssx0LLNkAisbnyLtwGmN7r+l2StkPpQHMT3?=
 =?us-ascii?Q?P+/zfbaT7jWEoxwwINCtYGXik4Vocky0a5ZigXIvLR3+9l0+Du+i7rpSfNpb?=
 =?us-ascii?Q?vtYcZ9Y65/OuybSZk7TrY1s+WHj+l5GbFKVHuEyFzBqE/meR4yGBiuFIbVMS?=
 =?us-ascii?Q?g8ywYhK+R2RleokfBFIF77PKd1kbHmJVJnPq4HlPsV3YylYJMRnKKhGvi8vI?=
 =?us-ascii?Q?ndIETz9Z8qD4RvPsTXf5BYDinhO8XdOO2/9s2P8SWKfDKsxijuz5RTB+iUAm?=
 =?us-ascii?Q?Ry/j2GCQHw2MaR/YzXtsR30XjxasokseNPC9Esz+e101o6u/OW+ePAcyDEPe?=
 =?us-ascii?Q?XQeyVrn7s4IVzHdXnHnzOc7h/oN5XtJAzcYU9mHuA66NDMhqv+pZboWD2/ss?=
 =?us-ascii?Q?ewXTG/rqN8RT27feeKYN1D6vqyj1iiTYDBUmGFTlwjWBq48NEyZPfCgxTA2p?=
 =?us-ascii?Q?TpiIe0O6kh/Usmo4l7YyNvYENmVz4lPljynmCQY5+sIpRFTIGv0jeOr/Yzvz?=
 =?us-ascii?Q?Ag29Oah656wNMlMjZylCcE6Je5fDg5zWFWxwXu/ueggNYLueT0cuVYP5zoS2?=
 =?us-ascii?Q?/PXeOHh8My2mO2l1QtPiDVsOn8sPmLKK4i2VLFF8hhoQqfj47MYcpjcMkygk?=
 =?us-ascii?Q?PAKPCKyhwRQ7A0xrmWcDRavkqKS59J4L3gkp2ysT0H9LZ1EtQsFljtOqoIYb?=
 =?us-ascii?Q?QNj4hhPEpLQxZ+uBcTRmUXWwqctjAcCXZ8hEbchGFum5xsswHvB8UkAoZHSc?=
 =?us-ascii?Q?TLQokAu9SwpGq1ytMwtCmMJ8TCHlJe7Jv3SXVxupVuGHuXH1YvsttxG/sMm7?=
 =?us-ascii?Q?HgeS/vROtj+yjMJcyh/iNcXXig+C9ZV9yvTRs7o0qfRAfwdR7nLJWO2BuVaF?=
 =?us-ascii?Q?hyvbyzm3XwLECEww86upuEhN5AHtgMQ0VeUA/t0uDEyz6RtRTPX3AJogcFF0?=
 =?us-ascii?Q?N4/wLjvJR2WQh9fUYKBxUFDbFoeKVlOC5GNJPIDCm5XoDy1rH+1S4t8SPzRl?=
 =?us-ascii?Q?q2FZAkRT/nuxvst1wv6Kf7/cOx66vH62abmQri8a1xdbS2gXo8rOSbHlZw3Y?=
 =?us-ascii?Q?8ZuLDP/WDS2KfN87Y7AycUWrTOVoPDTWI/oo8zDvmHeuX4YyNis+5JVGuMO1?=
 =?us-ascii?Q?Fi2GaEHbo2xgE3oWNT/a8PwNazosjXkC6ql90v08zCh4bpXfGahFHTbL/5oR?=
 =?us-ascii?Q?TNlUze2U9ofI8jZA0HQ24A0ZDEpAEosXEYGDVcdmeZX5n0ik2QrVRqHnhE4A?=
 =?us-ascii?Q?SyO+2lFU9DNXJzr2q22YI0GqTAHqgZlTDC+KgXP34u4t/spaZCv8OkAhkhaQ?=
 =?us-ascii?Q?4xzuoAlj4sMcpNxAnkY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3afc60d-268f-43b2-d301-08ddeca6f0b6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:30.5090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlRbN2dz4b4KLDb60GPcaeycTCt73s11+WxaPyNm1UAoD/zLqAdFSm/pW0qIlNjf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696

The series patches have extensive descriptions as to the problem and
solution, but in short the ACS flags are not analyzed according to the
spec to form the iommu_groups that VFIO is expecting for security.

ACS is an egress control only. For a path the ACS flags on each hop only
effect what other devices the TLP is allowed to reach. It does not prevent
other devices from reaching into this path.

For VFIO if device A is permitted to access device B's MMIO then A and B
must be grouped together. This says that even if a path has isolating ACS
flags on each hop, off-path devices with non-isolating ACS can still reach
into that path and must be grouped gother.

For switches, a PCIe topology like:

                               -- DSP 02:00.0 -> End Point A
 Root 00:00.0 -> USP 01:00.0 --|
                               -- DSP 02:03.0 -> End Point B

Will generate unique single device groups for every device even if ACS is
not enabled on the two DSP ports. It should at least group A/B together
because no ACS means A can reach the MMIO of B. This is a serious failure
for the VFIO security model.

For multi-function-devices, a PCIe topology like:

                  -- MFD 00:1f.0 ACS not supported
  Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
                  |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
a spec perspective each device should get its own group, because ACS not
supported can assume no loopback is possible by spec.

For root-ports a PCIe topology like:
                                         -- Dev 01:00.0
  Root  00:00.00 --- Root Port 00:01.0 --|
                  |                      -- Dev 01:00.1
		  |- Dev 00:17.0

Previously would group [00:01.0, 01:00.0, 01:00.1] together if there is no
ACS capability in the root port.

While ACS on root ports is underspecified in the spec, it should still
function as an egress control and limit access to either the MMIO of the
root port itself, or perhaps some other devices upstream of the root
complex - 00:17.0 perhaps in this example.

Historically the grouping in Linux has assumed the root port routes all
traffic into the TA/IOMMU and never bypasses the TA to go to other
functions in the root complex. Following the new understanding that ACS is
required for internal loopback also treat root ports with no ACS
capability as lacking internal loopback as well.

There is also some confusing spec language about how ACS and SRIOV works
which this series does not address.


This entire series goes further and makes some additional improvements to
the ACS validation found while studying this problem. The groups around a
PCIe to PCI bridge are shrunk to not include the PCIe bridge.

The last patches implement "ACS Enhanced" on top of it. Due to how ACS
Enhanced was defined as a non-backward compatible feature it is important
to get SW support out there.

Due to the potential of iommu_groups becoming wider and thus non-usable
for VFIO this should go to a linux-next tree to give it some more
exposure.

I have now tested this a few systems I could get:

 - Various Intel client systems:
   * Raptor Lake, with VMD enabled and using the real_dev mechanism
   * 6/7th generation 100 Series/C320
   * 5/6th generation 100 Series/C320 with a NIC MFD quirk
   * Tiger Lake
   * 5/6th generation Sunrise Point

  The 6/7th gen system has a root port without an ACS capability and it
  becomes ungrouped as described above.

  All systems have changes, the MFDs in the root complex all become ungrouped.

 - NVIDIA Grace system with 5 different PCI switches from two vendors
   Bug fix widening the iommu_groups works as expected here

This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups

v3:
 - Rebase to v6.17-rc4
 - Drop the quirks related patches
 - Change the MFD logic to process no ACS cap as meaning no internal
   loopback. This avoids creating non-isolated groups for MFD root ports in
   common AMD and Intel systems
 - Fix matching MFDs to ignore SRIOV VFs
 - Fix some kbuild splats
v2: https://patch.msgid.link/r/0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com
 - Revise comments and commit messages
 - Rename struct pci_alias_set to pci_reachable_set
 - Make more sense of the special bus->self = NULL case for SRIOV
 - Add pci_group_alloc_non_isolated() for readability
 - Rename BUS_DATA_PCI_UNISOLATED to BUS_DATA_PCI_NON_ISOLATED
 - Propogate BUS_DATA_PCI_NON_ISOLATED downstream from a MFD in case a MFD
   function is a bridge
 - New patches to add pci_mfd_isolation() to retain more cases of narrow
   groups on MFDs with missing ACS.
 - Redescribe the MFD related change as a bug fix. For a MFD to be
   isolated all functions must have egress control on their P2P.
v1: https://patch.msgid.link/r/0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com

Cc: galshalom@nvidia.com
Cc: tdave@nvidia.com
Cc: maorg@nvidia.com
Cc: kvm@vger.kernel.org
Cc: Ceric Le Goater" <clg@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (11):
  PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
  PCI: Add pci_bus_isolated()
  iommu: Compute iommu_groups properly for PCIe switches
  iommu: Organize iommu_group by member size
  PCI: Add pci_reachable_set()
  iommu: Compute iommu_groups properly for PCIe MFDs
  iommu: Validate that pci_for_each_dma_alias() matches the groups
  PCI: Add the ACS Enhanced Capability definitions
  PCI: Enable ACS Enhanced bits for enable_acs and config_acs
  PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
  PCI: Check ACS Extended flags for pci_bus_isolated()

 drivers/iommu/iommu.c         | 510 +++++++++++++++++++++++-----------
 drivers/pci/ats.c             |   4 +-
 drivers/pci/pci.c             |  73 ++++-
 drivers/pci/search.c          | 274 ++++++++++++++++++
 include/linux/pci.h           |  46 +++
 include/uapi/linux/pci_regs.h |  18 ++
 6 files changed, 759 insertions(+), 166 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.43.0


