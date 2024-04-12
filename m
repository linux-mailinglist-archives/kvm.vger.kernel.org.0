Return-Path: <kvm+bounces-14547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7994D8A3377
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 046FB1F21F0A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18857149C6F;
	Fri, 12 Apr 2024 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHKQ+hXJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23075148852;
	Fri, 12 Apr 2024 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712938541; cv=fail; b=ji2jE2NgUSrGXB96iI0bPYx1+9eU/kBuNf75y+mdV4mnpZysSrYqt5/WZWyTmdt0nFpYl2axbs318stMPymd2UkjRer5HvWTkQwWpekxHoY5+v/kihsBQUdHzrFsackmo81/xHAx74LAh0kGOMJ1EFMGVbhz8RgG5EGjaxSQkDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712938541; c=relaxed/simple;
	bh=sHUixiDWLPyOfzhnzxEZXk5EaNP6unz6ia4geiVQuRw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JqeDzNhdbfQNIK2/NW/NrVVwPRPAgN9SiSfzSqnEIpy8OfQnVAUVysupRFGKwAMuiENnw6mUeLWqzOgHZU/yTnnK24Lh+LpzB0dbzBpZGOATkiN7wrg3C/QCD8EAEjYuA20RMszs8yK7lgspRPTQOnNFkLIf1Cx6NmbDhPI9rEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHKQ+hXJ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712938539; x=1744474539;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sHUixiDWLPyOfzhnzxEZXk5EaNP6unz6ia4geiVQuRw=;
  b=OHKQ+hXJw7oXXY/wpNySrcv+YctPJwUTDauZlttIao0v6hwV5hWq/Fsu
   jQr58KCasjADkSqD0gOAVOaRHdLPldNeWIGKqMJfDdPlX3rBvfgRRkEjc
   +A2VATHv2/KAZKcG0Hm/EZ/jCZ8kUXv0RQ7G7n+rtDoQEp7Vk70HufXxR
   V59SZGCA3j3rUvrUmIlp91BU4jN+0rc+QvoZ0ocIJL6i5gYdWFsTeBj3Y
   awnm5QBtSbDKm0L3olFaNNVbnbSJzyat5cvKK/2ykD5j0h4o60YngMfFN
   hO6VOUnzRKrkx+QdEhEDByAfs0YPSYecyrbNtDGI8HlvsQy8LDn5D+KOo
   w==;
