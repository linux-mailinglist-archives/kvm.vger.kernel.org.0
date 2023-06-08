Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED1B727494
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 03:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjFHBog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 21:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjFHBoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 21:44:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBE13585;
        Wed,  7 Jun 2023 18:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686188631; x=1717724631;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r2zLHrYJMqEglZhoE+afpa+mcyVtRSwzpY+XtMAFkwc=;
  b=fg2ife88xsrBjsFRw07hdvTVqU4kXZd7YgbapnzzWi23a3UmME1ynkSg
   qDSVGX2L3QoB+x4EqXPQduRsQt/cL55FZydfdnCVuLs0SI8iQ23nOfn1q
   TrqvoBxYnPTfqBQkEYra1xYPhjeuhlA1bBAkAjtE3QXWgPKi1W0mUnQUV
   36W3d7O7O34fJDvjv+fEms4ht42pj++qrnN8HiS8wfrJ5xDZy3Sg2DJJX
   jXP9hTBdMEPHvVxtCqOG8v/Jo+3154cSQBv7S3GVKdpgZQF28mwZCMSmd
   SlckeCLH3cMRA91T6VNGXWuXJMpT258jw06lfWgp/ClCG3wof9GFFzZEm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="337526233"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="337526233"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 18:43:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="833957541"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="833957541"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2023 18:43:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 18:43:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 18:43:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 18:43:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 18:43:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBDfMq1AbONGMk+m0PJzdr4+xCgXOhp5/c56bRNgt/4cF628NtUv0/74A6VUWD2y3rPSflcOyAqXT1IaOIjk16DyRFzrlDvfjsS/7C1eybOQbn4ZgklLwM1XglHPEbKYKYmIdOIZTTxRaFF0ZJBazQYGr2kfaiioYqBOzG8nt1j5OHFXC784H7F8R7yc5DW5PerIbTEyjGgHsBxTnd/3R23KriKp3pmRNhah2ZflDZCfA6IYitVvktAud+tVLynOWvtEe/2F/XmOEMjYXQPZ/WrdKmRLqn909js+KtPepah1kvdqmO7LtHsRP+W0V/6aaxSrwaSTcUmVS9qrqMOPTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2zLHrYJMqEglZhoE+afpa+mcyVtRSwzpY+XtMAFkwc=;
 b=YSSdutSD5N/zF1ymevqCFBMztBVvW9Z/HR4MKXWGjwQ7DHmcHJwb9EdCZ5eFCINXiSFSxIGuItgHvTglZDxlYlg3UPCUAM3+GDBKdsxOzVZ/LE5R/fRkA/dY4QgUL5L3jjz35S5YuQURgIRN8aoUef6p/Fz0G5KtAqO/xzP3ZQfyWU17709Pr6uATnKWc5hI4WLb8EGZZGrzNduRRmeM7pcMAjjdRfIn/u9DTOsZ+Jz1jnnmlkbU8NUkdC/kKMdxyC+7xXg+DqpUQ1dG9FMjDQURmWj/EwOb9cCQqrLgNW4a7660X9UQLMDH3eeIL4NvB4hJ4mlISyDBY8ZcTXpPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Thu, 8 Jun
 2023 01:43:28 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb%6]) with mapi id 15.20.6455.028; Thu, 8 Jun 2023
 01:43:27 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: RE: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHZkeUO9CJK5Ein70KPqCCkDQrVv697abhQgARKm4CAAHDfsA==
