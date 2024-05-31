Return-Path: <kvm+bounces-18521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8F28D5E32
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81D561C22094
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBE981AC1;
	Fri, 31 May 2024 09:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m4fScvMl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C8C7710F
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 09:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147644; cv=fail; b=BTOV2/tYYs8AC4J6TkWtCuotxt09eP6+DptE3eZ3JElkb/6D2wkXOuYkvZcni9W4ZkMHXl2NTZegR8zMnKxwb931IHLLalCUBpmpyQmq0wkGNLn/LiIRWbgIMLeOi7zcLhRoDBpsA2TrAonw/C+9KJl/5TJf7vwDSSePLHl0FJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147644; c=relaxed/simple;
	bh=4jHdGInBXHTNIWS8qABkayXdX95qG1xVhD1k1XX2Oug=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KArP0NCtFchW2rgis/rbQk1klLRgNkKpldswe5ZWAZNgAK714cyWMeI1FyijK8ZL/lWZUKodSRvZzJYkOvwA8M2/76c3NfsCPrXq/t7OUrZljJhXA8PbrP4ipKeGTXzV1cvA8AbJDg1tA7tF00LLLH2wnj1uuHX/8+O4ovqIA1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m4fScvMl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717147643; x=1748683643;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4jHdGInBXHTNIWS8qABkayXdX95qG1xVhD1k1XX2Oug=;
  b=m4fScvMl23pCd+Y0UtJQRIJHZxGuxE37h6bGHlzXHyFnC+PxRfjATvfy
   Iipuklk/Cj/BE1DJwuc+gY/fZX5UlT3kLtT8F4iHJWChswvwQeMVf72Tv
   ZZDT+Xn0pdBpAomN38xbDhiRGB1WNu+2Vg9EUZFNorW6kESs3ncMy8uVl
   hbfFI89c0zBffC+IKa9Z0bij3gEHZ+VqhW8sepgkIdFPj4jz+Yp63Eolg
   XwzELh6dN4FNQo5evaR2BPE4JOaD7VVE+2CPdkaeEc/SiO06Xy5Pgxe34
   pRHbop7EYUq2wCxyDs64QDhg747PYj5XeW/b4oaaVk2Zk9ODRA3xBmleS
   Q==;
X-CSE-ConnectionGUID: ZVnfQBATTYKqD+dnSIn/FA==
X-CSE-MsgGUID: FYV6MsGCQQ6SWq4wbNly6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13530056"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="13530056"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:27:22 -0700
X-CSE-ConnectionGUID: mHyqrQQ0RTm0aNCwZZx/Xg==
X-CSE-MsgGUID: O+cGieciSBSembMWvKEtWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="59288252"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 02:27:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 02:27:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 02:27:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 02:27:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 02:27:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8c4Zo9NXk+klxFDihghcBnWb5naCOafCfUzAt1i+J9+HEN+I9b2QSZ4X+cfjvK6uy71/k/BH3ZBKS1tOK9xNsnjeLBfRrgnZWml1naDVy7zvEWit+5ShibU6iADMLtVCce4Bon/wkmlMjsmY1PK4hQaKqd3DdSRyV2H3putHeE4l9dvVtqGjVSmxl7T/HQEzTYCm7mn5NtSAhlNMPxy37lag8N/0wZAcVx+ZCvzx8o0nVf2ZvGKNkl8/MAHBRdNjOQPcGxBuxxlejYxD0RKj3cqxwUtJSIjOg77UovBQhm4viEAqFp6M70aFd7XFW0GlFF1VT6iAC/1dweSDGH2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xu2T9KrS4xlRo9/4C3729VhgddhZE6+jH/RUZuMotQ8=;
 b=VDB58DctC4+WnOnZZN9L1rvPxIDCqp3QrDFVhqGGSHlFEU04YoR9pYHPw82dZ0lS9fIiNUaB4Vjr14XehuvuG1pXYARoNpg6e/FRKAici3PDqb7QVmYyIanmns3znI50ZX2amPvH2JI4m8lmlTh9QMT7FmKZVl3G7kgCipETtnLsPiHwTVW7JfyySahks6P5pP0KtTUv/QvsLTqdXJLJ9LKe91x8ZJTEnNHIrMkwhsWy1xtX+f+f3EtSPQ/xjqeNIxlYuTZQTaXcakK0oR+ew2joXwhQAgP3TAAg4CsCImzHwk3ppYjR1Ks7MgkbmAjQ9ddtdGOwXTBytn8EB6jzeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Fri, 31 May
 2024 09:27:13 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%7]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 09:27:12 +0000
