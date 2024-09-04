Return-Path: <kvm+bounces-25849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A615F96B9F7
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FBD2281F7F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396421D0167;
	Wed,  4 Sep 2024 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lTNH+DN/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1053F1D1F7E;
	Wed,  4 Sep 2024 11:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448419; cv=fail; b=iFNvP68qzdcM90vT/3ijYGl/gmC1wCy+G6vwXzXVTBvQyJum4NMyq1oCAIEyPFrfhu5i1LXPv59NuQ9xvd4lQOVmRCwhaJfryUHfK201pZ0Jm5j2vDGsFUrVp2mLpixypzmduvT+abSsmUGL4t7Lr5cPjOYIrfiV35uDFfdUu7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448419; c=relaxed/simple;
	bh=AV/6GPC2aGb9Dg3S0LtesjuDqP1eIjNzfjyCHlotzWI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m6TmBaNKTN38ohRf2XQ7t0EXQT//0ZPRKcN6VZbBmJxLtkhECFSj2TdfI0rHsKXmyOGJg7FKTHFSz0xceFq+gGUKgPCCvB0sRlkNjEBU91vagyLij2qIkIlNEbzkXBzDIpXqrOPK+Ees90s+r/mtCfw/i6a3vQHDWPJXT9UE4NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lTNH+DN/; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZdI/N2Q5Z00PcfpBgmRJ1wXbVX0I3KxvGYbNg70LEzkd/KQtn4h9KJlBSrWZBSwZay7oTCMzL33vL3X0bJk75QrloRBzgnfeHN9G/sETU82OdXEACKCGV6WDAL2cQAdQ8JErmhlwVslIrlNLPxpqeGXjiAKb+0cUL30aWULO7eJpxEWKY+xAL3LmYbPO1zRFxgVmytg72HhhI9D1vE1lQEzhdioPmnykCsKbd079jjYPOS8UbAknI3YBegQy1v9SfOzL6S0rL9/26pK8Q2hGp7e1BWKdsbBzx/4ULuGIsc34tPalS0ozPBlRL3t3oRNPQej8JEr7XDMfNk4qpk8AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smgUnmWdaQIJIKdGJ1e/WBJJSvQORdbahgKJmbnEZ4A=;
 b=tICc4nO2UZ6wt9tbTPyXs6EISZWOnXr/WQkQn/LoJ2up8kUPaSVJ/6y6FrlmcCAc3DAIMk2DxvLUlzVeJNp1fTvEalApCz7oqhFrTAF7nPoQ8sa4qDm6HY+W2w9Cdw5jTNSXXeJkIK+GKURXa4zGyDInjbotv33aJ1N0Nmwkr5vAYu2Hnhdzv2oyPGIQkDIyp36f08GdQZesbVEqoqqVKB4nU21ITaz7dvbhR6fXKsq302RWgRrf+A7tdr/aGXwrXJiZp4gVJ54kWIbKzXx0VVjhvNzGNeuotB1cq27clv4Oi8lStRzrjjAniMgIESrHRbJCnPMm4P3T04Lq3LM+zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smgUnmWdaQIJIKdGJ1e/WBJJSvQORdbahgKJmbnEZ4A=;
 b=lTNH+DN//kOlpGmgEepahhmjd+Bt1EFStHOUn/dvt3ecAtrLzc3nGqWuF7wk+PPVqDnB9BLTA/i3TRJEZ74pVfpohCrAPkSYn4vnjoKdv4vuT1VDID8WzMEnMTZHE4nWIi1/6/v9VHkBiAtpxL50msmmJiOlmDj++vMhC1uDt1k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ0PR12MB8092.namprd12.prod.outlook.com (2603:10b6:a03:4ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Wed, 4 Sep
 2024 11:13:27 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 11:13:26 +0000
