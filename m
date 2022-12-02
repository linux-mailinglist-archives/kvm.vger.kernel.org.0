Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D3C641041
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 22:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiLBV5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 16:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiLBV45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 16:56:57 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B85F1CE0;
        Fri,  2 Dec 2022 13:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670018216; x=1701554216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+aelBun0nbxQl4TgaDlIGK4ieSrpRqw2v9cOMTGKtmQ=;
  b=YzBuyFWsvXAIW9v69dHEIfw4qcEkK4b4fpYR928n5GC2Za/L8qKnlu+t
   WrqSGMIK8jFP/FjB/+q3m/E9fc0Wuj8n+Y1oPhg7rtAYOeGXVi2C/kDhJ
   6+MdY+lqFgNfRPEYuHyOcLl49JSf4CrG0YlJWGrNjzdyxYObsOn1ordpP
   tVvlNxq95m4i1YX9e0FpfQwkJZsP6JrhbXibh7xfw9bUB1TqSa/97h/DW
   HLxAGXxzCxYrxrrCfqO9TfM+R9EoKuiTM1pz/jewZxVEPRyJZ+e3LYAJ/
   8C8aTJg6D3DTgjnq++YoXTIn0w7xUOzYqfk17juZVvyUk0kOZVuMV2tXb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="314761640"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="314761640"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 13:56:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="769742186"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="769742186"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2022 13:56:55 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 13:56:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 13:56:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 13:56:54 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 13:56:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3NTM1cJOvj+39q1HUDaclW/W7ADLhAMWIKDx+uugaKeD3/EBH57Q4sCla9XbOrVNJxIqm7mmBpKK8iwKfhAUB3buf0FYxtfFEKgoJlIPs4/z5RK0hJVZx8qtZXRflzpUgFBryGe1vx98zrxyxWckzmoUNUg6IoSAjZIqx3bH2q6Be2uX1Tg1bOMKJYll6mwX2WyzejfPBd/JpCXVXWFjPsm7k7YQkUAnIl9sHVj3pCbqnyd1dTM4BbTiQ+93NNkBMPrjmpnt+NDZ7szaqBHpJb8dUyHVEnmISb/Pw10ftKHAGosU/OEc/BGCtSapqa+I/3ar78W4xJSlgD9oYCQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aelBun0nbxQl4TgaDlIGK4ieSrpRqw2v9cOMTGKtmQ=;
 b=SpVpCj84SAJbcjZ/7DYj1fpXLEGv3v63DNZhLJJRFenJ3cKKGn6NS/DqZXus56hoeqcZ7BQI1i6kh1N9/6kICKb66eMofX8FdLFh5VLxwbjA/1K1Z1H7CH82NCPOVqmTSl83Yc+I20QcWly4/rKF5L0EZDD69jq0xBRb99VexvWj3xB3IOF7xJj9DzhfH+UJfETR4540u2cA2Jp/5m4e4AnMBY7H76x4p64wzuhUsfiiACKbMMTLSBffZAZ4u5aiH//RVAr+4XGXQ3pw47w2FmRdAUBQsTXmisrfT3YBWo84OeUnI5JFuqWGHIzclC3sJhKR0j6/iH/8QbD81lSpZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7389.namprd11.prod.outlook.com (2603:10b6:610:14d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 21:56:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 21:56:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHY/T3BkERrb6yHxUStNPJD5vkcxK5LnNIAgA7mZACAAGMHAIAAUTsA
Date:   Fri, 2 Dec 2022 21:56:49 +0000
Message-ID: <d55cb607566e43ea6522f0aeb6fe7c10628dd950.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
         <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
         <8f3b1492aefc37f6bdcd8a10051af57c7deb4430.camel@intel.com>
         <21b43adc-37aa-bac3-0615-4703438ea4a1@intel.com>
