Return-Path: <kvm+bounces-46157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3387BAB33EB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9643E3A2B38
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CC225CC5D;
	Mon, 12 May 2025 09:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXtsn6fl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C0F2E645
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 09:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747043009; cv=fail; b=GmgY/P+y6DhVX1Kdwxpkw4TWy2IrK0FSs2iUFQ9REI7shfPOTmXx+/X4auh5N2bqDDDmQ8L+5T3uXRVKYRSL324YGFbijCJ245LJAuWfYo90p/qzYh4HpwBJKRKER25l/XU8YjAOV3LLuGZRXTskh66v4itQf79jS8uR2wssAC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747043009; c=relaxed/simple;
	bh=WCoXXmjkwU71OBNIto7g/0JsCSAwOpl72b/Wh/SYyyw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tx0n5hb1ygcptzbZYq10cWz6Y1xDnmGKsRKu7pQ4jy+HjPmSHETB1xWkiuIxyvo4MEzpGV2Ff+O0SJhr8L50UBAMt0+0gWfipKF+4ClAzpmtDvgRWxs3971gauhx40eVBKJD7sBRrrHBzU1eV7etLbL6K8pdjZnuFTIdy7WBbNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXtsn6fl; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747043008; x=1778579008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WCoXXmjkwU71OBNIto7g/0JsCSAwOpl72b/Wh/SYyyw=;
  b=nXtsn6flXjm/0aMezFjSOxKdwqorXIE/riv2T+/lgtRCjyVrp00bn0NH
   5mjxpMVpy0by5E852orYB4LC5Hy3/e2BC0QQvA8H6HHUv09kzF+LXojFr
   my/TL/UlkdVBw5FwYjSDvp9VEYj4FeL6aXgGDnNhpD7pfsbHuFzLdQ9nx
   mOlwfYTIDtnHS/ztD1ZVkL0PAqKLnfyid1qNHigDWohIMZf1kCG9LSab8
   AtKKfda0Cbz8NQR3Spimyb/WJR5kXioLdI1ozshs3A730U0raAHnnFvlK
   wAN21Mlh2ATFM+EZ/vgELcgSS4M/fjlas5gDuAUU1YngdGXqKEfqSJRJs
   A==;
X-CSE-ConnectionGUID: TknnLegBQEmyss84rvpPFg==
X-CSE-MsgGUID: 2ZH433EIQn6giTMJc1A+hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="71341019"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="71341019"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 02:43:27 -0700
X-CSE-ConnectionGUID: u6oTTvT/QGePXMa3n80GIA==
X-CSE-MsgGUID: MygnK6OUSOSpRYsKKFyHew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="137821900"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 02:43:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 02:43:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 02:43:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 02:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WuWA5C7ohGUAYsDLMRsCBya4A+q4DBbiiAJRNHdvDAe9WIe8/IsD9kyLuJ2IliZldNheZSNdoax3aZ9Eo+1GzH0Cfiyz6RAi9QafB0QvJE5BFFAev97PaYHq36mwUxu4qOk4rxiWjSv8RFxdAXj2EvVuJqIznYEyWZmFoDjvXivFzDS7rUyp7T+1YULQrjZym9kQEwfKGkxH+F+fdWmgbvCevAMwG+aiHbrAxfe5b9aqKWJSBXoTIrgo0ebtKHYN4nOkXfZRKxGBVhOjBvkKYn5QjIOqbm/5WiUF4Ob/aGXOPhUM+zYCw1KttI7VYRNmCDRrEE+1zwWA7LU9135jow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2P/JEu2AADMQePARTxbKnNppLryNJSHvqj7LiOidCk=;
 b=QcniVqtG30WfFFOIJGGo/56Eu+gcoNFX8qR8LXr6VnWECfwyVQMsY/qJaLt32IQl+YPKOK0276QpdR6t8ptFY4zODTjVB3amOVmQGDT0SB7KR91WREMzLGizfIHRmluQHrp3wRM776sNLt96Jun9qJlB4F/uEmOjwWqIzNM9QozgebhNpq5n6JymKjF73wYb/PW7dy4vSV4uvP6Q6Pxm3Ut1n42vf3ACvLDRWBIDuoSoY++clU5eRbxzrOnwIWricwFVU9W7deD5Yyq8vfciXajnLQkr/P9dpf1i1JNxFYfhwtdzewfCV/GTJKFFZF3u0gNpjwtMJY/zvHG6uU07yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:95::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Mon, 12 May 2025 09:43:23 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8722.024; Mon, 12 May 2025
 09:43:23 +0000
