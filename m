Return-Path: <kvm+bounces-34383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3F59FD027
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 05:21:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95E7F18827C5
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 04:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12867C6E6;
	Fri, 27 Dec 2024 04:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eAxQJf3b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6690F191;
	Fri, 27 Dec 2024 04:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735273304; cv=fail; b=IiSgpY0OmTe99d6aRqBFWfIkQv4N92kJwZ6gASfR71dLx5IqhYP+h6MLphVGXeeXT/Px3pkPUh+/huMY7jLlhEa6WbiE4lz4t3QDQW22QX8dRV9n5ZOYGmyCBFe/YsCy7QI/i7Sr0rSTB/JFqSGWMJs7K937+uj9k10N9GRNAzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735273304; c=relaxed/simple;
	bh=NpAUTn1nCKWPht5+HmspyUAbWK2oV4yH4Ih+EEeZV7k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n2YrV741iQ4Q8Xd0HSPRRiDOOGWLAomWciZZRMEIwMlmqqjynliJhXmyMeEbdYmcgXqujVzZLTQi2cZUluCd/pouFmXbRRvao5bCwCpbxPebZ+h0FLsq25lnnD8obyhija9XKXX9ULQvn8Bqrj5be6EVFrFkng3QUnSniDkpLyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eAxQJf3b; arc=fail smtp.client-ip=40.107.243.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtLucCm30pzEnKVDUJtq2vgUwaQBLwufeYYGY78Qxi53yIm+xF/5V4lOeRp7sALQJ5EE1JoGRx5ynTOk58A7hJ+urv5rsDhnq6FcO0nf+1dzSLGWkuqluGkC99ND9/lxNmFo8TGXzIMlXEdHU33Q6VHwbM2T3AwWB4hUYuIsnNWyijYeRWBk96KtE1tCr2lJTaEl8A5bb/jRoE0HskMnpGc1oeN+J/JIrQWZqfnb4LFjukLCi52tyAxAlE1SMfe/BGxcKregD2vQ3a/8p4wg8RGKK5H+CLnoYgIy8P7fYBNrWsl/SQc7Vj/xHYq9Ej25sQlTgjsAcxw5ozXRwNM+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2awKQu7T0hPftlIZ7UcjT8Qd6qI/l7fa3+Vg8EBI3os=;
 b=ACm3QnRBLjmzwYIDcwzWghSHYl5CfTdma+wzvDEqSmnRqABlyvY26cBEyxWCTf8qomfRrS1UvVdiY7WIHsNFB6fSf7HteiCtehDCm5kk6hej2tCyd4J10gKeZ5EQ9mrwF6I4VOihipYqrcxdr0fVpVeaUoAx/c0CHPOAQU5glcTxEWeqCBKANh/F+LTgQNSWkUqOzRJtGD46CQdSK/rU28fRF+BDdXzdxvFIptG2FsTni0Sr56GKLAySlre4ukx4gjCrfzWlW3bKcCv0/Uz4G4ejFVbsvHLnopFMgxt+FMJimgVce67PFB52JOCgEX2C5BAOWybQE6vG9UkFPmPxvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2awKQu7T0hPftlIZ7UcjT8Qd6qI/l7fa3+Vg8EBI3os=;
 b=eAxQJf3bl9g+hfMD+t7/dOqhFXjd2KJZ6oXTB2yqQekAKBk5ZbvJGmUkWy3/rpTMvYVL/QJsCSxw69Cb3yZuW6Avsa4Ax547wgOjNA772HvSV1T8/8TeJT/EHA0MhpDlo4nOIfuVUScpt72iYiW5XeI2BK2sXDQY0yR0UtfLwjw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 04:21:35 +0000
