Return-Path: <kvm+bounces-43039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85209A83503
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 02:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFAFB16BB29
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 00:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC439DF60;
	Thu, 10 Apr 2025 00:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0AubEXxP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE963B9
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 00:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744243935; cv=fail; b=L0BVCAQ4eh4NtQmGoqbw80rbU1PO1+hk1HclCadFMUAfvA7924eg82uul1WpNJ08NvGJTsJnQCVlNYF5kzm3UvNIM6loVIBl7u5ZR/xlYUO3JLxc1YUK1r2F0CIzUy3P2O4yDANZQogBTgVQTxJzROS482Zfm4STAg2ephUDa6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744243935; c=relaxed/simple;
	bh=ma4tg9UQo6Pf6VCnjecljZ+Bd46xF44VebJ0JvQWe/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kjJHBi/l+G6HoqqiDwi3RsCNQpdxjbZqznRkrUluYElsiyhirvAr4iEpl8GW8ckEzDhlD1fHCixsuGrt72HUimgSQoONADsOb/X5jcp4hlhUHNo/fDt8Hh+sAwJXHVDS857AJeCZlwNq9T7Ikqaoqiz08HOcfXWKi72UdOByVqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0AubEXxP; arc=fail smtp.client-ip=40.107.95.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHNWOtwnpA3TCN7MfcnNL/Sc47hkWVuBHtUKKdijR5WBZ1mkQzbPQpe7oWIWYWkNR4ORzcJhvz6NtblpQKBcpxCDbDrlUWP+ih14A5/bBa/V5vKcOUPmNMWAOrNbGa8Or8os0Y2vLeAkOWkZ10jViwkNYMnhusflx+yhzLOh7FQVSt78NaMT4SPpogCLphk5XFWjbgbsfBEze+bCgCIhNx1NJSqf2cxRjuavc5zqQY09NlX5nIgv8ZI9ScXAf4ZXmIeFEfhgvB4anKefsyLw9Zjlg//Ae6K6+l1N/Y0m9WUE7/qT1KyXGQaQFZrRTHgmF9TgQhyFPzjdRJqAi9cqyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RrXQuSv9/Y46qgS3yFmreXdpscKf/old6B2Fmksoe4=;
 b=G9EdYwHbRobLK/HsUuKyCZvcxZcKESLi6Qs4gqGDqqc2i0kaZ3/YZylLmiTphb6QLxK2PvvFHEEc4MS9prlUyYj5uFIPqeDGbkb6af2xbwkIEOEnLyodPzCRcQFJdnkNG79OPeHmJoeAUQWPv4MOVUQ6wfiUAlbEzxAdTuvp6YzcvONDY7l06Z8WH+OREVIFSPz1ZtbB6Oe/8dI0XGAGReJELmltMU7AO8a7soPIMwT/Q8R/N3r/ifBeyMGxt3Z9xTSIdLjCWMBh+fvyIOvUrJ5VMmtfnYZ5EeEQOyZQqOpfkIC1Pz7mFnCUP5hF6Vr0lWCodAUYE/vXNLhZQKRXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RrXQuSv9/Y46qgS3yFmreXdpscKf/old6B2Fmksoe4=;
 b=0AubEXxPIaexvW96wdCVHGcAXGkUvgSxeTYAMxgNEGl5RzMmfVpghNUoQbRfBkiwXU31MCb2o/yzONnadWjNZyLhad8Ip1Zzf+cLc85uB1MrxHS9wLc33cZohCHNhL3bWHG6wLmxK/psDd7dGmXVoQiA4NMkze08gkwI4fmFSwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ2PR12MB7865.namprd12.prod.outlook.com (2603:10b6:a03:4cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 00:12:09 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Thu, 10 Apr 2025
 00:12:08 +0000
Message-ID: <25f8159e-638d-446f-8f87-a14647b3eb7b@amd.com>
Date: Thu, 10 Apr 2025 10:11:59 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-5-chenyi.qiang@intel.com>
 <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
 <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWP282CA0098.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1cf::10) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ2PR12MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: bda3c073-c536-42eb-28a2-08dd77c45510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnV1bWMvcnZsNlphNGl3VllqTkViUVY4RXBkMEhWL2ZFQWMwWTNTSzBueWJp?=
 =?utf-8?B?cjBtVjc0QTJZQ3FuK1N3MDhiQUIzZ3QxWnhRTmVYVi9zRUplakVadnFpOGFF?=
 =?utf-8?B?WTg1eXpUdDFnN20yTWh1MXNRakJZTVFxdC84TTVFazRKWG9LYk9rVU4yT3Nt?=
 =?utf-8?B?ZC9pUk9URVNPR1lVbTlrT3BYb3Q3Y2piNDVleU42M0J0MFNkeE9BQjhKRXpm?=
 =?utf-8?B?clVzMUF3ckJVSC9NM2dnS0pFVzZZcDBqQ3B1QTZJRmhRd3VOQ29zQ3l2MHI1?=
 =?utf-8?B?VTB6RkViYWw5RE0xblYrSUtnVkxMUFMrS1dtN2htNVV6a1A1eXk5c2tpeUJl?=
 =?utf-8?B?RFdpN3VqYlRNZUNlZ0g2M0ZMSHRHV2R1ZEJEWDlRa0Y2YzJEbUM2eFFxYjNa?=
 =?utf-8?B?Ti90ZlM4ZGVrclFSVUk0aTR4ZDc3dVh3UmszbGZMbFJ1REs4KzRhWjFrb3h5?=
 =?utf-8?B?THNPbkJPT3dTM1Mzb0lhbHZ5ZlZudk9qcDZDSWQyUVdqVlM5R0l4d0NtRFFS?=
 =?utf-8?B?Z2tVdWw0RlhkNXArbENFNzJYd242WFZ5eWVKTFM4aEJQM0c4U2V6bEM3eHBi?=
 =?utf-8?B?UjFLdVcyVVMwUjliU3RpQUpvRm8yM3ZkN3hYQ3ljZEE2THZ1TWpBbURGMGsx?=
 =?utf-8?B?K1ROVzh5NXNnWTFjbkFvdFFDaC9EVTVza2kzellWQnJ6NmYrQ1Vaa0hZYm1C?=
 =?utf-8?B?MXdkYVV4K2hNSmdLSWhtY3NDTklqV2MxUWlKL21VTFkzZ2EwcFR5VEMxSGVu?=
 =?utf-8?B?eW0zK0xvdjdIVHVBRUZOaTU4Vll0UURQY0gzK2grb3gxUG83UGdhNkJhZS9m?=
 =?utf-8?B?dW9SZHhIZGVOc2FBNVF3RVlMdldQQXY0M3IyV01OR25XbXVuandmWmd6S2Jj?=
 =?utf-8?B?dzVLU2tWcnNiWjZzaWZCUHdZZmJIakpSczhkOFg3TWpSU3hjbG9SNjNnbDNJ?=
 =?utf-8?B?NWVFdHZQS0VoVEEwMVNTbEVmcXMxOTk1TVZqTXliVWd1N0s0dWZ2K256eC9u?=
 =?utf-8?B?Zm1kT0tqc0tCNVcwWXNIN3QzUHlIRGc4MERHKzAzaHB2ejAzdHZxd0s1L3lC?=
 =?utf-8?B?S0I0NlJkSVFGeHh2WS8wcjRLY3A1OW9RZXlScExyRTNsSk9Ob2pudFpKSzFG?=
 =?utf-8?B?aUNDQzJCbmRsSGQrcE13TUZFUTFBSG9OdXhES0FxNmVlTU1uVVlRbkI0dGEw?=
 =?utf-8?B?N05vSWJIRCtTeVRtd0F6c2lZTmdsZnE0YjhrOVA0RGtGZlVST0c3dzZCVm00?=
 =?utf-8?B?MUFobXJsYWhiQjR5QlB2RnlzRVVyYlkyQm1icjR4YkNQUHBRb1lBbU9QV3FL?=
 =?utf-8?B?VDJINzMyMVVCZUtRZ1hieWh2aytaYWRDMDlDOFRiTGxvM3RZUlF5ZmFsRTBH?=
 =?utf-8?B?SFpDemtkSE1yWS9WQzFzU1ptcllZOCtTMDlPeTFsOEhpNDA5VlRuWmdZb3R0?=
 =?utf-8?B?V2pmUHV5UUx5eXhSK3EzY3FRTGR2ZGlxcEoxT1FXdlVSb0RkcjVOeUgwclQ4?=
 =?utf-8?B?SDdYa1dPeVBQaVg4Y2JBWjZ1YWlpWkxOemNWdWsyWVpmNFA2U3J0Q2hxNGFr?=
 =?utf-8?B?dUFHNG1paERTSUtYbDhuWm1sckhqN0NnWFAyS2hHN2xDQmk3UFVVY3B2SnJh?=
 =?utf-8?B?eE50ZzhrZEIrbWtQejBwdkdlZ2w2NDduWmhtQnp4SVR5TjY3LzJnbXRYWUpz?=
 =?utf-8?B?OVhYdVJEbTVXVWljSk5pRnFWVWlKaFpnZFF4bkpHN1hSV0NQVEJLcndCRzF2?=
 =?utf-8?B?dEJzbGVOaXpsMTEyNnZCSVVnMEdBNEMxOHVyTTV0SFJIalVkS0haT0VwZno0?=
 =?utf-8?B?VFRMbWRNbWh1L1BHR01MOGE5dkRwYWlOVnFDSTIzazEzelFKYzllTkZPYWkv?=
 =?utf-8?Q?7elKMxDu3zsiV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGx0NjI5MmFKaENsSVFqUDdCRC82T3FhV1dISHI5L0lJNUluamRQVTNFYmtz?=
 =?utf-8?B?Q0hFQjduV0hjNVZVbFZjYmk5OEF1b05GaXAxM0VrQ3g4WnF0eVpBTFR2MzdQ?=
 =?utf-8?B?ajU2VmMvcWV2enh5a0hUOEF0UGJWTkZ0a3YvT24zVGRSVkpPWXI1Z21LeTVl?=
 =?utf-8?B?bXJSZHNHQW4vZGg1aGFUcUJRNVlWSHNPemczekttd3E0Q1RkdXA1SDhDSllT?=
 =?utf-8?B?SXEvbGp3UnhCWGpJSGUvRHozYm50QkZXSUxtejlGOVJieDMvekxLV2FTZG1E?=
 =?utf-8?B?dnVVUjJDSDlYVEZQSm1KOVYwTUNJeVdFRktBM0RQKzBUZ2Mrc1NmaTBZN3Jk?=
 =?utf-8?B?bjlkOUV3aVhUaVNuM0tPUDlyajRWTXV4eXp4TklKTFVGM3M2bnBIOEJGRUdY?=
 =?utf-8?B?b0lGOXNJYTkxWG4zNjRmL0poR3B5TVJTWDZYRHc1VlBvcGVsKzhVSHNQTDVj?=
 =?utf-8?B?eEJvN0Z1WE5XL2thZGxtMDhpL3RIZ2wwQWRSRTZuTjc4Q044dUIyRGdldFIx?=
 =?utf-8?B?dHNIVG9zcGJGWEZOUlNyYTRWa1VSVHVSdnJrR2NrZWpzVjByNWt3MVJ2UC9x?=
 =?utf-8?B?ZGJPYklmTlN3M3lINUtFdG1Bckw2M1lRd1ZQbEtqbFVxbnpEeGNuTDlsQ1p2?=
 =?utf-8?B?L0loY21aL3RNU21HT05kMGFIZ2ljb0pvWmFNOERYMmQ5c1Mxc1U3Rms2RnpU?=
 =?utf-8?B?VzBXN0FrRzVLTzEwUFhuc0syeThObklQNnJnL1Vra3JNS25CMkxQalJlZ3g1?=
 =?utf-8?B?cWJISTh2b2xNVWhTdDJvczNvWFdWWm9xL1M3aGoydkZwN2NCWVpYVi9TQTYv?=
 =?utf-8?B?ZGd5SkUzaVVzaW10TEkzN1dCR3JEaU9OQ0Y5M1d4WC9VQlh1Wm5yZlkzbFpO?=
 =?utf-8?B?YzVQcmNJSE11R3ZpVkRrVDAvMjk4eFRqZDRMQWlsQURldlZEVkJ0UUhkWWo4?=
 =?utf-8?B?NkttKzFaMStiM1pVZ3Vld1F0RXo1VHJJVmkvdU96TVo4eGxSZkNLSWFuZzNp?=
 =?utf-8?B?c0VybTJMbWRlaW9rN3QrYTNPdEJ0SkEzQ0hNSEtCVjY3Zktrb0xkdW01UEtN?=
 =?utf-8?B?ZVlKQ0tNVytlWGRyU1diMUhZcTc0dVlKSDBMdjhJZFNqTWRLam9vNCt2VzJ3?=
 =?utf-8?B?WTVmS0daN1A5czREZWx5ZGZsWGt1MFlYMDF5QUVrYnhQY3ZKN1AyNU9qWjE2?=
 =?utf-8?B?RUtqQ1RrNnJtNzlyUWJRcFBYVk8wS052MmN0UTZXY2RoZ3RYY2lFNWVKY2Qx?=
 =?utf-8?B?ZjZTSUV5aHorc0NyemdCWjNBbHZ5aEhrY3EyQXh5emsvTEM3bjZSNW1EZ3Jw?=
 =?utf-8?B?R3MvbFB4SmZ0QW9vRW5DamI3WEN0dkZjZWZZd3hlemlESWh1VmdyNHBMU0lr?=
 =?utf-8?B?eGlPM3EvZWw4N3FuWUZSYm0yTHhuK0Z5bWxhUWxkL0dnVzBqcWdpTHE2Q0lW?=
 =?utf-8?B?ZkJ6WndCTVNJekdzVGhhaEZra0hyMHFhcGZ2ZE5oS1RjY3NpMXZBZzZ3WHRn?=
 =?utf-8?B?Vng5bUd0YTBjeDNNajR6eThMN0kyZ1RhMnRsOHRyU0RiYlpwNEF1dGtTRFli?=
 =?utf-8?B?bzZ6V0hwcWdjSWdnZEZ2SldtVXg2dzlZdStzQWlTZy95dktVYmQ5Wm0rV3BU?=
 =?utf-8?B?MlExVnJaZTFIc1lrSGxvSGxXSzhFd0x4MTZkeFBLVEV2YmFab0xVY2VxaWFm?=
 =?utf-8?B?MUJNTWdRN3Z5cXR1MVYwczd5Wmx0WG5OMTlBc2tqc0YrQUUwNS9PdVBWaENO?=
 =?utf-8?B?NmRyM3NydTBqdnpKanRZclpDWWRVNmJkMUtzVFhUaERUVUUwdzk4N2I4cVZF?=
 =?utf-8?B?dVZRUjZoc3R3ckFaUHNLdDRoMkxRQi9Mdm5DNzdQWE93azBpaUNCY2t4SEM1?=
 =?utf-8?B?VHhJVERveFRTbmdEcEQvOFY0MFBKbFlTUkhsUkY2NU8yOG1Ta2RUSTdoSERU?=
 =?utf-8?B?UmhxL2tDU2I3T1ArVlowY2tJcVJ2emViWGN6bFJYVSt3eGZKSlVjSTBabVhS?=
 =?utf-8?B?WHF0Qk4ra0tMWG1JMWNNaHh5K1p4bXlUZXd3TWZSR0NtVUV2azl6Mm9HU1Bw?=
 =?utf-8?B?bWJSeVBtblNCeVlacVBuVzNFQ0dwenQxb2EvR1psS2MyeHNQWmxNSkpRRjdX?=
 =?utf-8?Q?+HF/AVGssIYsoedVfSZPX8ZmT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda3c073-c536-42eb-28a2-08dd77c45510
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 00:12:08.4781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nka+Rm27oWn3aNOR2+VYCcc2gk2q38omvs6QhD4tzfdSm49BbQrZQZqNKii1KlM/vK81LoTD5HaStQJFqnfXvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7865



