Return-Path: <kvm+bounces-12909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FD988F338
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DAE91C2AC56
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B21F154C05;
	Wed, 27 Mar 2024 23:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBraSjmP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CEC1DA4E;
	Wed, 27 Mar 2024 23:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711582433; cv=fail; b=eb0xBlZn22b5lhZKEKkG/g3ZjfVDsor4xmqKcOZmzIs2VZohkK6NKtH9m/4bLWtMnazVPju0Ljbbr2wa1oaUU7rr3pvOEdsJYwmFIkY6evFX3ES90PVJk48ALm9JrkDrhemKvTuVCeKIazdDMiWwIg1u4SaRn3zgtpngJWlSl2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711582433; c=relaxed/simple;
	bh=n+RNfFEdYbmXjoVZpEtpkLkPLSrzAr/Bnvsck0825mA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i6XrQ7VT4KVbht8BNNTEIaEdKu4c93JSz1wOCw7pF6gxKeHszfv+BV0Ks25mPOao33FaqlBNbdYX4AaegP+hHMaYsMKYGUXy/dhZEpqKRHo3lwDAlyd1yNAtU+AOsM0qBqShWGWVFh5ROc/z8fpwep2BsyjB6Tg9lGNQV5Dv3mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBraSjmP; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711582430; x=1743118430;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n+RNfFEdYbmXjoVZpEtpkLkPLSrzAr/Bnvsck0825mA=;
  b=FBraSjmPcG1GN0LKWUc24M5ieZaOd1NFK/qD4srCuRB4LsQuuVljR5ri
   /4CKCrFnndCNI1XO0G/9Mn7rUo3xebjciInbEDI7AQB3aADkdNP2mlmav
   VcSP4XJp8OcVI9n2GBF7Kyd38SCMP4QFlB6bTV8Xev3vw6YC3VLRoTQc7
   kvozVrGvzIk8DR58J2VyM41zV9aZlAAt9+fL7eS2nUMCyHAIsWiXvyZs2
   4h2CRkvElYyaye3PYDRu9x2sHtZPU04fbsZxmwLKJ+dnKYkwo06zzK1gg
   GhYfg4BJte4kvWe6DQoCM8PGkORQTh4YHx6VAFJ6xFcM2RhnxG8TZO8L7
   g==;
