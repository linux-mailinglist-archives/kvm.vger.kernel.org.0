Return-Path: <kvm+bounces-52101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FEDB01672
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C61875C0F9B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCDB21127D;
	Fri, 11 Jul 2025 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xl7mvNxb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFFC1FBCAF;
	Fri, 11 Jul 2025 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752222903; cv=fail; b=CVkw/seH/mXa1dnPMcCRpYO7SaUwSQ4Ci6a03j+omNN4x+kd8DhHpWhq05K8KmoaaRk3YXrPO5byJ9ici1zdNm8Rt+zG8j+JCvZGDzBAFz8oASx9c3RAe4G5KBqXsdwTjeK+TS5mNuIqyNhHlmkL9b+hZvnzhGK56uCsMI7MshI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752222903; c=relaxed/simple;
	bh=S6PXf+PaPwGg5a32kBKp2b6rP/wZVKEpd/7jRwnLirc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zj04skzyKciI37Ei1t8Dr7LbZkPeHQ15NphnwbJX1CbOJ2u4Ng/O3F934SAH9hWM8oG6HLK17K7cpdZZ41iejxDpUjEjOWI4Q42nHKyL1DNNYDQGQhRpRxGo3XxJwuNCKUwwrOT2fpuuXWh6MMLlR4rRLAG5zNtCsHbFewCsItg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xl7mvNxb; arc=fail smtp.client-ip=40.107.244.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpBVTkrTw6SpoRQzW99gsQpVqhYYWQf3Yeq9Gfib/LP6cRucsukE7U8JNJq+B71+yXnbR2njdvBn0bUExqu7IVLKJuDeDXc4vv9I+vpNTPaJOQP4AEpAMZ6ky31306Kc2f9czMt6NAb8QEz3ZMcWDcpRtm6qC/AHYHkr1+ePMc505ww6BLPAQSCQiv9fz+ll6g+8F+mOPVBQLyQlOBNv9RHORv1fUK4Xo5wJ1mfEIS4MeE3ky+a6uDbIBUwkkhpzlz8kgem7bOJsXmiuWeoMJN/azVl5+lcJcJZ0yvNsxF1B3K5V3jIxrWcwkGB+wFEUbGg4kfAWSE6t6XY+9tkZ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOa1pkgWoFcXZXCQFW9nY5Z85x6P4Hhstfq3Pv+s7Vw=;
 b=S8lUwDMtbiDnaREJy/mlTKaYIBoGBZSE7kaZfvufb8NWgfpAGwdA9EBvyLKtFAaiE/NVJywXL0ci99OqpwpDkG/cdi5DAW/VN8TH04dzd5MiNrLT+lSPHcolepNoRExq24QhxbbiyJyymBAahyOLSGjBBwAFP8JRUsRVY5cf88t5UcSAgNWMGh61B4yoJ0//cVRmsaRFGnCgC3x9PcYlUPtgKNesrtf7fUUMSLn6+OYGeGGIMAv3W2tEH0C2oTpP0WoxadsPsrEN4hWW3JOfe6+hsm8B5x4AJ0YmvoiIIagpKl1Lsn4pxn0lajkP2nJLPY1gDaw8byBVm8PI02KU1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOa1pkgWoFcXZXCQFW9nY5Z85x6P4Hhstfq3Pv+s7Vw=;
 b=xl7mvNxbNUAGIaZFVdy5ElrNST54s8DetApdtVK4LKtB2EutnkoGtp9vuPLDdDwjIMTycPbeaHupOiQb420nuAzfpcfuqH+O2FLOunad1DVOxEkxdcOlQ/oqZClY8pa5/kKMk0Kp/Hado9LPEL89QuylC+VJBk/rcsnh5vr3m70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa) by DM4PR12MB7671.namprd12.prod.outlook.com
 (2603:10b6:8:104::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.34; Fri, 11 Jul
 2025 08:34:58 +0000
Received: from SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf]) by SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 ([fe80::40bb:ae48:4c30:c3bf%8]) with mapi id 15.20.8722.031; Fri, 11 Jul 2025
 08:34:56 +0000
Message-ID: <5d335c0c-3676-4158-9093-bc5e9f95c1dc@amd.com>
Date: Fri, 11 Jul 2025 14:04:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 09/20] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
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
References: <20250709105946.4009897-1-tabba@google.com>
 <20250709105946.4009897-10-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250709105946.4009897-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0042.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:277::11) To SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
 (2603:10b6:a0f:fc02::9aa)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPFF6E64BC2C:EE_|DM4PR12MB7671:EE_
