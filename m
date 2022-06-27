Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279C255CCF2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiF0HpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 03:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiF0HpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 03:45:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B010A60D1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 00:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656315908; x=1687851908;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DgErZk8hWpG2EOkSeAaNIH/us/EfCi7kHTsouLg0pMw=;
  b=iGLo5JUfy66sjciXnlSyT4Jc31qreFS8r4bVJ2d931twTxF8Q6IKJxlR
   shvH9SjUT3Nrz4WiHhJI5cjR2p/1Dk9Of8EThfNFaOmlB4v5UMOsNtiUA
   VSGxHzqGMgfVczAMqKnUPF8CiZkYFtySJEIPwIV7c4ibwTwRUtJKLGS3v
   YgOcqrG4fbZqG72QogYLV5TYycf+F6RysRamqIXSqdqaf0F9PmHb6XEwS
   pcg/culPT8pnDISxr08Jsg3ZF54MU9gHSMAYmQnFcid0mNUCjUzjHZLSZ
   1e0IxtbdekVZUHB9DcPFZjGHIMUrRNmP67+0vFoGY/SlkYzpxP7P2LVxN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="281427524"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="281427524"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 00:45:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="622470066"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 27 Jun 2022 00:45:07 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 00:45:07 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 00:45:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 27 Jun 2022 00:45:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 27 Jun 2022 00:45:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwQWD1L5u/OEAsru7chc98vpyorF6sb0PLM4QAtUJnXQ2tDnvbB5o/hJy3jOc/MjMje2E8dMNktfF9SqJQVtsRJdoqz55Hd2B23Eg8cN6TWkGpCai2xSzqsIxwZRB/PmKZxJtU8LNPL2pu4nOoPFEnwscpOBDWTfdonhYWzMgR98BFzzSbwQq8q6M4DGQZmGtC0PFeeONrF0r8Kt8+bPv2Q2WsuGRBktTOxx9Ygw9STg9D26T3INrPRvTCFejJ67NnMESXpuhacXmjWpJo2P11GYRjTMulxQvlreoLNJVwXbHWRTpDWkISyX8WS9NxtlrNesKU5e0LK4xh8cE40T3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1K3w+NzEvxg4Ba5QHveevkirH8+KNv7USRAl+Gt2Vs=;
 b=LvK3ZnDRCc1WsesynQ1I8mBhLtycbxO7+5ZIkDoTi2d4VCmzcrU1/UaO96XSNZeJrws5mLetMYitu9EEcE8okKV/uW/KLaPjkNCUH7FweDLr75YKJYHAB2oXDFxRufYDvcAhA8pFlDP1AeMb/MAJ4DAHEbu5NIhLOgiyGPoM4Ae+wiuG4n+J7toJBC9h1k7PGTlyzFN4Luosv1DKjx5qE5C8Zn/vudgAfci43Gjal37W+VGKCYjf75Oy9MRZh4ZBmlDRCF68IdmqvUVjClhtoNO5EkZxKthOuRpBOcG8EBfYCGb8WOfx8lFmhdLKekHnxFceW08XMw0AJK0CUVAwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4992.namprd11.prod.outlook.com (2603:10b6:a03:2d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 07:45:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:45:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>
Subject: RE: [PATCH V1 vfio 2/2] vfio: Split migration ops from main device
 ops
Thread-Topic: [PATCH V1 vfio 2/2] vfio: Split migration ops from main device
 ops
Thread-Index: AQHYiThx7fvX/oAeakGsYi5glvcXna1i34NQ
Date:   Mon, 27 Jun 2022 07:45:04 +0000
Message-ID: <BN9PR11MB52767F6751DDCAA7D38734788CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220626083958.54175-1-yishaih@nvidia.com>
 <20220626083958.54175-3-yishaih@nvidia.com>
In-Reply-To: <20220626083958.54175-3-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a976330-84ec-4010-5049-08da5810f337
x-ms-traffictypediagnostic: SJ0PR11MB4992:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MqEiXaXnvT19EFLbWBql1WQWYzktYJnKoqcZNF17rcXPCjvcOymKay89FOQCBBfwzrzXUSOVLFqM/EIPUzZCP5Ic9S+0ECnEo53ztQrRb7j5ckxdYvl0KCLmaeMv6C6COPwkxWfK0ALaPEL5LOT9UTo1JW2/fkbwFbRZ0wrStlwSktggZ51oaYPbaMIjY+EWkfuexrjklIpKB3iuR2gkHpLpqpUBwT8Fg9LyoRrebKjgKcynCHgpM4ejJT5e2GMgv6qBDpKVqgFHHOM59cRb4kU+Pjcsb5jDtq2Kf1UQrGtRIaU0A3ZURK+HJLIfoA7DbZ3lR4wZhXZn7cwtDLJC3/OBtYR/5+TtZR/UWRuAwmxc6vgxzeaRqA0vFRqxv2LruVrIdHQnLFWbn2CyGRak2vIe3jRYxBFx0N92gfJoptWFb9p3Y1Bi8J2yHagK9v3TgTsOq8cJswzXg4oqxbt+gx1gIrbxYvzDzL/Ikeq/K+CHvadouYSt3qOeFG6/CdCTyoAGFnJGPSLHCMm6ZX0C48E9aeeqXWq0KQ64HK8AzdlQU2JeVk7BlZJY1zABZ0EepAuCvx7/8DFljRllEcamXgqZ7ElzyuH0Umv7Oqav0v+Ej013r9JLwQOGucctouXkzTt6t/HBG+jWKZuF2cuNrwhHmLHg/+5QNmFMM9zRvB+MfQyZC3yHZuHxB9VlzwpYnUXJiIXStnZTFlcsPo+ZLiGSXFt/MLZWWg3TLOAutFcpqrOi+1Ot4r0EgFn75yOfXlzyrPn5G3j47/bzUgCU0I8pwMnh9j/Zw9BHWZp1d24=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(136003)(346002)(76116006)(26005)(55016003)(6506007)(82960400001)(8936002)(9686003)(7696005)(110136005)(66476007)(66556008)(71200400001)(52536014)(86362001)(54906003)(66446008)(122000001)(64756008)(38100700002)(186003)(41300700001)(66946007)(4326008)(33656002)(38070700005)(5660300002)(478600001)(8676002)(4744005)(2906002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z9LE29wqz5dph/RCmum4O7blZcIbmP+z9kBNV/nsM1es8IHa74QvZ40v4AC9?=
 =?us-ascii?Q?qOayHHOKIyq9iNyu+trq2FrqDpHbKfJsWtuNWB2uHcLc7sby5FTo2LiZoXuS?=
 =?us-ascii?Q?90Sje9HpqwXsElmRvjRgAhXtPpZl/TJK8ZoCXeZg81v0VgAzBP78eCDi4D+J?=
 =?us-ascii?Q?h38mWho6OZSSzzUyQ73ugfPpB0erYkJ6DgH4eXQczok0QJzgTRvgaVZb4NXw?=
 =?us-ascii?Q?7yEZJG7qP5DzRxkEJxZBgK4WNiTRl2PTyK6o1OGUrVquiAzHII2Ww0axL8o1?=
 =?us-ascii?Q?F367d+RO6y9KzkQpcroALx8QjLjtu76oqiiK4TEnffTc2cGzdy+AHvs11VKV?=
 =?us-ascii?Q?Mk2MJsst+FapOY+my5JVU5gLUVj4QbjPIQJxCu0/KTAzH8HmbJU1nI1t/jgB?=
 =?us-ascii?Q?Q+2UZylFu5oLHwNqAZ+JEzjhthBo1RydxrOKMMx4j/JTJ4+1QVDNxJphNlss?=
 =?us-ascii?Q?oiIR26YRE89T8jpTVL7WzCdCdu/PnYCV0dO8XX4Lot8xpeo3cMsqVwaaTo/U?=
 =?us-ascii?Q?ddGrfyqPJGZgiywfJ9j9KSptRoyC3PRkCCyMNsQh8LIt0IxbvonEE8RUhuYG?=
 =?us-ascii?Q?39k05+wPid4KiNim2j3jUC+Csb1cTt51OQCcYjeNAhBKWvT/4ZqXzRb4pW9Q?=
 =?us-ascii?Q?Hq0+B5KddgfrkI1QeTESYHFU6/2dZgiNiWn5c4M9zca/oifFvxhJ4rxHCJCf?=
 =?us-ascii?Q?u3u5I4hQdt2rZnsG/64tSsUgWkpdzoaB7g2OUvMfUbxulq86BVlNxbfowB5E?=
 =?us-ascii?Q?8t8xtF2mrWHSdR39BkPtAKSYiWNiDWq8XptlhDtZ2Q3yK+oEFcGs6fWQP5v+?=
 =?us-ascii?Q?1HuFomL4X9berGsj2tSsm5z4YQBRsYK/xvWiJj8lXwbBq+5BRIkuqet2GjHz?=
 =?us-ascii?Q?0KeJALYhr5Wku461LJHR+cpLRf9EI7OScIXZ1vaaK8QZsoSniH7NoGmfeRa7?=
 =?us-ascii?Q?zidaMCFGtDJt3rBU5+Sbq/r+KkYxSCJiqccXZN9kkEVUO+tNAgwrn97103WS?=
 =?us-ascii?Q?RYWIyLcjlhovZCjwJYd8Gubl1mgQxxoUGhz8dK0qCx3ZVewwEgyFvULEb76r?=
 =?us-ascii?Q?/x9OroJAZ3x+q5fEly3NyYGJ0dssZljbw4V4L2MkNlL+ummwTaAbu5U3lV53?=
 =?us-ascii?Q?oU2LMEePR6SUO7HP2V/Wf7rArSQ+dKexF9hx+8USVOlxEmrHorfBJUp18y4q?=
 =?us-ascii?Q?IRcDUs3F6W24UfFqPx50mza7QUjE4Oelb1N8Q+bkwycupyJZmbu8PWB9qsc3?=
 =?us-ascii?Q?jkqxSBwrWasH4YCmTmENiDUP/5TBbsIP9QFtzprldg6x91loScEAXjb7QEVU?=
 =?us-ascii?Q?RMp7xtEAsmKyG88noMMHJPnBltc2WQAldzWARWBXVA2voJhxBFYIL3Kqn+ia?=
 =?us-ascii?Q?b2t6TAK5M4x1R/Tm7qI6vzdtYWsWW+j+relpNSjz+unP8ZDL4cDWPXD58/jk?=
 =?us-ascii?Q?IWJnJBZf6C2Yh6KsEPbCioFWJjA1aWi4I/hxHPsNAD4u9WLV9mhNFtd7NNCx?=
 =?us-ascii?Q?zQm1U6spVT91pUG8SDTAX5jXSOVY1DiJ8jUX0raAUa2OYpBsw2oOmSg1TJA2?=
 =?us-ascii?Q?mdaf2GS67kLesMEcqG/VX/Gwy3DL806TIhip/Fam?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a976330-84ec-4010-5049-08da5810f337
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 07:45:04.9243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JIUsn/zxeqi9AV7Am54XxnySFvW6DOscMXzNwZe0tRfefPUSxglP+bcOKvPnyqokj7f0EqxNpZWzI3YSNyL52Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4992
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Sunday, June 26, 2022 4:40 PM
> @@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(struct
> vfio_device *device,
>  	struct file *filp =3D NULL;
>  	int ret;
>=20
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops->migration_set_state ||
> +	    !device->mig_ops->migration_get_state)
>  		return -ENOTTY;
>=20

device->mig_ops could be NULL.

I still think that it's cleaner to do above check when registering the devi=
ce
while leaving only a simple check on mig_ops here and later. While at it
you can also include check on VFIO_MIGRATION_STOP_COPY since the uAPI
claims it must be set in migration_flags. All those checks can be done
once at registration point.
