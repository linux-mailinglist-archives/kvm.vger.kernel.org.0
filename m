Return-Path: <kvm+bounces-14690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 141178A5B59
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 374371C208BE
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91C8157E91;
	Mon, 15 Apr 2024 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lrh5KqxY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23246156659;
	Mon, 15 Apr 2024 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713209878; cv=fail; b=dG8/nIrGMTBzgmTthrmB55nqd6LPVQPN5I+XXbeBrvrvE/Tu0Qa9xlAboALySNvZqK748DNg0CsnEJDH7MaGjxDCQ97+aKo4aVeRnVsL9xqFzxcV8JbPhvrmSnrgyTHyST7sppZnBz/xCZeFXqSznBykzArbujMKe1N/Bfk7xto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713209878; c=relaxed/simple;
	bh=iiZpkv45pfzCLCTR915wV7W4lNOs94pQyHFiNl/euoo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RkFcT58viN03U28QwXwqutpfvwPFF7JcuN2lReY6g62jyPMFU6n0xm1A/4dHEVdbAHmz7qEz/VJ/LCOUNTE7vNqrVyhH4Dwb4ULlrqBDhDSAg9U/mvSWnlO5zjYdf1/VGTZapd9yjSY9RWjcD4Ly8HHx7z8UQfXa2Ar+LNarIRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lrh5KqxY; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713209877; x=1744745877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iiZpkv45pfzCLCTR915wV7W4lNOs94pQyHFiNl/euoo=;
  b=lrh5KqxYH7cBVDNdJbImdelTOxBBFkn2oVQJe6IdvcelRntS8/GAyJSp
   Z4PWVCEEUJ5dxU/QQQrnYhk7tpIp6HaLe8HfZuH7Mm7NIUj9toaQ3qtoL
   fVpRCQ6QafIxSkdj0mzjgBUZwpdyjvQz54/2r++YT/9fW8q382tGzOA97
   bck2q1gCEfMXHlUJKElOCAGy77doBbo33dLxTFrrqqJxQb8YLk0uboZGp
   vBymVDQQUlHx3DbT2pp6Y4RjTeLyZ3+zFsw+rYY9ne5c0diDK5HqILrHo
   wopeSHYlD4Fnn4k8qPd/rDj9W6ozRMMELKhBZjxXPHCN6OUP+OpuY0+nP
   Q==;
X-CSE-ConnectionGUID: Vng/gjrDTAK2JR8K1T4dig==
X-CSE-MsgGUID: xnrcXKBiQJyYf6/t3U979g==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="11564063"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="11564063"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 12:37:56 -0700
X-CSE-ConnectionGUID: 9eUWG+epRiK3vkyhu4b84g==
X-CSE-MsgGUID: 39Wt7wHwRpebf2wHnb3CDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="22090638"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 12:37:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 12:37:55 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 12:37:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 12:37:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 12:37:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8U1m9n7dyIBEHqslPjGbVxw2U1s22ZilzllpOJHY6mLzKXVMc9NEB5Q3/81KaudEcTNcPB43AD2dKRNAD42+9jnKKNiGtMGejcxTw+VDoJKG/kn6Dq5Z4MyWyvA2B8he3fCfmTwB8osCY8VpUZGBx7gE0leUSMGy1GrHhipzGsrlt6mAUyrA9uz1FcZR2OZHmwlw0LgAPwjlAIbBMbGb609/KJqmxC3zPVsK14AoAie2W1eXO9hEMUJM6AX2Hp2ze+Ics8sR3ZH26jagq+UcjKSGEerH9PirtfKUfm0MDMopWMBTZGrntFhOyFbGtuLuDfjSJlGbAdP6drirKd1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiZpkv45pfzCLCTR915wV7W4lNOs94pQyHFiNl/euoo=;
 b=FBbG1HS8EisziRwYGm3NDBGoh552ZK9p/ELl/q93OE40h+djsCQlcsqiHV9/2n/wG9iBzedP06fJ4YrygAQVK95oz9K5dS4ub/liTvolMHsOsyJBiwfr9qwNJ+v46x0mLEI1XLLmVD7xqGkfu9kKEjNSgaksTS4MEER8P+rWvwUH4QCFpyiGvHzU+itDe8dsYPE0mWk5g7jY/UpixPGoB+MDYmgAbYLR6peG8TnZ/nE+bqAFoH/VwBzde+iGOddhZoevRK58KsydMkyRfEDR05K77/cOX35moGmYhg1ZujTwx/hsBSWqjlzF7of9xFfGTYdzlhTuou/LOXjVbk3qTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Mon, 15 Apr
 2024 19:37:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Mon, 15 Apr 2024
 19:37:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Topic: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Thread-Index: AQHaj2xn+VEgNlPf0Eipl86WfDYsqA==
