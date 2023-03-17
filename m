Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496C36BDE0D
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCQBRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQBRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:17:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4A25CC39;
        Thu, 16 Mar 2023 18:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015828; x=1710551828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5qjRpsugINbtoHKCBwpfWvZAc8j10D0L2Tr38QKwqbo=;
  b=LbJN0Z24gTWuY++dJzfX+OUXGRBwUW7ISMDZMBUI2SThAyCHV8E6debs
   aWUDkLvJfrIqFeGzOl/IT85BAfg9cSiVgAG1htdmRs9Ob1Ss9y55DgmZK
   czlGN/iaL9oG83Pv6hhwBJ+m31z0yiw7Q3ZzRg5aLBoDaio/AVfSK/9a6
   Vf/7HuMopjTIRiLtwKrK+fCS/IXkf3P9Okixmi7l93iI6RYMa4GDVN1sC
   sHKhf7r9hLmFKkGht0l0A3Y/cA20rTY5tL08aeef7eGwfCEkIGaOHAA8O
   NZiPzVEvbhbXshzum2w+hWfFFaIx91+rYWidLezriO7F2Sy/jAcYv+Tog
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318548434"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318548434"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="749074767"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="749074767"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 Mar 2023 18:17:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:17:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:17:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:17:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:17:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyR8GVH72+9Sh9JREX+ObAZhRnLu/165Xkyb4yyZ4jR0TDWxcfbmEdixpyHOolB2yfFSigx1+NQIK5FaxSel4skKeLavJf6Yu/abtv5+Gx9iQ2/ym28aoSENggKYXD4cLX/vF3sz97+zybgOAxUzS1+pSzX9E1jfy/uS6elraFl2xexL7KBrHRJlGs0andc7uW7BU7WiTjvx2mzgVl298qXWiPXB1CoEL6wRp5lWQHtWMwQ8JDMS8ynGKpytY1V9Ik6hAKUZtdUONfmDOZ5C8CgGxpBUbCqEKxEt/Io6bf9QMXR+UIMwZvEIv9PMeZH2lohXbWT8t6jfS9YfU2B3EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qjRpsugINbtoHKCBwpfWvZAc8j10D0L2Tr38QKwqbo=;
 b=FGqL6Mg4z+50UFbU2YqYcR/ba3NTNypYr8bgmK6QoSOy3+GS9e8s0OFexTYRtj15emIJRvmbcdg+8192GgKWPVRHYCijnugXap8jNof3g/z6i2GvtK1Tn1XFrJ7UVbXXuGmHQ9lGvW0CeyXoIEd6z/CTMPmK8nZ9ywMBJ9VOfQkKeDjemTiSFh4yKuKDQ9/ZhBQ3+QQZtZiUbANQug0tzN0yy9V+v1uit4b7X5X1QD5oDEXNNSEe18MKZ7W5Lh+DyVjsqjFfctlLi/q6ecDq+PqTX7w/C510mI4AtPMW4R2lDS31Cfwzr8/wMG0POfdhXHlew+b9Ix3HiZmholfkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5372.namprd11.prod.outlook.com (2603:10b6:408:105::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 01:17:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:17:04 +0000
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
Subject: RE: [PATCH 5/7] vfio: Refine vfio file kAPIs for vfio PCI hot reset
Thread-Topic: [PATCH 5/7] vfio: Refine vfio file kAPIs for vfio PCI hot reset
Thread-Index: AQHZWATEoI8DmHxBSkifrV1qU/mbdK7+LDxw
Date:   Fri, 17 Mar 2023 01:17:04 +0000
Message-ID: <BN9PR11MB52766E252FCF7D5BA95467F78CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-6-yi.l.liu@intel.com>
In-Reply-To: <20230316124156.12064-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5372:EE_
x-ms-office365-filtering-correlation-id: ceb9d004-c5af-448d-310b-08db268551c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IjPd76WJR1d/E9ZB2sg0bU5ZPvY9C5yo45E+CxjmMamW02omQR6lLmnta39BRwV8p7+qpVWwzir1godvRzYyUiS1jDpjLlznckUegEhZAN7mA5wo4qGjCXn7bcC/Z5NvM/h/Eq/p7gA9Auiql86zlw0DXdj3b0SZF5IdfyrDaViM56nWcpDtowW3zW9UpFRGp17WtrbMVBX2Sjp8mecS1xC5YPfzM8fRDPuCD573NdgFu1/alIHh+4v/MI9t4Uw6osvFzMWatUk0BrYAAsAYeI+I8N5jZ8gJ1j1KMFxYxMOnWbwtVktBp6S5rM7k1X7GnKNoACB5sB729c9bBWMe/Ckon9ZNkO1sI79vcifTpljxKhm8gkES9m7wn4qD7g2lp9RM6Bi6O3WQjq2MA5jaHSFD/PxdAsZWKd3hqz7iBqQgekw1A/YxiTeuzs3PEZncj/16m+o45TwEQtK9FaJXI9jU0PRrDspFMQGTWDTM4h0c55Zy3WMBsPYzVy4jxDmvtCLN1jxIHAIq702oz1ZY3RGKBKWpIBalwwTJ4U9/IDnE1J1dNyyOB+gekayk/nVTV85xJrXN2eUOj4xpWJarnIQb5EhNBNHtT2WNlse7hfxR7F7ZQ7n6CKKlPdTO5Z08XsJXVNdd2e6Tz1QthmKxw2m+xDflSJGrYGgEvr77eJjJJgNeUq9IWloH3dWGrjLvhdlbLXm7UPhjKZMRbyATNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199018)(8936002)(5660300002)(7416002)(41300700001)(4326008)(52536014)(55016003)(558084003)(33656002)(86362001)(38070700005)(38100700002)(122000001)(2906002)(82960400001)(478600001)(71200400001)(7696005)(186003)(26005)(6506007)(9686003)(66556008)(64756008)(66476007)(66446008)(110136005)(66946007)(76116006)(54906003)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YqhTY2XQi4y/GeGt9eETq5JgHJELRMtoNxj9G0KQ49gL2R6UFGoGMpUyfS3g?=
 =?us-ascii?Q?MoMB3qlWVz0yfa78+Cs93A0+x7+wwdbakYfOYsQIWtQTzlaNv3WQD1dIZAHR?=
 =?us-ascii?Q?LzPURhYVb2Q6qMKpk3cgjiEK+7frcWi0q5m9ndMsX/R2A+smpVhJIAN73WJC?=
 =?us-ascii?Q?/4EmRZ12op1NvLsfDOmJ9Z99D5aXO2mTQlJO9PkOcfIsZCrLMmxZjty//2ST?=
 =?us-ascii?Q?c0T553JeoD+RfwRW1AvFm1HVWxD+pVmyAlgVf5tbj2K09cQLybcOXnW+C2It?=
 =?us-ascii?Q?dCICFXafYUs/NbngVxnVp27kH3sU7Lj17fxJSDkor0bHLNsKP3dzHLaunVZS?=
 =?us-ascii?Q?BpSs3NE4dzYTPQrR9KI3csjWCjfk+HEIDM6X3YuougvuP6c4swGCwjHXJ0wF?=
 =?us-ascii?Q?EslkqlWQw7EzK/z65hNQsQRSnEdXY+q3VduWm/S4Z3TK1wMdIB0KRL67Yrgm?=
 =?us-ascii?Q?DUvaZz5f/nOZwZSWr4WJk3r3ZzW4GDN4PLi3oTVal1KfAXXBXqT1CA+HEDK9?=
 =?us-ascii?Q?44qqUVlP38+9DTPynELLIWOX/G7iXE1VeGufHQ3YfnP3dZEc8/744NiOCGKR?=
 =?us-ascii?Q?7e2tjEURAv/WB3gTj+PH6UwmCCz9gKHok/dGJOLyvK7DpJPn+ShXmlWfnzYY?=
 =?us-ascii?Q?k9ZV4PKvKQWUn255hr9hKmTMYXO4RF5WByey3LLahjo+ebC4891UIfQL6nmp?=
 =?us-ascii?Q?Xg9idKV8RJWThrZCNQDRoZi8EB4MnfE9LqIu5/UNzRNJbxMBWTyof+bPDh8E?=
 =?us-ascii?Q?YOMMXrESMNqyn7OPga6Vxy3ssdzTdBfGqWBs88poMCK06bIst7T6CurK9oQL?=
 =?us-ascii?Q?K0CuqF8IC9FhMrLovW0HLouzHINdWpxowbuCmCkH9Kv8Zavduz7D3MeqiTkA?=
 =?us-ascii?Q?TbztVQQMp78T8jDB7x3lbGbaiNNjFDS5TdIar5EbMcy9keuDoBqF8w3SPneu?=
 =?us-ascii?Q?kBwKV5cliXuGgNpw95Vjc0ZgHKMPJ85+bG6dLz5wJUBNP1a4/dV+roHAu6Cz?=
 =?us-ascii?Q?OVTKcIVK5+VJgawT+vxRlHBZvLeI8MpK5D1zOrOjZ+xDaAtcFpLRa8Z5bzFk?=
 =?us-ascii?Q?bjrp/Ug4GKjkME85gZU5jFs+5Rzsr9RGI/mehBGVjgJ0peb6ZWei4VTFd/4g?=
 =?us-ascii?Q?NQv5g0yKxf8rJ9PvibO3VfQl2wbY+w54sX59cUNa9qJLpnATHHu57bqNt6Vr?=
 =?us-ascii?Q?Hv3fK+5bJzb2xlZbPG2LEG1eZymBqryhp0lv1fYafzLTyf6rVCkmBaqJEpA6?=
 =?us-ascii?Q?7qe8Je15+YmetknGfveED/Qocn3FpDnqgwcX6qpcEJuoaUmSR9GDvcgSP6pt?=
 =?us-ascii?Q?BkmrxmOp6d398LA3t3tH1CQYE1xyckufUmFbuAPjQj/NrmssRVdPqxeBZkrS?=
 =?us-ascii?Q?JyvhSMk5zq/X0Z1TgyXQtQSE1ZyFMVKEiOEhfF81Ok7YHujx28WwDTNZnkFD?=
 =?us-ascii?Q?xL4XHTVlLE0MM1Nq7R9ewdBXp/zY/TsOp33R8+nigbEDFJaTpn7brK4G2sRR?=
 =?us-ascii?Q?QbrQSc1wASXtc68WpZbqwB+VLD5AufZsfUrTMHhCReyq2wmZ0zwxFQRV6s2G?=
 =?us-ascii?Q?SSGgQJ4DI0WrTvn0SPPyATiXhszW1ogiegHyYfow?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb9d004-c5af-448d-310b-08db268551c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:17:04.6957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yr1lxJKehZq95ijplsxWhNmOd8p8A7HVW5/ulwdMH0IKaqSdH+u0rJPIcGR/VDzN/c1pVu9AkabaPAmTJa3z+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5372
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
> Sent: Thursday, March 16, 2023 8:42 PM
>=20
> This prepares vfio core to accept vfio device file from the vfio PCI
> hot reset path. vfio_file_is_group() is still kept for KVM usage.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