Message-ID: <9c0bac09-f663-4592-b954-259aeb7ec268@amd.com>
Date: Wed, 4 Sep 2024 21:13:16 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <66d7a10a4d621_3975294ac@dwillia2-xfh.jf.intel.com.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66d7a10a4d621_3975294ac@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0001.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::14) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ0PR12MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: c77d8e98-6c21-4cd7-4062-08dcccd298e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czZMRUFHZWZNMC94Lzg1UWxVSUgzRTFENHpOSHlKazBGVjczc0NlaVduTXFx?=
 =?utf-8?B?ZFNKbXRmRlR6WUxmRERPcXJaWWJKc2lIMTB3bkV1TVU3NVNCakJVYU4rZThT?=
 =?utf-8?B?R0VDcjRSeXZFZTRLd3RpUm4zZG9BckFaMmI4QXMwQ3piVGlObFZsNVpZTUs2?=
 =?utf-8?B?TTF1eFpqZzlCaTFxNlJDV0oybGZ4M1BENmdhdUQwNVZTbVE3OXFMdGMyNHhB?=
 =?utf-8?B?NEhmSGVIbnAvMVZsYjNHeEpkMjkzQjhmc1A0Q01vdWdOVlB6N0l5ZmV2bnN6?=
 =?utf-8?B?NlA2NlhqT3ErUmphZ0FMcVlobGRTTHlxc0FPOFpPOE5mcy9lazhVdTBWTzBM?=
 =?utf-8?B?d1Q1N3gwU2g4a1lJM1FCVjJiTWNKUmN6a3A0VFBxcEJQMnZrNWJVcFpiRWpT?=
 =?utf-8?B?MG01M3R3RUZSMHVzbHBnV1hOQzhmYzdqRnBkc291a2lMcEN3VzMrdVNOYVRW?=
 =?utf-8?B?eWNLT2V5eTRNdk9WZFo0bGJWVm1NdUhlVmM4eElJdUtkTTkzK2YrcHlDOGs5?=
 =?utf-8?B?NXEzOVNtNnpVYkR6M0ZjQUR2bUNpeVZpNWozQW5VTjJFVHlYWlVHVW85emU3?=
 =?utf-8?B?eUxIK1ZLR3B6a211Z0UxNS8rS05HelJid2dBUkJMSjgzRXJxcWJpdHpwZWRO?=
 =?utf-8?B?QVhIOVR2cDM2REl6QkRqd1pXbG5SZlp2RlVFMEJxRTdnK1JhbHRySFVCMlNU?=
 =?utf-8?B?VVdXYXdsSDg0bFBjbjYrdENEajFud2twMHczY08yNnMrRGRGWDB0NENDZlN6?=
 =?utf-8?B?bVNaK2JrY0tvTXRDbkxhdFhSYm5kNXNoM2MxWnFVR1B6TDkwWGRMejJpUE5Z?=
 =?utf-8?B?VTEyMDI5c0FTL3lYUHBVTEE5STdwUzZqRG5VZHRUcEtqZ3hZSGdRaldrWEo3?=
 =?utf-8?B?dWlsVG14Vm8xcnY2WUpOTTg3elBzL1o2N3lvNHFVMjZmMU9HNmxtTXVzekNS?=
 =?utf-8?B?VXRlRi85SXVObjM3WHBJSnoxUHdJY0s2UnNSYitLZk9MNHk5bDlnQzZEbTFJ?=
 =?utf-8?B?R1JMK3JKSDlhKzV2SEtrWkVyemtYdVFzVUZSNTQwOE9lSEZ5SmFTWjBSOVp5?=
 =?utf-8?B?SzRYYk5aWmFxRTB4L2xPVDBPUWhOR2lGY1pUTTdXN1RPWmdiSWNxUG5ONUFw?=
 =?utf-8?B?TVNJRTdjd0U2dldVaFk0KysvclR6TDcyS0lRY29TVDg4YmVxdEhqVy9PV1BY?=
 =?utf-8?B?bG5wSW9LamNEeHZBTFBBaWkzR2gxcDlsdWdEU3g0MG1YOXNDTFAwMnRwSVgx?=
 =?utf-8?B?VmptYnRSMXc2cHkzelJkU2NjUkRQQ0NXVUdZWVBEUGkxS3MyNkJiWE5OL3ph?=
 =?utf-8?B?VTJmcEFxQTF3RlRnbTE3RFRKYVZVU0FlN1h1d29RQlo3ZENldUxLYTZCMWw5?=
 =?utf-8?B?SW9jeWNKYWtpdmsvWVRoUW1PdjZPaWJTNXpMSTN6NjFtZ2VjYm0wcC9sRmdr?=
 =?utf-8?B?R3E0MGt5ZEZkSEN5RG85cUY2YlB2WnBTVjAxSmdhN0hSNVVXbk5aN1BtOCtR?=
 =?utf-8?B?OE4wTmNpUTJmRW53ZjQyZVA4Z3JEaHJhVWtDekpuczc0SVZ1c1lxcnN4U3U1?=
 =?utf-8?B?WGtrSGU2akU2azh1MEFKWjMzcDRYcmVUdmMzSmJtRFhEODdPOHhnMXc2UUp4?=
 =?utf-8?B?WTJielhaaUNuY0xNcW42NjhhaTRWNDVkNkdUUlhDV0Q3T0VjUUpoQ25KOG9z?=
 =?utf-8?B?em4zWmc3VDNLRU5YNitNYlhaNzNQTnJwYXByQ3RUN2FZREFrOFVGdzVpQ3R6?=
 =?utf-8?B?Rjh3Z2o0RlhDQUk0TXMzOUgyMzJxa3dKbXVwYVdKSkcxSzZ0R1B3NVZFK216?=
 =?utf-8?Q?cpbOBReU1O00N3X5PAxtKyyprCoKGHjY3wK6E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmcwS3lGc0tTWFF4enFPcVBTcEpmOWNEMW5tdk14NElaTjFRMWNMaE9abWNB?=
 =?utf-8?B?UWJ6cmM5YUlHejVONFBKRUk5UHFTVGMvNHVCVFBJWVd4VnVFa092S3dNUElt?=
 =?utf-8?B?OXMyTnEzZkt6YnZEaHd3QU9vQUk0anpNMXJhN2M4Y0VGSHA2T3JNRitlbnhL?=
 =?utf-8?B?MXRTSjhCdnV5U1o3Zkh5UGZjcVg1Q0ROTEZkM0o5M3grOUhCUXo3WGJVYUEv?=
 =?utf-8?B?d1hpcGtiSHBzeTd1YnBTTGRrbEc5YTZYS1FCZ3kwWVg4NXdocTc3Uk9zN1F1?=
 =?utf-8?B?Y3pzQUNYSWpaV0t6aHNkc0w1UnBKMVREOHp4M2lVNDBQWHM1bmlWcHRDQkpK?=
 =?utf-8?B?UGZlRzNTakw5SDA3OEV4TmtMRS9wblZmM2pnWlBodW5MdXVPbDhvTU9JY2dU?=
 =?utf-8?B?S0RZZ052ZnF0M3kvcW5jTHVuV0lZYlh1dm5aai9WTDQrL2FHR1laa3dCK3Vi?=
 =?utf-8?B?dVpabk0vcy9sMlhVaXBOdHJjcjVWc3dFQjZheXljSXYya2d0dkJZeG03NTRi?=
 =?utf-8?B?bklHYTlOVXFVQWpLMStZY1R0dEtVRWluMURtL2huSCtkOFpzaCtURjIxZ3Ew?=
 =?utf-8?B?TTBJdFlCMWgzWlF6RndBSXI2WG1maGFmWSswOHBvODlkS2NLMG0vQnAvbnlF?=
 =?utf-8?B?U2pqRXJLb1pGeGVCeTdJZmlPaWt6cmc3UkZaTEEzTzVodkdkQllrc2FOcWFP?=
 =?utf-8?B?RHJ3RGdoM3A1VTlvd3VlY2NIdXU5NWRkUDFtaG9OTWN3cWI3VEgvSnh3Vjkr?=
 =?utf-8?B?MFNCRTRPTm5MdjJxTnJUNFVnRTg3Q0k5T1BDYXlvYXkraWZCTy90WjFsTDlr?=
 =?utf-8?B?WVp4QmIzNVVtOUN6MnJnR0NOVkdUR3pUSGJjdm5vMkFDS2xiZkhWWlhCdnJH?=
 =?utf-8?B?aVBYS1YzZi8vTFhCL3BwL0FNOWhBUTNZWkxqUlZSN0k2Z0N1c0JSMlhJbzBT?=
 =?utf-8?B?RzB3dzZCT2Q1UFBVNldxbHdVN3RqS2ZRSy9SZTFhV0hwczBBT3U2UFRrVjJS?=
 =?utf-8?B?Mk5nalNPbWFwdkNuWUhTaGhZc3FTUWJJbmNSaWJOSjk3MjJpQmFiR0NwNTRK?=
 =?utf-8?B?emJEcFFoL2dOMUttbnlFNkJjVTRWemF0MkZnSHRmelpwTEFyeElHR0dOcE83?=
 =?utf-8?B?ZEZmN25kMUNZUGNDTmRvWlZPcW1FcFJaVlV4U2ZDZEkwbzVESkZudzEzbGRv?=
 =?utf-8?B?RUhjL09kSUxMU2x5UjJWQnZxd2l6Y3JyQU9xMy9PbWRYUERCRmZYSXhHSkRN?=
 =?utf-8?B?eW5uSFZKdS9ocmVFb1hGTXVOS2s1UE41TSszam85YzlMU1NsVzZsMTdzYjBa?=
 =?utf-8?B?MVROd0xkQTZnZ2dwR3NleTk2a2NyWWdUQTYvNEdPRzlNYWpMNEZXQ25GMjRL?=
 =?utf-8?B?cHdIdmJibDczYVZsR0FKakdWbG0xaGJ5VllRS0xZSk51TUNtUzdWZFYxOVNx?=
 =?utf-8?B?bmJGTVloTzZJR3hOOVB0OU56djhWSFloelFoSVpCdEhzcHZLamx2SWtqU3Bu?=
 =?utf-8?B?b1JpU1A4cDhvM3BYRUZvbVVQZ2VCRTNkRDR3MjBVK1lkbUk0OWEwM1JHS3Ey?=
 =?utf-8?B?WWhnVkM2R2c4UWJCcFVrNlNQNHZZSGhXZzRzd2lZbjZic1U0MUc3ZjNGRW9w?=
 =?utf-8?B?VmkyMTVJMUEzMk5FeEd2NDZJQWg5VVpLa3ZTd1d2ZzlmNGN6OVdaUENyMmZz?=
 =?utf-8?B?czNjNExKNHZmN1lXUXhMZFdJUWM3S0U0aTdqRVJVRURQVmVyQTcvakxJNXQv?=
 =?utf-8?B?b3Z1THgyT28vRS9XSGlBK3B3V3ROandUeW1OTlZQM1gwSzQ1c2JWaXp2QjZa?=
 =?utf-8?B?VEpkcVRoNHp4MHZhR29oYk4vYjJNenpuZlM1aEwvOEFTTmU4Nkx6U1JJRDRC?=
 =?utf-8?B?SlFmcVhTaGJ0YXBSSTlienVIaUhOM0dvKytxVjJ4V2tpMlhIaVB2OGNqZGJm?=
 =?utf-8?B?dWswK3BDVmVneEhZTUhyTGhFSFBFVk1hYmlkUGkrc2paZGJaWEZwTDZmb1NT?=
 =?utf-8?B?V1RQRW96cFkwblhWalkwcVRzQWZ0RkVmWldLTlJQSTZRSWVTNlVFU0JBV2hR?=
 =?utf-8?B?MDcwRjEydnFzYTUwZVpVdlVzbnFNVnJCTWpYbnI0MWp1b3RRQlZlVk5HbUMw?=
 =?utf-8?Q?e1vEqeH1vkTrxl0ZM06QSoHuS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77d8e98-6c21-4cd7-4062-08dcccd298e3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 11:13:26.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4pKSHpdzhOQrXe9LGd6IEwGjTOf2VopaqPk8athqxdO7aVv8j14KLUvSKO898lkwOHzpBCePz5iXNWS9neqVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8092



