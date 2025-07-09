Return-Path: <kvm+bounces-51965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1937AFECBB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787FE17E250
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF662E8E16;
	Wed,  9 Jul 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sFadABOp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A582E8DF9;
	Wed,  9 Jul 2025 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072753; cv=fail; b=bsD9icvEfNSFnn0531uFIpN3oCCYMrE0PB+1Sj0o5qH/q50RwL7PKoX9xTmzIz61A9ZE/hrwPDqJ4fyOASY0moZigjiW6hLs8QnM3g3jM/Fr+v91WOTOLtKSxpT+r/gbXS+x+vGSbrCgyixAEO0C2EoNL1B6lTBABfDhV/O+qTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072753; c=relaxed/simple;
	bh=G8ZXlDZACNcvxZmtaNtyBU55En1+aOluT9iDlELUl1E=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BsPwJ+eTjKuVDuaDttUtJjpcYusH7reeoab522mKsxpefvuldnptgu6Rg5RQg9wTalgj0QnszuUFkRR2HC7V0mNXhpGbLe2fOvGnMhCxSF1lHb8RTPd42Xy/k/vf2Yui5gsKB9j+m1+SY/FmE7cgPYVAC+fp8Je+YdK9KyCLehc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sFadABOp; arc=fail smtp.client-ip=40.107.102.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZhVTqb1YYVd/z8PcU265K+k0UVMSMqJql10lMwq+hXsCoPtqOPnpSN2gCLpPPV7BoQATOTRUYI1j0KN3PsIZ6fBF+u1N1UssUUxTBnyyt5dixNygrnzzDmoy0e2AwDBKnSH5KCZYz1y7WMZXWk2qfeXnp0Hu51tN2AryT/+5Z0+OXLw+TcxzcjtLt8obkBVWfQHwphn5UZITcXHYWwtj4x5lxzhcmWhjsti6HM8BUKHkkWRI95yRe3Zw9P7cXwWkvduE9MsU1M/w+LfuNHKCX8D4j6KgXeMUE6W819Llk6MSlIWcsg8tc79WQrvayBYGEmi81uwUUHgG/Sd2apbsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEw7ThkUOvmnbZBTcyj5miLgCiFJO9sOfnLHlW9DUcg=;
 b=pvesz1KoaOIf5x/H63Tk1ZaGidA/iaFINHrKjHUdCgYZhu9nqOaNJdb8laP8FcOQlVw21xjfbrpA2MgVePtS7xE8ISIa/UudoFP19dcHwSd1TcA9ovJ8H2jZxeN2AsMQVW8M9AhZTP45Mh0LnV+1nKLKfkZOsNWuZdxLOkwonRB5u0uBEZQet9pKjeWVaQKrNtR++CE3hGGARbTAc7DqZE098Q0bdtGcC+XRhMoL3/dkk0dcILb7cbbAjzeyRd75fu2LcM6WhkogWrJy/EzHi3H8a/2bHXCE8goSbNBqElrdC5SY04jFz151hnH1PQOG4NicqAgyKVb36SVjv8qSNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEw7ThkUOvmnbZBTcyj5miLgCiFJO9sOfnLHlW9DUcg=;
 b=sFadABOpKmpbmF26Ny0BD07rSZ+RtjmPnU6KM+VG1WV0xL5144bodXdbqXMiovtZ6lhqQxJ8Rt99dXlo11gxKnTg6Z1WipR4mlQnIdGcyIKdg7JdD8MtdXGA9+E/rEhcgTKcDZQHweWnrI1DthSX+5QUGpnqfp/GjAMT1tLKLyQy7nepWqpudeplt46am1MlcCvuc235pAQPq/SxHpVY5v7HlyBIArEad/Hr6JnO7lZSVLRnVGmCtDj6kONN/NpCqX7neVqhfqvt4C1jKLZfc+TdhEw5H98CT441vco2Zs5bvQFNnb46kq+caWBZuAcUgRucTtVyZ2jF8KIW7FcUJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:26 +0000
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
Subject: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Date: Wed,  9 Jul 2025 11:52:03 -0300
Message-ID: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:806:6e::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8516c4-06c9-49ca-46d7-08ddbef83727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mz2Ti9rt+rwCWvg9TlBYfUYQZejaYWnT2HCOOryMAMD0M3W6eS/ZifVFJaEB?=
 =?us-ascii?Q?vevL/0WIeNIaiVYzmcXsS8auR/GtAoR/AVvf92dXQ6xdkGz/dLupPv0UEVZp?=
 =?us-ascii?Q?CY7oa8RjpsWmHCFTsH8W8FkXA21q4T1brYseor3SSy7zUDyDoj8mN/fX+4Pp?=
 =?us-ascii?Q?PUZH7tmfIHm9W8nD3vUwNdYdBo+89J2yzCQ8s7w/ihzMkLJUwSB0Ic5qgYHF?=
 =?us-ascii?Q?Vh+HbwGg5CnoiTPb2fjcEB0qHibFp2LTrscClrDAEbrNDKzRL8FbAs2qNeAo?=
 =?us-ascii?Q?hUyN3DJWRDUxhX+qkgay+fFEEUchxrqLPRLQTIAs84R/L7nnMSlqvapw1LH7?=
 =?us-ascii?Q?2MhaLMp6spZS3CXdrSjG+z7tHWweGDm/vpRUNhJ3tU3hUXe1xGtchFAFt4kh?=
 =?us-ascii?Q?AEfJ1YGd0KUplWt/gqpnlHLrVE9ilh8pJ/I1Qkm+e6JgNiVo982UGdKrg/iT?=
 =?us-ascii?Q?BdEkJHkXukTadEtA5CbHp3LR9YvZq1zQd9gEgU4HRLBEfl9ywilBNlrIfcyH?=
 =?us-ascii?Q?WM14lx94W6MSTM921sczljtDvLe1yxkd6qjtJhjPKHlDI+0JEJsd5yTNJaJx?=
 =?us-ascii?Q?/QOoVvjNQljdIJYOyhpZ9wWG2FbkRW94AcF9t7euRTekQ45jEcDA5hJOXtZd?=
 =?us-ascii?Q?jB0kzOD5EH29/y/WLLBwaz5KtDdJQN8G8N5HbVrQj8upupw5bMys0tfAqatu?=
 =?us-ascii?Q?upsG/nyWFcSidLth+8fXW3vXW/cOJ4iviHPq0ANEhQ1YarDy06e6hIMW7Nyy?=
 =?us-ascii?Q?q3AavlaNIWlPkxuz05aQ5eJS6H4j9PtYiGV9EG1NtBlBtu/0w/9/co5do28p?=
 =?us-ascii?Q?c4a2FprgrL0Ag6o4lkk9gGBsFrwPeFkAvE0snJLgakWdEzsjf4YzpPjeVP3C?=
 =?us-ascii?Q?DZNOxkEIwoYOpEH7OT5NJanQNFAI5vKTOSZaiVsc2W99S/Ne924OhSjQTf/U?=
 =?us-ascii?Q?hK5vlj/x7clM4uwxJ1VYhgRhiRT65L2M6uK0gRnjCz4H+RreYC5SCxdMrq0Z?=
 =?us-ascii?Q?ROD4FNcMt24OLaPv2dfWgqSmt0alD+S1Pc7px67+/UvXP8HbFhsQbNh4ObsC?=
 =?us-ascii?Q?mKqr+XQro04pvFmxGcI8buFwx/pegAUCH+fFsJAdCJGgMovYmho/XWVDNDR3?=
 =?us-ascii?Q?ta4n+iUaZ87W8T+b3NUSPJ1acc3mOPSIjLj7B7h73Z1akNGDOdNIFFe+DItV?=
 =?us-ascii?Q?VbNZ4aGAlI/Jx4tNPng9dfOL0YQEOUogMfxcuTkQbrBFb5qnGnY3Whv7SYSr?=
 =?us-ascii?Q?wnL/LQrnDUVBSNOHW+8u3DZMc4lKW4zKm81WZHz0nuJrq7jFnfWHW9Vu3Dw+?=
 =?us-ascii?Q?hnKQ9rtgBW46TjZ54lrz0Ux1P0h1uA4D9vyBBRh4g2RktWZN7TZaJQoEqkZK?=
 =?us-ascii?Q?GVKyaSgK6GNQ4vveEfNgChpDa9gNcVy2uUn14P0GxpjD0WpcNDjrWTGJwYHj?=
 =?us-ascii?Q?gIDZSLaX6Cg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VFOZvM3wuU8Vvb5/h+2ZvepUvNlfRYf8a3TW26DPauJjyBfw8dRo59plsKhW?=
 =?us-ascii?Q?BwWhaRndL2pjE1I9xJO5rAe3lrqnsoQZJ66CqtZxshmSDcoDY1X/m8aBDqkz?=
 =?us-ascii?Q?xrs7kTrFjNRpDKpmfcRpwZFyLZLvpb3VoNr5i7iWWpZNUWYPAIHfZ1FNuUHG?=
 =?us-ascii?Q?MjioJ5du05c0FugGxXWXLpIzh9zEJtkeF8aLX3Tap8NwFrIGVULv+BLxkLXZ?=
 =?us-ascii?Q?VqXu7sBddy8pGVwKKwIwyUp86vesWhp/9SoNjJvN5dwKwcZHMkKkYvck/fh/?=
 =?us-ascii?Q?n/P3kFrQsC80HCPAl7TWGIlWDtESiDueU+WCtE2eeLEKKWaLdmvJh6Andcuv?=
 =?us-ascii?Q?+ZJXaYgNG9+sK6ArU5Uw0L/rS6fgK9p4WZDaDCiOt1/kcGwAyw4O51OvD6Wj?=
 =?us-ascii?Q?4tC+DboWxZzl3NEL787U+Cnugi4I7LKJBg/1uaAWC9xow0Q0dcEzjiuTucDp?=
 =?us-ascii?Q?OeX12WuaONmuynHx+wU1D+jCoLZAcOJ38r+DeyKNJB51mzUnpGv0wAfPv99z?=
 =?us-ascii?Q?op5H37Z8kpekiOvMv5CQuRlnbNP6vCgzHcetzlUYisNFxWoZH+Jey39vsT1r?=
 =?us-ascii?Q?7OdqNpp1MVUDZgK3RtS0Ey3BclMO2aPHuxYum5+OVBiMnjjFUWZfimc7wh5J?=
 =?us-ascii?Q?otuKyM59V9l3QqQysWGPuogY4a69payoLwBMrEdqUN+CUsPz+7tW9MIZlDHI?=
 =?us-ascii?Q?1/qQKYwt4oxU02YWWsM2V3U/W4fyA8z4TVWEc43H044TR+bdeueg6tfPPK8w?=
 =?us-ascii?Q?ZxqgXlFuWkspWEx/Qs8uNcK8UPNGhmFdg+G5zWcWIQsNuWLHaF8a53nUheXb?=
 =?us-ascii?Q?qA9INwxmLWZf6hdFyjE5BWgL6a7+eMRMhfLcZC5svpIgDN45XPUx4XqWHL81?=
 =?us-ascii?Q?u2zeGLHOZ0mA7RQuAdEmEvCaiZ8FyhoY8sEPRMYIyqIBSZzqKXbaPerbnY0v?=
 =?us-ascii?Q?JVbKqQckkSk3eoeXVIV37c2h6UWwwP3u0lXZJTTrB7YSuKkKcXuBwTREP6MC?=
 =?us-ascii?Q?f1yroi3NtlP03B9sLF1j6a71gBfsgmP/OQkDiwZm22IdrlR7JTiyK+pc6DvE?=
 =?us-ascii?Q?P4QxzKPCL2mi+FJkS2wThiLy6cOUneAQi7KpJ9EV3usdWzFtXYvSiXXyuZHZ?=
 =?us-ascii?Q?Zou+xcyiABIkdkSmOVL2dAE6wFmVApdODbiP0GeqLVeGWLmpgnxUkCCBS4+X?=
 =?us-ascii?Q?nd3X3q/NK6g749FFFlvwYBSkUxUbX71rqTaw3fAvr7ykTKgmohLp0auSfvky?=
 =?us-ascii?Q?2kE6GtMpBrqYmEsiclHFgZAeaDK+RdI5jXGrxpzoUivAqLZ2//csmy9nlyc6?=
 =?us-ascii?Q?OH/w7J7/pRgIV1P2bYrW+F4/Hxxmr4e2UWWGIpHKTqXb8BU7gLN9MtnF843n?=
 =?us-ascii?Q?3w2itIHtvkLm0bFVD6s+7pSKgWO85OsiLB6Gu+jVrq/kmicuHgYflXP8ZbXd?=
 =?us-ascii?Q?6ddGmyRibBOPg6CCS8iatl/TPNMat7QngI9F2fPTamvxx0szPZDx07mYmoKn?=
 =?us-ascii?Q?XFgGRWbqeDHZdcu0y/g07OomksNgPGxMydxw4nVERHkGItFlPrZEhamdQBcG?=
 =?us-ascii?Q?Vn25v8aeqTo9v8JFsWNblSYRQG/HDROSr+3vQght?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8516c4-06c9-49ca-46d7-08ddbef83727
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:24.4839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 157zBMuY4Bo1Ay3ekWGX5WtRzYoFYkADz27OnuXiA1tDiEI/E1oRH85eCUF1xioo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

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

                  -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
  Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
                  |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

