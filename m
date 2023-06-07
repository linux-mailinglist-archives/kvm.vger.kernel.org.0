Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C311A7271E7
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjFGWnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjFGWnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:43:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D000119AC;
        Wed,  7 Jun 2023 15:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686177787; x=1717713787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ww7vFj4NCNDkgAkeBy14boLVra0qsEns9YULkYt2ScE=;
  b=Kr2QEvKXsgXOYHNn7kG193vagaIKqkn63dC6krSQoMcQhWS4aObXCFfm
   06BDQfSyfyX7jH1vm5I32qJFWPeO2DW2L7R4dWTyRoDv7yQViFnghFIuC
   i8bGjpkMu+uoFuA/OSIInzd2CQlEmEYrlEa2OBfanlJcC4h/TcA1SLVKF
   8BlZD3MJPJFRDrkxq1ytKueAXDcmSNKbndoj+rv+jKzKPzMDRu47x/l12
   TFcxfOkTKbrWF2QwW2iQoQFUe9AtZpknkUeEVwAlhGSRljr7yo61nmhZi
   7CTdiGrRJbZGQ9ggzHU37eSnRkrvVBi2MlToLWteRXFE4jdQhQG6QTYsW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="420690437"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="420690437"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 15:43:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="822352693"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="822352693"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2023 15:43:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 15:43:06 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 15:43:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 15:43:05 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 15:43:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZI9rO25jzEU/8ZQ/L209hNmfB0QA5LuMSK6Qt0BrgSrEgTqB6eWTHK9pSP0ZZQln1f1gn6+9CtU/2m6I41Ax8gqHwtIaqAnSB9WOmAIpu+XRoCuD7EOJ8nhjgwzFkifdjiLSO57si65T7jyD0dK8d1APA53pDyF7F0L/oCzi8Cm54Zp47qdKuy5nVaP8R8pIe1wiNnzQ8IcFZQggjuZXARML+TPE9KcUu1HnnjE5ZCok0Z2L6WNW5dX+mf0Z+7nKjqvkiOsLlznNYnUAhJpb1ggmH5llkb6TwBCqFLN+ja9jqat4A/+i4dXPxbWIzjNg/6aZxa4p/1rc6NarF/7ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ww7vFj4NCNDkgAkeBy14boLVra0qsEns9YULkYt2ScE=;
 b=J3VrfU5mdv03WbFGhWLO4tgiL2NKj1D0aV4haATi8qDmGuwBrsRQopfTZc50oWJkfiP0Tu/dOq00PJt+W+guK67p6DxF7otkCew2WR9NKeCTs9X1/p4kM7pb3Dd/GZ3ez2iI8Dmjil1WqByMMrGWOK/FFbdtDi633X+hvvnamL7RXsCn4Q2w8xpjpxBDUnAjmC2zO5u7W3JUxiz+4Ul8HYWL5ClZNXgzJlwx4j4GmA6XA2vHcRn8E3esxvASScqc2q8gC2qzNf136oxRNhIjYxTbvCBQuVxi2k3ckaWkzOZDfYE7cjIjzCmYh1FPPObpvKj+DTQlupr8iaCTuHJVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5223.namprd11.prod.outlook.com (2603:10b6:208:31a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 22:43:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 22:43:03 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Thread-Topic: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine
 check erratum
Thread-Index: AQHZlu+rViPY+CkNoE2o6SSiJzjZxK9/Z0QAgACNrwA=
Date:   Wed, 7 Jun 2023 22:43:02 +0000
Message-ID: <9cb242a0f5a6638770753b24ebd09e09ca047766.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
         <bf797bc6-e264-02b0-12ee-c2ebf7c92d22@intel.com>
In-Reply-To: <bf797bc6-e264-02b0-12ee-c2ebf7c92d22@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5223:EE_
x-ms-office365-filtering-correlation-id: 657034d2-483a-4719-6e91-08db67a88d85
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9mDf6QloePIAv45AH24FMddWE74H+Hv+FnqCMQWoM3SWxjN98u1KqBMKuix7Fc1kILP10F4J5Gxp9U7NcGDSgYOLh6XvGdC/mKNo17WZKGHENtr4MhFzVxNcvWBttlSOku5GtyQtQgWf8fVYEp28/71byWM+cA4UEEimcZLvRnslpK9dPucZRtxiaWkzBCSBKguDdZ3JFUnVhEmRjUMrYwH0bKii0ctu/cQHcEGUEQ0mSlM+EL/pO0rw2P/BKET0Zox/rpzP+qCKtx7iEudyvDwihg0J7LaNmH4YweDZF8S/C8rrbYYzVfKXi90da5EQNhKDWbSJ2FZ2ur/hEQoCWWuu9asNH7zsM8OK9RSfHeziJEotbearwiFmDKAOoA8L+OctMK8rHumXB/QAr7Ll7lEQBuW+9tkCzykA+5oxjA1r61qgBoBMXImAdjAS9IEiGhLLB1p5s21q611d7GoDJLqkRX3TAiGfzb+MwpU6RotYe61D/qu5Fk6AAAleTNw4BLx4M6nboFVc9IxQVgxG1iscVn+zSGOWPgjLpcag/zBfXPvTyCRIE1EI9rDNrIgPZSbXvXhN1QaqwPdguAxyg7zj8YI8+1sKYq6DtBQPjNUNRPh++Wo2ssRBQtt6oGcg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(86362001)(5660300002)(186003)(110136005)(26005)(71200400001)(6512007)(6506007)(53546011)(4744005)(2906002)(36756003)(316002)(54906003)(7416002)(8936002)(8676002)(41300700001)(38070700005)(122000001)(82960400001)(38100700002)(66446008)(66476007)(66556008)(66946007)(91956017)(64756008)(76116006)(478600001)(6486002)(4326008)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnNXVmtTN0FPdFdhN253bjkvc3k2WXdkS1lJNEp0dVk3L0pQbnBydnVmTXRO?=
 =?utf-8?B?LzEvVHZEVGVsbWVrUkxkWWpIUzNZK3MxY1NWclpKL25hRi81SHpmL0xIUk9T?=
 =?utf-8?B?b3hzWjRncGNKQVM4WlcrM3lLRjh1NmZpQ0hQcjJNOVFyVmxSdXBzeEpLd3pk?=
 =?utf-8?B?dTZZajlBTlhrMG9vQUM0ME1tcC81UnAzY0hUYlJQV05Dckp1dytsczUrbVA5?=
 =?utf-8?B?SEVBb2tVTVRiajlHTkNYRUdrRVhRbGdkMUpwbHl0L0RQQk5UMWJ0QmdCZlVu?=
 =?utf-8?B?UHE5ZkpxMVJPSjd6L3NZYkYxQmpzazYrVzh0NS8yMTJhRjRBNXF1dzB4U3RH?=
 =?utf-8?B?ajd3NllLdTRKdjVkbVFEQUpPT04yYUNBSEg1L1FuOVFiYzZyRk1QT0xqVmZW?=
 =?utf-8?B?ZXIwQ0FnTTB5T0s4aS9zN3JnZk93WEFoZExlWnoxOTFXcVVkL09DM1lUcWR3?=
 =?utf-8?B?c1hiNGtvVW5TRzd5SWZVYmI1bnlSdURQZnJMRmU1enY4WTdidFpjTmtkK0d3?=
 =?utf-8?B?RmpEM0l5QUU2SC9neVlzS0xUTEdXOC9ZK2NHUXBJSEV5ZWtiNGozNEJFWWsz?=
 =?utf-8?B?c2dPWjFXUDRRU0ZkcVZHUXNlcHVwbUl1UUt6QWdaMTVGM0dOWDBnVzFHd3Yy?=
 =?utf-8?B?RnBCWFU4QkZ0K1FBWXpzM2toaW9KLzZFYjBrUkMreFJHTGI0NzJjQWw3Qm83?=
 =?utf-8?B?dkVkMmRUUjk3S3QrL3VGSUovVTZYSUkwa3FHeW15RlVjSGgveFlDdWNOM2VL?=
 =?utf-8?B?VElhR1RoVmk1ak81SjRlTHVMVVFDcFFsNC9heG1ScDBkMldoZGVYdHFGUHAx?=
 =?utf-8?B?dW13Q3Q2ZTN0MXdNSUFRZ1hYVkcrV0w1OW11b0Z6ZXV2RHJ1bCtoVkY4bE4z?=
 =?utf-8?B?U3B3aFJBUGZuS2QvZWhLalQram93OVdjUDBlcEhrWjZFajEyNkdPMTBrUTRC?=
 =?utf-8?B?NWJIcm1hMUd1bnRWdXU3NFMwWlYreXQ4RllRdGZnZ2w5YW9KNm8vMGRkSEtt?=
 =?utf-8?B?cUxUTXhYZ2ZPL3QvcUl0ekZWRGRYbzhkQ016NnZpWHExWWM5VGpZbnpmY3hR?=
 =?utf-8?B?aG9Hd1pRR1VEeGttRjhnMG02ODBZYk9ZTXdaREFUdWFQNWE2dlFDZ2puTmxN?=
 =?utf-8?B?bGNzT2FHVndCQkZJZjBxUmZsS2thZDZBZWx6aTJJamFYREFESHhsU1FHbHBk?=
 =?utf-8?B?WEZ2NVg3TEpWeFFab255YjBsS2ZRUVJYS09kM1pEV2tYWVBJcmZydklZK2Fv?=
 =?utf-8?B?QmxJN25RWEY4bkYrUkliQUR6YXFuK0kwVVp0cVR4NlJxQlJyaVJyUnI0UUMw?=
 =?utf-8?B?WjUyblVsV3F3TXd2dXljcmdRNlg5QklwU1pFc2dtTS9sVnZId3A0dzRJcFNF?=
 =?utf-8?B?QU9UM1ZsRmJ0RlhWZGxXaC9DZTNNczNDWmVZY1ZpeVFLREVvQ3ZyR2NVVm9o?=
 =?utf-8?B?elVpVjhaSmhqU2JONGx1UGp2eHNSUDBOVHJxRC9oNk9PL2hTTk5naHJObHg3?=
 =?utf-8?B?Z2JNNmJLTG04WHZoMXl4dlZ6SWwzcVVOVkN6ZDU2bnV6cjNCMDkwZWVjK2Va?=
 =?utf-8?B?VEF3VjlTNXFwVDZLbmxLeFVBQkVQVEVhdjNZcHBFbEtWdWJEUWVYVjlOSFlC?=
 =?utf-8?B?WVBac1BiTkdyMUVLNFdQRHYxdGROOHo0L2x2SnJhMS8zVjdRT250MjV0QW4w?=
 =?utf-8?B?YklSU253enV6VVFlOEFzR0tLdWNZZDBMYXU1Z3BCNG1KZ28wSHNBNURXQ2Nk?=
 =?utf-8?B?TmU2MlVuTWRveW95TzlZU3Q0NjZnYk9LaXUyS2tsUng3RFBPZXNTcnR6Y3lT?=
 =?utf-8?B?dSsvTTVtNk12Y1FHUnBZZTJjbTBWY0ZXZ2dSaWt5TlZUOHNERXZ1bjc4Rmp1?=
 =?utf-8?B?VXVQK1JVY0IrYit3Qys1cmtXaldPWmdDMjZnQ2M1QlRKSytzelFGWi9SdmhB?=
 =?utf-8?B?cWM1L1hFa2hKa1BPU3RyWk40czJjOW1zSVhpNzgwTTJFYm0wN0hOY1J5SzRz?=
 =?utf-8?B?Y1l4TC85YzNmVEJpYTd2ZStvbUF2YXF5WEwzejVMVmJNOXlHTmlTNVV2bVky?=
 =?utf-8?B?MVB4ZVB0Y1BEMmlzUjBRblNoVVZWK1dSK0xSOXRLeFM3M050SHY5bUJRVlhF?=
 =?utf-8?Q?SIFzUi9z/yClt1aO97jJUNzVz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10F9C49AB0EFF3468501FD7016DD8033@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657034d2-483a-4719-6e91-08db67a88d85
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 22:43:02.9442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aGoPQAPBWHVLUUNKmp8k2d7FWFWaDACtQ/7mGcdf9jYaRwxb5GlDThbPuJ5G7riKowbqdc6sW/8Q9nl7WpCskw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5223
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA3OjE1IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvNC8yMyAwNzoyNywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFREWCBtZW1vcnkgaGFzIGlu
dGVncml0eSBhbmQgY29uZmlkZW50aWFsaXR5IHByb3RlY3Rpb25zLiAgVmlvbGF0aW9ucyBvZg0K
PiA+IHRoaXMgaW50ZWdyaXR5IHByb3RlY3Rpb24gYXJlIHN1cHBvc2VkIHRvIG9ubHkgYWZmZWN0
IFREWCBvcGVyYXRpb25zIGFuZA0KPiA+IGFyZSBuZXZlciBzdXBwb3NlZCB0byBhZmZlY3QgdGhl
IGhvc3Qga2VybmVsIGl0c2VsZi4gIEluIG90aGVyIHdvcmRzLA0KPiA+IHRoZSBob3N0IGtlcm5l
bCBzaG91bGQgbmV2ZXIsIGl0c2VsZiwgc2VlIG1hY2hpbmUgY2hlY2tzIGluZHVjZWQgYnkgdGhl
DQo+ID4gVERYIGludGVncml0eSBoYXJkd2FyZS4NCj4gDQo+IEF0IHRoZSByaXNrIG9mIHBhdHRp
bmcgbXlzZWxmIG9uIHRoZSBiYWNrIGJ5IGFja2luZyBhIGNoYW5nZWxvZyB0aGF0IEkNCj4gd3Jv
dGUgOTUlIG9mOg0KPiANCj4gUmV2aWV3ZWQtYnk6IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBs
aW51eC5pbnRlbC5jb20+DQo+IA0KDQpUaGFua3MhDQo=
