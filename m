Return-Path: <kvm+bounces-51497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49776AF7C78
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CAF06E2F9D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B7C2E88A8;
	Thu,  3 Jul 2025 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ntWnQMKt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2084.outbound.protection.outlook.com [40.107.100.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D3E222561;
	Thu,  3 Jul 2025 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556638; cv=fail; b=dpNB0NvffhvhYuSoHc60GNVn4CnaQQTKCFSS7pgd8Iybwfj03tymWF1KYEJdxmlxFCmQKewtLe2+/NH5eQRHhOiTUCej+EZ61xIFEOneEamFEUNeQLVJQFJBvLR15kuy3whXcDWWieg3FsITagAyJN1P8XfuJxT/2MZFvYWWaF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556638; c=relaxed/simple;
	bh=lPQaP8o9vui1FYT49T5ej7BiRmjhukwGPqyecOZnI7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hQzPAUjr+uaT+BIdtXwU+bEi04pYTS32F+ISRhTJWR7aE9cR1czua+9CNUGYBCy6DM4pIR4J2sIJ74eMughkWOa0CIXWpeDtLtMvUuYq95RZIbBalBHLcnBBZGIhiGzbfthaS0Un9wbP/EVkjpGU7XNHKC/YEnZMQxdmo92XLJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ntWnQMKt; arc=fail smtp.client-ip=40.107.100.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRATc1y8HI2mjZSzx/qWWMBFfkknz0kUvnpJm5l8+q/xDb7C5xmRbrKLW3CVqHPdcojlZIySqtljOehp3mowCVLXvSmCFzNT7GuuiO3oyOZHyetZjWEQ2tWjcZ8l2eRlK7ajiDsp1UW04fvK1VqBp/9C5wJbhO/VF61IqeF6bLUznEhiWyrqI43s0EDD23rvqApEMei65E+funlkHIhHcKSX0BzrnBT4xb2duTAiXyBPOvEKgLXR7KUM5J93l2IrjjRNaEtVSOkf5oBKcmKpF9TwU1RTNZEubuq1/lXU1TTmpXoQxxeoxbB4h+fwFeMxEueMNn1SIVaBl4/X+MuSAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tl49F7lJFFgXw/nrkBfQLPCuX70nLm094QvjCazvias=;
 b=r9wFNpUtRrSi3yQiTo73Oe7n74CIWFiJqnO86EOoAh8CdL8rN0fTAiC280DVS6+7+t2TmvfvfZaIjlKkJCo7TvPCKcoLurKdWo0pJNThZ+rqnXuq4rNxfUVgoVuvbQUnnP6DyhaW6uQzxecRgIlrb/QMqQ81e2zh+nPC2+TRv+2Iu3KFasABdUs73+ugFo+V/+PwGXAqBN92isxnKRVeKJhFOqJT8o+0OQRyoTuKC5IxUDuphiGteTgfbmeoiimMqRt+3fn1PDFjdBVCaiADJIc/enWNjH915FNmiBKze6RiviEC1Ibnv80c38/f4S7FutrzlQLXDSxf9HWBZwr6Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tl49F7lJFFgXw/nrkBfQLPCuX70nLm094QvjCazvias=;
 b=ntWnQMKtY8bukXInznp/fmVJUUlYT+vrPA3TPoE6dwvEOAsb6iIpHOJ60sP+GDSMzmp2z/KseMebhUK8VBHB2VpSYM8Do8l22D9zkfVSY5t//F5sDJsemeFbdZQfKZcdT6uxib7UB8gzfwIGo8yiUHHgjv/8WtX7nJxoV+o0QF+/A0fwKrV8a8SUTL6twLltXH477Bv3efmjLjgyt6W7T6uXCgE2OLV0zo4ZqhQgQLxgLbCiLEFR5EeExe/l9A7P4TINYIKuwIqF49ifsVY2uxfLmnKDr2AJz9PRFV3oyqh6+cRsOIRVEoo3KGFSuuMJB/gQzeQZWC3jMbzE9zYbYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.31; Thu, 3 Jul
 2025 15:30:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 15:30:33 +0000
Date: Thu, 3 Jul 2025 12:30:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 02/11] PCI: Add pci_bus_isolation()
Message-ID: <20250703153030.GA1322329@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132859.2a6661a7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701132859.2a6661a7.alex.williamson@redhat.com>
X-ClientProxiedBy: SN7P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: ab576185-1450-4226-98fe-08ddba468c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V9sz2SGDtAEuYiA1hzTuFRGo05mp/9yPkQXd7nSywc/WThcN9cbFWv8dUyH3?=
 =?us-ascii?Q?4QJ8ngqcNCzMmUA60Oi/MCFsL2B+J3SGrbJHt2OeyzLVe0yK4c2upDFd1w65?=
 =?us-ascii?Q?nodQ0ZhYMkZE3I5j43e0P9nahpgiBhQuqwuXJAtSl/TvZhIPmrpYX7sYawx7?=
 =?us-ascii?Q?RBcwk6kEnG10qPpSxEhAOnirab3oeTAG9xkoOmhRY/KaJESdCB+M4cJXgJla?=
 =?us-ascii?Q?zpz/HWXuRCjNixquOfsHD13IHz7OOZcq6YyeoXX2l0cYGdShcuPqBCk9Q6ye?=
 =?us-ascii?Q?0QD3YMmPCXsxALXX0gA0KtgFWflJjguAr39r+jIVuwgqcP7alUW6mVQM0RPT?=
 =?us-ascii?Q?1LrnhNRbSfe+kxXhQxJM99Iq5mtjH72nf6mddbewG3nDlocTC/uQN2TclCTX?=
 =?us-ascii?Q?mzl9yo999R7kVxnc/n/UHuaFlFtKKCavXS4PX6mk6SSQLLAYRWqBYzgwhhw8?=
 =?us-ascii?Q?xzgbDglzIuKEIK071tRx486FPvcFl+MpXRPhJDNhKHfzl3ZP+ydPydvotEhe?=
 =?us-ascii?Q?lbpU7/JfD/9bG2jnwANBwF94Wp/ryOR9/WSZBJDIdHN+uaEz6oYIqQqD1AUq?=
 =?us-ascii?Q?pcfU6DCo1zsapmTmppZR2sSjnMUsi6TVyC6BOnJHcTSr0AAsK2wi39vVWz7T?=
 =?us-ascii?Q?Vn2Dlsow8mxN8ITIjOEt0Uongs286/OsnXNA/I7eHpNoBm54XbMHDltde+6H?=
 =?us-ascii?Q?grnfNvK9TOq1l4RBDOPTXT5KRTtqr2C/tZ5m8cYNUnCFSIAcaDt2+RxDs9nU?=
 =?us-ascii?Q?YEKr/aFEG2t456cbGjxgZjYa8yhkF6fGnW3Kuq2YyCqIDs5XJiwCA/sG3y6J?=
 =?us-ascii?Q?2TQEF5xpjdOZc18w8vFWGUB3UKqYlOK+Z5n4ZnS3+vHvJ9xf0Nbrb1abKVYF?=
 =?us-ascii?Q?9LQFF74PBaktPK22hvQn7tZZHuBVXliJOknpztq8HkpH7jAv5yz/F7A0br3H?=
 =?us-ascii?Q?IaTBBhDUe+OW58tkqfEpswkx4JopVjll2+Kot9IJ5oKY9X2V1+vhkPItxxtv?=
 =?us-ascii?Q?3EPv14ZctullMOvgeJTPOBIcSJuiWcdnhWDJ/matjzZIaf4oRiYB9URhX3Vr?=
 =?us-ascii?Q?Sx0OJTmsLlvqL0NxqdbCTOHhLQunhvOSOyko32dtzEdVcStju+Oie57rC7vg?=
 =?us-ascii?Q?Fh0dHtwkxCiTiiiD4EcqzfbHpfORidp168FhvdViHU4RXK6cGJU08Y7Jshio?=
 =?us-ascii?Q?StLkwfOmBE0GVD5EBa+SjbiGG2bSelwmk1vFhKqktTxLz2aPhVahQdMyqSUH?=
 =?us-ascii?Q?SFsVzjFv1SpkvYolaKFhbg1rpGTxj6tN6f6bPrBi40NQSidYngpvx+6ETMj8?=
 =?us-ascii?Q?C1mA3FQzlAkH8qnPQSzzdiiZHV3GcB0Aeh1G3h8spP5WWxv73Oma3I0CgJWb?=
 =?us-ascii?Q?8jTpiYG6Ycee+LNaQgB+o638dEqTT9K1yPSmC20QJyAAEeezoWN5wpJ+APic?=
 =?us-ascii?Q?PubYw7KYiVo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ppTuI3LAMxTcTca8+v45W4xLcKxYYScdN+ij/Blj3MkdCoLR5SuZHXd5z/yv?=
 =?us-ascii?Q?sNREUeKLDnzn1juzl8b++xkeSAsiKUm6FY0X+lVXEsAu+LVmlWUAapWseMQu?=
 =?us-ascii?Q?a8ajOy614h3agOWGLfOonxLCe/GujgWrSWP57+G7Mf4Fd2jI9kBSIDc4yyQq?=
 =?us-ascii?Q?ltFMaUb/1AAor4D91ub5AnxtV1LEVvwAH4C1I51uBrf9fzxMIRlowKcWVdxC?=
 =?us-ascii?Q?uf6lvIHAj/F/5GicvJ8FM9+rY9ibD8C16s9T6romtTbnWUIjDgoaFFjG2lGj?=
 =?us-ascii?Q?DPGHdrfaZAcsRW38kX9s15rH1GfgGlPnZp+7aoDP4haQgOVP78e3acTwNthj?=
 =?us-ascii?Q?3s+SrVIENMxo6l4x+Jf5NhcV1yjaR12coWDZNhnnm2we0Zz0r5OBagFU4Ame?=
 =?us-ascii?Q?cPWGGSja6fuEOYya1Z6SLP9ey5B34lxUjaTCeC+BlyrRfT+Hqiv9l1C4HsbU?=
 =?us-ascii?Q?gliSyBXpG7YKONugFKRPkxQjRwXYMnrkJbysyMmt+LDW4GuVA5gwL1GH2a4s?=
 =?us-ascii?Q?0ged9EeCPRbuoyqHx9moRmnJ4V6v2wx3RBQjPAxJYgxJu0PJqs6IzOqpnU0O?=
 =?us-ascii?Q?3jhV7emaXpxvpN5xejs8kwBIUfmRYqzSsas4TgGtuKgmuH9RvHGbOqGuSCAH?=
 =?us-ascii?Q?urpsdDi8Pd8N9QhSlEWjU0yhKPkNCXPxnxvfVd+jlSluFCCAzcmqbsJjOVSR?=
 =?us-ascii?Q?demosHv52U1V2Lpe0hC1AnKpi+xciwnKRD06STHYd219nzD8jqp4aoaNuia1?=
 =?us-ascii?Q?LdRo6EAXIRkD2DtmUkogAfV5hsAzTJsXqm9Z4m5XYGF+fJZvZpkDFgX+U6ci?=
 =?us-ascii?Q?R9h0peWI8mwePz6TdJpMoocjjAXWWWQImLcyNnaXWkbQnUM6ldPTqAylBFOR?=
 =?us-ascii?Q?tetEzXsJSQt+2DQ9cqVRg2FBZZwj4bo3itkLB6HDQbmJn14wFBD74UZ8X3vN?=
 =?us-ascii?Q?qt4aKuWNtt8pgcqCM6x1le1hMv+FjeemcVL8dc6pDzUkGlw0yqKIGXzJxZcN?=
 =?us-ascii?Q?qomnKzT4ScYmSnDGihDPa5w419AOv8kQc8HyC0jdIzQlEDG3obHTLOStxlXd?=
 =?us-ascii?Q?cfm43u6fZZa3Jffws0AHydcwzzesK79WBDggt4XudNKyW3JihpTxEUpHQN0o?=
 =?us-ascii?Q?Jm58vylxQoOs7KOQe9xRMliIx2Snlp2GREUX8tnvlQm4exuJknS9yfGFWzW7?=
 =?us-ascii?Q?ZKqHw+ec0tIbeVSOcy8Q2kgo4bX9Cou0myN4FY60n8J62IPWhS4W2xOXgK3g?=
 =?us-ascii?Q?8H7OwgwzP3HmAwCzO5M18Hw/zzYMUUbIcUwL6UePbFk6BiJxttKRotX/YQ8D?=
 =?us-ascii?Q?ImbKnNichGfP3mnyGXkbNBnsNgk91AVwhY5BdBW8u669Pqkpj33yrUyi6S6q?=
 =?us-ascii?Q?BmsEnFfaonqppjPDOXbMiGRfhiBbRzvzknb8O1mw/3BzuRRuE2D752LVVLba?=
 =?us-ascii?Q?hpXlwHyiBmKAN5tTyR+ydgvSdHroaQjpcwRWdKVSgPRLFyZfvN6TljdmtXIO?=
 =?us-ascii?Q?ow8ad9g4PzNXbY8tnEs+zWd5FX7iL55rd6o34M4kxK+TN7fN/CbRzWhY5jxl?=
 =?us-ascii?Q?SnPh2xoKQDrfv5SKd+i3uODwyqhb90td8ZZXvHNH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab576185-1450-4226-98fe-08ddba468c92
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 15:30:32.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OuwBRXFqkQLJE7PJONRbkVBURE9BeveD3sf4XNC2Ky2RUUjiPSMh268JGeX13Ri7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195

