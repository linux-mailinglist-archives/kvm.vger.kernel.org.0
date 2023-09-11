Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C7679A34A
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjIKGHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjIKGHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:07:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF5B109;
        Sun, 10 Sep 2023 23:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694412399; x=1725948399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CGutJeudvye2h6yhfYkWn7qfQnkIYSgdxbJwl/EFxK0=;
  b=D5ECFH2rQurINm98UfHIxN1re+PAGoo3BIcBgDpVqn0nle0FnkFg07C5
   wmPWA8RJ8Gn7G5Z0brvWRIowQv+h475blkgr8j7/2U3+YvGhyP9YdAjFb
   LVKl4vK44iAOySzKY2K7A0jVLfAWb5MAqtx+2VnFQ9WPfCVlOd02Ncgli
   +TQ887w83DWFtKuZ1Lth4l3mTK52mV67jGR5aPEybBQ6zme5cPe4a5OEa
   JMiQC+RXeE3muqQ8VCZJ+bF+HBJxCROF0bp/qSYk9c//3J8o0n7J0DjBd
   02jaitYCYboneEz95odN8bvMWvWk3/OAuDREfDCsnmM/JiCmjHLjs93RI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="444419867"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="444419867"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 23:06:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="989966398"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="989966398"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2023 23:06:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:06:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:06:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 10 Sep 2023 23:06:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 10 Sep 2023 23:06:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApL/YiXjRh3sOolZ8jgzZluYZWLE4JXqqVXw0vwlrjEoBWRwxxPs7KibRR+CjxgWT0YGEalZzQLpVV2mw6m/erHO1vs/V7MTTYbmUwcB01Fyj/bKW9bRYRMqZFHdKMtzLKXGWt1JuiD4ykJO+I7H/wXbmAo9Xv2nSprbLUcZ7L3H6vWSsggkNlrW9e8g5/bDyrW/nkK2SOujL/uTNPoogwywpMqZwTfRS6rPGSC6zS/+iub2iJNeFkzk5OTHW8tE8gP2O/3y5ItTvh/dsrGywocCg4miPXDvWnzpTG5OEr8yjfM6/BZ8JL0VE5VTaA9HIF2F9b+YGaJ72sivTxUZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGutJeudvye2h6yhfYkWn7qfQnkIYSgdxbJwl/EFxK0=;
 b=nLTWjEmsKj1BgafHj/nCTOufk3fNOrEoeVcn1uvzYaTS1Jh/lMq/aoAT6YGuBRHRYd/RQIk2YnO/A3CkpRsfkteKvJ6gANj2WxazfcxqLx/E6nV6WfpLQlPee2WhIbQnuOIQuxYsPPYb2A63chzVPzH0YkkrZKXhblN5FfMySRm0NxRAHRG1lS9PBh47o/NtdT0+jTX5coYMhhBCUn3/c9TP/QERAtoNA31zoSap5qE3mfu79zR9LKW9NvRQctTz+6e7NDfU3Zy2xE0H3aLicUJmKxdSHO6DZjEgeIO6DZf5wjJ1ivOY5AyyKD8/jnYUxpXBbJJCAsVIE+ZOAbREFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB5989.namprd11.prod.outlook.com (2603:10b6:8:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 11 Sep
 2023 06:06:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 06:06:35 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v2 1/3] vfio: trivially use __aligned_u64 for ioctl
 structs
Thread-Topic: [PATCH v2 1/3] vfio: trivially use __aligned_u64 for ioctl
 structs
