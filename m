Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6286A6B00A1
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 09:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCHIOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 03:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCHIOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 03:14:24 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819062C659;
        Wed,  8 Mar 2023 00:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678263263; x=1709799263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9TVKRV7ttpNq836ph6/wUl/cXyQjFttoGFnU1dOTgDA=;
  b=bAZ8IPVf7fwIMAoXrl90XmjRqkgNQGQM4/jeMzdF7Ik+9ibe5pxMobci
   Ocsvsd0t+wYSMo22y29/kO9sObSUYhOMnvPd0Z19SRhHT0NWayDbj6kd7
   Sk78/1iA/fDaUbnGUOJV7yK42UOj+P2ak1lLgZncHk/p6E6sspHbPUbEq
   LI6WlQruiIduamtcJW6b6uZctGgDNFDRV1aA9AMFcV3JbOg3XtolG0SQy
   fjXMK9sOrQ/60zN/85y12Yrx24NUYBk4kDNbwOTGZ0LB/ABYHD2LKXyE8
   Fb0CzLyc/8O0TQDthunQOawtqfzftbOXdsJ0L8rpldAJGpSpm6MxLfTa2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="315756919"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="315756919"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 00:14:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="679254875"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="679254875"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 08 Mar 2023 00:14:22 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:14:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:14:21 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 00:14:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 00:14:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aw1qZ3yj/6fZuFw2S/uLmklLlXhrI6JSqNPq9Ui3ZtcmFIQSG9okajbL5WL3M1Hxxsy8MKjkocsbxRwjVE7G8ljJ8JN3LYvExy9jdZE12TADiVOvFSE8hOICVcjmBDMf4htXcYzuSuEU/5eqWWPsX+snLXWbVhlvXVjYqVS38DIuzTZqmc4Ad3T+ZCwwQwOY24UbQV27bDBqX+119YZ03K9IWFOoQzDlO3USPomp4LBwZl3+fkGZRtHHtRJng89USOBoEv/5hePVaucHmXiHZcTz4zuQi+YOrrZ++oa60y6LJGNRwK3M9hs6WwQg0GZ/2R6Jmg3vY3/2gUrTe+AHzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkFziq/zchUt9epLCBgvr/QlB0l4HKgCgpp/mls0PRs=;
 b=jXHlPzcs3wLdzAQxmtjcllDec137Jlf1FaJmJbxxW0NNYRR7N6iNWkYI72xhGGfD3yKwZx7IDm4nyS4OM9AAYOSNnVwCHnZ4M25Qq7+zrT59ihCbpaY2pAiHyCW/goRvBW0yCxAChBH8pIrya+nLkyBV5bbFyc6G0OnclK4fnQDnX5bDtpZPuQNgMHLH2+qJWBv+WvSQu7+Vyj8vMv9a/c/BrLA1A2gd1A15A2ogKwI/MpkvGdMOpQzKEhCXYLAr6ZIp3RVYLUjgwN9HquHMokRj9h4IE+xOB41c0CUI243Nu0N8q9fD0xg2CcVm0vdMQjqxk5sx6pv0bSfAt9gDfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5926.namprd11.prod.outlook.com (2603:10b6:510:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 08:14:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 08:14:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4CAALuIAIAEeeOAgADblcCAAKtwAIAADpYAgAEqwZCAAAg3gIAAAY5ggAACHACAAANEcA==
Date:   Wed, 8 Mar 2023 08:14:18 +0000
Message-ID: <BN9PR11MB52767FCB0A7B838B7D78D92A8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75298BD3EB872C938F86C96AC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527659E9DF1849873ED089DE8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75291E848C663CEF67B1781EC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75291E848C663CEF67B1781EC3B49@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5926:EE_
x-ms-office365-filtering-correlation-id: e455c18b-bbb3-46b3-b957-08db1fad1d58
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZG3lNWF+vunwQcDstFUEaJ4T9pkc47TQV69SLNEbMYPpU9jxzw44OQ2Y4/zCNmhUUzU7srva6io2Mo9uPGsO2whA8WwpPVF5Hj1twRfrwPmcFfYdl/ZyfQvPO/0shde/r/ABuLo4+zmqg9+NAo5SmiVldxoT+l+OLbrMU4rId1R9YQNPaI8I6LjrOonTUuBZuB+uVIAebCmUca6ppLFNFl6rDk3Tjs9xpDzpD1i7d+Zttx+ZG+CqtKuSEN8PT/KJYAs5+CqrC2ke5tZXPUu1MD4aXPuc5DItfX0mp6psIaSUKFiz0CjDQHcqTBUMOENznqcSExfhai32JvEGmLOP6jouPjyyYHSjbiXbsOyv6M6bFkGXLxjoMJ8NosFtSn94s7CckqQBBsO5wkaFVLmlhgyzvdM277593k8EpTZxkv+Gz7MN9jQry+A/XlsGKk1jGU0z3HBVOGTUZDS2j7pbjxG5fpHIocrkkp4PEkQJfq36qo9idgRAqr/N3i3Fp6WYeeBKp1YYoe55IYvATsAazgvLmxGjOgDVUbQG2TK8P7v/EqleDale3+4rjE42LIq8Jl7SOWYGjf/qtM3w2fC8x317FQUDKU+ddX2hrXOJp9EfTSi1BlVAndI4IiZQaH3RjG8jcme89DDx/0JuV/tc75+aH6+SzTFs9f+EtOww1bG49shAiQk6fEg5r++YFn4IgffH1n/fibyRyaB4JzmBcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(76116006)(86362001)(38070700005)(122000001)(82960400001)(38100700002)(33656002)(66446008)(4326008)(64756008)(7696005)(5660300002)(66556008)(7416002)(6506007)(66946007)(8936002)(41300700001)(2906002)(8676002)(66476007)(52536014)(9686003)(186003)(26005)(83380400001)(316002)(478600001)(54906003)(55016003)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BlSy5gTj0GRkwEaWqy3eScyqet4RmlUN6Hapb3DPwyW4IAxm9r3N+XJTgO5q?=
 =?us-ascii?Q?u5DsFHKyThgkp0v9U7ms11rkdzch6VKCSt9AFZAhipBwJdITQJKSM42CDdal?=
 =?us-ascii?Q?wBBEO7SLBHbQZ0QgQy5Ql1mDLDo4b/mvAJvN99b4vdQ69sdmQEFfhXpe61GI?=
 =?us-ascii?Q?k9sC9L2HIzugGnZFGMGQEut3HTZXRMfS048pdtjkp3cNWohPOcoxbPAEywNk?=
 =?us-ascii?Q?ZfW+/0Z4psoL1ba9+F/E775bnK6RumF6veeHaBzovKHmS6A2Ke1Jfe6/bUKJ?=
 =?us-ascii?Q?lRMiu0E6o6WpxH2OZ48FBFeWRhtqhI0n9UifnPYhrWQam8TDIMV/m7mZPunX?=
 =?us-ascii?Q?rhkc0s27G1GMR0AkD23eDbWEfCa45LJ0M26BcGFVhVMO9yBhEGoSZf4WzH3Z?=
 =?us-ascii?Q?KN2xDytKX3gjlIC2ZNF8K0aswUqLn1TZY9uyi/3eIvVzyjdXLx21ZIxbhLts?=
 =?us-ascii?Q?+w9CIC1H8lQHK4bYPtc7d0wrBP4DQc1OEAUnj009X3aQln4Qxx6yDqLKetaQ?=
 =?us-ascii?Q?BZnL1KaqG263jrOqnpvuujo8iSePlPDrySvE9aK4DrVady3Qeg7//cXRTjd0?=
 =?us-ascii?Q?cbq5y35uzr/YJ9ESZqZIWKt3fLuc0GcNqzxqS2OK+lhni/dypCoT9PW8PSU/?=
 =?us-ascii?Q?Y8owUHLywW36KjLKVuLN0I/czezpCwqp2de6AUacmSpGbBebPOuwPx7abyhi?=
 =?us-ascii?Q?cFRcKvI7dsO9iiBGHfegwNR/NF5hDYS3PVqGy8FkbjEi0AxRhMJ8fLqlUx9U?=
 =?us-ascii?Q?QwHLd5ee4OX0YXxoFPPG/1dr6DGRRO0S+p52xO7g9muVrrSdf6+X6xl7Qsi8?=
 =?us-ascii?Q?1ngF8Co90zNoOFjFf7I3e5BdrmP+orS9PKoVqfJmxbAhjzNRYhUWKs1pGCs2?=
 =?us-ascii?Q?xX5uY0oufg4NxTdHZzmySObXd/wt46h1QtrljqTXq5S1dXsjcfk6jmAs2Xnx?=
 =?us-ascii?Q?2dEs3MYG4BsCN2vVF51dtBVTS7TkLFQdXAL6mlgLcn9sF+G4sZlVfSb4SLsE?=
 =?us-ascii?Q?P8JR9TtAoMRlpNA7IvHGhsnJ9/x1GFjsYphbJE3Ij4fEuczxTYem4X1rY2e0?=
 =?us-ascii?Q?ftExZ6W3EAdkiJt/BUf+bKD1Hl+RMdRErLLbAJc2u4xapONYcv677a8XvuSR?=
 =?us-ascii?Q?LfWvTeejqNQOMeuQxxD0RNgnS6+xs/l8FErgVTiQnKqhxM2UMcbCaRKAlFA/?=
 =?us-ascii?Q?l57ulDrzjVrYan1ZyOWE0UsvNGShx4nliJqy+2T2r1lywloR0G6nMfy+KcBc?=
 =?us-ascii?Q?EUKzV1JzvLkgx6ormNTIHPAaKojS2/pXUSKfhIpjLew/XEeRLXoOfWR7IFzI?=
 =?us-ascii?Q?UjvUZipWB6eSMoJbtjIcUcg51acqjlsOfwuz+39oXWkRoHQf64QGT/m4tbYL?=
 =?us-ascii?Q?20ypVxVYyfCyaTZVSliYWVdVU7fwr7bdgnT2skJJ3id7oIQdgSNkBw4JAzNv?=
 =?us-ascii?Q?uQUi9t+JPjwuIg3eHnhuYluZov20asJlt2rz/0dmCTxDklgw5VmDNxaoSKg4?=
 =?us-ascii?Q?/XsqFT3dkzEr+eK0zBbLqc1aJZby9+FnH6v7uq0B2XuCDQGPjuLeN5FhPBtc?=
 =?us-ascii?Q?1tar7ql/nEEWEhGVXoE8OmXyAw+ufpuR4FBED+Xm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e455c18b-bbb3-46b3-b957-08db1fad1d58
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 08:14:18.4901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+q7talha0EQLiKP0L3mYyiS0NqaMeEqBFoFal46NaLhSW7FxXKem0NWbTWul0I3valvRo5go+5Xr01Z5OEFSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5926
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 4:01 PM
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Wednesday, March 8, 2023 3:55 PM
> >
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, March 8, 2023 3:47 PM
> > >
> > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > Sent: Wednesday, March 8, 2023 3:26 PM
> > > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Tuesday, March 7, 2023 9:29 PM
> > > > >
> > > > > >
> > > > > > I really prefer the 'use the iommufd option' still exist, it is=
 so
> > > > > > much cleaner and easier for the actual users of this API. We've=
 lost
> > > > > > the point by worrying about no iommu.
> > > > >
> > > > > Hmmm, so you are suggesting to have both the device fd approach
> > > > > and the zero-length array approach, let user to select the best w=
ay
> > > > > based on their wisdom. Is it? how about something like below in t=
he
> > > > > uapi header.
> > > > >
> > > > > /**
> > > > >  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> > > > >  *                                  struct vfio_pci_hot_reset)
> > > > >  *
> > > > >  * Userspace requests hot reset for the devices it uses.  Due to =
the
> > > > >  * underlying topology, multiple devices may be affected in the r=
eset.
> > > > >  * The affected devices may have been opened by the user or by
> > other
> > > > >  * users or not opened yet.  Only when all the affected devices a=
re
> > > > >  * either opened by the current user or not opened by any user,
> > should
> > > > >  * the reset request be allowed.  Otherwise, this request is expe=
cted
> > > > >  * to return error. group_fds array can accept either group fds o=
r
> > > > >  * device fds.  Users using iommufd (valid fd), could also passin=
g a
> > > > >  * zero-length group_fds array to indicate using the bound
> > iommufd_ctx
> > > > >  * for ownership check to the affected devices that are opened.
> > > > >  *
> > > > >  * Return: 0 on success, -errno on failure.
> > > > >  */
> > > > > struct vfio_pci_hot_reset {
> > > > >         __u32   argsz;
> > > > >         __u32   flags;
> > > > >         __u32   count;
> > > > >         __s32   group_fds[];
> > > > > };
> > > > >
> > > >
> > > >  * Userspace requests hot reset for the devices it uses.  Due to th=
e
> > > >  * underlying topology, multiple devices can be affected in the res=
et
> > > >  * while some might be opened by another user. To avoid interferenc=
e
> > > >  * the calling user must ensure all affected devices, if opened, ar=
e
> > > >  * owned by itself.
> > > >  *
> > > >  * The ownership can be proved in three ways:
> > > >  *   - An array of group fds
> > > >  *   - An array of device fds
> > > >  *   - A zero-length array
> > > >  *
> > > Thanks.
> > > >  * In the last case all affected devices which are opened by this u=
ser
> > must
> > > >  * have been bound to a same iommufd_ctx.
> > >
> > > I think we only allow it when this iommufd_ctx is valid. Is it? To
> > > user, it means device should be bound to a positive iommufd.
> >
> > I didn't get it. Do we have a iommufd_ctx created but marked as
> > invalid?
>=20
> I mean iommufd_ctx=3D=3DNULL. If a negative iommufd is provided,
> then kernel side only has a NULL iommufd_ctx. If so, the ownership
> check just fail if it uses iommufd_ctx for ownership proof.

it's fine. iommufd_ctx check doesn't work with noiommu.

User should use device fd if involving noiommu.
