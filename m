Return-Path: <kvm+bounces-4303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45362810C53
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFC8B1F21230
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BD91DFD6;
	Wed, 13 Dec 2023 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Abjs88BB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B9B8E
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 00:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702455877; x=1733991877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B+wHOEFrOLhch2Wfpk66KhsRBM+sHvqn/rJFEGH/Q8M=;
  b=Abjs88BBuPqobgxSToKwg1IId8JdtLFj/H9snAJ9aJ3UBH12tqyZmmp8
   xSzT2Elu2xwQbSZc/8sZsinahiXyXVkatpP6PysvAvslBhqUTLCWmodyh
   QF7SH5nW439s7hr0XM5j8yAJISwFnhsCWBkld5WaGYT1+PQg8KhtINSsa
   y65RGPeD6FwWjFLDVnFc+l+g9UrMupi0F7+nDgyZtqhlSS8IhnNluLG0H
   jvmRPeXwvoUkqZWFCGZ/6gqKku+ymWF5LGyjrcIRYLoSVI9j4oMeuu680
   kDZnZWeZ9olGeVhy97oJzbXLd8sCwAFUSV5va5BJCx+/IcJqZBaeGPaxk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="8318987"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="8318987"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 00:24:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="839776010"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="839776010"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 00:24:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 00:24:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 00:24:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 00:24:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6uB3Xqb4dZUffhi13FBdtkTQ1LUu07iKY75HYK00pU0Ed1MPcW6gZS0lkP+5wMkY1ltqMVSmRkaCsUik7uCpar0gieFu2fyZ+sn94viAoc0mgCMLh0w3TJ7cgmuVCj9//ELKj+O4pIsHZqHhNXG7bXMv45eryJMznKNgXIARdmYM8rbUqzEkrYcbGA9cq+4hD6Z0Wq+MO5/L+LM07CmpKfwtyd1h3IjHPenc9KosC8jv0BhgNeQL3dyayw8XYc13HIGcBtFOnzhkBgQNRVhEQ/H24//NZlLnpYmxw2sSVQR+rBs4CeYX2xh8Ahqu04gsdmDz0eS1InVv0sK47G4CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+wHOEFrOLhch2Wfpk66KhsRBM+sHvqn/rJFEGH/Q8M=;
 b=ZdcqfaBtBThSymes7H/BtHc9wSP9x6VIfNTKKUBW8BYqRVtAWpttANB7XowNcJ8YVSdhVSZngHd7rrOjKMWuo9jb1TlQocn4zKxmmCOc8L1QGAFY2p8ohT78BF3R57+q8IPw+GZojzQYOx/LTgn8aC1g11j/t2CxJxt9D6wJQgPI7WXNdn3NjBQadxgN1NYOlLKVBiMlX0a6KYftFHjuMDhzdPWmTiyp2Hz2e3im0fTD10wq6c57MoVQPuvc8HKcE84ga7yz8o3Tiq+oOZyDyEWecs4IZAJoVoysK+tfnjBCoK7/sO6C4R75GfR3KT+klntwfrHcGOldNKa3gXsXzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4898.namprd11.prod.outlook.com (2603:10b6:303:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 08:24:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 08:24:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH V7 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Thread-Topic: [PATCH V7 vfio 7/9] vfio/pci: Expose
 vfio_pci_core_setup_barmap()
Thread-Index: AQHaKPhZ40bgOHuFAUS8F7xqofWc3bCm6YOA
Date: Wed, 13 Dec 2023 08:24:33 +0000
Message-ID: <BN9PR11MB52763D6AD62471AD069A1E6B8C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-8-yishaih@nvidia.com>
In-Reply-To: <20231207102820.74820-8-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4898:EE_
x-ms-office365-filtering-correlation-id: ffc4ef20-0f06-41e5-ddda-08dbfbb4ef6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TOvb5oKk/+bcCUwrzS4TTF1n3UeGeop+pgYEI0PYnVbYNiWpotsTxtm1qbUPaUf1UOk1zjo82adcIQPCBg+lCMli8W27P1JAS/rQJwWy32wLAGiDUqrKTfvX+XZG+CITyS94xSM312+h2ooEzLNa1ZvBW/ns7LyG9tscIcWP++sV7ChP4EFx8QFj1CIf/X6VDWwXZt8x7vOoWvCtRzMfUfLHVT4ZKr+8/pIYJg2lvsA9b313qT5GKJSSgRtBBk1xF2g96V1N+UO1dkkLfbT5mv2j3XB1Zp4mT5sAhJxgT5+4eIK73a3STGUwl03/JY2kOwxP/tdWEH6zG5JzsXwqRzAhwRpqMis7tn1oxkZo5r+l2IxZdYG+Hbqk3K5lLICTR5WANY1FWeR1xb7DFIoZvbXaiJqmuko30eoGO4ic7Sdb0g9dwOf1UnKoZoAzcTCbtYQcoIFRO7UinW1ziBXH5Yb5xFH8UBC8mkgEEggB4/YZXom4EXkXPfDuTXkA6jDdmKns2kXaWNpk5uw3xfwxN2bvWWa/Zo/Cs/bOR4cv1rAQXmCPI+G+muL2S946P0ZfDaZxVUhL897OmPG1f6byHJvmMwvtEzI1DfnyoFQl02E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(366004)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(5660300002)(55016003)(2906002)(7416002)(4326008)(4744005)(52536014)(8936002)(316002)(54906003)(64756008)(66446008)(66556008)(66946007)(76116006)(66476007)(110136005)(8676002)(478600001)(9686003)(6506007)(7696005)(71200400001)(41300700001)(26005)(122000001)(38100700002)(38070700009)(33656002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FP96hUhTBDvxc4bDPinT9WRf79iM+mRU+8ytdz7JLsTos9hHO0jgE0tEiPCc?=
 =?us-ascii?Q?ncvn7atzUpuEtW9lCqo14hFhrFlzWInmB6rPSRYH1kZG/FjOvouRT3kdkWq8?=
 =?us-ascii?Q?cc75E2QenvaAtOUj4hDTudkjsubfWLqTGcgKZG0j/2iv6O/mTEdHm6dIWlGy?=
 =?us-ascii?Q?F+G7EEeS/5Hbsl7iyKujiyRCkjAvhZNL5Nn6TxEPkclcReN34m5voUxHzQQh?=
 =?us-ascii?Q?FN5HPUgzFNCBk0/KnRjsrQznkYt2rbae2VdapjIX0oMNtd20aGS/GyNCpQaF?=
 =?us-ascii?Q?qlQhh3Tt7Prrn6PZnQOnBVW023kytjANxmnAAy4cFpz7Svy2pWJKJ4og3NGL?=
 =?us-ascii?Q?+8AdzvfOjMclou/6nMWLtD2Jg3yig3HOO2lMCztUot5OulRu1LnnW8QIKVo3?=
 =?us-ascii?Q?AyXaYuOITDLkiaVTiidrbXFDcPYsRiP0NYramnjp3RJWpd+u3QV1rwRqt9LC?=
 =?us-ascii?Q?3II1apwMMr+7eo3dAEQe0wsZCcq/hNl9cCQQxi/5NucRk1GU7TMGT0bNN+pB?=
 =?us-ascii?Q?9Tk9j+s2xCOz+3hDLtMRyI8C240AQdxCqifneGTAhgfUuyI3wXAUvst3+mUs?=
 =?us-ascii?Q?Ch/CjU0jwHoAtwEaADivmR7ZlAkVK/QxNq/1IBtQLtKQHVuJLOf5xtKPpc+c?=
 =?us-ascii?Q?08+gs2dXxnTx4RJwkNvBxP2peX7Uqad2gBFdv0+BSqD+vNcdSDyK+LyYUkIT?=
 =?us-ascii?Q?/Chn31DZZushP16KFeQ3bEiOzRBPSS1FKlKxmuEkfj1xRJML4hqwkg4SDneC?=
 =?us-ascii?Q?hvNXGEE5qWjV/a9l61Nu9t7Q3W5RWu2XRJIcWoeGo+OYi2/AeV7d1k/tLIz5?=
 =?us-ascii?Q?dyL2NCBIgDI/YbTA5GQO0NwEKyVGSFia5eAO8L2qXvSEy4+68lkMEdletbIw?=
 =?us-ascii?Q?09fcEfBfMuvTu4bXu009lA7UIgdq+nQOFTHASE0oHcjj+VbgsG2dESLz/Vor?=
 =?us-ascii?Q?Q7NMdsAurbmvd/tLeHv0se1dWrBjEXXCXe8cZZ+BCTJyzIiATnlJ8Jf9WtYZ?=
 =?us-ascii?Q?vsXFcE0O2FMw2XF5Cv+08qXhBjkeBYyJ690zIo88v2oZzUza2E1thH9tElbI?=
 =?us-ascii?Q?2xdz+RBucK1FtsCbKLJF+ZC2mRUhLEj4d5Fn80XhuhMd3wwhoYXBWU2c2ziP?=
 =?us-ascii?Q?oW6btK00c/0V0qeeP082koaPUneCNwUXv60KIV8BpMFC06Pp5wa/ruPxZueu?=
 =?us-ascii?Q?yAlHQi48UjcCDVlpm9VX/lOWdMGunRHqzu3SBdwPpFrN5CT8hU2oksq1FNWs?=
 =?us-ascii?Q?xbI0DAUUaB5+VNOQaHJTrdlsvxdw9qI6LgQZU17JxtnXnn0i0nR8za22BfBF?=
 =?us-ascii?Q?gUCnnEATRZkNyJSLF6pOv8kBilMIDxTpjJHQlWP5Op4t/Q5bGaTcDdeGg0Dt?=
 =?us-ascii?Q?jj+hhK2stcK7EIOJDMHiQvPwH2WzZTJwkCT3CsXdCfJ20s91LBiUriyZhxiw?=
 =?us-ascii?Q?V95GKgmTMPi1GqicNsuwJ6gTQ56vCijotLN+2JVzyYpMkfkG4c4GWKit0PDE?=
 =?us-ascii?Q?SwMXkPRPp+34hZCeSGoTWBWEiRLA7ghmsL8W7SAJ2f69JLhaLeCVSjZZQN8h?=
 =?us-ascii?Q?V8TCsancHzoSbQIgElDjDWGXN52KKnPOQ2abLL+L?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc4ef20-0f06-41e5-ddda-08dbfbb4ef6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2023 08:24:33.2790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EnXwFq9Ok7tMu9AMkOYzhbjjJdsYKaTvS7cAmabp+6Zit+h9xgdY6rCJLZ9RFQA6sKdFOF76r/F1OpEKAbDHwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4898
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, December 7, 2023 6:28 PM
>=20
> Expose vfio_pci_core_setup_barmap() to be used by drivers.
>=20
> This will let drivers to mmap a BAR and re-use it from both vfio and the
> driver when it's applicable.
>=20
> This API will be used in the next patches by the vfio/virtio coming
> driver.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

