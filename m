Return-Path: <kvm+bounces-56907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 18A09B461C9
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0275F4E473B
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3104303A22;
	Fri,  5 Sep 2025 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MrU+rs01"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2ED31C56A;
	Fri,  5 Sep 2025 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095610; cv=fail; b=tJEEEoirM0Av+xMMT/mzdpJe56I6u1PgFQ6jNpANeXM7Z12po5DWMY6ADlloAwqk9ZSJ3OKq2dAMt5lLT5g9/035tzJWBa1xpBFK5V/wTvZihe2HfTfhWdp97o4a/Q/9lSnlYMfxdAe8wMOICbcQk2kmLZh5wI33ZQl1sboxsIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095610; c=relaxed/simple;
	bh=m98sWMtpgojAyLkb56M1ZMihrsOmH2G+yBzc0kz697A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H8LxqumMZjSo93LGCk1lehObOH4zTjwUVrEZWU+y+432S+kyThHY715iY2r+Yjuq1l4COPZXsVj3j7pttyROMJj3eoi7YHTBT+vNf0Kelj9g/Xf5zPxcCQIm9HBqn47friTjFGf8heG8FF8KYQMADO3vIxpqkoMEzXAcjRQKMRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MrU+rs01; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k24BX6UGIXIvHGBkC58BqKETXzBnNBawO1Yj8XD+CvVv7AkHnGbyTA2DhFdxI6JCm5fRDPOrWZCoM1NX8nesCmBG2Z6zsFCpz6p9E0OEmyYYTMcjPBerwek8yKgz0dQw9Fc2DnuryAsXTtBggSK3ldS3uh/zDZNb0fDEReXd2Rmr2i8jPuFabZTPufbgupvotIK+7kg4xwtXPlt7tTpobmn7jOoOhncR9NI0Y5ExB5lNpqpxm0jtFPESn4hWLQYWsjPcabqWJI1m80LQiXJtxluhYPLHxLlsoc35nOLAYXcHgMxlX/IJ+FdO1ONf3Z5cKbtOsmVNeqAwUbbynTeVLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nTGCQOX40S2ssB5ywdamDJkDG5W6y5RGCwWVk/TqaQ=;
 b=Xfi3oBU4ej3q94vs9fbLZLLx9prWcu1onWV71cfVctAKZKI7IqI8TIW33491uyrDwHbtNFH+yppmNptCT5AwjmH3ifnVtcpZHYR6biZGPwIJob+sZXKdgiNGW9vBWttVvt7+WU8gHOU9lZ0dElKBs2bJ84iKrh9olmruAscp4XmBv1z46l5Liro8L1RewQ7/zMG2+K6bYi+a2/ht8asEAKRa5p9dNFuXZ7sk0KCvN7rUSkyMBR6E4RefCQFL5ernX3yScxmrKvhpqCVKU9MxIcyhL+aKIKwUlc/srVaUgI9DQJQWm6H4xqqemgpxaD3pRaYPy9YLKiEOs9BjfLbdSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nTGCQOX40S2ssB5ywdamDJkDG5W6y5RGCwWVk/TqaQ=;
 b=MrU+rs01ehBxhM1SOhwd1CMd0cfMzPXqTWlIR6pnjZbSp/hJx4RRKhQ14s1AZQWmN70LJYvSWgFbLEVStqMkEhUGJrwcn8ifhuyn9QRaqTtWlJzshGC1CnoNeq81h5QXH+KLAfLbSiyvVLoc3O7KZ3R9NNSA07J2rlo0hxWejrXPTGFaJ06n97IjzE+heteY8be8NECeL+i5Exv2FD5S4Lj7/Ib782Pt6tZE9mesi5qHr/7T63OVYrF7wU/lxHJ5oiDY4BO9DM8p5Q8hj6TDuWjBwh0CZf7+jxmVZTFnQ4ioYJXdoRI+z/4B9yg/QI9LktpM8Lo+LHDrTsAyRFovbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:36 +0000
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
Subject: [PATCH v3 03/11] iommu: Compute iommu_groups properly for PCIe switches
Date: Fri,  5 Sep 2025 15:06:18 -0300
Message-ID: <3-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::26) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a1d69a9-2b6a-49f6-c77a-08ddeca6f1ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sd3S1hxP2OQzcXEotZWTUat8y0aj36UmTPEG7rN+Md+vaOhYTiLf51nx3pGb?=
 =?us-ascii?Q?UwRtplkpvRsgJKx6okel2avOJ5HAw7Fd6mj8Xk+UXimv1ojVejHOlyJv4kJQ?=
 =?us-ascii?Q?byc6WkhmMjo6aRM9HahP4zwsffzHGLjex2EK3fOuafGi/nXzwGvhVFP1eAqV?=
 =?us-ascii?Q?Oh+8QDFs3d3Gm4bem4GwLjuYtetWXvIufJxs3iWKQH+gI8HbhpwjxXqMDHrk?=
 =?us-ascii?Q?LgXCUg+1dF+n4+Zok4aQCvRKGRG5CLssnkN84oCoxs6ShHXoG+Ekl4fqrrSP?=
 =?us-ascii?Q?1JazK6DoJ1/cySHrZj0X9iC80dBuqBhKuQCaBnQkGpekIkskyXBqQrz8vJD9?=
 =?us-ascii?Q?UE/n1EePb1JCXoDF8Qi3NWWMANNhFmwph8nKF5IN5cQ2X02tgz6Aklo3fw+Z?=
 =?us-ascii?Q?iMjznJJIT+2E4gd0uhRBirk/QNMa3GaWvIs7pLwRmi2C986JV6itgrgHSFlm?=
 =?us-ascii?Q?iNSWJfQirhisOypogbSXVyaxaVqqprlBVQnniHpKmwVnBlYQjip0XIStTCYs?=
 =?us-ascii?Q?JJPvUJqHJpPv6tgo6MC+1Hwuf+miyN3qMhDnujdu7WR+NF4Z2HRxn7nKLTcg?=
 =?us-ascii?Q?xF/TdeqZgZvxXpFQN4cLnI4OqAf2li8bOtaCySjRbRna0Jpg5SX/T5mbQQ+S?=
 =?us-ascii?Q?JzWVa/9SUvjgMc5jwBHqcxjTq8jV7pzCotLMTW9f4SxmgD0lNgvZT4zud8+/?=
 =?us-ascii?Q?tOlf5G/zV1+gL4AsllAXU7OcD8913Zo9TlquMLjTNtLL0ZNGp3ly8A7oThmb?=
 =?us-ascii?Q?/DNAhor5QxzylRFy0e8Kxe3+A0MGnQLYunaXq3POr6Bimm0GIogDoYN/ur1y?=
 =?us-ascii?Q?F6m4J23hNM7Le8IksgoxyS8qwd46j0/pnJ7W8EMcKqR2PaQ1AelOxwYtRc48?=
 =?us-ascii?Q?Lyn2BPNP4Xj8JmklFK6L+o3aZktik8CUWglNVducHlqPfAJ9pulLO/+grzKS?=
 =?us-ascii?Q?/dnz7D2Y9cggYfCV52vavmxu5jB1IW+4oVy7efR09azJf5kYASd8GKzSmmgl?=
 =?us-ascii?Q?c/l+IefjVDXkGj8j7hdcHVH1vFzEaILMlwUBygghQiM2Djk4l8DgMjlouPvi?=
 =?us-ascii?Q?E9wbYBunP6uxtJWRdN/afZ+dFstHi1xkinixYXAb3y77xeXVrsC1wi8CCcD0?=
 =?us-ascii?Q?vVFPjRTKcYRoIGNY1KAd8MLmB2l4t2A5QNqsaXb1M1oCcY83f3/l8cSVJwyX?=
 =?us-ascii?Q?fqaMHo1zVECEIqGmqaTZ67dV+95NcfeNbOm466U/aUQ+DPzDz2pRCAnmNJMK?=
 =?us-ascii?Q?LbLuhEsFtTkUjwz4vbZK/8nTxQWNTJY8ZgqsA5YIXzirKwlDl9R/nKLVsC+s?=
 =?us-ascii?Q?BuBJOAAU7x/Dc6Jhpg5iQEPEHryYkRyjbVyqnlocpghdprjYYKj6rY4hCQPL?=
 =?us-ascii?Q?DR30WPRHAARq8pMWZDjaiOtSOeTuCF/nDfurQ4RiA/hJ6HZItgDbkbXtX33k?=
 =?us-ascii?Q?fNlBc4SXPak=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ARhDZylPY4oBOyHLusBRCrQYcxoGU+SEy/mBiCeYTcFqSY7SaOKM7cd9ChGK?=
 =?us-ascii?Q?BpXUqOpSTGxtgn5deyxH2s71jEjf6Ix9CuPuhU0YSqNLAUxxLUGuYCM3GCjl?=
 =?us-ascii?Q?6l5Z2wjhO/aJDYtoeAkpMaC4R5CF5W69PGDUWeWkLs1dLm7YXmuhfXMicDk6?=
 =?us-ascii?Q?b4rgZjTp8udel16BMObAoIJO9b+7Kjh5orwBmxXRrloc7qEbY7RjoHdHvq3F?=
 =?us-ascii?Q?9FZe0sOb8gNkKRjdT1edOk7pX/ENihrKv4FUbzSg0K+VaAug1t8GDkpu3Hre?=
 =?us-ascii?Q?sIzx/kP1sqIMjSVcyxa0jj4iRHHXVPMVzhEryS368JYw7/UNRCgIrxQ+hNpB?=
 =?us-ascii?Q?O2C01PXlLp5D+swICzoM/cOcUBUzEoIYWfNH/wFKu1gXpYN2iocYxYYkQkkW?=
 =?us-ascii?Q?Ae566L+Z7Lx2yBydnaVk5YQlFyBg+niaggugf/4FcZm1v7NsiEQF7JCPRUJR?=
 =?us-ascii?Q?YJeb+o2xr/gMJ8avDf8c7mKhi3v5qYoEGJxeY1idlAtW/h5sYtd2CJd+D7pe?=
 =?us-ascii?Q?9vBtp5zjIDiKf5Q1B/6M2r1yZ5/acMta3fKkNL7inc96gh1B3Ba0evPEFwLH?=
 =?us-ascii?Q?r503bPAREqdET5eFLRJgKDaZuJk1GRyCbJdhTlMqWhRG7DF1IBmU5Q+fQwp5?=
 =?us-ascii?Q?oKAK+UH3V5SvziCH+ZcjQDoJTAg2QJMfpA230wy55nXlSj5SBY0bnhgHsf66?=
 =?us-ascii?Q?sAnjMw50U37rYmchcO/9cb3Hc187piB4Z1rq0PerNBkTsCDJ/fdAMXmgRzyy?=
 =?us-ascii?Q?35jj3k/bBVGkF79HM6655wmqYxljMezfVdoGTiBzJVOA2wvQrlRAYnPh00aQ?=
 =?us-ascii?Q?FFQOH1mEk9UVvOvZvFeeKpMUGWUtIEAmaHKigso3REkICnsONt0tFatVDrXh?=
 =?us-ascii?Q?4MrYu7oBbQvTMGABRjAaR69nCSVihb4X9VJsrcCE6kk40+axuHqASGTTWeSE?=
 =?us-ascii?Q?PzfOLC7u+a5HcPqNgzDM5tac+yO8qEoLjWN0GWCXxH7Cz7qO3N/5mdtogaNz?=
 =?us-ascii?Q?OWFXS8pcDnOFDQzraljYymKv726llIkuFiTWdGER9whn+dNrSHqPjaLIbUyO?=
 =?us-ascii?Q?xIEkdTYl+z5c4gSFmz3T7F9N7HX8Ejj5vOzX353CP+9zI9/NlEiHL98OmobN?=
 =?us-ascii?Q?7kiIsUvx0ybLujCBAINrExtjN8A39f7no1TAERKUcQEJU/B6gxWOIPFimAIW?=
 =?us-ascii?Q?mUAhSecmcsw9+ev8qJOlOlMdorcyAKdplf5fgx2UMOhTKY+IUQ3dXchNkwz3?=
 =?us-ascii?Q?RQ7Gtggscx5mquOwsr8KSbKzVK05H888nlqHR29zXSG+a4EiX4gBLcAIgbi1?=
 =?us-ascii?Q?d3znRXeLt4c1zr1mEv1QfDp9IsuOrQG0rj2eHXW6wYW2dy1f5TmIhjRiD9eX?=
 =?us-ascii?Q?GJQyiRNaPQLdhabhTrAOd2YDyjZ3wv7DbfaDB/sOn4+cq2odhcN90iptVeRS?=
 =?us-ascii?Q?FfRvpKZVWl3/+xECxdZfy22b61RHF09xoPP13+HKu9q5hbn2/wW6Jk5DMzIC?=
 =?us-ascii?Q?+D/CfBYsIzwbQ8cHqgxb9hhTMt4gMFQvRGZSPMR+og8+uvsAW2HSD1YJ/B68?=
 =?us-ascii?Q?oySSkmxDP8lBc3qarMg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1d69a9-2b6a-49f6-c77a-08ddeca6f1ae
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:32.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 37UD4RbDuzA3yJMrY6yuS6hX8EphqIbQqwL0e9pEs8/+NHc4+aEP9z8kyKtEZOoo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

