Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35664E3DC
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 23:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLOWld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 17:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLOWlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 17:41:32 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4005EDC0;
        Thu, 15 Dec 2022 14:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671144091; x=1702680091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wAGl878q+ymNGo7SNHAuYi0GL4BZ1rqGLfCj62mcMPw=;
  b=hB56CS9qq4xGK346w2aTfXUn/t4sKe1Ltp0sMjuAXGXfAgFbZeFOAJRH
   tV2SJ6eVZ7+jEkZaPKOffwoxSokmkRrmzx3FXNbpMtiB2bKQdOgZJbu8D
   H3MupRCCd0N2MtPx2jqyOsHNvqP05jGsSIBZxwr2zMKwq2i7vZg07gr8f
   UsYmmz3MVTID8rfjlqG1GmtzwPUWm3+B+WCqfV8azP94fpRTrpGi/Dk9M
   /y2FIpQn9at31r/S077Uvyet4ut4FlNTChBiSk6f1ZXdb0VbCp6Tj6B6K
   52Q/Tl+ROG8KDaZ3JfU4MPBlhTGDK92BIFUiF/eU3cVPntbZFUqcCA9zK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="345902767"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="345902767"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 14:41:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="718156399"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="718156399"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2022 14:41:30 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 14:41:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 14:41:30 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 14:41:30 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 14:41:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcdFnK+zt5zZE5qZMZWKP1mix9seg+rbkZvlOIFs/8uFBuU4X6kWpfpoQ6lX51yMsan8JIS8wqDdW5YSrKch7JyBa8V30Z2i08Blg5SKTzA/nRgQH/OSihoR4U97EyFUSKUJzHKKHhtSlPWKebcflORjypV+mKpQWlQAPunZb1JhC1Rel2esPQS85eekUnl052VlJNzi4XHaJK01vzk12HA2SffzW4Ld/R2jNQYEV1QwCjJsf40ouc4GrtK3n5rcEMf/qIiiVFhVfuPsjYrjZbGkQ6+OutIh/5FTPd8RUp7ybz9XP8wEZbLguCXwSBmNytQazraKMQt8VtYodFIivw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAGl878q+ymNGo7SNHAuYi0GL4BZ1rqGLfCj62mcMPw=;
 b=mJCJVTIuxyBXQOA0CIvHhZgsXxci9GaRAb7sqR8C84dmKsJpPvQyut+oBP34t9qGvDkEaUh5sJDXjGcVVVDxuT6RZLlOQ2ZSfbEXzS97gi+uBQmn5M5glRzGb/a9TqwjR8EcUl6qI6WoRNRkj5Nlu5wiwpaJfAGsZcnqGIywuoh1QnmPHziSlzWh1xi59E5LgrsXqgAICNE5jiI1E1BCvwIb395Q80teZJDgpkY5cp7RXTH64NmrrPzz4y4uSa6pRMaOLBaR3WIOvQ7MCfbCmAiXZzvwcTWPuLGWqXpSDt4BXBaOFvnCjf4EXV3JXLksDljrJph3xJDDg03OVwW4/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5806.namprd11.prod.outlook.com (2603:10b6:510:14b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 22:41:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 22:41:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 046/108] KVM: Add flags to struct kvm_gfn_range
Thread-Topic: [PATCH v10 046/108] KVM: Add flags to struct kvm_gfn_range
Thread-Index: AQHY7CiJA0kfvmpBe0OC8BeNSC0dtq5te7mAgAJQFQCAAAibAA==
Date:   Thu, 15 Dec 2022 22:41:27 +0000
Message-ID: <2938fd03dc253e83ec6528dfa2767701738647c9.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <880c1016c29624964baee580985b6a736fc7d656.1667110240.git.isaku.yamahata@intel.com>
         <ce1b2bc760daf9cc07591bdc4d3e83e40391f468.camel@intel.com>
         <20221215221038.GH3632095@ls.amr.corp.intel.com>
