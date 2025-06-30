Return-Path: <kvm+bounces-51121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC75AEEA4F
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 374631BC3ECA
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82542ED143;
	Mon, 30 Jun 2025 22:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GGyCYasq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CA72D130C;
	Mon, 30 Jun 2025 22:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322535; cv=fail; b=i37MQgbx7JyBhSDdb9q16XDkkVyG92qGzGHmreGoR0LbQzgQAGJE/4GXPDpvqjTHuvMU27cUdqJ2ulCuePgZkyvOhHTLneMA3kpVJE8EQV9ft213QHwadslRD+WCLxcBgEyWGbDicMpCzlwLW5vSk+LCyFEBzaxvpJ83yzypxeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322535; c=relaxed/simple;
	bh=irKTCbT9H/mp2z2Lm8/fSfO97FhX6V7/Ifxq+NtYKY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bnmnDxMTcWtV8HYYg0KlUJqYWfx8+qOm63VnAAdSRsrIO5p4t2YdFzMAcrvrxiS+XaL8x7udEci5olpNzTF+z4Q7XHrps166ndST5r2Vds5y3ZKRAOxM0Toy6FvS1Sq75IgjnXIgdv4ci1TjiBshRe+A9CXfeAxNpsa3sItk5rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GGyCYasq; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CqSeNcCpihnNKrybTqgriE2WvoUqRvUbs/MddwzplsYAASdluV1MJ6p5Bkk7iZEsjKrnEY4KDatj+oe8+yOk2qzbNne7U0W+a43FDzLM7s75I6ds/lg3N3DlgvShy/HQin5P+xpd6yFcsylS/AQo05vTPzx1/P0C9qGH738bdlQhXsELE1pU3z9h/a93JQvHGzatzoytG1ABzQ/IAPu/Vp6erAL9A6GIz/1iwYVysrpZFM/uW88vJkDxdQkPEqBnFVT8tMOLN2c6IgKBUPLxAzbHQLTBMWBe5zVeKlITHwYMxKYNvIkfTN1+gNtvMANXHUEmkRh3RaShjLyHArWhlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irIYlFeNl5XtcoAewstN4M3lOQKk5iqpHg59k4MmD2Q=;
 b=hsSg6j9z7xZmUkGNTedCuPhiYOj+HLttPPDQ0j1BzougOlcNP2khxzm5dCLDGtiP44nphrV3X982J5/WeDbFlc0vsls/K77LLY852SnRFOLbZHoeo+ebdT+mq64IP8wcLpqHKaAoqtsR2WkIAgN7XGr0pY3cYzIP/5+o+vvkjsd8+DWLQc5pKpVbnS9Y1BVLrjfKQHaBFvYDU7q/l2txGoP77bXJ8xa9TTM9O6kC7GN8cpISqmdbmh8wca/VAYCrcK+SKwfzzwwuiVGkqjMF+PJvxnF8pOr59ltRr+/40MkOptV1Ctz/WgdTLN7mtXSW+76f/l6NPOSWTw7zJsh/Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irIYlFeNl5XtcoAewstN4M3lOQKk5iqpHg59k4MmD2Q=;
 b=GGyCYasqbt8CB3cb7RYK8E48xSTfNs5MxHE2ZgLO9+IEA5QGYBQXNHU5G28iL3olF66qBHvNh212p0EXuUciRxlIXUvSHva9Pmrr7SZUTZ2Nt/M8hfhMY+RbmIpYnfzw1Tb686QICR+zpDzEXee5XcShtMKsf2VnaesGeCqTFApFBXqShzno+y2Khi/GYCNXko9jyg8FJHyIO+VzBhK9pT0pJNVBIiMejyjC6hPOHCV5Ld397IvNpTxA1+mPV5nCXu4XYKfOljI4tzqCylKBvfnZFSpryBDTAWNp9uuWDnp8zaIj2xNazOyL6fPS+vt9263JtCbGT80piKhjxKyHIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:46 +0000
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
Subject: [PATCH 05/11] PCI: Add pci_reachable_set()
Date: Mon, 30 Jun 2025 19:28:35 -0300
Message-ID: <5-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0032.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::45) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 817461d6-c71c-4faa-5285-08ddb8257a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7dNFAspuKdCEc8P3+HZNiwOA266LwQm7jR5rdTnWxlon1DMw7uI81ApfaTaG?=
 =?us-ascii?Q?fiDLWmrY6167sUGDeJhlHfR1fALzIMt0ekp0vnCKhedSNk3vFdu/NQ/09bLj?=
 =?us-ascii?Q?VkbCv6+eH1w7j8m3HGbKUxSY6e9MzI5DAnDnGCj6bPFaEUbQJJG7tc4c1ZN7?=
 =?us-ascii?Q?Tb/B8KZYubCIQd21VZCILv4Qo90tabWMabGbaJNQuu8f4mYzbiBY2XLZkJ1k?=
 =?us-ascii?Q?6WhJtSVyvApJ0IHFmvpITyop8PEIaxzht0/OjbEjfhyNvY+YDbsFnF5mTo75?=
 =?us-ascii?Q?M0Bfh685dPSr9aWBZEoc+ILV+Hcg9uk5Ku+7ytKfy009pZmQUckE5UD5rQWu?=
 =?us-ascii?Q?h14xnfe7MhCJtYQNkdDfK95NvQTOODrf8ty6Btyj03OU0PPuN3iYjV7SlvtW?=
 =?us-ascii?Q?JyNdP152AzOwtLUf3FrCuuLO1FLD2/XDe47aiPgPR/3P+Gy/HqJMaUuT/bhN?=
 =?us-ascii?Q?1mn+3jukfqmrpWgznVVf6w9sHrjpyfmHev3SpbuybzPQcSnG4R/zjHsTtwFH?=
 =?us-ascii?Q?xtLCgxzcbLrhZiY3flQo8QXbqebAawbdcP1hgjrlELHWk+cHGENzYC3kVWrP?=
 =?us-ascii?Q?c6mGzJtpZQlqDzZqw4DRBjVTdKqoWrRQS7JspqVhG6n788jX7TXRYN+Cx2ZP?=
 =?us-ascii?Q?4nJ9Ltg8tkNMt5hMVMGg+fCajfRhLGau0ikdVW8+uPhKFiwMfJMRyzjflR+m?=
 =?us-ascii?Q?wEIl6ree5pf/aXKjIxPejB2S2lDqqO5uwnH1YFF4yUF8c68uaQpPGZH0YhhJ?=
 =?us-ascii?Q?mfhVII4SRKbgY/lgZStR8qSZ2bwJR9vET7Xawn8dQp1mL8UrBsG4Qw1l7qww?=
 =?us-ascii?Q?In8YDgH5VSagMBzwBa75yRIMhDtVvrqZGnOsylPv+FJZJHz4hX5ABLdcGSiY?=
 =?us-ascii?Q?Pao+ZMr2NR4MwHZ/KcIbRCp+601xf72CLeZJLp4X9n0hj3zyVA2YTWnnHsUq?=
 =?us-ascii?Q?fEIZzDlzquX7LGaIfJMDbDLT2yWCvwTF1YntEcTYkItwGnnkeyOcMWlFyR81?=
 =?us-ascii?Q?/6Yys+nWjqRAB2v8OnF2uZdwior6gkZ18vTI3eLAsD+r/P15Qmo6H3nS5vkJ?=
 =?us-ascii?Q?/kdl/BypF/Uv7FGiKTFdDCI+KNH8GBdYETflBHl1GBjNT7TG1+ee/6kVCxz9?=
 =?us-ascii?Q?kTl5hhMHweU0yfgeFRl33JOVzvFHA3VH2Hq/doj7UoPmF+V/LPgncQevsrBR?=
 =?us-ascii?Q?Du29WHTN/QqtHESY1KixnuEBbwznG8dcowm6/nEgjqf8SuQH7zLJid+wz7YR?=
 =?us-ascii?Q?vrVv7q2fDSMh18Cr0THRRpfqUe9Pqbh38MXiQOUSYJyHSv22KwVBW93ZYZpG?=
 =?us-ascii?Q?nRWXgEjVqSRUjTxWFFy6cHmSawzG+YVfZxwepBWtpRUcQJ80g3WhKx28UB39?=
 =?us-ascii?Q?5QkM9TokZk3g2OEkq7716lbMXAotgrEdDue54g8oN+rn/K5mjpLSFM0DenBC?=
 =?us-ascii?Q?H9IR2fz2Adg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0EA6FPKwwvefkmHhHG+utln8oUnDN5KRQQ6Olq0vDUninzCsdTDihgegSRZS?=
 =?us-ascii?Q?m3SUKdTaM2poTzrt5bGo19kt+Is+wvzvVFvcjxAT7LX7vcUPmidx9PKj2J8+?=
 =?us-ascii?Q?7gPlq9IGtahVJ1gXWgF62TgmhkhWHxyeqQ0zQY05QHTKUTytTJSTleVQ2geG?=
 =?us-ascii?Q?TOvWPqfYOgtZQdHAT6ph9q3f5escsiLYqpwOmL3B5hfkeurQT3mCo6Y+C4yU?=
 =?us-ascii?Q?As/14OGjOTUTgN44VuqzJH0WLKBYkKZyaCpxPNhxy1dlSyz+gNCO4NHTAXxb?=
 =?us-ascii?Q?e9WpHYUrfU1oHrJVoBrwwBuRdxq9MUODwKgHOe1gd6H3uPXMevMsHqak8JGe?=
 =?us-ascii?Q?avMrYaQKumcwTRGfJF8zJUiFxvcPYgieT6Byvua9JdrUT73qxBMyg+/IJ8z8?=
 =?us-ascii?Q?zb1NvNk2QIvjIyoBUguw3QIGtrJeZXofqn0fZ7iQVK5K0BoAaUg5HTain3VA?=
 =?us-ascii?Q?XbRINp2wxVreMg7MQ8SkGbNsd1lD8g8uRfuEN01FbOqv+MiAz7wbj/TbIhJT?=
 =?us-ascii?Q?L+PYr4qM2ocInKJwMsQpktbVecBVWOhOHKGaoP+EJttZFaIdJbpLtPkYBjay?=
 =?us-ascii?Q?Cip9HwlQi2qozhkzmxde9NzMiPK1KC1tvOW3IhoADdp4LYvCBE/C9jGTpIY9?=
 =?us-ascii?Q?a9Zc53gXsUlF1IsoE6cSWYV0kwI44qRmVk6zJfaZv0QRSKMs/wNJTJwnjQgq?=
 =?us-ascii?Q?Ubptv8WA7lFxwLsVlTmvV9ZfwTlpLX9T80SB2MUYlRfHGBYkiFHLBTripwwK?=
 =?us-ascii?Q?QVeQ46MubACIKUaG9t/eMMa7BoLOZspv9yJeuMsNCJb81dKLXsnKpFvp2hah?=
 =?us-ascii?Q?zwWHn7OcQ2Xc8xcOCy3radvb1kYPZHcuV2KrMAl7sNDJ/G5ndewaONzeVLkP?=
 =?us-ascii?Q?4ARAA4EG+htMdFnRooASsj0/cE3N1aq3B6UpRcRoGFsH1qHozty5A+S6LJOT?=
 =?us-ascii?Q?CsSRI8kyQg936cTLI4duQLY6x+fVyYOR9D9x9F/75xwAhazWzvI6oeqW0lDm?=
 =?us-ascii?Q?jj1KmQ/dQFIh/+cbrJz3l5e1sy9qD+znSibmsRfU4nqt+0TEzmn6RQ0//B7Y?=
 =?us-ascii?Q?Z21lwFVVrKCdBzU7gFK5QCdV1Jjo/bf4BbsfRcCFqMYFsaTHQi9MbFU6c3jJ?=
 =?us-ascii?Q?2XcRuSeKNCnnIiowpvnTJRuEFAgyecnIjvJt1+LUnIRdgcEvUjXZ6vucymJj?=
 =?us-ascii?Q?M33dIMUEP4DIJgZDRoSxoDUUFJ79Ugoo4fTkp3h1SMengjNcVuZ8xpmo+9+2?=
 =?us-ascii?Q?JqUaDG108kzdCq/3F+hDo/yGzQ0rhVppPnj9XtMlsnox7ptE2VLEj0umwdvO?=
 =?us-ascii?Q?+IRCvnOM7tznMSi/DkEw/EOEd794pcpp+mj2mTL3L5qyW4xelUWAtgd9st+f?=
 =?us-ascii?Q?zjOiOp/BB8Y9JSIQb6H5Jf4U30pSCPu0MHTTlrN8U+nnLBkaFLvyKpD85ZlZ?=
 =?us-ascii?Q?1Zh3cc5JBhUr0kdxl041o8Tm0hae70/AziHD0uI04FDKpatKglNUmpbelnB1?=
 =?us-ascii?Q?mnjUmbwHwvj4CVZ7lRdsoyLNz9bRwTahdn81w79hmj2K8x4qnX9JfSvRER81?=
 =?us-ascii?Q?s61BgBqRH0Ly0zz2jsvK+gYIHjdIM8V7/mpGE9zB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817461d6-c71c-4faa-5285-08ddb8257a54
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:46.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyNDh1zD4ewcnzIb1dMPkhbvreOs3pTArxxBVg+dscEGCfJ2jA0bUYJOQ5MMTKCu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

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
index 540a503b499e3f..3bc20659af6b20 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -571,3 +571,93 @@ int pci_dev_present(const struct pci_device_id *ids)
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
+void pci_reachable_set(struct pci_dev *start, struct pci_alias_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb))
+{
+	struct pci_alias_set todo_devfns = {};
+	struct pci_alias_set next_devfns = {};
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
index deeb85467f4f38..dbcffc77650dd7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -834,6 +834,10 @@ struct pci_dynids {
 	struct list_head	list;	/* For IDs added at runtime */
 };
 
+struct pci_alias_set {
+	DECLARE_BITMAP(devfns, 256);
+};
+
 enum pci_bus_isolation {
 	/*
 	 * The bus is off a root port and the root port has isolated ACS flags
@@ -1248,6 +1252,9 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
 
+void pci_reachable_set(struct pci_dev *start, struct pci_alias_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb));
 enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
 
 int pci_dev_present(const struct pci_device_id *ids);
@@ -2063,6 +2070,11 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
 						 struct pci_dev *from)
 { return NULL; }
 
+void pci_reachable_set(struct pci_dev *start, struct pci_alias_set *devfns,
+		       bool (*reachable)(struct pci_dev *deva,
+					 struct pci_dev *devb))
+{ }
+
 enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 { return PCI_NON_ISOLATED; }
 
-- 
2.43.0


