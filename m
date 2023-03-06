Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C625A6ABA8A
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 10:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjCFJ7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 04:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCFJ7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 04:59:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13B4F96B;
        Mon,  6 Mar 2023 01:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678096752; x=1709632752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=akWzsp+2DgLW32e2JpPZgNSg1Tp1PYlTQCHHSmvpuQ4=;
  b=dIVRtXeRnJ+z2+q+1+XKzk7PIJn92sId6az2vhDCccDO5At5RuvqXxAN
   HsNIfmTxlqxnAXQw+gqLMXagxuLaxBm1pUrzLUsiF13T+ixG2vY1K+fLQ
   73mZ7ZIbOaBVqzVnb7A69HE2uz3TVSjPKmCcOS+5odsyzkE9pUA1BUvkF
   pjggrpIQo79zvT32QXJew+843VniRdF74tyY8Y6iX8aoBkQqXzRY1qwA+
   rxAnYbY2pVWrVzZiNwt7RNEB4R3tUg6UMGKBBx2mUfJzViQ/DVp7aC9tZ
   /USOBCkGp0+WwHnd7fiCnAWrn4kKp+2DYhwBlGFQY9DRRQAQ2gpHsjeqM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="337032849"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="337032849"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 01:59:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="1005331970"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="1005331970"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 06 Mar 2023 01:59:11 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 01:59:11 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 01:59:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 01:59:10 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 01:59:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7T5mn7FBch0J2mHfQ1JVxYZXj8RIYNAAXN8OSxSXNVYdbr6nCRCjgiSKWU6CzG2wbmq9K7Gq7JQajwO4pI7Z5RrNPezsEgpPe1QVCo+XiTzg5IVWG0hEXZVTANGfrnPGb3dd8cs1dbz5ZS0LN21ne3FzAywL3tfpOHGWDMnFlooSKnJn01Ihaoc6olqnpL4AWbAe3fqTf0inoNr26qWkES+rURxkYs/ge9ZVWi1I0CbL5rFofoEH5k0IjblnPO+fE66V+a4HuSOjcN0lIJ4aJUpgrOKaATEhVZbacWyXSlYjWlKW2PlnmLnuyl9pfmXe57fpXN5al7Mf/6x3a7y3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akWzsp+2DgLW32e2JpPZgNSg1Tp1PYlTQCHHSmvpuQ4=;
 b=PA+QF7nqgBsbvYbblp3nflMJKVI1sPvFwNepXzdKtzrORZ4WvabnMPFggYPReivQjrLnsNVVeTUHgmL2FJUdHj86Ua0AZNg8/I1ah0aUAMuMoXelFl0BV7MQH2wc5eWCT4dbzCY6gu7yKlxEZ12GoasYQ7IHO+3Vix4hwCmn25Z/mEYcMyIV+ZtwvsdEVOs2nYfKaq01L5JUOxyyHcIs0yeRDcaVOL+GBbOS1gOPm3qXFYWbXDT70SkWp35HqyJGLqhN7bfCcXsM6h6pWH41e0AVwlhWNA0QEq/kNJQXM7mhRMrzu6RHFcGoqE5sHzQwQFFzm0iCeW9lViIrOIaSpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5543.namprd11.prod.outlook.com (2603:10b6:208:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 09:59:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 09:59:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
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
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAC3GEwgAFkR0A=
Date:   Mon, 6 Mar 2023 09:59:02 +0000
Message-ID: <DS0PR11MB75294782595B97485455C4BBC3B69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
        <20230227111135.61728-10-yi.l.liu@intel.com>
        <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZACX+Np/IY7ygqL5@nvidia.com>
        <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5543:EE_
x-ms-office365-filtering-correlation-id: d9bf037c-7d76-456b-e89e-08db1e296a4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: byfzdyC4x7yKYLZt+yHcgmwTmlLG2LmKXE74bsgK7lEpgw1Zaxr75B2Fv3xRSZl3dqo29igFn+bPSUdaTyDTIen/6bpvjiZOrGwWtf7RaotKdo1VLrnNV1KfFBE2+KJrbWTo9Q1qFM9omSkKhYnDMudWDdaOlyW1oxWJ/IIsJ8C1r+wwN9GxcEr5sLmxV3zNLBAhYLNLL3NP/wVDmBaJwIgdLA1FsqQoS0AwLyURqSnoIF+CGePQ64NPDIPm7SbyV+mzVqiePO7WhF3e+ymlgWz/F9KfO5+TXdUatfqLBxsNGrpUCEz2LqU8acQnkTIM9kVqO5FYDrJel5nl+g/JvR1eVuPCulixcHRdadax7ipzzCnP5lqchj1mMt4rm9AoYOhkcBUHZTW21K4YWBegwG+o8c07aWsUP5MmcEpJTRvOjJduArr/ZttkJnU1Ds89d5aa+Hkq67fC3Z10OJPO4+zxp2t1RwU6u3T5elD7695HZrXLDDTWottvhhTUhcXx23oeswO8+vPvK+ih7V4Dl0EoOCu4exrTU3AThhDjNrGBeuGzSi/E6T1ArVTuo/+rLBL+HWpjfP9+E/mMVji4RVwPlg0kiqCIP2OUrbbLdkBCW4L52+8za+AyM5a+aO3ggFpob/vcpm5HCq0+7P144e6QiIIln8dfTXW4vOIlJ5lEXr1hHxZYe3/Bv6hoYYGXzhBNhfYE6VeiJmEB4eXZSPT2BL8/FcfzZXBI8GNKG8M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199018)(7416002)(5660300002)(8936002)(52536014)(64756008)(66946007)(76116006)(66556008)(66446008)(66476007)(2906002)(8676002)(4326008)(6636002)(54906003)(110136005)(66899018)(316002)(478600001)(7696005)(71200400001)(6506007)(26005)(41300700001)(122000001)(86362001)(33656002)(82960400001)(83380400001)(38070700005)(186003)(55016003)(38100700002)(9686003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzJqL2hkYVpOQjNxT2hmMGl4WDFGQmM1V0E4L2k5WVRZcVM2MVU3My95YVQ5?=
 =?utf-8?B?Umh4L3dBYmx4SGgrWGtVZ3ZRT1NkQ0dlNVo4QzNWaEVrUDBva3lCS0hJai9m?=
 =?utf-8?B?dUVvVmkwM2VENWdFdk83TkZnT1pjakd4NmdtdmFOL0xMOFh1dlU4dUZncEtj?=
 =?utf-8?B?a0NrL3plaHNYZHpYRUg2Q3ErbFMrWGpwSW5qT0x0dlZkY3daSDJob3l3MGdY?=
 =?utf-8?B?Y3BaVllMZVZTeFpHVnUzaHdDdDR1TngzZldTelF0dTlDb2VIZWFCaEcrck9H?=
 =?utf-8?B?ZGpVbmc0VW84OFdVemw0MHFpaSt4YldITzRoamFzd3BaZ0JkbGFBNmxxLzNV?=
 =?utf-8?B?eGQxMkFyRDY0RmtON3FBc2VIbjlmWjJQRHVtUmpVZklKRHZiN1dTZ3dOY2t1?=
 =?utf-8?B?RGZEU2pPbEFZOG9DWkM2cEY2UG8yTEVyWEhIMTRkUnNTNWNmNURsa0FILzNF?=
 =?utf-8?B?QVNleDRIOWEvMmFjdTBtaHhnUHp0Z3pRTjZSRUtGSUlDQXVsaVRFZ2Joejla?=
 =?utf-8?B?b1ZNSDdxaEdFRG5MNXV5QzM5UGhza2tDbXpNYmhWTVNoeFZRSW1aT2p2WFlT?=
 =?utf-8?B?TkR1RkdvMFh1eW9KZUsvTFpnZDhlSTVwajlRU1hxS3V0ekRLZGRkT2U3dlVs?=
 =?utf-8?B?WDNRRkVXNmM2S1hMdUhFL1FRczZYeWFHUzZQZmVmVmRPalViV1RaWHY5cVQz?=
 =?utf-8?B?V0s4bTdkQkRVdTVLQ2Qvb3VSUzZjVmgvKy8xOWRha0xsWDBSLzg1c0J4L1lD?=
 =?utf-8?B?MEJteVY2S2dvNy9DU1FzeDRRb3F6SFpOTGMyUUZISDJDbUl3aHJ4cHJuQW51?=
 =?utf-8?B?TGtMaFE3TXhYbFhsUjNzOW1IVUlWNzNZaWtELzAxbGdQdnppbDB1bVJmVlhM?=
 =?utf-8?B?VlFHM3UyRzg3MFlhbjhObjBBU0pyMnE1bUxBZ2s0VU9uR2VGVVd4ZHBzSUpM?=
 =?utf-8?B?RG9hOTVYYjFuR3d4UENsOW8vTEg1RlA2ZldZVXlLdzkyZERHUUVMY3ByS1NN?=
 =?utf-8?B?bXdlN2xpL1VTU1ZwMEZ5NDQ4RjFVU01xSUdVeUx6VXhpSk9aZUc2a1VyS2lr?=
 =?utf-8?B?WFJURWkraHFreHA1OCtxSmllWjI2cEtjYndFNkFZYkFlWFUyVEdIbVBHZFZn?=
 =?utf-8?B?WWNPSDZpYThpSWlEQzkyMVU1K1BGelVJaGc5YUY1WGpxeDZHL0dtaWQydWN0?=
 =?utf-8?B?Uko5ck5lQnlJMG5VLy9NRzhkRy9CdDVzMFpiZEhCQUNZWms1RzA1Q1NtWkZX?=
 =?utf-8?B?RWpGSWd3MVhaaG53YzBqb2ZGbEkxS2ZVcStwUk5ydU84SEJSM0JiNVdYcmsy?=
 =?utf-8?B?RlczTGFONHl2MEZmaFM2TEZjMlRxZ2dtRzJQOEtaRm5uNWlITWFpYStqNi9j?=
 =?utf-8?B?OUdNeVdQbVJpZ3QvZmVkL1BEcVJXQUFUdVd4cWkzZ0VQVGpqZG0xUUZ1Zjlt?=
 =?utf-8?B?RElSRUpYUVFEcFBnK0hxa1JjUXhvdXphNWNJVzRvTCtySCtmbG5yYytjamJP?=
 =?utf-8?B?b3RBYWUrT2F0eG13N3RuL0VGMnZ3eHIwYVlPV0JSNnJzdUpKMkFVU3R5UFRx?=
 =?utf-8?B?ZCtNSjRUYmRmdXg1emp2SlMzb2JhZ1BlTkJSSUluUFY4UWhrNVpraGlZb3JM?=
 =?utf-8?B?YnlEUE1HeEYxUGRtSTJ6ZUw5SExra0JDN2NCNlJDS3ZCVWI1NWkxR1RXZVlB?=
 =?utf-8?B?Z0YxZGRscnc0dFFDd0VSdFEzQ1ZtcFJsYllnRlNMTkNZR3NsSnlFdmxORktX?=
 =?utf-8?B?eUh6R0FvcUN1aGJ0aXpCR3JwMkloRVYxOVIyWnZ2bUhDazhPd0tYSGtmM2Ja?=
 =?utf-8?B?VXYxbklhNEdhU25hdjZmVjNFVDMyRWZjY0VxNkxRQkxkVk1nY0pFdnBLQXhk?=
 =?utf-8?B?OXZERmFKLzdIR1Fwc25TcEpadk14UFNHZDU0eVRUaEJ1cG9YWi84NTNpNldz?=
 =?utf-8?B?RDF4Y0NyUnFKRm5WZ293NER1ZlE1UXh5Nlk5UVNCc0wyKzlKalNBdlBtRUs1?=
 =?utf-8?B?RTEzUjNSaHc5anl2K3VkRnJjemo4RXBpSkxFc1lsZE9TTlJxVlowYmxCU2la?=
 =?utf-8?B?YnV2MkE3cmFBaWFzdEcxZXRNdUsrVXBINUszQ3I4d2ZZbFN6WlFVdGpzZVhI?=
 =?utf-8?Q?IbVHtubvv6iPi99GTrp5qbJ1r?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bf037c-7d76-456b-e89e-08db1e296a4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 09:59:02.8637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XTZPtuLenNAfpisTlVbGVQBrcElSo1hrUb8qz5WduwTz9W71Urg7VTLUL0+QUkDWYIgLaD/6z3ubljrFxcmCHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5543
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

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogU3VuZGF5LCBN
YXJjaCA1LCAyMDIzIDEwOjQ5IFBNDQo+IA0KPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxl
eC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gU2VudDogU2F0dXJkYXksIE1hcmNoIDQsIDIw
MjMgMTI6NTYgQU0NCj4gPg0KPiA+IE9uIEZyaSwgMyBNYXIgMjAyMyAwNjozNjozNSArMDAwMA0K
PiA+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+
ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+ID4gU2VudDog
VGh1cnNkYXksIE1hcmNoIDIsIDIwMjMgMTA6MjAgUE0NCj4gPiA+ID4NCj4gPiA+ID4gPiBGcm9t
OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gPiA+IFNlbnQ6IFRodXJz
ZGF5LCBNYXJjaCAyLCAyMDIzIDg6MzUgUE0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE9uIFRodSwg
TWFyIDAyLCAyMDIzIGF0IDA5OjU1OjQ2QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+
ID4gPiA+ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+ID4g
PiA+ID4gU2VudDogVGh1cnNkYXksIE1hcmNoIDIsIDIwMjMgMjowNyBQTQ0KPiA+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gPiA+IC0JCWlmICghdmZpb19kZXZfaW5fZ3JvdXBzKGN1cl92bWEsIGdy
b3VwcykpIHsNCj4gPiA+ID4gPiA+ID4gPiArCQlpZiAoY3VyX3ZtYS0+dmRldi5vcGVuX2NvdW50
ICYmDQo+ID4gPiA+ID4gPiA+ID4gKwkJICAgICF2ZmlvX2Rldl9pbl9ncm91cHMoY3VyX3ZtYSwg
Z3JvdXBzKSAmJg0KPiA+ID4gPiA+ID4gPiA+ICsJCSAgICAhdmZpb19kZXZfaW5faW9tbXVmZF9j
dHgoY3VyX3ZtYSwNCj4gPiA+ID4gaW9tbXVmZF9jdHgpKSB7DQo+ID4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiA+IEhpIEFsZXgsIEphc29uLA0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBU
aGVyZSBpcyBvbmUgY29uY2VybiBvbiB0aGlzIGFwcHJvYWNoIHdoaWNoIGlzIHJlbGF0ZWQgdG8g
dGhlDQo+ID4gPiA+ID4gPiA+IGNkZXYgbm9pb21tdSBtb2RlLiBBcyBwYXRjaCAxNiBvZiB0aGlz
IHNlcmllcywgY2RldiBwYXRoDQo+ID4gPiA+ID4gPiA+IHN1cHBvcnRzIG5vaW9tbXUgbW9kZSBi
eSBwYXNzaW5nIGEgbmVnYXRpdmUgaW9tbXVmZCB0bw0KPiA+ID4gPiA+ID4gPiBrZXJuZWwuIElu
IHN1Y2ggY2FzZSwgdGhlIHZmaW9fZGV2aWNlIGlzIG5vdCBib3VuZCB0byBhIHZhbGlkDQo+ID4g
PiA+ID4gPiA+IGlvbW11ZmQuIFRoZW4gdGhlIGNoZWNrIGluIHZmaW9fZGV2X2luX2lvbW11ZmRf
Y3R4KCkgaXMNCj4gPiA+ID4gPiA+ID4gdG8gYmUgYnJva2VuLg0KPiA+ID4gPiA+ID4gPg0KPiA+
ID4gPiA+ID4gPiBBbiBpZGVhIGlzIHRvIGFkZCBhIGNkZXZfbm9pb21tdSBmbGFnIGluIHZmaW9f
ZGV2aWNlLCB3aGVuDQo+ID4gPiA+ID4gPiA+IGNoZWNraW5nIHRoZSBpb21tdWZkX2ljdHgsIGFs
c28gY2hlY2sgdGhpcyBmbGFnLiBJZiBhbGwgdGhlIG9wZW5lZA0KPiA+ID4gPiA+ID4gPiBkZXZp
Y2VzIGluIHRoZSBkZXZfc2V0IGhhdmUgdmZpb19kZXZpY2UtPmNkZXZfbm9pb21tdT09dHJ1ZSwN
Cj4gPiA+ID4gPiA+ID4gdGhlbiB0aGUgcmVzZXQgaXMgY29uc2lkZXJlZCB0byBiZSBkb2FibGUu
IEJ1dCB0aGVyZSBpcyBhIHNwZWNpYWwNCj4gPiA+ID4gPiA+ID4gY2FzZS4gSWYgZGV2aWNlcyBp
biB0aGlzIGRldl9zZXQgYXJlIG9wZW5lZCBieSB0d28gYXBwbGljYXRpb25zDQo+ID4gPiA+ID4g
PiA+IHRoYXQgb3BlcmF0ZXMgaW4gY2RldiBub2lvbW11IG1vZGUsIHRoZW4gdGhpcyBsb2dpYyBp
cyBub3QgYWJsZQ0KPiA+ID4gPiA+ID4gPiB0byBkaWZmZXJlbnRpYXRlIHRoZW0uIEluIHRoYXQg
Y2FzZSwgc2hvdWxkIHdlIGFsbG93IHRoZSByZXNldD8NCj4gPiA+ID4gPiA+ID4gSXQgc2VlbXMg
dG8gb2sgdG8gYWxsb3cgcmVzZXQgc2luY2Ugbm9pb21tdSBtb2RlIGl0c2VsZiBtZWFucw0KPiA+
ID4gPiA+ID4gPiBubyBzZWN1cml0eSBiZXR3ZWVuIHRoZSBhcHBsaWNhdGlvbnMgdGhhdCB1c2Ug
aXQuIHRob3VnaHRzPw0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFBy
b2JhYmx5IHdlIG5lZWQgc3RpbGwgcGFzcyBpbiBhIHZhbGlkIGlvbW11ZmQgKGluc3RlYWQgb2Yg
dXNpbmcNCj4gPiA+ID4gPiA+IGEgbmVnYXRpdmUgdmFsdWUpIGluIG5vaW9tbXUgY2FzZSB0byBt
YXJrIHRoZSBvd25lcnNoaXAgc28gdGhlDQo+ID4gPiA+ID4gPiBjaGVjayBpbiB0aGUgcmVzZXQg
cGF0aCBjYW4gY29ycmVjdGx5IGNhdGNoIHdoZXRoZXIgYW4gb3BlbmVkDQo+ID4gPiA+ID4gPiBk
ZXZpY2UgYmVsb25ncyB0byB0aGlzIHVzZXIuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGVyZSBz
aG91bGQgYmUgbm8gaW9tbXVmZCBhdCBhbGwgaW4gbm8taW9tbXUgbW9kZQ0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gQWRkaW5nIG9uZSBqdXN0IHRvIGRlYWwgd2l0aCBub2lvbW11IHJlc2V0IHNlZW1z
IHByZXR0eSBzYWQgOlwNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IG5vLWlvbW11IGlzIG9ubHkgcmVh
bGx5IHVzZWQgYnkgZHBkaywgYW5kIGl0IGRvZXNuJ3QgaW52b2tlDQo+ID4gPiA+ID4gVkZJT19E
RVZJQ0VfUENJX0hPVF9SRVNFVCBhdCBhbGwuDQo+ID4gPiA+DQo+ID4gPiA+IERvZXMgaXQgaGFw
cGVuIHRvIGJlIG9yIGJ5IGRlc2lnbiwgdGhpcyBpb2N0bCBpcyBub3QgbmVlZGVkIGJ5IGRwZGs/
DQo+ID4NCj4gPiBJIGNhbid0IHRoaW5rIG9mIGEgcmVhc29uIERQREsgY291bGRuJ3QgdXNlIGhv
dC1yZXNldC4gIElmIHdlIHdhbnQgdG8NCj4gPiBtYWtlIGl0IGEgcG9saWN5LCBpdCBzaG91bGQg
YmUgZW5mb3JjZWQgYnkgY29kZSwgYnV0IGNyZWF0aW5nIHRoYXQNCj4gPiBwb2xpY3kgYmFzZWQg
b24gYSBkaWZmaWN1bHR5IGluIHN1cHBvcnRpbmcgdGhhdCBtb2RlIHdpdGggaW9tbXVmZCBpc24n
dA0KPiA+IGdyZWF0Lg0KPiANCj4gTWFrZXMgc2Vuc2UuIEEgdXNlcnNwYWNlIGRyaXZlciBzaG91
bGQgaGF2ZSB0aGUgY2hhbmNlIHRvIHJlc2V0DQo+IGRldmljZS4NCj4gDQo+ID4NCj4gPiA+IHVz
ZSBvZiBub2lvbW11IHNob3VsZCBiZSBkaXNjb3VyYWdlZC4NCj4gPiA+DQo+ID4gPiBpZiBvbmx5
IGtub3duIG5vaW9tbXUgdXNlciBkb2Vzbid0IHVzZSBpdCB0aGVuIGhhdmluZyBjZXJ0YWluDQo+
ID4gPiBuZXcgcmVzdHJpY3Rpb24gZm9yIG5vaW9tbXUgaW4gdGhlIGhvdCByZXNldCBwYXRoIG1p
Z2h0IGJlIGFuDQo+ID4gPiBhY2NlcHRhYmxlIHRyYWRlb2ZmLg0KPiA+ID4NCj4gPiA+IGJ1dCBh
Z2FpbiBuZWVkcyBBbGV4J3MgaW5wdXQgYXMgaGUga25vd3MgYWxsIHRoZSBoaXN0b3J5IGFib3V0
DQo+ID4gPiBub2lvbW11LiDwn5iKDQo+ID4NCj4gPiBOby1JT01NVSBtb2RlIHdhcyBtZWFudCB0
byBiZSBhIG1pbmltYWxseSBpbnZhc2l2ZSBjb2RlIGNoYW5nZSB0bw0KPiA+IHJlLXVzZSB0aGUg
dmZpbyBkZXZpY2UgaW50ZXJmYWNlLCBvciBhbHRlcm5hdGl2ZWx5IGF2b2lkIGV4dGVuZGluZw0K
PiA+IHVpby1wY2ktZ2VuZXJpYyB0byBzdXBwb3J0IE1TSS9YLCB3aXRoIGJldHRlciBsb2dnaW5n
L3RhaW50aW5nIHRvIGtub3cNCj4gPiB3aGVuIHVzZXJzcGFjZSBpcyBkcml2aW5nIGRldmljZXMg
d2l0aG91dCBJT01NVSBwcm90ZWN0aW9uLCBhbmQgYXMgYQ0KPiA+IG1lYW5zIHRvIHByb21vdGUg
YSB0cmFuc2l0aW9uIHRvIHN0YW5kYXJkIHN1cHBvcnQgb2YgdmZpby4gIEFGQUlLLA0KPiA+IHRo
ZXJlIGFyZSBzdGlsbCBlbnZpcm9ubWVudHMgd2l0aG91dCB2L0lPTU1VIHRoYXQgbWFrZSB1c2Ug
b2Ygbm8tDQo+IGlvbW11DQo+ID4gbW9kZS4gIFRoYW5rcywNCj4gDQo+IFRoaXMgbWFrZXMgSmFz
b24ncyByZW1hcmsgKG5vaW9tbXUgc2hvdWxkIG5vdCB1c2UgaW9tbXVmZCBhdCBhbGwpIG11Y2gN
Cj4gbW9yZSByZWFzb25hYmxlLiBJZiB0aGVyZSBpcyBubyB2L0lPTU1VLCB0aGVuIG5vIGlvbW11
ZmQgYXQgYWxsLg0KDQpBIGNvcnJlY3Rpb24uIEEgc3lzdGVtIHdpdGhvdXQgaW9tbXUgY2FuIHN0
aWxsIGhhdmUgaW9tbXVmZC4gQnV0DQpJIGl0IGRvZXNu4oCZdCBjaGFuZ2UgdGhlIGRpcmVjdGlv
biBoZXJlLg0KDQo+IElmIG5vIGlvbW11ZmQgaXMgdXNlZCBpbiB0aGUgbm8taW9tbXUgbW9kZSwg
dGhpcyBhcHByb2FjaCBjYW5ub3QNCj4gdGVsbCB0d28gYXBwbGljYXRpb25zIHRoYXQgYXJlIG9w
ZXJhdGluZyBpbiBuby1pb21tdSBtb2RlLiBJZiB3ZSBhbGxvdw0KPiByZXNldCwgaXQgbWF5IG1h
a2Ugbm8taW9tbXUgbW9kZSBtb3JlIHdlYWsuIFNvIHBlcmhhcHMgd2UgbmVlZA0KPiB0byBoYXZl
IGFub3RoZXIgYXBwcm9hY2ggZm9yIHRoaXMgb3duZXJzaGlwIGNoZWNrLg0KPiANCj4gSG93IGFi
b3V0IGZhbGxpbmcgYmFjayB0byBwcmlvciBzb2x1dGlvbi4gQWxsb3cgdXNlcnNwYWNlIHRvIHBh
c3MgYSBzZXQNCj4gb2YgZGV2aWNlIGZkLCBhbmQgdGhlIGtlcm5lbCBqdXN0IGNoZWNrcyB0aGUg
b3BlbmVkIGRldmljZXMgaW4gdGhlIGRldl9zZXQsDQo+IGFsbCB0aGUgb3BlbmVkIGRldmljZXMg
c2hvdWxkIGJlIGluY2x1ZGVkIGluIHRoZSBkZXZpY2UgZmQgc2V0LiBJZiBub3QgYWxsDQo+IG9m
IHRoZW0gYXJlIGluY2x1ZGVkLCBmYWlsIGl0Lg0KPiANCj4gUmVnYXJkcywNCj4gWWkgTGl1DQo+
IA0KDQo=
