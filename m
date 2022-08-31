Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767445A794F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiHaIqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiHaIqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:46:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CDAABD56
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661935594; x=1693471594;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=8IiV0Cq3jsn9e9zoV22Oi9uDyuftm4Pp8wdY7LpDQ9E=;
  b=lMMne7lmC5yPgL08mYgXSAf+hbp19GoxU3lnL1PfBS4oZhvcbqkhNUy+
   IwE950jratwQ1R/PZ6P/H0ja1jjEL9ZK8hKtErA/bA4CmCsTO6cYOpBS1
   6E82lp67FhLlAKWpRg56bya3qtPZaBVrA+uyJpUs/t7HxQuugScoGR/em
   w6UuOpcvxj+uDeRUCg2+WCU7l1Mx2tIZ4xyW1DJC5dChHXg0ziKXkRwEn
   Vul+fbeEBHvWpL7akwfL1w4uKnXCgp7BdllD5afWWgF7KIj7Nz0cd0fRd
   KPSsNygTpguSOcH11seqKiVObK+uLB1vUfLLA/QpCmrwn+UhKLVtrW5yg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="278421689"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="278421689"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:46:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="645163375"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 31 Aug 2022 01:46:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:46:33 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:46:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:46:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:46:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8+H7SYcxCDt/bJmvm4VOYM0KXrP8m0P/mOpvS56lwLowzE94TlCPQBF800TBHQ30rW3rNYaPKoySZZ4aO+SPB+wQcYkmk5J0zMj+V/99r1+zVNXNzsaP0Zu98nphF/2BIb+vmBJ0JvdjTamm7ckouF0BU1ErrmHJEs7Ag5GISHj5ce87FhmY8FAX7sRB2aTaMu1lOsMFu7o+OiC4rLXofLuc/M/wEluOEk77gFzfJFYOOulO9XEmzQACAIMkldFw10R1P3bFj1WkRpQnDt5SjNphpXwluu/WtE6uJE6rAG78Y+2ymDYVSQMCen+LuijLTgGWBsR+v0kDLLki12sSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJlAFFWRHvIejlkqKbUdfWQtx0c52+9YN3uA8l1pSgA=;
 b=EXhBJeHLMvMuS/Kw4qtdJIDt4vEjHGX1wexjdl0otnm9hN62ZJfZYEAzPaXd7CO8Kr3cN0ajw3ZO7KW6DDyl2HIW5K+GfYhXmVCG2Qv7n+BA4c8AEnZtRVAe9hxKqMm0Ar+Qfty/t7oAIWPG8/YiLcCyLQkNAMjcEhYTT33R4JjLOCNDvldqvmnsDSy0P41Ujok7lXlf6deRwF7q+SCkzlTqmYGmKH/9qjKvEnwtEecbJH7xT70ZmWbrQKcBWp5h4yT/HkMhbYNy72GUBqxlzRTuLn1LytIVWZ3JS5X0442p5KByjy8To8+gntyvsU5G1MuFdQiRizfKIbDuvzDRHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB6819.namprd11.prod.outlook.com (2603:10b6:930:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 31 Aug
 2022 08:46:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:46:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Thread-Topic: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Thread-Index: AQHYvNVSThnzW9KUGEadAxVOclcPZK3IsYPw
Date:   Wed, 31 Aug 2022 08:46:30 +0000
Message-ID: <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: e8147c9a-2601-43e8-39ce-08da8b2d4cf3
x-ms-traffictypediagnostic: CY8PR11MB6819:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WIIxFxhrMDEq5ISfghJI5nqFctQZQDKEbrAzOtIxlHhbu/n+WJl8hGsnglq+BMTYmFvGdxo9Z4LsRDOx19nxodOlXEagbpsKUEbXPNpeoe+Fj8GPvxtMVxhlNa5OXb1ZEf0JlebmXHx/eXmxMhPE7Xlsw+WnAKGTRI/QcGvZHCwdWfvNKzb88KU6wCwP49YxYMB0OBFTw+UkmXtaYGE+04xQAfD+IIgmxci23gM+uQCHf2oIfn41GtsI5RmXMc2IMyMpT5BD68gT2ouPa2xtyxq+QxuZajNkz7a4f+LMWZHyU40zGg/7fzgRDQS2sgBV7uSdMIkiZGYQFJHwqu0cG3sCjiuq4B0T8UjPUh6UYXoBkzGNGSz0x3BlxmmL9P0jqcj4gai0Q0FgnGI8XcwEhbwzbNdMvpTkdwVwoSywWXL9PbY49u5Q8BHzunK6LKo05i+4gc27crZ5nQxSzsAAz/z/3Ohry4ax7jX4gUqrGvZYrRLoINDn3DIPJKrAdOqU8oj7vLnH4bNnd1TmEB8hi9Nx6PO6shd6QwbsiiNSN367KdmHZ5HFuE1PFGmTyCrs6ccppLawDaotsHrWRWOgoy6Yo7LMgcKPcWspCGSeaGStuuku0ks7ozg4Ncu2H0Blkx768r+t0dE3ru8lLMz9vBqMbH+RHWOZUO/o4pmbUzyE4A54uP2wMtFqJzCySQEtLK73OoLqfMfUnSA3++4ZAokcDguXTqyF6X3YIy9FjWnllaNfH/PrpEhKkAsTxWlofvU1Q874tqo0MZNFb0+vew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(366004)(396003)(39860400002)(66446008)(66476007)(64756008)(2906002)(66946007)(66556008)(110136005)(76116006)(316002)(7696005)(8676002)(186003)(55016003)(9686003)(82960400001)(38070700005)(26005)(6506007)(52536014)(71200400001)(478600001)(38100700002)(83380400001)(122000001)(8936002)(86362001)(41300700001)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9g1dxawYObF530i/1mSChUHfqKFrUKTyk2ilkj7PAEfMzAE6x07m5pI5c8Fw?=
 =?us-ascii?Q?sce65RkYPBHt4uKBwIHiOM+NKdTonypwoZ0s0RqTGSbLRP8BL5Mjxq5e76s1?=
 =?us-ascii?Q?zsXllHY3Irk0DHv/ks/zZw2lQ5UM+VlIIj1pjEa8fzQv61ihIb07ABNNqLuB?=
 =?us-ascii?Q?GPyOaR/VSukZ0pTUHCiLj6Ey3N3ZSxr7n9pSuDroX75baracRRSDzdD72FL0?=
 =?us-ascii?Q?0n24Wn/Z3sy8q6uXuYIn0seAwfxY1CtyXm4TscbFuou54wrfSEogTz5Wy3dc?=
 =?us-ascii?Q?wsfISMTYpiDBIXxJYrWEJDPCCCxCP1D7FiB1+9kRBvXmFeprE3onrWpEnY/o?=
 =?us-ascii?Q?KSEXjiYO0EjBBrHBpZ+Z/f+035Idi9pZh+dBedt6xspaCFPBPMJCEIqBVwto?=
 =?us-ascii?Q?mI9GHF46s7XSyoLjUsv2bbyL68eYUJ6p+3o7Ey5xQI4SxWiwUOJ6FxQPPqcd?=
 =?us-ascii?Q?8rg4JzQSVIEU+NOV3iednBsrEvKhgoDCt5++tOokPsXQ0hmFh99hOY+IlK0P?=
 =?us-ascii?Q?iUwsAIVfxFqwLS4VNd09jCS5Q6btH9iNfJ/bosKAQbmK9XqHp/pVCOiAdADS?=
 =?us-ascii?Q?odQaRC4PoOBCoTiJ5r0oeEkIYGXAMclEzfLhkU5Wt+aBqqodI9AunXnIQ+uV?=
 =?us-ascii?Q?0mmj1UAHWdb/B2IQkY9zrjJe+5y35JgTrHVj7ukSb/s93A6bYu+2tztkoPyj?=
 =?us-ascii?Q?jTi798woXZpMaYN4i0DYi4OsGU+HHkBYhVttk2cuIlpXgjiitOj7/P77r5Za?=
 =?us-ascii?Q?PDi0zKhOIFrD/+3QJTWKO5OAKAi/f2dMYXZqtpJrn84VPjpgK9t9I80KW7FD?=
 =?us-ascii?Q?0YOoQK14nzLYUKwcBeZWrCZWD+OqVM/3jfzy8JLWdeDM4vTAqi/dZwMwP/cs?=
 =?us-ascii?Q?TyaKd6cQkaaBW8hbfWuWtoZC8ZvL+rw09p90ttu/0VEgw0vCnIu/ZUudqop0?=
 =?us-ascii?Q?oGGbkIbj/qPXDtDhqJV1NWDm1SjUwLm0ZcsKnoh7w/ZyCWMcGAGCAENj4kRV?=
 =?us-ascii?Q?+bL6SZz0VlZgtMWtLgdO7RIr+Qbu9jFLw9Mw1SqTSIwqicL+WB46reQYzZr+?=
 =?us-ascii?Q?9lkF2XabQ/f4SGlwXFmwFp2yVy8eIlhUyxjKGUbJyC9pLjcq8hXjnaknzRo8?=
 =?us-ascii?Q?VtDrYn17VBde2t0NUtSonBvcuA9BKkOqqyl+y2XPty65Ft0uHohsnjvcCIJn?=
 =?us-ascii?Q?fwgNc4uSlWhXroJV2jID2/FxDXke1H9WH+oGjml7jyyriYjdMhtK6nO8gbil?=
 =?us-ascii?Q?CBql78h/Fo4VfmrksSOA+yZIT3idB52moIAh20Vr3jAfFSfee9AWRiAVE8p1?=
 =?us-ascii?Q?rrpBhZvgq9NLiM71QbphcyjTeXw6wjmn47LWOdeOkKcTkHrWNNmnZxZ/D1TM?=
 =?us-ascii?Q?do0SIJ7POu6dZjaliFg7KBwblJw2+XMsqxiGraS9fHdDw+Qtw5ZO5aPoaLMf?=
 =?us-ascii?Q?bjGl2SMOv8I+DDvCQfTp20Rs95MObWGDlKrN4ldgh+4jTxOiSDSkqV92OnEn?=
 =?us-ascii?Q?JqcqMMV3UKDptCgcKP5RgFv/IaZZEX1IUut6b7ZJQRvZ3js1D+TaPtQ37EGX?=
 =?us-ascii?Q?x1sHeBo6r6PHQzbC2RvALnfKb5fRZWKaoSMb0aiC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8147c9a-2601-43e8-39ce-08da8b2d4cf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:46:30.6675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V47UNMYxttyKRjsHbZ4S0dwZDA8biXqb53NIRzO6gu4TSnWXjgPCkMMtHnq7XVCvF6Vdzna6TQ1TR41XWNCmcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6819
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 9:02 AM
>=20
> To vfio_container_detatch_group(). This function is really a container
> function.
>=20
> Fold the WARN_ON() into it as a precondition assertion.
>=20
> A following patch will move the vfio_container functions to their own .c
> file.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index bfa6119ba47337..e145c87f208f3a 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -928,12 +928,13 @@ static const struct file_operations vfio_fops =3D {
>  /*
>   * VFIO Group fd, /dev/vfio/$GROUP
>   */
> -static void __vfio_group_unset_container(struct vfio_group *group)
> +static void vfio_container_detatch_group(struct vfio_group *group)

s/detatch/detach/

Given it's a vfio_container function is it better to have a container point=
er
as the first parameter, i.e.:

static void vfio_container_detatch_group(struct vfio_container *container,
		struct vfio_group *group)

ditto for patch7:

+static void vfio_container_register_device(struct vfio_device *device)
