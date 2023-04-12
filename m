Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D296DF1BE
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 12:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjDLKNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 06:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDLKM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 06:12:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D999795;
        Wed, 12 Apr 2023 03:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681294376; x=1712830376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Sg6ZkD/GHtVdoPvpE2xXpykYqqMkF5HwDkeGbR6YmNo=;
  b=l5hYp8Ragh7DnI1R60rf2ouXr2zsllqTLgVe5Htv4RXfh1gBW7Hzyaub
   aF/fmiNnLTRENMD491AN/OcOjyaZadbwL/IiX5vTZ6DAmuIUesE24DY1X
   ABkZVbFR4A06Dh9Fz3eRMvCleaCKTjeTLt5hcjdX+bIlXqzawTZzibSxa
   9Z9U8HO1sCHRO/S1rR2gXkRTJ5QJcGta/AYTIEH8YYRr8NCUFC09eO/Ly
   AR3KxokjbRXyJ3qDQZji/HqkcAoPD/2+NJhZ9cV+6lvjjCUaPe+kJD5Bj
   FgL3kq3JrmpBDDEWIRxf4eLvtH8A4wq1OqxIMzranqvNLFRs7NBI3ijSr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327965061"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="327965061"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 03:12:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="721517310"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="721517310"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2023 03:12:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:12:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 03:12:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 03:12:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 03:12:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=an03VJ+TvESTO4FATI7LBaB3Ym0jbEsDmUqbdaiW5RHApiWUMSLKWMc0kvEhDdGmDree5sURPVLffL5yLFsUMpwE/TGrVdvdh4mmOr0mvkBPLk8VW9s8jzqF/XrMJuAelVHigYlZkrJE7+r+j5O5mVSicmm6WWWcEUyZOhplewVZkJBFktz+N4BiRvpc44TqcVbWkUyJYiOxmSjF4plEKY+cXMSnDGpOYUgCBVN6Baq4sVWSbxmfTkblHx/XEblbt5HhbmBUI+jd1Qkr8+yHkecO9pRCv5kloExDdp7OZ3aIqHrQu6CQfmiUSrSgb59H5m+vPdthrZ8QPl347iIzdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sg6ZkD/GHtVdoPvpE2xXpykYqqMkF5HwDkeGbR6YmNo=;
 b=A6RQIGwU+qfP3wRUvY3Z+BBqtUymgUjUUNkSEugJLQIHc6SSHsR5WxjS/91H5i9cCyvrwVG5YfYsUlWuTWe/bsTfG2lEEowGuHIBh6Uwg0ZpNsRPILoPvaN6zjNmpuE+FG4igeRd8DrF9TlJBHMBZu2vwSy6x1Zir6pos3vIoghUZ+UuNzIC1MIMrmMRGSoWRh0sVyRL8P/di7h8iTnCiW0zB8L3Q8oR8IpiyUThpKtLsRvIELPw/CgBd24f/aIeTghqtfA1djIQkQ3gv7js1fOTKBnM4npUldFRCiuIps7+913m4ci/476p4NLV5MPnuxVNcY6gNuZOuGSaquMASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 10:12:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 10:12:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Topic: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
Thread-Index: AQHZZ1neYlqkq4ONyEOC8NUatF9pta8cityAgAD5CACAABXYgIABDueAgAjXVQA=
Date:   Wed, 12 Apr 2023 10:12:52 +0000
Message-ID: <6f7611300b3d2dfacd1399ccf4a2fdc1dd50b20f.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <20230405005911.423699-2-seanjc@google.com>
         <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
         <ZC4j37H2+2945xxb@google.com>
         <2cedc5ca5e1d126a0abf3b651c6fef1a8970fcfd.camel@intel.com>
         <ZC8J2J9Js7Z99k6/@google.com>
