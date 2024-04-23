Return-Path: <kvm+bounces-15669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BEB8AE9D8
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FC7E1F2262D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A9313AD36;
	Tue, 23 Apr 2024 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mpMbqhqU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D84513BAE7;
	Tue, 23 Apr 2024 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713883697; cv=fail; b=tGYvUHErAdECehOjFxHX4kFCUF2dHmDlJPWe+Zr93OzAaypQt6TR4mpzwikzdHe3oIuXDHOYYsnmRN7qxVPImCAszcvJddhQaX90HQp+8NCZ3kGjxm6FaYnK/87/BXkDscV19C676iu3szz+f8m8QgUxdzbOToBVeDPIyTPsLe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713883697; c=relaxed/simple;
	bh=hdJ4SbkJZQSDFGHMwU99ihvVr60Efp3UWpBvjnCEIkU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J5ruB/o88SZYbudZOfMlyL8R3cYwToCLTZAEqsOxSTKGbY3/xqYAXWEWWDedM61Y70TP14nzAdwYCQvcOW1mLgdPq+bKokYKWpGi+KPwtbTSXEV9BVB6VSuIshhTY5F+H269UdoNT2TxcMU8Na5t8+3vBMOByl9RMUTENRp/20M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mpMbqhqU; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713883696; x=1745419696;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hdJ4SbkJZQSDFGHMwU99ihvVr60Efp3UWpBvjnCEIkU=;
  b=mpMbqhqUbaOF4HajhO9Bgh4vx7DALDqp+5qgA28+Kg07j0UFnpVGo06N
   1Fa0RSLd0Hmk9tyHahf3qZ6N0OVBah/vgof1WgTX8lEXWW88/zST1DQu8
   b8ok751o3nZ2vBCh73fhcD9iAK1H76C9W0cRrOlnXjbZHLFA+4ceHxJ3q
   NeLb2mV/hMm3SGMUPqtCAr/LzLyJI0WuQ2hu1Zwuo0Ngeh1KcjlH17bpr
   rLJKF0e1Q44EhBT4f3ynrRF/uCt7T3QZiHNfl7VeJeWAOZwbpZu+0Kh77
   xrAUN27Yins5gHOzH1hlasP1nsHqPMTW3IZKzZwSjkeLv83XgY/lqZpEW
   A==;
