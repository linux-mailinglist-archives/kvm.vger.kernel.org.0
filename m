Return-Path: <kvm+bounces-38789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90836A3E599
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D95493AB25D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507732641FE;
	Thu, 20 Feb 2025 20:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JhxulzzL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4FB1E5B6C;
	Thu, 20 Feb 2025 20:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740082030; cv=fail; b=SCYugAacL9/eT5NdxvopBgNXI9J4WH/qgK6nMgELCXflShStKaAzcCuoQhPxFN2U0HkWHL4AppgcIGmy4qokvbRtWPA6G99X8cX6mhv8uuoRTNSdL+RGnTB5FbjmAwv955CmK0RpCaX2xxOf6wSZAoj4KUFucZeFIozWpjg6+Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740082030; c=relaxed/simple;
	bh=LApy7S79FDZ1n8b5FnrYEyiabYsPXemfwbZQ7ty+BxA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KhgjGJPJplpFsVgLmKcGZ5UnYZtpMNQQSY+dkyWTFE95ZW6xRSDoxoXxLRtuKV3JFP/HK+YY/TJr0xOAKNSSPaomOpXTZNBTMFbDfhzRi64FskWIouWsuFUvcvaqTuruwgJZTvniHk8UnOCCkpHKyKsU3KqWRaU/d8+SJ1d4qzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JhxulzzL; arc=fail smtp.client-ip=40.107.244.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bi5RxmUzk3SHbrBn8wSbXJoSqPSDlEABX8IzxdpgWQlw4hyRjp+50xlRT28BFGHsMB9IrDZN+DRFA1fuFLaZizGdRrvR0dNZNxKjhiXZVpxtLhNdF1WfgChxLXznVTPhi3niDO8Xr3n/brx0cK9AeVUs7NxkJZNiUJf0A7oAwELke0R9Oo+ZZUftoo6EAZCkmGl1Zf0FufE4oJqqcmKeiIJAXvQws4Tbznfq5zjVVboVEV38LlUUw94thZady3XbWRIEwfnrIStJL/McFyMFGAOVaE0PSfO1R0CnMYKsgbdP+M/7h6dv7n6icZ8EKqNKi8eww9ap6EL5HZXbSfjCJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0uQ0bXpbu8nccM2bv8OfNLLK1sk5XBI5uR7s8Qkqn4=;
 b=BujNu/0cgC7QLMYJi8bldH/M5xJe2FSwFIxog3ygJf2yFp73gF3kL9Ax2kLfwoIuJaIGE5d4lzbudsbz3q58zqe8Hz+n6a703AzHBfHr4Vw8QmLQEP+0DHp/V3RF8H5TLXrrZkeKKVBGxWSjIptZ5QfWJOSaIJh0eTsO0isT3jWykJOOnCvaofwcOdEao3VY88l8zQ/HrXvfnUN+PeNuDaDMO5H/5oSUcuZhjnUTLxfTWBT1O+TBe9RLDgNlXNFEflviCacph9euFeW/6Fbi/xbYL/BLvP4Xu6HM9wCN6hw1fdQT1SmOM+YUzJmkAz1k66/yyABnYMgovL49MGoYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0uQ0bXpbu8nccM2bv8OfNLLK1sk5XBI5uR7s8Qkqn4=;
 b=JhxulzzLuNgf6zz5h83NoGstDbrW0SDfPRFO6u3/fx81jS97eT9BneWqrCcQNJd0Tfe3FL0VUf91MJOMGZdO35cZ4yuisIvR1zo9PZS1mUiBrbj6RLjonLN0LCCNbU/8D08BLGVu4UttWJlMqZWBqPYE86m75bKzk27wfSsbck0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6166.namprd12.prod.outlook.com (2603:10b6:8:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.23; Thu, 20 Feb
 2025 20:07:05 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8445.020; Thu, 20 Feb 2025
 20:07:05 +0000
Message-ID: <27d63f0a-f840-42df-a31c-28c8cb457222@amd.com>
Date: Thu, 20 Feb 2025 14:07:02 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, michael.roth@amd.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
 <CAAH4kHab8rvWCPX2x8cvv6Dm+uhZQxpJgwrrn2GAKzn8sqS9Kg@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHab8rvWCPX2x8cvv6Dm+uhZQxpJgwrrn2GAKzn8sqS9Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::32) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6166:EE_
