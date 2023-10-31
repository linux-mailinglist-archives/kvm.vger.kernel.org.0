Return-Path: <kvm+bounces-152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EC57DC67B
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 07:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A20AC281617
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 06:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEED210947;
	Tue, 31 Oct 2023 06:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TLMKK6CU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1DC107A5
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 06:23:47 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE979124;
	Mon, 30 Oct 2023 23:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698732889; x=1730268889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YNNLnkDkPovySZkyRclr5rkL2MYQ8OGUN+HO7Wthc8I=;
  b=TLMKK6CUp3pqHUr5J9id7B05UTEn8dZZWWngyc1pPGflzh+r3mFHiH9g
   1QdmiEPh9bI1N4jFcbVs1mLSdXXgCsJezvZyCoRJyac3eFRThkc0uf9s8
   OZWP+vEVyDXCVgnpuWYUk61W7/SvQqzrJchV5HTRxk4RoVOxxAI0gpi9m
   73Fch3bgvnNjsdCHWyn4zc4tNRuXDjaxhgOJoN8UZv0Gc6s5cbR5Qdbre
   PxT3MfIUktXlWCI14Y8TCl89F9PDOMcrqRb1O45/PKI+PMEuFNVe10ZmB
   5tS8QqKHqt0F4LaJaNm5BCJDhagnfjRCo/6Q1vmp18eW7dIFpkB+QnqDL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="9752179"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="9752179"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 23:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="754042371"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="754042371"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 23:14:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 23:14:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 23:14:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 23:14:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 23:14:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6r4j8pkQSmyr06Ez8zLKAW07FCsbK02Tk2aYrWgY1ipC1tFonQUgQyaj45aq94/NdGFC8U7U6uHdbRVNh5XAaG8yMLiEnLt+POAokCtsJ2fFDhq1nhnFdjz1vsVHcc4MfpQCYrybB15lHuS/gPSjmdGSDu3ayTenuvCedmyxgYqBqliZU79YTtLfvr1Sv4d+KCqiTf32E85u1DLNlRbicPOXnGOXNQJE2uK8hKWetcrjdN0T/qyb52PA0sE1xbCvxX7ffxsO8tiwJs31lxqUIzoD339ha6t/0ODPh2//NI3IWUqN4DwDemJhO3D9m7Elalx/0SeMQDX0id+Vzn8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7OXWGZkzZPSGhEia1TgVLAS3KfoeK9eXzHAGea6BRw=;
 b=Uygwgh1PsWKacyVN2FcirJonmXQkehopZe9haUEKYXyiIA/smIu7cpYoNiDafVN05EeMnRlgRFucP+CCmteGG2oL3kyG1/K9Ut87PXG9u2sCi6YjYM2cCnG3Ej3nKC3Rgowv/1wMWTl12AuYyJv6FM9BcPyudFE9/RuxN+ekpPIOSOK0vMQOQqQWCgkKI1fDriQAmkxShp6khDxbTKPIrjZYt+Fm8+4TP1SP8DEXHXBhdFbb1MUC8dV9zZ3T8yDUMUoMisVX7kKjpyiep4nY3hTKudFu8DdnVPBS6S+RjP3pY6wZcK/LwdjgQ1RIPFaXz8AatMrOWO4RXvUAXdQaZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5518.namprd11.prod.outlook.com (2603:10b6:5:39a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Tue, 31 Oct
 2023 06:14:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6933.028; Tue, 31 Oct 2023
 06:14:45 +0000
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
Subject: RE: [PATCH v3 vfio 3/3] pds/vfio: Fix possible sleep while in atomic
 context
Thread-Topic: [PATCH v3 vfio 3/3] pds/vfio: Fix possible sleep while in atomic
 context
Thread-Index: AQHaCSYqxbj6ukjd90eyDxtddGRNz7BjcIfQ
Date: Tue, 31 Oct 2023 06:14:45 +0000
Message-ID: <BN9PR11MB52769E037CB356AB15A0D9B88CA0A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231027223651.36047-1-brett.creeley@amd.com>
 <20231027223651.36047-4-brett.creeley@amd.com>
In-Reply-To: <20231027223651.36047-4-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5518:EE_
x-ms-office365-filtering-correlation-id: 29576cda-df85-4263-66bb-08dbd9d8adaf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HPEHDnhVlg/2Gem2emxuxGqTiSGjpMIExMap5d9043yzONZ4KUjXETNRd6UNdc1s7i71BOsMmj44clJ07H5+cXFeuXdqk/lLO+hMjwKr1YvT/UnzrJl9BmZquF/BE1vC4fLoOhCsoo/DepIrlt6OA3mgwXQoRByho6rgHp5W9Lw0xgCvcaPL2Q9DofblnfZz+lhB8SHOZD3OQelw6C4+QHLftEFprAbCAC8UzFTEGCWe5m+EhOTRLoXgAm64MiCkjqFiDK+58P/RJVqBR1q1Jv/jVTBCmTaQlrgPK7gBNJj5rbjNoKF3rTEaSTJXSO0acEXjrK0a5HAIaPAYAV7GHi4Y8a0oH7gjWao+sL2vX4JiV86taG98AQrTnPUiY7bhidPABqogq/hO5Zxv1cfalZvM3MAeJ4ZrjlMm1hszp2vL30/CO2Vu9uxmj4JVlpfc/yzt636oju3uQ/4ZDZHBcOmXgCbsGlTszNnam+TAOv5eZag09Jy8dYkLWzImQVGL8R5ypin19WMBdb3cFcEh+QxFut6rV5UlgXGfJK6h4VOKjDZxAU6POv5CEnvj08hzfIOfJfapL/q8qxi5F22+wYbiEV+UclGt6RgAJ5T4BNk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(396003)(136003)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(55016003)(26005)(9686003)(71200400001)(38100700002)(38070700009)(86362001)(33656002)(122000001)(82960400001)(83380400001)(2906002)(5660300002)(478600001)(6506007)(7696005)(4326008)(8676002)(8936002)(966005)(54906003)(52536014)(66946007)(64756008)(66446008)(66476007)(316002)(66556008)(41300700001)(110136005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3j7RxsDfy6eB1Lm/VRyuHYo7xOpj/YR+Rkhf+ChZ1RVpuWzlimYyPJF/jx2c?=
 =?us-ascii?Q?esVkG/hdlRkyk3zRRExS6A4odtUHwgfWxpbuABOauXnnevPE5Xd17563xV27?=
 =?us-ascii?Q?Y6IEUDG7a8uwgaIE2lVhbXVHKSEPWGKex9Z+IGyqmMYCfEUumdSOFZl8vLtq?=
 =?us-ascii?Q?6qg5qquQhT9oblneghaCkf4dvrqJxqCbrls1HL1vYKhUj4FofKdnlB9LXiD7?=
 =?us-ascii?Q?O3RstRKOjKroledIBQIt7QuxhjOfg/vTfc80qluqfNsbcrMxqIyhsZzNsDT0?=
 =?us-ascii?Q?pZQlQqGr1hLnpunB55Dp+eR7gxKcawqckF6Fo4Ms5NddvMLmR1g0Jdw4ufoj?=
 =?us-ascii?Q?kZ5Op0Fccnuq4xsFbHgdaGDtVIIprnlxz/MEI6N4ZuOy75Tj9RzjmBybows5?=
 =?us-ascii?Q?o4hGqgxfPuJGY2JhzDtbtyQ+vX3qyzksBnzb0YdxkxjFrPv0gm1ZsTCNvfbs?=
 =?us-ascii?Q?WdORZHLITX5UVGeDQrWPNJFptgRWlG60OG7tQsRdkk9vmno9huFa+t7LMpcM?=
 =?us-ascii?Q?2/3HBUcDbtUhUQJRAfUZudPcn/y0ecPS2Yd+R6LeIpO9n1PfKr/jo6lcqSUV?=
 =?us-ascii?Q?JJLEgceuw4mALiT0TUxc/195qXttcijeTUoiJ5k9IwtdAaWCr3jlf579Nz2V?=
 =?us-ascii?Q?fkbohCIKGbiO5DUsNknrUBlJb31vBDq5qaUQbxo/mdRqCOMg7XIkKlrrucgE?=
 =?us-ascii?Q?Gqo1HRgVGuN5aiQrxdexmdUqAXT8agwKbSJ7Hl29XO9BdSaCeQJyHC23k02A?=
 =?us-ascii?Q?6GvdG0+T5eAwsq06Ihft5DZUoGVRpqZbPliAFGAcSXtuITna2DlC45kCYzMV?=
 =?us-ascii?Q?KmdhaReOXjDZvwhmvvW86GOmOyVrkE+W/51t6eR0PRDYSypV0GRy4e3edn6e?=
 =?us-ascii?Q?5kjV8eU9ry/9M2cT/c6gbZeD3OehCKKZEs6xJEJEd6WU72jdhnHlM5ghFz0c?=
 =?us-ascii?Q?Db0wZbpLzqR7s3bz4g+8fI+zaIKHV3RoS4cFEAEEN+xkngXDInUzAddsDKBJ?=
 =?us-ascii?Q?r3uGe1LDNAeiYT1/XqCgtCV8W6yMAZFoCwzT6+1p3BHDFwWe7Mr1oRVSlpQl?=
 =?us-ascii?Q?jMuONLE3WJ4hlR079FuGbxXgYQB/ElrA1jgZgeCCulOJo+DbxFJ8BUsUAm+Z?=
 =?us-ascii?Q?2vOD5n+SZ5e37QumNARTz1YdSF8xcC9CiVAacwoEbzam522DZuvg5oGuJU1U?=
 =?us-ascii?Q?sj9u/NVOzjegVCA6OVVPaxkdW+wo1hieVzQELx3ieRJpXhc5hNtbk9ErEdhF?=
 =?us-ascii?Q?eQoRBFCfX3N76bKtWpAuZ0H+9fgnkgohv+mghwIGxf+y2bq0EmCIpx2fZyXT?=
 =?us-ascii?Q?uERqJXW6hAPxm4eMCk2d3xbc1frhZOzQiFRDAs87fB4bBxQPkjDuRbct6ip6?=
 =?us-ascii?Q?PvJ7cJXE2bbvScEFx2BZ0mDBCSqsClNYpyY5JFqK+g0SEwW1q4gnTVW9DwyR?=
 =?us-ascii?Q?BY0r5AmmbFch6TmIkmf0tzp3NfjBPHcS8A030/Dog8L73E4riM9Ehxp/wRuD?=
 =?us-ascii?Q?F7z/VzYpWxFvKDzv4a70NJvhtdOgI5YZpMR8SFEky0GxqLV++sY0yFDf8AL3?=
 =?us-ascii?Q?f+Z80ut6j+GmW7it2ISziG8zp33H3riUGvN7ovij?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 29576cda-df85-4263-66bb-08dbd9d8adaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2023 06:14:45.2989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18LiRTAn0QhoHsI8OplP8bpb2wNWvwtfA/Zc+TMehwwdzkQ1Ag/W/muAQ9bqen/DL4QUI404CRiGy13hF9+h1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5518
X-OriginatorOrg: intel.com

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, October 28, 2023 6:37 AM
>=20
> The driver could possibly sleep while in atomic context resulting
> in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=3Dy is
> set:
>=20
> BUG: sleeping function called from invalid context at
> kernel/locking/mutex.c:283
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x36/0x50
>  __might_resched+0x123/0x170
>  mutex_lock+0x1e/0x50
>  pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
>  pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
>  pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
>  pci_reset_function+0x4b/0x70
>  reset_store+0x5b/0xa0
>  kernfs_fop_write_iter+0x137/0x1d0
>  vfs_write+0x2de/0x410
>  ksys_write+0x5d/0xd0
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>=20
> This can happen if pds_vfio_put_restore_file() and/or
> pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
> while the spin_lock(&pds_vfio->reset_lock) is held, which can
> happen during while calling pds_vfio_state_mutex_unlock().
>=20
> Fix this by changing the reset_lock to reset_mutex so there are no such
> conerns. Also, make sure to destroy the reset_mutex in the driver specifi=
c
> VFIO device release function.
>=20
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-
> ba2820c1b390@moroto.mountain/
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

better change all three drivers together...

