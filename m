Return-Path: <kvm+bounces-7131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0658883D781
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:12:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8016C1F2B47D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EBB22320;
	Fri, 26 Jan 2024 09:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I7Ft2p4G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527B522306;
	Fri, 26 Jan 2024 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706261802; cv=fail; b=aZYfqJBnFIB2p3NfXUWALE8VIxlh4sf8DlViCqHuNQuGoU34zk8i3EZzSC02mksubmMv8oysxqpowyU2O2SoK6gGiKp0NeZ5CCVj1uCRYxk2ApDIJvWe0sNTATdV++Oaj9H+fIausylwjLF3QqeAs2KScLMkz52S5nvl9r2BVCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706261802; c=relaxed/simple;
	bh=naoQCmttyLGu0t72/ZV9LASu16cUsXZZWMFoSiChPd0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h/mMWywm0EAsm27WHcncVOxjxrUddECaoouSSJptnQ8HOAkZ7GGdCFqK4IQgvShG7zhshwXNxN+F8XSaHzYbTcaNTYnI1xv+96yoivZaYw88kEWiwdd/tzC5JlwGzvkSQ8UQ7JrMjQu+smTPy58XUtz84bcAN0rCmXg5wMfWu4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I7Ft2p4G; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706261800; x=1737797800;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=naoQCmttyLGu0t72/ZV9LASu16cUsXZZWMFoSiChPd0=;
  b=I7Ft2p4GLhIIilOM1qANfNWLTKZ4fPWgWnltI6IGS2jTmQ6q3hjOPtVi
   R1/hHAlsbbd0hi71PkR9vCC+ERuVrExRNZOp1CXeyHZ5F+8JIz6GIpOWn
   BqcCEkAoECH7FrV1AaElJdKdxfzSBFvIpJXBIZyWMI9mIiKAHZ9NU1P+x
   tVFPTJlXBhX971GuGEKLuGt03VqrzCgWwyGZWu8cQojRA3DSzGgBJ911f
   f/avkk3XZuNsdKEe3GjZgpfv2kv/yWPNi6XP6DrTKb6iUIUA3t59gjkVF
   LP146/q26W8nLkyWy4CCZeDQLDP2DBxyar606M+5FkvW8x8ycU7v04rqm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="402084131"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="402084131"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 01:36:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="960160835"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="960160835"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 01:36:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:36:27 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:36:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 01:36:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 01:36:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+w48mQ3VFhHmvQwZZgCQHbgKBAQnnQdZOEflkykmcUq8gmful7ax+NP3j2UIgp6QGAK2H6AXN7iLEKX+XSAoHszNuqy4bMMRCfIm+bAMe3673aniaV2xp1JnlrwDF210FNjHSnLFn2Yl3KnLDPvYnk1ilrKAUgVwqtevmFo0a+Tr4exnyaGFeVWs3GBilCTaRgMlyS1gdCzDN+aJvjC/GV3MGpM5ZuiCjP7UEFACzi3grxueSBLjc2b3O4r9iVpZVxy72wd87N1bMXQoHNyhTSX2sB5kIvIgp6gOa8XWsCj05D/q3KvY2rxtQtno4e0IXzVAGnVtjx0zResAWMZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuF+Cv59x9LphRBZPLBRR3/JWwY+V8n0v83xm7sUBE0=;
 b=DMBokwvxiVPnD7B/9v6okScNGMdZCEB21mt79ZlzoSDzB4Ag8UWw5ijUTlUboQzCeHf2ximP8WsWcLDPOVHb2VFgSuD0QxF4/dIhdxrF/nQDS5+mUcKfCEtXGBGjurqHGNFqxo/rCsit+j/sleX/4AgiQaM+Rq4MODs9OjVCHxoVcFuRQu+sfwZCfOz5ZZYUz5QARJ3eVLJo7tuiF/E3YXtdZPHjjhMF6JYXZZfVq7hvpJgNcN/4vFiXOJVbEHYyCqt5flC3d56cBCrXrUAPCM9OAgE2wsOYc1QXEKvkJnSBYgNemUgQXVkqEqzcr2757eVe2ZQr8IR2UvM7jKc1QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 09:36:20 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 09:36:20 +0000
