Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FDF6B0047
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 08:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCHHzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 02:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCHHzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 02:55:12 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E09AA09;
        Tue,  7 Mar 2023 23:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678262111; x=1709798111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+hHMHG4cDqeY6Ph3AGCjVhtUT2E/NX7bhF38L8d8iFA=;
  b=XAkZCVqJTYu5ieYjBg+QQv8uFEu99/YAjBkmPVXTgEiDj48vmzpBS5eO
   bQN6t7nm+o9Pq0EZaJElpMqKKapA4CiRVpaqJfPmvuAdPXAzz7HPn/Ipq
   epoF/38eXJrcyKtVvZeumD7VCrsmb28ee4UXVvEU5G/6breWNVHvPPZbz
   bAMNVc07Dr3bIxdx25xkQ+HmJ2EtmH+H3sOgqMsyylRDQuTJqi8X4eue7
   wUuUbG3HOsxCTT/qBXKUIq2SswUWin1qqVqzTDqW1B0D3U1CvrdZCIQtZ
   OFZPwDWINg7ukYC5OBX+qDsbVDhfAI+8lcDLTN+SVVCSTdP1Wc+Jt1iI2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="400918840"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="400918840"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:55:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="765925671"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="765925671"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Mar 2023 23:55:09 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:55:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 23:55:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 23:55:07 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 23:55:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ez77qXIWJYz5rd2YVEkDQZj/r0E1LC0sNC+rmn6ONtiJprA393cL7AgcC1hGrV3hLHmKUwbHQph0w98EDDRpWEnskP9nZ1HVLhmnDFMgsmAkF0oGQIImflwSIHmP9DdwHPb9QifviduzKJfic9TyJA9FJ7usBEn2Ueod+maAQjO/NFcFDa5FDMSsbQrm3fuFPCp5BVHxJDE/x4X24btIzzwM8+UF2WqPmPXOq/M5SgbJWZImj9cmfay/MmND8VEgr9BA6vQ5gQZriPOClus6IprLO36HQXyNLexYzaZNir1JwMBbF807vOe8JVCmAEEpmOrGwcTkd43T0+I4fOmoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Macd4ZxtQLUz7upSr2FFpN3NIM48WNXOWPiUfAUQGo=;
 b=X4nGKfOyo1QnUrsDOJRKFKzai1aczl492OuGXb7QAus3fZ/GHtOSmVEKvwDhdNtvFuzYudIwYUPHKliB6Zh2KzSFhfxp3IJOa1BHzEOd8jSYl/2TXU9Jke3sHEmsLYI/3lDEdPOCZSoOEF4mdBq70UMSJVqYZV/t7PgkfgUU6WPlN2p9zR+2yTBL4HhAnGfCSAQU87ReoBVB5rb7ypsgX9ECDc/yW6CNtakX7NksJzRt4hV+BNY1zZnIk3js8y9fHDEQRBXt0/3w5aDhKyK7l8YzeWwak9u6dsgK7IfkBmnl3cKM/A54qdb1fWYFq8OGACHsKhZ+a1RUBduOd3WThA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6821.namprd11.prod.outlook.com (2603:10b6:806:29d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 07:55:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 07:55:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4CAALuIAIAEeeOAgADblcCAAKtwAIAADpYAgAEqwZCAAAg3gIAAAY5g
Date:   Wed, 8 Mar 2023 07:55:04 +0000
Message-ID: <BN9PR11MB527659E9DF1849873ED089DE8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75298BD3EB872C938F86C96AC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75298BD3EB872C938F86C96AC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6821:EE_
x-ms-office365-filtering-correlation-id: 2a3b5f6b-edbf-4230-bca1-08db1faa6d4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGzfWnVNdOiZF9MjNVfQt/qiGoKP5tDXzVODqXekIpa8C5ebg8MWT+ZQvpC+Vj3E3r/F9KqulX992bGDLJ3GTg6nDKsTTBuMR/ztzvf6tusOuNjk9IclL7NC7omE4YEXadXUjUU2+oVafLzlE+rwiXZNrjdXbqnAqFOml1LIgf9itTmdT5BWu7/kKAi8c7mKKmE87tn+/WZ6mAbaxP2oSrWLdBxb8KU9Cs8yDC6KLkdXO5c90BUjtgNjtWA4uBuPb8swHOhTrffJV05eijJuGn0xHIOrLmkGUPl3YdmboDKkGf5nnQCDlR48CRsHna0eHEhT/41+NeYJLQP42/MSYtexVs7NtSbBjv37E0OdYzgWoP10w8pfYbV/FZOC/XptCsa4CbZ1NmARQkWz/902pege3AdrvTgu+BG3n6fLfhy4V+JfmqmqOQGv6nKcHQsTWfi7kq0gIfuRNt5umfxWZFigU1OqOpAMLlC2tFRzSta8zkJRNU6rkdz/eG9R9AMIzUGFIzFIe82q6GrAeCeOI9pMZ34z0uKFRQCtGuMFtNzBjciawCA+f/9kUxpw2KDCY74E5AAHwyfqb3wC8n7i5ppc7pgaWhUWTQuMk0ldu4EliuZOzItyOYRXakhhAa1S1m4Qv92dycydo9Sw1B9YRob3jUG9jhcUDXBnSJcZcVYMkr+dReb4fuz8U+uGAkuaHVBmPkLbTJzdXDS9iTDTKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199018)(33656002)(83380400001)(82960400001)(6506007)(26005)(9686003)(186003)(7696005)(71200400001)(8936002)(66946007)(76116006)(41300700001)(52536014)(86362001)(2906002)(66556008)(4326008)(66476007)(66446008)(64756008)(5660300002)(7416002)(8676002)(38070700005)(316002)(38100700002)(55016003)(54906003)(478600001)(110136005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ixokMMMrXbAfF1fvh9DWXJJswGoNETzN5QLELc9k+utJ9EQN1aPLyu/tdxLN?=
 =?us-ascii?Q?HYolv1vlFg2e6DyTrHzccvgQN2CUicjp2fxR24ovusJD5cgyrz2CiCPFQZM8?=
 =?us-ascii?Q?Ov0rATnx5pnsccQT7OgacLlxf1aug1LezFDoxMbOcgB/I/EGV3i0uvS0X5IG?=
 =?us-ascii?Q?4r4C71aGGgUf1MWcs9ugHGyHYaT1SrjtrfMIYyfVboGG4TlMjPaAhToDDU2K?=
 =?us-ascii?Q?Io3yVoZ4umin3OrsGqAkHS57zF8iIE0M1sCfMVdVt93L3OYooXh/aC97o7+w?=
 =?us-ascii?Q?A7ls5Px6Sx2cAIlBjojz9qr6TVyMEtOpCweYkyeYw37Xrk7m3NP+mYunk72Y?=
 =?us-ascii?Q?Wh/3ioZFLBcHN9vp+x1mKclvPl/MtB5G/TnNnnyUWYQGJ2gddrSsGlkekIII?=
 =?us-ascii?Q?9S0arsod6adYK9KFXvrAzLfT+0lJdYjz68s7YpaKKRxEJoJxTK5s44bdvJwp?=
 =?us-ascii?Q?19OkRc7tucJNgDQP1iukt0NlZ4IenLc37EJUchyo7RV8tQd7QhKeWSX1IcTm?=
 =?us-ascii?Q?FqJSWodsZ/jgPQwNhLdH2TuqyEWdqLUPTwgGMQsMPRLbBViNFuGoYdpYCvwC?=
 =?us-ascii?Q?86kyQj741cYLrvMU1vqHZlobU5smKm7gRzaexsv94Vvonk97SWl/NbicNAwj?=
 =?us-ascii?Q?4jYaNZeoZFrWNSGTbiyZOFDbblN33chEd40Wj/QMrP99VDZetUT4Evx65SUp?=
 =?us-ascii?Q?xDRhZ+NyMYwBtTKU8TRe6o/tc4mLkQzVpY5Gota455QJvyJNlvULfbjFiWPf?=
 =?us-ascii?Q?GyK59F/uTGYlPbbh4ToUt49z4WdESt0nyhGz0NDOLAmGQqpjQKw6lEWbqeHO?=
 =?us-ascii?Q?wrCHx4tJuLUSrbmC3tdXtFwKFfcC8BUgpvwbdAh4eNq3spZaeizHSRPryS+E?=
 =?us-ascii?Q?GqDSdC0lij3mzRDKbQmm0E48vDaDvLhdsc3bWsnu/MxFTw0dGICuf9tXz7Wn?=
 =?us-ascii?Q?pygMI45TovjRZd6gvB/qXkqZtydvlFls4y/A6ubG/KukO8s6pLkXX+o2MrTv?=
 =?us-ascii?Q?UZD5IFyIoFOW7pmNB6RebZ7izhRQlfTp5zM5L+HhLoeeCeU85QAx1bRqkB8Y?=
 =?us-ascii?Q?diCrubFILpbMFDQzltBMJQA3NOM/W1SZZKfSLhN95FLTKRxG04uOum5oUwAx?=
 =?us-ascii?Q?wX7rHtyf9FXtsy5TWcOAOPn+ifiJZ0fYXuSb8TvKcsKC759CQ/jODZYYQMfD?=
 =?us-ascii?Q?1/xrBGeyF2QmpqEpT6ML6jumZFloDLYgSGz1Nf6q7FqeM1bF+q731fNbZkAN?=
 =?us-ascii?Q?SQJ2Z/UMmO07u2dv2W01KauVGHgw25aeoLZwnJa6ossuEWrt/0qoZyZSnHqP?=
 =?us-ascii?Q?SRgLXaQYL2H/pLsi0syB0H6ACoaSMABepwxwwm/0e3WQ6dRimlSbMRg9yLmE?=
 =?us-ascii?Q?Tthp79/IyiHOCMcE4bKzP3/l/oQXOBiJchBsrOovXFbRYOTFCbUE0jXAzMQM?=
 =?us-ascii?Q?7QKzQ5GSom80fr+xrOx2H7U6Vo65I38Wxy+qXaf+ArLvpZ+lRuTmhR+ofxxF?=
 =?us-ascii?Q?bWVnOTqkY+xIykRXEMZZ6tGAqSjYZZIzt5zKSLme5/BEko2Yv/BXJXW8oCuD?=
 =?us-ascii?Q?8dtyzXQuY7fmhzfbaUp7lFDqv0w1GBL9ZXo8bvBN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3b5f6b-edbf-4230-bca1-08db1faa6d4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 07:55:04.1210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xpOgZUZyN8FllfBfyRGs1vIHWvNmpAttBn+Jhc/zjTCQWFpfmr582lCzi7NcvKaDxrMPGDTKtfo48S70yte2KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 3:47 PM
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Wednesday, March 8, 2023 3:26 PM
> >
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Tuesday, March 7, 2023 9:29 PM
> > >
> > > >
> > > > I really prefer the 'use the iommufd option' still exist, it is so
> > > > much cleaner and easier for the actual users of this API. We've los=
t
> > > > the point by worrying about no iommu.
> > >
> > > Hmmm, so you are suggesting to have both the device fd approach
> > > and the zero-length array approach, let user to select the best way
> > > based on their wisdom. Is it? how about something like below in the
> > > uapi header.
> > >
> > > /**
> > >  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> > >  *                                  struct vfio_pci_hot_reset)
> > >  *
> > >  * Userspace requests hot reset for the devices it uses.  Due to the
> > >  * underlying topology, multiple devices may be affected in the reset=
.
> > >  * The affected devices may have been opened by the user or by other
> > >  * users or not opened yet.  Only when all the affected devices are
> > >  * either opened by the current user or not opened by any user, shoul=
d
> > >  * the reset request be allowed.  Otherwise, this request is expected
> > >  * to return error. group_fds array can accept either group fds or
> > >  * device fds.  Users using iommufd (valid fd), could also passing a
> > >  * zero-length group_fds array to indicate using the bound iommufd_ct=
x
> > >  * for ownership check to the affected devices that are opened.
> > >  *
> > >  * Return: 0 on success, -errno on failure.
> > >  */
> > > struct vfio_pci_hot_reset {
> > >         __u32   argsz;
> > >         __u32   flags;
> > >         __u32   count;
> > >         __s32   group_fds[];
> > > };
> > >
> >
> >  * Userspace requests hot reset for the devices it uses.  Due to the
> >  * underlying topology, multiple devices can be affected in the reset
> >  * while some might be opened by another user. To avoid interference
> >  * the calling user must ensure all affected devices, if opened, are
> >  * owned by itself.
> >  *
> >  * The ownership can be proved in three ways:
> >  *   - An array of group fds
> >  *   - An array of device fds
> >  *   - A zero-length array
> >  *
> Thanks.
> >  * In the last case all affected devices which are opened by this user =
must
> >  * have been bound to a same iommufd_ctx.
>=20
> I think we only allow it when this iommufd_ctx is valid. Is it? To
> user, it means device should be bound to a positive iommufd.

I didn't get it. Do we have a iommufd_ctx created but marked as
invalid?

>=20
> > and with this change let's rename 'group_fds'  to 'fds'
>=20
> Sure. It would be something like below:
>=20
> struct vfio_pci_hot_reset {
> 	__u32   argsz;
> 	__u32   flags;
> 	_u32   count;
> 	union {
> 		__s32   group_fds[0];
> 		__s32   fds[0];
> 	};
> };
>=20

why union? Just renaming should work. In the kernel we will first
check whether it's group, whether it's device, then compare
iommufd_ctx is zero length.
