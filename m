Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD296F9077
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjEFINz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 04:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEFINy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 04:13:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BB09EF9;
        Sat,  6 May 2023 01:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683360833; x=1714896833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zOHC+tFXpfzeAR4cwluAHkDA8fpWAYvLS1mC0DlYVx8=;
  b=Bj8vNgHDMnjUrNIrtQsamvkdPSh6FjDASHJZ2L3raLs2N3h0RZZ6LBAG
   2sY1z204cM7kvv2FcW9KedzUVgvR6Ic7I6HEtXhMo2TTlYZkz+NKwHsLd
   6bVpKRA34c3DYpmKRyESDR5zOyLpFpSTkZE5UiNH8pwSWTgztife18bAS
   DhtVwu58uGN7UXMHjdUkOtEDdiWS+PJI5qpdpSrpdKR9d4rCWfRjqz1WF
   MjoEX5h/H4UM04i/tHZI+zMU5/IqJ7svxZqekR7uOSEO54ppROa8KN/3j
   LeqjV5OSImhx7/nfY4cZ0LvWUfb87td6neyoShckbWcGmKxs42xmHv8bK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="352414598"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="352414598"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2023 01:13:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="700771129"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="700771129"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 06 May 2023 01:13:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 01:13:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 6 May 2023 01:13:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 6 May 2023 01:13:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 6 May 2023 01:13:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWc62PuaVkU/upWRjz0YvV0iQFKT0AeLRgShbfJnlZi3Y/wm5vAPeE5+P3fhuHdOyZu8u72HCY+2UVwC8UZ+hB8yVQafuaV/QxDKiXX+jku8UhljZsH+Hd5ZL59dzR1Z9HuQuYOAYDbPSywWeBcgVy7jHUPAAk32dYdq9/Bafbm2ibMBf6JFx7rzURcrDxjdABsalirCbBxXE29zteQX/vRfQ1t/qjdXlyXLIkFzmInYLg/6b4EiD2G+XAzg+Xi+WmX/jnM973nYmplZ6/fmnC7Nk0RPJ6YaPoqV9Go7UlLBOl/Op72Ely5HhdJ2KVRh3WUAbutw4Q5FUFD8AguNfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOHC+tFXpfzeAR4cwluAHkDA8fpWAYvLS1mC0DlYVx8=;
 b=ONt6QQKUDPfZCE3aU0q4BPZtzvGqZnUgzgt5C0mQNJA2bC3sIWfFYlXVLcLnjWVnHHfcKVmSQyxBJWMRJnwPnuc/c7LjbqmOWalh7F24XM/nyHLdaaxY9Xoc7tUs7dDvhfXAOZnwmmQAtnsa1fYhUjGHISuCe7RYlJULY6WY6uYfJUjJksnBmHm9UuTJlNanbqmsASQwaNWbWMj3wLa5DUnW/hQDj7Ds9fpkQvR8Sx/7ZPEN38gGHRFttr/LkwUfOECreklEEQNhpOCW5NeSoTv0bArjVknO+S3bBdrs0mH73viBbaYJhuYiJUL6Hw5IrMaDGwL5CGTS3ruCkFIGqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5562.namprd11.prod.outlook.com (2603:10b6:610:d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 08:13:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 08:13:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Topic: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Index: AQHZeS7NjeBSeWLT50GaZQKxGXZCA69ARxSQgADG4ICACkQGoIAAp64AgAD5QSA=
Date:   Sat, 6 May 2023 08:13:49 +0000
Message-ID: <BN9PR11MB5276FB14B00352802562C6308C739@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
 <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ca71f97e-ce0b-945e-4e86-49f485fa7d5b@intel.com>
In-Reply-To: <ca71f97e-ce0b-945e-4e86-49f485fa7d5b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5562:EE_
x-ms-office365-filtering-correlation-id: 9fe6ee36-7117-4c18-8453-08db4e09d27f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fhaph2PzkwTZ4qTz7PJh0r5u0bzsqJzgevQg7fN3XS440pv/VIhN/ojr8HeuqlL/B/uOlgL6cEgRUvBSag/O87JOAW7Zc9mqY0EzgOsYUs5HTDms6kHsBbhJvNPgf1xm4TuGFJ26SDdj6c8KrJs2pMjsbZEVyfp6keb85po+LAzYNBLiyFbIQtu9bF6zSQ0X8XJnRl6yFGqh7J8l3l6lPm01ezLgju+xUGybRNhwTxLPuXLpcO2nGzVIiDPx9dhsmDmOPYhbO+tQrikFiSL9e15aNHOR1Ai5KdBut+EnG2PAYGMMEbbopThLUOAaI1Px680RdSGyBA9zdSrs2TmjFTYJu9KbNiIWJvt5pBAWWs1NfIwuiRTX3/W//NFTVe24F+3czK2zlO+PMdPjqCeEMN2pGyEgJl1kwWJ4cc9xoBVmj1uLP37j7+cV0X5RjbYFiFLN/oT3lvG9z3ffrhXbHZa1th9XUSjf6AgbY0f6FLFif3F39WqgrOs9Wpfb440kT2F95gOtfxi7nwkQKJXvrGFKpqQeCSI2m/knbv2OgEb+49jifeK62eZEf06okRWPWecV1zVEJ4BBb01Om9CfIBy6JvUaXDGvtsTEg+VGyZ1XmvhBNUvVeQMAgHVW5VP9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(71200400001)(7696005)(83380400001)(55016003)(186003)(122000001)(38100700002)(86362001)(38070700005)(33656002)(82960400001)(6506007)(9686003)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(4744005)(2906002)(76116006)(54906003)(110136005)(41300700001)(52536014)(5660300002)(316002)(8676002)(8936002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnhzTEpYZVVCUGRjVUR2WE9OMTJyS1dWY25ncnFKbkNWb0Z5Q3BQMzBKWG15?=
 =?utf-8?B?SWE3cGtCb1p0WEY1NWljZk84V3N3NHkxdllLZ0g4ZnAxaXlrS0wyMmtBVko5?=
 =?utf-8?B?WE04RTBMTndETER6L0piSkNlcm8yWVFSdzNUOVZTdFlRbGFFREVRMWw2VEtl?=
 =?utf-8?B?ejdyTGdTbWMwWmthUUdvUTByTEFMQkd6NE02U01tQ2hTR2Nic0h5dGlPWlBw?=
 =?utf-8?B?VGFyaW44L2c3K21iNmhSL0tsVWloa2plNVRUd0R4c0lFa2hxbHhUQ2dkaHF3?=
 =?utf-8?B?ZGtWMjQ0MTY4cG9Bc3JzSnppNlpLS0RpS1d3MWNkcEZkdnY3UG1PTXUzZkcw?=
 =?utf-8?B?MlE5bkhENjR6V1R4U3NRYnJxcUNDcmZvVmZqNlJDeHV6Y3R0bTN0a2lZQ2ll?=
 =?utf-8?B?SHRFUGJEc3VsTlVLSklpckJvckk2WHl4WWhQdDE1U0NEZm1GMThVRGg3M2l1?=
 =?utf-8?B?NDduVVVyVEo1QTQzQXJVeG40OUlvTFRCcTEySTEzWXV3djBNRWw5VDNBQ3Zr?=
 =?utf-8?B?eVo2M0JqeFBwTlhnVlFmRktHLzVFV2xxbExibVRpYUVRcEpuWldmbmozdEh0?=
 =?utf-8?B?MVFNUlpnZGRsMllHQ3Rxekg4R1FOOVBNeTJ0dFA1emNpSWQvV0szT1NrMFhu?=
 =?utf-8?B?OGQrclNQVDBRTVNxOG1QU3o5OGdOUjcwU3RNT0g5b2NBU2xXYTdXSmUrdFNu?=
 =?utf-8?B?MTFuR1pMc3g2OGQydWdrR2lxNjM1STZva2tOelNHaitHTGIxaWU1aTJpV2N5?=
 =?utf-8?B?eG90ay8zT2pZUG9VbjZkRjRaVUdRY3NRV2x6RXRPOEE3L21MSG93KzlsQk5I?=
 =?utf-8?B?bVVrWHlMdmkrZmt0RzlVOVlDaEhFYXQ5dW9nNnFPOHRVSnZpaWFocW1UTVpw?=
 =?utf-8?B?aXlxVGdtUE14NU5JTERYL1NMWDF0TzRwaUNtREFQS25ITE9KL2NEYXJhSEkw?=
 =?utf-8?B?a2pXREJJZnRweFMzSGRRWm5DUXhQUmlQbWhjeU1yS0hrWlozSnB0dVhzZzZH?=
 =?utf-8?B?SFJzRXRzM1c5TVVZRWNMNThBSXFGdXFCOWt4Ti9WWG9CQi83ZTI1SnlxeFdp?=
 =?utf-8?B?VS9LWm40OEZDQy9xaXc5WCtyQW5UZkE0NWNWUXByMGxVbm1lbWxXMFc3M3JS?=
 =?utf-8?B?NWxRQ1NkNVl3ZWhBaFdPdmxzM3YweEsrNWtFdmV0ZnkvZ2U2SGNndTNGN1Ry?=
 =?utf-8?B?TWVudzk3Uy9ydnQvamlvWmZOcEFsMXN3WmF2c2ZnWXZ2NXFlenNxY01NSG5v?=
 =?utf-8?B?dXhvU1N6WFJGUnJMa05BTE9ZTmcvTEVEYUVhOUk0TVFkVytnQjd0VlVvblFs?=
 =?utf-8?B?L1JEdHlTY2x6UWlDTXhTQU5OTHd6MnNGOFBsMlFCZjhxejJyc0dWR0QvUDRZ?=
 =?utf-8?B?TmdGRzhUUng1bHJaQklURzQ2WHROT1k1QnJTS3pIWGtWaWRUMXdEdE5Lcmp5?=
 =?utf-8?B?UmNPRXppeXBYODUxKzNNTEZQNzMrRnBVU0tyWU94TkFrV2dFWDAwaHQvdWla?=
 =?utf-8?B?Wi9ORlY1VTFWL2htdG5kQVBCNVYxWUdEWjJoUzNYQXBDMkE2OVBkUlZuMEVi?=
 =?utf-8?B?aUtBUUlNUVd0U2ZqNlY0V1NXSFdmTUhvajV2S0pVR2NEZ3NFTUhzMTNwUk5D?=
 =?utf-8?B?VVdFWnlQNTVYV0dFcHVyajgyMUdvK3RNR1pOY1JaemVENEhuTHVtT29GRUF5?=
 =?utf-8?B?NGZOTCtzYUh5Zm41dnN6TDBjQXVqcUx4UlNaazRoSHJQY2dnU2MzY1dPa2lv?=
 =?utf-8?B?bWRjOVJMRmJyVWxManZhNk45SGc3YVpFT002WHlzRUhCRzNYd2wxdkcydWVq?=
 =?utf-8?B?OTB2WVpJa0djUmJaUHhsSittK3dCUFB5ZTBLTHFPZFRoVis3RTAwWTV0ZVBy?=
 =?utf-8?B?a2ZFVFpOWVVhQnB1MjB0aW5mMDR3cHhYbjhtaml0TUxwVjR6M1dEODl6SHRS?=
 =?utf-8?B?S1hGRlc2QTIrMDZzRXk1NnRNWDRxemliQWY1aCtXb1NzeWdzenB3MGZHWDh0?=
 =?utf-8?B?VnA5U01tdit3L0ZXb2k5L0ZGbDRWRHNTRjk2RjNPZ2RkYmRTbkZLZG5NVmxZ?=
 =?utf-8?B?TWZaVDVOZ05tNW9lWERZYUV4WkhIYnI3S1JDWUxhT2JaQkhRMHdzczFFeXFq?=
 =?utf-8?Q?4Dy8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe6ee36-7117-4c18-8453-08db4e09d27f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2023 08:13:49.6115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u70CqjyACgyHgWlMmLes0CfUEeVNtKV1cdQXgiIjgcGAUE7JHYYOCprXQxeg+sE69xMM5uowqJ+WDufQP+RpmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5562
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBDaGF0cmUsIFJlaW5ldHRlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgTWF5IDYsIDIwMjMgMToyMSBBTQ0KPiANCj4gV291bGQgeW91IGJlIG9r
IHdpdGggc29tZXRoaW5nIGxpa2UgYmVsb3c/DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92
ZmlvL3BjaS92ZmlvX3BjaV9pbnRycy5jIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9pbnRy
cy5jDQo+IGluZGV4IGI1NDlmNWM5N2NiOC4uYThlOTYyNTRmOTUzIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2ludHJzLmMNCj4gKysrIGIvZHJpdmVycy92ZmlvL3Bj
aS92ZmlvX3BjaV9pbnRycy5jDQo+IEBAIC0zOTMsNiArMzkzLDggQEAgc3RhdGljIGludCB2Zmlv
X21zaV9hbGxvY19pcnEoc3RydWN0DQo+IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LA0KPiAg
CXUxNiBjbWQ7DQo+IA0KPiAgCWlycSA9IHBjaV9pcnFfdmVjdG9yKHBkZXYsIHZlY3Rvcik7DQo+
ICsJaWYgKFdBUk5fT05fT05DRShpcnEgPT0gMCkpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiAg
CWlmIChpcnEgPiAwIHx8ICFtc2l4IHx8ICF2ZGV2LT5oYXNfZHluX21zaXgpDQo+ICAJCXJldHVy
biBpcnE7DQo+IA0KPiBJIHdvdWxkIHByZWZlciB0aGF0IHZmaW9fbXNpX2FsbG9jX2lycSgpIHJl
dHVybnMgbmVnYXRpdmUgZXJyb3JzLiBUaGlzIGVuYWJsZXMNCj4gY2FsbGVycyB0byBpbiB0dXJu
IGp1c3QgcmV0dXJuIHRoZSBlcnJvciBjb2RlIG9uIGZhaWx1cmUgKG5vdGUgdGhhdCBkeW5hbWlj
DQo+IGFsbG9jYXRpb24gY2FuIHJldHVybiBkaWZmZXJlbnQgZXJyb3IgY29kZXMpLCBub3QgbmVl
ZGluZyB0byB0cmFuc2xhdGUgMCBpbnRvDQo+IGFuIGVycm9yLg0KPiANCg0KVGhpcyBsb29rcyBn
b29kIHRvIG1lLiBUaGFua3MuDQo=
