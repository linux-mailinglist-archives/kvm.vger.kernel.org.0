Return-Path: <kvm+bounces-36359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D6CA1A510
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD4F03A20F9
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA6A20F99D;
	Thu, 23 Jan 2025 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jXdZSiuK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8103A320B;
	Thu, 23 Jan 2025 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737639198; cv=fail; b=P7Jup5Hm7tsnKvfavoOdBGfV5tcb1f/sx7iSJwr+c2gmyRsdnECfW9efwhnzaJaVX/sIgh4qHusPYGVr62vc8cjszdnuvIK3UsBPWsKSsECveWzURrfaiWQC/Xcwo1ZHlG4YzTnnueLghdtIGkqkHLXlA8Xvsb8cAN+BBHerTH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737639198; c=relaxed/simple;
	bh=Y+2Db0XV5gLcnO0pROGL8mPasKNMJybEELnBGrd0qc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vGOItmw5ANaWe6LzENzZWatP7NRT5EfcBaaSlFp7iOJ+FNqJWtVejPjBuHjYR31qZrA2oDChKqEhe3ugiGcKVh6MMwu5p1jhnZY/qFs10i8t/B3ZPSDXu7RMXmpzktFokmXsQkZjjuXqkcARNXVFt0PUBxAdNXR58BzSTl0Z+4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jXdZSiuK; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4r6TmN+oF0ohWVQtVY6k2N0qBNHdwxo5P0HH1alBz6rpWZ276ZFLi7Fmi1+DCKlbBdpTMb3kEavlZF8QqBnOUcP1j97o/RpvYKwTUmd2oamGCmg90ePd11xf85dOesgaNb/jUw4k2A9TTR13galJoZXTc+z0U2jhvVwpNGi31QG3QkLsO/EjexE3cP8Ek3KE6xfNDQeCU/6X37b4amJf/uHRt5QY6gRspfVqpvPV1yKA9ojLFkK2u/MjYpj8wp8+xBfoz5NPtAUATu5FLRzYRtDR+ovLCnmK2z7F1AIKRREstHz+9EuVlHjBWxnJQ5zIZWbjVNIlxj4tfsRE7u55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpG08yhJ6F/H67hCl+67hFss2+HGnS8U5DesU854KCQ=;
 b=x4t3CkmD92gmFf1IXPJYHmElW6psI8Z/3nz4YWD0R+6xYL5aMSbk3/pocaaoZ9v6WzkkL8YN68VCi7uM5hm+7n6hufIepSueSn/fmMXzIuUzChL9/aAn0ln5RBBz+htwrJpLrbafn3rrAdODWBNUhCP19r8iHWKH4uQw/hbTexenDDqb6o3vprUasm0lZImkkeccN2z5OTvRSpRZUKf+6zV/cvlXMFtC9BUrHbM9mAE7RnrnVMyhqL4CpMil+0sVenKy0Wl6OMnzEtAsuZcoqRZFoUohm/KKaljV6FpanNjwCaa3XjIJkuF8SnfToC+qqwfwAWMAWZCQ7k2JtqP4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpG08yhJ6F/H67hCl+67hFss2+HGnS8U5DesU854KCQ=;
 b=jXdZSiuKJa5FGBsr9JLt4HQvBuazwR6dvQmfFVg4ouoCFN2M/n6JARerEAd1Egyw45G4h3y2IGl/0qtysKmsOqisXP0Xwr+Cv90uP0g+Bv2j0zxoN+uAtGH+3E2G6PMwd52BLwEDTHxZhGfELD3RC9TJLPhJSjh/he8vdADSJ23+mtXiDiQzGL3DzHZ1KXoVExc+CZtHXXj6pxzTr/mpcTcYBQx2KX+KyCR+rIVeaOsNdcuPNWRN2AJzcJy+DLVuXmvBJSKmf4cAOrgxF0ihaqPDf6C/f9vKcEQBRRD6REiJjng9CNkRHmDv2NvM41uTl8g0Th1HItUq44FrPrnBHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7142.namprd12.prod.outlook.com (2603:10b6:303:220::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 13:33:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Thu, 23 Jan 2025
 13:33:13 +0000
Date: Thu, 23 Jan 2025 09:33:12 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nishanth Aravamudan <naravamudan@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable
Message-ID: <20250123133312.GL5556@nvidia.com>
References: <20250106215231.2104123-1-naravamudan@nvidia.com>
 <20250113204200.GZ5556@nvidia.com>
 <Z5E1alwzi4YnJFLI@6121402-lcelt>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5E1alwzi4YnJFLI@6121402-lcelt>
X-ClientProxiedBy: MN2PR20CA0037.namprd20.prod.outlook.com
 (2603:10b6:208:235::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: a96bc76b-1808-468c-9b84-08dd3bb27c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zSWcrA7l+rdUuYKP3ACNXmEKVjneE1YZPW/DEws93RWpU21qZdOQSUkFz4th?=
 =?us-ascii?Q?v3Nm4Gb7MKzbDn+U/un+SeRbgTQtWjI0MpL2bNskR6y/jQdJeeOYNDEB/Mzf?=
 =?us-ascii?Q?WjmcYOxeFxbQ8fA4kRh/XHOmfr2/BT+xehN+ON3VdGOz+AdJ+Q+0Gd6ULrbo?=
 =?us-ascii?Q?S0pIA8QALEDgP6onaZCifX30O8vbMkWWLmDTqjE6TaCwEh+6l33zWyEKtp3Y?=
 =?us-ascii?Q?hzCvHW1vU9KMhFXrL323MmopHWZIO1R29kHBy1BglVB6AMYLqaWVqhG7CXgS?=
 =?us-ascii?Q?m8aI7WTRBDkp4W+eFEwcv3VmTbIlUGlV/MN/GJixwdppZVn/yYy9x8r2ai2b?=
 =?us-ascii?Q?CuVz3mp/uewRJngQdPLCCdB9yBOA6Q4NLPmc3+ccCTBe5tob2WDsReW9CbGK?=
 =?us-ascii?Q?ZqN8Q8VY86pcr8zXhXqu5ieytfh7Vt/jmTB/jvpmzDNI8VO+hnopDyVrYTMo?=
 =?us-ascii?Q?vR+bJ909AzhmK9jtMT4dMcn9salsUp+1KqSpqA0mkt/eVLjJglhxLzsCxBOW?=
 =?us-ascii?Q?ZRjGfYQqSE+aJgGqMMP4iagPVaBFPBI/+mdqHX/ojEPFxXdOe4KASz/vPPbA?=
 =?us-ascii?Q?zDY3ViqvCT6Bp9wvLLJmfhhX5PoIvgKvhYSLGpFSwkkEPw/srgIDf8q2tCJi?=
 =?us-ascii?Q?AvVnpKqGJrME5c+p3FLkkvZcEXheWiGcRifnkKJptMgF85gANmupJlXswaaR?=
 =?us-ascii?Q?D4lk7A+ZWSO+7sQT+D5hlmg9eS08FUMkaQFzga6zWC96/Yt+8kI4VOUq1au2?=
 =?us-ascii?Q?4Xx8HI5jqcZrJMzHbF68nHNqwtfqoIJebBIOd32kqTBZAXH6+2WVkwc3bKEd?=
 =?us-ascii?Q?IsEypp03BbIgobBecDiL2siOTx8uX+XErZe10Ruhu9+1s0bz/7Q6wtE0SUMI?=
 =?us-ascii?Q?r4PktxAVASdFzQ8nRJlAC0BlaCZbx01TgKSuiWZSaDh7bLLdak90A3Hknk0e?=
 =?us-ascii?Q?NQI1EuDbraewuTUAEV6lAlE0VbUWNqmiS0m2G8lschOu3+DDBEjFq4A2SU8P?=
 =?us-ascii?Q?darYHxcHcaczqHzBl6bljqMraY1eFw/Nu0oYUgphuoCtQvCHuNhbmpLO41Tc?=
 =?us-ascii?Q?zFN69TwoRlz1kMdpxp3rxUsafUGoT6f9yLbOa5e9ZI0A9/2oRbSmEpZ9AR4S?=
 =?us-ascii?Q?Ktihp5KDYigcfdnvHKDq4kwbj9c3vBhV7AbYv/Hb/8yFZPPb+iIs/4urw9Qi?=
 =?us-ascii?Q?ofxvx/mis+EH/a5T5bboFQJvIHsAXOl4NjYlCpd7SIKwrHPVN27JIOBCo8Q7?=
 =?us-ascii?Q?e27xX3NiC/r/P02AQaZQt6drUfS0QdSoNeLvqaxJdTMf1UN64cc+B70/iuOa?=
 =?us-ascii?Q?pSWvZYZl306h49wv6eimDA4cJWfDX6aQV8TZkr+OUvbxeQbl52V93XY+Pwl1?=
 =?us-ascii?Q?kYub10ObZ8OQxHklvICePfCziOqI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T+ACDNp/tXLSJzpCSX0v5QzDJrH2hv8rCX5/xLNZeRobJG1IAs2dG7ic4dSC?=
 =?us-ascii?Q?paq1r2B2rKn8pbIeI12HGdo9AE00QF4HeznSnTxMHvgoSZZQeDCQ+sosME1R?=
 =?us-ascii?Q?yEQ8J1e90byLWfDmNb3NwkZKAjeXlvoMnT9regg2NMRltrXB1OOWmAWCMZ8h?=
 =?us-ascii?Q?M0vQFmuQXGX+tfqvhta4T91+ysh0oQiq/+fbGSZJcHvQ+AKvsZQfHEJlSVCX?=
 =?us-ascii?Q?1uByUNxM9yO2f+tec7KSyXtA6G2xt2kKsCSKgrwQszueslK8oPcS9K1Zr3Ib?=
 =?us-ascii?Q?FkBPtoomzQGDih50gPQC7Xc5bwx7mCg/Nuq/RkI755pWL9lz2M6RMTAXGYM5?=
 =?us-ascii?Q?w6yG3+Wnp6ftgvtw+ioVTq5frXI3z4ysm+r+y/d9r+n4hCC6x2RH2zXA6pRw?=
 =?us-ascii?Q?/lSp122rVSVYmCErsSb5H028xlXkWsCTWWvO1MvMDQ20ebciNd0+MG/UjQF0?=
 =?us-ascii?Q?xrQWGEppo2iM5Xe8sUbq8VmvsZMjmVQzxGihIqRvt4w36OZxU0VKgq9Q2xPN?=
 =?us-ascii?Q?6sg4HAd+1XKViV9H7qoktBNYqvpDRHpniDXtL35ZqC63FnFhK+rfmaDI0kLh?=
 =?us-ascii?Q?/paiLgja7SG87qmdIxoYASqUZxz0u7g7uexFMxbuK/C4G+BFw1v2/8Y4I2zj?=
 =?us-ascii?Q?Y+PVqFcKunHXcLo+HWo9gpT7DYuLg2vC6Re3NZZHo5AO/cRJoVZtBQJANePo?=
 =?us-ascii?Q?JPT1UwAljCenEEg9TDAO1ROGK9Pf6EPNDfmVXWwho4Fad9yZ+JjKce236/uo?=
 =?us-ascii?Q?Mjq95qaAiRJ7UDHa7nvuGom8nJ5xmerF065nI64veSGQbNEgiWE+UXyXm7OO?=
 =?us-ascii?Q?/JjAAvmz9A7J7Rhzp/GjJJuDeIQ1dD9pNDdWdJQko9i0G+062FVMyBzp+oxi?=
 =?us-ascii?Q?BhdApZLPQmjTaiq+lA13tCtM1Lq6JrtMTdsxam1iSTt9FJyebPGyawz9IOEE?=
 =?us-ascii?Q?mDnBTrM7VyfidQ4BTqvkCvSFAXJCNFX6sVNmsRC+I0nzLn71tc9AlejIxT9U?=
 =?us-ascii?Q?lP5V8D5x4oP2p1jviNcmXVkOHy5B/oErapkK8/aQcE6qXTCw+EI9hn6S/w3G?=
 =?us-ascii?Q?Osoi4833idUHtHF5NKI+7lBA8Jfcq4nB3/JdTSw5GRKW5S562JvJHkfB03sT?=
 =?us-ascii?Q?oKUk0zSMvFtwE0VFwR5W1lDcvCoXaPMSABcTY7Tvg2fa7tLQTVO5R4lqbdoO?=
 =?us-ascii?Q?kl7a6dLVl5Z61AM5jqlyKGyoMaEm86c+NFBboCjVTSnRR/Pvp768wFSTKVrX?=
 =?us-ascii?Q?R5wATA3XXWUEpE7q0bdB9n4y2G8m/83KU3Km/TOXmRBXgzGI4nA47aNdnfun?=
 =?us-ascii?Q?8C1/lTkpwyPu2uPOWiKpSNmL3V4FmeO2C3G7sQHIEwSVz28u/rUGdP3qyrXr?=
 =?us-ascii?Q?1/XTWPl7Nnuj0F0x0tUZQ7wBI5n559ysU5Y6l5vtHSQtmYzCfONM5cDqM61B?=
 =?us-ascii?Q?hz/sBt1J1g0/mD0In891D1sr4ewrWxpd9pXPEVGuM+qxQkEkqQOObfRwvBdG?=
 =?us-ascii?Q?WKkdzjXl070B/+2d6tW4J4Wh+3H0sPsRBQRUoSBaRfOQCcHfDJ5hZpSZY52U?=
 =?us-ascii?Q?4z7PUV8xDmJCOybnlxs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96bc76b-1808-468c-9b84-08dd3bb27c53
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 13:33:13.4932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WRbOTWgjF6Foq75vYkjWBRktg/rburOrsETnIZAgLOgGuPLr0hLJv5ZU1DL1ydO/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7142

On Wed, Jan 22, 2025 at 12:14:02PM -0600, Nishanth Aravamudan wrote:
> On Mon, Jan 13, 2025 at 04:42:00PM -0400, Jason Gunthorpe wrote:
> > On Mon, Jan 06, 2025 at 03:52:31PM -0600, Nishanth Aravamudan wrote:
> > > vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
> > > or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
> > > functions in turn call pci_{slot,bus}_resettable() to see if the PCI
> > > device supports reset.
> > 
> > This change makes sense to me, but..
> > 
> > > However, commit d88f521da3ef ("PCI: Allow userspace to query and set
> > > device reset mechanism") added support for userspace to disable reset of
> > > specific PCI devices (by echo'ing "" into reset_method) and
> > > pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
> > > see if userspace has disabled reset. Therefore, if an administrator
> > > disables PCI reset of a specific device, but then uses vfio-pci with
> > > that device (e.g. with qemu), vfio-pci will happily end up issuing a
> > > reset to that device.
> > 
> > How does vfio-pci endup issuing a reset? It looked like all the paths
> > are blocked in the pci core with pci_reset_supported()? Is there also
> > a path that vfio is calling that is missing a pci_reset_supported()
> > check? If yes that should probably be fixed in another patch.
> 
> This is the path I observed:

You didn't answer the question, I didn't ask about pci_probe_*() I
asked why doesn't pci_reset_supported() directly block the actual
reset?

Should we be adding:

@@ -5919,6 +5919,9 @@ int __pci_reset_bus(struct pci_bus *bus)
  */
 int pci_reset_bus(struct pci_dev *pdev)
 {
+       if (!pci_reset_supported(pdev))
+               return -EOPNOTSUPP;
+
        return (!pci_probe_reset_slot(pdev->slot)) ?
            __pci_reset_slot(pdev->slot) : __pci_reset_bus(pdev->bus);

And maybe more?

Jason