Message-ID: <3c4405f4-8d2a-48aa-b92a-f8fee223f1cb@intel.com>
Date: Mon, 12 May 2025 17:43:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
To: Zhao Liu <zhao1.liu@intel.com>
CC: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com> <aCGsPh/A3sh0dDlI@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <aCGsPh/A3sh0dDlI@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CO1PR11MB4787:EE_
X-MS-Office365-Filtering-Correlation-Id: e64aaef1-f90c-4997-1d91-08dd91396f71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UmJVazl4MWZIUkt2ckU3dHAwa3Q3UVU1T3FrRXAyeTJDTHJyOW5McHo0UWZq?=
 =?utf-8?B?K3gxT2ZvMGlsa3N1UDZFR1lFUGlxdVJ0Q1BZRkYrSkVyQU40Z0ZKNlRIaWpG?=
 =?utf-8?B?WjdTa1JIUXQ3TjBHUUVhU1hvMmJ5Q0JnL1k1d2FNZGh4b29LRHBIUFFVSkkv?=
 =?utf-8?B?YmdIdlpKUlp5SVZ0TU5zTVNsdnVCSjhZQzZ4bG9hRDlIT3dWT1dIdnVJd1dV?=
 =?utf-8?B?RlZtWWxDeEl3ZFE0MXY1VHJld0pHSDUwMytlaE9KbUM3UFN1aUY4MVB6MHpr?=
 =?utf-8?B?SVRkWExOWFpnSVlXN2VKV3N3NEk5TWxLbUh4UEFFbjFFRjV4NUFQM1VkRnVG?=
 =?utf-8?B?SUd5c21TMDJxdHJ2MWRzMjA5WW5ybzlNNTZsM0RCU3B0Sm0zd21WUkpwejg3?=
 =?utf-8?B?dExXWmtlSUNaMmsrUzNWTzhYa3VZY09SaDFUbUlrZksxWW1RTHErMk9uMnJX?=
 =?utf-8?B?UmxkbGcwNHVTdXZRaFhvbFNIWGgxcjdoTG9xVWN2MTZnUjRwV295TDlldklU?=
 =?utf-8?B?ZmYzS0E5VXl6eWovMFFxb0xNdWZuTkVwN05tUGFqSWtmcnVmdHl6YlFYajIv?=
 =?utf-8?B?UzJIWlYzTmJYZVFwemtpNkY4ZDZFN3pxREJ3cXRPdnE5b09NWUsxbCtZVnNv?=
 =?utf-8?B?NDR2ald0S0wrSkUzbVNrMzJETk9ub0dFSldLazc4dzBHdEN0U2RTWExsUHZR?=
 =?utf-8?B?bWVXZzczTFBJVSswYnd5SU95WSs3cE5QaDB1UHJGMVltdXRjMW00dERacklz?=
 =?utf-8?B?NEdSK0NvK1g5V0FndFVzYVEwTlVmdEVjU0ZiN3NmdG9ibmp2Q3kwQVZhcHlO?=
 =?utf-8?B?WWduNkRaaSszWHJYbUhqdUxiRFhKV3pYbGdnU1E0THBEbDdNZy9teFR1Y0p6?=
 =?utf-8?B?VEgzbzBUeUFoSWVnRVFHMXFiNjY5V2srcWc3NS9hSzlNU09MNC9Na3pMdHNt?=
 =?utf-8?B?SElxRXlDS0NtS0hyMWluQ3Jzd0lvQU1FOENBak5nWmhiMlh1T2JEamI4WU40?=
 =?utf-8?B?RDByVDE5UTBWUllQRnl3QnhJN0NPczdtSGNNOGh2QjhWQjFDOGxrQXh6bERE?=
 =?utf-8?B?WlQ2S3czT1JTcDkrMXZHYURHVC9ESHZCWW5BL0Q4OUx0VVRTRmZWZmdqMkFn?=
 =?utf-8?B?emZLQjZaRnI4TWxPOTB3MnVDcVRCMlhTdlExNXgvTzFvZWdaMmZQb0pUUkFj?=
 =?utf-8?B?cDFTejRERk80cFVsWS9nRzVjNkJFTC80SkpZSHZablMzSjdmelF4MUM5SDRG?=
 =?utf-8?B?UXVqdGJLUitwNnJlcytvMU83dVQ5dTRBZUNUYjgvOHhuVjhkd3pHcmNJeFkr?=
 =?utf-8?B?dDRpTHc1cTRaM282U2QvSTlRcGZudlhLbWd4bGxzVVRpdXNJTVJ0NURrUFo1?=
 =?utf-8?B?OU56ejE5bW5vMzJXSzUzT1BTd0ZFdm1ZM3AzTDVVWUh0SzlaY2RHYlVtV3Jv?=
 =?utf-8?B?L1RuNEFxdmk4dzN0aThYbkdLSVBIOEFNNHU3L0NkY1oxMFE4M2R4M3hOdHNO?=
 =?utf-8?B?Z0ppWXl3SmRJRWZIc0NxT0p2ODFjbFFhUytPb3QydXUzNmFacTQyU0NvRkVV?=
 =?utf-8?B?dkpDT1YybUYzQy9wbS9aUGlYRXRSc1BuVklsZkFmY201UWlUcnIxNGVSMVZJ?=
 =?utf-8?B?ak9wKy9HZllHNXRINUxXR0VzZldWajFUc2dCMEcvUEl2U0NzQWQxUEswd1hE?=
 =?utf-8?B?RmtMN0FQeGhqU004TzdjZGt1bHpGZ3BkY1c4VTI1L0F6RHBqc1VpSElnMHQx?=
 =?utf-8?B?V245bnQ4bkozMkxkOEh4cXpYUDlxWkJuSnhZQTFyc056SkdxTXFja0pnSktX?=
 =?utf-8?B?MG5tRG04MlVwZ0JIQTUzYlpkek9QYkVURWpZZ3QzVFlmMzZueVo1OFBZdm1E?=
 =?utf-8?B?em5VdDBRMXUxOHMrQ1hqY1lmVHlIcU5JRlJvQmNQM1hNTGhPQ2JoY1FjNEcy?=
 =?utf-8?Q?Mo+4sVBYJ5yaU/RaunbcsGlqi8/dP42c?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UE5YYU93Tk5EN09vSndRSXlBTXhPSDhIMWh5OEVydzUxbkZjTUZjV1lMOGJX?=
 =?utf-8?B?bWMxdTBVUEJOVEtQL1VkOEg0azVnODl3V0NxRnJIOFpFbkZOUXFONldvMDl4?=
 =?utf-8?B?YXF6ZDNPdkVITlZtbW1zbjIwYU5NdmhjMk9INGswWWVJV3JXTXRjQXNYclAy?=
 =?utf-8?B?YS9TcEg2VVZxVmFTcXE2M2Z4ZDBUUHExVDFBU2N2L2I0WHNwT0pXaE1YWXR1?=
 =?utf-8?B?S0x5bEJ6Y2xUUVlPSU4vRDBOOGlKbE5LK2Jtekl3M3JscHdqYXlBKzl2ZWFC?=
 =?utf-8?B?Nk1UQzJra1dBZkVCcHA1NkV6NHRGWjVJMmJsbDU3b3FOdlRqTEx1OCszNE5v?=
 =?utf-8?B?YVhVc054M0IxRmJ3U2VhUnNsYVZFRVZDdUFzV040bzFTT0J3MlluMFBFN2hC?=
 =?utf-8?B?aHMyTDVMMXhwRDVtNjZITG95dkpLQ2dFRStUelMybDRnR0J5TGwzbTBpeGNq?=
 =?utf-8?B?OUtkVjVsaEVtL2hpMktwc1EvTFVFM1ZuSjMvZ0xoakN1bXpNWE9NMHdRZ2ZW?=
 =?utf-8?B?Q2d5eFM2a0FWRHA5blJXN0tmM0Z0dW1rWDdiSm43Y2pON0lwbmdVSGJINUs5?=
 =?utf-8?B?MGxnK0FwOGdRa05TUkdmb3NMTEN2aWhMSDRjVHBIWkx4ZE9Nd2xCYzArZnVu?=
 =?utf-8?B?K0lPclYzai9URC8vNms3NEd3R0NkSUQySG5hYmg0OElKU00zK2c0NDRpampH?=
 =?utf-8?B?dnloS0tpT2JrMkg3SGk5Ti9QOENhQk4xWW5KWWZjemp3OHdpN2ZPRWxSbVc5?=
 =?utf-8?B?TWZtSWNPTWlEUHJpd012MWJ6V1lEb1pzSWJjMmRVWWNodEhJOU9yV056SlhL?=
 =?utf-8?B?ZTRCb3R4dTFRZzB2aSsyM0FBekQ2dTIwa1pCY0M4QUEzaysxbFlFR05meVkz?=
 =?utf-8?B?UUVDbDNod25QZ1d6RVlsVU1CT1JOWTdZRml1UWtKZ3NURnF5RjU0bEJZeTRI?=
 =?utf-8?B?KzI1TXZuQU4wa05GVzd6TUcyblM1Y01aTHh4Q2dHM2NUdXp1NE9JVjZOMnpJ?=
 =?utf-8?B?dWVLb2oxbmtTRSt3NFJRM0RrYWJib3Jld1AwSnl3Z3A1RnZNYVczZm1lWkZM?=
 =?utf-8?B?RkZoRUlUUGJsYVFpTkJhVlp5cjE1MEw3bXZoMGt3N1FVaHA5L1U3ZnR3Q3BM?=
 =?utf-8?B?andneHRNSFhRbUJSem4xd1hvSFpNRUd0eFJrenY3bHRLZ0NPZXlDT2tHcHVv?=
 =?utf-8?B?U0J6NmJDMW1TZmRseXJjb2I3OFBrWk9nazZnZmVRcjhGNUVqMHFiZmlubG9R?=
 =?utf-8?B?ejNVTVR1KzhsYjdybUc0M2pqZm9Eem8zQXJTenpNaTAxN05ueXRjQmVZS2ZD?=
 =?utf-8?B?MFZDSXNlMXpqUUt2cVJlTUtUVWNNdjlmWWRNVXpiMmp1RFBYTGpkRWVsRXE3?=
 =?utf-8?B?dUNpQ0w0R2ZFN2lYU1I4VGErN0ZTSVlvTkkyQ0hxVm1XT1UzUkRXTUVpaFFM?=
 =?utf-8?B?VjdhcjRldkJmamh2WnhoRFUyVzNEYlRkQmtQT1pKSzRlclg0c0trL2l1WStj?=
 =?utf-8?B?cUQydE5xOU9XbTc3Wm9oU3lCbjRTdzF4QnhveWVWVUpDaUpKYkVwUGZNN2pQ?=
 =?utf-8?B?L1JIQlhKNEZSdnByNkxrVUxrdXFrT1I3R3kxQWRoNDRTSE1KL3dRNXJ2WGsx?=
 =?utf-8?B?N084clJvQUVqSTJ2Ti9MbkEvd0xOa0ZwMW5OM2REc1ZhVUQvMDdGeHFLZnBv?=
 =?utf-8?B?UDNia2wxemNBUnhldDhRQjJWSDRGQWdFKytJMVdmR2thdHNnMmZNK09JbENK?=
 =?utf-8?B?M1d1b01idlVZU2VGQlFMdkhZUGRVaS8wZEQxa1BHemZlQitXRHBFeEdPcGls?=
 =?utf-8?B?QXZSdGt0ZUJGNld4UjlzV2svMVFITitGV1FkUTdvUU10QjM0eG0vVUZyMzgy?=
 =?utf-8?B?VklTY1hCT3Z0QlUvZWI3TUxiTnRDa2N6VDFmMzErMU1rUFRzcUtIMExWN2VV?=
 =?utf-8?B?ZmRVODE1dW9SYW5uZkltMklLVUZhc2VBSHJsL1Q1TkhUalZqWGNCdytKaDB4?=
 =?utf-8?B?OE45YVVVVkErYXRwS3FQSW5jb3JiLzBOd0J0WlJsSjN0ZWFsQldYODVqZ3JJ?=
 =?utf-8?B?RzBzaStlczMrbDNGaWw1YlRSdmtoblcwTVZkRnVEQTdpaVN3ZzczMXIrd0Fq?=
 =?utf-8?B?OU9mdzgycEIxWlJPV1c5VkhFYURXcG1wU0UzWE1nSlAvSkI5a0F6NThPdUNr?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e64aaef1-f90c-4997-1d91-08dd91396f71
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 09:43:22.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsrmlRppMqPyaWROF3hHWJBg6E4DolIzcxuBqth18jBmlfapTbmtuJ9zrf4Z6Z9muF52aRvVKsAGXEN4ICWNtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4787
X-OriginatorOrg: intel.com

