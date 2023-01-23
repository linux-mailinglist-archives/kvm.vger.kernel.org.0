Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B626773E3
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 02:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjAWBv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 20:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjAWBv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 20:51:26 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37831723;
        Sun, 22 Jan 2023 17:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674438685; x=1705974685;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rGY48v7TZq/F1gOxDnh5eYCXWOShqyAph82RF+BgtxA=;
  b=aBPmVXdQwR4S+TXkDM/sWN2YognowXKJaPmwmz5TsSBGGq2/lHXVyXp4
   xolmKGCyaSFMqLKaZPiV5R6RX0l5zvDwnoO8n0BGiqnZRv98f0qbiSnJ2
   rCwntmCiehNCrfTU1FUxJOCvJi06OGoExWRee9pJioUBXxvOPN1vtGPVa
   1xxLRJ+5lr3FOKEt/u0BrlGf0tddjYp8okyJrPO0gMheuwQCHfzBsAAaZ
   h4Pk5nAKgGtU7X01ceTf2ANtscZlinqqGtKZU1hGhfXCGma5rm3d8Op8+
   sqp2qZngAZ9nYcB3iR0xYOxLReoA2NsKJq5Zyty4FH1ylrKM5q7t322JE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="306316711"
X-IronPort-AV: E=Sophos;i="5.97,238,1669104000"; 
   d="scan'208";a="306316711"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2023 17:51:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10598"; a="693696870"
X-IronPort-AV: E=Sophos;i="5.97,238,1669104000"; 
   d="scan'208";a="693696870"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2023 17:51:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 22 Jan 2023 17:51:24 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 22 Jan 2023 17:51:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 22 Jan 2023 17:51:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 22 Jan 2023 17:51:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5Oe4gTZY7e0NxdiNEyK05SY0dwJmB5QRVLxzZIsBcVeCZ6anmEGR4kGFqJrcPnLaJy2V/HCDKgfa4rYyZ6lt/BHn0CZm1emZFNpX4Xu2MDHR7zuNkfxJ2R9CdmW03ugNKfL8Xvg5cI8SY7D70fV05/qZtCyu++2NZoQvX+Yb8+O6Qjo2A82eEw4hmvIaLsrseBkEnSV7EdQcTz+SIKUKX4ixAxnFbC7DhmnSa3q4m/HK9C2RTAWe8sIPOayrwvHCEeYL5Dfb14SM3Ei/zvDZCka6a/w9Nt0IPXmPMEqvcLOW8HZAIXppYY3801o+eKM4mwDSbRN1mzbZrIa6Pe6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGY48v7TZq/F1gOxDnh5eYCXWOShqyAph82RF+BgtxA=;
 b=AviiMJFvfRpUOou5hE1cOFds6u42oel0Xwsv9L9B6AHpJ6p4smc0xxHyUd5WiPhu8dGzYcNi5hJsdX1NqiGWzX3kTeHUAUmAe2WpdgPFlZwsZbg0EHqSRY+2fI2nw0kjwrEMqIZlzRQ64dDKFAf856sCayLcm2jIp7dlmoEEEJcU+1OdEFNZV/uW1wPY7eFQqVyUfKmeKY0KdZo1pr9caw13g8iMYMbTph5dFbQn5mdDP/pRxmXoQADvZDTa+2Mz+Nave+4V8loDEP//VWjwRjU0IDcVXpeFggrDsItkF0ccGxNrwa1KuYtloRFf0uSrAkhrJEHoVdatXnsWXvWmjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7101.namprd11.prod.outlook.com (2603:10b6:303:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 01:51:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 01:51:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAACa5AIAABg4AgAFyH4CAAB7oAIADQFwA
Date:   Mon, 23 Jan 2023 01:51:18 +0000
Message-ID: <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
References: <20230117214414.00003229@gmail.com>  <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
         <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
         <Y8ljwsrrBBdh1aYw@google.com>
         <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
         <Y8m34OEVBfL7Q4Ns@google.com>
         <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
         <Y8ndcGHUHQjHfbF9@google.com>
         <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
         <Y8st2PjGDQ+Q0LlW@google.com>
