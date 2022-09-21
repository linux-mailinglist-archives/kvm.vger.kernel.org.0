Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94465BF4EE
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIUDsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUDsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:48:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67D7C1FA
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663732090; x=1695268090;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s1qIUc+SIvDbOR/Yhab3r5bwMsXmgn1Kh+98h6mf07Y=;
  b=OQC4OM+GwqBTunwT5t3PYUkKsJfGalybhSrABXknxUdh4SNyqBVYFBQa
   0p0oAS2rja3tlCt+ngRTIZJGPByyn8l/1LYR0EcZW8m8TT+6CC+V+6IiG
   rhTRSNmTYY6/0BmtBAmuOgj2uXP8PEyuNLEGXcWWeG0XndlFlI1w9fGMi
   ltrjlm2+o0YLD5uc81TCJ3ew//d0c5AqHfjdZvbEfUOrNCvoco/U9Iz0c
   GTrqT9yghKsXtuhwj2rkUlKwNIZMSw1QEm5GSxoP3DRK4QQYlvTd44qAS
   2RM3flsknc7JDXnsivC5dW6ZF8Jakg3WyBkP002zsM6YrGQLnShAAJkiy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="386175413"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="386175413"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:48:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="649877423"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 20 Sep 2022 20:48:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 20:48:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 20:48:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 20:48:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 20:48:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB7rc17+C3hz/kWIax7lQjk5wnslAoQEHD+Vk3FBAEv0p22IjkucVq911dmLHQYx1m0ioKQlO/OMX7Z0GrOD98cjhQeG21LyoZlMw+Iqzlr3pG0d7fiq46naNqF+kVznj67ExFVCGQcW7aX5GGSUgm+qO7/14vmME8j3yjXFQmzMHuve19amrOmThtTyhyCZ0XTErvwjvqyi20DPTwLugIiSf5qgF974MBBzgD5M0BBXWufr6zIq6e2vWT1r1RQqcsOBXky2GGhtW22D+DNUTjtPNk5ne2FW0qiF2zlkJNuYwLxO4Qu7fSfVEUabeuq3LvWZhuLw5j433v2pexNxNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijNxi71PJG+m4nnACkEzqer/oMpwwm/D5+WJogS5v1g=;
 b=QIrK+bIH965cg4pSIkZUt+R95PPZYLnmGSQS+xsxgYhwcUcd2tyfxEpFzctw0atoatBFbo3Du1gaYQMtijg0PUJqDgJn8IETg6wQj584fFKjJJHrJH7ROu+ZpaPQejxYmncY1fOYjxayfDOCnnxTx6k1yNlVaAn81jIAVrXkYa8Dyta0zJkxptvayd3BhojfHEdU9EL3A0nHs4+THZzX/1TEAJ7xFcGyn99bDHCMbiwv5PM2QWSYv25N3cBhL5gz4fM1lBEMY2HqmP2pR4ewmgTIMmyGc3Br7yorSkdxKWP5WNK7K/9sPXv8zj/MBP2iGXy+ULsVYNxQBIraTHsCLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 03:48:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%6]) with mapi id 15.20.5632.019; Wed, 21 Sep 2022
 03:48:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Topic: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Thread-Index: AQHYvwaitkEm6TEO00KJwkFy6AT+ga3cooLwgABkOgCAC9FrAIAAgaZQ