The current algorithm does not work if ACS is turned off, and it is not
clear how this has been missed for so long. I think it has been avoided
because the kernel command line options to target specific devices and
disable ACS are rarely used.

For discussion lets consider a simple topology like the below:

                               -- DSP 02:00.0 -> End Point A
 Root 00:00.0 -> USP 01:00.0 --|
                               -- DSP 02:03.0 -> End Point B

If ACS is fully activated we expect 00:00.0, 01:00.0, 02:00.0, 02:03.0, A,
B to all have unique single device groups.

If both DSPs have ACS off then we expect 00:00.0 and 01:00.0 to have
unique single device groups while 02:00.0, 02:03.0, A, B are part of one
multi-device group.

If the DSPs have asymmetric ACS, with one fully isolating and one
non-isolating we also expect the above multi-device group result.

Instead the current algorithm always creates unique single device groups
for this topology. It happens because the pci_device_group(DSP)
immediately moves to the USP and computes pci_acs_path_enabled(USP) ==
true and decides the DSP can get a unique group. The pci_device_group(A)
immediately moves to the DSP, sees pci_acs_path_enabled(DSP) == false and
then takes the DSPs group.

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

The current algorithm has several issues:

 1) It implicitly depends on ordering. Since the existing group discovery
    only goes in the upstream direction discovering a downstream device
    before its upstream will cause the wrong creation of narrower groups.

 2) It assumes that if the path from the end point to the root is entirely
    ACS isolated then that end point is isolated. This misses cross-traffic
    in the asymmetric ACS case.

 3) When evaluating a non-isolated DSP it does not check peer DSPs for an
    already established group unless the multi-function feature does it.

 4) It does not understand the aliasing rule for PCIe to PCI bridges
    where the alias is to the subordinate bus. The bridge's RID on the
    primary bus is not aliased. This causes the PCIe to PCI bridge to be
    wrongly joined to the group with the downstream devices.

