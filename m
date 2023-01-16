Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FDE66BC53
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 11:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjAPK7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 05:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjAPK7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 05:59:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020CA97;
        Mon, 16 Jan 2023 02:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673866750; x=1705402750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=esPycDBjyIt5Yvl6K/GPZmTqdwajHZppk+S2ARWYB9o=;
  b=l1Ts1p1APkcw6Hb7PFNCFlL0YgNG0rE+CGAF7zLvqbyo2f884yofxXr3
   3Fs3HummLDHhD3AoLnQKbCPWR5SDrSzzil5+XhI/vf8Gd0KPxtaKVfH7A
   eWRmAke2LCaYvTwzvjTzchuWn2PXSOQKiJhI4Wr6Uup4HMunEAK90lc4i
   rKOhDP9e+3b5GTx6M1pGnLnKIw1B9Cv5CQlOK1Yeh+dzhhMUfThHxY1Me
   jEesvnaQ6/w+JgGn8JZAfzw/Mt6EeOdVMclfG+re6ygFCEEX06pwf2XsJ
   qinBcRyOu8zDVVNfxzk2NfXTgvdboTBTwDFiopA2O5jPvo78kMYudCMVb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="324497872"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="324497872"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 02:59:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="636502923"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="636502923"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 16 Jan 2023 02:59:10 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:59:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 02:59:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 02:59:09 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 02:59:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EK2ZF5UnsFrJEBPiZGrSc2Z6biVK25bgnne0PF4xD3TbcVB5xP/+rrEB12A+6fZgpW3GubohrvPO/WcGCvKbipBGOkdhPxrg4Aftbn1JOkCqYhGgs8OdueP53k0WP3Df8ZwuL4IL9U1QdBxbQBvK5LJeRzeYLb2ZtJVKqQ1nyNPm4t96fjniZviHrom7u3izhyJ1OfSkiLOfI/gbh42T7MfbyYOHVwrsu4GltmOwdcHd4QEWG/W5mhZFk7FPd6MceJv+MRjfD1q04krQreGeW3sZmJfKIxySoa3knyumSL9Y4Mw7yayCqy/DYnXl3bXiu3ZhjRxow1lRa3okVAOgIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esPycDBjyIt5Yvl6K/GPZmTqdwajHZppk+S2ARWYB9o=;
 b=Mlq1Tkmk1UQJl61ma4q51tzHX4RuZIdhcmxAYtvnKgReI6kNRRQdESptBVslL7y5AuWPtbe2omLamZ3r9LMGOb2/rQLhMm34w8atlWheymeyy2WTkxIpRuvnrexqfjAOfSOdZJEq6LO6O5FdAxoj0x1d4FEJxC2i9qg/RhqpDCK1Nr4TjDX1idXAQjclRsZZzV2mTj4bUzoLKpLyWD+vBFisrwnDq88fEq9yqjoWb/oiDSzcp4A+DY/dGXoHu+IAaiZU/8QfjrlwuUtetJzWtwkqOwxz+0FgAsEAMwaoc2yqeNQ78Du7rbxOLAPRqdKy3pxv5s7UUuKWMAtoc0d9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5121.namprd11.prod.outlook.com (2603:10b6:303:98::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 10:59:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 10:59:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 032/113] KVM: x86/mmu: Add Suppress VE bit to
 shadow_mmio_mask
Thread-Topic: [PATCH v11 032/113] KVM: x86/mmu: Add Suppress VE bit to
 shadow_mmio_mask
