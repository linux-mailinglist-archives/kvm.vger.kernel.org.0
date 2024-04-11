Return-Path: <kvm+bounces-14359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACA98A2205
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 00:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13249287E9C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E81247A48;
	Thu, 11 Apr 2024 22:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="in+k+h62"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABCF17C8D;
	Thu, 11 Apr 2024 22:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712876360; cv=fail; b=V5IhLXu7vP/DsLNtsUzXY2QLSOziICFKb04btKw4XBcvgA5XpeujJutQIDmYXUSLcubfldR+S5Vlnhip2NymcW0BFCHOOlWwKQmXwoktAqz8RH90kD7QJZovBNUrPyf5Sabbs0Zx7N87razkO9r/68rt70rxkZs6K4M0DCpI8ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712876360; c=relaxed/simple;
	bh=gNkLMAqOgBOa1Km7mMwoi6S1YCGQLmrcOmL/5IUwarw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GHvSOBNti3GHpr66KiqOiZ5mQyzcR3+DtAq9Y8mRd+RgC0gDbTXxJca0Woe8fyijO91oMJ+iOeQfvtj9q/QfCKLnqRn2SLYMFcJSVen1173IB6lkDHOfkK0cRIDJ51xV/44qV4OOXGyudnUnoo7dV9ubf5L74kVdKuSyNwVx2Hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=in+k+h62; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712876358; x=1744412358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gNkLMAqOgBOa1Km7mMwoi6S1YCGQLmrcOmL/5IUwarw=;
  b=in+k+h62EQBrc7OVTSYGq17LNmDRBAQoAmhtGEARqPg+42WFY53AFsF2
   E63Tk8cqQbsX2UPBgZYDl3Se7qMnXxb66irHdDpG0fePb6ossTlxYy/PY
   KPeNBPA5UMnaLaSjxP1VNZGW8i+cFd3kpeYRRkCDWG/g/bQWYdjTumeBv
   l/aN37aJoNhu0w8uuCgDWlIrDpfd/k+W9pb7y1R3NRL1Jqiwll0lWcxiJ
   e+jZ6VbK2mhBLim74qv3BFhU38juWZsL8yNKa+hLT0ll5tYOMe/xLyPIL
   XueNeK6RzFWBALe5TY2AyLHeAWwHombuVRFbuBpW/VCgPyl+Q07u9l9KB
   w==;
