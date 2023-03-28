Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2AE6CB519
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 05:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjC1Dsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 23:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjC1Dsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 23:48:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA1A198D;
        Mon, 27 Mar 2023 20:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679975301; x=1711511301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DSe7cwCFqUkotgsTLZL5vBouehG9crofUqo+7GubI1s=;
  b=cFVcWMjPm9V4pvusAneMmofBYCf3sCPYv72UVOk2/NB2cw5ApGDn3/YC
   oc4h1W1nMyMgHBVdIlQGAsQZ1tnu1u1Xl70MiOA6uKuU8tHbiSxb/HwER
   9maQ2iuKhhytPFIyEFNOOuZlVV9Qg4sr+rInRysQCyo3NDujuGEIukLyM
   fYhLW85GA+iZdgh+Mi948oMzUUg+WC3ASu1ZxZHmj8JhVExSZW2KWmlH+
   fkX0/JCYytI8jmcYq0AuqqjM2fwROZg7bvT7JGxTiyUniuWjFAzjCZSkO
   XD4cZ7M7EHvWMkcT41fh4zLrPe6XKrFHUoloZTKImS2BQbIUC+hL66gCh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320114890"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="320114890"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 20:48:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="686229131"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="686229131"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 20:48:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 20:48:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 20:48:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 20:48:19 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 20:48:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSUlvmIf3lbhCPsbsipSwmvVYud2Kw4yz9zMB1tQBqfDCbCNtfQ2IEipyBhv6k5rS6QwjW5fhZVTGc7MTdPs8bcN+V4ojFIGvdCavpwFvF2jOt8VhF9LewvdEdD2vGWxr2xtdpqQ+m7b/UWgv/r0e8gG4NUIAS3X6RnZZkx+fqTBtmlOR0Qbzxn+jGUvTc1DOuoKiwMUS4FhxrmAFkWpTe+9sfI1vsLBLyewxEvSz8scEZPsvg+ImQGkHgr3Xflt9+RWpYGyRM8Os2twZJ17BPIJZy1qUAEG5jVwuqcfTKNWziBHlTSLctwIDxis1ZWttVlyfcUf1KYtRk2Y6llLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUVU/gAfE1z/6aJxJUJlXhApowSJb1kP6vhdyDZ9UVA=;
 b=Ic6xGr3SRkhbQ3MO2hIoNBghtn2WKXXvKPvtRtmT4pFtfRPTL9b1FbZJqMgzgCbsmuMm3k5+wpluXlJjfTWJdr0uzlzKgSPIrWtw+6l0G83mrz2AgVkgZj3gve6rpDCd21H7Zauaa5k6rrJQXc5pF5NeXp/q+L5gNAjtUzl77ycwQtU5OuS9xfun22yQgcv395IE4xs+e+A4XInkjB2/SFdxUXSNvFdGAwy5RCXDXNTJCQqvyA1QdK5IeVP9QgbbhnvJBi8LZm0RVhrPkDtXWOwq+5eYnFJhCTqEGcEZsH0QpxQYBojvUsYRU5YlkLKsLI6aT39zJTxnGPsF0vTy3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6893.namprd11.prod.outlook.com (2603:10b6:806:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Tue, 28 Mar
 2023 03:48:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 03:48:15 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Xu, Yilun" <yilun.xu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v6 05/24] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v6 05/24] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZXMm/9Fa4v1v3kUOQKgn/7OF4qa8Ple6A
Date:   Tue, 28 Mar 2023 03:48:15 +0000
Message-ID: <DS0PR11MB7529357DA6D37BCC48ED95B6C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-6-yi.l.liu@intel.com>
 <ZBsMb3L4LmmK5tHW@yilunxu-OptiPlex-7050>
In-Reply-To: <ZBsMb3L4LmmK5tHW@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB6893:EE_
x-ms-office365-filtering-correlation-id: e85477a0-cb24-4a44-d20e-08db2f3f42cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9TuzIGbVJ5BC6AFIKjwuD/U5FN4HeT3/6bJkvgcne4IfrcMoZVH1syu0KpGS/8I7NBB/SxgLdHbuTs9ky0Gfql3x0k44AnXvSeFcyUxcWy7h6pySLMQvmTJPDVviWhotNMAvZTVFYdYgJUiJ6bEMdJpmzSPaVxx+hmMaBpUtZVDIml/5FGi3ahLw17FeCZeLGiIFc24rcCJXY/k0z/MWxZC3bTnvtOfLctk+GZ6muH7gL/IKPUck2xJ+Z+lzo2160jNTzH4gslMYRq7BkYYgUYOS8EkxDuf04uTimRLNKbMQuUClSq/MZFWS9xwh5MQgOwu1Gm5FNCehuRTKDZYj9z0mIyHVsEPn+5S+S9s/01rJujw0th5xnGLKCAWqsXVAeKHAdW57hLnZePWStGqRIPq288sUSqk3sXs1Kqmj3HTH9Ok57lAFBDPz64lC+vQAZVjCktogy5Rz6w6M4+IyQaz8s+IuvB3MnbLzvHQ8aHJNRrlIECbXj/vKmpIXjUorQbVatIGmiyBqTa26LNOXJe1C5tR/letf/zwEcNI2TMPgUUWWQr4pPdMo5IUUVcl8OQDlwpAIEjUg3qsknNunJEaHMJsKxcvJRyW6BY00dGiIHtYNuRrZ3klF3vLR+POL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199021)(66946007)(66556008)(66476007)(66446008)(64756008)(122000001)(4326008)(8676002)(76116006)(5660300002)(54906003)(316002)(6506007)(8936002)(82960400001)(6636002)(6862004)(7416002)(41300700001)(26005)(52536014)(478600001)(186003)(9686003)(7696005)(83380400001)(71200400001)(966005)(53546011)(38070700005)(33656002)(86362001)(2906002)(38100700002)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5GlfqGMO9aNLhVVyfKDa2Wr/xvlADJnTb8VE0gwteiouikXoGvf6o3/E6qPU?=
 =?us-ascii?Q?Rykxcf+Oex+/qRZDsGFri8TkNdomz3lQpuo1BGF51//kY+C24tFqYn29VoYu?=
 =?us-ascii?Q?XQewRMKhux9TYEa281J4fpjgJfmqcdK9MLuMaKWlp165t4RpcauPqW+6n9Sz?=
 =?us-ascii?Q?bXvw1VVRyfXTYldcBPru2hFkY8RelLuC0HU/a8kvTJwowwQwBaZusC8OhWDQ?=
 =?us-ascii?Q?HfGyHW9NqnxZLxQ/kGBK1noa6LUVpt0mr5cR1+OIWDnPqR0s2rVJIDyCLjYq?=
 =?us-ascii?Q?ZyCAmg+wO0mXXbSjG6jdkleETVRyQuPQ5X/cxy90nG8TG+DSOU4sMasPFNd0?=
 =?us-ascii?Q?Y2DrRKn2AsIZbl9cWku7YeTEuuGIWAhL2d95F9n8KbCNDv2zo9GrJmOWDN8e?=
 =?us-ascii?Q?A2Xb/7qpupqeG3cLE4r98fd2LGN7aAr2zjsbD5X1chydo/Z/Pb3kKi4I2AvU?=
 =?us-ascii?Q?Y3TLpLcusFwzXQDzE1EwrWQTixA/3mpSpG8mDEqh6QkX6eQmT8JMddx8S4C/?=
 =?us-ascii?Q?vAmFHoSOICh1KL8RNz+O1gJ9wsth51LOHn7OZ/ZF4k00/FhpgIrSLMyu/tKJ?=
 =?us-ascii?Q?oQ3ccRxvUcWA7sjf+XLVdnEmKKG1TLrjk7vIbqRHuIyDnmf0RUkLgeqTdrrx?=
 =?us-ascii?Q?UNfLxnS6UgsVul/g9n7FViXj4eOjirn292BWmyMFEzLdmfmVFIOgGqpR5pa7?=
 =?us-ascii?Q?F1XsLcQyHRElXkrP03+K9IAh0cKRUbidGd5DigcrBJwLyF/XdnjGmMw/1kCF?=
 =?us-ascii?Q?Oa97IouwPtj/BPyBeT8JyzqO5YK1c/jU5kxL0IW3sboo+NcjcUCmPyS7b29T?=
 =?us-ascii?Q?nSc2aDDZxKtL4jHAtPGtU2zKE3hYcAHrgIOcrVezLMO0icASWhzh2k/oYvQ/?=
 =?us-ascii?Q?s4V6R1rQRQXBcsv/tAjPx72FYmE9tF10Xa2/73vmOLu3od2PcaUHq62v+63K?=
 =?us-ascii?Q?vNuMjf/evvp5olXRiSe2/ghucScg7gnm70udC6of6w6q/bVrJ7Tc8XaYxlQN?=
 =?us-ascii?Q?2X86p/3DWnvqHEHldjXiQt5x6+g+1mVM5c8kY0AjLN6j495t6dommAyuz+Ap?=
 =?us-ascii?Q?tL8nMzpO/4EVTq4C1rvsjqTibLf0XmsYHFeyqd2sKL3cRo6blIBjMTJHJ7ZY?=
 =?us-ascii?Q?D7kndRF6XIBLDWm6ZxKQhW/JW6fCwoz/dTY5YlZHt6zJUPyn/bOsetK9fJR+?=
 =?us-ascii?Q?FI05KpBwLTrwJz5RPZ69TnRn695YyWlyTsUlGLEsqL8b0ywyVNZvBsvkhSSm?=
 =?us-ascii?Q?bvdL5uVD2A/E1xBgudrIH4lPzWyy9ikjJVp+WOndjg8fO9dTRicir123Ducl?=
 =?us-ascii?Q?hOC0CEG8dWMme6ml6hY3CZJPFw/VMPrJfXCpL6NnFL+j2ff1zUshPx1Ley/1?=
 =?us-ascii?Q?sFUMxfW9oZVSffsizRJcjuIRMVsnoymCmtLc1ng2yPvNKLd4WVMtM2Mo2SsT?=
 =?us-ascii?Q?3PO6ejVoIM4d5jNbDSOVBccwivsjtS4xmk06zOLTU2eOemGmdLx7pFFZvHZs?=
 =?us-ascii?Q?TUJ0voNvAbvaODg9VLEYMLHBuyqgynCwka+1Gzqv3Wib+YN1Kfw913GBPro5?=
 =?us-ascii?Q?fNS5idv/UXQ8jCkHtQkeDgr+pxvivv1b1vAv2ML0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85477a0-cb24-4a44-d20e-08db2f3f42cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 03:48:15.3130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 13VrpgUpL5AQaqkO5uj9RfvCtmzQ3Decpc1VCHKyYZyn77D1OKbxgmWKUH2xjUARB+qwbsZMEUyji65QQKTAOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6893
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Xu, Yilun <yilun.xu@intel.com>
> Sent: Wednesday, March 22, 2023 10:11 PM
>=20
> On 2023-03-08 at 05:28:44 -0800, Yi Liu wrote:
> > This defines KVM_DEV_VFIO_FILE* and make alias with
> KVM_DEV_VFIO_GROUP*.
> > Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >  Documentation/virt/kvm/devices/vfio.rst | 52 +++++++++++++++++--------
> >  include/uapi/linux/kvm.h                | 16 ++++++--
> >  virt/kvm/vfio.c                         | 16 ++++----
> >  3 files changed, 55 insertions(+), 29 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/devices/vfio.rst
> b/Documentation/virt/kvm/devices/vfio.rst
> > index 79b6811bb4f3..5b05b48abaab 100644
> > --- a/Documentation/virt/kvm/devices/vfio.rst
> > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > @@ -9,24 +9,37 @@ Device types supported:
> >    - KVM_DEV_TYPE_VFIO
> >
> >  Only one VFIO instance may be created per VM.  The created device
> > -tracks VFIO groups in use by the VM and features of those groups
> > -important to the correctness and acceleration of the VM.  As groups
> > -are enabled and disabled for use by the VM, KVM should be updated
> > -about their presence.  When registered with KVM, a reference to the
> > -VFIO-group is held by KVM.
> > +tracks VFIO files (group or device) in use by the VM and features
> > +of those groups/devices important to the correctness and acceleration
> > +of the VM.  As groups/devices are enabled and disabled for use by the
> > +VM, KVM should be updated about their presence.  When registered
> with
> > +KVM, a reference to the VFIO file is held by KVM.
> >
> >  Groups:
> > -  KVM_DEV_VFIO_GROUP
> > -
> > -KVM_DEV_VFIO_GROUP attributes:
> > -  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device
> tracking
> > -	kvm_device_attr.addr points to an int32_t file descriptor
> > -	for the VFIO group.
> > -  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM
> device tracking
> > -	kvm_device_attr.addr points to an int32_t file descriptor
> > -	for the VFIO group.
> > -  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE
> table
> > +  KVM_DEV_VFIO_FILE
> > +	alias: KVM_DEV_VFIO_GROUP
> > +
> > +KVM_DEV_VFIO_FILE attributes:
> > +  KVM_DEV_VFIO_FILE_ADD: Add a VFIO file (group/device) to VFIO-KVM
> device
> > +	tracking
> > +
> > +	alias: KVM_DEV_VFIO_GROUP_ADD
> > +
> > +	kvm_device_attr.addr points to an int32_t file descriptor for the
> > +	VFIO file.
>=20
> A blank line here to be consistent with other attibutes.
>=20
> > +  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from
> VFIO-KVM
> > +	device tracking
> > +
> > +	alias: KVM_DEV_VFIO_GROUP_DEL
> > +
> > +	kvm_device_attr.addr points to an int32_t file descriptor for the
> > +	VFIO file.
> > +
> > +  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE
> table
> >  	allocated by sPAPR KVM.
> > +
> > +	alias: KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE
> > +
> >  	kvm_device_attr.addr points to a struct::
> >
> >  		struct kvm_vfio_spapr_tce {
> > @@ -40,9 +53,14 @@ KVM_DEV_VFIO_GROUP attributes:
> >  	- @tablefd is a file descriptor for a TCE table allocated via
> >  	  KVM_CREATE_SPAPR_TCE.
> >
> > +	only accepts vfio group file as SPAPR has no iommufd support
> > +
> >  ::
> >
> > -The GROUP_ADD operation above should be invoked prior to accessing
> the
> > +The FILE/GROUP_ADD operation above should be invoked prior to
> accessing the
> >  device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to
> support
> >  drivers which require a kvm pointer to be set in their .open_device()
> > -callback.
> > +callback.  It is the same for device file descriptor via character dev=
ice
> > +open which gets device access via VFIO_DEVICE_BIND_IOMMUFD.  For
> such file
> > +descriptors, FILE_ADD should be invoked before
> VFIO_DEVICE_BIND_IOMMUFD
> > +to support the drivers mentioned in piror sentence as well.
>=20
> s/piror/prior

Fixed in v8, thanks.

https://lore.kernel.org/kvm/ZCHW%2FQIKQVhBjg%2Fx@Asurada-Nvidia/T/#m7c076d3=
b9450c9de62b99a6fcefcc31c8ae3f8da


