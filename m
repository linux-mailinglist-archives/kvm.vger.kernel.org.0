Return-Path: <kvm+bounces-16049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 341138B3752
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 14:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF4AB285A9D
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 12:36:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923B21465A6;
	Fri, 26 Apr 2024 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jfJwXHQp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7721F3715E;
	Fri, 26 Apr 2024 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714134993; cv=fail; b=bH3/aXXRbBAxyfWaFM/s45i8geptM975jnp+IpEDHdSpiEztff4sVIcOeg+XUnChWkx3mblwgKAsbgSpa/c73qP4n5zNkrBl2QGMiLeYuGCthD6wH+tuqG4hiweIT7VqqUg5EkFJs8cN7UcgEd5qhBfa/jJ78sK1eoDycJlrKvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714134993; c=relaxed/simple;
	bh=PWwIpqdLcrC+g6E04tfjPq+uHX27JWJpgxsDQQM+yeA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pz/Tm1rXfCuSg9I3cMbn0yHnlbxNpDQZ1C2jrUNSGwAqlO9jK52aIl2Zo6tsZXuuksfGHaA65oYyl1FJHQjYRqhl7e0z6CynLIh7/nuAs1OuztdqtKUVxeK1LPpA9n7bFQHnRaK4jwOcbVwoC7i8peIUWmQofBHJPP3H08NSzug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jfJwXHQp; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714134992; x=1745670992;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PWwIpqdLcrC+g6E04tfjPq+uHX27JWJpgxsDQQM+yeA=;
  b=jfJwXHQp+ioz5r8ROJ8K74Cki+h7ezVSF0o96+MCcOhmodhOxsmLDi1b
   s3vwu1UJFOXqc6WIB4L+3hvif8XoUapSgcH68l35Dt9e8Jg6332IlrQqN
   nZlBqQpO4C5/2nBVO+GjZGxNlNztVcoCEMUnUjLffZPpHeKdhve1cXsJb
   y7t9wt5PRF+LqIQ0jaCHmOMDJ/FSnBDLWGs8EROIaf405sp2R2CYNbc5m
   io195D2dOxs6E1bpUAZs/cUezg5vTXkxNFVYq8MtfKjLB71wd2c9ku6Qn
   qPLbVN2f/s3opFTqlFRZ8Z1nnCDb+Cb5Bq6Z7koZq94SlHdO2IxPtS2xf
   Q==;
X-CSE-ConnectionGUID: P4j3NkUuTAmfqIWadCH0BQ==
X-CSE-MsgGUID: JUNN2wEdSkqA5cxtVZVY+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="10025945"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="10025945"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 05:36:30 -0700
X-CSE-ConnectionGUID: TGzAkSEFST+K8iDY1ri0Wg==
X-CSE-MsgGUID: qvjEjB5yRfeh/SKnlP1Xwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="62881986"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 05:36:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 05:36:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 05:36:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 05:36:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRdNTf2zongYRgm/bppZCXpyw6FVm+nZVCfUARBpDj0Z3UmwymVGJK0pzsQVsz5fi/DvZDT3b0Hvb1H7iFV+FQuX00KCnyoRlvoFcHZgJQkx5D1G24iZNcZC7TZeuW121J6lWMeMbJNPCk7mZln8ZmFOZ3T2ryuC985QHG5oShICI3inzPz9teplDFgNflRyoHfGZYzB6NWmqsVI0hd4CeFrjHFmNR4nPrEcIsQR1r2aJ6jsjs9ovE4/U8Sbajd5lMMnpHNBGS6a/OlFgwKTSLwEL59GwlMzK4j5ZaQXR1HTIL0xE343htmEYbi6vE3Mooom01rFG2c+FhgRatuMqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEuXf/+NrNSZYr/bgx8Z73RSip5RvHP2Tep7ca+tgNQ=;
 b=Xncu4weHIdC38p93zqOPjSfRnts65nRWNMy6n/6FoPdrrwpUvpfXwnqIrgS1E/Dt6/vjZ8e1YZGNq4rjGp7rqCM+cMWDmaTns94cwweEQqJ1TUAImgC0pkRkQM+WEummmtapHb77Y3eUzaXmvsOKsfEXKCL6OiZ6qxTfuY231mSsIqGVz74h/7oBfFni+RJ1vRdymOPMPpjlM80Euvfle/oblKdFEBcnR7j2YeVD41BgXZ9ijRTg86y3iHM+8wpI1WLpNnXwLAS3sW28tu2R4w3M0ek5o1SCUkjqElhceV9C4KWOb5YmIGxUo1eQduKf6QFZFZATUWzDMQaqAuiDYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CO1PR11MB4883.namprd11.prod.outlook.com (2603:10b6:303:9b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.23; Fri, 26 Apr
 2024 12:36:28 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 12:36:28 +0000
Message-ID: <4c0cd892-8b7c-451b-9c04-2e83f33bef0f@intel.com>
Date: Fri, 26 Apr 2024 20:36:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] KVM: x86: Suppress failures on userspace access to
 advertised, unsupported MSRs
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240425181422.3250947-1-seanjc@google.com>
 <20240425181422.3250947-10-seanjc@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240425181422.3250947-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0265.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:455::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CO1PR11MB4883:EE_
