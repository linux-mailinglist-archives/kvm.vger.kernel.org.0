Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D21A6BDE3B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCQBjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCQBj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:39:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A75B06DB;
        Thu, 16 Mar 2023 18:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679017166; x=1710553166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pU3Mh83tIUgsPM3L41+HXpzyPfVDhVoKiOEhyMhOfns=;
  b=E/XZTj5YRRgFN7n8WwErvY9JuF3Wp8LEBmWYC7vXAmLbjz0gDoU/azCD
   U4+CvvvUhavcSIT8Vio6ayBaimTC3o18CVyQc4bFu7j162QpJ+PECwArR
   fveA2e6b5uIayDr+rGe/Ou1nhEip5m275YwR2TKnI6BQsRogtS5azqkca
   XhrVds1L2Qpz8AHQkypGmXhuGSP0B4uNAOmi733LhRD7jdH7pM9EyozdG
   gSLAb0ebTX6sEHK9tDV2AnTYrt5jpyJ24QDnqpbFPTqIHBz1mZBh6rq3M
   ez4GVEoegTdQJ9/6pKmNFsOXtwkfu+rsUZCo38s9SxNiXpaY1KmuKkVQg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="400739873"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="400739873"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:39:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749081510"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="749081510"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 Mar 2023 18:39:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:39:25 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:39:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:39:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:39:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgoxcUBRka63k9dfMOZLM5GjTzWBhSZ4Qhb6uBYbRBXGLyR6OuQ/q50ntyoN38O3VtysagCIF7flp4nP2gIEPFOk9KwJ7QfjPGRbNlXm9NXZ3s20VtY3l3Eg7NDBgtI4mpkUArZ4qmQEXnatOcfH0WPzVkskEWxH0GnVik8TQ5PT1kF9ZZh5SxggpICH08NkBmmd2GPbDvoBNlVcZIcb8fH3gHJzFuADtQIxJ4lRPnSg9yZ6jtfxOd5oNCTRaF9xeMlt6py2PaxJyIMClJ5L7OGDcE4WfvvXj/nSofiL6/F/CY2ydGyBJF9aPVvJv6vwlzjftmdWcEzrLjpghfBJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pU3Mh83tIUgsPM3L41+HXpzyPfVDhVoKiOEhyMhOfns=;
 b=I+iL6dFVQfJjwarfZQqZIN8pyGt/BeAoMcLSCqHv7lQ6uVVtFrSDZONnEkA0WSDGe3bEF+g/7nePQilBkXT4gFwhiaf1KtabMjlARH23NHyvdUceDm+UJk4zNYmq8lqhjxe891bh3sUW7fqlyvGjLWrRJA5hlAHZ8jqmxzWFJDDtIf9A7LXiUWHVK86BUhZC/yuZXKQLh/dcXd6QPKcVp6V4x6T02EqplUxJ9xnV8RVfIIoNzvsRTlBbXoCcl0lRvruLw6TAsz4BXAKDfFQ/OseVMnF78LkoFTfHhoDu1ZGMB2n2Uw8hYsYCdF/f+m65IwPNLRg06d4F7sfUhenCsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7766.namprd11.prod.outlook.com (2603:10b6:8:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 01:39:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:39:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v7 06/22] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v7 06/22] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZWAajg4jh6yoZNE2SG9KrtP5m6a7+MnPA
