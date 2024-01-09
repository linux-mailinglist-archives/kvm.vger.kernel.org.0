Return-Path: <kvm+bounces-5892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6133828887
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33EE8B23039
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B9939FED;
	Tue,  9 Jan 2024 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gaLcvYst"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993239FD8
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704812002; x=1736348002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ggIEoSvd34uOKCyWaOxfiMcPXrsO56Kkl/K3RsbFA0=;
  b=gaLcvYstKOR7OkkhPztSfBeZuL1sBJpVHUnPnQHoseP9376BAQM3wZz+
   o68OKfyknG6enJcgkdsA1CmxKNXcEbkTtvkyvWGooB+cwPdIiblsGqltf
   iotEj8J0sfrmm6rXe274FHTscP5okbP3kGeZMc1oROa5OAL58oVCre29+
   V+lYzVeDwf0SVsYcaodq9Buip7pVIxeSFEpxkFcJ1dpvRMi6LEJO/Y6j9
   BTnowtWt6Bh3S0rB0TrrM6OAWHu9wz4K2kfkD8epkZJE2ptBV79EpeGmZ
   48G0fw9Kio9ZeW7xE7zThanrlzgYNKJ9qxdxmQI1StBN+HzPub3gVaj+K
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="4970529"
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="scan'208";a="4970529"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 06:53:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="925289217"
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="scan'208";a="925289217"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2024 06:53:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 06:53:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Jan 2024 06:53:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Jan 2024 06:53:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZw6wlOj1mTjcT0OD6QS8F2re5yhqEZoNUgGZ4NEbJ/sHJV08j0L6ZJgX9StUC51DpBomN0+Gj0vchcxwi+4EBOx9wBe67ABPDD2/InsJcrzjbJXZXPqF7pPgJ5gxS5lq9DedqIv4lP/8WgCzG0Kqo2D7C5FetgqFkjioBwKNNtNAVV3BekY2u8mG2KLx5AcsbZO+Kf2CIlj17TzKNeL6us5Y+weTZexUWw/T1tu4AiSIO4Pwx3fuStoSDZt24Lso6l12YhBW3KP7re6E+GNl1hZnfyXEthw/y3Ai6hLN3DbsdHRmbeUYYpda1YrXbwy05/VxqqsHRtCuTVpZTQGwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ggIEoSvd34uOKCyWaOxfiMcPXrsO56Kkl/K3RsbFA0=;
 b=WoEG/brzIxJny0Jz8NYoSfRc3SsLwjm6vVKsIVsPFDGMZBcm7F/huxNvvUfgIiMiyiSDcf7HhG19JMOxYD1rek/zzbihOVuO7hlxbbZosNKULG9237XSEZUgN22gFG6Nm9WLC3/7NbRbkGAR6MUFdJOnyQLrFKWP2L3+13K/lA1Bqv5HaWWOmaj8OHGc5XRZjD0L1O9HgsktDVRF0iQgq4h+DY3pX4aiRAdiPobgP/ZGszAxdQ6YLt0WsuDTbAEnG2tt1ZlBK30Q/VwCFAZCKEX7uewWGjZ9gslXYPLzSNm4ILr+VuW6LBKXxQ4SFUymLGWOCh+yCE/ElDZ6z/gI3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 LV3PR11MB8484.namprd11.prod.outlook.com (2603:10b6:408:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Tue, 9 Jan
 2024 14:53:16 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a%5]) with mapi id 15.20.7159.020; Tue, 9 Jan 2024
 14:53:16 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Richard Henderson
	<richard.henderson@linaro.org>, Peter Xu <peterx@redhat.com>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, "Cornelia
 Huck" <cohuck@redhat.com>, =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Sean
 Christopherson" <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>, Gerd
 Hoffmann <kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Qiang, Chenyi" <chenyi.qiang@intel.com>
