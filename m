Return-Path: <kvm+bounces-15871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B00F78B1509
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 23:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C01D6B23CB7
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 21:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C09B156F28;
	Wed, 24 Apr 2024 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdWC5PCt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADCB745CB;
	Wed, 24 Apr 2024 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713992860; cv=fail; b=Bd544Mi2vJ85uzJDc5dETRE+KnNi0TsLj2hfmzG7bS+iJCvcFqezFRSopNCLRSqO2eJIlsPHZWBhHTf89ym2z8wrOPiTRmwwXt8S3rekPutG4TcNiT/nwtoJ1lKcdhT5LK4dCJxBQVW/g1QunERxZ8dOMoiTpF6Gk3eUuiau7xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713992860; c=relaxed/simple;
	bh=Z0hCrhL3S6CVQjCB7cluKJH4acwdu/X1Yynexq6P+D0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=swoTfNGXjpV0jcfxekr2iTaWjEj7YoNiIiu3K56zLykvsxByMLw+8xJ5+fvWAcnVZTxic527yh82J7J8MTB9wlGeYyPngQ6ETQppSulk3s4mD/ZcoIIdnaIrgGjxH9zXubkOkYcFIJ6ML+TgyajiHsb7OM1Z4E/rSprlpyCRPMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdWC5PCt; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713992859; x=1745528859;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z0hCrhL3S6CVQjCB7cluKJH4acwdu/X1Yynexq6P+D0=;
  b=YdWC5PCtLij09uTULZKPTLN1JUMfdvm4bNp8yQ3yfPhsfK/bj0psUY4g
   wOHxqCkf5sKeqo/JYk83tVjuJREZDPZSeN4cj/f1jF4cZ1SdffoXBX03r
   81zLda2tCb47rXV1TKMKeubnGTASXSvuM4/NmiC/BosKg00rLyn1H7mZ9
   iTJabCz5QapUN0FGpetyRjnnG1yF08d+EzbKXFktTr+2QCO9TN5W+NfAu
   VwTtSjqwqN3s7ikTjVfpf+O59BIjev8fW/Ig1xTx4KbR9KjJW9chPFlsb
   aT36NnIJkLd9Da7UFS9643qDPjUQsbiZiYOCyzcOD+msrFWveXFw2IYSA
   A==;
