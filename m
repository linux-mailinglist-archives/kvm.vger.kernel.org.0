Return-Path: <kvm+bounces-12613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0A488B099
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 20:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 929ED2E386C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 19:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6DF54735;
	Mon, 25 Mar 2024 19:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iBrNmgM6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B791B50A62;
	Mon, 25 Mar 2024 19:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711396514; cv=fail; b=OpROFGDyNyyiNNfwwq6f9YFbw/JNVYbKwRxvflxouVzsjZJaZk4PT4XlyK5HxzYq5U9j2MWWgF4bQcA+Dc/XKytICXfhy5bywvJVrcuNCnCUrV7/dVkUfHMhktPmFGwF5y3bmFLffGzeCkyUfwFE1/POeYRgjU4qRw1MbnYyjJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711396514; c=relaxed/simple;
	bh=GISEL+EN8VdFZ3eXWWp29cFGbJYTdVEO/KDs/FzhGDg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cuz5eDmdy7brwqI81b8QoY3B1UqMQT5IVXQ5YCgEg9iQFk4fKgiNMJyGFFWHWntztGjgER5oSmRvsaQdWuiJwbJcHaiMF83Up8nnm04MIr9ZYY6aK3YpHv/Iu2edAVjt+PaZRz/blP4OLRYrI/DcYnF/wRkwrR1YumA3uuxKn7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iBrNmgM6; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711396513; x=1742932513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GISEL+EN8VdFZ3eXWWp29cFGbJYTdVEO/KDs/FzhGDg=;
  b=iBrNmgM6ZC9NjK3S3abgUYb9n45G124Z5pMEr5lxK1hLqGX+EaNoVU26
   w5HN+fwg0sBjvNnUdO/LvTBCFvgz7K/wF5/ujDa/J4WtnCjOlX+qRaiwq
   d3fnfLj8EXA9hM/S4PBfd6SmH9oH6DbzwWzQoNv1OY5wCkgN6YKPhmkgJ
   KDmgs4r8mEuChH7ZpGtTG9wOqdfDRlnjCxQBTKdAep2H6LOmN288efrkX
   zqkMK/OVw0amH6CCWah3GNdu6bDoYaAfdQtbvWnKkVlfmlcrDtRWbTSbc
   e6ZfstBIemzQr/DSSvuVFeqAEVX/M/mxQ+JfQjt9HN9W+GAwTE6wRWEJo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="7016654"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="7016654"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 12:55:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20272577"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 12:55:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 12:55:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 12:55:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 12:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTwDqN/Ox2fdHA+/CHFYVLuyi8RPsVvsyuFbTMO/t3YpnxOGZZ//iHUpHYFhOZ63k5M1YT1BlOvQKdmfjAAOz7oGIFUf22nv+oz2xzbyDjJ2X9Ac4dL8vaRf6HFi/ORzg+lPxcMqnK4GVhKh+1f6LkOEjKcrePaiBZ/Bv7z/dlWy+CutaN60Q6hRKqM67PRrP0CmvsI01P/G3pTrK+GPrJWsPdIp5uDmUzvR/fCcOrU+/9i+F+U0evr99WGmZnmcBozPJRntEMifm1GwV9dSzTowkTFLk7Z/WGCBR8p3ue/RW6rhOxMSbodOVJ73M7B03NO9QiqfcVk80DgWzUp4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GISEL+EN8VdFZ3eXWWp29cFGbJYTdVEO/KDs/FzhGDg=;
 b=X+gj4Czj2NIZyQQLbz4iSG1Y2X+Xk2Uf7XuENLPfzRjacNHfDjLww8vxT6ukSj+gi1gqCss55hnpmkGgchVSn+gTy02BjuvqljeQOeXWL0OVyWx9eqCcYK/f5GcwctezqjfFPGGA2Eeqcs7KuLqC++a0louCRxtNSfUredhiPyuMkXGAZsajb6T7vpau92tU+Q6GZTfNtz0OhBQVAnSjlg8kWWWqFMfS09ev+PvXSJXUCy1JuZvfkdsaSKqk3rwhPg2Legwe3/x080vvf70makk3JjkaRxjwSH5SlIGYvxb14RWLCE8eYDK9F5JhJk4XZXJEovRWPDAmZxSW6ojOfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5950.namprd11.prod.outlook.com (2603:10b6:510:14f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Mon, 25 Mar
 2024 19:55:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 19:55:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oA=
Date: Mon, 25 Mar 2024 19:55:04 +0000
Message-ID: <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
	 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
	 <20240319235654.GC1994522@ls.amr.corp.intel.com>
	 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
	 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
	 <20240321225910.GU1994522@ls.amr.corp.intel.com>
	 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
In-Reply-To: <20240325190525.GG2357401@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5950:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GEODv+N7yTRDxO6AMunnJZYLY/XoAW3VZz/teK8SqCnW3YzZUNjCfuMkEOAXeb8pj4AlgbmPnE7xbIlxsHWHTdEEngife8A0d32g/yvaoP3uaAgkdC69GhPYz4YBkNyHpFw881ge3IjUNC5zD36v9ZiJlXoy6SUueQ7TvnwYpTyIlpxTKCzKoVOH5ch5pD8Z7M3wzXviAz4zWHXr12+lvlZZF4asV+wfw6xKNTSvwIJLpqg8cM8lfDPoq5VxqsCBq/gkhm8aD1GE/Ey8QUzJNc2wVVGAjhUlRpmf3vWwWRzyOIVtC1UKdLzEwNpMCLVLijd+KW4A3pstGXS7RH61R/1jFB34qv3MPjqXGWc7mWQYg4zkiQ3vOsjMvbUQZJBVbY9vnNGEF5whZYVpao0RcmPnQyt/n5ma6BU1HhYJyKvbmemEHV+Lfn1OguKgMl1tLM/gG9KRletlPW2tEoJgoOAHEeDmswFBr1H1ImNAHYKrO6DXbeoBQ4d6ur+kbatbYzhVpt2LHRE1m6dKSAlipN53I3z1tnAeFXNIBkMz668sFwXtwyh4nMFKq1RrZ9XHD0aDhRTHLcwgODhmgdS3Kdr+5gdq/NID8t6zASJmBZs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWdIM2haOWd4ZFdEdlZ1cGMxOFRJeldWS3lTaDFzTyt1NXV1SU05NXh2Z0VX?=
 =?utf-8?B?UHpiYVNkZG1meFVmRktPcVVXYXNVQklVZ0l0Q3FmTGE4d0xzREswbVZuUmth?=
 =?utf-8?B?empzN3JyeVQ1c2xYV2xkeUhRZU9laUNBbENlSzNqUEpXOFI0ZWMzRGxTWFlB?=
 =?utf-8?B?cTFxN29EbnEzQk56MFQrOXpHMlNNbXQ5Z2laNW5WKzdmejdUZVJFb0FpV1V2?=
 =?utf-8?B?TWhWa09za1UwbHpwWWhWVVFCK1J0ZVRuQk1QZXkxZnU3aFhFQXBkR1JRSkpX?=
 =?utf-8?B?TndwdEUxL1BXeEkvYjBod0NqaUpnUC9pZkVMMGJ6S3pYYTB2dlZLMGNrcXBG?=
 =?utf-8?B?TFZzTXNvQ0pEM3VRK0xJK29lRW41Q2dFeHdjZG9EZ2w1Nm43bW8xRnFjeWt2?=
 =?utf-8?B?c01WUnFJbElQUDl6enlwT2YrclQyTGtSSEZMamVZWEtvSGtQTVNIUnpsV2Zh?=
 =?utf-8?B?clJFUncvdk1HY1BzMllQVytlaEJqTXQzNzRLb0YxclBYTURqWkdsVGo1Nk5X?=
 =?utf-8?B?MnlQM0pPeEoxTzNIdmp1RzR6QnRLNDNrQ09Na1Fwc1FUN3poL3NER2RSZVZN?=
 =?utf-8?B?VUpaTjZtcllsZ3Z3Ry80TmliOXBya2o2N3lUQXpzYTlDQmhtQTZYTHJIbTlS?=
 =?utf-8?B?MG1wZk00eWxSMHI4dFk2QW9zUWR0cVJIY2RVWElleHhyOVd3V0wvNm1lajBV?=
 =?utf-8?B?U0ZQK09qejNSSEtlY3JEcHBhM3ZsTkR2MmU3aTZYUXN0RlROT2JhYXltc3V2?=
 =?utf-8?B?S1FzVERoaDR6eFkyb2phYWc0TDN3a1BHMVFPTDRYMDJIcUZEaURGTHVHNUtQ?=
 =?utf-8?B?ZjltYm8vOEVZbjh2L2dsak5RNWhnQ3B4WU1TeGJrOFNRTkl3ZUx3VUtCN2xU?=
 =?utf-8?B?aHBXTENEZjZVWmRQQUpJSXBMZDJKYXJrOHhXaFIrV052cUlueU1oMkNxc1hY?=
 =?utf-8?B?a1U0bzB1cTVGdDBPYXQwL21NR3U2aVEzSHFoOUtzOXdXaEN6OTRDNW1rSktr?=
 =?utf-8?B?am5NT0RyNkEway9RNmJENVl1NW9MRXd2T2FkYmd0V3p5YUxocmViMXJpdUdE?=
 =?utf-8?B?WnZ5T0I4UjJaOFVhL3ZzblIveUxIZ2FWRjlMVThYWEhIZS9FUElVS0tTSisy?=
 =?utf-8?B?OUtndjhSVXNLQmJsOGJHM2c0MW5WM3Q0RFhKVHV2WHRNWXdHUEplK2tVSVQ3?=
 =?utf-8?B?V1RsMXVwc05yQVJrcWUrR0trRy9kNFdzSm1MZFRrcjVJOFlVM3ExcmVWZjNJ?=
 =?utf-8?B?djk4dVhpNTQ0dGNzK1V6OEFxWGx0dEpOY2htRXdUK3pjVnZiZXVaN2dGOSsv?=
 =?utf-8?B?ZXN2eFhBdFZZVWFZNGRzbjlSVjFXczV5TEVpSWJNaHJNSkhWS1ZMREF3Umg2?=
 =?utf-8?B?cmlJZllDUUh5TmR6TUU1bG0zQXowN1dPajdiSjlObFBPQnY5S0pqSVlxWll2?=
 =?utf-8?B?Y2FkZUNIK0VxV2RUS1YxUUhuQS9pUW0reVdVcDd1Z1Y5bWhnZ2lkcnB4MEtI?=
 =?utf-8?B?S2MzaTJLUnp1UjBHRTRmSWgyS012Rkc4U3JwV0FReVJVNFhIa05ScFcvU1BW?=
 =?utf-8?B?VzI0RlNFOGk3akYyUXRMczEzS2ZnNmVNaG5hSmxXK3FWNTlTYnRVMUlidDJ5?=
 =?utf-8?B?MHY3OXlJTk0xNGtkSXZIN3N5VW0xZGZLY3FBQU1rSlVKRXRqNjFudzBocThr?=
 =?utf-8?B?NGxpREs0cHdSVHU1SHlnUmpqWTJFWFVrQ2orMHpWb2hWVisyQVZsWFJ3VmE4?=
 =?utf-8?B?NzE1b0cxckhlMStKUDQrMlpaVXlTL0piUHZ3UTk1OFhubkhUcjFtYzhzYUdY?=
 =?utf-8?B?SnM3TUVicVJFZkI3Qjg2NUo4aFdpRzVhUHJkQVpKVlB0ekdMUytsNzlOYXVm?=
 =?utf-8?B?SXNsVk83cHJ4bENDRlRPOTk5dFZGeVc3c0xtanBhSm9NMjJYcHYvRHV4a2oy?=
 =?utf-8?B?eGRyOW1UcmxDWnNaS3oxWnRObTExY0puWjkweWoyQWo2SXVxbHFXMTQ2QU5i?=
 =?utf-8?B?dlM0QkpMQm9zdWNkYkhvUXdOWXowMm5Vb0FnVWVYZi9PNm1JdXNSWGRtS0tT?=
 =?utf-8?B?Z3hWbThWaTUxcXJDOEw5cThIeUxFeWpxa3RjYUh0anJod1JzSlAyaFZwdWIx?=
 =?utf-8?B?aFUxeDZMQjNlaHQrZDh6R2FMS1NEOEpWZG9NRS9JZ2lidmMxc2JvNDlSaXdh?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C923200CBEEEF5418A1748F3DDE5C2D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9bfa658-949a-4115-e199-08dc4d0576b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 19:55:04.0877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: teobtmvPTnsr3BjXxiG80umToAcV/ueoLlLzCYgrL6VJAXZY7vTwFfg/MZhirSGmtKpVjWGPypBecOmXH/NvWewWvHMhItPZRtCV+szFrQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5950
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTI1IGF0IDEyOjA1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gUmlnaHQsIHRoZSBndWVzdCBoYXMgdG8gYWNjZXB0IGl0IG9uIFZFLsKgIElmIHRoZSB1bm1h
cCB3YXMgaW50ZW50aW9uYWwgYnkgZ3Vlc3QsDQo+IHRoYXQncyBmaW5lLsKgIFRoZSB1bm1hcCBp
cyB1bmludGVudGlvbmFsICh3aXRoIHZNVFJSKSwgdGhlIGd1ZXN0IGRvZXNuJ3QgZXhwZWN0DQo+
IFZFIHdpdGggdGhlIEdQQS4NCj4gDQo+IA0KPiA+IEJ1dCwgSSBndWVzcyB3ZSBzaG91bGQgcHVu
dCB0byB1c2Vyc3BhY2UgaXMgdGhlIGd1ZXN0IHRyaWVzIHRvIHVzZQ0KPiA+IE1UUlJzLCBub3Qg
dGhhdCB1c2Vyc3BhY2UgY2FuIGhhbmRsZSBpdCBoYXBwZW5pbmcgaW4gYSBURC4uLsKgIEJ1dCBp
dA0KPiA+IHNlZW1zIGNsZWFuZXIgYW5kIHNhZmVyIHRoZW4gc2tpcHBpbmcgemFwcGluZyBzb21l
IHBhZ2VzIGluc2lkZSB0aGUNCj4gPiB6YXBwaW5nIGNvZGUuDQo+ID4gDQo+ID4gSSdtIHN0aWxs
IG5vdCBzdXJlIGlmIEkgdW5kZXJzdGFuZCB0aGUgaW50ZW50aW9uIGFuZCBjb25zdHJhaW50cyBm
dWxseS4NCj4gPiBTbyBwbGVhc2UgY29ycmVjdC4gVGhpcyAodGhlIHNraXBwaW5nIHRoZSB6YXBw
aW5nIGZvciBzb21lIG9wZXJhdGlvbnMpDQo+ID4gaXMgYSB0aGVvcmV0aWNhbCBjb3JyZWN0bmVz
cyBpc3N1ZSByaWdodD8gSXQgZG9lc24ndCByZXNvbHZlIGEgVEQNCj4gPiBjcmFzaD8NCj4gDQo+
IEZvciBsYXBpYywgaXQncyBzYWZlIGd1YXJkLiBCZWNhdXNlIFREWCBLVk0gZGlzYWJsZXMgQVBJ
Q3Ygd2l0aA0KPiBBUElDVl9JTkhJQklUX1JFQVNPTl9URFgsIGFwaWN2IHdvbid0IGNhbGwga3Zt
X3phcF9nZm5fcmFuZ2UoKS4NCkFoLCBJIHNlZSBpdDoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xrbWwvMzhlMmY4YTc3ZTg5MzAxNTM0ZDgyMzI1OTQ2ZWI3NGRiM2U0NzgxNS4xNzA4OTMzNDk4
LmdpdC5pc2FrdS55YW1haGF0YUBpbnRlbC5jb20vDQoNClRoZW4gaXQgc2VlbXMgYSB3YXJuaW5n
IHdvdWxkIGJlIG1vcmUgYXBwcm9wcmlhdGUgaWYgd2UgYXJlIHdvcnJpZWQgdGhlcmUgbWlnaHQg
YmUgYSB3YXkgdG8gc3RpbGwNCmNhbGwgaXQuIElmIHdlIGFyZSBjb25maWRlbnQgaXQgY2FuJ3Qs
IHRoZW4gd2UgY2FuIGp1c3QgaWdub3JlIHRoaXMgY2FzZS4NCg0KPiANCj4gRm9yIE1UUlIsIHRo
ZSBwdXJwb3NlIGlzIHRvIG1ha2UgdGhlIGd1ZXN0IGJvb3QgKHdpdGhvdXQgdGhlIGd1ZXN0IGtl
cm5lbA0KPiBjb21tYW5kIGxpbmUgbGlrZSBjbGVhcmNwdWlkPW10cnIpIC4NCj4gSWYgd2UgY2Fu
IGFzc3VtZSB0aGUgZ3Vlc3Qgd29uJ3QgdG91Y2ggTVRSUiByZWdpc3RlcnMgc29tZWhvdywgS1ZN
IGNhbiByZXR1cm4gYW4NCj4gZXJyb3IgdG8gVERHLlZQLlZNQ0FMTDxSRE1TUiwgV1JNU1I+KE1U
UlIgcmVnaXN0ZXJzKS4gU28gaXQgZG9lc24ndCBjYWxsDQo+IGt2bV96YXBfZ2ZuX3JhbmdlKCku
IE9yIHdlIGNhbiB1c2UgS1ZNX0VYSVRfWDg2X3tSRE1TUiwgV1JNU1J9IGFzIHlvdSBzdWdnZXN0
ZWQuDQoNCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBTZWFuIHByZWZlcnMgdG8gZXhpdCB0byB1
c2Vyc3BhY2Ugd2hlbiBLVk0gY2FuJ3QgaGFuZGxlIHNvbWV0aGluZywgdmVyc3VzDQptYWtpbmcg
dXAgYmVoYXZpb3IgdGhhdCBrZWVwcyBrbm93biBndWVzdHMgYWxpdmUuIFNvIEkgd291bGQgdGhp
bmsgd2Ugc2hvdWxkIGNoYW5nZSB0aGlzIHBhdGNoIHRvDQpvbmx5IGJlIGFib3V0IG5vdCB1c2lu
ZyB0aGUgemFwcGluZyByb290cyBvcHRpbWl6YXRpb24uIFRoZW4gYSBzZXBhcmF0ZSBwYXRjaCBz
aG91bGQgZXhpdCB0bw0KdXNlcnNwYWNlIG9uIGF0dGVtcHQgdG8gdXNlIE1UUlJzLiBBbmQgd2Ug
aWdub3JlIHRoZSBBUElDIG9uZS4NCg0KVGhpcyBpcyB0cnlpbmcgdG8gZ3Vlc3Mgd2hhdCBtYWlu
dGFpbmVycyB3b3VsZCB3YW50IGhlcmUuIEknbSBsZXNzIHN1cmUgd2hhdCBQYW9sbyBwcmVmZXJz
Lg0K