On 9/4/25 22:57, Chenyi Qiang wrote:
> 
> 
> On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 7/4/25 17:49, Chenyi Qiang wrote:
>>> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
>>> mappings in relation to VM page assignment. It manages the state of
>>> populated and discard for the RAM. To accommodate future scnarios for
>>> managing RAM states, such as private and shared states in confidential
>>> VMs, the existing RamDiscardManager interface needs to be generalized.
>>>
>>> Introduce a parent class, GenericStateManager, to manage a pair of
>>
>> "GenericState" is the same as "State" really. Call it RamStateManager.
> 
> OK to me.

Sorry, nah. "Generic" would mean "machine" in QEMU.


>>
>>
>>> opposite states with RamDiscardManager as its child. The changes include
>>> - Define a new abstract class GenericStateChange.
>>> - Extract six callbacks into GenericStateChangeClass and allow the child
>>>     classes to inherit them.
>>> - Modify RamDiscardManager-related helpers to use GenericStateManager
>>>     ones.
>>> - Define a generic StatChangeListener to extract fields from
>>
>> "e" missing in StateChangeListener.
> 
> Fixed. Thanks.
> 
>>
>>>     RamDiscardManager listener which allows future listeners to embed it
>>>     and avoid duplication.
>>> - Change the users of RamDiscardManager (virtio-mem, migration, etc.) to
>>>     switch to use GenericStateChange helpers.
>>>
>>> It can provide a more flexible and resuable framework for RAM state
>>> management, facilitating future enhancements and use cases.
>>
>> I fail to see how new interface helps with this. RamDiscardManager
>> manipulates populated/discarded. It would make sense may be if the new
>> class had more bits per page, say private/shared/discarded but it does
>> not. And PrivateSharedManager cannot coexist with RamDiscard. imho this
>> is going in a wrong direction.
> 
> I think we have two questions here:
> 
> 1. whether we should define an abstract parent class and distinguish the
> RamDiscardManager and PrivateSharedManager?

