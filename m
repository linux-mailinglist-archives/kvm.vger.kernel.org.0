Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411A66A3918
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 03:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjB0CyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 21:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjB0CyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 21:54:06 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66E7BDCB;
        Sun, 26 Feb 2023 18:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677466440; x=1709002440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wDSz8pzYajSybRHKzw/LPoDfA2jOoEJAXB1SjxzVvKY=;
  b=PaJD7vCgScgtR6hkhpaSA7irbmmzB2zDKmMYF6pSK/6m6vBDyhhqL7US
   gVslMX8k98JcXy1F3klHi14UtBXxIhCrPir8WubhMx647coGIfPjRY/tv
   ZKQSkk/OMbnSI4TCkd/Uz1Gfwz/NOqCmfBokZY2R/j7tB4jTwz3B3oJjy
   psXFEtu3Fke39CKKfHSOYPO6VExScpKp45Dpi7MrknXF/G9L6baMwR1aJ
   MXZ+tm6cH37pxd12APg2sidT4rdqqOX2TCQ+PuCKutDmRGjTuZVS6ff+/
   hx8ILpFyWJ7XCeisxSeTCFNJ3XWS5NZoCuUz1YKSsQWrXWd3ZqK73HdqH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317567213"
X-IronPort-AV: E=Sophos;i="5.97,330,1669104000"; 
   d="scan'208";a="317567213"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 18:54:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="919125472"
