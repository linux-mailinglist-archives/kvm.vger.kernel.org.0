Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593D9584A13
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 05:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiG2DKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 23:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiG2DKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 23:10:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7043CDB;
        Thu, 28 Jul 2022 20:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659064209; x=1690600209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=earo8vTYpf1hjMNTltpqyif4puZ80SN6r6mrVNxRa1c=;
  b=H7i3fEbVYG98inhnE0bOlOcf7aquFr/AJCYAWsqTSRrtGAut/ndg3NJ7
   Apn2faXK6bO0JrVarSp5nT/R4SXghfmYQ4egZ6L/3ctJZMvGlVVTFr34C
   CL2J+d7hgPoEgP8eSiWKDkscA7XWKFzvUp9iANG2knsL0GXIFQqMZrFF6
   kv+p0vFA1DmI9B2G8M4wHBTBf1IDVXTxoRWk3/FqPqmTHD5gn32QjAsXC
   Bke3DgnhpBINQ9/MQuyjIDZ4rZIzxugVkj86Bn0mR8WLtmSidzd9vctVd
   dXjc4lxS7K1r9co8qOqc8ZB1xRPIGUVAQxIs4ROsQej/hOqY0LwIcY1Lr
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="268442428"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="268442428"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 20:10:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="690592966"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2022 20:10:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 20:10:08 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 20:10:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 28 Jul 2022 20:10:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 28 Jul 2022 20:10:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkRBcDolaRlsaVvEEGrX8D3PBCtQCFPcgVDizleSzs6XELdxTAAGWCBVJl9oABCwkzSe0w1fOQGehJ47SP3FGvTOZ96CoYzB3ZT2XwOB7xjiHncYvwTwcVwZxocvMKy3nWqjdeBaGD7jtNKMTBgE5WXiRS86F2i/Y1dTm8mdkJzrOje7S1ZrFea5uB0p8FAclZZj8D/BPEknKaW0Ix3wVoMa3VIJIb8s56jQYR/mBduK1NS6rvRjzTCDaQyhmilf0pXV98CbjYCwW/oy4VAFsLbmkOx6+0HPZOKRrtGkxzV1A8aGmwS2QJEyv9F8dY3ohUPA54cDj/CkCbcSr05+Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=earo8vTYpf1hjMNTltpqyif4puZ80SN6r6mrVNxRa1c=;
 b=QakGGCydBLDaUo7ZrvpFXr4E0GYkTfikJSo87ZtY2XEYsxbGeYfmtdU+evviS0YtHQYEV8s0cNZNnqylN3vZYw4y5Ukiw3k+Ey5bILcC6SU35DK/ZiSTu00zH6Oa7AQZkWgXqPDOthTclekbhKHZtCNsWIXsCi4PUp2pU49PrgDMxvqXAotiUthZjVnu+ZUvECKKYFJrXpsuitZcXrcd22IJfVNOCz5fec/bm7lTVQTQZY3cmvs3Wt3krIv99tK5zjHB1xADz/qLpQRMvW8EBf5LjO3h4uBQ4zsGPI7e0q9VgfA+++/zIroi2S0XzLtXnLRNlQUlXpzW7oP6mtDPPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB3288.namprd11.prod.outlook.com (2603:10b6:a03:7e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 03:10:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 03:10:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Oliver O'Halloran <oohall@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Rodel, Jorg" <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: RE: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Thread-Topic: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Thread-Index: AQHYkgm2SLPFbZ1K7Emw8giwhTYMU61zAy8AgADn6ICAABqBgIAAC2DQgCCu2wCAAAjKAIAAAsCQ
Date:   Fri, 29 Jul 2022 03:10:03 +0000
Message-ID: <BN9PR11MB527626B389A0F7A4AB19B6728C999@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <BN9PR11MB527690152FE449D26576D2FE8C829@BN9PR11MB5276.namprd11.prod.outlook.com>
 <300aa0fe-31c5-4ed2-d0a2-597c2c305f91@ozlabs.ru>
 <CAOSf1CHxkSxGXopT=9i3N9xUmj0=13J1V_M=or23ZamucXyu7w@mail.gmail.com>
In-Reply-To: <CAOSf1CHxkSxGXopT=9i3N9xUmj0=13J1V_M=or23ZamucXyu7w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e746d9c0-0c99-42f6-9259-08da710fd512
x-ms-traffictypediagnostic: BYAPR11MB3288:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2L9pnZYCPB97cRz+NXROiwmXcnkyJdKNZgGEj76dXe+dBfUgPX7qASt33ACn947tWXIHJ0rEVZe7yzOAE4k43G7Owh2D6CoIlEJS3oyT/aFBm3eocTlQ05PtKBDU1rwF6gdyQTB2/pXapOkE6jAaeYxaHV1xK5xwaxdd/GA2mYw1ySqzHlgFI3D81R4v8lAn2lMwrAgeIZ+kalL4+xTCAmTO65VoejNdl2WsO/NBofk1OiYPjdECgd9WQrY5miisXUw03u9EZomamuXBV0hkSr2oiSyPQJzbrj/g+u9ijOHkAWFcOx4+3L6DhscWIPDC3qoBcmUxb5d7MtApxg7EJbnH8neD2GPj9it4Ne7vN2YvifBN+uEJ8ALCTCtaaKmO9JCKPHVBHorlfUgkPwXPYL+LGcj646jKG872R69tFMFdrNtFkRWqXii32ZHWTwX5SHRaGfE+9EQ4cAAfhAJgr9RQlviV4lAVNfqxZgznzcK9exNADrH8f3wPUgilr0nAyXnBgMKzMlqp6DdjRud38CWCjN3h8cpgOIqsZVT65v5koOp1Crj71ZmjthrEFthKNoxwuJTweyD/jJ0XpC2WPYsiA9m+lZPs8zLEBNJKMRZriiIk1/RbaNEvaRzJt+eYT7XOKQVnuczFdwJaewK5wjFQJBybFuQWa/ex8hISNg6k3n+uHYsk2w35fcEA+evJxQGsmCGTD/TH2z/X5n68Y4v2Jh5+GfcVqfljTyneuGnRD8r41vme2QQgzA/ThVPQJhvCAFKDDfXEBK/t7KlcTeSZzaWR6ANTZuJiKE4YMOGc/9zGH3P3TPGwW+krPKJ2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(136003)(39860400002)(376002)(71200400001)(8676002)(41300700001)(2906002)(55016003)(86362001)(33656002)(66946007)(316002)(478600001)(76116006)(110136005)(54906003)(966005)(64756008)(66446008)(66476007)(66556008)(186003)(38100700002)(38070700005)(7696005)(53546011)(9686003)(26005)(6506007)(83380400001)(52536014)(5660300002)(4326008)(7416002)(82960400001)(122000001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVhJL1l5RVJlRUNaN0t0S2FuVkl5L3lUbWxQdFdlelFyQUd3TXc4VXhSL0JC?=
 =?utf-8?B?dlZUMkhOakFNK3JQZFJzNER0WTE3MzFKSFBraW4renE3QUxQQ1R1ek5NbGN0?=
 =?utf-8?B?VGVGdFdGOVU4bkJKK2I2WDlXSDRvZThwbzdzVHlGdE5SSmMyYWdrMGhJZ0dC?=
 =?utf-8?B?d3BjL3RWL2JKWnpBS1FIV2dsZExaRzI5N0tJck5Da3lUN1RZbmMrMjZZdkcx?=
 =?utf-8?B?dHRPNzUwS1VFY2VpVkIxOWRsY2JqTVdlSEs4QUlrL1JuR1dxQW8yeFpBNkFN?=
 =?utf-8?B?eE5xUStCQTc5VlVGUXZFMjhIbURndlNEU3pxWkM3UnJYbDBDVUFLaTdHcUpG?=
 =?utf-8?B?ZjhhTGZjSGRyYk92a0VEaExQc2xaSlJ0TmVhRzNQaGtSTWQ3NTJENDFKYXNG?=
 =?utf-8?B?citWd0huTy94TzBiYUVQQUljcmZEOUlvc29oT2FmWkFNUGpMbzBHWmJKOTVt?=
 =?utf-8?B?R3FtS0EySEYxUmhaVWtrM3hER1RhUzRWK3pkV0l3TEJRcHcxcXQ5bXJRM1dE?=
 =?utf-8?B?dHZFQ2lKajc4anpUQllpOHdrUGg2S3pCbU9UZWhWQStDN1d6M0p4RGtvZ1pt?=
 =?utf-8?B?NS9lK0k2L1hVdVdHNDlMMXo1UVI1TzRGNUNvdk5penYzak1TWEx4bStqZ3gz?=
 =?utf-8?B?KzBua1BOdWg0L3RZK21WcXEzVDA5a0h3bEQ0VjFPaFdvMlg0VFZHaVZjWURm?=
 =?utf-8?B?bTNWaUM3K3duVG5uNWxGMVdhdEhvVXNKYUJZRzZFQXFVSkhyVWNTa1ZKWlFB?=
 =?utf-8?B?Y2NEamYwSVVyTCs5RWplcFRFcVJKOHd1SDlXaTkwSEJPdXVrSkVaS2VDOVNs?=
 =?utf-8?B?OVhxdk9rY2JqMG93b3lFdWFtamlZZDlSWitBY3NUeDVpN1VrMjNFdFJicjdI?=
 =?utf-8?B?VThGc3ErNlIzUGMxTGdId21BUDFVRXpXSHd3T1BrR0E2NFNiUk5GTmxQdUF2?=
 =?utf-8?B?d0tUaXhPSFA5Z3ZsMlB2MzdZZnBZWW1TMXVPbytwVmlMSUZaai9Ib2xKK1Bo?=
 =?utf-8?B?REdQK1ppQkEzSUs4dTBxc1RvSUlFcUZLWEhXWGZnSWhVdFZLZElDVHlsb0Iv?=
 =?utf-8?B?djRHVWNSZUFrZHlKSWQybWJ1cm9IYlYyYkpVK2kvUGN5SldaTzIyZmo5NWRF?=
 =?utf-8?B?eGY2OHp4YW43dnUwc1lxRThxZHVjMUUxazhtQzA5Z3F2M09WZ3V3S3ptckxH?=
 =?utf-8?B?VHJtU2dpRnhFMkl2SXZrWUR2amVkRzN3Y1hqclVBY1k4d3hsMUJUTXYyRHo2?=
 =?utf-8?B?QVZMWi9wdW5ZTis4NEV0b3dtNWlpRjBBZjliS0M0amZ4NEZnK2twc01LMzJY?=
 =?utf-8?B?UUFhZG1EYlFWR2lpazE3RWZQNThHVUJ2aFF5MWNGektWUnRNVThkdW16SkJI?=
 =?utf-8?B?ZDVUUmFPVVVuYXhFRC9wQTRHbHR4dmdzVU9LUkpZZlhUWUZjaWFZN2FyK2tw?=
 =?utf-8?B?RTlpSlRYTHpwVjhVSG5RRzJEZC9HNFRNTVJJaTM5RDZ4SWpvR1NGNldnS09p?=
 =?utf-8?B?cVJHdWMrRFhXSVNIVFo1cWptUlBXRFA2cWQwWmFNS08xOVkrVTdibk9hM0cv?=
 =?utf-8?B?Ny8wd0hyUFVDTHJ0b3hjZE9UOWVUQWZzNmJLMldHVlRtQzdKbm5NSjJPVEpX?=
 =?utf-8?B?UGZjSXRCYWQvMS9Jek9hOXRhYjRvQXAzRDBRMFAySm1MWWFlU1FacHdGMXcz?=
 =?utf-8?B?NCt3YjMrTm9MbnJXa2ozOEFUcmMzSEhPdm9Gemp0MlhQRXdhQmdXR3V0RFdq?=
 =?utf-8?B?Y3JMQWpQcGRsYUtFaXhsL2JFTWVkWkI2R2RkbDRBTTVITzVkcUV3VkVmdGdh?=
 =?utf-8?B?UEZ2d0k5aGJGNWlxOFVzTDNaSklGQy9MNlY2V1A1Z3R2ZDQzSTRzK1VaeEVU?=
 =?utf-8?B?ZElxcThHa0hIRGJCcjNoeGcrZlJ5ckxjWVlhL3NyaXZsa2VsaG91dE8yMkU4?=
 =?utf-8?B?RGlPYnFWWmQwYVhIS0ducmhNRkhnM2wwWFdQQXFsWnU3RDlwb3M3YWtTekVR?=
 =?utf-8?B?L1JxdDEvNHpPVlQrQ1J6REZqeVVOT2p5cnRhZ1ArYnVqR2NXZlRwQnBRajFS?=
 =?utf-8?B?RlhUMTJLdGUwQWpvTGgvenp5V0pEQk5hNUZveGMzSjNETllXTlhGOGttZXhw?=
 =?utf-8?Q?couO3I8vicVWGe24yiVkOG2Q6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e746d9c0-0c99-42f6-9259-08da710fd512
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 03:10:03.9091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tQ3j4tEvGr9UQO89JWNj2bbs0IwYBjNlQg3Px4ARmb+F0xkhjPUnHY/q6RV9RR06/Yh1+g3GGYTPdFh6y7oQNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3288
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBPbGl2ZXIgTydIYWxsb3JhbiA8b29oYWxsQGdtYWlsLmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBKdWx5IDI5LCAyMDIyIDEwOjUzIEFNDQo+IA0KPiBPbiBGcmksIEp1bCAyOSwgMjAyMiBh
dCAxMjoyMSBQTSBBbGV4ZXkgS2FyZGFzaGV2c2tpeSA8YWlrQG96bGFicy5ydT4gd3JvdGU6DQo+
ID4NCj4gPiAqc25pcCoNCj4gPg0KPiA+IEFib3V0IHRoaXMuIElmIGEgcGxhdGZvcm0gaGFzIGEg
Y29uY2VwdCBvZiBleHBsaWNpdCBETUEgd2luZG93cyAoMiBvcg0KPiA+IG1vcmUpLCBpcyBpdCBv
bmUgZG9tYWluIHdpdGggMiB3aW5kb3dzIG9yIDIgZG9tYWlucyB3aXRoIG9uZSB3aW5kb3cNCj4g
ZWFjaD8NCj4gPg0KPiA+IElmIGl0IGlzIDIgd2luZG93cywgaW9tbXVfZG9tYWluX29wcyBtaXNz
ZXMgd2luZG93cyBtYW5pcHVsYXRpb24NCj4gPiBjYWxsYmFja3MgKEkgdmFndWVseSByZW1lbWJl
ciBpdCBiZWluZyB0aGVyZSBmb3IgZW1iZWRkZWQgUFBDNjQgYnV0DQo+ID4gY2Fubm90IGZpbmQg
aXQgcXVpY2tseSkuDQo+ID4NCj4gPiBJZiBpdCBpcyAxIHdpbmRvdyBwZXIgYSBkb21haW4sIHRo
ZW4gY2FuIGEgZGV2aWNlIGJlIGF0dGFjaGVkIHRvIDINCj4gPiBkb21haW5zIGF0IGxlYXN0IGlu
IHRoZW9yeSAoSSBzdXNwZWN0IG5vdCk/DQo+ID4NCj4gPiBPbiBzZXJ2ZXIgUE9XRVIgQ1BVcywg
ZWFjaCBETUEgd2luZG93IGlzIGJhY2tlZCBieSBhbiBpbmRlcGVuZGVudA0KPiBJT01NVQ0KPiA+
IHBhZ2UgdGFibGUuIChyZW1pbmRlcikgQSB3aW5kb3cgaXMgYSBidXMgYWRkcmVzcyByYW5nZSB3
aGVyZSBkZXZpY2VzIGFyZQ0KPiA+IGFsbG93ZWQgdG8gRE1BIHRvL2Zyb20gOykNCj4gDQo+IEkn
dmUgYWx3YXlzIHRob3VnaHQgb2Ygd2luZG93cyBhcyBiZWluZyBlbnRyaWVzIHRvIGEgdG9wLWxl
dmVsICJpb21tdQ0KPiBwYWdlIHRhYmxlIiBmb3IgdGhlIGRldmljZSAvIGRvbWFpbi4gVGhlIGZh
Y3QgZWFjaCB3aW5kb3cgaXMgYmFja2VkIGJ5DQo+IGEgc2VwYXJhdGUgSU9NTVUgcGFnZSB0YWJs
ZSBzaG91bGRuJ3QgcmVhbGx5IGJlIHJlbGV2YW50IG91dHNpZGUgdGhlDQo+IGFyY2gvcGxhdGZv
cm0uDQoNClllcy4gVGhpcyBpcyB3aGF0IHdhcyBhZ3JlZWQgd2hlbiBkaXNjdXNzaW5nIGhvdyB0
byBpbnRlZ3JhdGUgaW9tbXVmZA0Kd2l0aCBQT1dFUiBbMV0uDQoNCk9uZSBkb21haW4gcmVwcmVz
ZW50cyBvbmUgYWRkcmVzcyBzcGFjZS4NCg0KV2luZG93cyBhcmUganVzdCBjb25zdHJhaW50cyBv
biB0aGUgYWRkcmVzcyBzcGFjZSBmb3Igd2hhdCByYW5nZXMgY2FuDQpiZSBtYXBwZWQuDQoNCmhh
dmluZyB0d28gcGFnZSB0YWJsZXMgdW5kZXJseWluZyBpcyBqdXN0IGtpbmQgb2YgUE9XRVIgc3Bl
Y2lmaWMgZm9ybWF0Lg0KDQpUaGFua3MNCktldmluDQoNClsxXSBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvWW5zK1RDU2E2aFdiVTd3WkB5ZWtrby8NCg==
