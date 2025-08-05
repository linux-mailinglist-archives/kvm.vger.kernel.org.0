Return-Path: <kvm+bounces-53985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23BBEB1B392
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3032417B507
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B2727144B;
	Tue,  5 Aug 2025 12:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mLI0fRxf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030AE270579;
	Tue,  5 Aug 2025 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754397549; cv=fail; b=n56bzeHF3H89idcVKhT+ellwTt8OyWIv6JgggUaMLaXJGZ3JtD0f/yCDS6KruZOhzshd58J0zeICmpxj4LS5YGv2ki6D8+pJMmDCUjCUDiLG8d4Jb/aibdFW86g9uZgV2XBksG2WpnXJnOJ4ov5bvKRtKlNzXTcqAfXd3ugZTeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754397549; c=relaxed/simple;
	bh=t0KlbcqL785b9Us34gDkQAu3uRQqrLb9Azq7xD865/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JBnVR3K4pi+R9Q1icrDQVwoWlgvjM+QUVTHMiiizf9Xhxcmyz7iVuY/BBtJenxd9zqbLfpLtzxX4uBtwZsACWq1VUVYvzl7siYfGMgDlgALlda97LD4VYCZ+DDfU7i97esahzaxFLcyEAl5fvdlkkvFBRl8uGBbjpaUHrrfWXTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mLI0fRxf; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTP6SFcHeHZsBlI40kHiQvZ+OilFfmPDnv4a+c6y+pC+9xw3e+f5Ejd1n5VdhccORN3pMmENACmKAGvGcWJ4f6BtFJHXukrOcwmjPhxhTXp5rmmfTqKtSwOSqPiHqhJsBZMD7sgpncCNGx9PjqLbLbgiUFXs2ugH+C2qfcYKWjMuYItW5XYev0VXii8wd9nWJEFm8Qmwey5zFfDG75HmViTRf7YnuerE+weiHknOA7THCxN5zk0e3LJbpOTB6OtoeT8JyCruM08gKbr7D+qCzcAnMuoI4nsgeXimsSYYHEBtFlIYoGX6weKz6dyb2ejGw+YhKnTcbGKwUGQ1huvfnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0KlbcqL785b9Us34gDkQAu3uRQqrLb9Azq7xD865/U=;
 b=Lrn4kni3NJkZAJkvTZMd5SnSAor867aD0YPELpsCShwya3oQCoQnyPZqUV1C49JsHoSjCyN4LWmtfpYN8BFOJoXDNlNErC5YPm3MUtynPBssHpOvKSqaBxdvARwrt0nvg0Fa+eHUVT68/Bz6xV4nxCRnqyAhK5Y1pSRGt3ErX9bWh4Uz4fhEMsAffX3abvgVba25osGTtbGQu8Z74jSb+buHhpqKl95ZMY8rJVFCwFOFDcCRhMsnWlHOsxaywg9MkfNBUOs3bJMuDd9rZPL7hTiiKPCeRmuxyOhlQ66vDrMCMLMQ+UG5+CUhycp56Wq2yj27IH3+39nQaxVGTbsUKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0KlbcqL785b9Us34gDkQAu3uRQqrLb9Azq7xD865/U=;
 b=mLI0fRxfAPFZGqTdvl2wvZYTdHBLsSTLPs1pqQa+W1WinFXhryeSOkVXswE391qNoB9uGRZyGLearQwtnmTbWJZZrulG66H2geE+VWY/V8EP8vgM3xouqBCUQ1qfiAXNmbV1e5W6wLvkKpuVCgt2nVgB+YIBXmc59DjOmNVJrZiQFPBU47NKWW105WrdA8+p9sFvvTv53vkjmQbhQBOa3+5pANQbFxj79SCgS768y6QkDANI09/jShsmESBOimfnkr5F5LlzP4n56wgg0uNx0vR6C/XE/n7RW91Pnbbpqmc5MeHc/GUzsKH/PgUApliXzAvRx+HA3Lp9I2G/5YC5zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB8196.namprd12.prod.outlook.com (2603:10b6:930:78::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Tue, 5 Aug
 2025 12:39:03 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 12:39:03 +0000
Date: Tue, 5 Aug 2025 09:38:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805123858.GJ184255@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <20250805114908.GE184255@nvidia.com>
 <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b447a66-7dcb-442b-9d45-f0b14688aa8c@redhat.com>
X-ClientProxiedBy: YT4PR01CA0166.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB8196:EE_
X-MS-Office365-Filtering-Correlation-Id: 88a8c1d8-62ba-48a2-2152-08ddd41d0cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+hf0s71/ua/dKdd4cXqLbbChsHCYgdJYtVmOIwmVuMv11/nafXL+mohqWYMH?=
 =?us-ascii?Q?lr0IlOS4qgwBnGR8RU5GS0eiEGM2ElbPenhzgvjYMgLEBfVlnu8ZVNQ3C9z3?=
 =?us-ascii?Q?j6DigKcr6nZntnD9Ct2zQ/yqRiU6KB//LQ0LTTkPoZTlyGH/0ryoGVC4CKtk?=
 =?us-ascii?Q?V8drHUSyibsSE6VrS19T5gzZGkOLG1YSAS7zmaLhEkjAqDHm+jzH1YdRlI68?=
 =?us-ascii?Q?R+nmOjydHOnbPm+YpBw8jIoE6TaNpGy6IRhDoCEWCDz85ilVNUDPg093PO67?=
 =?us-ascii?Q?rla+74FwCRzY8Qo0d2ScZ0xat3K+LfrcUEK+/eriFssnwho+2Zrbuhw6R4i2?=
 =?us-ascii?Q?DBM+i+NugAouzn2znScDQkJyiHvOqPyVjOtv0OcXKH3ct3ezFc+Vfa0yoYDu?=
 =?us-ascii?Q?Qx9ZHbs7P2ZiJwsuN0W3HDB6NtGAxGw1gNyl+ViM1Zs7N4ht+Aa1uOWy3WYN?=
 =?us-ascii?Q?KROVlwN4rXwZQvSMH8aDWpDlMUiaBVNQB5NpBet4cLwR9L3kFF/Wl2Ven5uG?=
 =?us-ascii?Q?j7JwQafC7SJ0fYOULHO0Opv28NoDSJ+AAL3Aa+I9ImBVb7gn1seJ2thX5JF+?=
 =?us-ascii?Q?ofaoM3NoxyeBD4Af9vArVkqdVgH795CgSLTf7QfJ01eOH9AJ1zW+UpGSYkWw?=
 =?us-ascii?Q?CN8qi21/y4x11SOpQJqFNx7XAK2PCoTeKut8IaNZ0eBcES1VficHGdA5Fq6l?=
 =?us-ascii?Q?2oFuEJgS9njjaqkOS5d51yq8+v8gP/kWe2a8IHvcWO1v+ROIAc4Wmro75Uar?=
 =?us-ascii?Q?y0D9FjzyRpIoIPv9Xfmcvf5poIG/DuCVKS3pF9XO0BncO2aBhuDzvyW0ROM6?=
 =?us-ascii?Q?g8liAcv4uI+7Y2Bs44XJzJyDYEix0JLLltZUPORu+9XHcXhTmNxnE8QOYU19?=
 =?us-ascii?Q?j4KDizvf7WVUdOUaOQCVT8zTSD3sFNqeVdkPyilVZPX5um+T8JA1tmCaFpfw?=
 =?us-ascii?Q?3Zye3TP2CGbZNa6HvvQ0JcQXmis1Bg3ZOm/L6ho13Ab1fh0p039Tpf2s3SE0?=
 =?us-ascii?Q?QQAJRlB6okCgOAisSa55S6SjRYtfgck5x9eMX3ihocDeAYAuKN1nMZmQgOdt?=
 =?us-ascii?Q?DHfTV8xRXSs6vsBvatfmjrRahnoZGaPUMTqFBrS9opyg2YQsURQo9XqLX19+?=
 =?us-ascii?Q?OmyeoUTPVLWGrntlwCSTapQhkBvnBGf7gFsD63nhN3qy6/MREzWFOMarvrZ9?=
 =?us-ascii?Q?Mb88t8h0w9qUqUCpHILTjUYGPIGpR4bfNY0G37/ocfCcMhZ6YsuU1H9Lrmfz?=
 =?us-ascii?Q?/3kjz5kvuP+/WnpQoeBomWdRaecoaJcKoDGX07FSqhM31KTTocwomRnIbncP?=
 =?us-ascii?Q?LjD49c8of6sAACR5zjHbnIOx2GWgQdGqQ+6Au1PORSog8yOj8+8hyh9hcJCy?=
 =?us-ascii?Q?Jqwi1M0QoL7sFGAmhqJwI/Dti1hHPPYP+UIc+4uBhuzv20uZVMRPCG0aYp1E?=
 =?us-ascii?Q?eTHWaHrxHRQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mZZVGEtuj/ilgwbGOFkD/xMgF7BVxTn8eaiyr986vwcSMwKsL6r9uOPB/LQq?=
 =?us-ascii?Q?XyF2I2KDkA9QKWRHmjeyYarvNRvM5FYY1HyOKuNtTUp4b7rnd5ZY2JsM6kBv?=
 =?us-ascii?Q?osyvsb54owYTprCsgsqLuFixdCbsDZNqf3X9m6udrTMLNaO+VKXXnriqi+k4?=
 =?us-ascii?Q?x0QeisDrbluUbvpUi6rND5fD8JeQJnihC/sRa/+aRqhcYPRwxQ3bJ90U9WW9?=
 =?us-ascii?Q?qCbgnZ4meZKB9kRk825FWsrIGDR3ICXxGrUA/GNLnidtuun0KYEPNEW1xzXM?=
 =?us-ascii?Q?UJW7Lq6miFGe5B476st3W9EWtnfYJW5Cf1lSoX67GDYBBIYZJ3aHiaWpgxOq?=
 =?us-ascii?Q?jeUokgQu0j/q2wz0A2S1BEl7mZobYphgO9ug+6fFgEDfIswwP29WY3NLsXUW?=
 =?us-ascii?Q?hQdWGWFBQU0vswCvc1pNXQEr3YRdKSFE81oLfvd6bjthu75NJaTHaomB3Osl?=
 =?us-ascii?Q?KmtWyc/GkraTIjG/ZFoHiW0aSVnxuHwxVrO8hV55YFLWQDcnjBx2ZtbRyY8i?=
 =?us-ascii?Q?vUjXDO06I/roBYOolmIsWqxOT+46LBfw7+AVNHr5usPkFn6aCZStQw/3qtTl?=
 =?us-ascii?Q?thxzHwgBuzdr7n7F4Wov7aPM5XcEL6fw8GLqicDd1Bk8a5oekXnD/0bafUdI?=
 =?us-ascii?Q?ytuxRnX1VCjjxgmkp2kg1AU/vlGrTZl07lmaXwsKxZ4JEPZ0yEskSr65mrqq?=
 =?us-ascii?Q?+aPIdKro6rNwQiVIpOBG9ZOKNwxdgwYTOy8k7bWHZZoU/sRrPMF7ODUgHNu0?=
 =?us-ascii?Q?o3vtomd/xVNmbbkeZgmirD1lGs0pqlmT55S9naED/cBvlwioMkjxjPuItDbN?=
 =?us-ascii?Q?ONyS8dugplWE2kmzfQNYhnqmkHQF8O9He0qKOJ13N/UTFAoMMSVeR04Y0sE1?=
 =?us-ascii?Q?ZVKU5yUrvlta8J3WgGPYOKrkeWUv4fZV2txx21+N05e+uWLZz8W+MN37AVpK?=
 =?us-ascii?Q?71WEMFMtg/Yd9u6JhwzeiPf5BGFLzdOYFBQutAfEYOXqvZQaic+B0rf5RFhT?=
 =?us-ascii?Q?hyhafoT6qTVL7caIAg3dtGUQZ4esbO0tcXVd5NLRhJ8qp5WhBNfr1GOFc1wI?=
 =?us-ascii?Q?5d+VuGwtG6C8Ux026ZONnEUhWH3ucRzuhVC45fUMUWV2blgqXayDmcDuJ1sn?=
 =?us-ascii?Q?uSrgc9qzCrJvP0d2q85bY5EtQzcOhiGTgDsbpV1OFDFOfHYVlLNtp+ikD7kN?=
 =?us-ascii?Q?r81zDZ0e4S+ijPw+M6DFbDbI4cV4qcMcU90kSMOvygNd4lA/pV23n8JG11fS?=
 =?us-ascii?Q?ySUf4GK63guiEz6vkw9iGxOvi/KT/xiOXp9mHtBOaVOxNRrjTJ43LvlOKyYM?=
 =?us-ascii?Q?/Bk/urAIiwhKMTfBXrpmCVcQiArqIh2x2xD7XXsZFja6Ion54iHAqtLl79Y7?=
 =?us-ascii?Q?w2qwqIKBdWAvepPQon2PSdpaDSQBiBSkaM61CwJCAR8TELMft3FmfF7RruGi?=
 =?us-ascii?Q?nQibEZ61k8PTzfcvhgAxFGXQXnEE2eQ+ZoTEaTXCCXSo6v03xMqlnnLW5ESD?=
 =?us-ascii?Q?U8nSguWy8KObaCtRR51Gwv4V0UHxl2gHrKPBplkIyIlhaStHjW/pycWpT2fO?=
 =?us-ascii?Q?YacpquXPjXvrHwLGHRc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a8c1d8-62ba-48a2-2152-08ddd41d0cec
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 12:39:03.1548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjMFKArspUGziC8AbRVGvag0inS+v3oYmGl4KzgbU6tn49xWHMxKRK3i7cDTci/D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8196

On Tue, Aug 05, 2025 at 02:07:49PM +0200, David Hildenbrand wrote:
> I don't see an easy way to guarantee that. E.g., populate_section_memmap
> really just does a kvmalloc_node() and
> __populate_section_memmap()->memmap_alloc() a memblock_alloc().

Well, it is really easy, if you do the kvmalloc_node and you get the
single unwanted struct page value, then call it again and free the
first one. The second call is guarenteed to not return the unwanted
value because the first call has it allocated.

Jason

