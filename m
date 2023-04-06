Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712946D920D
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbjDFIy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDFIy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:54:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8904EFD;
        Thu,  6 Apr 2023 01:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680771296; x=1712307296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tJfFHPm9i1fzbZEp/ixaVYXgigXd7OgTQ2sNSQUecIw=;
  b=UEGt3W0kpZKMlsSUtC9W5kXVtd/hGKO/kcc0YER15aT5hGH2awbr56uJ
   sPoZyxsjyQljUAt34BoxbYNqh8CFmA8bUhjaj4FmYvlbE3DzdG3Fn61dd
   spqn+LYfjko0P0EkWnGsuwcnhnopxvVZdC07mZ/zkp2mZjFaAKqLZatd0
   LBJELwdaZGVeLz1YJ0EyvxGeTUIfp58x+4LFKwUIlso4Rr6pufLJvYLYN
   TOU333PPemU8WnztjyOpHsYjuoWsWN5bkD4y6K5e0EuQbaLD0Zr0i+d7m
   GgSvMwLN1GLm+mpJri+ph8XGlS8s/D7P5J4ZN0rfsfj5K6PVGMR7Yy3R4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="345282613"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="345282613"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 01:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="798246432"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="798246432"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2023 01:54:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 01:54:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 01:54:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 01:54:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 01:54:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIg+ib8LtagG1amkS53w+zPQWxC3t81TePekU+5J3mKLYnm5otC7Zk7lN+IGew2lfjp9fxTUlNlTY2KUg8Nz4fgT+FO0zZT6Z8epFFr5uc+JzvkLFDHNmKXDbHhjcp0w6p7Yz9Y3jq+7EuWNU9tZ1+PfJVjEG9SpnKJOnMaEhkWcMd17AO0BhCKm0Vx+RaEL5aX+65BybAJ2+05Qrj3XfJB9CF+QR0jQUHidc5WQdMfsIb4aoI8yrMPr0ySagIy8/qYRSp+0jSJ6vWLIM9S8EOGfXx0R6QbzmBQIEIk1LxvVcwX81mf4G2SRnbN2WROwCJAPUYAHbLWuFaUdxBVPmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJfFHPm9i1fzbZEp/ixaVYXgigXd7OgTQ2sNSQUecIw=;
 b=VAvR3HCNIY7tNvkkqthLkAXJ1kyRyXGC6jHEB1ImW/KxzUnnVZ7KfJaTnx0eDgWzi11lzCs2xv2TkaYzG0cWa3pU8QM6eRok+P5loFPM3CxnNlRdUR/019W4Ey9j72yv5HpGgr2LLO0rMBwQ/pTZixfeSzZ8EZK+1ye1P+Gyoc9SXLXkVeI9rkvGdtoCP6SXmaQNvNnDHpS+a42SiEdJvi2WZe2xdHOzESRAO2eFUQK6GRu/VHHoaXpO2HcdfO1zBS3OaqrncA+nJPXqd1sxRi+P0N6mRyggGnvI9Wd0YRxQOJwRU3cXgN0GQ3eaGlyz2MLJbbsD6GSQuEK6dFYGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7391.namprd11.prod.outlook.com (2603:10b6:610:151::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Thu, 6 Apr
 2023 08:54:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 08:54:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Inject #GP on ENCLS if vCPU has paging
 disabled (CR0.PG==0)
Thread-Topic: [PATCH 1/2] KVM: VMX: Inject #GP on ENCLS if vCPU has paging
 disabled (CR0.PG==0)
Thread-Index: AQHZaBjTnv3Xw4rSL0WDrKfMqYpF1K8d+rGA
Date:   Thu, 6 Apr 2023 08:54:52 +0000
Message-ID: <082ff217ecb7633ef4c1363bfd27a20f8afcbe0c.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
         <20230405234556.696927-2-seanjc@google.com>
In-Reply-To: <20230405234556.696927-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7391:EE_
x-ms-office365-filtering-correlation-id: 58c79758-db45-485d-4589-08db367c95fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Da9rMEySdH6LHhnx0ZdsfOirfehrbjBui7a8hShcDllthKqizFT7lCyLhF6b4M841VjroPxYMsMvcLM60xbyXZxlbTJg66AGPdJC8wO3ulNk6+VqOpUBiaVZhdRParpfAcOXA6/b3hcAOkjdb4P1fAT7vPU/ab7mF85rOWSwTCJ/wPiZdTMJePc7sgMc6lWcSZu9tsx3l36gJH0c0rewsAB4YJwZ3FXSWiEX+Tpxh5Yg6kX0Ef0D4WuPkBvE8ApP8gxsnYXFkf+OTLSZpUl38DbuiLmViLwOpNEypXVqNjNzPCM+b6aTyCun/ydSIAfkv+YAdgY+dn+4atLEFQhaAx8JAEBjTm8IuBNkSw72ZtcTUYojd575enNFEephUWpz7WzW/IrYeo/H4Ow7HRWmNRWqrQlJjPUkCQ8YSlhYl+hS7z+mNOtTOPpbF4+QD9XrDmdrmI09PhEwPOtg+rbzaATxnVbW4XkiVRgSCaEEtcXOUZ09xrgb+KKqoZnIuatVBXB1wtx41mXLdhAQlj3B/gW9G+pRZKD0bGaXR7dbXIJBAFqs8206wimo05ICjPwJ2ZWtAh3KCUYkKydZ3Ig73RzxxrB4zQNJXNMKjSMka/5Rk2I7LbGW4OFgLLioh6SI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(186003)(41300700001)(2616005)(66446008)(91956017)(64756008)(66556008)(66476007)(4326008)(66946007)(8676002)(76116006)(71200400001)(2906002)(36756003)(38100700002)(6486002)(122000001)(86362001)(38070700005)(82960400001)(83380400001)(110136005)(5660300002)(8936002)(316002)(54906003)(478600001)(6512007)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlhnVWx4dkdWaVB0d0V1WnVUczI5UmtIZ0FxQVhGRUk3MXNwNkswWFVHMzRB?=
 =?utf-8?B?ZDg4RmhCVTZzZlpsSm0xZVV3SmNHeTAxZk5iSEg0UTlvOE5DVHZTNS9pbU5s?=
 =?utf-8?B?Sm03cUZhVXFJa29IZXNwTytwVW5oUWNRUUIvRi80d29Vcko3QXVxWkViVHF5?=
 =?utf-8?B?OEpocTNiTEYyelV3OGhpeXVMbXBqZXIvUFUvTld2TkMrRStaOWZ0M00wWjMr?=
 =?utf-8?B?R0loNkJZMkdwZllXbmNPYmlEZUNZbUJ1N21mZWlnUml0MXV5RW9jekFsNHJ4?=
 =?utf-8?B?dEtmZDZDVXdYWm9QUlI5M2pWOWJ3Q21mMmRuTi91bWxZTG9Mb3I3Vm9TbGRw?=
 =?utf-8?B?NEl1Nis2cWg1eHp4bktzM2RwTENpa05uR3EwL05ObzUyQ284Nk53RS9jM0Fy?=
 =?utf-8?B?YktsTDFjVHhIaWFETDl3TzVxNlU1OVRQNldZR1AyNDhEeWFjcnBNUGE4UG1Q?=
 =?utf-8?B?WCt5dDZSeFpqeTZzeDZ6NHZYZ1NBWk1TdWZ6eVdIa0NPa2xaK1puZmlZZlJr?=
 =?utf-8?B?SzZZS01OWEIxZUFUMmJzNUJ4T1RmTS8rSXdiU2VGNDdBblVjTUE1aWRON1Jw?=
 =?utf-8?B?OFE4QkVkSFJidWh3Z1dNaThGRGU5RjVzM3J6bkF5RU90ZmhHZ3daOXk5T1Uv?=
 =?utf-8?B?UHdGL1FIdWlWQldDOE53UjJ3dkY4QXhWczZWamR3WWFmeHFmdEF3VGZIaDFk?=
 =?utf-8?B?ZlV3b2t3N1U5Mk1ERnV6dDZFVVFFS2dEa3EvR0taY2JnL3JZTEJWSnpHc3lJ?=
 =?utf-8?B?RkxXSm9iblQ5aThTbTA2WUUzSmZaeTVkdjVTMFcxVTA4TE4rWXREZ2wzK1FM?=
 =?utf-8?B?K2ZkVlhkNTRpaDdESEQzMTBKSU5KbUNUQ3hKRi9pdlJpTk1YZmpYNVU5eEk3?=
 =?utf-8?B?OGZvTE4rOVFBWEVRRk9MQzZjNGVYbFJiUytrMFN5eU1RbG5ySXJ4K2p3Mmdm?=
 =?utf-8?B?WHFmbjArb2JnT2JaUEJGc2VOckVpbWVWZnF6NEtUZ0RyV0toVmxzdWNwQkNT?=
 =?utf-8?B?L1N5YW40dTU0N0FhUjhHaUJlVlBITUxieWRsTlVlOVRINHkrTFJQNlRuUjlO?=
 =?utf-8?B?VUdEV1BoYW84VDEvd2wra3IwYlg2RjBBVFN3WlpjNWp6TSs4aHNac1h2RU5w?=
 =?utf-8?B?UTVaNE1iK2w0bHZ0UmNzbldaOXVabjZZaDNoT3dZaFZ0bUNNWFQvYVd2b3Bw?=
 =?utf-8?B?bDVwMDkzOEgrMlRheDg4OGRSTyttWGRxMWpxVHR4MTZJcWdzUFNHNUVocnlR?=
 =?utf-8?B?anllVytUeFNhaityNW4xZHBTY3VtdXA2NEJObnZoanNhc2Q3NURKVSsrc2FR?=
 =?utf-8?B?dnZEOGtsUGFsZnMyOFhDa3I0V1Jla0ZDY1FLVkFiRU9idkR5R2l4SEIrRGpC?=
 =?utf-8?B?U0R5YkVLMlVpNkE3TDA5QlhMejZsR2c1aFRnaHBoWGhkZHFZSmFNeCtEdU1x?=
 =?utf-8?B?U1NKbkdGWkpibkoxS0RBVllhWVJYUEovWWJXQ1YvR2RjMUNybXhNTng4RWpz?=
 =?utf-8?B?alpoWFZ0Z2poclFoV3ozU25saTA3ck91RGZUZ2ltSDV1UVd0c3g4SUp0YzRt?=
 =?utf-8?B?dXAxY1hyU3BGdVFLOWdYN2J4dXcwMElnb2tpc2RDN216WFdrM3gzWDlvNnFW?=
 =?utf-8?B?djdQVHBFSStXQk9qYWlUTFkvajJkTVpGdXRrNHVmdWlUeDZPTlVUQVY0WmJz?=
 =?utf-8?B?cGsvbE1vQ2RiR2c1azBGRHBOTytwbmV1MXJ1eTZhSmh3RGo0c0N4K3BtVlpR?=
 =?utf-8?B?dzJsQ1dUam9FZGRMeXJxTDhiaXkya1U2bzZ1NEhrWmVuVG82TU1BTjduVXJS?=
 =?utf-8?B?Nmd5b01QZFppcXlaMFEvVEpVV2F3MENacHNCR25vdExZOUJnaUh4OGNsamNr?=
 =?utf-8?B?clNVbXg4akVYRnFWMDJPUm1XcHhLWGFvUy9lYVJCclVDUVJ2M1FMVkxOV005?=
 =?utf-8?B?MzdBZkpHVFhTbTBCSVMyRlQ2UEgrWkpxUWIwRDVKcm9IUFVXQjljS1huUjhM?=
 =?utf-8?B?Zko4QjJPa29CY01BcjhFSWx6b1FBRFJvbVJkOFZLS3JWRzh0QWpqeDE1M0ZS?=
 =?utf-8?B?THFKcWlkVjJFWEprWkRxcXVMY09zQnUzMitsWlJjVHFMcnNnQjQ3Tko0RlNL?=
 =?utf-8?Q?vH73779ToJ0SArTt36NDb692N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A91F758E828D2E4D9D706B8DB7609036@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c79758-db45-485d-4589-08db367c95fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 08:54:52.2976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cydHqDmG/iFKJt0jFq0zgdsfZ1zyfSAlW8SzvKpl/LfafQN8WKqzT9mNpe/RNbsyQ88zdNQHtIECCwpOJtw+CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7391
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTA1IGF0IDE2OjQ1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBJbmplY3QgYSAjR1Agd2hlbiBlbXVsYXRpbmcvZm9yd2FyZGluZyBhIHZhbGlkIEVO
Q0xTIGxlYWYgaWYgdGhlIHZDUFUgaGFzDQo+IHBhZ2luZyBkaXNhYmxlZCwgZS5nLiBpZiBLVk0g
aXMgaW50ZXJjZXB0aW5nIEVDUkVBVEUgdG8gZW5mb3JjZSBhZGRpdGlvbmFsDQo+IHJlc3RyaWN0
aW9ucy4gIFRoZSBwc2V1ZG9jb2RlIGluIHRoZSBTRE0gbGlzdHMgYWxsICNHUCB0cmlnZ2Vycywg
aW5jbHVkaW5nDQo+IENSMC5QRz0wLCBhcyBiZWluZyBjaGVja2VkIGFmdGVyIHRoZSBFTkxDUy1l
eGl0aW5nIGNoZWNrcywgaS5lLiB0aGUNCj4gVk0tRXhpdCB3aWxsIG9jY3VyIGJlZm9yZSB0aGUg
Q1BVIHBlcmZvcm1zIHRoZSBDUjAuUEcgY2hlY2suDQo+IA0KPiBGaXhlczogNzAyMTBjMDQ0YjRl
ICgiS1ZNOiBWTVg6IEFkZCBTR1ggRU5DTFNbRUNSRUFURV0gaGFuZGxlciB0byBlbmZvcmNlIENQ
VUlEIHJlc3RyaWN0aW9ucyIpDQo+IENjOiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRl
bC5jb20+DQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdl
ZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC94
ODYva3ZtL3ZteC9zZ3guYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvc2d4
LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3NneC5jDQo+IGluZGV4IGFhNTNjOTgwMzRiZi4uZjg4MWY2
ZmY2NDA4IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3NneC5jDQo+ICsrKyBiL2Fy
Y2gveDg2L2t2bS92bXgvc2d4LmMNCj4gQEAgLTM3NSw3ICszNzUsNyBAQCBpbnQgaGFuZGxlX2Vu
Y2xzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIA0KPiAgCWlmICghZW5jbHNfbGVhZl9lbmFi
bGVkX2luX2d1ZXN0KHZjcHUsIGxlYWYpKSB7DQo+ICAJCWt2bV9xdWV1ZV9leGNlcHRpb24odmNw
dSwgVURfVkVDVE9SKTsNCj4gLQl9IGVsc2UgaWYgKCFzZ3hfZW5hYmxlZF9pbl9ndWVzdF9iaW9z
KHZjcHUpKSB7DQo+ICsJfSBlbHNlIGlmICghc2d4X2VuYWJsZWRfaW5fZ3Vlc3RfYmlvcyh2Y3B1
KSB8fCAhaXNfcGFnaW5nKHZjcHUpKSB7DQo+ICAJCWt2bV9pbmplY3RfZ3AodmNwdSwgMCk7DQo+
ICAJfSBlbHNlIHsNCj4gIAkJaWYgKGxlYWYgPT0gRUNSRUFURSkNCj4gLS0gDQo+IDIuNDAuMC4z
NDguZ2Y5MzhiMDkzNjYtZ29vZw0KPiANCg0K
