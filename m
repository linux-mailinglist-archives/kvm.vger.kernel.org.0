Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF2D5B6583
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 04:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiIMCWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 22:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIMCWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 22:22:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCBB52831;
        Mon, 12 Sep 2022 19:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663035740; x=1694571740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zygJnuE8E8jvKNdz2OIP3JKDOMe0BkKnwQo47Gv3Gjc=;
  b=Y0BPYS77HKHeOaaXs4RrzGN/RENeQTOVQPGvTp/N0rCsWAiLjx5Dq+4s
   tnQq61wPRV5JACSoVWcGwYZO/tduqVoX9J++egqpG/o7+QUHrg8Jn1b0D
   w+4OTCIYcW+VUaIdN2sDVz8XBbSObiRuFlZQ4kL/7Mk3v0r0hJwiH8py/
   VGorf9SHDsrNkI15kDF0iGV7Ug5rfBa6BYzXXWKd+cSG/cnqIs+lYg5GC
   xs2eaB8lxebJX8wdySkGDRz4dBI1OCS7Ng34ieCn0aJaSQocnVNM/S+8K
   DY8dvMMlqInjV8J9XGeYpgRA1pnE+z0mVL8Ex1jIqWE4KJbwLfOadVq1o
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="299356267"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="299356267"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="791762022"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 12 Sep 2022 19:22:20 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:22:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:22:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 19:22:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 19:22:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGXqaJiEawXuTviv0p9HjvJTkbOB9wM2og5byLbLd8HqXW1dyhxS93WQ8otXaBYvlG+tJ4he8mYdrB9NF3ZvMAjhMqJE+oO4196RvVZbQZcPzrqmG6xJxZFXCZIifNwlQArLHv3WqaQS+O+0Oupoi3n0xpLfcj6hcZTGa5q1fR6eUpB57OW++WevzcF0zDMx2ihXCkpmHZP6r0H0+SsSmUjjoccn2oyGXBGsIomcnWuM1aATcXBRqP24CslV6kPPJzKw0j/z3g5yC4JM3NE2E4e4goTCbKh56LUGxnZCyotw1xgphGY5ORP9kMwWtwTdBjIEXaCa2hCve2Ugp0rGIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3sEiqT6mWiBMTYhk6cJclFLHy+CFuei8OxoHTPxlyE=;
 b=Wo/ZYQBr8PwGhE5PjfrA25VYX9l4dikH3eljdVYxZZsQ5sPLSJ5gkHDFEnqtGtXVttY4uw6d1nrgiFCg5+vGcvldhVxDUuTwEIAh7JTH2FwmwS0GzV4fWkHz3wlM0106hHY6ORF1hKwnPfVdstKZdHB3HpRHQNWvj9MTplhgYU/iFhlfUs1OGlOsWeWIR1v5oSbErrzVqHPHW1w1jbBmtUEg372NrP15I+75D1YfGUPmOaO1dM4UIORKSE6QcjgCv2+R2pnl7S9loxaK9dZe8HPMF9ebVI18WUPLAAs+u+EsTHg/wxI8VGH4uDAHNbsZsadl4OlYesO1gVrNzz/AQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Tue, 13 Sep
 2022 02:22:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 02:22:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Nicolin Chen <nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Thread-Index: AQHYsNLwCXoHuSRk00qOEfaHbTrxlq3UDMUAgAASXoCAAAVEgIAAM22AgAFUQQCAAC55AIAAuSeAgAARJhCAAIL6gIAFo0HQ
Date:   Tue, 13 Sep 2022 02:22:17 +0000
Message-ID: <BN9PR11MB527670BB3EEB81064DC811828C479@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com> <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com> <YxilZbRL0WBR97oi@8bytes.org>
 <YxjQiVnpU0dr7SHC@nvidia.com> <Yxnt9uQTmbqul5lf@8bytes.org>
 <YxoU8lw+qIw9woRL@nvidia.com> <YxqwQ+3OICPdEtk0@Asurada-Nvidia>
 <BN9PR11MB5276D4CDC551DEA5962F9A178C439@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxsshXKlidq8WgT+@nvidia.com>
