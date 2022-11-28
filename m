Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B35D63A4B3
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiK1JVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiK1JVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:21:12 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B9915800;
        Mon, 28 Nov 2022 01:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669627270; x=1701163270;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pmtObCjXh9247iW2FvQmgIK9Gvt/OMXJTwFudMHJ3JI=;
  b=SMAkPiNAiruTf0hdNmSKoslM9rf5uovL8ndao6ANJRocg7qhOjAhYiKH
   5qVKJlDKhlK6OQPthe37c06SHMrbEZe+yEbZ6Q9yLpmXy1fe7VjozyYfO
   d8FmouHc30pLFD9eHEBfbwDVSnPYUYvKsv9T6IMB/EnhI/SfIgHqjq4Qi
   jHLHG1xe7d4wocNDmK5tLT8R4HEylHOg7t0nCsS79uDB6kKjG5bRf8omu
   emLjTP1hbAQ/QGBEuvSM/J2Qe3BgAc1qzaL4md3V3IMidg4ME80GE8awD
   cQb7ut22bB+eVeMSHjdxcOmj7ovIX9HwI43zN1jrvAaCn3LRTOpHdd3W6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="312422609"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="312422609"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:21:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="749301878"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="749301878"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 28 Nov 2022 01:21:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:21:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:21:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:21:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:21:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMqVBH5vdMF2VsuQpFa/DfnCuZOIMOh65HN6kpseAxd2GjxTk4SOwcKe+uDcIFpGdpC19mbukUP+5rd8GpFSTCNtsMwcFQsDvUdLm35iEV8v52A4hEsj90zgknzJ2AdrzS/opVYl3mAcX4ENw6qgqi7kU6izBLvFl1L3OuHTvdaos2DUexBSJbeNqs+Vu5h7MxuxOha5q8BnsJc92fZXdt7WwI4vaIUil9mxSuaWJMmy2ZDrvnhfyS93UBhEr1XGyvncI0H3pXhAsdURsxDoDBn797BsGzfK4PnHLXINiBFeh1bIuh+aFsaVgrki806HCuSZXH6DMU3IK5A7Fg8wsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmtObCjXh9247iW2FvQmgIK9Gvt/OMXJTwFudMHJ3JI=;
 b=l6LCiIMUJQd/NarMXeMfKytPeFMZiMewEo+BBys6AMvqwEopj7pZoElg8wHSlS1+fFBcCGw+ATxIkRSpPE/dOJlWMyZQQbrVAiq7+Oh+G1ef54Em0+ZNT/xDIdT0GAcBRD9AFFv3v3DEieACnBFd6D7NcUjoMXD+kki+VI+CBJw/NhKo1Yg9wrnC/ZaON063sRqn8/+Tu0fnyjcfo1H/KvVIzUnr77cVMu+mFKjWSKnmVBQ5drI6ykAtXohahUWYBUGpWK057CPxWKQt2O74ldN0cNI4cWIy3Y3QwOc8D15N/HDUSMbAuhhAQ4vSIfGyQvQr49GBjHWwm46f7aomjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5443.namprd11.prod.outlook.com (2603:10b6:610:d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:21:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:21:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65NU9CAgAB5pwCAAZiKgIAEqQwAgAABUwCAAAqdgA==
Date:   Mon, 28 Nov 2022 09:21:05 +0000
Message-ID: <8300f1098aa8fbfae711313be41ee44cb1203d62.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
         <8e8f72ad5d7a3d09be32bee54e4ebb9c280610a2.camel@intel.com>
         <361875cb-e4b3-a46f-b275-6d87a98ce966@redhat.com>
         <397ebe70bf9cede731f2f8bbd05e0df518fd3a22.camel@intel.com>
         <49ab9f26-9e23-25ab-71b4-e666c70ff77e@redhat.com>
In-Reply-To: <49ab9f26-9e23-25ab-71b4-e666c70ff77e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5443:EE_
x-ms-office365-filtering-correlation-id: 9ac44936-0e43-4f79-4105-08dad121e04c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0TgnCBWA5Y3CkFH0Jm9amhewvvrYqL4BfxpUB1PMlB+ynN9FahXz/Sb3QLBW2wX+MCt1tIXL8EydvIWW+62aDJp3La7WdMdfwImIDh0G2X0Gq6ePIGy9eMkngxfOk+QELmWgL8AmqZRyOq52rN62/HK9px4Hz/wtt84mtNJUaN4bmE4p/TTFAClPcT4269HbQZeaS8T01lGRzxEZnwfEj1kAImctMc2ofdqXVt+Pn3k91am7kAA0lKBkj7QkrSk2mH4uiqLsOapmGEmrNJCRF7Nd6quxbhwlZT55s7JgQMwTTNdAXrdECaV4DGPYjdDJyNfCyyW0xoT+fnimjEzOXCP4gEueb22XR7RBr0O4taGEjTGKYAy/aWdfkw6//sCfd9xm0WQGrY62K/j34RDUcbC+tzcEKEAPoD3GzTSk7pKV1w4/VxqzGDAMqufVsPWFsF171i3gqyJmgmZ+4a0Cvpfq1Ou4JGedUiStqFee7upVODGZuh6OeLv/epvvwkihFCRTEDQKijaP7fE2ZOOFkpMNB2KEU2veLSiwEY8JNJDISDeVRtKnRGzwTE8aPoS5ZThVEZqMV5JGiKkHPsuLyMFifFOdLo7R9zZcmhZHevxtaExGBvNOXO6TDs+MXYWXS7cPwPUeo7LclMI+9V39EqD3sLpzGgeUOVekW19dZ4oBIBDicIrFaFtS4fSqRS2V+I+VddTCWP6xQfvxdZTacA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(38070700005)(6506007)(86362001)(6512007)(64756008)(66946007)(91956017)(53546011)(66556008)(41300700001)(26005)(186003)(8676002)(76116006)(8936002)(66446008)(4326008)(2616005)(66476007)(71200400001)(6486002)(316002)(478600001)(110136005)(54906003)(82960400001)(38100700002)(122000001)(2906002)(4001150100001)(7416002)(5660300002)(83380400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REIvQkRwTlY5SmRDY0ZaZ2xndThDVjNFRmFKRWdiRHlCRDVZbTkxMzZ4RlpE?=
 =?utf-8?B?cGdRM3ZQSU5Ia1RVWTZtTks1NDlUN2lkRVBsYkVQRzJObkJjWlJWNFM1UmZM?=
 =?utf-8?B?RU9aYTVIb1U5YmJLTjZFNStsTTl6TmpEWkV5Q2RmczhxRmM0ZGpSZEVESzJ4?=
 =?utf-8?B?dm8yN200RnZ0djhUd2xZWHQ1eHBQcWZaOGQ4RndDOXBPRkZ1ZTRaSlp1Vi9m?=
 =?utf-8?B?ZWFKQ2FTV2VnbTR5NlZyZDBHS1pwSk96bjhiY0dOUUNVdFlOV0t3SzEybmZ4?=
 =?utf-8?B?RWNROVdSdU53RDZjbGhpcng0bnFpZndBd3U1WklLdS9IUE03a2lBSks4QVBi?=
 =?utf-8?B?NEpWVjFLcGQrRmIybXF4ZlBZU1lEbWxFTzdDeDZSNk5MQnh2NTREN3RseXJr?=
 =?utf-8?B?eTJDSmJMVTdGektEM2s1S0g1K09oZTRrQlhzTmJUWjlDMXlOcHBLSDFRZFRT?=
 =?utf-8?B?V3dpb1ltakZYR093Qk8vcElZZFdXOGQ2RDliT1hYUDRLc1Y2cmZrUi80Vngx?=
 =?utf-8?B?NTEraU50MXpsUGtkKzlFbjJBczZ5dEE3NksvSXA0L3ErNmlYSDVENGd6MExW?=
 =?utf-8?B?V00vZE9GeVp5YnY4T0p0ZjBrSTYzTDRWb3BaU21QeHkrVzc1MTVwOUQyTUVE?=
 =?utf-8?B?S2RzczZhTGlEYWs1S0xRdHR4aFhLaVczT1ExN3Noc21HYTdLcitIemFWb0E3?=
 =?utf-8?B?SS9zem5Rd05aRDdMZmRMRjZ2b1daYk92cjJzNnhqN2FjZXR1NWNaQWhNNnhx?=
 =?utf-8?B?cXU2MmhFTkRYT0tMUDNycGJsa3F3d2U1SkNQS1lIdlpoYkkrUnJHVVhuNlc3?=
 =?utf-8?B?Y1RDczlpMUIyMVZVSDV2Vldkb1BLYzMwMHd4LzI5aFpvbG5ja0J5ZlhJZVJv?=
 =?utf-8?B?N2Y5MzNtY2RmY0hWWWFJbzlxWU53VWRvZDZjV1FoSk1rYlg1ekd3RE1pMTR3?=
 =?utf-8?B?Vk5EaTk1ejBCam9vNHk3Nys4WTBvYUp6ZExzOUordTFRd2NDd2JNa1BxUXdw?=
 =?utf-8?B?aWR1WE5xTnZzaFE5cUEzalUwZmVYeGQrTTZNVXdaZE9mWnJaQ1B6WjB2WWdQ?=
 =?utf-8?B?NjU1UVUzZVBlRXp5Z3F5ZFZ6cjRhMEMwS1NZTkx4d2pweHNqYXN2S1kyYWJB?=
 =?utf-8?B?Mk9xTVpwaFBQRUtRcEFPdHoxQUtNKzVHMDB2eVhTNVQ4Q0s2VmMzK1hBL0M3?=
 =?utf-8?B?YWFSdll3QmVTcnY3QUQrV3FFeUFqcXp0RFJCY01BY1RoN2xXMjFpeDFLU0hC?=
 =?utf-8?B?WHY2ZEhYRzdZVUlYdTNUUmVPQ2Nvd0pydXphMUJIYVdxQmx0bVlKOGVxM3Q2?=
 =?utf-8?B?cmE3K0dkN3hva0JERG9xcnRIZ0lLQXRNZzFWUXBPMW1saFByaE1mb0hZVjVM?=
 =?utf-8?B?RjEwUDBEMXBpVTlta29ER1hheGVlTWRFNXdyOW0wdGZINzUzMElpaUx2TkRt?=
 =?utf-8?B?akh3QnAxbGl2Y0VTY0hSV0o4U3AvR0ZtUzMyTC9IMWF2Q2phYlRlL0tqMk5F?=
 =?utf-8?B?cFRIZGFWZzFDRUx1VDlsejg4SFlPbktaZ0pXSUNsSzFrNzVITXo4eE1HbTlt?=
 =?utf-8?B?YVNZSFZaZ2lqLzFuVlM5NUYxY1kxakJmSDduYXZIOHNFeUtZcFNLS2FqUTlS?=
 =?utf-8?B?WDloMHN1R3loNmpFVVlmTDNUT3BDVVg5azZBUjNiQnl6L3ZYWFlScFg4cHpr?=
 =?utf-8?B?blh6QTFhcG56WEtZM3U0MkxrQTZmQm00b1BGd2h5a0ZXVE9oelVZSDE4clVx?=
 =?utf-8?B?STExNXVmYXZkN2tKZGFjN0dPb1dBT1N1b1cybjgyRGZSSkNManNKQ2tYeTJI?=
 =?utf-8?B?NkxLRmlIM0pORGhuNVhreUptdzZ5YUhMbFkvMUNXQURBcktPQjlHOFdaTHVL?=
 =?utf-8?B?SEFWRWZzaUIvdFNLbmFyZkI5S3hhMWlpbTd6bjdoeWVTQ3RZLzEzZ1lFUy9Y?=
 =?utf-8?B?ajdjTGt3WHlKM3IrV1RKNDlqVUpUbVIyQmE5Sm9OV1BsMllhYlUvWUE1SWJj?=
 =?utf-8?B?dXBSMWRMRzhFNzhXRTBBMGpYcHF3cWlnS2FoU0tOMXZnM3dYcVlOaFJ0QmpG?=
 =?utf-8?B?NmFkbEZkNkM1TzZ0QW9yWXN3ZjNjUG1TMUF5UnRIWjNCTVBhcERnUHdMN1FD?=
 =?utf-8?B?UGJpRXNIK3V5V0R4QlFma2RjS2lPS2N0QmNGc1UxcHRiWndaMUZkd1pxK0ps?=
 =?utf-8?B?NGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D5629223F4F354C98602F921EFD01B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac44936-0e43-4f79-4105-08dad121e04c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 09:21:05.3409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YoKqfvtBkMYHARLX72kGcKm8ywFR6rUKbznkVsZGWw1pG5XE6neOu+QVYbVvPh+Yi1PbTbPAQ9ukpLgTCvcQSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5443
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDA5OjQzICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMjguMTEuMjIgMDk6MzgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gRnJpLCAy
MDIyLTExLTI1IGF0IDEwOjI4ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90ZToNCj4gPiA+
IE9uIDI0LjExLjIyIDEwOjA2LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBPbiBXZWQsIDIw
MjItMTEtMjMgYXQgMTc6NTAgLTA4MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiA+ID4gPiA+
ICAgICANCj4gPiA+ID4gPiA+IEBAIC05NjgsNiArOTY5LDE1IEBAIGludCBhcmNoX2FkZF9tZW1v
cnkoaW50IG5pZCwgdTY0IHN0YXJ0LCB1NjQgc2l6ZSwNCj4gPiA+ID4gPiA+ICAgwqDCoAl1bnNp
Z25lZCBsb25nIHN0YXJ0X3BmbiA9IHN0YXJ0ID4+IFBBR0VfU0hJRlQ7DQo+ID4gPiA+ID4gPiAg
IMKgwqAJdW5zaWduZWQgbG9uZyBucl9wYWdlcyA9IHNpemUgPj4gUEFHRV9TSElGVDsNCj4gPiA+
ID4gPiA+ICAgICANCj4gPiA+ID4gPiA+ICsJLyoNCj4gPiA+ID4gPiA+ICsJICogRm9yIG5vdyBp
ZiBURFggaXMgZW5hYmxlZCwgYWxsIHBhZ2VzIGluIHRoZSBwYWdlIGFsbG9jYXRvcg0KPiA+ID4g
PiA+ID4gKwkgKiBtdXN0IGJlIFREWCBtZW1vcnksIHdoaWNoIGlzIGEgZml4ZWQgc2V0IG9mIG1l
bW9yeSByZWdpb25zDQo+ID4gPiA+ID4gPiArCSAqIHRoYXQgYXJlIHBhc3NlZCB0byB0aGUgVERY
IG1vZHVsZS7CoCBSZWplY3QgdGhlIG5ldyByZWdpb24NCj4gPiA+ID4gPiA+ICsJICogaWYgaXQg
aXMgbm90IFREWCBtZW1vcnkgdG8gZ3VhcmFudGVlIGFib3ZlIGlzIHRydWUuDQo+ID4gPiA+ID4g
PiArCSAqLw0KPiA+ID4gPiA+ID4gKwlpZiAoIXRkeF9jY19tZW1vcnlfY29tcGF0aWJsZShzdGFy
dF9wZm4sIHN0YXJ0X3BmbiArIG5yX3BhZ2VzKSkNCj4gPiA+ID4gPiA+ICsJCXJldHVybiAtRUlO
VkFMOw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGFyY2hfYWRkX21lbW9yeSgpIGRvZXMgbm90IGFk
ZCBtZW1vcnkgdG8gdGhlIHBhZ2UgYWxsb2NhdG9yLsKgIEZvcg0KPiA+ID4gPiA+IGV4YW1wbGUs
IG1lbXJlbWFwX3BhZ2VzKCkgdXNlcyBhcmNoX2FkZF9tZW1vcnkoKSBhbmQgZXhwbGljaXRseSBk
b2VzIG5vdA0KPiA+ID4gPiA+IHJlbGVhc2UgdGhlIG1lbW9yeSB0byB0aGUgcGFnZSBhbGxvY2F0
b3IuDQo+ID4gPiA+IA0KPiA+ID4gPiBJbmRlZWQuICBTb3JyeSBJIG1pc3NlZCB0aGlzLg0KPiA+
ID4gPiANCj4gPiA+ID4gPiBUaGlzIGNoZWNrIGJlbG9uZ3MgaW4NCj4gPiA+ID4gPiBhZGRfbWVt
b3J5X3Jlc291cmNlKCkgdG8gcHJldmVudCBuZXcgbWVtb3J5IHRoYXQgdmlvbGF0ZXMgVERYIGZy
b20gYmVpbmcNCj4gPiA+ID4gPiBvbmxpbmVkLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyB3b3Vs
ZCByZXF1aXJlIGFkZGluZyBhbm90aGVyICdhcmNoX2NjX21lbW9yeV9jb21wYXRpYmxlKCknIHRv
IHRoZSBjb21tb24NCj4gPiA+ID4gYWRkX21lbW9yeV9yZXNvdXJjZSgpIChJIGFjdHVhbGx5IGxv
bmcgdGltZSBhZ28gaGFkIHN1Y2ggcGF0Y2ggdG8gd29yayB3aXRoIHRoZQ0KPiA+ID4gPiBtZW1y
ZW1hcF9wYWdlcygpIHlvdSBtZW50aW9uZWQgYWJvdmUpLg0KPiA+ID4gPiANCj4gPiA+ID4gSG93
IGFib3V0IGFkZGluZyBhIG1lbW9yeV9ub3RpZmllciB0byB0aGUgVERYIGNvZGUsIGFuZCByZWpl
Y3Qgb25saW5lIG9mIFREWA0KPiA+ID4gPiBpbmNvbXBhdGlibGUgbWVtb3J5IChzb21ldGhpbmcg
bGlrZSBiZWxvdyk/ICBUaGUgYmVuZWZpdCBpcyB0aGlzIGlzIFREWCBjb2RlDQo+ID4gPiA+IHNl
bGYgY29udGFpbmVkIGFuZCB3b24ndCBwb2xsdXRlIHRoZSBjb21tb24gbW0gY29kZToNCj4gPiA+
ID4gDQo+ID4gPiA+ICtzdGF0aWMgaW50IHRkeF9tZW1vcnlfbm90aWZpZXIoc3RydWN0IG5vdGlm
aWVyX2Jsb2NrICpuYiwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVu
c2lnbmVkIGxvbmcgYWN0aW9uLCB2b2lkICp2KQ0KPiA+ID4gPiArew0KPiA+ID4gPiArICAgICAg
IHN0cnVjdCBtZW1vcnlfbm90aWZ5ICptbiA9IHY7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAg
ICBpZiAoYWN0aW9uICE9IE1FTV9HT0lOR19PTkxJTkUpDQo+ID4gPiA+ICsgICAgICAgICAgICAg
ICByZXR1cm4gTk9USUZZX09LOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgLyoNCj4gPiA+
ID4gKyAgICAgICAgKiBOb3QgYWxsIG1lbW9yeSBpcyBjb21wYXRpYmxlIHdpdGggVERYLiAgUmVq
ZWN0DQo+ID4gPiA+ICsgICAgICAgICogb25saW5lIG9mIGFueSBpbmNvbXBhdGlibGUgbWVtb3J5
Lg0KPiA+ID4gPiArICAgICAgICAqLw0KPiA+ID4gPiArICAgICAgIHJldHVybiB0ZHhfY2NfbWVt
b3J5X2NvbXBhdGlibGUobW4tPnN0YXJ0X3BmbiwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgbW4tPnN0YXJ0X3BmbiArIG1uLT5ucl9wYWdlcykgPyBOT1RJRllfT0sgOiBOT1RJRllf
QkFEOw0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICtzdGF0aWMgc3RydWN0IG5vdGlm
aWVyX2Jsb2NrIHRkeF9tZW1vcnlfbmIgPSB7DQo+ID4gPiA+ICsgICAgICAgLm5vdGlmaWVyX2Nh
bGwgPSB0ZHhfbWVtb3J5X25vdGlmaWVyLA0KPiA+ID4gPiArfTsNCj4gPiA+IA0KPiA+ID4gV2l0
aCBtaHBfbWVtbWFwX29uX21lbW9yeSgpIHNvbWUgbWVtb3J5IG1pZ2h0IGFscmVhZHkgYmUgdG91
Y2hlZCBkdXJpbmcNCj4gPiA+IGFkZF9tZW1vcnkoKSAoYmVjYXVzZSBwYXJ0IG9mIHRoZSBob3Rw
bHVnIG1lbW9yeSBpcyB1c2VkIGZvciBob2xkaW5nIHRoZQ0KPiA+ID4gbWVtbWFwKSwgbm90IHdo
ZW4gYWN0dWFsbHkgb25saW5pbmcgbWVtb3J5LiBTbyBpbiB0aGF0IGNhc2UsIHRoaXMgd291bGQN
Cj4gPiA+IGJlIHRvbyBsYXRlLg0KPiA+IA0KPiA+IEhpIERhdmlkLA0KPiA+IA0KPiA+IFRoYW5r
cyBmb3IgdGhlIHJldmlldyENCj4gPiANCj4gPiBSaWdodC4gVGhlIG1lbW1hcCBwYWdlcyBhcmUg
YWRkZWQgdG8gdGhlIHpvbmUgYmVmb3JlIG9ubGluZV9wYWdlcygpLCBidXQgSUlVQw0KPiA+IHRo
b3NlIG1lbW1hcCBwYWdlcyB3aWxsIG5ldmVyIGJlIGZyZWUgcGFnZXMgdGh1cyB3b24ndCBiZSBh
bGxvY2F0ZWQgYnkgdGhlIHBhZ2UNCj4gPiBhbGxvY2F0b3IsIGNvcnJlY3Q/ICBUaGVyZWZvcmUg
aW4gcHJhY3RpY2UgdGhlcmUgd29uJ3QgYmUgcHJvYmxlbSBldmVuIHRoZXkgYXJlDQo+ID4gbm90
IFREWCBjb21wYXRpYmxlIG1lbW9yeS4NCj4gDQo+IEJ1dCB0aGF0IG1lbW9yeSB3aWxsIGJlIHJl
YWQvd3JpdHRlbi4gSXNuJ3QgdGhhdCBhbiBpc3N1ZSwgZm9yIGV4YW1wbGUsIA0KPiBpZiBtZW1v
cnkgZG9lc24ndCBnZXQgYWNjZXB0ZWQgZXRjPw0KPiANCg0KU29ycnkgSSBkb24ndCBxdWl0ZSB1
bmRlcnN0YW5kICJpZiBtZW1vcnkgZG9lc24ndCBnZXQgYWNjZXB0ZWQiIG1lYW4uICBEbyB5b3UN
Cm1lYW4gYWNjZXB0ZWQgYnkgdGhlIFREWCBtb2R1bGU/DQoNCk9ubHkgdGhlIGhvc3Qga2VybmVs
IHdpbGwgcmVhZC93cml0ZSB0aG9zZSBtZW1tYXAgcGFnZXMuICBUaGUgVERYIG1vZHVsZSB3b24n
dA0KKGFzIHRoZXkgd29uJ3QgYmUgYWxsb2NhdGVkIHRvIGJlIHVzZWQgYXMgVERYIGd1ZXN0IG1l
bW9yeSBvciBURFggbW9kdWxlDQptZXRhZGF0YSkuICBTbyBpdCdzIGZpbmUuDQoNCg0K