X-CSE-ConnectionGUID: 5J7yWCBcSXucXcaZZeIWqg==
X-CSE-MsgGUID: Dra3RGgRSYSFjVfjzyll6A==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="13439368"
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="13439368"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 14:07:38 -0700
X-CSE-ConnectionGUID: oCMDgLsmS5mIW2VyC4xdGw==
X-CSE-MsgGUID: gLo4yW25QvCprGQ1Asp6ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="25268917"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 14:07:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 14:07:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 14:07:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 14:07:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0/kXq9jVuCvWtdjDOTVp3PwTrEMVIBduFPxRCslv5c+6dxU7fTrXbsYEvOAaiBP/gTmhNAzJG3IfGaqBzusoFz0LwM2B6JNuUbzXE3lCgqy7WllvDONer0f9CP85HJtUD6njEDucyHouEvclnBBUGAmuKxZ09ZhZ/c0Q+rWZMNUCFuG1xRkpvoMst1OSiHD3WScaD3eGjEiblb/5vBtvH5uBX2ao6KBaqybczOu8H5yOIg8PlKxMhK1rBoo3eI5GAmLnN1KXpK8eW36ffh/qSpgDsRun14cS1KIzauGiuC9W7U2zw/JGS3CPf2HEBg/DGssyCpF2halLFrNiaakZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hxj8kvLJhgFooeIty/d1naghyIHMKR+w86aQFfrJZw8=;
 b=P0AaxPczB2OT0nhXiAsjTRSAAtRQNLlppvSWmV6B5Wii2d8zzECBcDeIc+VUGv2KGY+tXBCpJPA387fPWWxZKuIv+hGjNS4u4OftA838g9+DEP56v2NK8F3bPUuJi3SrE2lmcetQ09GvFMMVY9ZHgaGbtON/o9tnV3ILhJ+kvEUHPXWx1NSAm5Ng9fl6VsCjue4sywD4oyiiXGiUpr8dEvlmvSl9+gNr2jcRT2A6HVkN8dejSS1dc8+XjAJCOn8y4Pt7ktxi31VhejwgZKUzqzpf9HG5tuPwFmxTcqKEuXj0/3dMohzdzQM3wkbQnPU+Eoqsn0Oh/Q7ORhwyfBg2tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8350.namprd11.prod.outlook.com (2603:10b6:806:387::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Wed, 24 Apr
 2024 21:07:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7519.023; Wed, 24 Apr 2024
 21:07:31 +0000
Message-ID: <a76a430a-2a9d-4ff6-88c2-bdfafff92ae4@intel.com>
Date: Wed, 24 Apr 2024 14:07:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Yuan Yao <yuan.yao@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
 <Ziku9m_1hQhJgm_m@google.com>
 <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8350:EE_
X-MS-Office365-Filtering-Correlation-Id: 539bc3f5-db01-44dc-d01e-08dc64a28e12
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?THZueUh3NlFnK0N2cXFjMlp3TnI5Ym0zbVNxeU8velVDNXFTWWs0TlVvdmIz?=
 =?utf-8?B?OEgyQS9pb3c0N0RSOTJpdTl0aFQxUEpXa2RPSmsxZFFaRHQ5YTNYWWlJQ3FX?=
 =?utf-8?B?T0hkcnpXeXNEWmtpRmNWeVhadmNxNUhtbW9icjFXTnd0RWpGYmd0dkRuMDJS?=
 =?utf-8?B?L0I5OWw5OUtGUmdwRUlJeW5VMW1FQmdCWHhIZ1lFWXNFV1VNb2N1WFcxTEI2?=
 =?utf-8?B?VWJ0U0k5enhZRG1qRUJDcDZ1MUptM2NVcmlINTU0YVI2UkVXb0N0ZENJK2dP?=
 =?utf-8?B?OWhPM0N4d05aa1RvM3MrN3JnQktZNDhibVlDd2NCSnBNSEgyU3ViYzBnU294?=
 =?utf-8?B?ODdyUlZMVUVkQTVyMVpVT256dGR0SWpRRWNXYUROcnJWdHNNdWRud0dKL0pD?=
 =?utf-8?B?MkFhTWJhLzBVWGwwQkQxNm1YMzcvNmpZcEpncnY0MHpGY3ErYkdIME5XTU5n?=
 =?utf-8?B?NnFmRWczSWtrd0FMSGszSVVLRG0wTjJWZGxBSlZubytYK2pHMkhIRVRkZEdx?=
 =?utf-8?B?SmxVazNEV2R2TFc0RUNxRUE0ZVhzWTBQLzFaQmVpS3o4a3IyRm9BMExiSFFy?=
 =?utf-8?B?aTJyMWRWWVVMREphc1VFSmtpS1NrV25GdTExd2pxUmlTOGhyS2hLbmVCQTlP?=
 =?utf-8?B?L2tZdXdJdklCeWRTRm1oRFFMdUs4WTVYN0FFR2I1RVJLV3kvcGdsYWs2Sy9w?=
 =?utf-8?B?c2hZZFlWV2kyT1FaaE00dUE0VFliakFSRDc1Vmo2S05BOUNxMVQ0Nk93Tzhl?=
 =?utf-8?B?Q2ZJUXZGSnM2K1ZZbEJLMnFZMTlSQjg3dWhnRlp4em1KMUFXSWJJWDA4M3BS?=
 =?utf-8?B?eHdpK2tpWlhKeHN0cWovaGlEQmVqVTY3VHFKVTBRR293ZWVHU2xuR2tUeExR?=
 =?utf-8?B?bDNacEgwcmFQQ2xRL3pKbDlPc2lWMVdlb2I3Q3VkZXcwR1AwZTIrVE5uV2RP?=
 =?utf-8?B?b3ZHU1g0cVdKK0tsdUhPUnR3OC8wcEtleGZFUDcyRTA4Rk5JckkvSVl4R2pi?=
 =?utf-8?B?OUNJcVc3a1l3Um1WVTd1WjlEYTYxM3hTNmtqbzY4MHVqR0JGTmlDcUFncHBL?=
 =?utf-8?B?cEI0SUU4UEQrZE5LbzNtbGk3cTV3eUhEZzBQWmJ5QnAzMTV2ZThTN0VZcENM?=
 =?utf-8?B?WTlCQ1Jzc3B2cGkwYVR4eXBEUDcrN3d6NHpqVjFVOUJ3M0E3K0ZseUNYSzVR?=
 =?utf-8?B?NHIyUE41Rlp3NWJPYXdHclFIdnROUlJkVTJaV2hVQ3FDd09kelFVZ2I3dk1n?=
 =?utf-8?B?SXpRdG4wS0JLWWU1UGswUWJHOXBoOHJBdzFxZmZxeHpSRDdKNVc4encrYWJZ?=
 =?utf-8?B?akRINXloUG1Kbm5sNVI5RWdOaHM3NlY4YmV5ellhb01MSFI1L0NFWVkzYjlM?=
 =?utf-8?B?WWdsb2FwdG1QTFJiSWNtSzVkRCtaMDdDRWlxalJUMUkzSmR6bDZpZEZJQ0pN?=
 =?utf-8?B?KzJDempiYlIwT1hjRmVsbWwrR0V0U0I4dm01K1lWelJhK09oQ0lTYUpnb2o5?=
 =?utf-8?B?clgwUDVrZ0ZOa0d4MTNsSXR2RFFUdldVSjdKdklPNXRIVUtNZUFUSCs3ME5t?=
 =?utf-8?B?YW03Q1RCUWZDQldUVnVXWW5INmFHWDhKNWlDenpXVkpzdWFjKzhWZzdOMzV2?=
 =?utf-8?B?bVhVYytqQldZWXBUc1p0ZExTcDM3R1lVVVdHWGgxaklneTgyaVpad3ZDWmQy?=
 =?utf-8?B?bGNBcFMvY2lPVUFXbkRubzROQjZ3YjlCWGMwemJkRGNjd2RuNHkyeWdRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWtqWXp1b0VGT1d0dENOY21ydzV5OG1IYldYZjBROEZraTBVNVlKY0pzSCtn?=
 =?utf-8?B?UmFjWGlRUk9WcncvQS82MVBBRTJCKzRJWDlGSVVVdy9lMHhwWUl6dTBtOWor?=
 =?utf-8?B?TWF5Rnl2YWFoeW5LNnR6WktpQzVYV3JJdkpjOGxlaWpQRFg2SFczYS9meDA3?=
 =?utf-8?B?bWsyMThuS2drTTdvS21rTERuWERzOURVMmpKTEx6OU9oRWpqTXJpWjVGc1N6?=
 =?utf-8?B?ZVlRRjlHSTcrcUs3eFhKYjkvaU1YM3d2VTAycVJ6R2tuc2FDVldMdDZoc0s2?=
 =?utf-8?B?amg5bW9rMGs2SEpKRDB6WXcvWWtBbnFyTW5qUnVRNzNncXRpcmd5cEUyZktt?=
 =?utf-8?B?QUlTSkFSaHpFSzY2c1pieThldXpSRlJyT09jbEM1eGpzNW0welYyYjJ6S0hW?=
 =?utf-8?B?d0NnbnBZUERVRTlXdGJvWU9OZmg0VS83VktBZEYxYjRtM21QcTZxcFBCalYy?=
 =?utf-8?B?UkhMYnF2akhVOGlraDY1ZW44Z2hidzZhWHN4bzdzdG1xWDVPMTRHMHpoZjdh?=
 =?utf-8?B?cForZ2ljeXFEY1pmNU8zMTRLYWFWK0ZsRC9ibXhacEluTTltSTZaU0JZNGI3?=
 =?utf-8?B?V0VPREVMNnQ5TUQzbGhPNHRhK3FHdWZubk81QXZVT2VsSFFocjhINTQzenNz?=
 =?utf-8?B?VGxCSzA4Y3IrcXlCeEpGOEFxMkVkR0c5RmRqRU9ralJQMHQ4eTNReTduUEhY?=
 =?utf-8?B?RXRuaS8yMWo0Sm9WdC9lR3JPendxYis4dHh0bGtJNVNnWW1wdVdldXBLVmdl?=
 =?utf-8?B?M2ZiR3pUMXJBdWFvUCszQi8zUzNlQi9TUlcwQVJ3R1MvMEpVdFlWUUN6U1BS?=
 =?utf-8?B?b2ZBOXdtTmt6akZCZ2xJQ1BKT1NuSVVoRDltc21LelROdm94Zy94RXgvckY4?=
 =?utf-8?B?UEc5YWNiQ1lFd2ZlNzhidDMzTWFVclRlMEpqdFFRM2YxRmk4d0wzYnVWQjNv?=
 =?utf-8?B?U0F4N1JBb3RwOEdDeE5yaWI3WVF4WXF2SlVSMEN6Skt6cnV0ZXBGN01HYXZH?=
 =?utf-8?B?UklKK09XY3NzaytJMkZJQWdLMFExYno2TTNZTEc1djdvRE9HamhxWUljeGJT?=
 =?utf-8?B?T3gzNllhazZhdzZSdlFEUmJHMGdpSEdrYzlWRHdWQlR1L2MxcUVibU9wSmZs?=
 =?utf-8?B?YjRsb3lURkJIWlY0aXhsaFJ4TnhIWFQ2MzZwRzk0WEJxWkZ0MFljUnF4Uzdw?=
 =?utf-8?B?b3gyd3U3aG8wcWdCRnBGVjcza2VPeTNBVXNHSTA4eFlPcmpyK3pUUUdJSnhZ?=
 =?utf-8?B?N2pjdmJrSm5oOThadjFENnRWOCtvZVVscjJQNXdnT0Y0ajhiZ2xaVjhhQS9p?=
 =?utf-8?B?N0crNzdsbk5rK1V1bkN5OFNtVTVUTzFtTDUyTUFvbkZpanp3bWhoaURtak5j?=
 =?utf-8?B?alBaeFF6NG5QWGRUL2ZINFFRUTVIcjR0VWVMc3o1cmNPUVFlWFJicXRQOTBO?=
 =?utf-8?B?QXUyUG9SVysrT3ZYWFVnbEZieDhuUlBxVitMUDhxUEFoWlM3UTlUWFNHTnl2?=
 =?utf-8?B?bkRpM2EzdUlSSjBRSkFLdW9YODY1SFA1RjhoY0pNQWJoanFsQlYzTTR1UTUx?=
 =?utf-8?B?MmlJVVExRW9oNURYMXg4Z2xjOE9rQTRBT2prajR1OWdTcUs0TUJKWUpNa013?=
 =?utf-8?B?aTlIczNTOWZidWN0QitQeGUwMEI0dU81Q3hwS2FYcWxXRGtCSjJLMGFYYWc5?=
 =?utf-8?B?aFhRQ056WnA5TXNQZW5jbzRnUVd5RmJrM0VnSmpVRTk0STZva2pPdjZJcGdM?=
 =?utf-8?B?NEVUZTU4dGdraEN1SU81VllXcHoxYkhVanpyWndHVEh5MEFxWTZBdDZiZXlj?=
 =?utf-8?B?WXhFS01XM3g3K3RQZWdsUUR6UE5EYldBUFJ0bVpKRUljMk1TWlhlNGQ3WlFn?=
 =?utf-8?B?bnhGTTdWUlh1WVlFeDFBMFZDNjd6cWRXajkwVi9DQkNEU3NsblpmRWhNK1VI?=
 =?utf-8?B?SnhBd1NYSjN1Wi96dWpNRlhJcFlpSkx6NDhLOFdEeFZReWhoU3QyTklqcmFP?=
 =?utf-8?B?UVZvcnhWckI1MDZYdlRrZ3FBbDJneWltcGU1cW04S0FEQVQxNlRMei9Ja043?=
 =?utf-8?B?MHNxdlM2UkN1UzJ1bWhVTXNVU3pCb0p6T29HNmJzS2pNV1NjK1dSN3JkNDJI?=
 =?utf-8?B?R3h3c3VLWWd1TzBBZVNJK29EUFFVZTJHbXFvSHFiT0NuQmx5TmpvdElJU1dO?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 539bc3f5-db01-44dc-d01e-08dc64a28e12
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 21:07:31.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOkcnK8Y+4uY+24BiuwjMOGbAR1MSh+LgIV2NpRpO2klx4NbkEoqbMGZCRxblTr/s0klpSxWdr4xTELroH2+I3+IKUnZAXgWueXB/5paVpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8350
X-OriginatorOrg: intel.com

(+Yao Yuan)

Hi Sean and Rick,

On 4/24/2024 9:38 AM, Edgecombe, Rick P wrote:
> On Wed, 2024-04-24 at 09:13 -0700, Sean Christopherson wrote:
>> On Tue, Apr 16, 2024, Rick P Edgecombe wrote:
>>> On Thu, 2024-03-21 at 09:37 -0700, Reinette Chatre wrote:
>>>>
>>>> Summary
>>>> -------
>>>> Add KVM_CAP_X86_APIC_BUS_FREQUENCY capability to configure the APIC
>>>> bus clock frequency for APIC timer emulation.
>>>> Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_FREQUENCY) to set the
>>>> frequency in nanoseconds. When using this capability, the user space
>>>> VMM should configure CPUID leaf 0x15 to advertise the frequency.
>>>
>>> Looks good to me and...
>>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>
>>> The only thing missing is actually integrating it into TDX qemu patches and
>>> testing the resulting TD. I think we are making a fair assumption that the
>>> problem should be resolved based on the analysis, but we have not actually
>>> tested that part. Is that right?
>>
>> Please tell me that Rick is wrong, and that this actually has been tested with
>> a TDX guest.  I don't care _who_ tested it, or with what VMM it has been
>> tested,
>> but _someone_ needs to verify that this actually fixes the TDX issue.
> 
> It is in the process of getting a TDX test developed (or rather updated).
> Agreed, it requires verification that it fixes the original TDX issue. That is
> why I raised it.
> 
> Reinette was working on this internally and some iterations were happening, but
> we are trying to work on the public list as much as possible per your earlier
> comments. So that is why she posted it.
> 
> There was at least some level of TDX integration in the past. I'm not sure what
> exactly was tested, but we are going to re-verify it with the latest everything.

