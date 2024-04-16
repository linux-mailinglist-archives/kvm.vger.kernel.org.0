Return-Path: <kvm+bounces-14735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B52F08A6626
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA605B24009
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E727F6F066;
	Tue, 16 Apr 2024 08:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IdKbjn2f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4597553381
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713256363; cv=fail; b=CUJMam7jGww5Jr7RQt7niXIsRUpCaAAbwwo/sz3hecOZb3D2jBtOgYFt+lrp7YMqhlvvCoUxjmr0V70y7hlX2qOv8z7/wl6ul26xiHxlWPArgsfUlogqwVCSntYciw9b8awv1EKUOa61l3vGxqQHMCRZZ1inLhunMI1O4DVpBSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713256363; c=relaxed/simple;
	bh=A8Q2GQOU6UI36mxcZ8huwdnA3h903iBlgr89zwsWiSk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kxOPhrlg4CsHvoFLIIJxNmEGP2cg5w3zgeSUXo/TU6tJRpGo1pCJbyqcY2CiCg7FRetcOdkQHtWrugnQDYncyhX4NKGPdXyirUcxjAsI7ZzW56vuIvje8Pu1lRsGT+ffKaJgON1fl2Vx7UNVzYZH2T8FAIJD/33r9X3S7xx0fY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IdKbjn2f; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713256361; x=1744792361;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A8Q2GQOU6UI36mxcZ8huwdnA3h903iBlgr89zwsWiSk=;
  b=IdKbjn2fsO4FyCDjpmb/bMAQ7fnKTOCJ+/vAIPN0O6/81IkkS3EdE7L1
   mQoslt2Z4wmj5LlA+B0B+CMCTKB6ym93dkp7cTye+pmfJYeL+Gzz26pbI
   DApFyK3F6yC23Ow/4kDPaUP13Wd1abRE9soWdD/+vvYo/fxApE59BkPeR
   gQDgyMzeXNZJHq+h9e2dJsVoE5M40XXc5Dif7qFFz46sSRHJQmQOsTaQy
   LZGwQo8ToH7cHSwOcRI17FMXyLrSGpjCuWPfAB5zn5/vPVaoecEdpbEx6
   kvpXYr9Hn0lyyRHep9ilSTe53fPSm/bJluMaa1CTx68dWaVwwIQkDwlJb
   g==;
X-CSE-ConnectionGUID: 6jMpxD6YQQm18aOnBKnR4w==
X-CSE-MsgGUID: zdZyQG8NRcyTcfbdjoNZ6A==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8600333"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8600333"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:32:40 -0700
X-CSE-ConnectionGUID: RH2ANwMRRzu5TNou/DDsXg==
X-CSE-MsgGUID: uVsFMXXpQU6zsU5+Z9KDWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26848138"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 01:32:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 01:32:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 01:32:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 01:32:39 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 01:32:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hL8nEauxhjYheBYES1IvCnZ9zUmjisMJQcw5aXOm8Rdyzg/aufkY/HZOaCowbx7Ip+jf0LkBm9TNMHpP9XGJfGcFWGdRyGNkSjejQoG1/DS3AnXMkuEc60KmyYrC8pTuBebqeT3cYYwVBt+HVnlYxSSWYxgdpbmPC42ViuIsHvaMihHVZY4UkTCUPqVPmY0P1i4YkHLz2t9fPZs5XSiYIkeRJEeVIT7rAcCAk7SxcH3Vbkkm6i+mrBuy9veWrB/L3/bi5/G6TiC4tmRtCOFXDvIldNJZne4LJqQqxi5Esk7BFA4nHy4H1d2PLzVZhgyliidI0aFUuJ8U4sQBLPYeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhk5jq4OwD5FNZJx+DHgiU5vPapWfcAtt0OeTkaaL90=;
 b=nVZ15WX5gt+dLsYDsQH/TjZDDgx4TkBbNsxD9Nl3/xgLf2DrSSfvxm1IDkg9C/39BRLRIIH674/+rW4M4B8NLkPjuS+fBvA7n0ZFgm2jWmnSz6qX+9CawQ1WCV2/nlDayBvOE/5eWqqcJhfGjpXVB++bFIDZqiUOZCru8HC3Azj2zS0Mwg8u32xjVxz6xnDGshYKXTY7qskxrTquf1Q6SkfSY/jdFOo2BaU1hGrRPOUaMrt4xBIHtG0IFDKMLH6SN/2odTflxywVNyM6H7VK/b51Dz4dVDZKcdcTqK8QSeGu3JVjEjG+gK8kS1TCTnJRR5PhO/2Nfjfp6+WeMVPmHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by DS7PR11MB6125.namprd11.prod.outlook.com (2603:10b6:8:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.43; Tue, 16 Apr
 2024 08:32:37 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%4]) with mapi id 15.20.7430.045; Tue, 16 Apr 2024
 08:32:37 +0000
