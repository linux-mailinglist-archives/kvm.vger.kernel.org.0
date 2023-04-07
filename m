Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0416DAB3C
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 12:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbjDGKKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 06:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjDGKKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 06:10:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572B77ABC;
        Fri,  7 Apr 2023 03:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680862203; x=1712398203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s2yYZQThUODi05IIRw985PDa6UYPzLFFEIC8HNQDZjk=;
  b=S/MZYOX1NWs2vFuHoxzX8pcx9NkjHDegQE90H/zLrjLREHnwB4ye3MAV
   vwv8W9L9k4sQSyfpJKOoSJtx9ixaiRoyA1JoBmrSqUr/wd5gTw/yHeFvP
   xitkpet/YkJGcu/onbwWyQAhscbT5fkd+LpXk2Gx9VoKBvUMaVTHFbSqc
   5Guf284aBxDaKRR95d49sH3QGkvWgRcffGvC2sMWcQ8Kf7Mn0V3yB9Gsz
   przZRzqz7gu0XfcNE+84/+XCj8OTc2nS6iYt8un69DEfnrShVtBnZEnim
   7pdPufUZYakHJKMxk6/4LjfRV5lScPZ/JHDE/arZMRa9wHpELF3nbvQfi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="340453819"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="340453819"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 03:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="687480456"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="687480456"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2023 03:10:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 03:10:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 03:10:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 03:10:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 03:10:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qfh83I1ksttkqy5los4rb/k93bFuLKcw92V0+M1zo9SDRbMPDrhqEcldPb9Jc+hZJIsXDbXBj6ORb47mkBDN6h2GNvD2ZrWh8AeJGdOf9iyYrGqcdujGeL+ubQBNN0Qz1IsIA9vjksl/IO4AsUfewSaBqfiijP/xwzvEABeBrQuSkYHDMgFM1VyTEdQH71r+9Mm/dsUvS7Ow8Q01YzTNAxZEymKW+ZfwcFemIRK6A7Hc/aUZv8i8M8ZAJpGP1pfGnrahyYu5gxg36MiSs7uEo8ugF+InVVjavLKT26Q2Oz/hkcNoKV2eLkr8cqHyyYLBeZcXtKsfxtsVkFrJnpQD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mgb8wZhewaw2uQ5lADCDky5Z9DKz5Q+FXJGFEoDBhnY=;
 b=banenm1gRcDloirm5GaX9CeNb5xpOliJ3wEuRZuNoVsqOPTIHNxmaw1gTSvARajI52x/4EhyIbJ+0icEMAUYjpzU2MyVMZAMjS5Qv+M+g/zUDCCkXJRcvO4UWKk31UyBRepQy7mkvxn/a1Bs/0KEeYLa811p0FvQBL9Ygtg2Be1MsRkbntm5Gyfz/Sbf0rKJOoAOTnCiW3SWHevxysMW2QGRCOMLn2WLRahSUHf/LFhLIEMMl0kGLu9DNU9946AuCZblbqxCUvAQSYtd8zeTEKMyDO2I3hEChMk+rMQSQmWjHlTnklpM8EAsyTHqsdzHhrAb7rnw+OEipHkWIW340Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5529.namprd11.prod.outlook.com (2603:10b6:408:102::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 10:09:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 10:09:53 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIABB4Bg
Date:   Fri, 7 Apr 2023 10:09:52 +0000
Message-ID: <DS0PR11MB7529E28277DEDCEDFBFE4A36C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-13-yi.l.liu@intel.com>
        <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
        <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230405102545.41a61424.alex.williamson@redhat.com>
        <ZC2jsQuWiMYM6JZb@nvidia.com>
        <20230405105215.428fa9f5.alex.williamson@redhat.com>
        <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
        <ZC3KJUxJa0O0M+9O@nvidia.com>
        <20230405134945.29e967be.alex.williamson@redhat.com>
        <ZC4CwH2ouTfZ9DNN@nvidia.com>
        <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
In-Reply-To: <20230406115347.7af28448.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5529:EE_
x-ms-office365-filtering-correlation-id: 16bb6ca1-db31-425b-7fcb-08db37503b0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PhoL6BVm4oGjMV8UKT4ZEwpRgmVpB0D4ICJ6Ysr1VYIndCsgb6EeB1mISlquaWgDhyp9V9wwiqkJAvTgxv7w5jSKp4OYya32mrYz1ZOzEXVbPCPPmSui+JzwJfE3YTP09PyY9rSX10QhFQW4cnvXAadDtLLI3Mybujk/nBDGUl3R9lqJ7dgdgL+Tnxh+h74MO/Ar8k328NLQAUVPoBgSnpcmpxdjiTDP7ob5S13XMBVj93YhKX9La8y6Xa5OzSQ0u8AelI1/YMdfkfZkOqVxmWJl8g/xt0ShkHJG+aroYoZ1i+RiNcwbwmKtNvNTS5+JicL04gLZemvrzFU2MArKDrOn0PkpfchiaGWstmdXHvYQClVGMT2JrZviWXPHUwRqCgMss2QnD35y7ssyvlxj+gbOg20y27RQEL2kj9Ly4EPhQ7MGAzik6iqmKcHOzRsCmK2R4YMPlsVJ3aME2kOcUf8Pebr8u66oimWcaVgj6voVLPWzxX8ogtu6ICbNTnJFpBCF1+1gYgYWvDU0P2NKoK17on+dgkkWW4W7FJTawBUIMnkDps55yLbGkys6Wev3UqjhlQCs91jRnmJYiMVXqaMEdBbOXASIbpyVOBYJpCK2c8jwH+ZHpB9g+FSm6auQRr8NYtusmIuwPPA6bY56cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199021)(966005)(71200400001)(55016003)(54906003)(8936002)(186003)(26005)(8676002)(9686003)(41300700001)(76116006)(6506007)(316002)(6916009)(4326008)(82960400001)(52536014)(7696005)(38100700002)(66476007)(66556008)(64756008)(66946007)(478600001)(122000001)(86362001)(33656002)(7416002)(2906002)(5660300002)(38070700005)(83380400001)(30864003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fmU4J+m3U/cmurfFrHs9ygoY9quqjbiTm0Jjmp7ib/TdWvhbHTdl+Dy4tc2/?=
 =?us-ascii?Q?KwuPK84v5b3I/shyjn64rAVCsyPsPepQY2mYT/I2YtqdQmwnWwEyNVAl2x+q?=
 =?us-ascii?Q?1FSeWytRRl/xbyrjVCEYyKW/ULOZCvjkzQeBofEfwvgGmg4/yyxhhDYjUWIJ?=
 =?us-ascii?Q?lQ/708ecayN5JoYieUJkmSb/WGoXhCijsSrLRZl/zq+cdYtEwUOljoqmBTCd?=
 =?us-ascii?Q?fSWmTwL3SnTTMSA7XMk0zYnW3qGlQjy6xwXuiPVQuSg4BE3AScVAskV5nEII?=
 =?us-ascii?Q?I27PZdbOLSaRZ/fUul3eYt8L4fE9EBsG/zK3+FHI/NFGKRCcDPJ9JwX7mmZ9?=
 =?us-ascii?Q?l02Ki3LtZCEnJ3zRYgJaodqg2bJqHO428Dn0hdSUNtDLWrwmCCk6uuH/7ThB?=
 =?us-ascii?Q?lO22Iq6E+KIHelrYcJUg5P9W5sZdc2QPDNWEmTXIK9yWtRPIcvh9hhe2FsCI?=
 =?us-ascii?Q?8nra5yYS8cG/JB5WvLd2LVXHJfg34oB5RWahiGUn/eqUyvRGAXzlofwNsnvt?=
 =?us-ascii?Q?rQkEL5C37iO0yj1cyBgshvQeUlfafCahkUBZCAgQI2bb1lYbsnxQOeUnE21P?=
 =?us-ascii?Q?wQCvnUmEMjpLQqR/gEzSmjyIuWiDiO90cwF+c5Age5QJB8NRSP1uKOJFQlr9?=
 =?us-ascii?Q?osa50FRLED4vTB985AeQOdpPvSbCOxs+G22RJjOwy4orBl5J8hOpx/KIqrxj?=
 =?us-ascii?Q?/XhTNCmr+U8d1BIj9gYn3S/LKLQ/fCilhq+0swaDCJ1qKs6W7iYY3bmhSC9F?=
 =?us-ascii?Q?DuwXHlRX8+tn0nJhPfx0y39/lJikopnarFQ1WVkNd1uFAHk3ixSmnQb99nwN?=
 =?us-ascii?Q?4nk7f5XP5cltn4FYolLlQWY4RI5ENnNcnTBIDJ2zgpP2rFr8y9kcJrbO1xAQ?=
 =?us-ascii?Q?FnjKZIEEevrCTL9OmUmGdwL+YcOEc4VIayWGzsQAFI17N1lduBOHge5qE0Mv?=
 =?us-ascii?Q?hPAt6XxR+GMlEXbKgZY76TVjXgLjehPXa+J5VJwd4mf0Ae/WbeUYHhiT6MdE?=
 =?us-ascii?Q?b1RtlrLsxxfvlCI4OW413ZlrQW86B1aOxEfHvMTXjv+GtJP8eBwoykJM6QCb?=
 =?us-ascii?Q?QI3+vHpGkC+KG+V8MOWdPSK83136lGHzVPX+SBoioZBrLMp9f3DjvHN/0YpY?=
 =?us-ascii?Q?QaoQZlvY+aiZ+ju58U9cg7OAv9O8erB8gYmAgguvV3Ypelj/H6LCa4BpVnma?=
 =?us-ascii?Q?AyoF/xUot76qy36wEwQ5w2E+D4WfOYpE/O6ojm5aOwn8wGKoqcQOUxz6D1Gq?=
 =?us-ascii?Q?iS75dnW7QXyLCHULQW2ZSzRi8bsm5kzgaF+b2AaLJzIe8FvGgyKo4l+XLGH1?=
 =?us-ascii?Q?WRSchYGL5jqWO0cCeXH1/MjU/VFYeLJis5maMcG7uMA2f1q51aOfWozBn7ie?=
 =?us-ascii?Q?PI5IJGpa4RFd2EC4ecgVRCsHVRa/Xj2CNed4/m1vIqXBNvqyGU4zAruF23jn?=
 =?us-ascii?Q?HjNxXeoLItD0MoA3VQQEzf7i5EfbqdqCpdJDuRz9dfBJb7/UgB3YW8giBCnb?=
 =?us-ascii?Q?fNdpmg7konhbl5DHH+J5uk2Ud1PAlgIXcIl6bejbb+sQ1L3eZROmUZW3Xx70?=
 =?us-ascii?Q?9/DvCOcIniLbsnJoEps=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bb6ca1-db31-425b-7fcb-08db37503b0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 10:09:53.0154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FNeTEh6JFYLexxsnPZ/T2R4khKD4CmV5Gou7joorPVYr5arLz9aApc5QHVpYFFaHbzr/QE2ABug8tJf1INvjiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5529
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 7, 2023 1:54 AM
>=20
> On Thu, 6 Apr 2023 10:02:10 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, April 6, 2023 7:23 AM
> > >
> > > On Wed, Apr 05, 2023 at 01:49:45PM -0600, Alex Williamson wrote:
> > >
> > > > > > QEMU can make a policy decision today because the kernel provid=
es a
> > > > > > sufficiently reliable interface, ie. based on the set of owned =
groups, a
> > > > > > hot-reset is all but guaranteed to work.
> > > > >
> > > > > And we don't change that with cdev. If qemu wants to make the pol=
icy
> > > > > decision it keeps using the exact same _INFO interface to make th=
at
> > > > > decision same it has always made.
> > > > >
> > > > > We weaken the actual reset action to only consider the security s=
ide.
> > > > >
> > > > > Applications that want this exclusive reset group policy simply m=
ust
> > > > > check it on their own. It is a reasonable API design.
> > > >
> > > > I disagree, as I've argued before, the info ioctl becomes so weak a=
nd
> > > > effectively arbitrary from a user perspective at being able to pred=
ict
> > > > whether the hot-reset ioctl works that it becomes useless, diminish=
ing
> > > > the entire hot-reset info/execute API.
> > >
> > > reset should be strictly more permissive than INFO. If INFO predicts
> > > reset is permitted then reset should succeed.
> > >
> > > We don't change INFO so it cannot "becomes so weak"  ??
> > >
> > > We don't care about the cases where INFO says it will not succeed but
> > > reset does (temporarily) succeed.
> > >
> > > I don't get what argument you are trying to make or what you think is
> > > diminished..
> > >
> > > Again, userspace calls INFO, if info says yes then reset *always
> > > works*, exactly just like today.
> > >
> > > Userspace will call reset with a 0 length FD list and it uses a
> > > security only check that is strictly more permissive than what
> > > get_info will return. So the new check is simple in the kernel and
> > > always works in the cases we need it to work.
> > >
> > > What is getting things into trouble is insisting that RESET have
> > > additional restrictions beyond the minimum checks required for
> > > security.
> > >
> > > > > I don't view it as a loophole, it is flexability to use the API i=
n a
> > > > > way that is different from what qemu wants - eg an app like dpdk =
may
> > > > > be willing to tolerate a reset group that becomes unavailable aft=
er
> > > > > startup. Who knows, why should we force this in the kernel?
> > > >
> > > > Because look at all the problems it's causing to try to introduce t=
hese
> > > > loopholes without also introducing subtle bugs.
> > >
> > > These problems are coming from tring to do this integrated version,
> > > not from my approach!
> > >
> > > AFAICT there was nothing wrong with my original plan of using the
> > > empty fd list for reset. What Yi has here is some mashup of what you
> > > and I both suggested.
> >
> > Hi Alex, Jason,
> >
> > could be this reason. So let me try to gather the changes of this serie=
s
> > does and the impact as far as I know.
> >
> > 1) only check the ownership of opened devices in the dev_set
> >      in HOT_RESET ioctl.
> >      - Impact: it changes the relationship between _INFO  and HOT_RESET=
.
> >        As " Each group must have IOMMU protection established for the
> >        ioctl to succeed." in [1], existing design actually means usersp=
ace
> >        should own all the affected groups before heading to do HOT_RESE=
T.
> >        With the change here, the user does not need to ensure all affec=
ted
> >        groups are opened and it can do hot-reset successfully as long a=
s the
> >        devices in the affected group are just un-opened and can be rese=
t.
> >
> >        [1] https://patchwork.kernel.org/project/linux-
> pci/patch/20130814200845.21923.64284.stgit@bling.home/
>=20
> Where whether a device is opened is subject to change outside of the
> user's control.  This essentially allows the user to perform hot-resets
> of devices outside of their ownership so long as the device is not
> used elsewhere, versus the current requirement that the user own all the
> affected groups, which implies device ownership.  It's not been
> justified why this feature needs to exist, imo.
>=20
> > 2) Allow passing zero-length fd array to do hot reset
> >     - Impact: this uses the iommufd as ownership check in the kernel si=
de.
> >       It is only supposed to be used by the users that open cdev instea=
d of
> >       users that open group. The drawback is that it cannot cover the n=
oiommu
> >       devices as noiommu does not use iommufd at all. But it works well=
 for
