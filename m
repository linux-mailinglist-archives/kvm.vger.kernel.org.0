Return-Path: <kvm+bounces-3594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8D9805A0C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:36:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D18251C211B2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8AF675DA;
	Tue,  5 Dec 2023 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CiIBOjz/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57C31A2;
	Tue,  5 Dec 2023 08:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701794191; x=1733330191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vUJW0fTnE5jy+DeAWtBVTk8afsmkvtAE83nnpuVwugc=;
  b=CiIBOjz/IImgUKduNziI2r1REecGYO9F/SA4eIPK62rNXT0pqfwloh9R
   juHlz5t8jO9I8DbvfkBljliYV83dgXllS9NMSK6aZCjHaVtjMXxXXwDyT
   UqW5lGsUrmawIdieDyLswQbXeBpP0VYo2eVCjpS/4kR09jaFzBXEeQ04o
   dJLeBzCCQQHzyeJQ5xLKPFucRlNWpK7vb5wjiaDGkrVn/wlIP6ABFN1vx
   uIVr/3IiADdkCQDHZyMd3u+qjP7R4bKP/Bl8Rxmmuu+4mlhkb2xbEPaV0
   yvoEMuofuU7jWcgYfCevISE3K2LqPRS2YCqkpwGsmHViUrGL+BjyZbhlS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="374107191"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="374107191"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 08:36:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="774687077"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="774687077"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 08:36:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 08:36:30 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 08:36:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 08:36:30 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Dec 2023 08:36:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaf6aSmr76whFZ4MS0+oW1xmRbgOxMbR76MxE4SiQjmp4rOyflxUE7heGaNWR+hY0dsmfFO1pn5V05VSr5YUbeCdinloZewYiupoyZ5mYlD3yKzRaw3gjZ7SSuCs8nSZ38zad0RvpewPYtlGumpzLZ+QfD9HzqeyRrT+1sefw/bFMZb+LUCTD7sK/2DM7eGsl0EICVe0oPzfHlhN55hXLeoorirEEXjA8CobhpCQbk44266sANdooAL/Dna430t4Rc6SEwIrwFRJQK7uVV3MxQdN8Wj/QfKDEsUdVyCCmPXMzmS2UxnSE8NrX8+4K63ulXZFCPyqfBnFSmOSzVEYyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWq4cRKjGjGEj/rIU1sDw8YYJfPvtvJYttuv4695sM8=;
 b=FgQYrIPgytYnsPy204kvkJXNvib/frU9vNVp0PDXA+HMIzbj/u63uCEo+mrZXfN9w33wL21ZZYwqijyQXzQ1v+aS/CHyOqaYUPKCuxFIcTsVEZswCoN7EqWXLi2u3lPDsveYd/IOhR4a0yaGIQ/Ny1uq7SL+bMRvs72WzZ456DVpyPoe3K9FIhazAX3E+r+huIujHByICWADRsTYEeJcKDsy6UD+6De/7U0M/oj8EVJ4QeUBJzmqzsDzrIv84ausLT40ID2Q8DTTjt5TvoB8CkenaABqvk7QPEk6qhPkkHAuJNPVn3a7IHM6oNXlYncNRJlrAZJ4YuOuqneB1Ljq7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 PH8PR11MB6802.namprd11.prod.outlook.com (2603:10b6:510:1ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 16:36:27 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::f9b6:70f1:6ecb:5d45]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::f9b6:70f1:6ecb:5d45%4]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 16:36:26 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"Gao, Chao" <chao.gao@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "sagis@google.com" <sagis@google.com>, "imammedo@redhat.com"
	<imammedo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwQcZt17Ep6kgUia2q29VahHabCVBeyAgAKQEICAAeymgIAAQRWAgAASFQCAABYugIAABCEAgAAougCAAPMOgA==
