Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA25A7962
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiHaItq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiHaIto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:49:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2271CC7BA6
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661935783; x=1693471783;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=/WY/BY6zQr+dSTqxkYk24CRgHOUymRdMlnzeoYaq7c8=;
  b=cCkM21WKU1hFCSi94i0PsAu2HAHQYCSBTpoTVmx3+qRzWmW2vbzqunTQ
   /kGNP/uUa2Wkv1bzsTPqrY1C2JFe8NyMhB31ahDQ3Ipz9reL/JSUrVr90
   6mYFwEc5EYTUd4Phgpi1KKuF76rqeyakMqP4Y/tUac8wPh/ZwJw+VodWv
   bVfOsCYcS7oKdAPzWePxqShUczVK2vEWOEp+hqiFyF2IDRzwh7no5xsTn
   M7GRAhPb/MIe6GrzQsHrGxWwErpUQ/uzD075yN4JYlwV6kkrk8Fn6ZHmw
   6Xsq0Nd/JhtN8NGvubOPkY+4cYGRSuE5pq+qOVZjXU1K+v0P0yX7gz/S+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295409809"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="295409809"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:49:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="641769405"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 31 Aug 2022 01:49:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:49:41 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:49:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:49:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:49:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtB5UZn3WGkjb5Hg+4Oi6S31lv6Jh26Rp2+m5ix4tIFyflYiZsT2gxKaWaeN8Mh7yMTktlxMULNoowrjcIUSokskE72aSTjdbiLBRlZLC9xB79xitjC5qt/CIT5u2nwObg5wvP18Ve9NJHOEMXvZ6JMcbTit5sYRYhbX/H8PFg/ZKQT+5DG8ChHGK5ZvEjTPPdUd8+dB/LEodkup73/+UIKF0G31bRolZ8mzVQD1mhvx1dK9AUmkB1CD94DTQDUZUiibZZoatKLvQf/EIButpmkRG2N/AXba72n0UcfqDV6B1NH3jUzeBGJVx8s0kd+cR+uEt22D5Hn9uoJfisIXxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WY/BY6zQr+dSTqxkYk24CRgHOUymRdMlnzeoYaq7c8=;
 b=nCrKAHKhGIzA82F95tWD2OosSQtVI2j17Zx2RPzuA2HtMX/YYUA+/NHi0EMifUUGxN3eK2hAy4NWEZZ0kqbq7C7J43mZbuDkdeIdca0195ZyU/HVcLRE+UeAWUxOpA28j/geUnikiVT3M6TxS6jOhOvd/E+aSH3CeeIJRWQ5c4quc04/Gm41jMvCnvPliBoULsPQYED502YYTPJFn5qG6Fhu0zhoVXqCMV0wldxcxr0R+AJJ+3NHrpzyJxqUktxlY9czNF+cZLlnarbC2dZFqBzjaXLht+vQgFDxR8q3cY9pfjpnqEw9AhjuWb6AaeWcqEQgtrJHDkcQRsIFL9FEDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB2062.namprd11.prod.outlook.com (2603:10b6:300:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 08:49:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:49:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 5/8] vfio: Split out container code from the init/cleanup
 functions
Thread-Topic: [PATCH 5/8] vfio: Split out container code from the init/cleanup
 functions