X-MS-Office365-Filtering-Correlation-Id: bb75c358-2f94-489c-2290-08dd51ea256f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkpGWlJUU2ZNUTZDalBaVU1mN1Z4VDlOVjFscnkvcTZLZ24xK0dpWnJQa2Nq?=
 =?utf-8?B?RWVwcFFKR0ZYc2duejQ4MHZGOHA5U1BlUDF5UGZtUzJ1OVNDaU56ZHJEWjJF?=
 =?utf-8?B?ZS91U2dJWDFubDhzYlY0aHRDV0ZXOGdaQ1FJZ1BwWC8wMEZqeTg3M3lMOVNG?=
 =?utf-8?B?RWkvcWpHSGpORmRyTkdiVVpqQ25jVFI5d2dLZkZDdHc1QmRCMjljUTJYZjl4?=
 =?utf-8?B?NzhYRGZLUTRrQzNvU0FJV0Rud1RzaXhvT2pUSFZyaDVGZzQ3MzluU0g4djdF?=
 =?utf-8?B?VU9wNi9yaHNjOGJpMENSRWdsOWREcjUwcURrcUxlTS9MSkpPTS9hM3E3NGJQ?=
 =?utf-8?B?Y2NPanp6dzlHS0xvbTdJZDZoSTduV2pjTXd6UldVQXp1QktPU3JHeW9TL0RX?=
 =?utf-8?B?Z2FpMHphVmZtM0l6dDFqL1M3N1F6TnR2eHhQNUpBbXo4TU5JWlh2S1BGZkFm?=
 =?utf-8?B?bHhMc2FXNmdJMEFmT2xQNkphZFZaM3B5ZXErVmNFN3FTQmFTdExPdjh3SWR6?=
 =?utf-8?B?ZWdVNndOcEdlaWhEdUE5anZSYjFsQnpBUm8rQTJtTWc3U0Q2dmorR0xxd2Ni?=
 =?utf-8?B?REJGSytpbnpFTDFmcjBIem9GT0RldzVFYm5SYTB4SHUzc0wxYVk0Wkl0RmpI?=
 =?utf-8?B?VHRLQVlkQkZpMlNLSFJteENZZnREOVdHb25sT2lvRWp4OFhuQms0bVhMVVpI?=
 =?utf-8?B?dDNGQ01UbllFcUNuNk5mRjVjb2E4emYxczBDV2p1aUdLbm5PbUlieXY1K1BL?=
 =?utf-8?B?ZTBXUFdvN3Z0RUZKL01DTEJMUWJiQ1RybTd3dHk3QjVJM3FPUVRXd1V4VWFi?=
 =?utf-8?B?cm95Tlh2dnAwbDJsK2RlcUlxMVRHY0hIMHdGYThLQjlVc0RtT0pSNmt3a21K?=
 =?utf-8?B?c1cxZi9jTG9RQ1dibHR5S2JBVlo0ZmJPM2t2c2hUQmtPdlhZK0ZGbzJ0R1kv?=
 =?utf-8?B?QzFUcEp4WFRacHlPQzkxUFFidWRGTnRjb1h0c2ZHc1krVXZ4WCthTkRtZy9s?=
 =?utf-8?B?YzZzVXk5aE1wbGk3azNmajRGOVVLMHpnK2lSTTgzcEJEdFBVYmhTb0V2aEcr?=
 =?utf-8?B?M1FwZzFKT1c1b25jbmJaMS9RUFo4d3NocjExZlV6cktmZTFTcDBVWURmQW5x?=
 =?utf-8?B?QVB4eXJhVlhFU0pmZzd0aGtpWGVVZTJMUmFSSG9GUWNhazRUck5qMlIwbGF5?=
 =?utf-8?B?V0p1TVpqUGJFc3hKaisxamtyMVFRemJqczhHOENocWhDbEJ0dDNNdG0vSFlv?=
 =?utf-8?B?czhubmhWVnlSVUtDOHRSSzN0YnBXMHZBL0NtSXQ4b0xwalRPVFJ1T0d3ZDJN?=
 =?utf-8?B?Y0txTSt0NlhzLzcxTFBCWnBPeFE3aTJJTGRQUm8wOW1mcjRXZGNDWjBxZVJX?=
 =?utf-8?B?V3ZCVHI4dnFRbmdWcnR6SXlNZXlLYXZtTU04a2NGQnNTWlBSelB3VTEvNEVW?=
 =?utf-8?B?bjBIbjdFdERQTU0zWjNmUkdHSGFNOGh3enR6UTMxbVNWei9YaktRNWJyMnc4?=
 =?utf-8?B?d3hqdWdzOHNlTmRKN1N3Tmc4bllRbFVTYXQ4cis2V1lNR2xqOGo3czhYZHBh?=
 =?utf-8?B?NmloQnBZVUJpaHZhblNEN0NUaGdxVHhNRVozVEJlemNEa04yWEc3czFaWGpn?=
 =?utf-8?B?VVZiSDdPVURTZjl1NlpSUytlWklwMFB6bnpYZlUwTFFVWUk0OW9pdVJKZ2JQ?=
 =?utf-8?B?ckpGd2QvcXBHaWJyRlJBakp1dlFWVXJVVmswaFhZb1JLL1pScElQL005ckJs?=
 =?utf-8?B?T3Y2NGRzcTRvdmQwTFhZb25hOG9CVkZUMkxpcWxtb1FnczFZT0NDMFNZRHgv?=
 =?utf-8?B?NWZQMDVzZnZWTTFKaWN4V29QbFVLNDUzWXdaQUhFdXF1T0JkRzNmUkFVNjBn?=
 =?utf-8?Q?42Aa3TRYnd1AE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1FOVUxIUnUxN0tUZlVPa2ZpQWNXYjZvMGJZbkdLRGEreStobDl2b1E1elpj?=
 =?utf-8?B?OUNPMGdBbzd3TG9Da1JVaFJlOGd1NHV5OE9pZEJkK1krTmJqU0pwWjhaYjRu?=
 =?utf-8?B?NXRkeXhGWCtxQnNNYVJwQjBZQW9hQkhFYUQrbFVzVnFzVDJaYThpdHQ1Sjky?=
 =?utf-8?B?QXE4OWhpN0Z3aFc1eGtlanBwY2wyZFlCRTI0TFNnaTVuZDUwNFZib3hwd3c1?=
 =?utf-8?B?QjJ1OVVMSlZYZjB0Y2FLNGw5S0VRU0hIdEJINi9XRHVmVUpvcTdTNkhyZExP?=
 =?utf-8?B?OUQ0a0lFUnRJbEt4djcya3cxY0l1OEFWTktQeVRyb1hBNGRrdHRESDlDWjVi?=
 =?utf-8?B?MmpXelF5ZHRKa2I1TDViMXY5RzJvMEhLNDZuYVVUbXpUT1h2SjB6TEJvRFgy?=
 =?utf-8?B?aUVWZVBIUmtQTENtTTlwMHJGclV5VEkwcU55dk4rWU5FOGMwL0RUT2FiUkZT?=
 =?utf-8?B?UlRyQkV6cTJaRm5WTW5BdTBQcWhyRVRYVlNUSWVJQ09OcTJTbkJ6d0FpekJE?=
 =?utf-8?B?Y2xBZHZkMmwyR0hmMGcwdkRkSXlDOFNzYVBaY0VKS2JuQ0Ivcjk3ZVQ5M3FJ?=
 =?utf-8?B?Rk0raWhxNER0bUV1QVdtSlozTDBBNGw1YjlLMm15S1pXVFd1OHRtMHpZbVVG?=
 =?utf-8?B?Q2FkeWN3S2ZWM3g4L2RISndQY2JUWnZiZzQrak1YZVA1MUNVK1J6TXBrR1JM?=
 =?utf-8?B?RUpKZUZqajhRSVg5aVBuajhYWTNJU0NtelBENS9yc1MxYTJSc2NZalYrNjJn?=
 =?utf-8?B?bU9nYjdCODdOVmsyZHBDbFg5VnFuWEpCYnk2bG1UMnJVTkUxWlNNUldRdjMr?=
 =?utf-8?B?LysrT2wrRXVtVU1FT1p2WVFEdnNWWll1YXBGcWI2Tyt6R1VqQ25sc2tFMHhl?=
 =?utf-8?B?cTh3Mjl0c1VYUHVEaFR6S3FxUVY0YUdRZDlZVDBFb3pVRWFLNU1FOHZ5T0dv?=
 =?utf-8?B?ZkVzTk9PUWZYR0tKRzU4SklnODdERFpsc0pLMnkvUU1MUGhjWXF1OVVEOEl4?=
 =?utf-8?B?UVVuNXJvWlFqWUJHM3d6Yy8vSkJycHppMlYzaThRdHRWbm1nVEhkV242aTZB?=
 =?utf-8?B?SU5HdEhKY0Q4Y2tNK251aVRhTnRZQitxaUc4eFVoUnNKZUZHazIxMDdteGpT?=
 =?utf-8?B?elNrTUdDUG1CWnBrSXVnMGVMaGJJdHh0ckd2N0VlZXBUN1dBazNhYVhpSW5p?=
 =?utf-8?B?Slc2SlA0ZWliTXUrTysxSWZIZWRNSHl3NzVJOWVuUDlTblFJUnZWdWpQbzRJ?=
 =?utf-8?B?RncraGV0WWpDdkVkeGhla2kybXRBWmZhTlNZb0YvdTcrbFd2Vzd1aWZSaHIz?=
 =?utf-8?B?b0h0amNHNVhYY3JqRkdCTlFGSWRXSmwwMlZka2RmdUxVTlAzalFNb0pBZlFC?=
 =?utf-8?B?TDhPN0JWYm1CdklXbC9XOWdkcFVjSjdNSTJKYmp1dWJldDZ5ZWFLWTdreDlY?=
 =?utf-8?B?cjBDTkIwNWdXV0puQ2ZnS2ZDWkoyR2VrRXpxK1h5OUthREtNZTVYNU1TS0lR?=
 =?utf-8?B?VTZsT1FITmdVTTdodEY2NEp1UmlvMXBrZHBUUVFVM3ppdThuaGpJbkxNNlBF?=
 =?utf-8?B?L0N1eHAyRWh6NllpZll2SDhHZUZBcFpoc2xEMXIxUXhoOW45akQzV1F5SkRm?=
 =?utf-8?B?RkRFajZ3Mnp5aTdJSVpBNGhYNnNuRmNxUVVHaTI5bDhoU3VnNFV1cjhodjZz?=
 =?utf-8?B?Sm1XbG9yVTh0b2NjY2h6N1lqTDR1ZkRkV3NSeGdOUi9UUUtSTUY4dzFZOEwz?=
 =?utf-8?B?V2pYdmxqSDA1SWM1Y3FETW96TC9pWTljWnJlWnNGYUVqcmJNYW4zVjFVZjZ2?=
 =?utf-8?B?QlBVM3k3Wm1DNklrOGYwUndvMXJJSWZXZ3dEWjZUS2xSc2d4bDMyRU1UbDB3?=
 =?utf-8?B?cTFEY0JJMkJ3NWJTSXQ0b25kTUhrZ0JvYWlzMHZZWHpDZ3dSWDh3UFdZbTVP?=
 =?utf-8?B?WXlyTytqekFOYWQxb2k4Q0hQS2xucXhTaE0xT2N3NGlSUzBKN2pCQ1JFNk1C?=
 =?utf-8?B?Q05jb0dnSC83Mk14enVoZWlmK0ZtTnU3c0ZXRTVPUk5HNk5oMGpkOExiTjEx?=
 =?utf-8?B?MXoySkpHb2JGam55SEMzOGlLNTRhNG1MNTlVUXE2Y29zWGhaUnZwbTBaS2sv?=
 =?utf-8?Q?eAa8S6vDoR/24xoNDPz5jyyox?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb75c358-2f94-489c-2290-08dd51ea256f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 20:07:05.1177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBH/s/OWJEIoXYQnY2jKejTH8vvR1gFZPQf2MrLyPVr9TRo8HSxodAnLRKbncgNJ/GI74CEIfCSO3QrVzwynWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6166

