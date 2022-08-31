Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA395A7972
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiHaIur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiHaIua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:50:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F23A6C30
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661935828; x=1693471828;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=wD/oa9obgl+fTuzN9GTcUVsYA6KVpC8pascvbRt3Nuk=;
  b=QBajtTV1+AIr2pZL1GB+0UodSj/21Iean5Ko7J84I1oJCdTeNrh28eqG
   XTRtErImtiUntU5cd4zvRw3LmYE/oNlEAo3VV3Z38rM5JXGt89uBJ7uHh
   NaLsLAgzXy8HQ1qZUuFevDSmAtsSB3QHBL4XB0om5EbB+zHqXDkbLKEKM
   mfeTAdMv1uWukJPUrZGWSW89Vp017GPGrVGIW76OLud2YKQ6d8SUl1rlh
   ju9U16Vizri+G2PxOetIbrSWm6mdgS1EsbAnKzE6N5kbYnyJV74cxGSs3
   7dH+m7/mx1B5OUOCp82q3v9tN5PYzk1eIaBFJnDYxBb4uNX0pM30duEfn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="357123279"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="357123279"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:50:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="940366338"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2022 01:50:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:50:25 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:50:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:50:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:50:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDQ3m/qoAdDgKVss1kQirq66fY5WK/fK1egN/z5Dc80xkWqvY8Wl2Ryk7rPwgbGzblzKX7TdUumjOg3CvbC9JouG5cbonxSfdfCefqXj0WK4hcry6AwvAUL5ZYM4lZ9Ih1q5whJ5R+z8+nv/lqZcJMKofg1TzG8aML/XqtGOz5iMQqoi5nGGeq4evSQuAVWEBjM9mRsDI2RAbqdBRIzYH/RUm7L4EeYGwZTXkdKOn5M53l7K+snyrwMZwbEsErcRj6aXNrvIBggfOS+7E4BSiFUTDqXUY0CKQcXEW/wmZzeND5VwObxledRVcXVtQFKqJrQSyUi6Px+HX0b5J+W/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wD/oa9obgl+fTuzN9GTcUVsYA6KVpC8pascvbRt3Nuk=;
 b=Mfk2jWrHYgRMsYJ6H+HsAzi1GZ7d4qsctHT2RUhjjcLuDP/sirxSOni1GWt6j7UujiBVjSVJKQm1ypCKIG4QxYJHL+mGiWanP0/phNbEUSSpgfqJJK9Nbz8mpRAifjwj2JYOzEvK1qq83a5bO7sFk/L2Qi7SI1dB9VNjSX5FSbxR3O7MYdBpUAGgCxd0khbmJa/qPO2RbVOuCqY69FnCljBG5+vqkx0cmv435utGscOzYtB17EZ0Gdm+YRnhxLKNxpok7nAykpYTmXCiwussbgXFenpCqMjotIQs4ZaGhxm//JUPjXiIDR0nH6BE4OzvGl1Y6MrErMgwRdU/gGuPlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6017.namprd11.prod.outlook.com (2603:10b6:8:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 08:50:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:50:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 6/8] vfio: Rename vfio_ioctl_check_extension()
