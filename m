Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7F868B994
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 11:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjBFKLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 05:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjBFKL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 05:11:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA1E15574
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 02:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675678207; x=1707214207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dwEUZl5SyOSl6Le+/1acXGaHyJYyCmdblxVL37VP9KE=;
  b=hcwQQV4eatS17CL9ZVGPoDXVI/GhoEZNg5Q262kecPlGtETYPvhQBuqg
   o5U7Ce95qQqRzFVfcZejQypJi8n5x3aE9je7Lygtg2Y390QIVIL2usEIn
   rtDwM+DmedN6ZkfIFl5OOO2LgZQnEJJ9MDt+FhtGUtMhOEWGj8yOn/gF4
   R9sj8L8iBhROCRpWfFG1e752ObemV76PaJZ6wappKf9YXfyYughjoAzzN
   otR5Z9nB5Zp6J3wbjxC2vzwCnieRSaicS64Apr9KDlEmC9HeuufhChZL7
   z5reIuhqqzFQ2YMBVdwK3W56zihJ87EGPJ34/zjAvpxk606rdU8D3+M9g
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="329187418"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="329187418"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 02:09:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="643966684"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="643966684"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 06 Feb 2023 02:09:55 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 02:09:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 02:09:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 02:09:55 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 02:09:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0OngU63yh0mVA5i4SL3skR0cm9KwhXkQeCaf0m2aZ2Ebc/Wm75onQ8V2RLvNHr1dcia1zrjkpf94PXPwQjkbCp1sQ4uYByFmyycTJ29i0JcyY8/2tPMwpZDFH7NnaVQjIo3ZJ0GfEw/Uz5UHpUIC94nL+EXGJ0Cbw+H6di2QVradqgdJZ+Al4d9c6GSyUDWmVs++X+PNbT2a9YFkcD9dlkGOc97nzJC+6X6M/IjHhmV6eI0DYfX2FGYHpHDhj7pxtMUImhEg3CfLIFC77oFjCdd5eJdOSx9jsH5Xz0VHX3tq6v7F/RqvM6Lo0HRPp1Eh3a4yIf+Jm48bklCWhC18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwEUZl5SyOSl6Le+/1acXGaHyJYyCmdblxVL37VP9KE=;
 b=aPTYVYtUDpkkKPqfmOBlbAyc1gnkNHGxZ1L4LM6xplw2JGqVtKG9eT8qr+Q7KavbE56gJ8rp5xdZm9qRrZFSFYwmkEITDRwh9gw9BV6Q5ozZf7t5nHjRxVrcaT33P0X1UFwrSSNN/dvlZf9GWqsVGsSdtVhkbwttAHobKB3U553sZqYYMeokufzde42H5rMJCFa9dMObuc93VfE8Ho70nputkejQ1J45f2Jh+ZymRz291v93ql8BjwKjctgp/LcMwAx8bjx1RNXWYvrKOqRqFIPkfbiBarqo1qwvVGfuaBxXtVZ1fhgUwQ1Qt1GY16Rf7PMwo3qNjfVCzQfH+vu1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB8073.namprd11.prod.outlook.com (2603:10b6:806:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 10:09:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqafBBqpcX9SES7NJ4Rmsa6D66mbRKAgBCGzgCABEckgIACXXuAgAPaJICAAFxyQA==
Date:   Mon, 6 Feb 2023 10:09:52 +0000
Message-ID: <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB8073:EE_
x-ms-office365-filtering-correlation-id: a078d854-2e54-452b-a5b6-08db082a4a03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HCOwnWocPCbGGn/H1C7yGpW0kOUmzcmjIJY+RZ5bp8fYO7l+TxLC9lk5HeXo7vqDryMFOveVDN1Z+Wnb+TIaY4eHXfV3vNhNpfkAbczAras9tRpj+ZJ7qgM+kc5T3vKVo/uCtzalvZtO8JO4zP+sYGU72kSp4SrFILHbUbgXqE9Tzfjmhpdsu6LtnOk/vsgEUozGx1pxs7Ae/K27vAUgukyXrAU+eGOXxk7ZKfMpzw4CN5TgJZD2N01kc+3Pc52FBYT7LGCyUjK/BvrpuLrsZfSVExd9SE1vl/hrFQnbuwOFHhIMJRtlrED7hBc5jv/wiSPwM4k8t8PfU9kH0GFp5QZdefBVfgQldYXlGCvM/pBp+h+PcwhoN1ZDmqL5uC0sj2Mw/SMHF+y8ExrX8ztrz9yd6f0MawROLZSsmO+k45HUmFNVI1EbNiUj36c0Y3wE6i9i0LleLxWFGILYx7P4XgKBY0LCFhw2XdWFz2j62u/XkHMZVQTsYRM4h1uO2XdwNc0Xq0NMWsXJapzBFFlfcT4HblMCd6xP72K/pUE7g22jJmLoPjaJBPozC6VsWB6AFM9nmdlon2cqd90ovf728rlHFiCDjUNnW5MKfyUaExfcRBDQjQ8YnEvvf8uu4tO7xtHGgmOz4b2eID6SMZs69rZCgDtFkA6ZD4P4QoVUEGdZ+CtEr6vb1vbql2hgdGnR5/BAtDH+trWSwy64MRE8Yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199018)(26005)(9686003)(186003)(478600001)(64756008)(2906002)(33656002)(71200400001)(66476007)(66946007)(66446008)(8676002)(122000001)(38100700002)(110136005)(76116006)(54906003)(7696005)(66556008)(41300700001)(38070700005)(83380400001)(55016003)(5660300002)(316002)(82960400001)(8936002)(7416002)(52536014)(4326008)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wgugNresZ3IRSLwjoIFHuoCPWg2Z+ptENdzpUyS8InlPm5MS40tdBqxHFFX9?=
 =?us-ascii?Q?T4U675Nc3qvS8plVdqDa6t1Lx4gFghzB+VYk9G1kFQ8jWSBjmKJVdsDCIsS0?=
 =?us-ascii?Q?Z+H+kyNchU/S6CCjMguKUlvLx0vRr1NQ8Rt4ZJGnqzlbIl45c99LbDTmuTd3?=
 =?us-ascii?Q?bqjoFPogvNynkWLW436KaRoAoTIITQ9I4lHx+PgCCeKclSpo9gsEyBDwg7Z4?=
 =?us-ascii?Q?khc9lqS7xFW+wFz5OihPwCNqNC67FX0Ri8c5BM2IcnYVptq78sUB8uod7YQv?=
 =?us-ascii?Q?gy+tQBXfBs0cQhEryJDwMv4aOzb0UJSjXxsoF6udZLASD9R478F3vjxk/a12?=
 =?us-ascii?Q?IP+RjNlA7pI2ekXQQ6lH5TQ5so1T1MM4ZMr636/zr4FbWAFDkKELtA8uw+N6?=
 =?us-ascii?Q?rxrJHXQ5wJ7+zHhlyfjS202zZ0xBRHQOKQprVK5aTdukXhNmnP2n3WszE/1l?=
 =?us-ascii?Q?BaMO3/47ViEjfNpZWQJHxCc+nMZAjPmcLpKBmJCysdvwk33GAdt5KQbEdYFp?=
 =?us-ascii?Q?MAhwAIRXCKCPGip44rPh9K8pbuXUbx0H4kzJ7xFhCez4KGmtXwthqU1ksFlM?=
 =?us-ascii?Q?90pyhud0Q2Iq9XAOlPUcy1KeLgUUV5zAmZ6vgdj3arCqnrU16ZhGr6amytAL?=
 =?us-ascii?Q?M6JpIdbzcpD168RdrGGbYgb2f5F2ICGEQCUk6cOMIr5iK3JKFxA2eWB1xLpz?=
 =?us-ascii?Q?DLq0KW9hhGpUrDdsaVFteMBq0HDhsVRb/3J+IvDpjbayL0JLxr15+aIrIn/t?=
 =?us-ascii?Q?+xBiouOSj1dMQGveKO8l0gpC0VHus9TC+RlZOhmmWBP9qwS1uI6MtFZ6JMog?=
 =?us-ascii?Q?pZi1Uj7dxiq/opqowjAys3lWRJSt89CmrKKli9Q7PojxA35E8fXyjEQqXDAe?=
 =?us-ascii?Q?WPTD9l7ve1n5jU8NpgbYz3YN73R/2wEi4tRZZdXR8BAld/G/5i6aXXzP9cbS?=
 =?us-ascii?Q?RPEtfZBn3wobs03OgKsUlDCeeWx4piWF6K/7LnpskC8EcLmqiHIBHoOkwKni?=
 =?us-ascii?Q?avXFqn4wpK7twZ13nhzfSJM+qsj22bkInuS7Qig46ttr4POBrv4RokkRk/g7?=
 =?us-ascii?Q?CfKBBIraXM1KA7fv56qwlC/GIkCZ08KOtzQ9hmNNUd4EOA0m4RimMWt4WIdn?=
 =?us-ascii?Q?Tl/wfMj68M48b9WELbznEhiswy6W16z1b8PFd96TioTMq7Vbmx1AtxIJTS+k?=
 =?us-ascii?Q?Lej2k83Exi7LYy8OSuGdoFbxojkCQ7fJNLx/iLrtUSgIzGXCMWc4DWUMyerW?=
 =?us-ascii?Q?QYtVn679kgWPVZ5+52O7lg4XZ64KdmtkRIWH8c/7JD/826SDiNq7Y5k8i7Xv?=
 =?us-ascii?Q?sbw6n13ZRTAazsQ/gUjQSHWLqruZGmUMCXxPMiJiyZINo1GeQ64MnE/pG4o4?=
 =?us-ascii?Q?0F+4vdjl0yZbko5p7vPd4mTEgfEBGxxBcOAKUKVsMvWIkbESvAfglUH1oErL?=
 =?us-ascii?Q?m/jGCsF+5WLfmYpZ/nfEyJKyPbstmm2xnEzLqgsjHOrc0t/MSkAbmmcmZ1pm?=
 =?us-ascii?Q?K+vxDFV5QlVGcYWdG62V/jvbUcWb9d9xihNvbTdgw6dH2702hGEchNS+/aKP?=
 =?us-ascii?Q?m1YnUFHfN1RKMEEGoNH6QHQUvpl+ys6GxabOvGJS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a078d854-2e54-452b-a5b6-08db082a4a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 10:09:52.6302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PgAde/KPD39rgVQu0/CEmXxsvLQY9nCEBsZP4ZK+2plBiLFpb0ptg2NFo4R59ML4JHwl3FthHxWV/3YMqPeQZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8073
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 12:31 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, February 4, 2023 1:41 AM
> >
> > On Thu, Feb 02, 2023 at 05:34:15AM +0000, Liu, Yi L wrote:
> >
> > > This seems to be ok. The group path will attach the group to an auto-
> > allocated
> > > iommu_domain, while the cdev path actually waits for userspace to
> > > attach it to an IOAS. Userspace should take care of it. It should ens=
ure
> > > the devices in the same group should be attached to the same domain.
> >
> > Aren't there problems when someone closes the group or device FD while
> > the other one is still open though?
>=20
> Guess no. userspace can only open devices from the same group by both
> group path and cdev path when the group path is iommufd compat mode
> and uses the same iommufd as cdev path. This means the attach API are
> the same in the two paths. I think iommufd attach API is able to manage
> one device is closed while other devices are still attached.
>=20

I guess the problem is on DMA ownership.

iommu_group_release_dma_owner() just blindly set
group->owner_cnt to 0. So if someone closes the group FD while
cdev FD is still open, the ownership model is completely broken.

IMHO using iommufd_ctx to mark DMA ownership for iommufd compat
doesn't sound right. The group claim/release helpers are not designed
to be exclusive but due to sharing internal logic with device claim/release
we then allow group/cdev to share ownership when a same owner is
marked.

It's probably simpler if we always mark DMA owner with vfio_group
for the group path, no matter vfio type1 or iommufd compat is used.
This should avoid all the tricky corner cases between the two paths.

Thanks
Kevin
