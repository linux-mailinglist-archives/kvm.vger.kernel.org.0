Return-Path: <kvm+bounces-24941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E2E95D626
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 21:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 252EC1F24397
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F941925B2;
	Fri, 23 Aug 2024 19:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YzS4yRfb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B67E12D20D;
	Fri, 23 Aug 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724442060; cv=fail; b=MTl369HLk4cVjaJmv+sfAoLgd1Wsi2kSlloLq/e1asZsramjmpLyOLlCFt0SJptnvX4JZBXwwhgYcIYbDN174ZQU0GhA6BN42aRZzA53C3aLXWunl49WQ9Sj3tgXhbbulgWo0Bv82qRc+fPXgzcN7oNQGFU/CCoSG5/vrKAxbTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724442060; c=relaxed/simple;
	bh=GngcqLJ6ayuhU2N6c5h90ilPcHmPRh9KUxTFr2v9XaM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nxnmE/ufGlQw91t81ChVUeYS1emsW8tSSEIGNyrqO+lqKSGLNsOfNF5lW46d+amxu13cXYryrxmK7sV6+rOtjLUHZSKJWIrDrmUyS2NturCzDH2wMDHsKUGUy6hZuMY3+c+mKMEyROlsnyADMiL6+Nqw5Ekxw2TLZmFsA3WVgOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YzS4yRfb; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZPGy45Zgkj6bN0NcFTKDCg6G0eEhQ06rLZia2TBcw5tDifYoh6usahyjdSqxc7hLz75LBl5SPM2P3pJRKNI2K31usQNdnWlUoMrFgUazzg+74YFiqeMHetf0tyBJcNCOtCCOVFFbvTKKCZThEP+5BLcakHTxn/4XNkfCbaZXBI42r0e6TkR6VyOrQuYMKW0BWU57eVcq1tsBih1/I4a+B7Fai1fxKnaCNEeWCHv5wKXExuA7cnoWuBGkDmY8/0sGaRgwUDe84UKs8H5YBQf630O1jADTm4KoxlD34Xr3nzbn55rU2TJ5sxzyUlvnWd3+A6wyia3jRFfzjcG1EIItMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Md4gjKXogjPB1jRaaKFRtX3JADgRO1+Y5CgMEQZBQ4=;
 b=MvwBKgvHPuGYO/xre8n3ndAhgbC/6Fm9WfiI0KznVEPye/hPLGSwdSONHh89EAQsxsKDgi3Sa1/RYpggmrXQnFVnjMkrYmsdPmCWwvmUGvdtSiYn1w7hl3Ks9fTkuqXBnkb44WeZUlHWyofBTRTHIGnGi9hyvyFrBeGylcPkmKYpJZUDbxegCmc/kvM2oHhrY2Mxxo/Of+MHQPVqiV62GNwkSghtsWFuoPAbrP7VOQy45sghQBjnQQmPXMYGfmBZy1xazL6zQslWyqh9tWKLedwjA38T8a31sD7PBpx6m7hzzB4WPhSMiDhIoLzMiXf5Gzu2/q7gSRHo0B7y2imCqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Md4gjKXogjPB1jRaaKFRtX3JADgRO1+Y5CgMEQZBQ4=;
 b=YzS4yRfb+kjJXfnRZTyqiwv+Paq2X4JXyIGXXNu96RJIVY3gIUVgLKAV+P4J91aFACdLkmNNAJIXMazXrTcusngmZCsEtex/LV/20qKXLbKWB2pvKtCuM0axemTX6Sc1m/vESSCWZpDdWRn5Hqul/rSAU/HEDmvSoD7RDijJKd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB4280.namprd12.prod.outlook.com (2603:10b6:610:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Fri, 23 Aug
 2024 19:40:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 19:40:55 +0000
Message-ID: <26e72673-350c-a02d-7b77-ebfd42612ae6@amd.com>
Date: Fri, 23 Aug 2024 14:40:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's
 IBPB
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sandipan Das <sandipan.das@amd.com>,
 Kai Huang <kai.huang@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
References: <20240823185323.2563194-1-jmattson@google.com>
 <20240823185323.2563194-5-jmattson@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240823185323.2563194-5-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0012.namprd21.prod.outlook.com
 (2603:10b6:805:106::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB4280:EE_
X-MS-Office365-Filtering-Correlation-Id: 176934ac-994b-457f-7c3d-08dcc3ab813b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVpSWlB0SXg2cjBDbE1WcUl6d1ErTFMvaWtIK1FaL2k0MWppUXJDWnFDMmRC?=
 =?utf-8?B?ZU5uRWhrSTBnbDJWVGhPdnAwdFRuRm5HWTYrMlR3VkRWY1ZYL0xGbHNjY3hr?=
 =?utf-8?B?bW5ycU9IeUo4ejl2QXZVV1Y0VENudlNHa1NveEgyN1hQRGlWZG53cnNPL1A3?=
 =?utf-8?B?ejRuaTNsaTMxcjNTOWFIRWg4d1Bnc3IxYXptYnR4ZmdVWUI1VEVabmhvYUpq?=
 =?utf-8?B?YldJeVVmWXl2M2lNRHo0YmNPNHhMRStnVm1nZjVEKzhqaG5oZFBTK2RsMFox?=
 =?utf-8?B?RW9iRkR0bG9icWV0QlY1cDFIWi9jYlkwN2VqWGVCL2NROFJidHNHVVlwVDF4?=
 =?utf-8?B?MkhWaXkwZlF1QUYrcUlBSVQ5VVZUeGhvZ3lBMENkd1d2L2ZNNU9uQ0F3djBo?=
 =?utf-8?B?MzNqK0hUc0lLUXJxaGEybHpJUDV1WmlxcGNPQmY3Qy9RR3FRQUlPbXVwYmY3?=
 =?utf-8?B?NGQxQU9pNzN2eDJNamhCRXF3VnJZRjZzR3JaaTJwdlJEMS9HQll5dWhMV09R?=
 =?utf-8?B?RUkxdEdLZTJMNzA4bS9iZjlrb0VuaXNFUW1KRWoveG1QZWZ1d0NyUjZHS1Fy?=
 =?utf-8?B?bTVmeHdScjFCQThGZGJtaVlEaXhzNVdVTjVhaEFLaUI4ZnhOV0ZVeW1JQVQv?=
 =?utf-8?B?c3BwbUtKOXdULzF2dU1YVWVYZUN0Ny9CdENoamVrV2JMNU11ZldVbGRHaXlP?=
 =?utf-8?B?L0x0cnlPUXY4bFV0bTMxKzBiZndBakpFUlJScnBEQWErL2FtTGxkeXV2MmFy?=
 =?utf-8?B?NXlrbUViQy9EZEIxeWVBNVV6bVYwWWdVdUZuZGxDdHJ6aXJWRndWNnBTclI3?=
 =?utf-8?B?eWVWTTlrMWVGR0pKbzQ4UnhaSUV0Q3NJQnhFVXR4SlYrL0VhbGpHUGlFNmY4?=
 =?utf-8?B?anpBRHpSQWg3ZnZlTjVJajZIOGsxRkJVQ1QyaURZV2tENUNJQVg5cy9jK0Vn?=
 =?utf-8?B?RndwZ3JIWjA1Ui9Ua0VrT3lydTVtOTdIN1JlQzZLNVN1dk5GaEN6MzBwU2hL?=
 =?utf-8?B?TzdYOVJJMG5LOHgvbnRwWmRBYlc5UVN0VExHQmJ6WEt6bC93a1ViOEh1dHBC?=
 =?utf-8?B?OGs5OUx5RGZ2Sm94SEUrRzFiNm8rUEcwQjJOSzNGS2xhQUtWV3NGYzRmNTRM?=
 =?utf-8?B?VWF5TjVYOW54MlhOUmt0SE9RdCtYSXlQWUE2dldMOW90RTB2WWZBRjBFRXZh?=
 =?utf-8?B?NEs4Sm12NnRiU21HTGd5SUZOdlpQSVRXaFZsSnQ2RmJvc0NjeWJ2QkFHQW90?=
 =?utf-8?B?Y0J0ejVPT1puaXYra25MeDhTRnNxdW50ZlNFb2x4Nk1kK3JRT1R3RXMrbjh0?=
 =?utf-8?B?UmtlNTloU25MQTVFRGw3Rk5LOVNFR2hnYTY2Wm5IdFM4Y25mRytkbmtMUGtC?=
 =?utf-8?B?TnFKVWl1eFR4UmwzbFo3bFNkd3BLaVZQTmtmVzM5S3k3SWUzTFdzVm1ZSFR2?=
 =?utf-8?B?WVJ6SVo0Ky8ySVVCbnBjVndmOHJLNS9TZlN3T090U0FXYVJNWDBjaXBTOW80?=
 =?utf-8?B?dEY3YlorWlFGRlVvaTNWWW5Cc3FsT0hWSHhqSHVaRDFDTTFacUZMU1lYdmZt?=
 =?utf-8?B?UlBDQ0FHeTN6T3NFRWNsL2QvWmlYZHd2ZlBOeVV6T2dCakoxbmgyTkIxU3RY?=
 =?utf-8?B?aGU0Szd2UE93MHA0SmllcFlibDFOL2QvbHZsMGdDMjB2MGtnRmdCTXJrVUk2?=
 =?utf-8?B?alBubkR6NU94a1dibHBKc2hmVUNaN2dOSGJhTXRvL2VUL3MzUlB2WWsySE9x?=
 =?utf-8?B?R21QRkRETEwwRlpQWFhnMU0wQkRxa3ZYdURoQ3p6ZjNQMFlVSVUyTndKQzdD?=
 =?utf-8?Q?DTi7be6/TF+RWTa0zf9BhnQLH2QDMXVtf/i3o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3NrNnYvRm1wZ2NaZ25TM3dXMWVCTEtkcTFsNDZvY2Z5bC82eE0zMW9wQnpk?=
 =?utf-8?B?VW4xVFVUYnFhL1JwL0RPZnhKbm00Z3UzcFR1LzEyWjV0TmlIWEtsQVZaRXhx?=
 =?utf-8?B?R2pabm5aR0EvOUp4RGJkeXZoVWpxSGVOSjNGUTdvbitZY1BRQ0VsQkNrb25n?=
 =?utf-8?B?LzZ1NEIrT2VYZHRMU202UVZqRkpkSm1IaGNLQnVDWHRNdG0rS0hxcmd5MHRH?=
 =?utf-8?B?Zzc5ZGxwZzlVendub1RqWWhsZUJnb0xGZUdZMHp4V1UvRzhjemNOb25Cb0ZY?=
 =?utf-8?B?Zk9PdkJwaDErajhGczZYcFl6Uk1yZWUzZ0tyLzlxeVE1ZjZvb2w4MEsrOWlu?=
 =?utf-8?B?ZzFDSU5vbDVRdVlHbmtUZHk0eG1OemVCOEMzeTRLL1ZnM1pVWis1OVpKRzVr?=
 =?utf-8?B?TVZIZk9rY3dzYVk3cXF1dXk5MHFPYnVrTTRxSUh4VjVlQUw1QnFHRGdIMWl2?=
 =?utf-8?B?UmJBZGVUQ2NJMXZYQStHZC95Z0dzZXpmNTRFdlN3VFZpaXVtZTI4UVM1VEt5?=
 =?utf-8?B?aEFRUmh0NVFSZWZRMFdseXkrblg0U3JuRWZIL3hzTDA0LzcxajExR1FmeEl1?=
 =?utf-8?B?QURvcXNPcjA0eTdrV3BDaUhtMFR3SWFRQWNUTXBhV2NRWkROZ1c1VUNjYjMv?=
 =?utf-8?B?VGIyK3VwWnpZbXM5WHM5OXZkdlU4UC82QzhQRGprSDJ1c0hmNWUrdCtEWmli?=
 =?utf-8?B?M0JZK29EcWhIdzNDcUF4RUNvZDRDckh3MXJmb0V4a0pqQThOenc5NUJaQTE4?=
 =?utf-8?B?Q0FpeHdKQjRTMVpIaXdpMCtaVU1hL2hFeVdxT1p2U2pqOHBuOThRZEV4d3E2?=
 =?utf-8?B?MXJiSGVlZXA4SHVZREVFcU1GdmZUYWc2VEJMVFNmVFR6cHQyOVJIbkRvc2VX?=
 =?utf-8?B?RmhDVXh0bExIK3BMYU9IODl2Wjd5MjFMWTRXT3BhRVpRcUo1UURNdTA2aGZj?=
 =?utf-8?B?SEc3cndRL2ZaMjRXSlllK3AvcE1YMVdKWVlQVGlpMUhEeDl4QVE3S3p2ZjBI?=
 =?utf-8?B?MjRLYUlrWXRWbkw5S3JxZHZqWXJ3ZEJnalg3V0xlOHNWMHRmbVFsemthTWRh?=
 =?utf-8?B?Z0RxVUM1OUxnVDlzWmY0ZmdWTHYzbE5oVCsyM2hVWG5IVHI3VDdJY2hFZytV?=
 =?utf-8?B?dFpCQlpWMjhnLzYrdEtnT21PdjVIbFh0ckxyTEVBZWZtN2VUUC9OWDU0ZC9a?=
 =?utf-8?B?VDI3ZGo5NE9sdVB5SDFCSDFnb041dXZ1OFo0WGxlK3FrdlFxVzJCRTZOb1Iw?=
 =?utf-8?B?RzFyc2dLVVhnRksyVFNXT3Y5QWlsS0w5L2hyZCs3M3ZweDBYNHBGTzFSNUFU?=
 =?utf-8?B?dGN4Rk15WXlVVU4wbllzV3BwaE15ZjFqN1ZPZ3VDNEM1czE0dUZYWFNDVmZn?=
 =?utf-8?B?azgyRmdDUjVDODBVdXF5Y00rWFJGUDJVSFBkVXU0YTlWWHcvVURkS1JvM0RD?=
 =?utf-8?B?NHFlU256bGIrNWR5RFFkV3YrRUttK3drQmo0cnNKQzNUcVVDZGNOUHROWEw2?=
 =?utf-8?B?dW5kcVNmdmtwM3Q0RUJjVTBYV2FodVRCdXMydWZrZzVuOGtJV3lBVVpETmlQ?=
 =?utf-8?B?Vko1S2JPV2NOcUpQUVV4T2kwME53QmJPNG1jbjdTa2poYVNMREFydnpGaEQ5?=
 =?utf-8?B?SXVFdnpldWdJeFBQbEVQWjlrZnN5V3pJRzZ0OTAvaldsakZJZWpkb2hmQm9K?=
 =?utf-8?B?NVNqMGJTak5NazQ4Q29IaXNvVjE1OUxwWVp5K3VPUGpLdjNxRHB1UGZmdEpZ?=
 =?utf-8?B?aUVwcE0ya0dnWlRFT2dDM1h4SUIvbTdDakw4cXVhc21XM29JdzhxSkhVRFQ1?=
 =?utf-8?B?OGxPUnhMRzdkTnp0dmROamZyWVdmV1NRc0YwTDlJN1QzT1J3TDd6L2hYc0gz?=
 =?utf-8?B?QzZJYUtPRXAwT0ZNdUh6QVlmV08vRTYzdHpKZ1dIS0MyNGlGTG5PUnpCS3Y2?=
 =?utf-8?B?Mmhkci94SERJZzVERytXQ2Z3aDZpRVJ6RllzSUZqdHJ0U0xDMktwcHdDNHpP?=
 =?utf-8?B?dmNZUUdlaEZ0MzRFMHgybnIxZ0NaVGNkNlB5NEhpN1FWS1JQRmVGUzQ4a3NR?=
 =?utf-8?B?NFRpWFVZaElXdnJWZzJlRVFoYkdiSGM2TEh2STFlN3Z5VkdYQU1Obnp5dTFD?=
 =?utf-8?Q?S+v25j/CntpFP98wafSy7Pfwf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176934ac-994b-457f-7c3d-08dcc3ab813b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 19:40:55.6115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXTj25JYV3XdmOav2bFx1JxuGqQnok9UywqHC1BsJ3Dof9vnUyzevrH+D8T0fT566fnJ1ZdZgjv4D9S1R7amIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4280

On 8/23/24 13:53, Jim Mattson wrote:
> From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
> enumerates support for indirect branch restricted speculation (IBRS)
> and the indirect branch predictor barrier (IBPB)." Further, from [2],
> "Software that executed before the IBPB command cannot control the
> predicted targets of indirect branches (4) executed after the command
> on the same logical processor," where footnote 4 reads, "Note that
> indirect branches include near call indirect, near jump indirect and
> near return instructions. Because it includes near returns, it follows
> that **RSB entries created before an IBPB command cannot control the
> predicted targets of returns executed after the command on the same
> logical processor.**" [emphasis mine]
> 
> On the other hand, AMD's IBPB "may not prevent return branch
> predictions from being specified by pre-IBPB branch targets" [3].
> 
> However, some AMD processors have an "enhanced IBPB" [terminology
> mine] which does clear the return address predictor. This feature is
> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
> 
> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CPUID
> accordingly.
> 
> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
> [2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
> [3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html
> [4] https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf
> 
> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ec7b2ca3b4d3..c8d7d928ffc7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
>  	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
>  
> -	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> +	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> +	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
> +	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>  	if (boot_cpu_has(X86_FEATURE_STIBP))
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> @@ -759,6 +761,8 @@ void kvm_set_cpu_caps(void)
>  	 * arch/x86/kernel/cpu/bugs.c is kind enough to
>  	 * record that in cpufeatures so use them.
>  	 */
> +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);

If SPEC_CTRL is set, then IBPB is set, so you can't have AMD_IBPB_RET
without AMD_IBPB, but it just looks odd seeing them set with separate
checks with no relationship dependency for AMD_IBPB_RET on AMD_IBPB.
That's just me, though, not worth a v4 unless others feel the same.

Thanks,
Tom

>  	if (boot_cpu_has(X86_FEATURE_IBPB))
>  		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
>  	if (boot_cpu_has(X86_FEATURE_IBRS))

