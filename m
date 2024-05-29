Return-Path: <kvm+bounces-18273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E007E8D34BA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 116751C22886
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E8C17B438;
	Wed, 29 May 2024 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tQ4XDHDq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBB2167DB1;
	Wed, 29 May 2024 10:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716979425; cv=fail; b=T+IWuh25nD9zUDCSJ9eWMzpNGLIVgY19ESsmYT6eMhDy1qa6R4/BXKVsNTqaHkMO4yv6YLiL615Uo+6Cs0ltIzKSq38FMELM4l4IJWJZYw/yQ918WAgYcild9j/3sxZxDMHEKZEAZnuxsDJHtYag0dI+n5SuSk07Tjuqfit9K6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716979425; c=relaxed/simple;
	bh=szbP6760RCMriJqwwwfoVzrDamuqeRr4c5J7eATwCO8=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ESE3pjWCzHa/7lNfmaSBq7DIl+FYgDG1HPZEdbRmW8F35L0cHYANqPyrr7PUKTxe5VsgWCnFM31zq6B0IAM0V7gZ1LL+fhz9syUVKSwhZ+hGs/03xHLBWYVy90I3+D0L5J9AfNTkAFiCGqhGO6gMXVLmOHYUMO2GTPUAX2t2mIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tQ4XDHDq; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyBFKbRquvEXsAE2KhTzrMeUuxKu+BFl7NHscNyisuWM8ZlLyKgjXhK5xfeA6Ahyunxpt4eNsjYegzXXBWLVee71ifn8UdAT95Cfh1SbihEcnxQWoqyYT1GE7WV7mgWRKvbx2Md9XwneFQeV/Axq3rUN7f76ZdSPSi7eo8S+CnUhRUKcU/FfdWsU+iZWA/Uqr8r2bwbAfzYRXDPzztu4jc0FCgmZeKp0O5/w31n63fAllzNiSn1x42+i940JIbNrRP7dRfveDtgGtZkqCuusR0EsXMDPUTT+p70c1Ze7JZweYUvpWR5ClzGne2nLDtUN1THNSyD3PLfqhDUcjpUB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGVG/e7XNPWNqTHy3vXW+0JjecjNBrau/CgDJdaVkLc=;
 b=eZ9LPC8uV7OWGJAwha6RLlYWD3gwBbdCpIHHxk3WfGGujZhrbpuqRkbUw3dhecBZ6XW81NpHVTCEINToXRq2oRIBY7zXrNxaeU3R5dD8kFs2YWiFnWhGklHmxKotx7JQaUxWEsR/HRCuifvSLXUu6bqf+napwpZ9Ee/2COdjxKhmo1dQJhjV2ffXEPbMMivz7Kho2APQI7yBmUjKlBbwhBtcyGq32qBbK5OslJrfTco4p9LMMKVQhWKAZoLz2zqxc3gfNfKWt4KjfFAzg8WJjIhwbXvGN8VLzOgn/klYoSTWA6cvVqhX17t2Rqpx03DkLUQptSn2Q1NImjHO3IYW6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGVG/e7XNPWNqTHy3vXW+0JjecjNBrau/CgDJdaVkLc=;
 b=tQ4XDHDqKo3FPdXaH6T+7G6/Y5TS+X5bio5BcCjOxnY5m+cDZVG5+s7dK5O0pBbWjWbXaKVyUrMbu+Swz7zhWELTjzJ+h6wee2Da14oKLQqE3gJV2L4tKbRbEfHr9V6R9rY+ZntfoTyoBwcv8ydVit17RlVVD6+tuIkDUiEgtmw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by SJ2PR12MB7992.namprd12.prod.outlook.com (2603:10b6:a03:4c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Wed, 29 May
 2024 10:43:40 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7611.025; Wed, 29 May 2024
 10:43:39 +0000
Message-ID: <5c49ebd5-26ae-4a06-85e8-9f90777a904b@amd.com>
Date: Wed, 29 May 2024 16:13:28 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v3 2/3] KVM: SEV-ES: Disallow SEV-ES guests when
 X86_FEATURE_LBRV is absent
To: Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
 nikunj.dadhania@amd.com
Cc: thomas.lendacky@amd.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, pankaj.gupta@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ravi.bangoria@amd.com
References: <20240523121828.808-1-ravi.bangoria@amd.com>
 <20240523121828.808-3-ravi.bangoria@amd.com>
 <9626063d-40ed-4caa-8ac5-ba2e88b6e398@redhat.com>
