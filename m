Return-Path: <kvm+bounces-49814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BF1ADE382
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8EFA3A3C23
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA53200110;
	Wed, 18 Jun 2025 06:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bw2OAVtz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B745D156C6F;
	Wed, 18 Jun 2025 06:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750227360; cv=fail; b=FNtLUtTMyEya752sr+dflDaX7POQIYNUjSVOrP0K+KRBo0k+EYHk2E8zbFa+AIFYjPl5udCyy+F6cN9WySc6ccWsMUbqYHWy6JUGZ3GZR5PXadNVrlIV+c5KPUNsPyTIErwc5HYy2hND27dkgIfCKBXO884xLxzf183W2ySUjGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750227360; c=relaxed/simple;
	bh=WrbUjGoAor4qsNsxjjIxYJyCQi0WLjsJzrO4gNCJAgE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hLxsxVRbqCvxWXCm9627ewkfHUkYHrku+SxnhVgAIhkoaDaRbKkMAcLNaU9zyNGYa0QCvuCMMXj5eGAy+kGddoSGSeD3rrpeWUzVgaZUfmC3S/ZExvK0YOvNSDt/sjVFgfUIy92Pm0MIJLDxtCjuDUZRQXqZ+JJGOv8iSKpxozE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bw2OAVtz; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750227359; x=1781763359;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WrbUjGoAor4qsNsxjjIxYJyCQi0WLjsJzrO4gNCJAgE=;
  b=bw2OAVtzw4PpC8Z0wKMAOKLNHAbeZ5PKNE6rZAiq7FNcKeOxhWPoXekx
   4hrs2/HITKysT8I/J941dXr60KyPxqxmlqV9a2tjhTvshKtSRO6rDCAys
   RaTwoonRB9byl/P6BRWlyQzhor6hciTYoprX2qPP8pIL5O964zWpzsoik
   KpSmat1mGIMvyD87byYKj/DmvJvNQdxF2vzPIMq14hWA+WKIuFOSi/sjl
   Cs1OqrSSw4JEi1hN6gJxWfr1SKM1tPnQd50ghLifohJNCPLy7KHW9Ig/n
   8+UCT1N6dl9+yHz1+L54eWug8k/au3JqYnV9teZeB4CpK0yomjNYqBJ4i
   Q==;
X-CSE-ConnectionGUID: AFY0nBlZRb2mdQQ1QGm/aw==
X-CSE-MsgGUID: 1aDd96xgQHSKtEcDQ2Qttg==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="56243431"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="56243431"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 23:15:56 -0700
X-CSE-ConnectionGUID: 8DuITggkS8yKaHfacTm3dQ==
X-CSE-MsgGUID: PDNQaWu8TM2av0PnHppB3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="149060529"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 23:15:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 23:15:53 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 23:15:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.68) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 23:15:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ny6m/komXt026r12AGXtaSkqTpBxahvBG1/qIXt2Zu9wg7s++XQ/mSZKAuLdg9EFqWw/SUcaX7CQhIvNvchUxV/C605/rbvP2TebPBiTyXtFgxrtqU4z9MnYMgwTCdgG0HeFZWXrFiSQVEi4aJGOTgzIgj6egJe8LtSW2z7V8aLRrP+y+KCnGFz9+Q8vDg1+P3if0M9SHgbCzqmdCyrX3lkFlFgvU53TbgpgCdBMyDVmWjwGXCeFv3aUBdMvCCnxggnlUlHBMm0J/HWZTtZeUWXg6o9Q6w7PNPVjt9kfb4An+MO8scX0sXqfOV9OjDY4e2ddTV42c2L/ybzbds87Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CCDOuWpEYpU86IdyFhhH67b4ytdxtxJCZKAjXak+MA=;
 b=xnCfiFczuQFksQD9ls6o7F7SNwBmcu5FNrWn1vDFk2UhQ3muivxeGRpwmDusyRlxtcr/8AE6HFIpx0PhPGy2VnfBNUuGQ+4p6q/hCtCw+3F5n8W8HE4AtrmfyDjy/Rd+p3b3YuFXtHKqQ1VKjI+FvOOxmsFKnHGGLo1hxzAi4IW8r1TigGA/n4a63a0/wcz9l+C2OUzkGVwlcUyzj4gefGJ/a9/00P8+pRlwSoozdqooGpsh5tiUXF6haQvuYdVmn6TFnFqcZxZx8MTNltiSDHrlo4UUERBXq2tqeD6QHy98L4iUYAwOjVpNct0bUXRzG2qw/0jTZn5eUngBN1ehwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ5PPFD47FEA206.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::857) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Wed, 18 Jun
 2025 06:15:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 06:15:47 +0000
