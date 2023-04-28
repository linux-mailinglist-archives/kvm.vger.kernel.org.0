Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAE66F11C1
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbjD1G2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345161AbjD1G2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:28:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAEF35A6;
        Thu, 27 Apr 2023 23:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682663320; x=1714199320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W1y41Wr+0oCOw8SeXQZTqD1acnMqZPiGddlsJyP9OPs=;
  b=aM+xjA7rxXgx7NN0l/blR6RzItEWJo+p9uiYkf3jJ8oSmlsazUKpol7p
   jiDkjdD8izlLMIv6wgufrAeW926xFpTFC7xcK4lQH2QB7m7MCF/reR2kO
   FcBVR9KVeqtHnjPNMfmFWeZ0+IX6PL4iGVr5NAzEcJmVOcg5MGtxEmBd0
   ZcKIUEPOnAs/VnFlQHSEJMcEBkI4RBuXkcW/AtO+Jo2HRXuYTI75BLwG2
   6n0Zv2F+L97QoDDoKiiXZ1HYo3i2J1rdm8WVBe5rhllVk8yE9QaU/ZNq/
   vq33VbNbRyWtX0PtSnquPax1Awcxn9m9Fn4zDMImxWf869Z+XksiV1vWU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="336710560"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="336710560"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:28:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="694700830"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="694700830"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 27 Apr 2023 23:28:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:28:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:28:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:28:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:28:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7ZBj8QiBt4Zx/l/ze1ZBBWRZywibzikEfYFz7hOYN4g5C6qQRPPaaGcYW/KdXML6POO/yjTxjOg9VI29OtFAs6UUlluSZzn8gtGGEDL1d8XKAPRP7m7TSKTPvrAFcKVQnsSxvFR6xnYzlcqX7p6GxRR1+370QNcY/jUSkGuVtJ/qYkuu4VuChubcq4snCekXdSPyqu7ZML8ZZUr1yglsvDJzni6oPtlacRTcRwBSHtj89QZCEQD9TkxFP1OPIiG5MEVfthoirFwGGQgIw4cAs1DiC6b6mzAiLgf2/8iZJYHI2jS3DXHEkZILcvWb2M3FX/oI1CP1XrlW8z51+/f9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1y41Wr+0oCOw8SeXQZTqD1acnMqZPiGddlsJyP9OPs=;
 b=Bpw22uU8NHkyQaraR3ThaJ3oEH87/nM/beRfwabrcDi1XNG1yDHu2OEMoOd9jXEPCQP6VZgA1hk/Iap4FAZVcnM7Jh9nKkHGr86hPXXz5y5rheuhusDQCymsMsmuxZ8eLf3IGA4LEhKuzjNxmVFLDIli6BYYJJo+jhOisMsYj86FMxTtLRrzT+eJvKBY2kGngi8aBO/HwzUSa+ZQkXmBtHF/jq+cODW4MqW7uZwWIGm5ao4Cl8BHg/U8Qr2h4d8Q/rr6xDwikA9zfc8ONlCi1OYe38bVL+QCf2jM/hRA1J1+OLnoCKASa4uTqN3RAIQ8hsD2gtSx+QLFx4kBaZgF/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5581.namprd11.prod.outlook.com (2603:10b6:a03:305::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 06:28:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:28:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 01/11] vfio/pci: Consolidate irq cleanup on MSI/MSI-X
 disable
Thread-Topic: [PATCH V4 01/11] vfio/pci: Consolidate irq cleanup on MSI/MSI-X
 disable
