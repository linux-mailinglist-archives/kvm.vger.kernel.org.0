Return-Path: <kvm+bounces-52921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA992B0A9CB
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FD003ACED2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190382E7BAD;
	Fri, 18 Jul 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mNQUIkwC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74412BDC2D;
	Fri, 18 Jul 2025 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752860967; cv=fail; b=uOLTqPoPpsxMQGUI4bfRPBHvnhgiJDdm0Sm2mkegk9biELjbBLwR6vII9et6m3CZKAeLHtldA7/kv9N7K9BoWHAPHYsaal6eQQPomiN1wPunKcLVDmFdWitdmBKr7iOGVSOc9vPgCs9lFSU/NVAvCUnN7j9Hk1qeht8owQb0Flg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752860967; c=relaxed/simple;
	bh=khYQPCF9dS7NyehNUYfg7BAkwlnkmE8/XVwH0dIWbRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qiEDfai440D661l4ClnUZK8wNcd7HPAFzhckkv+uKjN0ofcEnndyRu9DWjObjBH2AqsgfHGKhYh8J7MGip2AjyAWHtTHsiQGanCcC+EnF4hBNF26/pNrfLVM7I4jDgjRcn6yDw5kEuBHNzAGCiIgaW7Bt9kic5nzSVFGvNXNl4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mNQUIkwC; arc=fail smtp.client-ip=40.107.96.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/wLrE8bxMtSpmIXXFkPbQflupYYs/ueWRCq9tF+pEr7OrHXJcMzbfWsxLS8gyG2T8uoRxs+yebF3PalQdLBFECjGZSST1wSDqBa5ZiE7/PA+0VhdHWbew4ZGvlZVcFeyUI+hxDgU7tMlwNk61LJz3FeZhmxuevlCw9WURX2+Vguc8koFB7S87EKouoNrhslqRtwKKuKkRU1FAg3MDmZdM0rfvYEjBP64fzNWPVfat5qUzre2kh0ds/0+qWXC3olQtfAH/Ll85qj4Qm+OdDXlQtt+lBM/l5f1I1dzhlQU0bGeMeJcfGHMqTC+I+hS0aK7eo+Zu7Ovl71gwi9ChrKTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rI97Vb6s9DhUSSzm1ADe3hzx7b47eBP0gotTh6oIg38=;
 b=DXfPX6b7pwS/4MFaSjg3vlqKKw9SV2W4NmfFtQnhQTN5ppDkXP4/Ov9E6gBvGpO91GgO2lfdGcehcQHwi5ALc/vZpljMjfZWgEKSYhiztUBongd1yHkhtvbd7QYWLQ8zBnbbPefO7cWmb4e52WPODiVJcSEodGroz4DJ/nPdCFsEm4gk2yGcBqWXMYRXyOMid8v00Tw0HChR4o9kgLjMuBeObGcRk0QETpSvDr22b7LAtjMC2TFUXs205+SDSE1t+olPr+AOxIjBUuCFaNGR9Rj1Q+Cl2SYae8TigcPOAasm6Wj1JSuQ+vlKOc3hbd9ZNwRcu7gJrloqifLoQ35kyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rI97Vb6s9DhUSSzm1ADe3hzx7b47eBP0gotTh6oIg38=;
 b=mNQUIkwCe6ECexyGPUqwHCJzXEJP/hjur7NY00GMGPiKIot606pshnDxt6Zwhmh+9jULl5Gd3sCJkncGW3wRZEJ1VLhA0XaeTytY2cf7cNVvErLsqNBjK/dTqMjaRq6FJOIfERMePIF0U6Gz/8GsgsoCqsN+0gopA7WMSvF40nj0nZZwvsBC84dELIZRvTwHgk2WZGveh4VSS5Bvvs5bP4IpV5YEsMKXPYNpFAMOaHCQTrFiMAfnJ2GP180crmLBxnp8mE4r2MH6dySdipwS6dsoZPBZNAAomOR2Hpdie4b/fWajHiEVWbeXGRIMhnMrVsXwvA9EkKGOivxO8SfmOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8739.namprd12.prod.outlook.com (2603:10b6:a03:549::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Fri, 18 Jul
 2025 17:49:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 17:49:22 +0000
Date: Fri, 18 Jul 2025 14:49:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v2 05/16] PCI: Add pci_reachable_set()
Message-ID: <20250718174921.GA2393667@nvidia.com>
References: <5-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <3bf0f555-535d-4e47-8ff1-f31b561a188c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bf0f555-535d-4e47-8ff1-f31b561a188c@redhat.com>
X-ClientProxiedBy: BL1P223CA0026.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8739:EE_
X-MS-Office365-Filtering-Correlation-Id: 6400afee-d956-46ca-8d20-08ddc6236dd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sSFVejx7iTE6unVIQL6n02TX/+o/a8t5xHJadV8eqvEOx+3F35gg3oXq9x6K?=
 =?us-ascii?Q?eVxZzZe9YBN2UQLExSm4bgiZesMiliYMTwCOmKfs2nOzsUeAk13kkSlLnsvA?=
 =?us-ascii?Q?sIBY8/JKdbbkpUE4/KFTNfUksBZB/4i/WqMUD6tfkdj6FYd1Pz8u6kLQuayD?=
 =?us-ascii?Q?mqY9cn+xHg9yztuN/z8/GsCTGQ1klqrlLVqOJ2Uq4CN6+8jCttoCzsZ+V67U?=
 =?us-ascii?Q?l/kGJ7c+rI+CSF4SBZmG0e98GJR4xp7w51HBCUjvhT6R7Btl+H0i06a9v2WQ?=
 =?us-ascii?Q?NrbaKcSn5ZtJLLN3xfE305nHq+HQ/6o4cYFyWVjC5sVlgICeX0vrvWnSEx/V?=
 =?us-ascii?Q?37OSeOQv16GzKNVclN1S+6aA+dcYtoV+1PJ1dcMVVpsHG41MXXaravWyIoP8?=
 =?us-ascii?Q?e8IRwGV3GurPLqXHl2oq0W3rZhq78Ju1vWvJzeztOiqhP/zmFQozCiaeD25e?=
 =?us-ascii?Q?gt531/Pp3MszyUnUIWPxHawVxuWX9QdDv/uByULQxIE2tMctkHitvL6ZIWWy?=
 =?us-ascii?Q?kdhFehUDpX0NPPVh8DMqwDv91LxOf4NarK9nMkLjKvITQzqLGhGs8/Ev2JAO?=
 =?us-ascii?Q?D1efv1C/xjnkcno3ORuNZ2qvpkqY5sX84wjN45JfIka3oPWtwjKOwKypVBCB?=
 =?us-ascii?Q?Rv/n7P/WNBFulB5/cMbc9ekr1v3UDA5z3WTMXXAYAvfBJwu3KNbTiwCAUf2f?=
 =?us-ascii?Q?Ne4x19PaZGjKy7Ba0dWnexcxC/sxJPVwnGVP/Iu7KJH/Vb0gEm/trXb1TPfc?=
 =?us-ascii?Q?chUVmuWIBg/blMI9KwFo/jEZxdIPbe899Nin8PUIwWFkRBokhC+4W84Mp33a?=
 =?us-ascii?Q?dCLELVjOp9XbMMONB4WhX4sSCaXcE1mislwLDFJK6U3lDv+DAvrD4Cj9RSxX?=
 =?us-ascii?Q?AjIILfhGB0gK3A6/Xqv2hOXKIzgSx57GZ5bowNNx7bRU8tG7af1wGPlMzYmr?=
 =?us-ascii?Q?05p794jqOTwNEiUA72hOt3mI9z36zpjc+esBRlvZ9ufubTnpWPLjJu6ONqu0?=
 =?us-ascii?Q?D/PxMIpZXa0YUobvjg0wp2wFTq2EkfrSBEuEj8NHK9nkSg9boVOaueZG1+ke?=
 =?us-ascii?Q?c4JGBqCWuMGi/2m9nKhVHK+PlSOpvsP/u8d0I8zyjdPxDmPdliK7U+2IZfTF?=
 =?us-ascii?Q?vWukRCupw2uurohiDj8Odd4CKMHz4OO1amwWnHmxlTwy/jzfOylkXUbxeT1i?=
 =?us-ascii?Q?s+p/8JzvXMogs0akj+wIgAMw7wG27gby/G74p+5Q+wIO2TQFHcRSI659MCUZ?=
 =?us-ascii?Q?A+RWhd5YmR7KTURAPnGGtF0x45G+6mLnn4enfrrZKZYNMWKVL6dOxZR+Tft3?=
 =?us-ascii?Q?GX+TO/bFgV00ZEd10Mz7ESC2mI6DlXXEWyUb017dBwDxTVRhlNExVxxVtURL?=
 =?us-ascii?Q?NYWvU/n943ejjebsHbYidvTdiNpxWDpzUvudIy1J8t3bRblX7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E5KLxrUsrutcEWeJ+/LsHxG/RnbJLP0j99ANxMUK4Du1LEtZmWE2UFE0m/WY?=
 =?us-ascii?Q?cVL4NSCYFE8tr3sh1TIC+QbI4Fk9RKvDmNPDCwckeb4L9jRxPL1/Kr+irQ14?=
 =?us-ascii?Q?TIUDdEX6f6tIpifNgjGT6m/VUZ47DhNxgdicqVe9FF2I0zNbSZ982WEzVpqe?=
 =?us-ascii?Q?w2f6LHbiGc+sgkeLJ6yOEUOPBKUX10OOkcHf0XMrtB2j8W/D3HI4zz09N4bY?=
 =?us-ascii?Q?1/4IvDxRFg5gkWv48ryqHj/ZWdGSWPpLsKOclDNdKJxqUtFmbA7cePAXXkdD?=
 =?us-ascii?Q?H4g/6TpN8hWCy2/opBvxYR/uyu+M1Oe9MAc+Ft16CX0BfzgeNxXps35VbHiz?=
 =?us-ascii?Q?1xerpwmAMP96NFmy3hCFG1fIk8fqX3/16RDuE29nJLRPPt932ctwMO4iA9yv?=
 =?us-ascii?Q?Gkk036KVD2vrA1LhG4f1Hwz1rEUEzTVxciZzGGobuYNWHPbW3GJy+Hjh/3yt?=
 =?us-ascii?Q?hoEEkmYUlyCUta3e8VWgsUTVX+3jKDJPqH/7Z7RRmorIeJUaIkszfjcKNLBg?=
 =?us-ascii?Q?l6/Wy+nrsDfoaWxLEg5syl3xnh05hIX4q0/1ZKy9ue+u6zxdJBsB2KH8HG3B?=
 =?us-ascii?Q?9fGq/MdHM76h6O+GTHmeX+zxYnHWa3h7JVmoi4wMhb4Eg3pLNej8+tYxP8p+?=
 =?us-ascii?Q?Qr9E6tKifcNN6nrgfcr6FeEDS9PPXNG/T7B/LyqAPhQ7LUCT4cuh3slCqqnF?=
 =?us-ascii?Q?eEWrx5BakLtZRXYm4lgpVSD9nLBsqrEDdb/0O15HxRQAv8+05HxAxgJxr/zz?=
 =?us-ascii?Q?Y/EJ9Pvi6EKTnKul8VOj8aUxSGmHE25gbAzw1p2Q+n1dFouejlGHy3c/CUHB?=
 =?us-ascii?Q?w1LIH7YA28oQVE+imFqmye0/FQdyAWESI4mAKlvh+RTojtW1wjIdCa2+kBFJ?=
 =?us-ascii?Q?sy9ToDw1n7SadpcfU2JFpJHvEKsF6AjAybkqg/faz4FBC908jwW0e+xUIWPd?=
 =?us-ascii?Q?PiZqR2+P7jhLq2fwy+c6qoaY+f3y7URcF+gxYaXjuwKh6Yi4KQeP3P/TPfsl?=
 =?us-ascii?Q?eZmu0meALv4DUeeefmEx4HknmSLTPOGntuegUGKjICK5mZFpryd3+OrVZm7s?=
 =?us-ascii?Q?peVObtzqGo/1CyXiVQ9G4JMXTTwRXKVvaCcIHpAF/fbk2i+AS9rV3y4JHPIp?=
 =?us-ascii?Q?XTiqhG87pbAIGn4GQ81N6nFTgIpIPrtRRd3kIaZUPT9RDLnAqfxX6VUTGSiD?=
 =?us-ascii?Q?s/6pva2NQr4gPqze/61Go2rmUkDDmHSwULB9uCkKT2cFtcofQOKGyzvTMHzL?=
 =?us-ascii?Q?ZLh4fq2xrK31E//9Gr6TxuZLgh80YYzmWX4jMR4a48IRSw5javUqansfhwsM?=
 =?us-ascii?Q?t0FHTfFKWOIGTPBF+/uU4Zd/0MdhwVoTgDA+ecyiYnVqHwox4szARszOmsOw?=
 =?us-ascii?Q?LIQMdCd+im9JX3GkAXXP+CcbPCChIvFgybTCv7xMM0+5w2tUk6yfvuRLCQPu?=
 =?us-ascii?Q?iOicUqbvzrPp+7iXbxzBFhm8vc88uyjd8sy/+KxTjJu5eaa4+btSOlxvWGtp?=
 =?us-ascii?Q?lt/TMt1QHrasiBZwz2GGw5sUBTf7Wshv+P3hWCtzbtggsYav1UwfZIxs1O3x?=
 =?us-ascii?Q?b7y+H0gNthVz2oXi/VOOsIGWRvP4q7/B+1XoJnIN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6400afee-d956-46ca-8d20-08ddc6236dd2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 17:49:22.7207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ld3t8Ia+vevaVgV2/9t0MKfsOGjcB8psYItYlUZEST+YPpBzceqUSxNDqibzDLrV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8739

On Thu, Jul 17, 2025 at 06:04:04PM -0400, Donald Dutile wrote:
> > Implement pci_reachable_set() to efficiently compute a set of devices on
> > the same bus that are "reachable" from a starting device. The meaning of
> > reachability is defined by the caller through a callback function.
> > 
> This comment made me review get_pci_alias_group(), which states in its description:
> * Look for aliases to or from the given device for existing groups. DMA
>  * aliases are only supported on the same bus, therefore the search
>  * space is quite small
> 
> So why does it do the for loop:
>   for_each_pci_dev(tmp) {
> 
> vs getting the pdev->bus->devices -- list of devices on that bus, and only
> scan that smaller list, vs all pci devices on the system?

Because it can't access the required lock pci_bus_sem to use that
list.

The lock is only available within the PCI core itself which is why I
moved a few functions over there so they can use the lock.

> Could we move this to just before patch 11 where it is used?

Yes

> or could this be used to improve get_pci_alias_group() and get_pci_function_alias_group() ?

IMHO it is not really worth the churn

Jason