Date:   Fri, 17 Mar 2023 01:39:21 +0000
Message-ID: <BN9PR11MB527647FFC3C69576F21617698CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-7-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7766:EE_
x-ms-office365-filtering-correlation-id: 85059201-d1cf-4b0b-1808-08db26886e9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8/VZFFjIEA1KFCATzkNqrAabg2jlzVceRzeKkiCZh4IbhjQqdelb3GDF+sTHVW7jxm9yE/tyaOnCpzHroxtAZ4xOzG2nttcyvKOeAUJ/XxgDJ/usRfyQUSXPo/BW3mT3ILIsOfOlEz6GsQEjBobr2q3pDQfOmVyqGT+2x4mar5o83e5rOsaUv5v/3cZMRhxjtvNZtUPG2bkTCTFyMJnDZRZV2/vfxri2yPDRvEMJbwsjIViV7T5j4GOycaeqF+9KnKmpOUtM2/QIAz07ke0XzMxXD2El+6iz115Y+Umli4NNbspofeL/t3PljDhq1CxBz8X84/03fgbYCawOi9EGt/N2i1ryBW0bL7PZItmPTbKGZdiqr1e6W2iTDnD8fNZPS7G2h+lJrhQDDJV/+HC3jn8riskTvSYf4sB+UoTLUnQebF1PdknTnljJME8DLZf3scCO2Fs3EHDhPwkUrSXU7IQpeG6XFMg7FnQq4KjLWrUUdeF+fcuwzGiUkJ0DRjbFp0XLjbpbXiEI8Sz/HiHzTEUyIufNWFGf32+Yfwpzw6Tn4vC50asVNOYc2fVRAjq9kNnji8qJHxEHtAhDe5oY+2Lop8d1oTgAQ+NOBXRaiWVLgYIq5SyQ7bm7WnV32p0ihybW4oQ/bvkKrRmmmJBvErOAbqUXEOxo2OFjQgSGHjejIVMHGxiB4CmPXlzV9J533YBLPGsACW1/N90+Ct7GMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199018)(38070700005)(33656002)(38100700002)(82960400001)(122000001)(2906002)(52536014)(41300700001)(5660300002)(7416002)(8936002)(4744005)(4326008)(55016003)(7696005)(26005)(186003)(6506007)(9686003)(86362001)(110136005)(316002)(66946007)(66556008)(76116006)(64756008)(478600001)(66476007)(66446008)(71200400001)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ETgp4iqUAJ096Yakwa49h01YU/4ASznMxDll9LVX8LdekJEBnUkPk0Gcthd+?=
 =?us-ascii?Q?SxUzVsmO4XddBF6N0wLZJY1ojFR5MUHSl/zlVC7M05a1kf+OPwahPr4QnkvE?=
 =?us-ascii?Q?7RrZ12DVV8untSvgNlJz8tNiUuaz2NiGdrxOgzSovkkHWvpxfQYLWdv5YagQ?=
 =?us-ascii?Q?t8hQTWe+XpcLOxzYlGYYcUPfugDK/vXiSqk3teEsLMPq0l+nPd3qUi1xwDF8?=
 =?us-ascii?Q?ROVU1raAcycRsup/VyhQb7DYN4CWt7KMygb4St+HMjEwY39mOiRaMTzJU1Y9?=
 =?us-ascii?Q?7Ami3KEe5qTVK74KM9B3vcofiXUf9fo1LZ6J3YoDX/sKdVlxuvdR5WwsYcPv?=
 =?us-ascii?Q?rfw8pQOmV+97Yod0g6+/tuKwxipBFbSuz9nDaLJ6FBj7SLhXeY0RkFDxhwHj?=
 =?us-ascii?Q?f7pXH5MrCe7/a9lQMkBvOcOzhOF81TwkgJNO0y7WcKi7GexaTL4dXzVAQIta?=
 =?us-ascii?Q?nuSCw0Qtp5zbKXXIT1QIt4QNRFM+LYM8wF0EilwCljqJb/iupXQQvKJh9uhR?=
 =?us-ascii?Q?qXxnenz1cfFA0h9cwwwM4cstXll50jMlPArK0Tzvihsd9pj7IjphTQNwJdoB?=
 =?us-ascii?Q?UTWMuSOTRbIA/K9zdxQxGUNmNpPZIHaN5g22hzoDy82ub97KYWZENzlIAM6Q?=
 =?us-ascii?Q?H5Fvd265RAWRCYh8MtIEFVi0WWA6TavFrxSQq+YNCyq3SLMByyFm9rIacKxx?=
 =?us-ascii?Q?th6LG3BycMjWsmCNBeUlSVpAXwkxoP57MdpNneIQocQUy1b3nN8kgdd2a6+E?=
 =?us-ascii?Q?30N7td7FzEFSTSlbpMEoR9XDufQe1cq1uQppRbsgcau8hY8QI/tOwOnxdDui?=
 =?us-ascii?Q?kd1aXKkkl9HQv6prGdwXs4yNtINpdUt3LBbk61FZ+vdPcvgcGwqjXFfszODk?=
 =?us-ascii?Q?aMIsANNUHsTFKASC6z4uoZQZgg+NjRokVwfFU4DiYwsTNZfNZI31pVBnzmMV?=
 =?us-ascii?Q?nr5bY6yd1/MX1IR32Sx73Whl0Yi53BGrsAWSwJU1q3PNLOEZrHBSbvIs3xtl?=
 =?us-ascii?Q?7w+Zu07FXD7IpiUILF6Yc3g6GD/DevhuBHFV32bBkwYG4HlkKCaYepfu+PJs?=
 =?us-ascii?Q?LoKdbb9901JT19hBIyn3AmryxJwjP9i33KAATiqR2v5PvR/mJmigOhXNl/58?=
 =?us-ascii?Q?tBSp0dAhhbAeMkcshl+DBn2hmU4M1Nucb99r6nDV1hH+1LRze6PIhnuNyqjB?=
 =?us-ascii?Q?PG6Q8fN5rfgmE7TFAMojqPKa1aXrdnJgdC6uXakpCj8Bjz5605ZBEbradpIs?=
 =?us-ascii?Q?ggAUwHbn7IO6tJkWjHlU7mjKIawfhXfUEOgKXtzWgpNFptPLYWwLmIXGUgsq?=
 =?us-ascii?Q?OtvPiBM7iY+GrTg+XHzy9JMVG6h7+mg26D7h9jZ/LSGf4lusa4iPMlMvBhoM?=
 =?us-ascii?Q?xuHH/bpQoca5tfBkTvY5sN3z/xXv5is/Cuhf7VnwOZ1SW72aQlMBP1ZhM8L+?=
 =?us-ascii?Q?kxIa1Acjy9nuCQHli2WH16EuatQEVtjYrBjU8/FtUcUwybZgHrAOPyJH44Pf?=
 =?us-ascii?Q?4fJ6bYULSj+hd2LP8/dIWjPVgQ4mpqzfiRsutWyaZmFDtaGbZ4NoRJpJy3QV?=
 =?us-ascii?Q?lDDlg+kimZ440kVUyyzLF8jom0yBJBQ6SClLz9Nn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85059201-d1cf-4b0b-1808-08db26886e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:39:21.5967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4islOnIIN92aChTK0NcFwgYJn0xQ3JohXCl1WWDrdrAYjEDu3tmQOXstDn6ZUMwAUIIND+wEdGGvm+zPWyY4Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7766
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
>=20
> This defines KVM_DEV_VFIO_FILE* and make alias with
> KVM_DEV_VFIO_GROUP*.
> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