Thread-Index: AQHZeS7Kk6SGEqv3N0GNziWVXSz0EK9AQtCQ
Date:   Fri, 28 Apr 2023 06:28:36 +0000
Message-ID: <BN9PR11MB52764ACFE8333427750E23C48C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <aef2b60d9a3c5a2984b39919561ade5ca9786b27.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <aef2b60d9a3c5a2984b39919561ade5ca9786b27.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5581:EE_
x-ms-office365-filtering-correlation-id: c7dadf04-7d88-43f1-9dae-08db47b1cc6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9zXinZz02Y8sYRSURecrrpY2CFh98gcR2WnGY/dRSHEStrxZegAgkz3AyHs1TEAYgWzmoaxJkwLegZivlAKJ7hJIr9TKiD0gt1r7PeB4w9wCYjMCRK1PT980vn7RnAhDNUQBABxk0TbU9r4/BtIKCaktKW1NxFRe68NbhjOgHTZA9ssblZmVow+EBOm17RJOUvzCs9o5FaUeHu3+26nTAYnslyBetdytiSzovThp9FgSFsiWnTN4Gq4zrvS1Sgdlwdp8DrKN/GceNkPLTQ5haZQwHHqG9XgmxRvmUUsHdOjtLpHuwFiFoC94dcsFEH/ad7DrB7F8jsMH55LvEgEyUtgcHqG4hU8sjY5bYJVpUhQxYdqyU6u3hVZ8wBhg4nxvgX/uihcXcvE0sJSGpVcwza2psz+tdslRO8BDaCAOzDyRttJiTRLBWfEitq959zT+kbvBujYnxqB/jG15bgpsMWC4CJKbcIfU8IB+iTd3r+7KOx+AVTrYjvGekMzNCWTi9mc1+4TW7leMHzVCWewEWAjZcAl5koU6U5bMqm9KWt2XzUM5esXVh/bkGgjdouj2oY5R5B66ybD3eKJ1bvSsmjZoktY8Hj6s3fUzB8PnWayDsWeUPB2zig3CLWVQQRr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(76116006)(66446008)(66946007)(66556008)(66476007)(38070700005)(8936002)(8676002)(316002)(38100700002)(64756008)(41300700001)(33656002)(186003)(4326008)(2906002)(4744005)(110136005)(54906003)(5660300002)(82960400001)(122000001)(83380400001)(52536014)(478600001)(86362001)(7696005)(55016003)(71200400001)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uvS/Jr616nhuNfqiKjLcbULu99RTJl/KC2I8MuNmbiFY6vyu4isMBdytM2gw?=
 =?us-ascii?Q?jy0AenX/QUmMZ85sJXuo3pWMjvvY97C6//aq82fQVtTvu1wXp/tSSu9uNXkB?=
 =?us-ascii?Q?4YXHe9Lq8V1+MWDHkM7OtonWi3EY3r/MMWPVW+H2niDxQz7S6xAIaCCmugx4?=
 =?us-ascii?Q?XlIMXyrDvQ0gmysC+Y8C/b9YS9MrRSoZAezxZSjcxcgUJsr2OXuymaCXojWT?=
 =?us-ascii?Q?XmyDgF8QM/23HeAy9vjmrjxsWv1JQKOm81NSPvbH03WFdbh62gPv6l/FrzcF?=
 =?us-ascii?Q?n1XbltWJmf7mu6ztpSIrLDXiJEcYLqGe4kbyQlu1oumCxSRXyASe9echHSUg?=
 =?us-ascii?Q?kzZFUXFv93Z0MGcjaSLBn49Rve4EGfbrJHeJ1uyryTQu9yJorff/qCVOp0Ly?=
 =?us-ascii?Q?7xQnyshf4lKx8NoHqHvTAPzZy9BulpsyqUuXKqDljX6cW8ti6fQlhGxxIBZw?=
 =?us-ascii?Q?3to2HcYZnMslM2nREMBhvbRb7lBbep3ENuQCzMsfe3q3FRDu3ZUajTr4dfy7?=
 =?us-ascii?Q?cbxLv6Ap0pdXz0aKchm1ciw4FPR5+SoIFj3jHI2lKO3olICVXqxJxGonUQh2?=
 =?us-ascii?Q?LEWF7PQd7ZikQM2UEytHiFwvYfsoXg4aXnrR7uigIMslAhEtKEtd19gAgPYi?=
 =?us-ascii?Q?H1QU0qXsDTabYxNSxHpgu7/x+dsTqRBmQdV+vU4/MU9PsxzrgzTmCHBZ17cH?=
 =?us-ascii?Q?LvXsEvCrDY7vzCBYZZ9Pwg/FX+goiuiNpha/qlB37fO26YRTfeczw7iCVGcQ?=
 =?us-ascii?Q?Ak1J0G0ete8X4vkHhhSPZCOVrQjFJFAWenB/K8NugViHstEZ31C05Q4ALY77?=
 =?us-ascii?Q?phg+0RzJxU8jWqL1lIOwbgVZDizm2dO7lwlDbokFcutHmw5cQLAJ48qvI9Wp?=
 =?us-ascii?Q?CxoGiidKhWSpRfeXGz3bldwHgxPEUDJbRftqqBDnE/n5srh/qZolAclBFFpN?=
 =?us-ascii?Q?0N7vKQBsmnaSMEG8sUioKd7s7oDwLDmfsoa8xWnP3EBcjYpZ6PvNrJj1k8CB?=
 =?us-ascii?Q?lZAaYL3LIV0gClFmT6p3+mnHFr0EweFJfNgKrcvr0LiE9ytT1shqvUPv8kze?=
 =?us-ascii?Q?xbZO2VLJ5egbD5MHDl17IqrlR1ZcI9qHTZPzPf2TIG3AgSJZWV+K81L5ozYM?=
 =?us-ascii?Q?iYGr0pi3G4h5RKeV6RI2AmlPOo+PFW1W8tfD1U2Azi9Fun4ngsWVBuO07hcD?=
 =?us-ascii?Q?pWmCSg/NVby+zz6wiKqMQ3xJAW5I8k/yWQHefB+1ucKpDCL7ldoyLXkY3sD8?=
 =?us-ascii?Q?LfC6lmZRpruWjlRkdkJBdvdxR7RoT5R//A+RZyAkjwc5JyNyCvokUlTJj/qd?=
 =?us-ascii?Q?qzDMojXasyvhFi4bqO6Fuc/IlUX4/1eo8obC9Wkxf/yXFMashPWab02EPG2p?=
 =?us-ascii?Q?NpU9lPA7MivtQdqWMzT0uPQh/BvDoRtPgOZzpjzsnYzINRUa24VoBMIO38Ku?=
 =?us-ascii?Q?zgh2rGo6QJB/oeQtVrP4XYhCxFUc3VmLzsisotgED/YrPdZIgkojhhbgzCCc?=
 =?us-ascii?Q?V2sqaSfICPiywF017JMN0Yc+tZz8242zefUxDeJ2gekASOMf+feumPqMssK3?=
 =?us-ascii?Q?QMHLtg3p7M6nTwAP2NWaHdWseqqZwlVpWp+f9t3E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7dadf04-7d88-43f1-9dae-08db47b1cc6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:28:36.7089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rfKPLtsk+9LUgJnKpxzQg5HSovoj4RzkzmX68sRlcQCGjhez1uw7r5pVNyCNATafbgww49/llfvW9WOOwEg+QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5581
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> vfio_msi_disable() releases all previously allocated state
> associated with each interrupt before disabling MSI/MSI-X.
>=20
> vfio_msi_disable() iterates twice over the interrupt state:
> first directly with a for loop to do virqfd cleanup, followed
> by another for loop within vfio_msi_set_block() that removes
> the interrupt handler and its associated state using
> vfio_msi_set_vector_signal().
>=20
> Simplify interrupt cleanup by iterating over allocated interrupts
> once.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