Thanks Zhao for your review!

On 5/12/2025 4:07 PM, Zhao Liu wrote:
> [snip]
> 
>> ---
>>  include/exec/ramblock.h      |  24 +++
>>  system/meson.build           |   1 +
>>  system/ram-block-attribute.c | 282 +++++++++++++++++++++++++++++++++++
>>  3 files changed, 307 insertions(+)
>>  create mode 100644 system/ram-block-attribute.c
> 
> checkpatch.pl complains a lot about code line length:
> 
> total: 5 errors, 34 warnings, 324 lines checked

Thanks for reminder, I have adjusted indent locally and fixed most of
them but still have some warnings for the function definition like:
static uint64_t ram_block_attribute_rdm_get_min_granularity(const
RamDiscardManager *rdm, const MemoryRegion *mr). The "rdm" argument in
the same line with function name will exceed 80 width and I think it is
acceptable to keep it.

> 
>> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
>> index 0babd105c0..b8b5469db9 100644
>> --- a/include/exec/ramblock.h
>> +++ b/include/exec/ramblock.h
>> @@ -23,6 +23,10 @@
>>  #include "cpu-common.h"
>>  #include "qemu/rcu.h"
>>  #include "exec/ramlist.h"
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>> +OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass, RAM_BLOCK_ATTRIBUTE)
> 
> Could we use "OBJECT_DECLARE_SIMPLE_TYPE" here? Since I find class
> doesn't have any virtual method.

