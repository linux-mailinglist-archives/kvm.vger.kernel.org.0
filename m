Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C486E5EEF
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjDRKfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDRKfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:35:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34009010;
        Tue, 18 Apr 2023 03:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681814109; x=1713350109;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SyQxVnfWD4T+TsNmLJjF7j8DaELQkT7UkB1h1ierSYw=;
  b=e31StdW42lmSXTaYuFycjAuDTjvQnDSqQ/pKDmep7Y9ceb2uhhg6cDj3
   NhMsg2mNbCzMJg1tTlhiRTWGGzaZeTywsDvBvMQKSB7MXGJUWk9o6hPom
   SRk7fdNrYEkMgx3Yoh1uapPqSX90bgBv5Bsx8VcfKQL2Wio7HWSiBf+AM
   asoDADpLalnMAa50ZeNAG01o+queolbLvQcxzhOWCTbZ6RrijcZSDOQPr
   K+jyXvaBeKlQqkenUv/+AiM9FeC4v19RmalYZcwh5HTblT9AEOZEWFKgE
   pXZdLd80virW8zPo3xiaP6cdA4CDrTIOBjTggb8B1wTtYQJSkuwjv879H
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="333938019"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="333938019"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 03:34:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="755661296"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="755661296"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 18 Apr 2023 03:34:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 03:34:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 03:34:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 03:34:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 03:34:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRts2Iq0wCfpdMXeaSgAaMkhUamDBLXQ8pjkpsHZ/4nLdIi59ump6D9Hp7LySNVxIGcQTyUpisEw72lAYy8H9K5ze4AJmQwXnEoao1Aj4m4nCA96wNN9QFNdqsDu/rgfWCJTS14x8YOUO+fw7uHo5zuGJY6QO8q0xmqyu2303jca/XMZE54aSRY2/OAqhL4WIgZTHMkG0leb5AA7t/Nop/ZLZfBPs8ryDcChFzDLDiXlDCbCwKTEb8bqPsbFF0Ic12EHCmhgCvY3hPxC0smOJ5Vn/WXy+a/zfOKW4Xx/91PrCYHtEbxWTFKKUCFG/EDAgiNmBAtd2hFe/OJHV+L3Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuEcLYxqX8i3EYYurTfI1iYyUqlPiMy/phmt3TM3EVE=;
 b=KYlbyZaXtB/3Gt6yenUPDdRYEDhjDTpMkWcgqFVZJnIZe4sAD/aj+CavQoW4pt2PeVjDrMcIwpcTiARn9Go5+lqbujSfOxscWBmQlqSqN3NjJFBlqxPCcOgD++TgYXn0ZF5FoSgRudznSWAdOyQgqJ8nBzRkA9A0ojauD33Omb1KXbpDX5OzTL6DWU9WXDvVrO0i0eGZFvU9wlrfdCiz31SOpYCLerc3nkZfvBc5yG53klN8/UOnicNmH4rVBe/Lqx4Vzg5xqTXGUM0cgkSFWcUUAjJHg7ZOVNpWLDZt+n9Lh/t6hV88ha58k9/WK//uPyt/23VAq+ZnhzmxCy5Xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB7156.namprd11.prod.outlook.com (2603:10b6:a03:48d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 10:34:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 10:34:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
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
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQgACCLICAA9TGQIABATgAgAAIdQCAAAm2AIAAemUAgAAMy4CAAGEJ4A==
Date:   Tue, 18 Apr 2023 10:34:45 +0000
Message-ID: <DS0PR11MB7529F0992BD2C5CAC1BEA088C39D9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <BN9PR11MB5276D93DDFE3ED97CD1B923B8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230417221033.778c00c9.alex.williamson@redhat.com>
In-Reply-To: <20230417221033.778c00c9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB7156:EE_
x-ms-office365-filtering-correlation-id: a3e6bdd4-f93b-4ef7-ee56-08db3ff88728
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgTaNouAYm87GX0FG9nFVq9Ek9BghTa/pd2Iybk16t2CHS3THOn/04Gp1K8btVB7e92frOJl1Rp9pBfF7D52Q73npwFEBWfB+7t9XD8FqV+xJD63ceOVDwviqX1lJspqLvAghQLLYU/PaT6Ex+jM3GxRX10vwp3wl1mNeH9IhAzYC/IG+chHXy2aDaWWzZZN2d00DpcGlv4Hg3OIXdt+URWwctR6JPT0pMOlONY9TxnGsiro0xMBLMCtdqssb4L5shMgKUX3CSMB74n2sFq5VJtFtlwtxAtzpl9gH3CGuwIpM03ptkdWxAUY0I9m6oN8JVT4fNz0GElPiZxHJOU+WgJCVA3Mt7Mc0CHD/hmlvPAeQjVYjlTNd41vCLa+qkwqx7xxpL6q0U6CJmByeRd2hAz7Qh2WeY7UxC8OpuEaZfGo1dV/82r7C/3l9sQzCQec23R/N0jWbgQzTmCUvvlynyBHe1N4F81RpEA2FUyFh1U4DMVMA/pdzblvLMmgr4Mlpn1qgkcTWlKg4PkIywv55GCZ7/fGdA0aAmGpIIseI2Qs89w9E2vo2ZoMax7sV0SECIyTDTrDOzZsQlz1+YyO3BFQHFh+JbOJ9uV0hxNIDCfTM7CugBUhhKaW4nX44N6q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199021)(6636002)(4326008)(316002)(54906003)(110136005)(76116006)(64756008)(66556008)(66476007)(66446008)(66946007)(33656002)(186003)(6506007)(9686003)(26005)(38100700002)(82960400001)(122000001)(83380400001)(5660300002)(8676002)(8936002)(478600001)(71200400001)(41300700001)(55016003)(7696005)(52536014)(86362001)(38070700005)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dDMCzeSdHprpF37rrERNPdxvImCmGXzyx5szqxeTF9NvLoGVPwm+i+xPiffk?=
 =?us-ascii?Q?aPMOFq3Kq6YIUcGNDRisjN8hxT0/0TxN8L7MD6ukpG0SLYfZmG48sy7CN0VT?=
 =?us-ascii?Q?pIICzNY/FSHWdNVmQfJhoCrnevI2EsV//5cctYUgIjenlB5KCyziy/BdACAV?=
 =?us-ascii?Q?SGZOOJe4btYEou9jz9nmyei5o+5L63AsMYUdlaxJnn8N6PLNn1oIyb/4GjwZ?=
 =?us-ascii?Q?ZA9/9+HWqbOOSiBdaDhHay/fns17qLsK+coIXlZg6JmG2fWGC9TMyyZzldkw?=
 =?us-ascii?Q?Gm07xm0RMIIv29IlyPqZV7DOTfdHA9EJFqS9z+8BXAejbhwMq98mttZaV+Nj?=
 =?us-ascii?Q?wLuULtDVKtMg7dBunFEb8sFotnEUhv2O5RzVcbXzhtXKLIXGJ6GvNpLF4i8c?=
 =?us-ascii?Q?TQ1VafXWHxE4RlZG7XzKZmDpQwSCgEyX3UOMTTItp275zQCptxqtW5/EB5/Z?=
 =?us-ascii?Q?peIcQouYNjpf/Yk2gETTUse0mXgKjRmhJsmMkbr/51QO1HBz/8Roh1IEqY29?=
 =?us-ascii?Q?qmvVXaYp1E1PrmKodoCQyK+wWtfRroqsQAt6l+v7tTIsNh9Tg+fHsgArNKM/?=
 =?us-ascii?Q?tbuQ5Ghjmz4CZ3MAzjmS/HNudFkM6lNrHbBatDn3rtynN3vcA9s2mJH0gE2R?=
 =?us-ascii?Q?NJ/C4UNMVVmeRDEHAtKZefkCNa/IKUYCCau7INfrj3uKy3KbsIbex8dm8JcS?=
 =?us-ascii?Q?RbXsIwh/ottM0u1Sq71L6iX4msemaSQSnRIYVyJYS9F6SvBKhDHZTw2XqhxJ?=
 =?us-ascii?Q?EFtTwlkbIMMKl4WIMQXTXvIZO0b0i5hvWYbycPkR9x+5XPvCsClwZVLC/n2O?=
 =?us-ascii?Q?TkF5tEDCFIKinFd0I7WIkwryQVZCttA1qECMTIF6F1rQ0fDYFGma49ktnjjC?=
 =?us-ascii?Q?vtXUh4J1NxOmi1kMTzSdIllQU/LbWK+WR4xmympLom9gmmNTAFXUbiCLt1kE?=
 =?us-ascii?Q?LS9Rj4Lv8vq3RgE+saz3swQdFY0mFQlOsKdULnBu5bUKXVPFdNpQ1a+J/Xmo?=
 =?us-ascii?Q?xf1TbRmbmGTO77XdKUBCOfnymB7qjSmC8cSd3zfTQTb9LfBQl5Zzd5DRC5Cu?=
 =?us-ascii?Q?t7DuaNi5u6etQ2Fu9/P83u1n3HoGCeaEyXvXfjmneVPLICvt4LPb7YnZeyIX?=
 =?us-ascii?Q?N7FX7A7OMvUZLFObGM4sQv109Hz2qB5aQCwuMjZYbG+4L2a7LBRPX2KRbGAN?=
 =?us-ascii?Q?32rJVxIdkBwehHspUwYJ/7evif1kP5eGOHaTfvaq9tIeCjowg2ESBKBGuVn2?=
 =?us-ascii?Q?BY4LQzOMBsQF5EwdmJcQcBDf/JlmFXszMfuBbeLIf4ytlhSIe1YyEZqNkvMc?=
 =?us-ascii?Q?VCHb6Uk29cJrZuIIA1AGHkwF5oNFPdHmA6LoKZSCJHNlDPAKZfjfqPNmHW/j?=
 =?us-ascii?Q?dJXHvoTKxYCgiUTX5MJtt5UWa1w5dJpsPA29mYuL5U0MgLnoCy5O0yBHXrb2?=
 =?us-ascii?Q?ygPMDDCv1Y528yD+MEkihfis6SuKr9YTR1WmB71s8+wlXqKQku6gSkmLNyXF?=
 =?us-ascii?Q?xy6Gp9K0MAgt4uU0pD6OUx8lZAgqnTqMJ9P04CJdwKRER2qv0xcgs8fmrpyE?=
 =?us-ascii?Q?VH/12rb+NHsn9Q7jkvQvu5zrNwVMFVpSCiBcJeom?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e6bdd4-f93b-4ef7-ee56-08db3ff88728
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 10:34:45.4021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8h5h7itUF2biFkP2e1rcTw7D4L4tCgshC7TURr31UGJq18zhrCemA2AnEbHuCYx4cWMJj+uJpDPWRlPy5y4ZEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7156
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 18, 2023 12:11 PM
>=20
[...]
>
> We haven't discussed how it fails when called on a group-opened device
> in a mixed environment.  I'd propose that the INFO ioctl behaves
> exactly as it does today, reporting group-id and BDF for each affected
> device.  However, the hot-reset ioctl itself is not extended to accept
> devicefd because there is no proof-of-ownership model for cdevs.
> Therefore even if the user could map group-id to devicefd, they get
> -EINVAL calling HOT_RESET with a devicefd when the ioctl is called from
> a group-opened device.  Thanks,

Will it be better to let userspace know it shall fail if invoking hot
reset due to no proof-of-ownership as it also has cdev devices? Maybe
the RESETTABLE flag should always be meaningful. Even if the calling
device of _INFO is group-opened device. Old user applications does not
need to check it as it will never have such mixed environment. But for
new applications or the applications that have been updated per latest
vfio uapi, it should strictly check this flag before going ahead to do
hot-reset.

Regards,
Yi Liu
