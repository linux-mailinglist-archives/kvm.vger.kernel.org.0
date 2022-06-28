Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0255CB9A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344383AbiF1JuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344360AbiF1Jtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:49:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DF525E8A;
        Tue, 28 Jun 2022 02:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656409784; x=1687945784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jBhvSk6IuOJO2NlNBwY7CCOgDYWrZ9nwebHFECj+zWY=;
  b=jiqPq9horSFlQph6G/f3vnD+yubttjsSGbawePYyZ5zjMwZI1a8JBaRD
   3EGx/wAzu33SE95gr79VxYj5c/pN2GSiBgQm77ypy98PJzLSTAQ4jEfI5
   xzpC45ThXLuHlWECmFnPuBUtG1s06YlXR1zD4KOOx1bDV+C5lYNsWOuly
   AxJ1zSEtsEIJ5DDhWa5Av2+VaB8jbsOf3RBqkBGesYgxEwGqIKuIDZuzJ
   tmhTfdsGxZ0tSs5wXuR3Fjfv2CGZLGMkSL2g/lOOGmQDOSQXNUWEcBrCr
   jiZiknrBj6t82+Fr5/9/yPMVFkk6dams/yCTDQxbm4W6ktnl3e2exYoqN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282430492"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282430492"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 02:49:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="693040477"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2022 02:49:43 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 02:49:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 02:49:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 02:49:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 02:49:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFS+v9JpesQFQ5iwvDrTa2ltYzvrCHwcM7dYBR7NWP4y//k5s8W3Kfc84REE846/FMk4QZgFTJA0Bo8dmPdQkUcw5c/IPgDyjSC1GjW/jtXC4cWOJ7elRxNr4I5tlRQQNNNaTrEG3SAGU5FC7Y3uDBMdfQORgSlkGvgeQTzbmCkxDY423WKHWKcl+bN68ALF7/VMK5DMB4aBfJCMED/ioLVDlFj8V6AmvwNwQCVUdSl9BJGLGWswtbkpf90UfpWtiJFVzxPjLvfg4bGpCsuR29L48wAcj+NsJaJ6b0gnAo9tWRF15YZ9bZWaVADuk6ZS8+iMaE9tj+2p+f1hLNh+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBhvSk6IuOJO2NlNBwY7CCOgDYWrZ9nwebHFECj+zWY=;
 b=CxFtSv8zOZORbYcQmEm6B9pyW73hiBPf+GvaGtjOoTRok0K/9V2mDBbkqJuDB/rULRLEyQZJf98R0P3RR3ApGKGO83MzcW6tPnv2G/pXiYb1X0J2zI/2j5bAB8VAa0SST9YgpPaKiOVQZ3nLwva0Rdn3RHTgqm/7++CSU7wQiG6dvzDrgsaum6iL8Y+OzlrqOkFQwoG00z6ZfwxsWWFaE9plneXROjcUovZonqVC2+N5+jMyWiv+w4W/9xF6Y4YKNmWEn1qw20Erzg9dz+/e8gJE2Vg0g3ot6veyG1TIHKKYoyiL2d1UWVw7M2HtXWXrKPDe0kmPyaZge4cHlKIUpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5233.namprd11.prod.outlook.com (2603:10b6:610:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 09:49:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 09:49:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 12/13] vfio/mdev: consolidate all the description sysfs
 into the core code
Thread-Topic: [PATCH 12/13] vfio/mdev: consolidate all the description sysfs
 into the core code
Thread-Index: AQHYiq4iIeDUHa2vf0uQztbkjfSPBq1kkmDQ
Date:   Tue, 28 Jun 2022 09:49:17 +0000
Message-ID: <BN9PR11MB5276904E0AF68462FC2C5B898CB89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220628051435.695540-1-hch@lst.de>
 <20220628051435.695540-13-hch@lst.de>
