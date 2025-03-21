Return-Path: <kvm+bounces-41656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F75A6BBB3
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F125B7A5CC2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFA522AE5D;
	Fri, 21 Mar 2025 13:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u0VeqF+q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303E41F2BB5;
	Fri, 21 Mar 2025 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742563540; cv=fail; b=m9WT/cEJoyLsUBJrDdTpDuVPvQwFa1b5w5n6x+s2SzBhNtzrL8x5YppDJ3ExZHhIUWVteKzxnl3jUbHqjgVZNR965M5eEBLOQWK+82rONQhoaz/KoueAgCRb3q3WTwAD9HL9erQ9AW57r+5GcAzlTcvqw1+0ml4eOujPdTd6+UI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742563540; c=relaxed/simple;
	bh=3WJAtV4i37J1teWnP6fr0G4QvVXb4edC/xWf0QV3z/k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mtmH6VrS9dQ3hQye+b3lL0DK85uCPG32nhod6poCJ1XiEXpXpXOWxd/1s8Rq5MIOem5s4JNNXd83Xkd5eUyPzvvsMJ0L9CwVMmJT3VZt+QVgnYUnOL4tb42eni41IvtUQ0qIymjtJR2b8twKylDxVxPx0GZZ3k/CmhCjJFbAdHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u0VeqF+q; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SuBBNPOTC7zPhW1ZCdnbeFCVt4ojuHQbNWIY5jIP61dCf7H7VkfKXbne3YV2qymhjAI/tX7K6B3gPL6CkRjLMQGeC+67t639eb3ly2y7cjN1I2uWPa6Lq0EOTt4eewPJOELEsrUwzum0EtMfdxXsk3n3xmb5SiFGxYQoLeDiqnYLl3xeUoEBjxABdUSERNLkdbp+ljiBEvwHBXbz/CaqyWGp6BD39uczVXXZ8tcMaS6/rBD3Lx/eK3bnkR9dWqGdK7t3iPKiRS/tW5kyCcZeXoZehqPXLXFYjXHY4sjM3Bgoua9oHQ7qES0+FjdfQqCxTff8go0sepVcZagQ4pvh9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnjdNznna+gyaudT3nEqxCXWO51tBMAw9br7TdNd+k0=;
 b=xWvM5OhHespn2Oh2+42zCZpb9h54rkUPACnfex9TuydqZRcrrAA7avryawxKaBsDZtzNqbt+Bb3R0p7Z5APWr2lP/jb1BA13wpupDWHZRMRWIpa9rmPUl2D5zHx+ZATjM5GWIWTiLFaX06Y3rN4KmHrwcjTvsqon5nssaPwIG68jBPVol/pYP1RSQ5c0bfdz3uoMLnOu3/5CrB/gbvSHtb1HhTDg9dTCfrPc8PVYkjnFxlbkF+E2yQwK6BYbZ5a66mlWlGPN5RnWcb5+Hir+gMjhufOSQ3CTbT6bjIv4H+WiF1gTPmgsK6Bs+Rif8g9iFSJ9leil7DNiMgLKoqFihQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnjdNznna+gyaudT3nEqxCXWO51tBMAw9br7TdNd+k0=;
 b=u0VeqF+qQbmLrvFPgZ7HdnxtgXaVotgnqVefVzeh3hLgZFkyRgu1ttgAOcrRhqSvQr/pP1eYtZPUVNBL3zhq+YYhy9KbZ4inLMrgIWF741rojdNzvW7XR2Vac9ZNI5VETIQkCB2DkjrMPXnAC3XEm7z0fBP+A5hqYxGwLbgWHeM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CYXPR12MB9280.namprd12.prod.outlook.com (2603:10b6:930:e4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.34; Fri, 21 Mar 2025 13:25:35 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 13:25:35 +0000
Message-ID: <a8320094-8002-49e3-881c-c5939002675c@amd.com>
Date: Fri, 21 Mar 2025 18:55:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com> <87v7s235pv.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87v7s235pv.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: JH0PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:990:5b::13) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CYXPR12MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 22555cc5-800d-4945-bc40-08dd687bdcb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ektoVWNST0hjOG1kWFJ4RG5kZU1MRG85dXBObzFLWG5qbWd6eFNxTnZDR3Vt?=
 =?utf-8?B?WGsraHVXM1R4Q0svcmhKVEdURTMwbElRTGNyZFU3ZUE3SnppSWIyOEhhTEc1?=
 =?utf-8?B?QUdvcFBDQVJwYnIvazk1Y0pHUHZNNXYzUFM5eldtaDd6ejh3KzhEOUF1WTRh?=
 =?utf-8?B?c0hERDNwYTluSWU3djBVN1BLUjZHOWpyY1FaTzBDYXlpZGNsc1BiNmFENXo0?=
 =?utf-8?B?U1RSZGVOQ3FQay85ZDNseUhUQTBhanFRT2pldnQ4dW0wcTAvZTNnRlRpSXVp?=
 =?utf-8?B?RTQ4ZStselEyWCtpb3I4akdIVEZUTHR3bDJtS0VkaGFGK0VRVEc3bW83bE9q?=
 =?utf-8?B?SXhFc21Kb2RxSkdsK2x6b1NQSU1IYkZSdzVSdjcyMWdWdDYwWWFlV0wrazhF?=
 =?utf-8?B?UTFWQ1Y4YUlqY1RNYnVaWHF2YWU3Tyt5cjZzVkU3UXRaeVl3TXBFYjJ1Tm5y?=
 =?utf-8?B?U2tWSzZLcE5pWG9sWCsrVjFpMlIxOVg5ZmJoVW1oeW5ucTBBeWtYa0MrOXdW?=
 =?utf-8?B?elcyRUtMRnpUaVo2L2tQVFZNdUhOY0MyazF0UmY2T0tiQWpJV2dYMjliK1RT?=
 =?utf-8?B?Mk5yclVCNTQxajNyZVBDMjgyQWNsZHRGZXkwd1dHVHVaanVuZkdiK2hpT3Ey?=
 =?utf-8?B?K0hKMWVic3JZTVhWM3MvZHRGSHd3cGg4bm04c3lyUEFNQ0R6b0pZWGVaTkFk?=
 =?utf-8?B?bjVMOEt1Q1dPaUU3NDVNcldHNjRWclFna1BqcEwrdGdsbWJkekUzVUhFb0I4?=
 =?utf-8?B?YkhnQ2hUczBNNzY0VjlVbmFZSTlPNjFrR2xLY2xKK3IyejdRY09NTkJSMXJU?=
 =?utf-8?B?c3Q0Vk9qTy9zU2dtcnlFbDl6VkJmcEV5eU1DTmFxZm0xNGM1V0R6NCs4NUVk?=
 =?utf-8?B?dDYyMnBiZ0ZHZHZuYk9CdmFkM0lCV3JaN3NxOEd1SDI0UlB1RmNuNVRxd245?=
 =?utf-8?B?ZWlwaC9YN0hrOUVUdFpvQ1VFNkRRNEwyUzBZNWpJYkRmS1ptazdmQ1pIUHZT?=
 =?utf-8?B?L2tiZ2xBbm5jVityOHlTMEVwcXNNU0UwSmEvV0Z4N2hKb0RzWno0eDhsUmVm?=
 =?utf-8?B?MnJNK0NCRUY0T3RISXhZWm9ZSUF0b2cwQ1NXNUZZdkNUQ256eU9TelRFcFBL?=
 =?utf-8?B?VEFBbTN1Y2RDYitHdlpCKzVZUnl4WnZoU2lwdjFiSVM2dTFyZUd6Q21UVWVt?=
 =?utf-8?B?dnhmVFd6SmVXSTFuZC84ZDE5aFY5UEczSmlmNFRpWnB5L0RNOERiZFhORVlt?=
 =?utf-8?B?QW1lbkF1bzdLN0VVbVkvN2dRbWNHNHFWT3MzSWQ3aUg5bmNjaElSWjhLNE55?=
 =?utf-8?B?TS9UbGh5akpsenl0QnNRL1lvWTNpK2J6dXpPMFlHbXVydGlmaG5KZXlnVm95?=
 =?utf-8?B?UmxMZCt2azVYdUIxWUdadHFlRjFyalJlcy8xY2RxZW1KUjNaallQRktJT2JB?=
 =?utf-8?B?ZFkySDJPdndRZXlTL1hjaU41V3dSVmJWbmU4ckpEZElUZ3MzU1NmdjNWaDFT?=
 =?utf-8?B?aDBMS0lQQkhEZERsU3FReS8yUWdXTW9PeUJtRXdKVVZYcndzOWtkcWFacXBC?=
 =?utf-8?B?MWg1WWUvcGZFY3kyY055NG1KRTRUZGVVSit5MmRSWElCTTNOSktzM1FGbUdN?=
 =?utf-8?B?TUJncUFGL09ydWxSVURSaTZxaE5CejdrTzgwUGNvbnB6aFVzTjBwZkZmS09M?=
 =?utf-8?B?Z1FSNkFYSlVmVm9UY0hPdjQrWkF0VzVYQk1NMlIydnNZZWZ2TXFXYStxbHcv?=
 =?utf-8?B?VVpyTUlwY0JtWUJ6VUt5NldaMWxtUmpzRGhZdFZKa2k3NHNCNHUycDVwMkcy?=
 =?utf-8?B?ZEQ2MWR6TXdKa2pGUFhZaVpCMUFVcmJITVdkRW95ZGFMeFRES0pQWkdZSkFO?=
 =?utf-8?Q?FS0VHPv8NKD7m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDJRRUdONGN4Q3lJUENibzVnMVpiVEpFd25yeTBhcW1Makp4eDBHTXBLUVlz?=
 =?utf-8?B?NmhidU9CRkkzWWFYVE5DSXRHS0dLMnFtSTlra09xT05nQ2FMQk5ycDJZQThT?=
 =?utf-8?B?UnBIdUFVMmt5aGdjZXlQUi9YaC9JNlY5MVFiN0wxeUVjSUNOUmtydUlucDhp?=
 =?utf-8?B?QkR1TDdINHZmTjljQWkzTEo4cUJGVkhkazVrckVUSUs5cDltRGUzbWRNZmk0?=
 =?utf-8?B?UzdycTFIc1o1Z1VKdlh5YmFGMWxlc2RlOWZaZFN4c2ZISC9RaUNhdWVYb0k4?=
 =?utf-8?B?L1JYUlR2eXRYMGtlR3dmRUtLakRuL2U1ZGVHaGEweFJkdG9ST1hDU0dsWWk5?=
 =?utf-8?B?QkRIV2tsRkMva1ZuVHJPUUNxUFc0YU1tejdDcnR3Z0VULzAvakhNa0hqQnFs?=
 =?utf-8?B?ZVBFMzZKL2YzRHBvUCtSeS92bFd6L2dEQmkxMEc3Q3BpUVczdysyTXFVRVFP?=
 =?utf-8?B?N09xUGtmdFFSU3A4RkFJVWtDRnFrY2NIQjF1T1VzVHFtcG1DVWpJdFVYcURR?=
 =?utf-8?B?NjFnSDhIYmsza0NVMzBnaThsd005WW1RWmRwejZJbk1zZE50TEJWQ3lMWTBv?=
 =?utf-8?B?azRSOGxEOGFNQWN1M0w1U0pGeDluR3o1UitobWwxckJSN255N0Z0dk9QdXJa?=
 =?utf-8?B?T3I0bnpvRlhpSjBaVnovQlNCTS9zb01aT0tyQ0dvc1pvK0JySjdEZ3hrRE5j?=
 =?utf-8?B?WjF6QVRDYjZoZkZLVm1GTEhQbGttc1VWVkxlKzZrNUdIT2Nva0wzakFsWmp6?=
 =?utf-8?B?L2MvcHhsK3Zrc0R3SWVWL09KSlBLRThieHp6azlwZERueWlFUEtGKzBjZXRm?=
 =?utf-8?B?bTdNMTBkdlZyeS9CR2pmUXNxMFZoNXVEK0pzU3JJa3ZpR3NxVGc5MzA4VEFt?=
 =?utf-8?B?VDVKNU8xUkNuUytScUV5M3o5WGZiUHA5Y3NyeDhiNFhmM24vbkxrRnV2NkRY?=
 =?utf-8?B?bENSVEtPY1Z0L000SmNLcUhxbXJqazg2TDdPd1dlbU1rb0Z4cFY3NVpnRFFR?=
 =?utf-8?B?eldwNGFpcHVZWW4rOUUrMU54OGZOVXk5Rmk2MXpySjNvOFJQVDRVenJJQzZ6?=
 =?utf-8?B?SVhwL0FoOTRZSDVOVVFPT09JS2VIKzBjN2dtMDBaSGdCQ051K2lSOW9SelRI?=
 =?utf-8?B?RVBrdUZyWmhDQUltdXBJb1hiL3hkT2MrcUt0UHVpWGlBWlhxMklLSGdRbGcr?=
 =?utf-8?B?L1JSY3o4QjhxdzBib05mQ1htWWJMQjNKUlRMWlZwL3NOMlVqYk9hVHo5dHM2?=
 =?utf-8?B?emk3ajN6N3BwMy93bmh3R1JMSXA1aXlpZDZVbVdmM0JIZnRVQlUxNkNVcS9H?=
 =?utf-8?B?b1dyMWEwVkcyZmlpVlpvNEhxUWV1VmNGNTJpclNRMFowM2dzS2RCWEM0ZmRr?=
 =?utf-8?B?Q2xCUHNTdWxpUWhiNmF3VlYwTEZVbTFUVi91c2VuazQ0aHhUV1k1TjZzOU9u?=
 =?utf-8?B?V1dVeEcrbWZDT1Y4MDMwd1U3QmxtSTc3OURmNnBJd24xeGQxSlRtc3djTVJy?=
 =?utf-8?B?TzBLK2FWeXVjelcva3JjbWRPSTdVMitTQmd5QTZUM1hUMUJTK29zMDhBMXRK?=
 =?utf-8?B?MVJvdVFHSkRNNVQ0MzVBN0N5MjNobFBrS0QyZlFIMU1uZnM5U3prL2IxQ2Z5?=
 =?utf-8?B?MTl4emVDZWZMeW5KdE1Xa1EyZ0UvQldOamxqMERwaXhTczJua0QzYzhNZVBO?=
 =?utf-8?B?T0YwSWJWcU1FbTV3YjRjNGQ5L3B1M2NaY01KVGVxdW0zSjA2SEdwNlNMSk51?=
 =?utf-8?B?YjNwT0p4eGpwK3VqeXNwQmJCbHlVRy9GR1R4d0wwN1JvSWJXMTJHTTdlWmRi?=
 =?utf-8?B?NUpKNytZN1BOQnJhbXVMeUdSVWpiU1hnZ3A3a3ZkQUw5SVBPb1FYbDI4bFZs?=
 =?utf-8?B?YTRPRVYvOGxlRkNtdW9rS1R4Vm5TUkdlOTB2QmdOK3lhcE01bTQ3dnUxMWdv?=
 =?utf-8?B?dGtKVG1XdVVVWjNTdE5zTTBNQmdYZXVhMmxOK0FMNU9kSWVYT3lEeldCakN2?=
 =?utf-8?B?dkt6aWlGbExHcFIwM0FMZlJkMy9LTkNqdnRNN0NPaEd2Q3ZncU43a0NGQlJh?=
 =?utf-8?B?OFRraUdSeTN1WnRia2htcVlXZHhremJGM1F3dGI3NGlTSk9MdWxLZGNxN0c1?=
 =?utf-8?Q?LYMxnOuYf9M8GaJBzrFDfxsJH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22555cc5-800d-4945-bc40-08dd687bdcb1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 13:25:35.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fEDP4dTfSmLgnCtQ3USHCDqQhcoyEDNDzF5Vwn5AMEzRfNPSjQ+TFsGHTsu3CtWCKTTpyRB4IY/whWp1RHpzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9280