> >       most cases.
>=20
> The "only supposed to be used" is problematic here, we're extending all
> the interfaces to transparently accept group and device fds, but here
> we need to make a distinction because the ioctl needs to perform one
> way for groups and another way for devices, which it currently doesn't
> do.  As above, I've not seen sufficient justification for this other
> than references to reducing complexity, but the only userspace expected
> to make use of this interface already has equivalent complexity.
>=20
> > 3) Allow hot reset be successful when the dev_set is singleton
> >      - Impact: this makes sense but it seems to mess up the boundary be=
tween
> >      the group path and cdev path w.r.t. the usage of zero-length fd ap=
proach.
> >      The group path can succeed to do hot reset even if it is passing a=
n empty
> >      fd array if the dev_set happens to be singleton.
>=20
> Again, what is the justification for requiring this, it seems to be
> only a hack towards no-iommu support with cdev, which we can achieve by
> other means.  Why have we not needed this in the group model?  It
> introduces subtle loopholes, so while maybe we could, I don't see why we
> should, therefore I cannot agree with "this makes sense".
>=20
> > 4) Allow passing device fd to do hot reset
> >     - Impact: this is a new way for hot reset. should have no impact.
> >
> > 5) Extend the _INFO to report devid
> >     - Impact: this changes the way user to decode the info reported bac=
k.
> >     devid and groupid are returned per the way the queried device is op=
ened.
> >     Since it was suggested to support the scenario in which some device=
s
> >     are opened via cdev while some devices are opened via group. This m=
akes
> >     us to return invalid_devid for the device that is opened via group =
if
> >     it is affected by the hot reset of a device that is opened via cdev=
.
> >
> >     This was proposed to support the future device fd passing usage whi=
ch is
> >     only available in cdev path.
>=20
> I think this is fundamentally flawed because of the scope of the
> dev-id.  We can only provide dev-ids for devices which belong to the
> same iommufd of the calling device, thus there are multiple instances
> where no dev-id can be provided.  The group-id and bdf are static
> properties of the devices, regardless of their ownership.  The bdf
> provides the specific device level association while the group-id
> indicates implied, static ownership.
>=20
> > To me the major confusion is from 1) and 3). 1) changes the meaning of
> > _INFO and HOT_RESET, while 3) messes up the boundary.
>=20
> As above, I think 2) is also an issue.
>=20
> > Here is my thought:
> >
> > For 1), it was proposed due to below reason[2]. We'd like to make a sce=
nario
> > that works in the group path be workable in cdev path as well. But IMHO=
, we
> > may just accept that cdev path cannot work for such scenario to avoid s=
ublte
> > change to uapi. Otherwise, we need to have another HOT_RESET ioctl or a
> > hint in HOT_RESET ioctl to tell the kernel  whether relaxed ownership c=
heck
> > is expected. Maybe this is awkward. But if we want to keep it, we'd do =
it
> > with the awareness by user.
> >
> > [2] https://lore.kernel.org/kvm/Y%2FdobS6gdSkxnPH7@nvidia.com/
>=20
> The group association is that relaxed ownership test.  Yes, there are
> corner cases where we have a dual function card with separate IOMMU
> groups, where a user owning function 0 could do a bus reset because
> function 1 is temporarily unused, but so what, what good is that, have
> we ever had an issue raised because of this?  The user can't rely on
> the unopened state of the other function.  It's an entirely
> opportunistic optimization.
>=20
> The much more typical scenario is that a multi-function device does not
> provide isolation, all the functions are in the same group and because
> of the association of the group the user has implied ownership of the
> other devices for the purpose of a reset.
>=20
> > For 3), it was proposed when discussing the hot reset for noiommu[3]. B=
ut
> > it does not make hot reset always workable for noiommu in cdev, just in
> > case dev_set is singleton. So it is more of a general optimization that=
 can
