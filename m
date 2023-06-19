Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4170173560E
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjFSLoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 07:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjFSLnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 07:43:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A26311D;
        Mon, 19 Jun 2023 04:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687175034; x=1718711034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V4TQsGqjFqEAAkzLjOg4jF+6uSF9gPUdbe/l4g+Ae9Q=;
  b=HCvYbx1nwY4q9e+CfxiOZuL4ZZZDqkifHN5znzgZRKLwsFi9U4ta8m4q
   btw41E+jTagi9nczxJ/jCRmlrE/qwAmFowbuQ1yun2ZDWL4YxafKX0922
   HWWLD2K5p4XTDYAxrOS4eZyW/e0sz6v7nkO/f4dgpkZeyZqK9NsT4bLiO
   HShpJuAt58OWbesNJVxtXNxGFWGTKPt2yEijsia5oCK8vSpB0jcRqhYW1
   4e9W9VZxiuauYC24LpUl9Nr+5/hNTDWI03ImdJSYTBg0PK1oYjb/Pizgr
   9K1HDdi0oIILQSjc9SYs91vSZ0uCRf9et0bdaIMyTRGFyfwHqLv1ydZw/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="363034694"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="363034694"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 04:43:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="783677332"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="783677332"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jun 2023 04:43:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 04:43:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 04:43:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 04:43:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 04:43:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKmh1d4eI+q++eUCt5P7vTIYGKj+LTgtB8goniOSgW3Ke6/VqcA5vVYJUAL8JJ84qF4sRgAVWsSx31FNiJIZcBHGXw3caDU7a3SF7TTe709QVuHtRrDbSdcS9HETZpvyk8JZnQiOWl6WvopLgzWAAb8atdnoXTlrMYN0mxXH5ynjkr4HgcsLrzHSIJSg9xuGvEVVzQ3SRShhj3/l46JP5rTsLrMO7SG9PQDcx/l0nPMYL5ddvOLBoKxePdomXTN6flSsLRivy+7syUHQhs8hDHhx4DAnnHIYgjthrxM0MmTHL/IFw52OVIaMcMsyRY+KJupmAnMxL20cE5jLBrF/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4TQsGqjFqEAAkzLjOg4jF+6uSF9gPUdbe/l4g+Ae9Q=;
 b=l+MJRvsq8LZjt+Mvz6xwrs560vENSRhp2mF9ku55YQzk9D4nSL9I4zbQ1CBB3fC1yHCc0POx2SyLgaxjJGPAkMobKejOu7XOkQfCOLEhVHnlKoqMjrgCHt82RPl0+fMnzrnIoYCFziE7mI/Zr0wiAMqHeLfO1AdMRwRv9NqFb7Ga/1XV1d64NywjsY0AP1S1vwibxyO8o1NJ2VtPL2F5IX+/h0u039F2dOLG1KUar5uO4VLmk7PPrakRe0IAwctDRWKrRfOCwXbVGlmcBiYOcdsGlACvpwiiwS/ygKIvyeHXYglJqxAzv9FhyDIMnskypz1GQhfdzgRdVpbwAY7hFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6486.namprd11.prod.outlook.com (2603:10b6:930:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 11:43:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 11:43:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCACt3UgA==
Date:   Mon, 19 Jun 2023 11:43:45 +0000
Message-ID: <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
In-Reply-To: <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6486:EE_
x-ms-office365-filtering-correlation-id: b0267d61-5e4d-4049-dbce-08db70ba7079
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XrqvX86h8QlEgVRDl3kgbzfsdyk0ylvOhwbu9R81LyZUVS3/NqyVoAaU8T8NKFVvPYhT8CO1VieHT8pBdKKXaLeWBxGT813HtbFnlVeD/HaDdXt6cAoX1xyh+NejrJD34ewLtw4cfT0xADhJf9ReSgy2G/Y+lpvpX5AyRxuHh8apU+dmUupz2j3lEnOkhKXx6O1Q9AgafLeQxOQjp4cgxk+j7Q6kcR3DTkEqbf0icvq7UeIsf5J068ogHZEcG/f+Jgi/KM3pwVNsYGiTh+sut5Sl8ociAqhmBIWyQTXv1aTHAbj+B3d9IM33/IJjkhKERIJnwHXxG6x0Fh/oH3Yfyq0O/YfhEEGYfwiieSxU2nSXMyheVQVGon3e9vdP9tVq/jZTz1PCrdKP+ZjLODwK7mZA97xc9jGpDzO5+Ss6fzt1QcghzU1GOofGLB0xi3A1oXLIWGEEi/uVoU6LGxpJOgPJN+3mgBf3//CR4IZ4EslnklTgE+ruBI56Z2st2VU+QFheT0Gu6tLZy+Kyf2NUQ2r0aaLPQ0hbwCCMNg4QXFTAYX97C7EpSzIrlEgOpEwwtd7Tp7t28w/3R6bv/Oa60Y3iKU2cBbgzyngCHTHjF60KzRyJ3PIZRfiL6mIV7NPX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(53546011)(7416002)(66946007)(8936002)(8676002)(66556008)(64756008)(76116006)(66446008)(66476007)(38070700005)(26005)(186003)(6506007)(6512007)(36756003)(82960400001)(41300700001)(38100700002)(5660300002)(91956017)(6636002)(4326008)(316002)(54906003)(2616005)(6486002)(478600001)(2906002)(4744005)(122000001)(71200400001)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE5RL0txdFU0ZUs2Um1EMDJQdjExNTFueGNOT3lmMXNLZ2QvUE52NE1KWmps?=
 =?utf-8?B?cExhYk9kRHBYendZYlNxcFQ0cmlWN0lQSTdIZVI5UC9sbVhaRkVPRjlsRWRI?=
 =?utf-8?B?ZGVnZTVoYjhZbEZKSXdxemczRlFwRm14UUxCdUxIQlVNdXNLcGx6MVZuWHlh?=
 =?utf-8?B?WGhnYjIvek5XeGs3MlFkaytBVVgzQ0FyRFFuUENBSTcvUVp5SVdnZ1dOMkhM?=
 =?utf-8?B?ZlgvMHVSaXJ5SmFLb1lVdk01UUduWGk4NGZqb2g4TU5ZRDMvZGNZNGRSUUtx?=
 =?utf-8?B?L0ZrR0dGMHRCU3Nsa2lobXI3dEpDK3FNZlhsc3QweWoyQzBrK3NzNWpIeEcy?=
 =?utf-8?B?OEFtMksrUWRxRmQ0cHU3bSs3a1hjVERXSlg3dzdkelNKV1JBN3RTT2VJQi9i?=
 =?utf-8?B?ZDJ3c2xzOW11S3oxWE5TZ25Da3lZdEhucjVDOTBLZGh3U0t0a2Q5ZktTR3Qv?=
 =?utf-8?B?RDN5OFNUYkliWlVUUEphNlRMcDhnZU94TVlicFdFckkzc0lGWFh3cEtSWU1i?=
 =?utf-8?B?dTRqQzJvVEd3RTgwZGJoUFpwV0JKQW1UdkxrSjRQMHAzeUk4YjZqZUtsak1l?=
 =?utf-8?B?NVlhazhzbHRCczFQN0hZRC8xUUpQWllaV3lxOWNBUW1yTWZiV2hrM1d5SjVk?=
 =?utf-8?B?SWhDbEF4Z21hTzFzVGlWZjhpd0VBazJaY0hIL1BRS2JuOXQ3d1RnSkZMLzZO?=
 =?utf-8?B?dDU1VTVtdWtkMCtjUEF3NDdTL2E2UWxmRFVFSGlYcjNwWndnejdRVHpkVThF?=
 =?utf-8?B?RW1DUXV5ck5CT2FjRm5Ea04yWGs3MnVXdFdBYSsvemxnRVpJNm9PRkRxZ09B?=
 =?utf-8?B?QkRtZk1zQUE0bEtoMVlCMzZYK09FLzNlZ2JJakY2S2M0b0hWNWdYWTc0Z0ZP?=
 =?utf-8?B?WnRKemRCQXhyNnpNbEExT0xQQjBrV1RSWkFubUtvR2hoaWh6M0hFRUkzZkZT?=
 =?utf-8?B?aXA1clJUbHpBWXhGMlc3S3MyM2lBRFY2eW0zTkFER25NVVdvenhWS1FXVTFm?=
 =?utf-8?B?eUovcEFMZC9naW5LTkl0ZXNHVnloQTlkMmIwQ3VETlU0OWNWeS9JUlpmQjZD?=
 =?utf-8?B?ekJBcjdvTXBuQnlLcWxiK3NDd3ZxN3NwKy8yV3YwWUVwdEFabUdhSThQTzFj?=
 =?utf-8?B?eFYxRnJnWThlT0V6d2k4U0pDbGx3cWNXVWozMXRxNUhBdDRLS05NdnMwYnZv?=
 =?utf-8?B?VCtvOFUyOXIrakJTcEtudElVTGJjVGFPMTJzczB4ZzExUGt1alByT0Y1ejBE?=
 =?utf-8?B?cjQzODZ4ZVRHNktSZ0ZMdzNKYXRmbzJBR29FV2RWSEpUbW1ZZ0JBUTJWcHVN?=
 =?utf-8?B?VURFb2ozekROeDg0c3lLdkp2SUU2OTlmR1RCTnpLYitJeHVPMzhGcnlXU2Vi?=
 =?utf-8?B?b0ZqT1pQWXMrRENONDhaVnozRjR2VkhNcEtFSlg4MjF2Vm1hNEsvZUhOdVEv?=
 =?utf-8?B?Y2VHYSswWXJ4dStndFAyanJveWRvMndFcnpVMm5xcWhITE9KMUYrcFo2MTdo?=
 =?utf-8?B?Q2htVVA0SlRiMnROR2JLTUV4dHIzaGk3c1BTWHBlVThLSzlBMGk2cEdlbXEy?=
 =?utf-8?B?a0xOMlVQeUU1ZVFOVjJZb2tFbVBma0pGU2JrTHp1VHpGeVl1NExNUERXNVBU?=
 =?utf-8?B?UVVXbm05a2NubWRDY05XeVduZmYwSXJ4V1Y3RTdQL1o4bTFWZ3dJY2hXSmtp?=
 =?utf-8?B?akhFZEQycXhqOG9EaXBNeUFCTENqc3hEaXNzc1ptODVySklld3lyUC9lM3hh?=
 =?utf-8?B?czh6U252NG04VWZEbXRjZHBWZmV4ZnozRGw4WFJKZ2s3VUNyUy96eEJVeVho?=
 =?utf-8?B?bHI3TlVYYzE5TjUvNW8remkvS3V3cVFIN3BHdzRKWVdkUE45ZkxET3l3eVhB?=
 =?utf-8?B?Z1NyV3U4Z1o2YWhORU1tUEwxZ0d3OXgweEo1eWxYb3IxMFRQOWRMbXVJeHVa?=
 =?utf-8?B?c1VlbWFwOTIwdDZBVmRlUUFjM1RQUWgyODlRdThxNDE2bCtuU1N3U0xaZTlv?=
 =?utf-8?B?Q3JHUk9xU3U2b1ZrRW5YWnZxT1JtOUJYNkdncVNWNlFraWdaeThjY0RTdVAv?=
 =?utf-8?B?QzVZbkFycUVaSkdBanY4eXFEWGptTzhrcGsxSlhCNFNmYjZlQ2NMSDBiNk4z?=
 =?utf-8?Q?eZHOQmUMHN4+Ofetkm83krhUN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC16DE6C86F2834B87ABDF2FE50F7D93@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0267d61-5e4d-4049-dbce-08db70ba7079
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 11:43:45.5740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QQ+0O2kVQsWGUqXTo31XqBxE3U2mMakSmMxr0fa9jvdU7bX2oFQcYrN4hHMVDjcpKKXYhfLPUTzgkHqQlOSjbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6486
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTEyIGF0IDA2OjQ3IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xMi8yMyAwMzoyNywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBTbyBJIHRoaW5rIGEgX19t
YigpIGFmdGVyIHNldHRpbmcgdGRtci0+cGFtdF80a19iYXNlIHNob3VsZCBiZSBnb29kIGVub3Vn
aCwgYXMNCj4gPiBpdCBndWFyYW50ZWVzIHdoZW4gc2V0dGluZyB0byBhbnkgcGFtdF8qX3NpemUg
aGFwcGVucywgdGhlIHZhbGlkIHBhbXRfNGtfYmFzZQ0KPiA+IHdpbGwgYmUgc2VlbiBieSBvdGhl
ciBjcHVzLg0KPiA+IA0KPiA+IERvZXMgaXQgbWFrZSBzZW5zZT8NCj4gDQo+IEp1c3QgdXNlIGEg
bm9ybWFsIG9sZCBhdG9taWNfdCBvciBzZXRfYml0KCkvdGVzdF9iaXQoKS4gIFRoZXkgaGF2ZQ0K
PiBidWlsdC1pbiBtZW1vcnkgYmFycmllcnMgYXJlIGFyZSBsZXNzIGxpa2VseSB0byBnZXQgYm90
Y2hlZC4NCg0KSGkgRGF2ZSwNCg0KVXNpbmcgYXRvbWljX3NldCgpIHJlcXVpcmVzIGNoYW5naW5n
IHRkbXItPnBhbXRfNGtfYmFzZSB0byBhdG9taWNfdCwgd2hpY2ggaXMgYQ0KbGl0dGxlIGJpdCBz
aWxseSBvciBvdmVya2lsbCBJTUhPLiAgTG9va2luZyBhdCB0aGUgY29kZSwgaXQgc2VlbXMNCmFy
Y2hfYXRvbWljX3NldCgpIHNpbXBseSB1c2VzIF9fV1JJVEVfT05DRSgpOg0KDQpzdGF0aWMgX19h
bHdheXNfaW5saW5lIHZvaWQgYXJjaF9hdG9taWNfc2V0KGF0b21pY190ICp2LCBpbnQgaSkgICAg
ICAgICAgICAgICAgDQp7DQogICAgICAgIF9fV1JJVEVfT05DRSh2LT5jb3VudGVyLCBpKTsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQp9DQoNCklzIGl0IGJldHRl
ciB0byBqdXN0IHVzZSBfX1dSSVRFX09OQ0UoKSBvciBXUklURV9PTkNFKCkgaGVyZT8NCg0KLSAg
ICAgICB0ZG1yLT5wYW10XzRrX2Jhc2UgPSBwYW10X2Jhc2VbVERYX1BTXzRLXTsNCisgICAgICAg
V1JJVEVfT05DRSh0ZG1yLT5wYW10XzRrX2Jhc2UsIHBhbXRfYmFzZVtURFhfUFNfNEtdKTsNCg0K
DQoNCg==