X-CSE-ConnectionGUID: wroSvfJsRgqOIcB1Vr7N2A==
X-CSE-MsgGUID: 652zUCqqQ7q0ry8yOv43bg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8484600"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="8484600"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 15:59:18 -0700
X-CSE-ConnectionGUID: itaEf5ajTYyqP2ayLK3d9A==
X-CSE-MsgGUID: sCMEa4idRWqhxh+SHY1Ulg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="25843769"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 15:59:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 15:59:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 15:59:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 15:59:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 15:59:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxN6BajUdXWPNGxQVgoAD96TPY+J+z7noBukTfUThPUbGPPuM93s3xCAywJThViaPoUeciqOdYrIb9BIEJ0fVL50qb5sgLZmKy+31VLVSd+7i9jPXZBboaerDeCQBzf/+oZRCSHYDbjttwWAXHSZRcta2RbTFbNeseHfnUoOzqskdTHomvxKBgA2nHigaBPQzsbvmsbxwsflXAX2fuYLPRA2Wp92ObSbgX3wCUn9wQEQkLEWfuzEcpsMqlw9TVgGwMFlmaF7nwgwHjvhRMB1LCS6hqNv/1G5p/jE/KjrxRPljeHa1LJnttI68kUzbZ1EnuTvKYUUHi1x9vp+Cgz2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMQt6ANvhMyN3DHloBQLqby41lcZEOeWkUvhV5em5lw=;
 b=aGNf8BzczhrLbJJpywIf12kaCeyDX9hrctcjljxg3aZUVlBn8xOP+NDD1tbkYNzIMT4TO6bpeNdS1NDWZ0g24noDePJNXnjCvVFgyKNEqt/tTOvJ+sv7M3d606wvl0t0rW8nNmAetRlvDwYxlapBjIsCaW7g97x+g9OHDZH5D8fYGpWqlkqm4uNG/IidKNivexxRjmTxgOxTDdVAVc6BK/MzGrt+t0FjWbB8wcB5nnBSCGBmHj4fL3zDnegPmPYiuCIwFyphKpkOfyYpCKZLS4fdC2jqXqPdMebvl1YbJvGS/0bswpTLdX5dD4IyMhmvkbtzwGwZtJpNfBEG4wA29A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5268.namprd11.prod.outlook.com (2603:10b6:610:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 11 Apr
 2024 22:59:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 22:59:09 +0000
Message-ID: <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
Date: Fri, 12 Apr 2024 10:58:58 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
 <20240322212321.GA1994522@ls.amr.corp.intel.com>
 <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com>
 <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zhftbqo-0lW-uGGg@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:303:b4::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH0PR11MB5268:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc1051b-35a9-4a59-71e0-08dc5a7aff34
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DSyIIyX9yqxF3pFOMEwyQV3GBuAr3cQSmGlJ2Bp1Nd8cO2p+lDfXPC3Q/Dr+w3CtXB542miJLNWNNjplR/81hcDELch90pI9NJHtWfavm0Mc9DrCDOjVWRX0zKR+dILARSLbsDB3+8PiNp/CCGNtJF33n0ht2Nn8IjDiWIN99NWJFoge55tf5l6Xp5vF5NtSgPYWoQLjfcyZPbqP9+Vsu9UiY6A8dCz8HIrnHD0QJxNYhvjk7sQ6qyvnQiHHH3HcKihJODcE7E9IDjTi4ut5bNuqqgIyQ2dH8LaVv9l2+4w0es4gHwV17J5K4qihcLbofcwvDw4NyIOfe5tUrg91ch2UY354y50EZ+EY4PCoRubKOo70dFpMI4FT3suLQ1wCSbfczpJ7DqHiJ7zQr66XLqj3lpDn19X9vHxpj26q0Dw6dosuG5nb45GWmg49sDFoFqZ9F16h2qCeU2KURPNhBWQapD3IUzz4qnYgsqiDnK4tO3DaUtdSAYyLSoFYcdJ+lf8M88AKi8EruApxk+iLbBgz4swdpA1rPhDGyFdmjDQIEfxnMR2yIKqLdWfbXk0Q+NZTmPM+aH1qL3/AYi2zoYT6dLwNkDQSrmbXvrvcc0q/kBk0HwTS1MsaNs3NvWjKSYD+3EnFSWu43Xu7CuNVPwOJN7BmPPvcxILxormgJVY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWlFUVI4WmRUYWIzY0R1T0kzOVJzcElJQUVNTjgxRCtwSytKTDBqQlpwd05m?=
 =?utf-8?B?RUhUekljY2ZubTJiMGdzMWpDaGNJUC9paEhVZmZRQnp0Q0pZRDNOMG5PTWw1?=
 =?utf-8?B?V1ZUdWo0L1V3Qzh0UDBFOXN4QXpRQ1JTTi84M1NyRklUUEFOQTRkR1ZOOTYr?=
 =?utf-8?B?d2xUU3VmUURtSUtkZHhkSkptZzBXbGlQcG1SYU1qK3VMSWsrd2VoSUs2YzVm?=
 =?utf-8?B?Um1yL01ZTWQxQlNFdnU5S0hvUUFad1BHdlVocERFZCtyRWVhaG9vTnRzdnZS?=
 =?utf-8?B?ODJoUEU4Sjd2UGNnaXczZjdKbmRReVJveWx5U3Q4UGg0Qm8rZ2VPS2x5MTNh?=
 =?utf-8?B?ZGcxOVBHSTl2cDhodWlaTndzZHk3bGEvQjJHNnJ6K3pucWRkU0hYQm96WjNa?=
 =?utf-8?B?RUVzWjFzMTZ0ckJDTkp2Kyt5NUdWalVNM0E5QllCZUQ4c1F0aE03UWYwV012?=
 =?utf-8?B?Q0lialJPd3cwUmV4MkFha3RkR3dDOFFnVFpkKzArU3ZjNkdzbWNlSUxRQ3Jw?=
 =?utf-8?B?RFFtbnpZRmtSNmJFWEc4YnZRVlVSR3ZnVWFkZGxTejJHM0xsNHlURTNVNXND?=
 =?utf-8?B?NHk2VlpSQjVhYmJERlRiWndKZ1NSekM5WmNzc3ZRSlpjWDRaWFV1NnQwYXZE?=
 =?utf-8?B?cDIrTjVDb05zNVh4OXEwRTJ6YjFEMERsc0pXeVJGREhwYTNGVVAvaU9HWkxC?=
 =?utf-8?B?WVBhMkQxRnV6ZHg0LzFhTFhzSjdXVXVZK0dGTngrRFNtMkw0aVUzejVhSmV5?=
 =?utf-8?B?NyttQ2xueDBNOHRJK1ZYZWlVWUV4dXVZSXZQWXF5OHczczVSTzl3NU9hUytI?=
 =?utf-8?B?U3I2U0t2NlFsTDBvajZ0ZkpkbUxQMXQrdnJsTnpKNzMzYy9GZlF6SDNjOHhS?=
 =?utf-8?B?RERGb2NnWEFpRHgzTmxnaGVudTBUN1Y5Z3dhb2JhQ0tUNnB6UXBIQm5lUms1?=
 =?utf-8?B?dXVwVE5NdU15VHRxM3dRTG01NlBKL09QbWpnQ2hUaUlHbzNtUFFqUGdKbjdm?=
 =?utf-8?B?V0pjLzV5a21GMFdWYTQyZGxSeEUxclJhRkcrTklXbkJhTzF6N1dheEt4SVA1?=
 =?utf-8?B?aFdtOWtTYnNQeHhaOHJ5bDZjWEZubHozWTNjcjhLa0greE9VMDFybW5OUE9n?=
 =?utf-8?B?WEJDVFVlSkZUenFFQVk0TERtMGdvbkpzRU1VcVNrVUorejRYTDNPcnZOd1JG?=
 =?utf-8?B?NlltRThYeFZqUTJFN01aQUpveDF1S3VJMStHblltQnZTNDNNSlNpaUlwZlU3?=
 =?utf-8?B?c1RGYUtJYTYyMzVxR3BZMk9aUEVhanRoUUp6ejJEM29QMFpiamFwSUgwUmxx?=
 =?utf-8?B?cnAyUkNuOVVBcE5qajlsRUNrVCs2Z2VlMEQ3ZjRCV1pndC83cCtXdEZ2QUVT?=
 =?utf-8?B?b0ZlUnZkNE9xWS9HZVljcWc3ZXBTYTNlTUlCWndRNDBZci8vM2FxSWoyakFR?=
 =?utf-8?B?Y2FJU2thaUd6ZUxoSEp2Q2F6N0pSdzdpUVpUR2ZETFUra2c1VlZKRVlNK29l?=
 =?utf-8?B?TmlUQTAxM1pSOVdBT0VyUUR5bjlzYVVQUStWOFJOd0J5L3VobDN5SHlLSW5H?=
 =?utf-8?B?MUg0VDl5d1o1cE9Tc2pndzB1Z0VnYUFkRi9BMGpuNGtSZ2ZySEo4WjFTdE9L?=
 =?utf-8?B?TEpYbmxrT3ZTU0NpVm40SEZJRGR2M2JmVmNRYzdLZmZLK0ZWeFZnMXBpZmlh?=
 =?utf-8?B?SW5TZjdCdDRWY1lkckx2UjAyVFU1ZFNhRUxJMUVoMlVGVG1tK0xLU1QrNndy?=
 =?utf-8?B?OGxIZlNaL1VubjFTT0tqQldSSnNPVzRraFZDYUdMOFB1Wi8wVTZjdGNkNWty?=
 =?utf-8?B?dVNqZW9lMTlJdVFhaGs2WjlFMU1uN0tDbXptMFpjV2FkckFybUhEbGV3bFpS?=
 =?utf-8?B?QUFJWVc3SndCUHp1NGdrN0hreVNCb0o3akhXZDQ2VkRWdnpZSU9iODEyYk5m?=
 =?utf-8?B?cXRaWExEWDJ0dGVUZTZGNnRXb3VPSHYvUDJuZ1h6elg3SkZOcXk3ejdYd0ph?=
 =?utf-8?B?dEhMT0JpVHM1cG5jL2g5T1JzVjVOeUp5QStvNHc2VlVUNzlrams2bXR0RnJO?=
 =?utf-8?B?c1hwYzB6V2NUbE9DajUzRWtObkJzcXBxTTcxckYyVDVYMnc3cFRTZVI2OW5W?=
 =?utf-8?Q?cR0pQlwA0SEHOn+/ovdmknJoo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc1051b-35a9-4a59-71e0-08dc5a7aff34
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 22:59:09.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fpS71L3eaCqoNGDl5q3t86+dVFXZbA3Mf5VP1dlNCvf4TP3CuwcL+O3PWLHsF7d1iCAuuoYTM8LPdpRm2U3tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5268
X-OriginatorOrg: intel.com



On 12/04/2024 2:03 am, Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Kai Huang wrote:
>> On 11/04/2024 3:29 am, Sean Christopherson wrote:
>>> On Wed, Apr 10, 2024, Kai Huang wrote:
>>>>>> What happens if any CPU goes online *BETWEEN* tdx_hardware_setup() and
>>>>>> kvm_init()?
>>>>>>
>>>>>> Looks we have two options:
>>>>>>
>>>>>> 1) move registering CPU hotplug callback before tdx_hardware_setup(), or
>>>>>> 2) we need to disable CPU hotplug until callbacks have been registered.
>>>
>>> This is all so dumb (not TDX, the current state of KVM).  All of the hardware
>>> enabling crud is pointless complex inherited from misguided, decade old paranoia
>>> that led to the decision to enable VMX if and only if VMs are running.  Enabling
>>> VMX doesn't make the system less secure, and the insane dances we are doing to
>>> do VMXON on-demand makes everything *more* fragile.
>>>
>>> And all of this complexity really was driven by VMX, enabling virtualization for
>>> every other vendor, including AMD/SVM, is completely uninteresting.  Forcing other
>>> architectures/vendors to take on yet more complexity doesn't make any sense.
>>
>> Ah, I actually preferred this solution, but I was trying to follow your
>> suggestion here:
>>
>> https://lore.kernel.org/lkml/ZW6FRBnOwYV-UCkY@google.com/
>>
>> form which I interpreted you didn't like always having VMX enabled when KVM
>> is present. :-)
> 
> I had a feeling I said something along those lines in the past.
> 
>>> Barely tested, and other architectures would need to be converted, but I don't
>>> see any obvious reasons why we can't simply enable virtualization when the module
>>> is loaded.
>>>
>>> The diffstat pretty much says it all.
>>
>> Thanks a lot for the code!
>>
>> I can certainly follow up with this and generate a reviewable patchset if I
>> can confirm with you that this is what you want?
> 
> Yes, I think it's the right direction.  I still have minor concerns about VMX
> being enabled while kvm.ko is loaded, which means that VMXON will _always_ be
> enabled if KVM is built-in.  But after seeing the complexity that is needed to
> safely initialize TDX, and after seeing just how much complexity KVM already
> has because it enables VMX on-demand (I hadn't actually tried removing that code
> before), I think the cost of that complexity far outweighs the risk of "always"
> being post-VMXON.

Does always leaving VMXON have any actual damage, given we have 
emergency virtualization shutdown?

> 
> Within reason, I recommend getting feedback from others before you spend _too_
> much time on this.  It's entirely possible I'm missing/forgetting some other angle.

Sure.  Could you suggest who should we try to get feedback from?

Perhaps you can just help to Cc them?

Thanks for your time.