In-Reply-To: <20220628051435.695540-13-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a4d8ac1-2698-4ff1-4be4-08da58eb7780
x-ms-traffictypediagnostic: CH0PR11MB5233:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kbFvXCYxUUVuD4eK+HmoCFihuEunszlfnIl0ALSqL8krkiJV3A1Wz2SU787twWmBFgbbDm5Yl6HaeoBNQkq1XZPWIhaVU2GCBVPasN/L7H1RJ1RapOY43kQK25UnoSaumtKzBm/F+x3mV/aAckhc63RYYIY1UXCmEjL2foQLPLi22CK3Lawk69Ir+qx5k0Yrifomtyj60O2ggUAFw4THgcAaPj0WpadtX3MCHVUtrOOTFjNslPrIlcHrivzK1qfdwKCXD8SJfY48Q38C4VdpWyg34FztC/f1w5mGLW+vqIJk9T9lKBHIxN5OH8OEpUm+kZOpmpzvWT0YX6vXSXY6jRVVcggeT2tG+nB4ATL7cj2x2+EGfBasA4JZhVIBsi0nNZpN10X1Fnm+DJiVIJDPsdKuMg3LCfRBkuqF+CBInpd6rI3oPxHGlhSZBS3HGwiThliNb1xYJjJG0snCILXb5iYeA2is9j6U8HTPzQ/OUvo4nIpFSHZtbiOXa2x7u8nvySKaKB+SE8NFCSmSlw7Eg+pYPvv60mJZRAe9HWSSJs57P24JjHYJmMyp8DgI0wYK9EKm90lR+ND7Wz+lxEuGApTio5c4cVtXvFVasQOw5xjh9lmgUbK9cwtl+UmA5/SI0M7UmYoOf/xvIfyLEeT2oPN3UpzKFVPaAaDxM/rA5H7Q6TRmWlgezaS7sEWIMOkWF31QVtTXSHnAXyHfkvS2fWR2xR3P3Xe6XR/DrKIyMjA5S3WNAn3aXbL/p3fj+T1fE0teZ/bVi9/BxlDGhhWyoW9NQLxyon1+eWPEm7OtrNa9r7mwNSxDGuk6SXdD9ik6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39860400002)(396003)(366004)(376002)(7416002)(55016003)(41300700001)(52536014)(478600001)(110136005)(8936002)(71200400001)(5660300002)(54906003)(33656002)(186003)(38100700002)(4744005)(921005)(9686003)(66556008)(2906002)(76116006)(38070700005)(122000001)(7696005)(26005)(8676002)(82960400001)(316002)(64756008)(66446008)(66946007)(4326008)(6506007)(66476007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5eRIjjxmdG31HLhzJWVX2Cm5c4acWR4okqbDr6v3cbXDPMKzchb3OIhj/crG?=
 =?us-ascii?Q?mAafRKki8iKoePlgGd01HwCpPBJiGQrSeh+KG2zRQa9hCzjZm6E57au68RFy?=
 =?us-ascii?Q?z84Fyll6eNpORNxLBsws+sb/x9lDkEJDl+urAqgM3g/+RWQV1YIo3bMCB9ZB?=
 =?us-ascii?Q?jBq0y9nVtxQ/Q7N6BsPDvy/tg+1oLJC1IwdcCojKoNFuxeg+27IjRFR5KSlJ?=
 =?us-ascii?Q?normA5Y70+6AbQ/5R4jghmuK4hMuTyOowSYwuo10aljJfL95Ii2d3w7VxOGh?=
 =?us-ascii?Q?ysMELlCBjIoFRpMcwYU9Qg/ua4uBru/Dl7VT5Zwqe9bQmrkxtf0h2SQcnsek?=
 =?us-ascii?Q?a1AWNI4wpBg9ymbv7U8OxMhByHsHxFF5faa/DPb3WHReGPtq4D/lM5Ww62xk?=
 =?us-ascii?Q?iWNYo78+UhLNvPTe+wdRLhFNTw4lhnrLUarQPXvsukCPUSLqi/sBpFHCbBc6?=
 =?us-ascii?Q?xMHgBrq/25NfRWyqHyHUOM3pa+Z1aEOEMajEE/rvMlyl2FYPgy+FDn3olGBl?=
 =?us-ascii?Q?nj+kLUboZkKB4vKEcfkf23+dBNlcU/CFEdTG1qA1RlEa238ag7xFu040cPUa?=
 =?us-ascii?Q?i7l4PgiDJ0JrX/sSfWCvgTRonFKMRSgtZ+ZZYIRUFerdDjDWvFLwRYVh8SKn?=
 =?us-ascii?Q?iZm/iZk0gKgtF9t8o5efLM/nMlGwLnC3f9hWaVOXzZDUtgiEa0Tml7E/aWla?=
 =?us-ascii?Q?dsj6LZCe0rq6ojsa04PvjLSUN9qfeqcHVHaVNMSh/mnIAtufi8llRGAdLDLD?=
 =?us-ascii?Q?Cb60o/lcp7sIr3WNDPaeZA6hT2abFogVNnjiZFtxo7ZdUDxcYliaiWUzN6k8?=
 =?us-ascii?Q?rvMDuAn5R4u3vDI7om8kGv9jkLaYLC+5ZE4yAbrfWYntW5zC2jk6lx67Aewf?=
 =?us-ascii?Q?J/C45F+oKjmV1aMEwhPsGdaQPjZsdH3mARnkzSsT5iXvRo13nMVos/gp9wxZ?=
 =?us-ascii?Q?MMHS16DUhPWV47Dnwh0KN4j/+5Tc5vg6vrfti1b2NyHEdz/Qg2sbirgpG0da?=
 =?us-ascii?Q?PJZRD5OgwdFhlXmFjP9hFo9CSsv+d7h0XsFVnwbeFxcNbbWI/haXnv86erwy?=
 =?us-ascii?Q?Ooo9Tpznv3D6I6fs3EJFJUZYxsw+OvRct6a8TuKrY3U3z2bUPk1pFm5pkbvU?=
 =?us-ascii?Q?RCxO+27JwLwVaEupbn1jDrVPomm6U6KeAPvM6LwUQvsAK5iPrW93qCOMhtJm?=
 =?us-ascii?Q?NcYURrZ0aC7MBngK8Kz0/aslMErj2hP8CzE2c4yHVULVdN2tfnzF/2yY+pFo?=
 =?us-ascii?Q?sZVG3YlGk48kz6q2nmAUBJvd6I8EOXJj1/Rje8udwg+aKADJ23rqeo8OzBAP?=
 =?us-ascii?Q?mNHUl9U3ng80D1uWkV8tO4yy5nGtV3054C+O1OWhpS24XGLMSolaULtsklQe?=
 =?us-ascii?Q?Rp+gpzwcDaZKKMnD6Qi3FVT2lMh2AVILAlJPDSe6LXF1V9M3KbBYoWqYZgEU?=
 =?us-ascii?Q?0myLLsVIMqwxdqnHwnqzeHHJ3fcxFoyFXy74+dCaj9+bDTn9Y7qQhsOeKWX4?=
 =?us-ascii?Q?r+9CSF7XnwCgr1mUBH3l2TnqqGEkj57M4DVZDRdhKwI1FLNSPn6D83Z/+cig?=
 =?us-ascii?Q?cyNh48T9VuACyw5qFApD6dZoDqiyaKYL6x4LiiB/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4d8ac1-2698-4ff1-4be4-08da58eb7780
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 09:49:17.1333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dDGKeWjXJ2fTnJSlrP7/wS7F1jRbSkJwwQf6qSf5lIFZ3VsvCmyMLX+wSl5ANShPE58MFqSNkexD1o8nbtshlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5233
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 28, 2022 1:15 PM
>=20
> Every driver just emits a string, simply add a method to the mdev_driver
> to return it and provide a standard sysfs show function.
>=20
> Remove the now unused types_attrs field in struct mdev_driver and the
> support code for it.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
