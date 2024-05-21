Return-Path: <kvm+bounces-17859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7414B8CB39A
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 20:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BE86281D85
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B200148FF2;
	Tue, 21 May 2024 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WK1u2T4d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB74148317;
	Tue, 21 May 2024 18:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716316673; cv=fail; b=gN5AHvzThMKmb5mvOa6zJWnsuHjIxR4P7opV8qxe6OWD5y8FkqKQ8HIA1lEd6JfSEM8R/xw62Z/otzhv18wfF956w/FpvhnMrY1SJyRGtl6aeOadpT+GTyLJnw1qGQAPcvoQU78BkRKLY6CkFQcrM7IrtympxY3L8yPbE8OiAZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716316673; c=relaxed/simple;
	bh=lZM1oowUOxsbGlvv3UbmXUTY3ZMmN9mkQt8XQYBwO7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CjmgASa03PCQFhOvZA62rLfAgiG4Umo11D2/CviIeSHVAaWftkIf6uE3L3CUHLJ3vnc6x6ZryK59kAWrji6A3tm/JmRx+2TW2zHL4VpzB2oFL5n6RstBEERSTHRY14JUSlmBhOkfcxlv/+bCHyDcBOWPSDEDsifM8VL2TDao4ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WK1u2T4d; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEjuRZu6eAIu0YXDPPb6koxqWJAGmhBhr509UUTJHfdzb3v49E660woCJQb4Mrf91nJt5U7XZQNA38eUDPJetJMpraXGhNyhZuw8ITnXFVSfesDBXTEW1ZNyvf2NyfQCIJdrU7aKO05dWEKQTN0jpmOssg4B/IdvK6xeQIDgHP5rJsn9wWQro5YmEN+fvwJ2D6gjGKBrTVHGPOb4CSlxKhNlD0WmRZhnHMcM17OmxV5X7j2W2naQcM/HAPi3npWCGKqHkFPI4XbF6kTD7EVSMY0cMEKM+c7zKiLsBPo3Crl5SXkrcFwI7Yiw4sPI3EPeylfn7iVkfdEkZi0wnovYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3YdUoRpaN2pxEMho0Y9IwcFgSiYSHJO0yLYJYjLwwg=;
 b=UTwSbn3UKouezR61Bn8VSoimznAMia894tEdfArqbImcmYAMnva0WVhB0UQMSrioRoM1t06rwgO1rVbeiW+GMZcAAPZs/Zr3UFvZRgYYt5z78HpipVVODLn+z2F8QEoWb6CzyAVVjsoXCqa/DYXxUneoB4mk0OPr4Oo3cCSG8pAe7iGLZLXZJ2deVq9U5Jvi2/CKImPJs55/toQWYOlGJqssTvHnTgDlSJWz33jTMUU1m22MGsFcHO2Qs+9VZF/RZH+2Joqg5OsLutLckE1i2lIxUuspNiSyey9vVcWcCIudn0+hQ4PIupDOeQiZdcIc1sjDxTaMrYoVWEmuDt0xTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3YdUoRpaN2pxEMho0Y9IwcFgSiYSHJO0yLYJYjLwwg=;
 b=WK1u2T4dbRwBjcVZi6jIRrYVLP0mmtn0BN0admYChrvssPj0yN/yXZNgvz1C+P6SUisP4FTMg0ghh/IE5YLvfEG1iHuk5um8YcndQ4uAyJ0iAoxFMrGTfTnNE78Zo4Q4XPgy/d+d9CtsgRc7DkT6VljoW70C6tSygWOpKZ2A9LTX9h14baUlMw29id4j6aOV6T1Qe7vGBWrH/NuqTMfCzaXb6/+lg5L1NMN+SOKN1hvT9bl0+d5HnOySIxk1P9nUbayrfX/RZIsPZJ3RfWXbcZ8+sEnRKFHW7IY6zqPzTCmqsvjnkOmw2DIQuKb1SwKHO3OEZSwSSZlWFFHizYCkKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17)
 by DM4PR12MB9071.namprd12.prod.outlook.com (2603:10b6:8:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 18:37:48 +0000
Received: from BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::efc8:672:884:fafe]) by BY5PR12MB3843.namprd12.prod.outlook.com
 ([fe80::efc8:672:884:fafe%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 18:37:48 +0000
Date: Tue, 21 May 2024 15:37:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240521183745.GP20229@nvidia.com>
References: <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521121945.7f144230.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:23a::29) To BY5PR12MB3843.namprd12.prod.outlook.com
 (2603:10b6:a03:1a4::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3843:EE_|DM4PR12MB9071:EE_
X-MS-Office365-Filtering-Correlation-Id: 110841c2-36f4-48e2-55f5-08dc79c51d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2N+PMxbbWM/oM0np7x7XbiWCEP2wsMpttIsEzTrOJtnuioFJpoJew/uHDZ4o?=
 =?us-ascii?Q?zgw+5Ui/9Y0eZhvwCibLb0SBU1yKf9igE1nb9pXMiUWE4wOb95oawB3PWbXb?=
 =?us-ascii?Q?2IleRXbupfgAMTAj1FZdjN8PmCjJfzAl1DWGyqKyFhdMGRo3zfTKrpU82Fos?=
 =?us-ascii?Q?LeZmNFoOREf9ZQ9fRAlo72inkjBqOnylVt8F9lYBXXcynwMu9LJzX3s51b95?=
 =?us-ascii?Q?WWGpUBEQy+XF27KrUo2AiFn/I1qORCdsmltb6x1hTim/LzKlxxILmfrw8r06?=
 =?us-ascii?Q?OEC3oON5w4TutBKrOM1s6fLzPZdH5FVlie6ut/hiDX9ZXMM4pHcRaJboAl4y?=
 =?us-ascii?Q?d8yDQ+H4+VB8jjuW9knamZs35IjVP5wKB45isiGk4qqgset2QFY/OEJJoXGD?=
 =?us-ascii?Q?aoOMBmj9iHPmIIqwA7kXavvt+aZdNMSa0OxCa2clLc6SIEdyUy7Jr7mNqkt5?=
 =?us-ascii?Q?9uKgBoIal/JqhQGtCFmiG4LgKMp16j9GBsvuch1F2ENoMceVmV6DUSh+Lysj?=
 =?us-ascii?Q?e+85E/23wNl49ZOfqIHLGPBHa6hImy5XR1ZY8AapnsshIDys+EFWFwpQAPdy?=
 =?us-ascii?Q?zDuFrf+D9UBbb4oi2i5Gy2c3UDzaNt5nw+N37xDGsSvTv3gsGnZKMRW/pqEQ?=
 =?us-ascii?Q?nfHg5x+Rg4c9QNbhw0NJpYBYGSlAUU02DXdddWLKAbo+MT9Vpzi0N67rs4c5?=
 =?us-ascii?Q?DSsSulsdsbOVWQndhZrQbYLoggG4ZmMRjeTNjBZqj+6XDCt7LZtF90mnZAF7?=
 =?us-ascii?Q?8sUBad4m8ogWC+LfEziAZzbGTqWqHBF+RTxANLuBYevsQlQioAifDsbIMzbW?=
 =?us-ascii?Q?KXakSZ9klNdvx/1xArV2xTN/6mwmPPF9EfQ1KDr9GWP0M/fLUk/j3Ti1cJTj?=
 =?us-ascii?Q?bWac/4d7fBYTClaW9HN4bmduyYOqNVxkjlLPFrPDR00W5N2G0muXgLNH5KzN?=
 =?us-ascii?Q?QkNrrHSR3O34/jdXSlD+B6jkXPjJzC5uOqT5B3RI6CRqQUuYp9HiAxfcqJm7?=
 =?us-ascii?Q?RBhfSA7FAQZ5VeJ0grkWnUNDDr69omj4Fd4dJHfY/x3n/RJIVkQpIHfOkozA?=
 =?us-ascii?Q?js0NEawnPdgSY0mZ3OLK4iWpHHR/C5p4cCA0C8j849mOn8PZSBcdM5Rvd9kw?=
 =?us-ascii?Q?RtgAXlps1sAkcL/L1mfZVkPjPRVKUGzStVKuaZiDvDPBwqGxKrIaShL/vkBL?=
 =?us-ascii?Q?qK+IX52Kk12guwQBNRHClK+bmdt34jyEAJuv7WopLnQxovV8AhLZXXA6sm/l?=
 =?us-ascii?Q?y85eARzuYffdsjhLkBHlTIoJejuOCenlIKDgYTdK/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?roIl7ffFd8cs9Tu/lQn51Rb4tFwg0atu6wvpnGD0CdhdUhUIAzho4LsupAzd?=
 =?us-ascii?Q?3UHng216FlOIPkgkS4nl5I554E90FLIZzZ85cB1hyZ6JSK1VqIqhzpbHd0v0?=
 =?us-ascii?Q?KGY5aLcb9zuA7++wc1GtzSI5aJS0akPtAFL9ModIjr2oTHA22U4N0uennnpl?=
 =?us-ascii?Q?dFbkZHtsUMQ2Q0qY7uzrysZdhSa79FBQlDZnriEYm3sAg15LPmQdeaWy6fVW?=
 =?us-ascii?Q?GpeAQqu2CzPYz781C9Hg2+UQc+0m+sld2j0CVOllQLb9JL7C5wqNfoW2iWPX?=
 =?us-ascii?Q?gowLCbYrg6rzr5EPletpX00DqistEPtUsKlfNY9DYHwhCXi76Erm/R/0GTYS?=
 =?us-ascii?Q?vcMjAg0kQlEDdWKLxtW6z+Yx9LWUKVwqjFDLP4QOjkyZRXTavfRcW1uopgT+?=
 =?us-ascii?Q?iE+BHRnAt02NTlnw5W9CORFBTM33p3yrB8o+joGpYjmLNEC6tSlpoL1iQNMz?=
 =?us-ascii?Q?Ib3B2x4e2wxfxuaTUBAm01CLpOCmDeSW/fHbbRfDWK+vZzCZZiYkNKBgEcPz?=
 =?us-ascii?Q?NZ3kVtaGh0er6HjwbVrZjylMPfzBuCGhg7FxNx2HMMpqlHbkrDQCv8pFV41e?=
 =?us-ascii?Q?uwPxh5f2MKdgnXPKKqxA/cSknyFOa+4PIiMo+dMEofotqHTF3LnJ0358G1ty?=
 =?us-ascii?Q?rPe/3/R1bzFJFqgqQ2wmXhZgPPO9xAOzyAslE7WRQOSXz4YNFmyragggCykt?=
 =?us-ascii?Q?QesS3mry97Q8jEHNZ7ChIw9f4AqGbRBMCEIWxQNJMTUxlv/n6J6HD7zkic4k?=
 =?us-ascii?Q?ZC5CAX8TVb3x9jK7VDI0Yu1gBr8LHGmKeJSu48EdAWy0IdPFuxYd9UGbFOT4?=
 =?us-ascii?Q?4nrYBn2qgpI0yP36zWzZDFLF6D6NFOOE3gBZQyFi+ug9q7plqaTQ5yaBflrp?=
 =?us-ascii?Q?05iGViq0XSOO8MjnUwcwED2nta8k3TnIg4eoKX13SPqD52DOSzl8Nse28Ky6?=
 =?us-ascii?Q?cMb9mntgGqvBWmUjKsEqBaIToGTevuPSF2+M+reoAZ2Q+IOBBGs2rjdGwe9u?=
 =?us-ascii?Q?AzU0xmduvF8WWnh8QsqCxXehPrnU+p02Ah2i7hUH0uXabcintcRdneHXfxwp?=
 =?us-ascii?Q?Oio4kCVHsnR72D8heXkw0FNJ31iQw6xzPbWN1PjxAxmHwk3dDZtT7qP3oFdm?=
 =?us-ascii?Q?4r5zFRnkaxNAI6kdTWzFpEOIyjerccE0PAP+u4+qXSqZdc4XV2amyphzETPy?=
 =?us-ascii?Q?ay8kQjEAehMve75650r8RqzrFnm4Zj9BFqAAXHajyiKhEgiU0uejNXz+neM8?=
 =?us-ascii?Q?BcCrzv6XP+vBvMubAulchRcUrCVdK7R05woA6K421wD5tEBw6IDB8v3lWoNT?=
 =?us-ascii?Q?+UJlYd/vCJmXQoUVDdAiz85fQU0/7Xl/AWAAEeJyZHAtdAufWUbDY1e1en78?=
 =?us-ascii?Q?h/M6qifcfuXH3SkJCbUsMvinpwXtpfKqePXQlR9VcLOWk875znC1m5Vn5Xhi?=
 =?us-ascii?Q?zllQckKNqVSO+szn1y2b49OLOmdTLBKJfnJGYdEM1zYolRX1UHgQdhJsssXM?=
 =?us-ascii?Q?qZ/N1zjOwcdyYMcQHS29BInJS6/1V8lnM7x6KFNZSaxpo5vwqxrqjki2q27K?=
 =?us-ascii?Q?D0Xme9PUNrQ3UFqaEHU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 110841c2-36f4-48e2-55f5-08dc79c51d1c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 18:37:48.6565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flrFkPeC6Mf2nUHqefp2z9wXBcfdh+Q/ahv9IlOPGOyblvK+MZ7Q4RodOBT1Ks2i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9071

On Tue, May 21, 2024 at 12:19:45PM -0600, Alex Williamson wrote:
> > I'm OK with this. If devices are insecure then they need quirks in
> > vfio to disclose their problems, we shouldn't punish everyone who
> > followed the spec because of some bad actors.
> > 
> > But more broadly in a security engineered environment we can trust the
> > no-snoop bit to work properly.
> 
>  The spec has an interesting requirement on devices sending no-snoop
>  transactions anyway (regarding PCI_EXP_DEVCTL_NOSNOOP_EN):
> 
>  "Even when this bit is Set, a Function is only permitted to Set the No
>   Snoop attribute on a transaction when it can guarantee that the
>   address of the transaction is not stored in any cache in the system."
> 
> I wouldn't think the function itself has such visibility and it would
> leave the problem of reestablishing coherency to the driver, but am I
> overlooking something that implicitly makes this safe?  

I think it is just bad spec language! People are clearly using
no-snoop on cachable memory today. The authors must have had some
other usage in mind than what the industry actually did.

> But there's no capability bit that allows us to report whether the
> device supports no-snoop, we're just hoping that a driver writing to
> the bit doesn't generate a fault if the bit doesn't stick.  For example
> the no-snoop bit in the TLP itself may only be a bandwidth issue, but
> if the driver thinks no-snoop support is enabled it may request the
> device use the attribute for a specific transaction and the device
> could fault if it cannot comply.

It could, but that is another wierdo quirk IMHO. We already see things
in config space under hypervisor control because the VF don't have the
bits :\

> > > The more secure approach might be that we need to do these cache
> > > flushes for any IOMMU that doesn't maintain coherency, even for
> > > no-snoop transactions.  Thanks,  
> > 
> > Did you mean 'even for snoop transactions'?
> 
> I was referring to IOMMUs that maintain coherency regardless of
> no-snoop transactions, ie domain->enforce_cache_coherency (ex. snoop
> control/SNP on Intel), so I meant as typed, the IOMMU maintaining
> coherency even for no-snoop transactions.
> 
> That's essentially the case we expect and we don't need to virtualize
> no-snoop enable on the device.

It is the most robust case to be sure, and then we don't need
flushing.

My point was we could extend the cases where we don't need to flush if
we pay attention to, or virtualize, the PCI_EXP_DEVCTL_NOSNOOP_EN.

> > That is where this series is, it assumes a no-snoop transaction took
> > place even if that is impossible, because of config space, and then
> > does pessimistic flushes.
> 
> So are you proposing that we can trust devices to honor the
> PCI_EXP_DEVCTL_NOSNOOP_EN bit and virtualize it to be hardwired to zero
> on IOMMUs that do not enforce coherency as the entire solution?

Maybe not entire, but as an additional step to reduce the cost of
this. ARM would like this for instance.
 
> Or maybe we trap on setting the bit to make the flushing less
> pessimistic?

Also a good idea. The VMM could then decide on policy.

Jason