X-MS-Office365-Filtering-Correlation-Id: a6fc82aa-ae3d-4c80-58f4-08dc65ed7e0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXVQS01uRmlNS0NPUDNlMEs4WDBoOXN6WjJ3TnFpOU9sSUFXNHNWSFJJbFVa?=
 =?utf-8?B?Z1lET256U0k1MWJReFFxVnFjeGxPUmZQRXRIMFpOSkxVSDU2b0tjaXkvZnNl?=
 =?utf-8?B?dk9JQTZGNHQ2ZDNpaWtMN2EyS0ZNcGQrcmg0QVVpNGJ1c1ZpdEMxSm5BK054?=
 =?utf-8?B?aE9YZm9KcnI4a0xoYW5YSUt6UjRVTVhRbFdoZzI1VE1UUlNqZGF6WGZhaFJB?=
 =?utf-8?B?bkhiM2Z0bktlSElkUDlWcUJzMy84M1E3QWZ0QWtQdEE2WHZES09Yc2d3SUly?=
 =?utf-8?B?cms3TW1WNVlhOEV2UE5WRExGRnlqRHlpYjVSVTBCZjZGSkIxRE1BbkVkbTc4?=
 =?utf-8?B?WDhPUnhUa2VVcmJNMklNT0FoeWpTeTR4RnZBZXZaTE1FQ1pzS2UzSGl3SUZO?=
 =?utf-8?B?dEw2V29GdmVEcnhSN2pRbStIdE1LM1laM3Y3OFVBMlpYVzhXUFVEK3NENVdp?=
 =?utf-8?B?a0NSS082Mlg1S3RjbndvNkhqdlZPUWRVQktGdDUzRjhPRjh3a0o1WWpTY2pO?=
 =?utf-8?B?VEpHRkJKMEk0ajF3eHI2eHZBSEFtYk1VVmphNkRHelVyczBOZ01uYW1iTjBi?=
 =?utf-8?B?N3FSS0pTMldVRWlhclhTTFljdHBFbjJNRFBNUExpeDFsNGg0VERxNi8rcXFP?=
 =?utf-8?B?ZEY1NFh6T0F4U3RrUFBlQVNoMEREd1RZN3Z1b2ZUbDhpNlJnckJWV1lGaGN0?=
 =?utf-8?B?c1orTDRJN3dSVzdCaGt0dGpnVUFCMWZhdlhnNnV2SkxuVGR5RTF4QjRJeFl6?=
 =?utf-8?B?UGdGWmZmc1NHMlZOZDdWY2xraTFBdVdJcTh6M2MxMm14SnNTOW4zSE1QQUJ5?=
 =?utf-8?B?dG5UNHZHVWJIbTk3eVZuZWt0R0FXQnNWYWZzZ0hWaC9tNVJjM3laY2NQUE1z?=
 =?utf-8?B?MVpUTGErNmllY2FXek4zNFN1REtZRG5nS1VIYzFXZWx1ZGs1UEVEQ3gzVTNm?=
 =?utf-8?B?RVl5dEFHYW9kMXErVzhKNkIxSWd5akRFTi9KRGVwRGtIL1I4YThpMDF6MmMr?=
 =?utf-8?B?WWRIT2RoNmVtNXZXb0FQZE52L0FuNzdMYlh6ZWVlcVRRaGpGMGtwb2VPN3NJ?=
 =?utf-8?B?eHpEakdtQy9GUkEyY2R2UGpPSWQ0QUxHQmVmY3V0K20yaUdPaGJIa0ZEVHpC?=
 =?utf-8?B?Y2lUZ0ZjU05lUDlVdXVHNERQWERCTStXQWQrWElQMk9LU3VYN295a1Z3bTJ0?=
 =?utf-8?B?b0hoUnFlc3poVnhiNE1LV3ZsZ2J6S1lmUGR4VVVBUU9vcklsdlRmZ3BCMzFN?=
 =?utf-8?B?dUY0SEUyVmptN1M1RWxXdzFBSVk5YVZuSUFzZ1lUWTEzYzlOczZZNG5GZ2pQ?=
 =?utf-8?B?L1Z4MFhBOE9uRWNpUlJ2ZzhYczlvaU5pb0lTdmtTKzFsWGEyLzJXRzNQVU9E?=
 =?utf-8?B?RzE4NFUwbzNTTUR0NFNjNzByNUN2SEJjTkxYZFpGSEVXWlpsZlNqTlBQdUt3?=
 =?utf-8?B?cEFXbHZNb3JET2MwWHB4eU4rWTRXaFY2MHBtL2hOSmpWQ1Exb3ZPeGV3R3Bq?=
 =?utf-8?B?UnJXdEpYWWFkY0RDVEhXdmpNVHFVUFdMV3lQeW9PL0gvTkhRdGpZMjcza1Rx?=
 =?utf-8?B?elgxVTJ2UG56OVRPWHpCZzVpNm5ORHVXNGdJY1RWdXBabFZnMzZ4L0hTTWZL?=
 =?utf-8?B?Uk80KzZrRlp2TE1PZ1g4K28ydGtUUFJQTVJYUjlBVkkrMW5vNHM5T05RV09z?=
 =?utf-8?B?SXdqb25lZk5KclhMSEVNZnNvRzZGTTl3Vk1ldUdxNlV0czBUSXluSlhnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFlJNEhvRW4wZ2lOanVMTnJmOEladHN2d3dEOGFObHdTZlI1cERtT2krQTJP?=
 =?utf-8?B?bmRuRURmTzVZMWxSWE9VZHlUSEplR08xdDdCYVVia3lMbWt5VkdtYkwycSt1?=
 =?utf-8?B?Q2NkQUpJbDR2SVlxL05oR2d1alEyOUVTYzh1dmYwSlpDUzBLRDNmLzh0blJv?=
 =?utf-8?B?Mlh1VXhqem50bURBd2JTVHlxdzRmMUVYWkQzQlNEQnpCRDZXRkJIbStmSHZW?=
 =?utf-8?B?UzBFbUZiZ2t1QUIxL3NMMW5TYzNKTHlUeUU1VnZETGpJKzhUQ2ZNQ3FrVDVx?=
 =?utf-8?B?eC92aDVNZ2s4QlJzY0xvY01aQ1ZXWjkwUkV0UzFvekE1bERyOWZRMHVyakM1?=
 =?utf-8?B?c2ZkN3FQUDB6M2lUNm8vL1RlZitoZDZjRUsyTkJtTnFVUllOZmtkQkV6TXpU?=
 =?utf-8?B?U1J1b29iYkgxWkZFWk9VNjhZZ2pnbDBXNVRDaVJqUVZNR3dCVlJVNHpXMWtF?=
 =?utf-8?B?WE1nSGNIc1Awc2x5SXprQWFsWGVjMjRDYWZSaXF6aHZZRmNkRXJLUm81MXhp?=
 =?utf-8?B?UitQcUlXeWtoNUdNTEs5Nnp1TlNQdjdJOVVNTkFoekludzI3YjBXb2hZR3Y4?=
 =?utf-8?B?TXdZNk5WM3hhNXByb0JqK0xaWGhIUjFwOVYzRDZRakZVblZNMzJ1bHkwcmd1?=
 =?utf-8?B?RkZKNjBWTndBT1M3MzJkZThVK0ZaeGV0RHZMb0dWdXVBOExZRkVuZVNCNTk3?=
 =?utf-8?B?NWZ5ZU1OR0ZZellBTjloamZyZTJmWnNPa0wzQlI1MmZvNHFXSVRncnVRZ0pK?=
 =?utf-8?B?dy9kdEdpU3lMSUZXY0lGdE93YUFpSll3NTMvckwycWR6emN4RFRUMjBuYm9n?=
 =?utf-8?B?U2swWUVTWml6VmxPRkJxbEhDMzlDcUgrWk1xZno5d24rSTBocjNXWWhnaDV6?=
 =?utf-8?B?Tk1XRVZKaTlFcndnbTZ2bGNrdTFUcG1rSlU4SU1QTHNvSHl0RUo3Y0RzT3Ay?=
 =?utf-8?B?ZlZrSW9Xb2VmN2tSTlRZZ0tqdkdXTlg1Q1gxVDk3aGZTb2xBajFLalpndTNu?=
 =?utf-8?B?RExUMXlobDJ4Uk03amJsYnhaU3ZJK2crSi9xcE5tYlMvUVFvV3hVcWpIR0U3?=
 =?utf-8?B?dHZnUG51cGN6bDBzMHhTMFRYTU1WWWFHZW5xR29EaWxLNXVxdEQ1UzZOOEVK?=
 =?utf-8?B?dk1yT0FnV2Z1UHBKVmp0NE1TeE92TWZKbEh2WUtJU3hMSDk4bkMxQmNNdk4y?=
 =?utf-8?B?WGw0ZXdTa3pHaXNoL2cxUWt3MGdyOVU0dzgzbzJ2WC9XZmlDaG11YkxmZkZQ?=
 =?utf-8?B?Uis2VFFkKzJwSjBJeitVMHBndGZwcE5Xais0dVMreTNyVDluYWZoSW5VZlM2?=
 =?utf-8?B?M2ZLdHBka08zUWI3VTRsN1I1YSttbGNEeXZoeHBOOGF1QTNGYm9IT1Q5MXJU?=
 =?utf-8?B?SytOL01NbG9sTEVDNVAwR1ZuTklXZVdwYWE4RW9tNEFWS2pYMUhyQkRDcmUw?=
 =?utf-8?B?Ty92bHZtSGZlVmhPVkpTc2c3TDIwa0hVODVwWTNEVVQzampwOWNrYXQzbU9x?=
 =?utf-8?B?MHVuSW8rRGR5ampiSWF2cXhtVjhtTWN5WTFWbkZ4SFUxeDBKcEpvMTZrczFj?=
 =?utf-8?B?UTV5ekNGaFlNTTQyNkVBTXA3UDlMTGNWWVRJS2wvZzNndStsOGk5aUNOZWNB?=
 =?utf-8?B?NW0wVEl4cnkyNzB5c1VnQWtETkx3Yno2czM3U25raG84bzdYQ0JEc1NhaXFW?=
 =?utf-8?B?bFNxdXpnTWlmWUFyN3czU1pJNXc0blorM1FsRUZrcFlQYjh1eFZnbXVFVDlI?=
 =?utf-8?B?M0NuYnBta0JwODAyZG0vZlVoN0I0TVlHNG1rSUhQbGxZUkU3Z0JUaHBtU1lE?=
 =?utf-8?B?VHpCTW9SWmVwanhaamg2dzM4MGZGRDF5RmZZUXM3SEtFYzJGZW5ZcXdpeW1E?=
 =?utf-8?B?S0FXZytKMFBDWm9JRkpyQ25lMTRpbTEzaDFWWVBPTXRMdDFXWit5TUFQSUZM?=
 =?utf-8?B?Zm1TUC9mUjJTSnFJVis3UU5FWlk4QzY1R0crSVcxbkJTRWttL2kxekl4YnlP?=
 =?utf-8?B?Tk5EOG91Q21vb0F1b1pjUElyY1lnY2lieFBDeVpOb1JEOE5ZdkxQL1JGdmlH?=
 =?utf-8?B?aGRqblZIMlFjNDdNQW5RU3VZRm5GZDNNT1NtdUQ5SDdMMUUzZnlqaHFGQStw?=
 =?utf-8?B?Q0wvU3p6SFlxU3oxVEhYWkttQm1YMzJFK1hCcDh3MkNmOUxNUlp6ZVJTTHhn?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6fc82aa-ae3d-4c80-58f4-08dc65ed7e0a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 12:36:27.8175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHeLcDAvOhxMnayLdNuhcReRoEXPHyG4MvYXpun3BwwDsb++WC/iHU0LIQNWZeHZOOCHRfYc0Z31wrou4yAmaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4883