X-CSE-ConnectionGUID: gN8trusOTreSya9QgyaSfQ==
X-CSE-MsgGUID: iBPvS6tlSF2vTTvsU9yW0g==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="30880562"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="30880562"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 09:15:39 -0700
X-CSE-ConnectionGUID: 5qXe5nc2SkO8YHNNBL4xaA==
X-CSE-MsgGUID: WWxBURahRtqgXk7WcDWsSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21310812"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 09:15:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 09:15:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 09:15:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 09:15:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 09:15:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ5s2NGTi/Gb8jd6E3ixGSmv7KQlMrR2vmAWnsdOpn4vvWFgL/N1sxewR2YKXHxX5a2+9gZBGfSo9soP+ota6YXbCysJlOj8JA/Vj7S6Qu0oQtEmeEqZiFPliCfG79FSKVppajT3C5plK70ZF1W9jtNVlLcpNrCEooOBFkJ2hiwDoQD/wNgFqIBA3Bmo+N2PnTEhR6VgdpoQLk31af6R7C0VXF7SNvQQ0YtiZogn2bvFOTUESvycTQ/fptPUpclCXBvBv4MYqgVkVjxOX5vcG4LJVyLE/Z7/BszkTEaWqcDKpJKMDMydLuYNXrPbytDPL6GMker7soPfK2lG0q55xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxC+4eY+KNbJN91aQIWJHNxLIigxi8ys2aMwKqxSv/0=;
 b=NuF05TdscSWwnTIzMPbcYD5A69Uccq+0hUGEMBaEfDJC087QVcwnFlslYz0Je7McZNB2ahtcsZirsJXZ75DbTd4AbGvwSixfcKw85BJgh0JkfUkpdwdJUz1izbWw446K+NDPt+OOuHB1KAIfHJ4svBUeuYquFvhe2C8+aesybClfd29fzCQMy8gRG0X3HLUc61qRKZM28IcoFMpmgkkZ1B9Ciug0cvMEN5OfieLyjDszlcxMYBfE/0YbhWc0YBkzQ6quzH6k0PUzrTVQ2oQC5rAIOjnJYzfb7JttvTJHT79EpPQYnllVw5wYt3z0K9YY+VNpBen0i0cFn44sCsJxzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4708.namprd11.prod.outlook.com (2603:10b6:5:28f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 16:15:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 16:15:31 +0000
Message-ID: <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
Date: Fri, 12 Apr 2024 09:15:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:303:8d::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: 615f4d59-f883-47d5-e6d7-08dc5b0bc6a2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0yalPYO269IC+kmnWtIZFXzMtwx04YCnItMnMGtTqLRDz0pt44Ct5euYglI/T1pYqsm8jaAw0vtteRK9wgAUxZE0RUW8+Ynkw7UCUb2EvtzXE3rH5qBn+91e0UK3aZTVsiBEN/CQzGG5IRO+Wz05tGnDrUeP71hhhe2zeaKwhpTl0DiyfhBZoZO/1PxRZP29jUSoLJVaKUQ3+CVckTn9DXSD3FLg+vriIl6ExVzmFQAIqiLVAsyWwOa3tF04LwhsevC72ocC2fkWNGzgLdzRL2ZO5vdEb+3eMj3IrG/crV0xsVZTXpxk+OirlV3B5D0U2mUgavvy7sd2FOvXeUeIt8wrCNRJs+fB1eykPrNg23pczr58BdfglbC26YgliUAGTWo4nPSbTJoBFyb0j0XxtGMssCiRbHpbiekeNKM0h6PGKmx3vYkHWb4O238Yy7MeLkV9/bn+/Uxn39FJOKRaWCkl4wYrAlm6C1drQschHF5D2Gfmit800DEo8GX4QAoTvI0/66RnlZucvfKriL5f8niNWcrOaTZVIjgpne7wqFN6eshcWi4XA6Hd4mHjkmVN6mIRh1qvqh4HpFxatMiBlHCGRuG5/kFwOf9bIxLccsM9lVknw9naQVcoaivYbl8nl7j+hmGLC8cp4PW/KQTGt1SxWEsoGmOTtp1M1GD/to=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmdNd0ptdCtjVThCQm9qMlQ1UVo0WUNVT3BlRXlwTXJJV1cvOE12S2NwdXVD?=
 =?utf-8?B?TDA4QUpGMklrWWZnV1VyNnJxZkIrWExJVnBYU2FKN2RYNEtZK0JQR0FxbDJC?=
 =?utf-8?B?clliazV1ZDIxVTZDUVpTaVN5ejF3YnEzc2x2N09xUm5mdVFtK2tVbkJLMnlW?=
 =?utf-8?B?UGM3dmt6b3lzMXpWODJkWGVKazFUMnpNRHRYNzB2clc4dHJwR1BkdFpJQjZi?=
 =?utf-8?B?Umk5TmZuY0NpOHV2ZnMrdXEvOGhKNHZ6ZjNsYTNqTURxTTRXdjFPVlRuUGNF?=
 =?utf-8?B?ZzNJbTlMOXFESzdVRElJc09selEyVzVTdG1sVmFjcmd1eTU2YVladlFBR0Nz?=
 =?utf-8?B?U05RWVRHaHJ6aTBma1dEdmdVWFo5VzNONzFubUJPZzFEZGkzUEJJcWEvMmpn?=
 =?utf-8?B?aDBQMTBDeUFmVE8vMnM1OFFBcENKbTRHTWNZUE9ocFl6RHMxZ0F4djV1dGpW?=
 =?utf-8?B?WXRxL0c1aHFiTkZKSjhnQVFnVVU1c2lwWWlYYUtTUzRoTVBsOC9QWU54T2Zt?=
 =?utf-8?B?aCtIZms5M1h0V1Q2djJZa1FhcmFJRTFGR0tac2VZOWFFTzJydE1aaEdBaHZh?=
 =?utf-8?B?RExhTWszQUFwYTQzT0dFVlRkUWJZU3d0d0ptdFROMG5aVDZIekV3cVhsaHlY?=
 =?utf-8?B?T2FMZXVSejB0a2Zlb29IclJLYWg4QzJTeElOVmttamRNQ09kd1FXSloxZkk3?=
 =?utf-8?B?RFBINlJzbmFoamN0TzNEeUFpNFFJNTF4VkRQZWxBazBHVFI0RDEzQkUvUnFG?=
 =?utf-8?B?SHpFS0FhcXpyU3M2U2NyZ2l2VWN4bStRMzVyYmNrbm1Ta2JUWWtMQ1p3akdQ?=
 =?utf-8?B?TnowMzhhVWdHQk1aS1Z4aHFtQXlIRVN6c3RVbk51bHVrV0RhVTRRU3dxMm5s?=
 =?utf-8?B?SWhmSVFsUWtUR3ZaUEU5QXpBT3Bmc1UvUUdXTG92K2QvVjBFOEtIQkh4QWFY?=
 =?utf-8?B?SVlIQ3MrcWJkRlM2K0NWODQ3a0N0MFJJZm9WcW5KQnZ2TnNEalF1aitiZFAv?=
 =?utf-8?B?Tml3bGtWZStWVWFNR2QrOEVhcCtyc2oyeHlWRXp1bDRLLzlHZm5ReGdTb2V3?=
 =?utf-8?B?aWQrSHFkWm8wcDZnZjV3WGRicnJVWWo4ZmJMZzRrSGFLaXZMZTN1cjdodCtJ?=
 =?utf-8?B?OTRHNGo1NlcvVzFHZmRQY3pVUlZqcTMvcS85SHZQQmVQT0RHVm1YUXQySVlT?=
 =?utf-8?B?Nm52Z1JDTytDUXU3NFhaekpmZFY0dFlzNURsU0hTUW1PQWh0WkFmUnBMbVhk?=
 =?utf-8?B?a0d0SkpqeUJCc2RjSUJxbkVTQkhzMGovSWtVVDhVMkU2bTZtLzZGQmhUYXlW?=
 =?utf-8?B?VUFwdW9kVVRXWnhxSWQwVmtncmFtT0p4T2o0MlJtN0VrQnN6T0pVM0xkRXlQ?=
 =?utf-8?B?MllBcWh6RThYbzFrTXJWT0FkT3JHSVkwNUdqUU83SjlpVzgrMWw2dlBVeGJR?=
 =?utf-8?B?MWdoQU1CalRteDFLOWZEc0d6ODhna3ZlbXYwdmg4aSthMTF0YTNWOWw2bVJv?=
 =?utf-8?B?QmJ6M1hlZ3IxK0JmMkc5OW5MdG1PYWhRMGhiWEJiY1pZWlljLzI0cFRNek5h?=
 =?utf-8?B?aUcvZm5TZlptYUVGNWk5dk55VHFVZTVRMlMzUHhDdUhRdFBMcFlFcHl6bUx4?=
 =?utf-8?B?RGUrWUwwMldWNWFQYnZYTlhDOVowN2c5SGc1QnB5Z01NT3VVd21SY0hJRHN6?=
 =?utf-8?B?NHllRmxwdXArTmFVQUxuRXRVb3NmL0taOHJtZWhiT0syMnFYZE9jc2FiZWUr?=
 =?utf-8?B?NXBPbjhiUisxaG9iNzd5d1Y1VzhUR3BjbUxPbmRmS1o1TEdMMVdSa0J0OHh2?=
 =?utf-8?B?b1k3VjloL3o3emZWejJkQURDbkNLbmk1ZllSQjM5bGJVZEJlWUtsekJwWmE5?=
 =?utf-8?B?Z2ltNE11blU5MnlCZ2piM3JMd2ZMTWtMS3VNekVzeUtrY2lSYUZ3c3FnR3hj?=
 =?utf-8?B?bDViUDNIVnJKdDlnOTJWZlAyMzk1cGZiZmR5WDZYY0x2VCtWVWViVk95U29w?=
 =?utf-8?B?NnU3V1E0L2VhS1E1cmVRRzN1QS9OZzMxV3pOcmwyUml5d0V0OFIyMXhGSFJ3?=
 =?utf-8?B?aGtmaHRoRVpsK0NacWFFaVZ4SzdWZWFZbENFR0E0S281elpUYmR2ampUNno1?=
 =?utf-8?B?VUtTOElUc2xXaFJUd2E3TWZDT2pMT1ZPOTJYVEZkSlVidHB1MWpiWmMvR1k2?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 615f4d59-f883-47d5-e6d7-08dc5b0bc6a2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 16:15:31.6893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDa6nC7ZzupGMT7o99Gf1UGm6tZEpdCaG6fauhEwrzLoxpv1lF3rzyxI/fcGLLN3f74RbIPTZUgdYimgjftoLDkpLgHZGes5+Cd2SiVzLos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4708
X-OriginatorOrg: intel.com

Hi Isaku,

On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>

...

> @@ -218,6 +257,87 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
>  	free_page((unsigned long)__va(td_page_pa));
>  }
>  
> +struct tdx_flush_vp_arg {
> +	struct kvm_vcpu *vcpu;
> +	u64 err;
> +};
> +
> +static void tdx_flush_vp(void *arg_)
> +{
> +	struct tdx_flush_vp_arg *arg = arg_;
> +	struct kvm_vcpu *vcpu = arg->vcpu;
> +	u64 err;
> +
> +	arg->err = 0;
> +	lockdep_assert_irqs_disabled();
> +
> +	/* Task migration can race with CPU offlining. */
> +	if (unlikely(vcpu->cpu != raw_smp_processor_id()))
> +		return;
> +
> +	/*
> +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> +	 * list tracking still needs to be updated so that it's correct if/when
> +	 * the vCPU does get initialized.
> +	 */
> +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> +		/*
> +		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are,
> +		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
> +		 * vp flush function is called when destructing vcpu/TD or vcpu
> +		 * migration.  No other thread uses TDVPR in those cases.
> +		 */

(I have comment later that refer back to this comment about needing retry.)

...

> @@ -233,26 +353,31 @@ static void tdx_do_tdh_phymem_cache_wb(void *unused)
>  		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
>  }
>  
> -void tdx_mmu_release_hkid(struct kvm *kvm)
> +static int __tdx_mmu_release_hkid(struct kvm *kvm)
>  {
>  	bool packages_allocated, targets_allocated;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	cpumask_var_t packages, targets;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long j;
> +	int i, ret = 0;
>  	u64 err;
> -	int i;
>  
>  	if (!is_hkid_assigned(kvm_tdx))
> -		return;
> +		return 0;
>  
>  	if (!is_td_created(kvm_tdx)) {
>  		tdx_hkid_free(kvm_tdx);
> -		return;
> +		return 0;
>  	}
>  
>  	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
>  	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
>  	cpus_read_lock();
>  
> +	kvm_for_each_vcpu(j, vcpu, kvm)
> +		tdx_flush_vp_on_cpu(vcpu);
> +
>  	/*
>  	 * We can destroy multiple guest TDs simultaneously.  Prevent
>  	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> @@ -270,6 +395,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	 */
>  	write_lock(&kvm->mmu_lock);
>  
> +	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
> +	if (err == TDX_FLUSHVP_NOT_DONE) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
> +		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +		ret = -EIO;
> +		goto out;
> +	}
> +
>  	for_each_online_cpu(i) {
>  		if (packages_allocated &&
>  		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> @@ -291,14 +429,24 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
>  		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
>  		       kvm_tdx->hkid);
> +		ret = -EIO;
>  	} else
>  		tdx_hkid_free(kvm_tdx);
>  
> +out:
>  	write_unlock(&kvm->mmu_lock);
>  	mutex_unlock(&tdx_lock);
>  	cpus_read_unlock();
>  	free_cpumask_var(targets);
>  	free_cpumask_var(packages);
> +
> +	return ret;
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> +		;
>  }

As I understand, __tdx_mmu_release_hkid() returns -EBUSY
after TDH.VP.FLUSH has been sent for every vCPU followed by
TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.

Considering earlier comment that a retry of TDH.VP.FLUSH is not
needed, why is this while() loop here that sends the
TDH.VP.FLUSH again to all vCPUs instead of just a loop within
__tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?

Could it be possible for a vCPU to appear during this time, thus
be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
TDH.VP.FLUSH?

I note that TDX_FLUSHVP_NOT_DONE is distinct from TDX_OPERAND_BUSY
that can also be returned from TDH.MNG.VPFLUSHDONE and
wonder if a retry may be needed in that case also/instead? It looks like
TDH.MNG.VPFLUSHDONE needs exclusive access to all operands and I
do not know enough yet if this is the case here.

Reinette

