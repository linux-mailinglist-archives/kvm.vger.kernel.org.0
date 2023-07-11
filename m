Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCED74EEEA
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 14:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjGKMbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 08:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjGKMbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 08:31:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CDC19AF;
        Tue, 11 Jul 2023 05:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689078675; x=1720614675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CU0JQI39Dj5+6Fr6SYGJDe3i7nhhmCeWrRA6n4IFcZk=;
  b=YczVhuJM9yNVVGSW9Jwn/uw7nvdHT9OGSFVepoLgTcjpCLDFFYET+D2i
   GV1obKpZu8ZmYDt91cMoE5znBTub09xkKnCgJjydeYtI9lXpp2BL0CSUJ
   8Xk9psp6tX3nGekZDS2+epOt15M/gg/xdhovbO7wnGqDkJiK/XVlbRUdN
   YDL1S/FriCkEsJqMAl55GFZahpfMGacm0MxGx2P1DkhXMDyo+hFXEqdpP
   2rxpka7vrZLEQTolIHcJvei30inp6OeEdHft0mTXAD/ZJNbmASZan+EiJ
   MfDlUQ9RCQYSPNUH+jhH1ES/0l1delRbFCTZ2HPkYCJblmFXoRIlwbL6i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="368103714"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="368103714"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 05:27:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="865724966"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="865724966"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 11 Jul 2023 05:27:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 05:27:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 05:27:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 11 Jul 2023 05:27:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 11 Jul 2023 05:27:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxX0ND3PqUgX2q+qXEU/eueh4GgfjzpRT7lEI1TiijTa9YFIyi7P2Nyo2QXUM2gENYrFFzE7K8xG7yTORnMrj75ymaL4mh5Gl9WenXxFe2Zc1+pLmDrK4vh/Fkrq7nAc8esoZ2nOwIyaQZppr6GIwNJCZS0eYmYUVoXJdvvN/g2Dzp4BaiJPYl2YLk0AbF6yn/DMHY4gf08YX77f33Ub4kcU0wv7m57jzHq5lyYNEDCL5BceorXBseyjmpodQ7Y1IcZYOOx0sp8+TAFb2BoW635+AJWaLWbkudqNpn0PNubNQZO2KjVLSEE5Q+VFd7aWapZ3Mpa6kCb6t2AJ9liz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CU0JQI39Dj5+6Fr6SYGJDe3i7nhhmCeWrRA6n4IFcZk=;
 b=TFRHT8dAIeLPJiAtS9Mb5S7ZdFCz5oHmlm1QMC6+E+k/O/IPYpL5IrlDxWr2yyRhzYAhrg4YsBGNZ6sdw5eeBb+GbxzdK3UtoerbQLxJICvtcYNcl81MiAWqzO7jC/mTcWnNicO1YwY4ljIReU3dRcy9WgaHwD2BLG5nlEJUbOIHF8PDgxXXaZXCznW8H1SEhxYKerQzOJmdR2JP+rDwuywhEOu7ei0h5BVgSJqH6J4JoK8v0qCOvjJoXi1neggF7uBAxMUBe68S0gitKVeVt/zCTOWAoCqut2b5ylUGJ5is/hPe4BbV9iizwk/IQLlQ26UHfdVfWYWX2IJ8D/xX6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7365.namprd11.prod.outlook.com (2603:10b6:208:423::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 12:27:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::aca2:5ddb:5e78:e3df%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 12:27:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 09/22] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v12 09/22] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZqDWtkbP5LQszokWyXqcsetG/aa+0h+uAgAANsYA=
Date:   Tue, 11 Jul 2023 12:27:15 +0000
Message-ID: <442ada861ba975fa12ec380aed0765038cba89ca.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <999b47f30fbe2535c37a5e8d602c6c27ac6212dd.1687784645.git.kai.huang@intel.com>
         <700c13ee-cf4c-69bb-7477-4f959d022b0d@redhat.com>
