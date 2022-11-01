Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA956614525
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 08:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKAHj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 03:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKAHj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 03:39:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1169A15A30;
        Tue,  1 Nov 2022 00:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667288396; x=1698824396;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dim0r5mXQWR+xIECYY+aa+oagxPgiFxAjygf4L8o5jk=;
  b=iJCLGq3wGR2tGt6xmsm7vBQ527F5B7nH3zT255cQbrv9mRnB1A7tuglu
   QCWxbvbi9WtYNhSClAS4/M7q6JNbW8R/J/IjQgasJC/0K9cZxL07IfQLA
   PuSeLnLt7wq1hM2hdVJuobzAIokm44PtzcRGUKENKhLy/MAwTKRwzcU7E
   9IXC91tNTKxP6CEP6wh7uvZeSAUQRyvr1/HxhTM1CSv6aO3fzyRsPPlrN
   XXSqgkFScXfvpUT/ZzGpdtOf8/ezqZhMwm717XzoVkZaUoH1cAykjBeu3
   ggqcDFGTLtfz5c9oQH3M3V7UwHoK3uYcCpDJwuaC9NC1CLpM7xVSwjOTh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="310181018"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="310181018"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 00:39:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="697319318"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="697319318"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 01 Nov 2022 00:39:55 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 00:39:55 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 00:39:54 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 1 Nov 2022 00:39:54 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 1 Nov 2022 00:39:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASRWZC/nZ7VP9Q4ZOwaIKyeeModJuSeGWopDXC3jidTnW+fTcbL311YvaJufAJzTumPRR1tVMVobsc9Liequ3LA45bcd15B+75vrfItTUbejTID1Ru+VgQJeitv7CshWK+MjNN2rQkNaqegTnnV1S26eLcyxXhbZVkVUi5H9iYrVt1MHWCGtJMpGO5cqYmVv1lamwoIefapHPudwpmbk9oNahovJPqs4+vZiBpln8odMuQWUG2MrNPaLyvA+oo8Eryq+OP5Lv4ZHeU4tYqcv692HdEP2zs+RQRnal0Fpn6zfF9JGxrM/Hi7CpgJJu6ManYIw+txDd49sbxnpF111CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dim0r5mXQWR+xIECYY+aa+oagxPgiFxAjygf4L8o5jk=;
 b=GlSRBoJyQzgCv5dZqsopqzcshiMfGXbiOxlSDmNETyN27y42O0f/wuMxixGaNtxtxnK8/coRXlo5iIBFMCpqclA59nVuWv/xk4e6VVx6Tb3EV77kZud7J171bp3yZc0g3ip6G13nP9SkOOTHbld2lPqbOqhI7H85PNWDzCsCKoz/w1cbBPdTGLjGcsTlbN+glKrMqVw7A/a9Ike2ea1p3GgRxXiOb/nmAnBYvJ6SWwo0mYcKClqz8lyeDdRJK2a67ihyAhZ+H1Y4TkKcGZtTnh8li+9KOUM5zf5JskpPHO6Mx/miQTktUk4o43kGdEQ+orPcsB2fZToxRIl5Rn7mGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6854.namprd11.prod.outlook.com (2603:10b6:510:22d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Tue, 1 Nov
 2022 07:39:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%5]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 07:39:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Eric Farman" <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        "Matthew Rosato" <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 03/10] vfio: Rename
 vfio_device_assign/unassign_container()
Thread-Topic: [PATCH 03/10] vfio: Rename
 vfio_device_assign/unassign_container()
Thread-Index: AQHY6J4NCFgG4sixGka3irJu+Z8xK64puOmA
Date:   Tue, 1 Nov 2022 07:39:52 +0000
Message-ID: <BN9PR11MB5276E31FC5128FDC00045AA68C369@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
 <3-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <3-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6854:EE_
