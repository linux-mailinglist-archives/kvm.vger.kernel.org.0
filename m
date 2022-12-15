Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E1C64D5E6
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 05:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLOEe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 23:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOEe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 23:34:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E65303E4
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 20:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671078896; x=1702614896;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eNg49/yBkTNrR1RIRaemZ6KdCVItQtflJCNSn/lOAII=;
  b=iEJVqHCxgtCc2GeKe2iiXPqmAW73LhaaS10A3Kg+5CcADxDAp1Nlojq/
   CDGKmz0SYQbfU4BGybvmdP12ppqj7o4pXKsfWeUtx3suhymGAgDc5gR+x
   Hhf/GDpx9mL/Vweg7fgfCIMWj/2ewa5fbUtMel3aHuYF33AR820qxAd0J
   42Ihby3FeGv8IJsaYP1yRQhiT4FwopSxANOaXVZ/tbm8ZJ6y8hM2/n7HO
   pTdUOKnHVlZgaKRKdjBkbxKm6q+MIkgzL98aZGXKQsb8BSG0YwmSR+ieC
   qe2hCeRBdw5niMR5sUHU424ZtNjR9+6qwyfS+mAHHn4xT+UH3RtT6WBh9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="301992217"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="301992217"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 20:34:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="756200004"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="756200004"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 14 Dec 2022 20:34:50 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 20:34:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 20:34:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 20:34:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 20:34:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJkWhyf8EDdWe591hxXI9kQxdjCW8goJB5jOXXSPDfBNcYb8fMfqTp3dE0QcsLixxTGj1q5e1V42O/6jnUcQMwkf+qhzY/xuZHE3wd76puIzyoJGwyAMpNZ940BB39uHn7AP6cEhDAxC/WP5XlJ64gim00S6o3jjTE97k1q+wRXVtOeQd0oTZAcfwiwvm+Qpv2efeGTEfR6mSwlhixT2icr++RX7ZGxioXhLJubMYdL1FJLU8ZZ5ajG5O6XVVCYZT8ned7WWbmQxxn+m1XL+zNDjxKdacLHHFw76RnXTUiO2vbrl01wkeqcP45NdrkYDPSxMCExpt0vTYmnIiA6obA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C72xVIgCbBHBrHDvX/e2wKBH1AgNufdniifLSin6oYo=;
 b=oKJ6q5VXPw/RvjjZWTzntIZSibF8RlRI+w+N6dHfdAGaqovYj9W7uycObIMea50Ot+XIMKokFNUhx+F4E2J1wBSjPYQDHuX0k1QtfK2dIV+iyPPnapRMyTvLGr9rw0ziTfkCiSHi3hvxOGXXbF4CBHskg5uG4n4+RH+fxyw2sWcKoSRfD5w4mhOtCVpv6n6aTZpw89r7d2KcZjKp4dQP9+b0ZvOKKzGUxWCSmW/uOEMhk79BzI3AgdMIJoFmA78iSERlxE5AFWM0mZsu/SzL1OwLr9H7UhmROk4CZ5/pXZw0brLmVgelrFMpOBvWOT1dqjqKxMwOzdpMD80KbjwKuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4566.namprd11.prod.outlook.com (2603:10b6:208:24e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 04:34:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 04:34:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V4 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Thread-Topic: [PATCH V4 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Thread-Index: AQHZEAKhacvxV3ROEUGPLLeq4S0PQK5uWN7w
Date:   Thu, 15 Dec 2022 04:34:47 +0000
Message-ID: <BN9PR11MB5276350404E2B74837416E838CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-2-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671053097-138498-2-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4566:EE_
x-ms-office365-filtering-correlation-id: 683cc0aa-151e-4c1d-d518-08dade55b265
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7YVUrm5wUSQ+r+vQhW7tanVzsfTwMYc2JnyMNfyT1S/Z+COsHtuXXnbL9HdhBYwxHi2wWwdsKhT6HGkQlxerG6jO/F0o7M9mHOFUM3o1za91YnxcGbQwgmWBcuY4C6VUT0MFT1uXM4r67bavpX+xu/4q0baiYjqsYSWYCY01RfLFhnxEYIyFbJliYSxPVcTtYHHI7H/PCEGrqwnXlsmp+WxVlHqg11L1sTSKzsZLh2zt+R2ayMNrZuba+pOHdsF+58Btp4Aa6GALcFyBV5lbhHpfXTD4furzdslzwqZgq7mS64+aGFY0IiRa8vthMcvKAVEUfHfTLkpRk3OaHuLrAww/E5QY7qbHX+Dg7p/8rmQPj/lIxJAHR5ZRIkXw2Yw09adyVpiiQzumQ0GAV5DW4m3be1iqUjreELLTXCV4lqmcoRrF6G9DjIdnwQ2G7fud5PSH61y98y0vbU53oXI84qEVfaADbeHodeACcZYNRam22uN8EFsGo9L5RVWzBI0goVq5b9lNnN8dMwfU8hh1c6NVpwzKkd/YLeef0I3ywTBJ3xhsO0Mm81Pjk5aDW772AHrRM5b590qoJt38t26f0qRg+O3tv5gD+ZWf+u3oHMCJAgyOWLF+zn64eLMPIF52FvIX6Yh9v4MG4t05ejzlnEiXT+ZbYpUuz6yLp4MZ/5J8XjgHF2NSphZHSxpkDQNsFFwNmqqxXiTxft9QwKPXew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(64756008)(2906002)(66556008)(76116006)(66446008)(83380400001)(66476007)(66946007)(33656002)(4326008)(8676002)(478600001)(38070700005)(41300700001)(110136005)(52536014)(316002)(26005)(54906003)(86362001)(7696005)(9686003)(82960400001)(6506007)(38100700002)(5660300002)(186003)(71200400001)(8936002)(55016003)(122000001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MBk+q5dzuZIkpymR9CE+5tUKbt6/H29kdrnjE+NZxmoJK0SHctoL4g0z9JWP?=
 =?us-ascii?Q?XivqWgZhjo7BHs8wr1y0jbJu1bRSCBk8k5d9EH9rzWMQgJGvHhV0JTy951js?=
 =?us-ascii?Q?g5K8gaqXm+TeuJGJttEZNB9W/yPdSq5l2c0UjXgrKbUgGNPwECcCDLDJO7QL?=
 =?us-ascii?Q?asHINi/dOFyBRM5yIAsHL3Kd9nsxvEkktUFTv8ea0bRiVXO792nPEbMf+rJY?=
 =?us-ascii?Q?T8cHrUKOE72NUp/pFr1ipOGSobuMjYnPsg6GiAh7xEkZo1KHZhXiXtT2ESsG?=
 =?us-ascii?Q?K3mSOox1aWQDZFMftPuonI135+1rf720KiWzXfaCXGMnMlBh3vrRQhorECN5?=
 =?us-ascii?Q?excMgZ1TrWjMuj+FgJeSlfwigfDr8g3EfKIzcXUyiF12qmemmY6LOlRFT2Hu?=
 =?us-ascii?Q?KEJEc2W7taLulALi4NgDLC/dAdCboLrMVWg5QaU0bAYsm5tbBGub9EtrXwNz?=
 =?us-ascii?Q?XCPKhdhQovRX5YCzNVwxV2xqKR7DKKWqskIbCGMxl4j78IpjjrWIeo2DeOYl?=
 =?us-ascii?Q?tZxy7ej9OyY91xasK7zwNX5UlctA8Gj9hhBYPiFlS2pf3IoqftCf0yclUa7O?=
 =?us-ascii?Q?bV5AcA2BQGfHEijk9tpmuOQ5oJBsn603IhYpCWdCubDTknMdt6jwM+kgNLaN?=
 =?us-ascii?Q?9vqTpStIa/CLJp7uHeB8Cgyq71JcYleawPkgw0rVXel+xcQNTnXePnLh+tsc?=
 =?us-ascii?Q?Hp1Sg7g7pXulcAp8M4b+I72YFv9baq5sRQM1DWpYbPf1uYsUPGGymohU1apq?=
 =?us-ascii?Q?mEZPDb6TTevXqIZyqb/8wF05EIU/ZqEJff153CdnJgow9dlf0Wp/aDODhdlQ?=
 =?us-ascii?Q?VNeMBgSQUKO3ipcNsPrJjrK+bGMCt/zmkYTNsBi130yxGZYKoFgti8NbfvMH?=
 =?us-ascii?Q?5r0Ds/ycbgoQB23cjz4wA8azWwewmbbSTX/9Nqs9JCAnUYZPVjKY1wyFUfyo?=
 =?us-ascii?Q?HhlrNZ+CdpfqcWq29KzRUUBo/pL1/z/NKC0NGJ0QzpjoOHWYtUwwzagr/keh?=
 =?us-ascii?Q?WXvknwLK6XZ7JwkIQi7m5RjFZoWXq1X5liFMtfpkeAeAWFW4c7WYnt0d9WRo?=
 =?us-ascii?Q?cmN0EcR6hEw1jfsPLY+ghff74PCJCVGpsqJG0gaWhFez98YT6OIm/r/zDqZZ?=
 =?us-ascii?Q?GE14EAOBPnFvJYZiurFu6rLntpq/4ISSp+2dsozqKtFI0C2cGET6QBC54TtM?=
 =?us-ascii?Q?sjbVDqKfvs9HCMCVJat2rjK+ndexM5eUqfCIZ0U8cuzjMdYTkF50C7BWT9TS?=
 =?us-ascii?Q?zHpUexVe3BheE6wmRDNr/zP73vyDMc85mEK7hlTpuroL/nYNBqpRzFvFhjQA?=
 =?us-ascii?Q?wynFsrVHeI6ooQ986bHNNbU6Um+buQwHAKJGgRx+u8OZzbzWre2k0ufKqd6V?=
 =?us-ascii?Q?3MtFVpLn4lvykeklJ3AJykPy3HztpEQMxeFOC81EalAO7d1b446jheViobJP?=
 =?us-ascii?Q?7+It3K8N1tj1+NOhGLSRl0mAGL/BWzMB41i9Sq7kXrUypYn+74Z/rM4n8WL8?=
 =?us-ascii?Q?xG2RtBbxH4UHaWRWhhtrtppdBfluvmF62BryX78icSkddX9exHLkEk0zEBef?=
 =?us-ascii?Q?ZUeKyjIgv88GH65bYxXJH4vkFPBPWVOKPDNWr6M8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683cc0aa-151e-4c1d-d518-08dade55b265
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 04:34:47.2482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bqnto52wzY4GvoXepTUYL6zhuNUX4gWBgxQpU7SUVcaLGO9NUgsasQ8SceINTT/3fJ3UDMqGMplXE4/+LMK22A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4566
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Thursday, December 15, 2022 5:25 AM
>=20
> @@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void
> *iommu_data,
>=20
>  	mutex_lock(&iommu->lock);
>=20
> +	if (WARN_ONCE(iommu->vaddr_invalid_count,
> +		      "mdev not allowed with VFIO_UPDATE_VADDR\n")) {

let's be specific on the operation i.e. pin_pages not allowed...

same for the latter dma_rw.

> +	case VFIO_UPDATE_VADDR:
> +		/*
> +		 * Disable this feature if mdevs are present.  They cannot
> +		 * safely pin/unpin while vaddrs are being updated.

only 'pin' is disallowed?

Except those nits:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