Received: from LV3PR12MB9213.namprd12.prod.outlook.com
 ([fe80::dcd3:4b39:8a3a:869a]) by LV3PR12MB9213.namprd12.prod.outlook.com
 ([fe80::dcd3:4b39:8a3a:869a%5]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 04:21:35 +0000
Message-ID: <37ce8f83-2ef2-4ba3-bcf9-1b93c1502ca6@amd.com>
Date: Fri, 27 Dec 2024 15:21:21 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH v4 07/14] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20241213164811.2006197-1-tabba@google.com>
 <20241213164811.2006197-8-tabba@google.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20241213164811.2006197-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0003.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::20) To LV3PR12MB9213.namprd12.prod.outlook.com
 (2603:10b6:408:1a6::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9213:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: 401e2149-5f9b-4efb-8d8a-08dd262df2d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0wvSVJQOGtaa2prQmVlRjc3QkdGL09yb0NIN08yWUNEZ2o0RkFlNEM1N29a?=
 =?utf-8?B?ZWFmZGl3eDlLckNoa2xSRlVUTExjczlabENZQmJLbXlDN1NxaTZQVXlUd2dH?=
 =?utf-8?B?L3RtNkdMK2dySCs1b0RZSWI5WnQzRUUwMHZDQ3crdFFodnROQXl4V0lLMi9k?=
 =?utf-8?B?WGZkWkVXMDdocTd5Sk5MYUMyVm9MTEpocmE0enJmRm5lQ05nWXIvbm1LRXhE?=
 =?utf-8?B?ZGZPdlZJYjNsTmQxbjdhYTd6cE8rT1dHeTd2RTBJV2gwZGJOTWRCMHIySGtJ?=
 =?utf-8?B?U2VydjN0Q3BZa0hIOW9lanN6SkZEYkJxYnBsTm03N0FhQndBUllqMkNxNUh0?=
 =?utf-8?B?TThsTHZjNzFNcFZ6N2p0MlJUcGdCYml3RldCMk1PQlVUQzA5NHJmejM5aDNL?=
 =?utf-8?B?aUNzeERCQk9sTHlabHZ0QW1FMzlraTBvR1FmS1RCR29zQzhPRHBzVXlaZmoz?=
 =?utf-8?B?SjY1UkwzemZIdGRYL0dnMmI5UWZEcEQ4TUFFcjIxNEd4WElSK3h4NVR5NlhP?=
 =?utf-8?B?ZStkd010NWNUZXBsZTBzYXkvaHVUL0VFVWVIajhoQTdBcmVqbG1uWXM3QTRX?=
 =?utf-8?B?cENMWGdIQlROdm9GM0M0cUIweGV2U0ZzRnY1akU3VnlVZDBCalF0dGJXR0pa?=
 =?utf-8?B?dkRxZlM2THNrVkFvallkdXd3dGFEN2tNaTVWOHVPdE1NVE1JcEFnU245OUcz?=
 =?utf-8?B?RkFDbTlSUGp6RWJjN05HN0RuWFdQOUtJT2dSMUZPNXhjdTBjZm5QYmY5M1JV?=
 =?utf-8?B?RThIMTkyVS9GTzlKaEI0R3V6SlJiZGh0RVBzckdGYUMwRzFDczNTZUgyaml4?=
 =?utf-8?B?MDQ4SmhoUXlITHhNc3RNQUttK0xTRWtEY1F2d0hydWJCZ250cEJ0TEQzWW9M?=
 =?utf-8?B?cG92VDNFOHVnNzNMUU5Ga25KM3pseDBUTGVYcHU5TTdnOGRBNHdIK1FDRTF6?=
 =?utf-8?B?UjBjOXlqQjhtNTBwd1BrOTBaVzVvS3F0cG83S1NmS1JNS2xkN2VyaVJOYlcr?=
 =?utf-8?B?S0lKMGRIeFlNZTZobmF3TDl2VTB3ZzVkQXBFVHcrbzl5a3lNcTROS25TRURr?=
 =?utf-8?B?VHVrdmsxaDYyZXp1ZklUN08weHhGM0VyTVZvV2RONTRpNlhlelFZRm5oQXY4?=
 =?utf-8?B?M3lyZm9PeG4zYUJoeC9LZUhBdEh4ZUJQeDdhY0VoVlFUUStIRkVueGpudFZj?=
 =?utf-8?B?Y0U4djI1L0VNS0lyR0dieHEyOUR0VzdEcU1ISlRDYVZNT0ZwYTRqVlBjTGlm?=
 =?utf-8?B?YS9jQ1J4NlFSWXJJR291ZlpIaGp0U1RTRTJaR1R1S2NCcEd6cXg4SW5KM3M5?=
 =?utf-8?B?RTd2ejBsN0w1bVdwcGl4cHdIREtnV1JkOGV2RVh2azRnTGIrakxyR3grbUM2?=
 =?utf-8?B?RXlObDhSbFI5Mm9FVzlhSUw5MW1ESVRUNk1SVWUrV21nZ21tUzJEY1RTMkV4?=
 =?utf-8?B?T1ArWWx2MURuWUtHQ01xZlpZMXlWbTRqRlc2YjVvNkNSMGRLU2UxcTRYZ0Nz?=
 =?utf-8?B?dFJDQ0JuL3owWmZPeVJRMk1ndnNMeXQ5UzJ3NCsvc0lvWnk2cEFacnczS2Vo?=
 =?utf-8?B?dm4ySHN5aFlCOU9zS1hvWThyNUJ2TCtFby9NVmpRNDQvd2J3aGZBQ0xuZVp3?=
 =?utf-8?B?ZkY0UWpBdzRyYTUweDhEN3NKbCtUSStHN0ZHaHBzdkVHOG0xM0FZVUovTStM?=
 =?utf-8?B?b1RjQ3hJVXZPTWo3cDFMaThnNDVPNzNSNGlNTnhMRy9tQjFBd1hmbWlLUWZM?=
 =?utf-8?B?dmpXeGMvRkdjc2Jmei9EYTNmN0RzdkY1clQvRk53RWkyUllVYmh6MWkyT0dW?=
 =?utf-8?B?SFZVMGdLdDZJUlJvKzhYcXNlOTBCRVhRdC9kRThZc0NOTWhBZTV3aHBtTW5X?=
 =?utf-8?Q?edK5LVzfy37o7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djZUQ3luSWhLeml3a2RiTThkMko3c2x4V0UvR2h0Sk93bDRwMlFEOURraDlG?=
 =?utf-8?B?MmRqMGdnaGcrU3Q0cUJzZm52SjlWcWExcURTaTNydEh6TDhYWlNTSDA3WGpw?=
 =?utf-8?B?UkZBZnh5cmFVcjJOK0Vpb3FxaVJOUmp3YitiNktyTS9xR2cxTktTcTUyQkhm?=
 =?utf-8?B?ZDFTcjNmL3pyVXJ6WjZCOXBDUEZadC95Q0xSTExwOVJ0U1U1ajIxSzFvQkhJ?=
 =?utf-8?B?UUVFWjUxdmphTktQeS95ZlNGTXFwYWtIQ0pHa3REMjZTcW1hek41Mnl1MTFx?=
 =?utf-8?B?YjdpdllCdHAxRzdHc0tkcmh0Y1NVTEkvejYrNTc0Z3FRTnloZlZ4ejZmeXVF?=
 =?utf-8?B?YmplTjY4RG1kOVFZUC8rVys4dGI3bjNhRURaMXFVMWRPNlppeXUxeDZHc1Yx?=
 =?utf-8?B?SlFNR0psOElMUnc0T2pQZVFoNzZnc2tXZVI4dFNaR2dyVGRxeTVGNFZLa0tl?=
 =?utf-8?B?RDJxT3BGZWNsc2dHR0dQZWpzWUd5TlpPVVlWUWFKQmFqQ1QrNU1mTThhM1Bm?=
 =?utf-8?B?Y3RvN2hiTW5zRVNDSHF3bzBUOG5VWi81NEZhOFB2YUFMVjlNUDBwY3FWbUt4?=
 =?utf-8?B?eE94SHdxQ0pVUWtQblFXdnVWWVdBdnJDUTVqTE1YRUN5NUlzSnRwR084OE5i?=
 =?utf-8?B?QkRRaHhxV0JRUXFBbXduNERRYlpSV2FKeUx6WjBFRXRvSlpiVzRYdnJSZGdN?=
 =?utf-8?B?RTBaMGc1dlRyQy8yTEIwcjNJN0t0ck0xR0c1aGRibHl6cUNNRFc3ZDAxQTZy?=
 =?utf-8?B?TWRLNjgvRFJVSlY3bXV5eWxzSk8xRU82RUJTeTlBQzloWmkxNWY2ckYvREl1?=
 =?utf-8?B?TWhrNEVZUWZjdzQvZkJpeTlZTk1xYlEzcXRuT2lVUUdrTnJ5RTRtRkxCd3Uy?=
 =?utf-8?B?cUZBLzR0bXFlM1lkZWVjQTF3UGpXY1V4RnU1Z0Z2dDJlT0F6cktVQjZXSWto?=
 =?utf-8?B?ZGg0MkpFU2lJL0Uxc2VtbFVTNDlEV1VrTXNOdkVSTjF1UE1oZjAyTW9wTHVB?=
 =?utf-8?B?NDBKNGsyRFRxR3hJKzE0VDlJUkdoRVZYZTdXTTdUK2Zicm04eUxTdy9wVndy?=
 =?utf-8?B?ZkFxWUdvMWN4OGkrWnNXcGJKZC9jNHN2bFNQUGNXRnpEREJpUlIzVm9hSlQv?=
 =?utf-8?B?aXZickxvWEt3czFZVUxHVXdMQnYvZWFBaU93SXlUelZoQXBEM0gxMXFtcitH?=
 =?utf-8?B?NTA0c09ZcHBGbzhyQzQxYVpJajc4aXlzRklnRFRYdU9UcTU3RkdnZmV1NExQ?=
 =?utf-8?B?eGZ2STVOWnY1dkZWZUluM3hsbEJsS3FxVUZMWmxHQTAwbEFQaytoYkVScFZP?=
 =?utf-8?B?K2UxV2w1SmdDZHk1eFhDUHE5eXljdXlQRWx4VzNKUzBhUzlUVklGVVB6S1BJ?=
 =?utf-8?B?UllRbE1HNkl4d3NpVTgrMWN6SEh4SFh3Z2xyZVhrOU9pVGd6eTdlcGNsbDRr?=
 =?utf-8?B?b1U3M1EvQjYrRFQzcndyemtJRkZCYmhjM3VKdG9wenFyZXE5c0M1aG03Z29P?=
 =?utf-8?B?M2xXU0lldGo5ME1wN2RaN3ZablZaOG1TZlMwcGhxbFpBWHd4ZkQ2NXVteVJs?=
 =?utf-8?B?OFNsSUt5aS92QzlUQ3h4WjNTYTVSUlgzSkVGM3ZQKzFvNzNTQXBnQys3RmpH?=
 =?utf-8?B?VHdkTGVNQ0pmY2l6bkdsLzZGQ3NzdXNvVzJ4b2hiUFErdWE0Nmx0ZDJCVExp?=
 =?utf-8?B?dFRCcisrR2F3YXVGSXZ5RHFQbUxxd291aXdUZHZaZy9BWDl6STF4TEpxbGNr?=
 =?utf-8?B?M0xXaHlsSUdjMVZNTlpoaEx3V3JKTTJyNGZsR05INWVSNzFGaTdQYjRmb1Vp?=
 =?utf-8?B?dVZBc1lVSC9yS2MvbEREUldyUVdyUi82TDhWMGVDdnJETWlaZ1NwSFM1Y2tI?=
 =?utf-8?B?VWJjeWs3MjJMTXdSdDhYZVBZSW90bmxwNkk2U0RGOTVFZGdZNHM0L0NWc0ds?=
 =?utf-8?B?K2xZM05UdkVkQ3UyUklKYUl2RG9OQ0R1c1BqYzRCSENvWGJxaFdvTEx3VkF0?=
 =?utf-8?B?S002NHdGQVlmL21OaUtOUXo4TFVMQUMzTFhyclZWYzJFK3F1SFVKZ2Z6ZU9W?=
 =?utf-8?B?ejRiL3ZITmlaRllic3k4MG1hYWNmdmkyZGtYa0NrZzFFb05CZEZSM3B1NHVx?=
 =?utf-8?Q?8yZkFUt/eSvveFVNTN46vrkzO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 401e2149-5f9b-4efb-8d8a-08dd262df2d6
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 04:21:34.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHM6Q0H0DVLxbvprjxGh9nVFhgpBHNMOaLhaoBnSGugov1mCiAuAM+KqRoRBltkQKwFfQEFtbRWviI4FQ8k/Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116

On 14/12/24 03:48, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd in the host.
> The ability to fault in a guest page is contingent on that page
> being shared with the host.
> 
> The guest_memfd PRIVATE memory attribute is not used for two
> reasons. First because it reflects the userspace expectation for
> that memory location, and therefore can be toggled by userspace.
> The second is, although each guest_memfd file has a 1:1 binding
> with a KVM instance, the plan is to allow multiple files per
> inode, e.g. to allow intra-host migration to a new KVM instance,
> without destroying guest_memfd.
> 
> The mapping is restricted to only memory explicitly shared with
> the host. KVM checks that the host doesn't have any mappings for
> private memory via the folio's refcount. To avoid races between
> paths that check mappability and paths that check whether the
> host has any mappings (via the refcount), the folio lock is held
> in while either check is being performed.
> 
> This new feature is gated with a new configuration option,
> CONFIG_KVM_GMEM_MAPPABLE.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> ---
> The functions kvm_gmem_is_mapped(), kvm_gmem_set_mappable(), and
> int kvm_gmem_clear_mappable() are not used in this patch series.
> They are intended to be used in future patches [*], which check
> and toggle mapability when the guest shares/unshares pages with
> the host.
> 
> [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v4-pkvm

This one requires access, can you please push it somewhere public? I am 
interested in in-place shared<->private memory conversion and I wonder 
if kvm_gmem_set_mappable() that guy. Thanks,

-- 
Alexey