Date: Mon, 15 Apr 2024 19:37:52 +0000
Message-ID: <245f8011e1f8cccb16a25f080d9521376172f909.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB6695:EE_
x-ms-office365-filtering-correlation-id: e6d27ecb-a3cd-4d4c-15e7-08dc5d838a56
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5nfUJs9rFsk75eTr7Jnmh6/4N9PC9I79/KWnFmiiMH3gU044+R7xUl43syGh0VeX6x9jR3ITP7N20sFfBqQ6jJ2NbXFLn1M0mJv9zb/YP2RiyG23Fyj4bFVaWkYuYiKIVJcdLxUhkQBZ9R5AtIoE0asjUBF2cToOrxBOccy7lVfaKoPKrbyxgQiT2ltKcXINZehJUuOTzO6r1CwoU726ag2IJ2BCM0/GoBqjcfpbViR15JyD0suWRBD8DZZxApH8+REXQxW9gDsAJoT7Ae2x6b3OlBYCi4V4aUbieg37xN1nYjrXFIRYTOnwXdM72lMTbjJFEjoxwEbsRkOYZwn6mG8lmekGXI+ZrLH9j6xChmWgYu7k9NHZp+hqqifYyTpfk63PeEnaBEZ56Nnl7TQvvlbpHT39ZdGrGiBgeIXf7US5YJ2mE1g3Edva09GJc0EUtCX/kz7XWm26IaPtQ+KniNmJYTVcqlm0n/5Db61hHr1c1jpgX30uqhreYgxBeCKND+gobBeTXDqVOQEW9BTeq9JuV2wAocCW+j1hheE/pIG7Z5Cq7uRSPsjmxOYm+1IPmHOVxE8s7Vvxk6Os2MjJQkGWaSPCObE64pXEsYVGX8H6Wphtxkd8bSZJeKbRYYNWBRi/IbRyPxAwPDW+pi4GvcO5wtxn2eDaSBD9Z5t1jIlbixhykWwRO1X5u8KRMisMV80jL5HQ6F8lmm4iDgxpIExM2x6Q6xT18P2d0MJckQg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkR5cE9GOXdoQm5WWjJzMngyQ1dOZlhtOTRQNFY2TEFwVTNnV2VYZG9sMG9r?=
 =?utf-8?B?cTV3Y0loSU1sb2dBd2ZUTjUzckdOT3FMa0hhSGRvOWxnQ1JKbWhsbUx5TUEr?=
 =?utf-8?B?MnVnNWt3MGtwbzBha3UwekFUVnc1S2FNdEJQQXIxZytMU3FJaGxHRnRLemIy?=
 =?utf-8?B?c2VOT2RBUjRIM0JBSDVFemhSTWpSRldCK1ZTaEJlRisrZnE5bE5TM1ZuWGgy?=
 =?utf-8?B?SFRiYVczcGdveUZXS0xhdDI0ZXVhc0Z6YVJkaUdVYTBlckxaTHNpRU5lWVBO?=
 =?utf-8?B?K0VkeHBGeWNMcTlRWE1INFRPU25sLzI4TjZuUGNTK0VOdEt0S1RSNDZ2SFAx?=
 =?utf-8?B?U0NOQ3JyVzBFYSt2dEFTRWhuNWFZb0lwckNQVWVxVXNuN2U3QTBDWXFaVGRD?=
 =?utf-8?B?TTU2Tzh1WVRSWjhHZzc5bkJLQXJwaHNvOHluUmJsY3BJaEtDOXBHL1BHZ2o0?=
 =?utf-8?B?K1RTdENNb25hMUVqYytZUkRaTVY5cmltdElkM0sxajJQdGI1cEtuUm9jTWM5?=
 =?utf-8?B?NG95OThJUktaTFM4YmJhRVd5OUU5YUMvaytlUjdJbjN6NFJUdzBQWXU0ZHpW?=
 =?utf-8?B?Ry8zdktIblUySDhqS09nemR4SW1OcnJBTWVLczcrQnFNUzR4YjBWZUNZcGp3?=
 =?utf-8?B?Q0NZOXlUQlJKWThXUmVOMHE1QU82cnA3Qzc2SWNJWXhiTDdhNVRTUDhoLzlL?=
 =?utf-8?B?aTRnSW9IZS92emtaUmxwSWtyclNackdlaHBQWnN2LzZKcUdRZFphMG9xd0ZO?=
 =?utf-8?B?akszUjRqUTBZR3pvRnhXcjNyYitvd2dkRDVmcnBPeTNOVXZtdmZmNllXVVI5?=
 =?utf-8?B?OVdXUTZlZUZvMGpmUjVUT3p5T3Z4c2FmUG5tQjZJdHZ0LzlvNHZSMklpSUdX?=
 =?utf-8?B?VytPK1JJNDFNeW5tdUtnRm55ZDM0RzBGVlhQcFFRaGVXODVodVBtUXZsUUdz?=
 =?utf-8?B?bHhrVTNVdzluTHVwTEJMWjlld1NmZHZucTRsR043ckRQSlVSWU42bEZveDBm?=
 =?utf-8?B?RzBIcVFLWlk0clVUbEJ2WHlBLzc5RVZpbGNkQUJQVEwxcGpta0RoZ0JsTTh5?=
 =?utf-8?B?UGh6ZitHbDRJSHBHZFhkdGdGZ09Yb2lwWFRVNlpYdE9GaStiQjlQczlib1hs?=
 =?utf-8?B?eS9lMFpXVGZwZGNqbFdDUUhXaFluOVY5SGp6OW9PMDlpNVl5MnV0RnVLdDhl?=
 =?utf-8?B?QnUvWW1EWjRTREdFVGhnd3p4UTFySU83b3dabG5jVzdycHVrWjd1bEROYUpk?=
 =?utf-8?B?M2RKaGxYMlZaSWQ5dWRIWVM0emQwZzZybXM5MURJNVY2SEpNRTJjUkpXYzlL?=
 =?utf-8?B?MkMrT2FwaW15cUFUU08yMk5kajJvaHkrMCtIU1FSblBkM2ExanQxdGZsQmt2?=
 =?utf-8?B?T0pyZHpHUGtZTnZ3dGdwVkdDNXdwekM2VjZza0gwUXFyRnh4SEszbWlENzBT?=
 =?utf-8?B?dXV1S3Y0cXpod09SMWJsM2NxT1BERVFsbG9YVzY1aFFxcUlYUEZUUEw4Mm12?=
 =?utf-8?B?a2tuczZZVzVuQTRvQzduVyt5N1cvTHJlMktHOG5ZdUJrWXVSR0dkQXFQRE1q?=
 =?utf-8?B?RUpnaDhlbk1LdEJiV0pMZGpNMjJZMVdqV3l2aVJKSUtNV0c0YmVBRS9iUDNj?=
 =?utf-8?B?Mll1SkJUZ2J1VzBZNmpxUHpKMkxlNzVtUXhsTFZxOGxHNG9UZW93WVFoejVv?=
 =?utf-8?B?b0gvSkpucXQ2cnNTRUc0akt2c2Mxd0F1cWRuMVcwdXZjZUVHKytDeDg3a1lh?=
 =?utf-8?B?UDd0djFyVkJHcldaT3NxT0pNQ1ZDdWpiaGFXR2JGTm94VnFMTUt4Tkl5RDFL?=
 =?utf-8?B?UW9HbG05SStwM0p6ZW4yNjNKZVRobXVINGNEVFNrMHZhZEl3akI5dEttay9M?=
 =?utf-8?B?N2dnckFpUmdQTExHZlFleVpnVkNsY1k3cTVhTE9GbzNxRlJRbmpSSHZMNDZQ?=
 =?utf-8?B?OWhQSDdac0R3Slo5cnJTdjFkL21zSHhrOFVna0lWOXJicUc0dGtEQnFPbGk0?=
 =?utf-8?B?bmowVDVQaGdSMFh0bDJ6QW91TUgwanAraHJKSndJc0htd0dWcGJGZUxSdmZG?=
 =?utf-8?B?VkJGYkE1M3g0R1ZaTUZZVTY0NDJkZi9PZmdCbFdJRlpzZlE0Q3VqaUVlRm8w?=
 =?utf-8?B?NmRHNExyblBDNU5hNDc5TG9xSzNSNHRvaExCQjRlMEVBSEpTb3o5dVJ3Mysr?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E68CC965BD03224FAF7008787ACA9562@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d27ecb-a3cd-4d4c-15e7-08dc5d838a56
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2024 19:37:52.2113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wLY39UEUgYZrty5oY7xA/fMcDZC1z5TxW0SpGlzTET9ZqXdmRe29Hv+HHPQvwc8FmdgD96T9MZIsbs+anOaZFhUzbFg6w95CBndvM/dMNJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gQEAgLTU4ODIsMTggKzU4ODQsNDAgQEAgaW50IGt2bV9hcmNoX3ZjcHVfbWFw
X21lbW9yeShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gwqDCoMKgwqDCoMKgwqDCoGlmICghdGRw
X2VuYWJsZWQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVPUE5P
VFNVUFA7Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqAvKiBGb3JjZSB0byB1c2UgTDEgR1BBIGRlc3Bp
dGUgb2YgdmNwdSBNTVUgbW9kZS4gKi8KPiArwqDCoMKgwqDCoMKgwqBpc19zbW0gPSAhISh2Y3B1
LT5hcmNoLmhmbGFncyAmIEhGX1NNTV9NQVNLKTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoaXNfc21t
IHx8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIHZjcHUtPmFyY2gubW11ICE9ICZ2Y3B1LT5hcmNo
LnJvb3RfbW11IHx8Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIHZjcHUtPmFyY2gud2Fsa19tbXUg
IT0gJnZjcHUtPmFyY2gucm9vdF9tbXUpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgdmNwdS0+YXJjaC5oZmxhZ3MgJj0gfkhGX1NNTV9NQVNLOwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBtbXUgPSB2Y3B1LT5hcmNoLm1tdTsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgd2Fsa19tbXUgPSB2Y3B1LT5hcmNoLndhbGtfbW11Owo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB2Y3B1LT5hcmNoLm1tdSA9ICZ2Y3B1LT5hcmNoLnJvb3RfbW11
Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2Y3B1LT5hcmNoLndhbGtfbW11ID0g
JnZjcHUtPmFyY2gucm9vdF9tbXU7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2
bV9tbXVfcmVzZXRfY29udGV4dCh2Y3B1KTsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gKwo+IMKgwqDC
oMKgwqDCoMKgwqAvKiByZWxvYWQgaXMgb3B0aW1pemVkIGZvciByZXBlYXRlZCBjYWxsLiAqLwoK
QWZ0ZXIgdGhlIGt2bV9tbXVfcmVzZXRfY29udGV4dCgpLCB3aGF0IGJlbmVmaXQgaXMgdGhlcmUg
dG8gdGhlIG9wZXJhdGlvbj8gQW5kCml0IGhhcHBlbmluZyBmb3IgZXZlcnkgY2FsbCBvZiBrdm1f
YXJjaF92Y3B1X21hcF9tZW1vcnkoKT8KCj4gwqDCoMKgwqDCoMKgwqDCoGt2bV9tbXVfcmVsb2Fk
KHZjcHUpOwoK

