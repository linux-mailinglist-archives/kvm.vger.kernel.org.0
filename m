Return-Path: <kvm+bounces-4540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B6110813EB9
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 01:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CA7DB21FAB
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 00:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B8C624;
	Fri, 15 Dec 2023 00:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ll8Ohgnn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55F360
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 00:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702600336; x=1734136336;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ku7WQGklrBCEaH7tlqv6KAMnPSzyvuiFquBA+11VJAY=;
  b=Ll8OhgnnQQzod42Us9s14Uwucv3QNAB8bbYWn0dr7Lx36oSV6ib/SVGa
   Bo6xhSL3VI3PqCZiaP4YvSCUb8tIC/AHD6gUJ3BZFSuqfv0OS6KjmMj6z
   T+60BJrEu+Fd925xzFFIikDTKWEun+sY7s50ckmXkDq/MBFgPeNP5Fm8S
   MWB5FHezeNrLtYeAojepHr60MoIwVYhBUxIwFrd44/j8/7GIiAAwAmaEr
   Zpayf/s6u3JQF9zX3OJ/pw7wBqhG/HOkEMUaSmQRTNS/r4uq6cHkigQ0h
   O02TFB9LNYoNOH5kB8mg+EHjvs7Pw3iX7xB4dXTQ4iPrkIIROHWAsJ5XG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="375358735"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="375358735"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 16:32:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="1105929521"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="1105929521"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Dec 2023 16:32:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 16:32:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 16:32:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Dec 2023 16:32:14 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Dec 2023 16:32:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJluKAUJSC0tso0aFNKlTyfmj9i3bxMOJx5NYgq0S+RRoCsdTwfrKPzzZjS93tcQjumJv8IqDljtvgkkhK6uGKkYxO7Yv6m44qSXy8AyIFWS8GgXZC7wb5+xM1OAz2o+wIsW53yjWSUmsPzZ7MYuMLgDKf7aYe1X/IweaMhjDh8iARdPWrpSY0wSbC4yetFut0nwsB6JvZcEKtwxZLgKGXOb5NKgrtu8Pj80YtC2+jyeXJyTiuvsEIJSK7XaBrG2EvzaRaSiKTKwJ/lfHfMAspeT+QDP5jq5A+s3tppOP1gvFvMPT0oGjOeAZWD1w8t4BF+Oh+i6bAVDGPvpgBr3Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ku7WQGklrBCEaH7tlqv6KAMnPSzyvuiFquBA+11VJAY=;
 b=kB/KYGdws1CcttUrcGetJlWr24naPR3VsNsFvDk35hXvcf7Evw1VU5LHvh5wkToIkX+0mMvGyvpYNDYAxC+VhSywVNR5DcfGfdvMD9hM/SHWDQcxRnxf/0sOVbkr37qlghLK6A80sRgv8pNQ/Q5xHXOlu0k0HH5LE/7I1jdDPzzjESlSZbSME6HRtP6/nVhsouUyJ2E9W84GNXRj/YUpxrtLuY/gN5CvfcxJbT1M/v5MNgcbSm6Tq57ulJpUc0JQtpkv9IVAgcFg3vAQ0Wx1IMzmk4Jd6wrRrQDcWxYH99wn7EXton5kcaVhtPqnuFO0Hi+KdW0FdFOOSXsqTVfF8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31; Fri, 15 Dec
 2023 00:32:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7091.029; Fri, 15 Dec 2023
 00:32:12 +0000
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
Thread-Index: AQHaKPhWxx9HXujfsUi0tG4mXIDTXLCm0VsQgABbiACAASSPMIAAM8IAgAEE5VA=
Date: Fri, 15 Dec 2023 00:32:12 +0000
Message-ID: <BN9PR11MB5276BFAA012C5B0F02807BC58C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
 <BN9PR11MB5276C5E5AF53B2DCCD654DEF8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <310c600b-c6d7-4c17-9606-76de5ef0e41b@nvidia.com>
