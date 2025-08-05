Return-Path: <kvm+bounces-53977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D02CB1B2C4
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08A9C18A16E7
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A92256C91;
	Tue,  5 Aug 2025 11:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JyLQ1IDf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310A242925;
	Tue,  5 Aug 2025 11:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754394558; cv=fail; b=FXEAFTXDTdZ2hCLJWifv2sVyDwq53gq2YuNK5ZINx2849oaxmF03hV4RfFkOB1Nde9PERP6v4iy9U2FvRtddlsHfHYne0BtqphQu6aHPpDdyyRSxjmvb92nD4u4yksc9wZwg0zWwOF01a0rXBsjwpj7qFYdyot8fiudPfMEq4ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754394558; c=relaxed/simple;
	bh=7paZeyOzlP5OZaHFIMIQDrD4R8H20Nde/dPTiejcJN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R2NETOBMOvMRevXEppjHqfnnbuIVF3284oFhB/w+bqwk5QduTuzfSS6NHULHnJEaf0BpJyVfqCjfBzzZcnOjmmW0ADpK4+/mEaoRdD4pm5UkBiwC2QkrkzVTEUZujZ5xA5nYWrQ3s+ss0kWu4aHr86v9dFSIbQDiSCppTTLJK3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JyLQ1IDf; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lvgf/lNSccW/7Bq+pQcH22Fk/UuypE6HtlF28u1FhmUlCpcwJ7Qk3yaPyQ3SiWXJz9KBoYQFeHk7+5p9U52wTnT7kem5IFe7XjP7eY/1lfu/GzyoLh8vn1WqRgFUT5EHGY5SJLRRGjzMBjDZFeB273/HchyFR6lxDWjr71DicRIaLD2vqKGcpX4c48Ohcc0g5jUoHKpjhf/FFO/qddXGVioPym2gPYjJx4UaPbpRDs6Fl0l6U5XQUdbf3btCf5vx/1EWPhlrwC5Gjg6fZsOS5wFcbZ9rhd4l5fkn7mdf5EEVuihr835XnHyX/GXIKtKwcDg4aAI2F/OJ3gbHN2zbsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PS8c6SCo5dd8VFvYL69o2hk6HeYeuVEWTHOQZ5BaZY=;
 b=COGzBTvp++e2O6Wu0kW1LxINOgPIpK8GZiX89l/LCqkk1iBR9XhFftQ++a9eztWUCYrvR1fzSikRXl0ixJfUkbZqelgspAmZYUNTlY0yo75iZKW0uKkgWFZTTy/gvawk6zs9SGBbaDSvBkxUYun9Nz6rSUxXMD0wBObAr/k8oe9kf/vFU5gSPCyF7N883kssh2htOjox4ipAOSDVwWEaH1L2H2qLqHERlDTn8XzhMIF9QjKoCzlNrKpwNxu9JnpjOzvCvmtoLXJI4Ww9gQZT2gHwzLiBg5BCsqufXupfuTdiIXi23oGW6ffXPGj4+gojdDb/3Hd2ftGQIJc94PV/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PS8c6SCo5dd8VFvYL69o2hk6HeYeuVEWTHOQZ5BaZY=;
 b=JyLQ1IDfgOQckiKgBlOWfu/0Rpfi5ODO8hpmG8v+pHCVSct4PHKq5fY2X16srHSljKopNa2ImtnMkHegfINK8wpZDDxVVESpQnIXG4zI/yEGv/HOtwoJnaJFORj0zIXCHaDQMinqjQd1O1r6cEzcM6yAYSJ1saZNMRgRoavAhsc5kJNSK+88AjYBl877PoCcNXyMfe9dh9+MOxJkNn9qejffKqmpSRCP8hVnCpNRmnGuy1w2DU6kbw8UQCQuZM2FUpEeB7MHnWI/X2g9NpNEeDg/IWdUNEmzIrhGw4IVDE5FFBmLvdNu1SftbkdiqUxb/1OrEk/K1/HXh+MN0ibGuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH0PR12MB5679.namprd12.prod.outlook.com (2603:10b6:510:14f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 11:49:10 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%7]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 11:49:10 +0000