Hello Dionna,

On 2/20/2025 10:44 AM, Dionna Amalie Glaze wrote:
> On Wed, Feb 19, 2025 at 12:53 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Modify the behavior of implicit SEV initialization in some of the
>> SEV ioctls to do both SEV initialization and shutdown and add
>> implicit SNP initialization and shutdown to some of the SNP ioctls
>> so that the change of SEV/SNP platform initialization not being
>> done during PSP driver probe time does not break userspace tools
>> such as sevtool, etc.
>>
>> Prior to this patch, SEV has always been initialized before these
>> ioctls as SEV initialization is done as part of PSP module probe,
>> but now with SEV initialization being moved to KVM module load instead
>> of PSP driver probe, the implied SEV INIT actually makes sense and gets
>> used and additionally to maintain SEV platform state consistency
>> before and after the ioctl SEV shutdown needs to be done after the
>> firmware call.
>>
>> It is important to do SEV Shutdown here with the SEV/SNP initialization
>> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
>> followed with SEV Shutdown will cause SEV to remain in INIT state and
>> then a future SNP INIT in KVM module load will fail.
>>
>> Similarly, prior to this patch, SNP has always been initialized before
>> these ioctls as SNP initialization is done as part of PSP module probe,
>> therefore, to keep a consistent behavior, SNP init needs to be done
>> here implicitly as part of these ioctls followed with SNP shutdown
>> before returning from the ioctl to maintain the consistent platform
>> state before and after the ioctl.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 117 ++++++++++++++++++++++++++++-------
>>  1 file changed, 93 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 8f5c474b9d1c..b06f43eb18f7 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1461,7 +1461,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>> -       int rc;
>> +       bool shutdown_required = false;
>> +       int rc, error;
>>
>>         if (!writable)
>>                 return -EPERM;
>> @@ -1470,19 +1471,26 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>>                 rc = __sev_platform_init_locked(&argp->error);
>>                 if (rc)
>>                         return rc;
>> +               shutdown_required = true;
>>         }
>>
>> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>> +       rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
>> +
>> +       if (shutdown_required)
>> +               __sev_platform_shutdown_locked(&error);
> 
> This error is discarded. Is that by design? If so, It'd be better to
> call this ignored_error.
> 