Thread-Index: AQHZ2qa2zQRqbVx76kGQl1BPbC1bWrAVNtLA
Date:   Mon, 11 Sep 2023 06:06:35 +0000
Message-ID: <BN9PR11MB52766EB0B99F292DED0C10588CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <20230829182720.331083-2-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-2-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB5989:EE_
x-ms-office365-filtering-correlation-id: 632b1468-4d88-4102-4dc2-08dbb28d4123
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9jw21XeZjVcxEWX/LhcH2kzam1rbQJMGdUsltzg0cFmRfpM84v7leaNvEo4RWOAmd6Fxs3rwFD8Z6IrER51ux/MtjJl1NgUPupIZh4FZl114lWVlMbtLdrC1YCLq+kVjPZV0FeVDP15GwjYKhUhW7/qlT3Qju8LxZFHF4kQuVTQMvBT/qsCSXTlzye6GI9mhVGsMDye38RtUfSwgnKtOBTE1wAqoD9+iDByvcDVsxuLCSUG0N6M8X3ucX3V/pR5FaNb9KgA2GGvvtwzWlJywgzdQDQLD3hon1Jz2hDrooMESm8MH+KqwXyaovtqmyA6C9S5spM8m1mzJEiXphZ4rW5pJFoHNGP2YmARUxpvKi+5gKostVBCa12ezLgcusXrwIpij9p77FJUQ9ifHGeNGOJ8/qtJLXjc3nlkIRwXXVhU9eHJpuQLCoO+W52AoqizaW5ZLiDcoDW/uhZxThMTQZ8N+TCZh30Pk6wqnWzqyzzgCJjVLWlJcj5U3xgGBmZ3Moxx5rEOFVpDYMpM3HVri2cOySzBcpbDChGgWYJNuP9GY+E6KaSh+eObnnovX6OVvL79IzC5x+v9XAVnMLh1A9dnorGMEuAvoeytGEonliGWGeUUanlPPl3xIU430OMs+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199024)(1800799009)(186009)(66476007)(4744005)(55016003)(86362001)(66899024)(2906002)(8936002)(316002)(41300700001)(8676002)(52536014)(5660300002)(4326008)(33656002)(26005)(71200400001)(478600001)(122000001)(83380400001)(7696005)(6506007)(9686003)(38100700002)(38070700005)(82960400001)(110136005)(66946007)(76116006)(64756008)(66556008)(66446008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OzIfnsZ/Ivb+A+ps21JIVv7Cxp3N6+yfkdIFTH0iJkkwiwrZa8m4diGYYrpx?=
 =?us-ascii?Q?+lNmv+/6jy3YfODaoTaZTiyLifcJTS/tGv1WYjHvKKYRfC5h1PH49N/kqJGt?=
 =?us-ascii?Q?V+rfTd2JO6QFUcRBzh/gWlIEaz3CHozZ7nPYO++fDmTdTajAZ5fp0bwElOTy?=
 =?us-ascii?Q?x84G3lyC4C47Xoq89RgLYG1zAtpTAVDpE1IdNEOjmMl0ZWy+wcgeO8SazAK9?=
 =?us-ascii?Q?kFlHrqAs0dzV5RcmXnO7swxP5DnKJWH+COUr57HZv0ODyufImE94zvJoGgaS?=
 =?us-ascii?Q?FnrRSkKVvTCW3KtN5ONa4WRcMUtyO6twPPKTZgl/mNWvCZnxjnwJY7i+xBSc?=
 =?us-ascii?Q?Inh6+z5naT1EjHNHReSftP0nar6ksz9PX8ZtG+55W2hEg/lgiPaSEnT0abSZ?=
 =?us-ascii?Q?c8FKY0Gzlvg7Or1Yy2pht5Uxp/e8++OspQD7C6crOmrmdwCRpQnOhSW/KVXC?=
 =?us-ascii?Q?mbVZT+D6JHPAEZLMO4c3hRcTMDBsM7bj/P194bjW5siTlxY0aYOJc4O3Wpg0?=
 =?us-ascii?Q?+zkrgIo23tjOSBqzSQuQKwLYKJobkRDpqqMX0i/F8CMCHd4z3IxH5Zn3eTBg?=
 =?us-ascii?Q?CmCIFUZTBNx6UzvR5jbLZrMe4lBR/AySfM03ITs8pekCBGeINcLzLS3nzg5g?=
 =?us-ascii?Q?gVMKlnTRRxBymW1l6DWK+Jao+QHbeeukag6XvVOwo0dgcayCHj+ICo60y0EQ?=
 =?us-ascii?Q?wc6ZyZ+4HuloXHBvy6776VOXBI7p4JypTyikDWsA1SFkERIWqV/2LQrq1uBT?=
 =?us-ascii?Q?FB/QMdBFfXLULA8cQKmDGpGHB0XIVWXZ8I5Tj534NOM5E8rbYb8Fso88qps9?=
 =?us-ascii?Q?lAGsM3+T/5M1gRosHo0lnrJCBTzhsGLjW+TrKrzOmLR+Igx2WY8ma3rNyh5f?=
 =?us-ascii?Q?IbRPtnsKALmGYlnsvRBKE4KV4wvGeq1i44pqhinrua97htLSuWT0BvlcYreS?=
 =?us-ascii?Q?dVqAKMx1MWoxZnoB9hSj3ia0zlwPQaPkLkdB5wuRFpjy1CTYhAhtbCBLkptK?=
 =?us-ascii?Q?66TS1pzxaOz6D/SExU0DYleyDXr+xVbQOoM17CsqHRKwBwrqsb5dsvPUgEHS?=
 =?us-ascii?Q?bGO+JTdGVJ2huWa5zZZHgPgvQJrT0TpCE705/z8nD0J1vgzGTmQBdU5Z5HH5?=
 =?us-ascii?Q?i5MDH93szwUNd8l6cJHKeXvWS0Ik3l0K5nVaBcROrCNfxRBm4573ma/OuqJc?=
 =?us-ascii?Q?FpWMmYOgwp9ANBpX7Zpy7JFU5OUtTVNgdMTGvKveLB23B/Q1CQlyZoOyEn7f?=
 =?us-ascii?Q?R8wFWmGyDd738kwcXWrlHxX2eDNfOkv96VJyfj0wY/g2Y26+gcAVy+i+A3Gv?=
 =?us-ascii?Q?qmN9w5oWIMrjcKelXqug/1KtsGyGtYBBy6gnRAkgLa8GYylzlSXPoeQ2kYxs?=
 =?us-ascii?Q?bsPMglSE5m1EnOb13hjowFsLV7x0JLJV+snI/ZyySDdeSROvYEVDTw3RhIlp?=
 =?us-ascii?Q?7QBALJ3WLkCuwC0OW2NzG7mm4P8M4/h+YSGK8NekUbHTQ5jKf5L5pm0ueuoY?=
 =?us-ascii?Q?4HcXOxFyzCEOv8cGRhM1YQ0940YgF105UgaaXhujuDqGc+PRqZmmW24tKLYD?=
 =?us-ascii?Q?KrhIKS/MPY/st9/zp3E0EjKdncJX6mvEvzF8GxYM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632b1468-4d88-4102-4dc2-08dbb28d4123
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 06:06:35.5851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KGYxDKYV33/FVTVsoIMz4CvnD+MARqQM9xmGaJAUbTTt6XiGSURI7pj0f/lqOs16aDFJ06ntrZ/t3Yh94aRCwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Wednesday, August 30, 2023 2:27 AM
>=20
> u64 alignment behaves differently depending on the architecture and so
> <uapi/linux/types.h> offers __aligned_u64 to achieve consistent behavior
> in kernel<->userspace ABIs.
>=20
> There are structs in <uapi/linux/vfio.h> that can trivially be updated
> to __aligned_u64 because the struct sizes are multiples of 8 bytes.
> There is no change in memory layout on any CPU architecture and
> therefore this change is safe.
>=20
> The commits that follow this one handle the trickier cases where
> explanation about ABI breakage is necessary.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