Apologies for the delay. I am the one needing to do this testing and it took me a while
to ramp up on all the parts (and I am still learning).

I encountered quite the roadblock (for me) along the way that was caused by a lingering
timer (presumably left by TDVF). Thank you so much to Isaku and Yao Yuan for helping me
to root cause this. I believe that this is unique to the kvm-unit-tests that does
not reset the environment like the OS.

A modified x86/apic.c:test_apic_timer_one_shot() was used to test this feature. Below I
provide the diff of essential parts against
https://github.com/intel/kvm-unit-tests-tdx/blob/tdx/x86/apic.c for your reference. With
these modifications it can be confirmed that the test within a TD fails without the work
in this series, and passes with it. This was tested against a host kernel running a
snapshot of the ongoing KVM TDX work and corresponding QEMU changes (including a QEMU
change that enables the new capability introduced in this series).

Below are the core changes made to the existing APIC test. The two major changes are:
(a) stop any lingering timers before the test starts, (b) use CPUID 0x15 in TDX to
accurately determine the TSC and APIC frequencies instead of making 1GHz assumption
and use similar check as the kselftest test introduced in this series (I did have to
increase the amount with which the frequency is allowed to deviate by 1% in my testing).

Please note that there are some more changes needed to run this test in TDX since all
APIC tests are not appropriate for TDX. This snippet was used in my testing and I
will work with kvm-unit-test folks on the next steps to have it integrated.


