Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26993610738
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 03:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiJ1BZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 21:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiJ1BZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 21:25:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4AF58DFB;
        Thu, 27 Oct 2022 18:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666920308; x=1698456308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w+rHMhctcTjZ2VIWm+YG2Pf3k834ymNROjo6h6m/Q+0=;
  b=angWQ1l3jlldcoETIe8zo3EBg5cjrQ0ltL+GxDlYeElZxiSB6HS5E4Bj
   oifneSdGt891MKdaCfsev8S7zcIcm6QCqY1vEqJvVMw+lSUmkxAyi1qTO
   /iSi6MA3td67SNi0r2E1201Db5t2etPtMStt3s4Sw9xIL0KCS236WOq89
   aJo7Pp0MC52KsPr/EQ9DVOhA2k/u1RJ+FF+l8mR2FHR3ROaWkKwrg6uIF
   6i0sHZeVuEUmq48miIdsqyVWnA9OBpdUYCVjcA3m56iUnw19TLeZO15OK
   D9htd4kL2GVWfqmUv5Y21raWTL5qoQU5ONC+uY3S5/EBN04LMnGI8FuM4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="308372495"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="308372495"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 18:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="583757663"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="583757663"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 27 Oct 2022 18:24:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:24:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 18:24:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 18:24:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 18:24:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbNzl0ABsggxibhCmeJukLfpPTODB5avv4qiFJQEScHUg3INC0M1i5fUd2cI/5JK/qtIGuXyyYx65B8dKccGK9iGj2VY5KLKm7UXsPomFO/w72pXBwpVrqCmdIGpn5lnuprhrID7sAXBM/l09V5DyAgP/UZw6VotdoO5IxPD/n1LYP3o71MVVQtK1wNWm7ZUwTyi8B0oc0nbEyavpoliOi3p2HFVZNa7zBMB5fATl7vV5G1QYidhy0scRvPgC97nuZeLDK4D3C/sX6igGb8jaPg6tAx+jAgKzOqqmBeGwGOfbb90kbZVTgijpBtrE/rq577MV9uhNtAoKG3YPpCoeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+rHMhctcTjZ2VIWm+YG2Pf3k834ymNROjo6h6m/Q+0=;
 b=eK36JB12719sSQflVxHIkOAvSPKUNbyWOQ3+/qsXuqe7d9EMnEFqD4IefYQa3Xdz94YTfaN+BsG+gaFQxvggqn0/Z96Wqvo8kWfrCZSOT81pQu7JY2gWNzF5a7dOiE55cV6RXLBrdyIPRCCffnP2RRQHYEwuyiElHGEg6iSgRBWaLhrKfR0GH7MIVEBqpotIZwnNAc8hykQr/b5T4zQrdh2zRsR7Fu8Q3bE3VmHyEZfUYpV5dKQj2Xqmu3sVoJHClHF3SsnYTM+pb5lYq6EUR3rlXqmQg/f5kLFL/JUkVtp+Kzc5T49yZ5WoNoJBYfdfvEGod7ZjvJd9mMcK6wSqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6726.namprd11.prod.outlook.com (2603:10b6:806:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 01:24:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 01:24:47 +0000
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 16/21] x86/virt/tdx: Reserve TDX module global KeyID
Thread-Topic: [PATCH v6 16/21] x86/virt/tdx: Reserve TDX module global KeyID
Thread-Index: AQHY6Y2j/whNWw355UKnUBTpTul9Ia4iL2iAgADVnIA=
Date:   Fri, 28 Oct 2022 01:24:46 +0000
Message-ID: <e177a82687eb546d6020821a5ccdf916f046b3de.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <7558961d3dff6311c7872f57ac5bd6727f21e140.1666824663.git.kai.huang@intel.com>
         <85531c8e-e708-c76a-2d66-30ad7a3f8471@linux.intel.com>
