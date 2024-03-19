Return-Path: <kvm+bounces-12146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8721887FFDE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2902848FB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296BD54FA0;
	Tue, 19 Mar 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsuUgiIG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB8F1CD09;
	Tue, 19 Mar 2024 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710859679; cv=fail; b=nAmS1FoB1eFOIJQue4PmjHaPGF0J7zukReXXWpXjNkDgRXydPwjtsMFGmZYnPlyn6jXvppgCZ3LoF2uvCS/mkT65WZOSno2c+XsNXpPkBCvj+6clm8SS3K2Y/SCCvwo11JSEYdmyUGrQudW7L9SNWc2hRhSorCtWrEMamgNtOzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710859679; c=relaxed/simple;
	bh=yRjrH50oGW1QDbcbVixxXpuMIVkzGdg515FFscxpZGk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PaGyAuvLYvdL07INeCV3suqeYLBA/k8Nk/FCwTneL70c7c6ujyDtDHfwj15nA3gwB1eUpGB1yFX0XPUPPg9p50oUdrm3lNflG2MJpWlA6I448+/Ta8sdy02jB2UUmMzIH0+lo1T1I1sejBaj2F/1O67bIa2nS5gFGSOkkKLyS+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dsuUgiIG; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710859677; x=1742395677;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yRjrH50oGW1QDbcbVixxXpuMIVkzGdg515FFscxpZGk=;
  b=dsuUgiIGTUnLrLA1YF4rpvdzaE2OlATna0I7Zs3IAANejr6687wsJffi
   TJLTr3uVbbEr6ojkW6mlNVbKXN/E5tAkAHTo2lfF0s6KMA7KBj9txZL9x
   nY3htv8ANvWTu1RJFXQSEIHRvHXaI0M8EvxVZje0EQl+mmehtYxgFdpbd
   kIPKzwemkJG3bV6hCaVZ/Imumcl9bcuPB8HoAGaF7KJfHDI6nTdV2h8h/
   E+vL+GPfXleSAfBfzDHTjJyjF8k7GX6q65MUi4U/JWwQ7tUSfgrrPGjC8
   LQLWBTvf/KkQ5U5NTcRbmCKTxFz+pa7HCNNmKOFKCgDR7vbGPjRlx0bsp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5591569"
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="5591569"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 07:47:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="18408005"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 07:47:56 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 07:47:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 07:47:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 07:47:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSLMTE3aHwcwbejQ+chfjXNTdEo7KwEy+OvO6ylxKu0nikgIYfEreAPlyb2Y3OwB2dwedVYcfZqweU1W7FZsDpfwdgBiPrfU3ItVyQ78rQDGPYcyFs8v+dOcoMZwzacllDrLQo3WfZRnOkWCsBJUv8gnwPlW1Wlar7dtQH1eiwxDB6Guwe0U/B06PvLXysUCI0v0sOcYxeqFzZNGc7F2sBn8eXZryfdLh4kNGxu7REF6CuSV3f4W+zAGDOUohznRg5dyoX4p+nsHU39B+XulERdMg8vKUa1B2w1XNKtu6Lbvm3rGDUBqsWezGEOFJKcPZn78Y6QJTiFVY4595E+1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRjrH50oGW1QDbcbVixxXpuMIVkzGdg515FFscxpZGk=;
 b=QObzynWKhUagrN7J5UiIegV+edEkd21PV4V5kF1i9laeEUhzzdjT+xu6TxSDhm1ddjenKyOnOgRWcrHhaJoxf8snatRUNQhK0m1T2KpnURUI7JZZuu9fDuugUznS5GfAI9N0hyxxZMZfsLors7jXg9azV3IMp3wDEyLuOeh2cDBAMu7MtpAWeBLRT8inIIDfqZeI3NUSW47GbK8HnSXjNmthfG3mC5A8MJVYmpvWXwJ5jedn5SQX0sbcq10HQ05dAzXvyHQ7nhsDqMFIo+SEyWnPkD3d11HPZXQcO+cdZOtzLsyirRlhSqpPiSMg71p71naOrbZ29F5NBbuWfjd0vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Tue, 19 Mar
 2024 14:47:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Tue, 19 Mar 2024
 14:47:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Topic: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
Thread-Index: AQHadnqYyiwEEDddI0GwsG68yoNoPLE/K9oA
Date: Tue, 19 Mar 2024 14:47:47 +0000
Message-ID: <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
	 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com>
	 <20240313171428.GK935089@ls.amr.corp.intel.com>
	 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
