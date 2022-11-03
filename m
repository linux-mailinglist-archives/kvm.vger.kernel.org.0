Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D715617937
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 09:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiKCIzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 04:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCIzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 04:55:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FC5D2FD;
        Thu,  3 Nov 2022 01:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667465742; x=1699001742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KwJBWfCrllzARcjfWiPYG0St0immSXT1dHgHajJOe/4=;
  b=VnAACHqBHe4g2h02f0tIEu9dqhFY15erQJzonXWsUIqajiaPNEdRdkIA
   u9QF3QUSXOfihXrXifFoPE+zcQZZ/n00pK8FRVI7pwrovhf2Rfg2J47Im
   2JVe64QDAwAXh4PkSUITox9nOYhzZ1ub6JeHOC/GOovsqAN4Y22oDjYox
   ZbSHAa9HN1DGdPMCbQmD3Ii/ZoGiD+fq12rlQyO3BHXU6BRLTPYVnXK8o
   JCrdyoBKXF7TZlVF61GXXSgIDs22EDEgMKsLqeJptHp/cu5/kahjphzj6
   vF/DmpBXVTzC0k70gn9n9ipFsnGO9y+CAImnzXzKhgsGyZA+C0kWZzXd+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="395933488"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="395933488"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 01:55:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698142437"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698142437"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 03 Nov 2022 01:55:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 01:55:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 01:55:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 01:55:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 01:55:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfVCSq+gRi4wN1eOi05WMGXd26pGkjxWU2PFK8zCG/RPYnQAR0T+ol23X39UKQsoXvLp9fF66NEyp8pzPA5uhEx6fIMtSg5IgVjYuO661vg75gHrAq9Ggse2xojKOd1phyU+8zjJw/1NLmKkeR+G0EdzaS9zXPb7JDmC+YHpnoTnJuXD11NKOgoE8qWg4IU27At4lpKITRQKcZr/DTuG1EYPjdH66fro9TuwQsNI4W0VfAdSVBOLDOBdXCH3HJQ6tyd2o/tZw3B1A160zqcIM56Udeew+6/EVVVztObPgT0SI5LL76JbeekzQTCvMDT43XjpkFKC/ltIk2YKmtn0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwJBWfCrllzARcjfWiPYG0St0immSXT1dHgHajJOe/4=;
 b=PN/wY7T/xxtWi/4AQ3sLs7CRbLh525skTSon5/D6RdSgRD7CXPD8ngCxivE1keOvXMwDJj2Q4ncEv6tn1eQTWBobmZ6hejcS3i9GHBzy2lepjstyj8lemKpSssrIeOmyK0gSUF/ArFBpHbmlbZCiQPE4K9/0ptEQ2SqqNhQzczSxpM+iYLFjPuh8/BHt1vX7uibUxnmEwfbqabjR+g54j+83eI4ZNd5P768VnZihNoQhEbEX/w+CZSE1ydXpoIwtCg9IblWpmGK/3j4GYjJMOr4dQP1BvE6hHjIccdEgqz4eGQxvk2K5/c0ofGrGdWkrQ1CoG1IdsR58MoHnS6+Z9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB5049.namprd11.prod.outlook.com (2603:10b6:806:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 08:55:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 08:55:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY6Y2jpLGj6H1IZ0qLOAaWltkKyK4iXzmAgAC1uwCACdwEAA==
Date:   Thu, 3 Nov 2022 08:55:37 +0000
Message-ID: <4f9ef0eac576df84110132e144cb8edb96f98788.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <fe0e1a1133166ca4008840cd1a5959fa70632f07.1666824663.git.kai.huang@intel.com>
         <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
         <83da61dcafc88c9c89f336d7387ecd9aa2857ab7.camel@intel.com>
In-Reply-To: <83da61dcafc88c9c89f336d7387ecd9aa2857ab7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB5049:EE_
x-ms-office365-filtering-correlation-id: a95a8e12-9374-4bb0-48de-08dabd792d61
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3wldFL0zqQpqvyK1rfM1oP6j36uLsVu/i2CfwdvyQOXKVU0lTHL7Kl3tTkiEjsn0Iw6VuaczkJPk16/zeh0g+UN2qHlsYL9pwukx79U/VZALetpaw0nEgdvwgp4MgKL9pLO+V/apEENG/fukaodt3dfIdyf9RqBxmLEMAE4MIwpWalXjtN/G1Bn4Asw0Wn2UZ2d0hcy4JzdkJa7UB7tLeac6jPh0R6EMHmBvqgx65Jfu5JGb7fjArV4sBxG601eFd7xAK9/KBXldLhCJQVpjyxVk7Pjt4CUFxNMfBbg7uho3i91b9ZfbNUEXDdUze7CnM5cyvXlv0aqlbxn73yKWFTbRfzpLQxlIo9PEUPWt1eChEmx5t5V6azjFsRknpdm+qsJrWGjOK2U0UDFb7OpwyMcWSweyVBZnzTcB4dZ0byJkOQto0X8rwo1AlKF9xYek8tRo2x7Ul0lptBjNmqUwAfkmfX5M8SlnI+LmYz1h2sst5p9vMQYgphETQTY1SFtc1CQ51l0vb5VpXxqoA3pSQdmdPjWxCL5Cb/W5NpKuJ6P6aAVul6jLiDSoYPCParnD3JArMw3ViZviA8O77zuJYGYTw9ZtuFVaku50WKgpNut0b9Vun50r4cJ0eyedVJCavfBO1KuuyYtY0Xd2bler+QnNwfJw5xTcPjz6FtV0OpOV6F21ihBFNj6svHBmhktOkJzuzV8b8UuM0Bu7x+FdcbyiwK6DNjbhXcpK0l0OMZjM75GadZH3Sbr58o/OZUEMh5yg1ksCZaJL9JMLsswCRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(4001150100001)(2906002)(86362001)(66946007)(66556008)(76116006)(66476007)(66446008)(91956017)(6512007)(26005)(6506007)(8676002)(41300700001)(8936002)(110136005)(316002)(38070700005)(54906003)(5660300002)(7416002)(36756003)(4326008)(122000001)(38100700002)(478600001)(64756008)(6486002)(82960400001)(2616005)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnBsYW5MS1lLRmh1SG82eE5NRllvQk9wNllpYytlc1ZVZEhvZEMvUXZTSGhr?=
 =?utf-8?B?WERtNUkwdU1lZGF2eXpHS3JvQjErRngyeUtUOS8xSHRzSkpDbzBmSFNzYXZ4?=
 =?utf-8?B?Slo3VGwvR2xubUg0dVNkRkhjTFpZcmpYeGFoM2FUakZpYWdIZkl6WVBUdnFQ?=
 =?utf-8?B?SXVkaStLbUdLUEE2dWRMMWIyY0ppNktNdU40U1pqMmxXZWVZNDJxMFd5RzhH?=
 =?utf-8?B?b0xtMnY3ZDMxNi90Z2ZxMjBCdnRSZDhhc3ZNNHZDSUlvTVhreThLZUp0bzdL?=
 =?utf-8?B?ZmtZUFZxOTZldmFRUFdWTjlXOU05eERDbXlnZ3VTRzlOSGNOVlVWMXdnaHF1?=
 =?utf-8?B?c0xQT09YSkltYmJkdnVUOFVpTW5DNEFycTZXckdtREtOa0J3R0FhVCsyNUcz?=
 =?utf-8?B?R09IbmRFc1NaMmJoVzdrSCtyMkFDQnMwWThsUkRPbXRZeTBzY0JSRkZscnlX?=
 =?utf-8?B?NTVtaTg3dVJZWFZybTN4ZlVlTW1qb3lmRkcyYmJ0cHVBK3FmcTQ3R3F3UHkv?=
 =?utf-8?B?Z21LcndTRXE4ZUljZFcrenJXdzczWWVqMjVKUVJOdys1NG1NTlFTclhZZ1lC?=
 =?utf-8?B?SmpDeTBHdEREb09vU2xyem9PcjNNUTJjYzFWMllkTkdDbUVXZmFrLytacE9M?=
 =?utf-8?B?dktZUTBSNmVBOFVrTTMwaW5XcXdTdjVYdVJqQUJhNWVoYTFBNFpPU1dxV050?=
 =?utf-8?B?U3VYZnVlTjEwWitwZTV6ZWNzYTFwMmJ3eG5YazlFRUM0Q2RneEx2QkovQm9Z?=
 =?utf-8?B?UVgvRG9kWkE2Vmg2OVU2NGw1NHUzL0dMMUszdUVWWEFCVHFrODg2NEJ2SHpt?=
 =?utf-8?B?anYvOXNiQ0NUQXU0L1ViS3NyWWs0WENiOVR6ZVhCNW0vVWZnLzFUQjc3WWJ0?=
 =?utf-8?B?UUtVVk9meEQvZXhQVkdnRkp6a1NHL0VDOHlOckh5cWpEQVdNeGs4MExHOHUv?=
 =?utf-8?B?c0xQZ0dmczNQZy9hWTBYc3U3M2lUTWxUZUhmT2hGV1dIcnJ5aURyNmlhM0U1?=
 =?utf-8?B?dW9pTlFsVTJzOVFncEpOaTZsRm1rNWtiNWdPNXovYU82bU1JMko1VGVuNEN5?=
 =?utf-8?B?ZVRHR1pPU1RVYTJXcUVMWUYrWWxSLzVPMDNEZHAwcVZWS1krT0hXTjNXQTdw?=
 =?utf-8?B?cXBXTDlyYnFidWZJUkxGNjZUcVVEUjlwbmdzRnV6aENxbWdMamFqRFJBbzNZ?=
 =?utf-8?B?WXcrS21ObVNNL0doQ1RsRjd4ZmViS1BtQzZ3LzdTS1NSRGE1Y0hCNmR2a3Ur?=
 =?utf-8?B?Ulp0UlBrZ05UYXUzdDdRMDlqODZxaE8wc1FUQmU1N1VrWEpIby9NdjJ5SHoz?=
 =?utf-8?B?VDRrSFQzNHNtdmJRVHA1aE4zNXFzeURLd0FkdHcvN3VKQzNYLzYyUE5UODRi?=
 =?utf-8?B?SG8zWWZlT2ZuSlZWcGpNRDdmeVJhMTlqZlQyaG5mTFdNNGdzSXZHOVFLR0ww?=
 =?utf-8?B?T1p2TVNhTVM1RW1nZ3gvRWFGU2FLemkvWXZJd1lGcnZxMW4ycHFEV2lxWjVz?=
 =?utf-8?B?dUcxQ0NYUmFqWndZRWpUOXVyNGJHaEo5RVkwUGRmWVMwbTFNcWJhVFY0eG9y?=
 =?utf-8?B?NEJFNnZLeHo4cWFtcjByK29DUnR5NmtWSzd1U1R0NzlaUXFNd0IrSWRoYThE?=
 =?utf-8?B?cDhGUDBoVU5hRFNScnVCSmdnWHVWazRSSmlEQmwyMHp0TVErYk54T21vSnVB?=
 =?utf-8?B?QzlyS3h5bmwyWG9IanMxQTdiQUIvTSsrSGo5endBMEw5UGN4SVJpK3NLR0dx?=
 =?utf-8?B?TUROUHB6RjdCaHVNM0YxZ1NyZENGd2pna0Rjdk8wMlZPWFFRVkpwQVd2RlZL?=
 =?utf-8?B?aVJYekZpYmNIYUhHWkYvN3hSbHpzZmZFUjhRTG9ZdytXcE4yanJmczQ5dStn?=
 =?utf-8?B?VWFEc2s4cTlkRk1EK2ZLVTdoalQzTTkvZmhMVnlGMUZJMVNBNlUydS9sNU0x?=
 =?utf-8?B?TndicHFpRGV6bWhadkhCY0twVEJBRXhhMEI3TGpNZC9KVzFRSkFZKy91M2gr?=
 =?utf-8?B?eFlzc3NTTWdoNWV3UktWWmNxaXU5bzdBQTI4UVpNcnpPdms0UGlnK1FYQmJt?=
 =?utf-8?B?bXNjQlUrQjJlWVVTdGNTeGgydDYrMjM1UWJpdlhRcERXdHFGbmREaHc3RUtO?=
 =?utf-8?B?ZldqVzhVRy9TMlprWDdYSjBVOWdPL0JMRVc1RTZRZUlBNEduYVNlZERWRU0x?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCDE81B8EB48F84D8CD9AEF3C26E93B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a95a8e12-9374-4bb0-48de-08dabd792d61
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 08:55:37.6233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXkZzXABldaf+9K8JjK3bvYRfLndpCrI3Ntm3mUQwb0UKQdNbZFJzVECE7LHYDO4lmHEtZ1z7aYGyuk/hnoO8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTI4IGF0IDAyOjIxICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjItMTAtMjcgYXQgMDg6MzEgLTA3MDAsIEFuZGkgS2xlZW4gd3JvdGU6DQo+ID4g
PiArLyogQ2FsY3VsYXRlIHRoZSBhY3R1YWwgVERNUl9JTkZPIHNpemUgKi8NCj4gPiA+ICtzdGF0
aWMgaW5saW5lIGludCBjYWxfdGRtcl9zaXplKHZvaWQpDQo+ID4gPiArew0KPiA+ID4gKwlpbnQg
dGRtcl9zejsNCj4gPiA+ICsNCj4gPiA+ICsJLyoNCj4gPiA+ICsJICogVGhlIGFjdHVhbCBzaXpl
IG9mIFRETVJfSU5GTyBkZXBlbmRzIG9uIHRoZSBtYXhpbXVtIG51bWJlcg0KPiA+ID4gKwkgKiBv
ZiByZXNlcnZlZCBhcmVhcy4NCj4gPiA+ICsJICovDQo+ID4gPiArCXRkbXJfc3ogPSBzaXplb2Yo
c3RydWN0IHRkbXJfaW5mbyk7DQo+ID4gPiArCXRkbXJfc3ogKz0gc2l6ZW9mKHN0cnVjdCB0ZG1y
X3Jlc2VydmVkX2FyZWEpICoNCj4gPiA+ICsJCSAgIHRkeF9zeXNpbmZvLm1heF9yZXNlcnZlZF9w
ZXJfdGRtcjsNCj4gPiANCj4gPiANCj4gPiB3b3VsZCBzZWVtIHNhZmVyIHRvIGhhdmUgYSBvdmVy
ZmxvdyBjaGVjayBoZXJlLg0KPiA+IA0KPiA+IA0KPiANCj4gSG93IGFib3V0IGJlbG93Pw0KPiAN
Cj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHguYw0KPiBAQCAtNjE0LDYgKzYxNCwxNCBAQCBzdGF0aWMgaW5saW5lIGlu
dCBjYWxfdGRtcl9zaXplKHZvaWQpDQo+ICAgICAgICAgdGRtcl9zeiArPSBzaXplb2Yoc3RydWN0
IHRkbXJfcmVzZXJ2ZWRfYXJlYSkgKg0KPiAgICAgICAgICAgICAgICAgICAgdGR4X3N5c2luZm8u
bWF4X3Jlc2VydmVkX3Blcl90ZG1yOw0KPiAgDQo+ICsgICAgICAgLyoNCj4gKyAgICAgICAgKiBE
byBzaW1wbGUgY2hlY2sgYWdhaW5zdCBvdmVyZmxvdywgYW5kIHJldHVybiAwIChpbnZhbGlkKQ0K
PiArICAgICAgICAqIFRETVJfSU5GTyBzaXplIGlmIGl0IGhhcHBlbmVkLiAgQWxzbyBXQVJOKCkg
YXMgaXQgc2hvdWxkDQo+ICsgICAgICAgICogc2hvdWxkIG5ldmVyIGhhcHBlbiBpbiByZWFsaXR5
Lg0KPiArICAgICAgICAqLw0KPiArICAgICAgIGlmIChXQVJOX09OX09OQ0UodGRtcl9zeiA8IDAp
KQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ICsNCj4gICAgICAgICAvKg0KPiAgICAg
ICAgICAqIFREWCByZXF1aXJlcyBlYWNoIFRETVJfSU5GTyB0byBiZSA1MTItYnl0ZSBhbGlnbmVk
LiAgQWx3YXlzDQo+ICAgICAgICAgICogcm91bmQgdXAgVERNUl9JTkZPIHNpemUgdG8gdGhlIDUx
Mi1ieXRlIGJvdW5kYXJ5Lg0KPiBAQCAtNjIzLDE5ICs2MzEsMjcgQEAgc3RhdGljIGlubGluZSBp
bnQgY2FsX3RkbXJfc2l6ZSh2b2lkKQ0KPiAgDQo+ICBzdGF0aWMgc3RydWN0IHRkbXJfaW5mbyAq
YWxsb2NfdGRtcl9hcnJheShpbnQgKmFycmF5X3N6KQ0KPiAgew0KPiArICAgICAgIGludCBzejsN
Cj4gKw0KPiAgICAgICAgIC8qDQo+ICAgICAgICAgICogVERYIHJlcXVpcmVzIGVhY2ggVERNUl9J
TkZPIHRvIGJlIDUxMi1ieXRlIGFsaWduZWQuDQo+ICAgICAgICAgICogVXNlIGFsbG9jX3BhZ2Vz
X2V4YWN0KCkgdG8gYWxsb2NhdGUgYWxsIFRETVJzIGF0IG9uY2UuDQo+ICAgICAgICAgICogRWFj
aCBURE1SX0lORk8gd2lsbCBzdGlsbCBiZSA1MTItYnl0ZSBhbGlnbmVkIHNpbmNlDQo+ICAgICAg
ICAgICogY2FsX3RkbXJfc2l6ZSgpIGFsd2F5cyByZXR1cm4gNTEyLWJ5dGUgYWxpZ25lZCBzaXpl
Lg0KPiAgICAgICAgICAqLw0KPiAtICAgICAgICphcnJheV9zeiA9IGNhbF90ZG1yX3NpemUoKSAq
IHRkeF9zeXNpbmZvLm1heF90ZG1yczsNCj4gKyAgICAgICBzeiA9IGNhbF90ZG1yX3NpemUoKSAq
IHRkeF9zeXNpbmZvLm1heF90ZG1yczsNCj4gKw0KPiArICAgICAgIC8qIE92ZXJmbG93ICovDQo+
ICsgICAgICAgaWYgKCFzeiB8fCBXQVJOX09OX09OQ0Uoc3ogPCAwKSkNCj4gKyAgICAgICAgICAg
ICAgIHJldHVybiBOVUxMOw0KPiArDQo+ICsgICAgICAgKmFycmF5X3N6ID0gc3o7DQo+ICANCj4g
ICAgICAgICAvKg0KPiAgICAgICAgICAqIFplcm8gdGhlIGJ1ZmZlciBzbyAnc3RydWN0IHRkbXJf
aW5mbzo6c2l6ZScgY2FuIGJlDQo+ICAgICAgICAgICogdXNlZCB0byBkZXRlcm1pbmUgd2hldGhl
ciBhIFRETVIgaXMgdmFsaWQuDQo+ICAgICAgICAgICovDQo+IC0gICAgICAgcmV0dXJuIGFsbG9j
X3BhZ2VzX2V4YWN0KCphcnJheV9zeiwgR0ZQX0tFUk5FTCB8IF9fR0ZQX1pFUk8pOw0KPiArICAg
ICAgIHJldHVybiBhbGxvY19wYWdlc19leGFjdChzeiwgR0ZQX0tFUk5FTCB8IF9fR0ZQX1pFUk8p
Ow0KPiAgfQ0KPiANCj4gDQo+IEJ0dywgc2hvdWxkIEkgdXNlIGFsbG9jX2NvbnRpZ19wYWdlcygp
IGluc3RlYWQgb2YgYWxsb2NfcGFnZXNfZXhhY3QoKSBhcyBJSVVDDQo+IHRoZSBsYXR0ZXIgc2hv
dWxkIGZhaWwgaWYgdGhlIHNpemUgaXMgbGFyZ2VyIHRoYW4gNE1CPyAgSW4gcmVhbGl0eSwgdGhl
IGVudGlyZQ0KPiBhcnJheSBvbmx5IHRha2VzIGRvemVucyBvZiBLQnMsIHRob3VnaC4NCg0KSGkg
QW5kaSwNCg0KQ291bGQgeW91IHRha2UgYSBsb29rIHdoZXRoZXIgdGhpcyBpcyBPSz8NCg0KQWxz
byBjb3VsZCB5b3UgdGFrZSBhIGxvb2sgbXkgcmVwbGllcyB0byB5b3VyIG90aGVyIGNvbW1lbnRz
Pw0KDQpUaGFua3MhDQo=