Subject: RE: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Topic: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Index: AQHaF5O24VxNhOyFz0ifdu/xEp7Ej7Cl0dCggA2oA4CAAEbrQIAAGMwAgAAVlUCAHWBegIAAWXZA
Date: Tue, 9 Jan 2024 14:53:16 +0000
Message-ID: <DS0PR11MB637348501D03A18EE7C394C4DC6A2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
 <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
 <DS0PR11MB63737AFCA458FA78423C0BB7DC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <a0289f6d-2008-48d7-95fb-492066c38461@intel.com>
 <DS0PR11MB63730289975875A5B90D078CDC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <1bc76559-20e7-4b20-a566-9491711f7a21@intel.com>
In-Reply-To: <1bc76559-20e7-4b20-a566-9491711f7a21@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|LV3PR11MB8484:EE_
x-ms-office365-filtering-correlation-id: f94a070d-d1d2-429d-2094-08dc1122b64a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uoQzwjAstBCSx33jF+l7FUAFu83NcLjXB/EeIbtoiW/8l5s1kMU0uewqDRAjCjWRCxVPsP+KIn3T+Ms+uWgGKCigdN1c6aXr+/fQxsuruRNfGRv/FwUVHHWq5nlIAPLxbboyMI1l7pdPVXbIKIUwyy/tU6XFt4kJp7bBTHMzRAbbSk5rYafMPnjaAeGDEDTIExmyovacsJCQ2oSZftgyzHOvzskseAOZXSkkTYHepoBTNEVrx4viDEAnZR3+rZsRJpI+hglhnPLzRVLKjhCKaUBHNkAwd4ZHtGghLHlVP/0/3BAj1QYvJzeOxvkOG3V+46Ehj53qBb3LMUd3LYlYtPycF/EiXgDVkDDoQPHWjYksl+iSgr7BetSGMjqUpjZ5BXPnqr6XtDCsB7XqVqMX9luntSVJP7E91hfu90LZ/1/tRwEp9SaR76bumXIo0QeWL/WHVZ5AQG0q8jGL0dyEcbvzUCTaXVXkyBCeqKYfgJ0ud7vNSuYUPBmgusqkv0n7q932aZsqjJktIKWmSJmDmBXXOZX+ATYb8/mP6FN45WXpqGRGnSaHs33Lt4tqzD0uKfAueNz7KjYr10AVqpyLBLuawwBV++QUbCSq1wki8Knzzs+xit2DVXf81maqVo3pMb/Pt1BdbQj4PVwncVEDSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(366004)(396003)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(26005)(5660300002)(4326008)(52536014)(122000001)(38100700002)(53546011)(9686003)(7696005)(6506007)(107886003)(55016003)(82960400001)(71200400001)(478600001)(66446008)(66476007)(66946007)(66556008)(64756008)(110136005)(54906003)(316002)(76116006)(8936002)(8676002)(38070700009)(33656002)(921011)(41300700001)(86362001)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXhpV1YzeVNpdnNlTDhTcmdKRW5Wb1dNdmFyU1pWTWZYdTNBelJoT3lpcVBr?=
 =?utf-8?B?TTBrRjNJcFVKZDN2SmRKMTRNcE95eHI0M2lEaE1memRhaGU2Z2VXSGI0b0NM?=
 =?utf-8?B?ZWdESk9oc3VEeHVqRXdmL29rS1cvZmJYdTRiTGpvU1pDSkpURUZSWnphTUYy?=
 =?utf-8?B?TUMxZFM4YjFDVkVUdjQzVkdpVEhldDV5ME8raG5pRm5HSFBjNjRNT21ubXp0?=
 =?utf-8?B?cHlJVUJUVnJkQmY3dFFLQm01d3ZxQ21jWDRGQ0V2dUltQ3lRZEZVLy9ucWFh?=
 =?utf-8?B?eU1pc1J1aW82eW1PT2NES0N5U3ZTRlBRbCtZdDkySHNhSzNKd2ZiM3lQZDdO?=
 =?utf-8?B?SW92TTdPVzlzWU1wY0pwN3ZDRTFBTjhwb2o2ZW1NeGQ0SFkrUVZDd0F2Y05J?=
 =?utf-8?B?elpZa3BFOWt2ZStIL2NZaWpCZHpFWUR5Sll6SlNyQzdXSkpGUG5aMzB6WGQy?=
 =?utf-8?B?THlJVy83bmgyMVhJcWhnRFpQQjNMODdUMVA0VkpXV1hEbm1qWllrZnc1UHBS?=
 =?utf-8?B?eDM1MWhGNUczcUJiSERISitFaU1BSGJzVDkydncwNFJPSmxqWklId2laS3dh?=
 =?utf-8?B?WlpGMitpeWhNaWxxMUowc044dHV5SHdjQjFyVHBlNmZIaENVWUdXbVBYOFVP?=
 =?utf-8?B?N2tKYjR6Y3lMbmQxN0paNVVGUWpJOG95Tkp0UHlMYVFySW1acTl4YTRFRFpO?=
 =?utf-8?B?d1l4a3pWL1VKU3JpOWR0cDErNWMvSDEwVjRwSjcvWE1nSEZsekxvcDZsN1J4?=
 =?utf-8?B?a1doTlloN054cFI1dit6QTJWQUdxWjUycFJhc1hsM012RFVWZDRFelRva2M5?=
 =?utf-8?B?WHVwWEhWQ3dZN08vbUVHTXEvUzVJU3o3aGdBZXVmQzFwNGt1cUpQeHd1b3dQ?=
 =?utf-8?B?d3d3SkZnRWtMNmprdFNMY2dTRGpWR0VpOHVTN0lMOUR6ZUswS3czRUpxa1Jj?=
 =?utf-8?B?a1lnTHcvV3Q5bUxGUHgyUGo5eU1xdEdKYWFISEwxVkFZVlk5T3NHVU9obE95?=
 =?utf-8?B?QjNETldVbmtEMVJjMmd3dlZLZGlJR2w1Q2pTOXEzWjhhK0VyM05UUFJKQzZF?=
 =?utf-8?B?SmNqYmJrZ29oWjJrOGNrWkZZemo1NXZpbWlsUDVuRXNmbFo3QWNnZUtpeWJ5?=
 =?utf-8?B?OUE5Tk4vWUNsTUFUTXVHSFBGa1FaeTM1d3d2NVVmSkVCK0tCaTNWQnEyQ3pk?=
 =?utf-8?B?Z1hjcDIyU0tjVmIwek9HODhDbHpuc0o4L0VoTmxMWHF6UjFlVzV1T2hpYnZw?=
 =?utf-8?B?d1A3S09KdkF1RjZPT2RHbk1vdFNIaGZHQm5SRDhuYStINkFzVEVXZzgyL1c2?=
 =?utf-8?B?QVk5SXBlSUpsMjZRTStjUmt5MDZkSEI3YjhmeEJZM2JBbkFCRFllUDZxU0kv?=
 =?utf-8?B?Zm4zOXZVOVNrS04wYnB1d3BRSGV6WkdGZTY3V1gwdWQ3NWJ0dUVja3djaHRx?=
 =?utf-8?B?VXFCUUJsZUdldGludFRqRzIxYVdqSHVKNlZNV1NNanpwMFphS1hBbFd6c094?=
 =?utf-8?B?cy90NDd3M1kwRUh6TXhiSG9IRThFbEx2NCt3YTF4Qkx2dHdMangzRGl0S2N5?=
 =?utf-8?B?QXBZMW82cVdZT21TK3IrSDBRYzNSN0lsYUdKM3EyeUlzNFBWYmJ1SEZpT3pT?=
 =?utf-8?B?UnZnb2JreXJJZkduUjdMSXNUSFFidHNLUVBtelBJZ1RsU2NsR2VqV2FuaFFQ?=
 =?utf-8?B?TFpnVWJBQW5tNWhtT2R3YVRZT09qaW9kaVRxWVZNclZIU3hlb1B6NzFTYi94?=
 =?utf-8?B?dzRYc01nYjBuMXV6bXhWd0RtYTJyclhvT3p5ZTAvem0vU2hXQzV3bWNnNlZ4?=
 =?utf-8?B?dThPL085bytEMEN2UzdXS0ljcVBDVWlFUnNiK29neUJBeGdRaCtkRmJJSWhQ?=
 =?utf-8?B?VGNPb0tGeGdXZ2pQYkNaWUZhalpKRHhJeHJLV05KODdFakh0VlBqbnFEVlhv?=
 =?utf-8?B?bWtKSGMxREV0dEN0bUxDSGFCT1RBODR5K2JjdDV1WjJQTGoyMWI1enN2ZEpL?=
 =?utf-8?B?elMrUW8xQnVMeHVLYVpWQVNXL1RoMmEySkl1U3FrRDhsU2YybkY0dVlTRU9v?=
 =?utf-8?B?anV4RzNJUUxBNkNwT3FDTGpSK1BNV2Z2bC9pU3ZsVDB1RnhUUUduaUlEK1lp?=
 =?utf-8?Q?7ls7lMJ9zfUvGGP5KMRgyEoe6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94a070d-d1d2-429d-2094-08dc1122b64a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2024 14:53:16.4586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngeZ8jl8fScrWN+eNA0GX3KO4rjmx1XBOcqam85tjCyZBV4sh+TOn6iH4G6QSKLMVTgv6sASVarZMnecJC8mFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8484