In-Reply-To: <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6680:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CoahtQoMpOTs9YRsVZsz0lHXjG80iboiXe5PjLkIAMh5A3+9w4tYRJBJ+IwK9+VLdYinkG6kXhOSOv391gbpTtx+hpw6W6Iezc424O7Gd1LmV/Lth6MwDEGnzqKJd03LpEpXDH7jsujVnaioFJ8PW5Re+PKOHosb/VSItBvyYm7S6VzJexDbMwB4SYeIEjdhbro9P2iOT2W+RgDsW7Mg2qtylgfiXgqhMSCro12kcGRNhgM0jcuQvHmD+iIqJjuh7PdGsRVvtRDG2wgwmMFO+3k0j/q5GG86ULanKr1aCf+4hKNRLi+BOEhjxhzxz/YOcczmAabCiD6dHR98mfa0w01fm1xyt/pDJPVP01R/wsmbkbvPU358HrKkWQ/Gl/qMkwJqbg3RBg9IlpgQtVa++6Mej65U3qAhV62cSRQhtqaT+V40xyWfPRWg99kKOTWzZH3LN2M04t6iRoaImaX08eNgVUdfufqVMmI74jjWD10d5YrZShVZaN9Owq/3SOQLexbvn9nUxWhThFQgI4FeFGa3INjCzeWzhXIoMoExM4OcvqhuS6+q5S1gCvWc6VbaKJjxdw0HzTxVdoV4R69F7cSvhDlLMHi73NfIv3TMt1izxoI4v9MiB9eIH1vGEo88
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MElXZ21XMjBWbS9KMVYyZnU4UjdOdHBPUTk2SldFRFNVL0ZpVGtJY1Z6UkRa?=
 =?utf-8?B?UzlvSGFZSjJCUmlqZ041RiswN0RScUFDdG15T0hzcmw4WXBYMGhCekdKeDlF?=
 =?utf-8?B?ZTFsaWVydGh0Rng0RGthaGpWQS8rbFJ1ZFFzY1A3VXptVXdqdTVZTVZOTlV2?=
 =?utf-8?B?Q1BTZGZwU0Z1dzhHeHBieHFOUTZ4ZHcwaUJYaTZkQjZsMk9KMzVaNkg3dFQw?=
 =?utf-8?B?L0Q3eVBudWJNY2NEUDNuZ2tXOFEvSVNMUFRPVXhhdW82ZUo2N0ZKdThxcVNp?=
 =?utf-8?B?UWNzdXRYRkVHODdxSWM4dzI0YjZJZ251Q3VpdlMvT01IY2VxaUhJNE9kUmNY?=
 =?utf-8?B?ZFNnWmRma0FzWFJUcXR1cUVrblBNWnhNLy9iazZ0MVk0bjAwWFZLdXhyeUxW?=
 =?utf-8?B?TDd6aWFQRHR3Y0RZd2w5bXIySWdOeXBHOFVGRnp2UzJ4R3JrSWQvZEdDYXY1?=
 =?utf-8?B?Qlg2enM2bldSZ3RrL3hseFZzWmFPNW5TN2c1aExVaE1yaVhZdzRPVFV5WEZR?=
 =?utf-8?B?TzFYYjc2aXRzN2Y0ODl3VGorbE9RdFptc283Sm4rQzM3ZEk5bXoyVzN0UUJi?=
 =?utf-8?B?QkdtZkxmTm5xTldWTnJjcXgzSHJ6b09lOVNaQjR4R0ZJYmw2Q3U4ZWYvUXRh?=
 =?utf-8?B?ZG1KN3BYZUxVZkRja052L3dPRHhjNGtMeTAxV0pRREZ3VUNpK0lFWm5CcmFB?=
 =?utf-8?B?Q2s1NDZpT3ViLzVyMWJhdEtENmNIREx5bzZuM1oyN3pRV2hJSkdsSFAvaEZR?=
 =?utf-8?B?OFNDRjhsUDZFRlJlMUM1Uy9CYzlMZ2tMak9Rdnl2Zlp2Q3ZOY2p5UGhLOUhW?=
 =?utf-8?B?N3NPWk1MNlR3ZkNidDlIbGNBTDhKRDlyejJLWHJIYm5hUEdjL2dFbXNaWEtJ?=
 =?utf-8?B?Z2J0a1RBbHFKdEFJVHJ3MTRUa2l4OEI2TmpqalpxK0xvVDFvUTc3NTZnQXJw?=
 =?utf-8?B?Lzg1bWpjTXZMbHB1dlFtbG1ZQVU0WVd0cjQyVk40N2JYQTgxdmZpeTJqSHQy?=
 =?utf-8?B?T3RRK21qeGZ4RC9sUVVuYWlxSTg0cUplRnBrcWlUL3JmcmpCSWF3K1JFcGc5?=
 =?utf-8?B?azY4Q2dLMG84NDZVelB1OHAzUEhBd0dvNFN0WkhBajBJVVYwV2JxcTNpWk9z?=
 =?utf-8?B?N1E3U2pIL1NVK1pTeXd0MTRFWHJTblZNMFlNeGE5b1VNMU1PMCs5TFZNYUxP?=
 =?utf-8?B?NVJYT0dmY0grVXphL2N2SXZyRnJCOSs4dUtVK1JXaGJvNTE4NEpHVmtCYSs3?=
 =?utf-8?B?ZmM0dUNESllaemplY2NML1piV3pIZ1RwVE1WOFdLTkJIZEhNempwUk1QVHhU?=
 =?utf-8?B?VktjcVZLSU8rbXhCelM4NjZKZG05RDU0ZHpEZ0RvQ2hGRGdyQnpjR1F0Mm9V?=
 =?utf-8?B?Ti9CWHEvNUcrMlk4YUZlMzZ5bzE5cCtmRC90YjEyZEVKa00wcndYUmhiZStC?=
 =?utf-8?B?d2FEa2lzNEt5UGExenNlK0pZRnRuTVVydjFiRjNIdGhjMU4ra083MWRQREZj?=
 =?utf-8?B?QWFYYklXUFk0SHdQRURISG5PMjRERzR2NjZLTFlaaGlueHB4MkxBVFpqTnhm?=
 =?utf-8?B?WE5id2orMCtVanRncDU1R2o5ZUxlZ0ZzQW84ZnhkOUVoa3FzbVJxMkd3OHJr?=
 =?utf-8?B?OXJKcWdFMUlJd1ZHWXVPZjlPd1BkRFJEOGVUUmFqWHlwUkJib2VvL2tLd01E?=
 =?utf-8?B?cHpBRUkwUzgyNzBSRjJ4bys1MG5iOTRrRG1UMGpRdm1KVTE3bXJPTXJUais4?=
 =?utf-8?B?Ky9ONUY0elNVLzB1TnNHVFJIdGhFdmFpc0loNmt5dW5WZjlhS3V6N3c3U3Qz?=
 =?utf-8?B?bWkrakxOemdrQ3JvMmVWamQwOHVVeGJKMm5jRGd5MitmRGNKOWdyRGV0em9M?=
 =?utf-8?B?Z3ZBQWU3QWt1Yms1OVJkeHNCa0NMaFFjVEJad2IzRHhGQkV0Y0pLSWFjS3Y4?=
 =?utf-8?B?ckJ0OW1Ca2k1a0VOdXFKdkpiNjdkV3RzK0NObjBpcm11YTNHcDlieFo5UGo4?=
 =?utf-8?B?bC9MbDNvUDdIS1k0a0plTTZGVS92UjRpdCtUNmk5WTRYMGp4UEF4MVdoQ1FC?=
 =?utf-8?B?YWt0WDZGYjJsdWVKUUhCVWh4cmFyaGVjbUtJam1samVTTDB6Wkh1dUszamN6?=
 =?utf-8?B?OUhoeGlrcFFWRmVwTUdmVXJ6aUZyREltU1BwcmgyUWdzZFJsdTZOWURkQWlq?=
 =?utf-8?Q?KJ4dR5kGE7RVI1GVfhpsY3c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E08CD01EC1D3314C91DD806945B7D72F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39bd05e-dcc4-4195-8b46-08dc48238ae3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2024 14:47:47.0425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCfKi/1ao/JgB1xBFiVyv16d9jKgSDa+kC9DOMmJTxNFRKVez9mdU7s7OsGwLM7V8XJr7ziI+mMUcn1sL3L8DhKHq2iOg71KVy6cYj2frh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTE4IGF0IDE5OjUwIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gV2VkLCAyMDI0LTAzLTEzIGF0IDEwOjE0IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90