X-IronPort-AV: E=Sophos;i="5.97,330,1669104000"; 
   d="scan'208";a="919125472"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 26 Feb 2023 18:53:59 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 26 Feb 2023 18:53:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 26 Feb 2023 18:53:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 26 Feb 2023 18:53:59 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 26 Feb 2023 18:53:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQ8/dDGxUkPWWD5KVROpZDmkg0O/tfZibsP06FiDXsdiwSriTTi/7yp4ubAWzRWophqzuI0JytompSlo+/ketPY9H2mMB2gDDhQ6kq+9E+sb1K1YWAQX5DAmyuGLZ6qcddB02EioD/2v1DjIS0DMd3txKOa5YQZ1tBCiWB315Y4b36hzFHAbc1IJn2Jo/N6zPwITxtaYc/RvK76t2pO25quUfDvJsTU0HGujTuKdwYRhwzxw/uDyREYEw8mEU7p8fHZGOIrxePtYWWxME7vkNR80GCL9Ao0Sg5EHTQjIwaDv62GcPerXHk+XLI01Oi//e3muATd2GOidegJlDXJ5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDSz8pzYajSybRHKzw/LPoDfA2jOoEJAXB1SjxzVvKY=;
 b=DSs7AiTpGipGLRBeZkR4ZqyWX9BP3E134jEO9LPvPEK6GLnpYfU/HaMi5Vm0QOJfJ9d1um5iTx54k5H8Js76lACcOcDqqDnTclzltfqXnyRss4393m5XnJPqQKZjbr/XMuF/UT1KLJA6R0h6Q1eGhIw0UY+tm+rB3iGJNI5kd8Cim6z41+DmNtMKaf4QyVtIZE52wkIrJW95V7IO2H8wAunZ5mDAgzeYZV7wNroinDNgCOozd1hLuh9eJFqfn4e5pB8mMa/4PwviWwIkcSvDjlWJSfwsspNV+INSSnjclaFo4I3ZvvRYnDMWl6LX/MEiAySVto0/p1p0VcBtsKI49w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4575.namprd11.prod.outlook.com (2603:10b6:806:9b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 02:53:56 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.025; Mon, 27 Feb 2023
 02:53:56 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRadeNlgrDl2wokCstlukf6hiCq7akpcAgABgJDCAAEUdAIAA9TSAgABbNoCAANnbgIAABBCAgAOERXCAAQGegIAAMUZw
Date:   Mon, 27 Feb 2023 02:53:56 +0000
Message-ID: <DS0PR11MB7529A45CFDB80DB4DB8253FEC3AF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/gilafqe4Xm45jY@nvidia.com>
 <DS0PR11MB75292B46BE9CAC31EF4AF833C3AE9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/vt4yjNhXUlFwlL@nvidia.com>
In-Reply-To: <Y/vt4yjNhXUlFwlL@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA0PR11MB4575:EE_
x-ms-office365-filtering-correlation-id: e02dda57-71e9-4925-5e11-08db186dde52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XyDqywmZN++PURyxnQBefroVR/k8c/A5F7qvBo72DG71WB1r3ZfZoMNEK+KTgS1HaZsVzM8w117bG0CfhTe83xSx9ciczh/DGhZPr+UwWASxhl8N9En9v0TlMbmCIw3hhtL3hzsu1pACZhU3C3RWl3W2RVHxuTLxPtcY1pXk0hyOysg2t8W+s/kHxnyRc7trcQ+m+IrEYpdnzDu53opRgeekv+fQ9HsC0+AIQ6XlA6Ww0oPmyW6J1vKljcv+bDHF4yFO9ddOEgsk9fPXq3frvtY3QFag2Pvf3osDSWUq+6ypimM5oZGvkdfxVMbWoMGzfBstc19b/oDSNDdvWTPBpXp/3W4JM3nd8i5m6nQN5xeeNFdjN4C+Qo8cYXkcGjLzx4bdJLU24zikinf2nMdZLLVpPkJfdJasJ6dMyc7HwpasqswC9hj+oDmOV4+qMmNxSqiLMBr4WUDqEt8+lXN22TR2IAfuOgxZAi71HPBzrw2TP4bjAl2XWRyb6RRF0Fa78gU8eiOPDIY5M3Pu/+3EtuFiNRtrDDgqGclXBMsY9PIh2xWGGippPBa+nD92Lc3zlO1F9sLgHAfLqqARgMJziEcGzG4PUOlXhotnsylyJcSrGuADHYHUw7BTW7MesXeEwYjGU1IgSNaDYLA5hY8qG8xdpzOmkOlqVKy14ITnzVHh5phKG8asnqgbaSgato7hxK8iBn00PpxjlL8E3V+WiVh4qJsV0tieHhtJjBYcSvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(122000001)(316002)(82960400001)(2906002)(5660300002)(33656002)(7416002)(8936002)(52536014)(55016003)(86362001)(6506007)(66946007)(76116006)(26005)(9686003)(186003)(71200400001)(64756008)(66446008)(66476007)(8676002)(6916009)(4326008)(54906003)(38100700002)(66556008)(38070700005)(41300700001)(478600001)(83380400001)(7696005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGV0aEk3Y0ZBMlBBdFFoR2dxUGNaM2wra3hVUHMxV21WVW1FNVRHRVRxY0g2?=
 =?utf-8?B?RUFES041WmNwU0VZbURJbk83Vm9wM0VqSVV6ZzMzZmZVVkdudDVHWVo4T1lX?=
 =?utf-8?B?NWJVQlAvSGNTU2pIUmNtTEZnZFBLNG1vS2YyekZjUEx6NGZuQzlGZ3o5dW9Y?=
 =?utf-8?B?dFBkRHJlWmxjWnF2bnpoMnNZRkZ3WEJBb1ozcll5SjZiTG01MW1ZcGp0R3Z4?=
 =?utf-8?B?ZWRRSkNnY2haN0VvQk1tY21PWmhVbVpGWC9TZzV4TGpzOUZEOWI3ckNySWRm?=
 =?utf-8?B?OGZQRUFhYmM2aGY3OWJ0Zyt5ZGVSR3BSaTlXMy9jMmVreFFSUnpYRVYxZEto?=
 =?utf-8?B?RzJ2Wko5WDl4cytmOW9VZDJxTERXUStXM0xkUnAzbUs3ZDRoem5EVGY0MUFZ?=
 =?utf-8?B?V1ZEeUFDUWFJSjVGRm5GUmZBUmplclBjejZSK3JqM0tHdmwwY3hSdm1pN1lt?=
 =?utf-8?B?RzJhUmlabjA3cmJ3cDV6bXdQdXM3ck5IZHduNWVPQTN0c01zaEFoUnl6RTJw?=
 =?utf-8?B?MmVzSW9CcERYa3piaDRiNHdFNW90YkFsTU5MQ3MyZTJ4a2JqdDBtbHdOYUlW?=
 =?utf-8?B?aWUxL1dxdXd2Q2FLTUJwVnBKNjliTzRBOVlQWllYdHA5S1BGVmRUZC9HeUgw?=
 =?utf-8?B?Yzh0TWFpR1kvNkNhRzhmd2ZvUVJ1NXNqc1RDVENPWVpmNU14Rk4vV21DZzJZ?=
 =?utf-8?B?TVFRanowV1BRVDl0eHJVV05zSjE0TWZFUnBRd2JvU3dxNFNnTGhCS0hwOVEx?=
 =?utf-8?B?U2ZpQVNZTTEwU2hCYTR0b2VoTkpuU2pxMEc3N1VYN09IQ2lEOUtBeitydVNj?=
 =?utf-8?B?ajJJVllabjZZS3Q1SVVFNU5EZGJZalEzZXdLMklKeGRRcnJlbHBJL0tyY2ln?=
 =?utf-8?B?a0dKbkE2TnNJTFlNdDFYc0NqNWV6QkhJVFI2ZWI5UnVnK3VlcnpxSDFOVGtq?=
 =?utf-8?B?aTAxZ1B2V2c4Wmk2anRtU3VMZDFWUzltbmxIMC8yVlk2dTgydHhMMi9sQnQz?=
 =?utf-8?B?Vkc1bjJSMkVFR1o3Nk4vWWVtRElqNzJqMmNHQVpjWGVYelhKS2pGWVFZK1Jj?=
 =?utf-8?B?VDRpTDVEOXQvQkpvcTZiNFl0TUlCaGJkeHkrRHE0ZWw4K2R5cldNa0RSTXVu?=
 =?utf-8?B?ZzlRbXo3bzFFS3hPMVF2cGU2a2pUb3VZZGFEVnNGL1J5L3BOUzRlREdDRG95?=
 =?utf-8?B?L3ZWWmV3b2hFRXZDVlJSS1NuNVhscU0xbmVCaWhTeXFtL3hnN2V6czNSa0FL?=
 =?utf-8?B?RmZ4bE1LcUtPWHpTK0s4S29zYkhOZmhtbFJabTZrbk9nenJ3dHVyaVRnbWdR?=
 =?utf-8?B?ZlB5cmJrR2ZwTzlvbWlQcWdwWEs2WGRkVFZGUzF2VHRNNU13d3VUVmhpNWFk?=
 =?utf-8?B?bUtOM205ekNLamlMMmVPVnAyaml5aitQbDdpNUxFVlFTczdCaVppR3hRZGdm?=
 =?utf-8?B?THhmN1NUemVPa1prc3A1b0ZWci9jbVNMVDE3UC96aU45eTgrTUlzZVJKM2xu?=
 =?utf-8?B?dGF1RUtXKzhFblVLVXA3ZllyQThQamJJSHhsM20xSmQ4MjFHdVFKcjNTcHo5?=
 =?utf-8?B?U1FlQU1RaXQvQmJIclg3YjRCYXRoRXIzeFM2WTZGWnNCeXFKOW9leGtPZnNJ?=
 =?utf-8?B?clhTRjBWcmQ1SlQ1bUFkVDBrRy9TZG12bjNLZmxFN0lxbnVYa25KeGlFNjZX?=
 =?utf-8?B?MWlMdHhGeW1zQVB4akVScVVqUHpRdTlCeC90UmdQcDNnbG9ZbmM5N3BqclI5?=
 =?utf-8?B?bFJIeTRRb09aM0pONTgxZklER2VVWG1nQlVrSFI3dUd4VVgyZUI1ckVtbXR6?=
 =?utf-8?B?V05JdWsrOGNDS05XVHFnQzhEbElxNGJCRUlLTVgvT2F4YmVrdHRldWhJRjNR?=
 =?utf-8?B?dW0yZGhyMExzQ2RoVytTUDVBRnYvOVAyRmJTaDQrM05oVmIvWFEvWS9qeUUv?=
 =?utf-8?B?Tm0ybkZRVXdQVm93bTVqeUhZWmMvV3RXZ1NkWXlVVm1MQ201NUJpeDBlcGpr?=
 =?utf-8?B?SmdxS2FmVVJIQUREL0sweTRrYmRQWEtjc2htUTVDdWxNVmxkcmQ5T3BEWWxT?=
 =?utf-8?B?dll6Ujk2bkpuN2tpWWgwRXZES2NaRXY5SnVVZUswZHRpakZHUGh0TnBieEVH?=
 =?utf-8?Q?vR8QsFMUeKDrk55w5x8IYNeU+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02dda57-71e9-4925-5e11-08db186dde52
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 02:53:56.3342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wiRbk+AHJ2w4oP9kW14QldJzBve2dqPCCTacV2Av9m28IKWjY/kkcEcd85CugUiQ13Ihcjv0FQMK9MH8YCQRBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBNb25kYXks
IEZlYnJ1YXJ5IDI3LCAyMDIzIDc6NDAgQU0NCj4gT24gU3VuLCBGZWIgMjYsIDIwMjMgYXQgMDg6
NTk6MDFBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+ID4gRnJvbTogSmFzb24gR3VudGhv
cnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgRmVicnVhcnkgMjQsIDIw
MjMgMTA6MzYgQU0NCj4gPiA+DQo+ID4gPiBPbiBGcmksIEZlYiAyNCwgMjAyMyBhdCAwMjoyMToz
M0FNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+IFlpLCB3aGlsZSB5
b3UgYXJlIGluY29ycG9yYXRpbmcgdGhpcyBjaGFuZ2UgcGxlYXNlIGFsc28gdXBkYXRlIHRoZQ0K
PiA+ID4gPiB1YXBpIGhlYWRlci4gUmVuYW1lICdncm91cF9mZHNbXScgdG8gJ2Zkc1tdJyBhbmQg
YWRkIGNvbW1lbnQgdG8NCj4gPiA+ID4gZXhwbGFpbiB0aGF0IGl0IGNvdWxkIGJlIGFuIGFycmF5
IG9mIGdyb3VwIGZkcyBvciBhIHNpbmdsZSBpb21tdWZkLg0KPiA+ID4NCj4gPiA+IFVwb24gcmVm
bGVjdGlvbiB3ZSBjYW4gcHJvYmFibHkgbWFrZSBpdCBldmVuIHNpbXBsZXIgYW5kIGp1c3QgaGF2
ZSBhIDANCj4gPiA+IGxlbmd0aCBmZCBhcnJheSBtZWFuIHRvIHVzZSB0aGUgaW9tbXVmZCB0aGUg
dmZpb19kZXZpY2UgaXMgYWxyZWFkeQ0KPiA+ID4gYXNzb2NpYXRlZCB3aXRoDQo+ID4gPg0KPiA+
ID4gQW5kIHRoZSBjaGVjayBmb3IgY29ycmVjdG5lc3MgY2FuIGJlIHNpbXBsaWZpZWQgdG8gc2lt
cGx5IHNlZSBpZiBlYWNoDQo+ID4gPiB2ZmlvX2RldmljZSBpbiB0aGUgZGV2X3NldCBpcyBhdHRh
Y2hlZCB0byB0aGUgc2FtZSBpb21tdWZkIGN0eA0KPiA+ID4gcG9pbnRlciBpbnN0ZWFkIG9mIHNl
YXJjaGluZyB0aGUgeGFycmF5Lg0KPiA+DQo+ID4gU29ycnksIGl0IGFwcGVhcnMgdG8gbWUgdGhl
IGJlbG93IGNvbmNlcm4gaXMgbm90IHNvbHZlZCBhcyBhYm92ZSBsb2dpYw0KPiA+IHN0aWxsIHJl
cXVpcmVzIHVzZXJzcGFjZSB0byBvcGVuIGFuZCBiaW5kIGRldmljZXMgdG8gdGhlIHNhbWUgaW9t
bXVmZC4NCj4gPg0KPiA+ICINCj4gPiAgID4gU2F5IGEgc2NlbmFyaW8gd2hlcmUgZ3JvdXAgaGFw
cGVucyB0byBvdmVybGFwIHdpdGggZGV2c2V0LiBMZXQncyBzYXkNCj4gPiAgID4gdHdvIGRldmlj
ZXMgaW4gdGhlIGdyb3VwL2RldnNldC4NCj4gPiAgID4NCj4gPiAgID4gQW4gZXhpc3RpbmcgZGVw
bG95bWVudCBhc3NpZ25zIG9ubHkgZGV2MSB0byBRZW11LiBJbiB0aGlzIGNhc2UgZGV2MQ0KPiA+
ICAgPiBpcyByZXNldHRhYmxlIHZpYSBncm91cCBmZCBnaXZlbiBkZXYyIGNhbm5vdCBiZSBvcGVu
ZWQgYnkgYW5vdGhlcg0KPiA+ICAgPiB1c2VyLg0KPiA+ICINCj4gDQo+IFlvdSBzb2x2ZSB0aGlz
IGJ5IGNoZWNraW5nIGZvciBhIDAgb3BlbiBjb3VudCBhcyBhbHJlYWR5IGRpc2N1c3NlZC4NCg0K
T2suIHRoaXMgc2NlbmFyaW8gaXMgc29sdmVkLiBzbyBpZiBvcGVuX2NvdW50IGlzIG5vbi16ZXJv
LCBpdCBzaG91bGQgYmUNCmVpdGhlciBib3VuZCB3aXRoIGlvbW11ZmQgb3Igc2hvdWxkIGJlIHdp
dGhpbiBncm91cHMgYXMgeW91ciBiZWxvdw0Kc3VnZ2VzdGlvbi4gDQoNCgkJaWYgKGN1cl92bWEt
PnZkZXYub3Blbl9jb3VudCAmJg0KCQkgICAgIXZmaW9fZGV2X2luX2dyb3VwcyhjdXJfdm1hLCBn
cm91cHMpICYmDQoJCSAgICAhaW9tbXVmZF9jdHhfaGFzX2RldmljZShpb21tdWZkX2N0eCwgJmN1
cl92bWEtPnBkZXYtPmRldikpIHsNCgkJCXJldCA9IC1FSU5WQUw7DQoJCQlnb3RvIGVycl91bmRv
Ow0KCQl9DQoNCkJ0dy4gSW4gY2RldiBwYXRoLCBvcGVuX2NvdW50KysgYW5kIGlvbW11ZmQgYm91
bmQgYXJlIGRvbmUgaW4gYQ0Kc2luZ2xlIGRldl9zZXQtPmxvY2sgbG9jayBhbmQgdW5sb2NrIHBh
aXIsIHNvIGlmIGN1cl92bWEtPnZkZXYgaGFzDQppb21tdWZkX2N0eCwgdGhlbiBpdHMgb3Blbl9j
b3VudCBpcyBub24temVyby4gSSBoYXZlIGFub3RoZXIgc2NlbmFyaW8NCnRoYXQgZGV2MSBhbmQg
ZGV2MiBhcmUgZnJvbSBkaWZmZXJlbnQgZ3JvdXBzIGJ1dCBoYXBwZW4gdG8gYmUgaW4NCnRoZSBz
YW1lIGRldl9zZXQsIGFuZCB1c2Vyc3BhY2Ugb25seSBvcGVucyBkZXYxLCB0aGlzIGxvZ2ljIHdp
bGwgYWxsb3cNCnVzZXJzcGFjZSB0byByZXNldCBkZXYxLCBidXQgZGV2MiBtYXkgYmUgb3BlbmVk
IGJ5IGFub3RoZXIgdXNlcnNwYWNlLg0KVGhpcyBzZWVtcyB0byBiZSBhIHByb2JsZW0gaW4gbXkg
cHJpb3IgdGhpbmtpbmcuIEhvd2V2ZXIsIGRldl9zZXQtPmxvY2sNCklzIGhlbGQgaW4gdGhlIHJl
c2V0IHBhdGgsIHNvIG90aGVyIHVzZXJzcGFjZSBjYW5ub3Qgb3BlbiBhbmQgYmluZA0KY3VyX3Zt
YS0+dmRldiB0byBpb21tdWZkIGR1cmluZyByZXNldC4g8J+Yig0KDQpSZWdhcmRzLA0KWWkgTGl1
DQo=
