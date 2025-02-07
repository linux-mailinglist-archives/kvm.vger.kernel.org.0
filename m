Return-Path: <kvm+bounces-37638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F34A2CFFA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 22:46:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C88D73A3D1D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 21:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 101651D5ACD;
	Fri,  7 Feb 2025 21:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sWotn6CN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211A61C5F19;
	Fri,  7 Feb 2025 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738964763; cv=fail; b=Zkb7+sZhwAFqRqKg9SCs60sCmAKV0SXC96othf5T13h80Qkzn9OCJ+qDzYnOp1zdTNsuBAI79rXzS4RPCOZHfkS/BUNRJiX9mA9nVrt02rUoQL6djmsDvDscOcuhS9a9oHMqWEO1XvAYGMwHnyZZSHsvCQ7CwvDu+GjU//Y+hvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738964763; c=relaxed/simple;
	bh=mPT4DCclj/m9kbM7Ew+qmZfva2LE8gVhKa3pP7WevCM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b4n37FbWbGHh93kbh01E+ZN8+/zdLSGuIo9KyE/SpoKHRhmGTOjT94IKB+zykurH95DsvVM+gSoxQOIpPTR3bitgYjoFIJGVleSuV2pgbq15dspZUgl9bjmmNPEmLbLughkR7+MEG2tw57Z5u+PwhLunoOFj5YbZ6B1QsEPA5O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sWotn6CN; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsL9UYVcgModQbt+tEAlAE1eY603MRUMJsvH0ndFs11R8X4+Wxgr+FJ7ge/3FNI6RLo4sfzQc+tT26NKOjmxsVptnt7GcsCI6zfy8XXWHRx4IRPZg5Wt1zgrU36eEo73EtmLH1wICJNGO6xRoRnZGEhpXroYdbGADlctOKcQitO7D14cKcAXwMjfYLjRUQcmLlrvTT4eBy3dFUnk6G0JXwGIqKy3xBhGFuHT0CBW/vnAt8bkPS5+cmk5beYdvBCxGrxM3C86NWcLe0L0f55zpPfN9CtSWPa73C6v3Bnjv9nNbqKMxpYxYIoudT7TdMkfk4qb+IA7gSrLPWVf4cPE7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFfxMn9euVTVOKVme+aT2FcAa3fqOINx09YrP63VIwc=;
 b=f8ldzjrh7mlQs23+AM6Wa/HPj1+vP0zpnUfAQEPrfSDMbmXJnt8+cTinG70OHwvwzhdV8rNftEeJHEofZ9OMhKQnwldYqDxMz9hgb88XNtqSySJOMhXiHcjxLvVbvdGtZIw+yhC16HWFV8EghOvp/Eh3eJPo5JmPZjDlY/AKkDsTlS3Rk3q+376XwxgL8RrGbRaMmlU3f7WlHofbfgLifukMqb0OYNfJi9M26CgRDHBgdWgVDbPGzrU1TnEdqNbjv57H52Wp3kOMx4RQnXVGOOxI5YLKfqwvIMxmq5FgPmtD/T9oNH5nbZeAH4yH+B05Rz8ItTslPJJgJy1lsvtiKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFfxMn9euVTVOKVme+aT2FcAa3fqOINx09YrP63VIwc=;
 b=sWotn6CNV3ck7RgePuxQenITp7JJJMd5OXQaRd83KQTxwSUbTW4ssCliBtHYc9VAFqBh+pttUPXWwAR6qvncc0pf6CIAIyXPoBXfFgMl8YCjgSt7AJnhst1tOfgrARPGmnnECu6H8sXus1Yc2Iyo2WzwTLN4QU7YlERsOyzw75A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Fri, 7 Feb
 2025 21:45:58 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8422.009; Fri, 7 Feb 2025
 21:45:58 +0000
Message-ID: <d438eb4b-c3b1-4318-8db3-b84443482e1c@amd.com>
Date: Fri, 7 Feb 2025 15:45:54 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module
 built-in
