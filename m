Return-Path: <kvm+bounces-18507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C4A8D5D12
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 10:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC0CC1C251DC
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 08:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FC6155732;
	Fri, 31 May 2024 08:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VeSTWVIS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF6156222
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 08:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145273; cv=fail; b=ShnbJN6h7SJbbz9406tQPN0ZIVY4RX9NKPlmkjaHP1+oR25bwjgdKeBaWRxM8/Csi3QzaisEv8XJb+mFrDnDl+yCqzUcmmLKYIZzw+7fV1Q/F7sJpaJ0ga+8h81q+5hW+nJLiT1jIjXDc8PRamdsfM5SHEuSx102T6DK89kFFPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145273; c=relaxed/simple;
	bh=2ihhrNRVob/DnEyMy9gjNchFgzLjuFa3KBWclcHLJ8s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h8IGTrYRy/nm5Cs8EGpF7gL4FRekyYbQB3Sz6jJ3QlSNucjBcZpxwggYqivlgX2O5jkBAgCVHOpRTtY1fNPOvlOhWc+RhINOsF18jxD6ndcnYHbu91CSREZn0f+U+Zg+3cggxroIjhXXFfqhXZfsnvenJcIoLql55b4v00PuIFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VeSTWVIS; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717145272; x=1748681272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2ihhrNRVob/DnEyMy9gjNchFgzLjuFa3KBWclcHLJ8s=;
  b=VeSTWVISSMd3q7W4xNeRVsqQsSUT8Rq681lRTjUbDf1tumeNJ6xDXi3K
   x3j1qvL4obNK3Hqqr/ejaRVf176jic4nIh23MRUx9O+SU6qLOESQWvhv0
   PqS6qB+YProYLt5TSuMQkoJqJ2SPN6Ah0Tvy9mdo2pNq/jU5DvrjcoHbe
   33ZahZJMHgZRBSF32xfwvUNaNrzmT6NZ5eXi23TMnartfJ4HN0d1gOgZp
   8+fk1rXp7gwQvCW/v4D8Kk6LLuBPDhMNsJgQasZ0w8mgMEmfh6smOWYXc
   Vz7pJ5U6AMGydd1z0M9JDyN00GOA1hs7LWO4TpcMXKTR6rA92GwqybHt5
   Q==;
X-CSE-ConnectionGUID: t7vNCzWjRROpU/mGgqmr7w==
X-CSE-MsgGUID: dT5yEOmtTRq8dTUMDDimqQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="24800834"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="24800834"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 01:47:51 -0700
X-CSE-ConnectionGUID: ih0SX4UtQJKYJHa0EeEITw==
X-CSE-MsgGUID: 7KYCAccYSiGy4VTcMz5DJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36034564"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 01:47:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 01:47:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 01:47:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 01:47:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 01:47:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JX7OIUtRb+t/VNDHYjIlQpgD6Tx4qMC0uyHzlCcwJbGrA3cMTpp0Z2qF47wm3bkyYwFz/dUaK7qqmheGmaZ0P2F9a1ohsLb6E8tbRDbSsf/BDwt2857XDhJKE2QMN1FoREopYbG/GNcLZxaE0gL0H6PlVoxJPCQBaQl7Xls/5d0lJF7HKc/eeSHsFwhRA2d23LNhyh5zP+ewSIDiLymiDBf9n4pNnjwlekd+UbeRglHBOWNZP6CaRDOWto10hPIJkymrWCDWXry+pvAQpXa4J9GQVPBRaw+7looZLLOnTA6/9QR4Q3CxiRgpzFyzAKIIpU6nthu7/gIhWzVZ96JV1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ifVhr39hqwtmjVLoFhwrLhUGAWQR3ycb0F65gE5Y7M=;
 b=HHTPXcYEXj25x/aDNE04JFg+CHKbmJpfOwBvDVqOzCRYln3ImiDm+lzAjPjuoZgK+jMq0618z7TPacdQfjmbiAvhvOwZ7Rk14svKHqJLWch3vm370jGDVdpHzoWJNG8yFpIGwnCk4bmpxw7Mqtwh4cPDS4FLpmLFaYJaOA2vWXmphKsKio7ljdTV8rfVmqOIWWzjyumVmL3kMSt7gtYxtGjMwrb9KyQJILoaYN4QCLorejufa0OmrwbP4OhnuiXHGgmY+Y5onQWuFl50ZhqLzK5+r9mP9karOKs7wVBxJLY1JV4F38PbhDPzUNO2ujd5v/nICQe5c2/flB7OFkE1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by MW4PR11MB6810.namprd11.prod.outlook.com (2603:10b6:303:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 08:47:46 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%7]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 08:47:45 +0000
