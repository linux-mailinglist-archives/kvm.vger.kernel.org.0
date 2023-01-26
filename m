Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D599767C93D
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 11:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbjAZKzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 05:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbjAZKzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 05:55:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE946D54;
        Thu, 26 Jan 2023 02:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674730502; x=1706266502;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KV1DADbuUfqHbUhbk7RBggZeJy88NEU3j1JuO7MpU/E=;
  b=WfxKrCcChQVq8fLB53KIJy+bQY4FYS7MGOBGP4ct2qphVBLPS+Z7qPID
   HrOYNhh28wlK6LmuhNso8OZGhMG7cnIZE+Cj1GqkVmCAflQQUP4BezlRs
   y/Rq33xFxI0MffPtiOrfem2xipVfnLvZA9GqrB1LDG89EtRvl5Zs6dx91
   HUT0H0xLhGzx4UGcdDYRB9VRR2CwE0s7TiFo1PxlvDc81EGLX/fuTMwoi
   ltqIGXsaVf9hvwpI4SnBk2SxodadNuTpqb3QxSH6HRy8l9gPn2e62Ktco
   NIvQWqIKueWyq2Pad91iKR15dteiRah1QFLlwI+PZwgGcD9fzM4rMAyx6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="391296423"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="391296423"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 02:54:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="656130782"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="656130782"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 26 Jan 2023 02:54:41 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 02:54:41 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 02:54:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 26 Jan 2023 02:54:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 26 Jan 2023 02:54:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJJrT6Qn0D2nE0AhJnInio77AxxHLaskQK5u46POXZrBUXaz27Mx/XaRAQkG1bRGbMq0tZ3IAkX2UHqjI4MfUfQ3n3jLZH7X50UYPfF1oc1Usa4DijXyjVQnLrthcqFYZ6lBWo+QwOHinSLUBMfpuwUR4rd63ZBwhb809VcD3F1qVQPwliOR96298APT2zqoR7MhZCYCAqQaR/iywehZR29IT8yqdto6trzukwfU26rT9m9aOkHe8H8hLaU/ClZGcD4CXyuFvmKX9PEDxGH2A2zXxdgsdSy9Dj6sFAw8/76xCfZFPxvkXylQR4rbJchcT/LVg4cr1irNHje4ejMgOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KV1DADbuUfqHbUhbk7RBggZeJy88NEU3j1JuO7MpU/E=;
 b=O+ivKwwQJQkVAJGe+E/AVuHKMpuCozftPT05BHkhoLkTIU+QA3FkweRfwQbQNlKIp2DlkhHGdOHnaqfPt8tsCLsK4pSgnckOh60YyiB1OEKIaIVqupPkZxcvxIPIXH2RTN9UGgnZE8uEOMjhukYQbFUJeYMr9DeOweIiST5eB8FjyUcaczaLob1mbktNcZOVlBkxPDwOeFVcfNYg3m8j+NJqkvidEzEAJUvKDg9Z5q8rQitzgb92H2+koTpcecmTDT6/aENaO/Hg09om0fKStrDqY180DChvcoKxM7wV5mQTaIjkUyJK22mh0UOr7qD1AICbz4bPb1AFWRSCO+IqTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4613.namprd11.prod.outlook.com (2603:10b6:208:26d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 10:54:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 10:54:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Thread-Index: AQHZJqOgR/AYJ+DUHUGfsmh5dZfuuq6cVDsAgAAiagCAAS3PgIAFJp+AgAA/zQCAABQhgIAAAWcAgAKFUoCAAETpAIAAVHGAgAAP1gCAACa5AIAABg4AgAFyH4CAAB7oAIADQFwAgAEJgQCABEVHAA==
Date:   Thu, 26 Jan 2023 10:54:37 +0000
Message-ID: <e5912f7d04ce7a27a68ce4328fc50ce594295c6c.camel@intel.com>
References: <Y8cMnjHFNIFaoX27@google.com>
         <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
         <Y8ljwsrrBBdh1aYw@google.com>
         <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
         <Y8m34OEVBfL7Q4Ns@google.com>
         <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
         <Y8ndcGHUHQjHfbF9@google.com>
         <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
         <Y8st2PjGDQ+Q0LlW@google.com>
         <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
         <Y87GzHrx8vxZLBEJ@google.com>
In-Reply-To: <Y87GzHrx8vxZLBEJ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4613:EE_
x-ms-office365-filtering-correlation-id: 341a8c31-c7c5-4c09-ae40-08daff8bb7f5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S+rc+QBw9jo9gzq4Tfw6EvqDErmNnJCVt+lLzNR0Mi4eW74QUq/tsRrh6h/WFSy20ympzi0YyDhvHmtKFlfO5WIGXjwtcRzBkYaE3eckyb1oYe13iK6+Rzpx9VsNW6QeDi7KLDJvhd8haFFgAurjd9nd9Gh7KkHbmsdDQv2UcOh1cKONq8opKj+dZJLred2WM5sK3xdNBLvbzmkV6usCHvd4dK6r/E5aivMySPEfkKw8ZN95F/Qa1ejnektZfMwXZfPsEbrkw8vpEvxApNHy50Eb8oESkOc2J2i36orU4GkyYR2szI2TQrUHFOfODMejJ8hj2qX4fyJMVByqrdZ/u1QMBH3PmNRevVbgRPNlGSlw5uxPmffewjtscndRq7FQG0w/lYZpdd9FqY3vHqS8DL51LOwingqoV6tLCfJ/S2y7LyxijwEobcOMQfXKrKh1cdK/t++G0uarEYRQsctp/VcnhYRc9vpTYiuFDqgZ3WkQI0p1adw9uZAgtu9PqmQjcjjy/RYpw759OZc+uMhOO39nz3WcORX3Mw8raIawKUdsjlQ2ufkaBu4rKBXXvQyHjSXQLz2xPXBx94yM5i2W6IdZhx+k7v4sq0DwR27OrPSiTa6qkjyS2cxbCnGR6kCnvw070yXRqhzHrIB7HqDp6XDQymVUnTJVOahVLHWpXGgs5SLwMgUHg/KTgBnKAQiwJNOF8QwIM/Z7UVfOhX/VIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199018)(54906003)(38100700002)(122000001)(41300700001)(8676002)(66446008)(66476007)(76116006)(91956017)(4326008)(66946007)(6916009)(5660300002)(86362001)(8936002)(36756003)(38070700005)(64756008)(2906002)(82960400001)(6506007)(66556008)(316002)(6512007)(26005)(186003)(478600001)(6486002)(83380400001)(107886003)(71200400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d25EZFBabEFncThRY2dNVW1xczF0WWV4ZmNISkwxVzZkNHNGRUpic2JSeTY5?=
 =?utf-8?B?eEI2VUYxekpPRk13anJiUVkxSDlUeFIvRTN5UzBJTG5GaDJ5UlNmcGNQclNH?=
 =?utf-8?B?YzlhdDZ0ZG9nRDBmUUFwUDMreS81MVFFcHZtL0c2Q25QZDJEQm9BZU1qemNk?=
 =?utf-8?B?OGI1NENzSnd3d1lYR2lnS0J4NjNYNFl2dm1YWjgxMzJOWm83V21MdDNmZlN0?=
 =?utf-8?B?OVBTNGo5Zldzc1ZmWnZxZ25DMUlMT1NKVS9nNEVBY0hKV1h0MEs1QU9TdXFt?=
 =?utf-8?B?WmZWOEZvdy92SU9oeFVBRWxXeVNEalRtNUdseHhtcVFJVC9SbEdBTWowK3Fx?=
 =?utf-8?B?Nmw1anpDNnJydVBGRG5xaHVrVWQ5M0ZrNW5jZE1FMlI5M2pINkxzcENTaEF4?=
 =?utf-8?B?M2dEcCsydGFhODRQd2lFOE5PQUZ3QXVsakNudEgyYkpyaWF3TVdLQ1NHTk5v?=
 =?utf-8?B?Q3RRK043ZEdQbTE3Q0I1L0lUV2FpSlZCTUpJczc5L2dKbzZ6TTRVL0hVYnJw?=
 =?utf-8?B?ajlac3JIVFBkdGZ3WVJzbjVDWkE1bnJtbWNVa1hjOHNwVWZJNHlpOFZROWRK?=
 =?utf-8?B?NHFNQjFxMXZDemYyc3MrWENLSDR2RlJTeVlPK0tWbWxtNDNlamlwZzhOdWFY?=
 =?utf-8?B?RjgzNGJvVmtwSWxzK2dNeGVWNkRPekh4bGk2dkNHY2RFUjlpUHpjOHhhK3Rm?=
 =?utf-8?B?Wkw3L1lqcXV4ZDIrMmYyY2dEK1ZaMnpxWHZVT3NiSkZLcFVOZHRXRmlUYkl3?=
 =?utf-8?B?Rm5Rb09JWW1GZVFsSVZIUWZFbHhUNk04YzNjY0dpS0hCd0dyTVc0TCtQbkU5?=
 =?utf-8?B?NWhsR0VrNkErdkN0SDZVdHBpVFdWMFB4YWJSZWVpb1daSXNpZVJQd0I0d3Zn?=
 =?utf-8?B?dld5U210amcxWFlSYzkzUGJIZktJNmRBSkNHRkRMdXJicnZDTjVBeGhxc0xV?=
 =?utf-8?B?WGNNdDJPOXhVRDAyLzVJbHZ2V2twYzlyOUR6L0N4Z1ZKS0tMUndlWTNXM2tR?=
 =?utf-8?B?WEYwYkk3WFcvZzA3OFJvMnFncGl2REczaGxwSDRUZ0ZabzV4Z2VhNlZZR29O?=
 =?utf-8?B?MGV6WjRYWnRQQTNBbEJzRG1DaGlZUlY0a2NXdWptazZIWElCRnMvcEpvR3ov?=
 =?utf-8?B?eWJpVVhqWGNOOXptbVZLY1FnL0RUOXpwVlB5Q0RqaW9DSkZlVDgzUEtUdVIv?=
 =?utf-8?B?SlIycFN3K0gzbFRmeTV1ZHE0KzVrOHNpcVo1RGthYlZWS2R6bnhuUHg5a3RX?=
 =?utf-8?B?RzFDYnpsbERnWHNlK2Jnb012Y2RlcTF1M0ZBVXRQTDI3cGNRVEpHaXhKdDNv?=
 =?utf-8?B?cnpIV0ZXbHV0Rk5WUUd2TjN2ZGRVNVFnNEJDY1RqZFpiQ3QxZkkrWU1QMzJw?=
 =?utf-8?B?TUk0dmFKdUl0NDBiZ2Faamo5UFZLVnp4cEdieWJqVk5qc2FXbUJiaGtCWGRq?=
 =?utf-8?B?OHB0WU5KVTBaOThZd1Vqb3o2V0lJSSt3Z0VxZWdjcHlQdFdyT2RDcXYvSXlt?=
 =?utf-8?B?SU4zKzlsek8yQWpkZUdHYVVWd3QwZkw4amFSa2xLMGRjTVVDT2d3V0hqKzE4?=
 =?utf-8?B?NWZqbUZyMUc0MGoxOUdyc1pxVnpkblFIQ2FTNGZiMHlpQnBrQWpPTWRmanJm?=
 =?utf-8?B?a0tQeHB4Tlovd01YRnhyZjBwZjg1bTFDZHIzMkN5S1laaWhrVFYwOGlZYkxU?=
 =?utf-8?B?bllNYk1QVmcwbTdyNklYYlR1ek9TeUhIRVk4U0VPemVveFJXa0pxMDZxQWRi?=
 =?utf-8?B?bDdXOGxoSlc4ZjFHRGxlMklEYzJaT0dXYVhscXM5NDh6clhSQ1R1QldyV1Zt?=
 =?utf-8?B?bi9zYWt1QTR6OWFGNHlRSUlReVliTFRhaUFSeWZNZXF4c2VRRmN5Zi9BQ1hE?=
 =?utf-8?B?aC9mS1FhSExMQW9hTW5DcFVKYmxUeENpVWI2cmdCMDRvNUc3SGRuZTd2bWw4?=
 =?utf-8?B?WHEvR3VtTUZYdjdlMzBORzNDaDVya1RTb2VwTlN3RWhXeHVhVDlsb1FvKzdm?=
 =?utf-8?B?WlNpMnRrM3Z3dXVBVlZ1OGFtK2dsbFkzV1l6cVVlQk1VR3NsTjJEWlNIc1NV?=
 =?utf-8?B?VzFKbWRSRzZwQmpjLzZzTnNkektPNFhDcEtwYzlLdFhxVHpseXFkTjg0Q1ZX?=
 =?utf-8?B?dkVkZHg1VnV1ZUNuZ1I5L3ZtcXRETlhnVDQ2amtyRkhqaTk1Z0c4T3ZqTjBY?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C3BBF0F63CE1C448021D5A0A08EC3AA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341a8c31-c7c5-4c09-ae40-08daff8bb7f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 10:54:37.7746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h3bEA3NhOqHlVyq7IMI25P+eGkivsKolckGbHMr8CHOamnUl/UwTwwkQufVu4SaEJ+UpHB+LWLchlLmp2C7XrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4613
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTIzIGF0IDE3OjQxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIEphbiAyMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IA0K
PiA+ID4gDQo+ID4gPiBJbnRlbCBmb2xrcywNCj4gPiA+IA0KPiA+ID4gRG8geW91IGhhcHBlbiB0
byBrbm93IGV4YWN0bHkgd2hhdCBzY2VuYXJpbyBwcm9tcHRlZCBhZGRpbmcgdGhlIGZyZWV6ZSt1
bmZyZWV6ZQ0KPiA+ID4gY29kZT8gIElzIHRoZXJlIHNvbWV0aGluZyBJJ20gZm9yZ2V0dGluZy9t
aXNzaW5nLCBvciBpcyBpdCBwb3NzaWJsZSB3ZSBjYW4gZ28NCj4gPiA+IHdpdGggYSBzaW1wbGVy
IGltcGxlbWVudGF0aW9uPw0KPiA+IA0KPiA+IEl0J3MgZG9jdW1lbnRlZCBpbiB0aGUgIlREWCBU
RFAgTU1VIGRlc2lnbiBkb2MiIHBhdGNoOg0KPiA+IA0KPiA+ICtURFggY29uY3VycmVudCBwb3B1
bGF0aW5nDQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAuLi4uLi4NCj4gPiAr
DQo+ID4gK1dpdGhvdXQgZnJlZXppbmcgdGhlIGVudHJ5LCB0aGUgZm9sbG93aW5nIHJhY2UgY2Fu
IGhhcHBlbi4gIFN1cHBvc2UgdHdvIHZjcHVzDQo+ID4gK2FyZSBmYXVsdGluZyBvbiB0aGUgc2Ft
ZSBHUEEgYW5kIHRoZSAyTSBhbmQgNEsgbGV2ZWwgZW50cmllcyBhcmVuJ3QgcG9wdWxhdGVkDQo+
ID4gK3lldC4NCj4gPiArDQo+ID4gKyogdmNwdSAxOiB1cGRhdGUgMk0gbGV2ZWwgRVBUIGVudHJ5
DQo+ID4gKyogdmNwdSAyOiB1cGRhdGUgNEsgbGV2ZWwgRVBUIGVudHJ5DQo+ID4gKyogdmNwdSAy
OiBURFggU0VBTUNBTEwgdG8gdXBkYXRlIDRLIHNlY3VyZSBFUFQgZW50cnkgPT4gZXJyb3INCj4g
PiArKiB2Y3B1IDE6IFREWCBTRUFNQ0FMTCB0byB1cGRhdGUgMk0gc2VjdXJlIEVQVCBlbnRyeQ0K
PiANCj4gT29oLCB0aGUgcHJvYmxlbSBpc24ndCB0aGF0IHR3byBTRUFNQ0FMTHMgdG8gdGhlIHNh
bWUgZW50cnkgZ2V0IG91dCBvZiBvcmRlciwgaXQncw0KPiB0aGF0IFNFQU1DQUxMcyBvcGVyYXRp
bmcgb24gY2hpbGQgZW50cmllcyBjYW4gcmFjZSBhaGVhZCBvZiB0aGUgcGFyZW50LiAgSHJtLg0K
PiANCj4gVERYIGFsc28gaGFzIHRoZSBhbm5veWluZy1idXQtdW5kZXJzdGFuZGFibGUgcmVzdHJp
Y3Rpb24gdGhhdCBsZWFmcyBuZWVkIHRvIGJlDQo+IHJlbW92ZWQgYmVmb3JlIHBhcmVudHMuICBB
IG5vdC15ZXQtcmVsZXZhbnQgY29tcGxpY2F0aW9uIG9uIHRoYXQgZnJvbnQgaXMgdGhhdCB0aGUN
Cj4gVERQIE1NVSdzIGJlaGF2aW9yIG9mIHJlY3Vyc2l2ZWx5IHJlbW92aW5nIGNoaWxkcmVuIG1l
YW5zIHdlIGFsc28gaGF2ZSB0byB3b3JyeQ0KPiBhYm91dCBQUkVTRU5UID0+ICFQUkVTRU5UIHRy
YW5zaXRpb25zLCBlLmcuIHphcHBpbmcgYSBjaGlsZCBiZWNhdXNlIHRoZSBwYXJlbnQgaXMNCj4g
YmVpbmcgcmVtb3ZlZCBjYW4gcmFjZSB3aXRoIGEgZGlmZmVyZW50IHZDUFUgdHJ5IHRvIHBvcHVs
YXRlIHRoZSBjaGlsZCAoYmVjYXVzZQ0KPiB0aGUgdkNQVSBoYW5kbGluZyBhIHBhZ2UgZmF1bHQg
Y291bGQgaGF2ZSBzZWVuIHRoZSBQUkVTRU5UIHBhcmVudCkuDQoNClllcy4NCg0KPiANCj4gSSB0
aGluayB0aGVyZSdzIGFuIG9wcG9ydHVuaXR5IGFuZCBtb3RpdmF0aW9uIHRvIGltcHJvdmUgdGhl
IFREUCBNTVUgYXMgYSB3aG9sZSBvbg0KPiB0aGlzIGZyb250IHRob3VnaC4gIFJhdGhlciB0aGFu
IHJlY3Vyc2l2ZWx5IHphcCBjaGlsZHJlbiBpbiBoYW5kbGVfcmVtb3ZlZF9wdCgpLA0KPiB3ZSBj
YW4gdXNlIHRoZSBSQ1UgY2FsbGJhY2sgdG8gcXVldWUgdGhlIHBhZ2UgdGFibGUgZm9yIHJlbW92
YWwuICBTZXR0aW5nIHRoZSBwYXJlbnQNCj4gKHRhcmdldCBwYWdlIHRhYmxlKSAhUFJFU0VOVCBh
bmQgZmx1c2hpbmcgdGhlIFRMQnMgZW5zdXJlcyB0aGF0IGFsbCBjaGlsZHJlbiBhcmUNCj4gdW5y
ZWFjaGFibGUsIGkuZS4gS1ZNIGRvZXNuJ3QgbmVlZCB0byBpbW1lZGlhdGVseSBzZXQgY2hpbGRy
ZW4gIVBSRVNFTlQuICBVbmxpa2UNCj4gdGhlIHNoYWRvdyBNTVUsIHdoaWNoIG1haW50YWlucyBh
IGhhc2ggdGFibGUgb2Ygc2hhZG93IHBhZ2VzLCBvbmNlIGEgcGFyZW50IHBhZ2UNCj4gdGFibGUg
aXMgcmVtb3ZlZCBmcm9tIHRoZSBURFAgTU1VLCBpdHMgY2hpbGRyZW4gYXJlIHVucmVhY2hhYmxl
ZC4NCg0KRG8geW91IG1lYW4gc29tZXRoaW5nIGxpa2UgKHBzZXVkbyk6DQoNCglyY3VfY2FsbGJh
Y2soJnJlbW92ZWRfc3AtPnJjdV9oZWFkLCBoYW5kbGVfcmVtb3ZlZF9wdCk7DQoNCj4gDQo+IFRo
ZSBSQ1UgY2FsbGJhY2sgbXVzdCBydW4gaW4gbmVhci1jb25zdGFudCB0aW1lLCBidXQgdGhhdCdz
IGVhc3kgdG8gc29sdmUgYXMgd2UNCj4gYWxyZWFkeSBoYXZlIGEgd29ya3F1ZXVlIGZvciB6YXBw
aW5nIHBhZ2UgdGFibGVzLCBpLmUuIHRoZSBSQ1UgY2FsbGJhY2sgY2FuIHNpbXBseQ0KPiBhZGQg
dGhlIHRhcmdldCBwYWdlIHRvIHRoZSB6YXAgd29ya3F1ZXVlLiAgVGhhdCB3b3VsZCBhbHNvIGFs
bG93IGZvciBhICh2ZXJ5IG1pbm9yKQ0KPiBzaW1wbGlmaWNhdGlvbiBvZiBvdGhlciBURFAgTU1V
IGNvZGU6IHRkcF9tbXVfemFwX3Jvb3QoKSB3b3VsZG4ndCBuZWVkZWQgdG8gemFwIGluDQo+IHR3
byBwYXNzZXMgc2luY2UgemFwcGluZyBjaGlsZHJlbiBvZiB0aGUgdG9wLWxldmVsIFNQVEVzIHdv
dWxkIGJlIGRlZmVycmVkIHRvIHRoZQ0KPiB3b3JrcXVldWUuDQoNCkRvIHlvdSBtZWFuIHphcHBp
bmcgdGhlIGVudGlyZSBwYWdlIHRhYmxlIChmcm9tIHJvb3QpIGRvZXNuJ3QgbmVlZCB0byBiZSBp
biBSQ1UNCnJlYWQtY3JpdGljYWwgc2VjdGlvbiwgYnV0IGNhbi9zaG91bGQgYmUgZG9uZSBhZnRl
ciBncmFjZSBwZXJpb2Q/ICBJIHRoaW5rIHRoaXMNCm1ha2VzIHNlbnNlIHNpbmNlIHphcHBpbmcg
ZW50aXJlIHJvb3QgbXVzdCBoYXBwZW4gd2hlbiByb290IGlzIGFscmVhZHkgaW52YWxpZCwNCndo
aWNoIGNhbm5vdCBiZSB1c2VkIGFueW1vcmUgd2hlbiB0aGUgbmV3IGZhdWx0cyBjb21lIGluPw0K
DQo+IA0KPiBCYWNrIHRvIFREWCwgdG8gcGxheSBuaWNlIHdpdGggdGhlIHJlc3RyaWN0aW9uIHRo
YXQgcGFyZW50cyBhcmUgcmVtb3ZlZCBvbmx5IGFmdGVyDQo+IGNoaWxkcmVuIGFyZSByZW1vdmVk
LCBJIGJlbGlldmUgS1ZNIGNhbiB1c2UgVERILk1FTS5SQU5HRS5CTE9DSyB0byBtYWtlIHRoZSBw
YXJlbnQNCj4gIVBSRVNFTlQuICBUaGF0IHdpbGwgZWZmZWN0aXZlbHkgcHJ1bmUgdGhlIFMtRVBU
IGVudHJ5IGFuZCBhbGwgaXRzIGNoaWxkcmVuLCBhbmQNCj4gdGhlIFJDVSBjYWxsYmFjayB3aWxs
IGFnYWluIGVuc3VyZSBhbGwgaW4tZmxpZ2h0IFNFQU1DQUxMcyBmb3IgdGhlIGNoaWxkcmVuIGNv
bXBsZXRlDQo+IGJlZm9yZSBLVk0gYWN0dWFsbHkgdHJpZXMgdG8gemFwIHRoZSBjaGlsZHJlbi4N
Cg0KUmVhZGluZyB0aGUgc3BlYywgaXQgc2VlbXMgVERILk1FTS5SQU5HRS5CTE9DSyBvbmx5IHNl
dHMgdGhlIFNlY3VyZSBFUFQgZW50cnkNCndoaWNoIHBvaW50cyB0byB0aGUgZW50aXJlIHJhbmdl
IGFzICJibG9ja2VkIiwgYnV0IHdvbid0IGdvIGRvd24gdW50aWwgbGVhZiB0bw0KbWFyayBhbGwg
RVBUIGVudHJpZXMgYXMgImJsb2NrZWQiLCB3aGljaCBtYWtlcyBzZW5zZSBhbnl3YXkuDQoNCkJ1
dCBpdCBzZWVtcyBUREguTUVNLlBBR0UuUkVNT1ZFIGFuZCBUREguTUVNLlNFUFQuUkVNT1ZFIGJv
dGggb25seSBjaGVja3MNCndoZXRoZXIgdGhhdCB0YXJnZXQgRVBUIGVudHJ5IGlzICJibG9ja2Vk
IiwgYnV0IGRvZXNuJ3QgY2hlY2sgd2hldGhlciBhbnkgcGFyZW50DQpoYXMgYmVlbiBtYXJrZWQg
YXMgImJsb2NrZWQiLiAgTm90IHN1cmUgd2hldGhlciB0aGlzIHdpbGwgYmUgYSBwcm9ibGVtLiAg
QnV0DQphbnl3YXkgaWYgdGhpcyBpcyBhIHByb2JsZW0sIHdlIHBlcmhhcHMgY2FuIGdldCBURFgg
bW9kdWxlIHRvIGZpeC4NCg0KPiANCj4gQW5kIGlmIHdlIHJld29yayB6YXBwaW5nIHBhZ2UgdGFi
bGVzLCBJIHN1c3BlY3Qgd2UgY2FuIGFsc28gYWRkcmVzcyBEYXZpZCdzIGNvbmNlcm4NCj4gKGFu
ZCBteSBub3QteWV0LXZvaWNlZCBjb25jZXJuKSBhYm91dCBwb2xsdXRpbmcgdGhlIFREUCBNTVUg
Y29kZSB3aXRoIGxvZ2ljIHRoYXQgaXMNCj4gbmVjZXNzYXJ5IG9ubHkgZm9yIFMtRVBUIChmcmVl
emluZyBTUFRFcyBiZWZvcmUgcG9wdWxhdGluZyB0aGVtKS4gIFJhdGhlciB0aGFuIHVwZGF0ZQ0K
PiBTLUVQVCBfYWZ0ZXJfIHRoZSBURFAgTU1VIFNQVEUsIGRvIHRoZSBTLUVQVCB1cGRhdGUgZmly
c3QsIGkuZS4gaW52b2tlIHRoZSBLVk0gVERYDQo+IGhvb2sgYmVmb3JlIHRyeV9jbXB4Y2hnNjQo
KSAob3IgbWF5YmUgaW5zdGVhZCBvZj8pLiAgVGhhdCB3YXkgS1ZNIFREWCBjYW4gZnJlZXplIHRo
ZQ0KPiB0by1iZS1pbnN0YWxsZWQgU1BURSB3aXRob3V0IGNvbW1vbiBURFAgTU1VIG5lZWRpbmcg
dG8gYmUgYXdhcmUgb2YgdGhlIGNoYW5nZS4NCg0KSSBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIGhv
dyBwdXR0aW5nIFNFQU1DQUxMIGJlZm9yZSB0aGUgdHJ5X2NtcHhjaGc2NCgpIGNhbg0Kd29yay4g
IExldCdzIHNheSBvbmUgdGhyZWFkIGlzIHBvcHVsYXRpbmcgYSBtYXBwaW5nIGFuZCBhbm90aGVy
IGlzIHphcHBpbmcgaXQuIA0KVGhlIHBvcHVsYXRpbmcgdGhyZWFkIG1ha2VzIFNFQU1DQUxMIHN1
Y2Nlc3NmdWxseSBidXQgdGhlbiB0cnlfY21weGNoZzY0KCkNCmZhaWxzLCBpbiB0aGlzIGNhc2Ug
aG93IHRvIHByb2NlZWQ/DQoNCj4gDQo+ID4gKCBJIGd1ZXNzIHN1Y2ggbWF0ZXJpYWwgd2lsbCBi
ZSBtb3JlIHVzZWZ1bCBpbiB0aGUgY29tbWVudC4gIEFuZCBwZXJoYXBzIHdlIGNhbg0KPiA+IGdl
dCByaWQgb2YgdGhlICJURFggVERQIE1NVSBkZXNpZ24gZG9jIiBwYXRjaCBpbiB0aGlzIHNlcmll
cyBhdCBsZWFzdCBmb3Igbm93IGFzDQo+ID4gcHJvYmFibHkgbm9ib2R5IHdpbGwgbG9vayBhdCBp
dCA6LSkgKQ0KPiANCj4gUGxlYXNlIGtlZXAgdGhlIGRlc2lnbiBkb2MsIEknbGwgZGVmaW5pdGVs
eSByZWFkIGl0LiAgSSdtIGp1c3QgY2hhc2luZyB0b28gbWFueQ0KPiB0aGluZ3MgYXQgdGhlIG1v
bWVudCBhbmQgaGF2ZW4ndCBnaXZlbiB0aGUgVERYIHNlcmllcyBhIHByb3BlciByZXZpZXcsIGku
ZS4gaGF2ZW4ndA0KPiBldmVuIGdsYW5jZWQgdGhyb3VnaCBhbGwgb2YgdGhlIHBhdGNoZXMgb3Ig
ZXZlbiB0aGUgc2hvcnRsb2cuDQoNCg0K