@@ -477,11 +478,29 @@ static void lvtt_handler(isr_regs_t *regs)
 
 static void test_apic_timer_one_shot(void)
 {
-	uint64_t tsc1, tsc2;
 	static const uint32_t interval = 0x10000;
+	uint64_t measured_apic_freq, tsc2, tsc1;
+	uint32_t tsc_freq = 0, apic_freq = 0;
+	struct cpuid cpuid_tsc = {};
 
 #define APIC_LVT_TIMER_VECTOR    (0xee)
 
+	/*
+	 * CPUID 0x15 is not available in VMX, can use it to obtain
+	 * TSC and APIC frequency for accurate testing
+	 */
+	if (is_tdx_guest()) {
+		cpuid_tsc = raw_cpuid(0x15, 0);
+		tsc_freq = cpuid_tsc.c * cpuid_tsc.b / cpuid_tsc.a;
+		apic_freq = cpuid_tsc.c;
+	}
+	/*
+	   stop already fired local timer
+	   the test case can be negative failure if the timer fired
+	   after installed lvtt_handler but *before*
+	   write to TIMICT again.
+	 */
+	apic_write(APIC_TMICT, 0);
 	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
 
 	/* One shot mode */
@@ -503,8 +522,16 @@ static void test_apic_timer_one_shot(void)
 	 * cases, the following should satisfy on all modern
 	 * processors.
 	 */
-	report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
-	       "APIC LVT timer one shot");
+	if (is_tdx_guest()) {
+		measured_apic_freq = interval * (tsc_freq / (tsc2 - tsc1));
+		report((lvtt_counter == 1) &&
+		       (measured_apic_freq < apic_freq * 102 / 100) &&
+		       (measured_apic_freq > apic_freq * 98 / 100),
+		       "APIC LVT timer one shot");
+	} else {
+		report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
+		"APIC LVT timer one shot");
+	}
 }
 

Reinette