Message-ID: <511a147e-bc01-7fab-24d7-4ae66a6d1c44@intel.com>
Date: Fri, 31 May 2024 16:47:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v5 17/65] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>, Cornelia Huck
	<cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>, Michael Roth
	<michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann
	<kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, Chenyi Qiang
	<chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-18-xiaoyao.li@intel.com>
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
In-Reply-To: <20240229063726.610065-18-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0210.jpnprd01.prod.outlook.com
 (2603:1096:404:29::30) To SJ0PR11MB6744.namprd11.prod.outlook.com
 (2603:10b6:a03:47d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6744:EE_|MW4PR11MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 021cb0a3-77dd-479b-68e2-08dc814e5785
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|366007|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OW4rY2lWbE1rNWVhNEczbXF5dVRNendjc1AvNkhaSDhCNVp4NkYxWVZER3NL?=
 =?utf-8?B?d2hTMm4vMDFxSlNackY1QTdubk4zazlIRFJDNHZGbzBlOFlBcFVaUUhObWps?=
 =?utf-8?B?ZEZTb2RtTVpzZmU4MFFaZm5vN1lWSE8rNjhzWlVYTkpYWXhlTjk3SzFLdGcv?=
 =?utf-8?B?bXNjMGE5cHlWeC9wVXdEc09kbUdXN2tPNEtEdElMd1dGMGYwNVM4S0k1eTFa?=
 =?utf-8?B?ZVVsR0xJeDh0TVdqT3BJblZOell6QlFmaWZBK2psOUJqKytTZXczTTRLL2lm?=
 =?utf-8?B?TVdqWExTbklkd1h6Q2lIL20ySjRLRnZ6aE1TTTlHZjA0WHhHZmc5VHF1RmJV?=
 =?utf-8?B?a05ZS0w5ZE96eFpnbVNGVDFjM0RqVHhHR0JnNzFMdUpsYkU2amxRenRHdDhk?=
 =?utf-8?B?aW5oaGxUY053Z0thUnFwUXF3VVAzYU16cHFNYVFJUG9Pd3V5U2N4UUk3MHJ3?=
 =?utf-8?B?c0xvVm45REtSN0NwSWFETERBRmw1OTJhTkxVaVovYVhNRTdRK0tzYWthT2h2?=
 =?utf-8?B?TFAyMEtxZWx0ek5iT1BVNk5mdTZiZHhUNTVwZ3ROd3ltUzlhSjE0cjNTWlhR?=
 =?utf-8?B?MWp4SEVaaEtPS01ORkh0ZHNvTlU2dDBZZHVZNjZZY0E2N3c5N1prbkZpa2JU?=
 =?utf-8?B?VWs1NElkbzllRGxURVFnYjI3M2dSU0NxK1ZFemhVTmdmdXdvL2s3MVlIVUw4?=
 =?utf-8?B?ZDUzd2NRQzQxb3RSeUd6ejlsQkZmVEl1Q3BzaFU1Tmwrei9vRVJsWWRDY3Mw?=
 =?utf-8?B?cFI5ekt5cS9MMjhaTWozRXFqWGIzbzBnR1J0WDc4Sk5GbHNHQy9pNEVQRW14?=
 =?utf-8?B?Q2lwTkw0RGlwMjZzaGduY2JFeTZhWlJLdERoaHB6RkEwVThBNi9kaEVEd2Ny?=
 =?utf-8?B?c0dkcXQxNE52QVlDektZdkRRMTNPODlzS2g1b0s5RVV5UkpxalJVQWdZYi94?=
 =?utf-8?B?NWlNNTNlZFl6enJNM1RZZ1RtZTQ3dE1yTFk4SkFwVnNjY1ZZdjZJYy9yTlhI?=
 =?utf-8?B?WE8rZmprUmo2cEt1RTdnSUY0SDFSMlhJUW5NUHpWS1J3YmhydFhIakNBZUxG?=
 =?utf-8?B?WHNFdGNZaThOM0J4RjdFb2l2U1FJTm5wNG56NDkvbWIwLzRUSTUvUUJETnRk?=
 =?utf-8?B?WFFGRDNjMWtIYm5lQlM4ODdLbUpZb0M5TnJuK1FBQlVzaHpNc3hhTVlZdXQ0?=
 =?utf-8?B?SDFGOE5aNWRUWnlyOElaUE9iS2FibGo5RUFNSldSbXRvMXhsWUpZaEVqRWts?=
 =?utf-8?B?cytncUVyLytOQnBZQXJUdlBqbGhxVDRjaS9OZ0owalNHRjY5OXhUS05oaEtr?=
 =?utf-8?B?TElCY244ZFpmR3Q5SXAyVmdmQThzdUdxOXo5NXJOM2piem5Td2pWa3FGQnBK?=
 =?utf-8?B?M2xYS2ZNZDh5TUY2bUxLTUZoV0xEVnlrZ2RKN2tnaGRESVpaclVzdnJrTHp3?=
 =?utf-8?B?MFB2cnZ3dWlodGgvQUMzQ1BNLzZlNlF0b2hHMjN5SWt6U0IwV1ZaOER2SHE4?=
 =?utf-8?B?ZGpjNWVpd2tJMElRaTNGZ0pDT293MFdHOVZWN2NPWjJnTVpUNHcxWWhaVWZF?=
 =?utf-8?B?OUZFVERaUEh0YzFsbkdObWVLUCtWQ2RSVXlvdDNPUXBGcjRhZ1h4ZG9LS3Nr?=
 =?utf-8?B?ZDNRQy96VEhtVFNZNS81VGIzbG9jdWZSQ05NbFh4cHcrUDdISlBGclFVQ3dz?=
 =?utf-8?B?Z3dUZSt0T1dPMndNWURrY2JubGR4S2RUMCtQd1RldGhEQm1jdEdISStkZ3p6?=
 =?utf-8?Q?OqO2BBZKx7xbNMygCEYZmnHR+XfANH8bAFOAsB4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0ZCMFBhU2tHTU45MDJSZGJ6Sm5zS2p2YTBYQ3lzMXFzbUR4bEZpYVpZbVg2?=
 =?utf-8?B?aGdBeThPMnNXNDNjVTNJSDVKV3ZlejNDaUdNRjdFV2liZlRLWGpCZFgwd3lH?=
 =?utf-8?B?NzZLcmp2MHBDQ1pVNWIzZHZMa2NuTzlPNGhIS1pPOG82UXR4aWRuK043Wks5?=
 =?utf-8?B?aUZWUkViZFcxRHJZRGlaNUJBRGhiZjJIREdqTFg5bmhTR1p2WEV1MDhKZkU1?=
 =?utf-8?B?YVF5UGVaYmZWMGJQMm85UXl1ck5oblc3cXpvYXVkbytxaHl2clV0Z3hlc0kr?=
 =?utf-8?B?QjRyNnJ6V3p3L3YydGYrbEo4YlkzQ2hsY3YyNllDNUY3dE4zZE9kb2UwQ3ZG?=
 =?utf-8?B?NFhpeGZ5d3FrcGgxMWgvWDF0aUU3SGYvcVhJOUsydHRXRjEyc2RISGJKQVRV?=
 =?utf-8?B?eFJMc3RGbUtNNWVmSmlEa0tyazd4QThDbnhtOWQrdmkxV3lFa2xsYUFqb2VM?=
 =?utf-8?B?bWlrdDNWbkVDWFRoU2pLL1VsM2xpaWRoUmp0NW9zemxWM3RtOFUyMmp1QjlN?=
 =?utf-8?B?YW1weEJNbEVVMHNWMU1EUTF4VTZkdTJUODhDcGNHaHdXVUoxbUs3Z2Npdlk0?=
 =?utf-8?B?L2tlRHJQbUIzeFo4NDZIZnpONkdscFJOUzVUWVRoWHZJcUhhSFI5RlVvNmox?=
 =?utf-8?B?Sk0vdXIvRmxuU1NNMzVrQzBrYmpKcFp2cURxNHQ2VXdOUktFWUhVc0xKNHl2?=
 =?utf-8?B?TVFHSldkSHhYc0RDY1ZiM0h4T0FodWl1bFpTUGlicjhsTmIvSUxwalFDTzdy?=
 =?utf-8?B?QURZamxmczVYd0tzRGVPR1hrbWRLMy8rSzg4blQwNlFvVlc3azdsYjdSZXM0?=
 =?utf-8?B?c3djMk5BNEF6cFZmdU9GcHdtdHY5VjhaWG5OSklUR24vWTlxWnZNZG5nT25j?=
 =?utf-8?B?Y0JWOFp3dVlLSDg4NGtXbU02SVRRMHJmbGE5a3dvc3dMblQ2bHlPUGFSRVk0?=
 =?utf-8?B?ZUFDV0k2NFdDK1JVazhXQjN6WWIxR0JLRUdpS2x3NUdjMjBnWXJ6Ulg5cWta?=
 =?utf-8?B?RlVKS3JrYnNLNTU1eklpNnNPT1FGdDZSM0FMZ0w5YUVESEVJYWFjNnJDZWdz?=
 =?utf-8?B?eDVSWVJKdEdtUnFIbEMzS21Qa3g2U0JJRFdpNEpRVytGWjZySmZ0WG5rRVhi?=
 =?utf-8?B?Tkw4OFBHYlNTVnZIVGZWNXhKQVIyV3dxRWROMFFMVVFCQzVBMWp3WGJ4K1RE?=
 =?utf-8?B?QTVyVzNPKzREdjc4SjFObEtHL1p5U1YvdXdDV05PRHpzOW4yak1kUlYzaEJK?=
 =?utf-8?B?NERPNEp2YjJzdnNtRU5Jam5ZcUZWMk5Ga2ltRmhZZjdqWkhjdmJiYmdzUEVp?=
 =?utf-8?B?eG5RMCsvczQxVHJpbGc0cjFNajhreWZkUGdqNitaSStsZUc4eHRTdFlGb2NC?=
 =?utf-8?B?cmQ5T0FFY2JHV1JKbVdqZndlVHZPT21wS0NNZzdMc0lNcFFHaHN3amx2cEpT?=
 =?utf-8?B?TjhML2tIdzRlVm9RbWFHQUxGd0JLZHd5Y1B6a1JKSW5zbGxyOFB6R21UbW5Z?=
 =?utf-8?B?NFNXdVFvWTVIRlBocUwxRWgzanl3Rzd3aUs1UndFblRyckJZTnJwa1IxMUhI?=
 =?utf-8?B?disySWRmRVp6L0FvMjN2TXp6bU02MEJCQkVVbVNwOXRaYWNlZml2M0l6UTBB?=
 =?utf-8?B?QXFNenI5TExFUGFORW1sNzQzYzk3TWJPU3JjUFIyWU9hL1UwK2g3MHZablJr?=
 =?utf-8?B?ZjZRVVE0d0NTZ2ZkZmVneWZJN1BsL1lXeXlLZS9NZ205SURCcmMrV3dXNTMv?=
 =?utf-8?B?OUZtdWpPN2F3N3Bpa3lWVDRrY0poMkRsVXA1eDRpbzgwcDJoMzdIa3FNc01D?=
 =?utf-8?B?RXYwUTlLQTgyL1pHdlZ1NjRRam5FT3B6Q0VtREJxWTgxb0oyRlFYWWd1aVJD?=
 =?utf-8?B?R01DNG9jYnlUdDV6TUxqYjFOWWVqYTBjaTdZSllJdHNOdUlRTXZwems0NWRM?=
 =?utf-8?B?S0JyRVdqVk1DSGc5NXIwYzN3K1hCbW0wSVB3VE5yMjZiQTMvaGlYajVJS0Qx?=
 =?utf-8?B?aWdzMys2YnJVd202OGV6RXRwaEEvd0R1M0JCSTA1N3ZyOVpzaVJxaU1lRmFo?=
 =?utf-8?B?SkVDNXNIeGNUZW5rWVJkYkY0NFJ6L2RvUGRGK2JqS3lVUi9TSkZoZjRyWG9W?=
 =?utf-8?B?Q2FIeXpkTFRtZTl0TzJyS3R1V0xsNkpvNWJwRjZ0bGZCaHE1MFpoQ2dYQlF6?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 021cb0a3-77dd-479b-68e2-08dc814e5785
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 08:47:45.6682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57Z6aO8eKl8bpLZE5i5EubyW5q7m4x0ef85cD69Q8I1nVCcLYsJPDCgviyD7XBXIAAiRzGYhvNV29qghumJhOa81hUb6A73CZqFqXTgbNMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6810
X-OriginatorOrg: intel.com


On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
> According to Chapter "CPUID Virtualization" in TDX module spec, CPUID
> bits of TD can be classified into 6 types:
>
> ------------------------------------------------------------------------
> 1 | As configured | configurable by VMM, independent of native value;
> ------------------------------------------------------------------------
> 2 | As configured | configurable by VMM if the bit is supported natively
>      (if native)   | Otherwise it equals as native(0).
> ------------------------------------------------------------------------
> 3 | Fixed         | fixed to 0/1
> ------------------------------------------------------------------------
> 4 | Native        | reflect the native value
> ------------------------------------------------------------------------
> 5 | Calculated    | calculated by TDX module.
> ------------------------------------------------------------------------
> 6 | Inducing #VE  | get #VE exception
> ------------------------------------------------------------------------
>
> Note:
> 1. All the configurable XFAM related features and TD attributes related
>     features fall into type #2. And fixed0/1 bits of XFAM and TD
>     attributes fall into type #3.
>
> 2. For CPUID leaves not listed in "CPUID virtualization Overview" table
>     in TDX module spec, TDX module injects #VE to TDs when those are
>     queried. For this case, TDs can request CPUID emulation from VMM via
>     TDVMCALL and the values are fully controlled by VMM.
>
> Due to TDX module has its own virtualization policy on CPUID bits, it leads
> to what reported via KVM_GET_SUPPORTED_CPUID diverges from the supported
> CPUID bits for TDs. In order to keep a consistent CPUID configuration
> between VMM and TDs. Adjust supported CPUID for TDs based on TDX
> restrictions.
>
> Currently only focus on the CPUID leaves recognized by QEMU's
> feature_word_info[] that are indexed by a FeatureWord.
>
> Introduce a TDX CPUID lookup table, which maintains 1 entry for each
> FeatureWord. Each entry has below fields:
>
>   - tdx_fixed0/1: The bits that are fixed as 0/1;
>
>   - depends_on_vmm_cap: The bits that are configurable from the view of
> 		       TDX module. But they requires emulation of VMM
> 		       when configured as enabled. For those, they are
> 		       not supported if VMM doesn't report them as
> 		       supported. So they need be fixed up by checking
> 		       if VMM supports them.

Previously I thought bits configurable for TDX module are emulated by 
TDX module,

it looks not. Just curious why doesn't those bits belong to "Inducing 
#VE" type?

Then guest can get KVM reported capabilities with tdvmcall directly.

>
>   - inducing_ve: TD gets #VE when querying this CPUID leaf. The result is
>                  totally configurable by VMM.
>
>   - supported_on_ve: It's valid only when @inducing_ve is true. It represents
> 		    the maximum feature set supported that be emulated
> 		    for TDs.
This is never used together with depends_on_vmm_cap, maybe one variable 
is enough?
>
> By applying TDX CPUID lookup table and TDX capabilities reported from
> TDX module, the supported CPUID for TDs can be obtained from following
> steps:
>
> - get the base of VMM supported feature set;
>
> - if the leaf is not a FeatureWord just return VMM's value without
>    modification;
>
> - if the leaf is an inducing_ve type, applying supported_on_ve mask and
>    return;
>
> - include all native bits, it covers type #2, #4, and parts of type #1.
>    (it also includes some unsupported bits. The following step will
>     correct it.)
>
> - apply fixed0/1 to it (it covers #3, and rectifies the previous step);
>
> - add configurable bits (it covers the other part of type #1);
>
> - fix the ones in vmm_fixup;
>
> (Calculated type is ignored since it's determined at runtime).
>
> Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/cpu.h     |  16 +++
>   target/i386/kvm/kvm.c |   4 +
>   target/i386/kvm/tdx.c | 263 ++++++++++++++++++++++++++++++++++++++++++
>   target/i386/kvm/tdx.h |   3 +
>   4 files changed, 286 insertions(+)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f52..7bd604f802a1 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -787,6 +787,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   
>   /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
>   #define CPUID_7_0_EBX_FSGSBASE          (1U << 0)
> +/* Support for TSC adjustment MSR 0x3B */
> +#define CPUID_7_0_EBX_TSC_ADJUST        (1U << 1)
>   /* Support SGX */
>   #define CPUID_7_0_EBX_SGX               (1U << 2)
>   /* 1st Group of Advanced Bit Manipulation Extensions */
> @@ -805,8 +807,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_EBX_INVPCID           (1U << 10)
>   /* Restricted Transactional Memory */
>   #define CPUID_7_0_EBX_RTM               (1U << 11)
> +/* Cache QoS Monitoring */
> +#define CPUID_7_0_EBX_PQM               (1U << 12)
>   /* Memory Protection Extension */
>   #define CPUID_7_0_EBX_MPX               (1U << 14)
> +/* Resource Director Technology Allocation */
> +#define CPUID_7_0_EBX_RDT_A             (1U << 15)
>   /* AVX-512 Foundation */
>   #define CPUID_7_0_EBX_AVX512F           (1U << 16)
>   /* AVX-512 Doubleword & Quadword Instruction */
> @@ -862,10 +868,16 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_ECX_AVX512VNNI        (1U << 11)
>   /* Support for VPOPCNT[B,W] and VPSHUFBITQMB */
>   #define CPUID_7_0_ECX_AVX512BITALG      (1U << 12)
> +/* Intel Total Memory Encryption */
> +#define CPUID_7_0_ECX_TME               (1U << 13)
>   /* POPCNT for vectors of DW/QW */
>   #define CPUID_7_0_ECX_AVX512_VPOPCNTDQ  (1U << 14)
> +/* Placeholder for bit 15 */
> +#define CPUID_7_0_ECX_FZM               (1U << 15)
>   /* 5-level Page Tables */
>   #define CPUID_7_0_ECX_LA57              (1U << 16)
> +/* MAWAU for MPX */
> +#define CPUID_7_0_ECX_MAWAU             (31U << 17)
>   /* Read Processor ID */
>   #define CPUID_7_0_ECX_RDPID             (1U << 22)
>   /* Bus Lock Debug Exception */
> @@ -876,6 +888,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_ECX_MOVDIRI           (1U << 27)
>   /* Move 64 Bytes as Direct Store Instruction */
>   #define CPUID_7_0_ECX_MOVDIR64B         (1U << 28)
> +/* ENQCMD and ENQCMDS instructions */
> +#define CPUID_7_0_ECX_ENQCMD            (1U << 29)
>   /* Support SGX Launch Control */
>   #define CPUID_7_0_ECX_SGX_LC            (1U << 30)
>   /* Protection Keys for Supervisor-mode Pages */
> @@ -893,6 +907,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_EDX_SERIALIZE         (1U << 14)
>   /* TSX Suspend Load Address Tracking instruction */
>   #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
> +/* PCONFIG instruction */
> +#define CPUID_7_0_EDX_PCONFIG           (1U << 18)
>   /* Architectural LBRs */
>   #define CPUID_7_0_EDX_ARCH_LBR          (1U << 19)
>   /* AMX_BF16 instruction */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 0e68e80f4291..389b631c03dd 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -520,6 +520,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>           ret |= 1U << KVM_HINTS_REALTIME;
>       }
>   
> +    if (is_tdx_vm()) {
> +        tdx_get_supported_cpuid(function, index, reg, &ret);
> +    }
> +
>       return ret;
>   }
>   
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 756058f2ed4a..85d96140b450 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -15,11 +15,129 @@
>   #include "qemu/error-report.h"
>   #include "qapi/error.h"
>   #include "qom/object_interfaces.h"
> +#include "standard-headers/asm-x86/kvm_para.h"
>   #include "sysemu/kvm.h"
> +#include "sysemu/sysemu.h"
>   
>   #include "hw/i386/x86.h"
>   #include "kvm_i386.h"
>   #include "tdx.h"
> +#include "../cpu-internal.h"
> +
> +#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
> +                                     (1U << KVM_FEATURE_PV_UNHALT) | \
> +                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) | \
> +                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
> +                                     (1U << KVM_FEATURE_POLL_CONTROL) | \
> +                                     (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
> +                                     (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
> +
> +typedef struct KvmTdxCpuidLookup {
> +    uint32_t tdx_fixed0;
> +    uint32_t tdx_fixed1;
> +
> +    /*
> +     * The CPUID bits that are configurable from the view of TDX module
> +     * but require VMM's support when wanting to enable them.
> +     *
> +     * For those bits, they cannot be enabled if VMM (KVM/QEMU) doesn't support
> +     * them.
> +     */
> +    uint32_t depends_on_vmm_cap;
> +
> +    bool inducing_ve;
> +    /*
> +     * The maximum supported feature set for given inducing-#VE leaf.
> +     * It's valid only when .inducing_ve is true.
> +     */
> +    uint32_t supported_value_on_ve;
> +} KvmTdxCpuidLookup;
> +
> + /*
> +  * QEMU maintained TDX CPUID lookup tables, which reflects how CPUIDs are
> +  * virtualized for guest TDs based on "CPUID virtualization" of TDX spec.
> +  *
> +  * Note:
> +  *
> +  * This table will be updated runtime by tdx_caps reported by KVM.
> +  *
> +  */
> +static KvmTdxCpuidLookup tdx_cpuid_lookup[FEATURE_WORDS] = {
> +    [FEAT_1_EDX] = {
> +        .tdx_fixed0 =
> +            BIT(10) /* Reserved */ | BIT(20) /* Reserved */ | CPUID_IA64,
> +        .tdx_fixed1 =
> +            CPUID_MSR | CPUID_PAE | CPUID_MCE | CPUID_APIC |
> +            CPUID_MTRR | CPUID_MCA | CPUID_CLFLUSH | CPUID_DTS,
> +        .depends_on_vmm_cap =
> +            CPUID_ACPI | CPUID_PBE,
> +    },
> +    [FEAT_1_ECX] = {
> +        .tdx_fixed0 =
> +            CPUID_EXT_VMX | CPUID_EXT_SMX | BIT(16) /* Reserved */,
> +        .tdx_fixed1 =
> +            CPUID_EXT_CX16 | CPUID_EXT_PDCM | CPUID_EXT_X2APIC |
> +            CPUID_EXT_AES | CPUID_EXT_XSAVE | CPUID_EXT_RDRAND |
> +            CPUID_EXT_HYPERVISOR,
> +        .depends_on_vmm_cap =
> +            CPUID_EXT_EST | CPUID_EXT_TM2 | CPUID_EXT_XTPR | CPUID_EXT_DCA,
> +    },
> +    [FEAT_8000_0001_EDX] = {
> +        .tdx_fixed1 =
> +            CPUID_EXT2_NX | CPUID_EXT2_PDPE1GB | CPUID_EXT2_RDTSCP |
> +            CPUID_EXT2_LM,
> +    },
> +    [FEAT_7_0_EBX] = {
> +        .tdx_fixed0 =
> +            CPUID_7_0_EBX_TSC_ADJUST | CPUID_7_0_EBX_SGX | CPUID_7_0_EBX_MPX,
> +        .tdx_fixed1 =
> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_RTM |
> +            CPUID_7_0_EBX_RDSEED | CPUID_7_0_EBX_SMAP |
> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
> +            CPUID_7_0_EBX_SHA_NI,
> +        .depends_on_vmm_cap =
> +            CPUID_7_0_EBX_PQM | CPUID_7_0_EBX_RDT_A,
> +    },
> +    [FEAT_7_0_ECX] = {
> +        .tdx_fixed0 =
> +            CPUID_7_0_ECX_FZM | CPUID_7_0_ECX_MAWAU |
> +            CPUID_7_0_ECX_ENQCMD | CPUID_7_0_ECX_SGX_LC,
> +        .tdx_fixed1 =
> +            CPUID_7_0_ECX_MOVDIR64B | CPUID_7_0_ECX_BUS_LOCK_DETECT,
> +        .depends_on_vmm_cap =
> +            CPUID_7_0_ECX_TME,
> +    },
> +    [FEAT_7_0_EDX] = {
> +        .tdx_fixed1 =
> +            CPUID_7_0_EDX_SPEC_CTRL | CPUID_7_0_EDX_ARCH_CAPABILITIES |
> +            CPUID_7_0_EDX_CORE_CAPABILITY | CPUID_7_0_EDX_SPEC_CTRL_SSBD,
> +        .depends_on_vmm_cap =
> +            CPUID_7_0_EDX_PCONFIG,
> +    },
> +    [FEAT_8000_0008_EBX] = {
> +        .tdx_fixed0 =
> +            ~CPUID_8000_0008_EBX_WBNOINVD,
> +        .tdx_fixed1 =
> +            CPUID_8000_0008_EBX_WBNOINVD,
> +    },
> +    [FEAT_XSAVE] = {
> +        .tdx_fixed1 =
> +            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
> +            CPUID_XSAVE_XSAVES,
> +    },
> +    [FEAT_6_EAX] = {
> +        .inducing_ve = true,
> +        .supported_value_on_ve = CPUID_6_EAX_ARAT,
> +    },
> +    [FEAT_8000_0007_EDX] = {
> +        .inducing_ve = true,
> +        .supported_value_on_ve = -1U,
> +    },
> +    [FEAT_KVM] = {
> +        .inducing_ve = true,
> +        .supported_value_on_ve = TDX_SUPPORTED_KVM_FEATURES,
> +    },
> +};
>   
>   static TdxGuest *tdx_guest;
>   
> @@ -31,6 +149,151 @@ bool is_tdx_vm(void)
>       return !!tdx_guest;
>   }
>   
> +static inline uint32_t host_cpuid_reg(uint32_t function,
> +                                      uint32_t index, int reg)
> +{
> +    uint32_t eax, ebx, ecx, edx;
> +    uint32_t ret = 0;
> +
> +    host_cpuid(function, index, &eax, &ebx, &ecx, &edx);
> +
> +    switch (reg) {
> +    case R_EAX:
> +        ret = eax;
> +        break;
> +    case R_EBX:
> +        ret = ebx;
> +        break;
> +    case R_ECX:
> +        ret = ecx;
> +        break;
> +    case R_EDX:
> +        ret = edx;
> +        break;
> +    }
> +    return ret;
> +}
> +
> +/*
> + * get the configurable cpuid bits (can be set to 0 or 1) reported by TDX module
> + * from tdx_caps.
> + */
> +static inline uint32_t tdx_cap_cpuid_config(uint32_t function,
> +                                            uint32_t index, int reg)
> +{
> +    struct kvm_tdx_cpuid_config *cpuid_c;
> +    int ret = 0;
> +    int i;
> +
> +    if (tdx_caps->nr_cpuid_configs <= 0) {
> +        return ret;
> +    }
> +
> +    for (i = 0; i < tdx_caps->nr_cpuid_configs; i++) {
> +        cpuid_c = &tdx_caps->cpuid_configs[i];
> +        /* 0xffffffff in sub_leaf means the leaf doesn't require a sublesf */
> +        if (cpuid_c->leaf == function &&
> +            (cpuid_c->sub_leaf == 0xffffffff || cpuid_c->sub_leaf == index)) {
> +            switch (reg) {
> +            case R_EAX:
> +                ret = cpuid_c->eax;
> +                break;
> +            case R_EBX:
> +                ret = cpuid_c->ebx;
> +                break;
> +            case R_ECX:
> +                ret = cpuid_c->ecx;
> +                break;
> +            case R_EDX:
> +                ret = cpuid_c->edx;
> +                break;
> +            default:
> +                return 0;
> +            }
> +        }
> +    }
> +    return ret;
> +}
> +
> +static FeatureWord get_cpuid_featureword_index(uint32_t function,
> +                                               uint32_t index, int reg)
> +{
> +    FeatureWord w;
> +
> +    for (w = 0; w < FEATURE_WORDS; w++) {
> +        FeatureWordInfo *f = &feature_word_info[w];
> +
> +        if (f->type == MSR_FEATURE_WORD || f->cpuid.eax != function ||
> +            f->cpuid.reg != reg ||
> +            (f->cpuid.needs_ecx && f->cpuid.ecx != index)) {
> +            continue;
> +        }
> +
> +        return w;
> +    }
> +
> +    return w;
> +}
> +
> +/*
> + * TDX supported CPUID varies from what KVM reports. Adjust the result by
> + * applying the TDX restrictions.
> + */
> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
> +                             uint32_t *ret)
> +{
> +    /*
> +     * it's KVMM + QEMU 's capabilities of what CPUID bits is supported or
> +     * can be emulated as supported.
> +     */
> +    uint32_t vmm_cap = *ret;
> +    FeatureWord w;
> +
> +    /* Only handle features leaves that recognized by feature_word_info[] */
> +    w = get_cpuid_featureword_index(function, index, reg);
> +    if (w == FEATURE_WORDS) {
> +        return;
> +    }
> +
> +    if (tdx_cpuid_lookup[w].inducing_ve) {
> +        *ret &= tdx_cpuid_lookup[w].supported_value_on_ve;
> +        return;
> +    }
> +
> +    /*
> +     * Include all the native bits as first step. It covers types
> +     * - As configured (if native)
> +     * - Native
> +     * - XFAM related and Attributes realted
s/realted/related
> +     *
> +     * It also has side effect to enable unsupported bits, e.g., the
> +     * bits of "fixed0" type while present natively. It's safe because
> +     * the unsupported bits will be masked off by .fixed0 later.
> +     */
> +    *ret |= host_cpuid_reg(function, index, reg);

Looks KVM capabilities are merged with native bits, is this intentional?

Thanks

Zhenzhong

> +
> +    /* Adjust according to "fixed" type in tdx_cpuid_lookup. */
> +    *ret |= tdx_cpuid_lookup[w].tdx_fixed1;
> +    *ret &= ~tdx_cpuid_lookup[w].tdx_fixed0;
> +
> +    /*
> +     * Configurable cpuids are supported unconditionally. It's mainly to
> +     * include those configurable regardless of native existence.
> +     */
> +    *ret |= tdx_cap_cpuid_config(function, index, reg);
> +
> +    /*
> +     * clear the configurable bits that require VMM emulation and VMM doesn't
> +     * report the support.
> +     */
> +    *ret &= ~(tdx_cpuid_lookup[w].depends_on_vmm_cap & ~vmm_cap);
> +
> +    /* special handling */
> +    if (function == 1 && reg == R_ECX && !enable_cpu_pm) {
> +        *ret &= ~CPUID_EXT_MONITOR;
> +    }
> +}
> +
>   enum tdx_ioctl_level{
>       TDX_VM_IOCTL,
>       TDX_VCPU_IOCTL,
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index d5b4c179fbf7..f62fe8ece982 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -26,4 +26,7 @@ bool is_tdx_vm(void);
>   #define is_tdx_vm() 0
>   #endif /* CONFIG_TDX */
>   
> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
> +                             uint32_t *ret);
> +
>   #endif /* QEMU_I386_TDX_H */

