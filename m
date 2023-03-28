Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3340A6CC441
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjC1PCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbjC1PB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:01:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E48EC57;
        Tue, 28 Mar 2023 08:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680015680; x=1711551680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7dKuorAvDSf748yf9JlHRdB5Gr3HzSafGazGs4KPmg8=;
  b=PYZQBkb47T7wdxiLgsaYKozaxGRodDLQft7EmLwd+wJynuPA1HS5fYWi
   7x/SgV9LxZgoF2PYqWpQhZyaY4FKCoE0sEqg60ucyPoXMPWG+smK2CQxR
   Zb2/B+8xv+W2Lou/3GmjdHbhKlbqr4eDm65jJe9jBKAQW9/ykj6z618/M
   gXRNO3Cb2KMKNiIIcJ5YQc5fjGHKy83gzT8DMCwqqt75RjnEqlGDSxkJK
   krxq29XvnIYIdOhRek87QXRHzWIXCuvyJ9CO9UHRwDLmIN01nGo/Fohv6
   uZY8Lf6Ho8M3MP76l/4Kfgws1CkVRTZNVKnidHiEd8LCZUxKguFDdotBI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="405526251"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="405526251"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="716508117"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="716508117"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 28 Mar 2023 08:00:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 08:00:46 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 08:00:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 08:00:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 08:00:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPSAN36wwJ3os5/8NInSmWTzWqtHeFAzb3TTKMhKwD4KTtpoK1JG7WI21T2vLGWE25wRIQilOHpp4P1boLgbZwbCNHezWvd+4wUpAWhgjB8/V/Yf9GO+kdiKDgtL/t5cpj+5xWLI7ecjqrh5AUN/4NiyenyR1Qxfv6ER6I23Rm/Iq+dUiDhr+zvUZFmwzOM3xgb/CLxZDZwGShXercFE/olIClQ7cZf/lhrK9ya8fFrbKCvdPHrcKi+Mov9NiObBVQ2Q1Icu4j1PYOUmab1Cz8k53QV/naUSur6CqWYDFrhcy9AXgyLTXSQX3f2BJIyNvP8bkKEdvTGlG7qJW/N+EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFUusXdcHyUjHq5OlY4WY0pdZl8F6OqPNGD0cDTBHqU=;
 b=Rsvq92PDJA5+LdRCsHsHVz9aOIQaYSKEJcgMGbE3qwU7KQpdi2hrcposIpIaKr3U6fFW4Mkm0QkdotFv9dAPXt1oQN6N3obqBk8GYf3GhkKya5t5AC76h5KQYsdaYbiVq+Jn5jeDWPeKJ2uGnqivHLXCQwXlRJbrNdcvkhkShg5EADldIXMh4/+XX2YI3fxdEHajYQyTcD0ldycq7eb+iDIZ746Rh+NySdgxp6o493eZOdb1QSAf6Yh/lLk/WPj2tpsBS8LZb9Jp0SSNoHl8+e1QFv+gj/qiQVJdcLTX5isj75OlzeZSXVPZDFYJMSh0wVmQRAkDylc8gsL8KN7aQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 15:00:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 15:00:43 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8PAuSAgACBxlCAADScAIAAh+4AgAABaZCAAARdAIAAAahg