In-Reply-To: <Y8st2PjGDQ+Q0LlW@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7101:EE_
x-ms-office365-filtering-correlation-id: 8afc2c68-b169-4118-6da4-08dafce45256
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XF0wvXmq2HP0AdZ9ymwwecvc1b1vW4iXwu+bKXYBCfYKHnh4NnqcTeb9iWIimfkgPcKDtpUteZ32uULZGuU7rHeb8/MVgU6KBBPL29T3xe/O7oG9pTlwdpiOurEE2XtfowA04uQGdeJQ9SWOdgKq1+5vncKDpQx7jlGmZUMvRaRCK+072b9XzvwswSbxGvhUyMXrUWST5h5P30ueaBycTIRghYjuwdhmK7V+7lQbJHv3cEE03rOt7gsxzxtaCNKXu3MZQDPq7DB3P6DdZLVH9X2srUWjFNlubyh994AsqMIRDEAjAhxVK3JlKBhfQfSlfrP2FfYiwSCbqosGg3hODDnTgYGFp7JNgtSq5OVG2WnQTNHISPmgc/rvy/24HRVklPGO8cQOPK13U/prS+diUiBEn49zN+Jfd3ovLBNRhNAg+ph3Wkvm0mo59mSGrM/ZVQIZC/ZNWQSDehE075HzIR/PmT4LMFQFbBZx8enN0iDUTUwxCMICyDPXsQizwb24GZlKYQ2lavshA2OBXu51nibIGDLReLvEZQ/WHs4lVFX4+GlqQPO8OcguS3r/QCkNf6WL9IYPcECbKnryCSFID1cpIZuy97nrPQDPvaz9Y5jR57Jo5pKAG9g3nf7CI+Es5cCMjCdp+6XNhfrn48/c2Fi78ijfIVOa3QCY+veBZiRJB3VgaSTRRJEZbDZD0DCL5QoCGJUmU4NqrTc2l44Xaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(38100700002)(122000001)(83380400001)(38070700005)(82960400001)(86362001)(2906002)(41300700001)(4326008)(4744005)(5660300002)(8936002)(8676002)(6506007)(186003)(26005)(6512007)(107886003)(2616005)(316002)(54906003)(76116006)(66946007)(66476007)(64756008)(66556008)(66446008)(110136005)(91956017)(478600001)(6486002)(71200400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDJhSjMxN3BqcFNRZ3lSbWc4ZjRqZXRDWXMxVWJTelJUbVBnenZocDJFcEFa?=
 =?utf-8?B?Q1lrY3lHR0NwUWxYelJvMnRzRExieEU2Rmh2cVgvTnFucXZuc1cybGt4MHNy?=
 =?utf-8?B?Z0E3V0g5dXJwT3pYU1JkTzRFdnBvK0liSEZKdDU0c2gzenVYMFU5eWJ6NWNr?=
 =?utf-8?B?NXF1ZmxPTlZ2c0l5MjljUit6UFplVEl1clpyR3pUYXZPUDhEUkFyL2F1Sm1K?=
 =?utf-8?B?SFBGRjdDTklBK0NyY2ttRllud2h4KzlhR043STg5ODZDUlNYb25mb3BIYlN3?=
 =?utf-8?B?c3FGcWkyS01QOThPRFZIYWhMZmZmWlhzTUFNWEFrUTl5ck8wdDZVdWNybzZ2?=
 =?utf-8?B?QWpIV0VGR1lyQldRVHM2M1paZFFjYXl1dUt1NDR2QlpLRHZRQXJGMFh1a3NR?=
 =?utf-8?B?NVVzYjJzUE5GN0dIMUVmL3RLSjZkRXNFSklLVnVaeEtGakpyQXZaZ3dlZWwv?=
 =?utf-8?B?c2VRMkVmZXlvYW03Q2M4T09NN2FYSldkZS9nN0ZJRnZZTHNUOHNyK1RSNzZ2?=
 =?utf-8?B?cUVaMlU1U3BYa2RoNFNxVFU0WS9ibzRIU3dVUkw1VW1NcFcxKzFTV2xTS3dP?=
 =?utf-8?B?eTl6Zm5ZK2xmekpIVEhZZWxFM1ArZE1MU2FhK2ZZZ2tNZ28xZit4NVlpM3dk?=
 =?utf-8?B?OGsyYldYeXRPbG84QjBlSVVWd0FzSXNiNDAwcjFMUmltbW9PZmRFQ1dBSDRm?=
 =?utf-8?B?cjJuNnZ0UlB2OXZOY25XSGJFY3hwWVlSMDNaUytCZDJmTmZsYWIzTkxFMzd1?=
 =?utf-8?B?Qk9EWFNMSEhSQ2VQcVJrRG9PejU0M1RzUmI5MVZRM250OGFxeU9HdTQydHFI?=
 =?utf-8?B?TGhZQnZ1Yzk1Z0QwMFhTYlRzaGsyVGRXVy93QkxWQXdLZWZjamhXWFBPaU5O?=
 =?utf-8?B?ZjFVR25aLzB6T2IzSzhZcmNNTlU1OHlweFJMYTZXQVhPL01rYUtscHNCWFlB?=
 =?utf-8?B?YWNHcDcvMjdyRnFlRGN5LzhNL0hFL1hyMEFyU3JHSTF0dmh6ZWcrTFcwRHRR?=
 =?utf-8?B?VGxEU2h2UjQ3WWJZSEw4U1YzVmRmbU50NDFWNnZqdlpoQkRXSEJKc3c4dXVt?=
 =?utf-8?B?a1FzUTNvWURzdDM5ZC8vOGxDZWZwODVOblJxSTR3YzArMUVkaGFjeVgwc0JN?=
 =?utf-8?B?bXJ4elVzRkJRWE9GUjFjNFZhQUpNeW83UjJJcUlRS0ZucWVUMXRSbllqellr?=
 =?utf-8?B?NHNkK2dPeGpyRExuTTBNMlBrSFYwSlV0VFFQOVNlaGt5bEYvMENUa0NGckxZ?=
 =?utf-8?B?bjZyenFZcHRzajhRN0tENjBURHhNR2VNQks0TkYrSzNrNFl1MEtuSmxibWxG?=
 =?utf-8?B?cGdic2R3N2p1bWdYWlIzSGJqKzZKMEZPYjFsTGxPdUo0S0Y1OTlyazNlbUc3?=
 =?utf-8?B?TENRdXUwTUljTFlEcklwSGh2cHNTbXhscENDK0xkbkN4N1lrb0JuRzFnK0J6?=
 =?utf-8?B?ZEMyWTdhanA4bDI3Yk1INmtsZDhmN0xPQnk2Q05HeFlSbEJFZ2ZQZXEzQ1JJ?=
 =?utf-8?B?Tkl6OWMrZS9UdXdFazgyWkdsekU5WXYvSEpIY0tqUTh0U3RORXRaaFh5cE9L?=
 =?utf-8?B?aDdyWEVmVFNVcFduWXNwSmZVbXlZbmRtQjdJeCtKSE4rTGxVRGxxRkdzVW9L?=
 =?utf-8?B?Nm1SYTVuaW9OY2ZvSVRFWlRuckpoSTdWSjA2elN3TjRYc1VXNW5Mdk0zdzYy?=
 =?utf-8?B?ZnBNd25LYkxsV045V1lJOUdIUFBRR2lTU3FaM09KdWVvWWswcmN6TkowYnVj?=
 =?utf-8?B?NlFSTTNUUGhVL0lIODVqSy9VR2RCNVYrbFZDeEsrU0h3VXduWHEvMDdlRExZ?=
 =?utf-8?B?eWNIY0RIdG9KbnVkb3JYK2NtWFlSd1hQSm9LUzdvbG9JREJ2VGhwT2lIWHVO?=
 =?utf-8?B?cDhqOS9jdnNXb1JnRitsWjZFa1hLclNZKy9vRE9MREJMNXR1TklQWFRCUXJu?=
 =?utf-8?B?djNIVkhLbDdoVU9yOXNDWTh2UENWYXU2TzM4YUJnK3c0Wk03QnNQS3QvbWly?=
 =?utf-8?B?NEdnTDNoNzd5cml6REdZclZ1cElFb2hiaU9lMWdRMlZlRVBnUEVtbGY5b0Jr?=
 =?utf-8?B?YVg0TXlJUldmUVUwRXFNV1JTT1dqRjlwZFB6MkthR3VrcDlBTElDeVo3Szhq?=
 =?utf-8?B?TTgzdnpFNXVTcVM4clBUQ0JwOThoSEM1TU1SelpvcGJUWU5WeXVGVlFHaVRm?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10D98237E2B5794498334F06316464DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afc2c68-b169-4118-6da4-08dafce45256
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 01:51:19.0016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LYdXDBl0K0q/q+m4gCCH95wl4AnOQ8iAFL2x3yrUrABmlZGalhKjqAFaEjHKOWrMpAY/O8QhDYvFq5z0Sb8rAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7101
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gDQo+IEludGVsIGZvbGtzLA0KPiANCj4gRG8geW91IGhhcHBlbiB0byBrbm93IGV4YWN0
bHkgd2hhdCBzY2VuYXJpbyBwcm9tcHRlZCBhZGRpbmcgdGhlIGZyZWV6ZSt1bmZyZWV6ZQ0KPiBj
b2RlPyAgSXMgdGhlcmUgc29tZXRoaW5nIEknbSBmb3JnZXR0aW5nL21pc3NpbmcsIG9yIGlzIGl0
IHBvc3NpYmxlIHdlIGNhbiBnbw0KPiB3aXRoIGEgc2ltcGxlciBpbXBsZW1lbnRhdGlvbj8NCg0K
SXQncyBkb2N1bWVudGVkIGluIHRoZSAiVERYIFREUCBNTVUgZGVzaWduIGRvYyIgcGF0Y2g6DQoN
CitURFggY29uY3VycmVudCBwb3B1bGF0aW5nDQorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
Li4uLi4uDQorDQorV2l0aG91dCBmcmVlemluZyB0aGUgZW50cnksIHRoZSBmb2xsb3dpbmcgcmFj
ZSBjYW4gaGFwcGVuLiAgU3VwcG9zZSB0d28gdmNwdXMNCithcmUgZmF1bHRpbmcgb24gdGhlIHNh
bWUgR1BBIGFuZCB0aGUgMk0gYW5kIDRLIGxldmVsIGVudHJpZXMgYXJlbid0IHBvcHVsYXRlZA0K
K3lldC4NCisNCisqIHZjcHUgMTogdXBkYXRlIDJNIGxldmVsIEVQVCBlbnRyeQ0KKyogdmNwdSAy
OiB1cGRhdGUgNEsgbGV2ZWwgRVBUIGVudHJ5DQorKiB2Y3B1IDI6IFREWCBTRUFNQ0FMTCB0byB1
cGRhdGUgNEsgc2VjdXJlIEVQVCBlbnRyeSA9PiBlcnJvcg0KKyogdmNwdSAxOiBURFggU0VBTUNB
TEwgdG8gdXBkYXRlIDJNIHNlY3VyZSBFUFQgZW50cnkNCisNCg0KKCBJIGd1ZXNzIHN1Y2ggbWF0
ZXJpYWwgd2lsbCBiZSBtb3JlIHVzZWZ1bCBpbiB0aGUgY29tbWVudC4gIEFuZCBwZXJoYXBzIHdl
IGNhbg0KZ2V0IHJpZCBvZiB0aGUgIlREWCBURFAgTU1VIGRlc2lnbiBkb2MiIHBhdGNoIGluIHRo
aXMgc2VyaWVzIGF0IGxlYXN0IGZvciBub3cgYXMNCnByb2JhYmx5IG5vYm9keSB3aWxsIGxvb2sg
YXQgaXQgOi0pICkNCg==
