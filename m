Return-Path: <kvm+bounces-52182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F95B0213D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01176A45892
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492FD2EF2B8;
	Fri, 11 Jul 2025 16:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f8DkaZxk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE217A2EB;
	Fri, 11 Jul 2025 16:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752250103; cv=fail; b=uXA7NW1gh6Dv9cMHD7vduBG9jlnQ5RDC2Nilk+J349ozQZ/ZJWSeZzSmC5Eko92jaAx4OoVt5sjV0wl4yC3DojV/t/mfGrTqeVPCHmZ0FAVbV3hvlI3H/24UeD5OaCLXzgBIhF6rBX2zzYfPyAd1zhNWhcWl9s5SYSuc5w4RMTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752250103; c=relaxed/simple;
	bh=e+xpQ8ZtIf6hjTVsYGKxuBOVx3GJE/LcBCU/NXseTuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X1tEhH85yUZNnnlEHRVPtfRVV6J7KrtEcGA5IqYFdvwEseMWufeVDw2yEOkCWA5AAHwMlnlxoXEAbDSoQkGb/1oaOjvV2C2ueB4YCI58La3SmetPk9SqGJ2NHJEEXZPP0GXhPrXhq0xHszxwXI+oDoNfvpvgVnj7Tgns7zazyv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f8DkaZxk; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CujuQefVXbwOwZy4mRjGx4aH67r70LljNpaLBgX+/TSNJxjC+ZchpuNkhPIYbduF7SKdutOeoLg+przm7aRda/Cy/ZZtSniDwo80fYaHA/w/jr3ZNRxEusubQd9HkW/A2hty4F7x4owIeAGDQwy9UEELdvhv8hZqUInTpCiBwpD102eVu70QLQwb/LTXhsm50DWK/77JQ8lAKIACjf2pr07aMUbVQVA0tOmMfmAo76YwlZ/jkWB9XzfX+lVmbg1OGiaskkGVRwW03CD5EMRUQdag6ceTiEcSOH4xlZaVZNobJ0AUPNYPT9q6tLXRIH/QhF8SYpJ+12MgbWkk6OAF0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkb3Td3tyA6ST4F1YURkfxhxp9wv2JrVQfseOElTygg=;
 b=t85NonlL7LhGViO2oVSCejnCM+DGgNQuG/UhUnz2a+iCy3wBmu9ELWJPIgj2oXPlCmDFV0RUlw+E1YGXZIOD8UNAEwQ4kSmj4PakedLIM1B4S570spJ9XkoHw2jutiShJzqmL9sxX/fZ8pPLyHIfXakHej8i/QlomTfc26eGrtvEYcVFk7hdGuhOJ1c++X+z84IPq2/NMOqEle9leOu6ffFwXaAKK/ZdsPY9WhwBj9hyhMmvE6fJRDFKD5Hfo4VWulZuiwK6ijmjXIngcbDn14HpLDzcW5C6S/5e3+nMF5w4E0XRSkl8CsR17Kguj6qbQzoE76745cG3vJXBXch5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkb3Td3tyA6ST4F1YURkfxhxp9wv2JrVQfseOElTygg=;
 b=f8DkaZxkPwJR7t4a89HcOzIpalJr5KjPpGPfRGhgEezuJD3ASv+LoC8JFvgzuQQAgy0+omTjTnYDLhy0Cv9FwU9P9hY16WnGSnm6bE8m2VZuX+sG9nNeO5z4RV+WAb0sR/MnDNzTYN/kk6n2+3plT+tOswFU8Q0K0UEVZUumucGnH2mMBUstxajvUy2rhz51RG+GoLfWJaHa9RL2GOmWIq8zLG9wIPl9bMmAZ5CVtThPVl8YDdmrKpGQ8hlIoN8drUmrOr/Mnn8/I9xw1BvE0XCaMB6DV96GlDC85YYhmjAjwcxe9dKPs4PUgOBlp8YBrn8IMzYVIbkbW7ccQfdv6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8658.namprd12.prod.outlook.com (2603:10b6:610:175::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 16:08:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 16:08:19 +0000
Date: Fri, 11 Jul 2025 13:08:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 00/11] Fix incorrect iommu_groups with PCIe switches
Message-ID: <20250711160817.GC1951027@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701154826.75a7aba6.alex.williamson@redhat.com>
 <20250704003709.GJ1209783@nvidia.com>
 <20250711085504.71e82a16.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711085504.71e82a16.alex.williamson@redhat.com>
