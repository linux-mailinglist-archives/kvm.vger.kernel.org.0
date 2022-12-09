Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8D1647C69
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 03:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiLICvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 21:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLICvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 21:51:01 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBF086F6B;
        Thu,  8 Dec 2022 18:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670554260; x=1702090260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gejzUkYvocmg2APb24uluVIU4qc0214qD7EcfuT/bxw=;
  b=jFpRXzClqPBu/16VstbLQWQaAWPEnDJ08cEHCq/lWAtZWV1uOLjYPmXQ
   yDqVzfnRW2LZCP2PAmf28ZU8NKkF8cKMEhnl5GoHFtk9b0kp9d/bx802c
   l5uFOgOrPUE6XvsTQrripG4ZVL/hQiTeJNPfFmr4lLHmxp4hnuyoBlHCB
   ogg0krhe+CcRt4ZwUJP3I/SNrnddIT1fcURQpJBX04/IuHz6D0jmGDD1F
   1fuaZqD6hk3f4LouRCXApj0cxYzLiLszrgFrfQnAm+o9lL/1ckpmTKTVc
   wwoN6xQS9cOJYPzHq2b0RIEmkWD63Lj+jqxL9aeFoyndii3btZpIK/vsr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="315002968"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="315002968"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 18:51:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="647257255"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="647257255"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 08 Dec 2022 18:50:59 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 18:50:58 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 18:50:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 18:50:58 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 18:50:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6STT8VpBcjD99gpRp1BNlCk5UIwT1pbGEjmb3qjQWtbFfQaAe30zXzcCtS/zlecMGf1oIP5/j3mrt8lat5R62CUocJ1hgdcpWWOi1kz9HIm/yoDVf2diinFrsIY+sGyczgvOxAmoeu7BJg8/3q2mRL0VIE82up+LXPyYLE/Hs5LA/pu5Ls8h5UYCLKmIA4Ilq9i442o6JhNPVTiBfe28iOSVKLo2qjQPG+dhjWRCHcAv34GgJG0KSe69m5IgxIK4k9zyfHsiJHmQal1qNo2kSTuauug5fHNQpEzi1/F3nQDw0xCsCzfVD0JwWswdrr8ZfSeEL7smd7if8NHjTojZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gejzUkYvocmg2APb24uluVIU4qc0214qD7EcfuT/bxw=;
 b=R2og7ooi6JEDg1i8qOqhAm4Bi6oNhHyTd9PZyacUGjpwg5DDQ3WBl16blK9QDcr/h5cjRzTMQTBsU1oQ4Ftk3woVD3Y2a0dIC3xOfD0zl1WqYBhpO/GVd/9oOcW/Z+4VPf0spC13FX2ZEXKjS33bFnOfaX476XAL1DNLdMIFExFqcbtjTz+4ms/wXe4B1w/QFr61QykVkHr93dZ4feo8sr12E2BW5OA9emKlGSyB2eYWj/9XKBM7LakS91bvYyjIpLgYgYjLktXiQEp1LziWtMuqBgKsWmdbXLOZU5zk4Wpdn/8DdmcOHoJRC/TPIwO50RzUIxcZBMCKBbUF6ikpDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5136.namprd11.prod.outlook.com (2603:10b6:a03:2d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 02:50:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 02:50:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
CC:     "Rao, Lei" <lei.rao@intel.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "kch@nvidia.com" <kch@nvidia.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Li, Yadong" <yadong.li@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Thread-Topic: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Thread-Index: AQHZCTfLVudoTcTfbUW71RdNMUs3aK5gYwIAgAB8LwCAAAPrAIAAF5SAgAAEXoCAAAOwgIAAEcqAgAAnS4CAANPxgIAAXv0AgAAE+4CAABT+gIAAGaOAgAAOwACAABFFgIAAGmYAgAH6rFA=
Date:   Fri, 9 Dec 2022 02:50:55 +0000
Message-ID: <BN9PR11MB52762EC4F67AF2198EB379FF8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de>
 <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de>
 <Y5DyorZJPdtN5WcX@ziepe.ca>
In-Reply-To: <Y5DyorZJPdtN5WcX@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5136:EE_
x-ms-office365-filtering-correlation-id: f21c1e7f-1934-47e8-f542-08dad99031aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tiiz+G6PXj0jaOPnvyANFjPr+32EkTKDeUFOGj3A/p5gCjB8XLGL+41GyuOh3f77lgJaWzSCG5tp+I5XL6ha5wrcR0dy1h3LsyiCn6GZzDDmclVlR6HscjEr0McvZyXeOLN/ICweE/UCMzS/8KOtUnpAF2N/FmlkMec10peAayH/kpEq6Lf9exTEgdwyX2B2k61yUUDd8m3j6R2RzxCTZ56KdxHLVhAmSJefGinpNtLZ6LEVyzyi4IHS0TshzYx39apC9EN9/xSJEdQvUyaxjE3TrGqz7nxZPjL/udE7MGlhvBcq0m6CtU01X0702xqOHyQZoRBL9wadImEWVYYK+gwze3yJN0Y0jZSSJy0uw26tubW7X83v+B9XWvkEMs4e652KAfUwHggW2i+qzsMvOhD8jBDRqpyAYVczGsgXCOLBq5coGJCcLZorK+7539ndsKPkcdezhU/G7VYCdyR2AtTZtjhemOpl6bOKy1GgEJT20a7mBeBy97yE39CAv9E2CmdyIubi0oRMnWKuoXFzR9OxIxjBGGHxzw/r7ZvpZ1Kk8s1O6VWXK7uvLLetbfo+IEB0lBEuY88yVKTMIu+R8+I33sBbVCN094S1uirVGR9aom9iqWoO0S59/xG5nBpwG1aylS0toEDpEfQTsiZyNSg+hrlJ2uJuuxrIHj1clfZHELcuGcKdX1ba46OA6LGn94C6M0YcNhD9zIF9u+XFEOFgS1xPGmWiW8vnoVwcKBQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199015)(66556008)(38070700005)(478600001)(8936002)(966005)(52536014)(9686003)(64756008)(76116006)(26005)(4326008)(186003)(8676002)(66946007)(66476007)(86362001)(41300700001)(66446008)(71200400001)(7696005)(6506007)(55016003)(122000001)(110136005)(54906003)(33656002)(82960400001)(5660300002)(107886003)(7416002)(316002)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEdhWXJkTmdDQWJPNEJyeVljdG1peTBGK3dvS0Vrd2xtTlIyenFyTDZldjZ2?=
 =?utf-8?B?alJyMFZuTVNxZERNazB2ZUdjOGpjSEhOb3FWOUVUZG1iU0RyM0dBRGt3RHpt?=
 =?utf-8?B?Nk5DWTVZZmRLNmtkeXVkNUdWa0JnREo1ZHFkSG9OKzZSTlJhTG42RUxkL2J4?=
 =?utf-8?B?bmlDVXJWeGk0NG9KR1ZtRGJkVW4rWmRudTBPdHBIOUlFaUJsR3R0QzJhN3Q5?=
 =?utf-8?B?eEs2QjQ3YlNjcHViM2ZYZVNSZ0tlWCtVVkFCOUlSQW95OG9UZldBcVJTS2FV?=
 =?utf-8?B?VlY2UERmekFkaVAydzk2U1JONVByMmdkUTdoMzBHTVZjU1lpTEM0NUEzd2cw?=
 =?utf-8?B?ZlN4NXdObUptK1Z0WjkyZFpvSzJjdVcrc0tQVEVEZ1NKYi9KMTJ5a2JsU2E0?=
 =?utf-8?B?aE95b1N5QndaUlVYcmZyN1RpdmswVURMYzM0Y0NnbjJ5MnYzUXZRUXJtVGxK?=
 =?utf-8?B?ejR4dFVmWjJHK3NNdWhTUk05bFdwV21NM1gycDY2QWZBd01WbEdrVHRma3hU?=
 =?utf-8?B?ejhabzBzaHdiUHFoUk02RitWa2loV2ROcWlmSE5WVVZpbmp4aGZwQkh5UGpZ?=
 =?utf-8?B?Ykw1T0FtcnBIN2hEbmo0RVdkOXRUS0hLd3NMQVhkMDBQbWFWd3JNV1E2U0la?=
 =?utf-8?B?RG5NSU80SVNpUEVUK2pLUEo5MnJpaEJRREJrVGl0WnIyZGUwOU1pSENHb2R0?=
 =?utf-8?B?bmprS0N6VVRmckFLUm56S1JRa2xTWXV0MjZHZHc5TXgzbkNpQkRLVHo3WnRj?=
 =?utf-8?B?MmdzakptK3hpeDdPMzRrWkxqcndCdmxleitBTVdCdnNyMXA0bFhxdk1xMWZo?=
 =?utf-8?B?anJjcjlheS9aR1NEWS83d2JqNGV2anVrWmpiL0hvUi9FS3VyQUU2aDhWbGFs?=
 =?utf-8?B?dGtTVHhISjJMZFdEK2dCZnMwbC9KUDJNcHJrL2drQlNsQjMxTnlKakpKQmhX?=
 =?utf-8?B?V0ZtSHlSaUtIVEwrMzNiTUoxdmJZNW93aEREaDB6TjhYR0FJZ3NMMTdrN0pm?=
 =?utf-8?B?dC90YUdhMTQxUW0ycVZmaHlHQ2xCSmVDRForaE9Na1BleGdxdjB5b0d4d1c5?=
 =?utf-8?B?YllNU0pISGp2VzdvbUNZUXo2YlQzQ210cHFDMjBRbXpQRW5KSDA1NFZHYWow?=
 =?utf-8?B?MmNnZXg3K3pmSDhMZGtYcHpwVm1aTGs3M0l4RXdZVVdMTWc5TisySTc5RkE3?=
 =?utf-8?B?N0pEOGJKMzUzMEtRZFNpOUVoOXdKdzJyRVhwdUgwdGhiWkRjdWl2WEJrb094?=
 =?utf-8?B?L2JOMzVXUjJNWmpqclBGQ1dYMTVIZ2pmZXZGYWg0ekJwUEg5OGFOc2pqck93?=
 =?utf-8?B?REwxdjBWZlp2T25OQnFKelJjNUZzOS9sZk84MFpGVHFjcm4wQjVPWDNKM2xG?=
 =?utf-8?B?VUpOU3JlcWlYU082L2FENVlLa09SYW5SQ1diUkdWUTNqUXdRQWNvV2kxSkp1?=
 =?utf-8?B?QlRZSjRyOFQ2a3ZZakwrajNHUGxaMHdiQStLdERFV2l3RWU0TkZCMW1TdDFU?=
 =?utf-8?B?RUpoMXVuc1ZxZFlsOWVsaHBzRHpkaGJZU0ZNRktYVFh1cVJ6VnIveEZhNWNv?=
 =?utf-8?B?UXljSllXejU0Q0lUMEhuQ3NPMWdHSXBaRUp0NXE0eW5MK1R3eXdZNEpxdkF3?=
 =?utf-8?B?ajZxbFQ4elQzNkZ1U3QyKzE4SFR0NEtyKzZCMStXbHQ4VGt0TGZwQk9PREFY?=
 =?utf-8?B?UjVyS1pjc2ZXNU1LUm56eDVSWEdlaldBd2NtTkxjeHg5eTdzeGVpTkVKZFhW?=
 =?utf-8?B?TzRicEFEUmhqOFJZaTNNV1NRbEZVaTBKMHhQMm5PZTJGMk00TWZZcXJDQzZ0?=
 =?utf-8?B?blJ2cm5tdXY3SjFNOU1RR2RKaWxxSHBMb2kwdUZEeE5PM1lpM0NSRlF1M3hR?=
 =?utf-8?B?VGhYSW40N1pyNDJyalQ4UnNacGlzLzhRdGNPdktaREdRVzFTV3phenZ2dGZy?=
 =?utf-8?B?Q21XaEtqMmdoaVh0dllBbGFkaHNLUUhZUjlSSnVPWEF1dnZPZ1lObEFqOUV5?=
 =?utf-8?B?SHFCamk2K3hZYXM0Y2E5TThkNms4QWFEOGh1RXhDRGl6NjF0a2JPNHpxZWor?=
 =?utf-8?B?ZFJuUmpUT1ZtK2FxTTVnczdIakptUTVXZ1JZODZFWjFlNHJ4Wk02VWh6WnB1?=
 =?utf-8?Q?ucCns4IZhtQwGZ2KA/qWf9rmN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21c1e7f-1934-47e8-f542-08dad99031aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 02:50:55.7683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kkGS5LzdEu428re2wC38Txoq5qw4WENRkIgVFvmxyHNUZEuWg4Dv0tQ//4RH0kNZ/W2NUr700OcNvVfXwTfVZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5136
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gU2VudDogVGh1cnNkYXks
IERlY2VtYmVyIDgsIDIwMjIgNDowOCBBTQ0KPiANCj4gRm9yIGluc3RhbmNlIGhvdyBkbyBJIHRy
YXAgRkxSIGxpa2UgbWx4NSBtdXN0IGRvIGlmIHRoZQ0KPiBkcml2ZXJzL2xpdmVfbWlncmF0aW9u
IGNvZGUgY2Fubm90IGludGVyY2VwdCB0aGUgRkxSIFZGSU8gaW9jdGw/DQo+IA0KPiBIb3cgZG8g
SSBtYW5nbGUgYW5kIHNoYXJlIHRoZSBCQVIgbGlrZSBoaXNpbGljb24gZG9lcz8NCj4gDQo+IFdo
aWNoIGlzIHJlYWxseSB3aHkgdGhpcyBpcyBpbiBWRklPIGluIHRoZSBmaXJzdCBwbGFjZS4gSXQg
YWN0dWFsbHkgaXMNCj4gY291cGxlZCBpbiBwcmFjdGljZSwgaWYgbm90IGluIHRoZW9yeS4NCj4g
DQoNClRob3NlIGFyZSBnb29kIHF1ZXN0aW9ucyB3aGljaCBJIGFsc28gYnV5IGluIHRvIHN0YXkg
d2l0aCB0aGUNCmN1cnJlbnQgVkZJTyBmcmFtZXdvcmsuDQoNCkFjdHVhbGx5IHRoZSBzYW1lIGNv
bnRyb2xsaW5nIHZzLiBjb250cm9sbGVkIGRlc2lnbiBjaG9pY2UgYWxzbyBleGlzdHMNCmluIHRo
ZSBoYXJkd2FyZSBzaWRlLiBUaGVyZSBhcmUgcGxlbnR5IG9mIFNSLUlPViBkZXZpY2VzIHN1cHBv
cnRpbmcNCmRvb3JiZWxscyBmb3IgVkYgKGNvbnRyb2xsZWQgZnVuY3Rpb24pIHRvIGNhbGwgc2Vy
dmljZXMgb24gUEYgKGNvbnRyb2xsaW5nDQpmdW5jdGlvbikgd2hpbGUgdGhlIGRvb3JiZWxsIGlu
dGVyZmFjZSBpcyBpbXBsZW1lbnRlZCBvbiB0aGUgVkYgc2lkZS4NCg0KSWYgZm9sbG93aW5nIHRo
ZSBkaXJlY3Rpb24gaGF2aW5nIGNvbnRyb2xsaW5nIGZ1bmN0aW9uIHRvIGV4cGxpY2l0bHkNCnBy
b3ZpZGUgc2VydmljZXMgdGhlbiBhbGwgdGhvc2UgZG9vcmJlbGxzIHNob3VsZCBiZSBkZXByZWNh
dGVkDQphbmQgaW5zdGVhZCB3ZSB3YW50IGV4cGxpY2l0IGNvbW11bmljYXRpb25zIGJldHdlZW4g
VkYgZHJpdmVyDQphbmQgUEYgZHJpdmVyLg0KDQpGcm9tIHVzZXJzcGFjZSBkcml2ZXIgcC5vLnYu
IHRoZSBWRklPIHVBUEkgaXMga2luZCBvZiBhIGRldmljZQ0KcHJvZ3JhbW1pbmcgaW50ZXJmYWNl
LiBIZXJlIHdlIGp1c3QgcHJlc2VudCBldmVyeXRoaW5nIHJlbGF0ZWQNCnRvIHRoZSBjb250cm9s
bGVkIGRldmljZSBpdHNlbGYgKGluY2x1ZGluZyB0aGUgc3RhdGUgbWFuYWdlbWVudCkNCnZpYSBh
IGNlbnRyYWxpemVkIHBvcnRhbCB0aG91Z2ggaW4gdGhlIGtlcm5lbCB0aGVyZSBtaWdodCBiZSBs
aW5rYWdlDQpvdXQgb2YgVkZJTyB0byByZWFjaCB0aGUgY29udHJvbGxpbmcgZHJpdmVyLiBraW5k
IG9mIGEgc3cgZG9vcmJlbGwuIPCfmIoNCg0KYnR3IGp1c3QgdG8gYWRkIG1vcmUgYmFja2dyb3Vu
ZCB0byB0aGlzIHdvcmsuIEhhbGYgYSB5ZWFyIGFnbyBMZWkNCmFjdHVhbGx5IGRpZCBhIGZsYXZv
ciBbMV0gaW4gdGhlIG90aGVyIHdheS4NCg0KVGhlIGNvbnRyb2xsaW5nIGZ1bmN0aW9uIG9mIElu
dGVsIElQVSBjYXJkIGFsc28gc3VwcG9ydHMgYSBuZXR3b3JrIGdSUEMgDQpwcm90b2NvbCB0byBt
YW5hZ2UgdGhlIHN0YXRlIG9mIGNvbnRyb2xsZWQgTlZNZSBmdW5jdGlvbi4gDQoNClRoZW4gdGhh
dCBzZXJpZXMgYXR0ZW1wdGVkIHRvIGludHJvZHVjZSBhbiBvdXQtb2YtYmFuZCBtaWdyYXRpb24N
CmZyYW1ld29yayBpbiBRZW11IHNvIGluc3RlYWQgb2YgZG9pbmcgaW4tbGluZSBzdGF0ZSBtYW5h
Z2VtZW50DQp2aWEga2VybmVsIFZGSU8gdUFQSSBRZW11IGNhbiB0dXJuIHRvIGFuIGV4dGVybmFs
IHBsdWdpbiB3aGljaA0KZm9yd2FyZHMgdGhlIHN0YXRlIGNtZCB2aWEgZ1JQQyB0byB0aGUgY29u
dHJvbGxpbmcgZnVuY3Rpb24uDQoNCkp1c3QgdGhhdCB0aGUgY29udHJvbGxpbmcgZHJpdmVyIGlz
IG5vdCBpbiB0aGUga2VybmVsLg0KDQpJdCdzIGRyb3BwZWQgYXMgdGhlIGlubGluZSB3YXkgd2Fz
IHByZWZlcnJlZC4NCg0KVGhhbmtzDQpLZXZpbg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsLzIwMjIwNTI0MDYxODQ4LjE2MTU3MDYtMTQtbGVpLnJhb0BpbnRlbC5jb20vVC8NCg==
