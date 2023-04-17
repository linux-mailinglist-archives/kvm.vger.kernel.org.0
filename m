Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB56E3E70
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjDQEUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 00:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDQEUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 00:20:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF96326BB;
        Sun, 16 Apr 2023 21:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681705239; x=1713241239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tVZHBasgHeum7ljNip8MOSwxpKZXnxDZ3FnxAqfVHEM=;
  b=Zt4WjNYnz1GKtzHWFF+mzeTmQHjmFzYMkVbaQ+VxvRRtVhkNnxsWq3zo
   aLRsjanc326vZfIjGfOdbGWfYEv1eQwXaGmLhg4uVfIEXYFX04WWPmHKG
   HzDdZV+6FBXEeATotJN3BhOZ/HtojEr9rEXlDiQAyEwiJNh2LVYfFxyFX
   hBSERWLibR8WNiBDEFXk9bdZgh5S4sDBMKMWr3UhFQE90RcoHgBgCjnTW
   njXQl4HbXmC5+g9j+P6Q/ojCYyC5wm8NazhF4SleBm/qalbeAM3Gd2qjF
   ir5FOlzOkYbaTK9B1diqXSU8FuYMSCZL1zHQ0tiHxnLltq/VHI7LZFqxb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="343555378"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="343555378"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 21:20:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="864864548"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="864864548"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 16 Apr 2023 21:20:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 21:20:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 21:20:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 16 Apr 2023 21:20:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 16 Apr 2023 21:20:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fe896OBCcaCQS9ui6qQh+qcxG3T4XwKXZusMphPIi9ysav76MaTh/N7ZtjeFsNGOdIGMiE13FV69BB7jijLmtttlCADiFjB8ApM3oh7F7/erM3vodZmIacVa88WYPOPoyeinn3Hz5wUt8bYKfgQc0QdoqgskQ0l01vfx14oZjKdPo15kfaDnFvW4BuBLRRzUlwk3cJhjUlvw1CbHLfKqZySiLDOFm9rmFZ0NrMN1OxOCuKSTwOtIo09tI1vEFw9j7/9RrNanyxTVTaaJy/fCi9HIHdsWaYzcL/gRUr0HYAi7ec5vQg9TMEdhW8Z5A8uxBSIw5ffOKPgwucu3hbEHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3JZYl5qPtuFjG14P5bP9U11kmCmIxzTRMHOSpPuF/Q=;
 b=ebnMHBMIcWOwdfQtn4tSqIujOBFySCQlIapA03fpSEAXgcTFNBw8MLiMKEiqS9k5tiRtadnkCHDNnzsYv16LLKbifsw0plQfUrsNdjPxAp/r57j6515zyp+vCJEtjMpyPdccqdyMW7yN8FzBhchF28j8DWXQbC+5bkfRfmD/7UwsXz19I4sJhh3dL0Arn79wJnqpZz0EfIzKoIKTyYAehnNkhIseUHSUksCe+sDdYyWPcLE9JshKkRTaznmwPx8thpgJbms0lACpffOwdt5JzR65zaYZUVfh+qlDE6UNi+fkY/N1qlPf0JLgs6jGInXLbSNl49OA9DijBLeAUF5FRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6875.namprd11.prod.outlook.com (2603:10b6:806:2a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 17 Apr
 2023 04:20:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%4]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 04:20:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQgACCLICAA9TGQA==
Date:   Mon, 17 Apr 2023 04:20:27 +0000
Message-ID: <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
        <20230411155827.3489400a.alex.williamson@redhat.com>
        <ZDX0wtcvZuS4uxmG@nvidia.com>
        <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230414111043.40c15dde.alex.williamson@redhat.com>