X-ClientProxiedBy: MN0PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:208:530::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: a7e351cc-25fb-4e78-a5da-08ddc09526cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?arxSIYf55kElEV1r79oNXElpBqbyGiTJnKiWAJlQfeyasdaN7AuQm4i3hGrc?=
 =?us-ascii?Q?89UOm3vXkDjjehH4ZLikMwcwZajjGQEff05USrIT/TCfdzE1zYMR0/fUnROx?=
 =?us-ascii?Q?sc1k7W4h9w8wa9rg8/6u8hlnMmYwgdI/ABUhTJkc1MNCAX6LUXC1Si1KAOkz?=
 =?us-ascii?Q?WfxtZPYXya5Sy3K2j+WbOlzKecuOpVxv/BkJSpQ0gZV6w1LKolt22s+4AXfC?=
 =?us-ascii?Q?y++fWpjMYmqxThOwVJSfP+H561z5efigxD14oCj8MdN1SEZrVLkVfNkrg6rE?=
 =?us-ascii?Q?+6ssGXxS2ktazJqXqC6svZcUWdbnEzPBiWo1QKu/W+nRje+769Om6zswXe1G?=
 =?us-ascii?Q?ijNWnqKddMxi5qRu/fL2F4hwXwhH/oV2upAVL/Y5mkuNIPpTrZNlAJCVf1wj?=
 =?us-ascii?Q?oc3CU3rV0YEFZzI0FNtW0S1x2qeFaQ+BHKt7caO/O7h366IatsjnijRqShSH?=
 =?us-ascii?Q?aXs2gYNopsXnQFDX7Z3Sw9ZFw1owcILwf4j7dgTZYnJsf6ZNRLJ2E6nPiBcV?=
 =?us-ascii?Q?NUoL2/LxUh9jRcnWVgPjPP8L1AaFu2u8fRGG3KFKnbduMDp7kZ7u9IjHd44O?=
 =?us-ascii?Q?vzfDec7UYSdNfj9KVcPul6iCuqIOGZ77bcldj00SNkiYMS1NkQaafY0B6HPj?=
 =?us-ascii?Q?iXlUznPhRw2v+MCvODZZjpfDFjrnITeCaiMXZVPCDeruIfacrwCoQuftNU5n?=
 =?us-ascii?Q?PN/SKLcGpToM1OqStRONu7DELA0ycsAyXgW9ism/A/z7G+qfTWgR/XDQFpvn?=
 =?us-ascii?Q?gtvCaIMS7ZhmghRZN3pNN4tusOZrKVmQ8bhsN/dJTk45Rhw2fAMsBzEg121U?=
 =?us-ascii?Q?A4A+hu4PXqgXiKsXaK9tpCmd7zkHYeq1y0bt4En8J5CimE42xoIT4A3EG+d4?=
 =?us-ascii?Q?bIdvHzw0TzT80+AyamJysPtjUE6Kp96R0afp3/fwtU/MEpdIrjHzb0mblTsf?=
 =?us-ascii?Q?FE0Sa/+eBiMVExEQiyympmOpKbZf6D06bURZLfBHBSi1+ZWFH9MHmYCAxBza?=
 =?us-ascii?Q?Opw4KoDwhv9s6lTbRrNGNr6PcocOnN402x17z8wWdTbNQ3tRD5SACo0tTQ4w?=
 =?us-ascii?Q?yY8BoLJyIglId/JktCJTVQ16pibAqso/S1PgolavmW8NYk4tT4KU+tz4MSef?=
 =?us-ascii?Q?xlBRMkVQvlGtb8fzkiYcwr6WoCTtRkLx3fi7mKHG2T40aDpMlVWq2yVArv8f?=
 =?us-ascii?Q?u/VXGtlymmNqrlYDmLB6ZLgzP3eDWkoeB25Z4x433eaEu1iK4b2j6LzDuEgp?=
 =?us-ascii?Q?zBaYG9/aJopa+PnakNad4jHE/ez8nxc6YUP9WgcVwGdO/MppdhaJAxrwNc+1?=
 =?us-ascii?Q?XetWIeO097V41z7cdNlgtnVY/rOGa2TB5JMXHJgTlTyCzL066v4ERH5jib/d?=
 =?us-ascii?Q?HwCpyb55mZvn7tVLPETUW8UfgHK+ODKcboqvHgl9YElyoxKdJLHuVx8/U7iY?=
 =?us-ascii?Q?zpuQyX+mZLQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yuKtc+KxVBVObbp59lL2cCJjRcep5NMiSExXAl2+6K3uKcXziwoyE+rfMi1V?=
 =?us-ascii?Q?8Q0FE20jqHM6TJRvIKOY6H/ngmfKQU3v7QPprTI7sFPAdd5WVD6AYDjIQxZv?=
 =?us-ascii?Q?yoQAsA263YK168KaVb7IsNmuZZSvIyMdVEkQ5hpvpVcFDzXnpPRFLE1vqDjQ?=
 =?us-ascii?Q?bJakujnFYfjOhLxudPSP0jMRAsqTgp/sJWZVHJmUY05sAYMV42OTe136I4SG?=
 =?us-ascii?Q?530GzFdiPALkK0UMgmDIFCxMmuwRmThlxXxZHcZW2w1p1WqjXTenoHlH6P1F?=
 =?us-ascii?Q?LA52TYzdyaHzW9AyGQsnD1jg1O5SriCpTIp7dxFOyGTrwEDSNu2Qc6OFcQrU?=
 =?us-ascii?Q?uKaFm+tKzWjarEEge8ZnZWR3d4J9oEWy1Ki4ygS0Pz/JQzrFoE3azx53FTfO?=
 =?us-ascii?Q?w7DIfLUg648DuCo8XxULPS+b4qs8gcOS1jAfh3vzDDnj0wK25ZtHtjYEA4yV?=
 =?us-ascii?Q?psq/ktqdXW+oQPp0iSea/CaTrg5W/CHyBUbBs5JyXh44lrXLpN5cNyUv2eOC?=
 =?us-ascii?Q?vXGeW93wSzIvvlnB47YlNITFsAIwAal2sngAedQWjxSIzTnSJpV3R4WHB7xJ?=
 =?us-ascii?Q?UrkMJC6XAAhQmA2j3dKvuO2AAYKIsnumm6iq6Kx/ojqUAAe/VIqO5aER5jp6?=
 =?us-ascii?Q?vr1OL2dRVQzFfgq9hCO3n9e5Y9bvawRldgfILnmN3R5fU5Sld7S/emdX0r/4?=
 =?us-ascii?Q?zvuXoJhR42tKeJFzG9hsqgSQ/lo5xaAFqzXKkSPIxhR70b4ZB7mbC3GRl5O3?=
 =?us-ascii?Q?VeSGpQApoA8ShCA4YMJMBjzDZBZJRy/d2gHVbNOfpWqTERzvfSgKf4Zg2mKk?=
 =?us-ascii?Q?Qya5b2Le7IkVKheMZK54p4aZdmzdvcEO7AUydZuT9BjOvcDByfAdWFz0Pf7K?=
 =?us-ascii?Q?GK9wfN8n7dapA8cL+isda7iVTiOesTce+m6DkAQekGq3apHNFBEZlRbbQYK6?=
 =?us-ascii?Q?+Hg72cHASxDjEqAr8HhJnKynCqyS07K765ctcNrHRMhEJoQ0m7i1nEsF3eQi?=
 =?us-ascii?Q?KTgoPHtj/3UC8BS+XCmtT5WdBP7OIXoBtaTRJCfHwVGvta2MekuwY5pHLmhp?=
 =?us-ascii?Q?TQ9SQ2UeJwopUGPtcZF9sdS7bvLIGk0N5o+H8+o7J0en4qqYG7ehfc2vmBng?=
 =?us-ascii?Q?ReXlxORBRjy/O+XvBA0sVLT6/+xPazyLwV+sqglOsnoNMcx7fX5hrhqyl3Za?=
 =?us-ascii?Q?GDHOBT4OoguY7N2kpaEofMEaANEeLVbngeyrFVf9+eqDh5haIqFwyjbCCi1X?=
 =?us-ascii?Q?G83sM/iI/P2l+TsdxweSRh9u+0pVxre1GCQajghJZFtfzvNDKG0GOxNU+6vx?=
 =?us-ascii?Q?/maG9DWIRK/+meBvfkyVq+vJv53r+MVejVYfSs+aw88aiuinl+8Gqpa6ikh/?=
 =?us-ascii?Q?glErXaoPJPsOH+TjYjzFz84Stl1yB2gX/yPakRX93nGArQVIpM0I9VccpBdt?=
 =?us-ascii?Q?wzNelVSd3qHMft0Ir74r2xpe7q5Y+LpcEPQ7Z5Lfv25mcDOS6UXv1xIyGcWi?=
 =?us-ascii?Q?En5pLmkYSnKy8z3xmiF/v2+7OGAXRyL0R5e1YlVRwuM8akDDO6WXGZ+mBiKJ?=
 =?us-ascii?Q?Z9sNMDrn5dcE8aRj459GHmNWF4SS/Y5kXrABk4cm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e351cc-25fb-4e78-a5da-08ddc09526cd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 16:08:19.2097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2pgVCpiXUDtf6XTbg16mZb7Zu6uW7w6scqAerL+6JhgsbIym/tyHXqs+w9oGmBW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8658

