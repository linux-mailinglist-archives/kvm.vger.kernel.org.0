Return-Path: <kvm+bounces-27022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A9597AA5F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 04:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFDDA28C9A9
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 02:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6754C66;
	Tue, 17 Sep 2024 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J1OYdnTC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD021C6B2;
	Tue, 17 Sep 2024 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726539114; cv=fail; b=s4dgdTQlggZj7716Kn+Q6Jy/jxLV1q03V8eemdk46LU8OFj6XZHroXCzwy79IkIcQU8+2BvoiQAAQZupO59M3tWJfdKH+HBU0tcAUqB91s/QKXrIR/YI2GJSWq/Wsj78pfyLU9cWzfxOI+R+ggn+KpnFPgQYoqiZ20eqpaOGpro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726539114; c=relaxed/simple;
	bh=QncAfoKdg4IcHlkH5WxHt6ZTQF2ov75ArOZrstUyfus=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kUn68y49Lt8jt6QiHfbCiYxo+WdGoNWBiYszmHjobKV5mlBlyP5dK7t0pp64J/7VFSmRjx4/jRKdPzNmCcD2JGgeCDIp+nNgx+v0Pu1OB9T0cnrN7KwSAQmjpEak39E2pwFXwigYV+v6bysCAW9elQ5ctxh3wzj4d9bwiw4SgnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J1OYdnTC; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726539112; x=1758075112;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QncAfoKdg4IcHlkH5WxHt6ZTQF2ov75ArOZrstUyfus=;
  b=J1OYdnTCD5I/22v2ypHPirqgWTvpd0yOn4b39pcIEe6oVq6dUTmeuWUA
   AN41w3NHvdpE3XmMGyHnRpuBYzLVx/10khAiScnZomJepU6/a6WIc6DRn
   Jz/1EpT34uCJJsnREiB0mFPdBI4ibfpd9dDwsGRzeumAxwe2nthwrkvqG
   OdF/2jcu9B1xVGRJrcDsIAQ4KsXkEdREgZ8ggafcFoxeA8JSXmJ/UDkFu
   aECqOy2xkBQ9XkzE8iboGGL84VqKJUFCYVjIOPEnCWKL3QEtKA+xMYIuj
   d/JnWvQOw93antm3o/89hxyqdpgSQQS1rJ5bq1I10WLH1Rk+VtO3zi9xI
   A==;
X-CSE-ConnectionGUID: HjL1pdbKRkeeKXzSd+gs/Q==
X-CSE-MsgGUID: SZWiio4cQrSy7WLzgZ6kSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11197"; a="42896055"
X-IronPort-AV: E=Sophos;i="6.10,234,1719903600"; 
   d="scan'208";a="42896055"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 19:11:12 -0700