X-CSE-ConnectionGUID: pVoUdPQ7TWSB6YQEnLLkTA==
X-CSE-MsgGUID: TSn7V8h3To6XpDbCEwDGXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17269472"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="17269472"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 16:33:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21115286"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 16:33:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 16:33:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 16:33:49 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 16:33:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLTjx4cIMSrHCJ3r1rXgaoXYo5ceQHG6t8tA51b/UFyCQJtJtoy0dguxhJFJQ/9ksl4u7dht44yOsj5GGRMLYgCQnZ9IA4TnDT4QID+9cBxSAbcJ18vI0vIYdQIPnU3M/k0be5rWxvDi8nRMCFODnCrHwkKwFSldgSHGUcQC5W3d1LsXfSND5aIlEkJKwydtwxvDpmeaZnxD7C7qDSx6k1iocsSnX+3P5M0JcXDshP4GwidIv0AzOTrur1ygwkuX8S/rM/BWDtFpAou63JpGrUOwjBFT9YVFKswbiy0khE5A1BxFBGpQauJ+ZBD4+ZC5wi2vEgtw8igHwjkPfbLuqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zea5smxVW65dhD2PaXA3/cWYFctwxxL2R+PK7yzwNqA=;
 b=ZWTLx6SuqmhkjkRIgwKfnClAoR/qgfprg3w5IsL6iu2uJ6WhltRf4rFr1X0BIUcmBZgl91UDsNu3lcRiIsrrXxzm7NSYrU/9acJbB6w/JZn4TcGf1sYAVLuUAa0RXWMoLyXIqVZpuST/6qtBamxXrWazZMwotzTuQsWP2EJTJm3DhGJ6aXpfd8lvH1V1tCPE8N3wEEHgj6OUs5IOWSaCvyNZiG2EG/8FcgQp6yFMn66CpGPFlM+9fa/bC2wPCqmpd9ibgthzxY5Gi+FIr6mqVjbFBXH9zw6RamO6EZbQonbnmfXIXurlGfYnjtamFQUUCmqUPd3lAd6z6mQVSuwaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7971.namprd11.prod.outlook.com (2603:10b6:8:122::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 23:33:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 23:33:46 +0000
Message-ID: <9f5c6259-78e1-4470-a013-91392bf3cea5@intel.com>
Date: Thu, 28 Mar 2024 12:33:35 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:303:8c::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: e1dc620c-cbf2-4b76-bb65-08dc4eb6589f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JlinF8WjIkjvmBljjM83sb4Ijcuy8Q1I/zoFdGohiMz0W29Q6y+8WXVaK59gJUrZeOe9pRCDG3Z7Z0mAav2iDv8KVruFxd3jC5OTrwLkcvBJxsxW/SwCCU82q2kKrlQgRNQiX4PWFCGxi6dsyjgAY9mslTBxhoSK3SYkl2HAvNFPUWGGJEq8uQuYOk9/ePTgh8G/pQJ07IGDj26BRZtho/SOr6iFJQE5g8KEJSXaewOc+m3B1NNrWvCcr84at2R/vTS7XhuHo3fScO1ppVJZpK7yJ/h3KwoWArBFp90/wBw1H+z7Mv5hhuwYmUyO59+gPra1dnf3InlpF7JQJk4ITujCBZDAL1OGG3l+sTytciBtv3th12SDpzOURuPfSFjUE8zTVOdyDl/z+AcQ5rQt3tYPiMzZQ3CFyV+EIkRX45RIpb0lUqL5G17QRFA+s90EVYDmfparvEKPblNXDFUtbbc9xhoWqkaZuXJBwHlkb6ObEX+qTcGGm3WH10CybHmCzHyYsSQruHiW9E7HfUfdYA9S/idVC3G6t3XtjkN26Lz3BoOaS7h8/UTjhcFEoyQnnkgzR5tdHix+IP4tgfSQXwvcia8Dzv0kggChwAM7/PQ5roqQP0XohSWuLYv1/et3dOimA1NS0XrdZcpTgTxORMLOL1kof941cJNTIAAs4Ds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlY0OUNnSlBvU1QzNE9DWmF5bVd0U1JXS0JNek9HZ1ZWcVlwem1qZzVtWFFk?=
 =?utf-8?B?RC9mNWNjUlJNS3k2ejJkWllVWFlML1hRYktJSDlGckQ2WDNwaU05NHhmTUR6?=
 =?utf-8?B?cWVRTHpjL1g1R3BhSk10TkkrZWRXeG5BcG1oQUlUN2hQY0IxZm8yWXhPanYw?=
 =?utf-8?B?RGRETHEzUmZTN0pkMGpvUXIyUTljVGpmWnIzajRIamU5dDZSSUJmY3lubTA3?=
 =?utf-8?B?cGVnOURKemJWMmE0bDcyVFp6bFJDVHB6ZzhsdnhqRW9yZU1HSFNpQmxPYWpO?=
 =?utf-8?B?eFZ1Z081d0JwaFpaU0Z0MWgwUEFuZ3QzRllhdUd6WEhaeXA2WWRHWXFEb1pC?=
 =?utf-8?B?dHE3ZkFQRnpWVHVHTzFRbStCSnBhY3JCa3h6QStOekYwM0l5WXNMbWcvZTVq?=
 =?utf-8?B?eHBsYmlmaUZFcVVOcDllSlhEc29BY0RQQUdKNXdnY3IyRkJvMnR6SENmQTNw?=
 =?utf-8?B?bTBZdUNPVFdLVml6SEVDK01oVUZ1UEd1bURVQW9GTnkwaFBXd0o5YWRhTHg0?=
 =?utf-8?B?NHl5aHVZWldFYkZrRnZNam1QQy9raEQ3Y3JEd3N2WnI0QUhTL0NZK2tQYTNK?=
 =?utf-8?B?MEpyZGZRY0c4K1YrejJTWTBzZTkwWFRLaXZra3crVU9zSnYreVRxcEYrSXdx?=
 =?utf-8?B?MDl2Mm5TRnRSNzUxdVpkblRHWGFKMS9wT0lxR0drNDRZb0tkd241dTNTdHFl?=
 =?utf-8?B?L1g4aGErQUhFK3NwT3FpU0tFL3JjUTFUY1orVm9JUUJSWUhxa2kzY1g1aEF1?=
 =?utf-8?B?MHVmWjVpODNmdHc3bGVOb3ZQTmxEemFzSkgwV0JnVm5kRHk2V2FxUXpuR0pw?=
 =?utf-8?B?aEt4Y3lTK1R4YzQwRGZTQ3YxODhQZHl6amJBZGVsMEpoZWM5Z2pqWU8yTUpa?=
 =?utf-8?B?WlNORk1yUkdFWTNDbVNZWDRuQTBkOWNmQlpWbE83RFBtMXN5bnh2UjBGVHox?=
 =?utf-8?B?K2h6TWlwN3ZWQVp1T1laS2h5Y2dmUnBHckg0ZDRlNnlxUEJ4b3JucFhMVXkx?=
 =?utf-8?B?MTQzMUZVUnE3L0xlZVo0VVY0T1pHa285TVo3V0hsMFVac0l2YXlpdFMxMjBj?=
 =?utf-8?B?Z2NDcmpmMTE2M05RQzduUjZyVUxBVzRhbGZhTXpUMlc3WmJLczdqa25Bd1Bq?=
 =?utf-8?B?QVFIZUZQQXZXVUlZcGZUblYrV2Y5ZHFlc1pGWEkrcUUzeTVrb0FkMkpaRkpu?=
 =?utf-8?B?MnRQUUtRcHNUdHAwanBOQkJxL0lmTXZJVGdzZGI5aVZKWVMxd29VUzVpN0NY?=
 =?utf-8?B?ekNxY0JCaVFSQmt5WmF0MjNmaW91MXNsM1lKc3FJd0hMZHBKUlIwblpEOTVJ?=
 =?utf-8?B?VTZLam5JL2tQd25XWkozV1RSSVFxUVByc2I3YVpMdVFVcnhhZWhxU2pPYmd6?=
 =?utf-8?B?bGFJUFhzclBWMFk2UGdnUjlzUk5PUktyUVRrMWFjaXJlcjM2YkZhYmVnc1RE?=
 =?utf-8?B?L3BMdVdjRDIvQis0NWptR05FdW5tZmpMdUVVT25xZHdmaDVwU0xXSlpFZENl?=
 =?utf-8?B?VmdQYnY4TmcvL3M4NVBzZjIvVW1MWjBHUW0yU1NoUGJQSTBmSjdPUmM0Um1B?=
 =?utf-8?B?YXdablNSWS92eXI2Y2tLSllxYUZETEVjUUFncXNsblJ3ZGI0V2NxUVZsNVVC?=
 =?utf-8?B?QkZPdnhOS3MvWTk3QXdnTWIxVzF0MVhxT3pJc29UUW9GeldHS0JocDlxQUxP?=
 =?utf-8?B?cjlmb3ZxdGVXOXZocDZZOTB0REtJS3ZIK2xGZkZoa3kxSUUvcmhFMjBXTVNE?=
 =?utf-8?B?a21ySkF2VEZ5Vkx0aFVqMEdIK1RsaXdoTUUvcnYzS3h0WDFoZTl3c0Z1MjBG?=
 =?utf-8?B?dFdveTlwWTJYLzg0aWkvb3J5U1IycFo4bjc2V1BXSzNKVzlFVDhpOWYxQXgy?=
 =?utf-8?B?aWlqLzZCbFlvaXpUdUMvSFBLeUlaVG0yZVBJaC9FNDlkSWRBcEM5YWxRc2Mr?=
 =?utf-8?B?MmRtSlpSNFMvS1dhZktScmtkTFF6RE9ldUl6WFJjdGNzMVIrZllBK3kzM2M2?=
 =?utf-8?B?N2l1NE1VMitRT3Q1OTNJdEZxTU1UY1M5NlR4NDF2SFRXWS9IMlBLb1FaY28z?=
 =?utf-8?B?dlFmcFA0eGdNbUhibXdnNnhuOGNsLytqSG5qUHpiN3NyKzlhNTN4ZUJONHhj?=
 =?utf-8?Q?0NoB3mcTzyqX+yKTf1duzAaOH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dc620c-cbf2-4b76-bb65-08dc4eb6589f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 23:33:45.9402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzPTlLzFlEQ1ynSdzx1qR0/2qLiabuMIWiV+Jc39SziHOwS6MLiBIl4JTceQ7uDxHh7iCKnonu+tMz4BRO6E2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7971
X-OriginatorOrg: intel.com

... to continue the previous review ...

>   
> +static int __tdx_td_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	unsigned long *tdcs_pa = NULL;
> +	unsigned long tdr_pa = 0;
> +	unsigned long va;
> +	int ret, i;
> +	u64 err;
> +
> +	ret = tdx_guest_keyid_alloc();
> +	if (ret < 0)
> +		return ret;
> +	kvm_tdx->hkid = ret;
> +
> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		goto free_hkid;
> +	tdr_pa = __pa(va);
> +
> +	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!tdcs_pa)
> +		goto free_tdr;