X-OriginatorOrg: intel.com

On 4/26/2024 2:14 AM, Sean Christopherson wrote:
> Extend KVM's suppression of failures due to a userspace access to an
> unsupported, but advertised as a "to save" MSR to all MSRs, not just those
> that happen to reach the default case statements in kvm_get_msr_common()
> and kvm_set_msr_common().  KVM's soon-to-be-established ABI is that if an
> MSR is advertised to userspace, then userspace is allowed to read the MSR,
> and write back the value that was read, i.e. why an MSR is unsupported
> doesn't change KVM's ABI.
>
> Practically speaking, this is very nearly a nop, as the only other paths
> that return KVM_MSR_RET_UNSUPPORTED are {svm,vmx}_get_feature_msr(), and
> it's unlikely, though not impossible, that userspace is using KVM_GET_MSRS
> on unsupported MSRs.
>
> The primary goal of moving the suppression to common code is to allow
> returning KVM_MSR_RET_UNSUPPORTED as appropriate throughout KVM, without
> having to manually handle the "is userspace accessing an advertised"
> waiver.  I.e. this will allow formalizing KVM's ABI without incurring a
> high maintenance cost.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 27 +++++++++------------------
>   1 file changed, 9 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 04a5ae853774..4c91189342ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -527,6 +527,15 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
>   	if (ret != KVM_MSR_RET_UNSUPPORTED)
>   		return ret;
>   
> +	/*
> +	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
> +	 * reports as to-be-saved, even if an MSR isn't fully supported.
> +	 * Simply check that @data is '0', which covers both the write '0' case
> +	 * and all reads (in which case @data is zeroed on failure; see above).
> +	 */
> +	if (host_initiated && !*data && kvm_is_msr_to_save(msr))
> +		return 0;
> +