X-CSE-ConnectionGUID: 69AI9o5KTOqresqpajQQ7g==
X-CSE-MsgGUID: pAv6Q9SuSdynr2ozuXeUDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,234,1719903600"; 
   d="scan'208";a="73877127"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Sep 2024 19:11:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 19:11:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 19:11:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 16 Sep 2024 19:11:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 16 Sep 2024 19:11:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JC4wcW9qKqe1tXy7j5bnAKi0CNPb/jA+XKqF8tJZIpS1+mA3ttlXvjbuVicGFxvJTBTzzTRzWBqlPY55Yx/4O/RuCV1o0hms5KcKbHLNuoUhHoYlBFtxk8y3LZyoG0G6O2bhIDk+PkctPsH4db3QlLQwuGl1jLSvqTCBURCbm2S2N8KhEquAYVf7JKoAKd9U8WTla8+MayuqZfbQ0YnY51k1Ui/yc74VR2iTKm7u1sbyBj85R9scNwSrI0yrwYNJ5aT09gImOEzT2eBA1iOX0ThYDIiHgJNHjkTxoFsDmMgijrfOMmVmRn4WfqoHhsUNYGVOO6AhPkww0mzPo8tASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enHtedmWrFdNhd4aTuLnUw+L5vu1rZSyhZtEz/UIqYs=;
 b=lqp5Ij4uOQNJMRgWOVybIbADfOmchxQuwpgN9S9VVJOMTZ6qv1aepu28aPtPgY0Y01FByt78knHVgXSUIbhZwHX3Bwrq+qV4GXDoLC34LubMCMYQaQVqXwpmNzvSs+FGFRORZ/ChZkZuWGR5h27cVTYQljvx28RxwhIciYlWpDvOZpyyG3fQxwUzss9Vz0wwnZmeQIOVSc9qLni2CU+vmTX0ySHwIwVzIOh6h5ChgMjavw8r37YxBmQBuHbgTB1xjnKdhReDwakUg5C2bO3bTRoKqT09GISaB+yUYXRn6T8Sj3PuZYwEnHbDrxNaVPtT5lGSXJQIw8ciRnKcyB5A2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6329.namprd11.prod.outlook.com (2603:10b6:510:1ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Tue, 17 Sep
 2024 02:11:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7962.022; Tue, 17 Sep 2024
 02:11:07 +0000
Message-ID: <b50bfb56-c2f2-493e-bd87-1c5aaa8bfb59@intel.com>
Date: Tue, 17 Sep 2024 14:11:01 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
References: <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZuR09EqzU1WbQYGd@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb14d34-7eea-4a88-acce-08dcd6bdfde6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T05UNFM5RExuQTZHRTZkU21kOS96akQyZTdUajc2dm1YZ25zb0RGcmplQVJZ?=
 =?utf-8?B?VU8zR0FsTG91QnZXWnVDV1RZYnRQVlN1Z2FEL3BVM21MdnltL25HSmJSQ0xv?=
 =?utf-8?B?RWlhbzUwblQ1ZWdEUU9aZm9Wc0RoTDR0TXpyRlhoaW4zZUJGV3VvOXo1Mlc5?=
 =?utf-8?B?MVJZdzlqMnBQNnVEMkVoOWd6czFVcUVDTVVMNnVjdG04K3l6WkptdVNtejZX?=
 =?utf-8?B?VGJ2Q1NmVEk1VVRUZXUwZzVncURPRTBNQTlmYkVvRjFLaENPS0tKQWJiajNZ?=
 =?utf-8?B?ZVZqbFBlbWFHV0I3V296OUw2SUY5aWlhOS84M0FmcURkMFdwTjlFSGVSS3p0?=
 =?utf-8?B?TEFFOTZLcTRHd3ROSmFKTmc5T2s3anpUTmJFbHBPeHFacGM5RTRLK0MxTCtw?=
 =?utf-8?B?RThDMTVYcm1rbS94cDZYR2VXUlJxQXBJRmdRWWcxajB6NXBhUWpteFB3c1RR?=
 =?utf-8?B?SUpYNWRxcXM3TFRQY1RJWkpJd3FEMnRiQVlrTHNRTmZLZXA3QTlsdjloUVYx?=
 =?utf-8?B?aGE0c3huZGtGaHBPYTJZVU5pQ1gxVHlDbGM2V1Y4TUdVbUhCZ3R0QWs1VDUy?=
 =?utf-8?B?WUpNMGNBeHRLNEN0aVlpMVNoRW9vWTI4TnFnS1BGYnl6VkpuQktmWjlYS2pR?=
 =?utf-8?B?N1d6QU5XczR2MFJuRzBnK05xUitSNnZEcjNaS0xLVTl0RjJUZHFxcFdWaXJm?=
 =?utf-8?B?YzV2TlNCeThmR3hRQVlmRGNpeHZHZHV4b0VqMklBc05jdk9GN1FSZXhld01H?=
 =?utf-8?B?cE5aeFNHSjMrODVuTlBPbU9nMUZOZEhkd28rK09DZTBYR1hrK0FhM0RDTG1T?=
 =?utf-8?B?a0xoaVFyMUw1YXVpejBCRlorVFVONmRJM3p4ZG1xOFhRTDBvbThPaEF1TmVv?=
 =?utf-8?B?YTl2Ty9CdmY5b05UQXJRbVdEVnhLNlRzZlFiS3MyeVpUSEJoZjNUVk1uUXFC?=
 =?utf-8?B?YmpIOTBkaHlQSXRWbFRGS3FoNkFyOVo5em0zdDYxNGZVU3U3Vy9wWWpEek9C?=
 =?utf-8?B?a0N0ekRLYmJLR2FFL29WbEpDdTFDcDcvZ2haNytZb3hwNDVWVE1qdE8rOUxk?=
 =?utf-8?B?Z3JrcWVPdGdvNVM5YXpDYVFBZ2d2UkFaTFhmRkdoc05DaTd2ZE5FU2dyYVZv?=
 =?utf-8?B?cUdBWDIwa05DQ0NwV2tZdlVIcHB4ZnRIcER2SzZaTTZhemhxdWg4dGs0UlBK?=
 =?utf-8?B?dHo3M0J4QnZMMnRoWmt0Mkp0VVJHVEhxczV1SlZuNDB4Y0hvSVk5bnBRazky?=
 =?utf-8?B?SlVSU3NGalliL2xCYm9URXdFaWFyMTNIcCtScldzL1dyKzFST1dScWl1UFFo?=
 =?utf-8?B?RDlwZWRQeERsRklVV0UwQ1ZtK2tlcXlmMVhtWWJ4Q2pkb1dLSFFHMEZDZVBu?=
 =?utf-8?B?aTFQOGVwd1pVSU84ZHRTWEpyZTBLdTNnMkRGN1JESDBmOGtvQjBISlBRNEY5?=
 =?utf-8?B?YkJGTm9WYm03Z1R3TDlmNFRxNjFTMk1mVWF0L2Z0OUN0cmdvcTNORE5jNG9D?=
 =?utf-8?B?bXdITUR3ajI3TWE5d09qWXBzUklXalkrTFNHNGVkU1lOaE01NGZ6N1U1dDUy?=
 =?utf-8?B?OXRlTGIwY1MwNGdrV0RDUGY0TmEvMXEydkUwbU51WGZuZGMvWFhDUkUxM05H?=
 =?utf-8?B?N0VWcUNxV3lPOEkxLzFibmNna2hPWVljQVF6MEhPNk1VL1JOVjdBK05pVllk?=
 =?utf-8?B?Y3l3K04rZHAxM1FGUmp2eUR0cnBtbXNtNjBnSmtZaEVmOElzaTdCK2JPUmw5?=
 =?utf-8?B?bmNNRW44clhRb3RxV2dvaUlLSnBxSFd4WnVicHZpVEFiR2JSbWIwS3BMeXRl?=
 =?utf-8?B?bXdwS3NwQVV5TVR5T2FNQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzhrYlRTYnNaNjVFalNod0ZLNHBJbVhaQnVLUTZPbWZoWENtZTVyczExaENG?=
 =?utf-8?B?VzVMenJUdG9ySlpXQmlRUERFdmxVVHZCOGpTNTMyTlNkaDJuRGdyQ3R6RmM5?=
 =?utf-8?B?QWphL0xEZGRpOEFDZzBnL0ErZlZkU1NJdy9KY0YvN3l4ekJOdlVTVzFjZENr?=
 =?utf-8?B?aDU0aWViVVdKWE9wRTRhb3I2ZkQxQ2FkMWpaaS9mMGYvbXFLeitaUHZqYU9m?=
 =?utf-8?B?Q0ZsRHk1S0dXQkY0YTRsVmw0ekgzNDFNRkQ4Vmd1ekpTWUFhVmpQcytzTDNG?=
 =?utf-8?B?OU54R0oxTmFTNjhDOS8yYTdKbW5vbTFtM2tZSGcrUjh0NEF6dktkMHpVaGlp?=
 =?utf-8?B?ZFpVVm94YmNrdFQ2OFo2V2NjNERjWjRQZUxWTExQcC9hYTRiWmxEWkllVTFl?=
 =?utf-8?B?QTZYOW1oNkYvSlFKaStvY0ZTL0IzeXA2RUc1SzVmblNkNVVoSFVYTXMwd0N0?=
 =?utf-8?B?YVZQVUZZN0V1c082SkhLMXBJNVVtN1NGWmhOVDE4V1JYMVRUS2RJSHV6b2lO?=
 =?utf-8?B?azNXaDI0bmZsSkwwMGNoUWFtREswNGwzOEwyK2hSc1RnVWNJUEIramxsU3Vi?=
 =?utf-8?B?c3JlMmZzblgrUUQrUW43T0pSbFgwVy95dHMyN1Fjbk56WHJ0ZEJidVBnVHFZ?=
 =?utf-8?B?dnNpWDJDcnl2dkRSSm1lRTJsOGVSSWNGcTcxYmo0OStDbE52YTNUSFVYaWg1?=
 =?utf-8?B?YjRZZ25IL05NMGlmM2Q5Y0h3cVBiUkcycnEyd0VXYWxHYlNVYWVoVkUydExy?=
 =?utf-8?B?Zk9BWnNBRFlwQkFka0tpTkFITHNFNFpTUUpWVTBScHhzdU9oZmd0L3NCVE5k?=
 =?utf-8?B?cW1MZUdmcU1nNExxb2hrdVRiS3lmZkVVZDVSbW9OS1loUnlpTWRISVJNR1Qx?=
 =?utf-8?B?WmtXRTFqQWx2bUROQzZtbWYzaUNRQ25kR1k3aEIyZXJCMzZsNlp1ckMvek5w?=
 =?utf-8?B?aU1jZEM0c0tRb2lwUk1obnpMQXFVKzdtcGVaU0tJN09mVkt5T2pUTStZZXlu?=
 =?utf-8?B?VFd1SmdSejM1V0kwZ29iWVF4L01pc1JneW1tT21CcFo3WU9NRm9xT0dhTFZT?=
 =?utf-8?B?WXE2ZU92a29ZYzJ1WXE0VUZ0TUNuMkFHWWFXak9yR0x4aVA4YWwwVk84Q2lo?=
 =?utf-8?B?Y0hNUDAwcWp2cmp3QXZqamdOL1FVMUd1YkR0eDZnRHpjUUNKWEI3RUI1Yktu?=
 =?utf-8?B?bktGYnRQQ1hZbnluVy9FejNHYzV6NVc5L2VZYWcyZlNVMWE2aWt5bHlqR2x3?=
 =?utf-8?B?RWJDUi9kR0thVyt1THVFVXhTNHlGSTlPbmN0NEFuM3VmTzVhOXZjb09CbWQ5?=
 =?utf-8?B?V1Nxa0RrZVRuVGxSUDYza2hRendiZHVXUE5zTk1sQ0lyVStBUEliaVdUazl4?=
 =?utf-8?B?S0JubDhxajVYWkNaZTMzTFRpRkRqbnhEaE9zSkFPTnhFS1NXaEdrUytNeUUv?=
 =?utf-8?B?ZmNjQXBKMGR0enBJR2tiRm5QVW44aUZOaGd5TmFHNUJhbzk3aTFDaDNUWlJ3?=
 =?utf-8?B?NTRaT0VoWkx6cnVjcXAyREliUmQvak9WOWFZb1NFYjBkSWYrUWVXYTF4VFF2?=
 =?utf-8?B?cXFmSFgrU0N2alcvYXA0WmpneDNJcUNnNmZKQTZ3R3ZkUDZrWURhQkJ2bG1r?=
 =?utf-8?B?aWlOS1ROVE5XdnNFNEVuVk1CeEt2THVBV0JJZFRINGZmdHJEWVVKckdheTM5?=
 =?utf-8?B?a1FhNnQrQTRxMXJSdDAvU1I1SUZ6YTJXbFdyNXpHbkVZZDdWRkpHNFByNWM2?=
 =?utf-8?B?NHE4dWdsQURhU05IZW96c0pLZlVBMnE4amlITnVTNVE1YVRoNlc0c2tYZUZL?=
 =?utf-8?B?cTA0aWZvNngzUG00eUlpeVRKdGVhbzg0eTVrdWlPeEdCZjdUYnpScW42cmYy?=
 =?utf-8?B?MENhenJzUUJoSEhRRy9lcTlneXpjNzRZSVJjc1VOeHU1MnhIbWlMVUV4blFI?=
 =?utf-8?B?dDdNWEkyeXlYK0pTazI0UjJLUzNVV2cxM1dyZFE2eEJSTThPNE1XZEhDaC9I?=
 =?utf-8?B?alpGYlo1aFJ0UTRMMHFNZnYydGRqQ0Z4Sm5PbGFqWm5wcGg2a3lCN2RYSWRD?=
 =?utf-8?B?bXkrYXlXdlRaUVlPQWdEb3lZcEl3ZHA4SDQ3YzZLeW9COHFEU3BCYU05Znpp?=
 =?utf-8?Q?d10+bPzFNJ5yspR1IIgDlFTbt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb14d34-7eea-4a88-acce-08dcd6bdfde6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 02:11:07.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZPI3uWg1tzyPSr5rpe/DwXSffN9zpJF+yHAKgQp2rGPYbKiDvL9d/6juoCZqQT3Q47d4+543trpDYC93Ixr4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6329
X-OriginatorOrg: intel.com



On 14/09/2024 5:23 am, Sean Christopherson wrote:
> On Fri, Sep 13, 2024, Yan Zhao wrote:
>> This is a lock status report of TDX module for current SEAMCALL retry issue
>> based on code in TDX module public repo https://github.com/intel/tdx-module.git
>> branch TDX_1.5.05.
>>
>> TL;DR:
>> - tdh_mem_track() can contend with tdh_vp_enter().
>> - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> 
> The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> whatever reason.
> 
> Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> hits the fault?
> 
> For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> desirable because in many cases, the winning task will install a valid mapping
> before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> instruction is re-executed.  In the happy case, that provides optimal performance
> as KVM doesn't introduce any extra delay/latency.
> 
> But for TDX, the math is different as the cost of a re-hitting a fault is much,
> much higher, especially in light of the zero-step issues.
> 
> E.g. if the TDP MMU returns a unique error code for the frozen case, and
> kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> then the TDX EPT violation path can safely retry locally, similar to the do-while
> loop in kvm_tdp_map_page().
> 
> The only part I don't like about this idea is having two "retry" return values,
> which creates the potential for bugs due to checking one but not the other.
> 
> Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> option better even though the out-param is a bit gross, because it makes it more
> obvious that the "frozen_spte" is a special case that doesn't need attention for
> most paths.
> 

[...]

>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5a475a6456d4..cbf9e46203f3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1174,6 +1174,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   
>   retry:
>          rcu_read_unlock();
> +       if (ret == RET_PF_RETRY && is_frozen_spte(iter.old_spte))
> +               return RET_PF_RETRY_FOZEN;

Ack the whole "retry on frozen" approach, either with RET_PF_RETRY_FOZEN 
or fault->frozen_spte.

One minor side effect:

For normal VMs, the fault handler can also see a frozen spte, e.g, when 
kvm_tdp_mmu_map() checks the middle level SPTE:

	/*
          * If SPTE has been frozen by another thread, just give up and
          * retry, avoiding unnecessary page table allocation and free.
          */
         if (is_frozen_spte(iter.old_spte))
         	goto retry;

So for normal VM this RET_PF_RETRY_FOZEN will change "go back to guest 
to retry" to "retry in KVM internally".

As you mentioned above for normal VMs we probably always want to "go 
back to guest to retry" even for FROZEN SPTE, but I guess this is a 
minor issue that we can even notice.

Or we can additionally add:

	if (ret == RET_PF_RETRY && is_frozen_spte(iter.old_spte)
			&& is_mirrored_sptep(iter.sptep))
		return RET_PF_RETRY_FOZEN;

So it only applies to TDX.



