Return-Path: <kvm+bounces-44288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C26A9C4F3
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44A001894A47
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72E323E25B;
	Fri, 25 Apr 2025 10:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zrXlAD4k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C1117AE1D
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745575998; cv=fail; b=Op6T2USG3Q/RA5BK0pdHUYr06QNlw0TEPA3wzE/zuqOQ/ZP/cgM4aXfUqXmaHDVC2YI0lUDJSmqcrWzmkryRDuwWH69/mPhBVg/ukC6omJ+a6CJU1jWA85SC1JmeXhERplmVJOSdBvFyHVTifjvKdgwCc6bGkcuJO3aMyfVXDww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745575998; c=relaxed/simple;
	bh=Ak9nDrLcWkpaxCpGInDtBtz9llUVn8/B4pZ5bhnh41Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K7QaqKBl+Bq+DhUUfg02dl4wd8eH4q5vbqdt0mDRy6/zlDl8k+8XVah6r+kbqclaYSrSSiyVeKgqKuRHfFg1cF2TwYPjWQ1FPbXnZsFWfx4j/ItfT0xItrECXVSJYgyWd9NZ4aLvqXXKVcpYu72BqbMFTgQX2ldbPnOw2rKbhHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zrXlAD4k; arc=fail smtp.client-ip=40.107.102.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B6ltXZmU9KL9GX7R0sE2tK3Sc0B/yOdFqaHexfpyp5g4L643WIy2NfBsWOTofMbsf37d2pyRG0h3BiuSkxjHDEpoFR9LNICrT0xjB1heHIpGiaXGwN8PzP2YEHXoJk0uuFCbrHo3GhmfeWlB2LR49ymv+jU5yRP/K/y0oOs/ZvVbDT1dy7IS9iJSLjjQO9fnGJD6S5WG/WvqqrDIkjTjh+dCbe3kVaanLuKHzGuemD0xiJvg2DYjMjo96eM+PtR2A4amGrlBsBKZbL94x8/7VPoZG5a9xP8fu5a/4r346N4rOfOD1szGHLh7WrFLDZApqgUMJgmjOjGq+/71JAurxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Adhiep8UsbklNsMCJMApGWNllALQiiX6/VyGN/QzyXw=;
 b=lpzgQD8qtsKVYdqirSnLf5AszZ98hv0Vffx8mEAWm7uwEnwpipKtXzpxxnGL2+Kklhfx70F0rrF4Tq2yLhA7xf0KNt9nxtBa4Tm3UGkRalbEZm6uUDfrJgTlPKXLeqNOtAvfKpQ3a/HAX/0kKeNdDq3QfwZbpb4IBqMCI1R2A8ElYyLZmQ2EquHAliuHpjFN3b/ZLhbhPb5CPoIkHPd+L4C6WKjQLK5vIyX4OU8SVTKDt6sctCx9HSL/7YGSmEPSpoW7gtDSZh3WPbxnJa4SRWInGpT0hl/MW4JObmiQYgg6rMNVJ4AY6fI/9gTTN9CCAccgWulOZZRsokL2Xfipfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Adhiep8UsbklNsMCJMApGWNllALQiiX6/VyGN/QzyXw=;
 b=zrXlAD4k/xPbqQqBYMYRiGtjYYrBOUuNuRMufTioFvC05z4Ct37ir9tD7et4GIzzT7YQoB08i9Tx1oDYcLXK/H01rmCVUcpPXwFf6EtkdH3wX7S6KLY3DCULQ/HfPQ/dA1rEickRbY5P1Es2ShhscjrusXUAClCxnZGc/6+np8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA1PR12MB8520.namprd12.prod.outlook.com (2603:10b6:208:44d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 10:13:12 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 10:13:12 +0000
Message-ID: <07b946d6-a55a-44d7-bdac-44fed3968005@amd.com>
Date: Fri, 25 Apr 2025 15:42:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/11] target/i386/kvm: support perfmon-v2 for reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, qemu-arm@nongnu.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
 groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
 den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, peter.maydell@linaro.org,
 gaosong@loongson.cn, chenhuacai@kernel.org, philmd@linaro.org,
 aurelien@aurel32.net, jiaxun.yang@flygoat.com, arikalo@gmail.com,
 npiggin@gmail.com, danielhb413@gmail.com, palmer@dabbelt.com,
 alistair.francis@wdc.com, liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
 pasic@linux.ibm.com, borntraeger@linux.ibm.com,
 richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
 thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
 liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
 kraxel@redhat.com, berrange@redhat.com
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-11-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250416215306.32426-11-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:277::8) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 527435c5-356f-4123-fb4b-08dd83e1c92c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bURudFdCRW1JTHdzaUtVaWdsZWVlblVwSEpualNNZVArOVRRZGZ5OUFnTFhB?=
 =?utf-8?B?K09kOWZWVlZlcEp4TXN5MnlEa05aYmdDZHRLdEtJQmhHVG5aWmFaeExJQ1hp?=
 =?utf-8?B?RVRqeEdXT0JSRWx2RUpwb3pQNGsvNEJPRDlISmZ2VGRmUjBmOEM5NnFZQ1FI?=
 =?utf-8?B?eXdjTUdWWVoxRTR6OW9xd1MrU1JRbWo0b0trb0ZOVHhwVTliQWpqRGlYWkVV?=
 =?utf-8?B?RTJCK0lkTENRTExZTU5qVDNsN1h5TmJSUCtvVk1wTnVMWnhrcnY5OGNUdVhp?=
 =?utf-8?B?bXhQdHFFSytEcVVQUU56RmRNRGdiR0JsYW9oTUtFSmF5ai9mUWNOdnlEakRK?=
 =?utf-8?B?Y1BJNFRyU1VRNGdybktCTkRFMm52L3Vyenlyb29mQmdNRzdxUTZNNjZKanVN?=
 =?utf-8?B?T0N1eVhhTUFPdGJCWC9FZEFGdXRLSnUyK20yTDFBbk1OUEt2UGUzeldUV2cy?=
 =?utf-8?B?byt1NmVqYmFuU0MxaTNCUjJJekp4NU9NeXZEUERNYUlYU3VacmxnaHlGYllK?=
 =?utf-8?B?STFZVjlETDFnRkpHTFNOa2RrVU1QUGE1eFkyZnJpYnRjQkpBdlR1RG54OGRN?=
 =?utf-8?B?SExTY3ZiR250U1FIZ1Q3c1R4Smw5bVJpbW9VcVJ3cWNsci9NdDRjcUJLdkxj?=
 =?utf-8?B?RGd4NjJHWGptM0JmU3ArcWduZC9OTnlmU3p1RGJBbzRrbURnaXJMOHNLdURr?=
 =?utf-8?B?dkJkV29DK29aUGVGUDVBQ2NnNG4yakZ5TjBxQWFicC80ejVEUElUR1V0VWxi?=
 =?utf-8?B?TWVYelN4NGtHdXZjL1dOemp1cjNnVWIwYUdyeDVGaHFTaWlaZ3ROZzlvUGJu?=
 =?utf-8?B?SWRQdGJQaHJJT1FNU0p4cGJ0cVUwQjFMUlZjR0FOQmtWSGMySEFjTzhJNDEv?=
 =?utf-8?B?NlN5cTV6b2RoNGxwMXliZEVWWjZWSXRWZGxCQkl3OGwweFBmZWh6SnNJbWkw?=
 =?utf-8?B?ZGF5RnAwcTZBUFlpS1dOVkprQk41LzY1cEZDb1czNDlxMmpnSEZpbzFQZXk4?=
 =?utf-8?B?dkFYSm5UK0RjdXZGc25jWVNmWm1jaEhRYU9ZUmZsTk5sOU5PaE5jVTJPcWRa?=
 =?utf-8?B?ejlta0d4dXlMNzFxUVczcVErem1lSS9nUS85Y1ZST2loWXZXSFdYRnZWMnFX?=
 =?utf-8?B?UGMvU2UwUTB3K0RFSHBabTFQU08rSVpqaHd5bzFPa0pqbko2ZThidEVTeDBR?=
 =?utf-8?B?aGxwRGRvcHp6N3o4Uklwek1DRVo4eXhvS2dkR21RQkhiaE9zMWMzYVg3MVdy?=
 =?utf-8?B?eHdjMTlaU0pIclR1MEI4SEdVbEtudS9MUWpwMzVRNytLNEZxOHgwME5SQlMv?=
 =?utf-8?B?QkY3clgrS2VJUXIydnQ2K29Sc1RxQ1ZIQkRTM1B5T0tOeno3a3IrM0hZUmJt?=
 =?utf-8?B?dnNyQXZjSkVqbWhoWlZFNDBqcVVGTzBVd3hhNjVERmlCUjRuYTBiYURoTFBw?=
 =?utf-8?B?aGNVMVJkcjJWcUdOWG5Ecjh1VTRXWFpnNWhncTN3UUZoMEdJOCtzQVEzZFFp?=
 =?utf-8?B?cU5Vd2I1ZEdOOTVGQXFwQ0Mwa2JHVllHQVRGNWNwUlErUDlUVXd6OUZ1NjM4?=
 =?utf-8?B?cVFEZWtEVXNtSk5TamVzS1I2Ny82RnFpZURxUW5YRytscTdWVG9VUmRaYUw2?=
 =?utf-8?B?VkVBM3V5dmFxSHNXMlZaMW0wNU1ZdDVRT3ptaWYrUGwvYTZ3Sjg5endLWkht?=
 =?utf-8?B?K0pIc1p2MjZqR0FLL3Z0a2lnNndYNndOa29GZ1dFME1kN1YwOGVaZXQ0MFRx?=
 =?utf-8?B?MU1TRkZxTlN4NXpqa3BMeTNhSU10T2NtMkJzQ0pnbmxKNlozQmttRWpoL1JN?=
 =?utf-8?B?QUdjbGpVS05Kdm9WdWdMVlhaYmQybXByUUNzd1Zkc3ZGOWxzRWxReWc0cTk4?=
 =?utf-8?B?L21wcjF2K0Yvcms3VlprWHZaM3pWT0NVSnVMeDJnOVlFb2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHZBOFljS2hVcWowaGNLWlZjU1QzSDNiQlYzZXBCZXllc0VnQVZxY3QvOUwz?=
 =?utf-8?B?QkYzb1VqRjVPcW14YmNzYnpSVHdURGJPb05PN3VBYU1rNmxwRE1ab1htOW5V?=
 =?utf-8?B?cVg3Nkhpcmd0amFzRjFXdFN6bUlCTUs0QVJ0ajA5OWpHcjNnRDh4NWxTQit1?=
 =?utf-8?B?dkwwUkNlZXYrbG5oYVhNOENSdk16bWYvUHhSdmVQOExxeEFkNFFiZ0NNNkRi?=
 =?utf-8?B?UHQ5NE9MUzJxMnpWRFpoN0dPOFBBMFhNOG4rc3N4U3U2dU1hbzl4eXhPRmkv?=
 =?utf-8?B?MCs4MXA4MHplekU5OW84Y2gydUI4bDhnVk1vWnBQZWhvTlRkanUwTUNaUXl6?=
 =?utf-8?B?UGlHQk5nRm8vQWhsZElscVdGSGpMWFk1NmRmYnVxZGlMQ0wvdWJwNEtBQ2lR?=
 =?utf-8?B?UHdqcWk0L3hjVUNPc2J0eEtzeEYyMW1MN1ZmaFRIR0RDVjNDbFFENW9oSmNp?=
 =?utf-8?B?a0ZWdXN6cXpFZFgvTjlZTEd3UFpqZ1dFR0tJNkFTOHlaYlBOTnEzWDRZZkZE?=
 =?utf-8?B?NTBiSlRRWVJqNlNFaGdyU3lQUG5DWnNoS3JQNFVXMGZrbVJGZXU3cUFUcTQ2?=
 =?utf-8?B?RnR5ckFHeTNSN0pwMWdPdzg4aUgwcWd5cGVLSi9PUTMxTEhXbnRVMjI4Rmw2?=
 =?utf-8?B?UVJXRzBOWU1Xc1RZWXJNd0hoUWg0U3N5M0xRdnNIdk9qeDY2QnNKR0R6R3Bu?=
 =?utf-8?B?VGZkM3htZEdFcFFiTXllRVh1bStFdlp4enlLOVNqakNHSHBJU2ZlR2JSY2F5?=
 =?utf-8?B?ZDMxQW5HSkdDdTVhaW1RVTNhdUQ4bVZOclpBOTdHZnV4SlNERUNkUlM0Wi9B?=
 =?utf-8?B?VnZySFdWT1d3RjY5M1NtdXdQTXRCZ0gzMTY5S0hQbWNwSFFwaEdCSmxPTVhB?=
 =?utf-8?B?S0dsZGU4VjNWbWF5cTMySkRtaHN4RzN2eEk0QWhISUN6UEVBZDdOQUs4bUZV?=
 =?utf-8?B?MlRMb3c0TlZiU2IzZ1RRMUhSbjZscjlFMWVid0hNK1RTVFoxMVVIYXFkRDV3?=
 =?utf-8?B?c1VzTnZRVVRqNGs3R2VqTkxZbVZ3QzNMdTZyV3ZpcTNpVnIzWk0vQUlhWW1J?=
 =?utf-8?B?YTVVRzRTeGxMYVB3VksvaEpGcU13TUliU05RVFk2aGdDdUhwS3ZzZ3M3WFhX?=
 =?utf-8?B?TjZ2Mi9yQUl5UlpYRVFyVURwSEswQVZOZlo4VDF1V2VNUGk5VHF0TlNiVXlX?=
 =?utf-8?B?NDE1a3ByQ0dCNGU4aHpEdVd0UG4xNjFaem56MnVQVVdwS3dxZ0Nlc0MrK3Qz?=
 =?utf-8?B?VXZQUTVaTUpzNU9vbElpaUN1QVRYVUlYQjg4UUxOTXprSE16NEhsRXRiK2Ry?=
 =?utf-8?B?ZVB3aWJhYnh2dmNadTR5ZmRabXN3VUY0RkhYRk9HMFQ3RnY5ZkRBN3lYWDdO?=
 =?utf-8?B?dS9LTllUdTVVcDFiM0Vkb2Vsc1NMSGJQV2lDR3ZVcm9McmYvVWVCUTIzd1Yz?=
 =?utf-8?B?YVEzYWwzQ1BEcnVISDJzelgxNGZWZk9aU1JvOE9LZkM4T0pjQkJnY0pmaGRU?=
 =?utf-8?B?Q0NDekhHWlRUV0pydzBjN0cxeWtzL2dhZzVIOGpHU3k4OU1KMkpqUm13S1Ju?=
 =?utf-8?B?UmVpcW9RWmZQbEl0WWR6QjhpMGJJVFF2Y1FQdjVMNGZnVE5SZDdBUlYybVVM?=
 =?utf-8?B?UVErTW0wRU5jRGhhRDNaQzhTUGpNNU9PUFpKK0VFSEVIblF0Z3MvVVRtYndF?=
 =?utf-8?B?U2hpL1VTZy83SVdGSmFkdVRNbWNhZzczeVA0YWkzZkRmN1JGYkIyUUV5V2Rz?=
 =?utf-8?B?QWJMV21pQVFPUEExSWF3aWRTQjdxTy9DRzlITHpXUVN3Y3RzOURjaHFuTzlN?=
 =?utf-8?B?dkZ5bXBua2FHMklLeTVCNWxKSkZjMXZoc1FqaUVCTW94K1pSM1IzWHRrZG1P?=
 =?utf-8?B?Nm9LaEtFcUFHNE9BYm93ZnQ1aG8xSFlCaW9ja0VubnJNNC82aS9rL0VFNVZr?=
 =?utf-8?B?K2RmUXdjMDdqeTNVT3hPVUlHdENRNVAwd05XMFVMRGVWajlGQU9RREkxR1ox?=
 =?utf-8?B?VmhDWllsV2tiK2IwQXpTNGY3WmFMeWpXdFVtM2liUUNxTmlGeHA0L3BJczZ2?=
 =?utf-8?B?MzB4Q1RySjJaWGp1cWcwRlpOR01qZjU3QmxKVXJKRzNGV0t1MWNSbVVTOVVE?=
 =?utf-8?Q?V5e7VN6zQBqVytY1Ut/AKCo9U?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 527435c5-356f-4123-fb4b-08dd83e1c92c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 10:13:12.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsJzOfPGGuC9bfRWGrDuukAQZ+izMBVhVJHVTeg2sEpfQZr5U99N9LPAz6M1S5a8c1hZmVsZVBHuVt/5pyy9bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520

On 4/17/2025 3:22 AM, Dongli Zhang wrote:
> Since perfmon-v2, the AMD PMU supports additional registers. This update
> includes get/put functionality for these extra registers.
> 
> Similar to the implementation in KVM:
> 
> - MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
> use env->msr_global_status.
> - MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
> env->msr_global_ctrl.
> - MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
> both use env->msr_global_ovf_ctrl.
> 
> No changes are needed for vmstate_msr_architectural_pmu or
> pmu_enable_needed().
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v1:
>   - Use "has_pmu_version > 1", not "has_pmu_version == 2".
> Changed since v2:
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Change has_pmu_version to pmu_version.
>   - Cap num_pmu_gp_counters with MAX_GP_COUNTERS.
> 
>  target/i386/cpu.h     |  4 ++++
>  target/i386/kvm/kvm.c | 48 +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 43 insertions(+), 9 deletions(-)
> 

Reviewed-by: Sandipan Das <sandipan.das@amd.com>