On 4/9/24 09:51, Dan Williams wrote:
> Alexey Kardashevskiy wrote:
>> The module responsibilities are:
>> 1. detect TEE support in a device and create nodes in the device's sysfs
>> entry;
>> 2. allow binding a PCI device to a VM for passing it through in a trusted
>> manner;
>> 3. store measurements/certificates/reports and provide access to those for
>> the userspace via sysfs.
>>
>> This relies on the platform to register a set of callbacks,
>> for both host and guest.
>>
>> And tdi_enabled in the device struct.
> 
> I had been holding out hope that when I got this patch the changelog
> would give some justification for what folks had been whispering to me
> in recent days: "hey Dan, looks like Alexey is completely ignoring the
> PCI/TSM approach?".
> 
> Bjorn acked that approach here:
> 
> http://lore.kernel.org/20240419220729.GA307280@bhelgaas
> 
> It is in need of a refresh, preview here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=5807465b92ac
> 
> At best, I am disappointed that this RFC ignored it. More comments
> below, but please do clarify if we are working together on a Bjorn-acked
> direction, or not.

Together.

My problem with that patchset is that it only does connect/disconnect 
and no TDISP business (and I need both for my exercise) and I was hoping 
to see some TDISP-aware git tree but this has not happened yet so I 
postponed rebasing onto it, due to the lack of time and also apparent 
difference between yours and mine TSMs (and I had mine working before I 
saw yours and focused on making things work for the starter). Sorry, I 
should have spoken louder. Or listen better to that whispering. Or 
rebase earlier.


