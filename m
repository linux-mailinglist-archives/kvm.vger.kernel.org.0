Return-Path: <kvm+bounces-52922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C91B0A9D7
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DD90AA4F09
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5BF2E7BD9;
	Fri, 18 Jul 2025 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qJWygoZg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0C71EA7C4;
	Fri, 18 Jul 2025 17:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752861160; cv=fail; b=TFOF8MinSjNdUHBvaXRykCZ+SDLJ2MXQklWRHv3B/7MTw3gSWIVLs3GNsbU0ohrTU8c6+CqfT2aUhLzPWiq0FdtiZxuPEJZ9UEZMlwNJk8TW3T06vYM49wdHwB/3wKKghR3T9YF51CNBMw8J2FWONN0EYWY7rk5Y/3UbFtH/95Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752861160; c=relaxed/simple;
	bh=8/UuP8hx5pU8lVVp/eBNjj3ufnXYsjkKAylJXOzQwLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HHbB9qaADGeMZ38oEsC+DcBV7YRYmKeIh6xT+4ozf8yXD7gkoEncQerdLm6ZlqaczKCOHrtOQgAh9awJjijai2OeSSEwAZj6ENezlT0JAoOdZnIyNUA75snBb8UJV8yyYbZQb11ZAydQd/fc24u+IxYv03I1VbgnRwibiF3+F5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qJWygoZg; arc=fail smtp.client-ip=40.107.95.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RI6hGpaBiPFc2TCQiZqN/qhghrx+m2+LwYksVRJiVu6HQXkUSwLZ13xTcjuwDZl49RI+hdKOGBG1VgC+JqGO1kpI3v00G0KSovqMiNNKBMlugy2gBcd0G1JDP4LUbGRpH5vWkbhN8nsttNQe3+KUAZRz0yDGo4o7ejPQWTHpY9KjAsjB24JfPdE6z296W1t9pqld8CR24TNLU0/Mb86Oq/chBHFsa6WSoQBTIK/z8sNN1sMf38eo6BuOsOVpI0mI2jNuD1pfiXzZJKBpJItHRRGY8H2pRkTKpGrkzJfR53zU2ysttSpbVzfVxEfK+hEl4RW8HKO7aEFcyZX9abXDLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfgDcHsftb/poL2u9Hs1lqHMYoxSwIu8I49lI1K7Qwo=;
 b=Q/JRqL+UitVzpBYGiq1/u3FmCbH3vA2/Hsuqk3LMNoCPrtPJf6PsqSe+f8o7wBEYDeJbAuVcSOwbvw7f71xLOGaIPNWxp90S+RMtxy2u2BbBMGIstwysNT2RbQGeUeYqamKq9AO36JBwNos8jXgbvg8SBlR0yN7MR/ZGIgjQOkUZbMO12kYjf4DOanJPPoS12Mlgldp+4TLJ/x6t6I8tL7jElQKlqNCgLNKuoYBraKO6zdJJvoy1U7vIf/vMGtLQQwg0fyEf5B6DlETsas2Ev5rQPyuViDSkB6jQCroi7z5oNGmB9iWeov7ZrGXKUtKI1746glIdm5yWxKKAMD37LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfgDcHsftb/poL2u9Hs1lqHMYoxSwIu8I49lI1K7Qwo=;
 b=qJWygoZgfmxuXifqqPbN4+2Gi8IvEI7L5T5f0zVlr8eFifJfvb7NBV9GbX1h/vu1hPdEeDzysWDBg8HL0yN2X5RpZu0TH9xuaTx4oeqUMOX4VyZmAQi9DeOViT2OturiYTvC02elY+Uh5qfHkwWDo9ZmqjSZggL8hOStClRWez0+vZ95aB+Kke5lrLWbX7BP+22Yzfcq4uIOj6Ml17nl4jDGSBG8Uy4h/hY/NUxCAPZhWytAFDamkz5MAlv8EEJV8DtU8NZjgeDIUmVu7O7QY8VWQv7vd8lTJqZyZlj1MJ7Heu/ICsHVZd1N2Fzo7CdiV8Nu75pwSGoGUI0mRXw3hA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8739.namprd12.prod.outlook.com (2603:10b6:a03:549::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Fri, 18 Jul
 2025 17:52:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Fri, 18 Jul 2025
 17:52:34 +0000
Date: Fri, 18 Jul 2025 14:52:32 -0300
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
Subject: Re: [PATCH v2 15/16] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
Message-ID: <20250718175232.GA2394663@nvidia.com>
References: <15-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <aa84cbc8-6d7e-4e70-887d-b103f2e01a77@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa84cbc8-6d7e-4e70-887d-b103f2e01a77@redhat.com>
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8739:EE_
X-MS-Office365-Filtering-Correlation-Id: f820a1cf-dfd1-4ae8-128c-08ddc623e038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lxBe20vRS6p3g3HpV7lPQrarOQ2QDfi52zpN5qnvCEO5Iscm8HtLdAaTNwAw?=
 =?us-ascii?Q?yMhbFnf+IoVZcUp51GnKAvivg+kwghEghQfrbaoL9BYrc+tKmFmwLegXiXgF?=
 =?us-ascii?Q?oQpfKmCVqy21Y87+wzpeKZlJId4W+TalFbKcyxYygO9fq+SQWiwlfx6BpOEQ?=
 =?us-ascii?Q?WdRUOoPwVcJmu8qS/7RZt9A9NfaVGBR6OjbEKrSDE09Yme8Mlrwdn29jpEYw?=
 =?us-ascii?Q?9DOMUr0gXLFWttJkDjrR0/ka1h7+I0g/smT3SO258iuT3f+0VbHMy4BCc6c6?=
 =?us-ascii?Q?pD0JOfis+7rxUhFbPEz7qWSA1tQGCg9hwJoErzlzyQYOqP2ohH9Ch/OndwaS?=
 =?us-ascii?Q?eBlN/lVHz60qj1Tr9fdD/Fqsf1qzihVAJCTQKba019oU88UA/sgA7CnAFQ9z?=
 =?us-ascii?Q?5zqSbhRG0+dwcC0Vgu6o0C1i/FNyHpJIbgl7GnodyfmEhxEe7iCC5AK1kJA/?=
 =?us-ascii?Q?wGXx8CXTdsyWaxbOrrN/6NVrU6n2V74EOYMFJmnguIG4qpcyx6BSiyQKeC2I?=
 =?us-ascii?Q?S94KZ8mEiUTN8EYWC0R9miefqvrOJSoWAWDWzpx+1ymdQSTpTXefGoyeA+PI?=
 =?us-ascii?Q?tbBbP2oflwCQCnAbBwvwSyRNLcNayhF2c8/mj6HcXs6n4IyDZrAAUuvOOq69?=
 =?us-ascii?Q?izRE6+a35rJKUrAu4EVNfiyMGUsmAxyZLWZajAlCyhxxzzx0M+NSGyfieuRL?=
 =?us-ascii?Q?ZfhWlMnhkDAON+lpclNOwIcXl7PzcNN9z/0BxLND827YcVWvrTJKk0fkrpTY?=
 =?us-ascii?Q?pMW8CLUHRRCSdAcrOYWxjGzmF2n+un+pZHPDb13kjnpjX3/ov0eVs3Mwgils?=
 =?us-ascii?Q?AZlfWwThdx/zwpaPatemeZ9TaxgaovEKJAkP1BP6mtzWJx2iXSUuvAmfHOyB?=
 =?us-ascii?Q?p35/fH/H7QOoLLjqt0H7ed6P4ZUSr510f8nLF3ggUL6i037R+WJ+1mZI+JG2?=
 =?us-ascii?Q?3Um+e70CDwEZ0GyFvWKjtahEp4LW5Fz91AGtYHvDWuSjn7jCV/ZBrdkYLJPv?=
 =?us-ascii?Q?hdRi7ozzgLpwAs3Pg4yD7mXI8CGbY+Ejr6A3/g65tiqNVnSeUGAcXdmBqNH1?=
 =?us-ascii?Q?O2kmHnOSUPXwcjDfKe2hZcf2cAG7P0/AMH4LQAQVsgEz4FxiORd9jWd3CrB9?=
 =?us-ascii?Q?4iwtYgx6JhP1r13fqefsEoI18XttPREjlLYsw8s/mRfeBrJX/dJRsXH3epKe?=
 =?us-ascii?Q?hanVrGS3UjDHPajYmAD4oNNthJdxbwrrBlc+QlctLrZYsWrGNVwL9VizyJZz?=
 =?us-ascii?Q?UHt9o1D7l8DbliIyZNL3gifJttXmXWkmQxNWAsKY5eF8KKzcwPshHDjmBCSF?=
 =?us-ascii?Q?OUvlOUVze+hGqEFMx9QQoowXz/MWjckECd5XlpcxHCvKxhEhcUeWKeBib/Zy?=
 =?us-ascii?Q?9WkX7+2BASu70nyRCIiQm67RjhlGJfX6sfk1M0tlEhY/7LHXY6Z+GXtoOj+C?=
 =?us-ascii?Q?4UwX5D45f3A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wiUu87JSQdXLu2uDCORH2XqLhhJ0ujkoDlnp4BmDfXRGvVg7rOpi9lPWcsi+?=
 =?us-ascii?Q?Ri7QxfCi494HJM3u/F2sKp4TJiU9vnswGhFxacw2xaM6G+CZE3b9SWJwihME?=
 =?us-ascii?Q?JKQiopQlC+XGpxX19QVS1DCizw/sH8p+BrIwl5RCGz7lDkjBpOEBG1C7nmKU?=
 =?us-ascii?Q?lWb0tSW3lJ5MmrD40mdsYfjXvnuripWoZjp43wfDgiYil4sfDc5o7my7HAxk?=
 =?us-ascii?Q?+M5jvm2q07pl6KSyaFknax/1Tf4sC9rCbg0GbUFH9dP+jlw3MC0gUIZWyIZw?=
 =?us-ascii?Q?9mKkBeCOiRhxQkO00IC3lLZ0jiL+segdKtkyo+RMC/T0KV8LzLyW81RgN8KC?=
 =?us-ascii?Q?2CIsbN18RBN+nRC89u9zXggRPyu+baw0MK6JljP6Btn6qi58N+grpDbjU5qh?=
 =?us-ascii?Q?zSCzdYpLI7z/6Ke42ZqJnXQnoOK3OR9gTqvgXK0C5gEQSf0SS7II5FOdqzo1?=
 =?us-ascii?Q?fS3E0lEucQyhKL0JbycuaTvBQnQfqtPXjM3G9NCy8iYXv6dd5GYUqI5tDuCv?=
 =?us-ascii?Q?A+gKxq7zYJBooNEfYFJTwb9zhIjR4Sod+D3BqLnPDjODiEchYt4e7pvdPcqB?=
 =?us-ascii?Q?YlaLEXCHXXHb5RQpKL++N4dezsQrfE+N5JSJHl1yi39K55KPFUyn3A3EBQBx?=
 =?us-ascii?Q?ayAnlQ3jhy4/NqY4n6Gs/XJCX+pkBLmIwRSn1sP1XtlpAD96OcVYh1KBxaaY?=
 =?us-ascii?Q?PP2cVMFcQYgI8QobEax7QQe2dvIzi3Q6MbdD9jEdwRUmtGrxJBiJeXYdLfbJ?=
 =?us-ascii?Q?bHozrwZVNHOI4qVe1tTN8wVB378SWy/Ycw36CehJkheqM8fs9QAYViAnrgXd?=
 =?us-ascii?Q?2QI8rBRA3I9Ns9/L5IJqhevqTaTmGk2V5Cd5tTCG1MsA+v0ggByHdtd/F2Mq?=
 =?us-ascii?Q?qOOW4MRYGUZ1QoLr0r0OW3jY4y0F83Avr/ytwqf0r0byrVkVb2G3XsHpQ8eA?=
 =?us-ascii?Q?/3LIzUi0fDkDC5w4ef26rETp4BPkJYMYXQknikp7vGlL8yhGGe5hoYStGOuB?=
 =?us-ascii?Q?7gRLbRkYXWj7gXQYptEYWaiEo2bTq86P4AlOpiDGfd8YZL6t+FVNqrKwksdQ?=
 =?us-ascii?Q?dUC9v7qo9clvFcjUJGeydIOOc0KUV279RlxlhZnwzw4DiiEweYL8fw0arPlq?=
 =?us-ascii?Q?MdlnFmwipRVguMsvVqpcO4mzBMvfa1LN2+N6DsQynI3AKZWzUFwkNrhREIZ0?=
 =?us-ascii?Q?8jAdzFXaA4SVf9w8oF8+8vkNb7yH+HXJOTc+kr+b2s8pQYYNbEvZ8FI1KzW2?=
 =?us-ascii?Q?/PvZ5ZOa6vf4zT+5irgFb7sP284b/uiK74uu1uEEUYDqBofai9wUVL/Az4tp?=
 =?us-ascii?Q?y75hSCZ5jIEE5Syzr21onuDWZqdhiJJUQMN0SxT++WpDYKOan90rnOVJFibS?=
 =?us-ascii?Q?gOwx9MB5jHrDCsZTilGMCXv0iAEl5b+GcjSf36lrrkzvRLmw/L43uY8Q866G?=
 =?us-ascii?Q?Hcia3Soq9r0rZShJpDmwPb8oXomdxtsj7yrFcV4k6TpUSM/2ZGT63hxFqzcR?=
 =?us-ascii?Q?YVz1Sr493+uIARJ7L1Iac/phL3m0HO1YA9nsDQl2K304ldT7F16FFvlX92d8?=
 =?us-ascii?Q?cvvjzs96XNBrSVMzIovLjubqOKfb2hJIb+ji6mxm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f820a1cf-dfd1-4ae8-128c-08ddc623e038
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 17:52:34.6564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1gL+6JYP9/Aage3RFuq6AZZsHut9GQqOzkaRl0sJykH21DlOYT8M+IYZEKuwgZXE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8739

On Thu, Jul 17, 2025 at 06:17:11PM -0400, Donald Dutile wrote:
> 
> 
> On 7/9/25 10:52 AM, Jason Gunthorpe wrote:
> > Switches ignore the PASID when routing TLPs. This means the path from the
> > PASID issuing end point to the IOMMU must be direct with no possibility
> > for another device to claim the addresses.
> > 
> > This is done using ACS flags and pci_enable_pasid() checks for this.
> 
> So a PASID device is a MFD, and it has ACS caps & bits to check?

Not a MFD, but the MFD loopback would follow the same rules for
routing PASID TLPs. For a MFD none of the switch specific ACS
Enhanced flags would make sense:

> >   PCI_ACS_DSP_MT_RR: Prevents Downstream Port BAR's from claiming upstream
> >                      flowing transactions
> > 
> >   PCI_ACS_USP_MT_RR: Prevents Upstream Port BAR's from claiming upstream
> >                      flowing transactions
> > 
> >   PCI_ACS_UNCLAIMED_RR: Prevents a hole in the USP bridge window compared
> >                         to all the DSP bridge windows from generating a
> >                         error.

Jason