Yes, we can. Previously, I defined the state_change() method for the
class (MemoryAttributeManagerClass) [1] instead of parent
PrivateSharedManagerClass. And leave it unchanged in this version.

In next version, I will drop PrivateShareManager and revert to use
RamDiscardManager. Then, maybe I should also use
OBJECT_DECLARE_SIMPLE_TYPE and make state_change() an exported function
instead of a virtual method since no derived class for RamBlockAttribute.

[1]
https://lore.kernel.org/qemu-devel/20250310081837.13123-6-chenyi.qiang@intel.com/

> 
>>  struct RAMBlock {
>>      struct rcu_head rcu;
>> @@ -90,5 +94,25 @@ struct RAMBlock {
>>       */
>>      ram_addr_t postcopy_length;
>>  };
>> +
>> +struct RamBlockAttribute {
>> +    Object parent;
>> +
>> +    MemoryRegion *mr;
>> +
>> +    /* 1-setting of the bit represents the memory is populated (shared) */
>> +    unsigned shared_bitmap_size;
>> +    unsigned long *shared_bitmap;
>> +
>> +    QLIST_HEAD(, PrivateSharedListener) psl_list;
>> +};
>> +
>> +struct RamBlockAttributeClass {
>> +    ObjectClass parent_class;
>> +};
> 
> With OBJECT_DECLARE_SIMPLE_TYPE, this class definition is not needed.
> 
>> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr);
>> +void ram_block_attribute_unrealize(RamBlockAttribute *attr);
>> +
>>  #endif
>>  #endif
>> diff --git a/system/meson.build b/system/meson.build
>> index 4952f4b2c7..50a5a64f1c 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>    'dirtylimit.c',
>>    'dma-helpers.c',
>>    'globals.c',
>> +  'ram-block-attribute.c',
> 
> This new file is missing a MAINTAINERS entry.

