Return-Path: <kvm+bounces-49371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A67AD8338
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DCDA169580
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF2B2580CB;
	Fri, 13 Jun 2025 06:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CEedpE4z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F233B253950
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749795949; cv=fail; b=hvvGTGMvG9+l38P14I+7cIPzCIZOb+S+SYqbWdk6KjWJEMgDzhyawbueOGsydJzKYFn76QHVfmUhl3FZNcHfOl3LxX2eXQkoSuxWlaHnDJ7LZuiuDWRs0C87EzbKbi81o6kSBa6va8Xmg8eQRRYrpeoeFx2ljg/WNxxo7RHvSys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749795949; c=relaxed/simple;
	bh=DiJ5OMuv6+2lgP0fLbX9ebW325zo7IIM44lcRhLNqvU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q/Nep8nu+2mxRYtvBTr7atLsdT3idk7/Wa5TY9cbchXp3vzGUo0uvEzPjpE4u5JufZ8BE9ZFs5RbSF56Yi4ehzf1zhKZpsxZQyTFbgLG8YApwJ9+08mBLLoSg/FRfQJzZgDyneRY6l/U95BJqahFCrjWB4kAGdeYr44Te5h3jzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CEedpE4z; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cw6+/VmY+6Kj//kjWMajHYHMAZXSfgtYIWcp0vOXNvfP+4smMd9xpK6mTHo4CVV6J7gaTwKuZKO/Z2lhP2O+PhSrbe7PvGnZYwcyLzkejyxRjxYJYMbuGivL3fER+6Ftwt7sLklxaiW1LEMDTEaVcVlQeBeD4OPGDHQ/cFgkaQ6Xi6nmo0O+XxFuG/k8JZBLXpJ+GavlC5ZOe/k1jLBW55TLbWmY7QMknBd2O2//MBqgH50UFYF8QEO5q03PJcCExuMoJdcBa9JiSeSN3n2ayxLd2ezRuMzJACAEgy2PrGnbxGItYyPODFzFlwoCNWKIfFDd5GvWlyHJxZu8WPTuxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKHKbmvUeXIA7NeoLoGpMkXM/0O81op/ZNhu5gtwArE=;
 b=Zz1EitZcx+G3rY8NydakFDlXD2zmiA0tjj6eWlh10HerjANba/4zURlY4CktzQwaBRSJZMhUk5b5nigQuycf8ICANyBvt4Ru6rRQTBvNcPAymT6BzwL34P8zVHrpndschjUrzpL6YMpzYr8hhc99rBugJCL6q9WzaQM9PWKjfWWu3IapuygKKlqCLNSzYlibZSJgQ4BMGS+ZIbd8lSaih8i3tt0qob7FwQSS3oqK6dinPfVNriqdzCaoSEmxr1ETH3o01CFU+o3LFdd83mEQZDNquVxN+HWAUk3fSHfXYWT6OS9FOaV2NIceJEh26l+vF45jzA7Ts8mHEOmhnf6gfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKHKbmvUeXIA7NeoLoGpMkXM/0O81op/ZNhu5gtwArE=;
 b=CEedpE4zRlNvWbzDpJVbZtglW2my/OnlmSW7c1o5CuNJ3QxODdgy8vL7y+VA8Biru8PBx0QAgkZTwfYosYgwdKGTm3yeEZWPzKGDmPgaHyilMzy4mJA9hrHHpB9xxDz0iKB+vSWIxu4eYcGxqDVcow7q9Z3TuiXPXrqamDSH7zA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 06:25:46 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 06:25:46 +0000
