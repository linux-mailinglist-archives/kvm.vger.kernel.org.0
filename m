Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C573A54DA94
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 08:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358742AbiFPG2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 02:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344922AbiFPG2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 02:28:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9AD56427;
        Wed, 15 Jun 2022 23:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655360930; x=1686896930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0uB8sKZR1bdRppG9lnIkuGIdy6JmhB1Ql271vOrPQTY=;
  b=k5SRTwq0a+/HzieEDsa0M8Zmx17OXNjDTWuNlHYFZ984xRXpm6wnAEWC
   PPkdwhGzgzmd86HVPxDXg/eGzzsPMYwiKejZbNA3tq8Ju677lpKPCVdWO
   zL6VWVwsgkrFF12tQoKGU7Ho8jr95mOp5hm/ElWO2uB3VM4XD6DVH7s5L
   Y4tTMpnopV8PU/9Igb0bkgcszab0BKTvuZhZW3OYOeoxCFA3QHb9xYOEl
   Icl3dkZBJhVk0klC82CGSUOUQyWyKSAyzyfnDo0YC5J1GLqJ0feCVDlqI
   5O15CUGU9R13QtYXp+TkoBW0arPyDcDTlr96TAWfq7CUj8zzwd8DgUx6P
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="340833850"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="340833850"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 23:28:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="589504400"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2022 23:28:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 23:28:49 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 23:28:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 15 Jun 2022 23:28:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 15 Jun 2022 23:28:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tu2+S0YNfluvuP/oCd2lP+t3ZCs01x+sZkqVRslb1SQZjP4qYzb8N8VpRy7ugt8Lnc/5hAxhnJqhMNtuvGzEtdwPO0YTfB3nuX3cas9Wcl+6Xc4AGhrxDR03/Vt91VnlHMihleq8iMLBoh4+fuCRcA1hm+jiti2VsclIKsJj4cwo2jnLKR6QRsAIg8Z7AlgQK3I54WzHUvLR5w+KZN5qsrWVh0izAJua6UEXfBpW3vRzv/3Kon/LZCiKG112IgBZQi5i4bY+q9Wz3TkcTfgJDNPVz+e63V+U+qJFZnJItWTTOk6m/K0/D4+lc5ZVYxk7AndLOlVogQ9yWOI1mGh0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uB8sKZR1bdRppG9lnIkuGIdy6JmhB1Ql271vOrPQTY=;
 b=mqQjXO+vO3Dhc2ymqLWKk+A/Hi0vi2b+MYz6lasyfRQBS4yo4AfSnZ06fDMwOheTWqnBOp8BHxK6BMugGjZoV4+PNiybq3TA+8Oev6ecYNM/dwH26FeLrzVRZCD+ga6Ymxjyy2ZL80hweVfd7kj1Wa2GCLufZMOrU8ESNUc/plCxR29RL7uKOtRnPT2sP2ukdVchCosa2yeI4tpAHM2jNauNHoXhkE4I8UPYreJkBCXE/RKVe0PjoCcyu/71Y+vwwooan/PcvCU/m13lsq6XiEeGJBCL6qh8CMio0Bi5S9DsQB5R17tfIJ5BG2Z3vP+KgGb1bjsFTiBcV+3leb5FCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by BN6PR11MB1810.namprd11.prod.outlook.com (2603:10b6:404:fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 06:28:46 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4847:321e:a45e:2b69]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::4847:321e:a45e:2b69%6]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 06:28:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH v2 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Thread-Index: AQHYgRSCE9FszAnpgU+hh7vtYPtk261RklOw