Message-ID: <24b3a66f-99e1-5301-52bb-f9a9aadc9a45@intel.com>
Date: Fri, 31 May 2024 17:27:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v5 19/65] i386/tdx: Update tdx_cpuid_lookup[].tdx_fixed0/1
 by tdx_caps.cpuid_config[]
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
 <20240229063726.610065-20-xiaoyao.li@intel.com>
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
In-Reply-To: <20240229063726.610065-20-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0109.apcprd02.prod.outlook.com
 (2603:1096:4:92::25) To SJ0PR11MB6744.namprd11.prod.outlook.com
 (2603:10b6:a03:47d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6744:EE_|MN0PR11MB5987:EE_
X-MS-Office365-Filtering-Correlation-Id: b18294f3-51f3-49a2-e2d3-08dc8153da54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dTJCSW96a3MyVDZOQkdPdng4MmVaV1NpUTBTYXF1ZTNEb1dUUFk3clhFc2Va?=
 =?utf-8?B?cnl3bGYwWjM1QXFyRTBhSXcrMWZUSlFPcy9JUy8vOUtiYVRycS9rVGw2bDRM?=
 =?utf-8?B?ZkRZMndhcW5CVlJrTzYza3JIOWMxZUg1QmZiL1JPUTdPaTZ2MDNFOG52bmJk?=
 =?utf-8?B?QS8ydXFQaFllbWhtRC9qb3g1SGdjblhIbkJrS3JWblNDeVJFRVk2RDBBN1F4?=
 =?utf-8?B?U1lqOW5qSVpQNUdJRlJDaFRlLzRZRmk2ZzhERVo1WFNNRnFaYW9WWGhPWUs5?=
 =?utf-8?B?d0NQcmNNSTdPTzJvZHJBZ2NDZStoQWlxWTFsU0xNUXFzRGQraC90SjgxbTc4?=
 =?utf-8?B?SHJvdmpFVnBhc0x6eVZQeUdJV2xGektUTnZHVFA1amFWekhVZjAvODBTRnBR?=
 =?utf-8?B?SjZZbkhXMGNjdDU1WkpVSVdUcDVhUnpIVi9LOVhGR1k0RzRmSGJlL1pzN0ox?=
 =?utf-8?B?TXlncVRBdldRR3lNY2N2MXdFUUlvN0dBakhBMTA1aHEvTzlJNG03eE9tVys0?=
 =?utf-8?B?SkN6c3paNE9nQTJKL1BwWjFYS0RHa0lYRVNQaklDdFFqZ21NaEdxYnFLWUZy?=
 =?utf-8?B?L2l2RVJhRXdzTnVpNGMzUHFTYlpnaGp5YVdHK3ljMUI1UDVDZGNBSmNpUWtk?=
 =?utf-8?B?N2pBallOQ3pjT0I4UUxvdFRkd2xoR3BRMnNLOCs2M09jTmNsOFdxQTk5T25Q?=
 =?utf-8?B?clBDMmVJa3JsVGNrcm9YWEc0U25QVnlBeS9rbGpKMFVBSlVMQ0grVytaazhw?=
 =?utf-8?B?UUtUbGlhL3RjM2NHaE80MFhScmVyOWN2WGphRVkzUVA2M3JZRlg1M1FNeHdK?=
 =?utf-8?B?SHZJejBMSktBTExyU0laZmtlTUtmdkdjTzV4dVZBRE4wOVdjZklCQjR0REU0?=
 =?utf-8?B?czVNRDhSTmJ1YjlEQ0V2aHhwTGFpYXBKYlI3S3Jobm9ZU0NRYjVicWpGakNJ?=
 =?utf-8?B?dzVlMFVHa0JKTmVsWTVzbmtLTENEaGNaQUZyVTBBWkZybTR5OERkQ2lxVmxG?=
 =?utf-8?B?R3JvYW5lZ1Z0YUJMa0RBNEFYeWd0cG9FZzY4bXE4WWgzeStFZ1FTYVorZndV?=
 =?utf-8?B?QkUxVkk3eWxnNzkvRml6SS9oaGMxVlBLYmFScmJodno0UDZRVTF4OG8rWFQy?=
 =?utf-8?B?cWNxWXlMbVdGSUhrZWorVEFDRWt0VlZrZ09iOGVDQ21MWnZHMVJ1MlQxaWdk?=
 =?utf-8?B?aGpJeHJWOXRVb3BscGNIUi9jaGFOOEtmQk50K0UyTDNhTUQ5aTFKZ2N6ZzM2?=
 =?utf-8?B?M3hObC8yUGMrTXhCUDFTWTBOTW5PeHZRRkJ1UFFQSjlCUGZCWlJwc3Nnc1dE?=
 =?utf-8?B?cWlPT1labDhvMmc1SStnWEpIMG9MbmJtenBOM1ZTTmtnN1Q0Vlo3aExqTWgr?=
 =?utf-8?B?ZmYybkUrRDVCU1JXTnlneWhyOGZqRXB3UGlUL2RPTEFJVGZsUkFmcnh1RG1P?=
 =?utf-8?B?K3MwNDZZYXI3QWFxN2FNMW0wVkFFbkF3Y3ZlZThPNXl1azNjVDQ3QXA2am42?=
 =?utf-8?B?dUZ0WDRFVzkwM0NoRENGUGpPS002YmhSN29tZThNZ2JzOStSMG0rYWJBaE9w?=
 =?utf-8?B?MU51R1lvaUgyd2pqT0kzbTk1OTQzdEZ1WEVJS0pBMW5uOUZ1cmdyQW1iSjJN?=
 =?utf-8?B?Y3I3alNRd0RKMytOS3lxdlorRFVJbUhxVldUNmp2SjhRbzRQd2hqUEd5SkdR?=
 =?utf-8?B?NTVLL0JRcmR3Q25kbks4M01ob2xzRXdxcFE2b0s4OTBiZ0NzOHdURlhKOC92?=
 =?utf-8?Q?DRlrm/8riV1zW8WZjUG8YlX6WEKUsClHX3XrcH2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDNlbVlzcHY1Zm9HdDRLTXk5S0pJUHhpZHJPZ3VhUk92R0Zsck40ZDlTMXE0?=
 =?utf-8?B?MFl5Q21oL2M5NDBSd1JCWEFWSjNGMStNeVJiUVFhcytmNDRIRURrWkdyWDRa?=
 =?utf-8?B?YS96OVBqdmFSK0dxekRrUEZJWTFrTDZyN2pKSS8rVE5FTkpLWWphQlpFZW9t?=
 =?utf-8?B?VmxlWWFzR3VkVGZwVGUwVlA4NzRTUy8vTUtzNVZpTUIxMGNiV1VtT3FhNzJh?=
 =?utf-8?B?bmk5ZUFYOStKQi9tNXJlbE9WTmliOE1OR3E1S2gwWnpqeVd6bHJ0VzA4SmpM?=
 =?utf-8?B?VEY3b2dzK29Xa01jMmd0TklrWERDeFRyMzYxY3N4SmtsZWNVNnRkL2NQeUx2?=
 =?utf-8?B?QklYaHNrN2FlNndmV0xjcWlLaGVDOG1ySVRKa3lkUkRldXpwSTdUUnlIU2l5?=
 =?utf-8?B?TFY1MlNzc2k5WlJ1ZGE4M2t3bHJTSElTZXM1VWoyMXN4MW44elZTS01NcHlj?=
 =?utf-8?B?bUJuZG56MDUvWkJNSlEvNEdkSFp1ZllDTTlMVE1FQnh6dlJWK0RlTU10N29p?=
 =?utf-8?B?U3RXQnk0L1dzckJYTFJOeEFyNHRlQktQbUo1V08vZWhETXY4dlZtYWY3MzZp?=
 =?utf-8?B?d3dLanZ5Nnk2dFdZRStuYUpEV0J5aHRhbWtYWTdtOHhubU4xS2ZyUUFUS1lE?=
 =?utf-8?B?cnEwUTRTL090OHFvVHpJbG01TnRzYjFRN0M0bnlVZkxRTFpjNVo5eTY3dlZW?=
 =?utf-8?B?TnMyak0vMW1mY082OHRSQUFyNVdQNGhaWTM3aE5kMEsvZk9VREFHRlBMaTlj?=
 =?utf-8?B?YkZlWkdYcWhLUFhSZ0pVd2EzNWFRK2JLRWlYUUxRZ3VraXBISnRkVldTNytQ?=
 =?utf-8?B?eVdwYVBnZUVlMXVpRXpQRDZwZVVFbmdPZDZ0UHlGcFNIR09EUVJzK3E0L3VF?=
 =?utf-8?B?a3NFYTdUZXNZYjVUcEZKd3hGQ2x0QVQrTGxhYU51NHEvZHRsU1dPQk5LT3Br?=
 =?utf-8?B?WkFOd2UzRmtramlYTHlObVNLMVFUUk5FWUxxR1VxNVBpSkZoUnBNaW5UbGVu?=
 =?utf-8?B?eUpFeE40QmNnODlMRmFDYVlmYW45bldqT2o2TkJINkpkWTNGZjFNSTREWVIx?=
 =?utf-8?B?Rnl4QWdNeDVibFJSaVc1enhZV3ErZGRrSjdmRUpOaFRtSHZJYnFRbC9LWW9Q?=
 =?utf-8?B?RjduNGRtQWI4ZVU1VTZVZDhkaG1Hd1UyMHJRNEdVbis0ZTFOeHF2UmFGRGdK?=
 =?utf-8?B?VmFqOU1neXR3VFU0Y0xqWjQwZ21lWk5tYWhxK3hleENRNUMxc09IOS9jUmsv?=
 =?utf-8?B?MUI1NnczVnhKQXZVN0RKMTlSSDJOUGxneUlXQjQ1eElYSEtkU2o4M3ZnK1JO?=
 =?utf-8?B?UU4xVGUzZW13S0dSbXFHM3U2LzdyNTJBSXFzR0VQRENxVEtWSzNPd0FDZURk?=
 =?utf-8?B?cEVoOUxrVTdrRzNiQ2U3bnhibWUwM1NBUFBYS3JLSTBrQ3NXNnBJazlNTmxU?=
 =?utf-8?B?MU16dkFyR2hnd3BUM1k4V0s2N3JBQlQyZEl3TjM1djlTN09yall2ZllSTkR1?=
 =?utf-8?B?L05JRDNPL0IyRS9KZzVNSUdraWdYNEpiL1lwbHdabnJoWE1kMGorYitza01u?=
 =?utf-8?B?NHVXMkQ1cExyUGVFY0dhSktNNFpaZmlQYXoxdFZ2TnZQNkVMc1E4Y3h3dVRs?=
 =?utf-8?B?QnBQZzBFTHNEbzVyMkcvS0NDU0lpand6Qk9NQ1l4YXlBcERDRDE2WkM5WGJL?=
 =?utf-8?B?VmNZMHZYc010UWozaDJLRHdDLzk1TXdHSXJlTWtqNVQyRkZiYlFGem9NSnc1?=
 =?utf-8?B?N1UrT25GeVRQdS9aczdtNDYrdmUwaWs4MXRvRXN2eFIweUk3YzE3REcrUm5r?=
 =?utf-8?B?YWJidzVrYnVMSng4Z3VyWW5kbWZDU3pEUDNCMTBJMTZxZS9VaWVVdkkxZnJk?=
 =?utf-8?B?NWFuY2FZaUlBUjBOVDNUZmhOY3Y2NFZVbkF4ZUFtVjdLMy9ydFNmY0NIT3Az?=
 =?utf-8?B?OG9kVGJtSEY2NU1kVlVmcHhBMDNXNjZIUWIyUlBRTjdUTnNBenRBeC9Zdlpu?=
 =?utf-8?B?TDRFdlBZenpnTGdIZ2lZL08vVmpVTVFpSFNibG9FOXVtTk5rUjcvdFBheXNH?=
 =?utf-8?B?d056YklSTS9BbTdXUkRhNzVUQVVCTjBWZUR6TmdKWTFickRVRERyaDIzdlVq?=
 =?utf-8?B?Y21veFlqTEIrcElGTmU1ZStIazVYUjVKQVFUYlRWMEk5UW5KbTY5c1FZVkM4?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b18294f3-51f3-49a2-e2d3-08dc8153da54
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 09:27:12.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8cslftxQaklm5WnXMuOndcoR+th/cCPHDrVQ+VJh4QZewcxjEMmSnJfHXxwMCG8jb3UmE3d+eqMvpnUoQMOO8IOqb4g9CqRPfYxFMsrHmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5987
X-OriginatorOrg: intel.com


On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
> tdx_cpuid_lookup[].tdx_fixed0/1 is QEMU maintained data which reflects
> TDX restrictions regrading what bits are fixed by TDX module.
>
> It's retrieved from TDX spec and static. However, TDX may evolve and
> change some fixed fields to configurable in the future. Update
> tdx_cpuid.lookup[].tdx_fixed0/1 fields by removing the bits that
> reported from TDX module as configurable. This can adapt with the
> updated TDX (module) automatically.
Can the fixed fields evolves to other type, i.e., native?
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/kvm/tdx.c | 34 ++++++++++++++++++++++++++++++++++
>   1 file changed, 34 insertions(+)
>
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 239170142e4f..424c0f3c0fbb 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -377,6 +377,38 @@ static int get_tdx_capabilities(Error **errp)
>       return 0;
>   }
>   
> +static void update_tdx_cpuid_lookup_by_tdx_caps(void)
> +{
> +    KvmTdxCpuidLookup *entry;
> +    FeatureWordInfo *fi;
> +    uint32_t config;
> +    FeatureWord w;
> +
> +    for (w = 0; w < FEATURE_WORDS; w++) {
> +        fi = &feature_word_info[w];
> +        entry = &tdx_cpuid_lookup[w];
> +
> +        if (fi->type != CPUID_FEATURE_WORD) {
> +            continue;
> +        }
> +
> +        config = tdx_cap_cpuid_config(fi->cpuid.eax,
> +                                      fi->cpuid.needs_ecx ? fi->cpuid.ecx : ~0u,

So the check "cpuid_c->sub_leaf == 0xffffffff" in tdx_cap_cpuid_config() 
is unnecessary?

Thanks

Zhenzhong

> +                                      fi->cpuid.reg);
> +
> +        if (!config) {
> +            continue;
> +        }
> +
> +        /*
> +         * Remove the configurable bits from tdx_fixed0/1 in case QEMU
> +         * maintained fixed0/1 values is outdated to TDX module.
> +         */
> +        entry->tdx_fixed0 &= ~config;
> +        entry->tdx_fixed1 &= ~config;
> +    }
> +}
> +
>   static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>   {
>       MachineState *ms = MACHINE(qdev_get_machine());
> @@ -392,6 +424,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           }
>       }
>   
> +    update_tdx_cpuid_lookup_by_tdx_caps();
> +
>       tdx_guest = tdx;
>       return 0;
>   }

