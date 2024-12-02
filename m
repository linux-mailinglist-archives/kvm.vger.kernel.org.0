Return-Path: <kvm+bounces-32846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 679519E0BF3
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADDDAB2B935
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899A1DE3AD;
	Mon,  2 Dec 2024 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U78pBnX9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECEC16ABC6;
	Mon,  2 Dec 2024 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733165696; cv=fail; b=KiTjP5wF1iApMuQboS0RXyO3Oe2FUAK08Em3mwZzNkJrt8dbOt7ys+AVFRaz0kuPSCK7nusr/A2rJr7uvCiVvBCD8OmSp3+M0ON37fqlhogOx/1cqNuKzNprwCTtsb00QC3tVE01eDiq/sN1hO/0Cro22oq4ljHLMoAEF/UIyjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733165696; c=relaxed/simple;
	bh=kjuxpzsbyDNHkK1Ssie3uyz2OzU5Tozccf4QlnoC3u8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tuWPKxKooDaFxXwoGLJVlHpTHGJkJK/aD4XZlgIK2snkCaKL5jD4vTM2CJ6GLKU8BFKthKbf1xV+5eWa7o+c6T6+/RBWl2HrDhXnD18sziNXnWsTYYDfKhAed171dAG6NKqWu0m/8g5At6hPEoySuei9Z2d6AZ28AjslDLkwR8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U78pBnX9; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MoCuG51DfiSYiFcFaIgdeminaq1WUTKrvcn/nDF6ZAU0b28LQC3oG5D81EEHAtJPTx+Df/QhhH80/kGNSA2obzktqbXbW8L3+NCZwuHbxJW3vv+NFxnrw38wmTev+AWq8TGNsvXdkC5JT5xgGJatgKQ13KhAVpNmuVxx+KhjU6fhtdwdDy7r9ux/pR9ClqpfrY6Bc7Nsp70v1rCSQhFnJ6bkG0FmumRaKxHHw5yk85EZ7x38b+lpDe8TnAehH60Yy7dIxA53YYf+akMpHfv0hi8qqCVPjplnsVON72aCgdJzein+/iRPmNEi3A7J5bk99RswXRkujUwODNcLjT5faQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSQedjpdQkEuWg0VqPw+ZflWREgEJW/zUyV5buebdio=;
 b=GJkK8kNvuOueTj9fhYp+XG7oRFte+/RH/WoXLvMXYckcsvlAJto5oikbdA+mLz2nvvXW3aa45mmU+Ae35aOT+SXfiXpKQCMNoCPAV51g+wIUURRDB/Wp+JfAdoD9BYfe/vx+ntT5ncM3opQDxDDEJ5Az5IT3dWFHBhE1aM1hiS2MfJ3LA+Hq5n24rHg5Y8HxXqPviI0ahsJPiEwV0lITyTm21SqoTwvV9j2hHCkX7qjvvjReYUQtHPAfF/PQhOUgWjber4TcUAgM1j/Ql4MiXLtuL3lWZsiscbSz8MGvhtgaiP/5Mxi6C7od2gFlOeH4K20Z8BKrAj1hkFnjhh3eUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSQedjpdQkEuWg0VqPw+ZflWREgEJW/zUyV5buebdio=;
 b=U78pBnX9Mw8CNeUfJweoV9QTEYikbdogJnLa0Ctch93Q4r/3obJObYS2tfYUuASVmkz0AP0d0LVlR4F01QprgySaGsRPYSSvxduhpPFkRM2we0vgWm+Uch6rSwdaaSuwG1DAlOy1OfUwrpcR//CgduGfRJM8SNCdVwfeXBW2JNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.13; Mon, 2 Dec 2024 18:54:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 18:54:52 +0000
