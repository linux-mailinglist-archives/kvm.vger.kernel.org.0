Return-Path: <kvm+bounces-51112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 628D0AEE779
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 21:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A492517CC87
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 19:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24E22E62AF;
	Mon, 30 Jun 2025 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F9VYHfg1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F41C8631;
	Mon, 30 Jun 2025 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751311626; cv=fail; b=uc8h8ljddqsXBr91s93UTJK6s9CvEOqOV0ni+GmSpnBpuzmMytB4pPAZm7t3ioERQWVwa/rXFAObx7cJu3KtVi3cyi3vD678a4OnXP5aJ9tuBn5dteDdw3Su+I/X4dFx1SvZMO2zf+iOlms32eocv9YUVd8rrPEPsrYjBg29PXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751311626; c=relaxed/simple;
	bh=4oYZJDK9hFAmLfvY9hXz77kVHCui+1rFqGdgKKfU3sI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ui3dw7KMCOvnFWsK2n4RMUJrEQMT9NBa93A+I2bhZzEvp2pL+0G30iq2tpOo7A3iqpmmrfEZPkkUTQIQcaZ6a8JZx/eaA3+WITAP20AQSRfh59ljAZ/52C4WAGZzCW3GyaiGXTWdaYuq6BGTRuWqnDFLY6XBr/oquR7OueXIX5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F9VYHfg1; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yN8CMjXe2gEH2lcgNvf3qNaZ7LVmJ1+13ZyTkQU53sOi81twcda71xzf7SmOFnQL6CG4y9EOxMCSERScY/fymf1gG0UFNegH9K4DcCl+Mq9AqgnqUksWUPSLDtUCqC1GqMEgt9OV0qDsuHelBk05s/jCWhpQ6w9Kyd2gN+AbbRvz2g+U7Wtfr297MSy9KlHPTQVsp7HsvK/9VRrmSv6D45sKZt0FEkxKuprZ42Kwk5RJOLzvnf3Hssv3oZbkOdYcai/vYzvYPYCV8AQwr4vwbLuYhr1vx9KIMmhRvbQkDdQ2ygvSsIGqtJ40tEOi0c3tNCpoXyvd1wkymgzppRb/dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAZ0dJRMqqcqTPqYuJsflReq9wZXAFWC6gBXfExRejs=;
 b=bErApiKxHy/R7HBRe3cK7EPfWdHwpyBDSha+cDwH40EOmO5u0VRN1vbfutSKnUWvdEwWHTRDfxx2TqLiTimylEGTI8iZizI3/LaqPDy1Qn9AGhsnHjk1Dql/C4DRQxhbU6ClILrvChxvtMVN5jC1FmsMN/XkNP3bsNZwN8gMUOl8wMNQ8uwnyHOmO+qb97bof7ZN/9FztiMif0NS/rJOM/SrWDsdtJs1v7d+RpAxQtghK4LKw1kUWS85dXpaa6EFVfNlzJ4eD0N970rdYpEYN79RZsluwHIdZuLPD3/shpfxFSym28Y3rJQPB1cnDd44g3khrRPVfVsDJyXiEmHWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAZ0dJRMqqcqTPqYuJsflReq9wZXAFWC6gBXfExRejs=;
 b=F9VYHfg1TwfTfIlQ7kO8ALAWvqtE9i3cOAzZgOtE/Vqq7RaFT/5HJGWQMTxHiNZVaTRN983Fb+BeaGyNUZsXOraBWhfXJt+WHeQOK3ArtdhYm0sAcOqSJ8f2LsNDdDtjA5QxMy7SzJb7yjYENJ2wD91TaVVDA8u5DigU78de9mI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPFDC28CEE69.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::be8) by CY3PR12MB9554.namprd12.prod.outlook.com
 (2603:10b6:930:109::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Mon, 30 Jun
 2025 19:27:02 +0000
Received: from IA0PPFDC28CEE69.namprd12.prod.outlook.com
 ([fe80::7945:d828:51e7:6a0f]) by IA0PPFDC28CEE69.namprd12.prod.outlook.com
 ([fe80::7945:d828:51e7:6a0f%4]) with mapi id 15.20.8835.025; Mon, 30 Jun 2025
 19:27:01 +0000
Message-ID: <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com>
Date: Tue, 1 Jul 2025 00:56:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
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
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-11-tabba@google.com> <aEyhHgwQXW4zbx-k@google.com>
 <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
 <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1P287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::33) To IA0PPFDC28CEE69.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::be8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPFDC28CEE69:EE_|CY3PR12MB9554:EE_
