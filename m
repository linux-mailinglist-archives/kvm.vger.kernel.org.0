Return-Path: <kvm+bounces-50815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04219AE990E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 10:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30B9E17A44E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6490F29E0F2;
	Thu, 26 Jun 2025 08:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vRoLc+LC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD22F29DB6E
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 08:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750928022; cv=fail; b=adjgclLTb6i0EQVemQE4tILYOOXaVyLNPgvDwsiFKAq6ApUMvW7uGZoD0iR/EFtN/h3dtu1K+CehVTEUZrApBl+17gmSJQXXpwsyEWciMM+IEdipTpfm7dJnvb0r602X8Ys7QrP8AdqKKIUk42YoboxtqeSh5rMyvRewhUqTK1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750928022; c=relaxed/simple;
	bh=oJGeCPVXH98cLsD8GZpJs7lByjImhmAsI92wGUb6iY4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cqYlgTEoYY7XFfmauYBtG9+UN+7feSr9taso+X0cjovHu+2bHMdUJpODTeXb75V2yP/rG76h349BhjcSDdtbHjinFo2IOFgDXveSuR/stHiKwCnOuHl3HCSYwovzI5KOYCn7ZZkyVJ9fNzdv6+qZzdyUAHN23IyI8MAvLcairm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vRoLc+LC; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9CfRROVZ5Jb8ZidOZwVRPtJT8eXDQAt3zAPXRpPDtv3qRb5/0a8wihExwLR3ONJAw55QdqLZXNSV4UqE/FvTfTSW2YD3WrTVblE9bSjGuYILwYcYyftrkkTaUYKW5HcmZy8qmHEjozUyG+xC+krrbR0dfPIqI9+vQ8/kK394Fdym9FaTo3pQT1bLWThGQ/u7IQsBFXdS+iDV3dNvImJtg2Z/R/HGVG+G2pE136l1Bszpiay/g9mtTDK+vV5E/T4+5JGBEvl7dVISwZy+EpNkSJn3GTmscl3RDuXvZVvAwwTat1XjWzcUaotNeqRAvbBRQ+R2TH1W4uedkvQ7AUw+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74FRRA1TNcD9BDLegZHtL1nm3R7pee/pgviR8MXiaF4=;
 b=PrBm9cJELey0NEGgAiX7+Bkw7Mpt1vluv3Qvv/UsQpTV4F8LTmIu78DH59Y9nSsC1mtkTSWbTMuhJPkO3QIRYBrqFfIpmAE/NK9GMUeH/TDeNDuEfTKL5dWP+0FbW072iZUBB8S4PSAplZkrPe7tPNhA2zqUllqqOLj1pmQbWkJK5I8AdYtDMDet8d0EpLnC4FOjBdRzFpOaLbhm5/cdW/irGMmXHdB5gCL5OivNC344FVmjr44h9G2N0AiHebU2dq9w/0/civ+UltMM5YmXaFi4OsJLZQjFzX2bAN1T1+caP0PN/YR1g7S6OESV6sxrMx2Msr77Y/BsFPUjm3dNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74FRRA1TNcD9BDLegZHtL1nm3R7pee/pgviR8MXiaF4=;
 b=vRoLc+LCidhCwjHv9gXkS5Wbt396d54Sp6Vf/Zpotq+uu9acm/n8KUHawiDw7mEDYWq/5bGzpydSigENb+VP9ZvC0QN1QkgyjrjSoG1XR4JtZVXmvEsMAXRVHmDh8/YN9uAHjTk/nKmBkbhFST5CG1dX1omtBk26KC7LSwGfXm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4SPRMB0045.namprd12.prod.outlook.com (2603:10b6:8:6e::21) by
 PH0PR12MB8151.namprd12.prod.outlook.com (2603:10b6:510:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Thu, 26 Jun
 2025 08:53:38 +0000
Received: from DM4SPRMB0045.namprd12.prod.outlook.com
 ([fe80::3a05:d1fd:969c:4a78]) by DM4SPRMB0045.namprd12.prod.outlook.com
 ([fe80::3a05:d1fd:969c:4a78%4]) with mapi id 15.20.8857.019; Thu, 26 Jun 2025
 08:53:37 +0000
Message-ID: <04a95048-d814-4dc7-a5ef-bf972db9468c@amd.com>
Date: Thu, 26 Jun 2025 14:23:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com,
 santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com,
 vaishali.thakkar@suse.com
References: <20250408093213.57962-1-nikunj@amd.com>
 <20250408093213.57962-5-nikunj@amd.com> <aFwHNNJXCrAzCGci@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aFwHNNJXCrAzCGci@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0074.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::10) To DM4SPRMB0045.namprd12.prod.outlook.com
 (2603:10b6:8:6e::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4SPRMB0045:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c8ff69-f0fd-4d36-4260-08ddb48ef0f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDJzVEpkZHdaaHJ2SjdPaHZ3aXNGMzE5MEdTOUhGTzVFZm5BL0ZwaUhmNWI2?=
 =?utf-8?B?Zy9WZ0VVeEFkR3YzZUZubllBUFowNDBZNEQ0K3NJd1BjVVdURVA4QU80c3E2?=
 =?utf-8?B?UnBFR2JhWkQ0NVF4WUFwaFZBZkR5ejZaTVd2WEtnNHpqMlNRT3RERWNVM3c4?=
 =?utf-8?B?bVVFV1IwUEVXMWpFeTIrd1NCeXROdGZmWnJzaXk2UzZkM1VYTUYxQURrakR3?=
 =?utf-8?B?S0I0MU4veGF3Y3dtNnhMYWpBUkk0NXUzSjlHeHY5dithTU56NUlHTXJjc3NM?=
 =?utf-8?B?VmUvRmtEVG9tWTF2b0VnWXVBVXBEZm94OWdTdVdMOHNLVG5XVFlRQUFvUlNq?=
 =?utf-8?B?ZCt1VzZ4SGZpWHNzT0VvbkF6U2NRcjg4SXRuQmd4cmlva3cxVEVDWm9yMnRt?=
 =?utf-8?B?d3k1bnI0ZEJOTkptQ1BMUStWdGZuMEU3cHZwcnVqakwzTGR3L3l2ZGtuU1hC?=
 =?utf-8?B?NDZLREp4T0FLVzZzMHFwNm12dFIrWlhiVGdHOHdPT1ZBU3U2Mk5qbkc0U25m?=
 =?utf-8?B?WWwyem5TTW9DZDI0eFRDWGpSZkIxQllyTDZPaHE1ODhaVkxxRzJuWFFSb2pj?=
 =?utf-8?B?NUN5eGZJTUxPbXBLdWVMYlFNcjE1OEgzUmV6ZzNINzRaU252bmVvazlPZSs4?=
 =?utf-8?B?VC92N3NhSlEwa2c5TjNIdWtEWjVMWTlIOVdUNUllMXJvQVlBSzdNOHFiQ0Ew?=
 =?utf-8?B?aCsxRHo1cGhObHB1Y3BXZ2FJM3JCQU0rRVNPblErb1Fpc1FrNG5GYWNDcVc2?=
 =?utf-8?B?RTkvTEhHdlM5elNoUWEzUTdBbVo2aTlhY2czWmNtNm9Gc3k2bnR2R2lYNWMz?=
 =?utf-8?B?VHYzbFNBdExTWW52UVRhbVJvWjZ3VWhLM1ZKMXJzOEs1ZWl3OTlyRUZYVE1G?=
 =?utf-8?B?alFwZW9tdHdUVTJScGFTdlEvT1R1YnZxTDJ3R0JMOWI5c0pTbm50UlkwRnhS?=
 =?utf-8?B?d0RJOG9QdWN0TGtnVUhFNnlCMGxacXprOTJzM0tLUndNa21jaThlVlRsL08z?=
 =?utf-8?B?SzgrUWQ5ZzhDWkVUWXljanpKLzIydkRFR3Q5SlVlRVhIRmhTMm44OW12ZWhF?=
 =?utf-8?B?UHNwd0dNdEJncFM4SndSM3c5NEFCOFNDTXVaVGJUZFR3SEU0TFh3QStKNzk1?=
 =?utf-8?B?RWJqaWJZTFVURjFkVExma3NjWU5LOXdXQ2Ztc1JBbzNYbDVBaXlxSG9Ueldi?=
 =?utf-8?B?UW9rYUR0cWVXbUtJZ1FrSG1HdHhoNk8ycjhxZlg3M2xxeXJRUEp2UTBUNnRh?=
 =?utf-8?B?Qjd1L1lXVlc4MjFudU9mVXQ1KzRRWEg3SzE0VGplR1k4cmJId1c2SGR1K2lv?=
 =?utf-8?B?Qnlqbzl4VzFVcEtvV1FUWS9GWktiMGRRMVpEV3JQMXJHR2dLdDNURzhnM0V5?=
 =?utf-8?B?N3N4UHpPaFNGVGdFd0c0aGFCTEtOWnE5YjRWQ1VsWEZGK3pMb1RmaCtrY2ZQ?=
 =?utf-8?B?SXRLKzdwSFlFQ0Vtc3ppcmF5Q24yWDh4UnZSMXRlWkNlRkNBZFN0eWxwdFIz?=
 =?utf-8?B?TWkzWUphZFJHZmhjdkU0RnViOE16N0Z5djZIejNubFFBRmEwa1JLcWU5TzVY?=
 =?utf-8?B?c1VHN1hKNWh1eWpaNFp2R0JqVllHeHN6MHA3WVNKRkVCeTFXM1BsbEc1eTNk?=
 =?utf-8?B?MG1kZE94NlRwSDJzTkQyVzlIdXhRTmJDYUtKR2RnejgxRFJHTjRFT09JYUwv?=
 =?utf-8?B?MFF1bVlJMTRWNmF5eFEzQmRhM012Y2FjRnNTa3BTcWQxNWNOQjJvdzU1Vi83?=
 =?utf-8?B?cVhoZlNTWjdNVFBTRVFuenkzejBZaFVpUUxLS1c5Tk4wem5NZ2NCeitCRFRq?=
 =?utf-8?B?dWNhdXR1cWVGRDBNbXFXVWY2VlJ0V2d1NUljMHZ3eGxCNGpJcDZTZ2dVL2xZ?=
 =?utf-8?B?d0p0MTFKTTBXRGRNd0ZKc1Ixd1BuOWVweHBkdVpaZEc2dnBlbGdTbmJDQ1RG?=
 =?utf-8?Q?Vgxj7StXB8o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4SPRMB0045.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qml0VUJHSENqVHRGOGNBWU9PRGZ6bkdIU3JNVndvMUNvUnVUMnhhZjV3QU0w?=
 =?utf-8?B?Vzh0TVV1WjJ2dm0wNDJ3WXNmYjVMS3g3U0UxRXYwalFoWmlXNU5ZZmRkdkMx?=
 =?utf-8?B?Y0FsSGtIQVBXazY4cGVoRFRtOFdXMndlUGtheWh5VS9TWnhyMWpKZ3BFdEFT?=
 =?utf-8?B?N0RyTEEvNUFSVXpLclVER3NuU3RvNGJpSDdzbUlkYWxXVituVUhNYVNlN1dL?=
 =?utf-8?B?WmsyODBPbzU4MkZRdFR5MlFvUnh4aGxyOHZjUS9XcWdkT1lIanljWTY1UTN6?=
 =?utf-8?B?NzhWV3hiMHN5Ui9uK2kxT1RtUlhSbXpDa2pVWW9QcWMxQUlGWm9teVJ0VjlO?=
 =?utf-8?B?bHcrZkg1S3p4c0dpa09sUFdxZmFCNkxiNEZvMDZHK01nRXRQcmJjNFh5ZXNy?=
 =?utf-8?B?ZTFpMWRDbnJOWndXZVJ6dVAvaUgycTlHN1dFUEtiakdLbTFZa1o2LzZGZGc4?=
 =?utf-8?B?S0hMYXJ6NWROUkJ1cy9YWTZQblpQaXdHMDJaaTdabmw0YzByUjhpNnoxalBr?=
 =?utf-8?B?RnVBMzhpMnB5WjdZTDdsL1BKbm9HclZBbTczUHprTDd1QU5acUlSb2hZeTJB?=
 =?utf-8?B?bjRJdng2NWdyYU02bUxEKzVvZzQwY1RQRGlnNmNMTjhZOTl1SlZ5bExOOGVI?=
 =?utf-8?B?Uzlna2VKa3BhYUtZOHB4TXQ1T2xCc2dpUVllcHUvcXUxdEdab0hDbmhjRkxW?=
 =?utf-8?B?czZRSmJoTnZjTURTSzFidnRVQXNzcFRrUVpiS0l5NytpK3NJTE1vQlREblV3?=
 =?utf-8?B?ZUk2Qm9SZ1NkakQ2ZHZlRnlXZ1ZvcUZ4bDN6amRnUC9WbTNsT3RJWVh2VlR1?=
 =?utf-8?B?ZnNMWjVKWFlCMFBFYWRJUitSQ3pZWGdTcVlkdXl5SGd0VlB3eklUanpFeFB3?=
 =?utf-8?B?bzI1ZWtUTGF4QXZYcis3cXU1QVQvTk4xSzNySW1oWHZIa3piZkc4UllPUWhK?=
 =?utf-8?B?Q0dPNDV4VnRtWjUrTFFyK1R0am4vTkNVamhsQlBvdjNkN09FTEFybUkwRkVh?=
 =?utf-8?B?MG5PblFDRkxlNEtJTDBrQVBUZFUvS1JPdHBHM0wrUGF4NjJMYkc3SHpnK1hq?=
 =?utf-8?B?U2RMdWRVdWZ5VFpPTllVbEFWYVpwSXdhRFpzWXRsQVJmS1BoTnNPelY4UmFM?=
 =?utf-8?B?Qys4WG5TTTBXQXVoLzJDYktZejYrd3A3ZFR3cU1sNUh1eGJyb28yMzJoQVlm?=
 =?utf-8?B?Q1ZTL3RjcS9hNHRCaFVXMUVPelhYUVdQdU5sUXZPT3Z5dGtlSmRCRGpUeFhC?=
 =?utf-8?B?Z1YyUlN5TFJyUzZKUFFHSUVYbitISzVSclVwZTZEVG5GL0JmbHZMdFYxblFC?=
 =?utf-8?B?MnlXMnowU3M2cklWMEFrcks4Vkk1cTh1N2thTWdPVmp6aGQ1SnMyKytWVmFK?=
 =?utf-8?B?RXlWemRvZGk2V01oWVAvbWF3OUcxY3hMVWFYZjNoV0tSS3JPaWtzWVlLWWpk?=
 =?utf-8?B?V1hCWWZLRVB5eGJBVWhyT0Y3K2tPY3dlZVJZbW16RGM0T3dCNitwZmp6L3lm?=
 =?utf-8?B?N1Rja1JRbnBHT2ROYUh2bFVHUVFVRzJ6T2JTMnp1emJuY1FDZEtZQVg3UVBa?=
 =?utf-8?B?a0E2cEN1QmoxQlFhWkxNV2xhUnAvdVhMcnFkV0p2YStrR2NBTU5tRmxZcnBT?=
 =?utf-8?B?dGd1aDAzZ2RYT25wNUllbHBEdENqWWdtREpoeXp0aVlrdU5HcXNvd2dCNTNk?=
 =?utf-8?B?UGZhNEVIVDNCdGl1U1FsNHU4bTBSdWVac2tSbmw5MmdXTEhNWTRkQTRjYkNq?=
 =?utf-8?B?MmphYWRqR2RQWDV4TDFDb0ZCbWxaZ2lIbWYwT3gvbWJFVUtib1JYUW9sQXpo?=
 =?utf-8?B?d1EzQ3k2YlBid3NOVDVoRkxpaXA4L0Zwckt4SUxlc2FaamhWa0ZPQXRVbE1G?=
 =?utf-8?B?cGFaTXkrQll5ekl0K3BVSmxrNmxGWEFQWnhMb0lVK0QzUnB1UnE2bUJZazhY?=
 =?utf-8?B?QXNDZ0d5a1pvd2IxbmRySitYaXZISDRKdWdRNWsvQ2RJUGRTajZ5SzJkMjJ5?=
 =?utf-8?B?YkFTSTBWbENRMG5xQi95L3VxeXJ3Y0kwb2NlOXFIV1FrWm42UjJXM3VzU25W?=
 =?utf-8?B?aEFlWGU1VGNWa3VGVjg1WDc2aFcwWW9GOXlzMFhGZ0s0ci9HVWtMWXR3a1hy?=
 =?utf-8?Q?Xu+eLB//O5u5UcspTxiQ/aKpr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c8ff69-f0fd-4d36-4260-08ddb48ef0f4
X-MS-Exchange-CrossTenant-AuthSource: DM4SPRMB0045.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 08:53:37.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwYBT97L66loMQPA69mgelEqZpRyU/Y2QjS/aDiECGQBGknG3grClD0O69Two1jx3DT3vuXwqi7SW8qcDzDHiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151



On 6/25/2025 7:57 PM, Sean Christopherson wrote:
> The previous patch to add GUEST_TSC_FREQ needs to squashed with this patch.  It's
> impossible to review the snp_secure_tsc_enabled() logic in particular without the
> details added in this patch.
> 
> And once you rebase on kvm-x86 next (i.e. the MSR interception rework), adding
> support for GUEST_TSC_FREQ will be like three lines of code, i.e. not worth
> landing in a separate patch.

Ack.

>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 50263b473f95..bcb262ff42bb 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2205,6 +2205,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  
>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>  	start.policy = params.policy;
>> +
>> +	if (snp_secure_tsc_enabled(kvm)) {
>> +		if (!kvm->arch.default_tsc_khz)
> 
> Hmm, so there's an existing flaw related to the TSC frequency.  Ideally, KVM
> shouldn't allow KVM_SET_TSC_KHZ on a vCPU with a "secure" TSC, i.e. on a TDX
> vCPU or on a newfangled SNP vCPU.  I'm not sure that's worth addressing though,
> because it doesn't put KVM in any danger, it can only cause problems for guest
> timing.  Yeah, I guess we leave it, because it's not really any different than
> enumerating a TSC frequency in CPUID 0x15 and then telling KVM something
> different.

We can prevent the host from setting KVM_SET_TSC_KHZ when arch.guest_tsc_protected
is set in the vCPU IOCTL. Although, doing that in VM IOCTL will be tricky and may
require to add something like kvm->arch.has_tsc_protected.

> 
>> +			return -EINVAL;
>> +
>> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>> +	}
>> +
>>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>>  	if (rc) {
>> @@ -2445,7 +2453,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  			return ret;
>>  		}
>>  
>> -		svm->vcpu.arch.guest_state_protected = true;
>> +		vcpu->arch.guest_state_protected = true;
>> +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
>> +
>>  		/*
>>  		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
>>  		 * be _always_ ON. Enable it only after setting
>> @@ -3059,6 +3069,9 @@ void __init sev_hardware_setup(void)
>>  	sev_supported_vmsa_features = 0;
>>  	if (sev_es_debug_swap_enabled)
>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>> +
>> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
> 
> I don't see anything in here that prevents userspace from stuffing SECURE_TSC
> into vmsa_features, which means the WARN_ON_ONCE() in snp_secure_tsc_enabled is
> user-triggerable.

Right, my QEMU patches enable vmsa_features only for the sev-snp-guest object.
But you are right, vmsa_features is part of KVM_SEV_INIT2 and can enable
SECURE_TSC causing the WARN_ON_ONCE()

> 
> Unless I'm missing something, this need to do something like:
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 45283a2d8c4a..09044f2524c2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -405,9 +405,13 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>         struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>         struct sev_platform_init_args init_args = {0};
>         bool es_active = vm_type != KVM_X86_SEV_VM;
> +       bool snp_active = vm_type -= KVM_X86_SNP_VM;

vm_type == KVM_X86_SNP_VM

>         u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>         int ret;
>  
> +       if (!snp_active)
> +               valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
> +
>         if (kvm->created_vcpus)
>                 return -EINVAL;
>  
> @@ -436,7 +440,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>         if (sev->es_active && !sev->ghcb_version)
>                 sev->ghcb_version = GHCB_VERSION_DEFAULT;
>  
> -       if (vm_type == KVM_X86_SNP_VM)
> +       if (snp_active)
>                 sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>  
>         ret = sev_asid_new(sev);
> @@ -449,7 +453,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>                 goto e_free;
>  
>         /* This needs to happen after SEV/SNP firmware initialization. */
> -       if (vm_type == KVM_X86_SNP_VM) {
> +       if (snp_active) {
>                 ret = snp_guest_req_init(kvm);
>                 if (ret)
>                         goto e_free;

I will fold this in.

Regards
Nikunj

1: https://lore.kernel.org/kvm/20250310064522.14100-3-nikunj@amd.com/


