Return-Path: <kvm+bounces-52230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12884B02C15
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 19:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8529F3BC11A
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 17:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D79288C88;
	Sat, 12 Jul 2025 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rf6XbDoa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F56C2874E1;
	Sat, 12 Jul 2025 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752340108; cv=fail; b=N8G8pQiBQzjoZ9vxu2FScBDOAKvl731MU3Vrv6PKMUpTqeUTTZkTzIvxclDpBpwHM2EXnIqaxfTY3WJFu9pdd5/vm61eRH7NM0J609nxLI/oGyJGHm5nJQ+GRbGqeiE+kziavIypgxpghoAcO0CgWmKCf/tO5pM2bZ5cLMf/2T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752340108; c=relaxed/simple;
	bh=IXPmY7T6mdDt8wIAT6UhRLc9zbR6boswg3IPycRonGA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nhb6GhyI55T/wqsK1VSIXBo6uoiaG2YLuxy3Us4vHAxiFSjBRweDSmrm4AuLTdwpGZu0Wu+lYCyWJyCaHcyudKXQ5iLHKVOxrk/KI5i41dPHuQHShfEr/iZbQMD0jcxsmIhuCCAFdTDIxCY6oX+gnaGO7jkJ3Nk+0BdscYRKAk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rf6XbDoa; arc=fail smtp.client-ip=40.107.101.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dhvvKg9LDWrEtHcGoto2eQJysQodYZBiL6LrCHCO311Xd7RqVzwnrcKdWv2gSsBd1hESHNcRX5nOSlv9CBTjCJeHzVkFBgRh7oOuUoUpL9x5pvyDBQadspjxCW8axNfNhcJkNqtxyomuBfdio+3Gx0208f0WpejjRzQ8E0N13H12pkAAkxA0G/ikZbGh4a+I/NM8PnR+QoKJkHoxduDB/FW6tJtbUvW0Rm9f1tkyB4X8EP6ksLhiYXr/CicGxbFBud7NwtPkNZYP9Z5/lE191LvpPpRwI5EEIoNyH2JWov6FHzhxXmHyRIExoy50k4BRPo20cvi7TVE3zHWjF26wig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmsXsOcPampmJn90J6sq5flCn877xHCctUaeuWJfmog=;
 b=Ae+IUAdp1USN1ZYcaDqCliP0BoR2b9I4Qem9R8EqpV4tU0BFDkrDJhCIMJEvV19lQE2j87IbkydD/UFndpOPS5B/PLmwl7l3iTlAAEL23M11Acwok0qxOt+nEi8zNk/DSz4RvcyOPuD+atIklVqXENR9q0OktYRnHA7EJY76u89t5etWf1EHPoWZbKZyFGINBhHkNy6pZa8pW84fOzkwO2lQzg9FyVybV6862zkvngmC60nNtoBtRy4UNRHtBR6g474E7vhPYcEA5HEU9pPGFkJjLABnyuaB9XozgbebNEnVWju6kIm76PPHIZXiB5zM1lLLbOvrLpYQoavnno3kRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmsXsOcPampmJn90J6sq5flCn877xHCctUaeuWJfmog=;
 b=rf6XbDoabJW92WaGyvh0o/sQ/oWWrXCkVNxwgPswteRXGPXMNdXYIhvoVgWFpAZHmbNzFJ5SbckcPQWwXclNoYPNlxn+9CGCv5eckiRTum8sUQxg8HSLC8f+iTQNNEgxHr4wGPiJOrcZdIgaxYUuy2EZde/vDGEHTXfXixvGd3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ2PR12MB9210.namprd12.prod.outlook.com (2603:10b6:a03:561::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Sat, 12 Jul
 2025 17:08:23 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8901.024; Sat, 12 Jul 2025
 17:08:22 +0000
Message-ID: <e8483f20-b8ee-4369-ad00-0154ff05d10c@amd.com>
Date: Sat, 12 Jul 2025 22:38:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, kai.huang@intel.com
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
 <aG59lcEc3ZBq8aHZ@google.com> <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com>
 <20250712152123.GEaHJ9c16GcM5AGaNq@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250712152123.GEaHJ9c16GcM5AGaNq@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0060.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:274::6) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ2PR12MB9210:EE_
