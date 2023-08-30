Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B9878D974
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjH3SdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242309AbjH3Hzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 03:55:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301C5193;
        Wed, 30 Aug 2023 00:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693382147; x=1724918147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2njWM5MpxLimJfU0HeI6Pbl1j6jPJ6ll5lUmuxsW8o4=;
  b=B9c+7j6iw9VUzRaOpuWeA3Gcbb0TsxYq3/4x/JBoDPWYZZOYQgXOftEQ
   EpJsVtGNs3B4KnV/Ven2QULh/udhxeNC0YtQfbc9HOcMGEJj6X4JMKB8r
   NsDCyoOhWZXn4ZEr89anEf7K2DOe5DYz1SpN09UINNUPjBW8ryh5EwOQU
   lqmyxh3jpHKrV6u0JmU082mv0tm7x9oceY++41eNBDODSTJpYIiG4Oif2
   U5pkDVyYQfGlQ8K3wf7ybclOKXo1jkyUUkc1h7dn3DcZYAvILJ+lcWUGq
   b9KAa0/RIalLLHHkN6YaSDFE0Z4W2Y29DQ1M1rZVJxL0Efq5kMQjdvTNu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="378290327"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="378290327"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 00:55:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="774016552"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="774016552"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 30 Aug 2023 00:55:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 00:55:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 00:55:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 00:55:43 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 00:55:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWWV725ZVG3BIK9eT+zID5kAQoGxiPmQMgPz09tiGDGYFwmER/B2drWC4XKj9XX2HI60bTMpssr0OHPQTlw46eGWxcTksEhiJtBFd9NiMB2k3KtuZWkmRoFWINAcQNImcHc1YJkm4iH/PYDqAEwMpz8vVsn++EsfmvIg0lv1WrVLtKx+OmpWCVAdJxCS3Pgxx0TL3CwDOcOBII6CwZ9+5FvlcuON54zaEau8Rjrn/ICpbUl5W0LG6uOy0x/8lUUOVg1TekREX5HRYoGfjMfZ0aSpKC9lojuogduDv/I1bQ390X8XqGkB08gFWbJgzN4aA6uhog9IAc3x+KOwRNtLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2njWM5MpxLimJfU0HeI6Pbl1j6jPJ6ll5lUmuxsW8o4=;
 b=Fun9hW/Vnga56LEKo2nMKPZCDY4cGZJapsSHnOFKqi+k/aadZDJe1znDhOBlEhBFeshHOjoogbYlLaXeoWEVPFfTf7dxcs4qX5ehZwRbzl6t4tfpjGrtacqIwMN79I0n53dStSCxts4/eaMFfET7ud7PzndDnAS+d+lMzUySokJp1ZqS184y+kT38VITvDFXVxhmr4YkaP07LPUtwF9oOR0xQVHgshqzjmaGx5kWgmQFYSOlWkJbNb8yGW8cmQoXdeO8IwE3sJ57xnFq8j8Xos+hslAw+RUqutg7/vAC0tZQ2r8ttIApOh3vY/F2IReraSEXRypdxrYMrNUlfyHraQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8458.namprd11.prod.outlook.com (2603:10b6:408:1bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Wed, 30 Aug
 2023 07:55:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 07:55:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jwgAGR2gCABkO3EA==
Date:   Wed, 30 Aug 2023 07:55:39 +0000
Message-ID: <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
In-Reply-To: <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8458:EE_
x-ms-office365-filtering-correlation-id: 7a89fb0a-486f-4867-bcbf-08dba92e80fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HCz/dFkkdAsYrLRN+tkvsfgd1oE6+2a2FU7ANMxc8zaa5sX6g3OZjOkLMI6nex8XAfwV1hYCbUuKE2tiWhrHW0oEGugMVvoRkVWEgmVV5uaJ2dbZVlXURu6clu9tkfDneiGpSdKmILA+gL1h40oeVWt9sMRQiBXT5djDd6+XITZ7QL1iVMaU8PP+VivCAARMSR3CKyjwrTwkLQuMDFN7ZJMMF5xHuWFVh0wGuA9lHUsgYFYKFfPv43Aekyyf6VyMNRskTqaw3QrVDmrOoM9jWo5islKow3RKllhsiw5PnvsudJ8KEHt8wNPI2SuU/1ajcmOavpK7o8bCqa3FtEzrcHUhEnXSN5L3HLuvzmgEWWaTJHtjbDQrOORdRT76pFQSaCJnw2mei7xWXa+3qkRXezF85GiFO7u2Yaadukj/cihk4MFGdJEjmOrZjMSMfEiqh9yue1gJs+445Q/ELmrb15m69v0zpFL7/X3fOgK6gOjH/kBM+Lm9erCpRk6VuoC7Ga6Ek2/JPZIaJF6ZSJ9v0AW69CnRUBLoylHAB1ojVgTr3kbx2zbqWYmJOvtq1pVy8pmOfetgRryP5skyjkwBcrY5CdSxe1LloJS9Q/9edWsSP3hruCSDuopRsorlPjUWOE6LPlwf8FqMhF+IyD1hUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(39860400002)(376002)(136003)(186009)(1800799009)(451199024)(7696005)(9686003)(71200400001)(6506007)(4326008)(33656002)(86362001)(38100700002)(38070700005)(82960400001)(2906002)(122000001)(55016003)(76116006)(83380400001)(52536014)(26005)(478600001)(53546011)(110136005)(8676002)(41300700001)(66556008)(8936002)(5660300002)(66946007)(66476007)(54906003)(7416002)(66446008)(316002)(64756008)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHQ0MTZ0S2ZaUVp0UmsxOWR6Q0ZoMG1CWXJvcDhab1JLRHZnN0ZxNDlYdXRR?=
 =?utf-8?B?aTFBQVJRL1RJWGVhUG9PdGhlNitmdFlrdVFMZEVRM0Y5RDBBS2xSYnBPMjVt?=
 =?utf-8?B?Y3QwRWhkTWJjRFU4MFV0bGJDM3dJUC9wL2l1MzZFTGhFczVQcWhqRjIvbm9u?=
 =?utf-8?B?bW9Lb0tvZlgyK2lLdEp5Ykg3a01pOGdvRnJBSnppTHoxeVBHUzQ4b3ozbEtI?=
 =?utf-8?B?NnMya3owWFJWc2c0MjZyWXFxbG1IQ2pmVVFvT2FDZzBockxVUkJId2V3Rk14?=
 =?utf-8?B?RUJRc21ZMFdpN1pRWUJLMXY1SmpjNkVid0RZR2tkWXBDbkJKL1ExemNaNmZY?=
 =?utf-8?B?ZzFNQ0lvaHFuODBOVjZUVHBOUWxyTUtTQXZ5dXNyTjlDNmp3ejVYTGc1YmJw?=
 =?utf-8?B?bE0weENFTFhldmhaWTFtV0NzN1hHbldvSkl1Y1NWZmhEYWpuSk5BUW9yQUg0?=
 =?utf-8?B?dyt1eFdYbjBoelF5N1VWcEdPNTNWQm4vd3NOOHdQa1hWcWtOWGpHcjRDVUV4?=
 =?utf-8?B?VC8zYTU1VWprSzNabkJ3a0c3MlRPUFJpZzYrMzBONFdZWVJQNG1EU2MydE1F?=
 =?utf-8?B?Y2RQMStJbGx2VFhBVG9BOERZTlpKb2tTanRpVXpLY0ozY2RqMzNGYm1Ra2cv?=
 =?utf-8?B?TFFEWUljaFN4bDJHRFpxZmZNRFI2QmQ0RWlaSXBsWnlBdTd4VjJ6cjdtYmRo?=
 =?utf-8?B?L0RNSWdSNDRDNTA4Q2wrWDlHWHRvWS9zVUp2cS9OTE1HMkVOUndVNFVHZmRo?=
 =?utf-8?B?eU9IbXJDS0VuNE55V2QrdisrS0ptOGlFYzJvTVJOSjJhYlRYR1hWVUhkRTEy?=
 =?utf-8?B?MWdoUGZiWHJuZFdxdjFxK0F6aHFrQVBNV2pIQWNOQnl2RmN4OUN2M1lQam5r?=
 =?utf-8?B?UHVwNHJpYTVZTkc2RDZZSkozU0w2cTFZbW1HUXp1YWFTYSs5S3QvejJobHl0?=
 =?utf-8?B?bDBENFJDUytvQUc0M00yZ3pLK1BpMWFHNXkxT2hvRGdJVExQUERYM1ljLy9a?=
 =?utf-8?B?WnBZY25sYlRwMFZnRGJlbW16SXRCS0gyS2E4S0VhcHl0WFdVWCtwdExaSTJ5?=
 =?utf-8?B?WUZIaVN0TXZHZXBjVkFJNWFxdTlQZGxScmV1SkovT3RNTkZKNXZ0R0YrTWRH?=
 =?utf-8?B?ZlFTR251ZWtrT3ZsTkZsWUlYcUM3cnpBdkk0R2wyNHJ3WnMzR090TXNpTWF4?=
 =?utf-8?B?azFwS2x4NWI1NmZDdUxaZnZqajU4Zk1pZ3Noc3lUSC9jdjMyci9JVk13Mjli?=
 =?utf-8?B?NFgwTFVzUDNpOVhmTVZqT0FJbmtkc09Cc1FsdkJtVXFPWVQ5cnlqVUJ3Q2Ja?=
 =?utf-8?B?Y21ONkNYWXhKQUhDaDVpeHBERGkyUzdFMkpRU2ducTJlSkRudlNGVTlremd0?=
 =?utf-8?B?WTNZbTQ2ZjJORndROW1FbndxZFI0d1BPcHRLTmZJR21qVHk4RlFyMExycDVO?=
 =?utf-8?B?bUhCcmo2c3BCSVFyUnJyMjk0OHNkck55WGlKa1EyWHRSbUNPTGFtWFR0Uzdw?=
 =?utf-8?B?SzFXdnVJb0kyVmo1VjEralk3S3U2c0FEczhUTTJOUW9SQm40UkJIR2lJSUI5?=
 =?utf-8?B?RXdIRU9DY3FHZlg1REdScTN4SnZvTEhpRmpTR0VML2I2b3dCYUorRGZwTEk1?=
 =?utf-8?B?WDAveU4rbE13R2Q4SldyN2pIeER5cmwwcDRHQytIR3VLaS95UFZicEdJUVZ1?=
 =?utf-8?B?a0QySE5kekNBVTN6dldvaTF3OFpySTVTRXNqVC9lNE9rbGg5Z3pzeERiTy9x?=
 =?utf-8?B?bDhSa1ZKMzNRUnVBaFAwT0FRNkF2cXFmUXNvQnAyK0lIajhYK0NJVG83S3lu?=
 =?utf-8?B?ZG5HRU9GZWlFcVZMWkVkeVRqRTQ4WTFiYzF6QWRMMTdLNGxsMGdjdVZvb1lS?=
 =?utf-8?B?ZU1mSmFRaUVMZDVPQTVPSDZvR1FEYWtkQWNHdi9zemVENklUSHBIWk11cktE?=
 =?utf-8?B?ZHl6eG9MNUNGNVg0WmVQN0d4ams0R3h5bkdmcXdDZXRJTHdxaUlZa1RYQnhx?=
 =?utf-8?B?Tko0NXMzeFl6ZlV2Nk1Yay94bmc1V2lWcTlBUjJrVjZsK3BUWm16QTg1ZTlQ?=
 =?utf-8?B?b2pvWEhSOENrK1VKMDU1dVpoZlRobGIwbURQL0IzdVZYRzV4WlJ4TDZSREVi?=
 =?utf-8?Q?60wiY6aax/uEaZOX1C4RP0o5F?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a89fb0a-486f-4867-bcbf-08dba92e80fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2023 07:55:40.0161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92RhCU1/8KzKkG+wF0iAbzqtuFY8bBkH2P4U3PgqCrCK813mUwKuWiZmrJVG5UQGJ/bSixW3q34G0sVbT1ZqlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8458
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgQXVndXN0IDI2LCAyMDIzIDQ6MDQgUE0NCj4gDQo+IE9uIDgvMjUvMjMgNDoxNyBQTSwg
VGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+ICtzdGF0aWMgdm9pZCBhc3NlcnRfbm9fcGVuZGluZ19p
b3BmKHN0cnVjdCBkZXZpY2UgKmRldiwgaW9hc2lkX3QgcGFzaWQpDQo+ID4+ICt7DQo+ID4+ICsJ
c3RydWN0IGlvbW11X2ZhdWx0X3BhcmFtICppb3BmX3BhcmFtID0gZGV2LT5pb21tdS0NCj4gPj4+
IGZhdWx0X3BhcmFtOw0KPiA+PiArCXN0cnVjdCBpb3BmX2ZhdWx0ICppb3BmOw0KPiA+PiArDQo+
ID4+ICsJaWYgKCFpb3BmX3BhcmFtKQ0KPiA+PiArCQlyZXR1cm47DQo+ID4+ICsNCj4gPj4gKwlt
dXRleF9sb2NrKCZpb3BmX3BhcmFtLT5sb2NrKTsNCj4gPj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5
KGlvcGYsICZpb3BmX3BhcmFtLT5wYXJ0aWFsLCBsaXN0KSB7DQo+ID4+ICsJCWlmIChXQVJOX09O
KGlvcGYtPmZhdWx0LnBybS5wYXNpZCA9PSBwYXNpZCkpDQo+ID4+ICsJCQlicmVhazsNCj4gPj4g
Kwl9DQo+ID4gcGFydGlhbCBsaXN0IGlzIHByb3RlY3RlZCBieSBkZXZfaW9tbXUgbG9jay4NCj4g
Pg0KPiANCj4gQWgsIGRvIHlvdSBtaW5kIGVsYWJvcmF0aW5nIGEgYml0IG1vcmU/IEluIG15IG1p
bmQsIHBhcnRpYWwgbGlzdCBpcw0KPiBwcm90ZWN0ZWQgYnkgZGV2X2lvbW11LT5mYXVsdF9wYXJh
bS0+bG9jay4NCj4gDQoNCndlbGwsIGl0J3Mgbm90IGhvdyB0aGUgY29kZSBpcyBjdXJyZW50bHkg
d3JpdHRlbi4gaW9tbXVfcXVldWVfaW9wZigpDQpkb2Vzbid0IGhvbGQgZGV2X2lvbW11LT5mYXVs
dF9wYXJhbS0+bG9jayB0byB1cGRhdGUgdGhlIHBhcnRpYWwNCmxpc3QuIA0KDQp3aGlsZSBhdCBp
dCBsb29rcyB0aGVyZSBpcyBhbHNvIGEgbWlzbG9ja2luZyBpbiBpb3BmX3F1ZXVlX2Rpc2NhcmRf
cGFydGlhbCgpDQp3aGljaCBvbmx5IGFjcXVpcmVzIHF1ZXVlLT5sb2NrLg0KDQpTbyB3ZSBoYXZl
IHRocmVlIHBsYWNlcyB0b3VjaGluZyB0aGUgcGFydGlhbCBsaXN0IGFsbCB3aXRoIGRpZmZlcmVu
dCBsb2NrczoNCg0KLSBpb21tdV9xdWV1ZV9pb3BmKCkgcmVsaWVzIG9uIGRldl9pb21tdS0+bG9j
aw0KLSBpb3BmX3F1ZXVlX2Rpc2NhcmRfcGFydGlhbCgpIHJlbGllcyBvbiBxdWV1ZS0+bG9jaw0K
LSB0aGlzIG5ldyBhc3NlcnQgZnVuY3Rpb24gdXNlcyBkZXZfaW9tbXUtPmZhdWx0X3BhcmFtLT5s
b2NrDQoNCg0K