In-Reply-To: <20230414111043.40c15dde.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6875:EE_
x-ms-office365-filtering-correlation-id: b823feb7-84a1-49ae-e2bc-08db3efb129e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aGAAMl3DrIdp8bdzmBlIQUfRJ+M++0GUse1jkTckhToKl2g/KEoTn/S4wCwXGInaLHU1djLRM5j63YhswGJPvHm2N0SQ7dScmV8VEKVlHMGPJVpGroUQThkI7moUM4usdd4jzDiMDg6qWN0qwiwTzW1FvwWz+w4/jVnqAfphTQWoKa5/Y0IbtgXUWa2n3iuyKykDovwRv1aGwBjoYV7V7AuD2kO2fkbx5mRtyUGO1kCfvbaVtJpxwKOCkD+vQQCgqL7RdO1iLIEBiK2+/QryQ5veXAtohzcXHmFyDEIVxIU/KkPUWtml8wkpgB/NIVWrCMrnRfRNFCUNgQdCX+MRVwXJ1DMyKqpZsA+gJ3V0/brw/cRkS9E1z/kGjjDqTmm+yGG3i3UqmqQSzSn5YfKdzmXxyEzETwcNxyYHl9SlytiXkEKDaJMhHLi7eCFOx0jN41TYeq0LEqWn3TOJqIYKa61aAL5EqSUcOxF6cOi8I3IMPlYeH9lgMcflRwuCuMUab9p36wK3bhmYHgqzEfLcrld1XR07lRfVf2pvNimK+JYghfXQ6Nct19pBYyK5VY+cTLbufm9jojs9BwPu0yL+pQ/JJOf9+fR8OAjhdgg7wq9U+1c9Kf4kk6rlJdBS+UqL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(7696005)(41300700001)(64756008)(66476007)(54906003)(66446008)(4326008)(6916009)(966005)(66556008)(71200400001)(76116006)(316002)(8676002)(478600001)(66946007)(33656002)(86362001)(9686003)(6506007)(83380400001)(26005)(7416002)(82960400001)(2906002)(38100700002)(5660300002)(55016003)(38070700005)(8936002)(52536014)(186003)(122000001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sOn3ydglWKUPFbeXWqqRqPuxWl/cEvhs6sMS861xo4LhMJcYrzfKH1xuRBxJ?=
 =?us-ascii?Q?k1DoAaDPefyDugBzaZkbtgM4TOcNmhihNE5/DM4WHDcx8tARXkIuqEYy/c6I?=
 =?us-ascii?Q?tgUxAenOwbtiYAk8Ac1zIx0HXfbfB4UPOpVGpdNDA5NfU/DIWwr1wRJ/3naI?=
 =?us-ascii?Q?tXx9aBSV1ykX4c9TLNCVurm8gF5B5LZxXWeeOvXhVSf1dxIwPupSbWg3++sP?=
 =?us-ascii?Q?yPR4oU+tiF+U4746L3d7qpZjtEgO3WHGmJdPDF9qlxsDnsl07hFjC2jDBOaU?=
 =?us-ascii?Q?s7JvAONrxtM1+gWkhg9jrYlqlrqF+urgc5a0jpR4DenjlQOF6QACrVCM0Msu?=
 =?us-ascii?Q?Ch9g/GqTZQld2RtkWD5KbotpCTrh7koi6TlxzRNi29q0oKXSrDa+GWIxsj3T?=
 =?us-ascii?Q?3D8gG5i/SplecC89zRnVJ1lU+8eFew/8NjHxtmqJe9hac3qaZFeIWkaEjW8U?=
 =?us-ascii?Q?j/wMKUKyWP9o5/W/YFjhvgVivzukCxHqo4Jo091zk+VNk017txF21AsXx4YY?=
 =?us-ascii?Q?jAsCnTlJOqJpTCBu53O7eHAmtBQqJovF09TWCoQ/GkjRhS25UZaPoyLd6cz3?=
 =?us-ascii?Q?XkdvkNzpCcNjC0iGK758CIiD+QKrf6lX+hsU6KP3c6uXfu/AyGQCN+IuK1uX?=
 =?us-ascii?Q?Dw0THcoPMxY/n9EL/2dqNRgtlD7Es9oFegDerH6g3IjRvXHUaeK7Z/sgeBVW?=
 =?us-ascii?Q?PG+JXNhoZRvB8Iq4ElVXuIWnIhFaCkuWa6T+JBqMGuFKsmNFbKQrpzzCz7P9?=
 =?us-ascii?Q?CIcMOO6mDb9pMx7Pa57xYNxJcWG3wM6aXIQ28woebqN4SqHi5ux+8ywGgllm?=
 =?us-ascii?Q?LCVk942L05pkSiSVU/ej/0gySMstab1Tgo45RBztXoJKPRPHorwipDgW4g6k?=
 =?us-ascii?Q?t/jLjoEo/GQSLb2DFey06GPTVpfqcs4DlZthBlDMChflekH7HA/Av/UUFtaa?=
 =?us-ascii?Q?zO9iQca+QVVLZgyW6sLgMA9wSdlgX/pc0yhNWj2zySwzFlAIFREZPsNdF00A?=
 =?us-ascii?Q?ZJu8QUq2I9pE1sWkO5WnzbYfXj157GOwEHHYouDwh01SzYClk0kkQhIcqgE+?=
 =?us-ascii?Q?M0UwK0DIx4VhjrbXsg7fYvkpCkrXyUS7G8t+kJ4bUkCFaYQ17TA0z3U3sLmM?=
 =?us-ascii?Q?jD+JvRLVyImyfDlNKyK8AI6i2zuD6mm6AZ8TTyjXHK56MVHMe/4j4+qDJ2q7?=
 =?us-ascii?Q?cnn4IyevxYhEbogmoMQhpU/JNIrJzmRHqj8pzdQTRn0MPCh2BO7yjDBVz797?=
 =?us-ascii?Q?VNSW1OqirztYBA9y7s6ZY0HRt898gdfGKPzIlMy3wVseCyq2qojgNNEzsZ4T?=
 =?us-ascii?Q?3SiGuWFW/IvKmtK1wcnYcpA1lLmjqW6b0r5rNcryTsLASIM49ly+HHNeSdwG?=
 =?us-ascii?Q?Dc4QwRsd1+Aa3HDnVGSg9o/tv9E6WEMCq8cgQVDIGsh7WbppYhqdCNIWg5na?=
 =?us-ascii?Q?Irbg4cLB8rC3xISWuyW65m8HlHyUnED3yNJKf+cbM3tiF+EII2Xn9KWUvwym?=
 =?us-ascii?Q?sN9p1Vlu7DuXDHtC9eN+D9MdEibihLsNiyB1OWQRW9kbQyWpznbXkYHPze4f?=
 =?us-ascii?Q?wXTqHcMX3Uez90v2Fzg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b823feb7-84a1-49ae-e2bc-08db3efb129e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 04:20:27.2802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MBSaKuz8Kivba/NOrHx9yRZ5YgzuUh0WdYY/XLr+nhJtL8XiLVWVnws+SaeQNsg2WGFEAht3Dd5rysZ9+Bht8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6875
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 15, 2023 1:11 AM
>=20
> On Fri, 14 Apr 2023 11:38:24 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Friday, April 14, 2023 5:12 PM
> > >
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Friday, April 14, 2023 2:07 AM
> > > >
> > > > We had already iterated a proposal where the group-id is replaced w=
ith
> > > > a dev-id in the existing ioctl and a flag indicates when the return
> > > > value is a dev-id vs group-id.  This had a gap that userspace canno=
t
> > > > determine if a reset is available given this information since un-o=
wned
> > > > devices report an invalid dev-id and userspace can't know if it has
> > > > implicit ownership.
> > >
> > > >
> > > > It seems cleaner to me though that we would could still re-use INFO=
 in
> > > > a similar way, simply defining a new flag bit which is valid only i=
n
> > > > the case of returning dev-ids and indicates if the reset is availab=
le.
> > > > Therefore in one ioctl, userspace knows if hot-reset is available
> > > > (based on a kernel determination) and can pull valid dev-ids from t=
he
> >
> > Need to confirm the meaning of hot-reset available flag. I think it
> > should at least meet below two conditions to set this flag. Although
> > it may not mean hot-reset is for sure to succeed. (but should be
> > a high chance).
> >
> > 1) dev_set is resettable (all affected device are in dev_set)
> > 2) affected device are owned by the current user
>=20
> Per thread with Kevin, ownership can't always be known by the kernel.
> Beyond the group vs cdev discussion there, isn't it also possible
> (though perhaps not recommended) that a user can have multiple iommufd
> ctxs?  So I think 2) becomes "ownership of the affected dev-set can be
> inferred from the iommufd_ctx of the calling device", iow, the
> null-array calling model is available and the flag is redefined to
> match.  Reset may still be available via the proof-of-ownership model.