Date: Tue, 5 Aug 2025 08:49:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805114908.GE184255@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
X-ClientProxiedBy: YT1P288CA0029.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::42)
 To MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH0PR12MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a27d496-0d15-48f2-daa3-08ddd416175a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JGWCMTBfn1Je6mcEE6GrDdN1h7rW7LlG5sF+4CsGSK/SCPjs+y5iS80ZKhoq?=
 =?us-ascii?Q?t2Jh6AFIv5rz6wSJMnX5oR5nxyoIeKPrUPSCthRrkhpJO28obNbJKm4K8P5D?=
 =?us-ascii?Q?a26Vw9fKCHjIRDI1j8dyaYxUCKBmzWgK1rloxK2F9d4B7LS8HZYtmQk+iOra?=
 =?us-ascii?Q?NDjqK6rPtMkWUYxjAa1eH98vSG85+YhtXn6kK6aEU41CBH6fAXlcks4bCt9j?=
 =?us-ascii?Q?fGRGGvupLh9tGmPR5Y7m3gjA8UfXgXPyBGjCFSqS54+ZFFVBdFJe7Oz2Ijnl?=
 =?us-ascii?Q?VHldNv6kBl0/gMai5QWhtZBvZh2UJItNqxLBJ9pngz/a0/kOZ3PknUG5b4J9?=
 =?us-ascii?Q?8Aue8VZbQNuPDT7MwOJ2B0bih3JAwQh3dv35TrEEA/nqHwwK6zN5743N/D74?=
 =?us-ascii?Q?I7gQTXGwFM/SflSmG6+werqfyNOh793S4w78aS8eVmSqZ4rTGUKkm77WfxzK?=
 =?us-ascii?Q?0XbzoLvHfruuJ0/S1i2TJczefXqOJixfgIihCJaC0q9wwupcTqA0so2deZrp?=
 =?us-ascii?Q?MDWshW9BbZ2IEROkhDD7isJqoJVlq2VASQWLe4Q3OMc9AW/Jf7r/GZMQd/a3?=
 =?us-ascii?Q?uAYH2M+ZTC+Bo0Sq2dfnNlgy5d6r4Kw/56o5LVfjWogMf0Xmr5FbrQYq4h5p?=
 =?us-ascii?Q?AiVzFUYL8ykdUczIYMT0KXQCDGzpn1FaLaMPZRw+342wdUh7cU1uOa1pdPnj?=
 =?us-ascii?Q?C/K6GEiMsU5F6PyZe0dAYTlcot0uNa1DGIF6VoZ4gHbaVEBFRPdhckgpQDGh?=
 =?us-ascii?Q?1fW8c2+DraryAy3jfAxL6YZA7VrtmNGKqVd3YcVOUB4yrmWtE3Q92ZElUdQd?=
 =?us-ascii?Q?V6VJZwMq2trmgIT/DxWFiOhq3Kk+kzuoKnP+PZq65N8x/NnI07V3GP0i1ls0?=
 =?us-ascii?Q?jR1fH1jlKhfcRQFILKh9YXFCsU7vSS9LTnew7l5KkfBcCkvA7CQVtUbId9R6?=
 =?us-ascii?Q?HihJkv9OnBKlzChQxDmNWttkot3FSUeKogczlBqY3eT4AeTGTFLiSr4CdH0i?=
 =?us-ascii?Q?i7FFctISkUXRr4cJZPSgZdNt2V4zZNQNa1xrk4PQB4FWiGl7r7xddvmYcGxX?=
 =?us-ascii?Q?h4hqsypEjHCDzcg1qBoXQAdDe3L/Mg7N8JlJ/51PcrbsMzi9SVIUXxRqqpvU?=
 =?us-ascii?Q?V8uZ1Qtq7P7PI6Ko4lLJiT/6K120jV5nRniBd63LZSVAaR+g3kLO5xlHjvOh?=
 =?us-ascii?Q?PNApRFGpbFoCOORQr4MGFlHYCn5CSWes1hGhRX8zd7u77zjARJ9jHK9cmt00?=
 =?us-ascii?Q?aimWRBckVep6yGW/usULrajH/3cq3bKKrspFcmAwnyg+pNmCLgCtcf0AsrbN?=
 =?us-ascii?Q?UdAmjnPUm3lVlK1Mu/QHXt57kPsibnJ9hI6dk5DPr90wrXhTyW0Prc5+hQSh?=
 =?us-ascii?Q?G20liDg+DtjnIDbhYSeCtggSkmzrO9WCJCwfnVTvj9SeQyDtnrtUaNuGq/rw?=
 =?us-ascii?Q?3tHpSiekB8o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CO4qJQ4JMRGUyeIIYQwNnnDHrXD8LT0Uvhe5cQJbq2KWInUdcF/OiQ+Nwymr?=
 =?us-ascii?Q?hy+mj3HX9ym/lUyDMjkMykVtkylytTRoFRi1BosYPzYPeuwJ7jktzgjDA1nL?=
 =?us-ascii?Q?iCigHsRu5vCmzb1NAoUhsRHdzSX54zI6Dh42LAJZL61KR11gDIeSNjJkxy7a?=
 =?us-ascii?Q?2+/Jq7QXGXxsPHAKQ0hQHnHXekE9fS7Z8zB2dMI12+P/zN5tozNZ08fPgaZi?=
 =?us-ascii?Q?EeJGkk2eEP6VpGGemHWJCCYF/YGqrQ649tVqw7s4ZwOtRO0O9tbsol1F0ARA?=
 =?us-ascii?Q?TvERb8uVa1/54DuBdSlv5MaiDrDMDfQCDtCcUhB9plR5SMDB0pXwRNvVTCRq?=
 =?us-ascii?Q?TRv9zTAVKSoKcYTXBCYeITSOjZ7dVRZApOtHGEdfEU9fCYQuT6h0RsVmvR4N?=
 =?us-ascii?Q?xQFHzQNjH8A01DI6Lc+7u0zjbT8SRi4imzmhn3+qVogKuJbVnc2YL30W5iOv?=
 =?us-ascii?Q?idWw6hpUxN8N69i0BrC8p5GGcghp4fq2a34p3v9R0ukm5ZZvb9uFnC/VkKNR?=
 =?us-ascii?Q?t14/4HDcoTGsa+Ez4WXSS9mwiKTBEjmCzaHkE2/4u1pWxPpdvFmrOeF/z45s?=
 =?us-ascii?Q?004lbMbQjrtbP9wSpdLb2k8UqnNvYl+qcQjMM+mVYkrWJvPXiEbvgbDv+Yvp?=
 =?us-ascii?Q?PsgOo1P5r795J2S1BaCSPrK+bE2syZ0QchvG493TkQxP7ePuAABlDu/Yvg/+?=
 =?us-ascii?Q?yGlz03xe9IWMQU+fQnmx8aQcXCGwMfOhuCRLAVWQLFHfqn/49yZ66Z/s1F5s?=
 =?us-ascii?Q?JGEeEduJoUOKIUH1ywD3ZKDbJ/CrgYRA1xWKh1WXJlRWOjbr5N6MQG06DC7P?=
 =?us-ascii?Q?4mxox8Ap+cemmrqFfdHZhjh82usm6ZPXkALnUhzi5IXQMEjZX4HIRGUp+/ky?=
 =?us-ascii?Q?EaOzm10dP6OMMWRUEMmn3Z84jQ4H8L15PJ5LBa+z0fF/955XyxGa9o1JPaYC?=
 =?us-ascii?Q?w3c8XGstMrk3MwV8vSE1b8f1Qy6abXTdiTzwvyPyCeARAuY/smojSz3Q+A0n?=
 =?us-ascii?Q?rMbmfC9yvLGQ/ulRj3AP4upKfTzTzRi8BWNqml6UxKwPnYZ27yA0sLJS/+O+?=
 =?us-ascii?Q?+45UsUDTcusFvyp66MUW/oeS7IbXaZ5FZg+8odXDrCilBoGO93WF43Awk49A?=
 =?us-ascii?Q?cz+iiwDHr5QoU7ntku8zUKBC01+AfsSzu/xR2C6dbH6oWzSE3Az8I6r9f9t3?=
 =?us-ascii?Q?rKwIPPt91/W/GiukUKNxm66MASfwAL1Az452+wJIY8wTYdGDU86KKAul4YyA?=
 =?us-ascii?Q?mR8ElpZd59A0SLBNl21zw2yvpwcKOCoroYGJzZHmEU+CxcqaAc7zU+4HZcIE?=
 =?us-ascii?Q?zPnFBHmgF6BnP9GqopDxllZ9LaEcMmNJW1R3+XR2vjvUwmzX6/E3B8wqMfCu?=
 =?us-ascii?Q?hcCPFiBXyepAMfyGnvXcf6/kH+BDpQlj74oZiwNFvBSdwn9br6XGaGJRmzFC?=
 =?us-ascii?Q?y/2riI60HGkg8bNYsMDaWdUGfPyRbKVDWMoIeN6Fy6yEmetF2JJfeTD2pifG?=
 =?us-ascii?Q?3GySQgqquccCL2pbrJyUmykOeY272JBY2x3/HRk7epza3cghs4/IkeVKWE9J?=
 =?us-ascii?Q?ubSMNCalw3vaJUduSSY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a27d496-0d15-48f2-daa3-08ddd416175a
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 11:49:10.3832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93bAsploI0QUVJcX5tUtv9czUGvKhb0Lv0ZPkCZAryTmZNv/0aRjz1aegrLfwZLo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5679

On Tue, Aug 05, 2025 at 09:47:18AM +0200, David Hildenbrand wrote:
> > There was discussion here[1] where David Hildenbrand and Jason
> > Gunthorpe suggested this should be in common code and I believe there
> > was some intent that this would get reused.  I took this as
> > endorsement from mm folks.  This can certainly be pulled back into
> > subsystem code.
> 
> Yeah, we ended up here after trying to go the folio-way first, but then
> realizing that code that called GUP shouldn't have to worry about
> folios, just to detect consecutive pages+PFNs.
> 
> I think this helper will can come in handy even in folio context.
> I recall pointing Joanne at it in different fuse context.

The scatterlist code should use it also, it is doing the same logic.

> The concern is rather false positives, meaning, you want consecutive
> PFNs (just like within a folio), but -- because the stars aligned --
> you get consecutive "struct page" that do not translate to consecutive PFNs.

I wonder if we can address that from the other side and prevent the
memory code from creating a bogus contiguous struct page in the first
place so that struct page contiguity directly reflects physical
contiguity?

Jason

