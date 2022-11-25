Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E136381FC
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 02:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiKYA7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 19:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKYA7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 19:59:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632CAA454;
        Thu, 24 Nov 2022 16:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669337972; x=1700873972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Dm3HeAj6gmwfXsMdnPFy8kOynvQS+Iy+GvvzsJ87DDk=;
  b=gmOWWZ7iPBHW3+wv42+ZDRczE3jSCc2gAJfr4F99y0ZLGzhJW9PpIFKT
   DpDZ2CO4OB8Oall6YmHCy4Sj3HS3tDzSPeBwSej83JW6MXDGZ+6LMi3AW
   SZEG4poyJ6JpbT/bRlwOY/ULJVOHCvOrN+9wAOycLk8QHI+py+IC6Yae3
   0Mmc/wltUlx3tLiJIYoGqlJQgpdJ1YROMr8BnlMcQu3eovIn5IEehA9Ng
   3P1h7My9/ewClCzw0Fb9oNqycYqqx2xNBkYQgF+lbucwL4MiADKE+csai
   m6pGUCv++71DA4mKVXqBsiSKztsCbbvl6UZJSLOdZO9tSoKTTQFr2xnQl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="315541236"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="315541236"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 16:59:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="731278763"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="731278763"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2022 16:59:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:59:30 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:59:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 16:59:30 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 16:59:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Emh0hOvLZj5R11jNcm/045ny0q+sZvygebfOqJL5WGjKyQneAI6tO0vfTOCsph+6B3OAmF3dosrKrrqxoyaEgKQCpPwx+gvf5V5R5L9NVhAz99GYecMgAQlpVGHJ83dTDwSs0EKbZonV60N8jX9Q5U+LzaL2KREDQlvj1TRK06rC/EFvSIHR8URpzrWs2eYnzHYz4OPdE8LUyJAE8yPbhMA0hDUJlO5VY/Z2qpX+4Qiaq4VDxM5mj9dbDF8XDNW0LYGEaTQchN4hAUIpm0TKTEUPBy/zTTOdWMLDXraCLQHIZn+CnrodDMcyvwE2fU+CRANOKXTPocPY0rBYgJ6lzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dm3HeAj6gmwfXsMdnPFy8kOynvQS+Iy+GvvzsJ87DDk=;
 b=Jz1WeBX0ijcVdoOuBD+tHei7JLpHLwBldZPoh0k4s3UcVE4L77MoQWyXpl46DHEI2lK3iJ5jyX1sqYGklBYgKOoIy9e8UkGp0gS3t5N5NvjXCdeMsMmq1Qrr2shj2mYN5jNU9VhtTdqKTbpE5oWhbwvzbNfZb0tfz3HfafQ2379pP2HW0oM/0CL/Hcb1NhKr4Ohgj/d9OpaQVZ3deDXUKrkTdXT03jXWpvRMZL/xeSYA+BS8zP65bL4ecRomt5vO6zSNiQjKKFKledW87Zpz8/zsMr5qxW/J3M5+mfBh/rg288oK15BJwbZAFOROhcL0IzuYufsV8gsrvD6ENPSwEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB6766.namprd11.prod.outlook.com (2603:10b6:a03:47c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 00:59:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 00:59:25 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs
 and global KeyID
Thread-Topic: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs
 and global KeyID
Thread-Index: AQHY/T3K4h1rHLbigk+AO0UKIyHeB65NNAoAgAGjyQA=
Date:   Fri, 25 Nov 2022 00:59:25 +0000
Message-ID: <cb83246f93281138f0e970bfccea4b13f2a64046.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <344234642a5eb9dc1aa34410f641f596ec428ea5.1668988357.git.kai.huang@intel.com>
         <301184ce-05e5-871c-7a6c-4298a0cbd1ae@intel.com>
In-Reply-To: <301184ce-05e5-871c-7a6c-4298a0cbd1ae@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB6766:EE_
x-ms-office365-filtering-correlation-id: 16d71923-966d-4b64-eed8-08dace804c3a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D9SNWvaN6NfsrkRe1xKqjRkWzRgFf67x0iiG+oGnBpnN4ChAPrQO8UhrP32AN30giJPrMVCqqRdfiI2bd7XxnPB2gWwy6wiJK0LK9OpJCDd+b/65xRsmb6yiCW9Rr01oDydN2DoeqJnyEjuDTeshfGSufDhqf2vQ0VH1wx+UFG3GFlKivEFqElo6q/u0f06xEHruvwyTJqlHxIog2AGzZ7jEEi85KwLNp/45irS4O80Biyi4mZx8fwCF7Ap3uE+XCQCG8ggKpyag+r02bcTd4fXG+VGIIXHyIslYjFh9Q2HGb/OsECz5TTY7UKXXMiwuM9kp17Uxeqb0uX45oZtvzrdlV0PNO2YAPZ5Hrq2WR7RSziB6bBGJmjxFKlBuRUF3H4YwbqutylmuHu2vPkU6R3CtiGKjLbvXc0DAIcJG+gKspD8xhRC58Za41AGQ4Psf3dlQyu7hmbsZ8JvV9Mon8RX8K6x+abukGByTN+eyoy4hJGVk4xU4o+Qfd88qMgtGhSlMUTwWWPU4VQhhteF/IYoIGDumK1Jczg9V+s4FK2O7z1kuKxYLlTjI/mGLcD7lQXppt6F1mp5r3H9LorfJmg2yIKij12s4t1G5/XeLKIxUS22Vmw7kXtQZAIjS/hjKcJjxAAsNSjwNeplHCDQo9RJF/Th+/KdK+xRdT/OB24xNckGdrHZE0Xh8Wsv0mxx7KjXKpaA63i7Zlr1X04RLAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199015)(122000001)(71200400001)(38100700002)(4001150100001)(8936002)(2906002)(478600001)(6486002)(38070700005)(82960400001)(53546011)(6512007)(6506007)(26005)(2616005)(91956017)(4326008)(36756003)(54906003)(76116006)(66946007)(86362001)(64756008)(8676002)(66476007)(66556008)(66446008)(110136005)(41300700001)(186003)(7416002)(316002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkswcDkvOXo3NmNpd2xXRjIrYnJldTdDZWFGcjhySmxxR1d3cWxLL050Tmxk?=
 =?utf-8?B?VmRJNWxTZEtrRGNBVjhCQ1ZmM1dUbHhDOVdnUnl2V3FIdkVGekZQbHlUN0p6?=
 =?utf-8?B?aGRlSEJXRE1MTnNUWkVLLzhZRzdlVXpIUjd6NWVaYzNpMjBldVVQQTRMczha?=
 =?utf-8?B?eHpUc1M5dEdYWWpPeXozRTN0cTVYMmtaUUtxOTZLOWpSK21zV2YybWQwbE8w?=
 =?utf-8?B?ZVlzM2pUcWd1WFFha1plVVFLRHBDUEZFKzNQMkIxaGVOZDd5eXpZRXFvaUxj?=
 =?utf-8?B?TU9FZGxsRDZpOHkxWGtYZ0NZTWg5TFBPL1ZlMkhQL0M2c3ZXQ20xNFBNY2E0?=
 =?utf-8?B?TlA1cDQ2RGxyQVpzOFNjMHRQRlpDZkhLZ1FpbmxLTTJhYlFwTHNDTTZ3cVYv?=
 =?utf-8?B?bzdIa0hXaXIrQ1poaW5MbE82K29wQWk3YkZ1emhWSTFFMEIxSWV3eUJxeDNO?=
 =?utf-8?B?KzFLR0Uya0lkWTFCK05VdTJjNFZwUjlzMENaOUowSG5vbVc0cGljdzNkYzlU?=
 =?utf-8?B?VnVTN0x3bnNJTTNDcEp0QlR3eUtyMXl2djllTk5mZHBNNUd4eTZUT1lOa1JW?=
 =?utf-8?B?RVJ5TkczK3J2bCsxdmlhblNWeHZmVkJlSnZaUzlIbmQ5Y01LRTVOa0Y3R1pm?=
 =?utf-8?B?UWdxY3VycUE0MWRBTVJXaWJJR2ROWEZwdnk0Wm4waFo4T0R1SmtTcHpNUjdH?=
 =?utf-8?B?aGZwVVpnY2l3bTF4cWQxc1dQc2c2OEh0cG9hTHgzS1QxNUpXaHlCb1BwU2hq?=
 =?utf-8?B?N0hKMmdxWUU1WHlmTWVUN2FjQTJ5aVlOenZzSEYrbTRZSVFIN050V0tXZU5N?=
 =?utf-8?B?a2N5d1JkeThkK0o4ZFdqWU5FbXpRNmh1SElQeGhzQTFRWE5maWwwdDl4OWha?=
 =?utf-8?B?TDlJSWFXYlZlNDU0VXZEc2NoSTFhdzV3UDZCV0pSaE1TRzdFTzJmeVREVUVu?=
 =?utf-8?B?aU1oQUhsRjBCRTlOcUlLOTlVVnVYZ3NFU05seEdORFpjcUFCRy9JQjhRVVJT?=
 =?utf-8?B?c05wY00ySDEvelgwVTBUTmpCc2Q4NTA5OFlmU3ZIU3FUcnljNkJaSUtBd21s?=
 =?utf-8?B?TndqQzlNMUpUS0tFMWJnU3FJSTQ0a1hRNU5LV24xZG1CYVg3ckZtSFpzQm02?=
 =?utf-8?B?YmxIaWYrT29lK1dnN2ErbEdMN0wvaysvSS9SN2ZJTFZnU0QzV0hCZ3VsRm1F?=
 =?utf-8?B?ZURmUnBsaHpPZjNNSHNYa3JEVjFpY1d0Zm1Td2hTWmZKRFpiMW1KdTBmNjU0?=
 =?utf-8?B?d0NGVE8xanUyV05LbzRIL1dyMDB5aTJmYkNuaXJLWVFDbkxGak9JZU1JWi9X?=
 =?utf-8?B?NFFlQWo5b2RRckhDbjk3TVlIZk44blY2TkY3MklXZy9Bc0dHMHUwU1p1NUh5?=
 =?utf-8?B?TkpvQ2pkUy81MGpKKzNoMXFvMXhUcDFTT1ZxUFR3WFBNbzE2WHZmRHo4Nml1?=
 =?utf-8?B?dDhhaTRvZ2JldllrQ2pobzlrZGsrODUzT3ZLSVFlV0p4ejNibTNiY1d2U250?=
 =?utf-8?B?Z3UrZjNpNmVsakxLOXhiVUZpMXByVnRFQmFkWU9ad3dqS2djWXhuMTMrWnFS?=
 =?utf-8?B?VjdqUXdQaThPNXZvbUJmQzFHOFNvajlaVkFEYkdVNWVlRlBzU1JsZU9xVWRq?=
 =?utf-8?B?SWkvM3BHZ3djTy9lNFdmaEI3cmgza2EvcU8rTGRVcGlrTW1zSURNcThWWWIv?=
 =?utf-8?B?NVBlTThEUXNqdXhMWDdvOGE0WHhEOHd3SnN1aWsyczFUTmd6d2pUbENoSzcy?=
 =?utf-8?B?MldEdUlYN0JXakdDOHBnRHo5amdvNkc3NldKTndXZmZxQ05XY2JKNy8zY1J3?=
 =?utf-8?B?WFRDZWJXSlIrMG0vSmw4TkR4ZDAzSDA1WmtnSzBLWkhxTDZUT2J1eVRsalNF?=
 =?utf-8?B?UGsvVHR1Qnk2U1h4ZlJvZEJubWMxdkhVWHFpZXUzeXdFd0ZEU0FYdEFSWE5v?=
 =?utf-8?B?UkdMdUFmSVJNQjlib09GVG9WdnQyd0hrWm1ncFZ6MnVVdFNzMmlvTnRwMkZn?=
 =?utf-8?B?djZVR0FKWktnMG1uSE5PMk50VCtMSjVqemxNRGhPcWJKdllLaUZUSnVJM2Nl?=
 =?utf-8?B?MlFxYkphZTFicERwaTV0RWJlb3puUGRMSkNTdEQ0aVN2ZjIxU3lISlpGRElz?=
 =?utf-8?B?bTZwS05LTEN3R1h6V1FvZTBGYkJOTjc0OExtdG9EMzFmbk4rTFFrNUxnTVl0?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <381BD18351EED34DA7B03E92B77205FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d71923-966d-4b64-eed8-08dace804c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 00:59:25.5944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MBcUZX0AEvAp7acYQlZ86WpGe9UZnh75ByF/3/dMxSnTU9+diRqfLFmeTkrKYWyhCV1fJVmcQYG/ErlKRXDGvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6766
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE1OjU2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBBZnRlciB0aGUgVERYLXVz
YWJsZSBtZW1vcnkgcmVnaW9ucyBhcmUgY29uc3RydWN0ZWQgaW4gYW4gYXJyYXkgb2YgVERNUnMN
Cj4gPiBhbmQgdGhlIGdsb2JhbCBLZXlJRCBpcyByZXNlcnZlZCwgY29uZmlndXJlIHRoZW0gdG8g
dGhlIFREWCBtb2R1bGUgdXNpbmcNCj4gPiBUREguU1lTLkNPTkZJRyBTRUFNQ0FMTC4gIFRESC5T
WVMuQ09ORklHIGNhbiBvbmx5IGJlIGNhbGxlZCBvbmNlIGFuZCBjYW4NCj4gPiBiZSBkb25lIG9u
IGFueSBsb2dpY2FsIGNwdS4NCj4gPiANCj4gPiBSZXZpZXdlZC1ieTogSXNha3UgWWFtYWhhdGEg
PGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYyB8IDM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAg
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgIDIgKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2Vk
LCAzOSBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IGUy
Y2JlZWI3ZjBkYy4uM2EwMzI5MzBlNThhIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+
IEBAIC05NzksNiArOTc5LDM3IEBAIHN0YXRpYyBpbnQgY29uc3RydWN0X3RkbXJzKHN0cnVjdCB0
ZG1yX2luZm8gKnRkbXJfYXJyYXksIGludCAqdGRtcl9udW0pDQo+ID4gIAlyZXR1cm4gcmV0Ow0K
PiA+ICB9DQo+ID4gIA0KPiA+ICtzdGF0aWMgaW50IGNvbmZpZ190ZHhfbW9kdWxlKHN0cnVjdCB0
ZG1yX2luZm8gKnRkbXJfYXJyYXksIGludCB0ZG1yX251bSwNCj4gPiArCQkJICAgICB1NjQgZ2xv
YmFsX2tleWlkKQ0KPiA+ICt7DQo+ID4gKwl1NjQgKnRkbXJfcGFfYXJyYXk7DQo+ID4gKwlpbnQg
aSwgYXJyYXlfc3o7DQo+ID4gKwl1NjQgcmV0Ow0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBU
RE1SX0lORk8gZW50cmllcyBhcmUgY29uZmlndXJlZCB0byB0aGUgVERYIG1vZHVsZSB2aWEgYW4N
Cj4gPiArCSAqIGFycmF5IG9mIHRoZSBwaHlzaWNhbCBhZGRyZXNzIG9mIGVhY2ggVERNUl9JTkZP
LiAgVERYIG1vZHVsZQ0KPiA+ICsJICogcmVxdWlyZXMgdGhlIGFycmF5IGl0c2VsZiB0byBiZSA1
MTItYnl0ZSBhbGlnbmVkLiAgUm91bmQgdXANCj4gPiArCSAqIHRoZSBhcnJheSBzaXplIHRvIDUx
Mi1ieXRlIGFsaWduZWQgc28gdGhlIGJ1ZmZlciBhbGxvY2F0ZWQNCj4gPiArCSAqIGJ5IGt6YWxs
b2MoKSB3aWxsIG1lZXQgdGhlIGFsaWdubWVudCByZXF1aXJlbWVudC4NCj4gPiArCSAqLw0KPiAN
Cj4gQWFnaC4gIFJldHVybiBvZiAoYSBkaWZmZXJlbnQpIDUxMi1ieXRlIGFsaWduZWQgc3RydWN0
dXJlLg0KPiANCj4gPiArCWFycmF5X3N6ID0gQUxJR04odGRtcl9udW0gKiBzaXplb2YodTY0KSwg
VERNUl9JTkZPX1BBX0FSUkFZX0FMSUdOTUVOVCk7DQo+ID4gKwl0ZG1yX3BhX2FycmF5ID0ga3ph
bGxvYyhhcnJheV9zeiwgR0ZQX0tFUk5FTCk7DQo+IA0KPiBKdXN0IHRvIGJlIGNsZWFyLCBhbGwg
dGhhdCBjaGF0dGVyIGFib3V0IGFsaWdubWVudCBpcyBiZWNhdXNlIHRoZQ0KPiAqU1RBUlQqIG9m
IHRoZSBhcnJheSBoYXMgdG8gYmUgYWxpZ25lZC4gIFJpZ2h0PyDCoA0KPiANCg0KQ29ycmVjdC4N
Cg0KPiBJIHNlZSBhbGlnbm1lbnQgZm9yDQo+ICdhcnJheV9zeicsIGJ1dCB0aGF0J3Mgbm90IHRo
ZSBzdGFydCBvZiB0aGUgYXJyYXkuDQo+IA0KPiB0ZG1yX3BhX2FycmF5IGlzIHRoZSBzdGFydCBv
ZiB0aGUgYXJyYXkuICBXaGVyZSBpcyAqVEhBVCogYWxpZ25lZD8NCg0KVGhlIGFsaWdubWVudCBp
cyBhc3N1bWVkIHRvIGJlIGd1YXJhbnRlZWQgYmFzZWQgb24gdGhlIERvY3VtZW50YXRpb24geW91
IHF1b3RlZA0KYmVsb3cuDQoNCj4gDQo+IEhvdyBkb2VzIHJvdW5kaW5nIHVwIHRoZSBzaXplIG1h
a2Uga3phbGxvYygpIG1hZ2ljYWxseSBrbm93IGhvdyB0byBhbGlnbg0KPiB0aGUgKlNUQVJUKiBv
ZiB0aGUgYWxsb2NhdGlvbj8NCj4gDQo+IEJlY2F1c2UgSSdtIGFjdHVhbGx5IHF1ZXN0aW9uaW5n
IG15IG93biBzYW5pdHkgYXQgdGhpcyBwb2ludCwgSSB3ZW50IGFuZA0KPiBkb3VibGUtY2hlY2tl
ZCB0aGUgZG9jcyAoRG9jdW1lbnRhdGlvbi9jb3JlLWFwaS9tZW1vcnktYWxsb2NhdGlvbi5yc3Qp
Og0KPiANCj4gPiBUaGUgYWRkcmVzcyBvZiBhIGNodW5rIGFsbG9jYXRlZCB3aXRoIGBrbWFsbG9j
YCBpcyBhbGlnbmVkIHRvIGF0IGxlYXN0DQo+ID4gQVJDSF9LTUFMTE9DX01JTkFMSUdOIGJ5dGVz
LiAgRm9yIHNpemVzIHdoaWNoIGFyZSBhIHBvd2VyIG9mIHR3bywgdGhlDQo+ID4gYWxpZ25tZW50
IGlzIGFsc28gZ3VhcmFudGVlZCB0byBiZSBhdCBsZWFzdCB0aGUgcmVzcGVjdGl2ZSBzaXplLg0K
PiANCj4gSGludCAjMTogQVJDSF9LTUFMTE9DX01JTkFMSUdOIGlzIHdheSBsZXNzIHRoYW4gNTEy
Lg0KPiBIaW50ICMyOiB0ZG1yX251bSBpcyBub3QgZ3VhcmFudGVlZCB0byBiZSBhIHBvd2VyIG9m
IHR3by4NCg0KCXRkbXJfbnVtICogc2l6ZW9mKHU2NCkgaXMgbm90IGd1YXJhbnRlZWQuDQoNCj4g
SGludCAjMzogQ29tbWVudHMgZG9uJ3QgYWN0dWFsbHkgYWZmZWN0IHRoZSBhbGxvY2F0aW9uDQoN
ClNvcnJ5IEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGUgSGludCAjMy4NCg0KUGVyaGFwcyBJIHNob3Vs
ZCBqdXN0IGFsbG9jYXRlIG9uZSBwYWdlIHNvIGl0IG11c3QgYmUgNTEyLWJ5dGUgYWxpZ25lZD8N
Cg0KCS8qDQoJICogVERNUl9JTkZPIGVudHJpZXMgYXJlIGNvbmZpZ3VyZWQgdG8gdGhlIFREWCBt
b2R1bGUgIHZpYSBhbiBhcnJheQ0KCSAqIG9mIHBoeXNpY2FsIGFkZHJlc3Mgb2YgZWFjaCBURE1S
X0lORk8uICBUaGUgVERYIG1vZHVsZSByZXF1aXJlcw0KCSAqIHRoZSBhcnJheSBpdHNlbGYgdG8g
YmUgNTEyLWJ5dGUgYWxpZ25lZC4gIEp1c3QgYWxsb2NhdGUgYSBwYWdlDQoJICogdG8gdXNlIGl0
IGFzIHRoZSBhcnJheSBzbyB0aGUgYWxpZ25tZW50IGNhbiBiZSBndWFyYW50ZWVkLiAgVGhlDQoJ
ICogcGFnZSB3aWxsIGJlIGZyZWVkIGFmdGVyIFRESC5TWVMuQ09ORklHIGFueXdheS4NCgkgKi8N
CgkNCg0K