As grouping is a security property for VFIO creating incorrectly narrowed
groups is a security problem for the system.

Revise the design to solve these problems.

Explicitly require ordering, or return EPROBE_DEFER if things are out of
order. This avoids silent errors that created smaller groups and solves
problem #1.

Work on busses, not devices. Isolation is a property of the bus, and the
first non-isolated bus should form a group containing all devices
downstream of that bus. If all busses on the path to an end device are
isolated then the end device has a chance to make a single-device group.

Use pci_bus_isolation() to compute the bus's isolation status based on the
ACS flags and technology. pci_bus_isolation() touches a lot of PCI
internals to get the information in the right format.

Add a new flag in the iommu_group to record that the group contains a
non-isolated bus. Any downstream pci_device_group() will see
bus->self->iommu_group is non-isolated and unconditionally join it. This
makes the first non-isolation apply to all downstream devices and solves
problem #2

The bus's non-isolated iommu_group will be stored in either the DSP of
PCIe switch or the bus->self upstream device, depending on the situation.
When storing in the DSP all the DSPs are checked first for a pre-existing
non-isolated iommu_group. When stored in the upstream the flag forces it
to all downstreams. This solves problem #3.

Put the handling of end-device aliases and MFD into pci_get_alias_group()
and only call it in cases where we have a fully isolated path. Otherwise
every downstream device on the bus is going to be joined to the group of
bus->self.

