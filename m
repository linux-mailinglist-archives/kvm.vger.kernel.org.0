Return-Path: <kvm+bounces-24626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B61958786
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A1231F21C03
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC2819006E;
	Tue, 20 Aug 2024 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j3OmhgWD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0045818FDD8;
	Tue, 20 Aug 2024 13:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724158927; cv=fail; b=LqOXrovmzAmnbl0CbMKs+4gkQvqzCYdBfHsNxpFU4LQR/O2mi5RIzhQqRT9O6ZXL3eHqJcl2edkQbvUuUW4dyOKYXJ6vIdvyQQAAVpDaOvIgfwl4DT9LHhMDoS+vTcKNK7T5CaK5MOOad6KbmEv1nro2v58A/g8UMryDsoji71g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724158927; c=relaxed/simple;
	bh=tUzpGvPjS6BvDBWtkX9zOxcMviychqsFrpDkbLSg2/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yhgl76f1n+oN+ha5EbCzBfbr7PPmE+gUHgUY91ZUictvPnzjldel51ferXMyt+eilkkUQDiYQGpdErWfTIy3rs+XQSJKDMVJAW05Jc6rWgFswkamEPgXl5qUihLd/ezsKdXFxFYe4Q7bOHeufC+zlhiJ3dWJKD9brUAE8uwqhoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j3OmhgWD; arc=fail smtp.client-ip=40.107.94.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ge4NmdZYPN9zLQ59FEMFu7zqJlAGZ1+Iv9LhwHfmrLHJBi7B+CQ/D6Y89kER7SwbQj1aycyZDAd965F1bulHrSqorVgakkvhwTrkDAQkcFN+4j+iLxOGAt0tT0eBOZhLZTDO+8maXgZ0k0/JnxYKzEvRAJxniqJ1L5BXNyUEPZKQ0/t1g8efjLTjwY8dTa9p7iIT3l9QrP+7ApD5G3w10N1N0uzAXMDiVx4jGR4s/gXXKyY1WrFfUTZHiEivUFUFjKwNrOPDF0am4S6K4OzxBnZdCQ0ZgXZhC1BXtc2KQuOwSmlXKHqk75PyiVUtFKGC9wAoAzsiuaz208DrkACqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUzpGvPjS6BvDBWtkX9zOxcMviychqsFrpDkbLSg2/E=;
 b=OFThIYjlWVafzTcnDsgz9yheqiy4EVEVyfalTCMYPWfAnX5r7OTSXRMiioT0u0p3nPuKX2kCxBvA1pXJ2o71RKnhs6XONcAiK89tV0D/HzK+cZNVkZkMz+VGNq6QTP4wD5uLftMJWMv+77T8zJJvFDJqElyBownlTkXZ/7fhntiVeJUJm/Sb1d1vnc+B9NIBNLYi9cfmbMzbNRP3yU1DEUVVOG918XKVmStmKBla5HA/kVx5SKwcnxHPc2Jqb3yZ20h1x+cT3JW7oPqkTGDNYmv/zuP9mVwHoScTwTM6hEO24/3iloMk9X8V1ISdNyCoazxVcBmk7VkQBj0QQEcvtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUzpGvPjS6BvDBWtkX9zOxcMviychqsFrpDkbLSg2/E=;
 b=j3OmhgWD6VgwghodVbnW7V9QEorzY/iCwWi2XJbgEusOydY7c7Ja7vIsmizexaU5HLwABH+l3Npi8P/86HodPBjI2BFR7QvREnXrhcMGiL6ze7TzjV/dQEFVzlviDBiggvb3XDCGv6i30mrLNBxHVjHTQ+4teZYpqVoMxzkYjt5XpcXXMhbiY/B2JblHm8TSnp7y+XGVN1iXNO0pYmeXyMC4lMcujxcbsouGoUt4gH+EeOliwnybx+nCGA5ncfdFcuNG/MFottkEFdyifJ2VYWfEIodQPvSWCCZoLTi4SRw1KBXBwNxzZnpjrJontfpmIQ5T7IuaH3v8QTIiO4SVoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB7376.namprd12.prod.outlook.com (2603:10b6:510:214::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 13:01:57 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Tue, 20 Aug 2024
 13:01:57 +0000
Date: Tue, 20 Aug 2024 10:01:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240820130155.GD3773488@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRUDaFLd85O8u4Z@google.com>
 <20240820120102.GB3773488@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820120102.GB3773488@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB7376:EE_
X-MS-Office365-Filtering-Correlation-Id: c6d3069f-3ef5-48b9-c398-08dcc118457f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5CYioQ5P7UolrWE4I6CZB+M8qFRpWqvm3jE8BT3oj8PpksX6oCtJxipGz9yn?=
 =?us-ascii?Q?OJ7wExzT3YQHFP4JDl/5JcT5iDGkmOmq5BWvWu9Jm6z7JjS06DIEVy6fVUhK?=
 =?us-ascii?Q?MmKzolZwhSJxp+/BuOpYQ9nJJ99wL+Pyq3sadwAOUDL4zHXGjsbP+DC136FC?=
 =?us-ascii?Q?tBBhLN6+4Y41EaeMJaXpmoO0G+COahZ9ZQ37TuPkL6bs7KC42L373nSNmNcp?=
 =?us-ascii?Q?faKAL6SBL2A1/+h9v2P2zUTT9tNZ4XJXMHQrICYD2rwCrKkpetynGk2JoJne?=
 =?us-ascii?Q?b1xhLCDQQp8yX43Pttn9jcFCG5qKrj/4QitMwdi39rIFByLJp3clzbrK3A0X?=
 =?us-ascii?Q?/A5UBzUbf+dN7Zv0tcOqhJZYhtsqcqbo9yTwn/0XzTgbVOKfjp7o4rfyc86K?=
 =?us-ascii?Q?2rJQk82L2Y5Ucq6cGRau5tvYJSgVAqLpU8RdfliwMDNn+EIW3LbAuqPWkLes?=
 =?us-ascii?Q?qUDdp4WLOWWDFTGRgOBsxl03nczEdw0/qqVjQ7SDGjMrlEvL5NvoR6XNPUSE?=
 =?us-ascii?Q?SGBHpmZpeYmPGMNB2Rkt+Uft3uJWxBt/F/WPwrlKUmPIFQX6uPzdsi2KjqRr?=
 =?us-ascii?Q?1z21eA/N2vnpVh2IIbTtLoFVs0O2497iK+4eoqsxbbCXhnft+RHtob7vNCOa?=
 =?us-ascii?Q?2ofz0taj9DCAtHVI2CXHsSmI0XAAddyDgT7XKG+lUktsx7RTZm0n1ZbA5XQH?=
 =?us-ascii?Q?UF1DtawuOeIEZtXhhhOSr0jyNoGxo271q+OwaNv8O+s5bsh3F2xDInb2apjn?=
 =?us-ascii?Q?gtTGffeM6/NBtGp1WFUm0uSUJEHEB8dNtiJsoHjLVOHppO9g4Elpshnl8IZV?=
 =?us-ascii?Q?QuIYUJWyf0UskvImuMbC5sFawYRhZxma7OA0SeO2Cw81hIuQ4sqx+4qFN/PI?=
 =?us-ascii?Q?cFSADO4NkVeDP0XazvZv2k/OLuxlvi4Gz0uhQjoiZBrqLkyVWmDvAtO053O4?=
 =?us-ascii?Q?paCMrvIhjdi8piymjJAATag7jP8cowlM4rQDcRppQ+iWkbD5CA+TwnLUTmQF?=
 =?us-ascii?Q?i8dKQzd60zPNkdYLXci5QFXXkoxYVtIe1zQpytgOnRJwOI2woWl6/QtxyvhZ?=
 =?us-ascii?Q?P1Jl3uo43MsM5kbbLi49nzhTzxvbcNPzm+t9VufCKrJNW2YNxxt3YpdDzZzG?=
 =?us-ascii?Q?1OxKIYnHQNs9kpUTOqTJKt9enzfvMNm3P//8OpLZlsX3d7sgQ7+1aCHqoJNG?=
 =?us-ascii?Q?oAU8GXqobBT68SzTntChechCw2zTXuS5nxb2BahjJdYPSbtdSIhxAUfTS/4X?=
 =?us-ascii?Q?PHYqBvIrxN/m5xM47p7SrjeC4e+bRY5OHRuTi2TtM/8BsB0FBcQzhc3UGTWX?=
 =?us-ascii?Q?AE6hQPQFPXXYX9JEpJvGzGlvaTb5R6/jwqAdesjOvZnh5A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+eZ/ipGZBeOwWWf8MpFe0AlJLw7uTnoEMt99f0+wU/y1tyuR6Rl2rDSuye/R?=
 =?us-ascii?Q?82NVBpy+z380+83LlwMlAF1nW9JAsXIq+DssyDhVtSCF+fKktnU8gSdcJSIQ?=
 =?us-ascii?Q?a85n1ARS7aWc3f2Ez73QBF4EZzSZQBaTQ0xTnt5Ovqvu9TzXlUlRbq2vYt1K?=
 =?us-ascii?Q?WN0UHlmG2ffC/myRbZK1jVndgHJUg9q2VYyKDe17JWOwle6WVMXo5FpDRu/S?=
 =?us-ascii?Q?SSZAF2oWYa//xQyGEqu7hZ89yusxH3BbyjcNupPQjbky+xvUW/kfKz6KLjP2?=
 =?us-ascii?Q?xAg7vBBSvYU2CCsoWTuQ4Y4QutYDqcYp3wl14aPbmHh5Oz2Ytrd9QGAvvHJh?=
 =?us-ascii?Q?Jo+KNRKMeFbTqhvO23075vBJED4upImJzpgHo2xRC3rImmWLclXH5IhGma4A?=
 =?us-ascii?Q?reqZTubKg7I7OA+QHCo1OHlyd3tG4jQgU5ZmT+Vyzjs+JJ/jggJcMiq+fC/l?=
 =?us-ascii?Q?E4uMKNbbtO0nAp+hnJalyH+6e2KiA1WcZFsYHt0raCZQ/PZBwL8vbO1AnosO?=
 =?us-ascii?Q?ee7A7a817nKKTpDR/rjh0dv4xhw88yt+E9lBOq0uuE3ZXPTGsYzW++5QTFVD?=
 =?us-ascii?Q?KeyecQej8tLHq5k9o/UEVznc+8Ct5JqT/B0FnObVkUWhgYFzYFNUrNtFfWCA?=
 =?us-ascii?Q?zxYKiuUfDT3bT7u7GUaK/tffPWuyKk9CEsW6jq1UVvoChoeHieDEJEIwPJ7G?=
 =?us-ascii?Q?zmT7mAIwYa77XyO9o2/yYyNaQ8whUkm78DEKk1oq8Vq18yyw/5Qltwd8d+Jy?=
 =?us-ascii?Q?7s6F12UhGthHUez5LJCW/E2yeKlKIY+81Vtlj6su6qugajqcooXkvr2Thcot?=
 =?us-ascii?Q?4QkyW5OZqjC9+GTb6RNgNEAvq2MUqixepBWWS2wGwvPSKOxbcAjOhjDb+3eo?=
 =?us-ascii?Q?YbkeOXReBalUqwQaLuSjig+GM099eeSIMwewyal/+irzL/s1+vmVPuvHEDWR?=
 =?us-ascii?Q?yDCM7+eVZWDr+VoApV6ynbXhJdGbAUAShGvRtuDHUKX+o12qFxNji/7Xk5KD?=
 =?us-ascii?Q?0aXkZ7qs0C/0siA3rcd/qWluSLPueNqMiGVYwipo/8bOybD1E+GlOVwSSDtI?=
 =?us-ascii?Q?dKJydct34fmxSRyDMso9+rOLBQJNm6tOAnIU9oBHxBrtVCimjYXstcS/uFS8?=
 =?us-ascii?Q?U4dY4ATk+0NeefOjB7+7A13qrQxxLvgUmvBoBhJM/dTbIufrRvAnxFzFSxcd?=
 =?us-ascii?Q?e+w0+idz6qfROWCZz6YTKuA1DFFL5v0oCQsOuwXndglmUcFuG4u/KEMEzHc2?=
 =?us-ascii?Q?0KMWmjevYRnsXsapk+AvWsVgw/Qeg+iRiq28TfhnTaYLzgvwLMFxbehwpPJa?=
 =?us-ascii?Q?OHALiZrdliTrjLsKLewjwuSe9eSqjM13Ved591fdpIADMUVOmVIqpkxl8MsM?=
 =?us-ascii?Q?Ps43tdZgYuK+3tkXbEErtxwamG8ze4MK1XgtoyV7utaP0hH01z2gNCiWR3/B?=
 =?us-ascii?Q?oh5PyS52jC9u2PpP/88gzeqMXJd+84Mz5NDpsXd1IFIfNbNQayCotzwbBmpF?=
 =?us-ascii?Q?6oj1kuFlPjQQ33JF6slYKZjZjrK6hXTmm/aCIf2ZFF90LQY/ddUYOmLcaSPv?=
 =?us-ascii?Q?pY7fE2Iiwyiwh6JbMLk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d3069f-3ef5-48b9-c398-08dcc118457f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 13:01:57.0542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J1688jy4G1rOGRp+xTtix1NNLVrPoSmUzhlxdYbHXynFfDAr+thih4/vIxU27T+g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7376

On Tue, Aug 20, 2024 at 09:01:02AM -0300, Jason Gunthorpe wrote:

> Also bear in mind VFIO won't run unless ARM_SMMU_FEAT_COHERENCY is set
> so we won't even get a chance to ask for a S2 domain.

And I should also say that without iommufd something like the DMA API
could select a S2 with S2FWB enabled, but all that does is change the
encoding of the memattr bits. Requests for !IOMMU_CACHE will still map
to non-cacheble IO PTEs like before - just with a different encoding.

The only thing at issue is nesting which will end up in the guest as
forced cachable - however since VFIO doesn't support non-DMA-coherent
devices at all this is not a problem.

Jason