X-MS-Office365-Filtering-Correlation-Id: 2396bb5e-b372-4d6d-b310-08ddb80c161a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmNvUlNFdm5qV29kUENwMEUxd21Bb2xtd0d3TXR5RkVwcEpENTcvQUlnZXNh?=
 =?utf-8?B?NkJTNFlaTHdBQXNzd3E4Z1VaUVBqNDN4OW45RVJ1aGZobENsckc3U3Nxc3RK?=
 =?utf-8?B?bEh0U2tVdGpYK2VJM3pNMUJvM2FRYXNMa045NnY1TEljWU9GMFJTZWRWNXNm?=
 =?utf-8?B?MGZSUTlZVGdndlo0blptMHh6U0hJbDM0b09tRnBGUi9Ddng1M1V1cVBuNDVK?=
 =?utf-8?B?QWhBcGhIeE9nMmtHTW5zSXdvL1ZnRjNVWEVEWUpBNnRTYmREWVpIU21CenFK?=
 =?utf-8?B?WldyQ3FjUjRkaHJwYjlnMTd5ODFGd3JBV1VwTFhlTk9lckFwd3pWNlBjcUZa?=
 =?utf-8?B?WVc0OGhpNG9hSFd6N1dWSUhnNnhwLzNsdFJEaGdBQU5GWVBnTklwdHNjTWxD?=
 =?utf-8?B?RktMRzluendZZUsvWGN0QWkyWENJb3ozZFE4NW9xbGYyMTUwZ0I5UzFmNVJM?=
 =?utf-8?B?MFFNNTE1TTFoSklzK0dUdS9IS3BMekpNd09SSnVWMXhHSW5sQ040bE5TV2Ir?=
 =?utf-8?B?NnQvaGpkMWlxOWJJZHBkRk9RaUI5T2ozdE14L2VCWlNiS2ovYnNaSnVxM2h0?=
 =?utf-8?B?NWxvdDFLTEpxSVRUUzBqYXpHZCtKNTd4TWs1WFhpaUxjV0NvQnRBNzAyMHdn?=
 =?utf-8?B?VFVQKzBkNSsrY01BYk02cXp4aUhiNit3Rjk0YVVIRVVDdUJ0YjNuK1pmdHBC?=
 =?utf-8?B?cDAwbnpUdWEwRk13anArM3o4UllucUdTcVlDNDduSngwYnhIZ2lKSEUyOVlX?=
 =?utf-8?B?b1dnV0oxRmVoQTlleUFtenU3eFBZdHdpR1ZGT01zaXFrb0FNOStaNGJ3MFdx?=
 =?utf-8?B?dFZpVWpIOGJ1RVpxaWcwaS9oY0cwdElFYmNjYmllLzd6ejlBb0RJTVkzTitE?=
 =?utf-8?B?ZS9oMFRFazlxMVdxRG5vYmh1N1pObHN4N1d0WmkxdVorOGNnMEhXSng0a3l3?=
 =?utf-8?B?aytlejhUamwwLysrTlB1VWhGeUFWQ1N3MWM1aUJqWW5kbGJSWHlNdkNQZjJo?=
 =?utf-8?B?TzVJbFlOSDU5V3B3dzBNZVplTlJMU3pQaXJ6RERnU09BbEhHM0V4UFlLbmQw?=
 =?utf-8?B?QUZrSmRjSWJid0EzM1NxM3N3UDRkcW1HQmwrZG14UUZLR3drOXVVb3RkaDc4?=
 =?utf-8?B?ejFMM2hKRERiNm0xSGVteCs2ZW8vMmhWVlM4Tm85WGlVYVZUN1NJcmx4R3Nz?=
 =?utf-8?B?eHhPYWgweUVDNW8vaDVLNUdGQ21UYkdnRGZYSVNWaEZQNlFjSGZDVkdvS2Rk?=
 =?utf-8?B?bk1UNVVlemE0TkNIbG9EQWREUWJIaVZVRlg4UFJ5aUo3b3N0cFJiQmVDM00v?=
 =?utf-8?B?L2ZtcjJPaytSb05xZUY1V1drK1JXWUJkUFplcFV1VDV1c3ZxLzBpL2pXVWVm?=
 =?utf-8?B?SE9BRnczVVozbEN4KzU5aVdLOUtiOHRTeUlGRWJkenR3czJyY1duQ0JzQUVF?=
 =?utf-8?B?bDVJTkV3YndKdEdtcVFHVU9vWVJSbzhrcXNBUkl4NWJNR0JyUnVrWHBxa2Zy?=
 =?utf-8?B?cnMwZkh4dm4wN0xQaDJ6VzlVcnl6OGJSbGxBZHRzNStPdTNncjZ4N3V3V1ox?=
 =?utf-8?B?Ti9tWmZhRlVkK0gyRXY0TzJtMTJ5WTNueGxxWEhSdU5yczdzMjVmRTdwOXBZ?=
 =?utf-8?B?SlJpTThmU2hEYmZNNDBTakFHYlEvNFpWRmNvNDBEL3BTYlpnYWFtbzVpSEJG?=
 =?utf-8?B?Wmd2eEZYL0NTbGtWako2NTZVV0JGckNZN2JLNVdtMXA4NkN6YjVmU2xVT3RI?=
 =?utf-8?B?RExHc2p3VmlJeXgvbytZQmg0Ri9RK0lkWk1rTTZwZzZXb2V4dFhVMXZFNFhJ?=
 =?utf-8?Q?92MgwYS6BdSKasv2AVI8xhM3t9YbnBs4SpZfw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPFDC28CEE69.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVNpNXoxelpGU0dNQ3dpSDZVME4zcTZNc2ZHWkR0R3FNWXdRWlhuUGE0ZnVZ?=
 =?utf-8?B?OWkrTVhzbFoxNHlNZnFIZnpkbDlzRlN1Y3ExT3AwSWk0VExVcTBUZG9qdWlm?=
 =?utf-8?B?SjY2T2kzcUp0aVljZnExTGtlS2ZZZW1zVWpRZXlqa3R2cm9hUU9HSno2RWhG?=
 =?utf-8?B?Z2JMcjJHMmNzK2IwSWFhbVNxSEsxYVhlMThhbWhWekI1MXk4UlRWSGlIRktr?=
 =?utf-8?B?WmlhSVpCdlhRVzVkcXRQS0h4ZEN3K2tuak45bWtXWFN3MGJlWGdJQ0xPU0NI?=
 =?utf-8?B?RlBzeVZJSlk1ZnVCMFpCc2dMWU84UXZ0Si9YWVZlQm5FYVdNNnM5VEJwMmtL?=
 =?utf-8?B?SWUwOVdmSHpxOHk4akduVnk1ajRiODFBRDJJUHRMR2Uyc1hZMElQYjd5L3Nv?=
 =?utf-8?B?ZkZmK1d4bzBCSHcrSldWRHpFc2dGOHBxNzI4SStwSGtYa0lzQjVHeTB4TzNV?=
 =?utf-8?B?eVd5NUFIVXp6Q3VPRGtDaU4yNHhGdy9zQndSQmtrRkxrVFRrS0Y5UUs5OEdk?=
 =?utf-8?B?QXNqUzdEY24zbTlyS25jMG1wTDZodDlKeG5RN0pONXJDU2p0UERudjhKbHg2?=
 =?utf-8?B?OVd4VjBTdkFsZVpGL3pBRTMydWVpRWZhdWowcHJ0VzJXTjZURmNUNWdxcVdP?=
 =?utf-8?B?Z0svaDZoSzhKdHRZTGRMQThNcHZ4dFU1L3VYQkdlaGoveGxENVgranhSbjlE?=
 =?utf-8?B?M0YzckNCeDZsOFZ4ZkE5Q0ZxMXdqTngxRjF6QTROY25va0VKampRZ3R5bkxq?=
 =?utf-8?B?RGxGeDVrQnVVM3RKN0R2RHBWQXYrUXlyWFBaaWk0YkZHb0IrbERJSHUvZ1Rl?=
 =?utf-8?B?dDN1UkVHbnB5MGhqaFYwa0ExeDg4QkVsVFplRDBZRDFjandDY0pjcWtacUpU?=
 =?utf-8?B?NkpaVk1EU0VpMmg2ZGNXbUFvMm5QUnNSaVRHY01NaGNNTUZUU2tHRHdXTDBX?=
 =?utf-8?B?Vk84Z3daMGUvL3FLN1kzV1grYktRQURFS0F6TTd1VXVtbkJGYzFGVDFUZFlD?=
 =?utf-8?B?V3ptZlFNdFVtWDdyQzhNVGlNeS9GakR6K0k5UmtmVlNHelU2cEVvcXdZdjJi?=
 =?utf-8?B?b2JpbUpBc2lHRGRXT2JuWE1LMnliT0VmWDlDUnNVZEcza2w2ZWV1aTZCTjVQ?=
 =?utf-8?B?NVBNT2g2VU5hdFFLYzF5cVlVcDVnVU1PZlgremx5OTQ3UEdmcGExMGlCanUy?=
 =?utf-8?B?U2JheGh4blhkOWROaW9qVnozajlJem9xQTNDVXBySTBmcWpaYVcrU3pkV3Nz?=
 =?utf-8?B?L0tlUmJLT25KWGJoTlZwcFlPNHY0aTczdStOT2IyNHNYVmE3L2VHUXNMbDRN?=
 =?utf-8?B?ajNnTzRPSUFPaVFOZUxFUVZtUDAwYmN0MXRzWGlrVzJibjVlUHY5RnJsUXZi?=
 =?utf-8?B?QVAxUXUvK1J2RjVSZWs2c3hsNVJ3bVR3QkQvS25OcjhObzdZYXRhZ0RRR0s0?=
 =?utf-8?B?Zk5ySUk4aFdBQmpkb2xGWlF2cFNYMTd1K0ZKMHVIZU85SW5PaDRmVC9QUHVF?=
 =?utf-8?B?TVpIVjZHdmJmRGVNRytHUmprTVhlMnEyTGxwR1RTdW9MWmNBaTdXd3h2NEF2?=
 =?utf-8?B?OEpqclo4ajljb0labmFjWEl0cmZBbDFXTnFBQnJYTHcyNHdzUjFFbFhxd3V2?=
 =?utf-8?B?b2dwNWlMeUxoVDZRNFU1Zkpwc214eitudFRPY2xXSEZMdDM3TWd6OHRObjdq?=
 =?utf-8?B?cjF4VzUvWDBiNm15eXdTdGZyeDdKZnBzeE5tVWlCdmVRS1FZV2RLSXZ5dWxC?=
 =?utf-8?B?eTFQS0RZS2lXQmFJcGFJVzRnODczancrYXFhWFFOVzVBb202djVWelR6WmQz?=
 =?utf-8?B?aXZqOHIzQ2MyTUVBcEQwbGxLWWRSenZ2Rm1oa3h0N01TY3JxWCt4SzZMQS9o?=
 =?utf-8?B?T3dhalBFSGl5TlF1NnM2aExDNVcvc0JOcXB4SVIrUU1pMHpMc2JucGJYT3NO?=
 =?utf-8?B?MU1zVVZCVUh4UkVBaXVQWHJGT3NDL3RrY0lGSmJwa0J2dGx6TlpyQUd2TlE3?=
 =?utf-8?B?NEdMZW94d2lWU3RGbnluUVU3VUcwVUplb05DR3gybUdwRDNGUkdMYjNPeURk?=
 =?utf-8?B?S2VRcU9IK1FsVmw3bm15bWwvMkVjZDNVbWtnSGp1R1U1b2JxNS92UElJZzgr?=
 =?utf-8?Q?E7HHr2laiR7ZD9gdxjsUECbQ6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2396bb5e-b372-4d6d-b310-08ddb80c161a
