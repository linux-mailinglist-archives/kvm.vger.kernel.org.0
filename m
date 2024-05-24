Return-Path: <kvm+bounces-18123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3F08CE644
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1E601C21B45
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7153C86AFB;
	Fri, 24 May 2024 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TkxxQ/a3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF93548CCC
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558181; cv=fail; b=YaxR3R6WkkF9LepfVJUC/dWL5uN4Lxf3iwrPL8K+Sztw/0WIw+5unLhWMTFew/JF182Rn04CTmB0B9+ZgkxxvgfrSTqb6KYJTR3/zsokd4Rwn4irPcQlaa0r9ngMqgoz9sJczEss7LibC+ts2ugtjy8gEjClQoXHx9dYBcaGCWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558181; c=relaxed/simple;
	bh=bg6rWBmjhm/n0d5UNaHOmfV6mUxWx7+xbekYzy5JP8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pgvSSIrgSUul+S5G6JjVD/UwpdS7nbmEaKFuECBwfk9f9NC8Vz8sqv1Ae70OvDjLiw2BWr667FuCfI/2ycP8ndrVhx2jcdmNVhlDyKlun4y1QuALBZcnDZrOG1ZZEiZpxWvJIcUgHvg/2/QaATd/ni3pjTkcEezEc9nkSnzreLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TkxxQ/a3; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEPtLf6dqoDk0gnIjV6ywmyq0DHrpdiAPV7zxvREzoVnBQlEaJryabApq2wMGeOSOeqZ1HMEpUXt+CB8P76cKmmVQscgPvWfbHmhRxJZ1O1AlyrSmhD1KVabTsThalz0m/LyFaNeKxhFqRQwyYbpU1rK0cr3kLd1TeK+lLTtYTUve7qgrYP2mxrTbGyxIJV7yun2shDHIM5Or/Tkf1Fh50h3dIhuig+8xTNwtFdLkJ16pvOpdAUJCWguS6o8VqyE0k1W/0AuOUy9XtFD02kKwxknls55qB3huIrN6fi1t2MDygaM4RwbYGGM7Em/Dj7evWqL0fw2ZCac6mx5KtpY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8xNktUSlMTnWaXEt03XQByUinevLh+0RrNf6dYLyB0=;
 b=UJmdzRjAqMd1vjmXf6FXrGGbeJMfQLGUi4ieyd5OPPz7ked0uKknK9aAzGJfZjKmntJGd83tpsFDK7Zbqa9wcMKR49Oo7kbgiVLwj/l93zozHCPCH7X7iZjniy/lk29dcSdl/SoVrUrYZW3VK+tnkd7eLPth88Xu6v0X13AEslvBdRIYPl2AFxBJco/q+MiidYhN5h3cUfWuE4T+lPbXlWwtrP+m6efz7/fXy5SnAiKKEsq5wcyYbEBudLTE7F1JQwg8arKl2PnmMVP6dGrcnt0bk87E7EGeTQR2nlk/o9f975Xiz2Z+Mi7Er2+jh8TtEOdRGGlwyJKe1c7ImObbdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v8xNktUSlMTnWaXEt03XQByUinevLh+0RrNf6dYLyB0=;
 b=TkxxQ/a3rF3gBV0EmBov6TdwL2fuwxEih/3N27Aj4VDZkM0TCxgG9QnlhWwFf2W0odUvZLlGqnHuJiFae0FaTMXmL8aG/5UKRUYLk+kO2bN+6Bk50A++0EQq6Himqdiq46vBhYhJrOJexfokxIpDMWjzy38NmOoZ4Wpniu0mofYpF3GZyxJWHBbCf7uhQVE6z3Xxg0baxycaf/O6DuCLFOlnHZWTooSBZfVpDfIfEJOLZaDPd9VdB/KLjwcAzDYElZOEEyJ/Bm5p7BR+JKTnVFyBK5i7MaYoN04sRsVDkmwpggHwdL1pFGX9JEinJQGmI05+d5toc7UkwoNTl5AWuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8505.namprd12.prod.outlook.com (2603:10b6:610:193::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 13:42:57 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 13:42:57 +0000
Date: Fri, 24 May 2024 10:42:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, ajones@ventanamicro.com, yan.y.zhao@intel.com,
	kevin.tian@intel.com, peterx@redhat.com
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240524134256.GX20229@nvidia.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523195629.218043-3-alex.williamson@redhat.com>
X-ClientProxiedBy: YT1PR01CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8505:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d0f7a44-cb89-4349-2ee0-08dc7bf76b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6IjhI1lWX+UdjJcgA2/k4k939SvJ+saPbtwFZKQAh1qdUF3sLcTk1kGTeyW+?=
 =?us-ascii?Q?UiYe0SyFXusyXWaDpKzYYOfZ1T1xBEMBCEaunNNDNW6BQY02ZBJkhpNQZ0hc?=
 =?us-ascii?Q?3inTNefomM+6FMQvoCGpkWM7qA8r9kNLx8m7j5zh5HDXTxH3TwVEL3aMOELH?=
 =?us-ascii?Q?zCF59ucV/xpbHEuUrAlPHuJYfrHL9Icz0xehtkvLfOQM0V18Jc8GoNBQ552R?=
 =?us-ascii?Q?QVSkvIPsDQx5/th3HkIju1Ac7xdA4OdexlYXjsmcqFnNJnRpds/1ClzivD13?=
 =?us-ascii?Q?QcR7fPmzz2M5abdbh3QaaVWiT8d1X48rR9em/CHbI4XzYIHCqVc0gk/1JdFJ?=
 =?us-ascii?Q?ar3NZVskB5Bk2sU27DxZsEJjJdnQGxsuYfsJhHSzq4a+3PzlaMLvo6W4Sq1R?=
 =?us-ascii?Q?im3sIvqsH0D8cuJjvAlQPMkl61v7Rns9SrBJ4Q/tJ8qh8Xl335NmLN6jZmvw?=
 =?us-ascii?Q?ZwjfaLrw4OfWPHOzPzjWp0KsoTCQs2tfvB9gXOAp7tIwhf71pRG9PkrWLmBY?=
 =?us-ascii?Q?+pe5dvM3rxiahtvTsWlkG7ulwAoivfifUPXn/1PWzFzTBbvq9DI8jTA4625z?=
 =?us-ascii?Q?uO6nGyJGFw5a+cY263Vj7X3IQ08PSzVB00M0yU9EmLC8T7O+5W147RMofAdt?=
 =?us-ascii?Q?l5T7B43SMkucAQ4T6v/gd7meT3yOABPWgF7umTebfq93rhRvy/kJn59uGHyv?=
 =?us-ascii?Q?wGh6J3bAhlIAazCKY3pdEuazMkXKdS+U4Zxtjm+psK/h33uSN/Ox6Fbdsf/U?=
 =?us-ascii?Q?30kBtBFRJ1MAMG7w8c1adx2IT+3kLtQXBj2jtUdEgZB3nysYNEwV+AiOpiOm?=
 =?us-ascii?Q?gYusYbGbJMUy/Itwc9gnV8Fqhmyy+V2AuVJdBBtvOrgMnq9MwiOElkA580I1?=
 =?us-ascii?Q?+48gYXbrmTPM54Lu+efe89LT24KizYQ0hj0PQcGDN45NySkV5J40AvPLJDFy?=
 =?us-ascii?Q?h+JmNzZLLiJwhmCHR7q7+w7jepruK9xhEPlf070iJ1zSi51bhfMOxoE6SB6I?=
 =?us-ascii?Q?AtF/lE/A9KjmoBLpQ0ClxrnkTd0ITXA2N6cmVzejHdm97N9pRXjd8jwKOA91?=
 =?us-ascii?Q?5L7r+NTCF0zbhMrmPERPynYdw+YBOHUyy6o6LMIrrAMGSYoJmbMn/l4Gxyie?=
 =?us-ascii?Q?OYc+ShGdCblwPLN+tYm7My+QrZqX3f6LWCf812QZNJiw6HubvkOCKqwbGJTB?=
 =?us-ascii?Q?yZ31WqOQG7kLTDrD32XIfP3esXkXGpK/SlQi0yiMx80vn7GpfpCB+m/4FMA9?=
 =?us-ascii?Q?eW2ZNdGZFVx69MH0j5T72nYJ9HV3ONm5j8qP0vHNzw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P5h2tWPyc8dD6WLFZgjCOn3oEdlzO0BBaDgELBObaa32XzufCngM4tyiD5z1?=
 =?us-ascii?Q?wr8d5OOMhyGkDSb/MawzaZ0/2hTQje47/20HCeIV+MCAbnKbUiRMxcGsHOyF?=
 =?us-ascii?Q?/y0N/CoA9m614TrJ+8fDdLaTZGx82M/xv3PAg55exlnTi5H3WwDPP2f2obRT?=
 =?us-ascii?Q?mT1DmIkNkyAB6EaWst0E+7pSK86pzzYbN99DQP8d8hVGoVTQpIrDSCoL/r85?=
 =?us-ascii?Q?rFSFY7gWeeoBQIq4ahw4FPPX4Bm/FER57eypDK6tXCz/GSDBaFeHTn0+14F5?=
 =?us-ascii?Q?KKeykOb6FvyavWY3SCl3WFGgLsmjkUvJ7U++85URWhPewsp2UwYtD3RlzEO3?=
 =?us-ascii?Q?IKYz43O0VJPOXI1BQ3mRj7lIBKXqbuaRwPeT8KENa5HD2g/BD/1S7BZpJlZe?=
 =?us-ascii?Q?+Q1qHQXJA4wU3DIB7ig1YDmWh5YJhdRnkjB0nzms7ajU18l8vw+uI5O2VD8n?=
 =?us-ascii?Q?gua8c7QmaGoFsAr/4XZhpmhcZSRgQH/QFvCD/KnluAiq1YLJKM7Vthp2M/I4?=
 =?us-ascii?Q?IxjU2tWG8g8MfPH69uPDj4pRRe7g3In2MyZPSNUsltDmeSkXYP2awsppIAdC?=
 =?us-ascii?Q?TNa3LMDzOyqlLTz9/gRcbpEfMTR/12xB9ZU/EN4BECedxyL7vngie8H0AUwP?=
 =?us-ascii?Q?xfJpuuiYU3aML2t3qFREQgqSrZW4nuDbXpPb88thtyNFfV2R867Eus40xs0i?=
 =?us-ascii?Q?vAAunDB+afQgq5wbU4xVKEOt7lbzUKaG2Y8mg4XZL/r69S+/wVcgO0IiyXKE?=
 =?us-ascii?Q?+zWhga8yeLdw3XM3HWtUw7qAesmFs4TFpnmM8itWBbckwHf7/9FrttAQJpo3?=
 =?us-ascii?Q?lD568lwRSFMivqpTsZ7NfOIuTuOxE0EzGQDt53i++ITvrcOUm307kJvbTyMB?=
 =?us-ascii?Q?Co/unf8l6ZxRfS4pjBUj8IGhMreeUgvJ/ia6hJYvidojkW+TcUKr1wljbpti?=
 =?us-ascii?Q?MO6i5gRM2WG5tXEmA57OJWJv04ta4YH2lH8bgXGptJ5fFRt62Hb9b34qZeKs?=
 =?us-ascii?Q?zGrVR4auNOQthfgc9marbj8YyOOuuNqX7w3WbdENp8W5BUceiRR5d7JZDT+D?=
 =?us-ascii?Q?pxuo+eF0g8vP1xqmGZvAnioMrtsuHbzxMxoy0/+tgOTJxZpWjHeVMlPfJ7NX?=
 =?us-ascii?Q?U1UEbzn0jYtRcy4h7rmc/KfLCAdK6vzYKia6onkz67PQx6RqlNfiFN8fzYPf?=
 =?us-ascii?Q?9wB95bE6o3K1Ji2/p2hhEkq2WRmXtGvlapLQYfM0ENZHfLjsRjcYJoCqTUap?=
 =?us-ascii?Q?ChaFsQaeTlLfZYhM/0eEZHkkrnvzfMwgJ7PGls8WoF7LBJxeVbpuS5FHsJ3X?=
 =?us-ascii?Q?LE0ZLSuzZX/uYgLlL9iPblw1RddCrVPYWeYDv64oKfBRJpotVXkDfkmfX69H?=
 =?us-ascii?Q?r6+L4Dp/SL9VeJrLM8cAc9aaAzoNkmV+Lot1gnpLm9JluTPeI/mSfj5UsTOf?=
 =?us-ascii?Q?88vqaLQK6QwNisOe90pvv/OMvn7pKpyBwA7NNlTH79GvdbO2uWSzpp6bXQ9M?=
 =?us-ascii?Q?6GbDeC8K6J34zma7bS3jRhNKmyn65uxjJbuxzHleL4I7Sl18l8v3PLELUXii?=
 =?us-ascii?Q?HelN7GHZMSQF5z7PxAdSsmG0fBuSvghq0jZRh7GT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0f7a44-cb89-4349-2ee0-08dc7bf76b72
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 13:42:57.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lbz78GAuUKqwcUFRw+TUiNwOMr5S7AGT/usOqq3uqJWikd7OMpdc/d3GOHkkgs+q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8505

On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:
> With the vfio device fd tied to the address space of the pseudo fs
> inode, we can use the mm to track all vmas that might be mmap'ing
> device BARs, which removes our vma_list and all the complicated lock
> ordering necessary to manually zap each related vma.
> 
> Note that we can no longer store the pfn in vm_pgoff if we want to use
> unmap_mapping_range() to zap a selective portion of the device fd
> corresponding to BAR mappings.
> 
> This also converts our mmap fault handler to use vmf_insert_pfn()
> because we no longer have a vma_list to avoid the concurrency problem
> with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> huge_fault handler to avoid the additional faulting overhead, but
> vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> 
> Also, Jason notes that a race exists between unmap_mapping_range() and
> the fops mmap callback if we were to call io_remap_pfn_range() to
> populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> before it does vma_link_file() which gives a window where the vma is
> populated but invisible to unmap_mapping_range().
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 256 +++++++------------------------
>  include/linux/vfio_pci_core.h    |   2 -
>  2 files changed, 56 insertions(+), 202 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

