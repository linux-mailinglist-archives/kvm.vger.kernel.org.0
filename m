Return-Path: <kvm+bounces-51963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E50B2AFECB6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAA5F5A317D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE582E7F1E;
	Wed,  9 Jul 2025 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iaV8OtLJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB282E7F34;
	Wed,  9 Jul 2025 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072750; cv=fail; b=l7zt53JBWj0bHW1/qBbiKi9MmNABX4ISEuAuPwxbqUfUTag+ZZn2za7MC3xNRmqzunPd+YrFW28U0Hjn617C7oI//oBB2JxgaOLbSxPL9PRTSdZH0TXPwumi6ulmGP4/K707jsaoCqEsUEus+I5sb/y6sz13EHHYYLPdji75sOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072750; c=relaxed/simple;
	bh=JRyWD3zTw0nh3YY2BAaZRGkH4peQl/Z5AZgcYcH/BNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JQt4wsoWh+zdCSD25RKh+I0RczzqHHBp7bRPMhQWptlOsAUP+0dwnum+YS0XZapOFUcDICDt7/yrKpE2x7NT6HKT8HyfCfsOwdVRJwr1aPQj2CAZxGlMx0Ci1+PesRe04y1FIw62zWf0y7/xKzId82IE7NWyX/eXgjExdhrYjBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iaV8OtLJ; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1IiwDErY+YO+RqeLFjK9f38eq5sigpnl3YEh5V8ck0ZjbhOWDIMb1Z2mvj8fKIrjKLzIumJJdDM49IxbXhOAewATySBdYNkqDlidzZFXY6ojFDa19ojznqoR3d5/699DfyB73EKJcuny72U3vXj8x5lVKuN7GkO2BqPcM9Jdm3IoTcwvU6m0LgyjaJTZQeGRWttBpAlHg81pNRmIcsKZiTwRZCXPYYkAo03QM3PPsTTZog+Wbqr/515nz6frZNGGP4F4SYit3TXnM2vUa1R89JuL0+xXm02ITt6/gZ55pDIeUZz8X/CNKbErbIGM/8T/v0MTs8nI5r5MD0oWn/kfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbxfIthAQdLdcbDkgkxx18FdH71ffKevY2MeH7vz8cc=;
 b=iFOoTLAqakp50jcyLjEe0lzH1vOJGRlHKw6+o5ES12sjnD0s1b9YhcMsKj704FwXBufzaJnAkQOSAdU9x3rFD7FQFGUldvNshqlfovNnSmBrguCrdpe4lqjE/ViUR219OLH5VjB5cAiWoDMwOiuG3x8giyCbYlB+48S2WVdylxHkBFFVpLgK0/M3BdY7Gt9mcb8ftHEM9qX/YFyHwhsFA+0bFnDpvXk7Ola2M8D0A9+gg8aDC3cww8gtMn+NvfYVIvt8zuV1o7A+ltwgHrHZwbKhG1+PBYz3bjtFw6cJIwnXb6mVlaZzNR85BARjMubSiPrAVfLgeX9xl51tooFAjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbxfIthAQdLdcbDkgkxx18FdH71ffKevY2MeH7vz8cc=;
 b=iaV8OtLJ8xswCpNQszUcG+dLUJcHlQF7xD81LF1taUx6tvyy1wfoIc2SkBNPjqS2jnlh/7dlKNgl/YWMi7OBohg8uw9jy67bZrJn/vAcSMb1051F06q1O5OsODRommPRvmMvmqSQQIMIpKZBUAoRr9/oerGRoUT6zXTCU33nF36izIV3U6ugrL8iM9lWr28407htvl84Df3Fc992na5Eo3d+EfXozhhaf61rfRJEATih5DH0Zvo7NT1Rxntct6W6kuBjWczo/EfX/qNyuGWa2uCyrGkKt6yO+hEShBIKliEx/1Y9uvGVgXU3ZPMMvobTxSLR/z8yU+ScZubEOZ58Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 14:52:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:22 +0000
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
Subject: [PATCH v2 05/16] PCI: Add pci_reachable_set()
Date: Wed,  9 Jul 2025 11:52:08 -0300
Message-ID: <5-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 983cb0c2-019d-47c8-1092-08ddbef83590
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OsSNdAK67xuXvU/VM7v6KN11IjEkEKsq9t+n6ZCVaq/WfRaYOriqF665O3b5?=
 =?us-ascii?Q?C3UNFVcYqZgWqdU96/3rzDfFGazVbmW3Oy8Iym4nVW37eGB8xLUN4jLybfXt?=
 =?us-ascii?Q?IKZAfO+r1iR6hrdBNGouZO9kK0/e41ff3dyanLGpge/DtEtAQ/YpXrd24WjK?=
 =?us-ascii?Q?6I+HAMW13zbgIrwtpTc1Jp1sttD7NCIk6TZbcG0bHWxs+5UJsc4cOZkSQLSz?=
 =?us-ascii?Q?I2sgHW5SSV4dOUOdwOAJqj8Dz5HNzozYU0arhtGGlBB7dcz5XGjpF4NT98qW?=
 =?us-ascii?Q?lkU+kz9JNUL6wAGBGEWKqSMYBQGpSk6lz+hzznvLebfcVTqHjA30wN+Ie4V0?=
 =?us-ascii?Q?gG0tsGRxpgaaA1bcMM1i18+w8GEjiNuDBeu2fjqwoondYQ2CQLGX4lvqfIiD?=
 =?us-ascii?Q?FRZyYC/zdHjxyhWC+KxuRZRZbUmzr4ajlSYFLXiCKpH0YV5g+6Yiyjz1yVZW?=
 =?us-ascii?Q?iCxbjD5kZmPI7i7rBZuKhZk33a2kX7ygquJ3Fh4HFqQnCX3EpoM0LnRBmQnj?=
 =?us-ascii?Q?DAMHZpI6yXWc4GRXZyUSmWh4+tD7sHViEz0nG/vzqEOSv6vU66Uvcp3G+3pB?=
 =?us-ascii?Q?jDLbvBC/MQSYkri+Vi83HzFE0YiZUIYDe13bUDr4DDSjt5uG+lyXbbuKE5Yq?=
 =?us-ascii?Q?H3Gx76j95s6n+l667tMybFM6Ckg8TAMQDG+f56POBzuMkiER5XoQ7nijsa7K?=
 =?us-ascii?Q?vdmqSfuQ26HzNFibKGf8oQHdu4U7WmvVXXKKiO73/7BwV7Gcmh5/QD2BhipA?=
 =?us-ascii?Q?vobAW2d1ZDO92GAl2rvPNOSt/FgpNjWMovSnLUU/4pFoYyI8Th7urNoJHqXP?=
 =?us-ascii?Q?qh1MO8EB3hGR56iL2LkRD79u+4cI23NqHNT2VeQ5I72iv5k2pqcpM5zdoU9s?=
 =?us-ascii?Q?783eB6/pYVOhMvPfBMPP044a/13CSkH9COdTZB3njNYzv78VVmdmB8UsYjuw?=
 =?us-ascii?Q?lSWrWQiuNtwy9LRvjK9XtHRTh0FfQg1ku9Kf2za2lMMcbUt3EAWfSiTdlQVT?=
 =?us-ascii?Q?dXnp/Nrwl8byQ30R/LXoAUofkrMo3g4RwqswdyCA8+XaKOgjsGf3iuzYgNC4?=
 =?us-ascii?Q?FsubXc8WpFEQPHvbw/hLWDK5OMyn2IW7+yLoywtdPLsV/1vciOCpP4omqkkN?=
 =?us-ascii?Q?yrfRa8283VIDL1r76IfSNx71PR2ZcM620IsuWDz67TufX1xYgrHFWQ6QlLqW?=
 =?us-ascii?Q?2yapzmwWWcvAR8roZqow2zPc5K8+81cyE1Zc6Aqk7lGjRa6A1Mpk6GOUuM6z?=
 =?us-ascii?Q?mBJNWR22xYSBSkhRhnrpfmrRTQCBRf1fNdLTrmBbsXDsesM7iYeNXZ2hARYl?=
 =?us-ascii?Q?T2kVzq9TiGBw1bh8iAr5ooC1S4as6X7LiblQQgSMGUlA6PXztQ5baI/uzW8B?=
 =?us-ascii?Q?qNbn6KQG9FRlWB87bqitkhz/bRm7ZaQcWhwVBmnxwAFj1O0DTpeJsj6oJOeY?=
 =?us-ascii?Q?uvkAwWPD5uI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x1ezbDzOoWotpFBTWbiPP0KUJomDeq399ir09g70egw2c8668W5CBRXRLJHP?=
 =?us-ascii?Q?0XOu8FZUxZmJ6l13jAZ2hodwocNpXVQUnPfqklClWgUTcKqapP+aiJYwkYz8?=
 =?us-ascii?Q?qQ9cdBJolN8pzyiK0L5W6/FIxoHJA8UvAR9MFSmcQ4TM5nUs1OpvgpBqpRYG?=
 =?us-ascii?Q?aIvmtSaZQvExaQU3k1xWSZr6OivuiWgcSdDvFQuBGrV+1mmXm94It2nCjUii?=
 =?us-ascii?Q?ifiCXbMnPmYyWplWgLDbRfa8LK+g5pShgSCuubt13PtDcnE+ZPjwZWaPP9N2?=
 =?us-ascii?Q?/BtNX+LC76XAqaUDEiM7Y1ts2rQGNEAACoVcomkaroGqFhsqhNUl4zhgwnXG?=
 =?us-ascii?Q?sLS6w/zdYiEEEJ2qAuluUl6aZbEAy8ihLtfPXxpBBSkavD1xp4OYNw3iW8AW?=
 =?us-ascii?Q?UDepMpHJQPLV0r8EOUeq4CZ/kbOUS60fe7BrX8/yXZgPxhjvKy6JS9ZajR3K?=
 =?us-ascii?Q?QJv49A4dXrnlbNWNe5KLWOgrXYXSrx2w/GefQgjdWN96nk2jq8JArwdo4cHg?=
 =?us-ascii?Q?xjFo815GWOHWkOh4cAAJlo5XwRyCAOHXCLFViMpH2D857uf65WEhCBsMxcHG?=
 =?us-ascii?Q?Qf2Vn8RCt3jn1wo2S2o/Nk9a6G022/+8B7K0nY6Wz6cmqIXh2wvqGW/kTEP/?=
 =?us-ascii?Q?OgQTBSerwYMj4QpxjGQeBiur9+kBjW+tB9/zVfOKZpTR47hPdIYIQi4B99t6?=
 =?us-ascii?Q?HWniW6DOfAJK4brH5PeyOG+rvq8AhsyZZ/Ht20nDRmf9VFjX5R6p6A718Syh?=
 =?us-ascii?Q?JfY8Eo0MVhfcePXiWfjrQc2f8hrRpJMgBMyUNKet1u/nG72r25jQkBg7p01o?=
 =?us-ascii?Q?NHiRTjzuCankkJkMoh11WKzzmau/8n+/Cg+OaGaGBS74pgAhfR/6Ss3suMAA?=
 =?us-ascii?Q?54KFvdodsajJoefzCFL21gZthue/ldyAfc1gZBxFVdqlZ1f2ejR7FbJV35jv?=
 =?us-ascii?Q?cqX4z8AxCg055rJQnN8wfRhxOtC/TkN92apqqhHGn6NZJPDeowx/ewbp+kLy?=
 =?us-ascii?Q?6Ll/lhaZKTsHG6Two11XDtsmZZmmUbTZxPgi8xyKZSgzhNhPQ+dyVkWTB1kh?=
 =?us-ascii?Q?VRbeDRaWaTxVsRLdendmijSv1yDkHL9piWk+yMb321mxFqz6/sMYVm4f9rzA?=
 =?us-ascii?Q?nqTU7oAVq1fgneRkKj6BLlTBaUqFU9qgfRFCgdnboXZqeeyHeC5cv23sqWCw?=
 =?us-ascii?Q?g04AtIL4wDQyT5vuUnXICTJdK5Wn6NMnmDbYl9QSBp4OM0c7az7CA19I5rRH?=
 =?us-ascii?Q?ciusX6CLZgnCty+NKxyo+HBOl/E16k0lO5pDvuYBDJ90+ZdQpili5FugE4LK?=
 =?us-ascii?Q?hNKJwj14Z0nF7N2LAGWlhauu+9rxlR0XQItoqOkbhqB7IriSp+RjApcaa6g2?=
 =?us-ascii?Q?9iONTcOrrPTHyqnOwsemD4Ddf/YRvt4NlWstiQ0NkIRIvRNKlKmutbDel8KR?=
 =?us-ascii?Q?iBXzS4lnAS9yMkmgKisKhDBnwBl1eqKdpJ6EDFmiAmx0cOqosy17v2LrK52C?=
 =?us-ascii?Q?yevfHcbFc41dQ/8IS3l4KhNW3nai0Y5CFZx4qIIyfbwCCJqfJtvvkUgMQq0t?=
 =?us-ascii?Q?fux50OBaPD+FF7awHNmjPjnp/fUE6HvzmrdvgNhN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983cb0c2-019d-47c8-1092-08ddbef83590
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:21.8812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57imOm0JQCryyd/4Ct0u03vQSLY1qd0aJYQXvVqAaPTnfR0/9w9+Ta3nhL6NvRch
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