In-Reply-To: <85531c8e-e708-c76a-2d66-30ad7a3f8471@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6726:EE_
x-ms-office365-filtering-correlation-id: 1acee6c7-71c7-4447-020b-08dab8833384
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aw5yK1bE6MdlS8z/9Br1Q2Fgwb1filrasdoruoWNMXUFWH9+Ts228CbqOP7OtCeh6xoS7MdOR2h8s2z940e0Sf5QJGl/Arw1VzA4QEOjXRafJKFsLJUC1Mf6KIVxEvAxzP08uVU83bb8v3A5RhKhOAQ9FTto8e9n15hJQ7NxCHRwCXhDseYXPcb/e6+zbeirGcQfxTYbikpP6Z14EzenzAPxKlhWReFL2sjwOeC1J5P87638qQJzgnfqe/w3BNpN0d6xs9niw7dSpxN86D+xf9oFUOtFO0/K/0JEEdJyNaDqMJKnJj7Qq9fuUOEv0alfbBPNC6FqipmIC15bEBhVz4vEofkCO2auui9we7E63M9zxxM5n3kuUGv7B5dSRjn/CcyHlFNwbZ3HU/wXirsTyC40nYL87wS8RKAvv+ZKhkv0aYTAQ8Ii89Lbp5UiB2n/snd8tO7ehzjTf+U7RUSuML1dQYSESvsRu6vdpaAqRpdg2MbLnmhsQ03+opRSxqTDulVuI6pjzsZgwcqcPxj5mKd+MbJbX7XsPKLUroDdeHiHbkXXHHflr2V95+7LvjxmLLZvC8CSY84K0OSq1al+suog7pG4LLF4Ob54yr2W/hL6USZubkhgXSCI1wv6pnYx3PrYnsZbNzn6lm+QvhCFLTQeGM6WkJLtcDzphbL+W++SQqSVSKUu6fpWqVecL1dWDdDcsBVxEMVtrTBNuOmlwpRqrYURDFUjKnJXbmerS0Jr7AWol476Jh3uRcrgSyfCFN8JEuL/s5CLKusmnXdS7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(26005)(2616005)(6506007)(4326008)(8676002)(66556008)(36756003)(66446008)(91956017)(186003)(66476007)(76116006)(64756008)(6512007)(2906002)(4001150100001)(7416002)(53546011)(5660300002)(66946007)(8936002)(122000001)(82960400001)(41300700001)(38100700002)(86362001)(71200400001)(6486002)(478600001)(110136005)(54906003)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmE0MFBVUVZYTHZXQmpSWkpkRGhRKzRSbUtGeG9LNExuMXdFZ2tmVkZMV0hr?=
 =?utf-8?B?bDZ3YzNJRjB3ME9sWldZRVR3Z0JXckxPb0YxRWNid3J2ZEVLWjRIYVllRlJQ?=
 =?utf-8?B?UHFCTlpuK3RVUzd3VDA3NTlQZTl0eWNQSWoxV09HTThxa2Z5VUpybjZWeDhJ?=
 =?utf-8?B?c2pBdWl1VkVaOUsxMWhuK1pqQ1hDSTdKeXBmZ3k0VThGTWVBVWJQYisxS2Na?=
 =?utf-8?B?VzFYSVRSVjZ4Nm5URnZUVE5sdlVxbkxiRVdqSVpxZURabU5KWnVyQW1jWEhl?=
 =?utf-8?B?SjVUaDNmeEU0V2s4dDd3UnF1dFdvM3BmcDdLaXlESlZqcm9LNk5kOGpVeEJ6?=
 =?utf-8?B?VXB5a3FTQjRSekFnUHdRcjhwM1FIQVF0S3VqRk5KdnlEQ3F1V0xwNGY2cDZM?=
 =?utf-8?B?LyttNVZWUDVhTUlGUE9qamxDYjFwczBDcW9zT0htWmplVWlnTGpjREpZZjI2?=
 =?utf-8?B?UUhxK0pLekNqVCtjZnVpTy90WmVQRkVXS1ltM1pnMklXMlpXZklPemJtd3VT?=
 =?utf-8?B?Vkp4ZFRpMWVRdVU0RTdZSUtBWi9VSEVvV1BvY0NGY240V1Vmejl5VUNpem1q?=
 =?utf-8?B?YXJFdklzQzZUQnowSEl2WE91VGxpdVlYZ3JKOUd5aGFSZVJhczR4MzBGdDdB?=
 =?utf-8?B?SitxOEc5OWloZDZySCtSaVA2Nm1CeUkwRi9DRXpFd0ZHVi9GdFF0QTFUbC90?=
 =?utf-8?B?RktITFZ3bXcxS2YreEZXTmd5NWJQSmVjVmFEUEIwdm9NLyt5RGU2UWs4SG1X?=
 =?utf-8?B?RFhCVm4zRklNTTRvdldLUmNoODJHQlRNOXFyRkJ5U3Y1dmZ2ZnlhSVJNaEsy?=
 =?utf-8?B?WDN4K2ZrUGdQVjYxNjFIVEdTbk1iRWo1cGdLVEs5T0FKQytDcnp1UEtzN0xW?=
 =?utf-8?B?dllDcFliNUhJUGxibU1JVldjSnZjUzgxMG5nQU9yQ2xYcXdiRW8vYi9JSE9k?=
 =?utf-8?B?ekJVcC9IdDJ2YXJ3RmN3UXdJbytwSXhpTERZTWprMjdIYlZYampXeVhsMXps?=
 =?utf-8?B?L0ozZzBrRmFIakFqUzg4eG5BZitCMTBsYngzU1BBbUljYXJWaTFqaVlmK3FS?=
 =?utf-8?B?QkRtUHh4R2dJa2hNM1pzVCtORVg3YlZLbks0YllFU282WG41ejBmZFlHd21i?=
 =?utf-8?B?UkVCSk9WZlU5ajZPZjRlcnhpeVZPT2QvSDVuSXpXSy8wclIxUThvY0FQTnpR?=
 =?utf-8?B?Y1dBS0ZFS2JVNi85U3N0R2lISzVGSGNkSWM4RFlPZmpwRmEwbUwxeTFHSi9J?=
 =?utf-8?B?dC9TcFVkUmhFTG8rcjFIQURBa21MYTFpaFlzc0hPU0t4U3VyN3M1dDZONXB0?=
 =?utf-8?B?SHRDQUFqQUoxTVE0N0N6V2xVcmJ2bU1uSi9yWDZVSENYOWxmSHBLV29KSE1F?=
 =?utf-8?B?V3U1Q1VoQUk0d3FkS0o5N0RuUGxQQVBoN0xDdW1OV044amdlZ2ZNT3NaY0tz?=
 =?utf-8?B?T0d0REIydnU4a216dVV4bDY4Qk9Ka0lYYzgzNXVSbDZ4L21rV3RUeVlxd0JP?=
 =?utf-8?B?ZnkydUtucGt1ZStxdVFiTXdFVVd2THBLRHZtVExhTytrR0hkYk8vSU1vWFFS?=
 =?utf-8?B?KzBRdHFOQzh0eVZQN2lvVFU2bmRDbkNtY0h1WnJWUkZjUjZ4MnNseWxCbmQr?=
 =?utf-8?B?djYrUzBhTktSVkhURVRjOENscWgxZDNUSkJvZ1A2akFXRTJxWlgwcXdRMXUv?=
 =?utf-8?B?ZUJjeUpaV3R1VDVEdFJCN2Y0SnRpNUtJcjd1ZE4rZmpnZlorYTBmeUx6eWVo?=
 =?utf-8?B?MXFQdnB3SUFKY0NsTm5xWGdONGE0SEF6L1ZMT2FxMll2all1bUFCc1FzOEd3?=
 =?utf-8?B?L3o0VUVYYjZFTldlTEI0aE11Y1k1NlJSdSsxRkh2elFsUFVzVHY2Yy9QWXQr?=
 =?utf-8?B?TFA3NTdlNFNZSGs0Q0xwUFFMVXRoYXFMNit5SU5FK3NQNnFPQjJHcHFlejJQ?=
 =?utf-8?B?ZkM4ajVRNUsxTzBMY05CdktXeWpnYWM3ck0zYXdkMnMwMWpLNDhhT0NKd0xG?=
 =?utf-8?B?ZUF4TnpFUGpSV0NsTUw3Z2IyTTZaSmxscy9YeEw2UmFLRTFscDhiREhYa09x?=
 =?utf-8?B?bFZOZ3owc0VqQ3Q2d2t6RTRZSWdHbWJ2QkxZSHpYbGRsdFNHRHV6S3R3bUVy?=
 =?utf-8?B?VnRTS1RTVWg2K1pGQXV3VTFXN2V5RDJpSWlGUGhKQ2FYM0lvb1ZDSzc4M3Vk?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E52968D11F1A884EA153C7BAC0CC2C2B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acee6c7-71c7-4447-020b-08dab8833384
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:24:47.0237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0hAhBQiOxc2uLO9oSQ9oA94yxIt3ArMVc+VQLsCdt+v7kGUmCNXTiEdDabIi2QwcjcYBaXuMCsIdfF8bRJ+Ybg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6726
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDA1OjQwIC0wNzAwLCBBbmRpIEtsZWVuIHdyb3RlOg0KPiBP
biAxMC8yNi8yMDIyIDQ6MTYgUE0sIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggbW9kdWxlIGlu
aXRpYWxpemF0aW9uIHJlcXVpcmVzIHRvIHVzZSBvbmUgVERYIHByaXZhdGUgS2V5SUQgYXMgdGhl
DQo+ID4gZ2xvYmFsIEtleUlEIHRvIHByb3RlY3QgdGhlIFREWCBtb2R1bGUgbWV0YWRhdGEuICBU
aGUgZ2xvYmFsIEtleUlEIGlzDQo+ID4gY29uZmlndXJlZCB0byB0aGUgVERYIG1vZHVsZSBhbG9u
ZyB3aXRoIFRETVJzLg0KPiA+IA0KPiA+IEp1c3QgcmVzZXJ2ZSB0aGUgZmlyc3QgVERYIHByaXZh
dGUgS2V5SUQgYXMgdGhlIGdsb2JhbCBLZXlJRC4gIEtlZXAgdGhlDQo+ID4gZ2xvYmFsIEtleUlE
IGFzIGEgc3RhdGljIHZhcmlhYmxlIGFzIEtWTSB3aWxsIG5lZWQgdG8gdXNlIGl0IHRvby4NCj4g
PiANCj4gPiBSZXZpZXdlZC1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVs
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCA5ICsrKysrKysr
Kw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90
ZHgvdGR4LmMNCj4gPiBpbmRleCA1ZDc0YWRhMDcyY2EuLjA4MjBiYTc4MWY5NyAxMDA2NDQNCj4g
PiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBAQCAtNjIsNiArNjIsOSBAQCBzdGF0aWMgc3RydWN0IHRk
c3lzaW5mb19zdHJ1Y3QgdGR4X3N5c2luZm87DQo+ID4gICBzdGF0aWMgc3RydWN0IGNtcl9pbmZv
IHRkeF9jbXJfYXJyYXlbTUFYX0NNUlNdIF9fYWxpZ25lZChDTVJfSU5GT19BUlJBWV9BTElHTk1F
TlQpOw0KPiA+ICAgc3RhdGljIGludCB0ZHhfY21yX251bTsNCj4gPiAgIA0KPiA+ICsvKiBURFgg
bW9kdWxlIGdsb2JhbCBLZXlJRC4gIFVzZWQgaW4gVERILlNZUy5DT05GSUcgQUJJLiAqLw0KPiA+
ICtzdGF0aWMgdTMyIHRkeF9nbG9iYWxfa2V5aWQ7DQo+IA0KPiANCj4gQ29tbWVudCBob3cgdGhp
cyBpcyBzZXJpYWxpemVkIChvciBkb2Vzbid0IG5lZWQgaXQpDQo+IA0KPiANCg0KVERILlNZUy5D
T05GSUcsIHdoaWNoIHRha2VzICd0ZHhfZ2xvYmFsX2tleWlkJyBhcyBpbnB1dCwgb25seSBuZWVk
cyB0byBiZSBjYWxsZWQNCm9uY2Ugb24gYW55IGNwdSwgc28gbm8gc2VyaWFsaXphdGlvbiBpcyBu
ZWVkZWQuDQoNClRESC5TWVMuS0VZLkNPTkZJRywgd2hpY2ggZG9lc24ndCB0YWtlICd0ZHhfZ2xv
YmFsX2tleWlkJyBhcyBpbnB1dCBidXQNCmludGVybmFsbHkgcHJvZ3JhbXMgaXQsIGRvZXMgcmVx
dWlyZSBzb21lIHNlcmlhbGl6YXRpb24gYXMgdGhpcyBTRUFNQ0FMTCBtdXN0IGJlDQpjYWxsZWQg
b24gb25lIGNwdSBmb3IgZWFjaCBwYWNrYWdlLCBhbmQgaXQgY2Fubm90IHJ1biBjb25jdXJyZW50
bHkgb24gZGlmZmVyZW50DQpjcHVzLiAgSG93IGFib3V0IGFkZGluZyB0aGUgY29tbWVudCBpbiB0
aGUgcGF0Y2ggd2hpY2ggZG9lcyBUREguU1lTLktFWS5DT05GSUc/DQoNCkhvdyBhYm91dCBiZWxv
dyAodGFrZW4gZnJvbSBwYXRjaCAxOCAieDg2L3ZpcnQvdGR4OiBDb25maWd1cmUgZ2xvYmFsIEtl
eUlEIG9uDQphbGwgcGFja2FnZXMiLCBidXQgYWRkZWQgImluIHNlcmlhbGl6ZWQgd2F5IGFzIGl0
IGNhbm5vdCBydW4gY29uY3VycmVudGx5IG9uDQpkaWZmZXJlbnQgY3B1cyIgYXQgdGhlIGVuZCBv
ZiB0aGUgZmlyc3Qgc2VudGVuY2UgaW4gdGhlIGNvbW1lbnQpPw0KDQpzdGF0aWMgaW50IGNvbmZp
Z19nbG9iYWxfa2V5aWQodm9pZCkNCnsNCglzdHJ1Y3Qgc2VhbWNhbGxfY3R4IHNjID0geyAuZm4g
PSBUREhfU1lTX0tFWV9DT05GSUcgfTsNCg0KCS8qDQoJICogQ29uZmlndXJlIHRoZSBrZXkgb2Yg
dGhlIGdsb2JhbCBLZXlJRCBvbiBhbGwgcGFja2FnZXMgYnkNCgkgKiBjYWxsaW5nIFRESC5TWVMu
S0VZLkNPTkZJRyBvbiBhbGwgcGFja2FnZXMgaW4gc2VyaWFsaXplZA0KCSAqIHdheSBhcyBpdCBj
YW5ub3QgcnVuIGNvbmN1cnJlbnRseSBvbiBkaWZmZXJlbnQgY3B1cy4NCgkgKg0KCSAqIC4uLi4u
Lg0KCSAqLw0KCXJldHVybiBzZWFtY2FsbF9vbl9lYWNoX3BhY2thZ2Vfc2VyaWFsaXplZCgmc2Mp
Ow0KfQ0KDQoNCg0KDQoNCg==