It is still uncertain to me if we need to introduce a new file or add
the code in an existing one like system/physmem.c. Anyway, I can add the
MAINTAINERS entry if no objection.

> 
>>    'memory_mapping.c',
>>    'qdev-monitor.c',
>>    'qtest.c',
> 
> [snip]
> 
>> +static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
>> +{
>> +    /*
>> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
>> +     * Use the host page size as the granularity to track the memory attribute.
>> +     */
>> +    g_assert(attr && attr->mr && attr->mr->ram_block);
>> +    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
>> +    return attr->mr->ram_block->page_size;
> 
> What about using qemu_ram_pagesize() instead of accessing
> ram_block->page_size directly?

Make sense!

> 
> Additionally, maybe we can add a simple helper to get page size from
> RamBlockAttribute.

Do you mean introduce a new field page_size and related helper? That was
my first version and but suggested with current implementation
(https://lore.kernel.org/qemu-devel/b55047fd-7b73-4669-b6d2-31653064f27f@intel.com/)

> 
>> +}
>> +
> 
> [snip]
> 
>> +static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
>> +                                                      StateChangeListener *scl,
>> +                                                      MemoryRegionSection *section)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
>> +    int ret;
>> +
>> +    g_assert(section->mr == attr->mr);
>> +    scl->section = memory_region_section_new_copy(section);
>> +
>> +    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
>> +
>> +    ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
>> +                                                      ram_block_attribute_notify_shared_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
>> +                     strerror(-ret));
> 
> There will be 2 error messages: one is the above, and another is from
> ram_block_attribute_for_each_shared_section().
> 
> Could we just exit to handle this error?

Sure, will remove this message as well as the below one.

> 
>> +    }
>> +}
>> +
>> +static void ram_block_attribute_psm_unregister_listener(GenericStateManager *gsm,
>> +                                                        StateChangeListener *scl)
>> +{
>> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
>> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
>> +    int ret;
>> +
>> +    g_assert(scl->section);
>> +    g_assert(scl->section->mr == attr->mr);
>> +
>> +    ret = ram_block_attribute_for_each_shared_section(attr, scl->section, scl,
>> +                                                      ram_block_attribute_notify_private_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
>> +                     strerror(-ret));
> 
> Ditto.
> 
>> +    }
>> +
>> +    memory_region_section_free_copy(scl->section);
>> +    scl->section = NULL;
>> +    QLIST_REMOVE(psl, next);
>> +}
>> +