ZToNCj4gPiA+IElNTywgYW4gZW51bSB3aWxsIGJlIGNsZWFyZXIgdGhhbiB0aGUgdHdvIGZsYWdz
Lg0KPiA+ID4gDQo+ID4gPiDCoMKgwqAgZW51bSB7DQo+ID4gPiDCoMKgIMKgwqDCoMKgIFBST0NF
U1NfUFJJVkFURV9BTkRfU0hBUkVELA0KPiA+ID4gwqDCoCDCoMKgwqDCoCBQUk9DRVNTX09OTFlf
UFJJVkFURSwNCj4gPiA+IMKgwqAgwqDCoMKgwqAgUFJPQ0VTU19PTkxZX1NIQVJFRCwNCj4gPiA+
IMKgwqAgwqB9Ow0KPiA+IA0KPiA+IFRoZSBjb2RlIHdpbGwgYmUgdWdseSBsaWtlDQo+ID4gImlm
ICg9PSBQUklWQVRFIHx8ID09IFBSSVZBVEVfQU5EX1NIQVJFRCkiIG9yDQo+ID4gImlmICg9PSBT
SEFSRUQgfHwgPT0gUFJJVkFURV9BTkRfU0hBUkVEKSINCj4gPiANCj4gPiB0d28gYm9vbGVhbiAo
b3IgdHdvIGZsYWdzKSBpcyBsZXNzIGVycm9yLXByb25lLg0KPiANCj4gWWVzIHRoZSBlbnVtIHdv
dWxkIGJlIGF3a3dhcmQgdG8gaGFuZGxlLiBCdXQgSSBhbHNvIHRob3VnaHQgdGhlIHdheQ0KPiB0
aGlzIGlzIHNwZWNpZmllZCBpbiBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSBpcyBhIGxpdHRsZSBzdHJh
bmdlLg0KPiANCj4gSXQgaXMgYW1iaWd1b3VzIHdoYXQgaXQgc2hvdWxkIG1lYW4gaWYgeW91IHNl
dDoNCj4gwqAub25seV9wcml2YXRlPXRydWU7DQo+IMKgLm9ubHlfc2hhcmVkPXRydWU7DQo+IC4u
LmFzIGhhcHBlbnMgbGF0ZXIgaW4gdGhlIHNlcmllcyAoYWx0aG91Z2ggaXQgbWF5IGJlIGEgbWlz
dGFrZSkuDQo+IA0KPiBSZWFkaW5nIHRoZSBvcmlnaW5hbCBjb252ZXJzYXRpb24sIGl0IHNlZW1z
IFNlYW4gc3VnZ2VzdGVkIHRoaXMNCj4gc3BlY2lmaWNhbGx5LiBCdXQgaXQgd2Fzbid0IGNsZWFy
IHRvIG1lIGZyb20gdGhlIGRpc2N1c3Npb24gd2hhdCB0aGUNCj4gaW50ZW50aW9uIG9mIHRoZSAi
b25seSIgc2VtYW50aWNzIHdhcy4gTGlrZSB3aHkgbm90Pw0KPiDCoGJvb2wgcHJpdmF0ZTsNCj4g
wqBib29sIHNoYXJlZDsNCg0KSSBzZWUgQmluYmluIGJyb3VnaHQgdXAgdGhpcyBwb2ludCBvbiB2
MTggYXMgd2VsbDoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS82MjIwMTY0YS1hYTFkLTQz
ZDItYjkxOC02YTZlYWFkNzY5ZmJAbGludXguaW50ZWwuY29tLyN0DQoNCmFuZCBoZWxwZnVsbHkg
ZHVnIHVwIHNvbWUgb3RoZXIgZGlzY3Vzc2lvbiB3aXRoIFNlYW4gd2hlcmUgaGUgYWdyZWVkDQp0
aGUgIl9vbmx5IiBpcyBjb25mdXNpbmcgYW5kIHByb3Bvc2VkIHRoZSB0aGUgZW51bToNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2t2bS9aVU8xR2lqdTBHa1VkRjBvQGdvb2dsZS5jb20vDQoNCkhl
IHdhbnRlZCB0aGUgZGVmYXVsdCB2YWx1ZSAoaW4gdGhlIGNhc2UgdGhlIGNhbGxlciBmb3JnZXRz
IHRvwqBzZXQNCnRoZW0pLCB0byBiZSB0byBpbmNsdWRlIGJvdGggcHJpdmF0ZSBhbmQgc2hhcmVk
LiBJIHRoaW5rIHRoZSBlbnVtIGhhcw0KdGhlIGlzc3VlcyB0aGF0IElzYWt1IG1lbnRpb25lZC4g
V2hhdCBhYm91dD8NCg0KIGJvb2wgZXhjbHVkZV9wcml2YXRlOw0KIGJvb2wgZXhjbHVkZV9zaGFy
ZWQ7DQoNCkl0IHdpbGwgYmVjb21lIG9uZXJvdXMgaWYgbW9yZSB0eXBlcyBvZiBhbGlhc2VzIGdy
b3csIGJ1dCBpdCBjbGVhcmVyDQpzZW1hbnRpY2FsbHkgYW5kIGhhcyB0aGUgc2FmZSBkZWZhdWx0
IGJlaGF2aW9yLg0K