Message-ID: <f9a50f24-d023-6361-607f-b7dc71590366@amd.com>
Date: Mon, 2 Dec 2024 12:54:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/6] KVM: x86: Play nice with protected guests in
 complete_hypercall_exit()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-2-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241128004344.4072099-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0093.namprd12.prod.outlook.com
 (2603:10b6:802:21::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f90f4fa-5cbd-4fca-f3a6-08dd1302cd83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1dvem02UFBVRW9YUDJmUm9rOEFqazB4Tko4M2RvamhNVXd1cE9pU25BamFv?=
 =?utf-8?B?cWZnM00rZUcyeVZ1aGZwQnRIUWd5YW51SWdXeml4YWJ4cTRPY0g2TStrMEFP?=
 =?utf-8?B?UE5WV01NckxQS3pUNHBLVTBxeE5OSFRIRnB4TDM1Z0VRMjR2UXplVCtiRUJ5?=
 =?utf-8?B?UktkenJnQ3ZTK2Z3YlIraXJlOHNlRUhWc05UUFZZM0R2Wks5VmQ4RXZyWHZV?=
 =?utf-8?B?SnkyMDhqcC8xUnVxbzQ5VGdxVy9qSGV2TWw0ZGxaMjdnem9RcW5XUFJuWGJZ?=
 =?utf-8?B?MG8zMHh4Wk81KzB0dzdvc2pydGdGTHJzdkZvc1V2MW1RWVpxSW16OEdEQ0tQ?=
 =?utf-8?B?VkYvMGNLR3hqS2t2cXljWTJhZ0dzeHkwY2g4K2grcjFWN3pDaXM3dmNjbWRa?=
 =?utf-8?B?VzNIcFpKVVJ2VndzeEltNzFJdTROR2pUaWhNMEN6TUhmYlltdzJVSTNtcjQx?=
 =?utf-8?B?ZGVDNjJBTWxTZHlMVXJkSzlXVGZPcUJXRERtMk9JYzZOZEd0SEhlRVBMLzYv?=
 =?utf-8?B?Qy9US2tnVHdUbzlTb2JiZ292WFZDZGNJUDdGaEV1SVloeGlQWlNiUUhyRHFF?=
 =?utf-8?B?L0RocjUyR25ibnFCKzRpVmVoSDBMSnREQ2JBRnZpeGtka0tOSUNFczNIMTBi?=
 =?utf-8?B?YjRZT2o3OXB3Rk5mLyt5TWtoVG0rZFBsUktubTJOaDNkY0FsM3gxMkQ1cG4r?=
 =?utf-8?B?akJYK09JSDBzZjNQN3Q0UnppcVBWRmthYk04UnpueUllSDR2UDdLNHNPRjRa?=
 =?utf-8?B?MURhaVpkY3RGY0JBdmk3NUJBWkFSQnNENENMK3Q5ZVA0WWRUSHVxOWhhZUc2?=
 =?utf-8?B?Z0JycE9vNEQ2eENaMGFuc1k2MFJBVWc5YzM1WFFjQlhBU2Q0ejhRNndwOG8x?=
 =?utf-8?B?aE42Uzk2c2RPbWpaSVBiWnJMZU93aGlidDFZRW5Pc0hUdkhCRFJjRjNjWmdL?=
 =?utf-8?B?Y2FkUEhCMklWNkMrNVZFQnk0UWFjcXJ4UXQwcW8rKzB3OElZRUcvTUZ0b2Vr?=
 =?utf-8?B?WGdDUWpNNjlJSDhiV2FYQ202Qm1xelJtenpGQ2ZkRDdyQU9nNzZvQ1BENFp2?=
 =?utf-8?B?aWNNbkZ2N0tMVXNaazF2WWc1VWxwOEhYcW9rVkpRTkFOVkRXRnV5ejhrTVdh?=
 =?utf-8?B?cWZyVHAyZGFTM0lMMVZERVNOVVJxVFJ6L3Y3UzZYOXRDNDQvUEp3S0Z6cFl4?=
 =?utf-8?B?Y0JCaUtEVWx1dGlodC91ek5SQ1ZBWXU2ZTk1UDBkU0ppcnNZRmk3bUJZQXE1?=
 =?utf-8?B?bHIvWUp4L0p5T20rTjMvTVVUd1c5Tno1eDNKY3VOTjdYenZWVjZueGJJN2or?=
 =?utf-8?B?WFF5Rkl4aC9tYWJ4U2JKbVpOekQybGE3czBEK1FwYlhPS1dsbU1ncHo1dTBM?=
 =?utf-8?B?dmdrRzJBeTRZYW1DSXlTQUYvTURBVVZ0S2UvcmMwODRqR1NqekFydWgwUmU4?=
 =?utf-8?B?UmxPSEgrQkpTdWJGcG5hVXZXa096cmRPT0FkSTMyNWF3bkdDdHliWmI2a3Yz?=
 =?utf-8?B?Uk5xTDU3ZWxmZktZdEt5dUEyT3FkY1JHV1RBOS9zRWlOV3RGaGROUkhsTVJS?=
 =?utf-8?B?U0VONzhkREQyaHc0YWZqbkhDa2Z2Z0xmQVdSVHFLK1ArWDdHKzdWSkRzNHAv?=
 =?utf-8?B?RVlkNkJsbHVqdmtTM0kveEFLM2tFa0Yzb2JDWHhleVAvNS83Ym1KejB2dDAz?=
 =?utf-8?B?RWprVU5PQVhQekgrWnFORXRuMDNUdkdSWUFvRHphcnhoc2VQalRkZGwxdzlo?=
 =?utf-8?B?NlBEOTRyTlJUblNMbGd1bnJBWE1KMDlKN3c3MEpqUzRnL0FmVnhEdVNYMWdK?=
 =?utf-8?B?TmJnYThxdUFiZC9LY2hCdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkRTRmdsV1NTLzdWU3l5OE5zOWNOdnJXMmNYWTYxdEdiWHJSdEgzajZlMWJQ?=
 =?utf-8?B?OW9wdmRlV3NhcEZKUi9OZkh4WXM5aUQwcjV1SWw4VFEwWkVtcVhzanNJQ3du?=
 =?utf-8?B?UGhyOGlZbXF1cEZldWE0NHk4eVFyL1hlOEFrNUY2aEVjQnJCZjh3K1BZUUhD?=
 =?utf-8?B?LzFMdEdoM3lTL2J0STY3dnJTVlZqWmQ3Y3ZHZHhtallQL3FIUVlwZVAwWEhK?=
 =?utf-8?B?TkRNQU95M2RpUGRuZ0M4NHJpd1RBUjBLZ240WUlCWXZKM1I1VjRpOURyUlpw?=
 =?utf-8?B?bklNd1VhRzRSZTl5WEtlMlVDUmthMW1qOWpFOGF2L2ZOVjNJSzJMbkFpMHh6?=
 =?utf-8?B?a0tsMkZBZ0lUeVB1czRpcjNCZ05MVDRlSlQrdk5YeXZpNWIzWEVSOHhvaGxC?=
 =?utf-8?B?YXFLdUZHWlRaTFFjVEhBWGx5NjllMnZRMlg1b2tyWENZSmNsNldvM0xVY1l6?=
 =?utf-8?B?M0laTFludnp2b2hkNjNHVEd0M01ORXBWK2VYVHVpMmE5N1Zha3o2U0Uxd3JC?=
 =?utf-8?B?YmlleW82TVYrUXFmWStLRE5RNkU5TGh4QmxvL0FlUmJjb1VidFNzZnFaRnZu?=
 =?utf-8?B?RnFzeE9RYTVySnhyMWIxQk0rQUhoNzQ4TDBLT0tZb2FiSStGbEIzMXVZc3p4?=
 =?utf-8?B?SGdlRkRDUjZBYS9rRjBBQXZjWnlNRWI0d0tJWjVVZ2J1amd4WGNGakp6c29C?=
 =?utf-8?B?dER1SngwckFDeSs2VzMydlN5ZXBBKzNraHVXNDkvWktKemkyY1VheGtNOUJ6?=
 =?utf-8?B?SWt1SGRaSVNkYWl3UVM1U1dNUTdYcU84YmovVlFFa2dOaGtmVXY0bjRqY3NG?=
 =?utf-8?B?UVp1eVlBdTVyOTJySDVyUURvUlhBamUxVW5HRmt6Nlh5ajhxcGJSZ0pHQ2hM?=
 =?utf-8?B?TEl6SUhhOGlUTXQyZEZoNHpwazVJVTM1VHNHVk8wQ0VDYjdOL1E2aU1NUHBN?=
 =?utf-8?B?VmcyREtVYjNuUEVmY3p2RXBBWnNaVmt1TWtTMUR5enU3U2F2aTNXcmpjYW5K?=
 =?utf-8?B?dkhqTCtDSEkwZ0dGVEpTYU9rSXdqZkdFbDlnLy9vL05YUGRIRGJHa1dLT0tq?=
 =?utf-8?B?OVlQamk5aW15SGc2M3E4Z0Y4SVVqb1Q4M0ZDdjIxNitWUUUxOU1PcDdKdm1k?=
 =?utf-8?B?UWxUZGV3UVRYUFpKWnBjdm5iLzZXQTJjRHFWOGVLQS93cTNhWXQ5c0hFeUIv?=
 =?utf-8?B?NnJJbjBxTVFUL3ZnNDd3eFNza2laNXExWnBUQ1pBSEVmL0p4M2ZCbyt2dTFi?=
 =?utf-8?B?MVRJNkVLZS92Y2RmTThDVlVxSC9WWHh5UVlIZTNsSXE5NnNlaDVBS3gwK2VM?=
 =?utf-8?B?N1hCUzI3dmJCU3ptSk1wc2hmNEpzSnFoajNiSmNpOEJPVWg5eTdOUTVsQjg2?=
 =?utf-8?B?YWZNZkVONk5uNzNpM1ZkZy9KZ2lkZ2ZUS0p3OFF4K3NMRThMY1g2UDlDaGxk?=
 =?utf-8?B?dWxRTUFpbm5Kd3M5RDFjTzBzMkZMaUxuTTZKQ1hHUzNIT0w3d1VTbnhtSkdM?=
 =?utf-8?B?ZHVCQWE5TFR1dE9VOFNKb1hyTUQ2QW9aWjNQM0EvMGVUaGxmb0RWU1ZjSGk2?=
 =?utf-8?B?OEtoUHoyT1d0ZTBxTHptaXdoRkVOc2Q5Q20rQkJmUExEeDZ4MFJvRzVTVDRo?=
 =?utf-8?B?WGozdHhrRkpDOTJRRE5Ca3ZBclVoNEFRamhTUmM5akN4QTYxOVhyYzhxWUVm?=
 =?utf-8?B?czR6MmhGY2crYk1HK2FYOXgvMTdUbVIvRWNxaUxCYlNLT1ZrNG4ySWI0NzND?=
 =?utf-8?B?QXF1QzlMcGRBbVhvSkp2M3ViOVh4bXBaZUV5OFZjZXlqaVlONU5uQWNuZVFl?=
 =?utf-8?B?ZzM0V2w0elFGSXlLRFVaNXlnQVpMOWFDdVdtaGU3ZGprOFhJTnBGWlAvei9M?=
 =?utf-8?B?cVgveWlKenNKeitEZFFBdERYb2FVWFNhT2I4b2xQeHZtL0JpZ3hUaEdmRHJG?=
 =?utf-8?B?WmNVU0xHaUdyYW50NGpiK0VWSFJOdHRPdDdBYmU5elI2L0dqYWljRGhnRjV5?=
 =?utf-8?B?Rk96c0JFQys0bDNiK3VYVUs1RjVDOGZ5SVc3Ym9WWXhwcUowNXJNaHVpQ2tw?=
 =?utf-8?B?bmNOWS82bWlXQ3RCQWpkMjZaZ3BOMXVPYzBVdUpxOFVXcGhBMkRhNVNEK2sy?=
 =?utf-8?Q?sp6UJbwfVw8T/B8GGwz4d9XPI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f90f4fa-5cbd-4fca-f3a6-08dd1302cd83
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 18:54:52.0026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYcunOHpo00iLkHjmI8hSdGtuf46BfUJ8bRm+T+Wi7+CmsnVasdgEI2rkQXQ390oATaE6JgEtONP+4Z/NK7Iew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048

On 11/27/24 18:43, Sean Christopherson wrote:
> Use is_64_bit_hypercall() instead of is_64_bit_mode() to detect a 64-bit
> hypercall when completing said hypercall.  For guests with protected state,
> e.g. SEV-ES and SEV-SNP, KVM must assume the hypercall was made in 64-bit
> mode as the vCPU state needed to detect 64-bit mode is unavailable.
> 
> Hacking the sev_smoke_test selftest to generate a KVM_HC_MAP_GPA_RANGE
> hypercall via VMGEXIT trips the WARN:
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 273 PID: 326626 at arch/x86/kvm/x86.h:180 complete_hypercall_exit+0x44/0xe0 [kvm]
>   Modules linked in: kvm_amd kvm ... [last unloaded: kvm]
>   CPU: 273 UID: 0 PID: 326626 Comm: sev_smoke_test Not tainted 6.12.0-smp--392e932fa0f3-feat #470
>   Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
>   RIP: 0010:complete_hypercall_exit+0x44/0xe0 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_arch_vcpu_ioctl_run+0x2400/0x2720 [kvm]
>    kvm_vcpu_ioctl+0x54f/0x630 [kvm]
>    __se_sys_ioctl+0x6b/0xc0
>    do_syscall_64+0x83/0x160
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> Fixes: b5aead0064f3 ("KVM: x86: Assume a 64-bit hypercall for guests with protected state")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e713480933a..0b2fe4aa04a2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9976,7 +9976,7 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  {
>  	u64 ret = vcpu->run->hypercall.ret;
>  
> -	if (!is_64_bit_mode(vcpu))
> +	if (!is_64_bit_hypercall(vcpu))
>  		ret = (u32)ret;
>  	kvm_rax_write(vcpu, ret);
>  	++vcpu->stat.hypercalls;