To: Sean Christopherson <seanjc@google.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com> <Z6OA9OhxBgsTY2ni@google.com>
 <8f7822df-466d-497c-9c41-77524b2870b6@amd.com> <Z6O8p96ExhWFEn_9@google.com>
 <d27f91a9-0dff-4445-8d2f-9db862acd1d0@amd.com> <Z6YsWiTGM___898F@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z6YsWiTGM___898F@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0018.prod.exchangelabs.com (2603:10b6:805:b6::31)
 To BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e740634-9442-4493-cdd6-08dd47c0ce88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUJka2FTVU1KNW12T1EyMFBpdzFoNTA0TmwzUHBtMEpSM3VZQ1NtS3dFSXA0?=
 =?utf-8?B?Znd4Mk1EcHFPSks4dGN4OWpYU0NzWTFaWmpNZS93Y3dySXd2d0E2N3ZRZ1g4?=
 =?utf-8?B?cWpGNW50am55b0hDSGJrYXhaV0NGWXVyVEtrSkgxd0xjR1NmRHRFOG03b0or?=
 =?utf-8?B?VmJzLzkzQWhBcWdmZFZqaGhxUFpTdEJMZ3JCSVo0bjZ2c3hFWFRvNmZGNDlp?=
 =?utf-8?B?cVlzSnNlalRsNXNnN0RGQ3ZlOHF1WlFuZWg3THZPOW9mWWdSOFJtNndwYm8y?=
 =?utf-8?B?OFdtQmNibEZJY085d05Ed2l6aFpFTkwyRWgvczNzUGp3dXBiUjB4WDM1Q0gw?=
 =?utf-8?B?ckpmd2ZaaGtYWXlFeEF1K0dFQk1SeDY2Ym5sY05UTGdhMGllcWxoZUlXRkpq?=
 =?utf-8?B?SjVtYWtmbHFaN25oS0JIWmthaXlMSThVNzhzTi9XZkh6T1N4bUJtY1lxU2p1?=
 =?utf-8?B?UUgvN1d5dTdQamZHTk11S2t4Vk1PSS9vMEhXZW9YN0ZFQURaN3EybXFvS3hs?=
 =?utf-8?B?K0FmVG9MYlNuc0gwNzhzWmR0OEJVMFBGckg2dmprVzdCTVNISWpHS3lEYVVS?=
 =?utf-8?B?U2RJWWFCUnIrNmZFVzZ2R2doelUzMnQ2Zkx4dVI5SHpHejdSU0pCRGJ6ODFs?=
 =?utf-8?B?NGRvRG41VFNoVG1aYTNxbDRIeXdRLzRFSkQyL1hRMmt3NmFEa0R2cmg2R2g2?=
 =?utf-8?B?SE5VNFlXZHBjWW5UWjVxMjJ4ODRKWEJTVnVuWFZRbnl2RkVBTzAzclgzWnRk?=
 =?utf-8?B?V1NxcjhhU2pMM1BEQUUzZWxjMm8valVMclpjbjI2MEhPbUY1STFXMktybEoy?=
 =?utf-8?B?QmlQN2x3M3E4QS83ZlF1ZGhJWXBZZVBsK2M1aTR5NzlQb2NhSlpsL1VJTzh6?=
 =?utf-8?B?cjFIanpBdHhsWGlJZFF1aERsREhCY2RGSmVuR3lROExjVHlpMlNNRlQrZXhO?=
 =?utf-8?B?UllKbnJYM3RlME9QS1FtdXlOWC9BS0EyU3dIK3I2VU9Ra3ZwUGh3enZTMnpZ?=
 =?utf-8?B?NUdwdUwvRkRIU0R4UjRnSlltRDJ0ZUVoejNMc0tTTkRKcnhGc00yM09uTTVK?=
 =?utf-8?B?c2Q4UjhaZFJIWlMrdFRIYmx3UTRRRmJ3MzB1QXdSL1BVVDVzYjBVNUN3TTIr?=
 =?utf-8?B?WTlzSGw2aVBaWmhpNzhyZ09YMmJKK2pXaUp5VXcwaU9pWXdiSWhTZ1FHVmU2?=
 =?utf-8?B?T3YzcWh3SURERjV3a2l3ZDFEQmxUNHlVQmwwV016MUdONXU3MFA1M2FraHJP?=
 =?utf-8?B?VFBTZWF6aFZqNzVlVEdmdkdTTWg4TnplZ0pVZGdNWVNDbUhZUHgrMTBRVm5C?=
 =?utf-8?B?MzNFY0hlVTBidmJvS1pqd0pSTnFlTEZ4WERZNXU5LzJ5OFZCajQ3LzZBd0pj?=
 =?utf-8?B?SzlBRGdiNHhEYVpjdGd0QjBBRjc3bjI5UnlENjVDaFQ1TmRoRHcyaTQ0ZStR?=
 =?utf-8?B?OEYyWE5ieFRpZENUdmt0Y3lsN055UXJZZmVzdGRVVTlPa0h6T3hUREhYS0o3?=
 =?utf-8?B?dE92YkNxemJnVzVwL1kzS2ExKzBCYnU0NFJHbnQ5RS80Y1FDY2FTUGI4YXJL?=
 =?utf-8?B?VWZXcWZMNGRRK0FCU0ZhTzVJYnlJd2ZpczJiZzNPeUdwcXg0Q0dnWmJxL3hY?=
 =?utf-8?B?NE1aZnI5NzlqTVFIL2s2Q01GcHg5cE1ON3l2RVJxL25sT3Y5SWdyM3VLb1B2?=
 =?utf-8?B?MU5UeXJRSTNuSGhSZmhVV3JxU0Y1ek5PbkJNbVJNUHBrNm5aYkI2OWF6TEoz?=
 =?utf-8?B?K3cvRWNSUUxaUEo1aUdHTmtRZytQTnpQODYwSENhODZ0UXMrWWhjQW1zV1hv?=
 =?utf-8?B?Wlc5YzhDSVVYVEpxZ3lzYnRUaXE5VEl6QUpucDRXM2czZHZUMDRUQjJFVWts?=
 =?utf-8?Q?Zlg2HKpDPIrl6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUFaRDNNRHd4KzJWTGI1UU1DMzJqRVIybFV1MEZQZjd3VklneVprTHhkdlRC?=
 =?utf-8?B?cG43NEhjaDQ0QjRwK1pHdXJxeGNHeGNib0Y1VVRhRGpVMGJhYjRDTDUxTjNk?=
 =?utf-8?B?REZVYWN1aUZHMzFOLzZBSWFPYjhOb1BaWGtDalB1d1VWbDlqK1psTys0RVJp?=
 =?utf-8?B?VDlDamYzNXlQTWJ1SHhBMGpLMkFVZ091NG9BQ29GQmZqanF4ajdlb3lWYUtV?=
 =?utf-8?B?T3Rpay9nbzA0R3A1V3gxWWhMYllOcThuMVBGWER6K2pYUFJzYU9peU5mSkgx?=
 =?utf-8?B?UzdCTWEzY1BVdFhpTWJkQ0ZFSG13R28rdGoxemhmd2MyaExZTDBzTDQ4WFVp?=
 =?utf-8?B?bHJoblI1YTBMYkZnSVcxb2YzWko2dndzemhvdUpiQW5LVi9jVnVRbGdBOGhU?=
 =?utf-8?B?cDZlSmVhWUNHd243Nk52bkJtOUFhNUUwYzJ6L3hTbkc1aUVUb0NUUUpLYXVi?=
 =?utf-8?B?blowSDdseGZYOWVhSGNBQXhZTmxPdXpCZjllTTBNOTRST3A5emJYajFQWFBk?=
 =?utf-8?B?NENRaUVNZEZ4eGtlRUhOUHAzUVVMVXlMTC9rRFhMMm1uMlpkTUNEOXBQL3pK?=
 =?utf-8?B?dDJ0MTRSR2NVOG1oYUlSSFhjd2VrMHM1bVpyTlR6TWNzQkFUd3hVYjBhTVI0?=
 =?utf-8?B?MG5NU3AydHMvR1R0MDkrYmtrQ25NdjRoU1BTUWl3TEhzTjlZcEdoclMwdU82?=
 =?utf-8?B?cnRGK2loYnhOY3dSWVJmb04rdkc3QUNqYjVJeXJyeVZXYk5HTVQ3Z2lGZFA1?=
 =?utf-8?B?VmFFNUo3aFkyaWFSWjRRTytyQUtrTWdrVTB5WWcrMnZzSWFjUEtIVWhacUZY?=
 =?utf-8?B?WnZhamJ6aDJaY291UytDb2dyYy9HRVVBQXIvT0ZUSUhnQ1pLK21wMGVSbEZv?=
 =?utf-8?B?MHIxUDZPQkJFd3BjVWRXMWJncitMYWhtSk1jN2xpYjQzLzRaRlFTeUdvYk5D?=
 =?utf-8?B?R3ltWEdGbHVrSTZrNlJxaGxNWm1KUmUvbXdhQ0wrb2FyU3plYStVRHRuaWs1?=
 =?utf-8?B?eWVOdXo3NlFHRVhWcFRuOUhpRGtUaW9FM3U1cmlqVTY4UndmaDRLbXRIa3J5?=
 =?utf-8?B?SUxpU1dVUlRFeHpRNll6d2sraG5XWm9SRFdhNVU2SXlOVTJtRlByZTJCSXRv?=
 =?utf-8?B?TVlRamZUSU4zZ29ZUk01aC8xS1NuOHZRL05ZTWFCTyttai9BcVN5bDgwZjRr?=
 =?utf-8?B?TlR3WWUwTXpDZFk2d1pnQ05rRzJ3TEt5OTkrRlA1c3VNRGU1UStMTHcxbHpN?=
 =?utf-8?B?WXJVQ2pmbGdrZ2JQVEU0NTZ4NVF1U3pIQ2REUkFIVTcxZFMxUC9NUjV2eUpX?=
 =?utf-8?B?NVM2UjE5TDRBTWRmUFNDbUVQR2Z1R1VuK2FtbWhNOElqRzNyeXN4MWsvVXpK?=
 =?utf-8?B?WG5TKzV0ZWVOS1RTVUdvT1JaYXZ4WW5PdjlSaHg5TVJKRzBLUmhaMUVwT3hV?=
 =?utf-8?B?Sm5NSWJVZGswQWtvYi9reGdRMzJZRnQ1aGNNdkVEK2VweW9PR3JHbHpLbU51?=
 =?utf-8?B?Q21aMXFEZE1LV3ZRcmxUbVBKMEhibkpGUEp1ZC9kbVhYYzVESHNvWm5vd2R3?=
 =?utf-8?B?dGFoZDlTSGkvcktxdzdmZVNnTWpGYThEWktsRmdMY21hQUZqVUhOeGkrbVVm?=
 =?utf-8?B?cG9WR3BPeGJ4YjBQVkN0TWgzOEVHUmZoVk1QSGxGb0JOakJSMCsvUmNkeHBJ?=
 =?utf-8?B?aGVPSE1Jd0MxOTFrOU5kdlB2VmovZkRqT094VWx4cmVLUTZzL1NvZnVwK0k3?=
 =?utf-8?B?VDBzRysrUXZmOGMyWTN5VjNOZnQ4bkc3bTg0a0l0REZOZStSdlZuNU9Obldq?=
 =?utf-8?B?RjdEWHVXYXg2bTZReW95V0dQeFVMS05LT0FEdE80OFZUazk0eG5PdzN1a0lh?=
 =?utf-8?B?dFM4eFlpdHBlK2JxdUsvQytsdGJPV0xqaXFuQVJxREMzMnlVb0UvNllZSnE5?=
 =?utf-8?B?cWlDaGZGTmp4MjRsYk94bW1XUVBVaUdTeS9DSXh4ZXc3UTFia0NiUWlSc1A3?=
 =?utf-8?B?ZUZtMS9wamU2M0IxdXdtNzJRb2phYWl0VlRva0JwbWFHREt0andXeTBYRUt3?=
 =?utf-8?B?Nk53UzZxT0dOU1lyQ1U2bXFQR0NtRFFEdGVjeHRxS2hRS0VzTEFnajNjQ3li?=
 =?utf-8?Q?C2uDKknQRHOBcXslJ4eODlXBx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e740634-9442-4493-cdd6-08dd47c0ce88
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 21:45:58.2940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZjsAngNY0owymTOHUCr7MuSl6sLAhxxrYjdpeesYNPoJAnB8FBITOQCtyO/Doakkjg97Sn90Spakf41RZQjlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243