X-CSE-ConnectionGUID: XifeswzwSlmbzNg8sjof9g==
X-CSE-MsgGUID: W2yb+2luQZ2TWG6HXOBUHg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9641396"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9641396"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 07:48:15 -0700
X-CSE-ConnectionGUID: UbnZuvU2RPmhWXZXO3tyVw==
X-CSE-MsgGUID: GXbvz2hJS4azojwfZo9FOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24442360"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 07:48:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 07:48:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 07:48:14 -0700
Received: from outbound.mail.protection.outlook.com (104.47.59.169) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 07:48:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5QU1sc8kNNZRjb/QAvgaQdE5bEGwE+3aRWMjnr6L4DGV6mQ+OYlzeo4z4TFUuHs7KWI6RvabkGmo/Bw2V/Evemto5KUxgqhg+DOm6U4aiqIS1zPtOBiN2blYFclF8c7A1pVu+uSOHTATVJmhaPeGBtP2weg3ZWYlRamK/NJJoEpsiOBXbyDL1FIfbcC+j6hVQTkjJc2IaN2WGyrN5QzfbUMkQyRZdzVch35Y7R/VbHWt62+DqJonzpzt+mG39XtZv08mzXkpGcJ/M9s3EFCe+SyRVxYAsmZOkozVY0FIXUNOKnqaaadpSB6N3CXJ94mq2ZBPJHJm2ld7eY3W4beRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVKa8LHVVnQMnP2iyGw487qPIM4N8vVaM1hlJ6FNyyo=;
 b=HTyTK+fTwsyjVS2H0k1xFfM0f34vpcAZxffdsG0gwryU9KoLb4UBN9ghgDfWyqDeHPt12w0ZBjpUQsCh+GIadDNHFhC6hBJsBoDB9JgWPLn+eCzbnEojf5HTHmHmEXIfVYRrciTJ1ABiTjdbJGBxug49QwZIorEIMCnPLI8ZHi48FVg4mGXT/SOUZ3oCtd+mlH3vkLVuQd8NTxepPBsIB1xvA8IEXZafbeq3xLYuftboNqBrgYbmOCBwmI/VCngLrReNVw436hOUuuTlYrsr3OEWJzO4V0FPyjv+lkA8ZNLyXL/EcbpM9V4TZc9TeniTfPdaWzxMnp5xkMy9Z09t/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8255.namprd11.prod.outlook.com (2603:10b6:806:252::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Tue, 23 Apr
 2024 14:48:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7519.020; Tue, 23 Apr 2024
 14:48:10 +0000
Message-ID: <2be6c0e6-416e-484f-9fa1-c4cb12486bbc@intel.com>
Date: Tue, 23 Apr 2024 07:48:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
To: Binbin Wu <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
 <7d19f693-d8e9-4a9d-8cfa-3ec9c388622f@intel.com>
 <fe9cec78-36ee-4a20-81df-ec837a45f69f@linux.intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <fe9cec78-36ee-4a20-81df-ec837a45f69f@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0302.namprd03.prod.outlook.com
 (2603:10b6:303:dd::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ab931a3-1467-4481-7de4-08dc63a4653c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VThuVk5RbCtkME85YS8vTWtjUkxwRzZ6OUpmQzRkK2tZWFZ0ZFdhdDJxUkdN?=
 =?utf-8?B?V1hzTW1tVGNZZlFSUXBNMWFXYjkzM2FjZU1vam1WV1RicWlqU01mTXE0M0JE?=
 =?utf-8?B?Ni81QU54ZHJtWGtKRkJtQzE1ZTF0Ty9WYjFXMlZBMU9YbXJuQ1ZoSlVHWGQw?=
 =?utf-8?B?YnlHRzg2MnF1TytUY0srZEZIUC82N2RIMzgyT2FEZ3lYa3MwdnBUbDJjVW1h?=
 =?utf-8?B?VWpXZGlPbjNlMEcxWktVcjhJWWN6enZEeEwyZERHdFIxUi9YYXFBa2tBazVM?=
 =?utf-8?B?Z29idmlqOTZoUXVoY1Q3R1dwZDc5MzNpTmtCZ2NVMkk2NFg3eHVHREJGQXd1?=
 =?utf-8?B?dHdEOFRtMHR4ZXNia01SeVhIajMxcnRPZDNFcVBFOUVQZDBwemtjV2dFS0Uy?=
 =?utf-8?B?OWcrVkR0SjI3WkNucXFlTWViNGpNazJPRHFMc2lrcmZVNjdWSWN2N3oxdm5m?=
 =?utf-8?B?Ui9kSVJJR2liTEx1Wk1HTGZZZFBjZklpVTBKeVlzNmxVS0luYVFobzZCRldm?=
 =?utf-8?B?WkRWSlVreWVZYXlRRUlNaUFIUndjR0crR3UydFV3Z0Nlclgwd0FMclBZbEhN?=
 =?utf-8?B?VlhhZDJBM0hwWHFBZEcyVEdtakJiVTNNY3JNT3NPMEl2TmwyQzMxOUp4ZVVM?=
 =?utf-8?B?RFhXZmg0WnlsbnJUME9iT3EzeU5RQ2pNMVI1VjFqN3cyYWFaL3RPTmlkU0lH?=
 =?utf-8?B?RW9WaHFkMStPR2d5V09Ma25vbmF4eEFmUS9sa2ZtU3FyWmhxNWwwY25NWnNj?=
 =?utf-8?B?bGlRWnJ4UVhMbFY1ZnU4a24xdHJLZ3Bnb2hOZnZCNGxEdUNJRmdWVFlEL2tj?=
 =?utf-8?B?cGZJMVdRa21INnNTd05ETHdzMkpyODZlV3NUajNUeE0ybXJOVllaUkRYazBP?=
 =?utf-8?B?NUVrRjUxTUUyQm5LaDl3VG56cnJmUVJTUkFwN3BpbndVek1WY0ZKWHh4TlpK?=
 =?utf-8?B?QU8vcFEwOTY0dnd2VDhicnhYUVRmajZ3bjRYaWVUanJmNkY2Wkx0dEI0alNs?=
 =?utf-8?B?OVRhWElLZHZDc1hpZTVOWnFxUkJIVHhOUXlJMDl2NHRqUlhkSVNDRDZCOURv?=
 =?utf-8?B?bHhydm5JQ3dPd3pmVGZ3WTJFbU9ESG5COFA3ditxcHlZUVEzNGRGV3pVZEQr?=
 =?utf-8?B?LzkrZFZJaXJzVXJGMTFXRjhBQXpmaWo0TnhVTkYrMGRuZzFpM24vcUV5WmRx?=
 =?utf-8?B?SUVoVVQrQVdIanJvbzd0UjdSWVhnMks5NnUyRFRJb3NOdVBOTmp0QVN3dXVC?=
 =?utf-8?B?bWl6TmEweHhub2NCSllaOE9iR3NnWDhNRGNqc0Z4c21iUHpqS0xJZnFhRDNE?=
 =?utf-8?B?OS9kZFZianNHZm82cmRsYmpSLzlkMlRFMkwwalVRSFF1NXd0UUhFWlJRbzV3?=
 =?utf-8?B?L2FMcmVZbUJoYWNzb20rU055SFVFVFNjcVE5NlNYb2FwSEkrVXYza01FVEda?=
 =?utf-8?B?VFM3MG8wcmlMaS91bXQxUlVVOXdNNEVRYWJlRVE4bktaNzU4czN5bkJUTW5u?=
 =?utf-8?B?QVBJWXVMaUhJQkE5MDVpU1J6RnBSYlBmeXRhRG9xRHhMQ05EWDZBT2ptSWpN?=
 =?utf-8?B?ZzlUTHkzMk9Wa3o1aGtSYkw0UkwrK013TVVieGNSNnV6RWpSTWVVWVhBVFBS?=
 =?utf-8?B?ajkzUjMrcHgyMFI1anVGR3Jtb3FhZjBadmZVR2JNWlpGUmNlWW1vSEE5ZTlV?=
 =?utf-8?B?Vzc0ZHlPSXpJbmdQTElOMDhRVXFleGp1RnRUVEo2dlhnU21QZnpkYVh3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3g2amg4eUVLRkZTNG11eDRQZnY3SThJQkhRSXA0ZS9WZTNyZDI4UE4zdGJJ?=
 =?utf-8?B?UVhic3MySUFlakYzb25sRGJGVVlKQ3BPeEVVVEpsUUdzZ0xIL3hWU1k4L0tW?=
 =?utf-8?B?aW5IemdQTzZROS9UM3ovUFp4bU5IU3BqRGE3b2pxeHNteU1EMUdKTjNmUDNh?=
 =?utf-8?B?c25PNURzNlRwS0ptM0F0cmphZE5hT1p3RTFxN1dWSTVvVldnaUdvNkh4bEQ3?=
 =?utf-8?B?ZjlDQWZnZXkydmc2dUFweVQzRzdCdjg2RG5mOS80UjlNNEdCNldWK1R3OGV0?=
 =?utf-8?B?K2w1VDhQTWFzZE1zamFDMmJDakVZT0txWjVhcm5aTG5iTHZsc2MyUDcraWlu?=
 =?utf-8?B?c0Q1OG0xSGJBL2h0WThwMll0cmk0SU9ualBSVGoyVVhqNTYxWjc4bGNCbUlW?=
 =?utf-8?B?eks4M0tjMnB1ODJ2a2JqSWZ4NUhJbE05VXBEL1BoR3BJM2JPTXdrQ2xLbGE0?=
 =?utf-8?B?amVJaktoR29JR3ZYUjhCVWM5WUdSQURFWGdQVWZmVk12cCtBa0RHS1VEbXM3?=
 =?utf-8?B?b3pxaEpzc3ZNQzNHOXFXOUMyT2J6K015Z1lJWjJLNEpjdGJ0cHVFTW5xTmJx?=
 =?utf-8?B?dnB6OU9RM1RKbDBlMWllRXNpSTYyMHBQQTZaV29XZ1k4WTgxUVJVWWlXWDU4?=
 =?utf-8?B?WXhrWm1YaE9DTFpkY2pKU1M4bUxDWjl2c3Z5QkVHK0QwaWd2Vzcrek1VcDlB?=
 =?utf-8?B?QTUwYUtGdm5OaHFZUWVhcGp1TVRhUmhZNVpJVzN4T0pGbGVEUzE3L3cyK05j?=
 =?utf-8?B?c2NQTC9IRnJJaEJiTzFrWFFmSEltV0hyYkdkWUxndXBaMUo3TkUzWmQwUTJx?=
 =?utf-8?B?R0hPUzZHWXMxZlpieWVsR1pLRTlTN0FLeUp2bzlhejZtQWxuVkQxb2F6MzFq?=
 =?utf-8?B?UXkrZXRFdDdWZmdJcHFXajBISHNRVnpNNVdjdmdEeW5vTkVwaEs4R1hZaytM?=
 =?utf-8?B?aVJ0ZHBzSVlqWDd5cTVSVVRJOGhsWERnblM0d0FwNGxpWWJ6RFJqYlRUT1RB?=
 =?utf-8?B?YTl2a0tWMXAzRm1PUTNmZU81L2JIa1V4RXFPcmZNYUVHVmNoek1pYTBVdCtD?=
 =?utf-8?B?a3luSXR4R25ZU1psQnlZNjFZVm92S1JJaUtWVUNDaFFYbWowQ0s3NTBzUFB4?=
 =?utf-8?B?cU9jSGZGc1pHTk5GcE9aeCsxREQ0YVhISHdkMWJzVkJVS2NaZFFXVXl2WUto?=
 =?utf-8?B?TG5iRTgyL3k2Vk9OVjlHeDhOdWJuWnJXL3cyaTdKSStUYU1ZWGVSTjROSm9T?=
 =?utf-8?B?bVE0K0wrY0o4ekVVZFQvNDhWT0dNWkpyU0t2S21Rc0pJWmttcUpyc3hPVkhX?=
 =?utf-8?B?QnIxUmNkTWhxREx2Slp3Tkx5c09DZ2VTcHNwR1pDQStzRS9hRGNBSkFnb2Ft?=
 =?utf-8?B?bnNuV0pSRDN0NHVXQkVmZGFOVVVlbjU1bEtGdDNrU3JNazRxWDRhcnp0N2dh?=
 =?utf-8?B?V1BYVDNzdkwxM0Jzb05mRjVtN2RYbGtubHdDUlhINW9WV0ZuNUdDcm0yd2ZJ?=
 =?utf-8?B?cDluZEd2aHhSWVNLU09EMEx1RHd0RzZFY0RLd3VRR1ZMQ3BmN0liYjRwNGhm?=
 =?utf-8?B?Q1dIMktYTXUrM0JTWEM5bjAvVlZGYWJYeVUzcUQ5bTRUQW9rakFkQkRWSjIy?=
 =?utf-8?B?bDNZTnFsWEdUQ2NTeDdodjVvekt0WlFubFpXYnhIcXFpS1U0WDFyZXpyVmZP?=
 =?utf-8?B?VXAyS3Rybmxlc2Y2bmkyZzJXcU5MeUp2M1pWdk50NFBqM3MrM1EwQjJ5b2ZQ?=
 =?utf-8?B?ZjBSMzJkTzZZdWMvUy9Kc3R3bXZvR1FJaVRFeFM3SjFKOGEvSmh4Uy9CMENT?=
 =?utf-8?B?UFBiOE4rVEVvSnFNbFRMZDhyL2pHelhrenIvSnBEZjgyNkM2YjZjQUdROEMw?=
 =?utf-8?B?ZWhXWGdkTzljZnJPV1dwckp0dkh5WXEyUTdlZW1TQWV0dHVFa2xRVnN6TjNW?=
 =?utf-8?B?eTR2amhHZFZZSnFZMzdMYjFwckdUT2ZjRmlMd3h6dWc2VjJvUzB4RE9kNEJY?=
 =?utf-8?B?VGJwQ1JVYlhzaDF3YndkbERmQTRXdmxNSzcweXZIbzhUdzN0aVZoSnpiL3oz?=
 =?utf-8?B?VjdSMDdlc2pxaEV3d3JVZE1MRHFEK3Q2WWdOMC9yWjJKcVBtMGl6aFZVM0oy?=
 =?utf-8?B?eVdQRk5ZdUtiNHlGZENyTGFveHhIUkRVTysydzVWbk5LN240eUFqZ3RLYW5P?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab931a3-1467-4481-7de4-08dc63a4653c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 14:48:10.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cc6/FGSPPmBAo4V7MU3hLRDLlPbYcCkJ4Y63BXC0an4c7MNs+LaTUZ2jZzy3PJG0DuYhkJevjdeJKBAzhGVVK16G6vxOpdpzCVgr2pJirDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8255
X-OriginatorOrg: intel.com



On 4/23/2024 6:15 AM, Binbin Wu wrote:
> 
> 
> On 4/17/2024 2:23 AM, Reinette Chatre wrote:
>> Hi Isaku,
>>
>> (In shortlog "tdexit" can be "TD exit" to be consistent with
>> documentation.)
>>
>> On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>>> virtualize vAPIC, KVM only needs to care NMI injection.
>> This seems to be the first appearance of NMI and the changelog
>> is very brief. How about expending it with:
>>
>> "This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>>   virtualize vAPIC, KVM only needs to care about NMI injection.
>   ^
>   virtualizes
> 
> Also, does it need to mention that non-NMI interrupts are handled by posted-interrupt mechanism?
> 
> For example:
> 
> "This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>  virtualizes vAPIC, and non-NMI interrupts are delivered using posted-interrupt
>  mechanism, KVM only needs to care about NMI injection.
> ...
> "
> 

Thank you Binbin. Looks good to me.

Reinette