Content-Language: en-US
In-Reply-To: <9626063d-40ed-4caa-8ac5-ba2e88b6e398@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::16) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|SJ2PR12MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: a317f818-ec2d-4f17-8ae1-08dc7fcc338f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WS9ENlFlZklnWlYyTmludzQvWm9QcDdZT3RwdFFzU0xCTUM3NitFQlB1QVEy?=
 =?utf-8?B?aEdpbUtncVRGR04xOW1jU3dTaVgzbFB0bWhWUlJBblNsNDl1MnRBUFRnQkV3?=
 =?utf-8?B?eVk1bG1jTkdPRlZxVUlWYU4yb3JpbnZIWXZ4bG5DSFBPdkIzdTBsZGhDcmdB?=
 =?utf-8?B?dUROYXEyOUFnWG44VC9lelFtMmx4Q2w1TWt5ZFluVkNGY01EdjZza0g0MzRo?=
 =?utf-8?B?YXlDSjE5QTFady9XU1Zqc1JhRFI5blNiVmsxOFlMWG9mQWIzRkwvVU1oaE45?=
 =?utf-8?B?eC9UT280M1hUd1ROTUp6MG9ZU3Fxa0NsMHFOektoL3J5N0VERWRudmxqS2Js?=
 =?utf-8?B?ZjE1dkpETDZsaW1CQTIzRFB1NVdEcXl4cmxqaTBXM3pYSG5mTDZROWNNVksz?=
 =?utf-8?B?U0VyamdQSE1zTEZWQkl2RDRiMjdURWx3OWVxb0NhVHdLNmFTaTlDV001eFk2?=
 =?utf-8?B?T3F3S3dQaEtVUWlDZm9NY1lheXdORDFuUVhmanU4bUZkNkZuV2NLQlB2UzhO?=
 =?utf-8?B?TWs3eEljMlg2cDRDamJqWG5WVzV5SFkycG5qWVdhQS9CRTFobldoZ2pyZ01B?=
 =?utf-8?B?OGRBZDdsdnNkY3o1WTlGMXFaR3Z0VnYwV1pxTzQrRURTZm1EZTdVMEpHWGh4?=
 =?utf-8?B?L05SUEhCZytFTm13UlFyZHNqcTM2MnZkNnI2VkU4eDZnY0srRFcyOHlYRVpT?=
 =?utf-8?B?bHFDTDJpYThYK3RpTklqWFpEeVprYStCQ2duNGFMaTBEcVdFYndyRlVsMFU3?=
 =?utf-8?B?OTlScGcxL3l4a2o1MzRWRk0zS1plQ3JlMnVvRFZJQThRWFFwcmJIL0x4Z3ZH?=
 =?utf-8?B?Wmp1bjVxWDlaWGxSSzdVb0E1QThyNEtwbmVwRm04TGhVckxCR2EzMkwvRVN5?=
 =?utf-8?B?SkpBUklBRVdKTFNtS3hmMSs4Mmt4ZGFpdWpRWk5aN1ZSMnhUSFpkMUo0MVZR?=
 =?utf-8?B?NXFiZFpoRE82ckFOblYva3NFS1FhbEVBOEtjNGljZ1NPU0t2Z05ETzFXQzQ1?=
 =?utf-8?B?SXgyK1Qzdk1LeDRaMHNHeThyN2NyUkJIMHBoOE1UUGc3Q2hXWkJ4dG50TXo1?=
 =?utf-8?B?bGNnZ0pKTktDS0pJM3FwZzlnTmZ1YjQ4d1FBcjFSVkNtdFBnbkt2ZWdWaU9J?=
 =?utf-8?B?Rkt0cmZxeW9Uekl5ZXdIVHA1VjY2TmRYVkdXUXNvRk9VbFlWYjlvdTMxM0lD?=
 =?utf-8?B?L3FaejVhYjRjNkdiOFUwc0xuM0N3NVVsaFIwWTJPZzJGYk4wZk1MUUZiQXdK?=
 =?utf-8?B?Q1ZhZ01LUzhVa3F5alJUMW9QdnFFNHZjaU1KVStlZnJMdmJFUHpNcWtPd2ZU?=
 =?utf-8?B?NnNjRWFWRmZuSEY1ZWswZERBTTRyR2RES2N1cGdFRGRZZlJvcFhWcWdsVmY4?=
 =?utf-8?B?a3lpcUpXT0tNc2doVzRQdXhqM2d0QmNrc3hZSjE4eXVhSDN2THJEL2tnOThp?=
 =?utf-8?B?d1FWMEdPVDNNSWVZa3BPNWpUKzBBUkhFSTcrTjlPOHlEVnFoS2FsbVhma3ph?=
 =?utf-8?B?Vzc3elYvbkdaMVpoVWN3bVduc1l3OTV4NGk4RkdVN0JoZjJNQU01cTU5dC9R?=
 =?utf-8?B?WnY2L21FdDA5d1pyWTlvT1VqVktiNXRIR0l5dkpZSlhIY2g0NWxMd0tlZzBH?=
 =?utf-8?B?V0VZd3FIK0J0eG1lcXdBOFJpTWtGSnJmYmpmMnhWTFQ2RGJ1UE1uN2d4cE5F?=
 =?utf-8?B?L04rR09aRm1NRFdNK1RVdXBMNFNjU21Jd0JrZFhhK3ZLL2tMT2JxYlJ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0k5Qk4vSG92MjkyYWJCL1A0SXJBQ1RFY0Q0L1JVYmExM2VFNU9JNkZGN09M?=
 =?utf-8?B?QWsxcnlJd0xlOEZNRnhneTg0SWNTOFgxOGs3WERCajhHb3M0WEpuRkNGelJB?=
 =?utf-8?B?REZ2U2NzVHg5aHFCMWRnQk53aWVuRkZJSXRQUkRkVzk2Z1E3SlJVdzdOWUZ3?=
 =?utf-8?B?ZTBFR08wbGNRZy9Nck9UVG5SbWt6MVpqOGtpU1VjaDFYaTViU1owd1pUaWVj?=
 =?utf-8?B?R3FXVEh2VHltNGRHaENBeFYyTGxJRmpTV0N0YlAvYWdPWnB4dDgyVks2dUoy?=
 =?utf-8?B?aDhVSFBST1BPbm8zeXZ1aUhlUnBGWlZaMU45a3NhYmVacUI5VnNZRW9GMWkr?=
 =?utf-8?B?UG5rbmFJNXlLV1VIMmNucHQxd3V5eWZKMWN1UmFobHJzcnhoTjltbkgxVENR?=
 =?utf-8?B?SUxPcG4vYkUzaGh4anJRVGlxRzh2TFB1MkRFNERMTjlEN0lnYUUyWGY4bnZN?=
 =?utf-8?B?M0cxOTdhOW9WVXZYSWlxZmhRNkNjb01lTzNITCtIWmRxR3lwNHdFOFJWcXpt?=
 =?utf-8?B?cmZtbnQ3VXN2TDkydkw3WEwwSlUzR1h3Q2ZiT25UazBESTg3c3Y1NnB5a3Zk?=
 =?utf-8?B?eU5ZQ2YycVZ2SW8zbnFwa2NsQVBEM3h3NU5pN1NFSHBTN0ZTZ2NPVERiM283?=
 =?utf-8?B?TWdWcFBWNGVZQUFqVHpSdkdReGc2Wm1zUVRiWjdGK3Q4WHZ1NW1GTDA2NXZs?=
 =?utf-8?B?NVdEWHJlT2Q2dnExYzJzRkt3RWFlTWZZc1B5eFVLa3REank2K1lhQmNOcSts?=
 =?utf-8?B?K1dSUFhxcUdTRmZ4SmgzTVlmWUJBanNWYnhpZVVnZStGT1dCYklVT2ppZjFo?=
 =?utf-8?B?VE5vNjdkZzlwNlB4bm9xblUyWWdySWt5NGRKbVF2TDZYSWh5bG5ocWtqeW83?=
 =?utf-8?B?T3I1M0c2L1JieUJjdlN1OW5qR1ZJOHNxRCszS1ZuMjFYMUgveXVCS3ErMkxo?=
 =?utf-8?B?U1VpNDNQd0tiUjdZSW0zQTI0cTBvMXBYTDJKRmdlSHVjZkhtSVgxdVpxREU1?=
 =?utf-8?B?ckRzaEhybTNBKzBRSllOUDA1M3YrdFhEdkRiYmF0elYxRGwzNGNqb1pSUXdk?=
 =?utf-8?B?NmtBdUhrTGxzMXBKTWdOWklvOHJpQ2hGUVYwUkJMQWpjTGV1ZU1sK2hkMDky?=
 =?utf-8?B?dTZYNmJjVkhMb2dqaW1BWlV1YzcrUk90L3Zyd1pybk12R0dQK0V5QkNUREJX?=
 =?utf-8?B?ZHdFN3p4cGhhTHZjU0NXbXUzT3FGWVlmZkpEOUhWZ1lNV28wZjBYZkZkTVpM?=
 =?utf-8?B?Nlh3a3A2V0JOK1ByRjNIQUxvaXpCdHVYUEVBcFFWaWxlbW1QTkZQVFZZOXBK?=
 =?utf-8?B?Tk13UEZFVmFVZUpwdXF3VUtTU3ZCUGtvSUhpaWpNQnBscDVUQmtEOHh5S0E5?=
 =?utf-8?B?RGdXMUEvV015MmVpeGpaMkhyV0M0elpLRnkyYmk2QlpxM3NPS0o2NThzWThm?=
 =?utf-8?B?U2s3cjhOKzJ4NWp3SG5oOTJSNkxjcFZVK2RHSWRsZUpKRmJhRFhxOEdlT3g2?=
 =?utf-8?B?SDlUV0p1STNrb0w5UzFCWlFkUzI1UjRGaGIyOXNZd2JmODNrSE5NUnN6Yk1h?=
 =?utf-8?B?eGJtK29jZEdzakpNNW9QVDUyaElXeXJwYUtCSlhXSW9QazZ0eEJaR0RmTnVV?=
 =?utf-8?B?cFA4VVhlaklGTmkzSU9qTzFqV21yRnJ1Y0FJRjRaNnRzdVhybHRvbnVtaFNB?=
 =?utf-8?B?cUdGc0hvVS9QWTVyeXdHWEV2aTBWRjU0b2kwMHlncmUrS2hsLzJ6YWdVRmt0?=
 =?utf-8?B?WHl3a3F4TUVaM0tmbWVTeitsQm04UXBzdldic2FOeko3SmwrQTVKQ3N6aTlV?=
 =?utf-8?B?b0ZIMThNSDFzT2o3dTJESDNMVEN0U0F1RzRrSDRBU2dvaGlSeEU5VUJhTkcv?=
 =?utf-8?B?b3FIa0dOakwrTGczU2t4LzkrbVY5YmJyVEhzV1A0MnVZM01VTkQvV0pYTGl0?=
 =?utf-8?B?eEN4QXJHTHZ5Sjd4dmFmMDBYbk92T1d2SGovaUg2ZVVhYjdlTkRRd0poU1h3?=
 =?utf-8?B?cEtKZ0VvZ0VBWTdJR09SdjlyYU9QclVxN3cvUS8zVUx5VCt6SitWdG56NkFY?=
 =?utf-8?B?WDZRYm56cWprZ2hxdXl6UlljZnNNQTBvaTlyTnY0S052WWRXdGxPQW84QUg5?=
 =?utf-8?Q?PhoLY1CtEyvShMJno8wwVotoF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a317f818-ec2d-4f17-8ae1-08dc7fcc338f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 10:43:39.8621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n83ENCok3uA/Z3NHB4QYdMI0ldiE9SfcUqpb+Kx0cF8uzgcWei7bgpP4ODyZ+9qvtfVtMS3CuNcyS6WVlKm5LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7992

On 5/28/2024 10:03 PM, Paolo Bonzini wrote:
> On 5/23/24 14:18, Ravi Bangoria wrote:
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 489b0183f37d..dcb5eb00a4f5 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -5308,11 +5308,17 @@ static __init int svm_hardware_setup(void)
>>         nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
>>   +    if (lbrv) {
>> +        if (!boot_cpu_has(X86_FEATURE_LBRV))
>> +            lbrv = false;
>> +        else
>> +            pr_info("LBR virtualization supported\n");
>> +    }
>>       /*
>>        * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
>>        * may be modified by svm_adjust_mmio_mask()), as well as nrips.
>>        */
> 
> Since it consumes nrips, just make lbrv non-static:

Sure.

Thanks,
Ravi

