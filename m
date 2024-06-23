Return-Path: <kvm+bounces-20341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1BF913CAC
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 18:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC4F61F229BA
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 16:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DC21822FF;
	Sun, 23 Jun 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cf6PM0uw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C841822DA;
	Sun, 23 Jun 2024 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719159383; cv=fail; b=RHQkv4+ehPE7ylCldf7A8DrG3XlgKdig4jbzcJ4yoETMsc4qnLPBs6Uou3YEXatDju4oD9NHIHfl/GT+waVGFg4tbeC7ZJ0C3h4pArnr9bcwtl9HgMI3G5LdLMkDhCDdl/xOwJVwMajiYPSSbJjfbwK/VeEQ16U8DyOxP3iH5Dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719159383; c=relaxed/simple;
	bh=ZJSq0THISZL+NogMmgVOip2KNPOa6fLhc4fkIRItZy8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XwnnAogkpZpcMhXMQcc2EJ1UJSV4L48AxwHBdD7gt53i9kA/ldEOeAEjtvIH0BkV2fa6+esSh+W1kJz2hx3EciSn3cYf2vSzcD0cLTJiEOI2ZDlcLXL0WQGIKix5Sfy5Q3FHraBFKKUIgLwrlD5IkWuM1u7o6pkQf0QvCCcFJwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cf6PM0uw; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7m+RuE+QelZuiPMGd0pjsOGkO72zJ3jGt4j/mWQhLCPY3ge/7/glPfih5FKKlOfE4D+rQqNBddR7aFTXChd/dv05anTv59OR4t32HR0EjkWodUMKo4gev6r7scMzOI2/XMbI6BeUQ4LUXaMnsdAwtvDvmCPa3uDbafU37ENs98r9lpSBLivFC1P0+fEFkBMs/+GcL0BFdqnM1fKIlRvT/xly5wnd8ygeqLUj5CAM2Gbvxbvj7YlN0+fE8OGFP26suX/ZH9pDWFTh99m5aNA4sD2eo65jsBDHhIx6CT7wieAfyD59pqQA0mHLW2K46upmbCEzEErD0+PCdoSLuGFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OR8zwZPumkCXdb6O180U890fExttZrH7bRUEKGNWFmE=;
 b=dvCr1oq03oQW9DyrIQH2/Q5JRoWybnE7KLYgD6ByDNivXBw44/agit6gX4mdas/6MM1zITH1yDpNJlzXnMYlttfZUk3DRjJHRmiJJFvrkXQ+x1w3Ln8RGrc++EVmMHQ3RehUXHPtyjlX+vY8SGtX/7VV/2F4y+rmnQ8m0BrNlIqGOepmWH06EKMMaguhJhCH+NX6E6PSAaiXNlPYpKswi3QJ3UtwDno91DygwNRCu29DCn2sQzrfgXj9MvRDZHCQXG0fYsIm6cqTyKx3UAuJmjszb5LcjOFFGRyn7toleVhp59tEIPTGedIz4/9sqXJoAFhW6MfZVgiwQD/Bi7WJYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OR8zwZPumkCXdb6O180U890fExttZrH7bRUEKGNWFmE=;
 b=cf6PM0uwJw3xJI8gDiyTyOzrUjI1CyhhcVlJTIMeuohVxUCmHhlNqxOtsaByIf0qRtGbhtiqKQ4xV+ew6ug+ivMhJS5+WklKWzfotxYzRurcmMoPX5yim91z4YdGR/5y5ILYlDmny+C37JUPeyTlsADiozUFL88UVisp1eStIxw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Sun, 23 Jun
 2024 16:16:18 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7698.025; Sun, 23 Jun 2024
 16:16:18 +0000
