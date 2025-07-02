Return-Path: <kvm+bounces-51237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E89EAF07A6
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73CC142398A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 01:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B6772615;
	Wed,  2 Jul 2025 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JM8kMuMK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC39EC2;
	Wed,  2 Jul 2025 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751418067; cv=fail; b=qSgD9pRNtfmA0mN8AK+Ed0zd8Ys2bfrjJSdQE98qG3vLZq0dh/k9pOVQ9egEr3SxnQn2bgqRyhzHw1brhiR7lMisr4g1GEYiXm8KWfxAsQvc5PiCBWL6MlRjhEjnwEam5wSGOcoh64hSEXmolB9IHAfNlqv6nQZGMVfdCC0xpAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751418067; c=relaxed/simple;
	bh=5vruit8saeFTdqJsK5plGqWQU4Eon5cpeZ+8m41wBDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mACaYSmf14VRy6PPqYBkJbxPBeS41k7WCuzuPUQWprtlIm2DU04yuTuBp7H/cudOzK21dPhLMRsIbVbgIJ+Bgxg0jz2hGV52yeQmEHYdh06yDwk0EZpq4W848ojSVVzPnUQDTVgLAdj7d1BbX3OA9c8sBkzwL+r7hzEbg+GOrEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JM8kMuMK; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FIfc1fA2kd0jtY3I4AG6qDtny0Qo+LA0yRRUw8iurCBgluFH6VDrUJgSjsKBW3NdvJQl458LhnlKZ5oima/STT+BCzZRtP+L9jEundCk4/Jn1tIWcKNm0vaDpE5P5EBYJgU0oi4MwUW9YEKd05Yq6Qd7IQlK6GDs52f22ruYke5uvQYQrAL7Mo4oG49MBIeuyDuaX6LvOHfGlyt6XU/A8I3mrkjU59mtG0kKdwmGd0TfC+V1IbdLj0W0gouOY6qiipm2tuLZg4J9ABLfO+nsKsfmT3NZuavzf4hGWIcO3GZ/RfH5DOx9aB903HiYsTpFZ2xFBF/1TUrHNxEBeJOVvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFuGRxy12PKujmwT3cscHtvqR6BT8YeamRmGmMuuDIM=;
 b=OrlOJuLl9VYOn0M4cptepvCtmIOJ5hhj8yTLo5VyDXeDYWjDBQ5190s0iwI1dl9JqsCvr3iaNvmZI6B2kyhfAA3rN5TpUBGPYAYnS5eeG3iHsPOt0U2TQAAWYSgDdMXzYERCl2Zvz/+jgTCj8RMkX8abj31ye+1DwO3HANzM9PQx+R58JlLnvEXRPMmQw2hCsUTrkGQUNNYsGIYo85rc4xCi9kIs6XsEv/fnR9yhiIECJymg71EWn/MDJYL51eLu9ZKZ4AVYK3csnxd50rcA1okbpfZDPRm3C3L0ztR2NCFcpwhWCt4oWISAxu1+QvmFTcR/rUQPMTmyRl152BxTEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFuGRxy12PKujmwT3cscHtvqR6BT8YeamRmGmMuuDIM=;
 b=JM8kMuMKpnxP79k7jq7tXYqqn9ae4ylY6ucZiHqevG1o1Fid9k8lSwbNOA0z7ffrFgvqydgXwhW3xEmreNZUigrAcEu1i1hb4Bz2yzTwBw5mBLW04A0/4mtgjOpeoTHGFO6WV21ZmAADCHRQ1O712FrMmAdQiGkDE23LCdtDvV5aqwypRHTv1LaUrLzTd2Wnm+eHk22uK5bd2VXOq0d6wW6reABAT272WmcrlfBMdFzauKx8qJU5nL65y2S3EBSCr8f9T9n+O2zdPZpvPqzHFFudRjqgx+UlPZsfkcUQSArn+IMrOwTHt6XTGy+NRGXCm/19MkkmlzzNXu6csLoVbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7533.namprd12.prod.outlook.com (2603:10b6:8:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.24; Wed, 2 Jul
 2025 01:01:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 01:01:00 +0000
Date: Tue, 1 Jul 2025 22:00:58 -0300
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
Message-ID: <20250702010058.GA1051729@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132859.2a6661a7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701132859.2a6661a7.alex.williamson@redhat.com>
X-ClientProxiedBy: SA9PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:806:23::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: bdab4ef6-4ba7-4ad3-4abd-08ddb903e91e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZjRISpXMAt/Xd8DBSeDHyJVEhvEo6GE58aUkWvbfXDQloQbDTBkQTTJFxwE6?=
 =?us-ascii?Q?E44sOZTCX2R6OrEFC9a9nN5+iB7di5PgMlXEedLSq9W+2q0wCLbDyZwyWpqY?=
 =?us-ascii?Q?sB5PF4/AFGGN3KBkTCIJxweuz8K+ww9MXqNYecvLynqgIZkWIaVGGh2m9GPB?=
 =?us-ascii?Q?SCD1rL0S488+ktsTWMASIyCVmuJ4wDwMn/goiYT8QYmko3NqJk+nP8EtP/Mv?=
 =?us-ascii?Q?ul0rYYZACf4LREatBj88WR+WStG6mvbopOn0gl4q3UKq5Mi0hqAQ7rRqeFqc?=
 =?us-ascii?Q?ck8K3emuBsqNqPkc4w0/5/fUL1QART9tOKQnBChhlbvzCQQcnngzs2fqUZ0c?=
 =?us-ascii?Q?JKnhr9AtKiBx8CMOA9zjXuF670dGeHHoHyNWCvUNUz1WR7o6sSdD8nXT/EBy?=
 =?us-ascii?Q?HNHqS9ynGkL3L1H3/WVdy54ydrxf6Ll2q95MTWQcR1BEfrzYsqf0GtlBmVkB?=
 =?us-ascii?Q?qtnwm1eGzf1APib2OKRMakIE6PKguT+UX/4f1yI9E9bH1H+2YhrVr7PmwjmO?=
 =?us-ascii?Q?cvnvV2r3Uxxm6Ed3S7YihKqCi4OEek/hKGqJwXXyMwMtQGIdpEApoZ1FLh4n?=
 =?us-ascii?Q?svyap0w0E7yftEebO5iWw6xzjE9S+fWFtIf+IiIdjofcTBJN9ImaUruYGZo9?=
 =?us-ascii?Q?XjUqe3Ij1KAh08yqjNW1oP2DINb+1VuvzTQ4QIDk0Gr/QvRGynkSxyJ6heM5?=
 =?us-ascii?Q?7Jjs4NIHFkjTyF3jwVY1FQyT0ST2S+BGCs5LL6cXUe0gb7xnqB25IDp0S3OK?=
 =?us-ascii?Q?LuIEPLcBCIXwchlWcdfJ0PXvvAG1XTzQGIpXJKvs/ifWUvjRer9V/irc1tSz?=
 =?us-ascii?Q?AdEYQktMqe2/51TpjfLWzB1GPyDNvlkzC1E6PCCsFiE+CO+M78EjGMHfy/c4?=
 =?us-ascii?Q?cgE3CLRQyJrR3Iyk4MtHVq/3owuEi7DpV/l+8LNk5RBWk0v/piM/2nY+uBmD?=
 =?us-ascii?Q?tgYJXXc2oWkl8Rx+Eup3TnKMLn1zrNt53P56232tDmWy25Op6X+sRtxAlG/J?=
 =?us-ascii?Q?dEPqh6EhDykY6m3CIA/b2sxUTNDQqpUbL78OG67U82WvBJ3ovZPiqGohTRBO?=
 =?us-ascii?Q?ii2YYBHYAsV/Honv+3ZvXKEykKh/HQE+WggJN3gyWwPfK8CD8QLKrU9CvrrJ?=
 =?us-ascii?Q?ndjQnXc8MfQ1PyRtLm4jFoqzeCwC3KD+NMjXY5UUF0BEpJtyVbo/qEIPn7Rc?=
 =?us-ascii?Q?M9p6CA07ghRrdcw0dC4T2U7apu9ZZpgYaoTDMTcsiC84wyMM2aOmq8bzmplG?=
 =?us-ascii?Q?m+8jr5AckZvDRYxf1alyT4bM3NlbYBIAJO7ySlmk9NK2XyikfGlgj93Y/zm8?=
 =?us-ascii?Q?cBqLucW+WP6NRkpnKAhBJAHM4uTSkjySZFDafn7TkqOEv5oYzw4sklhBW5dx?=
 =?us-ascii?Q?i/FMC27PN3OeBz0/x0VVs1/jcE4RR1frXqIWHod1ASKxHuLn+nxI3A0SDY1l?=
 =?us-ascii?Q?V0F+GDFS8wM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tVgggescjeHRe3lBMVv4/n5D4wdjfsL2bA4Cm3LmNgYpG8+ETgv+bpWQt/kR?=
 =?us-ascii?Q?YVXadd8aZ/4ZDzBKRO74jQnx2DY0GVrsTLlU19oDC0k+YeyXoDr1syggq1rH?=
 =?us-ascii?Q?J06Zpw9qJxWr8SN0RDQoiaUPuotnwOSRSqMepEBL8r3Dh7nj2CQtlGTU6XFw?=
 =?us-ascii?Q?eiq+Ytf2S1g03Vf4Z/GYjMHxRLldr/g2F6q/yNgwBmy99ikFhm6+bmwZFDlk?=
 =?us-ascii?Q?S13k83Vp1MHJTf3Aov3ElM9AFgPkQdp+zKb4O72k2JDnq3pYo7259UB6p2h5?=
 =?us-ascii?Q?+biAKi2eR0OIVsjCzcdDUxtu0QkPosp3QOEtHK7epybXQySq5MsMR0JR0zAv?=
 =?us-ascii?Q?u90fC312CKIFpQBDonhxNNsMiGwJDNiIrMEte3GoNHOD/ecQAyAYEGGDQU7F?=
 =?us-ascii?Q?OgrSVVJ8Me/FiN81CHbusIEs8KHIxKT+OCWYJ1saEh+FqZArNnwKL9ZWzVYF?=
 =?us-ascii?Q?ZQ5hOfvU/cbAuinI/mk9QEHmQQrVCe/0/q6MmWSBG/n07f55L/oTuZTBRuqM?=
 =?us-ascii?Q?qkoxkvSEJfCKXhpSTQTSO26lTHju8qhdThppDVPoYJCb1TFRv3pCmZw8U4lI?=
 =?us-ascii?Q?KG3J1ga32DR12D4xTDH+fyRyh4FPPXclFcrriYIKIkVHt6DynjuwH9YAYMB9?=
 =?us-ascii?Q?nEnCI9u0u0eRdh/MjPqPGb2Rr/GNAOKKNR0wHC8EVXGEb1dLQT0BoPcatbxh?=
 =?us-ascii?Q?UXXwLyPlNLyQBblu4qr2S4BEJdXAPQ871GQSM7a0xTXfebQpNWjeJ2a20HFO?=
 =?us-ascii?Q?y8k9I1zQGWh5zBddrlv3BxN/E4mwsrsh5NJ1G9bQ7fWmYsdnbGkVmybfwhIe?=
 =?us-ascii?Q?zv6NJH0uKYIEIaIIfPc2jOJtkNUoDMEYqI0CklXQAfeGCKFVfk+PDD6nsDW0?=
 =?us-ascii?Q?Ym8qECwJOm6vpE7gmEIdUMZQmtirxwkRuPNw1VfCzc4klfZajX01+vyw3ahs?=
 =?us-ascii?Q?IX1wf2v1vcs9V5y453GD2Swz5o1UHz43pQbfJK1e2keDoEpOnSlsqP3GkepO?=
 =?us-ascii?Q?j74ilbHV8KM7X/3O2C+1T48sbiDwlXVJbWbv5t0QAcehXt+WLX8j6aATQF9b?=
 =?us-ascii?Q?YxGDio/EzJ3jjO14KAwfAXqlUsltKwEFD1t75v4WzMVGRHLG+jvPsdEObUZC?=
 =?us-ascii?Q?BkhA1v30cTAqJRm4GJJPW9B0/vJ/zFc/6C/F7HIos/zbAFG9R8wR+2tdte1q?=
 =?us-ascii?Q?XrkyHf84cA+GaIBwKe/5crAY94xaeBzZHz4ktsfVpKVnyRBaFtrVJWPn3e9t?=
 =?us-ascii?Q?QwPzhT3MgkbyA4BN8ImIgjpLSYLzgDfpmYd3YE5JB5+R0/q+H5ObNr9NNvx0?=
 =?us-ascii?Q?fEctt/BwV+vIAwrzkRJCeVpyTx+WfFoFWb+qZQuLt3KEziapIQp7XIt6/Iko?=
 =?us-ascii?Q?m5ITpkOIHTUTpxyJcO8t+PthwVeP86f6Bi9DbcvvrV5Lf8dWHdOUMskaNMsY?=
 =?us-ascii?Q?KXvsWXiVMr+HaKLQ+T4cfBtp1qpC0T9o4G2WiWTd9fcJvkjr+Gd3c33nksf7?=
 =?us-ascii?Q?uHKNml2t/eaKbAukz1Wp8qSJWi95anwehn/VfZosWEH4tklKS6SdKRI6NTjD?=
 =?us-ascii?Q?9qq3Hl0j33zeSIwTAwI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdab4ef6-4ba7-4ad3-4abd-08ddb903e91e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 01:01:00.7602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcvSxEyU59UAh1ApSal9dkXrs/q7HzgluGpG6H7uh5M24ZPOPSTPRa2vfTXFBHPZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7533

On Tue, Jul 01, 2025 at 01:28:59PM -0600, Alex Williamson wrote:
> > +static bool pci_has_mmio(struct pci_dev *pdev)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
> > +		struct resource *res = pci_resource_n(pdev, i);
> > +
> > +		if (resource_size(res) && resource_type(res) == IORESOURCE_MEM)
> > +			return true;
> > +	}
> > +	return false;
> > +}
> 
> Maybe the intent is to make this as generic as possible, but it seems
> to only be used for bridge devices, so technically it could get
> away with testing only the first two resources, right?

Yes, the intent was to be general, yes it could probably check only
the two type1 BARs, however I was thinking the ROM should be included
too, but I don't recall if type 1 has a ROM BAR or not..

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
> How do we know the root bus isn't conventional?  I suppose this is only
> called by IOMMU code, but QEMU can make some pretty weird
> configurations.

I feel pretty wobbly on the root bus and root port parts here. So I'm
not sure about this. My ARM system doesn't seem to have these in the
same way.

Since we have a bus->self maybe it should be checking the bus->self's
type the same as normal but we should not inherit bus->self's group in
the iommu.c code?

Jason

