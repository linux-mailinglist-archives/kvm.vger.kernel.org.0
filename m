Return-Path: <kvm+bounces-18239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EF58D268F
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 22:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B9451C25D42
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 20:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256E117B407;
	Tue, 28 May 2024 20:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZO36PHs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E613C67E;
	Tue, 28 May 2024 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716929677; cv=fail; b=LQOwVQ6HDLH8Xv4Lv89BskkdVYs6OpkFDnoEEy3ughvqFqjtcLUYGXqXD7MnmkZ31KI+zKXqGw8XLkIYAAwV+wZ3MpudhXA2vg0Uz7bOFE53ZWxMQ/0Cr+nBgFru11HqllNVFiupTG9JYlQOc+F+tSdUquGoNjSs4yNRoj6Gnok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716929677; c=relaxed/simple;
	bh=ODwXS9xcC9Axgq2Y06k4nZG5rPzhX2CVAZzIBzoT77g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LYFRKghKnvj38Yl5VDXo9DKM8wNLuLEQUeTrEl8uB2jK6TXgBOPSnAvBaQqoUv5n17LOsV5YEAhl0IG7Fo84uTZAGdNYf98LZqcg6KJgrY246XaV99Gt0ynctLqQCPXiFoimM560HTN5bITNh92duSh83MHlifI1a6STeyu20qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZO36PHs; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716929676; x=1748465676;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ODwXS9xcC9Axgq2Y06k4nZG5rPzhX2CVAZzIBzoT77g=;
  b=RZO36PHsG657vVTRbMS9AoZrQsdZHmqxo3c6HkDGO0SWeOZD/P6+Rm6K
   zJXzvRs1INPlVJPXcCPDHpd18F7a09MvKxij08P6cWYzy4dbCemKge8V7
   /sopn8IDHXJtnBkDZ8UogHmSQICBM4OBaZdwV1V9ZhG2e1v8TqIPgEJqb
   yEY7iEJQTjQL6qV2eBvFJ8ZYQZwZsEG82EPRreqi2dsHZMvCwoQpSEa5F
   blaIeUDVwXz4HkXoaTIPFxDrlY95dMRQpXbQzXhkQgkniK1s/4zCXHSvO
   fwlABCQkdV5E5t7p5xXdTv0YmXizLXSyaGnQpS50FqGPQrz5B6pj1Gzkc
   Q==;