If it is 1 bit per page with the meaning "1 == populated == shared", 
then no, one class will do.


> I vote for this. First, After making the distinction, the
> PrivateSharedManager won't go into the RamDiscardManager path which
> PrivateSharedManager may have not supported yet. e.g. the migration
> related path. In addtional, we can extend the PrivateSharedManager for
> specific handling, e.g. the priority listener, state_change() callback.
> 
> 2. How we should abstract the parent class?
> 
> I think this is the problem. My current implementation extracts all the
> callbacks in RamDiscardManager into the parent class and call them
> state_set and state_clear, which can only manage a pair of opposite
> states. As you mentioned, there could be private/shared/discarded three
> states in the future, which is not compatible with current design. Maybe
> we can make the parent class more generic, e.g. only extract the
> register/unregister_listener() into it.

Or we could rename RamDiscardManager to RamStateManager, implement 2bit 
per page (0 = discarded, 1 = populated+shared, 2 = populated+private).
Eventually we will have to deal with the mix of private and shared 
mappings for the same device, how 1 bit per page is going to work? Thanks,


> 
>>
>>
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Changes in v4:
>>>       - Newly added.
>>> ---
>>>    hw/vfio/common.c        |  30 ++--
>>>    hw/virtio/virtio-mem.c  |  95 ++++++------
>>>    include/exec/memory.h   | 313 ++++++++++++++++++++++------------------
>>>    migration/ram.c         |  16 +-
>>>    system/memory.c         | 106 ++++++++------
>>>    system/memory_mapping.c |   6 +-
>>>    6 files changed, 310 insertions(+), 256 deletions(-)
>>>
>>> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
>>> index f7499a9b74..3172d877cc 100644
>>> --- a/hw/vfio/common.c
>>> +++ b/hw/vfio/common.c
>>> @@ -335,9 +335,10 @@ out:
>>>        rcu_read_unlock();
>>>    }
>>>    -static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>> +static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>>>                                                MemoryRegionSection
>>> *section)
>>>    {
>>> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>>> scl);
>>>        VFIORamDiscardListener *vrdl = container_of(rdl,
>>> VFIORamDiscardListener,
>>>                                                    listener);
>>>        VFIOContainerBase *bcontainer = vrdl->bcontainer;
>>> @@ -353,9 +354,10 @@ static void
>>> vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>>        }
>>>    }
>>>    -static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
>>> +static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>>>                                                MemoryRegionSection
>>> *section)
>>>    {
>>> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener,
>>> scl);
>>>        VFIORamDiscardListener *vrdl = container_of(rdl,
>>> VFIORamDiscardListener,
>>>                                                    listener);
>>
>> VFIORamDiscardListener *vrdl = container_of(scl, VFIORamDiscardListener,
>> listener.scl) and drop @ rdl? Thanks,
> 
> Modified. Thanks!
> 
>>
>>

-- 
Alexey


