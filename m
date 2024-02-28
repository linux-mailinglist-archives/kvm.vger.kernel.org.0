Return-Path: <kvm+bounces-10171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F28BB86A443
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:08:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 697FD1F260F0
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D4F1370;
	Wed, 28 Feb 2024 00:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACkyl/y6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DB7363;
	Wed, 28 Feb 2024 00:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709078898; cv=fail; b=dLvRCQl+dTEZrq31MZcYhPFdKsgEe0dBlRVvn4wiMUTJGNqrqS9KJJlHytmdzMpysSRxzCXFDn/0VX/wdQ6jOlI4u8MqM5zdHXoj/3aF/FNSrUzdJIADy2PQe6rRpWGNkDCMjJReKV6nvMo8xJ4irxv4hnrlzTEyYChgcrIDYeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709078898; c=relaxed/simple;
	bh=8o80wKlRmZjZN5JFNtZ5L8ae7OEvB8o+x6CDdY0tfhI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mjy/oRUCl+cIuw6qjZL09x1B7WBuvx1U/Q3NLWCuZKvIAEP9i9qxbXZundqvFpe1uEAuTnvziZ/MXcXQqbdJ4atBemWO8YK4DZofo5P4qnY9anJgImU5B54LtLFt9gtqNzgKxOhykV2ox6ljA9adtA/J5Qm1YFlmG7TdHrM1bbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACkyl/y6; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709078897; x=1740614897;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8o80wKlRmZjZN5JFNtZ5L8ae7OEvB8o+x6CDdY0tfhI=;
  b=ACkyl/y63zkwcMoinq18Ne7WnwPcFvlQ7YIrKJkouQDm4h/czH7DTyyV
   aGzYCwRcfGqfnYi5KxOqKtHNWElll+UUl67gujL08bUrXzVSfqqLjyRXA
   8Ye3r/0Bkhne6yLCWjSNFjtevN6X9ElIuXmravkbQNwlVcK/wrT1+lrBL
   SEHe4gMam4YW7xrzOZWLOdkDNhvKG5eGP3rPsvjY/jpEzhftUEDXKLPgc
   B/xKEtoohJlUXLpNWEBW32LmWd78Jg0dWpjtVzs4obKlYbFxHNvBUmCtC
   H4VvnashTX/9qk24bwsY511LG2KES1W+ySCSMNanqRzP3vNjef5RsbU2j
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14877510"
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="14877510"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 16:08:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="38046323"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Feb 2024 16:08:15 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 16:08:14 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 16:08:13 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 27 Feb 2024 16:08:13 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 16:08:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWkDTwQWHxjTa2ZWCsFGHeFwbAW+5PZVF+jZ65qaHB++uSSWyL0BfIelyHrSlA3QYauGKbppYFns1OYxcb3ShYyh3nVHopkk0fkc7dbH5t+dFzWtoU0JWJUyaCcl9Ra9A5xmD29QG1U61nNWoPR3DbisKxWLiVfp8faES2mE8jOTfJ3WkMivyYCpbqet31+tQk9OgwIJ4jy+LU/poesuj7xu4tdFQ9F0HnC1BW6HeAH4sBBKYu/8LsFCOAvViWpA+VR5BeKE7/dIyCT0b8AjsAoy6qIzaDc1TFH2yw6qsP0rdbgYC0wovbqgEP/evqn9LmTl6jRVvhLKridTTcqz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uU9J8LmWVpf2nA3mIT2bpooYFR7uBwAXNmXNQPC+bMs=;
 b=YBZlNMGQPHm7/uc14dKgFz1xxLtF0UDGnblUoeW+8pmolwC2I7nWq0lL2SssAYcX7f3ith87xDkxyiMKhBOcpuayQ9WwOd+pc6vX2lQuTIejHzPNqJLFXgezTEPycOyPP0ZEbr2QD2rKvGv1JhpUSe3IMFmAfQHay6Y8Obur5igJi+K1RTai+Oo5MEGGT96xccWuT9WKZSW0nM8nAdNYIR66B0H/YBBpDi/kA32/d9A3+AM5efrzSr7rU+97c/s0xHxAGNVb0Oe8jwyPw5r0+xRGtMEXkw+gMLY5Y8J3z2uZEJ15kLgtxJpxToqJJkEqLyZT5YsbaKvk6JCx2NQK5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by DM4PR11MB5311.namprd11.prod.outlook.com (2603:10b6:5:392::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.23; Wed, 28 Feb
 2024 00:08:11 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7339.022; Wed, 28 Feb 2024
 00:08:11 +0000
Message-ID: <3da6b6a5-dc66-47b7-b824-84e418695882@intel.com>
Date: Wed, 28 Feb 2024 08:07:28 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or
 TME
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Zixi Chen
	<zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, "Kirill A .
 Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@kernel.org>, <x86@kernel.org>, <stable@vger.kernel.org>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
 <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
 <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
 <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
 <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
 <7e118d89-3b7a-4e13-b3de-2acfbf712ad5@intel.com>
 <3807c397-2eef-4f1d-ae85-4259f061f08e@intel.com>
 <eff34df2-fdc1-4ee0-bb8d-90da386b7cb6@intel.com>
 <97b66d4d-f520-46c9-8164-ce5b2e4d5642@intel.com>
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <97b66d4d-f520-46c9-8164-ce5b2e4d5642@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|DM4PR11MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: e2e84167-76dd-44aa-0cfb-08dc37f15993
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qybu74Vz3dQRh/4XvI4wy0OvTH0GUzGZYbWpU7YHG5JK/IW7pDQ4BsMfxdlmT+iw9HO4Nl/ORljeG962FmSQ/L9NqwGL+DSg/sMhbv9PTSH93Y0S7BEhtKwmV58ImUD0cmb38R/mwGGbz3UfMJUopT0TCTgNlm1l5KA28hb3w3qqcRNsyrNbu89G2Zi1F9VvSlQ+7jNEl8dzuFMH62aKV/PwAtXFbExkQhuXBL64O0kMp0ZLfQ8QOCQDEyxk5qmtv1LlaLImkgIL0WQD8mBLs4rMfmMrr1puhxv2cysPZdG2aH7dXNc/dc1DhsjUx19CljvXRSzBUG+nT8h5xuiX6ku6WH5PCQiLJ+kpnycQiaC0frzYGubHYj/P2ttGjODnKSv/h8UrBkPCRWobHCJzumKlgUSFiDvnprvua6lmmbjVGaZiHGC5RLdKNt0WO0pj3iqKL2/ZR5EG9Tr397aU2LjsMCylIwh1JbyZVeq8519EX3l4fefBzyXdHY8LvYMFZ8GSG3rpi+/qJtdhSYzCxv01obe/ZJCRizRD660IZzSYa9gRQ+gg4CVxZee36Alf5cfsCW04BxCYgjo2Gwm0Q9BPKYU8k4l/P3IyA4WNnjKJta9cbgBlcdk56ixjOx1x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXFjVHlWZnlpSHNaSUkzR3g1cGU5SUUzam8wSm9Gaml6M3F4c3pEem1qVzlQ?=
 =?utf-8?B?Zy9QLzkyQkRrNGtLdkJUSEhyV0oxWFk5VFVaQXN1UHByQnd1SkpTNUkxR3ZV?=
 =?utf-8?B?ZktKYzhwUkI0VG13SXBHOUlCVGM2Q3o0Ym15eDkzK0dBTW5FSWdUT1ovWWkx?=
 =?utf-8?B?VXhRZEh6NjRYb01yLytlYTMrRnp2ZndYYTBlYzdxVzcvYjBEdHFTVWFiR2hP?=
 =?utf-8?B?SHprRVFjYk4yTXg5Y0pQelNZVnBDdjdlRWZPZERSOHY4c1daZkhyMjdqVzJz?=
 =?utf-8?B?OFBKQTBKYVRmdFl1bTArL3diaXJCa0FKNWcxMXAxaldmMjZpRU1za0FvUUI0?=
 =?utf-8?B?VHFST3N0KytFRERWQ1NjajNQYmdKZCtVMlRYSTRNOTY2VDd5TEhwVjdvY1p3?=
 =?utf-8?B?Uk1teGlOSC91MEFRdm9UTjh0Y0xNOGNGNysrUk1hNFl2WnBFdjhJU3YrUUlm?=
 =?utf-8?B?S2lxR1VnZExiaFZYS1NOWlpZRDdSNmpRbGJqVGVzcFR0d1ZnTnZjYnBnSXpz?=
 =?utf-8?B?bW90aWJBbWNCaDVDRmtScmlOQThINUNpTjdReXRUcGNVRU1iK3ppK0IyNW9l?=
 =?utf-8?B?eUF0TDI0YVVmNmI1eFRKVFR2Vm94OUZFU3lBWkQybU5RaVZCaWtPakJxL1Nh?=
 =?utf-8?B?YlM4NzdYcXJGTHcrdVU2SWhubDNrS1NSaFZqUTlQZWdoWTVmUTJTcXAwWFo3?=
 =?utf-8?B?QldLQ1NWZm5uVXQwL2p4ZU1EZVowRjRLeUFGSDRyT3ZNVVpmcVkrZE5BQ2kw?=
 =?utf-8?B?QzRCSTl5UmdydDFGUWxweTByc1VWby9YOW5MREZ6RHN3K0VnalREeFpLaGlC?=
 =?utf-8?B?bTdoNytvcHpxaEtWU1BFeWk0bi9YWm1zdW5kTi9yRVhqdUpLb0Y1VFFOQXBi?=
 =?utf-8?B?MGh5bDJIeWdtNTN6NVJQOHpwaVF0TnFnVlNmQUJ3QXY2aUtqT1FTRXJMWmVN?=
 =?utf-8?B?SVZ1akVCL2pOS291WitYd2oxZi9qMkNyTm82b1dIMU9yaklPY29TQWRpME5J?=
 =?utf-8?B?Z0lFOHJrWXhPM0RnTmVWTGlrKzZRTmxFMzR2bXNMWGxaUkdaRllMbSs2cytx?=
 =?utf-8?B?YXFmUUFqNFNoajZrOXJQNFBqSFMzb2JiNnJ1bTYxT2FDeDc4UGdaNUwyQzZi?=
 =?utf-8?B?YVlwcTVFczF3TlZuV1N1MnNNSGcwcktJR2JXeVJQTXdjN25VZ3dTVkt2RTQ1?=
 =?utf-8?B?K0pMaTNScEFZTmZCMUZmZlBoUlo4Si9MMkkzUGlxb2N4R24xU2tGTFEwdHBs?=
 =?utf-8?B?YmM5M1RCb3FDUzdHQlJuMmJmc1hValB6NW15T3Vob0JMRUZsWGozbEFpM1dj?=
 =?utf-8?B?VTR4WlozSWV0M0JRMGNhVXlZc1A5aEYyZWpyaU5KZENEK01rQ3hOZVBDMXF3?=
 =?utf-8?B?TUdqQ0JKZWxacTJTYSs0elZNNXZ6ZkVvQ01MSnhZeE9MVTIrZGZ2Uk9nVU4y?=
 =?utf-8?B?cDB3VkhISDFhWkY2Q1lyKzlDeUMva3MwM05mZ3ZrK05LdEZFU2tNZzkrZVdv?=
 =?utf-8?B?eWpodXNnQi9SaEw5TVl1SVRvVHE5YTEzM29pTzA0MlViOHNIakI4RWJZZ0ZQ?=
 =?utf-8?B?ekc5MDRxcnBYOU81eVJWbTkxZSthYXNqSEExaFlFbEpDcm1vOWE5MG5vbmkv?=
 =?utf-8?B?NWIxVm13ckZLY1FqY00zZXVrK1NobElDZko5QWkzZUxNRW03bElwcWxTcWlK?=
 =?utf-8?B?QU1ZZlA0aVlsTHNKSWRCbGdHQ3lmRks0VDdUWFErS3VxazNVK3ZBcGN4c3Zl?=
 =?utf-8?B?WjkwZHBKaCtPd052NXJiSzVwSWVLcHN2U3JmWGMxQnkwVC9mQUFFaWgrYytm?=
 =?utf-8?B?SllsQnltcUZyM29HZnREZDNRUGZmNTlkcjhpS3JLRUkrdEszeUtseWtlUFhE?=
 =?utf-8?B?czJqUXVGNm0zazF5S0tSdDczQiswOWVJMHRORzlYVXNkbElCb2dVTmR3RlVY?=
 =?utf-8?B?RHpRWk5nUEs5ckQvSUhlVnQ3bndhT3FreEhjREZRNkFXc01Ob2l2M2Y4T3Aw?=
 =?utf-8?B?dW1mMzhSdWtnd2VieCtYQmxIdlFhc1lvY0krOEdHUzFBYjd6c0xUUnY4NVcy?=
 =?utf-8?B?dEdENmR1c0NSQ1crVFAvd3YrNUhvRWRHR2xQblRpOUlvY0p0cDhxRk0wQmQz?=
 =?utf-8?B?VjRFSkNWNWlXUmgwbW1PMGl5c0Q3OTBiS3laOEV5eWdmaXFRWEJ0UzRCc3Vk?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e84167-76dd-44aa-0cfb-08dc37f15993
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 00:08:11.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: axibIoY6jz9SxtunwcowezpPDHB/bhJpde+V6Jwy/YTS0Nq8+yw8yh1G4RIJzboF8YNDPryy1WAqELpfqhHOvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5311
X-OriginatorOrg: intel.com



On 2/27/24 21:30, Dave Hansen wrote:
> On 2/26/24 22:08, Yin Fengwei wrote:
>>>> https://lore.kernel.org/all/20240222183926.517AFCD2@davehans-spike.ostc.intel.com/
>>> If it _also_ fixes the problem, it'll be a strong indication that it's
>>> the right long-term approach.
>> I tried your patchset on a Sapphire machine which is the only one broken machine
>> I can access today. The base commit is 45ec2f5f6ed3 from the latest linus tree.
>>
>> Without your patchset, the system boot hang.
>> With your patchset, the system boot successfully.
> 
> Yay!  Thanks for testing.
My pleasure.


Regards
Yin, Fengwei