> > make the kernel skip the ownership check. But to make use of it, we may
> > need to test it before sanitizing the group fds from user or the iommuf=
d
> > check. Maybe the dev_set singleton test in this series is not well plac=
ed.
> > If so, I can further modify it.
> >
> > [3] https://lore.kernel.org/kvm/ZACX+Np%2FIY7ygqL5@nvidia.com/
>=20
> As above, this seems to be some optimization related to no-iommu for
> cdev because we don't have an iommufd association for the device in
> no-iommu mode.  Note however that the current group interface doesn't
> care about the IOMMU context of the devices.  We only need proof that
> the user owns the affected groups.  So why are we bringing iommufd
> context anywhere into this interface, here or the null-array interface?
>=20
> It seems like the minor difference with cdev is that a) we're passing
> device fds rather than group fds, and b) those device fds need to be
> validated as having device access to complete the proof of ownership
> relative to the group.  Otherwise we add capabilities to
> DEVICE_GET_INFO to support the device fd passing model where the user
> doesn't know the device group or bdf and allow the reset ioctl itself
> to accept device fds (extracting the group relationship for those which
> the user has configured for access).  Thanks,

so your suggestion is to drop 1) 2) 3) and 5), keep 4) and add new bdf/grou=
p
capability to DEVICE_GET_INFO to retrieve group_id and bdf. In this way, th=
e
existing _INFO ioctl can be reused without any change. is it?

Regards,
Yi Liu