Date: Tue, 5 Dec 2023 16:36:26 +0000
Message-ID: <DS7PR11MB60774E0BC0F8EFA103310D27FC85A@DS7PR11MB6077.namprd11.prod.outlook.com>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
 <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
 <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
 <9b221937-42df-4381-b79f-05fb41155f7a@intel.com>
 <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
 <1a5b18b2-3072-46d9-9d44-38589cb54e40@intel.com>
 <ZW6FRBnOwYV-UCkY@google.com>
In-Reply-To: <ZW6FRBnOwYV-UCkY@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_|PH8PR11MB6802:EE_
x-ms-office365-filtering-correlation-id: 2d0bdbba-ffb2-41ae-efd7-08dbf5b05384
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rXd6TW/yT6w4xhsaU1zPjFoUifnMiEKSyDYwLcvA84eoMVa6lhQtCzz6cMATDxBhSyabzYEZartPA7wy8ds4AEz8b1/Hj3tEnVGVJEeke0MiMWi020yAUV6NpeSDlZvEbnl02y8VhlMZoPzPRWsIswHdmM5NvlVjNfStITcpHbeOEtF5o95GfEY6TwMmfjal7m7oebOnJTIwTe4Rzw73wiv6wlaM1qXih7oyu8EcHTiUqJsP7ioQHACWK4AuU8yzHAdsDk8uz37U7kvQdcMHfmrsT29aANqkZfaJaXgVAMNvH3moyzIzkmlqzSDF8EkOsketby9mt9yJkpHemR5zxBEmc0uRHMZ02ca11S38PTjFbCgag4FlpIag4IcnoJxD1EN43GUZDXqFWZzfJ6tOJRf0OezTWj8U8TEaDAOXjwGxZN6RoVmBRxP3Hrxvj78vAVN2wF7Uea+ANMU7Okfy+SOmPfJjpet7E6syBoeQOoSynH6ZWVnilZU45cuVOoiGKiZEzFHUL+Sg9i3unShdbg1jXqSw6DYEZogRQUqxVBpcWNv80wvaoCUYBwvQXvlzjC81Q90NnbaZpnvM3O+uYIC5CQdjR7NCNk//LwzSKkVhc4TRq/dEKSsw+d+71Bvh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(39860400002)(366004)(396003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(8936002)(8676002)(4326008)(7696005)(6506007)(52536014)(71200400001)(26005)(9686003)(66946007)(110136005)(54906003)(316002)(6636002)(64756008)(66556008)(66476007)(76116006)(66446008)(478600001)(41300700001)(4744005)(38070700009)(7416002)(5660300002)(2906002)(86362001)(38100700002)(122000001)(33656002)(82960400001)(55016003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NGsMo8ijy6m7FpTF23/gXaEDlDZ8PaJhElrvXUUx6x2KipvCbFnLCk2mpA2D?=
 =?us-ascii?Q?ZYMdJe4mPmXy8HA+HT/igqcgNvPd0JYJ8wRtq+Tr5Pq0qWX2+6Ct6dbnTqB5?=
 =?us-ascii?Q?OBF3zPDqYXwDdVVQrBBja8gx/zzFeml+VdEzwYMc8if12ANAlYYrjmlGWDXs?=
 =?us-ascii?Q?7Yo440EmL1Ig4gKoh7z0Sow39s3xRIcHQuVVqzvAPs2rBS38EBjmZseI4GYB?=
 =?us-ascii?Q?lPmlQVJPnCGf9FijLLEIeEerM4epSiaSSJ29qgolUI/xGfFGXbdR1fwQrFdZ?=
 =?us-ascii?Q?yv1m7SbRYfqhMbcQ7p8sIOETrPUIOFSeIcEhl2ljbcaN3s1I+4jRw3SQDaYA?=
 =?us-ascii?Q?oneVMufeCYsE0pc4NUFjAnQQd8H+VfhMF3Ftsqutd+SH9B45Pio9ZFvy0WwG?=
 =?us-ascii?Q?oN1cmHO//cpuDaL7xqPBF71tAFlCx490LPwGgB91pi/ZgolPTXiOg2IKj9tC?=
 =?us-ascii?Q?PtQKX9rFoqAbGmabKmWm6ngyzVyWUi9I6lYVgseYSXklJFxKSVNK0x6n9cj/?=
 =?us-ascii?Q?6NiaEsUZVARJuxk9UTuExIH7qnk9zGgYa5JTlVKi8SAm5Kp7y5k3dar37wEu?=
 =?us-ascii?Q?FxFINJheeUn5lsD8g2hXhNZGN4x8kXHu/l5/qS/OvBSwVgErbB1mhOYmLdwh?=
 =?us-ascii?Q?PXg3vBnFaRxtLfqXnFOvcYcqpg+gzcWi2Z3Y4A+irFSb9GUihAHVpNab3zaO?=
 =?us-ascii?Q?nD8wLTM55nTapUbeIVNcmC6aI1uU4BKaK43gu+cVDXbNRqe/qSRliOO5YvHH?=
 =?us-ascii?Q?aF/FCVerWpMnjU31R3LsvhxI2dN6RnqEGToa7yP6Yc5FasOyuOOcmSuBR51z?=
 =?us-ascii?Q?yg757VzxOTsNNoJ/g5Cw1PxOknTLi/WKBsLyx+o0KtMZkyG4j2jghwkKp3uO?=
 =?us-ascii?Q?hsVRqDdP8/6SJUIcxEus6sPQBSPWASTYJ8lAJYqZGOnjF6ZD648f4nX5QQJ5?=
 =?us-ascii?Q?VEzsdfQ62LdYtYiTE9K1ZEMWC+U1E1wOR63yERMYF6rkVX6ESxE97ozGCBNL?=
 =?us-ascii?Q?xi/U5SdR+OUOQkrRwB3ISfSr3ZrMKnJ5X4sRVyB4jAHvGXytXnfTaVuhFfBS?=
 =?us-ascii?Q?rIL4cC5T48eEcNYEB3ku8S9FWsWwB+Xwu669LQZhVu3WWlghiXhuNaZyLk3y?=
 =?us-ascii?Q?0w/lSWM0OxDDhh3MKPjrw6W9x1Qa4ASQxKbTxR+kWYBmn/wDBgdlFTO5Z5sA?=
 =?us-ascii?Q?gadn+0arckWtJjKtDzmG2/Jm2PmRydllQ3M6ZU97xmLK3if1clSKkblu/Trj?=
 =?us-ascii?Q?3RAOlHhyBqXIP1QWGoc29I5USWJ+GEjqnIc/wY3ayel2D+90cuCkyUcvYSOO?=
 =?us-ascii?Q?cCVQfw5hJoXdndXd1N3SC9Tp48/a0P2awMBDIOHMg7QJFN2/uN168G0K9Uoe?=
 =?us-ascii?Q?8NNWFD3S3qnQI64ksltF0NCes2Hngcpp91di4/GiesGoEsz9LR7r6i3DNwRf?=
 =?us-ascii?Q?pWcIV2B6lNaf5bseRUA5SbmMn0oBNeo5M69F6eHLAtzUwW3QOXkAQf3sCE0h?=
 =?us-ascii?Q?mRX0+h0xtjHlOlO3Q8A8mRTcGr6T4TDOD6eHpTswOUfNsD9fA8orhgkBrx+O?=
 =?us-ascii?Q?lONK37R1TKwAjITw7x24XleJTWcbXkX2YcPus1o3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0bdbba-ffb2-41ae-efd7-08dbf5b05384
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 16:36:26.7149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QiK58gehfD0ljQ1fZVq/8AqwrDiH+gid+0TqBA3F3jcT1yTE195ni8NtJv6mACniho3MuZ+UJnXwYkBlInB36Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6802
X-OriginatorOrg: intel.com

>> Fine.  This doesn't need to change ... until you load TDX.  Once you
>> initialize the TDX module, no more out-of-tree VMMs for you.
>
> It's not just out-of-tree hypervisors, which IMO should be little more th=
an an
> afterthought.  The other more important issue is that being post-VMXON bl=
ocks INIT,

Does that make CPU offline a one-way process? Linux uses INIT to bring a CP=
U back
online again.

-Tony