Message-ID: <b89211ee-6ac8-4efe-a9e0-16ae3bec4127@intel.com>
Date: Tue, 16 Apr 2024 16:32:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/65] i386/tdx: Disable pmu for TD guest
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>, Cornelia Huck
	<cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>, Michael Roth
	<michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann
	<kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-29-xiaoyao.li@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20240229063726.610065-29-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To CYXPR11MB8729.namprd11.prod.outlook.com
 (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|DS7PR11MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: a3122923-d3ad-4e89-24e8-08dc5defc59c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6AziujoWJ1RvhWTu7h6KMk4boirT+ifGK+fAIaHL/FoJJ6/wodlhXro/4QmwHVvxOWaJXrfph0lxts0mgSPRhq1RfmDyhoRdKhG1r5nEo2jTCqUtH+Ma0fBgLI+Xz0wDkLB/sSbSooDpnf5pbEnpoylZ5FPaNA65aBt1KHwCocLpkcls17/+9MR8CJlsUDKRffg76SJpejTfwRIcPW6iPVA/UdmHI5bnm1mRqbycXrsP627E0dnSJallEkoPyCJGJ/hOd7A0Dzn12T+PfN3pXENKY+LXAr/UnkoC9vJsXEOvfwuA4btgCMNyZUvcZNs9QReVCyYYiL9Mv8ZdvFGp/RS90BQ6gn+5qHvJ18isbr4FAcSdyUqSsk3VBrN0gOIXqFmnZlJaeSMXtWorsztvSJhdVcUjgIx4CF2uJxWitr4kl+t53zKVuigMEW8yg+NQejGJ+j/wmax77sSa6RcKJvH3iTdTBW3MJoKr+N7RlCRde/YKnoBIMGMTEILV/tO06Ni64jVJ/lSSazClfGoumZzmZ0r3egl0GBDPfnNHMytpSSG75eAz2gdcQF1q4GWrX0peI2vgDN79zAABqRNJ5p3PMMgg7ISwAEGhMw+P0K1RHB1CrjRabpOCSCGqxi8JftlcIEPKjpTTY6p7evNZHyhWQIlIBmSY5sDsy495Fw0loeHInYbVfTRo6TlhsxnDAYF4y/WrCuXknuNcBnx2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFg0d0ROMWlLb2hNM0ZKS0RTNndRK1JqYVpXcmNjcllpRk1wdlpCTFF2UVh5?=
 =?utf-8?B?b01GY3R4U1RLem05WjlZZkM2NXQwUWwvd3hXUEVadUVhY0FrMllXS2JDYVBB?=
 =?utf-8?B?aXpBOHVKM2xUVU8vbkk4eXhhaVRsNkFXTzBkZXhNYlVheS8vQmd6d05kVUgz?=
 =?utf-8?B?ME1Lc2l0djRKblhTT2pLaTZtTnJzem8vUFhWYjUxc2FITFVrRmVSNVFxZER5?=
 =?utf-8?B?Q0VOazdJazNPLzh1cTNMbWJ5Skk0Y1Z0NnhaT2dHS1d3ODU3WTgzSFgwcVF6?=
 =?utf-8?B?UDVueHl2M2J6NFBoZkRXeitTajBnTSttWWcwOGNYQVJXT1duYnV0SklXM0JB?=
 =?utf-8?B?SGlUMi9wdHdpK2xDVlRjb1cxSnhJKzFTOTN0M0ROdjZFUzdpWUVrcHJJOVRz?=
 =?utf-8?B?TTRRTjhVbGRjcVdKZGxWQzJuSVZNRXJYUnN3eG0xSzZUdVlZdXpNd0Rmb2ZB?=
 =?utf-8?B?eUJ2dTJyS1BKTkNtRFJHbExyTkozN2N2emJpSFo0UFBVd1dtbFNmdnl4WDlT?=
 =?utf-8?B?RGxKWjY2d2xBY3lTdTlKQnUrc1BycW5veVlyM2NHbEN6Mk93dGs4Y2l6cDdz?=
 =?utf-8?B?eG85cmFiaW9iQ3RLV2gzcXMvYzV0c3VrMkM2MGxldTZIeW9hNWFkcTMxd0xE?=
 =?utf-8?B?cjFMTkFkcHpYOGpUclYrUndZYjA4N2I1L1pYNVU5eFVCQmE1SXdYL3NEVUhH?=
 =?utf-8?B?eWhTM3lxQ3cxQ3NUdDBYWG9veWxNUW51d1Rsc2Zwazh6NEs2SG9lcHU2RC9u?=
 =?utf-8?B?VU1UUG9sTEUvUVVQYjArbGRyU3A4Yml5UlFCbjVHMnFWNjdpcm5KM3ZFOWlD?=
 =?utf-8?B?S3cyN3dlc3FZb1cybEQxem1rWWhUdzJZSkdMQTVBWFA5NkRwdUpJNXYxUG9G?=
 =?utf-8?B?YWpwYTI3cUZUL0tYRjdLa2M5bm5IVDNJRmJnZHR5ZXBwek53ZHhadXhtN3Nt?=
 =?utf-8?B?N1VxL0s1cjZZVUFITktzQngwVHlUYk8wV1MyTmNyQzFaMlRyK2ZUYk9EQ2Yr?=
 =?utf-8?B?TWhrbkNnT3hHNWhjbDZrUXdRSS9PS0FnQTc5VzhUTkFHS3N4OEliUmhvckpI?=
 =?utf-8?B?TnNUSFUxM0FidWtTOWgzMjNybjJEOXo0cWxxSnNiTDFtYmhQVFNRSTBNeDFE?=
 =?utf-8?B?ZmJnK01xdUpGaFZ0RklVamlRTXFBMlRrUDlXM3liRVBobzBuQXV5T1JSalBR?=
 =?utf-8?B?TFhZWXZjT2Zvd3c0RXcweGsyOHpqcXlHOFVTYVpFdnNpMmhhVkhxSlE3czhp?=
 =?utf-8?B?L1U2TFBFaDlVWkRLM2JNY0hXbkRpK0duK0dha2xmK0ZuV25qdlhXbnE0RWh0?=
 =?utf-8?B?dGJpOC9LbnBpdXFsYzJVckNJelk5bm51djB6N0RyM1BveElXWENCRlJWYm1w?=
 =?utf-8?B?alZodkVwNU5XQnQxcDdSMzNjc21XbWFLRUxDcmFqRU5YZnhxVVNVYUt1M2NM?=
 =?utf-8?B?TUNoOFlKYTgrcytpUFY0L2E4aEwzWUtORGU1RzZKUGZVTFE1WHdEa3YwT2JG?=
 =?utf-8?B?bUJyNjNIbTFib0VEWk1MbVViS0dtY2d5bWpLam5jdTlQenNVaTUrcDZqSzJY?=
 =?utf-8?B?NEkyeTQ4ZG1rUXA5UE9IS1o3OFVqbXpZSnd1Uzc4NjBPV3FIMFBNcSs3NVRn?=
 =?utf-8?B?aytQNVQvOHlDZVZ6U2xoUzhxdFRlSDRrWlFUb01ZWnR3UStISnRKbGhWelMv?=
 =?utf-8?B?U3A0WCt6bHA5dXhtdVQxZEFkZXcyeXFkRkp1RTNjNlB5K0tXdkhZaEtIbzdL?=
 =?utf-8?B?aHpjRGVHN05WaDJwUmViOURZYU03SG96OFFQWFVqaDFWYVljYVpFM09pbTR4?=
 =?utf-8?B?YVJuNmFtSzN3dmFQMitVWXY1RlVMb05OcW1yVmVxYUpsa1dIRERTZWdDVldz?=
 =?utf-8?B?YkxQUy9DVWlKRHpRZXgyOWhSdEo3N2FoczNoY3BmYVVlYlJ3cGJyNHY2Y3FD?=
 =?utf-8?B?ektRbmJteVpsS2c2NXRWWk9vL0FRdlRoNkt6RXo2dlhIelVTZ1poVU1kanNh?=
 =?utf-8?B?NThxVVlwTEtkazBDZ0RITmF6Wkp3alYrS3pndTVTY3Yxc21Rdk15UnJmbVU5?=
 =?utf-8?B?WVMwSDNQQ0ZDcWVtVldpRWNtWWlmSFNYM0c0ZzVhMGdFMUxmL3FLUTZVV3o1?=
 =?utf-8?Q?n/rPrdUYEaTYPkagtFtL2HKZD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3122923-d3ad-4e89-24e8-08dc5defc59c
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 08:32:37.6476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YISaPCRc7KQskEaxA11P1vW+jcBk3Dd/luJcQ+XhT86IjfBLNXI/Xa3ezEofKoiRnao0bzX8YZ/FlF6+pQ2UHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6125
X-OriginatorOrg: intel.com



On 2/29/2024 2:36 PM, Xiaoyao Li wrote:
> Current KVM doesn't support PMU for TD guest. It returns error if TD is
> created with PMU bit being set in attributes.
> 
> Disable PMU for TD guest on QEMU side.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 262e86fd2c67..1c12cda002b8 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -496,6 +496,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>      int r = 0;
>  
> +    object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);

Is it necessary to output some prompt if the user wants to enable pmu by
"-cpu host,pmu=on"? As in patch 27, it mentions PMU is configured by
x86cpu->enable_pmu, but PMU is actually not support in this series and
will be disabled silently.

> +
>      QEMU_LOCK_GUARD(&tdx_guest->lock);
>      if (tdx_guest->initialized) {
>          return r;

