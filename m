Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7862873F62A
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 09:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjF0HyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 03:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjF0HyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 03:54:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745AF10FB;
        Tue, 27 Jun 2023 00:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687852449; x=1719388449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pGcMA34uN8LKxn0e7RGhTTfstMz+FhFkfbBQcNsZxEI=;
  b=fAXRN4nCI+E6Gob0NgUABPDb0HN/OB9iQsSa3Xho6oejFCx9+T2zJYOb
   ClRsUj2ZrRgwS6RjPO1Dca9bpzC5YdIjIGcKLRrHL5LJ105Ye6YI4rbN0
   J1YFsuRNuYXLZi4FTqaFRuXwntQI7QL1AUhFS0JEhBmDvtUMWMaO+yKAJ
   m0fRl/LYOuuVSk0hwbir1lFzy1xEyFRDrcTw1T8LPIQ/ChxeLulw8UOaK
   hqz/aGSp0b+gj5yXH/oSh2Cu7MoR8h8DKAuPMGmn6jTaHADIAED3y21j8
   BMJ/qZrOsOjrRTt33cLdY+/GSC2C0wd5cTVb+e7tyGcmTQsIDXJ2oGlqb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="341095391"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="341095391"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 00:54:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="829575495"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="829575495"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jun 2023 00:54:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 00:54:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 00:54:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 00:54:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 00:54:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PalCH/77+akWRlo/NTRWVA3Qj9cAKzgB4n37XyNX7uSU8YJ4neGqcq7r+dkrl25yXg/Xmo/h64V+wXdneCqBeORpLILkdgczc/XAQn8wdVfqmBUeXg22IToNQIvjsQUPf3K41RR8Nf22tGZpb7Poi4ywK8JlYfy9+gDoNVlWOeGMpuvSWGwN9hrHJ5iWkcB4LJDDm9Ue692OkUJQiCm4FIefXMv6oA2alR653XPeB8/DfPoc6slxpx7K5l5NMQRD9mcrSRXBpVucp6UBOnw6Obzc9/ei/AuVhvv4SEQh0xnoxW4oHTCysQyQ1phc1jdM/oRRoyOfXrbxRFrasHmN6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGcMA34uN8LKxn0e7RGhTTfstMz+FhFkfbBQcNsZxEI=;
 b=MHgQkft5kRfEW/Sr+wmt2u4CFIosEMVWhD5vNubMUkEMi2Z2YBQOkUVUeADQ9ccJZjvOHvkE5fnVskvBDTDloJOzf5L0/NgDZU9beJj9Ww5XxqH5Qx3gO/m/iBgqdWt8KC1Ct4qBtheGc46YQkWnkskRRd6nbfQCZvtUP0ACCxM+MUgmZSu1AuOygXbE3eoTYHVzmKaT5en2plOuVDFcTX/0unhxSD+YcCUySlLUCoNS4D0EnIOjUAzaj8MMjRxqmq9UKq+CO67blloaxVBqIJNNrI3suonWkKsdE6FSz/kSKGyVsoBYAnfF4Bo++T4ncvAzFSsUmKzq6TY0nwUPow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4940.namprd11.prod.outlook.com (2603:10b6:806:fa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 27 Jun
 2023 07:54:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 07:54:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Topic: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Index: AQHZmPOfW21nPHSVEEOmSVh5Edp4ra+G3diAgAE6lgCAFk5D8A==
Date:   Tue, 27 Jun 2023 07:54:02 +0000
Message-ID: <BN9PR11MB52768ACA721898D5C43CBE9B8C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
 <69f50ced-e806-717a-0c74-a4cfa58600fa@linux.intel.com>
In-Reply-To: <69f50ced-e806-717a-0c74-a4cfa58600fa@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4940:EE_
x-ms-office365-filtering-correlation-id: 6960d47a-2a0f-4314-ad97-08db76e3acb4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aI5AtKiZziZM5NZ3M+66nMayilU7UGUdkG6YlurHELzBaDvNwvyG1AHtBtfbheVlz49a9mHFKSyVv46G3rw1uWOAxPoVoDiQEMbK+M95jbVsubTmRKaZWl3u8bKIXWiHdGJw/gYb7O4L6oKTiXTmtxNWBGqBwlmPhtQwvmE+jX149YV9F++DYo0+C/1CWT4yTpSDB2StgdlzG1WxFFHp8GEziGo67+xB02LZTLN1sQVOUAMR0/4rJT3Uc7G+z+bGdNwHTU1t4sRxNmUAlGi9JMjV24dqdv+lvrsq4GdZS1X1pUSm5AQwyFvBzC0cgWC+XV1zLvpwLQNoPKgMh7KfUvlPK7beeB1eTiXR9rmeYegEIow1lk1HsnFVCwGn7SPgxjAun7wP3DqQSH8XOeLo1ly3Wup2EsQwRRkKyTHJXMIJLQed5NxMsem3dMBzgfRaIMCnXO7/WVvonFrRhU+4YnFRVCiH80NTkBJkrLWfpP3Ly6unCQfUZ4GSIWv78PKZ+xOFB1L7tksucp1S9rWnzbmNswOuG8XyV1dbLi8GzY0Uj7a8njliTRrdMiriAHRXTCQbwVFmYS9jlfGXVF62e0nm43NInt031INUGu70vuZhiSZCuiC4/I54s1StPAZO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(8676002)(64756008)(66446008)(66476007)(55016003)(66556008)(4326008)(316002)(76116006)(8936002)(66946007)(41300700001)(6506007)(186003)(53546011)(26005)(4744005)(9686003)(110136005)(478600001)(54906003)(71200400001)(7696005)(2906002)(52536014)(5660300002)(7416002)(38070700005)(122000001)(82960400001)(38100700002)(33656002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3RqTjk1QzEyNFJreENFVU0wTnI3QXI1VUZBTyszcTk5L3V5TnNWZ0ZFejJF?=
 =?utf-8?B?aFlPT3R2MEk5bmFRZUxDa0c2SG5PRVZCeEhweFlQVVp6dzFUQWk2OEVnNnd3?=
 =?utf-8?B?MzIrc3QwcE0vYkNXTGNZYitndXZMdFFXbFg5Tk5EcGs4ZXB6VE1RaVZ3cTlT?=
 =?utf-8?B?enVKR2t3aTFVYUsyOXorTlpXSTU5aGxSekk0RVoxc1ZnVmIyOGZlWVlsaHI0?=
 =?utf-8?B?VjZ3QW94SzdtaWZ2NVZTaGpVQkRVTXhteDNQUkR6OFNmUElwN2J1ZVZCYXlE?=
 =?utf-8?B?dUxZN1N3ajRscDRpMklqaHBaTWxJUkJNOW9LcUkrMnFnZUxJdnZMT2krdEo4?=
 =?utf-8?B?d0JITlpOQlk2QjlJVXpZY3kycWgyV3VYZS9HOFpQRmN6QW04UHlJTGVsekVt?=
 =?utf-8?B?RGZaVVNLdGVkcEJsNloyYzBVbDFKdjVOQVEzUVhydW40eEtHeFJRZmdMWlpJ?=
 =?utf-8?B?ZUxMdUVQenlrekt0MWJ0b1NQcDkyUFdEd0FjcjJpdVdpQ0d1M0ZSY1lvR3Bt?=
 =?utf-8?B?cnhXeXk3d0VyMGVpL1d1MXFMVllxNHU1WGN6blhaMzFka2ZybHZYRE1HQ0hi?=
 =?utf-8?B?cERSckYvdkZRWlNPRVRvVklnMTlCaGNjN05TNCt0bk5Ka1oyZ2w5aFFKOHpn?=
 =?utf-8?B?bFlpRXZJbFpOendlT1BEam8xV3N0UXNRa29xb0l0RnlaeS9QNkduSWNMcnV3?=
 =?utf-8?B?a1ExTlFuaWFjZDBtSitOcEkrZE0raDk4VUFVVVVvcVcyR0lIK3ZsTHVZbzRa?=
 =?utf-8?B?T0pnRENwdmJkakJLWk5EMWlXNUFIQVFLTzVYeXRUcEJMdDVQQ21JUUFYYjFV?=
 =?utf-8?B?b0poNUpZa1lQTE8zN3poUWk5VVJaRktvMUZzTGFEc2FINllKWmFkN0xIdm14?=
 =?utf-8?B?ZkJURzVvWnRrOUcwVUNGN3k0RE9XWWZGaWtKOFl4ZWtBVXpsRjYzSVpKbmNO?=
 =?utf-8?B?SlRlV0tyYnVtZEQrMlM3MllPODRuOVF4WE5RUnk2bzI0UE1QUXBGNlZ5UGxi?=
 =?utf-8?B?YWFzT0NrdThjS2pHem1kMHV2SWxCVEphcVRPR3VHcEFVNHZ6RHpLVGtqU2Vn?=
 =?utf-8?B?TnZ4ZitocjRleXJ1dHVjaS9iM1c0ZERtMTFaR2x2YWx2akppbWNPeEF3THNp?=
 =?utf-8?B?QVNhUGFJcXdIN1EvMGhYQ1EvRkZPM1dkMW95RDUzMVJLWjJrQzZUQXV2Tzc2?=
 =?utf-8?B?RGZpWlE3ZTNiY25BNUk1VGpWak82bmtJY3hUV3pXWEZsSGtPN3NFUEt0WVFl?=
 =?utf-8?B?dEk0MFN1OGR0NW8zK1N3ekYyb29OTUs2VWJsRmg3eVVxZnQ5ZUg3MDNsaVd3?=
 =?utf-8?B?R2tFS0ZzcWFKblZ5UHZkaE1HS01rREFkNWdBdWtsaDdNVEY4WTlBZEtwV2w1?=
 =?utf-8?B?OFluSS9kanNuLzJEdHdUNnNvMFlWLzdqSFU2bUMyQUtJcmFSaEFlSVEyNE5K?=
 =?utf-8?B?YkxtYTJORFdqQnJ2dU9NRnBWV2JMd1BjWWRpczlUcDBzSHVTOUdLUEZDWTFQ?=
 =?utf-8?B?SGtEMnNUZzN2akZFVEV4QUFIY3dvVi9vYWV1NVNRRk8wbmFUSlA4cGFmUjFq?=
 =?utf-8?B?dnJCaE9VYThvNVcwU2lCMVJzTGFXUDNtZWc5V0ZZenJFVlZsV3RUZ3poNzNj?=
 =?utf-8?B?c2hHbGgxVGJuTXNUbFZhWm54cEN2S2dBNVhncU5JUnJSR1NpL2RkWmVrZDZY?=
 =?utf-8?B?SUhkYmdlSXpBNy9nKzJSVDV6QkhneTFkdmZiSzdxZzM1cWtUbDI3c2tWVDZm?=
 =?utf-8?B?RzlyU1NESjdqODNtZ3loQzVFVk9kemVtdWU0ODVvQWtIVkZUa1JienpmVTY5?=
 =?utf-8?B?aXduWVZoUWxad0w1YmlwcjU5dTJjZmw5TU9rbnhQYTBYUjl4UFJWdjVLM3pq?=
 =?utf-8?B?VmVKQzhUblFFYllxWUpuSnN0VFQvNm50ajlnZHRUZlFkTFdXajRUdGJnUXEx?=
 =?utf-8?B?MjNQZXdDMDh4U2NMTEZ2T3c2cyszSmxRQUNXbk1OUkpGNUJROVk1U3FFWDFM?=
 =?utf-8?B?TFdYREpKeS82NUJYMHVxLzBkdUJWMWt3eDJBdEsza2c0dS9XRUFreGE1T2R1?=
 =?utf-8?B?bWNZL2hTMkUrSUhPNkkzek1mNHlmQUJ2YzJjOXVmZUR3Y24zRlpac2ZCbVVq?=
 =?utf-8?Q?2YCFlWI/OqNDi/8ixakJTSNPJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6960d47a-2a0f-4314-ad97-08db76e3acb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 07:54:03.0082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0a6E5DVpkYDOIkVzv1NtTNF5MO8WyfSpjevYjBRDHWJabmO39fMGU2Gf8OlKCtFLNj6MipQMXl/FpM0/5py9Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4940
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKdW5lIDEzLCAyMDIzIDExOjE1IEFNDQo+IA0KPiBPbiA2LzEyLzIzIDQ6MjggUE0sIExp
dSwgSmluZ3FpIHdyb3RlOg0KPiA+IE9uIDYvNy8yMDIzIDExOjUxIEFNLCBMdSBCYW9sdSB3cm90
ZToNCj4gPj4gLQ0KPiA+PiAtwqDCoMKgIEJVR19PTighZG9tYWluLT5wZ3NpemVfYml0bWFwKTsN
Cj4gPj4gLQ0KPiA+PiAtwqDCoMKgIHBnX3NpemUgPSAxVUwgPDwgX19mZnMoZG9tYWluLT5wZ3Np
emVfYml0bWFwKTsNCj4gPj4gK8KgwqDCoCBwZ19zaXplID0gZG9tYWluLT5wZ3NpemVfYml0bWFw
ID8gMVVMIDw8DQo+ID4+IF9fZmZzKGRvbWFpbi0+cGdzaXplX2JpdG1hcCkgOiAwOw0KPiA+IFdv
dWxkIGl0IGJlIGJldHRlciB0byBhZGQgdGhlIGZvbGxvd2luZyBjaGVjayBoZXJlPw0KPiA+ICDC
oMKgwqDCoGlmIChXQVJOX09OKCFwZ19zaXplKSkNCj4gPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVJTlZBTDsNCj4gPg0KPiA+IEluc3RlYWQgb2YgY2hlY2tpbmcgbGF0dGVyIGlu
IHRoZSBsb29wIGFzIGZvbGxvd3MuDQo+ID4gIMKgwqDCoCBpZiAoV0FSTl9PTl9PTkNFKCFwZ19z
aXplKSkgew0KPiA+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7DQo+ID4g
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7DQo+ID4gIMKgwqDCoMKgfQ0KPiANCj4g
SSBhbSBhZnJhaWQgbm8uIE9ubHkgdGhlIHBhZ2luZyBkb21haW5zIG5lZWQgYSB2YWxpZCBwZ19z
aXplLiBUaGF0J3MgdGhlDQo+IHJlYXNvbiB3aHkgSSBwdXQgaXQgYWZ0ZXIgdGhlIGlvbW11X2lz
X2RtYV9kb21haW4oKSBjaGVjay4gVGhlIHByZXZpb3VzDQo+IGNvZGUgaGFzIHRoZSBzYW1lIGJl
aGF2aW9yIHRvby4NCj4gDQoNCllvdSBjb3VsZCBhbHNvIGFkZCB0aGUgZG1hIGRvbWFpbiBjaGVj
ayBoZXJlLiBwZ19zaXplIGlzIHN0YXRpYw0KdGhlbiBpdCBtYWtlcyBtb3JlIHNlbnNlIHRvIHZl
cmlmeSBpdCBvbmNlIGluc3RlYWQgb2YgaW4gYSBsb29wLg0K