x-ms-office365-filtering-correlation-id: 8a195653-bc16-495d-105e-08dabbdc437e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n2VWn5VSkoKEbAeQMVn9D6dJ8w3UNWhxYRT0Xgm5SL6lYDLSy2+yVTRo1u5uNh0YGpK0LByEeoIWd+1v+im/yDK2McGSFEg9dKQ1s0Wyr+rbm1GBAjVtbuMpLQXzufF8Fgl0W2zTyL+LgguNOTMUqY55x899oHuMDCHf5eLHCVtS6QWLCLCZRkzHLbotAXxPphGem7SeYYW5C6L89AVn9V+iYV9WopN2JZTDIv5df1pGC330AfrYCJWAE+/lCOUYCETM1eyCYOoCewor9ZKaREV8Zi8O/tIRgrfj8mR3ISlQfLv4BESTYx6fm4q+g1VLFbDlUI7rm94Wc5l79qPsfheCxWeJTP3HLN3vWm5bxa8qTFrwyX0F2xPqSplWbrDJDtSiU4Oyit0HHFM0HNK9de42u7EXcuEhE74qGC+2EjfDalRcav+5vIxIJgULbDQDI8rA2sXPTqGdAoJhsII8zSNlkJOgiygchAE3bAXqKLwjPLyMMNqZ4H7yHNGiNHxU7yULLDS1HLOqVeDS7LaZ1TYMm0/13031UAvBcahwICDbA8tORAxSsuddAbDMTNrjW02hwHa+psfIyAGVgT/8kCok0Y+zPdOBk6C0bqagaw/gr2pCCKF7Sijixwcpy7NpKmbm4D4ESABW0texZdcL+7uW2QUdADq453rgKcunaMYrmMoU/eKBrH0EMR6QJRgvUum3rW6y7yCZ8DIGfJ6WNjlRgD8r/v6WbrdaynSWGOh2Wyt0e+zeohV9mzdBDb/uzVWa9wyuAzw8sVnbDNtmITe521/WZ+pmDX3tonQOGUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(38100700002)(33656002)(558084003)(55016003)(6506007)(71200400001)(2906002)(7416002)(921005)(122000001)(38070700005)(82960400001)(86362001)(186003)(64756008)(9686003)(26005)(316002)(4326008)(41300700001)(66556008)(478600001)(7696005)(7406005)(66946007)(6636002)(5660300002)(66476007)(110136005)(8936002)(52536014)(66446008)(54906003)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h3EmQzpsMLpMtL0OFnXc52bfZ+LzqvpFOEZIIqZ+ntgwevT/AMwkYnDLEmRE?=
 =?us-ascii?Q?E5PeICSxqDb0Xw0aEvimAT0nuCauepK7xS9kn1Vh/C9l20KlZEyQd/u7xU01?=
 =?us-ascii?Q?DAiVAogGDBEm0oplgsBTKczYhWagvWxLRx9VxfVwq58ao8gCMFeCO59hJMzp?=
 =?us-ascii?Q?zTQlMmaBgcGxwm5ayhpur13EHcRLaZy2u40WgqtCzTJoXueup3tPy0Mt2tkB?=
 =?us-ascii?Q?NZ5PWyu61Yu86M5UBp1Zd66nTXwYbPJC5vLG5ovCn4H3sl+O/O/gukBpN8Nn?=
 =?us-ascii?Q?yMRYomxtO4xu5GVmb5dPsNURXLT0Bk49oPOBRAhOfq8J8ho4MjeUkJo30K3L?=
 =?us-ascii?Q?mRHMHGIsYaXhtY35Vhk9UbSH3JUdtTx5fE8uJg/2uYORBRl59SotjpqmAyJ2?=
 =?us-ascii?Q?7rYnj0dFvGqVUc4XasFofUe0fdEGa1vB6c2vLEHFLZUWQ3ump2L116hahhMO?=
 =?us-ascii?Q?IS33T55Sd4ewQRawv4sTWXgq/Fid1u8HnTQYipIvHPZa3AtGJAicUMHoCPaW?=
 =?us-ascii?Q?pTXgGArIW5yiiFA+iFtS7DYkSI0qPETH72pNWN5iXRCoeZcCv6qTlN63ygWe?=
 =?us-ascii?Q?+F/IB/moCXtsugPORkeRzDCqZL1IGZ1lJIfMa0pNse4HlQli2U5dy8n48xWz?=
 =?us-ascii?Q?98mbxMkb55281pa8xQFbLHMws26LW2klW6ojAGQWhkyIZMZgh+xwwmTxC6CA?=
 =?us-ascii?Q?66h0AtZCVg40aUV94nizUu62NJyJ16niAV+fCvwwFULDj0GmkLn5Lw3cBee6?=
 =?us-ascii?Q?suQpJZ6N+vJwNBVp9JTCfpoDqaKp8r2MMgaZZ+w2ZlmWRNVKLizPeepLbKCT?=
 =?us-ascii?Q?jLHZnhXw6AZBz6v5r33ZKwwJc9kk2BSuxep/Ru6YidTptJUqhxGV7HE//cl1?=
 =?us-ascii?Q?Vo6zV1r2JRmLtpui20eo72aelzEQQkJ+oPkbS+V87SBRUuJ/o2BWwatBw2cD?=
 =?us-ascii?Q?JOMI4vFuA1vkmdQ6xx+4gpNdfPjc99v96Dp8j6wwedAOQ/vwu5Nc2od3uZMa?=
 =?us-ascii?Q?aohdEC8RzPBQkMaxcpyLc1T2tukHkSnYokLgCYwI/Gax6LZTP3PRxEggqafV?=
 =?us-ascii?Q?PCwTOluEALvJz6IDqM+oPH1pLqGIHmhSDzk1siF4sBit0sxQBM5LdJ8z3W1h?=
 =?us-ascii?Q?2WMh5vulKhepev3Nz6cICB0iHV9oKPBAPPAbF83g++2C/8R/I+f4FtlsuMmF?=
 =?us-ascii?Q?iHG909jpfGYzvMZACsvEel8Ft6/BjF5YTGALQGnCp8a5keiOgvZjivMurpjR?=
 =?us-ascii?Q?YVdAXglAyytyvqvZRf9Q2Z8KuZgLYUY+xST17Qw0oGyMnFcshxvkNjRO+3mg?=
 =?us-ascii?Q?a1ozG8iF/bApnUi+X60Qx5qyodU98YSNQqpMHjRGSfNBKUbppYg4mmtEo9Hw?=
 =?us-ascii?Q?goPAhj5pZIFmH1d2zPcv2TjAlPWbcSS4CYZfmEAY1PPrBHxVpq1Nb0sISU6J?=
 =?us-ascii?Q?D2gMAP9of3YGWM3Naml+0mFgQpIPvGeSIx8uYUDcX2UrV9TCTRqLmHV8oqrr?=
 =?us-ascii?Q?F8DvWHs8dby4xUtKUEQv1TEnrHVnTYHiQxO0t/xdwEiUDSStXV1eMO9iK5OG?=
 =?us-ascii?Q?c+fW6SMLCwedk837tEoA2ZxsrXWHrpAC0S8yLpZJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a195653-bc16-495d-105e-08dabbdc437e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 07:39:52.5568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EVRy0Cr1mcUhHOB1vNMuFFI9ykrdc3y+9mply85outdvHfZ3SjuZ3maJWhAjrfblQKKI919EYZ0cGghgvYrv/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6854
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, October 26, 2022 2:17 AM
>=20
> These functions don't really assign anything anymore, they just increment
> some refcounts and do a sanity check. Call them
> vfio_group_[un]use_container()
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