Thread-Index: AQHZJqV1tHmG0xhOREKv2mzesYQlja6g5cuA
Date:   Mon, 16 Jan 2023 10:59:06 +0000
Message-ID: <820e1c1f828ea8e485078f5cd109d03b45981c81.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <8cb87ec35b24d9cf5b47b650597c3005a8adf247.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <8cb87ec35b24d9cf5b47b650597c3005a8adf247.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5121:EE_
x-ms-office365-filtering-correlation-id: cd30739c-4398-4ec8-a737-08daf7b0b021
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jLPkM+u9SEtSFeug0yLyK5akS9K0KQxP4UlQNiCbvrhWJg1QN/y3FP8Vlhy/93GkrGxWK7g0L3lUyFU5xLaBTXImGYB9iaqGryfzxDlYNxj0iD0fN/qMwiI6BN9FIeqZr2eazQBLmaeNETFSJVFZv36yybsNB7wgKHhgplKj9e2gc+ZjE0QyvqIu7KGHq7ar6thwXfrMWhk9GNqhDwDvrC6K2Tap8FDHDDQTzBrbLbdRLpN/C7NHdZyVHGnBpMAdEYP9BvwVqfh1bSK9O0JngEAHnSdi/sAVfGyyj9/qp81h2r3Q6GHlDfdfbQ0c9l/WUxfZkW8AjMo6HZ50fjzjXe5jV6YU/ROIgcPyHVQjrEYCTCaIVupoRVHX1zotcLQs0KxYxjj5eGnedY7JZ9HgJkWqeQFuJB0DdPE2+2d6h5eObnndD/eoCVpS/ShnsRGAhUYxr4gf4z9/K2kROihPJsIxyo6y481ngoocgVWPEIFEII8qQSl0wIQcuAofdLy+qDmmVPPsO9bPYRqYO5IY+G93568jH9ephy7s2siBJHGtbSognQxYlvuM4Am4jHjcnvwI9/emrSo19S05kmMQCTAx0lrFnwo4PSr+PsX7dFiMxeq2oMlQRJphi3Zv89YlCNpvtr6XEZjYOXyBlUCazhTsKaR5cCWp6I4LZo86NSpnJUOTJFxHzaVZSVQd+4zt7VcVWPi9XogI4IbWGs6ZJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(91956017)(86362001)(6512007)(8676002)(186003)(64756008)(4326008)(26005)(66556008)(66946007)(76116006)(41300700001)(2616005)(66476007)(66446008)(316002)(71200400001)(6506007)(110136005)(54906003)(6636002)(478600001)(6486002)(122000001)(38100700002)(2906002)(38070700005)(82960400001)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1J0SFNXaFJ5blE1cFdjT1crRVRiMm5NNXdGMDNRWEZOVTVHRTRHRmEzSGxr?=
 =?utf-8?B?Lzd3SXJ6Z1RLeDhkU2w3Qm85UWFPRWY3MnRZTE1WdDJkRm4xa1B3UFREbkwr?=
 =?utf-8?B?VUhvZGt1R2NiTmZwTVkrVlY2dWlUKzFtdHRmRnRoRUdlcXo5WktMRFNGZW16?=
 =?utf-8?B?TG96SDZ3WHJWa2lYWXlzR21xL28yZGN2eUtpc3Z5L0ZnSGcvQ08vMEV4RWR6?=
 =?utf-8?B?V3BmQ1ZTbXA3WHN2akQ0WHF0TGxQWFlYUDdyRnNuMWM4TDNSR0pncjZmQmIz?=
 =?utf-8?B?THg3TXcwZTJ3aENFTHl3dGoxSVhac1ZIUm9odWsrMFF6RWVMRXoyYkRrS1N4?=
 =?utf-8?B?anZRdWFHMjRySm12N3M0d2N6elRkUW0reVhkL2ozOGpxNnN6QmowQm8wWmtl?=
 =?utf-8?B?YXRZS21rMmdjRnY1dC8xWmhuUlg3SjNPVnh6aklCejdGakYycW9Xa2ZxL3Aw?=
 =?utf-8?B?U1VFWVA3ZmNaMEZVTHdkS1l0TlhhTXhoSjNDaCtsOVNkZ0gzMEczN1EzOVUw?=
 =?utf-8?B?SkhiVEJSdTBRK3BBVWpIZzZSbnUySDMvWGZqYUVLQlNncXJjUzhDZTZ6bk8r?=
 =?utf-8?B?emhhNmU4SSs4SHVrNmlYTENCYWxTc2JrN2U3eGUzcTdDWlBLaHhDNjlmVlRL?=
 =?utf-8?B?VjVGdGU4aEM1RFdEeHpEcWRjSk9PVGtCaVJUNS9yMldkK3FDWEZzbUpwS2hF?=
 =?utf-8?B?T1R0WlorK2U3ZU13WS9paDRzWTJUb0U1dDZubmVaZERkbVZKN09lUDcxK2Zv?=
 =?utf-8?B?eFR3ZVhKNVN0UTBkTXMvY1NVaHM1bGhaN0E0Mnd5VnhqTEdIdGxWUiszMllW?=
 =?utf-8?B?bmlqTnN2ZnhPL2U4aUZqQS9CdTZ6UkVFUTBQc3ZlUXIzRFhtRUM5OUFIVFRM?=
 =?utf-8?B?K2JOSm9GVzBEbDBpRVpkcW9RTnhJVHJPL1RKSDVTZEVWNHU2WXRqWU5yTkw4?=
 =?utf-8?B?bmVPbldaT2Z4RDE4dTVBNUVEM0NqVFArbXBuanFoZGRpaFVTNjE3SXlwQ05r?=
 =?utf-8?B?WHZleVJOSXpPdHNtRmZ1NzJaeXFHVVNDSkF5cE43UG1YRDhyZWp0NHRwc0lo?=
 =?utf-8?B?VThvd3hVMjhmc0VPdlJ3T096SkJrWVlId01jdVZQcFFGcUcxS2xXYXNiWmxs?=
 =?utf-8?B?SjdaRXVaNlJVZ3JXZDZ1SWlQMEdURFF0WUdlZFB0VTc2Q0ZMZ2RlN05lVTBV?=
 =?utf-8?B?cGxGaGltMSswejRqVnVyWXZVMmJyMmFwTmRSc2d5TzJmMXhpcEdJdWc0bUtF?=
 =?utf-8?B?VldPMFhTbXI2TVF1UEZSejBXU2RXS1EyTnJpTjVCdHJnUCtRb2hpQmg2ekJD?=
 =?utf-8?B?bEtRMHhkMnVRaVZHWFFmWVFjdnEyTXFvOGVscUI5cDgwTktDTGxPRjF3c0E4?=
 =?utf-8?B?UU1oTCthOFoyb3dieWFIaDV5am80dHZKOHYyRC9zcHEvcTh1bTVaakx4ZXI3?=
 =?utf-8?B?UythWEFPaFAxN05pQ3ZsUHFBUm1VQm0ydDlmdEVyaWdPNlc1S2xEMHRYUG9H?=
 =?utf-8?B?UFFLZVFlM0JKODM5WHowOGZMWkc3b0pIV2lNbVpnVTJzYm9YOEFwRjFSSmRO?=
 =?utf-8?B?ZWdOcWhZOUZIb2xET3ZaelF4czBOaWprcG5Vb1JReEpOdFVJbWlodlVucVFQ?=
 =?utf-8?B?a0pBOVhucmM4OHZEN0Q1QmhEdDAwUEhPOS9QSndDSmFEcWhlOUlMZGg3S3o4?=
 =?utf-8?B?SGNUTXZDaXZMTzAwclZZNmV4dlF5NnZvaGoyUlJRSUVSZWJ1c2NpRG0yQjJr?=
 =?utf-8?B?OXhQUWNWd0VGQTh2LzNqeUxubzBoeWc1d1ZTZWZrTTcwZDQzNGswVFlFcVcz?=
 =?utf-8?B?Q1dLNUMyenJEeStYd3dQQ2N4OWIvOE9kazk2MmNWWFAxSWhNUlNDNG96ZzNL?=
 =?utf-8?B?VDlUWUlYSkVoUzI4TTgzMUpzU1NCNENuVTdpdjBHcVlaNEdNZi9IS1VPMGZY?=
 =?utf-8?B?ZFlkZzRMbldjTW1XVDdkajdwRVJXY0hZaUkvM1NEc1ZvL0FDdExLMXZnNnU5?=
 =?utf-8?B?YWl1KzE0Z0Y2ZzMxaVRjaGhpaDNxc2FSamcwUXFIQmMwQ3B3TnJFbEErMDhS?=
 =?utf-8?B?eEZYNjFhNHR3d3REZExPdG85TVJJajhYMTZocEVxOU5aQlFkWHJxOEZzNjlS?=
 =?utf-8?B?dHFROUZEZ3RpaWZ3TGFoNlhXdy9vTGlTK0dWTmI2dWNpMGRidzhTZXMvOFE1?=
 =?utf-8?B?MkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BBDF1DBE17B7D409BCD200E50F59A4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd30739c-4398-4ec8-a737-08daf7b0b021
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:59:06.7334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Il7LkfAWkx1jCJmUakzbYNsv70jg9Hd0E35EVBBSAw+XuHNbEb99w1zLhypTpaN6xA2etkepHmY3tD+lKPO+ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBUbyBtYWtlIHVzZSBvZiB0aGUgc2FtZSB2YWx1ZSBvZiBzaGFkb3dfbW1pb19t
YXNrIGZvciBURFggYW5kIFZNWCwgYWRkDQo+IFN1cHByZXNzLVZFIGJpdCB0byBzaGFkb3dfbW1p
b19tYXNrIHNvIHRoYXQgc2hhZG93X21taW9fbWFzayBjYW4gYmUgY29tbW9uDQo+IGZvciBib3Ro
IFZNWCBhbmQgVERYLg0KPiANCj4gVERYIHdpbGwgbmVlZCBzaGFkb3dfbW1pb19tYXNrIHRvIGJl
IFZNWF9TVVBQUkVTU19WRSB8IFJXWCBhbmQNCj4gc2hhZG93X21taW9fdmFsdWUgdG8gYmUgMCBz
byB0aGF0IEVQVCB2aW9sYXRpb24gaXMgdHJpZ2dlcmVkLiAgRm9yIFZNWCwNCj4gVk1YX1NVUFBS
RVNTX1ZFIGRvZXNuJ3QgbWF0dGVyIGJlY2F1c2UgdGhlIHNwdGUgdmFsdWUgaXMgcmVxdWlyZWQg
dG8gY2F1c2UNCj4gRVBUIG1pc2NvbmZpZy4gIHRoZSBhZGRpdGlvbmFsIGJpdCBkb2Vzbid0IGFm
ZmVjdCBWTVggbG9naWMgdG8gYWRkIHRoZSBiaXQNCj4gdG8gc2hhZG93X21taW9fe3ZhbHVlLCBt
YXNrfS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0
YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL21tdS9zcHRlLmMgfCA2ICsrKyst
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuYyBiL2FyY2gveDg2L2t2bS9t
bXUvc3B0ZS5jDQo+IGluZGV4IGZjZTZmMDQ3Mzk5Zi4uY2MwYmMwNThmYjI1IDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3Nw
dGUuYw0KPiBAQCAtNDMxLDcgKzQzMSw5IEBAIHZvaWQga3ZtX21tdV9zZXRfZXB0X21hc2tzKGJv
b2wgaGFzX2FkX2JpdHMsIGJvb2wgaGFzX2V4ZWNfb25seSkNCj4gIAlzaGFkb3dfZGlydHlfbWFz
awk9IGhhc19hZF9iaXRzID8gVk1YX0VQVF9ESVJUWV9CSVQgOiAwdWxsOw0KPiAgCXNoYWRvd19u
eF9tYXNrCQk9IDB1bGw7DQo+ICAJc2hhZG93X3hfbWFzawkJPSBWTVhfRVBUX0VYRUNVVEFCTEVf
TUFTSzsNCj4gLQlzaGFkb3dfcHJlc2VudF9tYXNrCT0gaGFzX2V4ZWNfb25seSA/IDB1bGwgOiBW
TVhfRVBUX1JFQURBQkxFX01BU0s7DQo+ICsJLyogVk1YX0VQVF9TVVBQUkVTU19WRV9CSVQgaXMg
bmVlZGVkIGZvciBXIG9yIFggdmlvbGF0aW9uLiAqLw0KPiArCXNoYWRvd19wcmVzZW50X21hc2sJ
PQ0KPiArCQkoaGFzX2V4ZWNfb25seSA/IDB1bGwgOiBWTVhfRVBUX1JFQURBQkxFX01BU0spIHwg
Vk1YX0VQVF9TVVBQUkVTU19WRV9CSVQ7DQoNClRoaXMgY2h1bmsgaGFzIG5vdGhpbmcgdG8gZG8g
d2l0aCB3aGF0IHRoaXMgcGF0Y2ggY2xhaW1zIHRvIGRvLg0KDQo+ICAJLyoNCj4gIAkgKiBFUFQg
b3ZlcnJpZGVzIHRoZSBob3N0IE1UUlJzLCBhbmQgc28gS1ZNIG11c3QgcHJvZ3JhbSB0aGUgZGVz
aXJlZA0KPiAgCSAqIG1lbXR5cGUgZGlyZWN0bHkgaW50byB0aGUgU1BURXMuICBOb3RlLCB0aGlz
IG1hc2sgaXMganVzdCB0aGUgbWFzaw0KPiBAQCAtNDQ4LDcgKzQ1MCw3IEBAIHZvaWQga3ZtX21t
dV9zZXRfZXB0X21hc2tzKGJvb2wgaGFzX2FkX2JpdHMsIGJvb2wgaGFzX2V4ZWNfb25seSkNCj4g
IAkgKiBvZiBhbiBFUFQgcGFnaW5nLXN0cnVjdHVyZSBlbnRyeSBpcyAxMTBiICh3cml0ZS9leGVj
dXRlKS4NCj4gIAkgKi8NCj4gIAlrdm1fbW11X3NldF9tbWlvX3NwdGVfbWFzayhWTVhfRVBUX01J
U0NPTkZJR19XWF9WQUxVRSwNCj4gLQkJCQkgICBWTVhfRVBUX1JXWF9NQVNLLCAwKTsNCj4gKwkJ
CQkgICBWTVhfRVBUX1JXWF9NQVNLIHwgVk1YX0VQVF9TVVBQUkVTU19WRV9CSVQsIDApOw0KPiAg
fQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX21tdV9zZXRfZXB0X21hc2tzKTsNCj4gIA0KDQo=
