Return-Path: <kvm+bounces-57254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB7EB5224E
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BFBF56058F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CB82F39BF;
	Wed, 10 Sep 2025 20:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gxTVt1uY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F42F0661;
	Wed, 10 Sep 2025 20:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757536024; cv=fail; b=F0Zmet0bC8mWbYxXu6Y73FAZ5HsbUx8OfggFBLcTV0xS/+o+gL07vmhaxSarahRyYCA7yS797ToFPlmR89gPHOrstXMVjExBf8NQpwVxkpvuIjsf5u1+xelnofbC9zFD76LkDzMaQwMA9Cbc207h/mKwlWYrK4zxSckT2nP8NgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757536024; c=relaxed/simple;
	bh=jSlX5lGtZMgPBNnKD4eY83Ii8V8niqWelHbR7tZHelI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DyniY9WoEzivItu6D4Yq6TMY7oZf8kagchByvfj5Ylw3xmsC4j3nR7rQOZPCRkLUPunonC4W9N7p8AMSRNAAa9yYlB/L0ouc7T7g7J/3gBce44E83+m35wLtlXQEGynvznRHP/8YtSNn+GgL9xBmuMXsY8H9xx8dB67UnQsQ7CA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gxTVt1uY; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VCIshQpmDV0N/lTBqvORVePPXqVs2bz/558HWQhFkdE3M+VfKhSleRVNqmonX58R0PGmtgxvWgWH0fkxs1OR86b8g3FzAdyTG7hZ6/d3B2X8GtOJt4YQsZnOef+mL+44ZX926Sxyyi1vjh/wQwc2nondg+NTOgzRnD6+Uw91UQOpwhVhLEcwqxorj7CxP99MVidGqDdb4NjgdLmbbvChocuPc1F53Pq4WWzYHpE7bL229BE37JEHTnLPz0n4t6PYjzyqqPhJAQvSQewQSuNItNv9RjDoM/iBABgAt6NJFdojSQO+/jWC5oj4FtyLY7hfnAI7khr6jxSc8rLwMdzKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/jyQtgovVnfSfziaeSmCZULRwqpB28a81Sb/l4lDXo=;
 b=uP9fc4NJcauouORL0e+maK1Gp2X1olicLxOQqnCkrmwlAhViBwLmKhPfyDNF/1qwhUkNS4qstDCoOQCXfLzhqzHOSgiZ6rd30HteiF6Q+rczX3iDIBVrSbqFU9G/TcvXjlbAzWmr4II21K1ewUPLZj0gJh9H4UuIHU/T8CDaY8KNcRuaxcesT60txEGeknTDgpR3hVs/hmrV7lX5cjSr9Q9IU6Nd9oMmZf2mY4D0Vchfp9f7qJNjl4rKphKEki8aZTOo7curKUP1FoPdgRSxeuhXtkY4y42//rkDBTYXboXWtDU/X86pVr2wvZek2nRuiVoBvhdhNG/FnfzOjvRBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/jyQtgovVnfSfziaeSmCZULRwqpB28a81Sb/l4lDXo=;
 b=gxTVt1uYelOu7V9LJE3gI3OlKHhvPEogLpp3pRpikkokkqTQA5ogkgdnFWcNir0xb6zyib6T0eNjLAXdm38h2AR8Hb/gA5EIJ4F4S8jMYFsbbpZR8yepesM6C4hlAOODY6l5RuBZrUXVAvde+pz0JoF326QPzxGwEkWNCP8TewU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by MW3PR12MB4395.namprd12.prod.outlook.com
 (2603:10b6:303:5c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 20:26:59 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 20:26:59 +0000
Message-ID: <e3136d56-6b81-4d9e-aca7-d22a14eae49a@amd.com>
Date: Wed, 10 Sep 2025 15:26:54 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v18 14/33] x86/resctrl: Add data structures and
 definitions for ABMC assignment
