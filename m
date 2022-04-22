Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3050ACCD
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 02:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442945AbiDVAfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 20:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiDVAfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 20:35:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230F443EC5
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 17:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650587582; x=1682123582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zm/g8OPzNR9giOyFr9uM7ZZdfGYxNp5OC0ULeJAh1XM=;
  b=V9W3M+RkLhv5i/IM5RhmZggwxokLEKBxnlVSL7sQHKTlo6DD9T4IPmmx
   7HR8Cg3HKTshMIfe8wDhD+I1Yf7qeKue5FsZlhP2UqC78GTN1DouaL9hf
   2d/z93sA2xs5SDUbqMgc/DcodA8bIuUNRdYjE+6Rnqa+6jEkHGgkJi/rx
   MgFqBSkYdZ3Y3vWb91YVppfgQYVsm5NzzHOzaSI6IWHZrHJ4to+W57+rA
   hLXWmjIqLIfNzhzIp+jv9SE8tmNjXDUksxsvIxMXXhbM66P+d0mdWFur3
   SlDmVtWrbqGcM0Y3OKX49lNNCiv8Z1mnVE0j8ZQuHVWcageVCoQzsw2wk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="251848255"
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="251848255"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 17:33:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="648371821"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Apr 2022 17:33:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 17:33:01 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 17:33:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 17:33:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 17:33:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvhFSZgVZOwnF02/zdKmpd+xEd6JT3CZuO0PQh2ceXGKDLTGd6kOYRvd+JzhtizagFh0sTheg2klK8amflOE+Hpc5eAgVFF6FFPi1QUvhRJ2gfsgGC7WWIwCPOiAzd0RjokSSCUnTMy6GdarrQWP9g0Zdn1mnzo41V0Uv0udilQoH+tmjf+Es0dyiXWn4VsebcShdDZaeyr+yRl4JdocZWgJFLVHMjpOgKh6QhOLMMQcIIGu6usw14uadn366JcXBCn6eEz0Geu3YBnkDfHtvUn5VBUe8F1KUPppG2WfioWuQbBlL7dV5nNWEypPemhYolkOMJ0Of4dhYd7LI5dI+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zm/g8OPzNR9giOyFr9uM7ZZdfGYxNp5OC0ULeJAh1XM=;
 b=FT7A8rWSjPKYU4oFhXqIbHirQcC+3OOB4D4pOhVnAxMGFNaaFqA0U4xj3UGG84cEeR2T37d9/4Xo7WZ7JQIm1Po8fifPzZqMry+JUQ+LlqzkxGNi1ff8VOvbASpJd59PUZXQrqMfrQOB/X25TnxrV6r1XCtCgKocQBDVr/jv/ZbupZzR1w+Sv/KMU83iuP4vwWTQpQuL1eTLfd/oAHXGoFTuL1UvE1JCxnVxfkOVBORClxFJqVQbyottXajSU7KARehJUWhs93nlJ9xowsaQYOhIHyhpRa55byKZHryTMfql/I+pgCxjDIHcGii3dqzdhgz6FP+kHOcEmucoQ4nUow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1890.namprd11.prod.outlook.com (2603:10b6:404:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 00:32:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:32:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Topic: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Index: AQHYVOwc8QHMMV75gUKPqgPshj3xIaz52v0AgAEzw8CAAAguEA==
Date:   Fri, 22 Apr 2022 00:32:58 +0000
Message-ID: <BN9PR11MB527616A86D88299C7E5F4B598CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <20220421054116.GC20660@lst.de>
 <BN9PR11MB5276CFD31471D4EE85DD705A8CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276CFD31471D4EE85DD705A8CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c971189-9a93-4fec-49ed-08da23f7a698
x-ms-traffictypediagnostic: BN6PR11MB1890:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1890C08CEA94F26D19565F118CF79@BN6PR11MB1890.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ffgpSvCiOlHpPUeOZ+LUMbilqNyNV58zRpOJVsAJTDYCDx0AOvE/A76TAso0pgWvInYFzBvavyoC5k7b40If2vfhYcEYl7T0OMlnlocNaB3U/PbuMz6N74oQ5VQomcyYTsKweicyHoztteoezGfu7/WWU7ZqILPD38TD3C2uxmqO4bl+EBV5HBKyDGdKVsJXx6V6opbadR1Y0vOAMi40+hkEcx+TdpbwAKPjHUL7JLlMWqVF+8eOgKdUp3ChFYo1lYzmZ5BNBN+rruSYJDcOGs3+USfS1ozbzPxFqSa+o0t7E28wPpfgez2rMsLtlU8HIYKsCx6mgt1fiktD+z0XTVVlRztf7cIBLVatxiU4tsx/cipBVix2lH4sM8GUxVDlnRuQBqxEOY8YB3Lb6Ygl9iMJSDePTpIsmrVO2TVz5aNA2Ez1jQcrVXuKM+PdrljNUDq0iffIj6pYYhfqFOk44o2x70VYvIExiV3dEkZRsQhAooWIOn9/kB4f3oDxvxpXILLtn/T9Ys7CkAGLZ0OZ1tDj0gxAavSsC2D8p6HlOXpw4L//2QoEff2+JlCwJNLFLJufKOs37xSbrm56gW1MYfrekt3y32dO5X83zPJiuPhM7jl/NYi2SIige1auuVnWf4/e2IoDeO3WC88uVD5AuQhiZkl8i0jpuY6OE9UFUH+xOMDqElGTpp8FyVLOsxkzcY5kSE3Q9a4XbPhhTAYk7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(5660300002)(7696005)(64756008)(54906003)(2940100002)(52536014)(66446008)(82960400001)(9686003)(33656002)(4326008)(8936002)(6506007)(8676002)(2906002)(38100700002)(110136005)(38070700005)(86362001)(107886003)(186003)(316002)(26005)(71200400001)(122000001)(66476007)(66556008)(55016003)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sgvYBhs0uzde4yEe63q4LAqZsDXNRHlvMGqkbBM5m9OoEwSnHeU8GH9eNOC3?=
 =?us-ascii?Q?efykejdE+BvM7YQ+eHp4Z+1erdkcKkegUoJZxOrqrIeHj/Pz+col0KtPSRfL?=
 =?us-ascii?Q?UJLjk3RlCEZDmx1zKiFvdGZBq78R+4oPJXbCdrGzhcQJqPDXOEErG9h+NdpL?=
 =?us-ascii?Q?B+fhHIdY6wd3aNqPl70SmgqykYCqGqQSA3fPgGPFFRGperipMucgWH+IHJNL?=
 =?us-ascii?Q?F6DmTgL2UXEMcnSh8X3iDzZP4j9fK2PEQlECfNUUfUFBeYVNY8zzBw8j35yq?=
 =?us-ascii?Q?bVGYb/p1fJMtzrtqV3BnEMexg6EY50mv2XdzapQu0lhHt9QkPeeGFmY5Wdgu?=
 =?us-ascii?Q?uB9eWurNhQOSecN/4LSK59/OPo6yQVq5g8uIb1moiPBFhaAlCrfkiADvh/oQ?=
 =?us-ascii?Q?aT2tLjaiAkpNwnrLSz8rJGfUL1BgA311yuZJftWlyHIXcdxLLrnrMdwpT9c3?=
 =?us-ascii?Q?t6DIbWSIsbaWfemjlDXn73jXWKOW8rm/nIe621//0hy+vldhShdrdARP93CZ?=
 =?us-ascii?Q?+bwNm9MA1nkmXzzRO5RBNUkCu8wowTtGdPPSxVRr9aUpjPai9SD3YWpRoJTW?=
 =?us-ascii?Q?/DH2rkjD+qD3XvhNMYQFchEcj2P5uIVEHLZ37Q16IbY1pUcBwhpX5Zs7pbFr?=
 =?us-ascii?Q?bPXiB4UmUvbkGb7dGclm2Lhjo+xcnaBUCrnsUajkyU8SYF88I7GtHr4IxFUx?=
 =?us-ascii?Q?VRlQQc0HsPRrOHDEc94Syd2nHqvpb2kF8TWOJANiUTbC3GFr+3tPR6SOeeX8?=
 =?us-ascii?Q?nR8u1xeUH2eJHkRJ1V+2Z0CTOpD+QQAZMACwPlMbdkWjNrL2/DO75p8Yx952?=
 =?us-ascii?Q?wx+5RfvJr9vHTy9zYu/wYYSg5XMR+MhIEJ1LO5gv4FnOHDVp9KCXeua83NFn?=
 =?us-ascii?Q?Nxggwzvzsi5B31d2AVMu7Kg2L6FKzZdKEFIMUsbelFbDOSIIGyueQiF/drg7?=
 =?us-ascii?Q?LoBQmeu9TWTjqaaZ2W2GPO96t+1Aq2LW/EM9QuDfoYZJ+ANexXmTKGj4JXm8?=
 =?us-ascii?Q?ML1JrhFY47FpFd3pj7YrT8wTuVMzAWy0++sYL2QJc38FxXt/H+t1ZdboUz0i?=
 =?us-ascii?Q?LdLqKRv9N4Y1sQSK/yhrq4XdwigmUUcczRR7rwjyLgiz+enXHdL3yiqFbMJw?=
 =?us-ascii?Q?ZMYFoCBYZTj8UA5DJVIT2AqiwaZk9NIGuYB0ysnxc9XSAZ4xZqGRtLvJVDQV?=
 =?us-ascii?Q?gPPFDC4jFzrGghelc88/eFTD5lZWUp1HFNeQIRA0vPvGl2wHSiey1tdWwOcc?=
 =?us-ascii?Q?cEw4OG7l7HcR7qUbYCdYGKN94EmmEyncunyassEyfA+tbHKu2IuoyMGmVvBn?=
 =?us-ascii?Q?BiepEn5fvBBJ6xZ5rUr4jNyqH1mJr1eV8DZMImpf4IJlqikojiB3tkGlqbly?=
 =?us-ascii?Q?7YBt36XrHkNbPgdn47foJTgB+WUO5qGnu4Hzug++DYx2Z3jRNbNB+q8fJY7n?=
 =?us-ascii?Q?sV8frW3KecGN9qsVBrbMFLKasPp3b0/90nUQ20tNLidomr8SdlaQzSttI79G?=
 =?us-ascii?Q?EeQIHg0ScHDPbv4cncCPEXqOk/jO5ZgYL12kkR2UI3y1ConQiy/tbErTz4/J?=
 =?us-ascii?Q?26bSPczheF1MGzeVk/F6tuL74zJ1oI3viZeFBjTcVd0hN3m5qjZXDu+R2yZb?=
 =?us-ascii?Q?8zmgUJEX9kcaaqRpEAi59YLldaiTiCie2MuBRm/Zu2bdP+FCoVLMP89yWyAC?=
 =?us-ascii?Q?wIxHSvEf0hnkqiLYWaZVRaw5xlMOU8NM9m6/NpTX0D33EkZ9krPEvRuguDC/?=
 =?us-ascii?Q?/b9xgs96SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c971189-9a93-4fec-49ed-08da23f7a698
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 00:32:58.5082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJP23PAcLzZbzabc5po4t9H5iZ4HuuWZF9bxDbNpXUzzSOudDNLFZeDnofDukdEtW1LyI95AkLupJfHMl0zj6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1890
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Friday, April 22, 2022 8:13 AM
>=20
> > From: Christoph Hellwig <hch@lst.de>
> > Sent: Thursday, April 21, 2022 1:41 PM
> >
> > I can see why a specific error might be nice for some cases and am
> > open to that, but as a simple transformation this already looks good:
> >
>=20
> There is a slight semantics change together with patch7.
>=20
> Before patch7 the container must be attached before calling
> KVM_DEV_VFIO_GROUP_ADD, otherwise vfio_group_get_external_user()
> will fail. In this case the result of cache coherency for a group is
> deterministic, either true or false.
>=20
> After patch7 vfio_group_get_external_user() is not called. It's possible
> that KVM_DEV_VFIO_GROUP_ADD is called before a container is attached
> by the group. In this case cache coherency of the group cannot be
> determined at that point. I prefer to returning an error in this callback
> so KVM can still fail adding the group, instead of letting the inaccurate
> coherency info to bit the user in a much latter point...
>=20

More accurately: s/cache coherency/enforced coherency/ in above.
