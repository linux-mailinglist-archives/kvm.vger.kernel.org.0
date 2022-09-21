Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAF55BF899
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 10:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiIUIGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 04:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiIUIGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 04:06:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534CD7859C
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 01:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663747568; x=1695283568;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ZXXaKPPSUYocwbXoUPBiZFlhfuyt7hO5smR67U+nt2w=;
  b=lPaYmZ3C8WDbjXW3nwTb+/SCvQZQCIlV34hQDB5+lPRzF5Txas8uWrd3
   jxqkTW/UKPIpdi1/xoTi4KmmKRJNGtcxepXEiRoxuezJxPEcejtzXH5BI
   swZub7Mu27scYMQVAUt/ukbjt4W9UeAGTlu8DNFYdlGZ3BW72xDqGLOZQ
   tcfbC1JWir5YKf5N7hgTgqMcn+tvhxrvPb0O1wlgZLHGBGWQdVg4puK8Y
   pP030GQBjjz/xl4gE4emOCNSZPgB6h2M7atNOcDTU7t4l/VSTHGIot3zO
   DxJgJ5JrYVFzS5aMZAQ8jesTE2f87y+gJXo9RebTtEeMkrlbv7sKPdPP7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="300771223"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="300771223"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 01:06:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="681669005"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 21 Sep 2022 01:06:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 01:06:06 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 01:06:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 01:06:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 01:06:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMKOcOgtIpCJdmcvxkXlOyltWxiHI7iJqxyXKIQpU4jHaQ8EZ1mAvLaFFIBvi1mLsAAtmy2COjACO+Km3YDSLRtx0lTc/lUC6n00FNi1QxVR85HEGERRcLf//n7ZuoOADY1GqTiZ3vOJ6laaU1kmQoUVTft7a1DCujf5Mr9Wu/kxGOhVMf0l42YtomWpb0ewJqEpxJ9+Az3eeRh4RRFqkGtkFRgNB7mDlphTAss/5UFpCeK0JrhG6Boq3dpdIF9NVdJH1GJNHwaXGfzfuS7m3ye720lYZ/zGoaxrayo7qNztVC1Qnu0rtePi81ot4Hyq/cPyPES4FfvEoVwUN8FHzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXXaKPPSUYocwbXoUPBiZFlhfuyt7hO5smR67U+nt2w=;
 b=H7ivDjI65sc9qNn8KYN1m86d6GeooMkejs4uU1BayCtgvWDlYwxsvEyVM0qSI0fYvSC2NAiPrJHMu67BRPPV78E2N6Www+N6Gtur3Ax7QsHUj9Vejg9WXuhYB0CPaB36uRcxXj41jaENMyPIcP+s/dcUFyUX8f6JXdlORLokcZ2F7MbSwFWJaV6rIoCJH0IWELttfesfEslg3F3Hlnovh17Uiyfxlihmu7gD3//w7ic7vRR9kpq2sk465gY39rJu6Ed3NctQu7IL4AYkrtKmy1nMVKqYxtmQDp8nmDCOBHZQt/Txfxf2OoXH9G+BxWCPAVMVoOKlc+FDcM7GA6xB3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4973.namprd11.prod.outlook.com (2603:10b6:a03:2de::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 08:06:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 08:06:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 8/8] vfio: Move container code into
 drivers/vfio/container.c
Thread-Topic: [PATCH v2 8/8] vfio: Move container code into
 drivers/vfio/container.c
Thread-Index: AQHYzVMet4ixo7u2/kSFgfGo15g4uq3phz4Q
Date:   Wed, 21 Sep 2022 08:06:03 +0000
Message-ID: <BN9PR11MB527698404C550F6700C856D08C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
 <8-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <8-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4973:EE_