Will group [1f.0, 1f.2] and 1f.6 gets a single device group. In many cases
we suspect that the MFD actually doesn't need ACS, so this is probably not
as important a security failure, but from a spec perspective the correct
answer is one group of [1f.0, 1f.2, 1f.6] beacuse 1f.0/2 have no ACS
preventing them from reaching the MMIO of 1f.6.

There is also some confusing spec language about how ACS and SRIOV works
which this series does not address.

This entire series goes further and makes some additional improvements to
the ACS validation found while studying this problem. The groups around a
PCIe to PCI bridge are shrunk to not include the PCIe bridge.

The last patches implement "ACS Enhanced" on top of it. Due to how ACS
Enhanced was defined as a non-backward compatible feature it is important
to get SW support out there.

Due to the potential of iommu_groups becoming winder and thus non-usable
for VFIO this should go to a linux-next tree to give it some more
exposure.

I have now tested this a few systems I could get:

 - Various Intel client systems:
   * Raptor Lake, with VMD enabled and using the real_dev mechanism
   * 6/7th generation 100 Series/C320
   * 5/6th generation 100 Series/C320 with a NIC MFD quirk
   * Tiger Lake
   * 5/6th generation Sunrise Point
  No change in grouping on any of these systems

 - NVIDIA Grace system with 5 different PCI switches from two vendors
   Bug fix widening the iommu_groups works as expected here

 - AMD Milan Starship/Matisse
   * Groups are similar, this series generates narrow groups because the
     dummy host bridges always get their own groups. Something forcibly
     disables ACS SV on one bridge which correctly causes one larger
     group.