To: Borislav Petkov <bp@alien8.de>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
 akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
 pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com>
 <1eb6f7ba74f37757ebf3a45cfe84081b8e6cd89a.1757108044.git.babu.moger@amd.com>
 <20250910172627.GCaMG0w6UP4ksqZZ50@fat_crate.local>
 <1096bc24-2bac-4bc2-bc4f-9d653839e81d@amd.com>
 <20250910195938.GAaMHYqjfOdFQmllbQ@fat_crate.local>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20250910195938.GAaMHYqjfOdFQmllbQ@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0126.namprd11.prod.outlook.com
 (2603:10b6:806:131::11) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 89d24d33-509c-4e07-d8d4-08ddf0a8648c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qjh1ZU1Da1c0L1NSNmR5MDA1OXY1K1pudnlRVkhLdW5BbnEvbHpON1lOcFli?=
 =?utf-8?B?V2JRT05PNE9TZFBESHErb0pMNmNGejFNY093RGdkOHJoTXd2OUN1R3ZndDJo?=
 =?utf-8?B?aUxFN0tVV2FlK2YzcTdTZ1g0WEN6MEhISU5LQ2JLOXBFcFZpelp0ZzllNUhj?=
 =?utf-8?B?eXBoUTZKcXcxZHZQaDVUWm84VmlOTUROWHV0Slo4c2lLSWh0dWV2SUlkR1U5?=
 =?utf-8?B?ejliKzBuR1A0T0h1dkdybzQrenN1S1FJcWZZWUV1QWFUck1NRjBuNXcyMGds?=
 =?utf-8?B?cTRQYzBqYmRSMS9NTW1XOHk4MzNld2FiZzRDMGVqK01Rb3h3a1JIRmFvb3hy?=
 =?utf-8?B?UVo5MEplS2NMVDlOeVJxcW96dkZJaXhCalJPcFgvMmZ2M2Vxamp1bU5oRlQ4?=
 =?utf-8?B?dXNCdkxDVWdISjNlQlhwaHVUc2ZrK0pleDdORDIzdzVtR1NkRFZPL2tPSU5X?=
 =?utf-8?B?YkRSdEdYRVFqWW9EbHZldjVUMU4yMWdpUUU3NTd3WmtJV01ydExEd3RteWdj?=
 =?utf-8?B?bk8ycVV5ZUM0SVB0b29UK0FGTE1acGp4bXhrcHNZdmVPdmM0OWVxOTBYelFi?=
 =?utf-8?B?eEcxZ3ZPNXFkOGViN252TEx2eTk2U2RSai9SRFcrdThJRWlIaFNrcC9hRkZt?=
 =?utf-8?B?Vm1ZQllOanpuTXprRE9FUzh4bTN3L2FIVmtKTzZ1VWVUb1Z6bzM5bVU3ZStQ?=
 =?utf-8?B?UnViektLVFVvYldXM2FJZm9lQ1NXc0ZxVGt6c3lTT3ZReVFBNXpFQUNsSmp6?=
 =?utf-8?B?M2dFS3FYcVBsNngxYmpTSGM1SDgzUUdjaE9jTWZRTXlxcU9iMnJSWDVyaDI2?=
 =?utf-8?B?Znl0TUNieCtIeXlyY0lHdmdjTU1MNDFVRnZqQnZkWUVObVFnaXRteUZzeHMv?=
 =?utf-8?B?V3M5K1RWcVlnRE5KZkl1ZW1iWHg3TnlPR2JoSTcwbTFxSnRIc1QzQTQ2RWl4?=
 =?utf-8?B?M1dpRlR4VzVxRGxuU2hMSk40Qy9pbXorRjlJRTI2ZWhjVGdwcGlEaDJKRm9E?=
 =?utf-8?B?UHVYdy9ndmVHT0VrLzVNNmltTWV6Z081MWtla1U5ZHRWdmpPSUFEMkNtbUNt?=
 =?utf-8?B?TGVmM092ODM4UWRaSlFiZDBUSGdXRXVEUTFZdmp3V0ZmQU5GNXVQNi9qMkVn?=
 =?utf-8?B?dXV0NnJ4aVlSeWFZN0VjUlFmMjhFRDNlNXlaYnozbmQ2RnVGNDl0bUxPazJv?=
 =?utf-8?B?S3hDYmNHUXFOZm9xc0NxNTRFaURXTldOTGx1TmhPdVlZWE1FUGFXRDJ4S2tZ?=
 =?utf-8?B?OGtFVm5DTnZSL25sWjBjMnB4YklhWC93WFRIdGF1SUZYeVJaTGFhYkpjUUN5?=
 =?utf-8?B?WnQzOUNGTDVkeUcwcjRlNlo3VFhUdjJ2ckovQlM1Y3QzUG85RS9MWHk1aG4w?=
 =?utf-8?B?NmVvaXJ1dTl0OEFGTE9OMmJMbG1iMHRabXhLcTdqU2dtaSs4MnpHZUJ1ZHpU?=
 =?utf-8?B?NWI0VFl0VGlVb0pwQVk4cWNsN3NEbGt2bkw5cFc5M3dCYWlNd3plU0lxQzJG?=
 =?utf-8?B?U1dLaWxQWHVZcE9MVXpBYTh5V3NPcWpHNHJ5MHYyYld4ak1EWHU0akIxVlNI?=
 =?utf-8?B?UGZEZ2xmTTcvajVMakJ6dUkyU0tCTzVPeDVvVlRyRkgzV1QwY2s4aGUzUEZv?=
 =?utf-8?B?a3lqWXhnSW9KZjEzeU9wTm82bnpTWlBvczM0R2pXZnhCdW1SN1EvYlIycGlh?=
 =?utf-8?B?RUhUbFZFY2xWaWNteHpXTUQrc0VzRktSb3FjRGJFcEdsR2xmZHNVc3JyVWov?=
 =?utf-8?B?MjN6OE9sTEk5b1JTUUEvcitoTy9UcW84SURBU2dSZWpIT1JPMXlVNEhQRW9B?=
 =?utf-8?B?eWh5WklVWVVEbnlHZERUMU8rK0FURGdXRldpWnh1VzhkUnJTN1JXSWswYTVw?=
 =?utf-8?B?S1plSlYvdFYxVXF4eFpFTlByNGtMVWpzSU5Qd1h3b2xkbE9oQXhEZWxWSXdl?=
 =?utf-8?Q?U5vopcUkKoU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TW9tMExzZDZEbW1Bc3A1SGFZaVpUS1hRYnorK2JTa0VvUmxmeXNlUlBsY2lT?=
 =?utf-8?B?SnJpb01sUnFSLzQ0Q0E3d3ZDUjcxaW9GWWNaTCt1eENQNWNIbWNaSnlrY01x?=
 =?utf-8?B?V1UxMnNFcWtGRlNhVFd1NG9CaXlEZzdsTURReitiRjYveEVrbHc0elp3OUx5?=
 =?utf-8?B?VTlseTJjbDB1bWN2QVE4emtJN2IrQTk1Rk81RUJNYU1nWmRPNVB2YndadmlV?=
 =?utf-8?B?YzVPYUhnbGpwNVVNN1pEUVJKWktCVzdYdGJXWkpzYjUvbmdqK2gxMW9sSk1Y?=
 =?utf-8?B?cnVTdzdBb0E5UFpGZzNiYXU5em9GVy9OZm1MRitlZTlmVSs3UE9JR2JrNUdU?=
 =?utf-8?B?SzlTWjNFK2FBRDZ3MlFvTENWV1dqYW9mVTM5OFZvVktYRzF0UHJSZkJsVjF0?=
 =?utf-8?B?RVB6TlJhNWh0Vi95bkZDZEJNTzhuYVFEL1dQazc4YVRDQUJCS1JHVStjbnNr?=
 =?utf-8?B?dllwRjBmOE9JdUcvanI0a3pPbkFMUkRZOHJZcDBpNFhRc3hmRC9LYThtQzd2?=
 =?utf-8?B?Qm1YSnFveTNlNU1QSnJteWdyUkJvT3djdVY3enZTanlBYjdkV2thTUlSTmlI?=
 =?utf-8?B?QlRwczRuT1BHaFJTQjRwS1pRa3d4SWs4Qzc2MGlINmZza1NNVVg5K3NTellM?=
 =?utf-8?B?TlhqVWJBSWJMZlhuajVZZzg0ek9iSkJZZXVyTUd5Mk50RTBMV1I3RGZnYjlS?=
 =?utf-8?B?T3dFWi9EUEQzdUNmTWhjSE45djJ5YUlXam9qUDFRZURTS09GS3hwNjVKKzhv?=
 =?utf-8?B?RE5qRW5BTnBXejZMTzNJMDd0VUQrYURqZURxdnFNTDRaSDY0NnZESkplb0xX?=
 =?utf-8?B?bzZRVWxyN1haYjZWaGhDVU1EUXkvOWk0TzB4TE9BYVgyUWVLcXRKUFNYaHVP?=
 =?utf-8?B?Z1hSWVB5QVM5M0FCOXNpeHd5bVcyc1E4YXNySDBGRGpaSzlVRnU4MWtReGk4?=
 =?utf-8?B?VktFbkQ4R1FZVlh1dTd4YVBNWm04bS9XQ1Bra2xZNnRQMnd2L1doeDdUWW50?=
 =?utf-8?B?L0wrZ0lNOFdLbGtXZG9CWVFFTmluS0xJa1FLdXFveXIxTXQwcFZDMWlOOGZp?=
 =?utf-8?B?QzFtaHpYU2FremVDNTYwRDJkNG96eCtmUCttYUlORGNLcGorZ2lBTFZLOFAw?=
 =?utf-8?B?Mi9RNGtFdWRiQzcwTE5aQ3pKY0JFUmVTUlZxL2pKNnlvVnYwbWZESlRvNDhJ?=
 =?utf-8?B?d1VGTGMzZXN0U0NIbjVwUjF5N3pXMmZuRDBZV3FyUTlKYUdkZk5FVEJXWlBq?=
 =?utf-8?B?RU9zOUpnZWRoQWw4bkgwNC95QVQyRGtEaWorSXpoOXFacGd1c3UwK1BuY2hl?=
 =?utf-8?B?TjY1dVpBaklkQnZ0c283bVRHRk15S3N5aEFZbmR3dmVhUTNGKzVGaVdhaTZD?=
 =?utf-8?B?d3ZCTDFRS2VIOUhZMHVqZS9vdS9GSVBldE4wQkxGb1U5YlRoVmpvWFdzM1RH?=
 =?utf-8?B?YTRSY3FuYWlKSzl0TTdOVmlJNnllYktVOWoxZmlZUmtqUVZ4YU5OVEJzWkhu?=
 =?utf-8?B?MEFxd1hLMUEzV0UwS2RISG5mY0RXa2lLdGJsMDhSVzZqOS8vbnFjV0pOc1Yy?=
 =?utf-8?B?OG90V3ArWENWdlRySE14ZlAwdTdBRUEzVkFyaDF2czNpODdxbWhESUtCYUFm?=
 =?utf-8?B?d24veVZ4SVhTSEluUUNWRVFsenFOakl3VlhZL3Bmd1lxMk56dDNROFFvcHhp?=
 =?utf-8?B?UGwyNVVGSnJ2d0M2SExCVElUWFdpQzJubnNIV05uRjVoNXhGWmV5WDF5R0pz?=
 =?utf-8?B?dDBmTDlOZlZRN1VRSEptR2Y4eDNJYmZXREo1RWZrdHdmMUhPYUYxQ3FPdHdm?=
 =?utf-8?B?TnNLWmdCZUJiM1JCZzQvMHo3OFFlVjdrNURZcnp1YzQzNHhUbXl2UDNOMi84?=
 =?utf-8?B?T3JQYUJuUGNmOW94RDhCMmtEaVdGTXNEZk5HalFFck1XTWtOTk0yb3B5ZW8v?=
 =?utf-8?B?TjMwM2hnaThGM2laU0JtT2xrSFJzWUEzcmJxT1BXOEpQTHdOM2xhY2VJNXpn?=
 =?utf-8?B?VGl2b2l6enJKOW5YRHBZeGZONGlYK2JTQUFYKzVIcjZyejFtaTl3OElub3g0?=
 =?utf-8?B?TDJvVjJpT1VTanEyYlFPbHB6YnQ4djJOUlcrT1NUL0xrOVl2T25oVmw1SWFo?=
 =?utf-8?Q?yvm4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d24d33-509c-4e07-d8d4-08ddf0a8648c
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 20:26:59.0444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVtOeGgAlUGSzz0sJVdJhCvnKjcstmrt2P/rEKFnqiIpEA+uNNCEydmg19lisbGv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395



On 9/10/25 14:59, Borislav Petkov wrote:
> On Wed, Sep 10, 2025 at 02:49:23PM -0500, Moger, Babu wrote:
>> No particular reason — it was just carried over from older MSRs by copy-paste.
>>
>> In fact, all five of them are AMD-specific in this case. Let me know the
>> best way to handle this.
> 
> You could s/IA32/AMD/ them later, when the dust settles.

ok. sounds good.

> 
> "AMD64" would mean they're architectural which doesn't look like it ... yet.
> 

Yea. That's correct.
-- 
Thanks
Babu Moger


