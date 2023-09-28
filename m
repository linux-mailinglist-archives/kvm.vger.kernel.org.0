Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DC57B11DE
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 07:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjI1FAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 01:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjI1FAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 01:00:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6B412A;
        Wed, 27 Sep 2023 22:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695877232; x=1727413232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=otslHa2ijOmNPFruTadTPpZw+PytYLIf0DwxeY7rzdk=;
  b=QvNnmpzWoDiy12efWYyiFfqyDATQGUSYLDPn6h469LcnmC7Z+EXHfgtq
   Hu/xtsFdkWY/aWvPbeOVQNEoHQyoggtDe3XPzTCGRYXAGH/LwHlqP7E2m
   0diEYHE7vP+OM8gK3fcaDH31BcHFHtJAK/I6Wy6dzzzucA+zseIoX+aTP
   uOQndLAow/CaWHqWk+OUKC7uoN6rObIQr4XAWg0q9t5AmYNZQ9WWQcD0X
   YeVxhrbx873Sh65BCZg0cBE7oCE0DYzfsclUaulaQxT6cJJlzZZJtjU1E
   jBzQcB+Tlbjl+RAtuELmdE+CeWNwcSEaAknNcBTTseDjkQ+51oR3+Ur05
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="412902665"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="412902665"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 22:00:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="699143014"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="699143014"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Sep 2023 22:00:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 27 Sep 2023 22:00:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 27 Sep 2023 22:00:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 27 Sep 2023 22:00:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 27 Sep 2023 22:00:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjSrqqmYuKL1MlhIg6Q50uOLrqDj0RSfViSERoIhTIzYpAT9sSWfgcNeFll3MfPUQ7S3wt491yDd/WDBYSRzHTdfa2hc2h8s88d9mws0Yr72CynwQMgC1/83HTLA4IK7+zZp5bvAFaGL/YFvn4j61S07rgg2FvIIhbIiZJ/flY8ZQJ+ci8YtUY9Py77xVUQdm9oIAvllizLIkso9G8NP9b+gXKgoi8pZRp/6dp8qnygu4qJlzyw3tZWFjWn0wENtPT5PHlNEar5NbX3KUIE6NR13EKLjx9cTDcYkWliwxAW+JL9RLePJrESeoyhWnDc8/QmVpVWORpFZiGh/laOutg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otslHa2ijOmNPFruTadTPpZw+PytYLIf0DwxeY7rzdk=;
 b=G7kVjMst0hmU5Si+uMVHqGNOePyvUbqZrXArsSs8ZLAGwqFI8iZHQGsi5iia99kjsJsu6w2gOeNFQfnGVzpg6cnBUO7KHM+9ahfEy3DO5mvPKWAmiOc6IbFG/FLrXZQD9MG46aQ2E0oIpvKy/Q0eEP4xoaqeDtsKWnaXzjR61kyURohVjpoaMvl456lQSkBoMrt5/AnOpst5soC/BkJ7/X0x55DKw8B7DDa3phgDNY4sJstuqKDzrBOwmTEVV+vzZh3MFvxgam1d0otNrHP5COQHS7npAv1M8bpzlbTwgkwSQPw7MsIuVb2d78AKev4Uy+/+uPMVdRuVw0DHXYLQEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5003.namprd11.prod.outlook.com (2603:10b6:806:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 28 Sep
 2023 05:00:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 05:00:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Topic: [PATCH v6 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Index: AQHZ8cSx3Wevaa1nu06TreuvqwoupbAvrbRg
Date:   Thu, 28 Sep 2023 05:00:15 +0000
Message-ID: <BN9PR11MB5276018DE2AC15B3538BBC008CC1A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230928042734.16134-1-baolu.lu@linux.intel.com>
 <20230928042734.16134-13-baolu.lu@linux.intel.com>
In-Reply-To: <20230928042734.16134-13-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5003:EE_
x-ms-office365-filtering-correlation-id: 0bbde258-d032-4883-0a75-08dbbfdfcdd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3c/pGWSQ1hfqBOYlIKOxih54lvvj6Y1fHrq9TnGKyKXXS2LHm7c0yAMTjucwHaDfU18QM60Thg39FCz2eqJEylqwRFGPIkhLn+qulB0wdHeUJ4pPiv2fVCXrElkzcPERNAljK8XqtoHGH/Ac0TxONXzY+AgQOODJ2dMibGmIljT/KeFEj8FJKZPwh7EFc+JwZP8Byi4w4J347EV8F+RCNshnRwmWXrZPAntEfQfP4MZrLffYIgb+sBxjXJ0JJD88lFCsW/450xAarIlwgAA33TsePGi5pQogyNyUUHAGn3Iw/yDUh0d0W2apZZ/gcX7CSRLrLDq+PPwWXhju9cTuRTgsASjcIhC2uIAG/mQhJkLsIBXEi5Q4goufpENPxZfwGO0WMXT9SrmiedhoCIE1rOAmtll5OEQV1/18ptz4cvIIzGOKwMG7biwoe+9olT9E1Yh4sdTZMigNq0dbsxfTX1PzAEYVrwt7AE5wAY9we+/hcwh5dNAEm28m/euP4hoch6zxgHdINF+27yWyfwQAW7lUJkUyi5muGjS8Mo0d88nRruWr5bdwEdN36zmhX0cssFsdzQhl8RMJaNlnN0H1kNDviFPpz+XlpNdKJZIiS4fm1yMrj1wWjjkukZ+YFEmc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(366004)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(5660300002)(2906002)(41300700001)(7416002)(122000001)(33656002)(38070700005)(82960400001)(4326008)(86362001)(55016003)(38100700002)(83380400001)(478600001)(26005)(6506007)(8676002)(9686003)(52536014)(316002)(66946007)(71200400001)(110136005)(64756008)(66556008)(66446008)(76116006)(66476007)(54906003)(7696005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qd1XRaLE0dVW1v/xEOhwI/SXsW4WoijXbK7XOiDsZt/kL4swbayh6N6RsZk6?=
 =?us-ascii?Q?TxqfKJ5FVR2eVRS3HjbDx8apvsfGxMvQxM9mLjFCaGyVPRQV3cE2ZMhIRgPZ?=
 =?us-ascii?Q?eyMUQ6vyL/iOxOrVOWpeE4mfzDZmUiRm9LkvUOswPWXURgw+y4qPDQFnx0YD?=
 =?us-ascii?Q?28MbPwukskCqqd5h1FfNuZK2yS5VZuRxpqZGkLVPKqNcbiMLodQtciTSgWTQ?=
 =?us-ascii?Q?Xt65M/yRmtr8lsTzMJL4QUlxsUKpbvYy8OSfX2jThrnszCbGn9sq/61U8eBl?=
 =?us-ascii?Q?sIY/GVJixEQMbjqh+haW6AhLEMjv6XKMHNW/AyK0BXu/oq94+5L2qiqBAvYR?=
 =?us-ascii?Q?z9QVrwSJIAgnyO9+7LKXq2FhvLSye+IA5mSBKYza1lCF5bgzYq/TlGL68Gcr?=
 =?us-ascii?Q?oMiGlrbY2H2UnZkFpAxXI9UIEdp80h88udI6muCXawcp2w2Jg4YFRsfsoTv+?=
 =?us-ascii?Q?ERTPVq1/NLjTyS68jYOU+rmaKU8u4mZatx+LxBDi2fPZrTuua2Hu9emkSYMN?=
 =?us-ascii?Q?JbQNvr7dTUKVsOQ+9F91DpEfswN9XCUm8uxGp1c/4Mul6gC2Li7c9Y3Jf4cX?=
 =?us-ascii?Q?TjVtinjvJ4RWqvgFubdoSnmGFQpbXGB3Dg2LQh8Ivu9eky9+8HX9XwLB9wey?=
 =?us-ascii?Q?H661REFen5nQmKMLic+6UkdJynTocrgp676mNSLXjDw3hW8ctWJkRgsMKOfU?=
 =?us-ascii?Q?GX2j94DILoVU/M77AdLEWz4KTPw3RgNMgbymXUDhWMxCvCLZgvCYBWaxQa6x?=
 =?us-ascii?Q?G3MtBiCOlUKHOSNXcs+spydtg2IAFXbQo7iwfryg8P1UVWWjDF+z3uM1MXpk?=
 =?us-ascii?Q?GOxXH3GXk6xAx4v4kDZOBVrOEL/qo0xFFBb3Yax4fTWWbFnq8zgBkgjZbJCS?=
 =?us-ascii?Q?n+0fsGlIF03IcrT0++iysFrV3Juo+R18fKefmjdOX2tu33S8uFqXgdSqAkk8?=
 =?us-ascii?Q?+IZcVDTGWGYS16j6ZmyH2fKq+xvPOz4wXvwQGyDVcQKnLt5IYu0D3owyvF5l?=
 =?us-ascii?Q?j6bXHusjcLGHO5/sDv3EmTlzeQJ6X6mn984Ag4ckdpFxXeMeGXSLJ142B39l?=
 =?us-ascii?Q?x+F0jfqLtaj0S6BXxuWwq4dZ+S0wFHvKCB+TWLnAc7m/jPuz5OgApKr32x2z?=
 =?us-ascii?Q?vCSpRJXxR8vkOTW8JtBHKAfaVnh/OoEBnbAqNzYNKg3/iFWu4ZN87rOMM5g8?=
 =?us-ascii?Q?WzDMTSyie9DuBEo4hKyAni1UjV48G5AGEYksLGX6Vf40o/kTVK9/WX408AJi?=
 =?us-ascii?Q?Wpi/QqrOc/HxhmyQE6+dNoDjZ6+bMG22l2LR7xr0qMRxp+StYsqml8zQLFJ5?=
 =?us-ascii?Q?V6waAppCb8bvzmSPAtMGDrjsZ0cl4TO87GoUDVRkHA+3xvtckzxS65zhLDTv?=
 =?us-ascii?Q?oOBJfTdyUS4f9Y8BGH0ZVyVYK5P+Np8oHl3pWdc/Pj6usL/0ZTKyJtdrzbEO?=
 =?us-ascii?Q?2//A7w7G42dfQ1Xs1CMptbYKtU4ICL5r32cuSvcwbqXHGUzrlFax1fthpFvh?=
 =?us-ascii?Q?kSHH8iPUPG33DlWLenebFWL1jSOhQgRkl9p/nRG/1DubBtPzTAHc1BXt1EDH?=
 =?us-ascii?Q?li0X/UV9JFujoaogExojEJLf5T93PHsksvek/z0u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbde258-d032-4883-0a75-08dbbfdfcdd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2023 05:00:15.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wupYkfep7Sfy6Xe5L/uPWsS974TdW+9XQbaSL7rIaUYiIywDxdsnopG1L8kcwvOcFEGGid503GDNC+BFV6pxoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, September 28, 2023 12:28 PM
>=20
> The iopf_queue_flush_dev() is called by the iommu driver before releasing
> a PASID. It ensures that all pending faults for this PASID have been
> handled or cancelled, and won't hit the address space that reuses this
> PASID. The driver must make sure that no new fault is added to the queue.
>=20
> The SMMUv3 driver doesn't use it because it only implements the
> Arm-specific stall fault model where DMA transactions are held in the SMM=
U
> while waiting for the OS to handle iopf's. Since a device driver must
> complete all DMA transactions before detaching domain, there are no
> pending iopf's with the stall model. PRI support requires adding a call t=
o
> iopf_queue_flush_dev() after flushing the hardware page fault queue.
>=20
> The current implementation of iopf_queue_flush_dev() is a simplified
> version. It is only suitable for SVA case in which the processing of iopf
> is implemented in the inner loop of the iommu subsystem.
>=20
> Improve this interface to make it also work for handling iopf out of the
> iommu core. Rename the function with a more meaningful name. Remove a
> warning message in iommu_page_response() since the iopf queue might get
> flushed before possible pending responses.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