In-Reply-To: <21b43adc-37aa-bac3-0615-4703438ea4a1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7389:EE_
x-ms-office365-filtering-correlation-id: cc104cc6-0a0c-435c-8227-08dad4b01d70
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bXkENy9wiLkaVvG9BHb7XpAdVdU8Tjms6ow7NP7q/isBHuna9P4iN1TrUsceLoFqBeSBmZJVfeHnf2S2Zg2XSMgxs84Gyna3FLr2d0GffuwrWkRPpvwyxXRruhnBMTbX4H3ar8HiFreswZ9/FPMQr9439UQKcPuActd03UqQSOilm9JM5ROv4+I0XBOqmKpZ127ydtVN1jA5CzaPSNnrK7dp3E84vywswH60m2wLBxEsP42+Z7m0oywD6d0lSKHuHTNPPoqWndQ/9OZmY+9NR3dQNrsKC2gLsTHSggHADjhodo2wjK3Pj1ImedKjA4CZRk4Nx7DHhtX1bbeuPA3FvoKbJunY+2Ol6Cu2M0hcDXAWfOwZd2vi/QWakwRv9Y3tUSkUIbGApwEh3xDxyro+htqTXhZ4OMeLAh8TTmeHW+Psmgn8G6YeNvBd7tGrxNqoCokc9b4eVVv5x8frFA2Bv9JCqx1JpOEqUs+WVZMIvTjGifNHB/OUEWkIMvA3MXAPS5QwTrofiUb/s1++9BGQzO61S1wUmhfRV0BwoRE3q3MpNZu3ZstWu6jPekUFnPPVbVQ4DOTg6mxsasl7eZeJSayXQufB7OZ7vETjSprH+hZcJGTYAK7EiODTCrL3GtXsrTIhebIC6n3CKaVf7/IXRpRjlFAENiUDODclzufsWjzan2lYFbp9uZDjdLy1p4GIO+v/uSCY4xN0nwQlHc4NPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(38070700005)(86362001)(6486002)(71200400001)(6506007)(122000001)(6512007)(26005)(36756003)(54906003)(91956017)(7416002)(41300700001)(66556008)(478600001)(8936002)(66446008)(53546011)(2906002)(8676002)(4326008)(66946007)(66476007)(64756008)(316002)(76116006)(82960400001)(110136005)(186003)(5660300002)(2616005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3NVcmRqSy9lVFd6d3NOa0VxdlVRN2xNUHRTYUVaNnRwTHpvSGVucFAvRHYv?=
 =?utf-8?B?T09ScHBlbGhybVpXQW9rZ29XZFBkV0svL3ZnNXJmK3RJSENHRDM1akhjOWJ6?=
 =?utf-8?B?RGRHZ0ZEZVhsN3hCME8xVzBCdGFEZ1F6QUFhVkp2RktLcDdlOUVJUFN5L0pU?=
 =?utf-8?B?dUl3QXFqQksvWGgrUzlHYTdaVXhOb1RtNlpqclJaTFdmbUYrQWRSb3hEMUJS?=
 =?utf-8?B?RWw0am9yRDBFUWQvZ3Rhay8vSGdieDMrazZ3QWRZOFNGN1hvNGVYQnFqUkhC?=
 =?utf-8?B?UDU0RUtCOGcvUHdmb1hudEZkenRQeG1MakxEcWFQRUJzSDNwMEc1RllHNmVk?=
 =?utf-8?B?QlZVN2ZJR0trWGN6aC9Ja0djN3ZyZGlualZOWXg2RXRPdEFSOW00aVNYeDNW?=
 =?utf-8?B?WGdYNEp4MzFNRktxdXpreVdHQ2ZrTFFLNnJ2NWFQKzVJYWZMVGNGN2ZWaXBw?=
 =?utf-8?B?YytycUc3dE12TTZYdHN4ZWZnZSsrVDBKTURXU3FmWHMwNUR3MkptNHpRa2ZE?=
 =?utf-8?B?L09GWjdnUldJc20vc01SUkV5dkdTTG1RY1dYWWRjd2hiVnJrRmZ2WnY4ZXB1?=
 =?utf-8?B?RW1sLzRNS3I2S3EwTENhV0dYNytWWktxc0lyUWdMc0xXZlFRWmg0d3MzOS9S?=
 =?utf-8?B?UUZHaW8yQ3lySHJ4YVQxZkp1MzRya2pudTdKUUpTSzdMZHEwQUt2NGlSTGgv?=
 =?utf-8?B?NHB6QncwTG5VUklReVdLTWlseEdGNDVMcTZxT2tBeURUckhRUTdwVTRUSUtN?=
 =?utf-8?B?RzB5U0NoUmhZQlFlQWlITXFuZnlhbDF2NFRKY0lSTWw2RGExVzRPcHZFVk56?=
 =?utf-8?B?a1ZHU2x1NE9wdGRIQzBGT1ZpTzMydWhoVzdFajY3TmpNZmVOdmxsS1J5Uk56?=
 =?utf-8?B?Vk9kRFJwaVR4aVp0azh4bitCNlFIcUpJZlNUT0FYSVZmY2NkaFAyRGpYaGYx?=
 =?utf-8?B?RFhVUFpoYWVPdU56MzNrUkk3NkUzMkhHbnpNQk5OUHZXZkE2WjZyeDN6ZzN0?=
 =?utf-8?B?bXdMSEpvODloMlJFeUNiL2wxWlNTeWhZZUh2cXEyb1ZvYUxOODlFcW52MC81?=
 =?utf-8?B?cXVDZWNvYnl4WlpML1hzUGxlUW81YThZbjhQV090RmtTM21laHNFNzJjKytj?=
 =?utf-8?B?MTUwdWlLOWdBZXZiS05kRUtpRUxzc0h1VGMxeWFyRHdKYU5aUko4bkhEaSs5?=
 =?utf-8?B?bW5Ybkc5c0V2b0k5cWwvTS92OVRmb25tRzlGMHNMUGRzd2lHV01ubnFBei9n?=
 =?utf-8?B?b0VxVzgzMXYrTUl6QVpsdTRPSEVpem5NTUxRdGNrMEJLRiszam15b3JWb3lQ?=
 =?utf-8?B?M1NnU01XRnJwbkFJUHQvVzRJNFhmeGlPbU1aS0c0bDJLZ05uRlpKb3Z5UW14?=
 =?utf-8?B?WmUzKzlSUTJLeWNlVjFaeE54ajVnd0hSejNoVUxEUlZZZ0lkTFoxNUIxRTk1?=
 =?utf-8?B?ZGIwVzRyNDF5TGhyS2MzVklLc1BsQk5FTGEvaERHT2t4T1cvYUJmaGtqUTRp?=
 =?utf-8?B?VWFtUDlsWkZzaUJ3S1pGNHJlbmUxVGpKWGdkSndRb3p6d2Jka0kzZzVtRDNJ?=
 =?utf-8?B?UXNra1UwbGtwNlZKTUlMNTlLU1hwVWNuZUs4NnU5SmN0cEM3cXFzTDNySUdj?=
 =?utf-8?B?RkU3WFlKZUVEdVpDeTF5dm1nQ0dzaEpndktnYW42bTdRaGJFQ21LQ2dINjND?=
 =?utf-8?B?Zk10Nzg5aG54R1RRMjZId1NIcFJUcVQ2NUsxOXVnaERFbDAyU00xYVhhcEpL?=
 =?utf-8?B?dDAwM0dsZVhYdzlSckhuNEM1SVRXOEYrcnBsWG1DVktKNUJ1amlJbXJtUGNE?=
 =?utf-8?B?b1g5SHk5N21UUUJ4WnBncjBaNDNWUVREUnh5UUpUY0p6SFkrRmp0L1VVVWFQ?=
 =?utf-8?B?cmplMEdleVhxc05SOUFEU3RpRng1QW5jbmozTjN3Y3JXTjBQWlhQYmw1QWEx?=
 =?utf-8?B?bXM5YmkyU3gwUkZkdmt6dHllMmEzS1lQb3orYW1ZeW5hRjdYOGM1RzFHeERS?=
 =?utf-8?B?UjBHQndndkJtU2VMV2NkcWNzbHFTUnVIb2praWRaUm9PYlliVWFUZjliRGFG?=
 =?utf-8?B?clVjL3VvU1FrUWQ2RjRSK0VBOC9XWUo4VEtZTmxCemdmNWtKWkZvUnNZbkl5?=
 =?utf-8?B?d3Q0ejdBQlhoQmRUM2NFVXJBRDlmbk9pWjBSa0x3QXdEYWFSTHkwaWZJckZa?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CDD9C3FA66574428C63CA03D5D460B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc104cc6-0a0c-435c-8227-08dad4b01d70
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 21:56:49.8966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hkxxlugMuDA/6dfx65u82bfiNEDBxdUgsEnmMxXeD+6pfWfa3nOyZz3r/ScPJ1FEiPGZkF2KgPnXoP57q6EOjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7389
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDA5OjA2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvMi8yMiAwMzoxMSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBBbmQgYWxzbyB0byBhZGRy
ZXNzIHlvdSBjb25jZXJuIHRoYXQgbm90IGFsbCA4OTIgYnl0ZXMgYXJlIHJlc2VydmVkLCBob3cg
YWJvdXQNCj4gPiBiZWxvdzoNCj4gPiANCj4gPiAgICAgICAgIHVuaW9uIHsNCj4gPiAtICAgICAg
ICAgICAgICAgc3RydWN0IGNwdWlkX2NvbmZpZyAgICAgY3B1aWRfY29uZmlnc1swXTsNCj4gPiAt
ICAgICAgICAgICAgICAgdTggICAgICAgICAgICAgICAgICAgICAgcmVzZXJ2ZWQ1Wzg5Ml07DQo+
ID4gKyAgICAgICAgICAgICAgIERFQ0xBUkVfRkxFWF9BUlJBWShzdHJ1Y3QgY3B1aWRfY29uZmln
LCBjcHVpZF9jb25maWdzKTsNCj4gPiArICAgICAgICAgICAgICAgdTggcGFkZGluZ1s4OTJdOw0K
PiA+ICAgICAgICAgfTsNCj4gPiAgfSBfX3BhY2tlZCBfX2FsaWduZWQoVERTWVNJTkZPX1NUUlVD
VF9BTElHTk1FTlQpOw0KPiA+IA0KPiA+IFRoZSBnb2FsIGlzIHRvIG1ha2UgdGhlIHNpemUgb2Yg
J3N0cnVjdCB0ZHN5c2luZm9fc3RydWN0JyB0byBiZSAxMDI0QiBzbyB3ZSBjYW4NCj4gPiB1c2Ug
YSBzdGF0aWMgdmFyaWFibGUgZm9yIGl0LCBhbmQgYXQgdGhlIG1lYW50aW1lLCBpdCBjYW4gc3Rp
bGwgaGF2ZSAxMDI0Qg0KPiA+IChlbm91Z2ggc3BhY2UpIGZvciB0aGUgVERILlNZUy5JTkZPIHRv
IHdyaXRlIHRvLg0KPiANCj4gSSBqdXN0IGRvbid0IGxpa2UgdGhlIG9wZW4tY29kZWQgc2l6ZXMu
DQo+IA0KPiBGb3IgaW5zdGFuY2UsIHdvdWxkbid0IGl0IGJlIGdyZWF0IGlmIHlvdSBkaWRuJ3Qg
aGF2ZSB0byBrbm93IHRoZSBzaXplDQo+IG9mICpBTllUSElORyogZWxzZSB0byBwcm9wZXJseSBz
aXplIHRoZSAnODkyJz8NCj4gDQo+IE1heWJlIHdlIGp1c3QgbmVlZCBzb21lIGhlbHBlcnMgdG8g
aGlkZSB0aGUgZ3VuazoNCj4gDQo+ICNkZWZpbmUgREVDTEFSRV9QQURERURfU1RSVUNUKHR5cGUs
IG5hbWUsIGFsaWdubWVudCkgCVwNCj4gc3RydWN0IHR5cGUjI19wYWRkZWQgewkJCQkJXA0KPiAJ
dW5pb24gewkJCQkJCVwNCj4gCQlzdHJ1Y3QgdHlwZSBuYW1lOwkJCVwNCj4gCQl1OCBwYWRkaW5n
W2FsaWdubWVudF07CQkJXA0KPiAJfQkJCQkJCVwNCj4gfSBuYW1lIyNfcGFkZGVkOw0KPiANCj4g
I2RlZmluZSBQQURERURfU1RSVUNUKG5hbWUpCShuYW1lIyNfcGFkZGVkLm5hbWUpDQo+IA0KPiBU
aGF0IGNhbiBnZXQgdXNlZCBsaWtlIHRoaXM6DQo+IA0KPiBERUNMQVJFX1BBRERFRF9TVFJVQ1Qo
c3RydWN0IHRkc3lzaW5mb19zdHJ1Y3QsIHRkc3lzaW5mbywNCj4gCQkgICAgICBURFNZU0lORk9f
U1RSVUNUX0FMSUdOTUVOVCk7DQo+IA0KPiANCj4gCXN0cnVjdCB0ZHN5c2luZm9fc3RydWN0IHN5
c2luZm8gPSBQQURERURfU1RSVUNUKHRkc3lzaW5mbykNCg0KVGhhbmtzLiAgV2lsbCB0cnkgb3V0
IHRoaXMgd2F5Lg0K