Finally, replace the initial pci_for_each_dma_alias() with a combination
of:

 - Directly checking pci_real_dma_dev() and enforcing ordering.
   The group should contain both pdev and pci_real_dma_dev(pdev) which is
   only possible if pdev is ordered after real_dma_dev. This solves a case
   of #1.

 - Indirectly relying on pci_bus_isolation() to report legacy PCI busses
   as non-isolated, with the enum including the distinction of the PCIe to
   PCI bridge being isolated from the downstream. This solves problem #4.

It is very likely this is going to expand iommu_group membership in
existing systems. After all that is the security bug that is being
fixed. Expanding the iommu_groups risks problems for users using VFIO.

The intention is to have a more accurate reflection of the security
properties in the system and should be seen as a security fix. However
people who have ACS disabled may now need to enable it. As such users may
have had good reason for ACS to be disabled I strongly recommend that
backporting of this also include the new config_acs option so that such
users can potentially minimally enable ACS only where needed.

Fixes: 104a1c13ac66 ("iommu/core: Create central IOMMU group lookup/creation interface")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 279 ++++++++++++++++++++++++++++++++----------
 include/linux/pci.h   |   3 +
 2 files changed, 217 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2a47ddb01799c1..1874bbdc73b75e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -65,8 +65,16 @@ struct iommu_group {
 	struct list_head entry;
 	unsigned int owner_cnt;
 	void *owner;
+
+	/* Used by the device_group() callbacks */
+	u32 bus_data;
 };
 