In-Reply-To: <20221215221038.GH3632095@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5806:EE_
x-ms-office365-filtering-correlation-id: c2343971-7594-43f7-2997-08dadeed808e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lqtD8HjFRdxHNNOT0GXb8NysNIFLi9/JcL3PLVZoq410OANqD4HQIAsgPy7HGdGDhudFE3pQZUQ7g77VDeeV13rsWL/THOPHFHBlWsVlctSvKoxr10kX103gwM0leTFSMj6JZAw5fmtIOHKWhPG8+x1hrnAo8fO+zUVII6vRmy5LBehup1FMD7gbFySXcuUZNRAehy9seK+igMiatQcpYMNwfsbuWP1/4URpqNHldL25IdCWPtfBDe67dbMK1wVD+W0Q1Yj8x5zy33EtQXqdaNFLeKS2nVpUvDHYId/AODHub1edH83vyjUtDtpxzMkwZsYmWnoJDV2O490cOG/kbdU/avL0pgLKiw/8y/7RP0hPrJYsPexV7YcXlfR74GGyjRgHep7RGPThRJANxF8ZvVic3rzhWq6raqx7fLIkkmTJ/bvEq8j1hdayfH9FsUSlFFEElG+W2YedAIl5vWyTNi5tokVM1YawFzXnEhkT0/d89q5QjqYfkjufaiS/WFnWnvLJwaNfH9QcTc3qbXPtBe1Zpyw+ox3Wl6mSI39VWHyAs9pH1OP3G8o4JQk0zA9oHQKFWTR0hRrmUrLTPxPeamEBQrT6XdThZJKuhd+4gskIJ/juF4hRq75Lp+p+i7Zxehu0dwfx/rwiEPXrkhgLhn1hOhSdV0V6q541GToauXw6swyl+UxL8ykIt9G1JulL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(71200400001)(76116006)(2906002)(66476007)(6512007)(26005)(6486002)(91956017)(8676002)(64756008)(2616005)(66446008)(4326008)(478600001)(66556008)(6506007)(86362001)(6916009)(316002)(54906003)(38070700005)(38100700002)(82960400001)(122000001)(8936002)(5660300002)(4001150100001)(41300700001)(186003)(36756003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkJKYlkrbW9PNlozZ2dUcVN1Vjc0eHJaUjFaVldiS1lPNjNwdjU5dTF2U3FH?=
 =?utf-8?B?dHpSUGVvT2Z0YkxjaVlRTXc3NDJGZnlFemYxbGxIYzR1ZUpRK2xuK3pUenB6?=
 =?utf-8?B?T3J6OFl2cmpiMkFDNVVVMURTR0lwdzRiZjRIeCt0Z1kxSFhpZ3JxVnpXQWMz?=
 =?utf-8?B?cjJVZ3I0UnJLaVRTZUlnT2dXQ2h2U3p5QnJ3R3dGSlNldHNFQWs2OE1XMXNn?=
 =?utf-8?B?MHYvRzV5aCtqWVZMb0RKbjlKRzUyRmlqSWw1c2xLRzVVMlpKQnpBemVYWHEy?=
 =?utf-8?B?TGhxeXNHRXl2M0g4U0FCQ1NBY3pCMUF0SXNJUTZUSFpocmM4RmxVaEI2Yytz?=
 =?utf-8?B?Wjl0RWtmRCt1ZDNVSkJjeHlmdjRscW0xbW5OVFFVc0txZ1NOdzluWTQxeDZP?=
 =?utf-8?B?TEk3S28zdUdrUWNjZTV0QlRCK3hIL2xHZklnN1phMFA5aXdFZnl3RTJiOXpU?=
 =?utf-8?B?dFpjVmwyNzRadksrUERHSXRXMkhsZEoyRG5LNlJXYkJ6MTJQeUhYV05SQzBW?=
 =?utf-8?B?Tm9pSEdWcGpWQnZ0TU9TUFFMeFh0K0JmQldaWmZXOWVVb2EyQ2tNZkNiZnRr?=
 =?utf-8?B?WllqdnY3MnJHaHdMalJlVXFETThKY2w4N3VMTXd5ZnkyUzFrREE2UFE3cUxZ?=
 =?utf-8?B?VWY5dnZmbW5FVm1hTS9MUW5naGNlQ1ZRdnFyWStsOG5WYXlPYUU5eHgzRVZD?=
 =?utf-8?B?WUZ3OXYyazhQQ1JyT25LTmxjWTUxTDNtc3pibzN6VDJKRUVmMmswQi9tLytw?=
 =?utf-8?B?OEZLOXJWbE5sa3lXWU9WdmdIYkR4ZFRPSVRyWFRJVUJDVjVDNkdDRWNxZDdP?=
 =?utf-8?B?YkZVZDhCV3hKcTJHdXYrRCtGbHFRV3FjNE9PV28yemN6ZzRJVWxtYzUyNXhP?=
 =?utf-8?B?L1dJZ2pzTTRqc1NmR2lVODF6Nk8xWTRRYlVaVGV6R2REM0pkMjc1Z3V2amJC?=
 =?utf-8?B?WGpTSFR2OUdFUFZmaGErUjZQUlNOVnlTTUNOdEl0aFdEVlRPQnhid0c1OXVC?=
 =?utf-8?B?cFZIbmVYZXlLL2g0VlordFNiSzlRZFhYYzY1SHlkSmhFME1xNTlSVXZpRXlU?=
 =?utf-8?B?MW5XQ1AvZEVMNEp4V0F4NXB1OEtDWStGUlN0N25acm5OamRWTHpRZmJZRE5F?=
 =?utf-8?B?azUzNi84N2FROTZtRXJBT3M4NTFrcjNGay9tRjNyOEI4d3Q5cG1EdFRkYVpI?=
 =?utf-8?B?MjNXY2ZialJuSCtlYVhpMVBXZWlPdVl3WWdPdlpsV2IybmFEQWE5cStIR3Zm?=
 =?utf-8?B?ZWZiNjdHeEF2UFhFc2YzbVczaC9qUHNaQld3UjRpTTNlaXJMTHFvRzF6bjl2?=
 =?utf-8?B?RGpQQnJYc0VRdEtiR2NHRXE5VnM0aHRsUTRnUkhZUFhaSVF0MG5qZFZWTXdp?=
 =?utf-8?B?K0kxTk8zbGlOZGpXcUJPcGJ0YVlJWnNMdVJPbWsvNmFtZ3VSOEd2REZnVjZv?=
 =?utf-8?B?WCtqL1hpN3hVMEJsUDlBL2lBK3QvU3BKdmFMb2ZVYnJHVEwrVFp1NW9QZFk5?=
 =?utf-8?B?d2NJQWdiZ04zb1hkeUZheXphYjBodmpxVG1TVEt5RlJOSFdXMGVDaU9SMCtq?=
 =?utf-8?B?SGQ1YmZpTkVsTmI0VEJWL0psc2VTUERMWERwSFVScXUxNk9odHVCdEUvUjd0?=
 =?utf-8?B?eUIxWXNXalR5aUZFOCtnWVF2NW1uQVpKd2VDcVRlM3RJcGJ2NGVxZlh1VEM2?=
 =?utf-8?B?eGpyRHZRejdiekhxd09zU1FGNnFWNlZPUmgybzFWLzN1M3BMeExNN1RiYjZm?=
 =?utf-8?B?SmthNytBenJ6bVFuNEk2QXAwZ1FKcjF5ZkUyekNYVFlhMGFFZnNINER4REtx?=
 =?utf-8?B?ZTg2VVVWajlDWlNYNGE3NUtkL09ZQ08xZEl3L2hHV2pFODU2OC9HeWhoR09I?=
 =?utf-8?B?L3RqUFpBb1ZyRGtXY2lUUlZPSHB4UWV6QkY2dXI3Qm1SSmdBMFVXODNMekV6?=
 =?utf-8?B?cXFISVBKcEgvUHpDaTZqWXdETkhvMGtCdVE4STcrbzdoTXViSENyanJvbTlJ?=
 =?utf-8?B?MGUybGo1L2lDMzdqOEduM2NUYVh0bDM4OHJiS0duaFdoQjF3ajNSYVhNRklw?=
 =?utf-8?B?LzB2azVKdjBkVEEvS0VMTXE0L2MxUFlkSmIwUUZzSHpzQ0VjN0JybjMvZU9U?=
 =?utf-8?B?T3lkS1VjMHhtVlpwRmZZTmFtVXhkSVZlN3Rrd0VoaHBKQ2VmN0NhSEF0UVpp?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8EEDC325A7176488A82C1E1AE8614F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2343971-7594-43f7-2997-08dadeed808e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 22:41:27.1449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O6P/lIin1WfnAxzNtu0exWaLTCAyhPtr4vcVu3NTwbkBqD3gi/dJkFOQi//EOaMwNEJEFi5EPozRbbOWkZqQyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5806
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTE1IGF0IDE0OjEwIC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBEZWMgMTQsIDIwMjIgYXQgMTA6NTE6MzFBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU2F0LCAyMDIyLTEw
LTI5IGF0IDIzOjIyIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5jb20gd3JvdGU6DQo+ID4g
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+ID4g
DQo+ID4gPiBrdm1fdW5tYXBfZ2ZuX3JhbmdlKCkgbmVlZHMgdG8ga25vdyB0aGUgcmVhc29uIG9m
IHRoZSBjYWxsYmFjayBmb3IgVERYLg0KPiA+ID4gbW11IG5vdGlmaWVyLCBzZXQgbWVtYXR0ciBp
b2N0bCBvciByZXN0cmljdGVkbWVtIG5vdGlmaWVyLiAgQmFzZWQgb24gdGhlDQo+ID4gPiByZWFz
b24sIFREWCBjaGFuZ2VzIHRoZSBiZWhhdmlvci4gIEZvciBtbXUgbm90aWZpZXIsIGl0J3MgdGhl
IG9wZXJhdGlvbiBvbg0KPiA+ID4gc2hhcmVkIG1lbW9yeSBzbG90IHRvIHphcCBzaGFyZWQgUFRF
LiAgRm9yIHNldCBtZW1hdHRyLCBwcml2YXRlPC0+c2hhcmVkDQo+ID4gPiBjb252ZXJzaW9uLCB6
YXAgdGhlIG9yaWdpbmFsIFBURS4gIEZvciByZXN0cmljdGVkbWVtLCBpdCdzIGEgaGludCB0aGF0
IFREWA0KPiA+ID4gY2FuIGlnbm9yZS4NCj4gPiANCj4gPiBDb3VsZCB5b3UgZWxhYm9yYXRlIHdo
eSByZXN0cmljdGVkIG1lbWZkIG5vdGlmaWVyIGNhbiBiZSBpZ25vcmVkPyBJSVVDIGlmDQo+ID4g
dXNlcnNwYWNlIHB1bmNoIGEgaG9sZSwgdGhlIHBhZ2VzIHdpdGhpbiB0aGUgaG9sZSB3aWxsIGJl
IGRlLWFsbG9jYXRlZC4gIFNvIHdoeQ0KPiA+IGNhbiBzdWNoIG5vdGlmaWVyIGJlIGlnbm9yZWQ/
DQo+IA0KPiBCZWNhdXNlIHNldC1tZW1vcnktYXR0cmlidXRlIGlvY3RsIGlzIGV4cGVjdGVkIHRv
IGZvbGxvdyB0aGUgY2FsbGJhY2sgZnJvbQ0KPiByZXN0cmljdGVkbWVtLiAgU28gc2V0IG1lbW9y
eSBhdHRyaWJ1dGVzIGNhbiBkbyBkZS1hbGxvY2F0aW9uLiBJIHdhbnRlZCB0byBhdm9pZA0KPiB6
YXBwaW5nIHR3aWNlLg0KDQpFdmVuIHRoaXMgaXMgdHJ1ZSwgdGhlIHB1bmNoIGhvbGUgY2FuIGJl
IGRvbmUgYWxvbmUgdy9vIGJlaW5nIGZvbGxvd2VkIGJ5DQpzZXRfbWVtb3J5X2F0dHJpYnV0ZSgp
LCBjb3JyZWN0PyAgWW91ciBleHBsYW5hdGlvbiBkb2Vzbid0IHNlZW0gdG8gYmUNCnJlYXNvbmFi
bGU/DQoNCkF0IGxlYXN0LCB5b3UgbmVlZCB0byBleHBsYWluIHRoZSBzZW1hbnRpY3Mgb2YgaG93
IHRvIHVzZSAicHVuY2ggaG9sZSIgYW5kDQpzZXRfbWVtb3J5X2F0dHJpYnV0ZXMoKSBjbGVhcmx5
IGluIHRoZSBjaGFuZ2Vsb2cuICBPdGhlcndpc2UgaXQncyBoYXJkIGZvcg0KcGVvcGxlIHRvIHJl
dmlldy4NCg0KDQo=