Thread-Index: AQHYvNVSEnJfB0V5X0a4OzXg8tjp8q3Is3gw
Date:   Wed, 31 Aug 2022 08:49:37 +0000
Message-ID: <BN9PR11MB5276574741EB34B97F7DD6E68C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <5-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <5-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9129a7dd-c098-4301-b931-08da8b2dbc98
x-ms-traffictypediagnostic: MWHPR11MB2062:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jMx2QSFj2kwDCNzkb5vJUYjH+jgjLDW51RX84A+lcfU78awL8Bug8SziJluJg5fqaJ4OBg0Kb5mtcXSGQXczWgE7JbtMAHlNY9IRl/nCm5uoMa05wEL+81pAELw/cIDyiQopxuZvudI1OoDtPr8y1BcrVhQuwSefBynJ4OFbU2pt4bNtOlKL5BURmm4B1j+7qrPvtvSm1BCQ947AyzOWxsqqBn1A95w5C4iQR3dZKl7khQf16V6YzVXRY3njBQUgFHuQctXFzOXGeIm9sbd3nkRTXo+m5jQIRKfQ3gZvg/mKJl0i/bGTXGIxTGL4J+dk5H26hfmVDyDXjrFCK4RYezuXRfkdu92jtEtJIyOwGrkZHp1//naV4nLlmVpGzmu7wKcmvd4TipQRQoYaOmet6oZlWc7dLq7nKEosi1l3lmKJfAA2ap0EZqrDa7xU155LAr88zFI3wUiwrS1e5gE/0O8EMOlG6nluTTTY9knvKZpX8HXjq2x+/x0G1OOtRB9XSU0DzovPUxFh9F9UPXWmEmW3cI+oW6pGQsUhOWvEXPG5mp+5defXr2Yk4Qz7PmyM3Zagz+LMZQPLO/0ARwlKT8vvxUSJPPpCvWRaF53UIbQcJfK9MkPBSZDtSrsYcuPiwRU0D6B4Lf8v4zJCHkVSvVs0XMieT3G6lAdFBXNmBmlMADPDbc+DUb0Df8FcvEiJIaPqh4sloAb+2jRF9cuVARfToqiMDEPlLNtGMS04uz5tzMAdqtdVnpw30vDWHzkL1tjsn50Q3KTns7NBV1bbNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(376002)(396003)(136003)(122000001)(8676002)(5660300002)(66476007)(76116006)(66946007)(64756008)(66556008)(66446008)(26005)(9686003)(478600001)(6506007)(7696005)(71200400001)(41300700001)(82960400001)(86362001)(316002)(110136005)(186003)(2906002)(38070700005)(8936002)(52536014)(55016003)(33656002)(4744005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RoqBXgH9hIa2nj1yWArPy/4YgeHNobp7fP7uEp81ggRQkv401v5h5LsDvqRh?=
 =?us-ascii?Q?kaFNairHHJ9f5RAWndJMU8udAI33s6Q8XdjnkmzpMH2DPIUyNpNh1/Pd8aXe?=
 =?us-ascii?Q?p2cFkuQDgDy2YwMWEGKV6Ubo/qG2yKnAPduqVkugpf2mh77MiF1WJMBsNrLk?=
 =?us-ascii?Q?8tUOiOk+k0rxPOguLPSGzy+qa41RTDVIvv2+GS7ooGjwUWKcsztJMpINm+RC?=
 =?us-ascii?Q?8yStM8TZ5G7j0LHWRfP861eW71NiLpayCBfM3/FRfy07AcLmq28bB3snKhWb?=
 =?us-ascii?Q?C/8lTl2nGkwDuk1BKhQMUlfb7rt12xq/i0hPtfGx3/PwIMNh26zJNwsRTBJU?=
 =?us-ascii?Q?TybrCf5Gim5vKsx/Y8pzy0J5w3Ui+1Ujfkmpr5YeF1kkbPiDV8DlgXf8hpf1?=
 =?us-ascii?Q?q0tqyreHTqYhpDSFZZaFCl8QjAnU4c9XC5S8uW0PckHUlvKEYxASjvlhDaze?=
 =?us-ascii?Q?QO7icLLyoVq+Ky2GemzFBtTfJyi0C5B/hbWgw87OzpG9S+PCxrYCMmsvl1me?=
 =?us-ascii?Q?XKi4bHBtD1b47emwsJMXaFCp3RiYHIJ/jFutwJkF0htzJfpJAWTezA9lFk44?=
 =?us-ascii?Q?pGUfbzBihe28zGaYZ8/OyGJc6Ov59jjSy6MzJdAhq6eCXyHrUXEVAste1axF?=
 =?us-ascii?Q?w6u2WZAHaYa2t3LhEPeMzRCkfz+z7MeTrQAmVf/cMmSHT0udQ4jOt0HDW/MJ?=
 =?us-ascii?Q?lent4bmNFmkbP+HP3EdrkrLsFz3ArPJH0I9XszCxHjmM9WRp3/m9pjcdk7xY?=
 =?us-ascii?Q?455aGJ1LzPmfsAYeR2QL7G8nsZceHY8BUqrJP1l1KMEZ1bz19Ps54hRDLrUr?=
 =?us-ascii?Q?StWQjBloWp0c4E03HvcuZ2hHoH62IgIogdxAUeCcg27mM0d/HXGEWh+Rqt3I?=
 =?us-ascii?Q?PSx2jP8VXwSos/3cgE87SqZ5Xdl+67Fyq8v6mlgALaCv4zN0DtOKeXslGpko?=
 =?us-ascii?Q?mlJyGvEB4Ttv/Ze6PQBTqRSRFYn6l34AvF1iKPTqiNMMvpKLGcTNrnU7BV3J?=
 =?us-ascii?Q?CABaNh/cAuDd2vQBQzFeMrmQRRqEASzxkzSd7J84Dip6ugmi1Ha57ovzxo6J?=
 =?us-ascii?Q?DOng4MaYbVveAysAriwpEfESOgZg+5M628VyWEj2DXHvvsoez6PTmrCaX7za?=
 =?us-ascii?Q?GUTgqt2NVjahtlEuEhbkw/GKb0uoQ0TA/lp2YXj3+5IgQOzpJv2QSjuAWjqH?=
 =?us-ascii?Q?tT59peLKykh8DZXlQw25S0cLXCgeLUj3UygaF4JL1A7iZlWeuHKTZB41ReFc?=
 =?us-ascii?Q?+PUUAyvSBg4alCYMWaF9vaYFAoQ/2SAiCDAmtF+IYYTBFCpMmnsFfYxucMWV?=
 =?us-ascii?Q?kRvA2e7cewki6BIgECt7RcZZ5jDmdF/cqnl2c3cybKwMfPiAz+0F5VZoV/9s?=
 =?us-ascii?Q?Xz9QviXV62iIOB9chjGlxVjwgjUIQzq3I0zNkCEvJP8F51k0ZSNjj3uR3Uo1?=
 =?us-ascii?Q?NorD8CBUBOmGz+dELDzzt1s+ivlGyWKsX5ieWXBNjRezuIYdNT5dV6btkBCN?=
 =?us-ascii?Q?wNGDbwVtQjnPRsRgPQUTr6QB4y5QaUm3eB1u6guqimm8tBeszVDT1nrRD17s?=
 =?us-ascii?Q?VlLIwzJGeZ3ViuhrQutOs43xK/+i5gdlESnWcPNg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9129a7dd-c098-4301-b931-08da8b2dbc98
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:49:38.0105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9hAixQgavpWiaA2nK/MMkHhwoknhRDkLnx5HhCzdC2fqBN+pWcrWvZPGwFm0AUZNWMsCfSoUNtUSbkkCnqe2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
> This miscdev, noiommu driver and a coule of globals are all container
> items. Move this init into its own functions.
>=20
> A following patch will move the vfio_container functions to their own .c
> file.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