Message-ID: <c7c4fad5-a8a4-423f-9a5f-4a6d1d0cac4c@amd.com>
Date: Fri, 13 Jun 2025 11:55:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 08/14] x86/pmu: Use X86_PROPERTY_PMU_*
 macros to retrieve PMU information
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Liam Merwick <liam.merwick@oracle.com>
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-9-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250610195415.115404-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0012.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::24) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d8c760f-ca14-4116-8d2d-08ddaa43216e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emZFblVqc1VUdlBlUVVObXhxdGxNQnRnZUJSZWUwclZrcFV3SmVBQXZUOWtt?=
 =?utf-8?B?cko4VHd5TEkyTjNwektpYTBaUEZQOS9pR0tHc0lqTTYzWXRvU0xHdHp4Vnpz?=
 =?utf-8?B?S3lOVWVVVmdIaGtCUUhxcEZJaDNnMzJvOGlCdGVuOTJucmZ0RjVXZGZIUEdT?=
 =?utf-8?B?RlZLK1VYd3Nqek1WSG5wdEJlSDFMK2NLbGRDRm1GaHl3eEdWd1lyT3ljcmlL?=
 =?utf-8?B?dG9PSHJmVmUvelZSTHlhc0VObXRaUjA1c2ZqQWNZUDJqT0VqR2JXUEpYNk9D?=
 =?utf-8?B?b2JZcjVwZXQzS2VkSTF1V0FpcTkrRWkrRllKMlRFY1lQMkdxN2pyNXowOFB2?=
 =?utf-8?B?ZXo2SmVIZTYyUS9rb3RFYlI1SnU3cm55UU9zMjlMaDFrdVBML2xyc3JDd3I5?=
 =?utf-8?B?NGRDb1lZbTFqNzdrVmovbEsvWGx6S3NQUFd1YkNlbDFTSVVubkM1azdQdWlj?=
 =?utf-8?B?cklRWGFHdXkvY2FiclFQKytPUStKZmJSUVdZUmwyQjFKdndEYkFEQnVGR1BP?=
 =?utf-8?B?T2E5czdFOVFsTkd2MzBNVWtTTURoejlMSkdubm5MbTk0dEs2THViRUhXZ205?=
 =?utf-8?B?ZmNTOVBURGhKY1NhRUw5MVFYL1Z3VmI2QWl6aGJyWHhaQlA0NzhFS1pFdllP?=
 =?utf-8?B?MVBCancxa29qbXhFc1dYUTNXdnRha0JBM21lVUFTZnl5VDVBNjgranJGWm92?=
 =?utf-8?B?RDFJbjNvVCtrSlJQMXRGY2tuUkcrdWtiS01mWjRRSDNwTFBlMkt3a1lMc0Jx?=
 =?utf-8?B?dzJBdDhhNUliSU5NSzVoRFhjenZCb2tTSFZMTmU1OUxzUmVpYkdNTzhmV0Fk?=
 =?utf-8?B?QTNnbVBBQmxGNmNCSVNiUU1FeEprWnlLdkc3ODl1TTg3QTgyTXBycG12aW1H?=
 =?utf-8?B?VWUzcnVIUzFTMTNZK1NjZ09DWGRBTzFqNUNhQzM1UFhIZ2JjM1hDNEgzOU9C?=
 =?utf-8?B?TVJCTDhPMWFNbmhodHJ4UzI5d3NTTVdKWENiV1FOWXlBcERlc0x0YWM4VkR0?=
 =?utf-8?B?bDduNzBuMFM1Y3pyZlQzRlNkUENGYlVhSFA2NXlWWkNqYmhzOGR4Uk1VUmMv?=
 =?utf-8?B?V2dhOHhxeXVLbnZPUkFlUUhaTFpTZGRVK1lSazE4Vm9QbmFsc3BuVkJXZjR2?=
 =?utf-8?B?K01URkwra2d2VDZzWk5Qd080WXNnSGN6MmVVR3Nid1E2V0tTWDNDM0VUenM5?=
 =?utf-8?B?YUMxdFZvQ3dLVUgxSklGTkRHcXprM3RHQTAwViswdnVWQnpBSXhSZVJ5NzFv?=
 =?utf-8?B?djQrL0FmZkIyOWhwdjNLWjVKMGdXRXlYZDhKR3NDcjRwUmgvaW5MaGgxaU04?=
 =?utf-8?B?K20yMUh1YjhWVFNOK3pzVWhaaXdDWDhaVW4wNVExK1huY2tYc0E1eVN3T20z?=
 =?utf-8?B?eWRuSWhIYWVzemRqZlN5Mlc0N3lOVU9ibkpOQVNqYlVwUjFXNTZ2Q05rZkkx?=
 =?utf-8?B?YklZbUZwdXNwVkRIa3JKbnFzNjA0MGRNK1lxU0l3QzVpbDlhbEJCTGh2Tkox?=
 =?utf-8?B?dzBpSFVnQ1pCeFR4eTIzTVgyQUI1T0tsTTduRXdxNkZGckpreGtNU0trRmwx?=
 =?utf-8?B?N3J3MlU0RkZzVUowSGdTN1JxeEU4NnFHaWw0VjkwT3BRaFYwUTVnaG5tTGlE?=
 =?utf-8?B?alFFT3lSSHJrNmxHaXZNQ0FTSTRsd0xSM1hpQm5TU3JOa0pQeHhndU1uTzJv?=
 =?utf-8?B?ZVdURmIzTEE3dkdobkZRQWpBMXZ6ZEFLdTEwM2dycW0vdDBTVTZFUk93RHJa?=
 =?utf-8?B?Z2ZjUEdHN1RQRDJIckgrYThERHlVYUMxYlJkNTdicjJsLy83VW9UZHpTZWhn?=
 =?utf-8?B?am9FdVZndTBRb01Yc0N1S0FydTFXdlc3YVdPdzNZdjJzNGJucC8xNlcxTzEy?=
 =?utf-8?B?eFE4MFR6eHQwbU8rR0wzbm9MS3BHSldrd3gzYXRLOUdhamUwOGpQMkVaTStk?=
 =?utf-8?Q?zBJt8gXsRH8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3lkMXV5ZUJPU00wOXNpN3hzenRHVFFJZ0FLM3hCeExNTk1UcVdBSHlZaitP?=
 =?utf-8?B?MTQyeExjWWt5T01KTVZyL294R3BsK0F5bmZmMGZqdzZOVG4wT04raXhiOUor?=
 =?utf-8?B?ODd6amtVc0VwakpnTGQvUjR3cDIybzNNWW1LN0dOeHFUSVZUU0x3d2JpVVpy?=
 =?utf-8?B?dDA2RE1hRXR4a0dmajdVNTAwS293bjFtK0hxbVgrL1BYOFdFVjFxRkh0TUZY?=
 =?utf-8?B?RGVSckhudjR6TmI3QUVWZmhuUFZRUlc0NmpEaG9yRDNZN0lVZEw0b0VUNFl3?=
 =?utf-8?B?N3JrMG0yNUkyNzVRajFXd2N5bGVES3VRSVdhRWpKZy9PUHB0UFhZejY3eVRD?=
 =?utf-8?B?dUF6MjNoNS95ZzFudDVUMnVkcVVNbnkrQzM2ZTNKKzhRazIwOHJUaVQwZUNm?=
 =?utf-8?B?OVR3ZmNoQkZaaGxUV2VvRFRyK0sxSEhQam0rOXNONk9YVktVSytjZFk0bXlN?=
 =?utf-8?B?bllRTVJ1N3U2dW00MTJTczVyNmRvM0VqZ0l1cnJqU0hjN05YNDlBUy9ZSkt4?=
 =?utf-8?B?em5JQXA3L3hwaTdlVUpnWmswT2FyamdaeFlOT1YxZTdVVkhyT1RRLzh6QU5T?=
 =?utf-8?B?TnF1b2JCTjc0aGNrNzFhTTlRbXFPSzU1SnlHSC8rZ0RURmdyTms0WHlxUndp?=
 =?utf-8?B?RGVqdS9IU0p0Y0FKS01IY2k4a3pIRmFpdGtzWjNkNjFaT0tUaGkvYVkzRURz?=
 =?utf-8?B?VEYzeVZ5RllGTlJqend1SW0zTCtmK1JoNTRFUG8rMFB1RWpPT1ZUOGc2TFdB?=
 =?utf-8?B?UUJjcStOdXRzS0Q0QXhjUWdmZXovMkt5OGpnMGJWQmJ0ZFFZRkVVZHdneGVS?=
 =?utf-8?B?d3BkMGVIWUIxMVpob1Y1K0dnQVBCZFpPYXFHNjJrMzFxRFptMHlLSjVYTGpJ?=
 =?utf-8?B?M1RPZi83RGZwUDVqeU1meUpQb3hpUUpXRWJrVkhUbE9PWDlzNE51WERMV3Rh?=
 =?utf-8?B?SysyYzJPQWlETEl4TG9UamtyS2JiWWVGLzgzZDd1TTcreS9kRjJzbnFxODg2?=
 =?utf-8?B?dUdQMU1UMVpXc0oyMXJDR3Z4Y3FDaVVpNUhBTGh2bUt4TEJIN0I0eXA4SXpJ?=
 =?utf-8?B?OFViYXM3b3lUUUVWbHduU0wweWk4TCtjb0pOYldlVlZXWmRtZW9jek16dW82?=
 =?utf-8?B?VzZDc2ZFQUcrbFJhYzQrYnJxNk9pNW1aaFFmL1pjaDhDOUY5TUhFNTFHT1l6?=
 =?utf-8?B?cDRsbEVLSEVIbGFuaklYSWFocTNNYkd3TXNwZTFVR0o4V1BxeGE4OWFtSU9N?=
 =?utf-8?B?Tk03UGF2clhra3pJUHFSV2VmN3IvRndsdHRzSm5hOVkyKzN2c04rK1RhVHJx?=
 =?utf-8?B?UGtNOW1oNHNzOVp4N2lCK0M4NHMvZ25yQ2R4TUVDOVRyRU9Qb3JYOEtLbFpu?=
 =?utf-8?B?M2xBUWo0REFJRWxUYkdpby9EN3IwUXZIa0M4WEFjMlJ2NERYOTE3SlVaZlJs?=
 =?utf-8?B?TWcxN1ZDZEx2Ull2eFhTOXUrWmx0dVJMTkpNaTd3SEd5U0Jud1BDWnNSdmN1?=
 =?utf-8?B?dElidEhhRmNnaWZPQWhVaTFCU25zNFBlamJLeTAxOWZCMjFZRDlzVVJubVRX?=
 =?utf-8?B?aGtOdDY0QWNFNGhJVjRDSllBVEhwRDJDeWRsNVgzTS9LWmh1Z3crcm0yU1ZE?=
 =?utf-8?B?UVJvWVJUdXAzUm1EemYrOWpyS3FGU0doS05HOE9lUWJZa1VBZCtDSHBTbjZK?=
 =?utf-8?B?YlpjM2VkOU9mUVR6V0RmY1MrSmJCQWdoNzN4cWtWcVhGcDBmcjJITllnMzVX?=
 =?utf-8?B?OEtoZ1VYUlp2UUNIM0ZRSlIxL29sT25kMUZYTkxaTW9KVWFWMWovN0ZVb0RR?=
 =?utf-8?B?dHNaZDNqUlhjZ1BxZVhKYjZONkVCL041YkI2VmxHelB5NXl3alAxWGJLQ09P?=
 =?utf-8?B?QTk4bzRVY1JBcGpXWndhMW93TVhWYVdmckZlakNPcDFUUXBUdTRKeFM4bUx0?=
 =?utf-8?B?ZEpjS2NlcjM2eTNOWGtGdWxrazBGS3htVExaZ2JQVVNRNlkxaXczNjdYd2JU?=
 =?utf-8?B?cFVuL1lobEZOTERGUFBZaUttYWFxYVkrcnBvVlVKd2xlNkY4UW1lcUg5ZUZ2?=
 =?utf-8?B?ZXAxNjkxZHJuTlUwaUpackRONWNEV3NKYXY0STJtL0gyR2lRb2QrQVRBSWhS?=
 =?utf-8?Q?s9NWSNqDBfFGsRNT8a9AWlQiI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8c760f-ca14-4116-8d2d-08ddaa43216e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 06:25:46.0866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyzqAmBFCS1HhkfH1f4DnS1bmikE+oUH6GuUB62+62ErtJ5AP4/rWaCtmIIPmiv3BanWbPqfPdDkTjgfdQ4Shg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392

