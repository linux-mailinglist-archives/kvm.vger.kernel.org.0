Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AC66DCAC3
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjDJSbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDJSbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:31:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1182A1BD8;
        Mon, 10 Apr 2023 11:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681151503; x=1712687503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IopqkS/WHfAlSccHMNgMSX955fQPVsRVewpKs/jiEmk=;
  b=K81Pi0AzGy+NaXV8qsarRKXSE58d/Ac9OK0+TofjK4YTi02zIgmokr3m
   qn9++r57S1oU2PDfFJzZoVOEvC4U92x8GI9oWjgjlrGtqRUeZm5iuXQQ5
   RIwdZ+Nr+hQXyHZInHa1LqCuR+/W3I8Lrg8iZIRnRp5mgcRbkM9qNu4Ya
   qCoKjIWwRATX+JEjAnXp7ApBQmVo45lahZqYITtJUdEtSgnbs+Gqo9h6j
   kPCEbP347KSor1EGFkua0Q4hhWVRwp7Y58DIzv+iuGjfSH/6X0o4pO3ye
   vG2rxG/lu5wMjDm9ZbTjWFm8bKxEEWTnFquFJA6yMm7OhhvGxRujAkxv7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="332103074"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="332103074"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:31:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="1018067632"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="1018067632"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2023 11:31:40 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 11:31:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 11:31:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 11:31:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 11:31:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMfKE0bJBHC2EnsN+l4fkXJer4VPxT2V/2ATkJ+ee9VEWMuH6+uo9mfs3xIhmKvx0Wf/rWA4RbrWhhyF6OU07XnaZjOaJSYm+HJxV9XURrW/AHR/BP56q/KXpHqV7sFR2nAujQ/pRcjEhoAqNYaYHp9xluG1AyfxY2tWWAg3gPgdiQ2G+EHqepA+hboPl0w/IjjQUFd5LgHLnlQgwNICrgZfpb4Em6fdtqAUGp4ed7sqxJkz3rpRRGvko257OLOQpM/XP8UNdO28Ahnrjyo3RW7qBbq2ks6+27x+aEEli8+W4d3N4wrJzp8iUJYXtjI/l180il1EUUbDnoCcsSMCQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IopqkS/WHfAlSccHMNgMSX955fQPVsRVewpKs/jiEmk=;
 b=VU0atq5AOa3DLCvyvsn0ITRsu4QaMbkTL641UEqVlyoirjxvRAjUwHP+OsIzgr61TPwzm/Rckt1guZ+OMHIW2bl1usLxGEeuCYUp7/nmuJ9FU8qWxmU0GvEuMJ/Jc9MpFPFxFMhe65ZVVBaVSm/bxAvPxIN1fm4rJQjwvVI2OisoNi1axPzqvYj+S1LXjf4vxhS8mLKRvmVGeIlg8oo4cQlaTqhr+Ov4j0K/85uJ4HY7z601HZqnZBbQlymqzIqvqxG9H6aaH9ckg3cz9PTsQPiFZKLnQpFYUhWTU5a4sjm/qvlWkzOnt1vG0OyLNe3s2rXWIzXNBk68WoNhoLILXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB6747.namprd11.prod.outlook.com (2603:10b6:510:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 18:31:31 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 18:31:31 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v7 23/33] x86/fred: let ret_from_fork() jmp to
 fred_exit_user when FRED is enabled
Thread-Topic: [PATCH v7 23/33] x86/fred: let ret_from_fork() jmp to
 fred_exit_user when FRED is enabled
Thread-Index: AQHZZuQAhOn3U+sdnkOeEQpf5aTJma8k40uAgAADRiA=
Date:   Mon, 10 Apr 2023 18:31:31 +0000
Message-ID: <SA1PR11MB673446DC2CFD6DEDF97AC954A8959@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
 <20230404102716.1795-24-xin3.li@intel.com>
 <bbde7529-eb64-5454-0984-bfdabac37b64@intel.com>