This is by design, we cannot overwrite the error for the original command being issued
here which in this case is do_pek_pdh_gen, hence we use a local error for the shutdown command.
And __sev_platform_shutdown_locked() has it's own error logging code, so it will be printing
the error message for the shutdown command failure, so the shutdown error is not eventually 
being ignored, that error log will assist in any inconsistent SEV/SNP platform state and 
subsequent errors.

>> +
>> +       return rc;
>>  }
>>
>>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_pek_csr input;
>> +       bool shutdown_required = false;
>>         struct sev_data_pek_csr data;
>>         void __user *input_address;
>>         void *blob = NULL;
>> -       int ret;
>> +       int ret, error;
>>
>>         if (!writable)
>>                 return -EPERM;
>> @@ -1513,6 +1521,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>                 ret = __sev_platform_init_locked(&argp->error);
>>                 if (ret)
>>                         goto e_free_blob;
>> +               shutdown_required = true;
>>         }
>>
>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>> @@ -1531,6 +1540,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>         }
>>
>>  e_free_blob:
>> +       if (shutdown_required)
>> +               __sev_platform_shutdown_locked(&error);
> 
> Another discarded error. This function is called in different
> locations in sev-dev.c with and without checking the result, which
> seems problematic.

Not really, if shutdown fails for any reason, the error is printed. 
The return value here reflects the value of the original command/function.
The command/ioctl could have succeeded but the shutdown failed, hence, 
shutdown error is printed, but the return value reflects that the ioctl succeeded.

