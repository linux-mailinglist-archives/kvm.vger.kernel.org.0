Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C096BA79E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjCOGQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCOGQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:16:52 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E635BCA1;
        Tue, 14 Mar 2023 23:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678861011; x=1710397011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fWhnTbagHQ87qHqSXG8CyS3SzIlQ/C3zUGfbrw0tfVk=;
  b=L91Q1XNOLzlWC2QpcXi/ngD7d9XBwiogu1kelWi11vbsPs8OGwUoE/bu
   6qedDlsAIPEfTxlOX7RmBiJR2B4PAeam22TDBpksKJgUfINgGXdWXs16a
   SdKSMEcNPEKnHT6BDa7H9gsIvsSb6uVnn6npGJyVeygkc0A0/DTHiGmoT
   0wgC8J+ueCWzmJqyf7oUFiF9D5yV4v1eAtw4zDhXsfRV+UTFak1n+yiun
   0NfkaMGr83QYMUHLLfzuhGz3+sCA8gNOb/D9RconBLDsIKkWorDRcvAPr
   3k5Tp6CSti2jNpbIUM0DQoBl1H0oqkJTb7RvR7CxwI/M+02kw6HKeWzzK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="336310903"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="336310903"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:16:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008706618"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1008706618"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 23:16:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:16:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:16:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 23:16:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 23:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwNTNDIQ5/kFSdM2q2/WLfXX5ioMsoBIDoXlR2ZCinRKCJujXv3TFGlILijYRfE4CTxJB9Baad29LiXOsvdYPY0jPg35legfrORAmgDimUqWyjDCu1dpiSK1ptmsMBaOdJ83wJrJI9hPXj/r7nChjhHuwT/9r+Xl7x2ALwO2Ztd1j3dLjr3ZzEjvR0Cmm7v5CDYEihQqjaTRxcUmpe83bN1kWrtxZ2UFTRqKuKw2lT59M+o2nMF8u2TUU1x7ickA6RsqrIQZdy/gt4K4kJFw+K4VQPCs8gmeot8QyM2FIATYJT1bD53Rr7iajnTfUmU6Cq1UedtENwSqSPaxsApZ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWhnTbagHQ87qHqSXG8CyS3SzIlQ/C3zUGfbrw0tfVk=;
 b=kyZGboN7Dn87zUNmJhWbwlfj1zRM/5qJ9vGr7OrixdmkTrtrdU0bFxb850nHT8rRRGiZ49B0zWbx8PqUgFB/kaBcuaNh0HcLgbgwPFq4NRBO/+SBgGIGOoNLXJdQqWeDqB+fLfIGhGL1r1La3MgNZVVu8jMsSTFycfLRBT3mUDmR0aTwef2wm4/i0LQbXhz0lCBPuOUIsHDkfNQ8FufWclrHnZa+h4sZAeQNcUg9pSWXjAnQL26bntTa4tRgs3gGrJDkQWzC+hXHjFn+PxxtytuJBA9TzN8i4kx/96PNM3u9LGc0HJpz7a+IXYf1XaPWBeib1eq6v9v6+vUaiBzJ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO6PR11MB5651.namprd11.prod.outlook.com (2603:10b6:5:356::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 06:16:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 06:16:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq7zRkyAgAdh/YCAAL9UkA==
Date:   Wed, 15 Mar 2023 06:16:37 +0000
Message-ID: <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
In-Reply-To: <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO6PR11MB5651:EE_
x-ms-office365-filtering-correlation-id: 3ac1777a-ad11-4704-e5e6-08db251cd5af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fzjCm2Tn9jXErdinHzsKyklxJV76IIsFExOzXDFbKcDS6C6xmqMXEXqHVdJhsENXAUyGtvrz2d2bli12ZhuUk0MJKiHKsV3b9+Q6YpzlrFoLdqwUsCkwrmNZA4Zk3KDlG//c3Hewl0LIREB/0zHyqnEo/nxvOtQKm4q0sDRzIztGgR3mqElaGqqZh/wJwNXJpURb+e82hB1RxQgJKzso0hf8kQJLQEzREEpZb7SDLfFUSndq5WrlyGWU20m3UI0HerxgrtAaI5tS2bB+yftgvYmTOALKSiBTUU5fPF1kZMKKQpblThy/w5m1zEw8TvBLFQnPn6+KUIOo76kb2UHrzRRGBR7AB0I8SDM2LUYgQKDdK8Tuejx4lF3kMoFQweTj7kxMqEUo0zQIt0Ekecf340vb687MUkMA/pQa7ObOppx8cfqo9slbk04XXHCeL93aDZYIAioao2yuL/AWq8bPYXtOh6PRCtCLa/LETCDTQMI1+5DDzusZreLhbMXruBvuvbcoDlFtMlU/QKQlXSeW0Kb+n74+YQkd6DU9i7Q6Y171iO7ttpFGXKSz7sRe6GvFV+490rC+xFpuTl0HjBtrNG1TkAcKuTJn6n7J9m6IryQt3rgWjKPMZxhxP4pzQ14e5Zl8uwYHXPmKYBtN2nlnp4UtWiHLa8nLKHf/Mrq3yQKcsRqk1G/aIYHsJgKPUeH9bStUhZrXW0kf03uMf2foAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199018)(82960400001)(122000001)(2906002)(83380400001)(7416002)(5660300002)(54906003)(33656002)(55016003)(52536014)(8676002)(64756008)(66476007)(66556008)(66946007)(6916009)(41300700001)(4326008)(8936002)(38070700005)(76116006)(38100700002)(86362001)(316002)(66446008)(478600001)(7696005)(186003)(9686003)(26005)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVRDN1l5dTFXOEhDeFRZN0RHVlpjUUpUZWJJYklrcUpadXhZeWswazQyNElu?=
 =?utf-8?B?dWlobVRUbDZqbjZDT0EvbmxNQmFQSG9VWGZkNlJQakdmRDFrMDRPNVRpTkZU?=
 =?utf-8?B?K3NuUzNNRklrUFk5cG1MVzlRemR2SVBsWDNFdlRhYTBTQjVVUnJWTnc5M0lD?=
 =?utf-8?B?NzF5bmZCKzZrUitqSHNRNFVId0l4aTdOemFnd0FBKzhkNldJbHRsdUMrajcr?=
 =?utf-8?B?eUprMk1qUm9nQ2F1RllXa0hLMTZsL1hIUXh4bVBrM2k3SXFhY1hYZkN1eStt?=
 =?utf-8?B?YXdFTnI1ZGNYYSt4L0h2NGNLdEttZUNHem95djVHOWxpblB0ODBONTg5a05J?=
 =?utf-8?B?ZmE0WDNndWZxM2lqRm83VXgwNHhvWEZsSVdZZ2Q3cUJWRHdGVFFvblc0amY4?=
 =?utf-8?B?UGR2RXlFUDdQamRGRlQ5L2RPRGlJM3FxczBoTTA5MkQ0djEvSFRHcFJqOEN1?=
 =?utf-8?B?bktXc1QxOGE0Z3Fpcm1ib0xoQXd0OUVuU05MbnlrQ3hiVW50aFUyd1pRREE3?=
 =?utf-8?B?Vy9aQnhpLy95MUpqNitsT1lUWWxxOFFBaUVNbEZGb084Rml2dUR0bjBtSW5K?=
 =?utf-8?B?bElFLzN4TjJGYW81YS9WeVF4TTc2cmRFV3pBMWQ2MDJHSVB5UDEvM296NXBT?=
 =?utf-8?B?R3hnbUFRK1FkU2RNeDE5VFZLQzhNOTFqRDFsZUFtME5IR0k2TlNDMmQxMTVD?=
 =?utf-8?B?VkFuK2hqZEhVZURwS3hrdDhFb1hxdGNMSUs3TnBhakt3SjRUcDRQaVlkR2RP?=
 =?utf-8?B?cnJPVGxJeGZWaW5CbGRyUnkyK09KNTR4a09PekpOMzJnUytQTWlvUU5FQVFm?=
 =?utf-8?B?UGgrSkNGck9udDlDaEtWdjFRZGFQeDRkUnVTdlJNTnlFeTVrbWxrS2J6d1pm?=
 =?utf-8?B?MDIwTmhzYy9WR0wyVVljUzhCNDg4SFRZWTRWeW5VYndSa3EvYjFkUEJsQnh6?=
 =?utf-8?B?OEhjQnNGaGlyQUpINmV0bHdURWQ4TEdLTzNUQkx1OXpCaG4yeXIvcVlUMXNx?=
 =?utf-8?B?cS8zTTY2c3RRc3lWRU42UGJqVlhkMVpCemEycXpSV2hzMVRTcmlwTnVWQmZG?=
 =?utf-8?B?UHBEVGRUZDNXeldwcUpGNzQ4Z0VyY2N2R0hIODZQZ010RG8zRDlMa3MwenZ2?=
 =?utf-8?B?MGsxekh6bGl1YldzN0loVnl4RWx1S0Nuc1NZc2ZWK3ptQVJyZGNwQkcyVlhx?=
 =?utf-8?B?WnVRNHdMYmJZbERQUk9wUDhUNFdaTlc3NmEyaTZ3WlZDSTBBUmswS1lVM0tp?=
 =?utf-8?B?MjdLYm51OGowNUpQYlZFbWxUWXhCaHVMLzFtNTdOK2l1WXgxeloyVWVXdkVz?=
 =?utf-8?B?WlRCSVhCazBIeTRycjJNNzlhNUhIUkJrVnBRaEVVVG5haGxiZnB6b3dnZXZO?=
 =?utf-8?B?TlVDVURHSEVyK1NRWWtrVFluNWxCeGUxT0pFNUlHdmJhQlRTQWYwcHdwUFJZ?=
 =?utf-8?B?bnZUU2Q4ZXB3Mk5BeS90NERMMng3VjAyTmNaV1N4dGo1cER4SUgwR09TdkYz?=
 =?utf-8?B?UnM5SWRyalBObjdCTWZyRFVhUWgzSTg4Uy94WG5LQW5UNUxOZjV6N3M3ckhq?=
 =?utf-8?B?UUpabmVqdkptUFlrZjZUYmF5YlhSUVNtT2xFNURLTWJVc1ROWVNnMnFxN1RI?=
 =?utf-8?B?ZVppSEtKeGxKUWIzbEFLK250M2VJd25XZm9SbHFuT0U2Zm16RW56RGFNM2Z2?=
 =?utf-8?B?YUNlOUUrcHpuQlZXSVhqOHZIOWdQa1V6QlZadE5MSEVza1I2em1Oc1BVY1Zk?=
 =?utf-8?B?NW9QWXJKR1RudGtmL1FWYWdMVVdLS1krTEd0dWI1OEp5dWluQXNyd01iYTFE?=
 =?utf-8?B?RWlqNWxRc1haTU1jNmUxRFh6RW1Ib245OC92WW50ZUZOOGNrRVRwc05maFdI?=
 =?utf-8?B?NzkwYmltWEJXS2llU05EM2pXZ3NEUTVsWFJ5MytiYTNtSkxwZjNCd2lRejRu?=
 =?utf-8?B?czJ6bjFYVDhybkdnR2I4ZEFqNWMwSkRXOVEwQXNHYWR4OVdBN2Q0SldYczlC?=
 =?utf-8?B?anR6dlBYOUtPMmFHcW9JcTJyZmFLVUF1MmxVU0RtZEdXeVFRUU9VRGE5MUE5?=
 =?utf-8?B?Z3FmMGl0eFhJb1JPUjVCRFp6ODZzazRtVVllUXQxeUY3UEFsZjgvdktjTlYv?=
 =?utf-8?Q?OmqeItngaJAM7edQgiZHoBv+P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac1777a-ad11-4704-e5e6-08db251cd5af
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 06:16:37.7131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZUAq5eouuYwqw0cqHQ3ncv3rHNVhh0/wtjU5d7qDx0FgRLWPIFs33BUOsIlxnzrUsMzfsa46kGpXbF1elgn2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5651
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

PiBGcm9tOiBOaWNvbGluIENoZW4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAxNSwgMjAyMyAy
OjUxIEFNDQo+IA0KPiBPbiBGcmksIE1hciAxMCwgMjAyMyBhdCAwMjowODoxNUFNICswMDAwLCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3Blbmlu
ZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiA+DQo+ID4NCj4gPiA+IEZyb206IExpdSwgWWkgTCA8
eWkubC5saXVAaW50ZWwuY29tPg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCA4LCAyMDIz
IDk6MTQgUE0NCj4gPiA+DQo+ID4gPiBAQCAtNDQ5LDMzICs0NTAsMTggQEAgaW9tbXVmZF9hY2Nl
c3NfY3JlYXRlKHN0cnVjdCBpb21tdWZkX2N0eA0KPiAqaWN0eCwNCj4gPiA+IHUzMiBpb2FzX2lk
LA0KPiA+ID4gICAgICAgYWNjZXNzLT5kYXRhID0gZGF0YTsNCj4gPiA+ICAgICAgIGFjY2Vzcy0+
b3BzID0gb3BzOw0KPiA+ID4NCj4gPiA+IC0gICAgIG9iaiA9IGlvbW11ZmRfZ2V0X29iamVjdChp
Y3R4LCBpb2FzX2lkLCBJT01NVUZEX09CSl9JT0FTKTsNCj4gPiA+IC0gICAgIGlmIChJU19FUlIo
b2JqKSkgew0KPiA+ID4gLSAgICAgICAgICAgICByYyA9IFBUUl9FUlIob2JqKTsNCj4gPiA+IC0g
ICAgICAgICAgICAgZ290byBvdXRfYWJvcnQ7DQo+ID4gPiAtICAgICB9DQo+ID4gPiAtICAgICBh
Y2Nlc3MtPmlvYXMgPSBjb250YWluZXJfb2Yob2JqLCBzdHJ1Y3QgaW9tbXVmZF9pb2FzLCBvYmop
Ow0KPiA+ID4gLSAgICAgaW9tbXVmZF9yZWZfdG9fdXNlcnMob2JqKTsNCj4gPiA+IC0NCj4gPiA+
ICAgICAgIGlmIChvcHMtPm5lZWRzX3Bpbl9wYWdlcykNCj4gPiA+ICAgICAgICAgICAgICAgYWNj
ZXNzLT5pb3ZhX2FsaWdubWVudCA9IFBBR0VfU0laRTsNCj4gPiA+ICAgICAgIGVsc2UNCj4gPiA+
ICAgICAgICAgICAgICAgYWNjZXNzLT5pb3ZhX2FsaWdubWVudCA9IDE7DQo+ID4gPiAtICAgICBy
YyA9IGlvcHRfYWRkX2FjY2VzcygmYWNjZXNzLT5pb2FzLT5pb3B0LCBhY2Nlc3MpOw0KPiA+ID4g
LSAgICAgaWYgKHJjKQ0KPiA+ID4gLSAgICAgICAgICAgICBnb3RvIG91dF9wdXRfaW9hczsNCj4g
PiA+DQo+ID4gPiAgICAgICAvKiBUaGUgY2FsbGluZyBkcml2ZXIgaXMgYSB1c2VyIHVudGlsIGlv
bW11ZmRfYWNjZXNzX2Rlc3Ryb3koKSAqLw0KPiA+ID4gICAgICAgcmVmY291bnRfaW5jKCZhY2Nl
c3MtPm9iai51c2Vycyk7DQo+ID4gPiArICAgICBtdXRleF9pbml0KCZhY2Nlc3MtPmlvYXNfbG9j
ayk7DQo+ID4gPiAgICAgICBhY2Nlc3MtPmljdHggPSBpY3R4Ow0KPiA+ID4gICAgICAgaW9tbXVm
ZF9jdHhfZ2V0KGljdHgpOw0KPiA+DQo+ID4gdGhpcyByZWZjbnQgZ2V0IHNob3VsZCBiZSBtb3Zl
ZCB0byB0aGUgc3RhcnQgZ2l2ZW4gbmV4dCBwYXRjaA0KPiA+IHJlbW92ZXMgdGhlIHJlZmVyZW5j
ZSBpbiB0aGUgY2FsbGVyIHNpZGUuDQo+IA0KPiBJIGRvbid0IGZlZWwgcXVpdGUgY29udmluY2lu
ZyB0byBqdXN0aWZ5IGZvciBtb3ZpbmcgaXQgaW4gdGhpcw0KPiBwYXRjaC4gUGVyaGFwcyB3ZSBz
aG91bGQgZG8gdGhhdCBpbiB0aGUgZm9sbG93aW5nIHBhdGNoLCB3aGVyZQ0KPiBpdCBuZWVkcyB0
aGlzPyBPciBhbm90aGVyIGluZGl2aWR1YWwgcGF0Y2ggbW92aW5nIHRoaXMgYWxvbmU/DQo+IA0K
DQpOZXh0IHBhdGNoLiBJIGp1c3QgdHJpZWQgdG8gcG9pbnQgb3V0IHRoZSByZXF1aXJlZCBjaGFu
Z2UgY2F1c2VkDQpieSBuZXh0IHBhdGNoLiDwn5iKDQo=
