Return-Path: <kvm+bounces-66343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70377CD06CA
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED903300AFD0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA96F33B6EE;
	Fri, 19 Dec 2025 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rrxphmlq"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DCB33D6DE;
	Fri, 19 Dec 2025 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766156407; cv=fail; b=GNUHY5XqUpDGQy8JquViyGnx931/HTyCECDFpWwO0Rih1jYRrnQw99HKRmELDpbQIUbZLz2Ml2iBJvIPIy+ypb9x3cvUe1OyDIB2w4IiZlL7CoG8pY8bBSqiixJrA7TvzDE3tIx8DSGJHraEVOv/RITZFakreRXXsJxNGoVPbRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766156407; c=relaxed/simple;
	bh=+oDbsR+2+j41T2W/stLdbCoBd3TUOjF2T9q8XGRAvMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tMM/UPIKxnap3ZD+ablUr7SuDry8qLe8It9GnflurU+B2OL1PnzvhPlRJkq3H0LKnAdxclC9MvMajJkwJqDrVbhM0gGUEFtKk9S4FR+8SBWk8Eu9CbL61A15hICdBHjKmvKd4QKbbub0RJZ+z1RjYOTGZwdZm4M2PWwD196iLb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rrxphmlq; arc=fail smtp.client-ip=40.93.194.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQ68UbIpZ67yQuCL/XL7H48CldmU30XlgrpWD0/a0CfPc7kjSvfmG3gricAt2PldWbaTSyX06xkKBbtv/p/USBfEWkeD3eVehd7iJDO6yTL7lRGiDmbcqeKeUXfv5l5q8ycOu8FmtsPBus6AFOxQoAUE2otBYaT16Rcxeo2BfHZnqkTJ5pyrCNcoPz51YXkglZAzIfTgmh9LWJeFkBULABFGwhNuIlSj02rVsULJ2wd+LG1lM9aFZsydKjKOG6naLvTXE2r7kWxf00e/gmI87SQDy/r3ksTF8s2LzzXqogoCsPXm82KkDp+Gh9Rq+x6RXMKIrQcI89l1bSXKIfz+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HA+G9KM4tvSZKeBmBgJnn1mv96flO5unj1kyfH5aaIY=;
 b=RPLd096EpdPG2bktz0G0voduUS14vY7DxPxtWCzkCE758nIX67kgxh46lORrD/9LlrKdZ7m7QKXKcU2vPYvNcTKIs2R2uph1ZXJitkytOiY6V5lQUtTei4pVFJlCtq+G30fG5e3OfjmEOwSYy4zxAjYHM7jdV+lgGw8BfmUyUj/P6agDtV/sqZlXNhGXNlawbhJ5mvO3q6jVE55brup15Z2DovMNvn0N5yZsnIgwVYFGJ7MOHcFf0hXrk9IlZvOpD86WomiaFBYFUjmwQyB7Ce61p7x6O+B9zTxiE/6JO1guDjWsV7oy3zxemd/GoDHvskIk1+PK8EGZL55NE45v7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HA+G9KM4tvSZKeBmBgJnn1mv96flO5unj1kyfH5aaIY=;
 b=rrxphmlq571KYTfJZV076kLMTUtHqnQhjofJlmWrNtODEsus+x6oDn9pHhWIkPN2gNTr3xj5LU/G+CyX/N1qOwmplT7WDoKC+/1onjHpi81dJFQuvH+SnaINBWPcb3WpsdHdJOJIMxgBWEbatqpl8OveWQKRSluD4+w+jGLjD9D0XY6hv9NXFF9oEvF7Bk6Z6STnNxbuiHS0Wn3Z3hXNrklbSKW7KmyyYEn5YKGZcOGaOi/hriXhlGhqFGzI/au/c/kJCouQ5M1TFOPMGQjuAAP7UiIAW202JzKUwYdam2aQCWaPtcDN9h9/f4VHI3sPfy2/3a5TXZTc/8lYuOmXgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 14:59:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 14:59:58 +0000
Date: Fri, 19 Dec 2025 10:59:57 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251219145957.GD254720@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
 <aUG2ne_zMyR0eCLX@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUG2ne_zMyR0eCLX@x1.local>