Hello Sean,

On 2/7/2025 9:52 AM, Sean Christopherson wrote:
> On Wed, Feb 05, 2025, Ashish Kalra wrote:
>> On 2/5/2025 1:31 PM, Sean Christopherson wrote:
>>> On Wed, Feb 05, 2025, Vasant Hegde wrote:
>>>> So we don't want to clear  CC_ATTR_HOST_SEV_SNP after RMP initialization -OR-
>>>> clear for all failures?
>>>
>>> I honestly don't know, because the answer largely depends on what happens with
>>> hardware.  I asked in an earlier version of this series if IOMMU initialization
>>> failure after the RMP is configured is even survivable.
>>>
>>
>> As i mentioned earlier and as part of this series and summarizing this again here:
> 
> Thanks!
> 
>> - snp_rmptable_init() enables SNP support system-wide and that means the HW starts
>> doing RMP checks for memory accesses, but as RMP table is zeroed out initially, 
>> all memory is configured to be host/HV owned. 
>>
>> It is only after SNP_INIT(_EX) that RMP table is configured and initialized with
>> HV_Fixed, firmware pages and stuff like IOMMU RMP enforcement is enabled. 
>>
>> If the IOMMU initialization fails after IOMMU support on SNP check is completed
>> and host SNP is enabled, then SNP_INIT(_EX) will fail as IOMMUs need to be enabled
>> for SNP_INIT to succeed.
>>
>>> For this series, I think it makes sense to match the existing behavior, unless
>>> someone from AMD can definitively state that we should do something different.
>>> And the existing behavior is that amd_iommu_snp_en and CC_ATTR_HOST_SEV_SNP will
>>> be left set if the IOMMU completes iommu_snp_enable(), and the kernel completes
>>> RMP setup.
>>
>> Yes, that is true and this behavior is still consistent with this series.
>>
>> Again to reiterate, if iommu_snp_enable() and host SNP enablement is successful,
>> any late IOMMU initialization failures should cause SNP_INIT to fail and that means
>> IOMMU RMP enforcement will never get enabled and RMP table will remain configured
>> for all memory marked as HV/host owned. 
> 
> So the kernel should be able to limp along, but CC_ATTR_HOST_SEV_SNP will be in
> a half-baked state.
> 
> Would it make sense to WARN if the RMP has been configured?  E.g. as a follow-up
> change:
> 
> 	/*
> 	 * SNP platform initilazation requires IOMMUs to be fully configured.
> 	 * If the RMP has NOT been configured, simply mark SNP as unsupported.
> 	 * If the RMP is configured, but RMP enforcement has not been enabled
> 	 * in IOMMUs, then the system is in a half-baked state, but can limp
> 	 * along as all memory should be Hypervisor-Owned in the RMP.   WARN,
> 	 * but leave SNP as "supported" to avoid confusing the kernel.
> 	 */
> 	if (ret && cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
> 	    !WARN_ON_ONCE(amd_iommu_snp_en))
> 		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);

Yes, i can re-spin the series with this WARN_ON() added and additional comments added.

Thanks,
Ashish