X-MS-Office365-Filtering-Correlation-Id: 325c4ce8-3db0-42e9-cc4e-08ddc055d05a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3JVWUp1MVByZnNUY0dtS0RPNzV2a2FPdDluTldFUm5EQ2xSc20zaW54TEI0?=
 =?utf-8?B?L3c0VFAxSStPZitxcldYQ0IxZm1Od2poTDJ3ekNwY3NUZW5KMlBwc3FNYXox?=
 =?utf-8?B?WDhVYVNjakxSQmlvaVJoRnBYMjh1b0R3U3RFdy8zZEhQVDI2a28ybEkzV1ht?=
 =?utf-8?B?am9Eejk4dmJBV3ZJdmllODlyb1JDWGUrVE1QeHVxaXFTMHJPZE05ajVDUEFU?=
 =?utf-8?B?cnRiT0YrcUZnR1NRbWI5MVVSY1pXT0ZLYTFmRnJTR3YxVTk5K1poS2JkeGJr?=
 =?utf-8?B?RlhtUjA2alBsNHRBMms2eGlnYkZKZ1dHaXNERWpSY0ZYVEw5ODEzaXZnaDZk?=
 =?utf-8?B?aHpxM1R6bmVIb05KV3hCRy80RHNnbndxdlpRTHM5YnR3c0lZVS9qREdpOURH?=
 =?utf-8?B?dmcrUjZFeW5WMGNwa1BjMit5K3VsY1RTY0x2TENJVURKZUh0azRGVGdpZmxt?=
 =?utf-8?B?YjlNWEVmNjlQVXIyTFQvNWo1NHZhcU1qUmdaV3l3YnN3RXk1dDYvRnpOTG5W?=
 =?utf-8?B?dnlFNzY4dFI3SUM1ZzZCR0Nta29jQ3k5L09PNEZvWmNoTklJUnBsV2V6aXdE?=
 =?utf-8?B?eXU2cFl2MHRIN2NVMjVqK2E5WmpDQ2FBNWQyTWg4OHJpWWVURnBhenB1RjZM?=
 =?utf-8?B?L1RqaXFEV01zZWZhYVY4UEd4ZW5odDA2THpia1VzQ01tWVl5ODgwSFVoOU9j?=
 =?utf-8?B?OGt3L1FQaGhmZzBZQ3lDQUVLM0Q5YTRwSXByTEUvV01zRzVKY1pUSXp5M0FT?=
 =?utf-8?B?Tk5BbHI1a3pXaXJOWWdCZTFxR0t2R0pHS1FsVU1tT0VKQlpsVVJXeWY5K3ZY?=
 =?utf-8?B?QWpuYU9kYVppZGk2WWtndENJUGRWRm1JZXFXVjRNZm5POXZScU9pR1IyQ25q?=
 =?utf-8?B?Y2FLMDRUZlAxdURIOVNDTDFnSjVSL0ZSQ3FKelViMUJZRWJpUUMycnVVWkhP?=
 =?utf-8?B?Vk5pcXo0aGJrMU9MUzV4Y05ITW51TXpHbDdCUmdEYy94WnJDZm4wc29Mcmla?=
 =?utf-8?B?OHlQb3hxQXA2aktxaXlPamN1ZEJyUHZFL2Z6T21mT1p6aXlaeCswQzlXUkJm?=
 =?utf-8?B?UldQbGRyeTlPaW5heGtpSGFNQnBwOGJFRkhsK2doamtuUnZTODNSWDMzNFU4?=
 =?utf-8?B?Z0pUY0VMWE4vOHIyZGcwZVhVaEJnL05HSFg0ckJmYlZaUGhvUVVRWWpxeE5w?=
 =?utf-8?B?ZTJzdklUNU9hd2lYS3VrY3NmbFY2TStUZTF3N2lMaWdpQXY0cUZ0YWU2aVNa?=
 =?utf-8?B?amFYMndqOFFFeG1rMzhVa0J3RWtVbG5GUm5ieDM1UzN3VHVIZisyVnpZTFd2?=
 =?utf-8?B?NzlCRXFoelorbDhnZ3BvVWdBcU93OW1WZndsUjh3dXVIRXJhc0FiUXlpbHBi?=
 =?utf-8?B?MEdBMWp6QlBvR2xPK2pkbGJQOGRmTFhvWVVpSUtINlZRQjlvMzZ2NkNqVTcv?=
 =?utf-8?B?ZDN6UFFidzJjOFJvRFdMUkhqTlVYQnZ5TlZMSFVLRWRmRGZHcVFYZjcrYnhx?=
 =?utf-8?B?UUVWbXVHbFJOUG5sL0RYREg5WmlzakEvYmpKejhpRms4SGZ3T1dzdWNaSTda?=
 =?utf-8?B?SkdHSjllc3dGYlhaengvTFRacEZzWXliWkI1MXRoYUVqdzROMVdVZDJYdkhN?=
 =?utf-8?B?Rk9TSkFaWUtoekQ2WHVkWmtVSkRsV1l2bUZhQlFsODRVZlVrLzZkZC9LZCt4?=
 =?utf-8?B?OHlWSnRrZkc0bW5hWXpMWko5ZlVUYTExRk5PQ1VrRE9IemMrbjhJeUtVRGta?=
 =?utf-8?B?WkFHa0V5WDZrUExGSjBNUVROU1A1ZUx6a08wTFBLVlRYcU01RzkyNXdwWCtH?=
 =?utf-8?B?OFFTOG5nZENsblVVM2RicUNGSllNRDdEWk1yMElLaVh6cmYxMHczSzQ3ZzBI?=
 =?utf-8?B?TXRVU2JMRk5jdWNYMzFEUlluaU9RaERMSE05UFliVjhmVHJ6QzVreTZYYjgw?=
 =?utf-8?Q?9XboXW2NJJA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPFF6E64BC2C.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlQyWVZQUHoydXUrR29yT3FadUtaUUs5ZlpHL0FCVkQwL1J2RHJHODlKOVJ3?=
 =?utf-8?B?cThSRmRDcGY0cW9pS1ppdHl0bE9NVjJrQ2tOVjNkOFNDOUZPMmFVaHJyWENK?=
 =?utf-8?B?SlAzM3NnZWkvdm1DNW9keEhJdE5STE8vMFlMandjZlB3ZG1UOFpleXhOd3Ft?=
 =?utf-8?B?ZUJCbFRRM3FWTXBZaUYwTFVMeUN1SERyVlRRbFN4czc4ZDdPNXlVWHcvblQ2?=
 =?utf-8?B?SENwWG1OLzd5YTFKWHhxMmw1dE9GTTBYdVRhN2dyaFpnYXRnWmJDckh4NVpn?=
 =?utf-8?B?Tll0WEtpSE1YL0NKOExZMXgweWIvOVZoY2RRVEl0aXlQSmkvNVlrN2YxWUhk?=
 =?utf-8?B?YzRoV0ZDVHRWTndZOG44a1E2UGJVcXdzaVZpZTJmbzYwNGlYelE2K093Vi9Z?=
 =?utf-8?B?d0ZHRnNSeThNV3pheEc2WUxSMVcrVmNzdmFpMVh2b3NCWGN5U2RkaWdocmlr?=
 =?utf-8?B?WDJPWFV6YkVKTVh4MDVUL2FYd2JzME5FOEJIRENTYVgzVEVKckhMVCtyZXNQ?=
 =?utf-8?B?bllGeWt3YmhWMS9iRGcwYmJOSm1RNm5GdUNoM0dDbmxmT0pDdE5XMVkraWM3?=
 =?utf-8?B?Y2hySUlOcURmN0dpT1lCY0VHNGNTY3hmanE3NlgwYXJnblRFZkNDNmVWTkxD?=
 =?utf-8?B?WVcvem8zZkF1dlduR0hLeFBtbDhoVklpcGtpb3orTFlZNk9Bc29ya1BJV2l0?=
 =?utf-8?B?UHVZVCs4bHZSR1JDaDBkRzNZUlRMaWdzOFAzN2tYeWxwMmp4RzJrVk9IVzNU?=
 =?utf-8?B?ZXhuRnIxR0lDWTFyaUx2Vnd2QzJ5cDFoQW1CN3FlWUc5elVSc1cwWEJLTmR0?=
 =?utf-8?B?RzVtNTlVN3ZVYnR1YU1OY243TVJUb0lDQ3B6Z2Z6US9Sb0FOTWhvTi9WaHBL?=
 =?utf-8?B?QmVKRjBvV1hYT2lYY1lJYnNYZENkUEVySU1FOEFwVDJVSWFFWEpGTGVycDVF?=
 =?utf-8?B?ODZUd2J1dUtpTGxzWFR1a29LeGlydUpXbTY2MUhESTNzUHdVa2xXOCtyZGNq?=
 =?utf-8?B?ZUZaQzVNekFtaXlhN3drVEJ6MmxvcXlhL0dTR21HU0s4RmttbXNSS0xWNUJi?=
 =?utf-8?B?R3ZyZVZYcUFBbnZsTlZ2TC8vRmhBWCs5RjhNdlp3aFBkMXY3QW5ZV1RyVEpu?=
 =?utf-8?B?KzJ3OUdVSEhsOVBYajJzL0YwNEZWTVE2dko4c3daY0pWa3ptWTJudmZSNllV?=
 =?utf-8?B?L2R1WDVZNFNXejFPOVF0V05EUC9iem1NUllNNFFjYy9EYTM0STZuenp2bkNE?=
 =?utf-8?B?QmlPV3hwNitQMm55K05iS3BNQkJELzM5Z0tLUGlTZkdFOStabk5aYnVwYklt?=
 =?utf-8?B?RjgrRGtyWUl6bkxtRWhBZ1JLazBKd1NQc21IOFBLOEtOcEhwWXFBVThIc0JF?=
 =?utf-8?B?eXFUbWs4NlZpSEszV1dFUHNKZUE2TnFDT2lsbjI2YkNOOFd5TnJMS0ZaMmZr?=
 =?utf-8?B?bk1SMzRrM1pjWCtjOGV4WTlaTmU4N1JZSHorNmN1d2MyQk1FUlB3ZmxGanNB?=
 =?utf-8?B?c3JBNDNib05kT2FjSTd0N2JLWUU5dHZkZGd5MTVGcU9nRUdObDNHMU1TTFp2?=
 =?utf-8?B?VDk1QUNhZ1NENjhlY3lTWEltandoZVpXL2hyVVJlYk9xKy95Q204K2lrRHdu?=
 =?utf-8?B?bjNnZ2VKbHRtbm13Nk53RTJtNkU3b3I1VlV6bTJ1K2lDanNsaWpRcmdwdGNN?=
 =?utf-8?B?bEZISEhIRHRhdzBTdjdMbWVmZy9nbThQZ29pVURRNnJRTDBXS1RjZVc0cXJR?=
 =?utf-8?B?S1VWNUdweTF4ZzJWWUhZenF5TFBjY3AxU1ZOcTQ2UXF3cHlIdjJjZmhvcW92?=
 =?utf-8?B?Nk0xbEpEVzlzSmF1RTNwMDhCVVNFaTM2OXRJeUFjdUVudHByeDRua2taSlBq?=
 =?utf-8?B?NGE3WjVzZjlOWkdLSEJaWHFsaHBEOHJlZnJ5Z1VOa201MlRYTXEzUE5QSFNB?=
 =?utf-8?B?RlV1L0tjUVArYldrVCttOWlFNXlpbGRxcko2T2krbHFnMFVRT04yMndINWRx?=
 =?utf-8?B?eGdWMmFEdCtoSzAvS055WHlCdW1vbGxCenF1TUh1aDJYNXZ6MkdhbVd1UExZ?=
 =?utf-8?B?ek9KeGd5dEU5aWJBbVpjeTV4cU5oT0FxY05jYUd5ZThUK0xJTEJVTlRLTE5v?=
 =?utf-8?Q?9GNl46PKM3XHFHnhBKSxj85OY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325c4ce8-3db0-42e9-cc4e-08ddc055d05a
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPFF6E64BC2C.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:34:56.2885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8jyHFOB33ObvFTTeftbhHIs8qBl4l0Xs8E80WTN0G7R3+yU9IVZ3Lww+rIowy/hB9pF/SzcXoyLmMZcF3m3TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7671