Empty line.

> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va)
> +			goto free_tdcs;
> +		tdcs_pa[i] = __pa(va);
> +	}
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}

Empty line.

> +	cpus_read_lock();
> +	/*
> +	 * Need at least one CPU of the package to be online in order to
> +	 * program all packages for host key id.  Check it.
> +	 */
> +	for_each_present_cpu(i)
> +		cpumask_set_cpu(topology_physical_package_id(i), packages);
> +	for_each_online_cpu(i)
> +		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> +	if (!cpumask_empty(packages)) {
> +		ret = -EIO;
> +		/*
> +		 * Because it's hard for human operator to figure out the
> +		 * reason, warn it.
> +		 */
> +#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
> +		pr_warn_ratelimited(MSG_ALLPKG);
> +		goto free_packages;
> +	}
> +
> +	/*
> +	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> +	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> +	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> +	 * caller to handle the contention.  This is because of time limitation
> +	 * usable inside the TDX module and OS/VMM knows better about process
> +	 * scheduling.
> +	 *
> +	 * APIs to acquire the lock of KOT:
> +	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> +	 * TDH.PHYMEM.CACHE.WB. > +	 */

Don't need to mention all SEAMCALLs here, but put a comment where 
appliciable, i.e., where they are used.

	/*
	 * TDH.MNG.CREATE tries to grab the global TDX module and fails
	 * with TDX_OPERAND_BUSY when it fails to grab.  Take the global
	 * lock to prevent it from failure.
	 */
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);