On 6/11/2025 1:24 AM, Sean Christopherson wrote:
> Use the recently introduced X86_PROPERTY_PMU_* macros to get PMU
> information instead of open coding equivalent functionality.
> 
> No functional change intended.
> 
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 

Tested-by: Sandipan Das <sandipan.das@amd.com>

> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index 92707698..fb46b196 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -7,21 +7,19 @@ void pmu_init(void)
>  	pmu.is_intel = is_intel();
>  
>  	if (pmu.is_intel) {
> -		struct cpuid cpuid_10 = cpuid(10);
> -
> -		pmu.version = cpuid_10.a & 0xff;
> +		pmu.version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
>  
>  		if (pmu.version > 1) {
> -			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
> -			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
> +			pmu.nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +			pmu.fixed_counter_width = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BIT_WIDTH);
>  		}
>  
> -		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
> -		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
> -		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
> +		pmu.nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +		pmu.gp_counter_width = this_cpu_property(X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH);
> +		pmu.arch_event_mask_length = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
>  
>  		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
> -		pmu.arch_event_available = ~cpuid_10.b &
> +		pmu.arch_event_available = ~this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK) &
>  					   (BIT(pmu.arch_event_mask_length) - 1);
>  
>  		if (this_cpu_has(X86_FEATURE_PDCM))
> @@ -39,7 +37,7 @@ void pmu_init(void)
>  			/* Performance Monitoring Version 2 Supported */
>  			if (this_cpu_has(X86_FEATURE_AMD_PMU_V2)) {
>  				pmu.version = 2;
> -				pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
> +				pmu.nr_gp_counters = this_cpu_property(X86_PROPERTY_NR_PERFCTR_CORE);
>  			} else {
>  				pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
>  			}