X-MS-Office365-Filtering-Correlation-Id: 65855f17-a88b-4caa-63e0-08ddc166b4ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmJHQXVhRURKZlhsQWE0ckl1T2MyWVhVeVo3OVgrZVM5Q250TlpobEZjcUlG?=
 =?utf-8?B?ajdKUE0yOEwwVjUvdVRDQ2VWWS92MGE4c3pzNnZWYkNmSXlJcjRTMTBXVGlD?=
 =?utf-8?B?a3JJclJ3T1IvRUZwRjQxbGgxcEtweE9xSjRyM2lteDdvN3kwV1F2cFROMjds?=
 =?utf-8?B?eUNQS1N1K1J1MlpoRERONmt2QldsNjJJN1lJdEowZ2QrS1R0V0VZY21hcEwr?=
 =?utf-8?B?bG5PdTEvOE5ZOG0ycS80RTR4d3hVd1JDbTVzdzJNRDZOcEJzQVpFcUYvWGUx?=
 =?utf-8?B?VXlRaStoTkJYLzZ4T1dEOTFLNGx0a01OUTVlMEgxa3JWWUVCbEdEY01FZHlQ?=
 =?utf-8?B?anRVWFJhOHl5Znh6SEp0WXdRb3B1dEluL1BOczRqb29JQ2FBUWUrS01tRklM?=
 =?utf-8?B?ZGF5ZE9FY05zckFpT213OFdMSVI5Q2JtMmdRVmxJSDkySzFjSmdJQUZ3aUtv?=
 =?utf-8?B?TXNYdmZsOUJTWkxlWEhRaVVlRW4zck54cVNFc1ZOc0NTRm5OV29nelNURmNm?=
 =?utf-8?B?bnJ6U2xvc2Y1ejVoa0FFU2drbjFlanpUNGJZMTNMQ1lKaXRPU3lhYXoyVWJH?=
 =?utf-8?B?U3hhNU1LNTlLZ1ZwdE9OVWVOWFBtYWNVSUpVcGN6QXQvWkU2ZVM4Qk5CUDFS?=
 =?utf-8?B?Y2xSMk9rRzk0bzUvSWhIVUsyOXVpNkJIODFzZlY4ZUxBVzNaRjBSTlloRTBp?=
 =?utf-8?B?YlhXZ2ppSTNWdGQ2dDdKUFB5Y1BkVEZIcVpGaUNSYlViM21YZnp4K2pKRkR4?=
 =?utf-8?B?YUkxOVVSQXRGdXV2M1J6S3dtUWQ0aUduVTVNa3FVY0pBa21JeXZKdXdqSWdN?=
 =?utf-8?B?TjBpajBxaG1kd3BVbGxEQVdvMjhaN2lwSXlLSTlWQnVGTGJTWXNhUkZISnNB?=
 =?utf-8?B?eTFEZ3IzTzRVa3VxTUhLcUk3dWZiL2o5OHZMSkVZNW56RURLd0pXaEVMMElP?=
 =?utf-8?B?MXlsYTZPZzFGNjIwQTdLRTdiU3NndDlYdXltNEZOZXVvQ1RnSTBaQVYzNzlz?=
 =?utf-8?B?eEFvenpHNmRJZ2tWNkRGS1ZGcWc5YTVxd0hiQUhHRXkxRmFUMXdNOE9DNVZ0?=
 =?utf-8?B?elNhcmkvZ2dHdUdmdFhqc0kxMkZialJEOUJyY1VhUmorQXllNHJvNHBBQyt2?=
 =?utf-8?B?TUR3YVUydzB1eVZzQnZrZll3eVJkSnRyVUpkeEUrNGs5cE5RZE1aZjJxN3Bt?=
 =?utf-8?B?bGhhYmg4ajZMQ3p5eVJ2WWZEWW9KNC94NEhvS3BBcDBGdHJ3aXdDVU8vOHla?=
 =?utf-8?B?ZmhUTGw1UGNJODdDMXRld1ZmV0hySVNjdk1ZY1BCaUVhWlJZRHd1WjI4WXBp?=
 =?utf-8?B?MjlNZnRhU3RibElNd040dWxtcVJLSm42a2hLWWhnRjZRN09YUWd0Y3Byb0ow?=
 =?utf-8?B?QVdTZUNkTmE5QTVnMDJtdEJjcUFEY29idlFuZXJGbjZZaE85OXJKTFdlbDcr?=
 =?utf-8?B?T2d5UkJLSVphSGNwR09NeXpYRG4za2NNT2kwZnk2K0M4YjFJbnRrbW9lWjFV?=
 =?utf-8?B?dE15UzRGd0w4bGhQMWJwb3RmTTNEc1lWSm1iQTQ2Q2RKOERLcHd4cjFldDhy?=
 =?utf-8?B?OVZVQTg4dVBCaDlBemdXaVBJTkdOTHRPMUlnQ1lNdERnSkZDOVhGYTNrUlZU?=
 =?utf-8?B?clJ6aHA5UjF3L01wTVA0dmM3dHdMUUd0Y2NuTW5nSkhRTndmMHd0YnRzZWIr?=
 =?utf-8?B?eGZ3VzlXOVIvckZZd2libFdMR0hLT0FBY0hHanN6WlI5YVNJZ2JrWmJleDIx?=
 =?utf-8?B?Q3lwTmNZai9KVEhqc3BEN2p5Q2NQSkVwMTlBSEoxNWQvN2F0Nlp4S0xyalZu?=
 =?utf-8?B?NGRDV1F2cHRSZzRoUEN1UmF0d1pFd0N2ZkUzME04YVREMW5iUUVHQm14Ymtj?=
 =?utf-8?B?SHkxaGM0N21aeW1DYXZXSmttWVlBZlpNNjBVS2pNWjcxMVhFSHRBQUhiNnRV?=
 =?utf-8?Q?ORE8GIFUpDo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXhhWmFsTy9VeWZGVXhoWCtpOUkxSkZWb20xZ25aQ1pGTXlNU3JwTjZXclV4?=
 =?utf-8?B?UlZ5dEtCMDRTVUFlNGZMSm4vY0FRUFZCQzhpT3lFT1FJMGI4ZGN2eGZHV2pX?=
 =?utf-8?B?MFptemxZRExacDdURktndHdNZy9LeU5Da1hkdWVuYTBIYk95dnJKL21Va0FC?=
 =?utf-8?B?NGRJN0Q5K092RklqOGp0cFhkczI5bnZMeWNtd0pNRytBc0tZbEw2bWhXYzI5?=
 =?utf-8?B?R2lXb2M4SGtzUTRXMjVURXc0dDFXVkJ1MlZiWXhsQnJhTjBtUWd3SjlMMWtv?=
 =?utf-8?B?MGp6Rmkza09ldGlNUWE4YkJkamxad0pweUt6MzNXb1NMWWJxcnU3UWlqbEZi?=
 =?utf-8?B?blNuZDJqVXk0OUcwMGhacUl6WnBLaDhJNExqY3RJbmwrYU9RVWttdUJOKzVF?=
 =?utf-8?B?Ty9EZTNRa0VyemV5UEZHVTl2UXVmRzN4bEJZR1ZrL3I3MElaWVBZUU1YbUJF?=
 =?utf-8?B?ZFQvenV4RGQrbUZYSGEvQ1FoTVg0WUpnNUZHeGtqM3pEYmhHdUlESzlZT3l5?=
 =?utf-8?B?K3lOSHk0Zmp3ZzY3YUgzY0JsSm0wcnorUVNRUVZnOUl6aEhjUWY3RjU4VFFV?=
 =?utf-8?B?dzM3YjRsVE1XdGJaNHk3V01rNnV1dVU1M2hPT2lhckxJMEVXWm9PTDhTSlVL?=
 =?utf-8?B?aFpiYjNWTGxOZDloeGp2eUorT0VGSWxrc2dZU24wKzZ5b3ZmSEQ3ZkJkb2F6?=
 =?utf-8?B?Ui9pcDlscHZIWjBmd2VmZ2VvTVh3Vk9WUzBQVEplWUJ1V0pzaWhidTFsTi9Z?=
 =?utf-8?B?S0xkUTJXUmNZc1dXRFlUKzlMUmFSV3R2eXI2QUdKaFJFUW9TeVhtQnIwVUFo?=
 =?utf-8?B?eFRtdG12N0R6anlBUHdhUkNaaWRZY2xaWEZzUXlldFMrcHh4YXFmdnNEbHR2?=
 =?utf-8?B?MzR5UGtRRlBGcUxHYWlVQy94NXkzOW51QVNCeEt0YkxuVk9wRXgvMkE3OGJn?=
 =?utf-8?B?dFI5Q3hFMlZ3YkpCRmo3OU80TlBmRS9wVEMwWkR0dzFVM2VTLzEyb2pZRkFy?=
 =?utf-8?B?bmkzdzRIdURNTjBUWTdoSlliNHNlSWw2SGcvRnRXcFhGaHdXd1cvNnlLS1Q1?=
 =?utf-8?B?U0xLS1BQMmFsYUJxWWI0WFA1c0ljNUlqekZXZU1OQTBGRHRyVFlFTG1yYnZ5?=
 =?utf-8?B?aFpBMmhkMEo3WjFhSVp6bDNmeXRyN0dTNzF5NDVKRFRwUkswNy9mbUNQaE91?=
 =?utf-8?B?c3dSRDd0VjRnSlJrVHBpcS9iQUZ1ak01TmRPVkdZM0JwQjNJUU1FejBBS2VH?=
 =?utf-8?B?K1d4OHM3dXovREJud2doWmh1RmxZQU9Dc0dTVkcrSzJ0ejNkQXdSNVJ6L3ls?=
 =?utf-8?B?VDJYWlJpN3QxYUdPb0xSSTNFcGpnNk4xaE5UQU5McXVOZHErblVNQWRQUUFV?=
 =?utf-8?B?dDNjMnVqRGhDWWFsRkQ4dXVvUkY2enJKOVFFczBoV2FNaXE4elFTOHhDd3pi?=
 =?utf-8?B?bEM2YWxEcHpWTlh3dnluRzJEM3lmUld5cTV2VEFpK2xQR1JaQS9PRHVqRXdj?=
 =?utf-8?B?U2IyOCsxdGFQeTBScGoraU5wN0dHQmhoNzNOZHhRems1S2diekZqVElvTjZF?=
 =?utf-8?B?bkRORWtmdFdLWjc5TXNER05kY2NPMVQzUUlTZDBUTEdWZyt4RkFGek5FZllE?=
 =?utf-8?B?aVcyQ2t5NTYvd3llL0FmLy9RMGxXZ2pESmtzaUlKYW1iZmwvbG8wY2ZPYWZ4?=
 =?utf-8?B?d1RzcGtITWV3VDZheVNxV3ozOWtGRXE4eklKUUpPSStFeFZsMGNvUVpaUFcx?=
 =?utf-8?B?a3dBUWVMb2drWDF6UHRkTk9Xd2FlREE3OTBYWk5MeU5sc2Vmd0hyVGN2ci9N?=
 =?utf-8?B?elZHUWJCQU5qV1E4VWFkRmhHaWpCcllDYmxZVUFvU0FEN0VYV1dyUWxiNXli?=
 =?utf-8?B?b2t5S3p6dW9sKzNncmRJVTR2VzFQajZIa3psWm9GcHZLYzR5ek0xS25HbnA1?=
 =?utf-8?B?ZldvbGZXT09nNkJYMHNGMkYxeWlYa3VnWHZDazRlckJGc0FZQjd5VEYyQW8r?=
 =?utf-8?B?aXlDU3JTclZYajBVOWhNdW9NMktTb3lKdmU5M1J3NnF6cG80bXlPOGNDajBy?=
 =?utf-8?B?enZBNkFIdnNSOWV4elorV2xtaGpBTVgxcXU3c3NKNndXbm1GYXJPV3BlYVIv?=
 =?utf-8?Q?jG7SuNhWEldOnhBUZzmWju8r2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65855f17-a88b-4caa-63e0-08ddc166b4ef
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2025 17:08:22.5233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JT35izvzriqlPmX8uwwAf8E7ZX+9sMQCHcjM63h14D06iXNxQj+k3yTARQP1UgNqNcApJuejlNLVUCkIahrgMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9210



On 7/12/2025 8:51 PM, Borislav Petkov wrote:
> On Thu, Jul 10, 2025 at 09:13:11AM +0530, Neeraj Upadhyay wrote:
>>     struct secure_apic_page {
>> 	u8 *regs[PAGE_SIZE];
>>     } __aligned(PAGE_SIZE);
>>
>>
>> to
>>
>>     struct secure_apic_page {
> 
> secure_apic_page or secure_aVic_page?
>

In v8, the struct was named "apic_page". Sean's suggested to use "secure_apic_page"
to avoid name conflicts with other apic code. APM calls it "guest APIC backing page" -
guest-owned page containing APIC state.
 
> I mean, what is a secure APIC?
> 

It was more to imply like secure APIC-page rather than Secure-APIC page. I will change
it to secure_avic_page or savic_apic_page, if one of these looks cleaner. Please suggest.


- Neeraj