Date:   Wed, 21 Sep 2022 03:48:00 +0000
Message-ID: <BN9PR11MB52768B0E335FBDCE341053408C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
In-Reply-To: <Yyoa+kAJi2+/YTYn@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB5911:EE_
x-ms-office365-filtering-correlation-id: c3e26f64-de2d-4960-1938-08da9b84146c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yZEDcoM81OSbK42y/YI72u52lJayhI3ehU2pWA/1Yn37cS4epSfaP19rW6b5XLaIgsQhYY9u7zUT/bhQgBeqmtMJBXK0poLiJFSutQt3HqI3fSE8V/PCQ2vFC8gZv254RR64sXIc/ETo7gF+nJqFjpXzTsLVlJ0J3lcOpwMz6ZSp/R0HnmCTC78J4hwHKmJBP8CgJDpp/9SJ9slIiUb+arfB5D7OoV9jS7ANwaPZImuJUIJmBuGsOedRaYZtFgqtblEZdt1jQFMUJXNi9Ksi0F0xhm4aSbpNdorTAThjHcsOsP1aAR4cmwrd3AuSXnysRE7RoZBpDiQvO41iE/4iCYGpFDQCxtxI+Rd1rI725CLxkyMy5rnhcuHqSMAsDriWJlfoVWe27yNmLH5tIvLNWcLX+n+wZr7ofyamu40Lsu1oyFvF+06SOiJZNB/JqAQSYXH6ulQEpFfOr/wMouf6mA/7KjIi9kUkVDvwD+s02V5Z1RPrg81G249I5t0ioye+2CYHeHl1oUVJ1ozzs5G+u2HgXwm5RGX2Q5S1kXP3qgExL9JhCF+cFdp0yzW/ANam+/TqJ267mHqqQhHlC6TCoggeAsrWSO4qgBMCT4ouiupCIoaG569f518I7RFwMJelTKv7eXiUpvx66iAE21u4d3sEDQyjQi6O8ESKSEja6vE841lGhy3FtUquGOa0+KEWLrLzZfSk206sOilG7Ts6pZ2+4ColJXOPwicwiNXRLwAXMW3aePR8g9j0rlCNLO65RX3A9lUODtPOtJsWEl8XFEtdTxU7VkbUXVqLPw+mxco=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199015)(54906003)(38070700005)(110136005)(86362001)(83380400001)(478600001)(7696005)(6506007)(41300700001)(53546011)(38100700002)(33656002)(122000001)(186003)(55016003)(71200400001)(9686003)(26005)(316002)(2906002)(76116006)(82960400001)(5660300002)(4326008)(66476007)(66446008)(64756008)(8676002)(66946007)(8936002)(52536014)(7416002)(66556008)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vvRee9ixdLGCs6eGvZrt9ffoVwv630p3yy/KCjMyMTfsmAvNoOgwbQ7fOeVr?=
 =?us-ascii?Q?jZkeX8QBEH2vRYKObGcJ43nUwmQ7sfhmCd+oKPN9jiJNRH0lYQwSKuKRZuiw?=
 =?us-ascii?Q?K3qknI2CTscP7lo1r9khFon8KKlIYK3khl5TRswrjuFckrw1ya3KDfovSdtW?=
 =?us-ascii?Q?OERi207KfPvpcE8zoDFJub3UaaDd4JwkPMBWvc5dHIEIvvUA+WBCCMnlqbRX?=
 =?us-ascii?Q?q1ED7Y4sWtCkkhDw4JH/JHacN55yvA6N6074Eyxr0UgSmoUVLjqirpfYQa0f?=
 =?us-ascii?Q?8VuaXaJlR3mbNAyvBuSizPgShopysdPXuIfDdQzOaqq2lfiEJ5K8+jRK72kT?=
 =?us-ascii?Q?MAMvGKl8T0xogs7yevfFKKkjLCtAIkNxKY0myux3bAPorrDNtrIyldmT1AuI?=
 =?us-ascii?Q?hSvdGLwIZRU6BrgML/Kpa4YkV5X1J5fr7cCYZ6ZytgZVaZQ7B+JDi5oHqK6U?=
 =?us-ascii?Q?ouGl6/NFQm4DBJ1b0y9aZBRQvWRTFCoA+wphgrF5sS49fnwDkDcBwSpDqpCJ?=
 =?us-ascii?Q?HQ9R6s0UX8O0xOH1h3fLDcUtzAWZJOxFTI9zd/b8RypDWNQlT3+A4bXURob3?=
 =?us-ascii?Q?sTT3zNEvc5Rkbc78E9O+LmGv+OaKFI/vWcS4UDlLFmzSFSwiHc6b17zgrljR?=
 =?us-ascii?Q?9OVKYD3XmuX30qsDrbe8J4wIa4/f/IB4r7aq8YokgtUU5Hz7PcDBKDRIMiAr?=
 =?us-ascii?Q?F8mbwx/FK/EbD5Nc6CHs/vjKtbncPs6dSR1dkc/oqIPx/YfNNb9jaa0922Qo?=
 =?us-ascii?Q?PKm3MfEbNb1wWB15jny8/1V9xsTsa90rXaofPCpwCtsn74n3/+7XdWbCGx4z?=
 =?us-ascii?Q?2o8aiI+ZWxb8EbtSx7dPxWqP+u9Rm65gbApB8vg4px9xjqgWKNdqnmZYVCz/?=
 =?us-ascii?Q?DoLXDB331HGd+zC1kNMExlQ2OgLrTKj4RnmS5OoP1DSi2BOGx5Ohaq3uQ3Bs?=
 =?us-ascii?Q?f4jCtl8i4nh4KZ0eVpSAxAZtlBUr8bXHfIBuri514aunbOMDhZG4QS5oIcWY?=
 =?us-ascii?Q?wQvic1/WNtnVmAiYAzDzg13OgbxyVggmdsCJ7/8kbBxHrwqFUxH+EIjIgUlD?=
 =?us-ascii?Q?QmB9eW02qaQ4NGy6MSdTJ2syabWwJb0eH7d+88dNpQ/xOnaGbu6cvFgIvFl7?=
 =?us-ascii?Q?HniRsEbfB/QTTwwkqc198ZZe6iQYgfd7vHuikamtX7D2ZXrIeqC8vTkp5nKJ?=
 =?us-ascii?Q?NZr8LtuS+rsmfBWj0b7fO6uzHfeDiGh7SHoKGIiv3/6QGnlrEacmt6dz883I?=
 =?us-ascii?Q?nYQ1ccAx7S5XcOxPk30srSLrBEyAZFu0+YO2HvwsICED5OHACCFs70599R76?=
 =?us-ascii?Q?J3sP4quKzgfxMEKhdDp5qO3+2afOomRiKv3UFxaQPGOBBjxToQPIkCgB9gfG?=
 =?us-ascii?Q?G5EsV0ACME1E27auouAZmZPGYV0gNIDFcsvTXac5K0Yy39uphHArhop00ZeQ?=
 =?us-ascii?Q?KJhKiONpq2I444KWr6HUYmMfYghWKEKrSUpyG+axxK0GFHyJH+hXl3iomHKA?=
 =?us-ascii?Q?iBxnD8Gv8VIhtl5z2a9zBVYT9yznyizpN7JkLEIrjhlIOXabhMQhS/PPyHuy?=
 =?us-ascii?Q?hZaGTq/UT0Z6Qj5441CZPequyjLN0n1UHjG+TycR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e26f64-de2d-4960-1938-08da9b84146c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 03:48:00.6807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HFykdeA7Wli6taJiYC957xEL8tRTkIlZLgJekoWPkcoOSaWFyarwojaqtCVddnBXtBabS0JpjxKrgzPCJTnq+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 21, 2022 3:57 AM