On 7/9/2025 4:29 PM, Fuad Tabba wrote:
> Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> supports host userspace mmap operations. It's strictly for KVM's
> internal use.
> 
> This optimization avoids repeatedly checking the underlying guest_memfd
> file for mmap support, which would otherwise require taking and
> releasing a reference on the file for each check. By caching this
> information directly in the memslot, we reduce overhead and simplify the
> logic involved in handling guest_memfd-backed pages for host mappings.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 11 ++++++++++-
>  virt/kvm/guest_memfd.c   |  2 ++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9ac21985f3b5..d2218ec57ceb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -54,7 +54,8 @@
>   * used in kvm, other bits are visible for userspace which are defined in
>   * include/uapi/linux/kvm.h.
>   */
> -#define KVM_MEMSLOT_INVALID	(1UL << 16)
> +#define KVM_MEMSLOT_INVALID			(1UL << 16)
> +#define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
>  
>  /*
>   * Bit 63 of the memslot generation number is an "update in-progress flag",
> @@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>  		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
>  }
>  
> +static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
> +{
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
> +		return false;
> +
> +	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
> +}
> +
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 07a4b165471d..2b00f8796a15 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	 */
>  	WRITE_ONCE(slot->gmem.file, file);
>  	slot->gmem.pgoff = start;
> +	if (kvm_gmem_supports_mmap(inode))
> +		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
>  
>  	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
>  	filemap_invalidate_unlock(inode->i_mapping);

Reviewed-by: Shivank Garg <shivankg@amd.com>