In-Reply-To: <700c13ee-cf4c-69bb-7477-4f959d022b0d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7365:EE_
x-ms-office365-filtering-correlation-id: 3ff814bb-3032-4cc0-044c-08db820a2973
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0iUpQGgQalTsTf7tCRB9X6xIVXqhq9UsaRZw/hZ5tZk9nh045hc9/RQhMyiS2YiAWByBLocfEuIzallC12aR8/RjHZIwXUspJzOmJKeT0qqhIcyUBLkL7GtUTLKdn7aYHxGwPnMg2iiW4HvfKU1mP0ZOPYMuwQGnL/s5X1L8NkhgdvEXXvuDs6JyRSnERYarYvD83J7NlTbGbNAjxm/n/nULMvtL6/a9iPaPcCwaBd/ImVZOeag+uPvkGk/sP0QeeKS02jqIrZgNn1XslrTO1vOlg62qk/eyDg1fHypDNslg5k0zj16doYBeLj7sXRgFL4VfH/dC/sOphrvYdDsGA586YRMRO74uhVeLSQ1LFXtMmlK8DE2nNMw2yVVYR+ez2PvFrQIwwvKwZ6vyETXc3dRKNcpqJYTHknVZ6nVk+FdSN8tLEWrHeFYsTYLxxt2tBUbVFJQY7/ASB/gO7tWW6WTX3eFs5ETTuqmPHc0BZkyiHwut1QCNp3CIPxtmV8vK59mqgEvM4ntfxpOp8YgxvPIT8vnBYmg8koqOT/gdWEGpH1GAM0rZiQu4wQi125ZJ6kNOyKRm+pC6JtM9sYYXp6V2tYqpQ0gH987MFaVwYIJ6sljFz4nYhBd9XYAHH1wZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(110136005)(6486002)(478600001)(76116006)(71200400001)(91956017)(54906003)(26005)(6506007)(6512007)(186003)(2906002)(66946007)(316002)(41300700001)(66556008)(64756008)(5660300002)(7416002)(66476007)(4326008)(8676002)(66446008)(122000001)(38100700002)(8936002)(82960400001)(38070700005)(86362001)(36756003)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVU2SmlXVkRHU1JONWpOTjdZUC9jZncwUnpteWxRLzl1Y1NnM2VteHA0ajlV?=
 =?utf-8?B?YlZudFpWc3FzcUdtelhVU3hENUptVVdBL3pDUXFSQnQ1Y2ozSElZYkJtWnR5?=
 =?utf-8?B?Y0dma1ZyeEtQQlpzNXRGMVgwMk5NK2xMVUU4T3dpVUZqRUFWdjAyblpOSGNS?=
 =?utf-8?B?N0w0WkVsZUQrSlpwRFEzcU5XakV5aHNiTDlXMWxCUjk5NUR4cFU0RWZhZFRp?=
 =?utf-8?B?NmMrMVBCOGs0ZlB1blpLQ3JtMDVidlNLV3M4b3JKeTlGZE5PZTdKWHZmbDBm?=
 =?utf-8?B?eVBCdFQySit3NUZyQjZ4ZG44SGVpTDlsdDRuUW9ncGR1VjNqSzYyR1Zpalg0?=
 =?utf-8?B?UGFHLzNrWFRiYmNGZFpVOEluTDFOSEdRNnpDa0JDdjVtQ0dxd0xYamV4RGY3?=
 =?utf-8?B?WWZFazBHZXVLRTZNa1YrVkYwTkNSMjhVc213emZQTHQzaEJsQUM1V0UzcEds?=
 =?utf-8?B?M3h0ZVdSMi9aanRUa2JacFU3V0dBVVVGNnZSdFp5aERoem9wR2MzMjcwWU1v?=
 =?utf-8?B?VGMxTWhkVkpNUy9uejFubjFyVmEvQmtFc1FaT09aZnRJanZQUmt5bnc0b1Nm?=
 =?utf-8?B?QndpQlVJMlVhQXF5QnBXLzdDSjg2dG5CVFo4V2JaMGVqSVhQR1BpVlRuSWp0?=
 =?utf-8?B?aW9mb0hRUVA2ZEx2emVCbGVma0FsaTNmdzRSQ0NneGlMUzBRMy9kOGQ0MlJ4?=
 =?utf-8?B?YWN5aU5JcFc4YlVGSzdRMU5pSG1WRnRycXlodHd4ZFVFbGYvSGlERDd3UUU0?=
 =?utf-8?B?dFJkWGwwYlg1b08rRjlPbStROFUzV21oQlNBOHJIcnFMNkdYVWNuSlArUUVr?=
 =?utf-8?B?RFlXc21VMmNoUm5UL2x0azgrZmF4cUYzL05CRG9wRzRxWVZENm91M05ud202?=
 =?utf-8?B?Tk80YTlkM1BBaEpndkZML2Jsd2FwSXEzKzFNSFdJMnJOWnJwd1hOY2lvS2Rl?=
 =?utf-8?B?N2dZcjhVQVdNenZuQk52TGNHdHkwWnByV3JDMVppYVRjVDRsblZEb2hrV3JS?=
 =?utf-8?B?NGJRdUh2SmVDZHFxQ1B5d1FSRGVhZlBFckRIMlhFL0JORFVZU0JPbE9DMjl1?=
 =?utf-8?B?ZjBCa0lQVTBLOGg3NWV0K2JuNCt2NzdrWDBYT1pkNWF0eWpkTysybitUNndu?=
 =?utf-8?B?VENNTFlDZUt6Wis2S3dRa0V6cU5NeFpSdmRZS0ZadHhqejRuSXNOTnNVOHc3?=
 =?utf-8?B?cFZ0cEtncjFoWFJNaTU0SXVFVFJ5SXVCRkdkV1BIOURSYm5rendoekV0dElE?=
 =?utf-8?B?QmZCd3llWnZqZlFEc1Z2WStpbWFjM29GZDlJZ1FPZlZ3ZGdRUXYzNGtXT3VI?=
 =?utf-8?B?QjV0TG5FNTZtaWYydlM2b3Y3aCtnNTFKeUFjeGdPT1ZFaTNDcE1BWUtxK0po?=
 =?utf-8?B?L0x4OS9vTklvTkJLOUZlWWJva1gzdVVBclN2c3pSamdsYXBQQ01JTCtpejVt?=
 =?utf-8?B?cE9BZHR2UFpRR0NqeVpCTWpacUR2ZEMyODNGZUtxa0x1eml5WUdGaWNpcDM0?=
 =?utf-8?B?RVAvVnZ1T0VLSEZxN202SUdzZU9uRjFXaE5jOXJKb2U2enN6ajBJbTcxQkJr?=
 =?utf-8?B?NUdpRzZ3aW9kQUZjUlRBdEZCYld1SlRJR2RNMWtSOGV0NHhNc2FBSW1MNVJm?=
 =?utf-8?B?VmJ6OEx6NFBDbEc0N0VvUVgxSHlTd3kwVC9DcGFZYTNpc243bHBrSDhYcHhK?=
 =?utf-8?B?cHNoTkw1bjlGUW1ldkZuMkp6ZXpRaHNpS1RNdHNGTDBhNXFYcHFVQ2krU00v?=
 =?utf-8?B?U0VhNGgxY3ZWZ1RWYmgxd3crem1NVTlQaFVkR1RmNUhpVGZoY3N6K0RJQ0ha?=
 =?utf-8?B?T2JZQ0JpQ3RNaVJjYlV0d24zRU9kTU90NC9PNFdvK2pneGJzYUduektDTDVr?=
 =?utf-8?B?Q3k3MzVqQ3FCcWwvZ2hKRy81VXNkOVpqT1Bvc3J2aDJlWTFVWFBSdjl4bDBl?=
 =?utf-8?B?NnBkc3k1VFdzVVVnTisyMWdVRm9JL3AxajhEa0lUbnBaOUZFa3VzaEZ4S1Zo?=
 =?utf-8?B?NE5RSDRBelErNWdSeWF1a2ZFYVNTSnFpUTljeW5HdUNyM0tVNE5lQm9scDlm?=
 =?utf-8?B?ejhTRjBuZjlodGI4UW9VVktwNW9MMlduM2lJaHdnZnlRZmhIVVFQUVF5VlpS?=
 =?utf-8?Q?+95RFTJdQQ6MQS9Tst+XDdPHM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F345AB7196E82747ADE7950E2A4ED8AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff814bb-3032-4cc0-044c-08db820a2973
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 12:27:15.9387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aUZPm/dezSSDB+VLspjG/gJrhtp8jQF4q49GqeziLq4RKUCBsNPuJHjVp95W7BXjS0EekI/8kV97oigM8OqhLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7365
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA3LTExIGF0IDEzOjM4ICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICsvKiBBbGwgVERYLXVzYWJsZSBtZW1vcnkgcmVnaW9u
cy4gIFByb3RlY3RlZCBieSBtZW1faG90cGx1Z19sb2NrLiAqLw0KPiA+ICtzdGF0aWMgTElTVF9I
RUFEKHRkeF9tZW1saXN0KTsNCj4gPiArDQo+ID4gICAvKg0KPiA+ICAgICogV3JhcHBlciBvZiBf
X3NlYW1jYWxsKCkgdG8gY29udmVydCBTRUFNQ0FMTCBsZWFmIGZ1bmN0aW9uIGVycm9yIGNvZGUN
Cj4gPiAgICAqIHRvIGtlcm5lbCBlcnJvciBjb2RlLiAgQHNlYW1jYWxsX3JldCBhbmQgQG91dCBj
b250YWluIHRoZSBTRUFNQ0FMTA0KPiA+IEBAIC0yMDQsNiArMjE0LDc5IEBAIHN0YXRpYyBpbnQg
dGR4X2dldF9zeXNpbmZvKHN0cnVjdCB0ZHN5c2luZm9fc3RydWN0ICpzeXNpbmZvLA0KPiA+ICAg
CXJldHVybiAwOw0KPiA+ICAgfQ0KPiA+ICAgDQo+ID4gKy8qDQo+ID4gKyAqIEFkZCBhIG1lbW9y
eSByZWdpb24gYXMgYSBURFggbWVtb3J5IGJsb2NrLiAgVGhlIGNhbGxlciBtdXN0IG1ha2Ugc3Vy
ZQ0KPiA+ICsgKiBhbGwgbWVtb3J5IHJlZ2lvbnMgYXJlIGFkZGVkIGluIGFkZHJlc3MgYXNjZW5k
aW5nIG9yZGVyIGFuZCBkb24ndA0KPiA+ICsgKiBvdmVybGFwLg0KPiA+ICsgKi8NCj4gPiArc3Rh
dGljIGludCBhZGRfdGR4X21lbWJsb2NrKHN0cnVjdCBsaXN0X2hlYWQgKnRtYl9saXN0LCB1bnNp
Z25lZCBsb25nIHN0YXJ0X3BmbiwNCj4gPiArCQkJICAgIHVuc2lnbmVkIGxvbmcgZW5kX3BmbikN
Cj4gPiArew0KPiA+ICsJc3RydWN0IHRkeF9tZW1ibG9jayAqdG1iOw0KPiA+ICsNCj4gPiArCXRt
YiA9IGttYWxsb2Moc2l6ZW9mKCp0bWIpLCBHRlBfS0VSTkVMKTsNCj4gPiArCWlmICghdG1iKQ0K
PiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiA+ICsNCj4gPiArCUlOSVRfTElTVF9IRUFEKCZ0bWIt
Pmxpc3QpOw0KPiA+ICsJdG1iLT5zdGFydF9wZm4gPSBzdGFydF9wZm47DQo+ID4gKwl0bWItPmVu
ZF9wZm4gPSBlbmRfcGZuOw0KPiA+ICsNCj4gPiArCS8qIEB0bWJfbGlzdCBpcyBwcm90ZWN0ZWQg
YnkgbWVtX2hvdHBsdWdfbG9jayAqLw0KPiANCj4gSWYgdGhlIGxpc3QgaXMgc3RhdGljIGFuZCBp
bmRlcGVuZGVudCBvZiBtZW1vcnkgaG90cGx1Zywgd2h5IGRvZXMgaXQgDQo+IGhhdmUgdG8gYmUg
cHJvdGVjdGVkPw0KDQpUaGFua3MgZm9yIHJldmlldyENCg0KVGhlIEB0ZHhfbWVtbGlzdCBpdHNl
bGYgaXMgYSBzdGF0aWMgdmFyaWFibGUsIGJ1dCB0aGUgZWxlbWVudHMgaW4gdGhlIGxpc3QgYXJl
DQpidWlsdCBkdXJpbmcgbW9kdWxlIGluaXRpYWxpemF0aW9uLCBzbyB3ZSBuZWVkIHRvIHByb3Rl
Y3QgdGhlIGxpc3QgZnJvbSBtZW1vcnkNCmhvdHBsdWcgY29kZSBwYXRoLg0KDQo+IA0KPiBJIGFz
c3VtZSBiZWNhdXNlIHRoZSBtZW1vcnkgbm90aWZpZXIgbWlnaHQgY3VycmVudGx5IHRyaWdnZXIg
YmVmb3JlIA0KPiBidWlsZGluZyB0aGUgbGlzdC4NCj4gDQo+IE5vdCBzdXJlIGlmIHRoYXQgaXMg
dGhlIHJpZ2h0IGFwcHJvYWNoLiBTZWUgYmVsb3cuDQo+IA0KPiA+ICsJbGlzdF9hZGRfdGFpbCgm
dG1iLT5saXN0LCB0bWJfbGlzdCk7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4g
PiArc3RhdGljIHZvaWQgZnJlZV90ZHhfbWVtbGlzdChzdHJ1Y3QgbGlzdF9oZWFkICp0bWJfbGlz
dCkNCj4gPiArew0KPiA+ICsJLyogQHRtYl9saXN0IGlzIHByb3RlY3RlZCBieSBtZW1faG90cGx1
Z19sb2NrICovDQo+ID4gKwl3aGlsZSAoIWxpc3RfZW1wdHkodG1iX2xpc3QpKSB7DQo+ID4gKwkJ
c3RydWN0IHRkeF9tZW1ibG9jayAqdG1iID0gbGlzdF9maXJzdF9lbnRyeSh0bWJfbGlzdCwNCj4g
PiArCQkJCXN0cnVjdCB0ZHhfbWVtYmxvY2ssIGxpc3QpOw0KPiA+ICsNCj4gPiArCQlsaXN0X2Rl
bCgmdG1iLT5saXN0KTsNCj4gPiArCQlrZnJlZSh0bWIpOw0KPiA+ICsJfQ0KPiA+ICt9DQo+ID4g
Kw0KPiA+ICsvKg0KPiA+ICsgKiBFbnN1cmUgdGhhdCBhbGwgbWVtYmxvY2sgbWVtb3J5IHJlZ2lv
bnMgYXJlIGNvbnZlcnRpYmxlIHRvIFREWA0KPiA+ICsgKiBtZW1vcnkuICBPbmNlIHRoaXMgaGFz
IGJlZW4gZXN0YWJsaXNoZWQsIHN0YXNoIHRoZSBtZW1ibG9jaw0KPiA+ICsgKiByYW5nZXMgb2Zm
IGluIGEgc2Vjb25kYXJ5IHN0cnVjdHVyZSBiZWNhdXNlIG1lbWJsb2NrIGlzIG1vZGlmaWVkDQo+
ID4gKyAqIGluIG1lbW9yeSBob3RwbHVnIHdoaWxlIFREWCBtZW1vcnkgcmVnaW9ucyBhcmUgZml4
ZWQuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IGJ1aWxkX3RkeF9tZW1saXN0KHN0cnVjdCBs
aXN0X2hlYWQgKnRtYl9saXN0KQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBsb25nIHN0YXJ0X3Bm
biwgZW5kX3BmbjsNCj4gPiArCWludCBpLCByZXQ7DQo+ID4gKw0KPiA+ICsJZm9yX2VhY2hfbWVt
X3Bmbl9yYW5nZShpLCBNQVhfTlVNTk9ERVMsICZzdGFydF9wZm4sICZlbmRfcGZuLCBOVUxMKSB7
DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBUaGUgZmlyc3QgMU1CIGlzIG5vdCByZXBvcnRlZCBhcyBU
RFggY29udmVydGlibGUgbWVtb3J5Lg0KPiA+ICsJCSAqIEFsdGhvdWdoIHRoZSBmaXJzdCAxTUIg
aXMgYWx3YXlzIHJlc2VydmVkIGFuZCB3b24ndCBlbmQgdXANCj4gPiArCQkgKiB0byB0aGUgcGFn
ZSBhbGxvY2F0b3IsIGl0IGlzIHN0aWxsIGluIG1lbWJsb2NrJ3MgbWVtb3J5DQo+ID4gKwkJICog
cmVnaW9ucy4gIFNraXAgdGhlbSBtYW51YWxseSB0byBleGNsdWRlIHRoZW0gYXMgVERYIG1lbW9y
eS4NCj4gPiArCQkgKi8NCj4gPiArCQlzdGFydF9wZm4gPSBtYXgoc3RhcnRfcGZuLCBQSFlTX1BG
TihTWl8xTSkpOw0KPiA+ICsJCWlmIChzdGFydF9wZm4gPj0gZW5kX3BmbikNCj4gPiArCQkJY29u
dGludWU7DQo+ID4gKw0KPiA+ICsJCS8qDQo+ID4gKwkJICogQWRkIHRoZSBtZW1vcnkgcmVnaW9u
cyBhcyBURFggbWVtb3J5LiAgVGhlIHJlZ2lvbnMgaW4NCj4gPiArCQkgKiBtZW1ibG9jayBoYXMg
YWxyZWFkeSBndWFyYW50ZWVkIHRoZXkgYXJlIGluIGFkZHJlc3MNCj4gPiArCQkgKiBhc2NlbmRp
bmcgb3JkZXIgYW5kIGRvbid0IG92ZXJsYXAuDQo+ID4gKwkJICovDQo+ID4gKwkJcmV0ID0gYWRk
X3RkeF9tZW1ibG9jayh0bWJfbGlzdCwgc3RhcnRfcGZuLCBlbmRfcGZuKTsNCj4gPiArCQlpZiAo
cmV0KQ0KPiA+ICsJCQlnb3RvIGVycjsNCj4gPiArCX0NCj4gDQo+IFNvIGF0IHRoZSB0aW1lIGlu
aXRfdGR4X21vZHVsZSgpIGlzIGNhbGxlZCwgeW91IHNpbXBseSBnbyBvdmVyIGFsbCANCj4gbWVt
YmxvY2tzLg0KPiANCj4gQnV0IGhvdyBjYW4geW91IGJlIHN1cmUgdGhhdCB0aGV5IGFyZSBURFgt
Y2FwYWJsZT8NCg0KSWYgYW55IG1lbW9yeSBpc24ndCBURFgtY2FwYWJsZSwgdGhlIGxhdGVyIFNF
QU1DQUxMIFRESC5TWVMuQ09ORklHIHdpbGwgZmFpbC4gDQpUaGVyZSdzIG5vIGV4cGxpY2l0IGNo
ZWNrIHRvIHNlZSB3aGV0aGVyIGFsbCBtZW1ibG9ja3MgYXJlIHdpdGhpbiBDTVJzIGhlcmUsIGJ1
dA0KZGVwZW5kcyBvbiB0aGUgVERILlNZUy5DT05GSUcgdG8gZG8gdGhhdC4gIFRoaXMgaXMgbWFp
bmx5IGZvciBjb2RlIHNpbXBsaWNpdHkuDQoNCj4gDQo+IFdoaWxlIHRoZSBtZW1vcnkgbm90aWZp
ZXIgd2lsbCBkZW55IG9ubGluaW5nIG5ldyBtZW1vcnkgYmxvY2tzLCANCj4gYWRkX21lbW9yeSgp
IGFscmVhZHkgaGFwcGVuZWQgYW5kIGFkZGVkIGEgbmV3IG1lbW9yeSBibG9jayB0byB0aGUgc3lz
dGVtIA0KPiAoYW5kIHRvIG1lbWJsb2NrKS4gU2VlIGFkZF9tZW1vcnlfcmVzb3VyY2UoKS4NCg0K
WWVzIGJ1dCB0aGlzIGlzIGZpbmUsIGFzIGxvbmcgYXMgdGhleSBhcmUgbm90ICJwbHVnZ2VkIiBp
bnRvIHRoZSBidWRkeSBzeXN0ZW0uDQoNCj4gDQo+IEl0IG1pZ2h0IGJlIGNsZWFuZXIgdG8gYnVp
bGQgdGhlIGxpc3Qgb25jZSBkdXJpbmcgbW9kdWxlIGluaXQgKGJlZm9yZSANCj4gYW55IG1lbW9y
eSBob3RwbHVnIGNhbiBoYXBwZW4gYW5kIGJlZm9yZSB3ZSB0ZWFyIGRvd24gbWVtYmxvY2spIGFu
ZCBub3QgDQo+IHJlcXVpcmUgQVJDSF9LRUVQX01FTUJMT0NLLiBFc3NlbnRpYWxseSwgYmVmb3Jl
IHJlZ2lzdGVyaW5nIHRoZSANCj4gbm90aWZpZXIuIFNvIHRoZSBsaXN0IGlzIHJlYWxseSBzdGF0
aWMuDQoNClRoaXMgY2FuIGJlIGFub3RoZXIgc29sdXRpb24uICBJbiBmYWN0IEkgdHJpZWQgdGhp
cyBiZWZvcmUuICBCdXQgb25lIHByb2JsZW0gaXMNCndoZW4gVERYIG1vZHVsZSBoYXBwZW5zLCBz
b21lIGhvdC1hZGRlZCBtZW1vcnkgbWF5IGFscmVhZHkgaGF2ZSBiZWVuIGhvdC1hZGRlZA0KYW5k
L29yIGJlY29tZSBvbmxpbmUuICBTbyBkdXJpbmcgbW9kdWxlIGluaXRpYWxpemF0aW9uLCB3ZSBj
YW5ub3Qgc2ltcGx5IHBhc3MNCnRoZSBURFggbWVtYmxvY2tzIGJ1aWx0IGR1cmluZyBrZXJuZWwg
Ym9vdCB0byB0aGUgVERYIG1vZHVsZSwgYnV0IG5lZWQgdG8gdmVyaWZ5DQp0aGUgY3VycmVudCBt
ZW1ibG9ja3MgKHRoaXMgd2lsbCBBUkNIX0tFRVBfTUVNQkxPQ0spIG9yIHRoZSBvbmxpbmUgbWVt
b3J5X2Jsb2Nrcw0KZG9uJ3QgY29udGFpbiBhbnkgbWVtb3J5IHRoYXQgaXNuJ3QgaW4gVERYIG1l
bWJsb2Nrcy4gIFRvIG1lIHRoaXMgYXBwcm9hY2ggaXNuJ3QNCnNpbXBsZXIgdGhhbiB0aGUgY3Vy
cmVudCBhcHByb2FjaC4NCg0KPiANCj4gQnV0IG1heWJlIEkgYW0gbWlzc2luZyBzb21ldGhpbmcu
DQo+IA0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICtlcnI6DQo+ID4gKwlmcmVlX3RkeF9t
ZW1saXN0KHRtYl9saXN0KTsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo+ID4g
ICBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+ICAgew0KPiA+ICAgCXN0cnVj
dCB0ZHN5c2luZm9fc3RydWN0ICpzeXNpbmZvOw0KPiA+IEBAIC0yMzAsMTAgKzMxMywyNSBAQCBz
dGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+ICAgCWlmIChyZXQpDQo+ID4gICAJ
CWdvdG8gb3V0Ow0KPiANCj4gWy4uLl0NCj4gDQo+ID4gICANCj4gPiArc3RydWN0IHRkeF9tZW1i
bG9jayB7DQo+ID4gKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+ID4gKwl1bnNpZ25lZCBsb25n
IHN0YXJ0X3BmbjsNCj4gPiArCXVuc2lnbmVkIGxvbmcgZW5kX3BmbjsNCj4gPiArfTsNCj4gDQo+
IElmIGl0J3MgbmV2ZXIgY29uc3VtZWQgYnkgc29tZW9uZSBlbHNlLCBtYXliZSBrZWVwIGl0IGxv
Y2FsIHRvIHRoZSBjIGZpbGU/DQoNCldlIGNhbiwgYW5kIGFjdHVhbGx5IEkgZGlkIHRoaXMgaW4g
dGhlIG9sZCB2ZXJzaW9ucywgYnV0IEkgY2hhbmdlZCB0byBwdXQgaGVyZQ0KYmVjYXVzZSB0aGVy
ZSdzIGFub3RoZXIgc3RydWN0dXJlICdzdHJ1Y3QgdGRtcl9pbmZvX2xpc3QnIGJlaW5nIGFkZGVk
IGluIGxhdGVyDQpwYXRjaC4gIEFsc28sIGlmIHdlIG1vdmUgdGhpcyBzdHJ1Y3R1cmUgdG8gLmMg
ZmlsZSwgdGhlbiB3ZSBzaG91bGQgbW92ZSBhbGwNCmtlcm5lbC1kZWZpbmVkIHN0cnVjdHVyZXMv
dHlwZSBkZWNsYXJhdGlvbnMgdG8gdGhlIC5jIGZpbGUgdG9vIChmb3IgdGhvc2UNCmFyY2hpdGVj
dHVyZSBzdHJ1Y3R1cmVzIEkgd2FudCB0byBrZWVwIHRoZW0gaW4gdGR4LmggYXMgdGhleSBhcmUg
bGVuZ3RoeSBhbmQgY2FuDQpiZSB1c2VkIGJ5IEtWTSBpbiB0aGUgZnV0dXJlKS4gIEkgc29tZWhv
dyBmb3VuZCBpdCdzIG5vdCBlYXN5IHRvIHJlYWQgdG9vLg0KDQpCdXQgSSBhbSBmaW5lIHdpdGgg
ZWl0aGVyIHdheS4NCg0KS2lyaWxsL0RhdmUsIGRvIHlvdSBoYXZlIGFueSBjb21tZW50cz8NCg0K
PiANCj4gPiArDQo+ID4gICBzdHJ1Y3QgdGR4X21vZHVsZV9vdXRwdXQ7DQo+ID4gICB1NjQgX19z
ZWFtY2FsbCh1NjQgZm4sIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0IHI5LA0KPiA+ICAg
CSAgICAgICBzdHJ1Y3QgdGR4X21vZHVsZV9vdXRwdXQgKm91dCk7DQo+IA0KDQo=
