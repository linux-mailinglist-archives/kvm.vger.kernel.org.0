Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E6E6B39C9
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjCJJNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjCJJMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:12:53 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF1A1125A5;
        Fri, 10 Mar 2023 01:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678439284; x=1709975284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2mYYXlKOSBKYusH9k43bALaUggJ+IwLAzw8o6K5mvv4=;
  b=Hbi3wIFhApOdk+EULDWjEL6WPege4+fy2RE3RyENFhijt0EzVst6J8eh
   lGc2NjXcedm9eGkEjINilMzAScjl/4thExQ05ozvuD5mV2TzqG8YcsRY2
   p3pgzWhdmGbBKhma73fj55dzJCW1JyCAhWsPsxDdEIZfCguS1c37YOZqV
   9UFDk21aJykoFLXYmD2Y42aeD8BQM8Ki4eyPtFPyWz20Ja5A/xGW5O8kn
   N5kMPP+yeFOOCLhfECy4Zzbpn+Zecql6oM1xK0sDxeT5kz99kQkGyKqT4
   hNLS6l+P0wFrFUZ60jC3HJf4aEwSrCWxcwdFmNAYb42q6WPm1V2E19UuQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="339049286"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="339049286"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 01:08:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="1007047930"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="1007047930"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2023 01:08:03 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:08:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:08:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 01:08:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 01:08:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvIYbtS34sHxeweAog3CgMBj7TEAuxyXfkMXhcpH+LDxwWLkh/QyCHT1nEpvEyAwbOnEA+og2fMmWTP5PWL7BBJnHAr8Ba5WAgT+u890U/oXI3Fi/1WC97etCZ4UGYIpCz3AXoFmWlh1z0gHhXKfgZhEyrn+d5AJuLjJny+N2r1Tpk1Gfkdtt8ibLFndEnnl5NuQ6ZsdFKWxTG/VwHPnvEpMiyR8wKPWwoQkeHLRbP0xTUpydEdBP+RvhsvAV5GLDCK2jRdhlv9WMxvea8w/do5j3QTyJ/oedD24zpHvF/TYIjtmRGJMZE0kg8mxNU5LKTRk/S+BB5yNV8w2o0GNNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mYYXlKOSBKYusH9k43bALaUggJ+IwLAzw8o6K5mvv4=;
 b=gaD/QYgxvReeIm6+EtxEGXnMWFRScL4QAQ3BO26wD17RiGiFp3/SfbcMB1DHZMe9/3BRjP5NG+6v8/f9c/owVkz6OEjqBG2prOOPQr2lbUGcRkXToVC0uDgXtrSWoGXgs2PLKfJVq7/dKxgBmclppFhKdjTe8TzfHGumu+Dcu+U56s/Cc2IduYoIIHwokjsReUfjdUppyLa9+VFjeGFlR2hrj/LMyfxo5UlJ0w1FaHTCK2AZyEDMXqu+1iN117vgGBrXguMSJs5qcvmm6DJdNA4xDefiVtodITMckTjU2F5LlV2n1E06v8zEBKAv4NgFm4khYKL0Bk2OvkjbKRUzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB7422.namprd11.prod.outlook.com (2603:10b6:510:285::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:08:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 09:08:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIISo3Z1SbL8EmJASujVt/DZK7zfnuggAAKOgCAADLcgA==
Date:   Fri, 10 Mar 2023 09:08:00 +0000
Message-ID: <BN9PR11MB5276D348B54EFA0BFD0CB4E78CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <BN9PR11MB5276C4BB18EC47CD047D498A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75299B12BFB1A12DF786E6C9C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75299B12BFB1A12DF786E6C9C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB7422:EE_
x-ms-office365-filtering-correlation-id: 10d5f17f-074a-4d23-8e6a-08db2146f2b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qlq7C2sclaclw/nFDnOm4GEte+FPSAfzS3iglt9OesOSSn3R9ggYPB1VUX+lR0DcWce0aloYf8eeudJAxFhA34EjXnbmuSW2eV6UJh/gJxQKmbnFuOZqUVaJPg9OYrV0LCLr3PKgsqf4Pktwbny05bhEGrdoXjfeUvhpUlKEvBSe8gfJ4Dmo8HQSaku6isLi+QNgPHBDqgSO1Ht/rmPQTN2zz5NzLDTfLUFgynpAVN7WcBEXJNU5XeGNi9JVB4ojRvft3EDJHsTNxFCadSnbqHlJ9d2oRgX9+K5OdrfUcIUH38EdCUPwJy+WhDmSpUgrGzTVH0Ss0vqjxDMatfejO/QI4CEa7bltf8thSBqsjIW3PeD17u6IUCinXekSvZxaeDF/jWTIR2qBgNIZjRtLO27MWifZNGo1g+g+YyUlexdFeQsszB+p0+zoPTNZerZiVWpGhStOhv3aQ6wLMxPeZMaFsX41AfMESpPyZcgogr7vWtTpN5M65a8X3HaMpzOF56y8H22kpBw0bwkbcDMjbrQTrejBvzfbUBGMv8RbuvxMYqeiVPLcEY8EQ8KiSA4V2AFwA+Bob0tuzaYeAb8YzhkgAJwJtGyabqcGBFGQwP6l4X5wuhSESpNVSS/g5li01YODbSweOQzaKTqYq62XmS4Ujuo02Tp48qmb8cTH2+8tC6AenlAFwa5FSj/SR+KiC7leKLZKeWlVK7wn/abozw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(6506007)(26005)(9686003)(110136005)(71200400001)(7696005)(66476007)(54906003)(186003)(316002)(66946007)(64756008)(66446008)(8676002)(66556008)(76116006)(8936002)(52536014)(122000001)(82960400001)(41300700001)(5660300002)(4326008)(7416002)(2906002)(4744005)(38100700002)(38070700005)(86362001)(478600001)(55016003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmdidkRadThQVEx3OWFCenB0WkR6dW5qSVNWLy83bFRDNTdiMGNsRDI2Tm1q?=
 =?utf-8?B?SS9VOEJ1UXljMTVGOTlzVG5lendNNXJ2UVYwTmJxUDd6bng5LzBYVE5YYjVK?=
 =?utf-8?B?Uyt2cE5XazJrRU12dkovQUIyL205b1VFVG5WWis3Y3ZVdWNvV0ZkZjA5QTE4?=
 =?utf-8?B?QTZ0aVlZM1dmUTB5Q3dsMGNWNzVybjFoTHEvS1BTTjhjcU9kQVhQYkUxYlN0?=
 =?utf-8?B?c29ZY3U4OHoyY094YmlTckx5QjlnblN1RFBOYldBaXVYMDkzcVVoNlhUVzIr?=
 =?utf-8?B?Mzk0TENYYTBsR0h6eTJUTWM3ejd0QUt3ODd5L2VrNlpmeW9GWHp5WVdkWnQ1?=
 =?utf-8?B?Q1hhRXRIMHczcTFNZ2l5WVhkR0xabEpwUEJNZFQwcUF5WllXdjFleTMzaDFs?=
 =?utf-8?B?WmZ5WE55c055TXJRN1E0TTgrRE1ZbEF3THV5MWhhNjFHSGtQcGRMNStYMFhl?=
 =?utf-8?B?eUdYbUczQldWbWlzeGFiQ2h1ei9yL2JYS3BINnlwUHMvamVwczEvVmdSOUg2?=
 =?utf-8?B?TWFDczlDLzJNeHByVnE3WDN3RzBCekxyYlBBeWh1M3hKUEwxeGlyMm4zSlZt?=
 =?utf-8?B?SWR2OFpBYVBIQk5Ed2tVUnJDb1F0Q1c0L2QvLzFuSWFVM0hnN3IyRGJBOURN?=
 =?utf-8?B?RXlBVlc5QWxKdEFjVDZkZ3pvOFZJeFR2RlREbGY5K3JKMldQcVlYTEJpZkJh?=
 =?utf-8?B?NjhNbmdOaFBseFRhM1VIdS9Ub3BvTkVhYmFvVDBneTZ0WkhKSnJ3ZmVha3dU?=
 =?utf-8?B?K0VwR2pxNTV2d1V2NGVMMUdFY2h5WDVZOVJpc1VtSU9wZnNHdFNRVjhVTkxD?=
 =?utf-8?B?dWRwdmhWZk0yM0J1d08zTHhtNERJVW5QWTJ6QmlCaGczSWhpc3d2NWZFRnlP?=
 =?utf-8?B?aGhqRVdlai85dFFrcjJkNWxhM0RxNVlNbDZkZ0lGVFk3RWZmaUJEbk5wdzYz?=
 =?utf-8?B?QWdrQ0JreVFzL0lnN0ptZkxLNWFpYUhvS2FCb1V3QUVKZ2ljODRmWDBHbGtG?=
 =?utf-8?B?RC85QjJTdTJCaTZMZER1Tlc5TGVVQTdHWkxwQk5KYlFTaUgzc3M3T1BVOW01?=
 =?utf-8?B?V3dHS3ZUQ29XeHEycnpSTmdJUW1kNVRLRVBhSTlEQVVZSjFHV0dYcm40Z3ZN?=
 =?utf-8?B?UmN5MWU3aFFZRE1USXdvdEpWK0ZEK0hEbERFZ3lHdmptdkhxbzQydFlKeTJG?=
 =?utf-8?B?VUpvTmxnejVNODczQWgyd01vT2dmR2wxZFJCL3dXQ1dVY1U4a0x5ZVhLUnNn?=
 =?utf-8?B?MHN6dy8xbHpOR1FiUU5acVFuRGhtdVlZOHFyaVFkZnpHYTl1YkFMNEVDNk4v?=
 =?utf-8?B?V2M1SENBSUR3dzVRcitEN2cwdkU1cU5Hc09KU2dCdHpHejR0ZjZseXg2aU5K?=
 =?utf-8?B?dVdVZFRML1EyRlBxU0p5eGhBTEVxMk9lZ0doUUJVbFM4SVhUVHh5YTlRM0Qy?=
 =?utf-8?B?VG10UHZBLzFSQ1hFK0krN1F6bytaU0NkeFcvVzlkN3owQmZCVGVaNUJRUlVX?=
 =?utf-8?B?eVlLQmp0MXEzYXk5N3grM2dwR1ppcnFZaWlBaXBZU3Z2dENTNHZGRG53SVk5?=
 =?utf-8?B?RWtSMkdWSFJnaC9BN2FkaVhQSDArZ2gzSGpUK1pHcG5GL3FhSUZvaXcwbUx4?=
 =?utf-8?B?NzFZa2ZRNlFGcmdRbHpBUEdjTVNFK1JDc21oSUxSZ3AvaElLMjRSbXI4VHhK?=
 =?utf-8?B?QWNpczVjOWJmcmc5S3BOQ0taY3ZKQW4waUh5LzJDTFJ0N2RDeUU3MHMxL1hS?=
 =?utf-8?B?ZUhuY291ZWVlSXpqTGxiMUJXRDhkYmIvajRTK2cvUlloY2x4d0ZIYytrTkZr?=
 =?utf-8?B?RmJVUUhxbnhjaEZFNVpRK2xKMm9rYURZSWlQbUNNWlo3TWdoZ256MlAzUXA5?=
 =?utf-8?B?WFZ0dzl2TTV1MmFORE1rcFk5bzBQZ1Z2QXBKdzdmeGdINjJ1SkJZRG5kY3Fj?=
 =?utf-8?B?NHBDOTFIazZUZ2R6bjYwSkNMZmNuNFFLYnZvU3UzcktGOTNzNGRINzJ0dm9s?=
 =?utf-8?B?Wml6K3RtUzZCeUFpeEUvdnJCa05ycVNUM2lwNldiUGowSFVERHUvalZMeUcz?=
 =?utf-8?B?TXo4dkY0dVhxYmNBRHROQlZOWjVrdTdQQ0lNNHBFSWx3bkpTMUYrV3BsTnNt?=
 =?utf-8?Q?4cJg5H3igA3X96CzzTq4t6AP7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d5f17f-074a-4d23-8e6a-08db2146f2b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 09:08:00.6575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vif8E2W6t/okcVvcE/npLQfC8LUbVBbNbE1AA9MZgvjQEiWb7wPwn6Ye+Ivn/0soKPN2MJQOA9/77I9VFre1MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7422
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

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBN
YXJjaCAxMCwgMjAyMyAyOjA0IFBNDQo+ID4gPiArICoNCj4gPiA+ICsgKiBJbiB0aGUgbGFzdCBj
YXNlIGFsbCBhZmZlY3RlZCBkZXZpY2VzIHdoaWNoIGFyZSBvcGVuZWQgYnkgdGhpcyB1c2VyDQo+
ID4gPiArICogbXVzdCBoYXZlIGJlZW4gYm91bmQgdG8gYSBzYW1lIGlvbW11ZmRfY3R4LiAgVGhp
cyBhcHByb2FjaCBpcyBvbmx5DQo+ID4gPiArICogYXZhaWxhYmxlIGZvciBkZXZpY2VzIGJvdW5k
IHRvIHBvc2l0aXZlIGlvbW11ZmQuDQo+ID4NCj4gPiBBcyB3ZSBjaGF0dGVkIGJlZm9yZSBJIHN0
aWxsIHRoaW5rIHRoZSBsYXN0IHNlbnRlbmNlIGlzIHBvaW50bGVzcy4gSWYgYSBkZXZpY2UNCj4g
PiBpcyBib3VuZCB0byBuZWdhdGl2ZSBpb21tdWZkIHZhbHVlIChpLmUuIG5vaW9tbXUpIGl0IGRv
ZXNuJ3QgaGF2ZSBhDQo+ID4gdmFsaWQgaW9tbXVmZF9jdHggc28gd29uJ3QgbWVldCAiYm91bmQg
dG8gYSBzYW1lIGlvbW11ZmRfY3R4Ii4NCj4gDQo+IFllcywgaXQgaXMuIEJ1dCBpb21tdWZkX2N0
eCBpcyBtb3JlIGEga2VybmVsIHRoaW5nLCB1c2Vyc3BhY2UgbWF5IGp1c3QNCj4ga25vdyB3aGV0
aGVyIGl0IGhhcyBib3VuZCBhIHBvc2l0aXZlIGlvbW11ZmQgb3IgYSBuZWdhdGl2ZSBpb21tdWZk
DQo+IHRvIHRoZSBkZXZpY2UuIFNvIHBvc2l0aXZlIGlvbW11ZmQgbWF5IGJlIG1vcmUgc3RyYWln
aHRmb3J3YXJkIHRvDQo+IHVzZXJzcGFjZSBwcm9ncmFtbWVycy4g8J+YiiBJZiBpdCdzIHJlYWxs
eSByZWR1bmRhbnQsIEkgY2FuIHJlbW92ZSBpdA0KPiBhcyB3ZWxsLg0KPiANCg0Kcy9pb21tdWZk
X2N0eC9pb21tdWZkLy4NCg0KbmVnYXRpdmUgdmFsdWUgaXMgbm90IGEgZmQuIEp1c3QgYSB1QVBJ
IGZvcm1hdCB0byBtYXJrIG5vaW9tbXUuDQo=