On Tue, Jul 01, 2025 at 01:28:59PM -0600, Alex Williamson wrote:
> > +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> > +{
> > +	struct pci_dev *bridge = bus->self;
> > +	int type;
> > +
> > +	/* Consider virtual busses isolated */
> > +	if (!bridge)
> > +		return PCIE_ISOLATED;
> > +	if (pci_is_root_bus(bus))
> > +		return PCIE_ISOLATED;
> 
> How do we know the root bus isn't conventional?

If I read this right this is dead code..

/*
 * Returns true if the PCI bus is root (behind host-PCI bridge),
 * false otherwise
 *
 * Some code assumes that "bus->self == NULL" means that bus is a root bus.
 * This is incorrect because "virtual" buses added for SR-IOV (via
 * virtfn_add_bus()) have "bus->self == NULL" but are not root buses.
 */
static inline bool pci_is_root_bus(struct pci_bus *pbus)
{
	return !(pbus->parent);

Looking at the call chain of pci_alloc_bus():
 pci_alloc_child_bus() - Parent bus may not be NULL
 pci_add_new_bus() - All callers pass !NULL bus
 pci_register_host_bridge() - Sets self and parent to NULL

Thus if pci_is_root() == true implies bus->self == NULL so we can't
get here.

So I will change it to be like:

	/*
	 * This bus was created by pci_register_host_bridge(). There is nothing
	 * upstream of this, assume it contains the TA and that the root complex
	 * does not allow P2P without going through the IOMMU.
	 */
	if (pci_is_root_bus(bus))
		return PCIE_ISOLATED;

	/*
	 * Sometimes SRIOV VFs can have a "virtual" bus if the SRIOV RID's
	 * extend past the bus numbers of the parent. The spec says that SRIOV
	 * VFs and PFs should act the same as functions in a MFD. MFD isolation
	 * is handled outside this function.
	 */
	if (!bridge)
		return PCIE_ISOLATED;

And now it seems we never took care with SRIOV, along with the PF
every SRIOV VF needs to have its ACS checked as though it was a MFD..

Jason

