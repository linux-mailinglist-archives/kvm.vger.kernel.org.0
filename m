Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA6073EE9D
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 00:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjFZWVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjFZWVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 18:21:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6321293;
        Mon, 26 Jun 2023 15:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687818107; x=1719354107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gbSg983WsDOeAaex+U9ZeDOCjg/cR5g+sBxe9ApohsQ=;
  b=A0nMgBvFTjVfKq105mxUDNagR6Qva8je2itm/9u9f3MtTqIQ6JP1fuat
   5qfE/0XpwAVs3sQ6CFHzjRf6oBUrWjJ2ophy8AVkN/m0MkOHcJfC23qrd
   CX4fZTtSr6G/pFLcE92mIov3XKcZKbvLHeiAGvp91VGpqOXScJTaLptgi
   r15G/JhXTGtxA8Loov6o4jFJNu5VBb8qcGZ8gsE3Sbrp/A9/O+5GFSD4a
   +Nw8KVL+onE8C3yhKfglFcidDzZvUvimS5r/O/Y+Dv+AooycK50JDlgza
   NlAE8wmaDeROGJiDvtAcfhJ19XMwJG945P2Etbx2rehp/pww6K1t3imja
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="427406695"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="427406695"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 15:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="710386285"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="710386285"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 26 Jun 2023 15:21:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 15:21:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 15:21:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 15:21:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 15:21:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn/4NH+D6LgTyQ9F2IjYqwRRUXgFjLvVs+/gwtkr7QtSz4Toh0RxUuWkbb9oH/vgqh0iOn5QsugqM1Vj+0wQtuMl1jpl56j/BJZHseDa1wYsnZx1zLg2tNFG5ehx1tz+VN8zaG0QtrIFI/enpiPqtwgBhp31OxuWVBxkWN9jN/rrNAkOdKy+LNpQDapV6c6fDWovt7h1sJKc+eEN9t+9sFzzHOEGYaW2rOMH7i3uLG0X6cEgwG5v0FB+FxbP1EXFu7NdySEj9rwD99yhulIZNxyz7UYl6kE0HPGq+JexIERitDUsU42A7C7gzYA2lsqhq72ulRHz/yZthS/Yl4F+cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbSg983WsDOeAaex+U9ZeDOCjg/cR5g+sBxe9ApohsQ=;
 b=US5Ms2DNpX0YAI6axOQyHdIbvVJqpCdhlP8/I49VCaihNp/Bqb9Qk/krNytbh+uvm64afgyd3NStcpx/zID2fuxaWjcyzKLI7Jb97Q9VnGOo4AiNZHdsye8P/JTJep6s1TDUpi4MxbDy3CWlqZ18NBfhToJVItywvWsuri3ccABdLAmNAKP0lJoUgM24uD8pmsEy0kIuTmk1ipczlf3MTegQ2kICbJt9/koSroklTILNsd7GWjltq7U2bY87w51j3IaFG/CCzeqhzIlzMflLjzivg5Qs2lo9FJsD7y19xekGg/y4XKQ/KmhQbiRn+lc2QhGl67KDNkNnZaDSfb3dSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6832.namprd11.prod.outlook.com (2603:10b6:510:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Mon, 26 Jun
 2023 22:21:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Mon, 26 Jun 2023
 22:21:42 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mizhang@google.com" <mizhang@google.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Xu, Yilun" <yilun.xu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "bgardon@google.com" <bgardon@google.com>
Subject: Re: [PATCH v2 4/6] KVM: Documentation: Add the missing description
 for tdp_mmu_root_count into kvm_mmu_page
Thread-Topic: [PATCH v2 4/6] KVM: Documentation: Add the missing description
 for tdp_mmu_root_count into kvm_mmu_page
Thread-Index: AQHZqFrqeEq9I9TUOky20uDJkvmD8K+dqHGA
Date:   Mon, 26 Jun 2023 22:21:42 +0000
Message-ID: <5a6fb38bb223516bdf3da0378dbfa89be8b62f6f.camel@intel.com>
References: <20230626182016.4127366-1-mizhang@google.com>
         <20230626182016.4127366-5-mizhang@google.com>
In-Reply-To: <20230626182016.4127366-5-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6832:EE_
x-ms-office365-filtering-correlation-id: 9dda60c9-f9fb-4bdf-e2f6-08db7693b7eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3C2izvGCozVBnfwYWQqO7isAY5cA+WflBEvoPQBpSdSEkEEpf0SBhy2d24m8zgYHpYjIzfgzVN96yeSmWcmVklgoQe1xWr73H9bjuVyABIbJLbxRQC1Rz7eiDeVrP/XzRPW7ELcZJSn34gyR/l9IVPJY/17eMjbVE4zwkaBzQOkuW4D/CU/L31EHU9m6qQkAatLfsctNuHVrv+9LMqDLj4eLMn90WEfq2DpOPskMIKCtNI4t/WC0i+DFAAZVSeDMM7vy5KsgXLe6exRIq1r0ZbuPVnMj2Zs4XszJ+5N3ThFtdukb/zTJb56WBqll4SoHy5dbLo9reczVf+Ww06axqNCpLIgDejM2Gvmk/TqRj/pSYx0IYx8LrMyeU6SzDdYX0Eiuw5uVqnq74TsXWdTp8A//i2t+POSoT+c5JoH+h+qW+KmaVMj6X5KC2on0MRwu+Iv9DsX/zlaW3WRT0umk46qGvCOIkJnu9MUTtAHBfyt1giAqnP/7RzSxghbUzdCvRnPOpeY0zuoKduTvM/ETJcSh6y1RLmcZb7QZagOqUxgmd5NMgQhYZrmBPtJBOyriYpnKW9JEjXiYW5cTWgaMnZG655x5ihPDfcE3r0+3rjbJ1nUsUjQ1Q9O7IB+GEeq1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(66556008)(36756003)(6506007)(6486002)(2616005)(54906003)(110136005)(478600001)(83380400001)(66446008)(26005)(186003)(71200400001)(2906002)(5660300002)(7416002)(122000001)(316002)(64756008)(82960400001)(66946007)(76116006)(91956017)(38100700002)(8936002)(8676002)(41300700001)(86362001)(4326008)(66476007)(38070700005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDkwMGROdHBIZ2FFNFU3SWxzRU9MZ21QbWREWGw0YllTcGtleTh0TUNaamJw?=
 =?utf-8?B?dWZqdnVUMmJqei95QytxTU5IRy9GUU9LK1liUUgxQjVvUFBMTHVnM3JMSzdQ?=
 =?utf-8?B?S2k0UVl4dXJQSURaNzQ2dzRmdk1uRmtwVDFUVlVGb2Nhdko0QUtVby9vQkpG?=
 =?utf-8?B?WEVUbjFmN2VTaDY2bzc2TjZSUVduY0RUZUVoZWpQUTM4NmgwR3JNNDZYMVNX?=
 =?utf-8?B?Z1I2cUIvMll6N2pqSFRuQlRWOGdwZGVMM1Q0R0h6dFN5Qy8xQWkwRWVVUWJm?=
 =?utf-8?B?Y29HQkY4WEpSR0JLRzZXTTVwbmc2aXY4QzBaWTZYdm9FdStMbDNwczE5M0x0?=
 =?utf-8?B?QTBLdVdlUlRCK21FcEk0cnF0TzdZd0g1TWVaNUE3NGROY0xrbTNhTElWMkhs?=
 =?utf-8?B?N2lkbVlUS1dST25yQ0R1bWNKOVlHVENDQkk1Z2xoZDJsbk94VzdIYjMzYTI3?=
 =?utf-8?B?dVBWTUUyL0g5RkRxbmRjYVNGRVdMOHhVR0dNSkk5VVAxa2YxcmtHcXVGZlNQ?=
 =?utf-8?B?bHUzM0RiWitlMEh6cVg0SUtZMjJJR3R5UUlxUSt5K2lTTGwzR2JtS3BUYzRH?=
 =?utf-8?B?bWp0RlUxTEdzNTNRTXNra2xiWlpYY3hnNzRuSTNtQ2UwLzN0akZLaVdsRVdq?=
 =?utf-8?B?bFoyOG5yUjlUb29nY0Vxc2I4UWRJNUtCTlIvRFRuTjloS3FFVTM0TXg3bEt6?=
 =?utf-8?B?SmtFbFdIdDdrelVPVkY0RktZaWxZL3lPRzVhZ3MvZ1ZXSjRoamxDUXR4em4x?=
 =?utf-8?B?TUVFL1ZUV2xFY0I1dzVzc1ZqMndRVDgwYlpCWVlLbTY1MWlkS0o1RkFTWlMw?=
 =?utf-8?B?VFFlN2FPcDZvY2I1Wk9pa3pVN2NIYWQvOEpWQlZuUUNHTno4VkNXRFRrbUVx?=
 =?utf-8?B?K2lNRmFMbnAxL2RlM05DcnhHRnV3ZUVnVGZjUkR4Z1ZVSVdrWFhLTjhJMEk2?=
 =?utf-8?B?NXRVQmhBL1c5SWFLZVpQWVBhbDdRV1pIbWVJRmtkUEowTFJMejE0bDZ0MEZu?=
 =?utf-8?B?S05QYmJwU0JuN3hkbkpyaDdrRWJJaHBDVWZoTzVSWHJmcjBuek1rM3NUOUw3?=
 =?utf-8?B?dk5zQmUwSmo5Z1MvN0paZ2tqY2xaYjB5MW42VlB2UTZjS3puNGwwT2NIcEZv?=
 =?utf-8?B?M3llcTRBSlB4dmJYbzBGTTZtb2dURnRuVFJhampxNEVsSTM2MnZKVVgxSGg0?=
 =?utf-8?B?ZTZ2V2tPd2RxSzhpNXd4Q0Z2OU1BZW9zMGdhU3I1bWZJbzl1TWpETWJGbVpu?=
 =?utf-8?B?WDhkRVRaT1BadkF1aEFNdndwMGZNQ3hpU2FSaUZ1dGhTQ3NRTENoWlFBL2Ux?=
 =?utf-8?B?RkJhTEcyWnhNeXFiNnQ3RGJtZ3ZSdUN1SCs3UU5uMFZhUnM1cUUrbk1ETSsz?=
 =?utf-8?B?ZnhYanljR2pTY1IrNVJFTzd1dEw3SC9ibWplUndxb1BOVXhzQmdyNXR5TGEx?=
 =?utf-8?B?NURldVhLelRwejdVcDhPK1dZbGFUOFVVNjhxV3cxczBBbUt0K3pQWVd6TWpT?=
 =?utf-8?B?Tnl5ZzdZeElLZWtKcU5hS0V2WjhJaEg2UmlEMzRHeDUxSDdCQXplZ0VHVjdL?=
 =?utf-8?B?UmtBWUNuYVIyYVdjOUt0LzhwUnVxVGJIc08yNDBWNU00M2dXNzlrL3lkd0Yw?=
 =?utf-8?B?cjZncTVpM0swT3A5VDcwTTRyOTFBd2p6cllOV1FFTFRaS2t1UVhnT29NVm5M?=
 =?utf-8?B?b1IzbHVvOERRMm8xMWRoT3QveVVrMmtaQUVCTU0zVldEelkxUUFJYytpVHhG?=
 =?utf-8?B?SHRYOXo4cmZjVGZLRzFqYUhPUGFrSjNFY0FwdVhYbWxqRVZLTmtaa1pUeFZ0?=
 =?utf-8?B?YVpSNFJPem9sb2hFeG9UVDdOSkZwU1dxRjlJVVlXR0NUYU9qV3l6SzVxQXVr?=
 =?utf-8?B?RmRTY2JVaDNsUzFOMk9wYkRCQWk5dlAxRlZRWlZUdHNvY2ZPUjBFdDFSSTZS?=
 =?utf-8?B?cGN4WlIvdkJHOE9aMmd6bWlTc3FNN2swSXZlTGtIcUkvTlZtcHpaWkNsWUw1?=
 =?utf-8?B?enpxWlFmK0ZRSGRHTjJBMFpVdCtGZldTUHJ2S000endKcHgvZDdlcURpajNr?=
 =?utf-8?B?WlZ6MVlIRkg0SHV2L2hUcmNrakFxQ0VmWFhoUlpheE9HZTRVOHFZVXp2R1I2?=
 =?utf-8?Q?BIayDAC6ZiwSPglFxxk9OqG6Y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEEB479E73940647B48D646AB85999CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dda60c9-f9fb-4bdf-e2f6-08db7693b7eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 22:21:42.0826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GmOj9LUUGlCZ/gvDUuqvPGFtSxXhqTYXoohScY7h+tr1a98G9e3zVCJAKbJXexX7NW0wwIOJ1JXpd/y+rZ/Iyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6832
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

T24gTW9uLCAyMDIzLTA2LTI2IGF0IDE4OjIwICswMDAwLCBNaW5nd2VpIFpoYW5nIHdyb3RlOg0K
PiBBZGQgdGhlIGRlc2NyaXB0aW9uIG9mIHRkcF9tbXVfcm9vdF9jb3VudCBpbnRvIGt2bV9tbXVf
cGFnZSBkZXNjcmlwdGlvbi4NCj4gdGRwX21tdV9yb290X2NvdW50IGlzIGFuIGF0b21pYyBjb3Vu
dGVyIHVzZWQgb25seSBpbiBURFAgTU1VLiBJdHMgdXNhZ2UgYW5kDQo+IG1lYW5pbmcgaXMgc2xp
Z2h0bHkgZGlmZmVyZW50IHdpdGggcm9vdF9jb3VudGVyIGluIHNoYWRvdyBNTVUuIFVwZGF0ZSB0
aGUNCj4gZG9jLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWluZ3dlaSBaaGFuZyA8bWl6aGFuZ0Bn
b29nbGUuY29tPg0KPiAtLS0NCj4gIERvY3VtZW50YXRpb24vdmlydC9rdm0veDg2L21tdS5yc3Qg
fCA1ICsrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJzdCBiL0RvY3VtZW50YXRp
b24vdmlydC9rdm0veDg2L21tdS5yc3QNCj4gaW5kZXggNWNkNmNkNWU4OTI2Li45N2Q2OTUyMDdl
MTEgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0veDg2L21tdS5yc3QNCj4g
KysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS94ODYvbW11LnJzdA0KPiBAQCAtMjMxLDYgKzIz
MSwxMSBAQCBTaGFkb3cgcGFnZXMgY29udGFpbiB0aGUgZm9sbG93aW5nIGluZm9ybWF0aW9uOg0K
PiAgICAgIEEgY291bnRlciBrZWVwaW5nIHRyYWNrIG9mIGhvdyBtYW55IGhhcmR3YXJlIHJlZ2lz
dGVycyAoZ3Vlc3QgY3IzIG9yDQo+ICAgICAgcGRwdHJzKSBhcmUgbm93IHBvaW50aW5nIGF0IHRo
ZSBwYWdlLiAgV2hpbGUgdGhpcyBjb3VudGVyIGlzIG5vbnplcm8sIHRoZQ0KPiAgICAgIHBhZ2Ug
Y2Fubm90IGJlIGRlc3Ryb3llZC4gIFNlZSByb2xlLmludmFsaWQuDQo+ICsgIHRkcF9tbXVfcm9v
dF9jb3VudDoNCj4gKyAgICBBbiBhdG9taWMgcmVmZXJlbmNlIGNvdW50ZXIgaW4gVERQIE1NVSBy
b290IHBhZ2UgdGhhdCBhbGxvd3MgZm9yIHBhcmFsbGVsDQo+ICsgICAgYWNjZXNzZXMuICBBY2Nl
c3NpbmcgdGhlIHBhZ2UgcmVxdWlyZXMgbGlmdGluZyB0aGUgY291bnRlciB2YWx1ZS4gVGhlDQo+
ICsgICAgaW5pdGlhbCB2YWx1ZSBpcyBzZXQgdG8gMiBpbmRpY2F0aW5nIG9uZSByZWZlcmVuY2Ug
ZnJvbSB2Q1BVIGFuZCBvbmUNCj4gKyAgICBmcm9tIFREUCBNTVUgaXRzZWxmLiBOb3RlIHRoaXMg
ZmllbGQgaXMgYSB1bmlvbiB3aXRoIHJvb3RfY291bnQuDQo+ICAgIHBhcmVudF9wdGVzOg0KPiAg
ICAgIFRoZSByZXZlcnNlIG1hcHBpbmcgZm9yIHRoZSBwdGUvcHRlcyBwb2ludGluZyBhdCB0aGlz
IHBhZ2UncyBzcHQuIElmDQo+ICAgICAgcGFyZW50X3B0ZXMgYml0IDAgaXMgemVybywgb25seSBv
bmUgc3B0ZSBwb2ludHMgYXQgdGhpcyBwYWdlIGFuZA0KPiAtLSANCj4gMi40MS4wLjE2Mi5nZmFm
ZGRiMGFmOS1nb29nDQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50
ZWwuY29tPg0K