IMHO,  it's worth to document above phrase into virt/kvm/api.rst KVM_{GET, SET}_MSRS
sections as a note because when users space reads/writes MSRs successfully, it doesn't
necessarily mean the operation really took effect. Maybe it's  just due to the fact they're
exposed in "to-be-saved" list.

>   	if (!ignore_msrs) {
>   		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
>   				      op, msr, *data);
> @@ -4163,14 +4172,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (kvm_pmu_is_valid_msr(vcpu, msr))
>   			return kvm_pmu_set_msr(vcpu, msr_info);
>   
> -		/*
> -		 * Userspace is allowed to write '0' to MSRs that KVM reports
> -		 * as to-be-saved, even if an MSRs isn't fully supported.
> -		 */
> -		if (msr_info->host_initiated && !data &&
> -		    kvm_is_msr_to_save(msr))
> -			break;
> -
>   		return KVM_MSR_RET_UNSUPPORTED;
>   	}
>   	return 0;
> @@ -4522,16 +4523,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>   			return kvm_pmu_get_msr(vcpu, msr_info);
>   
> -		/*
> -		 * Userspace is allowed to read MSRs that KVM reports as
> -		 * to-be-saved, even if an MSR isn't fully supported.
> -		 */
> -		if (msr_info->host_initiated &&
> -		    kvm_is_msr_to_save(msr_info->index)) {
> -			msr_info->data = 0;
> -			break;
> -		}
> -
>   		return KVM_MSR_RET_UNSUPPORTED;
>   	}
>   	return 0;