In-Reply-To: <310c600b-c6d7-4c17-9606-76de5ef0e41b@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5243:EE_
x-ms-office365-filtering-correlation-id: 1f4adad8-838c-4f3c-f6b0-08dbfd0547c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rtxhl85da581deZhHGNLoiKDzra/51fFeyGG10EzndUf1tYtDYVwb+uOQ22I01eAL9sKGGkbfoy9P11r8HjnMBthgZfeIEy7VwAaz7PWBgm7U1dXZfzFiGFUEZjlfoxwwDoBFQjApJithJqTwS6fIYPP3xBWL81qORMyZHF287ZBrrkJEuVLaN/QmgdZD8W8rQqhj2wOmMm96qz8po7ezhsuKpJyNvR0zN+Kf4O0ZpzY0aMoNkHk0unAu3VMAsF3F1x4LxtzLnCaLe5pWMC/wMIFF+W7Xu5ltgtllFaNLp8AtMIxKUXPk/+CGQlaxXzZToYLGI43ka/IjWArkuion3rd5PDGDC4pMk2beuNMkZ0kvIIViRKG7X6f3pOm7mEW3VPjsFSB0T8+LavROLYeVkFunOtfTs3oRfJlyqI5jXLaSBnvdNGyQ2frYbxIL7mJHAVufqisdDDKORB1z38k7lk1EtmzRmaFo3yGLj3SgKYxJpVyR7OwlR8EQD90TiDz4d2M0UMYWCzka5EJLrf2i5ZwRnsFcl512kQZC+l4eXW7WSmUx1jq9ejn1SOOGxGiNeQQylK5btOrmLJJ2d08mSLTH2BM0iYVZkvmajRTCEQ/6FypSJx3MfHQhlTFrPvL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(4326008)(8936002)(52536014)(8676002)(2906002)(7416002)(5660300002)(478600001)(6506007)(7696005)(9686003)(53546011)(110136005)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(41300700001)(38100700002)(122000001)(55016003)(33656002)(86362001)(38070700009)(82960400001)(71200400001)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vm5iWmJxVjVQV1FFRnJ2TmNuY3YxYVpOMnJPMGNsZDdkOXBnRWRyT0dJSWh2?=
 =?utf-8?B?MXhWWFpndXdpQVhWejhKdkgwUHNzZ1NLc0kyMllhbmRMRmIrMElHNlUxQzNO?=
 =?utf-8?B?WmpZYXRVZU1FcWx1TDZieDl4TzRsZXhKSVVaTSsxYUlMYzNXWFl6d3paWGJ0?=
 =?utf-8?B?QVBQNmNkRjE3QmY5L2xvMmtoWXk0M3k5YlNvTGc5U0VIT2Z2RG1IRTBzNGc2?=
 =?utf-8?B?WUEzclE3TnVqR2g4L0pObzFUcnJGZE9kajYvTkxEZ2Z4T0srdG5TdzFGOVAv?=
 =?utf-8?B?N2tqcXF1cmkyT1Q2VC9vU3hKVkZKVjV5cGVGRll2ZFBRMlE1SHhOY0ErQTFX?=
 =?utf-8?B?VG5UZHd5WHlxdnVmZFNMSGRwQ3EvN1hsTEhjTlBJRTRhNnM4QlljZFp5a2tT?=
 =?utf-8?B?bGJUQnJDRlB6TlNKM2t6QU1nMlU5YTZpTjB0UDJQQ2E3dFNmNHdZRGd5cVN6?=
 =?utf-8?B?K0ZjSzYvQ3dGWXRoRzd1c01TbVNVaHBhZmhKK3NnS3R5aVdFRXBFM0xKSmJq?=
 =?utf-8?B?WTJOWnlUV0RON1lLaStJT0NGbEV6RW9BZCtlcktoRlM0MUFHWnRXdWltSlo5?=
 =?utf-8?B?S3lWSm1WbzRLQkhrcmVCdmQ3cmZRYi9ISDRrUkY3TzJCbjhBZVh0ckoyejhr?=
 =?utf-8?B?d2Naek1LRnR5bUlEVGMySFp2L3pZaTB2MU1mYWJ4T0RFdkt6TUU2TkdFRFpw?=
 =?utf-8?B?d2kzQVBNSUdoM3BhQURDZmEyejRUMTJzS3NKaUxuUmFkemg0eU9TQlNuV21I?=
 =?utf-8?B?amFDdGMrVm9mZGhmL0YrVGllOW9aMHRNd0kvL0RwS0MweWtMWk9aUXM2Wnp0?=
 =?utf-8?B?aVozaEt1SUYyMUoyejFJV1YvdjFVdFdEaWU5UDJXNXhvUzBHRXdONGVRZWZY?=
 =?utf-8?B?ZFc1RTBrNTVGS1RyU0VVV1prRGNwazNEQkdBNDVGdHhFTitTbDA3WVYwallJ?=
 =?utf-8?B?MkEzWUJxTk9DNmRGS0JxYTA2Zk9XcDdVN2ZudXp4Q2pRQkdCZDdna3F1aSt1?=
 =?utf-8?B?bW01RUFoWjBqTTZNMEgyWXlVZ0c4YkhTbUVMYkZoOXFUWWxnTEJoMysvczdy?=
 =?utf-8?B?VVV3eVJ2TTAvYmwxU1BpS3RUdjRvcy9TaEFpQjlZK2hpbFBvN3lneXJwWjhS?=
 =?utf-8?B?Uk90SGdJNUVGcFV5RzJURGowY2RFaytwc3FraE1sK0hKWDVsaFpGb2VKYU03?=
 =?utf-8?B?eUI3VVQ4NnRrcEkvSFd0N0FjRThhamFHQjRRbDA4Q2kvNW9IMWNFam9NWHdi?=
 =?utf-8?B?Rk9WNmtOKzdTT0FhQjVhNEdsVkJFK3daZWpQeFd5RWdSVTNzQVBBSjJrQ3M2?=
 =?utf-8?B?c0xzWkQzUzRBTFhjYmJLL2NkbXp4UURxVGtvYVVZQXMvMEF3VUpCSXhONGtE?=
 =?utf-8?B?Zmo5K28wa2NPYUszQWVTTUp0eWJ6TUl4RTNKT1NDRW8yeGp0bzBWR0NOZGR6?=
 =?utf-8?B?amtYdGgvSUN4U1NaY3J2bnFXOE1qNkJEZ1puUFplc3hWQ3RyTW9Kc2VzdDNG?=
 =?utf-8?B?TFFpdDE2WXluSDhhY3REUCs5QUQyWUhLRndacVZJZU44TEp4UXJPUnhnVnMz?=
 =?utf-8?B?b3dkaytTbDRJYkVWQkl3YzZKdWFadWZtTXR5YU50Y2pzQVVZSCtHY2xIL2du?=
 =?utf-8?B?NnpkM1N5QUp4aFJ3NWkzak82bjNDSUd2TzJzRzNsR1puVWhhMGw5S1hxR0Q1?=
 =?utf-8?B?MDc3empYQVpySU5pVnJFb0RCSnlNVU1TTG1VNXVGSHVnR2h1NmhGclNOUnlu?=
 =?utf-8?B?VDJ6MEUzdHlPcDBMVnVQcXBlOUtOL0psTkRmYUdQeXkzd2NjcmJvRmhHZ2tw?=
 =?utf-8?B?MnpERUNhdWhKTVRYbUpRVnAvbnFyZER1SmtRdi9DeEN3UVNMbUJuYmI4OFdS?=
 =?utf-8?B?a0t5YTIyckw4Q3oxbWp4dHd1ZHcveWt4d2JFd043eG9DdWJHbU1nVTVUdndl?=
 =?utf-8?B?OWw3Q2haaFk0UE1DSjZYT0dKQzFiU3c2bWVjM1JiLytrc3RXNmFEYVFsWjVY?=
 =?utf-8?B?ejhMMG9LeWtLMXBWbkd0UEI5LzV6TWN6cUgzRWxrb09mbHlGNUVyTmVzMjlR?=
 =?utf-8?B?czhOZE9CTDhmZktpbkVISG1BQWZZc1drQUhMRC8vb0IxNnF5V2pNN2l2TUJa?=
 =?utf-8?Q?+wsygE5C8PZ7eXbFT0sNwtXwJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4adad8-838c-4f3c-f6b0-08dbfd0547c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 00:32:12.3203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNn1k6UYM9qPJnatnN9T/HzxumC+8CDMZ63TgvQhXkcEisaV84/1EUf2wGsoHCh2fNFkv8UY93gv7UoGrtgZig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-OriginatorOrg: intel.com

PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT4NCj4gU2VudDogVGh1cnNk
YXksIERlY2VtYmVyIDE0LCAyMDIzIDQ6NTggUE0NCj4gDQo+IE9uIDE0LzEyLzIwMjMgODowNywg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IFlpc2hhaSBIYWRhcyA8eWlzaGFpaEBudmlk
aWEuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDEzLCAyMDIzIDg6MjUgUE0N
Cj4gPj4NCj4gPj4gT24gMTMvMTIvMjAyMyAxMDoyMywgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+
Pj4gRnJvbTogWWlzaGFpIEhhZGFzIDx5aXNoYWloQG52aWRpYS5jb20+DQo+ID4+Pj4gU2VudDog
VGh1cnNkYXksIERlY2VtYmVyIDcsIDIwMjMgNjoyOCBQTQ0KPiA+Pj4+DQo+ID4+Pj4gKw0KPiA+
Pj4+ICtzdGF0aWMgc3NpemVfdCB2aXJ0aW92Zl9wY2lfcmVhZF9jb25maWcoc3RydWN0IHZmaW9f
ZGV2aWNlICpjb3JlX3ZkZXYsDQo+ID4+Pj4gKwkJCQkJY2hhciBfX3VzZXIgKmJ1Ziwgc2l6ZV90
IGNvdW50LA0KPiA+Pj4+ICsJCQkJCWxvZmZfdCAqcHBvcykNCj4gPj4+PiArew0KPiA+Pj4+ICsJ
c3RydWN0IHZpcnRpb3ZmX3BjaV9jb3JlX2RldmljZSAqdmlydHZkZXYgPSBjb250YWluZXJfb2Yo
DQo+ID4+Pj4gKwkJY29yZV92ZGV2LCBzdHJ1Y3QgdmlydGlvdmZfcGNpX2NvcmVfZGV2aWNlLCBj
b3JlX2RldmljZS52ZGV2KTsNCj4gPj4+PiArCWxvZmZfdCBwb3MgPSAqcHBvcyAmIFZGSU9fUENJ
X09GRlNFVF9NQVNLOw0KPiA+Pj4+ICsJc2l6ZV90IHJlZ2lzdGVyX29mZnNldDsNCj4gPj4+PiAr
CWxvZmZfdCBjb3B5X29mZnNldDsNCj4gPj4+PiArCXNpemVfdCBjb3B5X2NvdW50Ow0KPiA+Pj4+
ICsJX19sZTMyIHZhbDMyOw0KPiA+Pj4+ICsJX19sZTE2IHZhbDE2Ow0KPiA+Pj4+ICsJdTggdmFs
ODsNCj4gPj4+PiArCWludCByZXQ7DQo+ID4+Pj4gKw0KPiA+Pj4+ICsJcmV0ID0gdmZpb19wY2lf
Y29yZV9yZWFkKGNvcmVfdmRldiwgYnVmLCBjb3VudCwgcHBvcyk7DQo+ID4+Pj4gKwlpZiAocmV0
IDwgMCkNCj4gPj4+PiArCQlyZXR1cm4gcmV0Ow0KPiA+Pj4+ICsNCj4gPj4+PiArCWlmIChyYW5n
ZV9pbnRlcnNlY3RfcmFuZ2UocG9zLCBjb3VudCwgUENJX0RFVklDRV9JRCwgc2l6ZW9mKHZhbDE2
KSwNCj4gPj4+PiArCQkJCSAgJmNvcHlfb2Zmc2V0LCAmY29weV9jb3VudCwNCj4gPj4+PiAmcmVn
aXN0ZXJfb2Zmc2V0KSkgew0KPiA+Pj4+ICsJCXZhbDE2ID0gY3B1X3RvX2xlMTYoVklSVElPX1RS
QU5TX0lEX05FVCk7DQo+ID4+Pj4gKwkJaWYgKGNvcHlfdG9fdXNlcihidWYgKyBjb3B5X29mZnNl
dCwgKHZvaWQgKikmdmFsMTYgKw0KPiA+Pj4+IHJlZ2lzdGVyX29mZnNldCwgY29weV9jb3VudCkp
DQo+ID4+Pj4gKwkJCXJldHVybiAtRUZBVUxUOw0KPiA+Pj4+ICsJfQ0KPiA+Pj4+ICsNCj4gPj4+
PiArCWlmICgobGUxNl90b19jcHUodmlydHZkZXYtPnBjaV9jbWQpICYgUENJX0NPTU1BTkRfSU8p
ICYmDQo+ID4+Pj4gKwkgICAgcmFuZ2VfaW50ZXJzZWN0X3JhbmdlKHBvcywgY291bnQsIFBDSV9D
T01NQU5ELCBzaXplb2YodmFsMTYpLA0KPiA+Pj4+ICsJCQkJICAmY29weV9vZmZzZXQsICZjb3B5
X2NvdW50LA0KPiA+Pj4+ICZyZWdpc3Rlcl9vZmZzZXQpKSB7DQo+ID4+Pj4gKwkJaWYgKGNvcHlf
ZnJvbV91c2VyKCh2b2lkICopJnZhbDE2ICsgcmVnaXN0ZXJfb2Zmc2V0LCBidWYgKw0KPiA+Pj4+
IGNvcHlfb2Zmc2V0LA0KPiA+Pj4+ICsJCQkJICAgY29weV9jb3VudCkpDQo+ID4+Pj4gKwkJCXJl
dHVybiAtRUZBVUxUOw0KPiA+Pj4+ICsJCXZhbDE2IHw9IGNwdV90b19sZTE2KFBDSV9DT01NQU5E
X0lPKTsNCj4gPj4+PiArCQlpZiAoY29weV90b191c2VyKGJ1ZiArIGNvcHlfb2Zmc2V0LCAodm9p
ZCAqKSZ2YWwxNiArDQo+ID4+Pj4gcmVnaXN0ZXJfb2Zmc2V0LA0KPiA+Pj4+ICsJCQkJIGNvcHlf
Y291bnQpKQ0KPiA+Pj4+ICsJCQlyZXR1cm4gLUVGQVVMVDsNCj4gPj4+PiArCX0NCj4gPj4+DQo+
ID4+PiB0aGUgd3JpdGUgaGFuZGxlciBjYWxscyB2ZmlvX3BjaV9jb3JlX3dyaXRlKCkgZm9yIFBD
SV9DT01NQU5EIHNvDQo+ID4+PiB0aGUgY29yZSB2Y29uZmlnIHNob3VsZCBoYXZlIHRoZSBsYXRl
c3QgY29weSBvZiB0aGUgSU8gYml0IHZhbHVlIHdoaWNoDQo+ID4+PiBpcyBjb3BpZWQgdG8gdGhl
IHVzZXIgYnVmZmVyIGJ5IHZmaW9fcGNpX2NvcmVfcmVhZCgpLiB0aGVuIG5vdCBuZWNlc3NhcnkN
Cj4gPj4+IHRvIHVwZGF0ZSBpdCBhZ2Fpbi4NCj4gPj4NCj4gPj4gWW91IGFzc3VtZSB0aGUgdGhl
ICd2Y29uZmlnJyBtZWNoYW5pc20vZmxvdyBpcyBhbHdheXMgYXBwbGljYWJsZSBmb3INCj4gPj4g
dGhhdCBzcGVjaWZpYyBmaWVsZCwgdGhpcyBzaG91bGQgYmUgZG91YmxlLWNoZWNrZWQuDQo+ID4+
IEhvd2V2ZXIsIGFzIGZvciBub3cgdGhlIGRyaXZlciBkb2Vzbid0IHJlbHkgLyB1c2UgdGhlIHZj
b25maWcgZm9yIG90aGVyDQo+ID4+IGZpZWxkcyBhcyBpdCBkb2Vzbid0IG1hdGNoIGFuZCBuZWVk
IGEgYmlnIHJlZmFjdG9yLCBJIHByZWZlciB0byBub3QgcmVseQ0KPiA+PiBvbiBpdCBhdCBhbGwg
YW5kIGhhdmUgaXQgaGVyZS4NCj4gPg0KPiA+IGlpdWMgdGhpcyBkcml2ZXIgZG9lcyByZWxpZXMg
b24gdmNvbmZpZyBmb3Igb3RoZXIgZmllbGRzLiBJdCBmaXJzdCBjYWxscw0KPiA+IHZmaW9fcGNp
X2NvcmVfcmVhZCgpIGFuZCB0aGVuIG1vZGlmaWVzIHNlbGVjdGVkIGZpZWxkcyB3aGljaCBuZWVk
cw0KPiA+IHNwZWNpYWwgdHdlYWsgaW4gdGhpcyBkcml2ZXIuDQo+IA0KPiBObywgdGhlcmUgaXMg
bm8gZGVwZW5kZW5jeSBhdCBhbGwgb24gdmNvbmZpZyBmb3Igb3RoZXIgZmllbGRzIGluIHRoZSBk
cml2ZXIuDQo+IA0KPiB2ZmlvX3BjaV9jb3JlX3JlYWQoKSBmb3IgbW9zdCBvZiBpdHMgZmllbGRz
IGluY2x1ZGluZyB0aGUgUENJX0NPTU1BTkQNCj4gZ29lcyBkaXJlY3RseSBvdmVyIHRoZSBQQ0kg
QVBJL2Zsb3cgdG8gdGhlIGRldmljZSBhbmQgZG9lc24ndCB1c2UgdGhlDQo+IHZjb25maWcuDQo+
IA0KPiBTbywgd2UgbXVzdCBzYXZlL3Jlc3RvcmUgdGhlIFBDSV9DT01NQU5EIG9uIHRoZSBkcml2
ZXIgY29udGV4dCB0byBoYXZlDQo+IGl0IHByb3Blcmx5IHJlcG9ydGVkL2VtdWxhdGVkIHRoZSBQ
Q0lfQ09NTUFORF9JTyBiaXQuDQoNCnlvdSBhcmUgcmlnaHQuIHNvcnJ5IHRoYXQgSSBpZ25vcmVk
IHRoaXMgZmFjdC4NCg0K