In-Reply-To: <bbde7529-eb64-5454-0984-bfdabac37b64@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB6747:EE_
x-ms-office365-filtering-correlation-id: 4e128cdd-aa16-4b0a-2c2a-08db39f1ce6a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eQkRm7IO1R+yaGQCALGMhgHXg/FS8gfDFIX5NegdooivJW2niJQ0EPhOxnr8K2CzvXz+l1hzDt6YWf01DF+BmfYEWsxyiMuN+YulivhodlQKvqlQcXuZWamhHvQlkNzvrrKGEsI3el473gKsBAAXvOEPEz+Y4KjDkyBpF9wJ+ihp2wzmwKbwWAraMrf1CstWZa+LXWcut5Gu9qVfKpICZYO8VFItX5Ix99nk67bXX+7gfK/6s3QgJip0Dv4j69XgT+y7g+iOAeW2ti0w4znFFeuVa+YtKeC6LEIa2bOtv4v2hQlZGefrCy0p0MFY75WhAShB9i0mmlv3i0lUn8Q1HcirpqPFrF0m3c37hwtd8aViyveEjGbU7IrNrBe+mNj8h6BSwKEsdcU11G40wq5ouGJMsIlda3WtiDMs/Q9N1po08b1ExH9iZYVG7xuKx2LHNSU/dle9EfrR5yREpV4P1gQzt5y+bOssD4u1HK1UedRC/ShK3eMB22p0oUKNZ1CWf/QjU887jZvZGYQWJQeJOS6K1O3BGEKuOFhlezNgfjU0kpQu153G1oGUh8JV87SXRnf7NHAX24plKFkdo57fagCxHJfp+L7z2iIJ0w+dIQWonWCHopNn/Q7dvy7jBU1c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(7696005)(71200400001)(478600001)(86362001)(55016003)(33656002)(83380400001)(82960400001)(122000001)(38100700002)(38070700005)(4744005)(2906002)(110136005)(316002)(9686003)(186003)(54906003)(53546011)(26005)(6506007)(7416002)(66476007)(66446008)(8936002)(8676002)(41300700001)(66556008)(52536014)(64756008)(5660300002)(76116006)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzEzbXdPSzM5VWoxUHUwN3p1MHY0OVdNZXpRWHVsRzZhcFErSDYzUzBoOEZp?=
 =?utf-8?B?R2RjVlZPMzYvT0tFcGY0TDNDelN1OG4weUY1UDlLamJOZ0U2ajkwaXJXdnlT?=
 =?utf-8?B?azVoRTJvKzczb0tSNHBBSkhyVmpMR0NNN1hVY0pwUzRxZzhyRi9KRTRVWTJT?=
 =?utf-8?B?Y0pmNXQzaitNZjYva3E2OXNXS0hoejFXRmJEaTFuWGlUdWpTYWhaUThMbVdJ?=
 =?utf-8?B?bTBTbGZyOEpMUmVvN3VKQzNrQmRmK2VhWlEyN0lDdEJsY2pyMGo2QW1xc3Fi?=
 =?utf-8?B?OURCMDBQN25WOFZTZ2VTQVhoOWRmRUJqTDBpTFp2cDd3YjVrRWhiWUl4V1Yz?=
 =?utf-8?B?R2N6RkgvQ05SbndmVVVMdjZxSnN4eFBTMDk3V1ZtNkc3OGovMEcwbitSWjlP?=
 =?utf-8?B?N05oRE13NlU1eXlidElWTGFIaG1aUGx5b3N3a0NpUUJkbGpxZmltMGVrUkdO?=
 =?utf-8?B?YnB6dVNtZElUMXNOZVZ2NmVRanlmd1c5UGczVm1vY1RTZjVaVm4rVUFOcE1X?=
 =?utf-8?B?TFgxZlBjOEU5V21HcnFNNUNSK3BsSTNmd1N0cHczQ1ZCQ2RiczJ3Zmwvb1ZO?=
 =?utf-8?B?eGVoRWFkNjY2cEphSUdwZVRzY1B3cHlZT3FJVUFZN1p2U0llZVdMTXFxYlVa?=
 =?utf-8?B?M09wSnRtUDdnZUxFNURRNElZaXM5MGJuRmpIMmkxYmxXQjlOUmNRc2tra0c0?=
 =?utf-8?B?RWQra3E1SW96VXpqalVNMkxDMEx5cFhlc3FFZk8weUwxdWxJaVJLNnRNdFhr?=
 =?utf-8?B?MDNCaWNvN0RqUG0xbUdOMGtHQThGbzNDbDRWRXhyUXp1VlEzZlJFcVNiTTdk?=
 =?utf-8?B?b2Rka0NuRU5OaHNMS1FZNldkd2RlOTFmaGE5UUJnSURjOXU5OFFuOFp3OHVM?=
 =?utf-8?B?ZzVJZEp3VWhQUE1mUFJUZUsrM2NjQ1Q0YVc3L1dYYjV0Q0d3VUc3blFiQnhp?=
 =?utf-8?B?WlhmazlPazdvU2R0Vm9acUtsNG5VWS9jMzdoUFZOMDN6R0RlVng1TnoyaFVX?=
 =?utf-8?B?WG5tQUJMR2h2QTcrejJPM3VLNHJaR3pJbWlzVGtuWDkrbXN0eDUweHNSOUlC?=
 =?utf-8?B?UmNLbUJDUmJ5VElsaXl1YTlrZ0c4QmIxZnFpZnJoMlI3UDRFZGlPVDlrbVlG?=
 =?utf-8?B?TzdQQkZCMkt3Rjg2Yy9vZDhLRnJENUZycGlVMVZ2bDlmVXc0ZTdMbERYemlv?=
 =?utf-8?B?MUVqU3dDWjFPSUx4eU5mNko5QWlqVjBmQ29raHNmRGVWVnVNM3kzVFFPYzZa?=
 =?utf-8?B?aGFuQThPM05LRXlpYzNRaFNQRU8vajMyZVlyWFBWclU2U2kraHZwQXRXTDRs?=
 =?utf-8?B?T3paVFdSZWlib3JtYlBFZCtDaDg3VUVicVhBQnRqUkRUaWE2YkM2RE1SWXNK?=
 =?utf-8?B?dDBHd1hVM3hQQmNJcFhwM1IvWUpjc0pHenBVRkZqTmhnMTNRekVKSzVTTEVx?=
 =?utf-8?B?cHNHTFBwb2IwdzVxQzkyTzdpcVpJQkNqWnIxRDhxVStlYS9YNGdCeXJSaldH?=
 =?utf-8?B?WWs4cHhabjdVZVc3Z2kxeHZqYXoxZHlWdGFFb3FDRkxVMnF5NkxyVVB3SGN2?=
 =?utf-8?B?L2g3MEt6ZHEwdUdPYTJSRW5FVXNEa2xSb2hSL3V1S0hRTFg1alBhcnFNRno0?=
 =?utf-8?B?K0ZBQjNBUTJoNzZnQTJTVFFJK3M2WCtiWEZIUzgxRGhXUU5ZTEVIdWt1WGNL?=
 =?utf-8?B?MTNGTm1JOEI1M0lDcEdIc1NkUGI2TDFsTmtFQ0hZTXlRYkwrb0IwczFPdmw5?=
 =?utf-8?B?UU1GQ1JVZG9DandPTEhYS3JwY0hXbDgydWEya0w5eVhvMWE0a1ZURHlGZmhx?=
 =?utf-8?B?QUVOYitKaTVlYTZxNmN4SjcwQkNEeEVvVnhsM2JVcVF0WFNiVTZzT1RmWld4?=
 =?utf-8?B?VVltUUN0ZUdIbTA5d1lxTUtMV21VcFZKR0R2UVV5eVRMVUFZem9HN2YrSS9x?=
 =?utf-8?B?dFdaVkhQWjlxa1hrZXkvWmdvZjNJRS92NUdLWGVqeUZvdUdGNTcvRUtSdDVn?=
 =?utf-8?B?STRvTWNKdFMzQjg2Qm1MOHJUN2w3VWdiQ3phSkI5TlB0NVYvN2FzcEhzRy9G?=
 =?utf-8?B?YVZwQlBDRTNJVm03akg4UytWRmthWVJzbGduZ1cyUGlWRWs3RUljUEFJZnBk?=
 =?utf-8?Q?twr4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e128cdd-aa16-4b0a-2c2a-08db39f1ce6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 18:31:31.5784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o+cXF4oJHVMLzU9fSLbOVnggEznHsF2PB5unauf/nWOtL5WHziDH4EgcIn5Wt/YgROY1wiC76+ZEhlek9a5uKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6747
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiA0LzQvMjMgMDM6MjcsIFhpbiBMaSB3cm90ZToNCj4gPiAtLS0gYS9hcmNoL3g4Ni9lbnRy
eS9lbnRyeV82NC5TDQo+ID4gKysrIGIvYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUw0KPiA+IEBA
IC0yOTksNyArMjk5LDEyIEBAIFNZTV9DT0RFX1NUQVJUX05PQUxJR04ocmV0X2Zyb21fZm9yaykN
Cj4gPiAgCVVOV0lORF9ISU5UX1JFR1MNCj4gPiAgCW1vdnEJJXJzcCwgJXJkaQ0KPiA+ICAJY2Fs
bAlzeXNjYWxsX2V4aXRfdG9fdXNlcl9tb2RlCS8qIHJldHVybnMgd2l0aCBJUlFzIGRpc2FibGVk
ICovDQo+ID4gKyNpZmRlZiBDT05GSUdfWDg2X0ZSRUQNCj4gPiArCUFMVEVSTkFUSVZFICJqbXAg
c3dhcGdzX3Jlc3RvcmVfcmVnc19hbmRfcmV0dXJuX3RvX3VzZXJtb2RlIiwgXA0KPiA+ICsJCSAg
ICAiam1wIGZyZWRfZXhpdF91c2VyIiwgWDg2X0ZFQVRVUkVfRlJFRCAjZWxzZQ0KPiA+ICAJam1w
CXN3YXBnc19yZXN0b3JlX3JlZ3NfYW5kX3JldHVybl90b191c2VybW9kZQ0KPiA+ICsjZW5kaWYN
Cj4gDQo+IERvZXMgdGhlICNpZmRlZiByZWFsbHkgYnV5IHVzIGFueXRoaW5nIGhlcmU/DQo+IA0K
PiBJIGd1ZXNzIGl0IG1pZ2h0IHNhdmUgYSAqVElOWSogYW1vdW50IG9mIHRpbWUgYXQgYWx0ZXJu
YXRpdmUgcHJvY2Vzc2luZyB0aW1lLiAgQnV0DQo+IHRoYXQgZG9lc24ndCByZWFsbHkgc2VlbSB3
b3J0aCBpdC4NCg0KWW91IGhhdmUga2VwdCBzYXlpbmcgbm90IHRvIHVzZSAjaWZkZWYgaWYgcG9z
c2libGUsIGFuZCBJIHRyaWVkIHRvIGdldCBpZiBvZiB0aGVtLg0KDQpTb21laG93IEkgZW5kZWQg
dXAgd2l0aCBvdmVybG9va2luZyB0aGlzIF91bm5lY2Vzc2FyeV8gY2hhbmdlLCB3aWxsIHJlbW92
ZS4NCg0KVGhhbmtzIQ0KICBYaW4NCg0KDQoNCg0KDQo=