Date:   Tue, 28 Mar 2023 15:00:42 +0000
Message-ID: <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
In-Reply-To: <20230328084616.3361a293.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB5295:EE_
x-ms-office365-filtering-correlation-id: a383a9a8-3640-4b8d-a48d-08db2f9d33e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +wAymlCk8Y0jfMsHcgjG9n1fKDwNajl18SUmdYYiES5R2BgIKK4X8p2I45tM39Rz11isUkB2YePwCaXncpqVwrcPZ+lrEr4RlzqstpkN5hNii1aSZJLMH+MfHbem9YCuCUSKsfQqVC+FhQliy3cVKaB19vKNpUv/83Xssgik+b7bB7rYUWCj7mdd58Fk7K6Z3CWwr4wKlbOIeSrasWIA3eC30aKXQRKwylWg2fZwmww5qijxsyYp6slLMZalDaA+322xtbCj9UL0Bct7RY3frGRnteVeqeyROVejGtDHebTuyn+UnyAkVma4xMGWIWn/QpyKJ6ENUejAnOHcQ0SgfQ809wTTb5qqkuayWeOb9krsQIOGtv+/oWoZIxGLGN2iahCzciyw0UDvBF4DPj/oV30Nve8FFm2B+qp2+gcIOSm6Np14tXCAsYydq1wMvL8XF2zM9Q3X2oS241y+GOwbBhohINgFV0MHMgy0h4fTrPZGNNd7/9XArz5Du02UFDh9g/6wSokt5NlFHWkYupnnN25Ttyavt8NwIgUiYW+xtUmJc0zSyy2qxlrN1ZIYL/+/A0PoyuJ+g5KyBysqXPVzPBpiBzdXeTqqjvRKko3gQwtfQLNobqodA4mVTPPpka4yN6ojPviH5CW7+eCCm0fxoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(2906002)(7416002)(8936002)(52536014)(5660300002)(83380400001)(7696005)(55016003)(71200400001)(86362001)(33656002)(38070700005)(38100700002)(82960400001)(122000001)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(8676002)(41300700001)(186003)(76116006)(66946007)(316002)(54906003)(26005)(6506007)(9686003)(478600001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4L4DXY22pIvA4ZiLUEPk1J9wUDXReYeb25L0oYYrfo6dBsETVjB9agOgiU0j?=
 =?us-ascii?Q?cwyY1AysQejuLyYZ5xaSPBIGQHj6J6sO22qCApkLBcSTeWyt1iZeXDRIjWYr?=
 =?us-ascii?Q?AoC+QW2cOkuztTNWwvQXQ5mt6y0+4qtTwtABjq6qpwz1ThkTBhA52r0WB1tJ?=
 =?us-ascii?Q?8nup5I7z4O16qbhL5v4FHnpt4mmAlSMrRMq7ndK4xlP3ooJu746Q3oC7QxdU?=
 =?us-ascii?Q?zaTRw9xerjnICwLMAJbtbWUsq99f0K2dUGUbGD/DT57qJRN3h+E38Iw4T6LL?=
 =?us-ascii?Q?cwyjFxl7Ucv7Vy2wCtVXtbJzqSF4qv3gkdLIE5CwlNS1ReULwyaVQOTu8i66?=
 =?us-ascii?Q?OUJWQxVVvIyet4/HY1u6bYdzlAynWEkQzW/b/RPYiS8wwFLjZzN21mArO5PW?=
 =?us-ascii?Q?WgfmZpgmNnyGsxXhZJjUKDJLrrZf60hlMhVQn5bYWLwOgPFIg7YpLVzfCAPX?=
 =?us-ascii?Q?wUdFD+BXdcFIZBZplE+eyKEt4hePwsNoS0rl3W9b6odfUpYXlmZGMo+utwhd?=
 =?us-ascii?Q?XUu0pbdGFfad2I95LO0hBxkMOYJRgXqzCT4BhIRDg+0GASCfA/pg9W+F/EDT?=
 =?us-ascii?Q?AYYggKHjb7YlYfneD66AGBr8Ucimhh7O63HWXWEe0en9ahSOUHkmjUuWVBPD?=
 =?us-ascii?Q?WZQZxbbD7BXL690XGkK6mFlHp3s9v3xY/gjyYydIiOfOxT3+q9ToI7MnL6aP?=
 =?us-ascii?Q?MnPOaAgtAnkw4+W/b1Bc1HQp4mx9HKYCBJHIvTr3jIk70PqbqVahf99uNggo?=
 =?us-ascii?Q?VPGTYEQ4SRH4lZ9RrIUGouVDE3F1MYwcJDFnmdORuHus3TBi2K1H1zqAdl/w?=
 =?us-ascii?Q?JU6Mcqxf8NbmrCmpEsWwajN/Mz2V0tkf08/sFY2pda1kjz/0KE93iKIrqX/V?=
 =?us-ascii?Q?2PeJZ5RMo4edz27/9XZQUjEfnQUyvgdaL1ZdZeuWRhLzI33pDF9aZLjW856H?=
 =?us-ascii?Q?C4LIfUFR3aZGTOT0rV48rTMzM5D7mps6hT7dvIa51REfXG9Di5kezxsmo6d9?=
 =?us-ascii?Q?iAjT6gs0phzb2otDU7cP3wgsNuHKYRYifHZXsoWezfnpCPGNXsXP7K3whC4H?=
 =?us-ascii?Q?G7Ol5onlnYr+86Wdheg/AzXpsDfQvMGqDTWUnboMCz0fhUMQMzS20cGxjBLS?=
 =?us-ascii?Q?1GzuVqI1iBwh5qWxwPIdIh5IicsdsZY0Pp6ZW+cJvK6mKKrJpbUtPFejzM5b?=
 =?us-ascii?Q?1xs4yQQVsQ+m2KquXVmJ9GqtpQHfK5ZketGJxGWby1LPdBLchgxOkHWr/itS?=
 =?us-ascii?Q?zB/sMjMiacICnKoKEtdkqrvmTGwgvKONktMmF84F4aXcLIo8mpLqUcenumwU?=
 =?us-ascii?Q?rHogh59XyGOttoAOQO8DszyqFZVXvUouaT4b0D7MaheJU9J13IKAgRJPtZd7?=
 =?us-ascii?Q?3qjjE1G+KGAqfDiZGIerrUjMI1KRr9O494l7u04HxxWT570ELFIqQmMvB2E8?=
 =?us-ascii?Q?cw1RxFMJ0agWTKWcDfKU6SR464LEVaW/se4LKUbIb14F0h4U7AtxEiYvTILE?=
 =?us-ascii?Q?pcBIpi5Wb6oc13evG2NVmlp+Dt5e3GnVLaMIXvcTDG/taNn570yJhcFqG7d+?=
 =?us-ascii?Q?hBGmlQQfydeAbZw4SoU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a383a9a8-3640-4b8d-a48d-08db2f9d33e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 15:00:42.9909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hiyR6jrkXtnfZXFGgTx4IwuPV5hDfXvA8WQyUXh3efW8cF+zPck/XaX/Vou8X9R7cI7hGE+owfyTPZ4JiJfKZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5295
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, March 28, 2023 10:46 PM
>=20
> On Tue, 28 Mar 2023 14:38:12 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, March 28, 2023 10:26 PM
> > >
> > > On Tue, 28 Mar 2023 06:19:06 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Tuesday, March 28, 2023 11:32 AM
> > > > >
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Tuesday, March 28, 2023 3:26 AM
> > > > > >
> > > > > > Additionally, VFIO_DEVICE_GET_PCI_HOT_RESET_INFO has a flags
> arg
> > > that
> > > > > > isn't used, why do we need a new ioctl vs defining
> > > > > > VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID.
> > > > >
> > > > > Sure. I can follow this suggestion. BTW. I have a doubt here. Thi=
s
> new
> > > flag
> > > > > is set by user. What if in the future kernel has new extensions a=
nd
> needs
> > > > > to report something new to the user and add new flags to tell use=
r?
> Such
> > > > > flag is set by kernel. Then the flags field may have two kinds of=
 flags
> > > (some
> > > > > set by user while some set by kernel). Will it mess up the flags =
space?
> > > > >
> > > >
> > > > flags in a GET_INFO ioctl is for output.
> > > >
> > > > if user needs to use flags as input to select different type of inf=
o then it
> > > should
> > > > be split into multiple GET_INFO cmds.
> > >
> > > I don't know that that's actually a rule, however we don't currently
> > > test flags is zero for input, so in this case I think we are stuck wi=
th
> > > it only being for output.
> > >
> > > Alternatively, should VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
> > > automatically
> > > return the dev_id variant of the output and set a flag to indicate th=
is
> > > is the case when called on a device fd opened as a cdev?  Thanks,
> >
> > Personally I prefer that user asks for dev_id info explicitly. The majo=
r
> reason
> > that we return dev_id is that the group/bdf info is not enough for the
> device
> > fd passing case. But if qemu opens device by itself, the group/bdf info=
 is
> still
> > enough. So a device opened as a cdev doesn't mean it should return
> dev_id,
> > it depends on if user has the bdf knowledge.
>=20
> But if QEMU opens the cdev, vs getting it from the group, does it make
> any sense to return a set of group-ids + bdf in the host-reset info?
> I'm inclined to think the answer is no.
>=20
> Per my previous suggestion, I think we should always return the bdf. We
> can't know if the user is accessing through an fd they opened
> themselves or were passed,

Oh, yes. I'm convinced by this reason since only cdev mode supports device =
fd
passing. So I'll reuse the existing _INFO and let kernel set a flag to mark=
 the returned
info is dev_id+bdf.

A check. If the device that the _INFIO is invoked is opened via cdev, but t=
here
are devices in the dev_set that are got via VFIO_GROUP_GET_DEVICE_FD, shoul=
d
I fail it or allow it?

> but it allows an actually useful debugging
> report if userspace can know "I can't perform a hot reset of this
> device because my iommufd context doesn't know about device <bdf>", vs
> an opaque -EPERM.  Therefore I think we're only discussing the data
> conveyed in the u32, a group-id or dev_id.  Thanks,

Sure.

Regards,
Yi Liu