X-OriginatorOrg: intel.com

T24gVHVlc2RheSwgSmFudWFyeSA5LCAyMDI0IDE6NDcgUE0sIExpLCBYaWFveWFvIHdyb3RlOg0K
PiBPbiAxMi8yMS8yMDIzIDk6NDcgUE0sIFdhbmcsIFdlaSBXIHdyb3RlOg0KPiA+IE9uIFRodXJz
ZGF5LCBEZWNlbWJlciAyMSwgMjAyMyA3OjU0IFBNLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4gPj4g
T24gMTIvMjEvMjAyMyA2OjM2IFBNLCBXYW5nLCBXZWkgVyB3cm90ZToNCj4gPj4+IE5vIG5lZWQg
dG8gc3BlY2lmaWNhbGx5IGNoZWNrIGZvciBLVk1fTUVNT1JZX0FUVFJJQlVURV9QUklWQVRFDQo+
IHRoZXJlLg0KPiA+Pj4gSSdtIHN1Z2dlc3RpbmcgYmVsb3c6DQo+ID4+Pg0KPiA+Pj4gZGlmZiAt
LWdpdCBhL2FjY2VsL2t2bS9rdm0tYWxsLmMgYi9hY2NlbC9rdm0va3ZtLWFsbC5jIGluZGV4DQo+
ID4+PiAyZDlhMjQ1NWRlLi42M2JhNzRiMjIxIDEwMDY0NA0KPiA+Pj4gLS0tIGEvYWNjZWwva3Zt
L2t2bS1hbGwuYw0KPiA+Pj4gKysrIGIvYWNjZWwva3ZtL2t2bS1hbGwuYw0KPiA+Pj4gQEAgLTEz
NzUsNiArMTM3NSwxMSBAQCBzdGF0aWMgaW50IGt2bV9zZXRfbWVtb3J5X2F0dHJpYnV0ZXMoaHdh
ZGRyDQo+ID4+IHN0YXJ0LCBod2FkZHIgc2l6ZSwgdWludDY0X3QgYXR0cikNCj4gPj4+ICAgICAg
ICBzdHJ1Y3Qga3ZtX21lbW9yeV9hdHRyaWJ1dGVzIGF0dHJzOw0KPiA+Pj4gICAgICAgIGludCBy
Ow0KPiA+Pj4NCj4gPj4+ICsgICAgaWYgKChhdHRyICYga3ZtX3N1cHBvcnRlZF9tZW1vcnlfYXR0
cmlidXRlcykgIT0gYXR0cikgew0KPiA+Pj4gKyAgICAgICAgZXJyb3JfcmVwb3J0KCJLVk0gZG9l
c24ndCBzdXBwb3J0IG1lbW9yeSBhdHRyICVseFxuIiwgYXR0cik7DQo+ID4+PiArICAgICAgICBy
ZXR1cm4gLUVJTlZBTDsNCj4gPj4+ICsgICAgfQ0KPiA+Pg0KPiA+PiBJbiB0aGUgY2FzZSBvZiBz
ZXR0aW5nIGEgcmFuZ2Ugb2YgbWVtb3J5IHRvIHNoYXJlZCB3aGlsZSBLVk0gZG9lc24ndA0KPiA+
PiBzdXBwb3J0IHByaXZhdGUgbWVtb3J5LiBBYm92ZSBjaGVjayBkb2Vzbid0IHdvcmsuIGFuZCBm
b2xsb3dpbmcgSU9DVEwNCj4gZmFpbHMuDQo+ID4NCj4gPiBTSEFSRUQgYXR0cmlidXRlIHVzZXMg
dGhlIHZhbHVlIDAsIHdoaWNoIGluZGljYXRlcyBpdCdzIGFsd2F5cyBzdXBwb3J0ZWQsIG5vPw0K
PiA+IEZvciB0aGUgaW1wbGVtZW50YXRpb24sIGNhbiB5b3UgZmluZCBpbiB0aGUgS1ZNIHNpZGUg
d2hlcmUgdGhlIGlvY3RsDQo+ID4gd291bGQgZ2V0IGZhaWxlZCBpbiB0aGF0IGNhc2U/DQo+IA0K
PiBJJ20gd29ycnlpbmcgYWJvdXQgdGhlIGZ1dHVyZSBjYXNlLCB0aGF0IEtWTSBzdXBwb3J0cyBv
dGhlciBtZW1vcnkgYXR0cmlidXRlDQo+IHRoYW4gc2hhcmVkL3ByaXZhdGUuIEZvciBleGFtcGxl
LCBLVk0gc3VwcG9ydHMgUldYIGJpdHMgKGJpdCAwDQo+IC0gMikgYnV0IG5vdCBzaGFyZWQvcHJp
dmF0ZSBiaXQuDQoNCldoYXQncyB0aGUgZXhhY3QgaXNzdWU/DQorI2RlZmluZSBLVk1fTUVNT1JZ
X0FUVFJJQlVURV9SRUFEICAgICAgICAgICAgICAgKDFVTEwgPDwgMikNCisjZGVmaW5lIEtWTV9N
RU1PUllfQVRUUklCVVRFX1dSSVRFICAgICAgICAgICAgICgxVUxMIDw8IDEpDQorI2RlZmluZSBL
Vk1fTUVNT1JZX0FUVFJJQlVURV9FWEUgICAgICAgICAgICAgICAgICAoMVVMTCA8PCAwKQ0KDQpU
aGV5IGFyZSBjaGVja2VkIHZpYQ0KImlmICgoYXR0ciAmIGt2bV9zdXBwb3J0ZWRfbWVtb3J5X2F0
dHJpYnV0ZXMpICE9IGF0dHIpIiBzaGFyZWQgYWJvdmUgaW4NCmt2bV9zZXRfbWVtb3J5X2F0dHJp
YnV0ZXMuDQpJbiB0aGUgY2FzZSB5b3UgZGVzY3JpYmVkLCBrdm1fc3VwcG9ydGVkX21lbW9yeV9h
dHRyaWJ1dGVzIHdpbGwgYmUgMHg3Lg0KQW55dGhpbmcgdW5leHBlY3RlZD8NCg==