In-Reply-To: <ZC8J2J9Js7Z99k6/@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7546:EE_
x-ms-office365-filtering-correlation-id: df05df28-c938-41ce-a799-08db3b3e7a4d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jD7VbuesLALXvzGmbPnFhVUg69JQ91eI84itX6ZjQbN7AYOK40giBN56Zg7iy2TE2iGK6vIbLBFLZPtMQlhhoz6xcu6JslXm1oIZc751OyngdUkcXZch70dsWFN16jm11XwqND4oWircm/Pd+ZizHiDRZllNQww+nRX2SRRSaqNCSMMel8LuVngvf0I4VK6M9CvNrdGUgTM4+T6hhQZgvdOE/sdhCFbslrHPpEtnVshX7to7oKWicLWO0RcYtccn/mK4WDAFJ4QvxVqCcO+8B0iPURvf48XbPKYyXQdzNABCmIH63pmkKF/1mC2GqMDLFk2yR7mgKpbFcVAeyBnEqfNr2BzQ0aknlrLqvg5O0dZ4V/DLaGGlvDhk7+kC8sJNUBzWXrqitHSE6i6tP8eRqp+Qb1HhO1nxZ1HwKRBZmTuYL8Qo84H+nx8ZdumucLdPx/873eMVfghJkL+ytNk3Ipbszf9Wj9+oOz9xL9XZg7o23vxIQteXi9rJA6jVUo18vyjqFD3+DM9g1YTxyJHjo1w85KZ9S89aTnVSFppFHkIFyusvd2AamJGS5B0duUBsASNIzKjEpzzlI1TlS0v9vkmmyZRxGVXC+kBiQt9igPoLLKG9gfqt6KrVYO9L4Vb1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199021)(54906003)(478600001)(2616005)(122000001)(6512007)(26005)(83380400001)(6506007)(71200400001)(6486002)(82960400001)(41300700001)(64756008)(316002)(66556008)(66476007)(66446008)(6916009)(4326008)(186003)(66946007)(91956017)(76116006)(38100700002)(5660300002)(2906002)(36756003)(38070700005)(86362001)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXBwcFR5NHdWWm9hM3pTOXRoc1VLaXNVVG01eEFhR0s4MlhDNTd5N2w0L2h5?=
 =?utf-8?B?aVlmcXVMdk9pczdlbGxIM3dlRVVqVjRESncvSzZiNlhuRXlaa2k5dEpHcFlG?=
 =?utf-8?B?VCtLWkVIdnh5Y1ZjS1pvR2tDTjc2QkVMRTBLRUtkQzRpT2w1ME5SSS9MUGhS?=
 =?utf-8?B?ODRCVnNUN1NlUS96NHR2OFVmVXh6dnpFcWNNTXZMQVpnQzd0UFlaOXFPanox?=
 =?utf-8?B?MkF1Nk5iL3lCRldzeExCODMyV0lhNHNiS0ViK3Q0YjgxM0w0eldYQVVzK0U0?=
 =?utf-8?B?SnVjb0V2emlQRXlzQnl3OHdQYzh6bTNiT2d3L3VvZXpIR0o0ckJBbkdBcDE0?=
 =?utf-8?B?dFI5enZwd3BxcTNyeStHcGQ4aExPMi9HTlh4OGFaZVJ5eGh2c1ZCdFhkbStn?=
 =?utf-8?B?aldXNHZaZUVlZ1hDOGJHZHN0bk1iay9GdnpEczdpZlBTMHA1S1hzdktia0NL?=
 =?utf-8?B?by81ek5EQXBrN292cHpXQ2MwRmxPWG0vdy9LNkxDWmJzL2VoY3hQcW1GY2Np?=
 =?utf-8?B?eE9CaDdFV3FMNlFQcm9IYm13anBpQ28rOUpjWTRjNlI1T2Rvb0kwdnJVcDcy?=
 =?utf-8?B?RTcyMVBQeXcyeWIydTVpVE91bzlPY1h6bm5ocnpEUXc3QkkxWm9OYmxHVnRt?=
 =?utf-8?B?Z2JaemJYU0M1TElnZVdpbldaNXFidkRuVDhFc0NTNzdpVWVxWi9abWR4dXE1?=
 =?utf-8?B?Q3ZDcHFvUWd3ekxHQU54ZzQvZkgzRHg5MlJZSzJoZS9yUjZjVURnU3RuQWhL?=
 =?utf-8?B?TlpDd2w3NGpKb0VOOHJqUlVYclNoOHJVeU56aHVFakl4d3JwOFVZdUxJOFdp?=
 =?utf-8?B?NUZ5WUczV0NiSjNZTnRnNGZKODNqUktCemZqcFk0M0RYODYwNWJZWVQwNGhY?=
 =?utf-8?B?UXB3ZW5NRzZPNmtaK25mTFJxREFsT05oSHZjc3Z4aXgzN1F6Q2FQUjRVRHl0?=
 =?utf-8?B?dHV2U2lwdUQvRmJscUtRTmZRWGRDY0RHVnNjUkFOOWZENDgvdTNESldmOFll?=
 =?utf-8?B?NEZlOUREVlY3VmhoSDJzbW9XOXU4elEwTDVoSDdxVVRZTHN3Tkk4Q1E5VERy?=
 =?utf-8?B?T2FHOWIwbTNvODRTdXAyWlVHdjcvNU9RTG15SmkzbzFKMDlUTEZlNkJ2YWNP?=
 =?utf-8?B?c2E5cFlCOENIcU9UZ1pZWDJQSVl0WUFmWEtTSCtVSm5YUDRHT25oWm1DTnNN?=
 =?utf-8?B?M3VjRjYrWEJSNldHTXFyZElod1NFaUlrZElLTXB2S0FEd3hHVVZJQ3FvcnhI?=
 =?utf-8?B?UE1ycVowZERGUm0rbStZNkxPa0hZOHRDc3pFZHN1aUpzQWh0clAycUgwOHdl?=
 =?utf-8?B?NkpGcXk4NHFiQUtkL083VDBIYXREVTk5VkJCZE91aHNjK0pXSWZUS1ZQdmNX?=
 =?utf-8?B?NWp3TDQ1N3JjYndJNWlKWkJhT2FIWDM2T2dEWkU0Yk1sbGhCYTFxeVA5NU1C?=
 =?utf-8?B?QU1CVFlaZ1RFTm1iZ0dCMFNFMi9uYTk2YW1UU3VWY2U5b1VpYlZZUHNsSEpz?=
 =?utf-8?B?UnhzRWpYSDNhUnlZYnVLV1owZjZtdWRZa2ZaaS9JT3NrWlAwYmNnckdKeDlz?=
 =?utf-8?B?bG51UktHWFJybXdKREdKeGtTaVFCZjRORGdmSERsMWpQVG45U2JaQ05DR1pW?=
 =?utf-8?B?VHFWMHVWVWpIN0dUaFM2b0lTWHhyMGZVMFdnMjRObHFYSitmY0p0N3BBSmdW?=
 =?utf-8?B?RDJnSWI0aFBtOEx6b2JIcklJazlNN00rc2pDVGFISWNyQTZGWDQ3OEJjSnMr?=
 =?utf-8?B?UUd0NDluVHVKeVEwWkVYVGFPYTgxaXBpekxIY1hhTllYaGM0Qkl5OGFrUGgr?=
 =?utf-8?B?R0FFZVk5NldEeFRYV2Q0ZUt4YnVJMGdPcE5udEVicGluT0ZOeEhYM0FWUmdT?=
 =?utf-8?B?YkFwK3ZIektFeGRkemN4QTZlZFlkMExjakY4cER0N05GeDFZNHp6UHpvSThp?=
 =?utf-8?B?bVNFR2NFQ1kwNFV0YXVzWi9sUlpMeTlHM0F3TUF1K3ZVN3V0dk44MTg5T2Vz?=
 =?utf-8?B?K1psallxMG4xejNneXRPTHdudW56VjJnRnlCZWU0YnBRYVYvUEtWWCtOSTF4?=
 =?utf-8?B?Smc0WTY0ZC80UXIxeTJiekpCcXFYcUE5ek5kcW11WXQwMVE3dmtNbVRPcThj?=
 =?utf-8?Q?JsudeUxOADb19Po8DF5yBgcRq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E8C4E20035780429F3DB8E937B5B439@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df05df28-c938-41ce-a799-08db3b3e7a4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 10:12:52.8355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LnzMKlOpglF30t8YdPVCXbe8scp08lxXQOQ7zcu32fuy2TcL0vTCFkd1BTPU/J6lnC8L0VB7hvKMY8PyjoASZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7546
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA0LTA2IGF0IDEyOjEyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAwNiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBX
ZWQsIDIwMjMtMDQtMDUgYXQgMTg6NDQgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBPbiBXZWQsIEFwciAwNSwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
T24gVHVlLCAyMDIzLTA0LTA0IGF0IDE3OjU5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiA+IEV4cGxpY2l0bHkgY2hlY2sgdGhlIHZDUFUncyBzdXBwb3J0ZWQgWENS
MCB3aGVuIGRldGVybWluaW5nIHdoZXRoZXIgb3Igbm90DQo+ID4gPiA+ID4gdGhlIFhGUk0gZm9y
IEVDUkVBVEUgaXMgdmFsaWQuICBDaGVja2luZyBDUFVJRCB3b3JrcyBiZWNhdXNlIEtWTSB1cGRh
dGVzDQo+ID4gPiA+ID4gZ3Vlc3QgQ1BVSUQuMHgxMi4xIHRvIHJlc3RyaWN0IHRoZSBsZWFmIHRv
IGEgc3Vic2V0IG9mIHRoZSBndWVzdCdzIGFsbG93ZWQNCj4gPiA+ID4gPiBYQ1IwLCBidXQgdGhh
dCBpcyByYXRoZXIgc3VidGxlIGFuZCBLVk0gc2hvdWxkIG5vdCBtb2RpZnkgZ3Vlc3QgQ1BVSUQN
Cj4gPiA+ID4gPiBleGNlcHQgZm9yIG1vZGVsaW5nIHRydWUgcnVudGltZSBiZWhhdmlvciAoYWxs
b3dlZCBYRlJNIGlzIG1vc3QgZGVmaW5pdGVseQ0KPiA+ID4gPiA+IG5vdCAicnVudGltZSIgYmVo
YXZpb3IpLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4gPiA+IC0tLQ0KPiA+ID4gPiA+ICBh
cmNoL3g4Ni9rdm0vdm14L3NneC5jIHwgMyArKy0NCj4gPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3NneC5jIGIvYXJjaC94ODYva3ZtL3ZteC9zZ3gu
Yw0KPiA+ID4gPiA+IGluZGV4IGFhNTNjOTgwMzRiZi4uMzYyYTMxYjE5YjBlIDEwMDY0NA0KPiA+
ID4gPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvc2d4LmMNCj4gPiA+ID4gPiArKysgYi9hcmNo
L3g4Ni9rdm0vdm14L3NneC5jDQo+ID4gPiA+ID4gQEAgLTE3NSw3ICsxNzUsOCBAQCBzdGF0aWMg
aW50IF9faGFuZGxlX2VuY2xzX2VjcmVhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+ID4g
PiA+ICAJICAgICh1MzIpYXR0cmlidXRlcyAmIH5zZ3hfMTJfMS0+ZWF4IHx8DQo+ID4gPiA+ID4g
IAkgICAgKHUzMikoYXR0cmlidXRlcyA+PiAzMikgJiB+c2d4XzEyXzEtPmVieCB8fA0KPiA+ID4g
PiA+ICAJICAgICh1MzIpeGZybSAmIH5zZ3hfMTJfMS0+ZWN4IHx8DQo+ID4gPiA+ID4gLQkgICAg
KHUzMikoeGZybSA+PiAzMikgJiB+c2d4XzEyXzEtPmVkeCkgew0KPiA+ID4gPiA+ICsJICAgICh1
MzIpKHhmcm0gPj4gMzIpICYgfnNneF8xMl8xLT5lZHggfHwNCj4gPiA+ID4gPiArCSAgICB4ZnJt
ICYgfnZjcHUtPmFyY2guZ3Vlc3Rfc3VwcG9ydGVkX3hjcjApIHsNCj4gPiA+ID4gDQo+ID4gPiA+
IFBlcmhhcHMgdGhpcyBjaGFuZ2UgaXMgbmVlZGVkIGV2ZW4gd2l0aG91dCBwYXRjaCAyPw0KPiA+
ID4gPiANCj4gPiA+ID4gVGhpcyBpcyBiZWNhdXNlIHdoZW4gQ1BVSUQgMHhEIGRvZXNuJ3QgZXhp
c3QsIGd1ZXN0X3N1cHBvcnRlZF94Y3IwIGlzIDAuICBCdXQNCj4gPiA+ID4gd2hlbiBDUFVJRCAw
eEQgZG9lc24ndCBleGlzdCwgSUlVQyBjdXJyZW50bHkgS1ZNIGRvZXNuJ3QgY2xlYXIgU0dYIGlu
IENQVUlELCBhbmQNCj4gPiA+ID4gc2d4XzEyXzEtPmVjeCBpcyBhbHdheXMgc2V0IHRvIDB4My4N
Cj4gPiA+IA0KPiA+ID4gSHJtLCB0aGF0J3MgYSBidWcgaW4gdGhpcyBwYXRjaC4gIERyYXQuICBN
b3JlIGJlbG93Lg0KPiA+ID4gDQo+ID4gPiA+IF9faGFuZGxlX2VuY2xzX2VyZWF0ZSgpIGRvZXNu
J3QgY2hlY2sgQ1BVSUQgMHhEIGVpdGhlciwgc28gdy9vIGFib3ZlIGV4cGxpY2l0DQo+ID4gPiA+
IGNoZWNrIHhmcm0gYWdhaW5zdCBndWVzdF9zdXBwb3J0ZWRfeGNyMCwgaXQgc2VlbXMgZ3Vlc3Qg
Y2FuIHN1Y2Nlc3NmdWxseSBydW4NCj4gPiA+ID4gRUNSRUFURSB3aGVuIGl0IGRvZXNuJ3QgaGF2
ZSBDUFVJRCAweEQ/DQo+ID4gPiANCj4gPiA+IEVDUkVBVEUgZG9lc24ndCBoYXZlIGEgc3RyaWN0
IGRlcGVuZGVuY3kgb24gQ1BVSUQgMHhEIG9yIFhTQVZFLiAgVGhpcyBleGFjdCBzY2VuYXJpbw0K
PiA+ID4gaXMgY2FsbGVkIG91dCBpbiB0aGUgU0RNOg0KPiA+ID4gDQo+ID4gPiAgIExlZ2FsIHZh
bHVlcyBmb3IgU0VDUy5BVFRSSUJVVEVTLlhGUk0gY29uZm9ybSB0byB0aGVzZSByZXF1aXJlbWVu
dHM6DQo+ID4gPiAgICAgKiBYRlJNWzE6MF0gbXVzdCBiZSBzZXQgdG8gMHgzLg0KPiA+ID4gICAg
ICogSWYgdGhlIHByb2Nlc3NvciBkb2VzIHN1cHBvcnQgWFNBVkUsIFhGUk0gbXVzdCBjb250YWlu
IGEgdmFsdWUgdGhhdCB3b3VsZA0KPiA+ID4gICAgICAgYmUgbGVnYWwgaWYgbG9hZGVkIGludG8g
WENSMC4NCj4gPiA+ICAgICAqIElmIHRoZSBwcm9jZXNzb3IgZG9lcyBub3Qgc3VwcG9ydCBYU0FW
RSwgb3IgaWYgdGhlIHN5c3RlbSBzb2Z0d2FyZSBoYXMgbm90DQo+ID4gPiAgICAgICBlbmFibGVk
IFhTQVZFLCB0aGVuIFhGUk1bNjM6Ml0gbXVzdCBiZSB6ZXJvLg0KPiA+ID4gDQo+ID4gPiBTbyB0
aGUgYWJvdmUgbmVlZHMgdG8gYmUgZWl0aGVyDQo+ID4gPiANCj4gPiA+IAl4ZnJtICYgfih2Y3B1
LT5hcmNoLmd1ZXN0X3N1cHBvcnRlZF94Y3IwIHwgWEZFQVRVUkVfTUFTS19GUFNTRSkNCj4gPiA+
IA0KPiA+ID4gb3INCj4gPiA+IA0KPiA+ID4gCSh4ZnJtICYgflhGRUFUVVJFX01BU0tfRlBTU0Ug
JiB+dmNwdS0+YXJjaC5ndWVzdF9zdXBwb3J0ZWRfeGNyMCkNCj4gPiA+IA0KPiA+ID4gDQo+ID4g
PiBJIHRoaW5rIEkgcHJlZmVyIHRoZSBmaXJzdCBvbmUgYXMgSSBmaW5kIGl0IHNsaWdodGx5IG1v
cmUgb2J2aW91cyB0aGF0IEZQK1NTRSBhcmUNCj4gPiA+IGFsbG93ZWQgaW4gYWRkaXRpb24gdG8g
dGhlIFhDUjAgYml0cy4NCj4gPiANCj4gPiBUaGUgYWJvdmUgY2hlY2sgZG9lc24ndCB2ZXJpZnkg
eGZybSBpcyBhIHN1cGVyIHNldCBvZiAweDMuICBJIHRoaW5rIHdlIHZlcmlmeQ0KPiA+IHRoYXQg
cGVyIFNETToNCj4gDQo+IE9vb2gsIHJpZ2h0LiAgSXQncyBub3QgdGhhdCBGUCtTU0UgYXJlIGFs
d2F5cyBhbGxvd2VkLCBpdCdzIHRoYXQgRlArU1NFIG11c3QgYWx3YXlzDQo+IGJlIF9zZXRfLiAg
U28gdGhpcz8NCj4gDQo+IAkJeGZybSAmIH4odmNwdS0+YXJjaC5ndWVzdF9zdXBwb3J0ZWRfeGNy
MCB8IFhGRUFUVVJFX01BU0tfRlBTU0UpIHx8DQo+IAkJKHhmcm0gJiBYRkVBVFVSRV9NQVNLX0ZQ
U1NFKSAhPSBYRkVBVFVSRV9NQVNLX0ZQU1NFDQoNCkxvb2tzIGdvb2QuDQoNCkknbGwgdHJ5IHRv
IGdldCBzb21lIHRlc3QgZG9uZSB3aXRoIHRoaXMgY29kZSBjaGFuZ2UuDQoNCj4gDQo+ID4gMzku
Ny4zIFByb2Nlc3NvciBFeHRlbmRlZCBTdGF0ZXMgYW5kIEVOQ0xTW0VDUkVBVEVdDQo+ID4gDQo+
ID4gVGhlIEVDUkVBVEUgbGVhZiBmdW5jdGlvbiBvZiB0aGUgRU5DTFMgaW5zdHJ1Y3Rpb24gZW5m
b3JjZXMgYSBudW1iZXIgb2YNCj4gPiBjb25zaXN0ZW5jeSBjaGVja3MgZGVzY3JpYmVkIGVhcmxp
ZXIuIFRoZSBleGVjdXRpb24gb2YgRU5DTFNbRUNSRUFURV0gbGVhZg0KPiA+IGZ1bmN0aW9uIHJl
c3VsdHMgaW4gYSAjR1AoMCkgaW4gYW55IG9mIHRoZSBmb2xsb3dpbmcgY2FzZXM6DQo+ID4gICDi
gKIgU0VDUy5BVFRSSUJVVEVTLlhGUk1bMTowXSBpcyBub3QgMy4NCj4gPiAgIOKAoiBUaGUgcHJv
Y2Vzc29yIGRvZXMgbm90IHN1cHBvcnQgWFNBVkUgYW5kIGFueSBvZiB0aGUgZm9sbG93aW5nIGlz
IHRydWU6DQo+ID4gCeKAlCBTRUNTLkFUVFJJQlVURVMuWEZSTVs2MzoyXSBpcyBub3QgMC4NCj4g
PiAJ4oCUIFNFQ1MuU1NBRlJBTUVTSVpFIGlzIDAuDQo+ID4gICDigKIgVGhlIHByb2Nlc3NvciBz
dXBwb3J0cyBYU0FWRSBhbmQgYW55IG9mIHRoZSBmb2xsb3dpbmcgaXMgdHJ1ZToNCj4gPiAJ4oCU
IFhTRVRCViB3b3VsZCBmYXVsdCBvbiBhbiBhdHRlbXB0IHRvIGxvYWQgWEZSTSBpbnRvIFhDUjAu
DQo+ID4gCeKAlCBYRlJNWzYzXT0xLg0KPiA+IAnigJQgVGhlIFNTQUZSQU1FIGlzIHRvbyBzbWFs
bCB0byBob2xkIHJlcXVpcmVkLCBlbmFibGVkIHN0YXRlcyAuLi4NCj4gPiANCj4gPiANCj4gPiBB
bmQgaW4gdGhlIEVDUkVBVEUgcHNldWRvIGNvZGUsIHRoZSByZWxldmFudCBwYXJ0cyBzZWVtIHRv
IGJlOg0KPiA+IA0KPiA+IAkoKiBDaGVjayBsb3dlciAyIGJpdHMgb2YgWEZSTSBhcmUgc2V0ICop
DQo+ID4gCUlGICggKCBEUzpUTVBfU0VDUy5BVFRSSUJVVEVTLlhGUk0gQml0d2lzZUFORCAwM0gp
IOKJoCAwM0gpDQo+ID4gCQlUSEVOICNHUCgwKTsgRkk7DQo+ID4gDQo+ID4gCUlGIChYRlJNIGlz
IGlsbGVnYWwpDQo+ID4gCQlUSEVOICNHUCgwKTsgRkk7DQo+ID4gDQo+ID4gVGhlIGZpcnN0IHBh
cnQgaXMgY2xlYXIsIGJ1dCB0aGUgc2Vjb25kIHBhcnQgaXMgdmFndWUuIA0KPiA+IA0KPiA+IEkg
YW0gbm90IHN1cmUgaW4gaGFyZHdhcmUgYmVoYXZpb3VyLCB3aGV0aGVyIFhDUjAgaXMgYWN0dWFs
bHkgY2hlY2tlZCBpbg0KPiA+IEVDUkVBVEUuICBJdCdzIG1vcmUgbGlrZWx5IFhDUk8gaXMgYWN0
dWFsbHkgY2hlY2tlZCBpbiBFRU5URVIuIMKgDQo+ID4gDQo+ID4gQnV0IEkgdGhpbmsgaXQncyBq
dXN0IGZpbmUgdG8gYWxzbyBjaGVjayBhZ2FpbnN0IFhDUjAgaGVyZS4NCj4gDQo+IEVDUkVBVEUg
ZG9lc24ndCBjaGVjayBYQ1IwLCBpdCBjaGVja3MgdGhhdCBYRlJNIHJlcHJlc2VudHMgYSBsZWdh
bCBYQ1IwIHZhbHVlcw0KPiBmb3IgdGhlIHBsYXRmb3JtLCB3aGljaCBpbiBLVk0gaXMgdHJhY2tl
ZCBhcyBndWVzdF9zdXBwb3J0ZWRfeGNyMC4NCg0KWWVzIGFncmVlZC4NCg0K