Date:   Thu, 16 Jun 2022 06:28:46 +0000
Message-ID: <BL1PR11MB5271A92E9C5BD7ED559D93268CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-2-nicolinc@nvidia.com>
In-Reply-To: <20220616000304.23890-2-nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d0fcac6-3940-427a-1d5b-08da4f6177ba
x-ms-traffictypediagnostic: BN6PR11MB1810:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1810C0057D7B70597D7A6FFE8CAC9@BN6PR11MB1810.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KjO4dO0YFTCZbugDtBZ9IKswgU+Vp71EWmo0r3NhA6tiM4ZEv4qxjQ7DGIXq0EYjBkabvLorm8kESs5yUyX/aXNElYDto463l/tVbon/eogBIrVoclZtLsV/wka9dcqwQ+a0nhrLpIrPw9J8syApEV9BJyr+m0HbACotgjC+XAG5pvR9JyHtyeg3J3JO39aXFnLCjmVY6SnHkaCIm4tUu7JozRArUnnysfFzZQyqiMiPzEVaq5UwitZPDw1Smp1N3pi+Gz2DufagDXLupG0JwH+RXWTbeivx9CV4dS4pvOp98tl6jg14zm9YDjmw/FGQiFJSWjosj1vQWdsKQM2dcEFBvQJgL0Tyo0mm7Ut8j0Kgs0PonbD7EReh86+F/uku5Eh2IoUy+JoDLDR3ehdfwX9U1q4VKaMsOEdA8NkRrFbxBANCmBzFktxqghBAc5LHm0ESAkYWDRqyvOMkZlIzNsn92//SSkohifseZhfttV5DzeMsI4Vue7h/lxhzd5WJItcHzgZ7LZ3j3z6nS0MAmRzDy9+6RMduzq0qL2LcW+ugTOEeuK6PjwhfLJKh6SywHmf7g6QOPB080rrFwPzeRrF49QdKqKhqSsxPdYsFvfKw9Yi4NZndE1hdgZilu1KLYOf/ZT/zMAR86/laOg8Ysy/61Q+2SXld1CVg6r/Q62NDeFvWUfwSVBx2uYhc7locV1EayA01H6oJ1ZjxtHT/FAkwuqwRj3LezTdiFIYti9E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(71200400001)(508600001)(8936002)(52536014)(55016003)(316002)(33656002)(110136005)(54906003)(83380400001)(82960400001)(8676002)(122000001)(38070700005)(921005)(186003)(86362001)(76116006)(7406005)(7416002)(66946007)(7696005)(5660300002)(6506007)(66446008)(66476007)(66556008)(38100700002)(64756008)(4326008)(2906002)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nSk2NWp8JscFQQR5zyKOlWKnP8TnVfAS15o4UzcgvC1AxRtjlTmnP8f1b17g?=
 =?us-ascii?Q?cgJGqKs7eQjW0urnx8MjoLTiilTyCXcSGfrQtjxNceOEPaqQLn5Xbw+eLtYs?=
 =?us-ascii?Q?BcjQV38n1QrSChjqJMGHvjzvlNHWDNBeUVPT1F/78fPNwJ62vPZHw9RCcAHS?=
 =?us-ascii?Q?WRHMl96s7tNzVbS2sASOKMrSWZefObmDjWea8Owhmy0wHgeMGALZ/yx9ZTC2?=
 =?us-ascii?Q?W0juNTiX6XpWnYzs0nRRBqx8Y95loHrR8Cv+qQbcxo6DHz1PY008U3SOsC9t?=
 =?us-ascii?Q?WquhaHYDPfsSlNleILuEurk4kTio+t8NgXI5FepXS2EaHPv4XJvLv4DcZDte?=
 =?us-ascii?Q?66Ky/daVylK6DGQ3+gcKglDLCPUsBo3+ZaXX/YFmqAIoC33irsi3kSsoLEl2?=
 =?us-ascii?Q?hwytVUT0AQIWv9CrdhpZ9Mh/5GbwwrHzI5UcA4Fu1zSzDzMa+gYeDNbvlj+z?=
 =?us-ascii?Q?JN/Q8wlR4Ge2HfukMvWobt7EGq75hZU+AUegznDb78qFjLbhbdhLGhwPONPn?=
 =?us-ascii?Q?G5IRhfv/Q/Ry04livtIipojGW9WEKrs1pfxOL79NFic7ImyRAALV+XcKX6mz?=
 =?us-ascii?Q?08Ebef4JBxEs8dQqowbaFI24P68d1tMHjIOr9pUylFtWAuYsg4gJaKLrgy8e?=
 =?us-ascii?Q?8YtZRL2SkSw7NovtxEEjcprXnko6NVyPh2R+X49M941qQciOy7HvUvvldvRt?=
 =?us-ascii?Q?zq18xVvapLA7CSIL7TF03clgb6u2EsrC+2ugVdXJCy0mYBcmKAVqM3fzyXP9?=
 =?us-ascii?Q?TqmX/MbeYIzH9LYRr+6Mp4ZETlwpBF7y+Uc9cGzLWRDuUEpDEhcKsFTfUkhE?=
 =?us-ascii?Q?o/psp4b3ebA7zoGTMvXtVHqDV+4yjlpVhfe+5xikgxrQEFRDYDhuslJlbXoz?=
 =?us-ascii?Q?jDkhI9ZGqPnLss0pWxGI+9Gqvhvr7xlmxGzkOdoeSRtvWkWOaAFa+3l3r/Am?=
 =?us-ascii?Q?8RJVxrH0A9rTtT/fs6AOBjISO1WQjqo0At5ZNT3s+J29P2DYO33tMCFNcPAK?=
 =?us-ascii?Q?3dtYmY75IwZ2H+hA494ljZS0i+OMz15EBZAOHPOIqxzFxYmDgKMe+0NmEvjr?=
 =?us-ascii?Q?uJZDJZC8tZsbh3TmGqqAIRdugT6QSHz/cgqEbSBeWSbQtWKT8E2aaxOTmcoj?=
 =?us-ascii?Q?yOF4KCYz8qIYXgHJ+SotG668kEk8yVudDahNGXECJB6DuDncqJBy1rkGM7EI?=
 =?us-ascii?Q?skFdhrmf0SoVIMFKl5jRxKltwiHET2ayrwEo8dsEJ55E0VQbUdfTUrOsx+QJ?=
 =?us-ascii?Q?q41Va1LcT+asptKIz/nH48S3K3ivCzogF4309E1uYROM/PTayKNmXXIkaKBv?=
 =?us-ascii?Q?TfrqKr5FDD4R7p5H1R92M8ii5vAz2KP8Q+8POkHO6n5L86CYuNH/l0FqA3lQ?=
 =?us-ascii?Q?WoT4PmzzO+f0WUiHDLgFuzlqosdmmafE0tsvq5hbyuY3JpXQY47uFGhuq0K0?=
 =?us-ascii?Q?3xRoX6hUEs/0uhuPr9V+mY5PDu5Y+5ya1bnzy6tNv9fnW8Ood+2RMO0h9ZUS?=
 =?us-ascii?Q?vF+2E4wa7yjLcxe4WNAb2ipcNuwN2Pmar2eR39Aw4f5EDG2+cB/7fP1S/Y3C?=
 =?us-ascii?Q?Iail6dr9qyO+K3vBtIMkJDqROJcpg9E07LnGehlVZdk1L16lKNeHyUmnCiNX?=
 =?us-ascii?Q?Fm8IMJQx081Kb3pS9EVxYROtnHupbHNpeU6DUeZFcd5xlVvySge+wjPDGIwZ?=
 =?us-ascii?Q?MqhKmmY6p9eTXkYExqlEHt2uXdYiwLP8f79DsPqNTpQYQRMvafBhl6JEEGsf?=
 =?us-ascii?Q?PK3K/CsnSw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0fcac6-3940-427a-1d5b-08da4f6177ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 06:28:46.5298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hseN5bjO1JkL5PjeiLFd917iT3XF117TA1f7kscH+RXgPT0lX7GfiXbY018Yu2lFz0OCFxrlg2EpoS3ZD23pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Thursday, June 16, 2022 8:03 AM
>=20
> Cases like VFIO wish to attach a device to an existing domain that was
> not allocated specifically from the device. This raises a condition
> where the IOMMU driver can fail the domain attach because the domain and
> device are incompatible with each other.
>=20
> This is a soft failure that can be resolved by using a different domain.
>=20
> Provide a dedicated errno from the IOMMU driver during attach that the
> reason attached failed is because of domain incompatability. EMEDIUMTYPE
> is chosen because it is never used within the iommu subsystem today and
> evokes a sense that the 'medium' aka the domain is incompatible.
>=20
> VFIO can use this to know attach is a soft failure and it should continue
> searching. Otherwise the attach will be a hard failure and VFIO will
> return the code to userspace.
>=20
> Update all drivers to return EMEDIUMTYPE in their failure paths that are
> related to domain incompatability. Also turn adjacent error prints into
> debug prints, for these soft failures, to prevent a kernel log spam.
>=20
> Add kdocs describing this behavior.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