In-Reply-To: <YxsshXKlidq8WgT+@nvidia.com>
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
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6287:EE_
x-ms-office365-filtering-correlation-id: e5ce67f3-a65f-4a98-18d2-08da952ec7ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CvufSMyXupdZ6hPSrHTaPQQRgcIKIy6wazEJlKOA6JLYffstT31snx8xeYpMW6u3DcZx3q+6q8TOAcHGS/cUELqYySFRzpLT3uoZAC4YnnM3Dnwi+M59b+TzxZEg7jQ6IFBlnOiZARjY548EnwdXox/QVr8Mg3ANoYUijZ21cl/7HUee6/cYEw+S6zzmlq72xitNmFCxS7V+ZY4aPS66leM9VWr4KFwZKRTiCDrEZw44mrXvPZ8bUsGUYeBncP7T0TJolQZtCpiOfdlk4UqPnItsJ05d0jLAjEFTRu6z2UPXg1nUDWY3iaixCqrDp54+6yaH7Gf0y86oahQQZGWb4cR9s9prn/WiNzzRm4OoeK8vw04MJ0wOfH1EaB7ikD1ZZ54bVvaiiNhba0PQSlzPVMu1pucJHVLeFCXMfyDOZNrLzN00fv7GqTpUdB3jcoc4OgRaDAquyTNIRMBkfMcFdWGictUZjd0otUMqePgpPWQxLFe8fTMuC+Hi9GkeO0CDxLZ1xwuFpMtXEkfPmzNYNr51YGhqYE0t0DfH6QSD2gz+SMeWWz2lXfadp/zOcgD716wNy86ldbyA6jgrC09qGJ6locXomAljelTl6aMZjxtMknofRGdz6A/b8TeIzg5OM2SQ5DNyvs1MSTJg62s+77Uy+HULTrJeClxZgEzVw2LOGHWH0W38KpG2lfTy2j95sCDKJDQE4xaDfZxQyhTtbG9Rp4qux+bb7NkzZ+IuO0/LcbimL0YP1RzALcNyk3sM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(396003)(39860400002)(451199015)(33656002)(38100700002)(54906003)(26005)(122000001)(8936002)(4326008)(41300700001)(55016003)(66446008)(66946007)(8676002)(86362001)(186003)(66476007)(9686003)(71200400001)(82960400001)(7696005)(6916009)(76116006)(38070700005)(66556008)(64756008)(7416002)(6506007)(2906002)(52536014)(7406005)(316002)(5660300002)(4744005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b4qeXk9yk5QzTjdJ3jnMCs1ixGiIWHfRF1YgiHM7o1kcAFatKoQ5Tb0N1ZWm?=
 =?us-ascii?Q?7vUvFYVzbOslLtFOKCjHUOWwkECNobeiQr9H3ycGf9GELBfzz/Am0c6x3o/u?=
 =?us-ascii?Q?wTMVs8rFQaSv7dZxxMrIndj2OTxhIeNvC/kDeasgnCXvul8zk4o+2V4w754L?=
 =?us-ascii?Q?ph4lQjDy0/st8JCQN3/61s0L6eGfFTm5t0gN2ngFjWJfy2UmrylEjK78ToqN?=
 =?us-ascii?Q?2NpZeVswFV0eZbNCO5zu2wbUZlbZINhZyeRZ9ms1O+ashlUKT+jiVcZXztTr?=
 =?us-ascii?Q?CotmeK6Iruz7auG0RkVJ13qDUpkpMMr0Jk/qVGrY/esSKZ2uuQwjpTflF84v?=
 =?us-ascii?Q?Ip93U5V+aDSPmt6LMXosQIR0StyNS9VYAWZVWZ0Fae6gG/kWvdgU691sUJA7?=
 =?us-ascii?Q?sv3+U7AnLfyQ3nQIcYgVPbNlbDGqefSyQVKX/BDFs+4ph7tteXb4lvnarIqx?=
 =?us-ascii?Q?Jk+GDVh0PM1RMOcstoBBU7saETKdcUf5mlnQcLFsd+l629bFC1pqdHs+WQXZ?=
 =?us-ascii?Q?Iee23pKgt9LDOIr7Qt44KL6N+D80pFnY0kQ/QpHx8yLM3VhuG4GPqYHNKw/v?=
 =?us-ascii?Q?Y54inkz7Hvb52dkdBJoKxQ3QyOlWvVqt7Gfl5KJ4vr4dNrgCem/aMsJR4C/0?=
 =?us-ascii?Q?QJv8MWTJXnwJJhLlPWyluM+0I4xy3yPgkc9ijTbYzCFs+74bio0kW3FDQx2U?=
 =?us-ascii?Q?6Lo4Lz1Tzdd+1Zg8hWa8ruC1Qdv2cSC6TXyOtP7yrm44lpFLRl15BYxiq/dZ?=
 =?us-ascii?Q?/Isv8ynn1JsRnQvSzK+RvQxtJ8FR5HFZAERGcsGvdAaxedkp9lL/qN7i/PC0?=
 =?us-ascii?Q?baFDGRLrMy0InZMcCJTg9e3rMF6WvZ1VlprLiBTHQ63ZODYasDOED19JVVxM?=
 =?us-ascii?Q?UXDURkGCzBpcACXmngM+4Qb3m4MupLOC08LVRRsObGT0iCuCnRVN0hRViH0q?=
 =?us-ascii?Q?OiR1gRIF8SbdMWbxSrs6nQvkwo5fFID34ePJOsuLqz28ibpn9mhCy+JyW2/a?=
 =?us-ascii?Q?UhbHCkoyz+UCB81s0JPwT1pij7cMgFE9HgYQ2BJTiQ8dufs3P3N+VMuuk3ra?=
 =?us-ascii?Q?LJHBPNCZeQSK6TUPmrPKxF3vWkXBFvxec1SM58OiFwSx8+helW5c+x5OIs13?=
 =?us-ascii?Q?oBGlvDvm4H++fCpWdTIlkm0IbksSOHGNqXTZX5rDVR+qGNBDiT+ismsqXm0b?=
 =?us-ascii?Q?udPt46R25GgtwlssftxrwfLyBNkV6YVSxQGodmoEMrOcvOjqwON80hyCN5yp?=
 =?us-ascii?Q?HdqLRZNkXZwqtvKd/zSq2o+v7Ns7w62nUvCsfvONISKv6ToQiGitBazLlKvr?=
 =?us-ascii?Q?KONzotzNgPNtvoWYxR3ztbFn/C6ZnpDrVvpz6FriWfCv6ujGwwIr3nXLZ05j?=
 =?us-ascii?Q?Z99MJTfaqOG88D4ft0x44nMiUY/twm8byKqiyK81GUXxcVIoWAqYVp5U4Rbn?=
 =?us-ascii?Q?dktqjoJGQ4p1tZq/wUAxURv/Ft41uRJBDCzV6HkyqLnbeK2ym9MbXp81hYz3?=
 =?us-ascii?Q?ssTk+BM5ZV7yMi8WBTVhU+YATdVbyqlQ94qJsAgHB39m0nj9Ye77ZetgNB1V?=
 =?us-ascii?Q?4tloqOtwtOjDysZUsRc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ce67f3-a65f-4a98-18d2-08da952ec7ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 02:22:17.7012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /H/LmOHGk/LV+KRBVGSs00g9G8hLQ0HGzLapZzpWY5xN0nFoEQgopuaQQLhqb/2GkrmbUM+Rqt1I3lDYrc7t8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
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
> Sent: Friday, September 9, 2022 8:08 PM
>=20
>=20
> > As discussed in a side thread a note might be added to exempt calling
> > kAPI outside of the iommu driver.
>=20
> Sadly, not really.. The driver is responsible to santize this if it is
> relevant. It is the main downside of this approach.
>=20

Better provide a clarification on what sanitization means.

e.g. I don't think we should change errno in those kAPIs to match the
definition in iommu subsystem since e.g. -EINVAL really means different
things in different context.

So the sanitization in iommu driver is probably that:

  - If an external kAPI returns -EINVAL, convert it to -ENODEV given iommu
    domain is iommu internal object hence unlikely for external kAPIs to
    capture incompatibility issue between domain/device;
  - Otherwise just pass whatever returned to the caller, following the defi=
nition
    of "Same behavior as -ENODEV" above

Thanks
Kevin
