Return-Path: <kvm+bounces-4435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7D08127B9
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9A661F21ABF
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 06:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A5FCA5F;
	Thu, 14 Dec 2023 06:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Msr4B+sC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C537E4
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 22:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702534138; x=1734070138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7suAOmY3HMhyuZ7sdoLSrFYxKrQIjnIsBLgaXZvLbrQ=;
  b=Msr4B+sCTZGMM7xIRao4SOviWVu0h4KeFq62Ylz5D/BXELJcKMb0zzon
   /UJnlyq0/RDX76GfAkjkpLuzBojc7M1qB7suePUfZckAROInDoXKxTiGa
   PhEA5MOalEtHB3sJ9rNfAEmdzRNslD5E7OParblGwN6lUGrCKeNW5qHqg
   J0HYnjeNffTL06MUf3hWsgny94Li/dC6wca3S/LWZCfLmq8UYv2ASyU7h
   SlcxIXvS+Ur5iCN8oF1JDIoI/tLFGGaztry5G15Xk3K0dr5gb/FVTjHAV
   GDiPWap9zvH4mmng/dykIfcnTcIbB6f/F6Epy5mhSMQZfJrRkZG25RFDk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="375228827"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="375228827"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 22:08:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="808457940"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="808457940"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 22:08:57 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 22:08:55 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 22:08:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 22:08:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 22:07:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8Tn5E1CjxvetxDqUW/RTM7vyYoTH78iG0Pe4ELaMzLYL81oD/0d7lE7CGFDDDlCzhxAoWdHuTJsHoFy+favuWWGrPzMsRxMuKbnmu6Lsgl58+krp+vXLsZqVc7eHeHF5p/3p44yJLjnMFakfR1IO9V+Ak4GB9hYdljaz7GYDABnEk5ML1Tq3UREUukHBolbmyJcaZ3zJueq6LT+K+FuPAXzDJisGbzhZtyzgVmZ6aLpgizmjKeRELRPRlJoj+R/yOvVbz6mi6jIP+/hKER9yziM+aI//ru/SfnsRIZCNM6epjlQddiv17HKCNeBuv/xOs8ASHq5B37zCxgEmhJkWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7suAOmY3HMhyuZ7sdoLSrFYxKrQIjnIsBLgaXZvLbrQ=;
 b=R6LXjpGOSLEBV7V6L8JsNcZeKN42qwNpfkFoKIby3uaaLLYDI7zWMO7GOmNXDDXpYeyoWWHUz5pArVDQrr4DYgmAd5x+PAaTOWIkYfjKX910P5IWYRNQFFwigQahddGIOAehowCBATUUAjB5AWROziLZSVKckdb/XDjl4EvTztxeVgs8GPNCd7lbMjaGat+sH2+MlD7tmtuEABGQs44ROvOPbhTZYpFa4e1FzJQsb6jIW5UE3wVD3zp15xxr4oi2IpbvYLlTMtjV9PHQdbWzOJwOIcPIbfI33lp6wjtlAe9eS+ZydsNj2eJ6qTQWg7TxPNceR2M96A9A5m7zCp+huw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5970.namprd11.prod.outlook.com (2603:10b6:8:5d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.38; Thu, 14 Dec 2023 06:07:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7091.028; Thu, 14 Dec 2023
 06:07:55 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaKPhWxx9HXujfsUi0tG4mXIDTXLCm0VsQgABbiACAASSPMA==
Date: Thu, 14 Dec 2023 06:07:55 +0000
Message-ID: <BN9PR11MB5276C5E5AF53B2DCCD654DEF8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
In-Reply-To: <fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5970:EE_
x-ms-office365-filtering-correlation-id: 86de4f51-1326-4dc6-2a5e-08dbfc6b0356
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EATSq8+uqm+iRCl8h08Aa8NhTcFHWSubrO4X84M8RfrPn0DQ3lshTuXEDKJpj1e8oOiXUDrcQl7hAtH7sn0Ho+f6ZebOIbfhFBtL67ARMVd+tMXw43T284NYh86zk4k/hH17xEsu0Z8xu/wAynvQZlLxfuNCf281W9uLSk67V5Wdv9w43uBFj8j95BG4sFLQx5jBensANuQg0VISOzY9Nvuw1LZcb3DwRn/7KR61u5uTc8FvQlBs5ePrVr7kOANi25do4seZkBd1G7DzOE/mI9GY+houty+DX/4fzekZCwMJvZWq1Xl8b0qZz+Vkjfg0e4aJUO/CiU7tCBcwzFRjYtfn8rsqyk6PQvWp6zU6d6fOqIluS6bUlS3Lhn0F7SwiufhspMjqaq1iXm39VBeI3PCVN5EUxjO1YhYvL/6pjyJoqqOhV7WUWCX52qdhMxIbgKnxmq9r3GOFR3EBon4A4TUbOe0K2lVj0LRD7StHXOM9Ln1RaO8WXon4zJZDC6AF+CqLqjVRO6oNrqP5EPGSxpL/MbLv4SyRK7tFGNbD5lAP510+cwlx1IO78AzbWVrg17EzHiB/XM2+DxLMYjYCsai4m54hzcqw6+e1kdnJSfI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(346002)(366004)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(966005)(9686003)(71200400001)(4326008)(8676002)(8936002)(83380400001)(478600001)(52536014)(26005)(110136005)(66946007)(76116006)(64756008)(66556008)(66476007)(66446008)(54906003)(316002)(55016003)(5660300002)(6506007)(7696005)(53546011)(7416002)(122000001)(2906002)(82960400001)(41300700001)(86362001)(38100700002)(33656002)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0VJOElyWkN3RTFuZFliOTFQS2VyQXZCdEg2VHk1bklGUjF6RmtrRWVkZmt3?=
 =?utf-8?B?aVZ1TlR0L2gvR0JYODBCZER1dkFsWWpQMkNxRTdoUGtQWVdwV0Fzcy82YWVT?=
 =?utf-8?B?alIycDFVTjZHKzlpRjlUOFR5anNic1ZHd05nSWl4UUh0M0gxQW1TTU1rRWRV?=
 =?utf-8?B?dlRpenkxeHNCYjB5S29DZlNPNmdIclgvN0ljU1psZkpWZGhkcE5VL3ZWQlhi?=
 =?utf-8?B?RE4xdlJ1dElKS3pEN2NaSmpnWmh0cmZlZ3IwUnNmZ1JoYUVMMkNJWkQxdnEx?=
 =?utf-8?B?a2dnUU1ZeHR2Q2gxSENXUHV4UTc0TlZsY0preCtlTzQzNFN1YXp5aHkreXVJ?=
 =?utf-8?B?WDNVWmk2cy9ZY3l4dWo4ZkVkanBHNGZFOW1oYk1jcEw0bktQL3I1VXdTVWZ3?=
 =?utf-8?B?Q0U4aTRMOG9ObngrbDI3aFVZMVRpMXVYaUt6a2Rhc08rTFBNSzRheEtuSERl?=
 =?utf-8?B?VDNyRGFzWVBWZkFGeHZjZjcvd3diUVlpOUxVNWlMWFZzZ1Jkd3d4N0ZFUmVG?=
 =?utf-8?B?Q3UydFpXcG1QS2ZJK2dWZUo2TE9xVHVTUE90YkJqRndydnFhM3dtY1hoZmV4?=
 =?utf-8?B?dzZiWVlJQ0daSDZLczJRMndYN2xkM1RGUTNnVjdaU0pJZU42RG9mRXo3OGNQ?=
 =?utf-8?B?VVRVU1NKSTc1VXNDQXJpenNMcUxNMWZ1SHc5SVZKNVdjdFlDVUdqWUNWNjNz?=
 =?utf-8?B?MFc3Sk1BYTBrYTBmdHNLeDZjK21BZkgxZkRhTjV1ZHNFZjR6QzE0U3NUU21J?=
 =?utf-8?B?SktoTXA4RGw0MUJMUmNZTEJpbjZqbmFLS2ZvSmM5d3dmZzUxd01GL2J2dWxN?=
 =?utf-8?B?SFBFRTJMQTUxay9wRmhCY1JFc0pZTnFzaHM0Q21GZUo4ZHFiVFcwQWJWRExH?=
 =?utf-8?B?QkQvSktTSG1YOTI1anlNSVhBaDlLdzBkSVZsMFAwVXpJbHZ2YXFNemdxbE9F?=
 =?utf-8?B?UjhpanRqSXc3bC8xbUNjQ2FoVWRiR0xzemNyVXR1TWhEaDhlQUtLUU1mcFNr?=
 =?utf-8?B?TUJ1cUtON3lwSFkyL081bERUTnNNMjZEOUc5SEhZNDh5VC9aMENrVWZ5MEht?=
 =?utf-8?B?QkY0SFJtRm0zTWxJdzNWOXRzWWJSdDJjeWtPTXBxWm5uVlJtd3I3SkpmQyt4?=
 =?utf-8?B?V2hPVlBwbVNybFNVSEQ1UEZBaXFVSnpKNnhsWlVkVk5POHF1N2p6MnZCc2xD?=
 =?utf-8?B?eGZ3cnNUZ1l1ZW1zTmI0bEROUzJxOEN1TGp2aGZ1cUVNVExUOEFpTE5FRFZh?=
 =?utf-8?B?UGFTNHB6aDZiajZjYkNoK1o2dkVjQ0xOVEM2WTdiS3A3Wkdzd2xRcFRzQzNS?=
 =?utf-8?B?NFBBcEM3aEp1SGQ1Z1Y3c2NaNmx1NEQ5QXNkajhUbDYrbWlLODNpSXBGb044?=
 =?utf-8?B?TXgvbDdUMC9SSnNPUzNWOU96ODd0a0JJUmZyK3ZiSko4K3BFN21kT3Y3TGVI?=
 =?utf-8?B?dnZreEJzenI0NW1nVHJXT0VrQUo3bXBoRDBHVUVEcnhzQU1QWlRhejFBVzVH?=
 =?utf-8?B?MHg3MC9XV3ZRRG1nWklQdms3VitIUkVRb3oyNkYvOTZWZVg4cDFTWEEzdDNt?=
 =?utf-8?B?UCtUd2V3MVRkQWpkdWpyM3VCM0JYUERuamVlNkJqTlJrWEdhQXhVOEloVm5V?=
 =?utf-8?B?aXkxQWh0WjA4SDBIcjJCUVAyeWZFTzQxaUs2djRHVjNTQ3hqVWhVcEp4UlRG?=
 =?utf-8?B?L0NPNXlHMDA0UndiVmZrYWNTd1VwQy9MYmdrUXJKN1ByTldERXdQc3F6Q0ln?=
 =?utf-8?B?bGdua3U0RERkNDZ5ZTNsQlJiTi9oblhpWXhIblVnU2Jhbi9qcm1IbGxrT1Nh?=
 =?utf-8?B?UjlkZ3JXdWI5YnVneXd1cm80L2p3bkZza3NiQ3UvLzc5MHpCR1liYkdCQ2hU?=
 =?utf-8?B?YlZrcFRia1RMc2ltSnVlaW9JU0liMzBuVXZ1Y3loSyt4S2h1NjFwVi96THhN?=
 =?utf-8?B?M2VveTc4TzZuRWpyUk1hd2ZIcy9JQWtDOUNUdjgrVGw5MEVhOGJ1K2lseDR5?=
 =?utf-8?B?SDBUUUJxeDNVZmJDeEpIRTBUMzc1M2JkbWtUa0JXNXRzejFZZzhBZFUzU2ti?=
 =?utf-8?B?VTl6MktrQUVQV3JaWXV2aXo5eldkVkJvcEdvcXk4SEIwbHBTOE16aVFlOG9S?=
 =?utf-8?Q?+uCTFEqL+hbBGh4jUj/fpwPx6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86de4f51-1326-4dc6-2a5e-08dbfc6b0356
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2023 06:07:55.0689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MjatmwpqTPh2AQs8+8xMta9tGsd0gbSxq7h96dPAXPFCmARf4qQGEcMEmrLPEgf2h3FDDcQwebZfvCewBf8qag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5970
X-OriginatorOrg: intel.com

PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT4NCj4gU2VudDogV2VkbmVz
ZGF5LCBEZWNlbWJlciAxMywgMjAyMyA4OjI1IFBNDQo+IA0KPiBPbiAxMy8xMi8yMDIzIDEwOjIz
LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogWWlzaGFpIEhhZGFzIDx5aXNoYWloQG52
aWRpYS5jb20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciA3LCAyMDIzIDY6MjggUE0N
Cj4gPj4NCj4gPj4gKw0KPiA+PiArc3RhdGljIHNzaXplX3QgdmlydGlvdmZfcGNpX3JlYWRfY29u
ZmlnKHN0cnVjdCB2ZmlvX2RldmljZSAqY29yZV92ZGV2LA0KPiA+PiArCQkJCQljaGFyIF9fdXNl
ciAqYnVmLCBzaXplX3QgY291bnQsDQo+ID4+ICsJCQkJCWxvZmZfdCAqcHBvcykNCj4gPj4gK3sN
Cj4gPj4gKwlzdHJ1Y3QgdmlydGlvdmZfcGNpX2NvcmVfZGV2aWNlICp2aXJ0dmRldiA9IGNvbnRh
aW5lcl9vZigNCj4gPj4gKwkJY29yZV92ZGV2LCBzdHJ1Y3QgdmlydGlvdmZfcGNpX2NvcmVfZGV2
aWNlLCBjb3JlX2RldmljZS52ZGV2KTsNCj4gPj4gKwlsb2ZmX3QgcG9zID0gKnBwb3MgJiBWRklP
X1BDSV9PRkZTRVRfTUFTSzsNCj4gPj4gKwlzaXplX3QgcmVnaXN0ZXJfb2Zmc2V0Ow0KPiA+PiAr
CWxvZmZfdCBjb3B5X29mZnNldDsNCj4gPj4gKwlzaXplX3QgY29weV9jb3VudDsNCj4gPj4gKwlf
X2xlMzIgdmFsMzI7DQo+ID4+ICsJX19sZTE2IHZhbDE2Ow0KPiA+PiArCXU4IHZhbDg7DQo+ID4+
ICsJaW50IHJldDsNCj4gPj4gKw0KPiA+PiArCXJldCA9IHZmaW9fcGNpX2NvcmVfcmVhZChjb3Jl
X3ZkZXYsIGJ1ZiwgY291bnQsIHBwb3MpOw0KPiA+PiArCWlmIChyZXQgPCAwKQ0KPiA+PiArCQly
ZXR1cm4gcmV0Ow0KPiA+PiArDQo+ID4+ICsJaWYgKHJhbmdlX2ludGVyc2VjdF9yYW5nZShwb3Ms
IGNvdW50LCBQQ0lfREVWSUNFX0lELCBzaXplb2YodmFsMTYpLA0KPiA+PiArCQkJCSAgJmNvcHlf
b2Zmc2V0LCAmY29weV9jb3VudCwNCj4gPj4gJnJlZ2lzdGVyX29mZnNldCkpIHsNCj4gPj4gKwkJ
dmFsMTYgPSBjcHVfdG9fbGUxNihWSVJUSU9fVFJBTlNfSURfTkVUKTsNCj4gPj4gKwkJaWYgKGNv
cHlfdG9fdXNlcihidWYgKyBjb3B5X29mZnNldCwgKHZvaWQgKikmdmFsMTYgKw0KPiA+PiByZWdp
c3Rlcl9vZmZzZXQsIGNvcHlfY291bnQpKQ0KPiA+PiArCQkJcmV0dXJuIC1FRkFVTFQ7DQo+ID4+
ICsJfQ0KPiA+PiArDQo+ID4+ICsJaWYgKChsZTE2X3RvX2NwdSh2aXJ0dmRldi0+cGNpX2NtZCkg
JiBQQ0lfQ09NTUFORF9JTykgJiYNCj4gPj4gKwkgICAgcmFuZ2VfaW50ZXJzZWN0X3JhbmdlKHBv
cywgY291bnQsIFBDSV9DT01NQU5ELCBzaXplb2YodmFsMTYpLA0KPiA+PiArCQkJCSAgJmNvcHlf
b2Zmc2V0LCAmY29weV9jb3VudCwNCj4gPj4gJnJlZ2lzdGVyX29mZnNldCkpIHsNCj4gPj4gKwkJ
aWYgKGNvcHlfZnJvbV91c2VyKCh2b2lkICopJnZhbDE2ICsgcmVnaXN0ZXJfb2Zmc2V0LCBidWYg
Kw0KPiA+PiBjb3B5X29mZnNldCwNCj4gPj4gKwkJCQkgICBjb3B5X2NvdW50KSkNCj4gPj4gKwkJ
CXJldHVybiAtRUZBVUxUOw0KPiA+PiArCQl2YWwxNiB8PSBjcHVfdG9fbGUxNihQQ0lfQ09NTUFO
RF9JTyk7DQo+ID4+ICsJCWlmIChjb3B5X3RvX3VzZXIoYnVmICsgY29weV9vZmZzZXQsICh2b2lk
ICopJnZhbDE2ICsNCj4gPj4gcmVnaXN0ZXJfb2Zmc2V0LA0KPiA+PiArCQkJCSBjb3B5X2NvdW50
KSkNCj4gPj4gKwkJCXJldHVybiAtRUZBVUxUOw0KPiA+PiArCX0NCj4gPg0KPiA+IHRoZSB3cml0
ZSBoYW5kbGVyIGNhbGxzIHZmaW9fcGNpX2NvcmVfd3JpdGUoKSBmb3IgUENJX0NPTU1BTkQgc28N
Cj4gPiB0aGUgY29yZSB2Y29uZmlnIHNob3VsZCBoYXZlIHRoZSBsYXRlc3QgY29weSBvZiB0aGUg
SU8gYml0IHZhbHVlIHdoaWNoDQo+ID4gaXMgY29waWVkIHRvIHRoZSB1c2VyIGJ1ZmZlciBieSB2
ZmlvX3BjaV9jb3JlX3JlYWQoKS4gdGhlbiBub3QgbmVjZXNzYXJ5DQo+ID4gdG8gdXBkYXRlIGl0
IGFnYWluLg0KPiANCj4gWW91IGFzc3VtZSB0aGUgdGhlICd2Y29uZmlnJyBtZWNoYW5pc20vZmxv
dyBpcyBhbHdheXMgYXBwbGljYWJsZSBmb3INCj4gdGhhdCBzcGVjaWZpYyBmaWVsZCwgdGhpcyBz
aG91bGQgYmUgZG91YmxlLWNoZWNrZWQuDQo+IEhvd2V2ZXIsIGFzIGZvciBub3cgdGhlIGRyaXZl
ciBkb2Vzbid0IHJlbHkgLyB1c2UgdGhlIHZjb25maWcgZm9yIG90aGVyDQo+IGZpZWxkcyBhcyBp
dCBkb2Vzbid0IG1hdGNoIGFuZCBuZWVkIGEgYmlnIHJlZmFjdG9yLCBJIHByZWZlciB0byBub3Qg
cmVseQ0KPiBvbiBpdCBhdCBhbGwgYW5kIGhhdmUgaXQgaGVyZS4NCg0KaWl1YyB0aGlzIGRyaXZl
ciBkb2VzIHJlbGllcyBvbiB2Y29uZmlnIGZvciBvdGhlciBmaWVsZHMuIEl0IGZpcnN0IGNhbGxz
DQp2ZmlvX3BjaV9jb3JlX3JlYWQoKSBhbmQgdGhlbiBtb2RpZmllcyBzZWxlY3RlZCBmaWVsZHMg
d2hpY2ggbmVlZHMNCnNwZWNpYWwgdHdlYWsgaW4gdGhpcyBkcml2ZXIuDQoNCmJ0dyB3aGF0IHZp
cnRpby1uZXQgc3BlY2lmaWMgdHdlYWsgaXMgYXBwbGllZCB0byBQQ0lfQ09NTUFORD8gWW91DQpi
YXNpY2FsbHkgY2FjaGUgdGhlIGNtZCB2YWx1ZSBhbmQgdGhlbiBzZXQgUENJX0NPTU1BTkRfSU8g
aWYNCml0J3Mgc2V0IGluIHRoZSBjYWNoZWQgdmFsdWUuIEJ1dCB0aGlzIGlzIGFscmVhZHkgY292
ZXJlZCBieSBwY2kNCnZjb25maWcuIElmIGFueXRoaW5nIGlzIGJyb2tlbiB0aGVyZSB0aGVuIHdl
IGFscmVhZHkgaGF2ZSBhIGJpZw0KdHJvdWJsZS4NCg0KVGhlIHRyaWNrIGZvciBiYXIwIG1ha2Vz
IHNlbnNlIGFzIGl0IGRvZXNuJ3QgZXhpc3QgcGh5c2ljYWxseSB0aGVuDQp0aGUgdmNvbmZpZyBt
ZWNoYW5pc20gbWF5IG5vdCBnaXZlIHRoZSBleHBlY3RlZCByZXN1bHQuIEJ1dA0KSSBkaWRuJ3Qg
c2VlIHRoZSBzYW1lIHJhdGlvbmFsZSBmb3IgUENJX0NPTU1BTkQuDQoNCj4gPj4gKw0KPiA+PiAr
c3RhdGljIHNzaXplX3QNCj4gPj4gK3ZpcnRpb3ZmX3BjaV9jb3JlX3dyaXRlKHN0cnVjdCB2Zmlv
X2RldmljZSAqY29yZV92ZGV2LCBjb25zdCBjaGFyIF9fdXNlcg0KPiA+PiAqYnVmLA0KPiA+PiAr
CQkJc2l6ZV90IGNvdW50LCBsb2ZmX3QgKnBwb3MpDQo+ID4+ICt7DQo+ID4+ICsJc3RydWN0IHZp
cnRpb3ZmX3BjaV9jb3JlX2RldmljZSAqdmlydHZkZXYgPSBjb250YWluZXJfb2YoDQo+ID4+ICsJ
CWNvcmVfdmRldiwgc3RydWN0IHZpcnRpb3ZmX3BjaV9jb3JlX2RldmljZSwgY29yZV9kZXZpY2Uu
dmRldik7DQo+ID4+ICsJdW5zaWduZWQgaW50IGluZGV4ID0gVkZJT19QQ0lfT0ZGU0VUX1RPX0lO
REVYKCpwcG9zKTsNCj4gPj4gKwlsb2ZmX3QgcG9zID0gKnBwb3MgJiBWRklPX1BDSV9PRkZTRVRf
TUFTSzsNCj4gPj4gKw0KPiA+PiArCWlmICghY291bnQpDQo+ID4+ICsJCXJldHVybiAwOw0KPiA+
PiArDQo+ID4+ICsJaWYgKGluZGV4ID09IFZGSU9fUENJX0NPTkZJR19SRUdJT05fSU5ERVgpIHsN
Cj4gPj4gKwkJc2l6ZV90IHJlZ2lzdGVyX29mZnNldDsNCj4gPj4gKwkJbG9mZl90IGNvcHlfb2Zm
c2V0Ow0KPiA+PiArCQlzaXplX3QgY29weV9jb3VudDsNCj4gPj4gKw0KPiA+PiArCQlpZiAocmFu
Z2VfaW50ZXJzZWN0X3JhbmdlKHBvcywgY291bnQsIFBDSV9DT01NQU5ELA0KPiA+PiBzaXplb2Yo
dmlydHZkZXYtPnBjaV9jbWQpLA0KPiA+PiArCQkJCQkgICZjb3B5X29mZnNldCwgJmNvcHlfY291
bnQsDQo+ID4+ICsJCQkJCSAgJnJlZ2lzdGVyX29mZnNldCkpIHsNCj4gPj4gKwkJCWlmIChjb3B5
X2Zyb21fdXNlcigodm9pZCAqKSZ2aXJ0dmRldi0+cGNpX2NtZCArDQo+ID4+IHJlZ2lzdGVyX29m
ZnNldCwNCj4gPj4gKwkJCQkJICAgYnVmICsgY29weV9vZmZzZXQsDQo+ID4+ICsJCQkJCSAgIGNv
cHlfY291bnQpKQ0KPiA+PiArCQkJCXJldHVybiAtRUZBVUxUOw0KPiA+PiArCQl9DQo+ID4+ICsN
Cj4gPj4gKwkJaWYgKHJhbmdlX2ludGVyc2VjdF9yYW5nZShwb3MsIGNvdW50LCBQQ0lfQkFTRV9B
RERSRVNTXzAsDQo+ID4+ICsJCQkJCSAgc2l6ZW9mKHZpcnR2ZGV2LT5wY2lfYmFzZV9hZGRyXzAp
LA0KPiA+PiArCQkJCQkgICZjb3B5X29mZnNldCwgJmNvcHlfY291bnQsDQo+ID4+ICsJCQkJCSAg
JnJlZ2lzdGVyX29mZnNldCkpIHsNCj4gPj4gKwkJCWlmIChjb3B5X2Zyb21fdXNlcigodm9pZCAq
KSZ2aXJ0dmRldi0NCj4gPj4+IHBjaV9iYXNlX2FkZHJfMCArIHJlZ2lzdGVyX29mZnNldCwNCj4g
Pj4gKwkJCQkJICAgYnVmICsgY29weV9vZmZzZXQsDQo+ID4+ICsJCQkJCSAgIGNvcHlfY291bnQp
KQ0KPiA+PiArCQkJCXJldHVybiAtRUZBVUxUOw0KPiA+PiArCQl9DQo+ID4+ICsJfQ0KPiA+DQo+
ID4gd3JhcCBhYm92ZSBpbnRvIHZpcnRpb3ZmX3BjaV93cml0ZV9jb25maWcoKSB0byBiZSBzeW1t
ZXRyaWMgd2l0aA0KPiA+IHRoZSByZWFkIHBhdGguDQo+IA0KPiBVcG9uIHRoZSByZWFkIHBhdGgs
IHdlIGRvIHRoZSBmdWxsIGZsb3cgYW5kIHJldHVybiB0byB0aGUgdXNlci4gSGVyZSB3ZQ0KPiBq
dXN0IHNhdmUgc29tZSBkYXRhIGFuZCBjb250aW51ZSB0byBjYWxsIHRoZSBjb3JlLCBzbyBJJ20g
bm90IHN1cmUgdGhhdA0KPiB0aGlzIHdvcnRoIGEgZGVkaWNhdGVkIGZ1bmN0aW9uLg0KDQpJIGRv
bid0IHNlZSBhIHJlYWwgZGlmZmVyZW5jZS4NCg0KZm9yIHRoZSByZWFkIHBhdGggeW91IGZpcnN0
IGNhbGwgdmZpb19wY2lfY29yZV9yZWFkKCkgdGhlbiBtb2RpZmllcyBzb21lDQpmaWVsZHMuDQoN
CmZvciB0aGUgd3JpdGUgcGF0aCB5b3Ugc2F2ZSBzb21lIGRhdGEgdGhlbiBjYWxsIHZmaW9fcGNp
X2NvcmVfd3JpdGUoKS4NCg0KPiANCj4gSG93ZXZlciwgdGhpcyBjYW4gYmUgZG9uZSwgZG8geW91
IHN0aWxsIHN1Z2dlc3QgaXQgZm9yIFY4ID8NCg0KeWVzDQoNCj4gPj4gK3N0YXRpYyBpbnQgdmly
dGlvdmZfcGNpX2luaXRfZGV2aWNlKHN0cnVjdCB2ZmlvX2RldmljZSAqY29yZV92ZGV2KQ0KPiA+
PiArew0KPiA+PiArCXN0cnVjdCB2aXJ0aW92Zl9wY2lfY29yZV9kZXZpY2UgKnZpcnR2ZGV2ID0g
Y29udGFpbmVyX29mKA0KPiA+PiArCQljb3JlX3ZkZXYsIHN0cnVjdCB2aXJ0aW92Zl9wY2lfY29y
ZV9kZXZpY2UsIGNvcmVfZGV2aWNlLnZkZXYpOw0KPiA+PiArCXN0cnVjdCBwY2lfZGV2ICpwZGV2
Ow0KPiA+PiArCWludCByZXQ7DQo+ID4+ICsNCj4gPj4gKwlyZXQgPSB2ZmlvX3BjaV9jb3JlX2lu
aXRfZGV2KGNvcmVfdmRldik7DQo+ID4+ICsJaWYgKHJldCkNCj4gPj4gKwkJcmV0dXJuIHJldDsN
Cj4gPj4gKw0KPiA+PiArCXBkZXYgPSB2aXJ0dmRldi0+Y29yZV9kZXZpY2UucGRldjsNCj4gPj4g
KwlyZXQgPSB2aXJ0aW92Zl9yZWFkX25vdGlmeV9pbmZvKHZpcnR2ZGV2KTsNCj4gPj4gKwlpZiAo
cmV0KQ0KPiA+PiArCQlyZXR1cm4gcmV0Ow0KPiA+PiArDQo+ID4+ICsJLyogQmVpbmcgcmVhZHkg
d2l0aCBhIGJ1ZmZlciB0aGF0IHN1cHBvcnRzIE1TSVggKi8NCj4gPj4gKwl2aXJ0dmRldi0+YmFy
MF92aXJ0dWFsX2J1Zl9zaXplID0gVklSVElPX1BDSV9DT05GSUdfT0ZGKHRydWUpICsNCj4gPj4g
KwkJCQl2aXJ0aW92Zl9nZXRfZGV2aWNlX2NvbmZpZ19zaXplKHBkZXYtDQo+ID4+PiBkZXZpY2Up
Ow0KPiA+DQo+ID4gd2hpY2ggY29kZSBpcyByZWxldmFudCB0byBNU0lYPw0KPiANCj4gVGhlIGJ1
ZmZlciBzaXplIG11c3QgaW5jbHVkZSB0aGUgTVNJWCBwYXJ0IHRvIG1hdGNoIHRoZSB2aXJ0aW8t
bmV0DQo+IHNwZWNpZmljYXRpb24uDQo+IA0KPiBBcyBwYXJ0IG9mIHZpcnRpb3ZmX2lzc3VlX2xl
Z2FjeV9yd19jbWQoKSB3ZSBtYXkgdXNlIHRoZSBmdWxsIGJ1ZmZlcg0KPiB1cG9uIHJlYWQvd3Jp
dGUuDQoNCmF0IGxlYXN0IG1lbnRpb24gdGhhdCBNU0lYIGlzIGluIHRoZSBkZXZpY2UgY29uZmln
IHJlZ2lvbiBvdGhlcndpc2UNCml0J3Mgbm90IGhlbHBmdWwgdG8gcGVvcGxlIHcvbyB2aXJ0aW8g
YmFja2dyb3VuZC4NCg0KPiA+PiArDQo+ID4+ICtzdGF0aWMgY29uc3Qgc3RydWN0IHZmaW9fZGV2
aWNlX29wcyB2aXJ0aW92Zl92ZmlvX3BjaV9vcHMgPSB7DQo+ID4+ICsJLm5hbWUgPSAidmlydGlv
LXZmaW8tcGNpIiwNCj4gPj4gKwkuaW5pdCA9IHZmaW9fcGNpX2NvcmVfaW5pdF9kZXYsDQo+ID4+
ICsJLnJlbGVhc2UgPSB2ZmlvX3BjaV9jb3JlX3JlbGVhc2VfZGV2LA0KPiA+PiArCS5vcGVuX2Rl
dmljZSA9IHZpcnRpb3ZmX3BjaV9vcGVuX2RldmljZSwNCj4gPg0KPiA+IGNvdWxkIGJlIHZmaW9f
cGNpX2NvcmVfb3Blbl9kZXZpY2UoKS4gR2l2ZW4gdmlydGlvdmYgc3BlY2lmaWMgaW5pdCBmdW5j
DQo+ID4gaXMgbm90IGNhbGxlZCAgdmlydGlvdmZfcGNpX29wZW5fZGV2aWNlKCkgaXMgZXNzZW50
aWFsbHkgc2FtZSBhcyB0aGUNCj4gPiBjb3JlIGZ1bmMuDQo+IA0KPiBXZSBkb24ndCBoYXZlIHRv
ZGF5IHZmaW9fcGNpX2NvcmVfb3Blbl9kZXZpY2UoKSBhcyBhbiBleHBvcnRlZCBmdW5jdGlvbi4N
Cj4gDQo+IFRoZSB2aXJ0aW92Zl9wY2lfb3Blbl9kZXZpY2UoKSBtYXRjaGVzIGJvdGggY2FzZXMg
c28gSSBkb24ndCBzZWUgYSByZWFsDQo+IHJlYXNvbiB0byBleHBvcnQgaXQgbm93Lg0KPiANCj4g
QnkgdGhlIHdheSwgaXQgZm9sbG93cyBvdGhlciBkcml2ZXJzIGluIHZmaW8sIHNlZSBmb3IgZXhh
bXBsZSBoZXJlIFsxXS4NCj4gDQo+IFsxXQ0KPiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9s
aW51eC92Ni43LQ0KPiByYzUvc291cmNlL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL2hpc2lf
YWNjX3ZmaW9fcGNpLmMjTDEzODMNCg0KYWgsIHllcy4NCg0KPiA+PiArDQo+ID4+ICtzdGF0aWMg
aW50IHZpcnRpb3ZmX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwNCj4gPj4gKwkJCSAg
ICAgIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCj4gPj4gK3sNCj4gPj4gKwljb25z
dCBzdHJ1Y3QgdmZpb19kZXZpY2Vfb3BzICpvcHMgPSAmdmlydGlvdmZfdmZpb19wY2lfb3BzOw0K
PiA+PiArCXN0cnVjdCB2aXJ0aW92Zl9wY2lfY29yZV9kZXZpY2UgKnZpcnR2ZGV2Ow0KPiA+PiAr
CWludCByZXQ7DQo+ID4+ICsNCj4gPj4gKwlpZiAocGRldi0+aXNfdmlydGZuICYmIHZpcnRpb19w
Y2lfYWRtaW5faGFzX2xlZ2FjeV9pbyhwZGV2KSAmJg0KPiA+PiArCSAgICAhdmlydGlvdmZfYmFy
MF9leGlzdHMocGRldikpDQo+ID4+ICsJCW9wcyA9ICZ2aXJ0aW92Zl92ZmlvX3BjaV90cmFuX29w
czsNCj4gPg0KPiA+IEkgaGF2ZSBhIGNvbmZ1c2lvbiBoZXJlLg0KPiA+DQo+ID4gd2h5IGRvIHdl
IHdhbnQgdG8gYWxsb3cgdGhpcyBkcml2ZXIgYmluZGluZyB0byBub24tbWF0Y2hpbmcgVkYgb3IN
Cj4gPiBldmVuIFBGPw0KPiANCj4gVGhlIGludGVudGlvbiBpcyB0byBhbGxvdyB0aGUgYmluZGlu
ZyBvZiBhbnkgdmlydGlvLW5ldCBkZXZpY2UgKGkuZS4gUEYsDQo+IFZGIHdoaWNoIGlzIG5vdCB0
cmFuc2l0aW9uYWwgY2FwYWJsZSkgdG8gaGF2ZSBhIHNpbmdsZSBkcml2ZXIgb3ZlciBWRklPDQo+
IGZvciBhbGwgdmlydGlvLW5ldCBkZXZpY2VzLg0KPiANCj4gVGhpcyBlbmFibGVzIGFueSB1c2Vy
IHNwYWNlIGFwcGxpY2F0aW9uIHRvIGJpbmQgYW5kIHVzZSBhbnkgdmlydGlvLW5ldA0KPiBkZXZp
Y2Ugd2l0aG91dCB0aGUgbmVlZCB0byBjYXJlLg0KPiANCj4gSW4gY2FzZSB0aGUgZGV2aWNlIGlz
IG5vdCB0cmFuc2l0aW9uYWwgY2FwYWJsZSwgaXQgd2lsbCBzaW1wbHkgdXNlIHRoZQ0KPiBnZW5l
cmljIHZmaW8gZnVuY3Rpb25hbGl0eS4NCg0KSXMgaXQgdXNlZnVsIHRvIHByaW50IGEgbWVzc2Fn
ZSBoZXJlPw0KDQo+IA0KPiA+DQo+ID4gaWYgdGhhdCBpcyB0aGUgaW50ZW50aW9uIHRoZW4gdGhl
IG5hbWluZy9kZXNjcmlwdGlvbiBzaG91bGQgYmUgYWRqdXN0ZWQNCj4gPiB0byBub3Qgc3BlY2lm
aWMgdG8gdmYgdGhyb3VnaG91dCB0aGlzIHBhdGNoLg0KPiA+DQo+ID4gZS5nLiBkb24ndCB1c2Ug
InZpcnRpb3ZmXyIgcHJlZml4Li4uDQo+IA0KPiBUaGUgbWFpbiBmdW5jdGlvbmFsaXR5IGlzIHRv
IHN1cHBseSB0aGUgdHJhbnNpdGlvbmFsIGRldmljZSB0byB1c2VyDQo+IHNwYWNlIGZvciB0aGUg
VkYsIGhlbmNlIHRoZSBwcmVmaXggYW5kIHRoZSBkZXNjcmlwdGlvbiBmb3IgdGhhdCBkcml2ZXIN
Cj4gcmVmZXJzIHRvIFZGLg0KPiANCj4gTGV0J3Mgc3RheSB3aXRoIHRoYXQuDQoNCm9rDQoNCj4g
DQo+ID4NCj4gPiB0aGUgY29uZmlnIG9wdGlvbiBpcyBnZW5lcmljOg0KPiA+DQo+ID4gK2NvbmZp
ZyBWSVJUSU9fVkZJT19QQ0kNCj4gPiArICAgICAgICB0cmlzdGF0ZSAiVkZJTyBzdXBwb3J0IGZv
ciBWSVJUSU8gTkVUIFBDSSBkZXZpY2VzIg0KPiA+DQo+ID4gYnV0IHRoZSBkZXNjcmlwdGlvbiBp
cyBzcGVjaWZpYyB0byB2ZjoNCj4gPg0KPiA+ICsgICAgICAgICAgVGhpcyBwcm92aWRlcyBzdXBw
b3J0IGZvciBleHBvc2luZyBWSVJUSU8gTkVUIFZGIGRldmljZXMgd2hpY2gNCj4gc3VwcG9ydA0K
PiA+ICsgICAgICAgICAgbGVnYWN5IElPIGFjY2VzcywgdXNpbmcgdGhlIFZGSU8gZnJhbWV3b3Jr
IHRoYXQgY2FuIHdvcmsgd2l0aCBhDQo+IGxlZ2FjeQ0KPiA+ICsgICAgICAgICAgdmlydGlvIGRy
aXZlciBpbiB0aGUgZ3Vlc3QuDQo+ID4NCj4gPiB0aGVuIHRoZSBtb2R1bGUgZGVzY3JpcHRpb24g
aXMgZ2VuZXJpYyBhZ2FpbjoNCj4gPg0KPiA+ICtNT0RVTEVfREVTQ1JJUFRJT04oDQo+ID4gKwki
VklSVElPIFZGSU8gUENJIC0gVXNlciBMZXZlbCBtZXRhLWRyaXZlciBmb3IgVklSVElPIE5FVCBk
ZXZpY2VzIik7DQo+ID4NCj4gDQo+IFllcywgYXMgdGhlIGJpbmRpbmcgYWxsb3dzIHRoYXQsIGl0
IGxvb2tzIGZpbmUgdG8gbWUuDQo+IA0KDQp3aGF0IGFib3V0IHJldmlzaW5nIHRoZSBrY29uZmln
IG1lc3NhZ2UgdG8gbWFrZSBpdCBjbGVhciB0aGF0IGl0J3MNCmZvciBhbGwgdmlydGlvLW5ldCBk
ZXZpY2Ugd2l0aCBzcGVjaWFsIHRyaWNrIHRvIG1ha2UgVkYgYXMgYQ0KdHJhbnNpdGlvbmFsIGRl
dmljZT8NCg==