Yes, if there are multiple iommufd ctxs, this shall fall back to use
the proof-of-ownership model.

>=20
> > Also, we need to has assumption that below two cases are rare
> > if user encounters it, it just bad luck for them. I think the existing
> > _INFO and hot-reset already has such assumption. So cdev mode
> > can adopt it as well.
> >
> > a) physical topology change (e.g. new devices plugged to affected slot)
> > b) an affected device is unbound from vfio
>=20
> Yes, these are sufficiently rare that we can't do much about them.
>=20
> > > So the kernel needs to compare the group id between devices with
> > > valid dev-ids and devices with invalid dev-ids to decide the implicit
> > > ownership. For noiommu device which has no group_id when
> > > VFIO_GROUP is off then it's resettable only if having a valid dev_id.
> >
> > In cdev mode, noiommu device doesn't have dev_id as it is not
> > bound to valid iommufd. So if VFIO_GROUP is off, we may never
> > allow hot-reset for noiommu devices. But we don't want to have
> > regression with noiommu devices. Perhaps we may define the usage
> > of the resettable flag like this:
> > 1) if it is set, user does not need to own all the affected devices as
> >     some of them may have been owned implicitly. Kernel should have
> >     checked it.
> > 2) if the flag is not set, that means user needs to check ownership
> >     by itself. It needs to own all the affected devices. If not, don't
> >    do hot-reset.
>=20
> Exactly, the flag essentially indicates that the null-array approach is
> available, lack of the flag indicates proof-of-ownership is required.
>=20
> > This way we can still make noiommu devices support hot-reset
> > just like VFIO_GROUP is on. Because noiommu devices have fake
> > groups, such groups are all singleton. So checking all affected
> > devices are opened by user is just same as check all affected
> > groups.
>=20
> Yep.
>=20
> > > The only corner case with this option is when a user mixes group
> > > and cdev usages. iirc you mentioned it's a valid usage to be supporte=
d.
> > > In that case the kernel doesn't have sufficient knowledge to judge
> > > 'resettable' as it doesn't know which groups are opened by this user.
> > >
> > > Not sure whether we can leave it in a ugly way so INFO may not tell
> > > 'resettable' accurately in that weird scenario.
> >
> > This seems not easy to support. If above scenario is allowed there can =
be
> > three cases that returns invalid dev_id.
> > 1) devices not opened by user but owned implicitly
>=20
> The cdev approach has a hard time with this in general, it has no way to
> represent unopened devices. so any case where the nature of an unopened
> device block reset on the dev-set is rather opaque to the user.
>=20
> > 2) devices not owned by user
>=20
> (and presumable not owned)  We still provide BDF.  Not much difference
> from the group case here, being able to point to a BDF or group is
> about all we can do.
>=20
> > 3) devices opened via group but owned by user
>=20
> I think this still works in the proof-of-ownership, passing fds to
> hot-reset model.