Thread-Topic: [PATCH 6/8] vfio: Rename vfio_ioctl_check_extension()
Thread-Index: AQHYvNVTkDRuSMCx1EmbAxdvgvKPp63Is69Q
Date:   Wed, 31 Aug 2022 08:50:23 +0000
Message-ID: <BN9PR11MB5276920C944C048B121BFF568C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <6-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <6-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27e8081e-bc3f-493d-0aab-08da8b2dd793
x-ms-traffictypediagnostic: DM4PR11MB6017:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9jAnzg8eLn/2UCsUP19m3Sl2jr/m12ho4qk42hWz6xxW2R/7psSok0rBAktU+IDlm+C2sHkFihPCpV6HwT0AtouwFiLMwov60XiJuIGBbLapkN8eHEk38lEQHmTOpENtIHzcCcmUcXxpmykn8Y2e9hYt3yRF9IFLrFiR1xqMrfc7c7T8lTsZMOJWbA9O7qQqPqJ42AqaO9D3EcrOW8HRAlw1kDbN5xjYLsBgcAvwG+8upo5iaWIWfqXcw5j9l1OWTsuGqkoxQ4W70HlZgeJoTDocTRtq14Eg93j8gke3MEmo6SBQcqEDN402TcI+s0ADMoRT+MxHkMZK1VVPRg2VFsoPbpIe26pdewAFvk79fP+wrljinqxgRwaaEXvVtlA2DJFVCACm0Jle+Bq+u2aPUG2NlJ+i+eaaFRWtd9oUXKJ1SXvIGyjp09Dfff3w8izM7a28HGjScKv9hrOJ/rCRdNhZ4iYnGCcLDILysyygt1mMDefATpxIU7gTNwZXOEdl0ltxZ+SEHb7h/D72LPz2gAT51fgcXsyc+o9iwqaQDJDwfW+LlpJYVdpsaZjiU8Vw0jMsQIuVCIZRQtAqBJKucFiBV12sJD+VOp204H+N9IQ+bwmk5F9uCJ2jakJ1dc8jPYWdne08fmmgwtimIBZnyKnb4AxiqLF+Xahvuc6ySH5j2Xj3nOwwXI4HP70hCJZxykuCZF66WwTnKF8UORb7705gf4ULu1EE1mxyOhdW5TOOYHYI3yfra0IQqgHHIm3uxKgCcKRRCfaZ909PQ11x/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(82960400001)(26005)(33656002)(52536014)(122000001)(86362001)(5660300002)(41300700001)(8936002)(38070700005)(66946007)(8676002)(2906002)(66446008)(7696005)(66556008)(6506007)(66476007)(76116006)(64756008)(9686003)(478600001)(55016003)(110136005)(558084003)(186003)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tKL8sDE9nS75/V4rl2LaA8b3WDTY3kV4i96M4f2u6A0jWvVJ3s3dM/fMe8uN?=
 =?us-ascii?Q?lJL06lUSmhdq47sw7TuQOGK51xaj8PDZz/WLx+JpTNEgwM3Aid0n5tA7X8yM?=
 =?us-ascii?Q?03uyhz3zgueTwDnmOqmqSOL6RRTaLA0/hr1CKRo1nQ9FvLNhl7+z1terFIpP?=
 =?us-ascii?Q?bu89brpudQTJcrM/32CStI71Q2nL7LP3KkP+9KN2nCXHDbgUnKVOBB+OlRlg?=
 =?us-ascii?Q?aQKzy/Ubp2CkglyGBiFS96chB5onxa41cmAND++9kyHx/Edyor9Y3AV/PxwW?=
 =?us-ascii?Q?S1g7p2hoLvYSRdfudL4BDYmY3qt8GDHLV9DLK+DVcUGuVQKs6Q7DTMKZGpHa?=
 =?us-ascii?Q?FW2rbgMofHFmRfMJooITJmuHTMOUC9pfs9vw4Y6NKE3mSe5QfoDxdQc91jVe?=
 =?us-ascii?Q?FhnQQW2zQe0gUn0AT7Mlw0BG95ZtqeRO7/DtVke6Zi/OtWVteiRHUwKssJM0?=
 =?us-ascii?Q?gCRE5S68FzlSZkkg2yu1sBhICybtd2Kz8AnMySKZZXws8IaxF+vRoRQZNYxC?=
 =?us-ascii?Q?jEI+4Snq2NOGkA2tbshNguOuLScIAUFfxu0H3XpEZlkkh3lBgHXiy6Vbox6L?=
 =?us-ascii?Q?bUKT1GeXSpm26NHUTTqIjdSrdjtA+Wayx+aoNUY7g0FqBLUs8Riyg56xAaBJ?=
 =?us-ascii?Q?elFAOhzLxFL23VUxfPSdPmdTrh7J3JDzuPOdy+n6/4XH8bAgfXW9U24uAiun?=
 =?us-ascii?Q?PlOQ3189/T4qON+wXPChNcmwBKeER4K0CbphOsAjJ10EYxHjCAEpPS04GQQy?=
 =?us-ascii?Q?qmKRQsCg/wj9CklXskcpIt2D/h3Lbz9+0N2PtEQQB3WsznatLMjpqFEqqdF0?=
 =?us-ascii?Q?HR2JOBTJwYXvZW7D4qRng0XTsoXsl1pXmK7HsQguuqBPevMjOJuLBd0YCfe2?=
 =?us-ascii?Q?P/A08EpKFKstluhsFMN9UMUh/8UUDd5pIZIo7Zl1LIFrGHz2nUGZaLe71/3R?=
 =?us-ascii?Q?YE5R4oYJoq74nA18Ddu4n50vd+KUtO4GWGvqmq7oNXustkX7YTcXTvWTiA01?=
 =?us-ascii?Q?OL1OfBH7kvT4saCU9OWBrPrxE6vAsMzkUdeUgYAwpW1KDzeiAn7m5e7yxT45?=
 =?us-ascii?Q?uYsIQrGF2st32SjCortcs2JQ3YN1N9/Qiylrd8srbrNpOtYw5/m7xifjdRaX?=
 =?us-ascii?Q?lbGXsg27o0ZphDSYAg5u2uXN6oacoecXm2P+a0PoZ0Qt0dOdQKXwevdsHqM+?=
 =?us-ascii?Q?MCBWyKSY4YzoeWFYKVUMXu8Vh/kC3H8jDRFUDwkcV4ZnhOZNHIqbMhWtg5f2?=
 =?us-ascii?Q?0WTYfAn3q0A8KqeYP+CmYL0Y0AWKHM4tTiWfpYw6wCEixuzngUheiXp3RWTQ?=
 =?us-ascii?Q?ZDThM07A8YjZ5RyrEY/XBNfq9g2L8srnw9dnPOMmw8kFRVq/6a1/1TwOC6oZ?=
 =?us-ascii?Q?j0tSOncahyG9OFbxYaR6IyMmth6y3Dzsy2GaNSclxx+Iq0MV7QqFcTH0ILo7?=
 =?us-ascii?Q?Y74sE+aCu3KGSD8g9UxI9gxgV3LZf9wzzCJQqf9CLaIrpa4tCE0+f1BEctrB?=
 =?us-ascii?Q?uuS5yWpqX6Ig1batbFUxlQskz+ySvUTVLbbj+fwM4jf7fefP+4xbu7tK86xl?=
 =?us-ascii?Q?CoHCZW8+/zu+wYSWDKhUShsrKTZDBHMsuygrt2td?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e8081e-bc3f-493d-0aab-08da8b2dd793
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:50:23.2717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s6G+ik7eQ8yECT4WLc3HLF8lm/BNzwjNFsvyaNESsu6YXOHepxr4543oF1SlGX3s83zIY6NB+E3DyudB9Om10g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6017
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 9:02 AM
>=20
> To vfio_container_ioctl_check_extension().
>=20
> A following patch will turn this into a non-static function, make it clea=
r
> it is related to the container.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
