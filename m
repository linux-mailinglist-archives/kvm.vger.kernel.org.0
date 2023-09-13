Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4579E6B0
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 13:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbjIML14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 07:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjIML1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 07:27:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EFC1726;
        Wed, 13 Sep 2023 04:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694604471; x=1726140471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=11OZftn8LGfuFjzdYg7+eMFJoCqtB8TC2K7v5hpwkh0=;
  b=Rg5QSckNvgKYE+a3DqZobfABiqRMmP6YYRgQBD4cd2Ies19KiTJ1bwMZ
   tpZ01qUPtIXlEOUCKcHINwWGHC4cEH3jiv2B3RlKq7ZqJeeytiRCpdMxU
   utU7dMHsV2jNGcFbcOYvw2Ehudjz+zreRBcTLiAjkW9ZsI37M+QdkL6i2
   S/YjMkhLAki2CC2A5QwVv7Jhe5mB/+yxkzHOMWYsPaR5UcRDZOn2EbgBf
   7ZLwMjuXt793jDIftGmuwBnfy+xIXcasAA77nC4C212rL47MZ6Xook9Bn
   GulJuWHRGVam7DhfSmxA2eLuXTZ61uY7ZsKzbgoM1sIRFjnXgNFCyW+mx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="363663383"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="363663383"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 04:27:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="720770026"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="720770026"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2023 04:27:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 13 Sep 2023 04:27:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 13 Sep 2023 04:27:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 13 Sep 2023 04:27:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 13 Sep 2023 04:27:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL7Pa79wJ4GXx8vch0M4Fs4R2ee9sESmEEAbhF+vnuxE2jm4jLZN4RQ9kbtLrAwqMP435CA/0AO2U+E9W1J3XNEkNNYoLR6/RUPqlhWPj/+kmqPDB1k2BBuJnRoDlbKCyP3GwccHdUoMptfk7VeCEEF8CzsFzenqd1JeAnYrnHLLGwpyyXut1UT7Fbz87BDMRF0/rP+e8WuXHAME6fJ+lRkVtdP+JeXOli143mXhI8h6SILszV7VN1CjnbM1uZJSWKKYpVJDfK49lEsG86JeBRLWGHi8rr8fdjHpOgyv9nV0MsaoiaR903H0guVo+KhracLLZZGgCqfPNUqkSAzxxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11OZftn8LGfuFjzdYg7+eMFJoCqtB8TC2K7v5hpwkh0=;
 b=I3cZQT49+9bjGgnpOj1Pi28amlybz5HEhsT880hQO056dLWyl0qg0FSF6axNhwy+Baj/NctSQ1QvEpg60dxlXZuiRS2qfcz0uTMqorZ3nqrqC23L9k/DPjrrmjlBPBWEWETpbHkjZz7yKKidYnHmLXVTJjBz8rj4F0M2Si103FVXb8TK8rofgg49wA0OtKicLOq629VABTMYR8WjW+9HkipvLxYMI2qc688axgu21G8gwii8E0Rmf76DFhfI/TDeMPAhlXPqlWKiVErrYxR/RbQPHleF9+SKlBW/JxtH0HQt+X4tpDMKos8POE/3Aet+E9CdFE6FrQYcQtDwWVZAPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7392.namprd11.prod.outlook.com (2603:10b6:610:145::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Wed, 13 Sep
 2023 11:27:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6768.036; Wed, 13 Sep 2023
 11:27:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
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
Subject: Re: [PATCH v13 22/22] Documentation/x86: Add documentation for TDX
 host support
Thread-Topic: [PATCH v13 22/22] Documentation/x86: Add documentation for TDX
 host support
Thread-Index: AQHZ101M+pXqjOGuO0Kt8EKXDCxWjrAVmKuAgAMjOQA=
Date:   Wed, 13 Sep 2023 11:27:19 +0000
Message-ID: <862ad257bc87efbbd73f886a24b0e589a1c2be4c.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <840351e17ca17b833733ed9e623e7a51d8340c2d.1692962263.git.kai.huang@intel.com>
         <528511e9-c205-f248-9a64-9066281004ba@suse.com>
In-Reply-To: <528511e9-c205-f248-9a64-9066281004ba@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7392:EE_
x-ms-office365-filtering-correlation-id: ca308c70-5d2b-4174-92df-08dbb44c6480
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W6Zjox5MDAtOe+McH4FDuIS6Dg5ggWalHddqdg7ugqky6GABLaqBOE1Q6MWXeQHqkppa0VMH1UvONqvSZHlKazGq5wwFwJ2IeadrSqB5V8ff9GemwAjsi4YvN67E3KmyttXff06uUev+UescOl2dFhkJrRxYjZp95Ja6FK8wWGuzylYaY0OxWwZB69IA7RB11o+gvOZSmlOaCKJ1InzYJK8NRhRIZZ+S0QdE0IYafql1/rz9LdkHAoXVMH1avcA+AE4fLxS5PCIDv7eH+lXXh21rZHnlYWWsxLZD8APfMq/LHmCpSXiAk/LvqtkIM1P4YnCnSDc4s+ItOl7X09I//1iOKx3eQx+wOWlBwEuQGNXRpCn5OBttiZOJXVV34x47wQ3fWj3zndMHCP0ABAFPAC2lcwXrZfMPFNhBO6o9uWncI14cCWu+s79S5W+mWnRr8nFSa7blyIUi9qfxTV5BhlqToal9Z6BwgR2K5QEzUaQsYT42Rzs1hEo7cjEb6khFvnR8s4Ca/6y5BLOqBgM91iokNKJnj4KqAGVSM0bFh5Q+l7uoSwZtb9QBnnJd3uaN6OLWChEO4z056YIArdN1xyBjPonvcGCsvlxZBH9f0Es+UXuarukCrmI5xhQ1cTzw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(396003)(376002)(346002)(186009)(1800799009)(451199024)(8936002)(36756003)(4326008)(8676002)(26005)(82960400001)(71200400001)(6506007)(122000001)(6486002)(38070700005)(5660300002)(38100700002)(86362001)(110136005)(2906002)(91956017)(76116006)(83380400001)(2616005)(41300700001)(7416002)(6512007)(66556008)(66946007)(478600001)(54906003)(64756008)(66476007)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTQzV3JYWWx6NXBGZ1MyQUZYVmE5K2VlKzRvMDB2Uno3dzFoeFpkcEtCZ3Nh?=
 =?utf-8?B?clJUNGlLVXE5RnN2WTRnRXY5REN6NVNyZWhiNkp4WWkwNC9ieWtNWUFQV0dB?=
 =?utf-8?B?MTJuM2RQNkdZbXJsZisyVXF3K0JIUmdoSzZkU3ROeHBVcU9aS1BBb0RQVjEv?=
 =?utf-8?B?U0Z2MEovRUE3QUc5bFpBck1lMFBYU01VMFBRSklyM09KMkZ4bmdzcEFsSTRw?=
 =?utf-8?B?SWc3OTVRV2RtQ29BM1lxUEpxa01yZzNJUk8rdE1qaUt5M2VvTGMzaUphQjlW?=
 =?utf-8?B?Vkd5eXF5RkpFUWxGeEZ4Nkd0dmEwSHZmSVJzTEVVYjVsL21XVG5NTVFUdFpr?=
 =?utf-8?B?TkRtYmM5ak91Z1NTamZWbUVsSTRncWFhdFR4NEtFRUlDa1NhM082Zk94MElw?=
 =?utf-8?B?elJyQWtBdkFCMnNtemZlQ0t0T016aWlJKzFPdytvaFpSRnJiTUNpVC9EUW9B?=
 =?utf-8?B?UzhJc3hmbERLRThTdm1Ta3IveEF5SHB6RDRRZnQra2NINUF6anJpYzE2SlpH?=
 =?utf-8?B?MFRWZlZGWGJBSU9nWXYzeFpqdWp0YnJFcm9pcWt4RDBJd2FsUStsNlk0K204?=
 =?utf-8?B?c0VyN0xnRzVCK056TzVOT29aL05Ob1VBaHd5SDRQVG9xcVkvanZwSW5jWlU3?=
 =?utf-8?B?WEJRNjd6c08wK21OTmhsZG9rcjIxeXorQmNPczJuR3ZaaEhBZTBXTTErdVhX?=
 =?utf-8?B?WjNFS3V2cThKNm5lS2x5M0J1algrNGZldExIekV3ODdIK0lOakZ0SE5IVkRp?=
 =?utf-8?B?Y1JWNUtOb2NQYXE4eFg0ZEM0OEorazc4ZmQyWXFaWGNOYi9vbmNxUjF2MWww?=
 =?utf-8?B?aVJjdmdWMWozQnRqN0pBK0xvM3puS2o4TjVubXlSN0R4eHgvN3lBUkJvZmpI?=
 =?utf-8?B?TUliUGpTcGRzUTRnZFRFb2I4ZDdnbklrbmFjY2ZFVXFxb00wei8xb0hVdEJq?=
 =?utf-8?B?TzZ2RUh4ZkxTMHhhNC9oOXEyQUJlUlpkTXpaWjBTb3lEOE9MUEl5OW9ReFlR?=
 =?utf-8?B?Y2FGc2lhUWtuSmVNM2VTUVdGMkJSWnNhdm9GaXp1ZCtFcHBGTFMxNXNWZEN4?=
 =?utf-8?B?R0JBQ2twYk5pNXhFSFVtU3d3VkdiZzlDczY3Sk5XdzZKWnMwekcxR3dwcENC?=
 =?utf-8?B?VGZYck05YVFhQlY4Y0Y1OE5zWmJDQVNhQzk2YzlWd2IwR1NIUGNIL2xIeWRi?=
 =?utf-8?B?a1d0RjQydDJzejRaQWhpUWRhRXMrYUVLeDZMQnFYRGxwbGx6Z3g1K1cxa0Y4?=
 =?utf-8?B?VEVaVkpsZ0NMbGZOc3lzL2pxc3RLQmtrUFN6cU1QNVZqTUVCV2RpSEJhUnZQ?=
 =?utf-8?B?Q2VLMENRZm0xQm1ucHdUOEs4UmV4aThDaVQxb1EvMGs4d1h5Z3ZodUpOMmhz?=
 =?utf-8?B?WDhyZjVzZXhVaGRTRWJxWFloVG5SZktwK2QvTnp0TDd6bHU1Nno3ajR0eFZq?=
 =?utf-8?B?NFd4UHYrNDhQQTZnTGhHZ3QrS2FCNmpyc0lTZFZwcEp5Yys0bTlPV3IwQmJ6?=
 =?utf-8?B?RHI0UWc1THMzQUhIbHNKbHBrZjFUME90S3NJTldHdWZRT3JGakY3WDFYc0U0?=
 =?utf-8?B?Z1dCVTdIQ2dETGpicHBVVG50UWxidkc3cXFQaEFyT1dxdWdsT29WeUZrWU5R?=
 =?utf-8?B?R290NCt1NThkMHlOajZtK29YNk1ZdXNlV1lXUEIzNUN0YVFHS3VhR1lSeUwy?=
 =?utf-8?B?c2YvZE1aQk05SVduUHY2ZlpOYjhCMlBsMWN4bytBOUI0VWQ0MytlYVlibmRT?=
 =?utf-8?B?bFNFWEZmY1VxYVpsWm9pMVl2aEhDMkZWYVJFU2JWdFl1dHRaSzZnKzNZbXA2?=
 =?utf-8?B?YTJZanFWSFlMWncvbjVPTFBtQ2VpN1ZjTmRwaXNERGxxTlNwQzlmdXdLZWtx?=
 =?utf-8?B?TmVHa3p6MnFJbFR6VldCUlAvcjFpVzRKd28vRkFORm9ldUZNdys2a1JPOXpn?=
 =?utf-8?B?NEVCaFY2WXhaMVBmMDVva1F4eVhvUjlMWjBTaXVHd29MaHN1cUhnZWg5TnJp?=
 =?utf-8?B?SWZ0SmVFSGR0L295aWZUcnJ0c25JaGhSMFlJanUyV2RmODdUMmx3T1BFcktU?=
 =?utf-8?B?WUs1dTc2LzhmVXlGaWczaWMzazA3LzllaFc0Q3U4b2hSbmRFKzZ4YXpJYVFj?=
 =?utf-8?B?Tjc3UStrVTJpazgzR0xrVjlBcDJNa29PeDJieEpJbEpQTlJtZ1RXYUdMOEFV?=
 =?utf-8?B?MkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <760BA60E687E7244BA8381054C4E3B4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca308c70-5d2b-4174-92df-08dbb44c6480
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 11:27:19.9116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bx6Iv15IMq0yZqG56DRb81F54PJDpVT65tGcjQNsoRAYPAYJtc3GwoXmLnffyyIjMCleZdq+99BzUtxBl2BtGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7392
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhhbmtzIGZvciByZXZpZXdpbmcgdGhlIGRvYyENCg0KPiA+ICtNYWtpbmcgU0VBTUNBTEwgcmVx
dWlyZXMgdGhlIENQVSBhbHJlYWR5IGJlaW5nIGluIFZNWCBvcGVyYXRpb24gKFZNWE9ODQo+ID4g
K2hhcyBiZWVuIGRvbmUpLiAgRm9yIG5vdyBib3RoIHRkeF9lbmFibGUoKSBhbmQgdGR4X2NwdV9l
bmFibGUoKSBkb24ndA0KPiA+ICtoYW5kbGUgVk1YT04gaW50ZXJuYWxseSwgYnV0IGRlcGVuZHMg
b24gdGhlIGNhbGxlciB0byBndWFyYW50ZWUgdGhhdC4NCj4gSXNuJ3QgdGhpcyBhbiBpbXBsZW1l
bnRhdGlvbiBkZXRhaWwuIEl0J3MgZmluZSBtZW50aW9uaW5nIHRoYXQgVERYIA0KPiByZXF1aXJl
cyBWTVggYmVpbmcgZW5hYmxlZCBidXQgd2hldGhlciBpdCdzIGJlaW5nIGhhbmRsZWQgYnkgY3Vy
cmVudCANCj4gY29kZSBvciBub3QgaXMgYW4gaW1wbGVtZW50YXRpb24gZGV0YWlscy4gSSB0aGlu
ayB0aGlzIGlzIGJldHRlciBsZWZ0IGFzIA0KPiBhIGNvbW1lbnQgaW4gdGhlIGNvZGUgcmF0aGVy
IHRoYW4gaW4gdGhlIGRvYywgaXQgd2lsbCBsaWtlbHkgcXVpY2tseSBnbyANCj4gc3RhbGUuDQoN
CkJvdGggYWJvdmUsIGFuZCAuLi4NCj4gDQo+ID4gKw0KPiA+ICtUbyBlbmFibGUgVERYLCB0aGUg
Y2FsbGVyIG9mIFREWCBzaG91bGQ6IDEpIGhvbGQgcmVhZCBsb2NrIG9mIENQVSBob3RwbHVnDQo+
IA0KPiBuaXQ6IEhvbGQgQ1BVIGhvdHBsdWcgbG9jayBpbiByZWFkIG1vZGUuIEFuZCBhZ2Fpbiwg
dGhpcyBpcyBtb3JlIG9mIGFuIA0KPiBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzLCB0aGUgaW1wb3J0
YW50IGJpdCBpcyB0aGF0IGNwdSBob3RwbHVnIG11c3QgYmUgDQo+IGJsb2NrZWQgd2hpbGUgZW5h
YmxpbmcgaXMgaW4gcHJvZ3Jlc3MsIG5vPw0KDQouLi4gdGhpcyBhcmUgdXNlZCB0byBleHBsYWlu
IC4uLg0KPiANCj4gPiArbG9jazsgMikgZG8gVk1YT04gYW5kIHRkeF9lbmFibGVfY3B1KCkgb24g
YWxsIG9ubGluZSBjcHVzIHN1Y2Nlc3NmdWxseTsNCj4gPiArMykgY2FsbCB0ZHhfZW5hYmxlKCku
ICBGb3IgZXhhbXBsZTo6DQo+ID4gKw0KPiA+ICsgICAgICAgIGNwdXNfcmVhZF9sb2NrKCk7DQo+
ID4gKyAgICAgICAgb25fZWFjaF9jcHUodm14b25fYW5kX3RkeF9jcHVfZW5hYmxlKCkpOw0KPiA+
ICsgICAgICAgIHJldCA9IHRkeF9lbmFibGUoKTsNCj4gPiArICAgICAgICBjcHVzX3JlYWRfdW5s
b2NrKCk7DQo+ID4gKyAgICAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgICAgIGdvdG8g
bm9fdGR4Ow0KPiA+ICsgICAgICAgIC8vIFREWCBpcyByZWFkeSB0byB1c2UNCg0KLi4uIHRoZSBw
c2V1ZG8gY29kZSBoZXJlLCB3aXRoIHRoZSBwdXJwb3NlIHRvIGdpdmUgY2FsbGVyIGV4YW1wbGUg
b24gaG93IHRvIHVzZS4NCg0KSG93ZXZlciBJIGFsc28gYWdyZWUgd2Ugc2hvdWxkIG1ha2UgdGhl
IGRvYyBjb25jaXNlIGFzIG5vYm9keSB3YW50cyB0byByZWFkDQpib3JpbmcgYW5kIGxlbmd0aHkg
bWF0ZXJpYWxzLiAgSSBwZXJzb25hbGx5IGRvbid0IGtub3cgaG93IHRvIGRyYXcgdGhlIGxpbmUs
IHNvDQpJIGNhbiByZW1vdmUgYWxsIHRob3NlIGlmIHRoYXQgYmV0dGVyLiAgQnV0IGJlZm9yZSBJ
IGNvbW1pdCB0byBkbyBsZXQncyB3YWl0IGZvcg0Kc29tZSBtb3JlIHRpbWUgdG8gaGVhciBmcm9t
IG90aGVycy4NCg0KPiA+ICsNCj4gPiArQW5kIHRoZSBjYWxsZXIgb2YgVERYIG11c3QgZ3VhcmFu
dGVlIHRoZSB0ZHhfY3B1X2VuYWJsZSgpIGhhcyBiZWVuDQo+ID4gK3N1Y2Nlc3NmdWxseSBkb25l
IG9uIGFueSBjcHUgYmVmb3JlIGl0IHdhbnRzIHRvIHJ1biBhbnkgb3RoZXIgU0VBTUNBTEwuDQo+
ID4gK0EgdHlwaWNhbCB1c2FnZSBpcyBkbyBib3RoIFZNWE9OIGFuZCB0ZHhfY3B1X2VuYWJsZSgp
IGluIENQVSBob3RwbHVnDQo+ID4gK29ubGluZSBjYWxsYmFjaywgYW5kIHJlZnVzZSB0byBvbmxp
bmUgaWYgdGR4X2NwdV9lbmFibGUoKSBmYWlscy4NCj4gPiArDQo+ID4gK1VzZXIgY2FuIGNvbnN1
bHQgZG1lc2cgdG8gc2VlIHdoZXRoZXIgdGhlIFREWCBtb2R1bGUgaGFzIGJlZW4gaW5pdGlhbGl6
ZWQuDQo+ID4gKw0KPiA+ICtJZiB0aGUgVERYIG1vZHVsZSBpcyBpbml0aWFsaXplZCBzdWNjZXNz
ZnVsbHksIGRtZXNnIHNob3dzIHNvbWV0aGluZw0KPiA+ICtsaWtlIGJlbG93OjoNCj4gPiArDQo+
ID4gKyAgWy4uXSB0ZHg6IFREWCBtb2R1bGU6IGF0dHJpYnV0ZXMgMHgwLCB2ZW5kb3JfaWQgMHg4
MDg2LCBtYWpvcl92ZXJzaW9uIDEsIG1pbm9yX3ZlcnNpb24gMCwgYnVpbGRfZGF0ZSAyMDIxMTIw
OSwgYnVpbGRfbnVtIDE2MA0KPiA+ICsgIFsuLl0gdGR4OiAyNjI2NjggS0JzIGFsbG9jYXRlZCBm
b3IgUEFNVC4NCj4gPiArICBbLi5dIHRkeDogbW9kdWxlIGluaXRpYWxpemVkLg0KPiA+ICsNCj4g
PiArSWYgdGhlIFREWCBtb2R1bGUgZmFpbGVkIHRvIGluaXRpYWxpemUsIGRtZXNnIGFsc28gc2hv
d3MgaXQgZmFpbGVkIHRvDQo+ID4gK2luaXRpYWxpemU6Og0KPiA+ICsNCj4gPiArICBbLi5dIHRk
eDogbW9kdWxlIGluaXRpYWxpemF0aW9uIGZhaWxlZCAuLi4NCj4gDQo+IG5pdDogWW91IGdpdmUg
c3BlY2lmaWMgc3RyaW5ncyB3aGljaCB0ZHggaXMgZ29pbmcgdG8gdXNlLCBvZiBjb3Vyc2UgDQo+
IHRob3NlIGNhbiBjaGFuZ2UgYW5kIHdpbGwgZ28gc3RhbGUgaGVyZS4gSW5zdGVhZCwgcGVyaGFw
cyBqdXN0IA0KPiBtZW50aW9uaW5nIHRoYXQgdGhlIGRtZXNnIGlzIGdvaW5nIHRvIGJlIGNvbnRh
aW5zIGEgbWVzc2FnZSBzaWduaWZ5aW5nIA0KPiBlcnJvciBvciBzdWNjZXNzLg0KPiA+ICsNCg0K
U29tZWhvdyBJIGJlbGlldmUgdGhpcyB3b3VsZCBiZSB1c2VmdWwsIGFzIHRoaXMgbWVzc2FnZSBp
c24ndCBqdXN0IGZvciBkZXZlbG9wZXINCihsaWtlIHRoZSBwc2V1ZG8gY29kZSBhYm92ZSksIGJ1
dCBmb3IgdGhlIHVzZXIuICBPZiBjb3Vyc2Ugdy9vIGV4cGxpY2l0bHkgc2F5aW5nDQpoZXJlLCB0
aGUgdXNlciBzaG91bGQgYWxzbyBiZSBhYmxlIHRvIGVhc2lseSBmaW5kIHRoaXMgcGFydGljdWxh
ciBzZW50ZW5jZQ0KKGJlY2F1c2UgaXQncyB0b28gb2J2aW91cyksIGJ1dCBJIGd1ZXNzIHByb3Zp
ZGluZyBpdCBoZXJlIHdvdWxkIG1ha2UgaXQgZXZlbg0KZWFzaWVyIGZvciB0aGUgdXNlci4gIEFs
c28sIEkgYW0gbm90IGV4cGVjdGluZyB0aGlzIHBhcnRpY3VsYXIgbWVzc2FnZSB0byBiZQ0KY2hh
bmdlZCBzb29uIG9yIGZyZXF1ZW50bHkuDQoNCkFnYWluLCBJIGFtIHF1aXRlIG9wZW4gdG8gYWxs
IG9mIHRoZXNlLCBidXQgbGV0J3Mgc29tZSBtb3JlIHRpbWUgOi0pDQoNCg==