Empty line.

> +	if (err == TDX_RND_NO_ENTROPY) {
> +		ret = -EAGAIN;
> +		goto free_packages;
> +	}
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_packages;
> +	}

I would prefer more empty lines.

> +	kvm_tdx->tdr_pa = tdr_pa;
> +
> +	for_each_online_cpu(i) {
> +		int pkg = topology_physical_package_id(i);
> +
> +		if (cpumask_test_and_set_cpu(pkg, packages))
> +			continue;
> +
> +		/*
> +		 * Program the memory controller in the package with an
> +		 * encryption key associated to a TDX private host key id
> +		 * assigned to this TDR.  Concurrent operations on same memory
> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> +		 * mutex.
> +		 */

IIUC the race can only happen when you are creating multiple TDX guests 
simulatenously?  Please clarify this in the comment.

And I even don't think you need all these TDX module details:

		/*
		 * Concurrent run of TDH.MNG.KEY.CONFIG on the same
		 * package resluts in TDX_OPERAND_BUSY.  When creating
		 * multiple TDX guests simultaneously this can run
		 * concurrently.  Take the per-package lock to
		 * serialize.
		 */
> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      &kvm_tdx->tdr_pa, true);
> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +	if (ret) {
> +		i = 0;
> +		goto teardown;
> +	}
> +
> +	kvm_tdx->tdcs_pa = tdcs_pa;
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> +		if (err == TDX_RND_NO_ENTROPY) {
> +			/* Here it's hard to allow userspace to retry. */
> +			ret = -EBUSY;
> +			goto teardown;
> +		}
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */

Then, how about renaming this function to __tdx_td_create()?

> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially initialized TD
> +	 * varies based on where in the initialization flow failure occurred.
> +	 * Simply use the full teardown and destroy, which naturally play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	for (; i < tdx_info->nr_tdcs_pages; i++) {
> +		if (tdcs_pa[i]) {
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +			tdcs_pa[i] = 0;
> +		}
> +	}
> +	if (!kvm_tdx->tdcs_pa)
> +		kfree(tdcs_pa);

The code to "free TDCS pages in a loop and free the array" is done below 
with duplicated code.  I am wondering whether we have way to eliminate one.

But I have lost track here, so perhaps we can review again after we 
split the patch to smaller pieces.

> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;
> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +free_tdcs:
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +		if (tdcs_pa[i])
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +	}
> +	kfree(tdcs_pa);
> +	kvm_tdx->tdcs_pa = NULL;
> +
> +free_tdr:
> +	if (tdr_pa)
> +		free_page((unsigned long)__va(tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +free_hkid:
> +	if (is_hkid_assigned(kvm_tdx))
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_tdx_cmd tdx_cmd;
> @@ -215,12 +664,13 @@ static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>   
>   static int __init tdx_module_setup(void)
>   {
> -	u16 num_cpuid_config;
> +	u16 num_cpuid_config, tdcs_base_size;
>   	int ret;
>   	u32 i;
>   
>   	struct tdx_md_map mds[] = {
>   		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> +		TDX_MD_MAP(TDCS_BASE_SIZE, &tdcs_base_size),
>   	};
>   
>   	struct tdx_metadata_field_mapping fields[] = {
> @@ -273,6 +723,8 @@ static int __init tdx_module_setup(void)
>   		c->edx = ecx_edx >> 32;
>   	}
>   
> +	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> +

Round up the 'tdcs_base_size' to make sure you have enough room, or put 
a WARN() here if not page aligned?

>   	return 0;
>   
>   error_out:
> @@ -319,13 +771,27 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   	struct tdx_enabled enable = {
>   		.err = ATOMIC_INIT(0),
>   	};
> +	int max_pkgs;
>   	int r = 0;
> +	int i;

Nit: you can put the 3 into one line.

>   
> +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> +		pr_warn("MOVDIR64B is reqiured for TDX\n");

It's better to make it more clear:

"Disable TDX: MOVDIR64B is not supported or disabled by the kernel."

Or, to match below:

"Cannot enable TDX w/o MOVDIR64B".

> +		return -EOPNOTSUPP;
> +	}
>   	if (!enable_ept) {
>   		pr_warn("Cannot enable TDX with EPT disabled\n");
>   		return -EINVAL;
>   	}
>   
> +	max_pkgs = topology_max_packages();
> +	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> +				   GFP_KERNEL);
> +	if (!tdx_mng_key_config_lock)
> +		return -ENOMEM;
> +	for (i = 0; i < max_pkgs; i++)
> +		mutex_init(&tdx_mng_key_config_lock[i]);
> +

Using a per-socket lock looks a little bit overkill to me.  I don't know 
whether we need to do in the initial version.  Will leave to others.

Please at least add a comment to explain this is for better performance 
when creating multiple TDX guests IIUC?

>   	if (!zalloc_cpumask_var(&enable.enabled, GFP_KERNEL)) {
>   		r = -ENOMEM;
>   		goto out;
> @@ -350,4 +816,5 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   void tdx_hardware_unsetup(void)
>   {
>   	kfree(tdx_info);
> +	kfree(tdx_mng_key_config_lock);

The kernel actually has a mutex_destroy().  It is empty when 
CONFIG_DEBUG_LOCK_ALLOC is off, but I think it should be standard 
proceedure to also mutex_destory()?

[...]