Implement pci_reachable_set() to efficiently compute a set of devices on
the same bus that are "reachable" from a starting device. The meaning of
reachability is defined by the caller through a callback function.

This is a faster implementation of the same logic in
pci_device_group(). Being inside the PCI core allows use of pci_bus_sem so
it can use list_for_each_entry() on a small list of devices instead of the
expensive for_each_pci_dev(). Server systems can now have hundreds of PCI
devices, but typically only a very small number of devices per bus.

An example of a reachability function would be pci_devs_are_dma_aliases()
which would compute a set of devices on the same bus that are
aliases. This would also be useful in future support for the ACS P2P
Egress Vector which has a similar reachability problem.

This is effectively a graph algorithm where the set of devices on the bus
are vertexes and the reachable() function defines the edges. It returns a
set of vertexes that form a connected graph.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 90 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  | 12 ++++++
 2 files changed, 102 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index a13fad53e44df9..dc816dc4505c6d 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -585,3 +585,93 @@ int pci_dev_present(const struct pci_device_id *ids)
 	return 0;
 }
 EXPORT_SYMBOL(pci_dev_present);
+
+/**
+ * pci_reachable_set - Generate a bitmap of devices within a reachability set
+ * @start: First device in the set
+ * @devfns: The set of devices on the bus
+ * @reachable: Callback to tell if two devices can reach each other
+ *
+ * Compute a bitmap where every set bit is a device on the bus that is reachable
+ * from the start device, including the start device. Reachability between two
+ * devices is determined by a callback function.
+ *
+ * This is a non-recursive implementation that invokes the callback once per
+ * pair. The callback must be commutative:
+ *    reachable(a, b) == reachable(b, a)
+ * reachable() can form a cyclic graph:
+ *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
+ *
+ * Since this function is limited to a single bus the largest set can be 256
+ * devices large.
+ */
+void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb))
+{
+	struct pci_reachable_set todo_devfns = {};
+	struct pci_reachable_set next_devfns = {};
+	struct pci_bus *bus = start->bus;
+	bool again;
+
+	/* Assume devfn of all PCI devices is bounded by MAX_NR_DEVFNS */
+	static_assert(sizeof(next_devfns.devfns) * BITS_PER_BYTE >=
+		      MAX_NR_DEVFNS);
+
+	memset(devfns, 0, sizeof(devfns->devfns));
+	__set_bit(start->devfn, devfns->devfns);
+	__set_bit(start->devfn, next_devfns.devfns);
+
+	down_read(&pci_bus_sem);
+	while (true) {
+		unsigned int devfna;
+		unsigned int i;
+
+		/*
+		 * For each device that hasn't been checked compare every
+		 * device on the bus against it.
+		 */
+		again = false;
+		for_each_set_bit(devfna, next_devfns.devfns, MAX_NR_DEVFNS) {
+			struct pci_dev *deva = NULL;
+			struct pci_dev *devb;
+
+			list_for_each_entry(devb, &bus->devices, bus_list) {
+				if (devb->devfn == devfna)
+					deva = devb;
+
+				if (test_bit(devb->devfn, devfns->devfns))
+					continue;
+
+				if (!deva) {
+					deva = devb;
+					list_for_each_entry_continue(
+						deva, &bus->devices, bus_list)
+						if (deva->devfn == devfna)
+							break;
+				}
+
+				if (!reachable(deva, devb))
+					continue;
+
+				__set_bit(devb->devfn, todo_devfns.devfns);
+				again = true;
+			}
+		}
+
+		if (!again)
+			break;
+
+		/*
+		 * Every new bit adds a new deva to check, reloop the whole
+		 * thing. Expect this to be rare.
+		 */
+		for (i = 0; i != ARRAY_SIZE(devfns->devfns); i++) {
+			devfns->devfns[i] |= todo_devfns.devfns[i];
+			next_devfns.devfns[i] = todo_devfns.devfns[i];
+			todo_devfns.devfns[i] = 0;
+		}
+	}
+	up_read(&pci_bus_sem);
+}
+EXPORT_SYMBOL_GPL(pci_reachable_set);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 517800206208b5..2e629087539101 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -834,6 +834,10 @@ struct pci_dynids {
 	struct list_head	list;	/* For IDs added at runtime */
 };
 
+struct pci_reachable_set {
+	DECLARE_BITMAP(devfns, 256);
+};
+
 enum pci_bus_isolation {
 	/*
 	 * The bus is off a root port and the root port has isolated ACS flags
@@ -1248,6 +1252,9 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
 
+void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb));
 enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
 
 int pci_dev_present(const struct pci_device_id *ids);
@@ -2063,6 +2070,11 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
 						 struct pci_dev *from)
 { return NULL; }
 
+static inline void
+pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
+		  bool (*reachable)(struct pci_dev *deva, struct pci_dev *devb))
+{ }
+
 static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 { return PCIE_NON_ISOLATED; }
 
-- 
2.43.0


