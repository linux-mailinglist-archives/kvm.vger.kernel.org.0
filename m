Return-Path: <kvm+bounces-49299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 925B5AD780D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 18:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9482D18987D8
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 16:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9FF29B78C;
	Thu, 12 Jun 2025 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2hG/Ctk4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83D927144B;
	Thu, 12 Jun 2025 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745042; cv=fail; b=Gre01vxqpiZ4UlYlt68rDm7Qs8uRtaCvOmsQnYVDAaKD3QDeTMhVEaiV9ezYTNTe8fLwmH2b9gSmmaykqL0T5AYn8VroEuG0H7qvVdczsFNO2uY3douIMJs99uh9w/i+yAzCliB74OsH8jpMPbnWTjyhFwInhiOSBjukguxFnI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745042; c=relaxed/simple;
	bh=erbDSW1VvZBVxP6XWp+Qyx2yEjjNHwGhoppq7fDRPb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mX20tTO1CqSXrKn0lndD3/nCKdMkyUNiCCNTYcsfysqdrszagCD0Fw7SFEF7hraN4/1xk+Nylz3H2HsvmacVmpDYbFBw5WS3ulqF1fgxKYUr8kwW3D71yCGyI42rnAgjdpTroS31ZiqcJXzyEpKhRrVa7jdcCpTnSEvjT1bMtuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2hG/Ctk4; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=viT+qzjChJIFoQbZXg33zaRSHPo8K6EXRnJlo0rJeLysC6C7oZeY8youkshAKjJrF1C6mXmmF19w/YtC0wwEknLUJHHtOHaCOj2G7sNPDARHCuAuMi+x533N796w7pgRlB9qhGjsWoPIIVYhUM7R9fCUAV/K5CK0rzP20FTP3m65rNbaluH5mkZDG/DYiiyGiVlpe8hCJDD2uV+r8uFdVpC31mR0Nv6bIfTF5k2rMuGH7taFRsXzoxVdPCY8hprBUByIgovBCRdIYJBh/grlymg+idtKJxQOUGupw4JB3ZXOdVBcThk0atQMUVu2wyZoF+znFWH7w1hPOcoseES62Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0pYKW56AftMlQcRCCbwhRsWDw/RQm2c1FYPGhk+MY7o=;
 b=xXssWNbROARIqmT5nH/PmzSYCpEOBP9JLpcyDDvU/xkEXDlstD/odAnGLapRsC3BbSgCPXA2G/Kg6k+AN2HOfQorqHwnblF4GOIa9XnnXmOMlX1R6TcxMRGTsiaJ3IGit4BD3+dkpt/gm7JXZDPIrQalpa7COIL8iMOu1HGghN7jYWyp4CqZFcz2fdlOZyI7OHURsE8x+ARAn46x8wgyK09bRmwVUlTvTOtRvyrmVwjX2PhYO2SZqPiHrF5SxNLl9KUE6dPRB/u8MrX+RbrvtVVNI8YIvctDb3NoZAVKccSaO3zJy5wSDoXNK9OdpBT+rpgtMupgYJUl9QVZ5iS4TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pYKW56AftMlQcRCCbwhRsWDw/RQm2c1FYPGhk+MY7o=;
 b=2hG/Ctk4/jsCzQkUL5kOX0M4D2XVnKTb0r1aYSH8Qw3cLUPVDYxkekszz9tfPGgl4p4Y9NM7NoVqM9zhGCZry7Fvm9lUjWFi0wfbQMQEVfwXa9hjkPAmINKhyz7cTQkBnw79AC5JV9qrhNk5EA1UGBs8q0Aax0a7TZ1RXMtHQE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by SJ0PR12MB6941.namprd12.prod.outlook.com (2603:10b6:a03:448::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Thu, 12 Jun
 2025 16:17:16 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:17:16 +0000
Message-ID: <85df068e-9db0-4d93-9a63-e59575f1baac@amd.com>
Date: Thu, 12 Jun 2025 21:46:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250611133330.1514028-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0094.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2af::7) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|SJ0PR12MB6941:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a65e47c-0453-4db3-74f8-08dda9cc989a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NS9rN1dzdHRTclNHc2lNeXNyU2hLc3JUVkRTYUZzK2xkaVp6OWlWNTIwNUFH?=
 =?utf-8?B?TFgySWRzN1k3RjNFcTM4alZvcktuQldKeENJTzM4bDIvNWdvZFdlOWJCMm5y?=
 =?utf-8?B?c1lJcy9xUDNhRFZDWXkvenJtZG1vTWlPdWJ3QnhETnFicTZMc0RzU29xVmF4?=
 =?utf-8?B?eFdEa2RzOWFQanpkRXozcnpuTkVNNE5XdDY4emsyanBNeFVHSVBoWTlvMzJC?=
 =?utf-8?B?TzYyVlFMa3RhaVRjMm5nckxZdnRzYVNPQWZwU1hpSXJZRFE3THI0NjZGeWFN?=
 =?utf-8?B?UlAzMlFEcTZXOHpQdE0rSHVJMnZKTnc5cjVnanE4b2FDUjFCV29aVU51TjFE?=
 =?utf-8?B?c2lVZE9ydWJXN1o4T3dnYUh0ZzltZStIY2g4eE9EK2J0VWtoL2FlV2VQRzFo?=
 =?utf-8?B?ZXpEMUpVVVd1REorSHpCRnpNeVoxU1ZIc3R3c2ZXWUxUamNjUXR2WWJpSGRy?=
 =?utf-8?B?WGU1Z2hzUVN4R2tGUnpNL3NZbXNXRy8rbW9TRGJjbkdwMnVnUWR0NngwUmxr?=
 =?utf-8?B?Z3VLVG5RMEpOQ0k1U0VmV0FqUktPTUczL2pzMnZlWTIxVnJyNDMyNE5Ydm5s?=
 =?utf-8?B?RXY4aWdJZVRoN3d1RnoxQzFBM0hlRkVEZkJWM1lSb2dsWjVQZ0NrUkRFdlJO?=
 =?utf-8?B?eTlXNGljZitDb3ZNcnhqREhRV0xORUV6QlpNcGR0RVl1bEQ1MUJ5NUplS29O?=
 =?utf-8?B?WEs4YlFXUkZhM1RDSGpXaHprd2JhbFVjNmxZQ2g5NldWbnZoK09mWDdQeW5O?=
 =?utf-8?B?bTB0YlkwMGVQU2ZVUHltL1ZZWVVGb0x2ZVlHVnRDM2lBNEpFbW1Fbm44V2Fu?=
 =?utf-8?B?S1dwN2hheFlET2FhNlNqd2FXNDhlSGNuNFkwN1dqL0doSEN0OUR5TDFFWDc5?=
 =?utf-8?B?VUZPMFJNbG0vb0dxNkZ5Vllqc0tBb3ZVSzdpNzg1V004bjNseThoYjJhZUxP?=
 =?utf-8?B?d1JYTDJnQmkrOWYvVGx5ZmNXeitlZTBXZkNNNXhMT2xjMkhRNDRTUFE5VE1I?=
 =?utf-8?B?dGsxREROYmdia0h3c2w5eW9JMWZRQThNZ1dud2F6VnpudXNKazhXV3A0UldO?=
 =?utf-8?B?ZHlnWXNiQUFkb3ZqY0w1NVFmRUVoaVZhWlZxREJteVZFd29xQTFvYmJpa0ZU?=
 =?utf-8?B?S3NZMUxETG1saFhSZ1NsWFd6Y1RhSlE5dnU0RlVTQUE2UHo5azdEV2llU3lT?=
 =?utf-8?B?QVY1WWF0OHB5K21reU9ZZkZjYmZySFNieEdsc0h4cUZ2MkRDTDQ4aFRGeXht?=
 =?utf-8?B?NjB4SHNjVGh4NzVTMysyeHY1b2xIU3VxeVhvN09RbVFueVZsbE9jKzQ1cTd6?=
 =?utf-8?B?L0V0V09mWVZZdm9QOXMyWk9TUlR0cDgvc0Zyd1h3T2ZKcndUOXZUaTBobWp1?=
 =?utf-8?B?TU1BR1FQSTVLUHZ4a29zTG9DdmpPeG5CTlBla2Y5RFlDZEYwdGdzMGszbnhM?=
 =?utf-8?B?enhwQWVyekkycjVNTFFxYjJEVHRIYzd4cmFpa0JZUGM1WkU2dGtYV25EaEJx?=
 =?utf-8?B?ZnB3M3d1NFpFaUN3NVNNdnRwY0FjQ3d0OGR6ZFhOQ2NPTDlySEg5U0grSG9D?=
 =?utf-8?B?NXdxNHM5QlJqZkxjdnA5R2NLYUZLanZYVmcvRXdjYUlBWTB4c0loaVZRVjZt?=
 =?utf-8?B?L1cxODhPdEtNZkh2WXZaYUt0VUUxclJtOS9FU3E2ajl3SnFCVkFHKzdpT1dm?=
 =?utf-8?B?Q1VuV0pQOWFGMEx3NUM0UkIyeTNuSmFKa3V6aXRGamwwMHZ3QTZZZTVCM0hm?=
 =?utf-8?B?SWd2SVRGRGVncGZ0RkJ0cUtPV053YmpVTXlzQ2MyMHpkbk81OUJnbTVJMWNO?=
 =?utf-8?B?bWhKUC9RR0kvYTRkdDBoVDc1anhFRXNOZmVTVWlWeGRhOVdWejFyeFMvWUFE?=
 =?utf-8?B?cVEvVFNNdnUxc1pYMnQ5NExmQVlQKy9xZ281aXpLL1lSQXpaZ1ZKNlBleDYx?=
 =?utf-8?Q?Fn0ZD23MHnw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHFCbjZac05VU3hYUmVEblhHV2xLcDVrL2hPYVNDc08xSFNGeWtFZ2JsY01J?=
 =?utf-8?B?ZWxjL0twbm0zVjFnY1lONFJ5K3ZEKzlCUkljTy83djhlNGNXSkptczJGU3Vo?=
 =?utf-8?B?RmpXYjRnRzV5Y3Nodi83a080RmovQVVpM2pBaDYwRHliTDNoY1hTVnBxSUJZ?=
 =?utf-8?B?aGdacHZxMEFWd2VGN3FVUFZPYUJHdnIwWExiNTlvdkg2MTN6alhJeDdMcU1r?=
 =?utf-8?B?UkNZd2UrVFZSWjBtVUZXamhBbTRFd3huTWN6L0c3M3ovd2ZaTUZaNHpLbE05?=
 =?utf-8?B?c2h1WDJqMVZjNG5wcURzVjNVNEkwWngwSjhUa1pWc3N0N09BVG9NUFQvMmpo?=
 =?utf-8?B?YnY1Mko0c1FXQXR1eDVPZWQwbnNFTHJOaEtmTTBBODk5M2hJZGdEc2NMRG1s?=
 =?utf-8?B?YjJkdWJXK1FKUEhvTzdHM1dxK0lSMzVlNjdheUU2MmdJRk94QWJjOXpOUVdo?=
 =?utf-8?B?S1lHSEVuWEV6Yll4MDJ3Q21INlE2K3cxeUpZRDZ0NkNCemViTlY3TXFJRlQx?=
 =?utf-8?B?dWt3TGE1c2p4NUlyQjMzRDVHa3lmMDJkMUFwbHZtdzZkV1FJTXlLMUdDMmZP?=
 =?utf-8?B?OUFwWjZNZXREL0RCU1N2TERHQzZWOHQwdENxNWJ2eFdkejMyVWVGQW5ZR3Vs?=
 =?utf-8?B?LzZtcVRzMWw5L0N2emJPUG1YUnQvK3dDSWF4WThvdllHaVBCWVMxT1Bnczlj?=
 =?utf-8?B?YXE2blVlRFhhNU1mamdaU1praHl6QWtVOE5LaFNxWTJUZW9hb0ZOUHdOcFF3?=
 =?utf-8?B?R2ZaT0ZGY3JwR2tGRHkxbHNFUCtveFA1a2V4S3RzQlovZjZyMVhTdHZyY081?=
 =?utf-8?B?QUdYWFB4LzFuSkFoKzRnTXVhS29kTEZzMndjSjJJd3Bmc0tFMVZJOTA5WjVz?=
 =?utf-8?B?eXNPaFhIbmdXNGxwaXBjcDN0STlMa3JkdGYyMjkycFV5MFhLcWN3U0dxeUNp?=
 =?utf-8?B?NmpzZEo4VWdINUpqUURjKzFERm5ocFZnMW4vN3lOTmtXanRMdU9RelZnRE1X?=
 =?utf-8?B?WmN2aHFJVlVZb1BmNnZKbW5UVFlHVXhHNWpoS3FDTndNTzdsWUNDd0JTa2FE?=
 =?utf-8?B?ZzBzZlRJS1F4eDI0Y3p4czJvMkhKcEdWS3N3ZitudTlMQmF1NENwRldPSUta?=
 =?utf-8?B?d3ljaDI5TEozWHd1L0d4ZWd1MFJscTRTV0ZFZ1VpNXR2YlNRZWZUazY4ZzY2?=
 =?utf-8?B?bFowK20wZkJFQU5QUTFwUzlBZm8vc1dOZ0Z5dUFiMk5VVjB2c1BjRCtoT0d5?=
 =?utf-8?B?SVdzK3h4MFAzeldZdUZER3lLK1dRZjdNZ2FiTUJNbXBxUDB1STNSVjNIM3dj?=
 =?utf-8?B?Q3RzQ2xaWTFURi9hSy9ZQlE4R3hlcDRjNGlZdXk3UGJpYUtvbGJya2ZlMWc4?=
 =?utf-8?B?OExPZ2FhTXpkeFN2NmhTZUtQdEljQi9EV2JRc1l2Tks1WFpWbVVoSE1IYytN?=
 =?utf-8?B?cEN6azQ5aTI0RjlDd0lQZlhIL3JTdGdEeWVHNG9lMnUxMlVaTTl5NWt3STlT?=
 =?utf-8?B?UEhhNGNNd0dYeXRJR2ZuVkQrMGlGeXVsaVpIMmNIWXd3bG90TGgzYXBvK01O?=
 =?utf-8?B?WXdyQmVib2hFNzFBK1p3RDVRV3h4MjlEODNKMWtHckd1Q1RMalAvSE5aT3ln?=
 =?utf-8?B?c01NRDZNRkY4Zm5ua0JpZUFMUGkyZzUrZXVTZXBraTl4T3J6RHp5ZTBGeDBE?=
 =?utf-8?B?WHZtTTBRRXovaWZYZlVFaUovTjI2SlAzQXdGWWdCaGV3bUVGK3FYQkxReE5l?=
 =?utf-8?B?SG13UlFzMHIvWk9tS0pOMXd5Uytpai9mU3dIN2RtaVlCYnVTUThTVUtJT2Q0?=
 =?utf-8?B?cWxLTlFRTmV5T1lVNUIvQkhDVFhSMVNjRFZnR0VSdStBZ0lycUZzYkNFS0VM?=
 =?utf-8?B?NDdPODdEaTNzdlYvRDdwU2dnOWpRSWlNZUkzbUlyK2tXL3RuTTFxcCtCR0hI?=
 =?utf-8?B?eWlXb2dPU2JGdEIyVGVrdlVSamR4WUtPOThSOXNvbWQwUGZINDVZZXJFSmV1?=
 =?utf-8?B?M0hvYUE2c0dScnAxblZ6T1lsWExqODBoRUp2eHpPamlUSTViaHJ0YlpTNVNw?=
 =?utf-8?B?bEpKTWdkS1pWcU0wZWNqcGdROTBGRFd4RlBjWXppejMxQUlHeTdPaUlGclNo?=
 =?utf-8?Q?4kMxFcbA0gN9XhpQu1tsJX9U8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a65e47c-0453-4db3-74f8-08dda9cc989a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:17:16.2504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eqdrY8hXb0WkcWup3Y/wfdt3nVA6VNzBqFBply//LPzXN8rTlqxOcEUmZxAnml4Rdv3V2PgCEDw7RshSh53Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6941



On 6/11/2025 7:03 PM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory from host userspace.
> 
> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> flag at creation time.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 13 +++++++
>  include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig         |  4 +++
>  virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 91 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9a6712151a74..6b63556ca150 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Returns true if this VM supports shared mem in guest_memfd.
> + *
> + * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
> + * guest_memfd is enabled.
> + */
> +#if !defined(kvm_arch_supports_gmem_shared_mem)
> +static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d00b85cb168c..cb19150fd595 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
>  
>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..e90884f74404 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_GMEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..06616b6b493b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	const u64 flags = (u64)inode->i_private;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> +		return false;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_shared(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	u64 flags = args->flags;
>  	u64 valid_flags = 0;
>  
> +	if (kvm_arch_supports_gmem_shared_mem(kvm))
> +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  

LGTM!

Reviewed-by: Shivank Garg <shivankg@amd.com>

Thanks,
Shivank