On 3/21/2025 6:23 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>> +static void x2apic_savic_send_IPI(int cpu, int vector)
>> +{
>> +	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
>> +
>> +	/* x2apic MSRs are special and need a special fence: */
>> +	weak_wrmsr_fence();
>> +	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
>> +}
>> +
>> +static void
>> +__send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
>> +{
>> +	unsigned long query_cpu;
>> +	unsigned long this_cpu;
>> +	unsigned long flags;
>> +
>> +	/* x2apic MSRs are special and need a special fence: */
>> +	weak_wrmsr_fence();
>> +
>> +	local_irq_save(flags);
>> +
>> +	this_cpu = smp_processor_id();
>> +	for_each_cpu(query_cpu, mask) {
>> +		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
>> +			continue;
>> +		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
>> +				       vector, APIC_DEST_PHYSICAL);
>> +	}
>> +	local_irq_restore(flags);
>> +}
>> +
>> +static void x2apic_savic_send_IPI_mask(const struct cpumask *mask, int vector)
>> +{
>> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
>> +}
>> +
>> +static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
>> +{
>> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>> +}
> 
> The above are identical copies (aside of the names) of the functions in
> x2apic_phys.c.
> 
> Why can't this simply share the code ?
> 

In patch "06/17 x86/apic: Add support to send IPI for Secure AVIC",
__send_IPI_mask() becomes different. It is modified to call functions which do
Secure AVIC specific handling - weak_wrmsr_fence() is not required and instead
of wrmsr, APIC_IRR is updated in the APIC backing page memory. 


- Neeraj

> Thanks,
> 
>         tglx