Date:   Thu, 8 Jun 2023 01:43:27 +0000
Message-ID: <DS0PR11MB63733FFA02B4A5C04561A1BFDC50A@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230607181537.GG2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230607181537.GG2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SJ0PR11MB5117:EE_
x-ms-office365-filtering-correlation-id: 710e75d3-2f02-40bd-67e1-08db67c1c163
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2272XjBP12+1QVemN7kSSpQuzahAD68xFe94lcI7p0TLUab7nW0/8zElc/EvR2pK5xN3p4oeW8vM0A14Ujm5PQ/ZXC73Bvo2YJDFjihX/QxmNOeTbwLXpSpDQMgU5fOH4PITrV/ek7Mx10v7Cwh6aNNZkcUHJPIjbY0K0evT5nXirCqfgEdxTz0VwwIqtxOiyQEqkRSEYGpo9KOIWeLXXTj3zB2wZ/nnZEYDHH8CNkoUw5flMyWTVPGKrJKSD72hhzM0scwSjOYHXmHVCo0w3y5Q0kFP7jSD3NxJ46rFlkHS2BUMHsgGwVcLQ4dNcVd1/mWPOzKhL3mT8fMjBlqQBCdLrlJuNFBRKxl5+z3BCrFEWjj8QPLP9MTMm0C4zGNQ8SSqBbkudPkE8puFVhiG8vR/IUsrgxzTOPjjhphjcqXsbUMCBgUwlltCwq3aFPkAPIExR5DDka6msyHXt6w8P+/9VK56ME4DYywuGte+FAB3mRyHHVScQJV58/PasdAA+DBk0uWykrzhq8P2Oehyxlz92zfqfSjp/JHGaQVNKdXjBjx5hg4hlQh3Yqu8OGjspj14VdkfcRBeEbcK3hMMPfgC9nihnmv+aruB3PIoH0/FR1k2ABoslgV6QYNWzY8A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199021)(107886003)(9686003)(26005)(6506007)(53546011)(83380400001)(186003)(82960400001)(66556008)(66446008)(64756008)(122000001)(66476007)(2906002)(76116006)(66946007)(7696005)(71200400001)(52536014)(38070700005)(38100700002)(8936002)(8676002)(5660300002)(54906003)(55016003)(478600001)(41300700001)(86362001)(316002)(33656002)(4326008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1YwUnFidGxKcTM3WGRwNzh4d3ZvQUxNd0wzKzhQQkttdjVINXlhSHlTYTJS?=
 =?utf-8?B?N2kwSTk0S0l3L3QyRUNjeEpYV1BPYTZBYVJPcWRmR09SZFZtZklyL0dwSWlr?=
 =?utf-8?B?QVBrY29ZRncxWXJ6UkVia2h1VStIRFExSitTRHdpenh3RGY3eHMxdWxYbkRU?=
 =?utf-8?B?d3NPdVFzRFlseXkxaDdWUk9BTldHRUZyci9KaGVBWkZhSDQvSUxBV2NENHNC?=
 =?utf-8?B?bk8rMU92ZlljM2tnVlZlS0d4aUczMFBHM0NOOEtKN3hEM3ZiZGZ5SUpkR2ZR?=
 =?utf-8?B?eVoxYmpNMXZvcTF5ZTFMd2pvT0pneFhWZXJnSGZ4blhreDlkV0dFUHJVZHlY?=
 =?utf-8?B?SUQ1SzlBcm9NTU9DQ0FMSWJoKzZZcm5EWi8wYVlQbEV4MnVVUkN3aVlMRThR?=
 =?utf-8?B?ajJ6VVMwSXlJL0FuMUlsVVdqeEVHQURXRVQwYmhCR1YzZU9yNVBWV3QrYUFJ?=
 =?utf-8?B?QzRaaXJDZ1RZSkM0RlAwaHozMDZwQ0ZxaVBJOXdSY1pDeG9XNlpuS1hOU3lR?=
 =?utf-8?B?dTFKWURiWGZxT3lBSUh4SlRabm55NVBOT0l3K1dJc3p4RndPblRHOWNZU3c2?=
 =?utf-8?B?ekM4WDhNN1g3L0xwOHhGeGdaZGV6OGx2R0JHWUxPcVF4RDJHTWZyZ3dUMnJQ?=
 =?utf-8?B?M3Ava0dQZUNHZ0lxMjZhaW9sQTllUUk1NHVQMkoxM2FRb09pWjNGaEpacjN0?=
 =?utf-8?B?clhCMFRqRU8vYTJ1eVRwZW0raThIdmJkR0FrN3g5QlIwTFFOWDVvaHBGalFm?=
 =?utf-8?B?ZkhuVWt1a1BydWZKa0VsSlJhWGRSYkJtWGlLTnVKVldMT09oWER3SXh6SFZp?=
 =?utf-8?B?SlpNY2FJdjdkMG9ZalcwZDYvRE9RNVd1NmJJN1U2c2lUdEFjYnZKVUxsSDhi?=
 =?utf-8?B?MWJHaUh6dDl4WHNxcTBaVHNOREUvUzRLWmdxa2xiNHk0RTZvd21ublBGMlJo?=
 =?utf-8?B?SEtDVURweWxmUk0xL0xoKzVuc1dvOURSV3RkYTZ2VVhzcW5kNnljK2lmbTN2?=
 =?utf-8?B?MzhiVk5UdVBvVEtrMldud01Udk5hZFBZZU43OHJaN2VtOFkvMkVMOTZubHNm?=
 =?utf-8?B?VS9nQVRJVW1YMTFTREsxWEkwZVArTWlCVzh1YWhUVUtTeU13V3hOMUZiOXVr?=
 =?utf-8?B?dVhXVksrTm1CbUNWeUVRenlpRzkrSFN5Qkx5OUQ5ekdwUjdTWE5acVU4dnNo?=
 =?utf-8?B?WUxhNkhCY3huTlZDSU9BNVo5Wll1RVJlekoyeVF5M2p1NkNlbmFNMVBNOVBX?=
 =?utf-8?B?cGxEOHhvRUoxN09ra0dTRlpBL1ZFNVRUMkdIS2ZwYkxwRjArWGZVVEQ4NnRN?=
 =?utf-8?B?SFZHT0VFNlpYZE4vRFU5b3V5TVlRZ0tlVVRjc2xOTWZ3VHlrSW1nRkJwT0pY?=
 =?utf-8?B?dWhwRnBIMk1ST3NHMW9CS0NlU1g1QmMvSC80b0htRW5CL2JBQ2ZnWUNMMUty?=
 =?utf-8?B?ZEdKN2JVWDloQlFGS0k5UjYwSk1JdWM1eUJHdlUyUkpLSDUya3ducUcyb0Fm?=
 =?utf-8?B?M2RXSllkaFlXdVhRRjhZU2xtTjc3bmJFNEVhZ3hsN2pIbEx5bXpYVlB2Titn?=
 =?utf-8?B?NFZpOUNVWk5ySHRyakVqajFoWFRKLzR3VkFlbzNwSFFtRCsweHFOVzhKQzVu?=
 =?utf-8?B?b291TXVIK0FjN3AzdHpScUVxMzFZRDlMNnZPVEh6Z0EvY2ExL0QyQmZVWXJa?=
 =?utf-8?B?Z3MxOWVJODllYS9zQ0dUWVErUUdWdFNEcU8zUkJpeXBOQkFVMXF2cWp3Wi9L?=
 =?utf-8?B?V2NjVlk2aEJHY0FMY2xxWlc2cW5nWGI4WUIxTDV0dGtKK2xod1BZYjd5dkJK?=
 =?utf-8?B?Wk9xNWNDMkp5WGg3MDZ4TDhDc3dJeUVVVi80VXd5WjNGWk9ENTUwRitsTXJh?=
 =?utf-8?B?UzduVldHWFdOclJtUklPWUYzOXBRZmdKanE5b0h5N0o3RG4vdTU3N0cxSEpk?=
 =?utf-8?B?MzhaZ2xlM2lGdDV6endWQU5DMnR3WVFvWXhNdkJseUI1aUtXMCtFZ3NxaVZB?=
 =?utf-8?B?YUxVdHhFM3lHVUREaVJsOEwzWjZBc1Y0TnU5NjMyMlNaOGdnNWZBWXZuMHF0?=
 =?utf-8?B?SWdUQ1FWdDI1N211Z0FtZWhGdkxSRWZaN2lPLzYwUmxtaXpjSlZEeXJFaWE5?=
 =?utf-8?Q?aSzdHXx4rLgwQWonlpfyIfziV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710e75d3-2f02-40bd-67e1-08db67c1c163
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 01:43:27.3751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hceADKqjojnb5BpJOVUGEWyxMvaEg/mqdFW+SANXmYbmrJCGigLNUMTF9qp3FzbiseAtzxd9O3ewPwlItGp6fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
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

T24gVGh1cnNkYXksIEp1bmUgOCwgMjAyMyAyOjE2IEFNLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBKdW4gMDUsIDIwMjMgYXQgMDM6MjA6MTlQTSArMDAwMCwgIldhbmcsIFdlaSBX
Ig0KPiA8d2VpLncud2FuZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gK3N0YXRpYyBpbmxpbmUg
dTY0IGt2bV9zZWFtY2FsbCh1NjQgb3AsIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0IHI5
LA0KPiA+ID4gKwkJCSAgICAgICBzdHJ1Y3QgdGR4X21vZHVsZV9vdXRwdXQgKm91dCkgew0KPiA+
ID4gKwl1NjQgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKwlyZXQgPSBfX3NlYW1jYWxsKG9wLCByY3gs
IHJkeCwgcjgsIHI5LCBvdXQpOw0KPiA+ID4gKwlpZiAodW5saWtlbHkocmV0ID09IFREWF9TRUFN
Q0FMTF9VRCkpIHsNCj4gPiA+ICsJCS8qDQo+ID4gPiArCQkgKiBURFggcmVxdWlyZXMgVk1YT04g
b3IgI1VELiAgSW4gdGhlIGNhc2Ugb2YgcmVib290IG9yDQo+ID4gPiBrZXhlYywNCj4gPiA+ICsJ
CSAqIFZNWCBpcyBtYWRlIG9mZiAoVk1YT0ZGKSBieSBrdm0gcmVib290IG5vdGlmaWVyLA0KPiA+
ID4gKwkJICoga3ZtX3JlYm9vdCgpLCB3aGlsZSBURHMgYXJlIHN0aWxsIHJ1bm5pbmcuICBUaGUg
Y2FsbGVycw0KPiA+ID4gY2hlY2sNCj4gPiA+ICsJCSAqIHRoZSByZXR1cm5lZCBlcnJvciBhbmQg
Y29tcGxhaW4uICBTdXBwcmVzcyBpdCBieSByZXR1cm5pbmcgMC4NCj4gPiA+ICsJCSAqLw0KPiA+
DQo+ID4gQ3VyaW91cyBob3cgZG8gdGhlIGNhbGxlcnMgY2hlY2sgdGhlIHJldHVybmVkIGVycm9y
IHdoZW4gIiBTdXBwcmVzcyBpdA0KPiA+IGJ5IHJldHVybmluZyAwIiBoZXJlLg0KPiANCj4gSXQg
ZG9lc24ndCBtYWtlIHNlbnNlIGZvciB0aGUgY2FsbGVyIHRvIGNoZWNrIHRoZSBlcnJvciBhbmQg
d2FybiB3aGVuDQo+IGt2bV9yZWJvb3RpbmcgPSB0cnVlLg0KPiBMZXQncyBtYWtlIGl0ICJyZXR1
cm4ga3ZtX3JlYm9vdGluZyA/IDAgOiByZXQ7IiBpbnN0cmVhZCBvZiAicmV0dXJuIDA7Ii4NCj4g
RG9lcyBpdCBtYWtlIHNlbnNlPw0KDQpTZWVtcyBubyBuZWVkLiBUaGUgY29tbWVudHMgbG9vayBj
b25mdXNpbmcsIGFuZCBub3QgYWxpZ25lZCB0byB3aGF0DQp0aGUgY29kZSBhY2hpZXZlcy4gRnJv
bSB3aGF0IEkgcmVhZDoNCi0gaWYga3ZtX3JlYm9vdGluZz10cnVlIHRoZXJlOiByZXR1cm4gMCB0
byBjYWxsZXIgYW5kIG5vIGVycm9yIG9yIHdhcm5pbmcgaGFwcGVucw0KLSBpZiBrdm1fcmVib290
aW5nPWZhbHNlIHRoZXJlOiBjcmFzaCB0aGUgc3lzdGVtIHZpYSBrdm1fc3B1cmlvdXNfZmF1bHQu
DQpJbiB0aGlzIG5vbi1yZWJvb3RpbmcgY2FzZSwgSSB0aGluayB0aGUgY2FsbGVycyBkb27igJl0
IGdldCBhIGNoYW5jZSB0byByZWFkIHRoZSANCnJldHVybmVkIHZhbHVlIGFuZCBjb21wbGFpbi4N
Cg0KQW5vdGhlciB0aGluZyBpcywgaGF2ZSB5b3UgZG91YmxlLWNoZWNrZWQgdGhhdCBpbnZvY2F0
aW9uIG9mIHNlYW1jYWxscw0KaW5kZWVkIHJldHVybnMgVERYX1NFQU1DQUxMX1VEIHdoZW4gVk1Y
PW9mZj8NCg==