Date: Wed, 18 Jun 2025 14:13:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFJY/b0QijjzC10a@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
 <aFIMbt7ZwrJmPs4y@yzhao56-desk.sh.intel.com>
 <CAGtprH9Wj7YW-_sfGQfwKHRXL-7fFStXiHn2O32ptXAFbFB8Tw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9Wj7YW-_sfGQfwKHRXL-7fFStXiHn2O32ptXAFbFB8Tw@mail.gmail.com>
X-ClientProxiedBy: KL1PR0401CA0030.apcprd04.prod.outlook.com
 (2603:1096:820:e::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ5PPFD47FEA206:EE_
X-MS-Office365-Filtering-Correlation-Id: d84832d7-3777-483b-a90b-08ddae2f9111
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UEZXc3FBUmFVMDJDR24vT1lLRzlldi95WjQ1ZXljaGJVaExlb0JWVDZkWFov?=
 =?utf-8?B?VlBlc0hnWmMzNTdkcS93enVNK0lqL2I1ODVqVkJjemdueitQN2M0ajZ6WnRr?=
 =?utf-8?B?VkdyeWZLVFZHWTFEdGZvMmMwQzRoVHAxOUhrcGtxMGlQNGpCcjNXeThXcDV5?=
 =?utf-8?B?YVp6QXIvL0tVODlhdUo1cFppOUFCMVdYMjVSOFdwRS9xb1FrNzRvaEpONG8z?=
 =?utf-8?B?ckk1RVJwYTFCYm5jN3Z3UUVkK3Mwd3pyS1RpWmRvWS9zTC9jdU9JSnU3VlUy?=
 =?utf-8?B?VEpYai9POVJjVUMwYlAwWXJudkJ2S3ZFZnJPTU0xcmxmYzgvNE5QdzQ0Qlha?=
 =?utf-8?B?WlFqOWNla1ltWllUK1RSM1RGeDVnUm1uZkt0VlVIQXRmZ3FIZWwzYVRiRFJY?=
 =?utf-8?B?bFFvajVuWTczRWR0eTZsOWQ0V0JodlBrMnR1UExnemZkYWh6czk5cGx5Tjl2?=
 =?utf-8?B?RDN6Ui95WWI5bCtlMHZVS1BkS1A0VWIraHUwOXNMcEZMM200N1Blakh6U0p6?=
 =?utf-8?B?dEJ3RjBNZUplZjNWNG9hU1ljNlZNU2Z6eTU0ZUFhNWVDQ2k1MFRWbTduRnBw?=
 =?utf-8?B?NVIyaVRkdTlXby84TkV5cEpjYnN1WTUybHV4S2hFYzlWMGxMdTdFSVBZNy8w?=
 =?utf-8?B?YlNWdlZzcnpHWUlwUkEzUXl1akNWR21wbTdMQ1RuMUh5eHNTNXNrK09jVnJI?=
 =?utf-8?B?NDNVYnRtZTVlc1ZFMHhibW1VRC9RSW9kQ1ZndmJ6TmM1MS9hNlh6ZDVZREhw?=
 =?utf-8?B?NlhNUWZueXk4NnZyaDBrT0hQSFVEa3huYWRrcGNYTEVQa3NBaHJqY3M3L2hB?=
 =?utf-8?B?SW45Vng4cVZ6eXkwbmYxR3ZhS3Y4OWtUaFd6WVJKalpLV1hkMTR3SC9pSU1v?=
 =?utf-8?B?SWlkaWdxbDljWDUycTR3RGRYZk1LUWlyYnN0cWRCU0F6bkdBVXlHNjhHamlV?=
 =?utf-8?B?VVBEamtUci92Ui9VM1g0ZGVJdEFwRnB2c01wajAxQjFxZmhOZTdCTlUyWlNV?=
 =?utf-8?B?MDJLN21Ddm1NaVEvWmtBc0Y3TERPdG1LR05HTFhtOUF0VnpzSzAvRXMvQnhl?=
 =?utf-8?B?bmo0eDZYdzhjQTNLL2xVTDZJZW16SmRDY0NodHdqOGpmSGg2RjY5L3oxZE4y?=
 =?utf-8?B?UTFoZEhycktDeWJ6SXh2R2NiTWt1Yng2Yis3a0c4Sm81S1pBR3pYNUFIcWkz?=
 =?utf-8?B?NEZ4N09kUWVvSTUwaG83OUZDdUFyU2VGWUNsdHpKVkQyL2VnRFArZ2hXVDFX?=
 =?utf-8?B?Qm1mQnJnSi9sRk5NemdPcEl3UUROeEFkVXovWlpzOXVpbC9UMDZrZUJRcTND?=
 =?utf-8?B?QzhrTEordUFFdFhZSHQzcUNpdjRpcjJ0b1U4L2RsTGNnbW4rdzRWb2xUL3NU?=
 =?utf-8?B?Vi9GYytLRDIzRnNyNEdoNG9VRFZzRlF4T2U0U1VYT0Q3RVcwMFdNbHRzaDdt?=
 =?utf-8?B?SHBwU1lkVTRIbzlDMk5vVHBJR0V5MnBoWFRCTmR1S1MvS1VTVjBZUDZSZUxs?=
 =?utf-8?B?N1U4WlZDbjdGU2dwSnF4NFZpdnRNUE0vWEJMU1VRM0ZYeUgzV2d0cERNSm1n?=
 =?utf-8?B?VG1aM1YrcHBFOFFnK2pYamNZWUY5TXhzNHVCeFRaVTNmclpJV2JwV2JHc3pD?=
 =?utf-8?B?bGhZQ041UE96M1I2RGVqaklpY1N0a1dFemswK1Zyc3I0Yi9LR1UvSkthVnV3?=
 =?utf-8?B?VWZwUFBKTjNOdzZCT2FoUG5WZkJOMzlRMmNmZ1F6cU5BVXJJM1R5M1huTzBu?=
 =?utf-8?B?UGZSV3liclNFTFliZ3JGYmQvcGJVSk50Z2FFaHZ6bzVMbXV4c3NpWXc5NUll?=
 =?utf-8?B?MjlGdW5YcU5hZVZwMEZuUGM2OVdPcmE5YUJoeWlMMmhVcnRwdHNMZG5LbEpx?=
 =?utf-8?Q?ptQC4zne0AJ7N?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFdzTUJkb1MzQUxlSVA2N1lEYjE4RDBYeU1Qb2V2c1dKWkJVN3R2YVRRUGhF?=
 =?utf-8?B?aU5MRGx6dVF5azJxRFVxTmF6M0ZwUVhNZkNrOC9KWmFoU0hyNmNZdzBWeGtm?=
 =?utf-8?B?NFFwL1gycEtsZ0swZ08zanZtVmFTZFhLb0t2S3VINExzT201dFBvWHVWTERZ?=
 =?utf-8?B?dU9PWGtRdFB5QjFOUXJ2TGdPTEsyL2NPV01OMVJMUW5Sa0NHRi9kVHFhM1hU?=
 =?utf-8?B?QVl2aHMxenhEaFJDdUNwKzJDanFaZmVzdzNYNDc4cktuWlBCS3VxL0xocGdG?=
 =?utf-8?B?V1QrT1ZxR0l2RFJqUUhEc1BCM1JyaVl6NmUxa2hRZE1HZmpSUnJ0M2NnYUVl?=
 =?utf-8?B?eC9YY1o4ZHdyTDFuTUtxb3JXU1J4dW93cmlUaFJHaFl0dThESFZseGFndHgr?=
 =?utf-8?B?ZEE3ak11WGNNbHMvdTd3akc5VmhRYjUyQXRMZW90bVJ6UGRWMXNkMEhuYUFQ?=
 =?utf-8?B?WHZUTHFyRXBPem5aa1lFd1FMTnNOY05uYTlLMFZPZjBYSURQdm9rNjZnL1Uv?=
 =?utf-8?B?SGNtS1dXVElac3JLMzhlOFY5RUpzb3ZGWnNFNHFOOHVYbUNsS3JTSEpTd2RG?=
 =?utf-8?B?U2ZWVHlNRy9tUVBJMy9VNWs5WGQvMjJMT3o1c2V6Nzc0TkMzT1h3S1hBYmFn?=
 =?utf-8?B?TTFvc3BYYTFxN0kyanRRYTlyRVc5Q0Q0SXFXOEdBMnJ0NXo4bjFsQ2dnRHgw?=
 =?utf-8?B?NytlV2YxK2JXUHVjM0RhYmdiV2UvN3R1TVgwb2h3SVJtU1F0RWhWK0hYZFZC?=
 =?utf-8?B?VkZ6VlAvcHA2eTRzSXdzS09rUmllaXZ5Wmp0NGtaQ0kwbWlKayt4Vm8yNmU0?=
 =?utf-8?B?TmhJbDQ2SGQ0VUpHd05qVjEwdXRvWUlpWEVYbnc2Qi9Md2REUEpwNld1bmF3?=
 =?utf-8?B?T3B6T2RENDlINXFEVWxkaTlhcnJRTnJPR0x4WWhLTWZmejNuanRwVWhGK3FH?=
 =?utf-8?B?c1hWWGlJbUxMcWZ1K0tVQVl3Mnc0NmVrWjUwUndoVWNyRG1aVTVnWmhHSm40?=
 =?utf-8?B?VFM4SDhudUxNTUk2R0ljMTZkSTdjbkdreWw3dmh1SG0xK1QwYlc1YUFLVlpW?=
 =?utf-8?B?TTRWeXpSNDJZK0YyVEVOalBFVUNoeis4SUJiTGprVEpHQXI2MGF6R2FScW0v?=
 =?utf-8?B?WGFVeG5LMW84WDUyQ2R4cmEwcS9vSDdVR0ZDVmd2MEdFYmkrWnhmb28rblRZ?=
 =?utf-8?B?MmlRM0thMFRlUWxJbCtETUpmamIrcURXZzFQT3o1ZXc4aHNIZmxQSDhzdzFO?=
 =?utf-8?B?NmVsM3EvZ1dCaXYwQ3NoblBjaTRIK0hJNThhSFhDcUNwRzJCWjJYRDRvUzMw?=
 =?utf-8?B?R24zVjViVk9oeEQ4MklEWWtWREYvMWRJcGllbGtDNW1wdlNHaS9XdER0YUx4?=
 =?utf-8?B?bDMwVU9UdEtLTnBJbkFkMUtPUmJ1bFJkVWVoM3B0MnFWYlFEVnQxZ2tyNGMv?=
 =?utf-8?B?VmN4aGxuV0QzT1Y4SlhiOFJpYi9rcEZqMFlSRm1BMmFVTEU3RXZnS2c0Sldl?=
 =?utf-8?B?eHNXMlJSVzFlMHpSRkFmcEVheUVCcGwxU0theDlWWC9vOTZHNFkxbVZSMmtQ?=
 =?utf-8?B?VE5ZMnBQYk1pZlhyNzN0c2g1NDhyYXRZYzJHTVRiRjJFREU3Q2U2ZzhZSVBS?=
 =?utf-8?B?RGk5WW1QUVJUenVmT3doUVIySkdyMkZmOGZaZGFGSmFiK1RSNG51WFJ1K2ti?=
 =?utf-8?B?T2VVUlpkNEZDSDU2ZjRvRVFnTVI2b3pRNE5NWVNBSUFqaGhxN3hkNWVFV1dp?=
 =?utf-8?B?ZnJlVVFJOEZLK1JxcFJEWkVTVnkvcloxdDFOMHRqWk5yeUZMelFvODFTZFZF?=
 =?utf-8?B?V3psYTA3eGJvUU03ZmtPcElsNEhjMUdvNE9xazlYTW9SUi90OFMzRE1rRUw5?=
 =?utf-8?B?N3dQbmtIVFBOamVqMFZCdUlvYzlWN2hEbVFhdU84NGRnYXVXanArQThwYnk3?=
 =?utf-8?B?eXFrOGs5N0l5ZnRqaWRwVGpRMTNSUW5CM290V3R3NE9NM1RvVU1jc2pNT0U3?=
 =?utf-8?B?RmZTRlFSRkdSUDJ4YXpRbmVPencrTnN1cXlTV3hIMS94UXRia0pHalFyTzlS?=
 =?utf-8?B?Qk81WlFCVWZxTEZWMVdRa1ArU25qOTA4eXBqd2svMnNibE40dlcvL3Y1eU1F?=
 =?utf-8?Q?aDmj39h8Uoc6epfnhVEceP2du?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d84832d7-3777-483b-a90b-08ddae2f9111
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:15:47.8209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8HJUvR8r17SDJJG/sg5Zb3ngzocluAgjnylsj9/lZahVnB2vG95a5zuLoluiMRWOwG/v/ZXnurf8vo4fKX62w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD47FEA206
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 09:33:02PM -0700, Vishal Annapurve wrote:
> On Tue, Jun 17, 2025 at 5:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Wed, Jun 18, 2025 at 08:34:24AM +0800, Edgecombe, Rick P wrote:
> > > On Tue, 2025-06-17 at 01:09 -0700, Vishal Annapurve wrote:
> > > > Sorry I quoted Ackerley's response wrongly. Here is the correct reference [1].
> > >
> > > I'm confused...
> > >
> > > >
> > > > Speculative/transient refcounts came up a few times In the context of
> > > > guest_memfd discussions, some examples include: pagetable walkers,
> > > > page migration, speculative pagecache lookups, GUP-fast etc. David H
> > > > can provide more context here as needed.
> > > >
> > > > Effectively some core-mm features that are present today or might land
> > > > in the future can cause folio refcounts to be grabbed for short
> > > > durations without actual access to underlying physical memory. These
> > > > scenarios are unlikely to happen for private memory but can't be
> > > > discounted completely.
> > >
> > > This means the refcount could be increased for other reasons, and so guestmemfd
> > > shouldn't rely on refcounts for it's purposes? So, it is not a problem for other
> > > components handling the page elevate the refcount?
> > Besides that, in [3], when kvm_gmem_convert_should_proceed() determines whether
> > to convert to private, why is it allowed to just invoke
> > kvm_gmem_has_safe_refcount() without taking speculative/transient refcounts into
> > account? Isn't it more easier for shared pages to have speculative/transient
> > refcounts?
> 
> These speculative refcounts are taken into account, in case of unsafe
> refcounts, conversion operation immediately exits to userspace with
> EAGAIN and userspace is supposed to retry conversion.
Hmm, so why can't private-to-shared conversion also exit to userspace with
EAGAIN?

In the POC
https://lore.kernel.org/lkml/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com,
kvm_gmem_convert_should_proceed() just returns EFAULT (can be modified to
EAGAIN) to userspace instead.

> 
> Yes, it's more easier for shared pages to have speculative/transient refcounts.
> 
> >
> > [3] https://lore.kernel.org/lkml/d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com/
> >
> > > >
> > > > Another reason to avoid relying on refcounts is to not block usage of
> > > > raw physical memory unmanaged by kernel (without page structs) to back
> > > > guest private memory as we had discussed previously. This will help
> > > > simplify merge/split operations during conversions and help usecases
> > > > like guest memory persistence [2] and non-confidential VMs.
> > >
> > > If this becomes a thing for private memory (which it isn't yet), then couldn't
> > > we just change things at that point?
> > >
> > > Is the only issue with TDX taking refcounts that it won't work with future code
> > > changes?
> > >
> > > >
> > > > [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.googlers.com/
> > > > [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon.com/
> > >

