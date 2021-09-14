Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A6440A67F
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 08:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239698AbhINGM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 02:12:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:39056 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237875AbhINGM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 02:12:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="244221711"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="244221711"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 23:11:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="609474631"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga001.fm.intel.com with ESMTP; 13 Sep 2021 23:11:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 23:11:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 13 Sep 2021 23:11:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 13 Sep 2021 23:11:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0fj5atdu1TMAjsg3aGM61FSbFu3Bq6Kx3FUenbqyOfSk+xNhJKXIsjGXiA5vi4TSBsyKwR1hcsMVcF3tnBfaT2k0km8cx8P8W1U+SLWpbrptJilKHKV9R0RafNHj/maIpyfyJ1p4gvCsX3gS4lirttcf5qEA0gKUKSa3uCCliK0Pid2Cgyh/edM8lvC2b3avWCDZ6ucw4kkv73bVYlkIWB1aYtHtwk/Hjyu1tniU4/3CankjnkDdNsPOkr8iEKIhZeodjzooNwucdTuY2OikG59yPuvnmMtgXoUc7IIEAwAeWYUtFDcEyrrpWTCAwK6dnIts7jkO9xQDB/4EkmCYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Pu0zWLZzS0Nj5IRZke5K98EQ9pXUfwuQEAW/CkH9XAY=;
 b=ED4uX5e9cW/vmPs2c/BZlggq4ZmNLjCRwtWT1Ti/o8wxQgX7MgHUezYrjDGkM1p//fXUlWrlW+rNuHRMTZqZLFhTuDmJiPGcJaGpSd/4VPN/UYO51It7v8m/5AEOBB8aNfkJXprRtmmy6M2o/Eboiy0M7fMmjmZ6EAWQqJStcRO70JDnbntbqmDsRol6kV117PKHGLJEE1uV7BvnzZUYYiG/x8DmXwY5M4dExS8DiaXr1cwEU/xh+JFlRbHTFy3KbIYBSJa6xuJqLLoKrnB+FWgiQj6lv/F/JffgcTN7fX1OBeK1+SAXKiNNt7pkftPYcuuRXbeccQfwUiV0ReiRRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pu0zWLZzS0Nj5IRZke5K98EQ9pXUfwuQEAW/CkH9XAY=;
 b=i0uh0QfES1fnIT/6/Upb/aP4iPJE3hTPfzrnhTt6AE5qJ3d7oK3/vCM5kWPUxBF1aWoFDQhLoDDjzesNRZ/8cjqMfIT4gYIpAMK+BC/xcc44otaiCt/DqK+wbwPIHfgS7y5zaKvZCa8qAecNj9TOCCCjz/grdBh3EfiT438yG5g=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB0049.namprd11.prod.outlook.com (2603:10b6:405:67::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 06:11:37 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 06:11:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Thread-Topic: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Thread-Index: AQHXqG++RwC/0bfXt0ebt0WlG8MA36uixrRQgABAGQCAAASWwA==
Date:   Tue, 14 Sep 2021 06:11:37 +0000
Message-ID: <BN9PR11MB54339DBD8B72DD41AD6761998CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-2-hch@lst.de>
 <BN9PR11MB5433CB67B7E36821E0F1716F8CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210914054618.GB26026@lst.de>
In-Reply-To: <20210914054618.GB26026@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2f589cf-c684-4e62-c6c1-08d9774682e5
x-ms-traffictypediagnostic: BN6PR11MB0049:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB0049CEA51A400729433FDE648CDA9@BN6PR11MB0049.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sc5HOBdzJ0nMApvUsfrXR+L35ScRBcY5fbSz7VxFEcy7S206zaelvGJaZJcjwQQwrBdP+g4MpB00+pA7xJV/WxEJTOFuPyRCrKIGSwzv38fpJSqMOzckypTzLYTIHh3UVslgV1rze+NbsMcvvgQ/b5v7HlakXr+VBHDxc/czx3IYCronTka0IrTA2YVeCstVLG3JWdm57Mffcy9aGJGD1LvER0WiTPNqrqYiZinOqVeY300hnwVYy4tDiYZOGAk7DmNz5GmTwmlTvJJXRqzKgOJC4td7sLWIXaXA0+QHCaoRVl7tp0pYT5jOrN3FMhAXrGKw9oHPfpDVcrY2bmEVyBGqiavQ+A+qu0tuy6dEEbAmNkB3d+VMiO2VIr2jyVjsQy68ipsP2GXXM/W3WqPvgypfrYTviw8d92DD8bIXnF94ERh6m3Wr9eB7DoydCGykwL3IKOHM15D0Pz7/T2nPslIv5OaCUGtUl+9HSpsPGvMq60mXUv8cYQvH3LgnzOHFY2rEHncAtpYxFYxkuNpRj3wHWTXQDpNeb7EB1CFv/Xwu6SSWPqfz1PFA2MOuZbjocPiqywrdWphbMdWnFVS9Hvi8uKecjkckWrXqhB6I5NAfvSLtTnfqXFTYmPCSP5orNEixy6rbIUVvlufNm6be1P1wuUb04E/ZsoHUra6nQntAfvTEiq1/gwSGOkds/zmH/u7ih86qJ5bWu1K4fjSRTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(186003)(52536014)(86362001)(122000001)(26005)(9686003)(5660300002)(38100700002)(71200400001)(33656002)(7696005)(4326008)(66946007)(38070700005)(6916009)(64756008)(66446008)(66556008)(4744005)(2906002)(54906003)(316002)(6506007)(8676002)(76116006)(66476007)(55016002)(478600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BRW8tLNB9mSudUFU7qCUFFENscY38kwqKcCELnXxfFTZ1ggaoTS2nNgedjV8?=
 =?us-ascii?Q?FoI+xP+Jc/N8z06gEpMekzl8du0MQbTTSLtxt9PfPqVmlpS7ZYw85ZeuVZFJ?=
 =?us-ascii?Q?katS1n/ydeSj5JrvPA+iUslY0WDuJS32mAxCk0WGmlRSVDd7yekO6m66iYsT?=
 =?us-ascii?Q?KltAVfyblh31orPuumWRDKKxOTmzLFS8GooJ/Axptk6Ba1cfL5NF6sL5IDLp?=
 =?us-ascii?Q?aWLXUf63XhLUcnlvtir8BbFdz5G03BC66goSb6ZrAx4fD+9M53UumOcBqcOT?=
 =?us-ascii?Q?PBBYGXi8Xq/rqtvfajtab9pAifxD5YoQBUCJhc6dueW0sHsEMNKttvQfwPEi?=
 =?us-ascii?Q?e28aC8ocZCWkotYpJkbh0AbOo3R1xsPLdGk+Odg/R7zICpdIoDPmjmNGpJQv?=
 =?us-ascii?Q?KCRvzvmxnMU5risIMiqm0+rAmU0djJmyXHnJHnqthlX/HjLWzwXCqo1S7IuB?=
 =?us-ascii?Q?EUs2z6qr5ijJwEcAmMkZyyOlmOUEN32VXR7EPATmKjNW4ygXSD7F9BXR4GPY?=
 =?us-ascii?Q?DtkDQKrpO5UyTv8ttORhbvLxLlRB3FWMrmtOdEpAIrTmV3/r86dD7P7fhCs0?=
 =?us-ascii?Q?+bgg8ps4kJZJeNblK3W+5Wv96gU6YMX+rDVOkpIvRZCZmlcWH9QtIu8puxX2?=
 =?us-ascii?Q?Y5cqCwpUwwkt3dQyeXOq18gvezh6oao3fCxFFlKsyZKywV7WhHPlVGemUsBm?=
 =?us-ascii?Q?NR4GBeZHkyC9WTZMlGIUVvBIHkF0jZjoPKTJG7BX5CqiPiso5VjzXWQ62SWV?=
 =?us-ascii?Q?+O+kJbRcH8CV1u5MMJRz8/5Cbe7igRrQYEPVXM5uDflpkGtH5z30gX52ekFI?=
 =?us-ascii?Q?q5VNFmaPr6ZUsWWb+BCa6hsPbJoAcfdjyXGNO+Asf6OEWyH2VNBl+qjZHKvX?=
 =?us-ascii?Q?TndvOoeOcq3xnGPqOsfcjRiq9JO8JniQCniF4RCCL+evdu0rqAOdoYYNZZDp?=
 =?us-ascii?Q?z8xFMDlkjFIH/fNHLxfVo6idkRWR+PUm0xxEfI10sKPhotk6daZtIx/sLOdm?=
 =?us-ascii?Q?GjgObZg8IFdjJy5tbiPhEqgpTfyAazgRCnMek6Z8lnyCyy6gGi0DLLheShxp?=
 =?us-ascii?Q?s0fwVoarmZnsCJa5lx8tPNSJy0PZqn7NfB2Q9c3SvjK6rfp/VG2qk/Ro0tUW?=
 =?us-ascii?Q?u9E0mokHlZGknXS9NNjRukuX7yup6jkMU/TEdUuDGuG+2xxgp0uzVjoc0T7t?=
 =?us-ascii?Q?r71XrEJjS8orfgDZfu2uH419ZpFgsNZT7qedZZ/5+tMCn4JupwcfJJghmWNV?=
 =?us-ascii?Q?6xDRlM4srW2toPYnbuGg7LN4Y4/nyp6xyAx8PNTfLUsgjZJPue+ko+mb9gcq?=
 =?us-ascii?Q?wf4/O7aDricWgZVfxcPdlP8q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f589cf-c684-4e62-c6c1-08d9774682e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 06:11:37.5675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dyZcED6xkVBvEJhFbQArZ3+rb0Rqs6+5NzGrp8sCC3Mygo/rHdgdKIigeMGGYNk/3atVYLXZz/7cdtuvOmM5cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0049
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Tuesday, September 14, 2021 1:46 PM
>=20
> On Tue, Sep 14, 2021 at 01:57:55AM +0000, Tian, Kevin wrote:
> > > Since the drivers never use the group move this all into the core cod=
e.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > I gave my reviewed-by in last version. Looks it's lost here.
>=20
> There were a few changes, so I'd prefer everyone to re-review it
> carefully.

I did a quick comparison between two versions. The only difference
is on a few line offsets for applied changes. No actual code change
if I didn't overlook anything here...

Thanks
Kevin