> 
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   drivers/virt/coco/Makefile      |    1 +
>>   include/linux/device.h          |    5 +
>>   include/linux/tsm.h             |  263 ++++
>>   drivers/virt/coco/tsm.c         | 1336 ++++++++++++++++++++
>>   Documentation/virt/coco/tsm.rst |   62 +
>>   drivers/virt/coco/Kconfig       |   11 +
>>   6 files changed, 1678 insertions(+)
>>
>> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
>> index 75defec514f8..5d1aefb62714 100644
>> --- a/drivers/virt/coco/Makefile
>> +++ b/drivers/virt/coco/Makefile
>> @@ -3,6 +3,7 @@
>>   # Confidential computing related collateral
>>   #
>>   obj-$(CONFIG_TSM_REPORTS)	+= tsm-report.o
>> +obj-$(CONFIG_TSM)		+= tsm.o
> 
> The expectation is that something like drivers/virt/coco/tsm.c would be
> the class driver for cross-vendor generic TSM uAPI. The PCI specific
> bits go in drivers/pci/tsm.c.
> 
>>   obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
>>   obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
>>   obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index 34eb20f5966f..bb58ed1fb8da 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -45,6 +45,7 @@ struct fwnode_handle;
>>   struct iommu_group;
>>   struct dev_pin_info;
>>   struct dev_iommu;
>> +struct tsm_tdi;
>>   struct msi_device_data;
>>   
>>   /**
>> @@ -801,6 +802,7 @@ struct device {
>>   	void	(*release)(struct device *dev);
>>   	struct iommu_group	*iommu_group;
>>   	struct dev_iommu	*iommu;
>> +	struct tsm_tdi		*tdi;
> 
> No. The only known device model for TDIs is PCI devices, i.e. TDISP is a
> PCI protocol. Even SPDM which is cross device-type generic did not touch
> 'struct device'.

TDISP is PCI but DMA is not. This is for:
[RFC PATCH 19/21] sev-guest: Stop changing encrypted page state for 
TDISP devices

DMA layer deals with struct device and tries hard to avoid indirect _ops 
calls so I was looking for a place for "tdi_enabled" (a bad name, 
perhaps, may be call it "dma_encrypted", a few lines below). So I keep 
the flag and the pointer together for the RFC. I am hoping for a better 
solution for 19/21, then I am absolutely moving tdi* to pci_dev (well, 
drop these and just use yours).


>>   	struct device_physical_location *physical_location;
>>   
>> @@ -822,6 +824,9 @@ struct device {
>>   #ifdef CONFIG_DMA_NEED_SYNC
>>   	bool			dma_skip_sync:1;
>>   #endif
>> +#if defined(CONFIG_TSM) || defined(CONFIG_TSM_MODULE)
>> +	bool			tdi_enabled:1;
>> +#endif
>>   };
>>   
>>   /**
>> diff --git a/include/linux/tsm.h b/include/linux/tsm.h
>> new file mode 100644
>> index 000000000000..d48eceaf5bc0
>> --- /dev/null
>> +++ b/include/linux/tsm.h
>> @@ -0,0 +1,263 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef LINUX_TSM_H
>> +#define LINUX_TSM_H
>> +
>> +#include <linux/cdev.h>
>> +
>> +/* SPDM control structure for DOE */
>> +struct tsm_spdm {
>> +	unsigned long req_len;
>> +	void *req;
>> +	unsigned long rsp_len;
>> +	void *rsp;
>> +
>> +	struct pci_doe_mb *doe_mb;
>> +	struct pci_doe_mb *doe_mb_secured;
>> +};
>> +
>> +/* Data object for measurements/certificates/attestationreport */
>> +struct tsm_blob {
>> +	void *data;
>> +	size_t len;
>> +	struct kref kref;
>> +	void (*release)(struct tsm_blob *b);
> 
> Hard to judge the suitability of these without documentation. Skeptical
> that these TDISP evidence blobs need to have a lifetime distinct from
> the device's TSM context.

You are right.

>> +};
>> +
>> +struct tsm_blob *tsm_blob_new(void *data, size_t len, void (*release)(struct tsm_blob *b));
>> +struct tsm_blob *tsm_blob_get(struct tsm_blob *b);
>> +void tsm_blob_put(struct tsm_blob *b);
>> +
>> +/**
>> + * struct tdisp_interface_id - TDISP INTERFACE_ID Definition
>> + *
>> + * @function_id: Identifies the function of the device hosting the TDI
>> + * 15:0: @rid: Requester ID
>> + * 23:16: @rseg: Requester Segment (Reserved if Requester Segment Valid is Clear)
>> + * 24: @rseg_valid: Requester Segment Valid
>> + * 31:25 – Reserved
>> + * 8B - Reserved
>> + */
>> +struct tdisp_interface_id {
>> +	union {
>> +		struct {
>> +			u32 function_id;
>> +			u8 reserved[8];
>> +		};
>> +		struct {
>> +			u16 rid;
>> +			u8 rseg;
>> +			u8 rseg_valid:1;
> 
> Linux typically avoids C-bitfields in hardware interfaces in favor of
> bitfield.h macros.
> >> +		};
>> +	};
>> +} __packed;
> 
> Does this need to be "packed"? Looks naturally aligned to pahole.

"__packed" is also a way to say it is a binary interface, I want to be 
precise about this.