Message-ID: <4da92124-ab97-45dc-a89b-61a85f6ce240@intel.com>
Date: Fri, 26 Jan 2024 17:36:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 22/27] KVM: VMX: Set up interception for CET MSRs
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-23-weijiang.yang@intel.com>
 <ZbMs6KsCWqE0fpQv@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbMs6KsCWqE0fpQv@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 1621410a-faab-4aec-b59e-08dc1e524091
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7LgHg7oQKD4AFcub36np6bkWSofFVTlTmagYlQbgoKwegWsy0PJWby+RgZX4lNwg9Mk2/oLlS0X8auCrOiAdBJMznPIcBTbH8gLaaPyA2Hf6T0reT3bprtFHOGr/hZsym6GxjqLkf1TMg02gM5pPVEFLM1JbIT1dN4L7Ld8SjQV+joEZtjR+2Vdo8v44A3KTqdd/u6J2wvpFNcks1wljf12qxMJmwUKK8Fy0AXWtbzCBwIWNFMAGgluGALUPOt1UojYIQm+vmOng/E9oU2xza/HcQo57eOZRmIvnmQ83bQSwKzf/l9OBvRzHTCk66EDZ3w3riRgVESHaJYJWAuCY0kTfha02J0ctYYCM3v7g8WfQ/2lU3FYk/QRZfm/CJVkGUGHmaYPKJOgljDSIjEZQ1nYn1E+c4ZuIq2Ejyxm4qBHB8VY+LlrQJJFNHg9oMSZXFmcBMJz6UHznK0USJKRUtddrrlJV1k3E9E1mlj4fQjBKI+PIpHvr3IkOrX3kVUr0IRlw0hvNC6WSrfFT6P2FBey/f8Fci+L/F/+SUC8/2RgGq6b/Fs8Dj3mhjtYTUkfIXdLv4y8/OqUwZv/WD4ozZoinolf8FOF0qQCdJzlZoUAXaJEzSG4KGVLv+GCFOMotipD0PipzkTWFi+7nA/V00w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(366004)(346002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(26005)(2616005)(31686004)(6486002)(6636002)(37006003)(36756003)(478600001)(6506007)(6512007)(6666004)(83380400001)(53546011)(38100700002)(82960400001)(316002)(5660300002)(31696002)(2906002)(66556008)(66476007)(66946007)(86362001)(8936002)(4326008)(6862004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3c5Q0xtQzd5K0pmdzhVVGRCWCt6NWw2RmxYQVVvNW1LRVNmczd6eUNMR2Fx?=
 =?utf-8?B?WGY0WjM1SzFoM0d4TkdPM0tTM2ttVUErSThvb1NvYk12Z0x1czdpampWQkRG?=
 =?utf-8?B?RzJNOEJueVR2V2hMdThybTRRZmUxZlNtdEpaVmFCbDN5cCtORmUyVkY5Tkt4?=
 =?utf-8?B?L0cyTXNITXFITHc5cy9YZXhJMm1uRmtDbHJHbDV3NndsTkxQdGVPczZSam0x?=
 =?utf-8?B?dUlCWktHR1A1Ri9KSDRqOW9pNUtBc2NMb1BxWWRtV3hzNE0wejdxcjVSUXdO?=
 =?utf-8?B?bGZxZUkrRERuWThWWWwrS2thcTQvcU1oM0FTSnZLRTQ4NG04Q3RXYzVGWnlx?=
 =?utf-8?B?RUNlNmpTQzU2Y0xqc1Q1c2RwN09uWXl1dENFcGpzRnlrZHYwUGpIZU9PUXFM?=
 =?utf-8?B?SkZlV3U2dXhmRnpuS0JSN29vV2s0QTV2UjdaK0Q3dHZnd1cwVEtmcW9HZG1j?=
 =?utf-8?B?akt4WXd3b1pxWGZYQ1EvRFVPR3RySHM1MXJrMUZXY1YySGN4azdmUVpJSlg3?=
 =?utf-8?B?bHlBQXhEMjlHMEw5Wkl5QkJ3WTBiczlUY016R25uVWo5WnhBSUpZQUhUbkJR?=
 =?utf-8?B?SFZIYnl5a1RsZjVkZGxudWtiUFBZcnkxMXUvTUY2QjBYem5ESjBWblNGa0RF?=
 =?utf-8?B?R1lhRXJtNmVVdWtRS1FEUFprOUkvMXlQMjZveEdiUTkrcVlTRVYra3Q2NWNj?=
 =?utf-8?B?bk9SZ1hzRzF5RjQ1ZTh4L0VNMk9WbEd5TDlPd1FvLytydFJiRjUxSm1mSERS?=
 =?utf-8?B?ZjdoekN6TEEzaVhpb3pGSjUzMjE3TUIxb2RnTEt4dEZuNFpIZk9yQUh1aWNN?=
 =?utf-8?B?VENVbnBGVHRDR0V6WVcrS0RLWTIvUjZjRUpqTDUva1FzR1lWL3FLc01ETFF6?=
 =?utf-8?B?QjVJWGNOTUFKQjlrYm9IYXVSVk1SdjNidUcxT2FDUU55NGtlQk9IWk85TVFp?=
 =?utf-8?B?N3gxcHNHZktZa3RDRmo1RUhib013bDV1STQ1T2QwTEV3U3BMbTBmbFJQOGdT?=
 =?utf-8?B?VG14Qm5VTndHc3FCSDBXczBLb2YwSlBaQzA3dUtLK1ZmeGprYzM5SlRsdEhs?=
 =?utf-8?B?SUhBakJnc3pWRmJvNVlFejN3N2lxYXJud3V6aVpVUHpHM1N5UzQ2ZGMrb3Rl?=
 =?utf-8?B?MXcwZDZCTE4yY1k3dVpLbTBpdWgvcGRzZnhDeVZaaWo2VzBQKzdvbXdUems2?=
 =?utf-8?B?NnRVRnRUclcxZ2lvaW1RdVlRMnd3ODM3UEJmaWNhc1gvQmVreDVUd3IwMnht?=
 =?utf-8?B?TXQrZXp0WGZhUzdxUlFEUklNMG5DUkZhVWZKeTNzMEdaZHF3VUl0VWZMRW53?=
 =?utf-8?B?bHo4eWY0Wk93MTBsTmx4NXBYclNOVmlWcGl3M1BYdjFvMzFwTVpnYlZ6RWV0?=
 =?utf-8?B?MUJDQWY5cllDekx4VHQ3RWVaOGpEOW1YeFVtKytpd3hqRHFkZFFCck1EaU5V?=
 =?utf-8?B?bU5TN2tLMHl6MTNkWnY3Y0krRjI2bEJ4WEJxUW5USmRZRHViNEo1Zkh1OHdv?=
 =?utf-8?B?WDNKNHFkRnNvNE5qb09PY0t4SGZoUWJVZHlkd0lKV1czTHVFNVZFNGRRb3Zq?=
 =?utf-8?B?ZzBpaGVPNTBKQ0pGZFZMa1I3Q3JIQUhqZGFXUlkyK0NTU05lTGwyc0I2UmF6?=
 =?utf-8?B?Ty92TVN4Wmk1SEFEMlJtUTNZa1ZrZDhndXJvckJnUEhIU3RGdlF4UzlzMS9k?=
 =?utf-8?B?bVdpMlJUN3pTUk9UUGErU1JZZEpFZXNiSHdlQ0NRK2RtSkdESjIzTitxNHNJ?=
 =?utf-8?B?UXpxdTlwOHpZbUlKQi9QY1FkVjdqNGsvbnY1SHN0QXp3UTYzK3VCSG04Zndw?=
 =?utf-8?B?RFF2YTgvaExuVXNZSEFsSEZBTVFkVVRiVlgrNWlHTHlTU0pPc21oUnBkWGhr?=
 =?utf-8?B?QjdGVHdUck9vVURGTmxsVXVLMFl3TFZVM3RKWkwrWVRhNzhPTzJ6VDlNRGNp?=
 =?utf-8?B?dm5Fa0xlWUJsR05uNVpLT0FDRDhvNnl2L0p2bWNoUUxlU2h6TVRLOXJqWElJ?=
 =?utf-8?B?RVNqaUtNZ1pJaERFUjRaL09NYllWakR0Z1pqZTFUYllXbTZOZExNeHZvS2Jw?=
 =?utf-8?B?ajA2dE4reE9rL2prdGdxdlNWdDRqVnRpU0JaVEYvd0twTmhVYXlSekppM0x0?=
 =?utf-8?B?N0RNeTJtd0crS3Y3SFRKMzRCMUtydkxXN3R6MmF3OVZHNFFvNTRYdGpuOGZ3?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1621410a-faab-4aec-b59e-08dc1e524091
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 09:36:20.2316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xl5egRQIM66VthpZ0Y70KHD7jIDtbzVVkCOcohENd7x0Xh6DeKDfL4P1FosaDZaUM+esALkD2cUiOaPeldyN+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com

On 1/26/2024 11:54 AM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:41:55PM -0800, Yang Weijiang wrote:
>> Enable/disable CET MSRs interception per associated feature configuration.
>> Shadow Stack feature requires all CET MSRs passed through to guest to make
>> it supported in user and supervisor mode while IBT feature only depends on
>> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>>
>> Note, this MSR design introduced an architectural limitation of SHSTK and
>> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>> to guest from architectual perspective since IBT relies on subset of SHSTK
>> relevant MSRs.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> one nit below,
>
>> ---
>> arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 41 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 064a5fe87948..34e91dbbffed 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -692,6 +692,10 @@ static bool is_valid_passthrough_msr(u32 msr)
>> 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>> 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>> 		return true;
>> +	case MSR_IA32_U_CET:
>> +	case MSR_IA32_S_CET:
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		return true;
> Please update the comment above vmx_possible_passthrough_msrs[] to indicate CET
> MSRs are also handled separately.

OK, will do it, thanks!