X-ClientProxiedBy: BLAPR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:208:32d::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 02a8027b-8159-4c20-7366-08de3f0f4714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wqb4DR0mLNTuEUQi49hMQcfafTtIrP3A00Uv/fcrHTQOGgkO4g4audgZEw4E?=
 =?us-ascii?Q?vfKTj3RgqkgV52oevwtsYm5mta1HgpWXQb7K0BVxasdwkQ2oaKeEhqZkfWSK?=
 =?us-ascii?Q?wL9wX9jQXZduciGnWuSWDmrqKg3T3L5DTHMsouDAzhkUvrsxbqLRlHhcYm4e?=
 =?us-ascii?Q?daTP/QFMTGXQeNLfRPaMSPKJMXVBh8aKMNI7vMCif1tP2mtgJVT6gE1eWMR0?=
 =?us-ascii?Q?wcFIvuxaOoZfCo9jk4+hda1JaWTpPGiE+hhIN7DT8B6veaKq/P3vxjs99GJO?=
 =?us-ascii?Q?tpqC9+rcb07nPoi9NgWQkjQyrxmW4BOErolOpBSZo0PtnoysD6Bkak5KUuMN?=
 =?us-ascii?Q?DymI07vhJaFHtAjlBHMQKYWsm6LWp2WLqAiOcofvyg5wq5fN7X9l5+VmPQZR?=
 =?us-ascii?Q?+oTjILm5+g3QuiGf0oS9c8BVFE65nWh0IkCdA6gmAccOaSnN5sGZvMPpgDF/?=
 =?us-ascii?Q?NwF2KppinyGOFnggCpupgzui37BvmozRzFCBcHSTW3dBVGBShhVUgmzSUDSo?=
 =?us-ascii?Q?DXNx5vqEkK5ZGaWnpnLxMWdhYS6YZq4LP3gVYntEkVC3FQMKD8I3zBHOMW+F?=
 =?us-ascii?Q?7kBa1CFnaREHk7lNDiEOBPJzvLN96xHuRPzC1zdhZY280rkq3JXm3PxHhcfY?=
 =?us-ascii?Q?b592KquFOitLDtMxURHdswsSWFGmFhJrpsUvr06SAdcz9ENLs7EmuO8oQtf3?=
 =?us-ascii?Q?cmq1m0Y0Cv+pWYzgTPamuhFtv1/gb4SF8PNJ9iDJcgsUOYZnTAX+zupkVcSD?=
 =?us-ascii?Q?748SM9+7HP4rVp8rls/VH1RKUo5vC/g3qYSiDe2FRxl2SS4DF0GKwJk79lVH?=
 =?us-ascii?Q?RFeo096X939ihPNCG2YoLf/eAvvPL3fSdhqQBS7DH2i9jP0nsC7JCXMMJM4C?=
 =?us-ascii?Q?2DaJYQ9fkMxPpVHvPtBa1K7bxTkN3fIsXznt1mooLzSn/FxwE/WZV70Q+dZv?=
 =?us-ascii?Q?ResBPQM3O/xz2Lree9YUVWS2HaUO6/xskcseVUAKRZJ+vko70kraXst9wM6O?=
 =?us-ascii?Q?vHiEgOb8Q/ipXTj3kt+Ggy6OuDAHPo+gxYRkD5JPxSDeUuct4oWY/Z3oowNJ?=
 =?us-ascii?Q?6LwMdQ7048l2jMpWl4NMyu+vWpWui3ungPgfrntL7/ZIyO7b116xFLAcl/e/?=
 =?us-ascii?Q?bLyp8IrkO8hoywYPiXBwulMWMj8mg978APMCquUdnhkVzG0XWAtNxeORno/z?=
 =?us-ascii?Q?d5FBzhLBceAeukXYaW7H1E75rmJZoUReXBFPHOgFFLBTWzPpejjCA4gZBkvY?=
 =?us-ascii?Q?2HV0Rm5rVhSkJun8HZ5f7ue7qvrZK6qrn1YjvmSfB+mag/dAOIGO8L6S+Lmm?=
 =?us-ascii?Q?IrRzGgo+7XVhLa7G5wS5xxoSyUay1LYvVcMTWwB0kG6GX2X141UjhJWJD2vr?=
 =?us-ascii?Q?Yd64FqIMD8OYNWwO+QpFQjVb8gUTNkksuXnOYqeOkAfylcD+Gfqes/BYm9D1?=
 =?us-ascii?Q?OhO6t1kV7TP//pXlnoLA86RpkoOtbbN9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zTtiXAG4SH8dWqsnM4Kxqnat87bpmqV7J06qV/TYoVRsb7WI/G2UNGwj42u7?=
 =?us-ascii?Q?5WkOMEGyr8/qzmLbtcMM3BW+xF9+PfzV36FYD7cXTUB3qhQKYveVsZfV2CCj?=
 =?us-ascii?Q?WIMsFZ5ecSa1c9jfY44gLjaKzY4UuhnWliT4g07XVOBu8QjArGLsBIJrQsk9?=
 =?us-ascii?Q?uRISzriZ3ZsrnDNC28lT1Uj+HdJDFyRISRu3KKwZtD+No+HU+upm3gbv+X4r?=
 =?us-ascii?Q?4q94UrLux6mR5B1gGeTvfTAmLzGsMzpAoRTnT11Yn3a+w2euJhdFxsTSrBqH?=
 =?us-ascii?Q?pBFE04pu0jZ9FA7dlMHDWq9fgEsc0A/2PCtBzxfHWMKCmYR/GcNlNMIYDzJA?=
 =?us-ascii?Q?QXhwnEl4JdL4rgkVkcTZCXi6zPLOIlFAyUlEQWRdEgzKAqUWTdl+sTSBov/V?=
 =?us-ascii?Q?ud7TfNK/4xrB76mSGYce4yXxUWPSLYq1hVrZXHPOwRRKTlAOLnvuVeswBQJg?=
 =?us-ascii?Q?bOqVgKsSACYhXpv0rtBz2FwpiQsSscTC89kPCBs+p4gp0pYJDzw6tISgJJIY?=
 =?us-ascii?Q?kf7z7zSNaF9AEu0TWjgNqY5iXsGdvcmkL9zXHiPDCPnN6Fq9p2KwblgE/gl4?=
 =?us-ascii?Q?Isf5YlhvDCq5r7oYZUTlHdHx7kEO+ToSL6WVzqUV2Dh4T5+ZydvMvOugl8jx?=
 =?us-ascii?Q?Q1qO5+DPAXVekxq8wHZQMrfy1Kw9c1HCUn0Uh47SWxAtq1Ggptv4hp78Rs/D?=
 =?us-ascii?Q?S4xOqBU6KI6PtdC6Lo2KZZDm+EAeSgWUjZlnzOv/EuXrvE5Afa4JeafX+bZc?=
 =?us-ascii?Q?im4IJFU5UrycYk0nC0BJzJ89FohyLsDaf0Sl26en0lMan7pK/q+ufUdSGeil?=
 =?us-ascii?Q?fhoTYh7LrQO9V9PEb4HD+L4kqCeJiSVweFtq3tw/XvtD8qDEx/II5Yy1Kirm?=
 =?us-ascii?Q?JhcYtFTlPxAmra9amcCiWQ+WhGBf2+pHJeWiVB8BUSVyYhC5iFO+gHZaVd49?=
 =?us-ascii?Q?++7d1tPQ+cEZXQdx5HQeBUlbQnICMI1nsYWBWnWPUHYBg3yCwfgyRd+LMCi/?=
 =?us-ascii?Q?DzAyq2whcM806dgpCWk/+C0jOaGRfRjHseP0vRaMA2xvCSBgX/oyUsthVWy2?=
 =?us-ascii?Q?J4LfLfe99QdiMcRO3x6S2TFLonQOSDJrMA8AG7do7rnTrqi1XrJOlpWbVOkq?=
 =?us-ascii?Q?rN+AUXc0WeS7FngxFDOyINQcR8iDVA41rDsvOp0FIfIde6z64I56QS74OQ3I?=
 =?us-ascii?Q?mcbWrwrQl8KdonVdkIhgjI204I0/kqcIDcQjO368cEO7AIcxJXg/QJD6dkL5?=
 =?us-ascii?Q?OMhgp30QH0LFdjPUdC/avrjLER2bofLWnO/xCIdo38ZMPQ5qWJDrW3I5ViFp?=
 =?us-ascii?Q?tMtpnJBt1Q68p/SdW0QMz7sdXMSzMvx0M8AI8SBF2TgtB8lxbw0CyV0V1nJA?=
 =?us-ascii?Q?2KfTv+t+SncE/gewdZOqWjS1JwarytVZC/H7FH1e1VG19Mu/NU5/vF6zq8br?=
 =?us-ascii?Q?IjbnALusad4BxChf6zFQARCTFIjKRYoyY6iw494xAKwIJC/LsGF/0cqa6l+7?=
 =?us-ascii?Q?yj6y9fG5SVRDW3wVPvi0LzuZn7JCZc6NjEu3J+tl0E/nfT6OkKGmJ/VOktzs?=
 =?us-ascii?Q?XPbqkXRvyYwizeQCaRQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a8027b-8159-4c20-7366-08de3f0f4714
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 14:59:58.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5lGo85411/jxGKAotUf83ifYnH66NDR6RCrFs+ONOmthf6O9ujGq7nxbBKfvVaSp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861

On Tue, Dec 16, 2025 at 02:44:29PM -0500, Peter Xu wrote:
> > > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > > let me know; some example would be greatly helpful.
> > 
> > Just document the 'VA % order = pgoff % order' equation in the kdoc
> > for the new op.
> 
> When it's "related to PTEs", it's talking about (2) above, so that's really
> what I want to avoid mentioning.

You can't avoid it. Drivers must ensure that

  pgoff % order == physical % order

And that is something only drivers can do by knowing about this
requirement.

Jason