X-CSE-ConnectionGUID: MQIHsWxISTuSKg56t9bgfQ==
X-CSE-MsgGUID: HfEPH6R7SuWnB+7PIyyQXw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30826854"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30826854"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 13:54:35 -0700
X-CSE-ConnectionGUID: j9fTEdI/Qteq4vCx+hsu6g==
X-CSE-MsgGUID: 2W91ReWiQ56PmO60q1pfxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="39715695"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 13:54:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 13:54:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 13:54:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 13:54:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 13:54:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwc3ESAaWfe96lK7+Wougn7Ijnq+VWnelVUnKfmTdbUGU/0iMewRpWpdUMiI5iiGdfwq1sf8nAtXBYWTHLD2zTpRthBSKlKe5SFKzo+Hn0U+vh1WsZJAJFcRKUYahin6teTHXY1Z0OKDX16tbFlHz26LI7OD0co8PTG/zZDyCB8aOhvpwe3Uzt9/wlar3SVB1AS5+NTeVRRMFo0+z/WlA47MzRz5FjNvAwc0zWFu1skUoyOBCCrWOt9yCL1ksfeb3s74H6p1dB/3a4sm1se9V+ydBUwrJAan7v47B6y3iERU/MkEh8sipzB3DJxzBCsUtRAquSfm6g8k/oBQX7m3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODwXS9xcC9Axgq2Y06k4nZG5rPzhX2CVAZzIBzoT77g=;
 b=joNutqYl3Z4+zPysmtjn1O5VD/hqKFEV5ZJbAb8klQ1J96XSfaejl2NPNGRvZ8Dk3pZIH374RhFzdWdXM426Zz7Imqw0B5+iEi7090tie2dU+Ctonm0KFPfhylsfPPeWk6MWxN2+kY9zl3e5A9gdj8Orm2oxOrjNjoHy/UoGKhm0N4PWEH4yPIPHs0P7Spv6uVjIzpNnl8aw5rNKKMkGEnsMBZnkSJ7mTcWcDcPO35T1PTG3I5tqdfC1i2YcF+dLga09ZypceoN8yYT7ovIr9kc4d9uiJlNUfUH7ckTZI+VLIxfj33JUp1AKb6fHBxHfrcRx0pHaY9Yc3NCvQ7Y0IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB4782.namprd11.prod.outlook.com (2603:10b6:a03:2df::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Tue, 28 May
 2024 20:54:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 20:54:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GtNbEA
Date: Tue, 28 May 2024 20:54:31 +0000
Message-ID: <36a1b5d239bdbca588625a75660406c1b5ea952a.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB4782:EE_
x-ms-office365-filtering-correlation-id: 0152f21e-dfea-4e50-4602-08dc7f585f5f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bFltRHJaOWhwVUJ2WFFuU3U2WkJ4eWdIK0JKSFZjcktqQWtVTGpQeUtkQkdz?=
 =?utf-8?B?eE1iUzR2VVZiZEZkU0s2UGlDZlRDckxBNXpCMFV0eXVCSWRmb0tWSEVLR1Zm?=
 =?utf-8?B?T2h6K050SWZmem9kZmRGWXpCZ21vTHU0VDNYMGNPSHJwbXpBQ0xIUDYybUQz?=
 =?utf-8?B?Wk5nRjdZRkE5dVdEWGprT1ZKODhsajE5SU5SMEVtdWg4OFRCNFo5b3c3UlZQ?=
 =?utf-8?B?WFNDODJ4MHB1UXRSVGtwV3ZiN3BnOEd2UXFwWlRJNjJGcU84Vlc3YWhYblMw?=
 =?utf-8?B?eFZwM0ZnaHc2V1BDWW1SL2hiVVJZa0M0ZDhQYnNoYjltQVkxa2Z6QTB6Um82?=
 =?utf-8?B?ZEtvL09mbHp5aHM5SmtWMDFlTUFkYTlUT1RrbFlRRG1QcU5ZeDhHejJ0aC9i?=
 =?utf-8?B?TjdDK082S3NsbklNZmhNMkNwVEZrQWxEdEwvL2k3OUhMZDJNL2t0R2kvTWJX?=
 =?utf-8?B?bkdBNW8wa2twSjhsOE5Md0pxclk1cXRLaWhKYkxIaDRjdDkxaTRGdzRvQktM?=
 =?utf-8?B?MDhWb0lKdkRsZjhNdEUwSm92V1VqZHRGRVh2NHdackliVTRGc0NBZjVvTjJP?=
 =?utf-8?B?WEFjQXVocytUWkpOUldXUUcyTUxjQUJaTDVOTjZqTHMwZ3JPa0hIL3JGMkZC?=
 =?utf-8?B?WjY1eTVCMXZYY1BiYWtiMmZPUWtuKzFGTW54SUlMR1A5RzJWdDJvYnN2blJF?=
 =?utf-8?B?VFp3eVpab2ZYUVVxY0sxSXdGUEFKZUlGWTMrVC8xakxDdUxYaDB0V3BLVjFT?=
 =?utf-8?B?QWIvQ1BoQjRUaTJlNGVpeFVTdVhVdEs0TWYremZ1Q2JOMEREQk4yVURacW1R?=
 =?utf-8?B?bW1vYitDWmJzZTNvMHZ4VHZNKy82eTUxdFo1anRyenh3UU9BaHBtL1dqZGlU?=
 =?utf-8?B?cTQ1NTRzN0pONlBTajh3Nk96TEJKclhRWkhOQ1pidXBPeXAwMUVYdnQxTkt5?=
 =?utf-8?B?eEswZWoyNXhadndvcG5TbTVpMGkzNlRIM0txUVRLWGtqVWRVZ3lFZmx6WldG?=
 =?utf-8?B?YlFYQU5HSlVaQVJsQTJQYkliUXQ2TXlTbHBLWVo3U3JPTnk2QTFBSXNWM2dG?=
 =?utf-8?B?Q1ZzMy9JdlBIZHB4VVlHczgxMzR2M2tEd3IvVkY3UC8xQlRLNDMzMlRQQWRN?=
 =?utf-8?B?ZFIrazJDSjc4TTdxUDBvd21ReFVDUjgxRFdnYU1sdzRCMFAyUEtNOUJLSFpl?=
 =?utf-8?B?bnJ2enhKYjVCZEFaeG1OREtzcHJKZzJMUHRreXBiZ1pDaGVUQnVvL0d6M0hv?=
 =?utf-8?B?UDN6SEJnU0xiRmNCNmVpRFhXQjMwbWFXY3BTZk9ZbHZQS1lTYi9QT1p4S0Yz?=
 =?utf-8?B?dFkvWWt5VXA2MU43Q1RIVFkzamlQRklQam95cFdsWjIvSFlmeEk3eGhQZXpC?=
 =?utf-8?B?YjF2Q1huUThaZVNQenlwYzJVNjVLSStUZ2VoT0FmMVp5U3BDcnovaXVrUno1?=
 =?utf-8?B?Zi9MOUttRUZEbERLTDdaUk1RWWZIeFNKbEtsNitQbWhvQ25IVndNSUtaZVFT?=
 =?utf-8?B?QVN1U2NTTXZXdHFHQisxQ1hsTGxsY0FUeXBERG1Qc25wYjJlN1owbnFDWlFR?=
 =?utf-8?B?YW1hZ0hUM1hOQ085OHNaeFdSRVZqSktNVE5kV2I1dGsxb1Mwc0c2ajJmYnd2?=
 =?utf-8?B?VnZpWmtOMy9kMkRoT3ZCcVRBam0renQrZlhQUnZkYTRnVDd5dmc2UXRRWHUw?=
 =?utf-8?B?TDFHTTlZbnQwVWFxUUdMYmNoakNlS3o5N3ZrclpqcXhBUS9oK2tXK29MbG5z?=
 =?utf-8?B?Mzh1WWd4S25QaXg4emp4bEQ4MHYyL1dVTFkxdVJsK3JOV2hqMkx5UEhmUm42?=
 =?utf-8?B?a2ovZlpuN0RHL1d3QUdVdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azJJdi9FbVQzQ0hmS2JERzUzTGVINDRaZ3lDMTN4MVlZTE5hbGY2RnZSV1hG?=
 =?utf-8?B?RkVZQXc4N3JsYmwrQTR3N0JrVzVBWnV6RjE5VnY0NzVDQ1FRK1VIUHpORG1O?=
 =?utf-8?B?WHUxUURodW5ObzQxbVRzcFNVSnFaVFFKSDhqd0k5TXhmeU5QcE8vWlNhajdD?=
 =?utf-8?B?aU42UE1qRW94YlgrWE9XNEphbGhEbFNkWHlNSUh5NWxPUDZjNERwZyt2bXZa?=
 =?utf-8?B?dThubFZBNU9YZytYKy9xSjVyMnVNZzkwT3YwT0pVUEtGd09GcDFnK0JqUUM1?=
 =?utf-8?B?WXNNUDljTmlHeUZEWUI2VUc0TzR5NEdtb21LdlU1TkJMSldYVU52TFZqMFFS?=
 =?utf-8?B?WndaK3I4R3YzYWVNa1V6RzF3NjdBVUd3M2s0V1d4RGJNdk9rZHE0dUxpYWor?=
 =?utf-8?B?T2ozUVFvRG5OUzM0b1RlVFlQRlJPdVhOZkwrTVloQ0YzYXFzQ2N3Skt3QU1G?=
 =?utf-8?B?bGoxVkJ0czZ1aUxJNHMxaTFYS05yRXhpb3JzRjR2QXN0ejdpcHZkNWVwZkN2?=
 =?utf-8?B?SDlQWlYralVJSzNEaTI2Sy9XTVB4NnpYd1RTR3V5R3NYSnRRTjV4U28xempj?=
 =?utf-8?B?eTF2R1NpNHBXWTQ4OXhCVmMzUzhMcFhzdkl1OFl3ZGp4aWV3K0xDWVdlYTJw?=
 =?utf-8?B?K1JRSGN1NXgrVzlISUtDSGRwWVBpY1JkZ0VwSCtqODRMM1h0dCtwaTRjN3F2?=
 =?utf-8?B?SzZ5RFFvN2lSYWtUd1ovdUlQQkVkT2s1LzJodE5uUW9rTXZjT3lOWXE1cjFq?=
 =?utf-8?B?enFQcHo1b2dmeXNId2R5cFI3bnJaeFgyeWVzRmdxYmpiQVBZRCtHRDBaQlpq?=
 =?utf-8?B?QUFHZVhnb3JLRnlaY090YUNDNmxpOTE0VXFicVpmZVNiV1JIMUl6QVpJN3Zu?=
 =?utf-8?B?U25mODNKL0ZnN25oUHZkN0hJa1BhNU90WWNtN2l5Mm01NFhVVENMdmFFNkg1?=
 =?utf-8?B?WndIWStEck93d2RFODlwYmYvOGZlR3k0RnUxWFNSRVRNSmpid2JadWNEZDhx?=
 =?utf-8?B?RCtPR0U1aVh3enM0V1JDTk83eWhrbHZhZTdCckgraFFWckNQUWExQzdFblpq?=
 =?utf-8?B?UVZncXJPK0EyN2hEN3BnRkRDYUp5NjIwS3VOTGM1c3FNNEtlNkluZDdqTGpT?=
 =?utf-8?B?M2ZnRUNKQUVzb05CSVR4Q1hRZkQzSjNDeFh4eVYxTmtxRkZORkVLSHo0OTJO?=
 =?utf-8?B?L0ZxUG1PSWlpSkJnanp6aVpUQTBHb3ZiYVM0MW1GNVVLRk04VlBhbzVlVFMv?=
 =?utf-8?B?L2R0dUtiOFJWVmVrWW42eTQvdzJHN2Yvb0xiQVoxbjd4bGdGRmNaNlNpVUsr?=
 =?utf-8?B?bVJYenZLZEJQTzZHMUJvRWx5NVpEUitEd0U4T1U0UDYyNGd1V3JxbUpyLzBE?=
 =?utf-8?B?M2tpVVlCNHZFRlN6RGJsbjNYbG05STJJS1h0QlIxaXkzemRmZUhCL2xhdWxw?=
 =?utf-8?B?dDZicHRScnU1bGdRQzFYekloQXF2UUg0dlBSNXFSNDhMaWF3NUlCWmhBMTJY?=
 =?utf-8?B?eWhjUG1aL1JjSmdJV1R0VnZhdktRYTI0U0U3azhpc1FMR293OUU1Q3lOSWZm?=
 =?utf-8?B?TjJRZ0NiUk1abGhWYlRDSWhQbkhlQ1dYdjU0cHZWQit2SUVGVk1ObGgwUmpP?=
 =?utf-8?B?MGJKSVB1TGxIMmJzTlp4VHNOZDlOWXZiZm01N1dSWDQxSVFxcmxKVFdudTM3?=
 =?utf-8?B?RG50eUFUbWs4cFdWekVCVkNTajd1d2c1d0F2eHdzQ0Y5RWR1OE4ySUg3K2lC?=
 =?utf-8?B?UXo5VjI1dFZpbXhmMENuZjFDZU1LVkFQNnkrbk4zZkEvcVRqd2EzYXhRV3Ni?=
 =?utf-8?B?dGxGYmQwOWJZMXR0UHJxQXJMRjlVY0J5Z1JKYWFVYmFYZlNmWjlhYmhLeGMr?=
 =?utf-8?B?eENKNlFWakdyRitxZmczcXZteUpZelRSQmpuSDh0Rmhham54dW9pNDQ1czZB?=
 =?utf-8?B?MlNhWTByd3IyYlEyLzNzUDNMZjhvU1puTi9vZDErbEhDVUtaeENyWHMzTGZP?=
 =?utf-8?B?OXBYaEVTeWRHNW4rRXlSQWlkUlJIRVBPZXR1anVOY2QwTzR0UWM4QWRtZGx1?=
 =?utf-8?B?bzIxTzF3RkJGZkVvbTNVU0xDUUdiUVpaVS9PTXpnd3g5cXR5RVBHK2ltWUFK?=
 =?utf-8?B?VURaZUpqK0FNMXpOUHlWanNVcFlBS1lDRG0wenJQZVNvVDhkTG9QQXlFbEdN?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9775DE2979E3414083B97AAC16DAD0C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0152f21e-dfea-4e50-4602-08dc7f585f5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 20:54:31.3283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +9nLimJeYDZS154kkkKxvEsFLX4hggD4xVTYvSQq0Un+LypGV6dgz9SpX0b33WZ5KlZoTyH2/rkk/F9YhZtQt+6C7EAGNDpraF2U6KlsYQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4782
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToK
PiArc3RhdGljIGlubGluZSBpbnQgX190ZHBfbW11X3NldF9zcHRlX2F0b21pYyhzdHJ1Y3Qga3Zt
ICprdm0sIHN0cnVjdCB0ZHBfaXRlcgo+ICppdGVyLCB1NjQgbmV3X3NwdGUpCj4gwqB7Cj4gwqDC
oMKgwqDCoMKgwqDCoHU2NCAqc3B0ZXAgPSByY3VfZGVyZWZlcmVuY2UoaXRlci0+c3B0ZXApOwo+
IMKgCj4gQEAgLTU0MiwxNSArNjcxLDQyIEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fdGRwX21tdV9z
ZXRfc3B0ZV9hdG9taWMoc3RydWN0Cj4gdGRwX2l0ZXIgKml0ZXIsIHU2NCBuZXdfc3B0ZSkKPiDC
oMKgwqDCoMKgwqDCoMKgICovCj4gwqDCoMKgwqDCoMKgwqDCoFdBUk5fT05fT05DRShpdGVyLT55
aWVsZGVkIHx8IGlzX3JlbW92ZWRfc3B0ZShpdGVyLT5vbGRfc3B0ZSkpOwo+IMKgCj4gLcKgwqDC
oMKgwqDCoMKgLyoKPiAtwqDCoMKgwqDCoMKgwqAgKiBOb3RlLCBmYXN0X3BmX2ZpeF9kaXJlY3Rf
c3B0ZSgpIGNhbiBhbHNvIG1vZGlmeSBURFAgTU1VIFNQVEVzIGFuZAo+IC3CoMKgwqDCoMKgwqDC
oCAqIGRvZXMgbm90IGhvbGQgdGhlIG1tdV9sb2NrLsKgIE9uIGZhaWx1cmUsIGkuZS4gaWYgYSBk
aWZmZXJlbnQKPiBsb2dpY2FsCj4gLcKgwqDCoMKgwqDCoMKgICogQ1BVIG1vZGlmaWVkIHRoZSBT
UFRFLCB0cnlfY21weGNoZzY0KCkgdXBkYXRlcyBpdGVyLT5vbGRfc3B0ZSB3aXRoCj4gLcKgwqDC
oMKgwqDCoMKgICogdGhlIGN1cnJlbnQgdmFsdWUsIHNvIHRoZSBjYWxsZXIgb3BlcmF0ZXMgb24g
ZnJlc2ggZGF0YSwgZS5nLiBpZiBpdAo+IC3CoMKgwqDCoMKgwqDCoCAqIHJldHJpZXMgdGRwX21t
dV9zZXRfc3B0ZV9hdG9taWMoKQo+IC3CoMKgwqDCoMKgwqDCoCAqLwo+IC3CoMKgwqDCoMKgwqDC
oGlmICghdHJ5X2NtcHhjaGc2NChzcHRlcCwgJml0ZXItPm9sZF9zcHRlLCBuZXdfc3B0ZSkpCj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUJVU1k7Cj4gK8KgwqDCoMKg
wqDCoMKgaWYgKGlzX3ByaXZhdGVfc3B0ZXAoaXRlci0+c3B0ZXApICYmICFpc19yZW1vdmVkX3Nw
dGUobmV3X3NwdGUpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoaXNfc2hhZG93X3ByZXNl
bnRfcHRlKG5ld19zcHRlKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLyoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqIFBvcHVsYXRpbmcgY2FzZS4KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIC0gc2V0X3ByaXZhdGVfc3B0ZV9wcmVzZW50KCkgaW1wbGVt
ZW50cwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICrC
oMKgIDEpIEZyZWV6ZSBTUFRFCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgKsKgwqAgMikgY2FsbCBob29rcyB0byB1cGRhdGUgcHJpdmF0ZSBwYWdlIHRh
YmxlLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICrC
oMKgIDMpIHVwZGF0ZSBTUFRFIHRvIG5ld19zcHRlCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiAtIGhhbmRsZV9jaGFuZ2VkX3NwdGUoKSBvbmx5IHVw
ZGF0ZXMgc3RhdHMuCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJldCA9IHNldF9wcml2YXRlX3NwdGVfcHJlc2VudChrdm0sIGl0ZXItPnNwdGVwLCBpdGVyLQo+
ID5nZm4sCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaXRlci0+b2xkX3NwdGUsCj4gbmV3X3NwdGUsIGl0ZXItPmxldmVsKTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyZXQpCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIHJldDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBaYXBwaW5nIGNhc2UuCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBaYXAgaXMg
b25seSBhbGxvd2VkIHdoZW4gd3JpdGUgbG9jayBpcyBoZWxkCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChXQVJOX09OX09OQ0UoIWlzX3NoYWRvd19wcmVz
ZW50X3B0ZShuZXdfc3B0ZSkpKQoKVGhpcyBpbnNpZGUgYW4gZWxzZSBibG9jayBmb3IgKGlzX3No
YWRvd19wcmVzZW50X3B0ZShuZXdfc3B0ZSkpLCBzbyBpdCB3aWxsCmFsd2F5cyBiZSB0cnVlIGlm
IGl0IGdldHMgaGVyZS4gQnV0IGl0IGNhbid0IGJlY2F1c2UgVERYIGRvZXNuJ3QgZG8gYW55IGF0
b21pYwp6YXBwaW5nLgoKV2UgY2FuIHJlbW92ZSB0aGUgY29uZGl0aW9uYWwsIGJ1dCBpbiByZWdh
cmRzIHRvIHRoZSBXQVJOLCBhbnkgcmVjb2xsZWN0aW9uIG9mCndoYXQgd2FzIG1pZ2h0IGhhdmUg
YmVlbiBnb2luZyBvbiBoZXJlIG9yaWdpbmFsbHk/Cgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUJVU1k7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KCg==

