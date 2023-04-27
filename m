Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295286F06D0
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 15:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbjD0Nnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243361AbjD0Nnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 09:43:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9962701
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 06:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682603013; x=1714139013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6tiI0QXAyWO83YSz/op+0f//DAMyjG47F2dqo4QIvu4=;
  b=WgpKLWZinFvdfyDk2dpu/gMb8fIngkdeIh2Q/RhfwCd1VyR7FqoxAuVV
   vijWa+146aB+csM3smHsj1qIlh4PoQL29n/wBhfZ3hPQ2lr3Tq3sSLYS0
   VOj0Krex2zRLTtATBDgmqvF6W+PQFD6zDKYMQR0/dir4if2wFca3UJ8tk
   yf5Q9Ow3foprA3ZJLGfaREy7iXtBEJVj/Dfjco1Z6svWR7YPNhfwbU3JO
   ehPJuOsDRIjesRklB/A+1nCO8a6OmTO7rh6LNx9iLtfF6sLx8YwjdJR53
   sh8p4yH30dBjIDb9hb3mw72Yer9qhNHiDq4P42G9phs/Tjn0Q5Xe1PNKn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349405422"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="349405422"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 06:20:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="818533660"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="818533660"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2023 06:19:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 06:19:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 06:19:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 06:19:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 06:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAzjUeBEZ/SWTXyibJy9/OBUEU5FPgHJIgMku81xAon0NdT7L0t6cLd/RyDGy5+0Mu+lBkqVfVAYHZKqqDaoQlWR35k2u/Tvw2GDM0A1Rynt9LSqEpQ24GvVtbTaLZ9Jhw3nPH7iIpGlce/FZ7JtNArgR9usxWqH3nURWcPLYoL1u+wsMUvuOm5+0h8Bwe3NUPYVtBkJ2tmIlknSX1n8mbZxA4szofCdNXBBrfLtP01ttITEHLmyE4omG8IIhFBj2US9/2tXiAiB9/gFJCktttr31wWGOch2WWcdPCDnku2y0FBywU5wo1csnYdkSqA3C0hap9kR862HpqHHN8goYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tiI0QXAyWO83YSz/op+0f//DAMyjG47F2dqo4QIvu4=;
 b=hdMN8EElT7A9hNgNFlJNiCkNgyKivgXhYN0YKQDCIYcKIv4H8Ia4pozQ1SGWdycPsxVsbijs5lx3+Q3HdPpSTsVPqX8kBEe7PGR/Ydo8Y62KFAjs8GB7xUv7gM0udfnljSshquvsi7zvj81ff8uLzwnyrfWy4o71QxiksZqprLLGbzkX1PYyOCvjqlFW43AAv/FOAMXp7iBCs8O39qDO9C6/XpuctfTkQbxn6XmLv2FLdPt9AHZDF6qspGXzrxPKNhcsnO2142U/xZAfI85Kf9CFglqiDHLEWmncTpUR+Crm72Lg6EGSwbNkQuaRrIVIVku7CNcWxo/pYvotD3OtYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5499.namprd11.prod.outlook.com (2603:10b6:408:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 13:19:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 13:19:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Topic: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Thread-Index: AQHZZva2XlM7fnwAvESmPCLhodGl668nnluAgADkdoCAAA4jgIAAJr0AgABKcWCADGbRAIAAVjKAgAEJCwCAABPDAIAIa/+A
Date:   Thu, 27 Apr 2023 13:19:50 +0000
Message-ID: <262ed94998cf104c5fefcb290a81d60d10342173.camel@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
         <20230404130923.27749-3-binbin.wu@linux.intel.com>
         <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
         <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
         <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
         <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
         <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
         <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
         <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
         <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
         <ZENl3oGrLXvVaI1O@chao-email>
In-Reply-To: <ZENl3oGrLXvVaI1O@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5499:EE_
x-ms-office365-filtering-correlation-id: 0367acf6-fe93-4da6-e673-08db472214dd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yW+9vXnjHcW7NtS63uJDdXUcWJ1YTODAJigQtD1/BTPdztlNAyOpgTXaZbLP0IFZIU+Q5bu4vSK4fQpu4jQARmvgpyQn+kehvanM+QpLBPiEwjp/D0VowdhEvqk8+EzT2gxCwGPzdI4A+N4psXblmrIyc8f+39uTejLAz5XbCpuCgespOg/9em+z6Jp21YunvvnNKtr/2DlnwK9aUHwxc0/9UoS7nY1ujGekMi3dxjk2i2q7AkzlDshD8t6tPMXpIhTNYURqiFElKNVDemsDRalcpiI8QfZ7yiPYRkXl70DeKx3R0E1jz6O5nsr2ohYE+CN96S5/A5GdrKskcBDsA6Qlc8zRMahZHU80/eQAVRuWy2gdUAS7h3sPZJMOoTxLKj1yBEp96sKMzgpQ/tZcTJyafOVNXTUOlIK0z4bbDFRekIlIJux6TAX7bXkrBt+uYG+biGa2o0vDnHSPumjBqw4XUZ1nXT1jCHGaHI5BB5/thdENsDPMqmrlX7YWgGQOpc8y1Qj4heBWg6ynHAK2kWq4b+JeRbgv6zDSo57ELSLgC314xJtIDFD7Mi+/DoYknshk2f/4AzLNgoeWcbYR40x0g1YeMjvKcddDesiGQoBiXF2hxpP4XOW5s2AjNOWv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(38070700005)(478600001)(110136005)(36756003)(54906003)(38100700002)(8676002)(8936002)(5660300002)(2906002)(122000001)(66446008)(41300700001)(316002)(66476007)(66946007)(76116006)(64756008)(66556008)(4326008)(91956017)(82960400001)(26005)(6506007)(2616005)(86362001)(186003)(6512007)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dU9CVmNHWHA5UUxKNTVHUEtjMmgwU0dra0R3aDdzYVBWMkJNYVRrTmtrMzNu?=
 =?utf-8?B?ZVFqQlptUlV1QSt1dXNKWnNEMGRhc0t0ZVhpNy9la0xLSDlJOVVqamVjSVpk?=
 =?utf-8?B?NXVmbTFpekVKWW5HTjR3aDkvU1dhM2lXdzFvTEFuVXdkd2R1ZVpzRU10UFlq?=
 =?utf-8?B?a3dVR29jRGY1WnUyMDBzM3Rkd0FYWkZZeTN0bEphRWdRWGhTMHhtRTZyNWlN?=
 =?utf-8?B?SVU5ZWVuRk1Jakd6Y0JwR1d5TmZHdHZZRnRacW1xNmp4TkdRYlkzNGp3dmRv?=
 =?utf-8?B?c3JJK0pFY1BQQkdpMmp2eDVhYWcxeXRka202aVVwd1pzMXowRDBEN1BMOWdW?=
 =?utf-8?B?TG13R25sWXBPdEF0RWlwSU9Tb1dTamdGT3B5NFZEZkxDVHFsRncvRDErUGl5?=
 =?utf-8?B?K2VTbGo4cW5SVitVSURRdU5Ea3JwL1BkVE96cGROeCtXL2dTaUxkTWFwSjN6?=
 =?utf-8?B?dWZ0R0I5WjV3R3I1TGhxVW5FcExEU0NDeXo3blB3TmJ6Mm1jOC9aN0J3RlVF?=
 =?utf-8?B?VC9QM0cwaFc3TUNSdDlVTFFWYlJzNkJsWnZkaHlFeEtaQVVDR3dTbmcxb1JI?=
 =?utf-8?B?bGdhRWh0RW15QzRveE9ZVytrdGRFTjVpR0tEQjZLc2ZaSERxNXVyUU94aWdl?=
 =?utf-8?B?OUNOZlZ0TC9jQk5uYXh1SDg0SnZXSE11SnRGbHlnNUJvclh0Um9jdDZhcWJ2?=
 =?utf-8?B?RjYwS3VDamFNcUtCWHA0R0orZGpUUHYyalJlR1phd2JidGc1TlJweXZnaXNq?=
 =?utf-8?B?TlNjOHJ5aHJiSXZzVldUdHgvQTF4M1pCQ01FU2dmTzUyTEU0ajlXOTNzYXlB?=
 =?utf-8?B?ZzZSOTI2bTQwd3Rwb04zNXRDbHlQSlRXbk5RSElqNi9GY2trTXp6eTk2Wkds?=
 =?utf-8?B?N29rM0VsekE4MWZFKzliZ2cweW9mN25OOWVNT001a1dLM1prNy9YYVlzTFQw?=
 =?utf-8?B?UWlyNFNGNGt6YVZNZFprRCs0ekNVUTZvb0Y0dFRQelJFNHV1a0YwbmYvOG9H?=
 =?utf-8?B?WTNrV3kza3NCOVRzeTZua3pYODJxWC9KWTNvejRqUnM5cHU4R2xWOU9mYk9Z?=
 =?utf-8?B?YXdQeVBpQ3BYTXdmcGtrbFhxcFBkL1VrazZaZ1dpbS9IOHRyS2F6eW9kSTQx?=
 =?utf-8?B?NzhXbG02ZFhXM3Y1dm4xQ1VoV01zUHlVdTY2c0hzYldSZUFzSzRiamlHWlNH?=
 =?utf-8?B?YXFPdHg2bXkzM21lU1FYUG9ja05wME51eXNjaEtYN1UvSnNtQUt2OUsrd2dj?=
 =?utf-8?B?NEVpOXJuZVhvOUNaODN0YjdYQ294YkFSTW83WW5DMnd5bXEvUWxWeEF0MkNQ?=
 =?utf-8?B?YU90VzNTZ2VTbmtvSnlyR2dWY0twRDNaaHVLNU5XWGowTGNHb1VZbjlqQk5M?=
 =?utf-8?B?cXd6bHhPQ0Jkai94WnlBc21ySVFPd0pUU2RzcEcxQlFqZnFBckR5ZThwN1g1?=
 =?utf-8?B?NTZ6a21QTk1hZ28zTEtQVnhZdm5KTjZrQVdPTFlFaEdwOEQvYi9QSzJDOEVF?=
 =?utf-8?B?ZGtZMk5mNzlkMXJrYW1WK2l2TVZhSW1LdXNOa0NmN25DL0RtWERlQTQxbm1r?=
 =?utf-8?B?K0NWYWhnSVdFUHZxbkxiTUFwWUk1cy9xZXUzblc2OHNjc1dEaDRyaVdRMk5l?=
 =?utf-8?B?VkxuODZoTEJXVWQ5MjZxK3NuTnNoblpHbkVIY0VMVXEwNmQ2T2FoUHM0RExm?=
 =?utf-8?B?bVR1U3ZNcWZZa0wrc1NXNVpwc2dJZjhEd3g0YmNNTUlaV1FhVExQQzkvOUZr?=
 =?utf-8?B?QTFsb21rVk1ocWJKWW5HRjlzdGU2clBlWE1JQ1hCald3Q25CT2UyUFVlVklY?=
 =?utf-8?B?QkdtT1RSZTkzdWRXenBSbWVrNTV1SDBPVFZNSGFSa2hvTUZjb3VhbjBFd0Q0?=
 =?utf-8?B?Q0NvcnBVb0pyREJ4SGM1TEpzeEdqd0RQZVNoWjVkVDNJcTBOZmRKRHR4WmJ5?=
 =?utf-8?B?SXFTZUx0dU82cXE3czlIRkFRMFVPaDBZOU1ZSW9BMHdtMzIwbFp4M1MxREdN?=
 =?utf-8?B?UDBJRENwVmtDcHJybDh0TmpCQjJaazZYYVBWZU1JU0tCS0d4ZTJVM0djakcy?=
 =?utf-8?B?OHdtenRzV0gwb2ZTTjBBRkZVbklMUVJBOGlZTjM0Yy9JNlJVMXFSRTQrREF2?=
 =?utf-8?Q?uqX+5Nuzq0vks/ZuEAjKQgVSL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5327A17D4570C4C91F5EF405E43F094@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0367acf6-fe93-4da6-e673-08db472214dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 13:19:50.7241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AbL7l7nUdoN1q6zGWr01UsEkD/X+dR1SbaIA9dWfzopWS2CIhNSW0ad9LCTWxZ3P09AdKR4HbySKhS7XZspXFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5499
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA0LTIyIGF0IDEyOjQzICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IFNhdCwgQXByIDIyLCAyMDIzIGF0IDExOjMyOjI2QU0gKzA4MDAsIEJpbmJpbiBXdSB3cm90ZToN
Cj4gPiBLYWksDQo+ID4gDQo+ID4gVGhhbmtzIGZvciB5b3VyIGlucHV0cy4NCj4gPiANCj4gPiBJ
IHJlcGhyYXNlZCB0aGUgY2hhbmdlbG9nIGFzIGZvbGxvd2luZzoNCj4gPiANCj4gPiANCj4gPiBM
QU0gdXNlcyBDUjMuTEFNX1U0OCAoYml0IDYyKSBhbmQgQ1IzLkxBTV9VNTcgKGJpdCA2MSkgdG8g
Y29uZmlndXJlIExBTQ0KPiA+IG1hc2tpbmcgZm9yIHVzZXIgbW9kZSBwb2ludGVycy4NCj4gPiAN
Cj4gPiBUbyBzdXBwb3J0IExBTSBpbiBLVk0sIENSMyB2YWxpZGl0eSBjaGVja3MgYW5kIHNoYWRv
dyBwYWdpbmcgaGFuZGxpbmcgbmVlZCB0bw0KPiA+IGJlDQo+ID4gbW9kaWZpZWQgYWNjb3JkaW5n
bHkuDQo+ID4gDQo+ID4gPT0gQ1IzIHZhbGlkaXR5IENoZWNrID09DQo+ID4gV2hlbiBMQU0gaXMg
c3VwcG9ydGVkLCBDUjMgTEFNIGJpdHMgYXJlIGFsbG93ZWQgdG8gYmUgc2V0IGFuZCB0aGUgY2hl
Y2sgb2YNCj4gPiBDUjMNCj4gPiBuZWVkcyB0byBiZSBtb2RpZmllZC4NCj4gDQo+IGl0IGlzIGJl
dHRlciB0byBkZXNjcmliZSB0aGUgaGFyZHdhcmUgY2hhbmdlIGhlcmU6DQo+IA0KPiBPbiBwcm9j
ZXNzb3JzIHRoYXQgZW51bWVyYXRlIHN1cHBvcnQgZm9yIExBTSwgQ1IzIHJlZ2lzdGVyIGFsbG93
cw0KPiBMQU1fVTQ4L1U1NyB0byBiZSBzZXQgYW5kIFZNIGVudHJ5IGFsbG93cyBMQU1fVTQ4L1U1
NyB0byBiZSBzZXQgaW4gYm90aA0KPiBHVUVTVF9DUjMgYW5kIEhPU1RfQ1IzIGZpZWxkcy4NCj4g
DQo+IFRvIGVtdWxhdGUgTEFNIGhhcmR3YXJlIGJlaGF2aW9yLCBLVk0gbmVlZHMgdG8NCj4gMS4g
YWxsb3cgTEFNX1U0OC9VNTcgdG8gYmUgc2V0IHRvIHRoZSBDUjMgcmVnaXN0ZXIgYnkgZ3Vlc3Qg
b3IgdXNlcnNwYWNlDQo+IDIuIGFsbG93IExBTV9VNDgvVTU3IHRvIGJlIHNldCB0byB0aGUgR1VF
U19DUjMvSE9TVF9DUjMgZmllbGRzIGluIHZtY3MxMg0KDQpBZ3JlZWQuICBUaGlzIGlzIG1vcmUg
Y2xlYXJlci4NCg0KPiANCj4gPiBBZGQgYSBoZWxwZXIga3ZtX3ZjcHVfaXNfbGVnYWxfY3IzKCkg
YW5kIHVzZSBpdCBpbnN0ZWFkIG9mDQo+ID4ga3ZtX3ZjcHVfaXNfbGVnYWxfZ3BhKCkNCj4gPiB0
byBkbyB0aGUgbmV3IENSMyBjaGVja3MgaW4gYWxsIGV4aXN0aW5nIENSMyBjaGVja3MgYXMgZm9s
bG93aW5nOg0KPiA+IFdoZW4gdXNlcnNwYWNlIHNldHMgc3JlZ3MsIENSMyBpcyBjaGVja2VkIGlu
IGt2bV9pc192YWxpZF9zcmVncygpLg0KPiA+IE5vbi1uZXN0ZWQgY2FzZQ0KPiA+IC0gV2hlbiBF
UFQgb24sIENSMyBpcyBmdWxseSB1bmRlciBjb250cm9sIG9mIGd1ZXN0Lg0KPiA+IC0gV2hlbiBF
UFQgb2ZmLCBDUjMgaXMgaW50ZXJjZXB0ZWQgYW5kIENSMyBpcyBjaGVja2VkIGluIGt2bV9zZXRf
Y3IzKCkgZHVyaW5nDQo+ID4gwqAgQ1IzIFZNRXhpdCBoYW5kbGluZy4NCj4gPiBOZXN0ZWQgY2Fz
ZSwgZnJvbSBMMCdzIHBlcnNwZWN0aXZlLCB3ZSBjYXJlIGFib3V0Og0KPiA+IC0gTDEncyBDUjMg
cmVnaXN0ZXIgKFZNQ1MwMSdzIEdVRVNUX0NSMyksIGl0J3MgdGhlIHNhbWUgYXMgbm9uLW5lc3Rl
ZCBjYXNlLg0KPiA+IC0gTDEncyBWTUNTIHRvIHJ1biBMMiBndWVzdCAoaS5lLiBWTUNTMTIncyBI
T1NUX0NSMyBhbmQgVk1DUzEyJ3MgR1VFU1RfQ1IzKQ0KPiA+IMKgIFR3byBwYXRocyByZWxhdGVk
Og0KPiA+IMKgIDEuIEwwIGVtdWxhdGVzIGEgVk1FeGl0IGZyb20gTDIgdG8gTDEgdXNpbmcgVk1D
UzAxIHRvIHJlZmxlY3QgVk1DUzEyDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCBuZXN0ZWRfdm1fZXhp
dCgpDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAtPiBsb2FkX3ZtY3MxMl9ob3N0X3N0YXRlKCkNCj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC0+IG5lc3RlZF92bXhfbG9hZF9jcjMoKcKg
wqDCoMKgIC8vY2hlY2sgVk1DUzEyJ3MgSE9TVF9DUjMNCj4gDQo+IFRoaXMgaXMganVzdCBhIGJ5
cHJvZHVjdCBvZiB1c2luZyBhIHVuaWZpZWQgZnVuY3Rpb24sIGkuZS4sDQo+IG5lc3RlZF92bXhf
bG9hZF9jcjMoKSB0byBsb2FkIENSMyBmb3IgYm90aCBuZXN0ZWQgVk0gZW50cnkgYW5kIFZNIGV4
aXQuDQo+IA0KPiBMQU0gc3BlYyBzYXlzOg0KPiANCj4gVk0gZW50cnkgY2hlY2tzIHRoZSB2YWx1
ZXMgb2YgdGhlIENSMyBhbmQgQ1I0IGZpZWxkcyBpbiB0aGUgZ3Vlc3QtYXJlYQ0KPiBhbmQgaG9z
dC1zdGF0ZSBhcmVhIG9mIHRoZSBWTUNTLiBJbiBwYXJ0aWN1bGFyLCB0aGUgYml0cyBpbiB0aGVz
ZSBmaWVsZHMNCj4gdGhhdCBjb3JyZXNwb25kIHRvIGJpdHMgcmVzZXJ2ZWQgaW4gdGhlIGNvcnJl
c3BvbmRpbmcgcmVnaXN0ZXIgYXJlDQo+IGNoZWNrZWQgYW5kIG11c3QgYmUgMC4NCj4gDQo+IEl0
IGRvZXNuJ3QgbWVudGlvbiBhbnkgY2hlY2sgb24gVk0gZXhpdC4gU28sIGl0IGxvb2tzIHRvIG1l
IHRoYXQgVk0gZXhpdA0KPiBkb2Vzbid0IGRvIGNvbnNpc3RlbmN5IGNoZWNrcy4gVGhlbiwgSSB0
aGluayB0aGVyZSBpcyBubyBuZWVkIHRvIGNhbGwNCj4gb3V0IHRoaXMgcGF0aC4NCg0KQnV0IHRo
aXMgaXNuJ3QgYSB0cnVlIFZNRVhJVCAtLSBpdCBpcyBpbmRlZWQgYSBWTUVOVEVSIGZyb20gTDAg
dG8gTDEgdXNpbmcNClZNQ1MwMSBidXQgd2l0aCBhbiBlbnZpcm9ubWVudCB0aGF0IGFsbG93cyBM
MSB0byBydW4gaXRzIFZNRVhJVCBoYW5kbGVyIGp1c3QNCmxpa2UgaXQgcmVjZWl2ZWQgYSBWTUVY
SVQgZnJvbSBMMi4NCg0KSG93ZXZlciBJIGZ1bGx5IGFncmVlIHRob3NlIGNvZGUgcGF0aHMgYXJl
IGRldGFpbHMgYW5kIHNob3VsZG4ndCBiZSBjaGFuZ2Vsb2cNCm1hdGVyaWFsLg0KDQpIb3cgYWJv
dXQgYmVsb3cgY2hhbmdlbG9nPyANCg0KQWRkIHN1cHBvcnQgdG8gYWxsb3cgZ3Vlc3QgdG8gc2V0
IHR3byBuZXcgQ1IzIG5vbi1hZGRyZXNzIGNvbnRyb2wgYml0cyB0byBhbGxvdw0KZ3Vlc3QgdG8g
ZW5hYmxlIHRoZSBuZXcgSW50ZWwgQ1BVIGZlYXR1cmUgTGluZWFyIEFkZHJlc3MgTWFza2luZyAo
TEFNKS4NCg0KTEFNIG1vZGlmaWVzIHRoZSBjaGVja2luZyB0aGF0IGlzIGFwcGxpZWQgdG8gNjQt
Yml0IGxpbmVhciBhZGRyZXNzZXMsIGFsbG93aW5nDQpzb2Z0d2FyZSB0byB1c2Ugb2YgdGhlIHVu
dHJhbnNsYXRlZCBhZGRyZXNzIGJpdHMgZm9yIG1ldGFkYXRhLiAgRm9yIHVzZXIgbW9kZQ0KbGlu
ZWFyIGFkZHJlc3MsIExBTSB1c2VzIHR3byBuZXcgQ1IzIG5vbi1hZGRyZXNzIGJpdHMgTEFNX1U0
OCAoYml0IDYyKSBhbmQNCkxBTV9VNTcgKGJpdCA2MSkgdG8gY29uZmlndXJlIHRoZSBtZXRhZGF0
YSBiaXRzIGZvciA0LWxldmVsIHBhZ2luZyBhbmQgNS1sZXZlbA0KcGFnaW5nIHJlc3BlY3RpdmVs
eS4gIExBTSBhbHNvIGNoYW5nZXMgVk1FTlRFUiB0byBhbGxvdyBib3RoIGJpdHMgdG8gYmUgc2V0
IGluDQpWTUNTJ3MgSE9TVF9DUjMgYW5kIEdVRVNUX0NSMyB0byBzdXBwb3J0IHZpcnR1YWxpemF0
aW9uLg0KDQpXaGVuIEVQVCBpcyBvbiwgQ1IzIGlzIG5vdCB0cmFwcGVkIGJ5IEtWTSBhbmQgaXQn
cyB1cCB0byB0aGUgZ3Vlc3QgdG8gc2V0IGFueSBvZg0KdGhlIHR3byBMQU0gY29udHJvbCBiaXRz
LiAgSG93ZXZlciB3aGVuIEVQVCBpcyBvZmYsIHRoZSBhY3R1YWwgQ1IzIHVzZWQgYnkgdGhlDQpn
dWVzdCBpcyBnZW5lcmF0ZWQgZnJvbSB0aGUgc2hhZG93IE1NVSByb290IHdoaWNoIGlzIGRpZmZl
cmVudCBmcm9tIHRoZSBDUjMgdGhhdA0KaXMgKnNldCogYnkgdGhlIGd1ZXN0LCBhbmQgS1ZNIG5l
ZWRzIHRvIG1hbnVhbGx5IGFwcGx5IGFueSBhY3RpdmUgY29udHJvbCBiaXRzDQp0byBWTUNTJ3Mg
R1VFU1RfQ1IzIGJhc2VkIG9uIHRoZSBjYWNoZWQgQ1IzICpzZWVuKiBieSB0aGUgZ3Vlc3QuDQoN
CktWTSBtYW51YWxseSBjaGVja3MgZ3Vlc3QncyBDUjMgdG8gbWFrZSBzdXJlIGl0IHBvaW50cyB0
byBhIHZhbGlkIGd1ZXN0IHBoeXNpY2FsDQphZGRyZXNzIChpLmUuIHRvIHN1cHBvcnQgc21hbGxl
ciBNQVhQSFlTQUREUiBpbiB0aGUgZ3Vlc3QpLiAgRXh0ZW5kIHRoaXMgY2hlY2sNCnRvIGFsbG93
IHRoZSB0d28gTEFNIGNvbnRyb2wgYml0cyB0byBiZSBzZXQuICBBbmQgdG8gbWFrZSBzdWNoIGNo
ZWNrIGdlbmVyaWMsDQppbnRyb2R1Y2UgYSBuZXcgZmllbGQgJ2NyM19jdHJsX2JpdHMnIHRvIHZj
cHUgdG8gcmVjb3JkIGFsbCBmZWF0dXJlIGNvbnRyb2wgYml0cw0KdGhhdCBhcmUgYWxsb3dlZCB0
byBiZSBzZXQgYnkgdGhlIGd1ZXN0Lg0KDQpJbiBjYXNlIG9mIG5lc3RlZCwgZm9yIGEgZ3Vlc3Qg
d2hpY2ggc3VwcG9ydHMgTEFNLCBib3RoIFZNQ1MxMidzIEhPU1RfQ1IzIGFuZA0KR1VFU1RfQ1Iz
IGFyZSBhbGxvd2VkIHRvIGhhdmUgdGhlIG5ldyBMQU0gY29udHJvbCBiaXRzIHNldCwgaS5lLiB3
aGVuIEwwIGVudGVycw0KTDEgdG8gZW11bGF0ZSBhIFZNRVhJVCBmcm9tIEwyIHRvIEwxIG9yIHdo
ZW4gTDAgZW50ZXJzIEwyIGRpcmVjdGx5LiAgS1ZNIGFsc28NCm1hbnVhbGx5IGNoZWNrcyBWTUNT
MTIncyBIT1NUX0NSMyBhbmQgR1VFU1RfQ1IzIGJlaW5nIHZhbGlkIHBoeXNpY2FsIGFkZHJlc3Mu
DQpFeHRlbmQgc3VjaCBjaGVjayB0byBhbGxvdyB0aGUgbmV3IExBTSBjb250cm9sIGJpdHMgdG9v
Lg0KDQpOb3RlLCBMQU0gZG9lc24ndCBoYXZlIGEgZ2xvYmFsIGVuYWJsZSBiaXQgaW4gYW55IGNv
bnRyb2wgcmVnaXN0ZXIgdG8gdHVybg0Kb24vb2ZmIExBTSBjb21wbGV0ZWx5LCBidXQgcHVyZWx5
IGRlcGVuZHMgb24gaGFyZHdhcmUncyBDUFVJRCB0byBkZXRlcm1pbmUNCndoZXRoZXIgdG8gcGVy
Zm9ybSBMQU0gY2hlY2sgb3Igbm90LiAgVGhhdCBtZWFucywgd2hlbiBFUFQgaXMgb24sIGV2ZW4g
d2hlbiBLVk0NCmRvZXNuJ3QgZXhwb3NlIExBTSB0byBndWVzdCwgdGhlIGd1ZXN0IGNhbiBzdGls
bCBzZXQgTEFNIGNvbnRyb2wgYml0cyBpbiBDUjMgdy9vDQpjYXVzaW5nIHByb2JsZW0uICBUaGlz
IGlzIGFuIHVuZm9ydHVuYXRlIHZpcnR1YWxpemF0aW9uIGhvbGUuICBLVk0gY291bGQgY2hvb3Nl
DQp0byBpbnRlcmNlcHQgQ1IzIGluIHRoaXMgY2FzZSBhbmQgaW5qZWN0IGZhdWx0IGJ1dCB0aGlz
IHdvdWxkIGh1cnQgcGVyZm9ybWFuY2UNCndoZW4gcnVubmluZyBhIG5vcm1hbCBWTSB3L28gTEFN
IHN1cHBvcnQuICBUaGlzIGlzIHVuZGVzaXJhYmxlLiAgSnVzdCBjaG9vc2UgdG8NCmxldCB0aGUg
Z3Vlc3QgZG8gc3VjaCBpbGxlZ2FsIHRoaW5nIGFzIHRoZSB3b3JzdCBjYXNlIGlzIGd1ZXN0IGJl
aW5nIGtpbGxlZCB3aGVuDQpLVk0gZXZlbnR1YWxseSBmaW5kIG91dCBzdWNoIGlsbGVnYWwgYmVo
YXZpb3VyIGFuZCB0aGF0IGlzIHRoZSBndWVzdCB0byBibGFtZS4gDQoNCg==