Additionally, in case of INIT before the command is issued, the command may
have failed without the SEV state being in INIT state, hence the error for the
INIT command failure is returned back from the ioctl.

> 
>> +
>>         kfree(blob);
>>         return ret;
>>  }
>> @@ -1747,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_pek_cert_import input;
>>         struct sev_data_pek_cert_import data;
>> +       bool shutdown_required = false;
>>         void *pek_blob, *oca_blob;
>> -       int ret;
>> +       int ret, error;
>>
>>         if (!writable)
>>                 return -EPERM;
>> @@ -1780,11 +1793,15 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>                 ret = __sev_platform_init_locked(&argp->error);
>>                 if (ret)
>>                         goto e_free_oca;
>> +               shutdown_required = true;
>>         }
>>
>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>>
>>  e_free_oca:
>> +       if (shutdown_required)
>> +               __sev_platform_shutdown_locked(&error);
> 
> Again.
> 
>> +
>>         kfree(oca_blob);
>>  e_free_pek:
>>         kfree(pek_blob);
>> @@ -1901,17 +1918,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         struct sev_data_pdh_cert_export data;
>>         void __user *input_cert_chain_address;
>>         void __user *input_pdh_cert_address;
>> -       int ret;
>> -
>> -       /* If platform is not in INIT state then transition it to INIT. */
>> -       if (sev->state != SEV_STATE_INIT) {
>> -               if (!writable)
>> -                       return -EPERM;
>> -
>> -               ret = __sev_platform_init_locked(&argp->error);
>> -               if (ret)
>> -                       return ret;
>> -       }
>> +       bool shutdown_required = false;
>> +       int ret, error;
>>
>>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>                 return -EFAULT;
>> @@ -1952,6 +1960,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         data.cert_chain_len = input.cert_chain_len;
>>
>>  cmd:
>> +       /* If platform is not in INIT state then transition it to INIT. */
>> +       if (sev->state != SEV_STATE_INIT) {
>> +               if (!writable)
>> +                       goto e_free_cert;
>> +               ret = __sev_platform_init_locked(&argp->error);
> 
> Using argp->error for init instead of the ioctl-requested command
> means that the user will have difficulty distinguishing which process
> is at fault, no?
> 

Not really, in case the SEV command has still not been issued, argp->error is still usable
and returned back to the caller (no need to use a local error here), we are not overwriting 
the argp->error used for the original command/ioctl here.

Thanks,
Ashish

>> +               if (ret)
>> +                       goto e_free_cert;
>> +               shutdown_required = true;
>> +       }
>> +
>>         ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>>
>>         /* If we query the length, FW responded with expected data. */
>> @@ -1978,6 +1996,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         }
>>
>>  e_free_cert:
>> +       if (shutdown_required)
>> +               __sev_platform_shutdown_locked(&error);
> 
> Again.
> 
>> +
>>         kfree(cert_blob);
>>  e_free_pdh:
>>         kfree(pdh_blob);
>> @@ -1987,12 +2008,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>  static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>> +       bool shutdown_required = false;
>>         struct sev_data_snp_addr buf;
>>         struct page *status_page;
>> +       int ret, error;
>>         void *data;
>> -       int ret;
>>
>> -       if (!sev->snp_initialized || !argp->data)
>> +       if (!argp->data)
>>                 return -EINVAL;
>>
>>         status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> @@ -2001,6 +2023,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>
>>         data = page_address(status_page);
>>
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
> 
> Error provenance confusion.
> 
>> +               if (ret)
>> +                       goto cleanup;
>> +               shutdown_required = true;
>> +       }
>> +
>>         /*
>>          * Firmware expects status page to be in firmware-owned state, otherwise
>>          * it will report firmware error code INVALID_PAGE_STATE (0x1A).
>> @@ -2029,6 +2058,9 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>                 ret = -EFAULT;
>>
>>  cleanup:
>> +       if (shutdown_required)
>> +               __sev_snp_shutdown_locked(&error, false);
>> +
>>         __free_pages(status_page, 0);
>>         return ret;
>>  }
>> @@ -2037,21 +2069,34 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_data_snp_commit buf;
>> +       bool shutdown_required = false;
>> +       int ret, error;
>>
>> -       if (!sev->snp_initialized)
>> -               return -EINVAL;
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
> 
> Error provenance confusion.
> 
>> +               if (ret)
>> +                       return ret;
>> +               shutdown_required = true;
>> +       }
>>
>>         buf.len = sizeof(buf);
>>
>> -       return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>> +
>> +       if (shutdown_required)
>> +               __sev_snp_shutdown_locked(&error, false);
> 
> Again.
> 
>> +
>> +       return ret;
>>  }
>>
>>  static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_snp_config config;
>> +       bool shutdown_required = false;
>> +       int ret, error;
>>
>> -       if (!sev->snp_initialized || !argp->data)
>> +       if (!argp->data)
>>                 return -EINVAL;
>>
>>         if (!writable)
>> @@ -2060,17 +2105,30 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>>         if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>>                 return -EFAULT;
>>
>> -       return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
> 
> Error provenance problem again.
> 
>> +               if (ret)
>> +                       return ret;
>> +               shutdown_required = true;
>> +       }
>> +
>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +
>> +       if (shutdown_required)
>> +               __sev_snp_shutdown_locked(&error, false);
>> +
>> +       return ret;
>>  }
>>
>>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>>         struct sev_user_data_snp_vlek_load input;
>> +       bool shutdown_required = false;
>> +       int ret, error;
>>         void *blob;
>> -       int ret;
>>
>> -       if (!sev->snp_initialized || !argp->data)
>> +       if (!argp->data)
>>                 return -EINVAL;
>>
>>         if (!writable)
>> @@ -2089,8 +2147,19 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>
>>         input.vlek_wrapped_address = __psp_pa(blob);
>>
>> +       if (!sev->snp_initialized) {
>> +               ret = __sev_snp_init_locked(&argp->error);
> 
> Error provenance confusion.
> 
>> +               if (ret)
>> +                       goto cleanup;
>> +               shutdown_required = true;
>> +       }
>> +
>>         ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>>
>> +       if (shutdown_required)
>> +               __sev_snp_shutdown_locked(&error, false);
> 
> Again.
> 
>> +
>> +cleanup:
>>         kfree(blob);
>>
>>         return ret;
>> --
>> 2.34.1
>>
> 
> 