>> +
>> +/*
>> + * Measurement block as defined in SPDM DSP0274.
>> + */
>> +struct spdm_measurement_block_header {
>> +	u8 index;
>> +	u8 spec; /* MeasurementSpecification */
>> +	u16 size;
>> +} __packed;
>> +
>> +struct dmtf_measurement_block_header {
>> +	u8 type;  /* DMTFSpecMeasurementValueType */
>> +	u16 size; /* DMTFSpecMeasurementValueSize */
>> +} __packed;
> 
> This one might need to be packed.
> 
>> +
>> +struct dmtf_measurement_block_device_mode {
>> +	u32 opmode_cap;	 /* OperationalModeCapabilties */
>> +	u32 opmode_sta;  /* OperationalModeState */
>> +	u32 devmode_cap; /* DeviceModeCapabilties */
>> +	u32 devmode_sta; /* DeviceModeState */
>> +} __packed;
>> +
>> +struct spdm_certchain_block_header {
>> +	u16 length;
>> +	u16 reserved;
>> +} __packed;
> 
> These last 2 struct do not seem to need it.
> 
>> +
>> +/*
>> + * TDI Report Structure as defined in TDISP.
>> + */
>> +struct tdi_report_header {
>> +	union {
>> +		u16 interface_info;
>> +		struct {
>> +			u16 no_fw_update:1; /* fw updates not permitted in CONFIG_LOCKED or RUN */
>> +			u16 dma_no_pasid:1; /* TDI generates DMA requests without PASID */
>> +			u16 dma_pasid:1; /* TDI generates DMA requests with PASID */
>> +			u16 ats:1; /*  ATS supported and enabled for the TDI */
>> +			u16 prs:1; /*  PRS supported and enabled for the TDI */
>> +			u16 reserved1:11;
>> +		};
> 
> Same C-bitfield comment, as before, and what about big endian hosts?

Right, I'll get rid of c-bitfields in the common parts.

Although I am curious what big-endian platform is going to actually 
support this.


>> +	};
>> +	u16 reserved2;
>> +	u16 msi_x_message_control;
>> +	u16 lnr_control;
>> +	u32 tph_control;
>> +	u32 mmio_range_count;
>> +} __packed;
>> +
>> +/*
>> + * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
>> + * Base and size in units of 4K pages
>> + */
>> +struct tdi_report_mmio_range {
>> +	u64 first_page; /* First 4K page with offset added */
>> +	u32 num; 	/* Number of 4K pages in this range */
>> +	union {
>> +		u32 range_attributes;
>> +		struct {
>> +			u32 msix_table:1;
>> +			u32 msix_pba:1;
>> +			u32 is_non_tee_mem:1;
>> +			u32 is_mem_attr_updatable:1;
>> +			u32 reserved:12;
>> +			u32 range_id:16;
>> +		};
>> +	};
>> +} __packed;
>> +
>> +struct tdi_report_footer {
>> +	u32 device_specific_info_len;
>> +	u8 device_specific_info[];
>> +} __packed;
>> +
>> +#define TDI_REPORT_HDR(rep)		((struct tdi_report_header *) ((rep)->data))
>> +#define TDI_REPORT_MR_NUM(rep)		(TDI_REPORT_HDR(rep)->mmio_range_count)
>> +#define TDI_REPORT_MR_OFF(rep)		((struct tdi_report_mmio_range *) (TDI_REPORT_HDR(rep) + 1))
>> +#define TDI_REPORT_MR(rep, rangeid)	TDI_REPORT_MR_OFF(rep)[rangeid]
>> +#define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
>> +					TDI_REPORT_MR_NUM(rep)))
>> +
>> +/* Physical device descriptor responsible for IDE/TDISP setup */
>> +struct tsm_dev {
>> +	struct kref kref;
> 
> Another kref that begs the question why would a tsm_dev need its own
> lifetime? This also goes back to the organization in the PCI/TSM
> proposal that all TSM objects are at max bound to the lifetime of
> whatever is shorter, the registration of the low-level TSM driver or the
> PCI device itself.


That proposal deals with PFs for now and skips TDIs. Since TDI needs its 
place in pci_dev too, and I wanted to add the bare minimum to struct 
device or pci_dev, I only add TDIs and each of them references a DEV. 
Enough to get me going.


>> +	const struct attribute_group *ag;
> 
> PCI device attribute groups are already conveyed in a well known
> (lifetime and user visibility) manner. What is motivating this
> "re-imagining"?
> 
>> +	struct pci_dev *pdev; /* Physical PCI function #0 */
>> +	struct tsm_spdm spdm;
>> +	struct mutex spdm_mutex;
> 
> Is an spdm lock sufficient? I expect the device needs to serialize all
> TSM communications, not just spdm? Documentation of the locking would
> help.

What other communication do you mean here?


>> +
>> +	u8 tc_mask;
>> +	u8 cert_slot;
>> +	u8 connected;
>> +	struct {
>> +		u8 enabled:1;
>> +		u8 enable:1;
>> +		u8 def:1;
>> +		u8 dev_ide_cfg:1;
>> +		u8 dev_tee_limited:1;
>> +		u8 rootport_ide_cfg:1;
>> +		u8 rootport_tee_limited:1;
>> +		u8 id;
>> +	} selective_ide[256];
>> +	bool ide_pre;
>> +
>> +	struct tsm_blob *meas;
>> +	struct tsm_blob *certs;
> 
> Compare these to the blobs that Lukas that maintains for CMA. To my
> knoweldge no new kref lifetime rules independent of the authenticated
> lifetime.
> 
>> +
>> +	void *data; /* Platform specific data */
>> +};
>> +
>> +/* PCI function for passing through, can be the same as tsm_dev::pdev */
>> +struct tsm_tdi {
>> +	const struct attribute_group *ag;
>> +	struct pci_dev *pdev;
>> +	struct tsm_dev *tdev;
>> +
>> +	u8 rseg;
>> +	u8 rseg_valid;
>> +	bool validated;
>> +
>> +	struct tsm_blob *report;
>> +
>> +	void *data; /* Platform specific data */
>> +
>> +	u64 vmid;
>> +	u32 asid;
>> +	u16 guest_rid; /* BDFn of PCI Fn in the VM */
>> +};
>> +
>> +struct tsm_dev_status {
>> +	u8 ctx_state;
>> +	u8 tc_mask;
>> +	u8 certs_slot;
>> +	u16 device_id;
>> +	u16 segment_id;
>> +	u8 no_fw_update;
>> +	u16 ide_stream_id[8];
>> +};
>> +
>> +enum tsm_spdm_algos {
>> +	TSM_TDI_SPDM_ALGOS_DHE_SECP256R1,
>> +	TSM_TDI_SPDM_ALGOS_DHE_SECP384R1,
>> +	TSM_TDI_SPDM_ALGOS_AEAD_AES_128_GCM,
>> +	TSM_TDI_SPDM_ALGOS_AEAD_AES_256_GCM,
>> +	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_RSASSA_3072,
>> +	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P256,
>> +	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P384,
>> +	TSM_TDI_SPDM_ALGOS_HASH_TPM_ALG_SHA_256,
>> +	TSM_TDI_SPDM_ALGOS_HASH_TPM_ALG_SHA_384,
>> +	TSM_TDI_SPDM_ALGOS_KEY_SCHED_SPDM_KEY_SCHEDULE,
>> +};
>> +
>> +enum tsm_tdisp_state {
>> +	TDISP_STATE_UNAVAIL,
>> +	TDISP_STATE_CONFIG_UNLOCKED,
>> +	TDISP_STATE_CONFIG_LOCKED,
>> +	TDISP_STATE_RUN,
>> +	TDISP_STATE_ERROR,
>> +};
>> +
>> +struct tsm_tdi_status {
>> +	bool valid;
>> +	u8 meas_digest_fresh:1;
>> +	u8 meas_digest_valid:1;
>> +	u8 all_request_redirect:1;
>> +	u8 bind_p2p:1;
>> +	u8 lock_msix:1;
>> +	u8 no_fw_update:1;
>> +	u16 cache_line_size;
>> +	u64 spdm_algos; /* Bitmask of tsm_spdm_algos */
>> +	u8 certs_digest[48];
>> +	u8 meas_digest[48];
>> +	u8 interface_report_digest[48];
>> +
>> +	/* HV only */
>> +	struct tdisp_interface_id id;
>> +	u8 guest_report_id[16];
>> +	enum tsm_tdisp_state state;
>> +};
>> +
>> +struct tsm_ops {
> 
> The lack of documentation for these ops makes review difficult.
> 
>> +	/* HV hooks */
>> +	int (*dev_connect)(struct tsm_dev *tdev, void *private_data);
> 
> Lets not abandon type-safety this early. Is it really the case that all
> of these helpers need anonymous globs passed to them?
> >> +	int (*dev_reclaim)(struct tsm_dev *tdev, void *private_data);
>> +	int (*dev_status)(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s);
>> +	int (*ide_refresh)(struct tsm_dev *tdev, void *private_data);
> 
> IDE Key Refresh seems an enhancement worth breaking out of the base
> enabling.
> 
>> +	int (*tdi_bind)(struct tsm_tdi *tdi, u32 bdfn, u64 vmid, u32 asid, void *private_data);
>> +	int (*tdi_reclaim)(struct tsm_tdi *tdi, void *private_data);
>> +
>> +	int (*guest_request)(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, void *req_data,
>> +			     enum tsm_tdisp_state *state, void *private_data);
>> +
>> +	/* VM hooks */
>> +	int (*tdi_validate)(struct tsm_tdi *tdi, bool invalidate, void *private_data);
>> +
>> +	/* HV and VM hooks */
>> +	int (*tdi_status)(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts);
> 
> Lets not mix HV and VM hooks in the same ops without good reason.
> 
>> +};
>> +
>> +void tsm_set_ops(struct tsm_ops *ops, void *private_data);
>> +struct tsm_tdi *tsm_tdi_get(struct device *dev);
>> +int tsm_tdi_bind(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, u32 asid);
>> +void tsm_tdi_unbind(struct tsm_tdi *tdi);
>> +int tsm_guest_request(struct tsm_tdi *tdi, enum tsm_tdisp_state *state, void *req_data);
>> +struct tsm_tdi *tsm_tdi_find(u32 guest_rid, u64 vmid);
>> +
>> +int pci_dev_tdi_validate(struct pci_dev *pdev);
>> +ssize_t tsm_report_gen(struct tsm_blob *report, char *b, size_t len);
>> +
>> +#endif /* LINUX_TSM_H */
>> diff --git a/drivers/virt/coco/tsm.c b/drivers/virt/coco/tsm.c
>> new file mode 100644
>> index 000000000000..e90455a0267f
>> --- /dev/null
>> +++ b/drivers/virt/coco/tsm.c
>> @@ -0,0 +1,1336 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +
>> +#include <linux/module.h>
>> +#include <linux/pci.h>
>> +#include <linux/pci-doe.h>
>> +#include <linux/pci-ide.h>
>> +#include <linux/file.h>
>> +#include <linux/fdtable.h>
>> +#include <linux/tsm.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#define DRIVER_VERSION	"0.1"
>> +#define DRIVER_AUTHOR	"aik@amd.com"
>> +#define DRIVER_DESC	"TSM TDISP driver"
>> +
>> +static struct {
>> +	struct tsm_ops *ops;
>> +	void *private_data;
>> +
>> +	uint tc_mask;
>> +	uint cert_slot;
>> +	bool physfn;
>> +} tsm;
>> +
>> +module_param_named(tc_mask, tsm.tc_mask, uint, 0644);
>> +MODULE_PARM_DESC(tc_mask, "Mask of traffic classes enabled in the device");
>> +
>> +module_param_named(cert_slot, tsm.cert_slot, uint, 0644);
>> +MODULE_PARM_DESC(cert_slot, "Slot number of the certificate requested for constructing the SPDM session");
>> +
>> +module_param_named(physfn, tsm.physfn, bool, 0644);
>> +MODULE_PARM_DESC(physfn, "Allow TDI on SR IOV of a physical function");
> 
> No. Lets build proper uAPI for these. These TSM global parameters are
> what I envisioned hanging off of the global TSM class device.
> 
> [..]
>> +/*
>> + * Enables IDE between the RC and the device.
>> + * TEE Limited, IDE Cfg space and other bits are hardcoded
>> + * as this is a sketch.
> 
> It would help to know how in depth to review the pieces if there were
> more pointers of "this is serious proposal", and "this is a sketch".

Largely the latter, remember to keep appreciating the "release early" 
aspect of it :)

It is a sketch which has been tested on the hardware with both KVM and 
SNP VM which (I thought) has some value if posted before the LPC. I 
should have made it clearer though.


>> + */
>> +static int tsm_set_sel_ide(struct tsm_dev *tdev)
> 
> I find the "sel" abbreviation too short to be useful. Perhaps lets just
> call "Selective IDE" "ide" and "Link IDE" "link_ide". Since "Selective"
> is the common case.
> 
>> +{
>> +	struct pci_dev *rootport;
>> +	bool printed = false;
>> +	unsigned int i;
>> +	int ret = 0;
>> +
>> +	rootport = tdev->pdev->bus->self;
> 
> Does this assume no intervening IDE switches?
> 
>> +	for (i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
>> +		if (!tdev->selective_ide[i].enable)
>> +			continue;
>> +
>> +		if (!printed) {
>> +			pci_info(rootport, "Configuring IDE with %s\n",
>> +				 pci_name(tdev->pdev));
>> +			printed = true;
> 
> Why so chatty? Just make if pci_dbg() and be done.
> 
>> +		}
>> +		WARN_ON_ONCE(tdev->selective_ide[i].enabled);
> 
> Crash the kernel if IDE is already enabled??
> 
>> +
>> +		ret = pci_ide_set_sel_rid_assoc(tdev->pdev, i, true, 0, 0, 0xFFFF);
>> +		if (ret)
>> +			pci_warn(tdev->pdev,
>> +				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
>> +				 i, ret);
>> +		ret = pci_ide_set_sel_addr_assoc(tdev->pdev, i, 0/* RID# */, true,
>> +						 0, 0xFFFFFFFFFFF00000ULL);
>> +		if (ret)
>> +			pci_warn(tdev->pdev,
>> +				 "Failed configuring SelectiveIDE#%d RID#0 with %d\n",
>> +				 i, ret);
>> +
>> +		ret = pci_ide_set_sel(tdev->pdev, i,
>> +				      tdev->selective_ide[i].id,
>> +				      tdev->selective_ide[i].enable,
>> +				      tdev->selective_ide[i].def,
>> +				      tdev->selective_ide[i].dev_tee_limited,
>> +				      tdev->selective_ide[i].dev_ide_cfg);
> 
> This feels kludgy. IDE is a fundamental mechanism of a PCI device why
> would a PCI core helper not know how to extract the settings from a
> pdev?
> 
> Something like:
> 
> pci_ide_setup_stream(pdev, i)


It is unclear to me how we go about what stream(s) need(s) enabling and 
what flags to set. Who decides - a driver? a daemon/user?

> 
>> +		if (ret) {
>> +			pci_warn(tdev->pdev,
>> +				 "Failed configuring SelectiveIDE#%d with %d\n",
>> +				 i, ret);
>> +			break;
>> +		}
>> +
>> +		ret = pci_ide_set_sel_rid_assoc(rootport, i, true, 0, 0, 0xFFFF);
>> +		if (ret)
>> +			pci_warn(rootport,
>> +				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
>> +				 i, ret);
>> +
>> +		ret = pci_ide_set_sel(rootport, i,
> 
> Perhaps:
> 
> pci_ide_host_setup_stream(pdev, i)
> 
> ...I expect the helper should be able to figure out the rootport and RID
> association.

Where will the helper get the properties from?


>> +				      tdev->selective_ide[i].id,
>> +				      tdev->selective_ide[i].enable,
>> +				      tdev->selective_ide[i].def,
>> +				      tdev->selective_ide[i].rootport_tee_limited,
>> +				      tdev->selective_ide[i].rootport_ide_cfg);
>> +		if (ret)
>> +			pci_warn(rootport,
>> +				 "Failed configuring SelectiveIDE#%d with %d\n",
>> +				 i, ret);
>> +
>> +		tdev->selective_ide[i].enabled = 1;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static void tsm_unset_sel_ide(struct tsm_dev *tdev)
>> +{
>> +	struct pci_dev *rootport = tdev->pdev->bus->self;
>> +	bool printed = false;
>> +
>> +	for (unsigned int i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
>> +		if (!tdev->selective_ide[i].enabled)
>> +			continue;
>> +
>> +		if (!printed) {
>> +			pci_info(rootport, "Deconfiguring IDE with %s\n", pci_name(tdev->pdev));
>> +			printed = true;
>> +		}
>> +
>> +		pci_ide_set_sel(rootport, i, 0, 0, 0, false, false);
>> +		pci_ide_set_sel(tdev->pdev, i, 0, 0, 0, false, false);
> 
> These calls are unreadable, how about:
> 
> pci_ide_host_destroy_stream(pdev, i)
> pci_ide_destroy_stream(pdev, i)
> 
> 
>> +static int tsm_dev_connect(struct tsm_dev *tdev, void *private_data, unsigned int val)
>> +{
>> +	int ret;
>> +
>> +	if (WARN_ON(!tsm.ops->dev_connect))
>> +		return -EPERM;
> 
> How does a device get this far into the flow with a TSM that does not
> define the "connect" verb?
> 
>> +
>> +	tdev->ide_pre = val == 2;
>> +	if (tdev->ide_pre)
>> +		tsm_set_sel_ide(tdev);
>> +
>> +	mutex_lock(&tdev->spdm_mutex);
>> +	while (1) {
>> +		ret = tsm.ops->dev_connect(tdev, tsm.private_data);
>> +		if (ret <= 0)
>> +			break;
>> +
>> +		ret = spdm_forward(&tdev->spdm, ret);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +	mutex_unlock(&tdev->spdm_mutex);
>> +
>> +	if (!tdev->ide_pre)
>> +		ret = tsm_set_sel_ide(tdev);
>> +
>> +	tdev->connected = (ret == 0);
>> +
>> +	return ret;
>> +}
>> +
>> +static int tsm_dev_reclaim(struct tsm_dev *tdev, void *private_data)
>> +{
>> +	struct pci_dev *pdev = NULL;
>> +	int ret;
>> +
>> +	if (WARN_ON(!tsm.ops->dev_reclaim))
>> +		return -EPERM;
> 
> Similar comment about how this could happen and why crashing the kernel
> is ok.

In this exercise, connect/reclaim are triggered via sysfs so this can 
happen in my practice.

And it is WARN_ON, not BUG_ON, is it still called "crashing" (vs. 
"panic", I never closely thought about it)?


> 
>> +
>> +	/* Do not disconnect with active TDIs */
>> +	for_each_pci_dev(pdev) {
>> +		struct tsm_tdi *tdi = tsm_tdi_get(&pdev->dev);
>> +
>> +		if (tdi && tdi->tdev == tdev && tdi->data)
>> +			return -EBUSY;
> 
> I would expect that removing things out of order causes violence, not
> blocking it.
> 
> For example you can remove disk drivers while filesystems are still
> mounted. What is the administrator's recourse if they *do* want to
> shutdown the TSM layer all at once?

"rmmod tsm"

>> +	}
>> +
>> +	if (!tdev->ide_pre)
>> +		tsm_unset_sel_ide(tdev);
>> +
>> +	mutex_lock(&tdev->spdm_mutex);
>> +	while (1) {
>> +		ret = tsm.ops->dev_reclaim(tdev, private_data);
>> +		if (ret <= 0)
>> +			break;
> 
> What is the "reclaim" verb? Is this just a destructor? Does "disconnect"
> not sufficiently clean up the device context?
 >
>> +
>> +		ret = spdm_forward(&tdev->spdm, ret);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +	mutex_unlock(&tdev->spdm_mutex);
>> +
>> +	if (tdev->ide_pre)
>> +		tsm_unset_sel_ide(tdev);
>> +
>> +	if (!ret)
>> +		tdev->connected = false;
>> +
>> +	return ret;
>> +}
>> +
>> +static int tsm_dev_status(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s)
>> +{
>> +	if (WARN_ON(!tsm.ops->dev_status))
>> +		return -EPERM;
>> +
>> +	return tsm.ops->dev_status(tdev, private_data, s);
> 
> This is asking for better defined semantics.
> 
>> +}
>> +
>> +static int tsm_ide_refresh(struct tsm_dev *tdev, void *private_data)
>> +{
>> +	int ret;
>> +
>> +	if (!tsm.ops->ide_refresh)
>> +		return -EPERM;
>> +
>> +	mutex_lock(&tdev->spdm_mutex);
>> +	while (1) {
>> +		ret = tsm.ops->ide_refresh(tdev, private_data);
>> +		if (ret <= 0)
>> +			break;
> 
> Why is refresh not "connect"? I.e. connecting an already connected
> device refreshes the connection.

Really not sure about that. Either way I am ditching it for now.

>> +
>> +		ret = spdm_forward(&tdev->spdm, ret);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +	mutex_unlock(&tdev->spdm_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +static void tsm_tdi_reclaim(struct tsm_tdi *tdi, void *private_data)
>> +{
>> +	int ret;
>> +
>> +	if (WARN_ON(!tsm.ops->tdi_reclaim))
>> +		return;
>> +
>> +	mutex_lock(&tdi->tdev->spdm_mutex);
>> +	while (1) {
>> +		ret = tsm.ops->tdi_reclaim(tdi, private_data);
>> +		if (ret <= 0)
>> +			break;
> 
> What is involved in tdi "reclaim" separately from "unbind"?
> "dev_reclaim" and "tdi_reclaim" seem less precise than "disconnect" and
> "unbind".

The firmware operates at the finer granularity so there are 
create+connect+disconnect+reclaim (for DEV and TDI). My verbs dictionary 
evolved from having all of them in the tsm_ops to this subset which 
tells the state the verb leaves the device at. This needs correction, yes.


>> +
>> +		ret = spdm_forward(&tdi->tdev->spdm, ret);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +	mutex_unlock(&tdi->tdev->spdm_mutex);
>> +}
>> +
>> +static int tsm_tdi_validate(struct tsm_tdi *tdi, bool invalidate, void *private_data)
>> +{
>> +	int ret;
>> +
>> +	if (!tdi || !tsm.ops->tdi_validate)
>> +		return -EPERM;
>> +
>> +	ret = tsm.ops->tdi_validate(tdi, invalidate, private_data);
>> +	if (ret) {
>> +		pci_err(tdi->pdev, "Validation failed, ret=%d", ret);
>> +		tdi->pdev->dev.tdi_enabled = false;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/* In case BUS_NOTIFY_PCI_BUS_MASTER is no good, a driver can call pci_dev_tdi_validate() */
> 
> No. TDISP is a fundamental re-imagining of the PCI device security
> model. It deserves first class support in the PCI core, not bolted on
> support via bus notifiers.

This one is about sequencing. For example, writing a zero to BME breaks 
a TDI after it moved to CONFIG_LOCKED. So, we either:
1) prevent zeroing BME or
2) delay this "validation" step (which also needs a better name).

If 1), then I can call "validate" from the PCI core before the driver's 
probe.
If 2), it is either a driver modification to call "validate" explicitly 
or have a notifier like this. Or guest's sysfs - as a VM might want to 
boot with a "shared" device, get to the userspace where some daemon 
inspects the certificates/etc and "validates" the device only if it is 
happy with the result. There may be even some vendor-specific device 
configuration happening before the validation step.

> 
> [..]
> 
> I hesitate to keep commenting because this is so far off of the lifetime
> and code organization expectations I thought we were negotiating with
> the PCI/TSM series. So I will stop here for now.

Good call, sorry for the mess. Thanks for the review!


ps: I'll just fix the things I did not comment on but I'm not ignoring them.
-- 
Alexey