+/*
+ * Everything downstream of this group should share it.
+ */
+#define BUS_DATA_PCI_NON_ISOLATED BIT(0)
+
 struct group_device {
 	struct list_head list;
 	struct device *dev;
@@ -1484,25 +1492,6 @@ static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
 	return NULL;
 }
 
-struct group_for_pci_data {
-	struct pci_dev *pdev;
-	struct iommu_group *group;
-};
-
-/*
- * DMA alias iterator callback, return the last seen device.  Stop and return
- * the IOMMU group if we find one along the way.
- */
-static int get_pci_alias_or_group(struct pci_dev *pdev, u16 alias, void *opaque)
-{
-	struct group_for_pci_data *data = opaque;
-
-	data->pdev = pdev;
-	data->group = iommu_group_get(&pdev->dev);
-
-	return data->group != NULL;
-}
-
 /*
  * Generic device_group call-back function. It just allocates one
  * iommu-group per device.
@@ -1534,57 +1523,31 @@ struct iommu_group *generic_single_device_group(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(generic_single_device_group);
 
-/*
- * Use standard PCI bus topology, isolation features, and DMA alias quirks
- * to find or create an IOMMU group for a device.
- */
-struct iommu_group *pci_device_group(struct device *dev)
+static struct iommu_group *pci_group_alloc_non_isolated(void)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct group_for_pci_data data;
-	struct pci_bus *bus;
-	struct iommu_group *group = NULL;
-	u64 devfns[4] = { 0 };
+	struct iommu_group *group;
 
-	if (WARN_ON(!dev_is_pci(dev)))
-		return ERR_PTR(-EINVAL);
+	group = iommu_group_alloc();
+	if (IS_ERR(group))
+		return group;
+	group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
+	return group;
+}
 