>=20
> On Tue, Sep 13, 2022 at 09:28:18AM +0200, Eric Auger wrote:
> > Hi,
> >
> > On 9/13/22 03:55, Tian, Kevin wrote:
> > > We didn't close the open of how to get this merged in LPC due to the
> > > audio issue. Then let's use mails.
> > >
> > > Overall there are three options on the table:
> > >
> > > 1) Require vfio-compat to be 100% compatible with vfio-type1
> > >
> > >    Probably not a good choice given the amount of work to fix the
> remaining
> > >    gaps. And this will block support of new IOMMU features for a long=
er
> time.
> > >
> > > 2) Leave vfio-compat as what it is in this series
> > >
> > >    Treat it as a vehicle to validate the iommufd logic instead of
> immediately
> > >    replacing vfio-type1. Functionally most vfio applications can work=
 w/o
> > >    change if putting aside the difference on locked mm accounting, p2=
p,
> etc.
> > >
> > >    Then work on new features and 100% vfio-type1 compat. in parallel.
> > >
> > > 3) Focus on iommufd native uAPI first
> > >
> > >    Require vfio_device cdev and adoption in Qemu. Only for new vfio a=
pp.
> > >
> > >    Then work on new features and vfio-compat in parallel.
> > >
> > > I'm fine with either 2) or 3). Per a quick chat with Alex he prefers =
to 3).
> >
> > I am also inclined to pursue 3) as this was the initial Jason's guidanc=
e
> > and pre-requisite to integrate new features. In the past we concluded
> > vfio-compat would mostly be used for testing purpose. Our QEMU
> > integration fully is based on device based API.
>=20
> There are some poor chicken and egg problems here.
>=20
> I had some assumptions:
>  a - the vfio cdev model is going to be iommufd only
>  b - any uAPI we add as we go along should be generally useful going
>      forward
>  c - we should try to minimize the 'minimally viable iommufd' series
>=20
> The compat as it stands now (eg #2) is threading this needle. Since it
> can exist without cdev it means (c) is made smaller, to two series.
>=20
> Since we add something useful to some use cases, eg DPDK is deployable
> that way, (b) is OK.
>=20
> If we focus on a strict path with 3, and avoid adding non-useful code,
> then we have to have two more (unwritten!) series beyond where we are
> now - vfio group compartmentalization, and cdev integration, and the
> initial (c) will increase.

We are working on splitting vfio group now. cdev integration was there
but needs update based on the former part.

Once ready we'll send out in case people want to see the actual
material impact for #3.

>=20
> 3 also has us merging something that currently has no usable
> userspace, which I also do dislike alot.
>=20
> I still think the compat gaps are small. I've realized that
> VFIO_DMA_UNMAP_FLAG_VADDR has no implementation in qemu, and
> since it
> can deadlock the kernel I propose we purge it completely.
>=20
> P2P is ongoing.
>=20
> That really just leaves the accounting, and I'm still not convinced at
> this must be a critical thing. Linus's latest remarks reported in lwn
> at the maintainer summit on tracepoints/BPF as ABI seem to support
> this. Let's see an actual deployed production configuration that would
> be impacted, and we won't find that unless we move forward.
>=20
> So, I still like 2 because it yields the smallest next step before we
> can bring all the parallel work onto the list, and it makes testing
> and converting non-qemu stuff easier even going forward.
>=20
> Jason