x-ms-office365-filtering-correlation-id: 4c006dff-030e-4925-44f0-08da9ba820fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1ZH73l9F62AL6SX9ihgTOQIYCJIVryfp195VEToSScaVws4dbklbFgMScCI6doDiEx3hjkxHb7CvZdVS/OXq5zR5LNL7R6MgaTzNnjPICa7/bwwYBQ792yuy8mruDbpyWDsobHqkz+GKpFIgu8YyTwl/U8AX4bGDt4hdP+E3IuP+kcHzEnXjuScxUvcru/R+3CvYtButqnh37GlcI4MLu40bbsUcOo7em5NaV8AztCxCFsw0r+cX2HHA2Uz+6djsfz1qHtv2yp5rFUXg60Pxx0a7G/PmxnSZgK2tvEkm2M6mJ6R2iUXyMdCA/iCcAY28VB1y1q0sUqKEFsCYqK5HZRVXdbrzTCvJw/CrSrbITarxXTrmGkg2t8YyrkvDmQN4fiHdNSniu63ZbMTTsggYSC2T68P3NBotB7B9Y+03qb+b1qhmeEU6GyfYee/L8FuZiSt4YFE4/oWhAhSTU+di8LAvaS7rBmkGSH/gjnX1eJ59AaI5r+v3Q0dHfQwyVplZ4/xFaX74VB3rZVL2/K9MQZz45Io8avICMLstD8TxyKXRxchYGDvvIGFwm1OXrPcKFeIzn4Jv5DPMyEqJkcqjlFSTcgRT4suMDHoXkPoFqMPblELNiHPw++S3oApiIRtIxQifMcboY1Cd74tcxTB2XbEkwziTuCZgfVJ2xpnaG4DSzs9nrwV+S6jDQNbDBNEj2JxUayewkfmCkWpbJqo3uHmUpNBorz0TIZSTVEQTHPHHSGqpzXot0xNaC49bb65Sgcd8DMZj12AGMPSy2yhXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(33656002)(8676002)(2906002)(38100700002)(7696005)(9686003)(41300700001)(64756008)(66556008)(66446008)(86362001)(76116006)(6506007)(66946007)(26005)(82960400001)(66476007)(558084003)(55016003)(5660300002)(316002)(52536014)(71200400001)(110136005)(8936002)(38070700005)(122000001)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bZgOJsE2WWnFoB7yLNn5DhDf8hiF8ujCn5bul3phytzuhdXUKTS3iqnlarqy?=
 =?us-ascii?Q?1rEXVhun8M5LNf9nBfvPnx4WiFQMPbSCpdgvrtk63UoCxY0Nc7JGLk/VtDm5?=
 =?us-ascii?Q?Q63dcTGoVLob4lBVc5kbylBylW94kzaDUHujqJx3dTj/osZDa1mZcXivnODP?=
 =?us-ascii?Q?43tJ/0P4VoX+WJ803kRF4qutnTfD2eUtKJAHYCVbsla9ZqGn81Ii6asSci5Q?=
 =?us-ascii?Q?CUBS833e4qFE9hahK9a9eIAuIeSt2gV74k54hDly56pavwEloAPPzs2LCmnX?=
 =?us-ascii?Q?w0x6f1JQcWkmup1MYzGwWqjpoyGEtq5hPheleLksuQkbEBPOeaO+HujyrdQA?=
 =?us-ascii?Q?FoJjMqGw+pEBeDuLd1ZnFEdbNkXbl0UYix0mxEQHlARoCVOEN9zmYuLhir6g?=
 =?us-ascii?Q?6VOdYaACzoqNT+nL9S7PGBCC5LN33YtilD6CN4b/AZN+l1kHKlyTtfhd5Wm9?=
 =?us-ascii?Q?z/qn+RyAPQ+zYPUIGluz2bEatntRdlhvGCZvMydFRQpZ2J0PKoWoeuL4Tou9?=
 =?us-ascii?Q?/OD6OaNmHw/1EoL3xD/ZuhpxlCHia/2dcg802EF3zZ1/cnm5i7497RcM3f/R?=
 =?us-ascii?Q?cKBuBf3MsnIo57n9Hrt2EML9AikJzV45iZBEcG09ZHVwqsy7wk7mMjVmn/bk?=
 =?us-ascii?Q?4aeR2LTRdG63bEEBfCQ0lAOvEvAfLOvfQY1ck8jL/QtGqqpm4tuQYI3JCU6j?=
 =?us-ascii?Q?DHd8e1YGGlqrPJM9XtkSwC4ohJ+AJR1faKXuFB/5zI708stCWkBAKhMkqV3k?=
 =?us-ascii?Q?2RHx+U++MA0QU4Jk692a6XJ3Jm0oWadQzGUr1jmpDagVYJneTGGrl+OaQSzK?=
 =?us-ascii?Q?NVrlWBALqtwZWqOP4dK2E8BmlSZeRt5F5Tag6B5BbxF+BkAbvdx1UXm0FOyW?=
 =?us-ascii?Q?+vfFikR47R4gvOj0CkgVUkDd17uSxTXT2AL4hblaA0g/CIOsWsttslBtZKC+?=
 =?us-ascii?Q?HCaEIAEyAWxy4evCvahUtUYeQm8TezTbp1fdhbmTdxZyS2KnJSmNhqXWYEH7?=
 =?us-ascii?Q?eQP8r7KObMcqUhXbYlz5DTfoEOdtk8UAj1rNmwP+wv1VPtdgUdjFeV8oBFf5?=
 =?us-ascii?Q?4S5UwcYhSGUNnRAFpCRy8ooqZTcDoyVikCpyPeLMsNY8tBfhJaINOmqZpCZV?=
 =?us-ascii?Q?Y4b5COwnQKuPscJblnpWm0eCvJxiv1eEblFmmhs6J+05sw1KINNyIWAZcM9a?=
 =?us-ascii?Q?tWj//VoUsx/D1OVWtswhVO/f8XYKcxKJXCu6fmpeyiWp3CzmFsid8nbVs4fo?=
 =?us-ascii?Q?R9sI30Q/i4pndyHnQoIesCCYg1kdvJ3uVWfSd3Cl4Chd9FqXY47fmK5lJbif?=
 =?us-ascii?Q?zH+JI0MgoswvWfIxLMAzCBuUsjrSMuQC3YdJFnqyPy5adVyy6Rx+QS48/4Id?=
 =?us-ascii?Q?JHMPTDVH/5nP9RocwzmIZ203cSRjq7A2xr+X4b04xKNwmPhDyZYv80Nqf9tN?=
 =?us-ascii?Q?mE5dLOxl+/MHGX121GYEklJNrhFaeAHTKMP1KzTjpjeWPidctd7oGWRliMSC?=
 =?us-ascii?Q?gk+dJBYOXIyoJLpJicDgBrwppE0gs26n/ou15Fm70xMOiJmT83Ki+jkd5iXx?=
 =?us-ascii?Q?thTJ+eJLWbtKyEzrpjn1QTp/K5E1+N0iSQfhuSUt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c006dff-030e-4925-44f0-08da9ba820fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 08:06:03.6273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07noPseEcriBHVz5oA/NyH1KVbvuuvSJ37/Qmnf5c+dlNV83wfvCRHpG/EocZTUtRG6vIsIE6xCJXeqnQKaCwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 21, 2022 8:43 AM
>=20
> All the functions that dereference struct vfio_container are moved into
> container.c.
>=20
> Simple code motion, no functional change.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
