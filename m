Return-Path: <kvm+bounces-151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C25527DC67A
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 07:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 641F5B20D2D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 06:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EF1107BB;
	Tue, 31 Oct 2023 06:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtSEktns"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF3C10797
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 06:23:46 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CCE12C;
	Mon, 30 Oct 2023 23:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698732829; x=1730268829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1YdVFaBNCLOg7z/sNMr9eLyIR3cKsz3D5fmtFEjB0Dk=;
  b=jtSEktnstFj/N5cy8/w0ozk6al5SSdx5na8Q/hkuzxbLw0AbJxaPGezV
   J79iOyd9gm4lLvelIK6sHqwYSrFyTlZCa8GRBiHAPSsL1we8vZssz0LIg
   K/o5Ryw8Zz3ixk2xG3lzYSoAOWgoARzGBR/HMeXRcB7eq5csID/f63LEi
   448Awtccts94y0STFvBjrrYotfGsVYiF1hAX8rB7/3SzOwtHX60o6a8OT
   l3scOY2PCDusu8/qpkWQyt7sbfPz3sLekm8AynTYzqU84ZIt7oSkt73g3
   J6ifGtmSuAzvvCVJr05kWk5L47UdOcdmo73Y3ia2HYYDPxQ6C6X+b2xZq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="388043974"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="388043974"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 23:13:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="736977445"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="736977445"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 23:13:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 23:13:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 23:13:48 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 23:13:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiHrCzJmjk3Llb3EHrw4f2EamQzxrTB/4zfBqwr2/lJw0SMAkx7IuoA9Ir57+i5IBy2xP/dtCj1LaGjCzNnwVpXDafmI5OR81a9Ns2ZTuyhmph7tUGXyiEU01XjIWv2agvzpnSLrGOokGmf/qVFv+ylFOxlP12DbWI+fFX2O7SHyiAUxAkeB07WGTWI7NRt9ld/mf21uA2oESgIkGrE9KtuZdOGhdsXRWec4gqCUhBUV5OpPaziyBOtKuZc1RgAim9K5y+2AYYs5gHsNZAYCG4TPgSIhcyH8aoCiBuRqnDKnCUXgAhyNm0CvVdgR1gD36qkIIi8+YA3peevcA6SLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Llz+UNdC6h0FlWDu64k2l+uiwtUZsIk+/9SjA9idfHI=;
 b=FmEMDzGxyXT0Ri3m971EtQmSnJFMJEFdiTlh6feu4f6KJ8NLqvHfXvkiqGVsttGaT8/xskC3AKb+Zu1rQHBj3X37ZPV2T59ck5SLZKWVZLwpllT/mmM/JFNlxTjQbz7ez3ed/NQA21+J2U8glTNduKOHBBeYimcYg3cI7aNSiVQPpzjVzD/a+ud/b8wUf8ymRiwjAHbdBeEK9mKBOnyqYaMGSf0VeT+px5J5P2g6cT6NVSrQHX5MTQoYAdAX4rIAlgmjfvLKkG5Xn/qegVLsNgGWP8raNx9F+BuiXmr80jENbLVUYVXKTQAgvWhHGHk64ushxMRPKt8sSAt8yeU9tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5518.namprd11.prod.outlook.com (2603:10b6:5:39a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Tue, 31 Oct
 2023 06:13:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6933.028; Tue, 31 Oct 2023
 06:13:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v3 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Thread-Topic: [PATCH v3 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Thread-Index: AQHaCSYnHeJgmCqOXkOJcdKxD8TuVrBjcCDQ
Date: Tue, 31 Oct 2023 06:13:44 +0000
Message-ID: <BN9PR11MB52761611F89F3AF731234E2D8CA0A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231027223651.36047-1-brett.creeley@amd.com>
 <20231027223651.36047-2-brett.creeley@amd.com>
In-Reply-To: <20231027223651.36047-2-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5518:EE_
x-ms-office365-filtering-correlation-id: f3be034b-c50d-4166-a077-08dbd9d889ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LEJ1P/NjWsG/MvIBdh+WIrpv7VodnZgXkEcRLukYp2VAyyeARCJOorjGqZflLUbtc4c8dEqphxoqwsCRaovkTLoQYSC1w/0IK2eZuAiGdujQrVN0ASzFtdrkR5h+1opOATH1HqioWL00P8il8RwqwpnON8BnKQ7fjkhA6bDtrxicZDjO5U6TDG2MSKOsTnANiq0EGbnK+pGbtaFjqwD+oDqxBNJiYEtWoKLb3/LmPZiUvh2aMQ/s5QUqi14JuBqX+ZNh7Lhv/uJvnjn1hILe4YmUDasuNUftZ7nD31g6yyVwDtKJP5GEFYhV6IQG/MCR1fOMNMrDQ/Sb5pniyBI+lgbJJqWglVy96gph2tviGq+0n7UMxi3x6usv68xPfs8ckXk/PKHFgcizPIkmGVvHNxnWYoUz3UpXZTljM6XkBbUZKNCrmqf0Q1f8B+UeayI3dWx2/KfaNT2pgIlsjpWqX57aZnizESKDXnq0ISnJ1VJm69uBbIjCBQUZ7Dr/BLwnm4iB25IjcfjU/+luDkXpD37hc/reWcHLVPzgUgweFLhqZoCJLGcQz4rv81jduMHmnH4eNSvhHVUA2Ktkqar32t8Onqk7G5uq/NrjiQH5iufHZJ0WhPcMfDTR7OLG/IXA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(396003)(136003)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(55016003)(26005)(9686003)(71200400001)(38100700002)(38070700009)(86362001)(33656002)(122000001)(82960400001)(83380400001)(4744005)(2906002)(5660300002)(478600001)(6506007)(7696005)(4326008)(8676002)(8936002)(54906003)(52536014)(66946007)(64756008)(66446008)(66476007)(316002)(66556008)(41300700001)(110136005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KGxfqneHJx5EweGywXiRTdOlYmrmIQWysaEJJIZCoEFEINH9mj5DHBMUN/70?=
 =?us-ascii?Q?e+XKC6YnrwMIfRjF0jOzlnwp8HgWQD8zAu+Gn/o8L0CACeLQAyrRLYzanT+l?=
 =?us-ascii?Q?/B5aQdb7YUeNOkkMbnGdRtvRVwddW3DGk8UNoIkEfq9PHtaLouV0QqJU2hH8?=
 =?us-ascii?Q?grPAEomtMB6jLT1mvjGCnF++UQ4iexbHKp5j0yYr5mEEveTNtjURcMI/ZHSS?=
 =?us-ascii?Q?/GcF/kQMlJbeW/rycwzI0THkYHjLY4XRrztdKODrv3Qejtluz3O19SbES7su?=
 =?us-ascii?Q?EziUXVqBdnz/GCdwUaptHvWwp3GjP+hHtz+Am04d74saQTq5agnrQEyW89MC?=
 =?us-ascii?Q?oI4Y38zPBMb6Yplc4o11Q6GxXT85vBV5zrC6v/7etL3L7003w/Wk6Tw0vG7T?=
 =?us-ascii?Q?3mmXASFMDjYrgF70860lK4wOYwZMHF5/uucDrc5KyPDmWaenvmcsppmjSbfV?=
 =?us-ascii?Q?b4lw7j2+T9VeZ87IXsUuFKy387PY63XGWtRSp2zt7ADiDbIof3yQax+JZRgK?=
 =?us-ascii?Q?JpoNTDFe3T40sSMEls5S+BwermUTgYtU7WoJwY9cGC7zJ2Ta1J+KaKzgwEUY?=
 =?us-ascii?Q?Q+6OJ3hEmkuBNf7OU329XvK651Oo6VfdyBiIrQ3Fi8QOpVVlb8HBAJatndzr?=
 =?us-ascii?Q?a7bxmAggxTvgBu7lCNMLWKMDs+LXoGNo3wsyuCTRtxA2G0xaYMj4OhlX1VDh?=
 =?us-ascii?Q?nAeDNNIuypUI9Z/P6d8acz6NmLMjPt58o/c3bgBoRiCW2t/tygPnbQbwWDNX?=
 =?us-ascii?Q?DhJ5x6FIn2u4Q0gOQ9GDh/Psx1S0Nii81CxI1C25uttm9DGSfl9hLx3f0Vvj?=
 =?us-ascii?Q?BzW5ttoQDDBCuhm3BDFz/YuY4XUe/NWm97/L/YSAIyYEhNSXF50qgm1WYm6L?=
 =?us-ascii?Q?mes48kGuKA1BSaTGIDBQ9rxP3hbxIeuxfo2kHEcINWcDjvQXdpwFqXCnrf10?=
 =?us-ascii?Q?ugfhunN3WhcAaUpgvS30C1CuuPzS/JLq0+a4vLiOwkeSfFceTc1ZzheTwg5d?=
 =?us-ascii?Q?GgpubQDT9bSlsr7sXmDDC7U1i21bx65PjretjueZV2Tt1QiTL3DMZV4TezRU?=
 =?us-ascii?Q?BeGtFIDyV1Tmb+5+4HHScSC0uJ61cNJKVA3seA2//kkq6Ueb8zvIHTseQtTb?=
 =?us-ascii?Q?VlM2V+FVgTsrHxFQGZ+QxY8twxKTQhsKUEZ3nrykjO0JsrFOjAkurk5k3rMf?=
 =?us-ascii?Q?Y9zeMqf6Wd3yNXSrmq7v9ETehDVB6c+OsABPKK5lAzOprXtF8eFE63UQry7W?=
 =?us-ascii?Q?dH68U/kgOmWi21k6nI9AkR+mzOseCLsPW1Zp/pxWPU8hOTCsKLfKPXNdIuaT?=
 =?us-ascii?Q?P1eRVJkbwPTJcNoauBHvnCt5se6FLWAUG6781ITwCReU1/igRjePrj5VnDsK?=
 =?us-ascii?Q?Fb2PsLWQM42UjL6L+omc9uDK1cp2G7gysZnMG+cG8wVrSGuUx8ejRLbqshsr?=
 =?us-ascii?Q?GUTy7lZUkhls+0X9zmfASL3+szk3BoqNXxwFm6KsFXgZLuYfdy/6hbIXuM/W?=
 =?us-ascii?Q?j5KJkzFnettjzCNWoykNM30bIIFPjgalRuGkE+WMt8zwkfbMAWMLRfY0mFO3?=
 =?us-ascii?Q?jxf2BM75Jqj4BWJWt4AofmW1eDLwvZsKj6C0Tqef?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3be034b-c50d-4166-a077-08dbd9d889ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 06:13:44.8482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pxd1bXaxLAfADM7ftjJgpoTKHXgJl9zbPwSmO+8ME/c4Vqpb1BY5qxJXsg5UOK4uSeZXjbdXsNX00hSPRvqH9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5518
X-OriginatorOrg: intel.com

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, October 28, 2023 6:37 AM
>=20
> The following BUG was found when running on a kernel with
> CONFIG_DEBUG_SPINLOCK=3Dy set:
>=20
> BUG: spinlock bad magic on CPU#2, bash/2481
>  lock: 0xffff8d6052a88f50, .magic: 00000000, .owner: <none>/-1, .owner_cp=
u:
> 0
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x36/0x50
>  do_raw_spin_lock+0x79/0xc0
>  pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
>  pci_reset_function+0x4b/0x70
>  reset_store+0x5b/0xa0
>  kernfs_fop_write_iter+0x137/0x1d0
>  vfs_write+0x2de/0x410
>  ksys_write+0x5d/0xd0
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>=20
> As shown, the .magic: 00000000, does not match the expected value. This
> is because spin_lock_init() is never called for the reset_lock. Fix
> this by calling spin_lock_init(&pds_vfio->reset_lock) when initializing
> the device.
>=20
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

is this patch still required with patch3?