This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups

v2:
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

Jason Gunthorpe (16):
  PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
  PCI: Add pci_bus_isolation()
  iommu: Compute iommu_groups properly for PCIe switches
  iommu: Organize iommu_group by member size
  PCI: Add pci_reachable_set()
  PCI: Remove duplication in calling pci_acs_ctrl_enabled()
  PCI: Use pci_quirk_mf_endpoint_acs() for pci_quirk_amd_sb_acs()
  PCI: Use pci_acs_ctrl_isolated() for pci_quirk_al_acs()
  PCI: Widen the acs_flags to u32 within the quirk callback
  PCI: Add pci_mfd_isolation()
  iommu: Compute iommu_groups properly for PCIe MFDs
  iommu: Validate that pci_for_each_dma_alias() matches the groups
  PCI: Add the ACS Enhanced Capability definitions
  PCI: Enable ACS Enhanced bits for enable_acs and config_acs
  PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
  PCI: Check ACS Extended flags for pci_bus_isolated()

 drivers/iommu/iommu.c         | 486 +++++++++++++++++++++++-----------
 drivers/pci/ats.c             |   4 +-
 drivers/pci/pci.c             |  73 ++++-
 drivers/pci/pci.h             |   5 +
 drivers/pci/quirks.c          | 137 ++++++----
 drivers/pci/search.c          | 294 ++++++++++++++++++++
 include/linux/pci.h           |  50 ++++
 include/uapi/linux/pci_regs.h |  18 ++
 8 files changed, 846 insertions(+), 221 deletions(-)


base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
-- 
2.43.0