On Fri, Jul 11, 2025 at 08:55:04AM -0600, Alex Williamson wrote:
> Sorry, you hit me right before holiday and PTO here.  I agree that
> we're currently looking at isolation primarily from an egress
> perspective.  Unfortunately it's not always symmetric.  In your case
> above, I think we'd consider it safe to assign 1f.6 to a userspace
> driver because 1f.6 cannot generate DMA out of its isolation domain.
> On the other hand, 1f.4 can theoretically DMA into 1f.6, so it would be
> unwise to attach 1f.4 to a userspace driver.  In practice there's not
> much utility in assigning 1f.4 to a userspace driver, it's generally
> bound to a "trusted" kernel driver, so all is well.

That is not how we've defined groups as a security object though. If
you flip the direction and say 1f.4 is used by VFIO and 1f.6 is in a
kernel driver this would not be acceptable.

While I like the idea, I think if we keep the current group system we
can't really make arguments like this.

FWIW, my v2 does seem to solve this problem class well enough.

> If we say that 1f.4 taints the group, including 1f.6, I think we're
> going to see a bunch of functional regressions for not much actual gain
> in security.

I have been thinking if we should have an isolation=relaxed/strict
boot option and relaxed has assumptions that are closer to what the
current kernel does in practice while strict would basically require
ACS everywhere to get smaller grouping.

For this problem relaxed could assume that a MFD function with no ACS
also has no internal loopback at all. Realistically this is probably
true in most cases.

What concerns me is the enterprise market that does have a strong need
for security here but does not have the resources of a CSP to properly
self-audit their systems. I think if the enterprise world could be
happy in a strict mode where quirks and ACS caps are mandatory which
would force their vendors to audit.

Consumer/etc doesn't really have the same security need and could be
use with relaxed if they have any problems.

> Maybe we need some extension to the concept of groups to
> represent the asymmetry.  Thanks,

Do you have any ideas? 

Arguably the right answer is for groups to only be about DMA aliases
and a separate 'P2P security graph' of what devices are allowed to P2P
to other devices is used to enforce the VFIO opening rules. I can
imagine how to make most of that work in iommufd, but not how to fully
retain the VFIO group uAPI. It would be alot of work.

But my main concern right now is the switch ACS which is the first
three patches only. If we remove the MFD loopback downstream
propagation from pci_get_alias_group() I think it will behave quite
like today unless switches are present. Would you be comfortable going
that far as a first step?

Jason