Ok. let's see below scenario and user's processing makes sense.

Say there are five devices (devA, devB, devC, devD, devE) in the same reset
group. devA and devB are in the same iommu group. devC, devD, and devE have
separate iommu groups. Say devA is opened via cdev, devB is not opened, dev=
C
is opened via group, devD is opened cdev but bound to another iommufdctx th=
at
is different with devA. devE is not opened by any user

If this INFO is called on devA, user should get a valid dev_id for devA, bu=
t
four invalid dev_ids. The resettable flag should be clear. Below is how use=
r
to handle the info returned.

- For devB, user shall get the group_id for devA, and also get group_id for
  devB, hence able to check ownership of devB by checking the group
- For devC, user can check ownership by the group_id and bdf returned
- For devD, if it is opened by the user, should be able to find it by bdf
- For devE, user shall fail to find it hence consider no ownership on it.

To finish the above check, user needs to get group_id via devid an also nee=
ds
to get group_id via device fd. Is it?

The above example may be the most tricky scenario. Is it? user shall not do
hot-reset as not all affected devices are owned by user. But if devE is als=
o
opened by user, it could do hot-reset.

> > User would require more info to tell the above cases from each other.
>=20
> Obviously we could be equivalent to the group model if IOMMU groups
> were exposed for a device and all devices had IOMMU groups, but
> reasons...
>=20
> > > > array to associate affected, owned devices, and still has the
> > > > equivalent information to know that one or more of the devices list=
ed
> > > > with an invalid dev-id are preventing the hot-reset from being
> > > > available.
> > > >
> > > > Is that an option?  Thanks,
> > > >
> > >
> > > This works for me if above corner case can be waived.
> >
> > One side check, perhaps already confirmed in prior email. @Alex, So
> > the reason for the prediction of hot-reset is to avoid the possible
> > vfio_pci_pre_reset() which does heavy operations like stop DMA and
> > copy config space. Is it? Any other special reason? Anyhow, this reason
> > is enough for this prediction per my understanding.
>=20
> It's not clear to me what "prediction" is referring to.

It is predicting whether hot-reset ioctl can work or not as you mentioned
in prior discussion.[1].

"I disagree, as I've argued before, the info ioctl becomes so weak and
effectively arbitrary from a user perspective at being able to predict
whether the hot-reset ioctl works that it becomes useless, diminishing
the entire hot-reset info/execute API."

[1] https://lore.kernel.org/kvm/20230405134945.29e967be.alex.williamson@red=
hat.com/

> As above, I
> think we can redefine the reset-available flag I proposed to more
> restrictively indicate that the null-array approach is available based
> on the dev-set group in relation to the iommufd_ctx of the calling
> device.  Prediction of the affected devices seems like basic
> functionality to me, we can't assume the user's usage model, they must
> be able to make a well informed decision regarding affected devices.
> Thanks,

As my above reply with the five-device scenario. It still needs to get
group_id to check implicit ownership in the case of sharing the same
iommu_group.

Regards,
Yi Liu
