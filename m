Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B35A8B5C
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiIACUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 22:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiIACUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 22:20:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC8565578
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 19:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661998829; x=1693534829;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=u/zDTO6X+UD+yaSaUcGfR932MmCR2MSp3Rd5UbBh8jo=;
  b=aaohJIvXK6zSeflIQlv/oL4S5WHMSLrrc//zQ88LZu9IpBMrMNZ0glBD
   qGKttuRY3vqoTh2iA2rF2AkQEYmlpe53XSj/hnpHug7SHhakV1Fw8YemG
   XA+X+9AImmvORhiXAAlpWgy28xyBiKvGT+arMkLASA/zofWIk5k2gqD2E
   KO90bOW04DqDEgXWWFK0yIBRXraBHPCzoFak9/ar7l7PXbMGVu/l3KtBO
   SJckooZqyoPkGXzorwIjJJjEkLCZFFl6XrmU6VRMSNVsIeZFsUvv9EFQP
   NbUAz8ejzMnRPyT9mdCmYZ/B9Bxy/2b08p5iI+c0rkP0ChebVYJvZgoTj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="359558011"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="359558011"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 19:20:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="615166167"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 31 Aug 2022 19:20:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 19:20:28 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 19:20:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 19:20:27 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 19:20:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MujrT6B333D9TYDR/cFxEp/Uv8RsPuGrZESFbc34Te8WmC//ZHuSD/6ZFFviF1jWptuESHZXhYz4j6qC4C4Jl6IZ7tz0FJQgvWn0IczYv+Vj3jihIIrEc1j5+xhHgbjZJ2yFEGDcKMNOqoTnw/hTP7pwIWtH0LSSrCw4zyaQmmBMKO9JFvBsDKrMq9JSElbM/NKw0Qh3SXjX4angAcPIPmGX2JOfVZGvWfGCOAAXYosVhXH/9RHBzqw+lJL+e4F/dT5QI7cnWhOoIpRtKPaa5eq7H7zCzIdF0jPlpKnB9rw7XG11AmEZyg/zCB4+AiBqAESiCuATaGj6GfNARnZQIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/zDTO6X+UD+yaSaUcGfR932MmCR2MSp3Rd5UbBh8jo=;
 b=YkcG8mluHVSRUT/TgbuLivG9jszuHbVlmYWQ/Ei+DJ8O0dcBlri2oT8Tii6PhQDHs2m47rBFJcaaX3C48Xi/KhaF0uzLXQxahxLQkMSXYDZ9Fbhiaz9WBEGWLGEvO/4GHEt91XuYpR17IFxnx5S3XnyU86EDbF5rZ5CN6BQbV6lRqTwkurgS9Mc9hhYMf6aCgDlnhJaKyONrTVNlqcWeZhoJV4txrGDwSCoKJny894wWKdM4sJGbYJGFtXkm4ubzRsIfgcboec8xdj1kQs84V8IFL+g/w/EOqx3uc893+DeK5k+hbcodLcYJMf2lel31fZY7umbscZ9tnzpFLMp5tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2627.namprd11.prod.outlook.com (2603:10b6:406:ae::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 02:20:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 02:20:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH v2 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Thread-Topic: [PATCH v2 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Thread-Index: AQHYvXaNSDyEcVaFMEGCU8mYD/S8Ka3J18nQ
Date:   Thu, 1 Sep 2022 02:20:26 +0000
Message-ID: <BN9PR11MB52761030BB5F60ABCEB9BC728C7B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
 <7-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <7-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6d3094f-cb3a-492d-4c92-08da8bc08851
x-ms-traffictypediagnostic: BN7PR11MB2627:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: npnsz6ZcMyqMbi1WvZ10Jx+7lqMEMTFSzrsSlKRewV85DJ9j9PYczvzOsKQA54igCa8ir1t3DJ8fRlbHIAvYrnK6EyXp/Gugmm/qwq34DBlWlJn6FEd30daZKxZt5Byun8RnKPS/UF0zgKehnH/7s+/NbRkKCcjP7+5alAHjUBybij8vZri68wiWbk7I5RcpDCZ6g+Xko565eivme4xRm7US4wldi+Mp9bahkJWb65250Tcq0fbVBenpTU/4iR7zgGR+zO742G6j9pUDFVziAehVswyOA91NdR+Q1BlgUcGdPbi5nXaBGBT3qp+R7nnUe5FzV7ju8/ZadYsw9/mcZkFxCFCrDdnnCqfTFraLvpYmG8dNFWvucMxRumtzSr2HER2eOXLYMEvwLp/1EO+stD4BO/VDoMEM8R0MAnEMVvSOxReSh3J/9SwlhocpDKi1BmblDSFw6KiSkOlvox2phDSlfNAUTQKnr5aJDnWprMmY7B2VCSiE7IF5gBlVD21hycn9czDOl6tySLbOd8tn2CiA/e9pMKAzT3aNWczKcJ0zDkGHAPzP1bFWqhgJjHQEowzHQPjvCbOErX0wYyoT9otz1Dn9qpoVnXkrmZyqpPW7fDuB8LqMIuro0Y41UUm5fS1hVBObPAy3tmlkft/JR3EKj3P3nm69J1v2IuvUHihOajQYhX836Jstlr5vEZiHmorPd4oMc7PaV6PVxDB0aorFg1GlIE/HrUlLbnkRoIYgAivywwaHJflEYEBqjqKZ+QvhHFHBOhZ7V609SKBzcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(376002)(396003)(110136005)(66556008)(316002)(38100700002)(83380400001)(71200400001)(76116006)(66446008)(122000001)(8676002)(478600001)(64756008)(38070700005)(82960400001)(66476007)(52536014)(55016003)(41300700001)(5660300002)(8936002)(33656002)(86362001)(558084003)(6506007)(66946007)(26005)(7696005)(2906002)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NKDCBAR2fX8cCsxlBhM34rc9OyqVHti1X3uHR59nQgKXJ30jBXTJjLPQ84BL?=
 =?us-ascii?Q?4JznMnjLMsygJ5ZCReAkX65T1g9T/4+ZvwQmO9eLHWPCK9fz3PXviyqmoaKE?=
 =?us-ascii?Q?kof0OClxYzT2h6Fhk3ROmi0BB7Ycl4nw1EZPCoP3XdzVNghct0tYycLvzyS8?=
 =?us-ascii?Q?lhgt0pLvqPaIoqi4OUXqP1LGGxHO+2Mz1mGqBVKQHfMW9b4LOV7X/APSIw00?=
 =?us-ascii?Q?pxA0tpnbTPg36okDZgxXzJv0vTJkGRehV06PiYbjv0IltKczw8QHo5r6jYv5?=
 =?us-ascii?Q?2P4ezJQDuvvSngg6mCEHRV5N5b02n3zo8lp1XNtkkVGG2PuGsSpJn9iu/lb3?=
 =?us-ascii?Q?qc7p+SSijTM1UW7FCUgzc6VLvFHgKZD3O4qQGxTzy4enhnSm0LfBoUIjrWKf?=
 =?us-ascii?Q?PaFON6q97QglCJeyPxJDTVzwhyENY9JcPPNGfWpmrnnM+EgqfbqqiWGyElZO?=
 =?us-ascii?Q?RQZXwvZjEOzaF09honHs3mESdpxxYiNPJhVkt9viO+9A1Bcu+OGxZoeaRt9+?=
 =?us-ascii?Q?wXrSVDPv68euIaHOA8ZmsEAmhRhsZOyUpWfVrwa8g9pWdxYSwSzgbtAN4LoT?=
 =?us-ascii?Q?8UQX/7QnJspDzWyi2tzyeK1K/aR6MmwcWR02yUQWzX3X6sEjMs/VX8KVqeWP?=
 =?us-ascii?Q?NPken5TN6wDaVN6OgTj0Yt4PIy/XfsxR5JQ5FIE1+ywH+H8y6cDzxtZ7o0tq?=
 =?us-ascii?Q?r7Soj8WHVTmsDNjzoeRUssGg2e7/4WdtUJT9MUv50Vu5lCi7A+1OjyAKsqEU?=
 =?us-ascii?Q?iyd4MvIO4nYOTQnm2Ah6FXmsyyDfqDm6qc+aA3S4ZgEOyhoQAwH/yICcq35Y?=
 =?us-ascii?Q?XaHoAa4HLVQhuu4RCyCuC+Bekw8icvq+sDIFicp/nMpeLTuJEN8eiYF5GtDz?=
 =?us-ascii?Q?+k78wW7T/fg8KFcbbpTk84Hif1u5NlLrIh66l2QQUp9+q2OAu6PSurrUM3YU?=
 =?us-ascii?Q?DK/IiD/vr6As4otv0ogzk/+JuF6hufLC9Yu6OeU/8vmOHyDedAtSBo0mP4Up?=
 =?us-ascii?Q?NIgDTDkSRN/qupOTKk6iCzaLvL59ZjbZ0fNJDQQbuS4QkhloDF4XVyDJ4jaz?=
 =?us-ascii?Q?uRclf5MxoMNF64OpvzgawuE+lJMGdrmSL7knz73Ag6T5cJ+rl+LnUMG1pMJK?=
 =?us-ascii?Q?KGVVjnU9P/JN2NU24EuGsEuGEvShFPOiCiJqjjJWBQ5o4h4zr0IH1dEJ252m?=
 =?us-ascii?Q?H4vvAHOW4N12RgmMAenbXATK8pRNWxB2ZKNeYzT7H3Dr7FmWAuObpP+wCVot?=
 =?us-ascii?Q?CKGxxqLYOaU2LRrjH4i4LNnQuUSG5c8EaAjOmlicoEKdaPCWWZl7RnKlH5X1?=
 =?us-ascii?Q?FeGIfndYWm48CFYCwY4jf6WOwkRb6qKB2OSe5mZTU2SPRehnR7Vabir7WXxl?=
 =?us-ascii?Q?LPFsdsq8N2BbqInfyZtzfCCxLuJKOR/1fx1GCKeGOFjcw65vPOkQbft9aL/i?=
 =?us-ascii?Q?xXgDp/Tos3vEkdoyTmMy/lOY46NwSaisXaUgvBCi5I1nxdU7EGYWxunuUltY?=
 =?us-ascii?Q?cAyB2QqaoT7GzumlPZdxzrvVPRcPGVuYoqAfoZHGC3fzfT2Y9H6SR/K24Dtg?=
 =?us-ascii?Q?d2U/McUbAF8x9IIGkrvLY14BFwlBkLGWF9EzQfwR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d3094f-cb3a-492d-4c92-08da8bc08851
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 02:20:26.2732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZvmy8fST+rDUvsxlhXwan0KuAVp915ETf7FLuJn7RwkAr4AHPoPOMJzAvmbZKH/5RsBAx5IeEiSW7OirbyQKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2627
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
> Sent: Thursday, September 1, 2022 4:16 AM
>=20
> Make it clear that this is the body of the ioctl. Fold the locking into
> the function so it is self contained like the other ioctls.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