-	/*
-	 * Find the upstream DMA alias for the device.  A device must not
-	 * be aliased due to topology in order to have its own IOMMU group.
-	 * If we find an alias along the way that already belongs to a
-	 * group, use it.
-	 */
-	if (pci_for_each_dma_alias(pdev, get_pci_alias_or_group, &data))
-		return data.group;
-
-	pdev = data.pdev;
-
-	/*
-	 * Continue upstream from the point of minimum IOMMU granularity
-	 * due to aliases to the point where devices are protected from
-	 * peer-to-peer DMA by PCI ACS.  Again, if we find an existing
-	 * group, use it.
-	 */
-	for (bus = pdev->bus; !pci_is_root_bus(bus); bus = bus->parent) {
-		if (!bus->self)
-			continue;
-
-		if (pci_acs_path_enabled(bus->self, NULL, PCI_ACS_ISOLATED))
-			break;
-
-		pdev = bus->self;
-
-		group = iommu_group_get(&pdev->dev);
-		if (group)
-			return group;
-	}
+/*
+ * Return a group if the function has isolation restrictions related to
+ * aliases or MFD ACS.
+ */
+static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
+{
+	struct iommu_group *group;
+	DECLARE_BITMAP(devfns, 256) = {};
 
 	/*
 	 * Look for existing groups on device aliases.  If we alias another
 	 * device or another device aliases us, use the same group.
 	 */
-	group = get_pci_alias_group(pdev, (unsigned long *)devfns);
+	group = get_pci_alias_group(pdev, devfns);
 	if (group)
 		return group;
 
@@ -1593,12 +1556,198 @@ struct iommu_group *pci_device_group(struct device *dev)
 	 * slot and aliases of those funcions, if any.  No need to clear
 	 * the search bitmap, the tested devfns are still valid.
 	 */
-	group = get_pci_function_alias_group(pdev, (unsigned long *)devfns);
+	group = get_pci_function_alias_group(pdev, devfns);
 	if (group)
 		return group;
 
-	/* No shared group found, allocate new */
-	return iommu_group_alloc();
+	/*
+	 * When MFD's are included in the set due to ACS we assume that if ACS
+	 * permits an internal loopback between functions it also permits the
+	 * loopback to go downstream if a function is a bridge.
+	 *
+	 * It is less clear what aliases mean when applied to a bridge. For now
+	 * be conservative and also propagate the group downstream.
+	 */
+	__clear_bit(pdev->devfn & 0xFF, devfns);
+	if (!bitmap_empty(devfns, sizeof(devfns) * BITS_PER_BYTE))
+		return pci_group_alloc_non_isolated();
+	return NULL;
+}
+
+/* Return a group if the upstream hierarchy has isolation restrictions. */
+static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
+{
+	/*
+	 * SRIOV functions may reside on a virtual bus, jump directly to the PFs
+	 * bus in all cases.
+	 */
+	struct pci_bus *bus = pci_physfn(pdev)->bus;
+	struct iommu_group *group;
+
+	/* Nothing upstream of this */
+	if (pci_is_root_bus(bus))
+		return NULL;
+
+	/*
+	 * !self is only for SRIOV virtual busses which should have been
+	 * excluded by pci_physfn()
+	 */
+	if (WARN_ON(!bus->self))
+		return ERR_PTR(-EINVAL);
+
+	group = iommu_group_get(&bus->self->dev);
+	if (!group) {
+		/*
+		 * If the upstream bridge needs the same group as pdev then
+		 * there is no way for it's pci_device_group() to discover it.
+		 */
+		dev_err(&pdev->dev,
+			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
+			pci_name(bus->self));
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
+		return group;
+	iommu_group_put(group);
+	return NULL;
+}
+
+/*
+ * For legacy PCI we have two main considerations when forming groups:
+ *
+ *  1) In PCI we can loose the RID inside the fabric, or some devices will use
+ *     the wrong RID. The PCI core calls this aliasing, but from an IOMMU
+ *     perspective it means that a PCI device may have multiple RIDs and a
+ *     single RID may represent many PCI devices. This effectively means all the
+ *     aliases must share a translation, thus group, because the IOMMU cannot
+ *     tell devices apart.
+ *
+ *  2) PCI permits a bus segment to claim an address even if the transaction
+ *     originates from an end point not the CPU. When it happens it is called
+ *     peer to peer. Claiming a transaction in the middle of the bus hierarchy
+ *     bypasses the IOMMU translation. The IOMMU subsystem rules require these
+ *     devices to be placed in the same group because they lack isolation from
+ *     each other. In PCI Express the ACS system can be used to inhibit this and
+ *     force transactions to go to the IOMMU.
+ *
+ *     From a PCI perspective any given PCI bus is either isolating or
+ *     non-isolating. Isolating means downstream originated transactions always
+ *     progress toward the CPU and do not go to other devices on the bus
+ *     segment, while non-isolating means downstream originated transactions can
+ *     progress back downstream through another device on the bus segment.
+ *
+ *     Beyond buses a multi-function device or bridge can also allow
+ *     transactions to loop back internally from one function to another.
+ *
+ *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
+ *     that bus becomes a single group.
+ */
+struct iommu_group *pci_device_group(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iommu_group *group;
+	struct pci_dev *real_pdev;
+
+	if (WARN_ON(!dev_is_pci(dev)))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Arches can supply a completely different PCI device that actually
+	 * does DMA.
+	 */
+	real_pdev = pci_real_dma_dev(pdev);
+	if (real_pdev != pdev) {
+		group = iommu_group_get(&real_pdev->dev);
+		if (!group) {
+			/*
+			 * The real_pdev has not had an iommu probed to it. We
+			 * can't create a new group here because there is no way
+			 * for pci_device_group(real_pdev) to pick it up.
+			 */
+			dev_err(dev,
+				"PCI device is probing out of order, real device of %s is not probed yet\n",
+				pci_name(real_pdev));
+			return ERR_PTR(-EPROBE_DEFER);
+		}
+		return group;
+	}
+
+	if (pdev->dev_flags & PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT)
+		return iommu_group_alloc();
+
+	/* Anything upstream of this enforcing non-isolated? */
+	group = pci_hierarchy_group(pdev);
+	if (group)
+		return group;
+
+	switch (pci_bus_isolated(pci_physfn(pdev)->bus)) {
+	case PCIE_ISOLATED:
+		/* Check multi-function groups and same-bus devfn aliases */
+		group = pci_get_function_group(pdev);
+		if (group)
+			return group;
+
+		/* No shared group found, allocate new */
+		return iommu_group_alloc();
+
+	/*
+	 * On legacy PCI there is no RID at an electrical level. On PCI-X the
+	 * RID of the bridge may be used in some cases instead of the
+	 * downstream's RID. This creates aliasing problems. PCI/PCI-X doesn't
+	 * provide isolation either. The end result is that as soon as we hit a
+	 * PCI/PCI-X bus we switch to non-isolated for the whole downstream for
+	 * both aliasing and isolation reasons. The bridge has to be included in
+	 * the group because of the aliasing.
+	 */
+	case PCI_BRIDGE_NON_ISOLATED:
+	/* A PCIe switch where the USP has MMIO and is not isolated. */
+	case PCIE_NON_ISOLATED:
+		group = iommu_group_get(&pdev->bus->self->dev);
+		if (WARN_ON(!group))
+			return ERR_PTR(-EINVAL);
+		/*
+		 * No need to be concerned with aliases here since we are going
+		 * to put the entire downstream tree in the bridge/USP's group.
+		 */
+		group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
+		return group;
+
+	/*
+	 * It is a PCI bus and the upstream bridge/port does not alias or allow
+	 * P2P.
+	 */
+	case PCI_BUS_NON_ISOLATED:
+	/*
+	 * It is a PCIe switch and the DSP cannot reach the USP. The DSP's
+	 * are not isolated from each other and share a group.
+	 */
+	case PCIE_SWITCH_DSP_NON_ISOLATED: {
+		struct pci_dev *piter = NULL;
+
+		/*
+		 * All the downstream devices on the bus share a group. If this
+		 * is a PCIe switch then they will all be DSPs
+		 */
+		for_each_pci_dev(piter) {
+			if (piter->bus != pdev->bus)
+				continue;
+			group = iommu_group_get(&piter->dev);
+			if (group) {
+				pci_dev_put(piter);
+				if (WARN_ON(!(group->bus_data &
+					      BUS_DATA_PCI_NON_ISOLATED)))
+					group->bus_data |=
+						BUS_DATA_PCI_NON_ISOLATED;
+				return group;
+			}
+		}
+		return pci_group_alloc_non_isolated();
+	}
+	default:
+		break;
+	}
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(pci_device_group);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c36fff9d2254f8..fb9adf0562f8ef 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2093,6 +2093,9 @@ static inline int pci_dev_present(const struct pci_device_id *ids)
 #define no_pci_devices()	(1)
 #define pci_dev_put(dev)	do { } while (0)
 
+static inline struct pci_dev *pci_real_dma_dev(struct pci_dev *dev)
+{ return dev; }
+
 static inline void pci_set_master(struct pci_dev *dev) { }
 static inline void pci_clear_master(struct pci_dev *dev) { }
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
-- 
2.43.0


