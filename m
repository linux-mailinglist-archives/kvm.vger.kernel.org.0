Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A9E73699D
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 12:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjFTKmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 06:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjFTKmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 06:42:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2639D;
        Tue, 20 Jun 2023 03:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687257757; x=1718793757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oQCbblvS3v+kAr2U5sbTGdii5JpNOgaZHMeokKK/2fI=;
  b=fiae8Eo+nIGZGAnY4yiElJOmy44Q50T3TDAIqGhlEWhqMuSAHGqpuPZH
   EOSdrEQCPm/1QPP2Oj+LCjuw4vaKkbGk1d2NDoD7fI5ghkvUsc7sRZhYB
   dOmQbsdqEySl/KX1c3G8en339RRr62Wg0Qs82zD2E7Rk0Jmc7i+N+BEqe
   GXQYAnxLJqdlggk3m/aVYqo1izByngxOfw0deQ6L5kTLNoIRpNNnfjovv
   CPAciC8Wg/pElSnHX+22x7oJ7MhG3NPh0VmmiMtotp5PSVRUSuVNGiQkl
   xegdQB/rypR0CtTq2apuDIBWOy20YXa71kJC3/VAjR5hdHzlo3ULyRHPr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="344568651"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="344568651"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 03:42:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="826945069"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="826945069"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jun 2023 03:42:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:42:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:42:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 03:42:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 03:42:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQsu9JLaIP6Fe2PtTBNhESpwDQDNLvaWVLNxx8TwxpMY4fOmct1httSPcdd0EeGOVNcG5HSw22baiPPUiSi2o4MPm/Qq2K64qm7uiFup5dMQ4KnPqNwQvf7RTSN+j0oj/80HzJQF7uYnW2iHZcTUZW6sTs4unhOMr2pAPNKy3EisqQB17BMMFW9Tjftdd95BP/u30xFK8gKAqP/b+Dv9syHhZyrgGUDTbqk9t8ycJmsOn/QeMWrMFF1uv7Cn2DPsIz+tT9kdVigHjJ+mLvaVaB1ausz44zG+4il8NmSHCMeG+oafvGi9jG1CxMJnIB5r2/+5ogYrFbxVvNGDRoD8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQCbblvS3v+kAr2U5sbTGdii5JpNOgaZHMeokKK/2fI=;
 b=nuT1448jOneD8qinitTa0mWywTY+XZQ00P78wTXVwq/JjmjtGfoPDtOj7Qu9Ni8/SxwzAHGFq3pT0Zx5WVkEKdybkoCmJ6+CNlHIbx9ERNwzPZbCR6nk7YjAo3N4/gceiTBj/sjN6ffwZPeqKEIEaX/EF7KkCNRs6Sd8C8wL0SblDLlXqee/TxM1laTYbf9BmI6rdOSaVJugtAv4z/joIJOwj35wA/feysfcifhivjE/doJM+4qRKTOL0gmSZgEJZqfIyTNKAbxZ47yK48zuTouLbJWkP5cEYklKr/5Ave3b6PIoGFfiG+PMbmhNx2CodEgW4c4XpViwBLMm9rMv4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6650.namprd11.prod.outlook.com (2603:10b6:510:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 10:42:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 10:42:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICADOfNgIAAKi8A
Date:   Tue, 20 Jun 2023 10:42:32 +0000
Message-ID: <93b49134cdf5c7f0658ba0aeb2b1a49778b2aece.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230620081131.GV4253@hirez.programming.kicks-ass.net>
In-Reply-To: <20230620081131.GV4253@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6650:EE_
x-ms-office365-filtering-correlation-id: 8c5d4fad-bdae-4231-e754-08db717b0d8e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iiiA1y7TkW027vJqETm0Ct0WRdQztVHO5Ip20F7Ns6xJe3IByfNAUyn1GTRRNt5NVfEu04a4Z0qXHSrI4uplKt449kBfEY6iiIR5qyka9HfcumaGpsrdymW14+nz8VGtLrElfES5shBQLDGj4FLhAtmfJGs9Tago7JFHQa89SyEfmOXXzYRpxl/VJaI31/v3BuzSw4rOoxUljxhwSIvsrsco+PoxD1dBnVTQxeO/KpHDuRSpjLisYgTprNOSbLjBDONtEWRfMVlqdiwbFiKP+76XkXVhafZFr3+37PlBoIGRQuPUsD98/xzl230Y5aKvaAgCLXK6UmxvOoGlBPlX+RNFK0EKuVV7Jlu0MdOoGNAuSIvxwlHy7udTf+uB9+QbU4EoFBmEhoIiKYSM26eLjp+hB1Y2eBWTCzF2iBQifynJSki8CjKR9hcTU0AGMnr+54g9ku93RQzoLmzxumtIJjxTRHwu7iujN9HgbHVWtrKioG3hEQNZSqBpnCn5NMNCzTEvyKAF8li4kK06rrN7igAdhJfjHD7hoSN9o5eThbtXlOvy/Eib9nU93AcgFb7QPkdGEQG8WW0Qt/Us3nNLrdeYI/CxWetnfnN/88tYkYrxIv+XYKMYiMKSopu0rP6+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199021)(71200400001)(6486002)(478600001)(558084003)(186003)(6512007)(6506007)(26005)(2616005)(36756003)(38100700002)(38070700005)(86362001)(122000001)(82960400001)(8676002)(5660300002)(8936002)(316002)(2906002)(41300700001)(91956017)(4326008)(6916009)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(7416002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVlkMDNUOE13VHhWeVJWSDg0MmNJckRGcUs3SDNyT3lwUVNaTVp3SHpMWTFa?=
 =?utf-8?B?endPUjZjQWU3S0U4eTJBUjFsWkErVVA4OElTcmplRG9iU0JkOGltMGVTWGRX?=
 =?utf-8?B?K2dHQ1ZvQVY2Q3RKQVNjM2hsWnBrTXM3akxLWERTSzV1S2F1bE1ERXQyeW1M?=
 =?utf-8?B?aXZyZWNCTXBKK1Z5Z01VeTcvMGZXVjhTaklyNzYwT0JPQk5oRTA2eTFaOVNQ?=
 =?utf-8?B?Um5oNEdCN1dQYkg3blNRT2dLZkw4cHQ5ZG9LcFl4K0t5Y3NwNDY3SGFDcXlm?=
 =?utf-8?B?U2lJT0pGOFF1VFM4eEdYaUJleGt0d2Y1aGNiNG04UmhjaitUbzhIS0VpeG5L?=
 =?utf-8?B?blpuMHdPODNtb2QwME52MlNPV3Q2QUEwZmVvN0dKUENNc1NZYi9QZXc2ODJP?=
 =?utf-8?B?UDRBM1pFUnhvNXJuQ0tmRXNhdnNrQ2NtQng0d0RFRFJVNzczSzZOU296K3dF?=
 =?utf-8?B?czMzcjZFVWhFaFpHSitGcU5XQmxRS1NGYXE5c09BOEpYOFZVREpDc2IrMlRp?=
 =?utf-8?B?V0QyOGl0Tit3QThjRFB2ZVAweW9zS3ZkK0hrb1BBZVZINVdDYTVrdlFpbFJW?=
 =?utf-8?B?dGs5TzdjSmpuK2l4VFlQWnMyYkljSURqdVhCRVo1eGxHR29tNGc2cnR0cTBo?=
 =?utf-8?B?MEhYUUdBZWlvZStDN3NiejdtR3lXZlpJeXJKRWwwelZaU2VKanZtNUpBMEtY?=
 =?utf-8?B?R3Q0ZDZQM3Yva1dNTTZkUllDdzlFU1BUdWdKM3NtcGlvUCtlRnpEbml5ZUVE?=
 =?utf-8?B?ODZmN0pjNThVcldjcmRoUFh4MHdqRTlsYUQ2SzdWTUd2TXlqOXJvL0E0NVl1?=
 =?utf-8?B?VFdETU0zSEFsbTQwRWZyaFd6aFBVS3JDWmUyYzh5aldUZXVHMDJJTHNYUzB2?=
 =?utf-8?B?NDZLWG9NZHB3OUxydUpMU0loWjl1U3M4SloyTVFCWFliOTlJanEzajU2Q1Iw?=
 =?utf-8?B?QUM0OVpyODEwQ2hHaGI2RUlUNmY0dUhQay9qcmY3M1dxZXFxQi9YVWxxdXdr?=
 =?utf-8?B?YVIzdWdPQk9LVUNheVBKL2d1Uno1VTlhN09ncmwxYlBmOVJRckZSOUVYbzBp?=
 =?utf-8?B?cXRnTS9YU0JTZXViQk52eXFOL040VG50U052dXZJaDk5aHVUaldDL280N3l0?=
 =?utf-8?B?S1pnamtvUklPNmRxLzFJYXNYYzBkdzh0bEdJd1lTb2hOMjlidUMzanBlT29p?=
 =?utf-8?B?dzlXZGV0Q2FUKy9Wbk5qSDFCQ1hNUG40TXg2cVhUL29TU2ptelV1QkhSaU1E?=
 =?utf-8?B?enNYYkFsU0lubkE1NW5nbDBUTW5Rc2NoVmkzZ0VKM2Nha005MXRzd1UxUG92?=
 =?utf-8?B?NU9xd2hRdTl1VXM4d01WMFpKbUdmamQ0VlFzUTBETGNoOEcyT0VSYWVFYkds?=
 =?utf-8?B?RGpmSmpsQVBadUViNzFmcFdlNTFwRDNJaDJjdkFVRU9zNFdKWGN6WEhja2lU?=
 =?utf-8?B?aDFueGRTdktJa0xiS3A1dnlCSXQ1YjRyV2RiT05SemVRM3E3ZUhvSnBUY29S?=
 =?utf-8?B?ZUJlcU1pRG5mSHRYZUs0VkhzTGI3d2FUbWRvN3hROEkzeFdMWWIyYmdxbkE1?=
 =?utf-8?B?T3l5b0VnWmxPeENCeGhWUzBSOXpyUGcwQWE4RHUrZnBIUmthVWlYcE5XUGlH?=
 =?utf-8?B?UVBjNkZBWXBUYVE2ekQzakp5SzY1V2tXbnZudzZlcURXeDM3MHVOdmx1bUJ4?=
 =?utf-8?B?OU1NQXBCSnI1cmZhaTFDaytYY1V0V24zQTZZVUU1OUcwL2lLVDIzYnltR1ox?=
 =?utf-8?B?NzB5bXZkNXcxZzB2ZlM3QTVyRDZqQWdrOWNZLzVZQlBKenMxRVlEMnlSOVpi?=
 =?utf-8?B?MkhYL1h6cDRwdndFcFhzK1pNV3RIYU1JRGxmcWpBOWRLNXhqeWx4NUVYZnFT?=
 =?utf-8?B?REY3dHhIZ016Rk5kakR1UlpRNXhHQlA1WjJmZ1VQc2NoU0NNdW0rQmYzeko2?=
 =?utf-8?B?NnV3ZEZWbnkzNG8wSStKc0U0NWVkVlF4ZnlhaWhXY0ZxOVFES0YyRjZLSzYr?=
 =?utf-8?B?dzRncS9HNld3TWFmT1VOOWd4bExWbVRrY2JKQzJhRlRlWEZQYUp6UUtDK0d2?=
 =?utf-8?B?VTJXTmE4RDd4N2tjTXRJL0JwZXlNNk1EWkxIZFdqTjRwQmNzbGRVNVQrdHJw?=
 =?utf-8?B?K2tLUSs1UDVuR3h4QlA3dDJaSG9lK1orc1dja2k4MnM1ejZvV2haOHl0SVl0?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B09E74B64037F44EB5D8DBFFCFF17EEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5d4fad-bdae-4231-e754-08db717b0d8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 10:42:32.5139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sLW70sSsRfICLt7DJcgBJ1eK3Sz7nK1vqNVhmV7pJmZkLzeE+pBSy4YGiyUQV69UUyP3kyBmbEF6r8Z1vQPT+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6650
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTIwIGF0IDEwOjExICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gTW9uLCBKdW4gMTIsIDIwMjMgYXQgMDM6MDY6NDhBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gDQo+ID4gKyAgICAgICBfX21iKCk7DQo+IA0KPiBfX21iKCkgaXMgbm90IGEgdmFs
aWQgaW50ZXJmYWNlIHRvIHVzZS4NCg0KVGhhbmtzIGZvciBmZWVkYmFjayENCg0KTWF5IEkgYXNr
IHdoeSwgZm9yIGVkdWNhdGlvbiBwdXJwb3NlPyA6KQ0K