Message-ID: <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
Date: Sun, 23 Jun 2024 21:46:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::16) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ2PR12MB9161:EE_
X-MS-Office365-Filtering-Correlation-Id: 41e25815-c9fd-49cd-0175-08dc939fcf6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011|7416011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFBhNzQrN2NEbnprWmNDVzkyR2M3WHRVczdtZ3dxWGtwR3FYMk5SNEtHeVYv?=
 =?utf-8?B?TmI2SzdaanZrSnRod0Rrc1VNVjB3aWlqSHBFVWFUZzZITmxCM0I2NlZxakYz?=
 =?utf-8?B?RjcrR2dNUXlWOHZ5a0RMdmtXRU5XSDhxdTNyRGkybDZlZlRzWHNJMUtRUGI3?=
 =?utf-8?B?My92QVlNRERHcVBEZHFRb0FrN0VyaG5nNUJZV2FJdVZGZlBBUnNqTnRiUE5p?=
 =?utf-8?B?a0loVVpTa2VYUkdzNmtucmtGY3RMTlRKa2ZNOEl2QUdsd2VZMC9Nb0s1N3lI?=
 =?utf-8?B?bUJXSm9GdTZEVGpGUFZwOVEvcm5tZ1JDZ24zMWtRbU40UlBITEVMenp0ck5v?=
 =?utf-8?B?S1RvOG9Xd0hhQ1FTUnBpYlNjRElXQ3dkOVlneExOOGt3dTB0Szg1UnVRRk5m?=
 =?utf-8?B?NDZVK244VEdiYUZ2VGlpNzd4VkZiQW44UzNnVzd6MkZPdmFQam1laURJdFU2?=
 =?utf-8?B?YnFOUVFaNlM4MENZYlNPMXZ0VTJTVm00dURSUU92T1NWUjdVNlhIZ0hiMlhD?=
 =?utf-8?B?NEhQU2Y1NE94RW5FRzQzck9zUjhSamlpOHY4aDAxd0x6SVl4Wm1nMVRnSjRY?=
 =?utf-8?B?RkFXcm14NjZBK05JNHNwK0FNYWJxdnFrVklsR2hDS3FINTgrdC9kS2t6dnZl?=
 =?utf-8?B?aVZRWGNwMlp0a0F6VFVmb3I3U0kvUjZ6dlJLYlJPVUtBV2ZRbStzVmptMVpU?=
 =?utf-8?B?YURSS0RScmZabHpKeElwWG4reTZBcWZEUW1kUUNhZE15RWZLNllmWEVlUTYz?=
 =?utf-8?B?WmlFS3BMcHpYeUtsVEVlUFRheEs4citBTFB6VE96dy9GdU16RzY3d3dMTXAv?=
 =?utf-8?B?dGlSbzB5OEFmT0hscFhDbUpPdzVMRXF3SFdPZHFFSlpWY2JMcHNPT0FyU20w?=
 =?utf-8?B?Nit4U2N5QTB0ZXlNZ1RQWjVMdFVLeXpMRTd5N0tGczk0SGw3d21WL2wzakhj?=
 =?utf-8?B?ekZXOXE4eCtoRmZtVFNpSno1bWhVS0Y0MzFTa0E4VmVKc2tZeXFwYkRXdElX?=
 =?utf-8?B?Q3VEcG5jcnM3ZnhPVm90Mm53Y29IR0ZsSmhwTWFER08wZDBicFlYTlcyWDRN?=
 =?utf-8?B?R08rb1E0Y1NtdTNreDdVY1BYdVFmb2F3dWFXeVhsYTdlUllNUG9jTk5hanNB?=
 =?utf-8?B?aXRuTGNrNmF2SDVROWMvdFlXSEh4NUFUMkEvNzhZU0N3VDJXRjBWRlkyTk8y?=
 =?utf-8?B?M1daK1NwbzdKL1FqVHE3di84b3JlSVBTS3A0Z2M4RVNWTy9UaElmQzVFajBw?=
 =?utf-8?B?YW5tOE5OTEtHRTNZaUk0UVBWU0J1NHhzUWlOQzBublRwZ3ZKQ2c1a3lDb0NS?=
 =?utf-8?B?WG5FQk5tdEYvYTNZcmFHSldzMUlHZjhuMDlEakgwOCt6a0F3RVo0SWprVUU0?=
 =?utf-8?B?K096OVZJRFB1YlhUTnBhQ0xVbW5NZTJ0Q1ZlcDZsRVZ3eDR3aXZwRlNjZlUr?=
 =?utf-8?B?UC92TmpiY2hJZkhRdnZoY1hoQk5mYzNVeC9McFd6NmpCTE1iVUhCZ21HNm1H?=
 =?utf-8?B?Q0RVZDUxNmFjbDFpbDJOeXJoYVh3alUxSGxoMVZYM0QvanZNc096bDNaQmdX?=
 =?utf-8?B?akJlMkR1MVZBdkVxcURSTXpLQ0ZTTEVNdlpwUVRaNHhXdW40dnlXSStGRGwz?=
 =?utf-8?B?QzNqbXpWQTliNEtKOTlOemUzWWNsN2Q5TklMMHRobm5nOVBVUmJ1TTdGMlRo?=
 =?utf-8?B?dVlkZTNXejVYZjI1TkluY2JxQlc4SWRqT0JSWFQ1bE1nS3REYlZwc05zT3Yv?=
 =?utf-8?Q?z/rgkKOclBUO2m+qJg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czhOUUdMOGloS1AxUldDRzlqQzlVUDRWOTNhRnFBMzI3VVpHREUybG1FaERG?=
 =?utf-8?B?TnQ4VWJ2NHJHclQ2eUFtdDY2R2tKYjZXQ0ZqRWZXUFdEVjZSdTEzaDlNWW1x?=
 =?utf-8?B?U0lieUVWVnJ0VWFIL2VNZTdHY1U4OHhoWkpiUGc1ZmFCRktGS29EMWpHN3Y5?=
 =?utf-8?B?MWozRXNQTjlhUnlmaWYrM1BqNVQrMmJXLzdCYmZaOFNHTTE4VDA5RnBZR0xq?=
 =?utf-8?B?U0V3YmtwTi94TStVOTZzaU1mT1hlUUNFTjFDbGZhM1dEbW1KeFZpS2dTOTRx?=
 =?utf-8?B?YWNFRU8yTnFNUjl0TnRsWDRmTjNmTnVBTkhaazIwZDV0ak1MSmhhQkpBSUNN?=
 =?utf-8?B?U1VvNVNWcXJsZ1M4VG1FZFpIVU13aUdwSjZIMjZKMWRNU2pSK29PSVkrY29H?=
 =?utf-8?B?Um52aSs2MTRmclNFS21SMW03a2lWNUg0ZVdYQ0ZBMy9QNDh1aEZlNm4rQmw3?=
 =?utf-8?B?eDU1a2RzaTJPdWxYOFMydWFjRnQ0L1o4cWdYTkIvMTlSRStxRHllOHBlVk5Z?=
 =?utf-8?B?K1FYZjhFakZmVEtzTGUvOTBneXc4N2cwazRmUGl2YTdYTWhwWXlldEFCVVBI?=
 =?utf-8?B?b2p4dHpVMkphcEpuNnhQZlJLNSs3Nkh3aXJGaFV5NUloYXhLMHBxcmpyb0tw?=
 =?utf-8?B?SG5YTWE4WFJlSjRDUG9WYlhRNWVCZnJiTGZ6c2NwWUZrdE01ZHBYQlFSaVBR?=
 =?utf-8?B?VmVrUFBCYllkR2hCZWk5T3R1bnF3L2IzVHNSY1NzcjM4M2ZIb0FTM3gyTXJn?=
 =?utf-8?B?Qi9ZY1FMUnBtQkRKSDYxQ2w1WXJwbWwwVHBBaG1GZ1c3RWxIaDVZQ1YrT1R3?=
 =?utf-8?B?eWFuK1V2N2VlUkJHZGhoNm0waU9BbHBXcUw3U3gwK1lEamQwcUVEdGJkVzBj?=
 =?utf-8?B?Rmh3TkYxR2xXMTl6eW5sWll6T3V3QzFnWFlTVG9SbTBXQjVQUXdXeGZib1po?=
 =?utf-8?B?WXVKeFp3WFd0Y0QwdWxJWmI2K29DdnhmY0hQcWhmamx0V1JrcmdsWndsNGtQ?=
 =?utf-8?B?Y2VLamovVWp4RHVlZEl5NzhXaDQzWm4wQXZZa3puRUFrM2VSRkJPa1hJVGZM?=
 =?utf-8?B?UHNLa2kxWTU4SGd1c1pmdVVKQ0g2QWZ1UThSQlAwRGRMZkhKVklYK3lBM2Mx?=
 =?utf-8?B?SnpyLy9EN0F3OVA2b1pENVQzVUZxb1lwU01TVk44UHUzWVgrZUNUY3VMOGlo?=
 =?utf-8?B?MzBTZitzTCtiNkQvbUlSSUx1dUU4aG9qdW0wUUJBM21acWh5eWU2TzRUS0lF?=
 =?utf-8?B?S0VlM210L0ZHMjV6TTc5TWNZVWNhMHIvenh3eVk2a29aRW1Fa2h5M3hGN1pG?=
 =?utf-8?B?VlkrYnFJUkxEbDZLU29YM0FFMjIvR1FaMHZKcjJOelowQWl6eW5hdVR4MG1X?=
 =?utf-8?B?WFFjUUpWSHVJT3B6d3JmQ2Rod1RLczROOXNhbkxmcmNjTm5oYkNhckhUMlFR?=
 =?utf-8?B?MjdkWHBvQ1pqSHdUZnk5Ui92aytMeHBtOW10elJCQTBDRVhybUxUUjk2ejVD?=
 =?utf-8?B?cmowWlFhajRaYUNJNUZUTmpHeEVlbDdCQitFRDB2ZmNrWTZvT0FaYVpXaXFL?=
 =?utf-8?B?VFlwaFV6TDNMbXlHbmcrQmNXQXk1SDBiU2VOVzBUeFUyVldtbnc3T3VvUjBK?=
 =?utf-8?B?LytQQk1wOFFKdU5KT0F3c2RTM2ppbnlBcjRIRlZVYzBBVTcyT21nRkdyTDlK?=
 =?utf-8?B?VzJ5KzRpd0kzbE80M1RpMUJDU2JkelRqMmxibTZmSWdHTENzeVROZU4xT1Nt?=
 =?utf-8?B?b0Q5S3dkRVl2V2tjV210YlhYZDF1Yld3bU9oYlFFVm9IMGpxY1FzbkdRWHNB?=
 =?utf-8?B?QnMreHBUR0w3dGZrMGtjUFVMNnRLQnNBM1NySFE4akFWN09paDBBaUl6V0d1?=
 =?utf-8?B?WEJRQWVyUTRvMC92VW1Cbm9aOGhyY3k4OXFYNXhhUi84eFRnM0JrYzlkR2V4?=
 =?utf-8?B?YzBlN0x0YVR2VTc5V25JeVhTbitLRmVkTXBUWjd3aGFCUFJJaXlsMEp6ZVBQ?=
 =?utf-8?B?WUpaT0xndTRMbHRJL3R5K09FOFdQUENqWEYwdkhWcnVnakNHWCtwRE93L1lh?=
 =?utf-8?B?R3J1NUI2LzhNU2hJNnJ1bGVTd0k4UTJzbUczNnM4dkFMKysyeFhwODhHcmJn?=
 =?utf-8?Q?huUGy2izkpVL+xZdsD3zMp96R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e25815-c9fd-49cd-0175-08dc939fcf6d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2024 16:16:18.1595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtQ3o/+SyADIisfR56u9u7hUGp6o6/xOk3Bt53q8+QW8O053UA0GdtBascruQIPYZTYtwkTxeG1FDk6KLGKugQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9161



On 6/21/2024 10:24 PM, Borislav Petkov wrote:
> On Fri, May 31, 2024 at 10:00:17AM +0530, Nikunj A Dadhania wrote:
>> Currently, guest message is PAGE_SIZE bytes and payload is hard-coded to
>> 4000 bytes, assuming snp_guest_msg_hdr structure as 96 bytes.
>>
>> Remove the structure size assumption and hard-coding of payload size and
>> instead use variable length array.
> 
> I don't understand here what hard-coding is being removed?
> 
> It is simply done differently:
> 
> from
> 
>> -     snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> 
> to
> 
>> +     snp_dev->request = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
> 
> Maybe I'm missing the point here but do you mean by removing the hard-coding
> this:
> 
> +#define SNP_GUEST_MSG_SIZE 4096
> +#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
> 
> where the msg payload size will get computed at build time and you won't have
> to do that 4000 in the struct definition:
> 
> 	u8 payload[4000];
> 
> ?

Yes, payload was earlier fixed at 4000 bytes, without considering the size of snp_guest_msg.

Regards
Nikunj

