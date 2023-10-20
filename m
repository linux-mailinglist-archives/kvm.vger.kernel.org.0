Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB987D0885
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346919AbjJTGdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjJTGdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:33:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F77A3
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697783580; x=1729319580;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EHxBJqsyjG8NNyNFZOdyL2/3Jbu7eGrkAOnvpH2IhGo=;
  b=FRpcWXVECk8svR6GXgLYmL1hbSBCeXDAWUgZiVKA8GQL2MWL9hScH5+t
   4AIMW0w6ycIMkzVTsrtKgoOH8LCje1wz9V3YZVtYVAQfMZ6EqBBisMO2+
   3M2trU+uKNglBQrVym0aNNiplTqdICbmibrmnp3Tl6yahC3Rs8TnFtkae
   YWWxhthGQmAALyRw8E+cbYE4lH0VQvLvcSe/D74yHGTh4fHrPMVcf760P
   2P0FRuVcK4Tt022jMTuIbQ/pckreaWHXksXvsabcOF1cfUgPuULRXe3eY
   MscUCLsk0PQvgT9am7GrHFOHd/m8vvqu6P27L+HfWkyf8JrKgwHFnEZOn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="389300938"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="389300938"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 23:32:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="880977990"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="880977990"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 23:32:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:32:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:32:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 23:32:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 23:32:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHcB3iH0kpTzsc0ERaSDlQvKuAizB6mEKV3oVw2z8OFKmBwHCDKWL4TA0o2e0fKjDYo9lg2Cwmx8l/ZFSB86h8ez3HnePpUvADLqZroyQsWH88BNKbf0OiQ+sys8RSg98ZxHdZGgyrBcleP8Gc0ZW93WFTdHQ1fFILB7yF61yUp4qgrS32RC0AF1dRr3p3xP9uQbpnl04l9vcbn9AU1lNO1gnW8fWbzTF5IQX1QB+VwsZE+pkldDJ+JoTM1IlDuSKZeDj+h3UGg7mq2/4eNfLKOGwjTm06gPNsRSPT/QYLzX7REgw+HK6IYutERikSSE5Ey9iijD0l3a1vG1gNTBFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DLWGkX9tIQDXbEcyIkRPc4K3EwgkGGB7g5cWmnIAy4=;
 b=n1ynOzF3dRyd+CE0NBTYknjrqw4CXqoVYPznS8sbJwyawDZDk9BmBFyaZeZy3SCa7EoldeGiG1nKYy93NPLfeLKeAGkuGbNkAdqWqnzeNU8G77mLIZhaXaFh66R9OaTlh/PDJCv517dlg9xfV9DivHFNecY1llXsYauSf+S7LkyeH6u1d/tTrtPkTk5Aji3JWIYC6BNaNHl8LRByE4tmy1IwdeXpRhamsiuFhgicMm9+e+lBVGkH2NTRDBQMk5pPS7eAlnS5Be1/Tevr8Plv0KIOL36wx7hm6jDD9CvzGlgJc8ZbHzPPpiNPa9I7a4Al1c2t0zn2IBZ/Kd4RIAqAEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO6PR11MB5665.namprd11.prod.outlook.com (2603:10b6:5:354::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 06:32:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 06:32:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Thread-Topic: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Thread-Index: AQHaAgGooWgvklvxW0yKo+S9lxek47BSOUlA
Date:   Fri, 20 Oct 2023 06:32:53 +0000
Message-ID: <BN9PR11MB5276E0546391A87457258D368CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-8-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-8-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO6PR11MB5665:EE_
x-ms-office365-filtering-correlation-id: 02645d8e-1421-4efc-bcbb-08dbd1366401
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tt/9hW4X/WjR+w4X675G53XnzOLWK9lsKOMPpAf/QWp4dZ0FNbJLjLwKwWazrNSMmgi9yUNZFkepKg/mfc9muBBG2U7aiZL1fj9durYkWJMqEVPcNZpwo1vRZZLZXnSKPHW9hageY21B+vt0MbKutpLpVOvL22GFxNrOPhTUDePWNoCY+ABZjOazzcPxnf1sSKk8qCFovPUN79cZsg5+6DwW5amheBK5BydCW2gJdiHfJNQCDTl95TZAuo/RY9C/xaIhV4wHnTuzDDBSQCP+zh1VxELJy3rydgRzm12mQxKDPWZRxla8mBErLgo6gQZbK420xQYIm4DB1SC/WqpOH74EtwGugzI7y0vGiDPAbRBFi34NTAOEtrm3lJRyzDrE55NPbfOWvIeG0rVJ9ji+dFvVNYDyIRQRT3lozE9prlx8oROGCnKxeE4INqcQQKJ2bPUW8VCH2eyo4VgiP2ucQ5IlwMo3cLHpgvSydpWPbyw9ehVEGHkU8TaUaUOl6tozKVnUDqzSkS/pwL4dOw/6XAWZOGELY2layAb068G/Am0EO7nPNpT9CYaRDIw7K8Rtrnxg+TCfldd8VFR2O8IL/+0gazqfuFhJPvVqnYyToy/ZOQYsypQSZvoZfNoZ00CtwZJybA0/biqDfAh5mVYFhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(136003)(396003)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(8936002)(8676002)(38070700009)(55016003)(2906002)(7416002)(52536014)(5660300002)(26005)(4326008)(41300700001)(110136005)(33656002)(86362001)(316002)(54906003)(38100700002)(71200400001)(66946007)(478600001)(122000001)(66446008)(66556008)(66476007)(82960400001)(64756008)(76116006)(9686003)(6506007)(7696005)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XJ9n4ikpytAPCO+H3js52jL5GheEb8pPahwtKzcJ1RueyOsU/qXwYJfy7UPZ?=
 =?us-ascii?Q?EE4FMZc3rbyyqyadEEu1F6hSZ9slyVaPCV7wyub1RomPZtlPXQNitjE9xdhv?=
 =?us-ascii?Q?6ACWC16Kxlq5znwoYpTHZ8vQ//zLvH3BZy1koCkFZzgu0iJZ0DS8+idFbJUc?=
 =?us-ascii?Q?iqU8G1uq43Io99hDzSyULYMqpLPoYDbQNsbcSWCAIaXSFf88hWr+yKMjNvec?=
 =?us-ascii?Q?mrIaC8GaCw8Wlb7HHnubnnrcjsW09MIroFH0LCxlkpY3mOtBkfSsj1JO7hIW?=
 =?us-ascii?Q?g61LW9piymVtUtIw5Fp1wC+cRf8FTARr9gTzkBojOuPs282iijC7RaFqK9NA?=
 =?us-ascii?Q?QeKk/LQl6c4wOWFxnDgK4B6JjW3hYmAiLsaQqDAkoifH66SJfqAxDrbMCJO5?=
 =?us-ascii?Q?+dxZA1uNLKz1AWFse6r+0OYDEJWrevByKQVrnL++gmrptW6ZY87bFEps0uPT?=
 =?us-ascii?Q?7DOmhcweaXUXM9NN8d1nEXMjAYuKLWG36ZjSg34Id2RBKqWLvrjPTHvLfpw1?=
 =?us-ascii?Q?1yJveyPhUUYmT5Lty0vxdXNwhPEM60ifkdEEV/jtozkUIp4lSZEKWRIEBhAt?=
 =?us-ascii?Q?JcnLWWV84SLktxwLdBrrDSH08Yl3SZ4bU47Sja3Qa4VAycLKj7hTSklk4u7D?=
 =?us-ascii?Q?ywfvKl0XjN5gJZf1qkIVVqLiz8bi5O9xEUtt/bifNRiL6dPkAmx5wEskr6sQ?=
 =?us-ascii?Q?4fYhAO7rjEZiOy9n/Z3DIsN+jtKMIEVmzdXBbypbxYYSJXd6LZLBlrFIlAF/?=
 =?us-ascii?Q?8Z1RtijXCtHCjB9BeBn0rXkCuJkfFQZvbXQ45V5y8SZTECtVueOFabHYwYwt?=
 =?us-ascii?Q?PJj55J67Q8WoDWZut60HzMG7UNKfARAiu4BBZcbtp63KmlPPg5xXi+eJwK9N?=
 =?us-ascii?Q?SGRNe3b+xP96J7Gm5tdbR8kQ/rS9E8DB3e6KhJa3l2HqdaoyQMWppk3TzR1P?=
 =?us-ascii?Q?ik9FvDmN2rAd1u+bbB0yuj0cgWKzM0k37ejc2+QsJdcD3UAk1i+DI3TxCGUI?=
 =?us-ascii?Q?8Q6EQIYBNNnoSFrFicq/CZ/gBWhJlYnliMsX93xG1pn6VsjWp4sanRW/aLOz?=
 =?us-ascii?Q?MP16LAxCdwAF8I1AYyADAPIjhejZ+jABdCYBaudPO3E/xA1H5U3U9zNyYIFa?=
 =?us-ascii?Q?sl7wg5D/I9EoNCYNsXUxVHu6Fw7Q4Q7m4mnBTEHN7vWfxgqLk8e91mVfIi8J?=
 =?us-ascii?Q?oNoJTaSyToPBA5ckhU/5/ramzP1P4uhypK7i7LmIHioITvf77dikJYt1YlQ7?=
 =?us-ascii?Q?cJItxcmlMlbn+OBEbhiW5ihi9aFLczNZi0MauElv96wUVgcpXWpA+KOjV/t3?=
 =?us-ascii?Q?YwvuxN38wsei6PXAwvoa0X37t8RuK/cRAuMH81fViw46BvE/bw6OS0f5xxdv?=
 =?us-ascii?Q?5hmVup3iXhe1nk54FN/s0gJlWrlaaDd6tdhYDN1mtbyNAMdAWLWYFYqACPxS?=
 =?us-ascii?Q?5FTJzA43z6fV0FYNH4OkmL08EeofNBVGnrpyj+SJo/yhWoAqbT+qu5qD6h3c?=
 =?us-ascii?Q?ELD/QLaDbC8sUM8BLKLLAnzoutdtfZdxUQY3QNjc+oNMBQBC6dL2Ljx13fhm?=
 =?us-ascii?Q?7Tf4l8EmUi0YNwO6ct/kPYK5j9OhcGsfQ3Lk4cIQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02645d8e-1421-4efc-bcbb-08dbd1366401
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 06:32:53.8838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XqqUcN3EyRdOiXs1amVctipjk2heKcSnrqL00Z/fB5UEVE3M9pHGNv9e0DuYC7cLhYf00fcEVASuhMGf5n3ZYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5665
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

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> Underneath it uses the IOMMU domain kernel API which will read the dirty
> bits, as well as atomically clearing the IOPTE dirty bit and flushing the
> IOTLB at the end. The IOVA bitmaps usage takes care of the iteration of t=
he

what does 'atomically' try to convey here?

> +/**
> + * struct iommu_hwpt_get_dirty_iova -
> ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)

IOMMU_HWPT_GET_DIRTY_BITMAP? IOVA usually means one address
but here we talk about a bitmap of which one bit represents a page.

> + * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
> + * @flags: Flags to control dirty tracking status.
> + * @iova: base IOVA of the bitmap first bit
> + * @length: IOVA range size
> + * @page_size: page size granularity of each bit in the bitmap
> + * @data: bitmap where to set the dirty bits. The bitmap bits each
> + * represent a page_size which you deviate from an arbitrary iova.
> + * Checking a given IOVA is dirty:
> + *
> + *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))

(1ULL << ((iova / page_size) % 64)

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