X-MS-Exchange-CrossTenant-AuthSource: IA0PPFDC28CEE69.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 19:27:01.3162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3r+D9e2ErXNn9CfkUVTM/lQ/I6lDcKP0fi06xhjX6+ofyJHReuvHNnpXIzhxrIlScM6u/n0BCVM+JggSKXQRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9554

On 6/30/2025 8:38 PM, Fuad Tabba wrote:
> Hi Ackerley,
> 
> On Mon, 30 Jun 2025 at 15:44, Ackerley Tng <ackerleytng@google.com> wrote:
>>
>> Fuad Tabba <tabba@google.com> writes:
>>
>>> Hi Ackerley,
>>>
>>> On Fri, 27 Jun 2025 at 16:01, Ackerley Tng <ackerleytng@google.com> wrote:
>>>>
>>>> Ackerley Tng <ackerleytng@google.com> writes:
>>>>
>>>>> [...]
>>>>
>>>>>>> +/*
>>>>>>> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
>>>>>>> + * private.
>>>>>>> + *
>>>>>>> + * A return value of false indicates that the gfn is explicitly or implicitly
>>>>>>> + * shared (i.e., non-CoCo VMs).
>>>>>>> + */
>>>>>>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>>>>>  {
>>>>>>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
>>>>>>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>>>>>> +   struct kvm_memory_slot *slot;
>>>>>>> +
>>>>>>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
>>>>>>> +           return false;
>>>>>>> +
>>>>>>> +   slot = gfn_to_memslot(kvm, gfn);
>>>>>>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
>>>>>>> +           /*
>>>>>>> +            * Without in-place conversion support, if a guest_memfd memslot
>>>>>>> +            * supports shared memory, then all the slot's memory is
>>>>>>> +            * considered not private, i.e., implicitly shared.
>>>>>>> +            */
>>>>>>> +           return false;
>>>>>>
>>>>>> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclusive with
>>>>>> mappable guest_memfd.  You need to do that no matter what.
>>>>>
>>>>> Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
>>>>> disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
>>>>> out. Where do people think we should check the mutual exclusivity?
>>>>>
>>>>> In kvm_supported_mem_attributes() I'm thiking that we should still allow
>>>>> the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
>>>>> gfn ranges. Or do people think we should just disallow
>>>>> KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot is
>>>>> a guest_memfd-only memslot?
>>>>>
>>>>> If we check mutually exclusivity when handling
>>>>> kvm_vm_set_memory_attributes(), as long as part of the range where
>>>>> KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
>>>>> whose slot is guest_memfd-only, the ioctl will return EINVAL.
>>>>>
>>>>
>>>> At yesterday's (2025-06-26) guest_memfd upstream call discussion,
>>>>
>>>> * Fuad brought up a possible use case where within the *same* VM, we
>>>>   want to allow both memslots that supports and does not support mmap in
>>>>   guest_memfd.
>>>> * Shivank suggested a concrete use case for this: the user wants a
>>>>   guest_memfd memslot that supports mmap just so userspace addresses can
>>>>   be used as references for specifying memory policy.
>>>> * Sean then added on that allowing both types of guest_memfd memslots
>>>>   (support and not supporting mmap) will allow the user to have a second
>>>>   layer of protection and ensure that for some memslots, the user
>>>>   expects never to be able to mmap from the memslot.
>>>>
>>>> I agree it will be useful to allow both guest_memfd memslots that
>>>> support and do not support mmap in a single VM.
>>>>
>>>> I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_MMAP
>>>> should not imply that the guest_memfd will provide memory for all guest
>>>> faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).
>>>>
>>>> For the use case Shivank raised, if the user wants a guest_memfd memslot
>>>> that supports mmap just so userspace addresses can be used as references
>>>> for specifying memory policy for legacy Coco VMs where shared memory
>>>> should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be set,
>>>> but KVM can't fault shared memory from guest_memfd. Hence,
>>>> GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.
>>>>
>>>> Thinking forward, if we want guest_memfd to provide (no-mmap) protection
>>>> even for non-CoCo VMs (such that perhaps initial VM image is populated
>>>> and then VM memory should never be mmap-ed at all), we will want
>>>> guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP is
>>>> not set.
>>>>
>>>> I propose that we should have a single VM-level flag to solve this (in
>>>> line with Sean's guideline that we should just move towards what we want
>>>> and not support non-existent use cases): something like
>>>> KVM_CAP_PREFER_GMEM.
>>>>
>>>> If KVM_CAP_PREFER_GMEM_MEMORY is set,
>>>>
>>>> * memory for any gfn range in a guest_memfd memslot will be requested
>>>>   from guest_memfd
>>>> * any privacy status queries will also be directed to guest_memfd
>>>> * KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute
>>>>
>>>> KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
>>>> GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support in
>>>> guest_memfd.
>>>>
>>>> Here's a table that I set up [1]. I believe the proposed
>>>> KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
>>>> (columns 1 to 4) correctly.
>>>>
>>>> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3710/guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%20tracking.pdf
>>>
>>> I'm not sure this naming helps. What does "prefer" imply here? If the
>>> caller from user space does not prefer, does it mean that they
>>> mind/oppose?
>>>
>>
>> Sorry, bad naming.
>>
>> I used "prefer" because some memslots may not have guest_memfd at
>> all. To clarify, a "guest_memfd memslot" is a memslot that has some
>> valid guest_memfd fd and offset. The memslot may also have a valid
>> userspace_addr configured, either mmap-ed from the same guest_memfd fd
>> or from some other backing memory (for legacy CoCo VMs), or NULL for
>> userspace_addr.
>>
>> I meant to have the CAP enable KVM_MEMSLOT_GMEM_ONLY of this patch
>> series for all memslots that have some valid guest_memfd fd and offset,
>> except if we have a VM-level CAP, KVM_MEMSLOT_GMEM_ONLY should be moved
>> to the VM level.
> 
> Regardless of the name, I feel that this functionality at best does
> not belong in this series, and potentially adds more confusion.
> 
> Userspace should be specific about what it wants, and they know what
> kind of memslots there are in the VM: userspace creates them. In that
> case, userspace can either create a legacy memslot, no need for any of
> the new flags, or it can create a guest_memfd memslot, and then use
> any new flags to qualify that. Having a flag/capability that means
> something for guest_memfd memslots, but effectively keeps the same
> behavior for legacy ones seems to add more confusion.
> 
>>> Regarding the use case Shivank mentioned, mmaping for policy, while
>>> the use case is a valid one, the raison d'être of mmap is to map into
>>> user space (i.e., fault it in). I would argue that if you opt into
>>> mmap, you are doing it to be able to access it.
>>
>> The above is in conflict with what was discussed on 2025-06-26 IIUC.
>>
>> Shivank brought up the case of enabling mmap *only* to be able to set
>> mempolicy using the VMAs, and Sean (IIUC) later agreed we should allow
>> userspace to only enable mmap but still disable faults, so that userspace
>> is given additional protection, such that even if a (compromised)
>> userspace does a private-to-shared conversion, userspace is still not
>> allowed to fault in the page.
> 
> I don't think there's a conflict :)  What I think is this is outside
> of the scope of this series for a few reasons:
> 
> - This is prior to the mempolicy work (and is the base for it)
> - If we need to, we can add a flag later to restrict mmap faulting
> - Once we get in-place conversion, the mempolicy work could use the
> ability to disallow mapping for private memory
> 
> By actually implementing something now, we would be restricting the
> mempolicy work, rather than helping it, since we would effectively be
> deciding now how that work should proceed. By keeping this the way it
> is now, the mempolicy work can explore various alternatives.
> 
> I think we discussed this in the guest_memfd sync of 2025-06-12, and I
> think this was roughly our conclusion.
> 
>> Hence, if we want to support mmaping just for policy and continue to
>> restrict faulting, then GUEST_MEMFD_FLAG_MMAP should not imply
>> KVM_MEMSLOT_GMEM_ONLY.
>>
>>> To me, that seems like
>>> something that merits its own flag, rather than mmap. Also, I recall
>>> that we said that later on, with inplace conversion, that won't be
>>> even necessary.
>>
>> On x86, as of now I believe we're going with an ioctl that does *not*
>> check what the guest prefers and will go ahead to perform the
>> private-to-shared conversion, which will go ahead to update
>> shareability.
> 
> Here I think you're making my case that we're dragging more complexity
> from future work/series into this series, since now we're going into
> the IOCTLs for the conversion series :)
> 
>>> In other words, this would also be trying to solve a
>>> problem that we haven't yet encountered and that we have a solution
>>> for anyway.
>>>
>>
>> So we don't have a solution for the use case where userspace wants to
>> mmap but never fault for userspace's protection from stray
>> private-to-shared conversions, unless we decouple GUEST_MEMFD_FLAG_MMAP
>> and KVM_MEMSLOT_GMEM_ONLY.
>>
>>> I think that, unless anyone disagrees, is to go ahead with the names
>>> we discussed in the last meeting. They seem to be the ones that make
>>> the most sense for the upcoming use cases.
>>>
>>
>> We could also discuss if we really want to support the use case where
>> userspace wants to mmap but never fault for userspace's protection from
>> stray private-to-shared conversions.
> 
> I would really rather defer that work to when it's needed. It seems
> that we should aim to land this series as soon as possible, since it's
> the one blocking much of the future work. As far as I can tell,
> nothing here precludes introducing the mechanism of supporting the
> case where userspace wants to mmap but never fault, once it's needed.
> This was I believe what we had agreed on in the sync on 2025-06-26.

I support this approach.
I think it's more strategic to land the mmap functionality first and then
iterate. We can address those advanced usecases in a separate series.

This follows the same pattern we agreed upon for the NUMA mempolicy support[1]
in 2025-06-12 sync: merge the initial feature rebased on stage-1, and handle
CoCo/SNP requirements in stage 2.

[1] https://lore.kernel.org/linux-mm/20250618112935.7629-1-shivankg@amd.com

Thanks,
Shivank


