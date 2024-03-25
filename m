Return-Path: <kvm+bounces-12566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C420E88A35E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 644C5B40C56
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13615155311;
	Mon, 25 Mar 2024 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4eP0lvl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC3613C9D9;
	Mon, 25 Mar 2024 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711356234; cv=fail; b=SycEjyXpvgdKZtoguDdB8kkgDbFAoIjIknHtnEV8bI8+hdMFT4E1hxxBx6bLouf14MwDNAq7L8jWIwWSUkmbVnfmgBvry/TmNDXUQ7rjMxXkp6FD3n+KsuGDTzqBeKxrbCAslF1eoZ+axzEPzPCyLqw6ErBdVP4CWudhBVhdn3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711356234; c=relaxed/simple;
	bh=mVqfa7pUT/8B5X5DhVDSF5ndS3J8opj0KV122sKLAxU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Horc+nDfDu2b4xktwEwIsNidxyk3IF9VdfaOMLplGjJPQ1uo9TdQ8dFh/UA8hFn/TscRDBQcN1KxAiurAekuKP1V9UIYa05u3srSGEd9FMnhcmLQ1cuQfyi5aFDXuQw3DdwMIkqKclDETpXrTy8L3ishqmpdvoN3yU+Bw+ctUHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4eP0lvl; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711356232; x=1742892232;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mVqfa7pUT/8B5X5DhVDSF5ndS3J8opj0KV122sKLAxU=;
  b=W4eP0lvlVCLbshQoHuq6qhutJU8mWCyU8/er7v8vkjBxRYJJQsjuVMT3
   J0yL5TIgDU7vXsLOn809rtPWiFHVUdDkPE43kjsmeNzr2MWtVeFnBK+SK
   rD1EkZf8N/khiu/jdz/2XDVgztsjpY0KZ8AXOtlVnx0PeJPsd4013sAEc
   +TB4LinkrWM9krt/vdy/dCdJRInYAv8bHcpnBLDkDw3Px1p1fqVLn+UY+
   SmIN/MTzOueqAhHshGG0M8xzgzsumGpYEhsRznWsH+b1k2wsWaqTyQJbV
   psFU7iAP7yKdUpNerW2La++gXbW9zUAxIZdw0oD1uHyKByIQE4xZpIx6N
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="10142176"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="10142176"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 01:43:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="15631758"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 01:43:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 01:43:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 01:43:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 01:43:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 01:43:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrHVdXFvu9Pnn2GKNHed4dAsGw8Z71uwVZbbcK+nc7ea2o/vsJQHYgtkymzxgxugje7Ny8mGLDthIcee/n1Kp6AHWaIWjaQflNUjA4XHW3hBhaSKwS0tGjRWQmzmplsvJi0igOwN2Oq/SDLup+MXARiDGK6MpbriAXyiB9VnuQjjVoZeksv2D79uMu9cN3XBmD0yNfALXrFuWiT7iERabOTdhfKZ/XKRqXDlFrYlfCOkH6ew9UXBBXoWan2m+96x2HyuYEwFJ5JYCu0pvYMTJrwJwv74keb/jaL75iGKy8CcH0WuAGjdxz3OCd5nWpj7t8CKPafWJ1EOpYSjcOjrNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpvETG1xXCaOEO60Qq1P4C3eYhVbpi/3owfh3Egl1wM=;
 b=ocJrql/uzZ4PQcMeBbqfWbfYdS+YNYnMa0Xm13b9DwzH8xEqYaX389dVnUhLtFRDwo4CxqoEWwdLHBPyWRFeU2BAQhYdHC36UuzGjufW0oVODM9KPJntJaAhFhX3hybIZRTQwCqalefS+DzwGm/NjJWBlPPgt1kX0crMTxdbnQxRmnLCxZ/4w6MVOkhOU37SyWEHOoFzQj5OaLNinM8vSBJKGAXmd4nnUjpsUUD+J2vhfSL21JsHZyUIUO7ZTkyHK3EjzOwEBp8Hy/3+IaEGJ1mrH6ryvuzBTFO0UHXfkCi7U9qoTLnZFWWrPToMtn7iSrzlz6tvI+2deqehNnOgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4663.namprd11.prod.outlook.com (2603:10b6:208:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 08:43:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 08:43:47 +0000
Message-ID: <d4014bb8-168e-4147-9554-bab22b0f4afe@intel.com>
Date: Mon, 25 Mar 2024 21:43:31 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
 <20240323011335.GC2357401@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240323011335.GC2357401@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0023.namprd16.prod.outlook.com (2603:10b6:907::36)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MN2PR11MB4663:EE_
X-MS-Office365-Filtering-Correlation-Id: 030d6a5b-acad-45ac-5518-08dc4ca7afab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtsSwDZzhtd6kGY4qTuOUDTw2cx+/2nlqyZOTSHQ2QaKQtlZQT3f3xj3nIRwVwK0/nTGAbxcrMlmI6rie6dwXd/sulhkbvubk/8BzDcY+lNFuXsm8jO5YhPGpY+KZI+vxD8Jm61iCQHkXSwdhjIeEQNDif5fIld8BFT4KZ0xuPB+6g94wJZyuwYwmkHKUkdpCcVrJhM4fIJXKgrxy/wqET3YiVn4niJSrTRHWHMvXkqVVCMP2oI22+C0nTT3ggGGDOJjbrNKEirhYfHeB0bE3Tr+MigpM7mDQcTrby8/kDAQeX2Osfe8W7fGgCfq2dtsDcl43jHZSDsOZQxkBDghc4g+KIhixcN4hyfVcupAAfndPu8Ib6RjMag96r3ENDgVLRxvap8nXTrggApYhcrl77O/g8qY6VLRKXfEhBPZIeuVh454oQC2vjk1fG4TPBRoEF+hBLNJcdqS3t8QTukiQ2ro50JFnfoRGE2BY3ZYRzkhtCuaViP7POCaNzt149j1ydTUCLAD6DRKgUpBFpNxVKUrIEmyLN9ussGO6hrK+7u6c+FhztFwh+67feouP+Nwosb/vsqo1LBfOCM+N43eC/bPURLxjUUdV+H4RR14xnpNypY33YdWZBHdpPAduC12mO0FXjMVNPL5NbwTAnApY9j+YKYA1SMr7sxlgFVDNVw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjU0SGhROGlhb1d6cXNMUitmVGVWSjNGbHo5TTR3YTZLTUYwNmhMWHZBdUlD?=
 =?utf-8?B?MkpTODdFbDRmck1XUjNmUURXMW5XVm5BMDF6RktpcldpdTl3blNWbjEyMllm?=
 =?utf-8?B?ZXFOVTlwbTcrMVRWWmFwNnZDbW82R05FcFMvMngrL2NuWjV4Vmx5emw4YklE?=
 =?utf-8?B?cG02WDArM3o2N2U0Qk53SDhlbU9KSDhQeWNBQno0RXhCVVYzSmtCcWZLczFC?=
 =?utf-8?B?aFJyaGVrN0liYmcrVXUyc2pCSS9rUFBjMkR2MG54bW9lKzFFZ2crTHUyOUkz?=
 =?utf-8?B?T3JnYjhhem9hUnBWM05vTU81VU5vTkVlZmozWXJoU3p5NFlJbS9ZbnNQWWNQ?=
 =?utf-8?B?RXNESTBKaFFwTmlGNEJRMHVpa2JRc05vcVB1a0Q3aERKNWlZMkxST0hTbGxH?=
 =?utf-8?B?WFVXaDFibTAzSFNweVRrK2NXN091YjEvaW1kM0dpTW8xRGs0SUV3SWx1Q3NC?=
 =?utf-8?B?UE1rTXFUZTY3a2U3NEhSL1paUGljN3dBYnZqdVlFQWdLdnAvNmFmWUl6ZnVL?=
 =?utf-8?B?d2YwbG94TjlOaDhpRUpMa1NRQlN5T2gyS3NTNnRieDNqcEZ4eFFucy93RHZz?=
 =?utf-8?B?M25XenJ2clpIVDJSV0JxQS9haHloZHpibmszU0QrMVNXbGs4OE1IMFRGcGJQ?=
 =?utf-8?B?RUZWeWQrNEsza1d6S3BVbFFwRFN3RHZFVGtYdjVKaXBwMHlPTGhPRHJudkpo?=
 =?utf-8?B?cUFYdDQzVzN3SlZMMmczZXlRWHJFM3hLK3Zsc2hKa0RvdXJkWkZCWkRTdFhv?=
 =?utf-8?B?UU9MbmFOSXAwR25aOVVkY0Jncy9meFBJUW8raXM1VUIrM0NGSHJkVDIvVW1k?=
 =?utf-8?B?M3lDMUlLSUNLV2dwKzRrT25BaTVRRjFwQjNRZTdyZEhrSnlDYmR5SWdGZm9R?=
 =?utf-8?B?ZXV4N2NwOGNXUWh2K1NDVTJZaGd2NjRBVVo5Z2krZWtWRXd1byt4S25oKytV?=
 =?utf-8?B?MlBhbDdOK2lGdHVVaFh0SkpENXBCLzdhRVZFYTYxbW9hM1h5am4rekZ3Z01v?=
 =?utf-8?B?V3J2NDFOUlk4T2tkTThFb3Z2T21YWUhJNVJyZ092THpOVmNhUEh6bzQ4VllU?=
 =?utf-8?B?emFkZDUvRXoveHFPQ3BIYUExbXdQN0svUnd3NHk1L0RuOFJVd28yTzlaVnU3?=
 =?utf-8?B?LzNydURKOTAzS1c2V3V3WnJ5Tm1aTW1mRCt0VUF6alZmKzQ4dnFBVGg1Zk1R?=
 =?utf-8?B?ZjdERXZzeGM2UmhGRDZ0TW1iSUxRYU96dWdxaU9qU3NMcisxQzBkblRYc0RX?=
 =?utf-8?B?eFJkYlNvMDdsZis4ZzBkb2FOOVRKOEpOK1c4VTRZREQzaWxacmxmYzJSOTN5?=
 =?utf-8?B?eFZRU1ZLd0l1OGRQUzlFSmxlbGw3bjhOeXNOeE9WNlhBQ0pZazRNZHNaV1c3?=
 =?utf-8?B?UkIvSFgrVGZpNE5iWXcxRDhKLzhrL1B0NFdGOEViWU5raGxJUWVwa3RMcnBi?=
 =?utf-8?B?bm8zb05qN0FsZm9BcGJzUjg3QzRkT09ldzI4ZVYxeHZMSTEyazNLUTMzODhC?=
 =?utf-8?B?cjUwdWFUeHhkNG82RUtFUmt1dU5ZVjM4TXdLa2Y2VTVXSTN0bExaeXJ5VWRD?=
 =?utf-8?B?VWVtYTdUNE9zM3NsNzJpZXVUZVlJWWNzS1RialU5YldzcWZsZUxBUnFxa05a?=
 =?utf-8?B?cy83Z29sM3pGaWhyWEx5aDFwL216eHNMR0lrVllKRk9nMTAwNUxtRzFmdWw0?=
 =?utf-8?B?MWx4RXlkOXY5K3RhK2xtS0ZIeUdidWplS2pIanc1VGxZM1hMMzJuM0JrU29I?=
 =?utf-8?B?cjhveG1LRnRNRjMzY05YZ0Yxa29oV2dqTVltYUlXYkVVS0VabVgzdFhTRndh?=
 =?utf-8?B?MHRzaHg5ZzAyUUxLWk1WZmdZN2pQOFdraExLQWRLSHRZY3dqbGpvSGp3TE0x?=
 =?utf-8?B?TUErcGxkcUdpeVdraUhOVTBBcGRmSno0WWFBL2FCRzBZZnlxekk2dTBsQWY1?=
 =?utf-8?B?bDR1RkxKTjY5TXZ5b2RrRkw4R1A1TWRqandqOFduNnYvVWl5K3ZPazR6bWE4?=
 =?utf-8?B?ZS85T24rcGQyRlZFSCtZOE9saWlzWnFjY3cxdFpLNmlpaHViWG1CWStxbDhj?=
 =?utf-8?B?K0V5ZU5JVVdqc053SE40Ym9McmVFNzdkYUR0T0pZbGxhK29lREVNNEFWUnh5?=
 =?utf-8?Q?KUQezkQV8fB00J3oTXqBr3SQ9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 030d6a5b-acad-45ac-5518-08dc4ca7afab
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 08:43:47.2110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iD4/n5wUu+duipxJuKq8HwFsSpTT3D8nojoHVF0b89Q2OxKoxTsbYLnmIMGFNmEdSyoOaLJVNf3ckbTWmzoyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4663
X-OriginatorOrg: intel.com


>> Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but doesn't
>> allow to enable KVM_CAP_MAX_VCPUS to configure the number of maximum vcpus
>                                                       maximum number of vcpus
>> on VM-basis.
>>
>> Add "per-VM maximum vcpus" to KVM x86/TDX to accommodate TDX's needs.
>>
>> The userspace-configured value then can be verified when KVM is actually
>                                               used
>> creating the TDX guest.
>> "

I think we still have two options regarding to how 'max_vcpus' is 
handled in ioctl() to do TDH.MNG.INIT:

1) Just use the 'max_vcpus' done in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS),
2) Still pass the 'max_vcpus' as input, but KVM verifies it against the 
value that is saved in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS).

2) seems unnecessary, so I don't have objection to use 1).  But it seems 
we could still mention it in the changelog in that patch?

