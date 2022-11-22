Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3716633157
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 01:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiKVAam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 19:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKVAak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 19:30:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7138C4C12;
        Mon, 21 Nov 2022 16:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669077039; x=1700613039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AzTG2pIGnc8JSAKNK+Qq1kUMfTJMVAz7eSkNo7srJJ4=;
  b=XEWf4m/nCExfnrz8C8DS6impKXdhRwugk3O+C2x5zA8Y/OS1+6P/Vq9h
   G+tFIrT4TY4a9NJU6EAlHfEICGoU7hHP3PrhJkQ5Gz+PSLvhuMXZqfJIe
   vVxscg1b8rMzDPQpNrtBJDM5smUyiGfZjvIgxOPQ2dYLTbPm8TIPNUTcG
   7aS1Nx7Itmn88Y4J+2k27VVlCQrnR2MQ2Oj+0zKiE6Xzm7//YSBCQC6fj
   m3jR72u6JJVzY5vChZ42gHDxu1kQvwPj5AlzvgbiMYzukOM2kAHMPuTPX
   RSxXwovhdKLvyx9jnQRNEOZccRCNkzkO3jbDbFOBdSvbHVU5wq5/hnb7F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="315515447"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="315515447"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:30:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="886322110"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="886322110"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 21 Nov 2022 16:30:34 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 16:30:34 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 16:30:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 16:30:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 16:30:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Naasop4oL0sni7tKu+GHUqyZBuUKn2d6V+chCZQEztmdURCCzvaORGgD0G7TMAvpHNHWTWQdAI1sRygvPitC5mmlU5zm8XgAJDLJH71tctYLwikvcgr/KFmDIJkIAfN4l3uIDqpFheDd+FrkNe24ggPq44H0/+xm8ot53uA5nDuhvupOufNUOKlMfoU3gCS5Wbvbhgee1xsVd35J3A3sTB7X+YALB5SKCRxwdDy6//1gs8WNJ1EgZoNdOnitgwavC8QjpaErhqRBPyDPATVcQ0KIAonhKU7R5dZC1APW7iCE/jYMusz/ZGwkbZ4tvPP9xjyPe0S7TudRnw32S6DpCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzTG2pIGnc8JSAKNK+Qq1kUMfTJMVAz7eSkNo7srJJ4=;
 b=LEgh09c/84Klhn+FzLT+Puap6f9XmHTItBlwbHvpFMyBtBKfR/lHvp0G2Tv92Sr6aW6xE8bLVd1quwqiCSdmtfmt7tAqDtR5SlXsO1jH5QA/QOUcwM5hHP3eSTYPNdJDfdXU/NRfuLLkpkSWVUFaOd2OObu+nBuqL7xpcIOD50qmo1m7AJ75Zdz38dcf8nl0yrSq2SvgAr3Zd6AUukCZyTIa5YdUDrDznpoVi2+5hfxU+sw1H4J6GsHY8jtTmUiQdNsdMcgSER4WLrPE7hs6D9N302NPlyWHaXUbpmIqb4Q/3bVGzmKlfBYwuwQbf7BLxk9T9e7hV4kWWEm61iqcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO6PR11MB5570.namprd11.prod.outlook.com (2603:10b6:303:138::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 00:30:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 00:30:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
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
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Topic: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Index: AQHY/T2/qiNrCEbeGka7t7fkot0Cyq5KDH+AgAAMRIA=
Date:   Tue, 22 Nov 2022 00:30:30 +0000
Message-ID: <f9918596c4013444428899aca2cfa73b1f18c703.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
         <87e17024-755d-e195-d9ea-ef62a4de6aa8@intel.com>
In-Reply-To: <87e17024-755d-e195-d9ea-ef62a4de6aa8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO6PR11MB5570:EE_
x-ms-office365-filtering-correlation-id: 12c2b05b-3b96-41d0-5fff-08dacc20c317
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EktdEJ4cj7szgeaMFiDbwdlMG7OZRVv3/G11tYQkuy+CQtyN2faB7bXUSbtWAB04r/aY83TNdOJ4YySaeVm68LDS4cTttClB56qDop/1wFacrpasSw6+XZlM1kws+I3YkrMepTOBUGtEecg3+7SudVTacjomBVXkHGkl4CPsFFjsjWxFRaLBhUXEELBLXe3+Hyn8w3Z0Fft4Gsr+Ml6gr/laJ+T6hy5g844+xZFfDRk/OKt6DKDprJqzp7+7iMmLOglTiatB94MG5ct9Emr7aff2GKJqA543MSzIYExBla159VvC893WNYE28aAZRhyRg+fCz+FJKna+CAU3ezN13LfjcM878eaE9QQck3osJZrOrUHnrSkfVFQ1VlWkCRLiFnE+enyHfsp9jN0NVMTWupqMKh3CeyjPG+ZPjza0HE8AyDNgtBby/pSm3waqzBSGmIahqy6QPz7kqeM+eMoNjIuUX9nqZ2El9nEdtee5/0X0BzkieWNprT/2QtkAddfbEWJ62g5bxTG87m38116RnqE0N+38/JOCflkJ0kiU17McsiLZFuqqCJiWRrwKaW+uj6QH1rttOybYEjITMqvXY5Xxdy1xCA7+Hepiu7Mkxa30QPitomcpcodxveV/xeb191NSraV29RNM7DqNiLSCXHVnqdseUmPfFA7MYY0DRB/tbMD98NxTC79VmtuJfIyzedBOFEraB1dcnPGo8cEMf7u3cj8hEtXgezR+WTf2gDg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199015)(2616005)(53546011)(26005)(6512007)(36756003)(186003)(478600001)(4001150100001)(2906002)(966005)(6486002)(6506007)(38100700002)(122000001)(82960400001)(38070700005)(83380400001)(4326008)(86362001)(76116006)(66946007)(66556008)(66446008)(64756008)(8676002)(66476007)(91956017)(41300700001)(316002)(54906003)(110136005)(5660300002)(7416002)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXY1SFNjak1ENmJRbnRrL2p1L2RTYWV2RjFkN0thTktDcUNIZWIzbDhTeXRh?=
 =?utf-8?B?T0NzZEljaGlnYmJqdmxYa2VCUU1LbDlBRGkyK0Erb0hlUjA4SEkzZmR0MXY2?=
 =?utf-8?B?REpWUWJXeFUrTitiQXVRb2FnWkJ4MjlPemNwM041MEI0VXNIQ1A5VWdkMmNl?=
 =?utf-8?B?VG81SmxQa3JWVUw5NTRucXRTK3B1dE9GSVhadW1ER2hldEFOU0pRc1JYajZI?=
 =?utf-8?B?Sy9VeFZScXpweHpSajRXOXBxUkw5M1RPMWllN0RlZnlxcXkxQmNtSm1sY2Vl?=
 =?utf-8?B?ZmpGZGhMZ0pwZVpNS3FQZmZzcDlKcklmczV1bUtma0hrWTBrVEV0Ky9JUURN?=
 =?utf-8?B?ZzhHRjVMazAvemJBdTJVazZvcTdOMEtMU2JpdWpnTno4MTBRTWhiUC8xNTV2?=
 =?utf-8?B?aTZKazhJY3VTZ3NuN1BvQXpWZngwSC9kcThzV2Raa0NqQXVrWm1MK3FwUVlB?=
 =?utf-8?B?UWlhVHZKMDVsSkx4clcxU0NCRzgrL1BUWmFzdng2eVV0VXhxTkdsSU1jcitk?=
 =?utf-8?B?d0duZDQrbHRRb1BSa1d5YUVmVzRNd0dPbEV3RWhpZ25KVEVmdmgvVlFPT2oz?=
 =?utf-8?B?ZUFDL3pRNjJkbVVRUUdBMFFDdmVjaUhSVUJLMnhoNXRjNDlzcVJvaXk0R3JM?=
 =?utf-8?B?NldIeWZLN3FUWFVLL2dzVHc5U3dDM2kwQm5pSWhWMW9URUNTUEVKcTlML0Fi?=
 =?utf-8?B?ZUh1ZkFaWW9KdkZvU0lqbFIySm1FcEdIeVBUZDVPelNSbUNtZWpneENrT0hU?=
 =?utf-8?B?aDlBdHg3UmNuS2dqb0pkamQveUNVb1BXNmQyeUFQQy8vVjdrOTh3T2JQc3dP?=
 =?utf-8?B?dzVQMCsxOWZlY3RsdStPNWxRZ0RhbUFYM1FicmhFVlhRUGlxZXpVb3hrQUN3?=
 =?utf-8?B?c2xIdFp1Tmk2bXpTbDYwbXR4RXNlL3RXM3h0anJQSnZOeDJrSEJiQ1YvZFlz?=
 =?utf-8?B?VXAzL0k2RXpOS2IydHE3Y01CNWl0elpyZWFidko4MGw3bjJaSGJZbGNEaUVS?=
 =?utf-8?B?UEdpN1VNZXZtMWYzemVDc01TRUhFYjNTV1BxUk8vQnJFNm53VG5RK251NXNi?=
 =?utf-8?B?MGpNM2ZFWC90ajZ4cWRZTDZPOTZOUkdyM2h3eHhzVTF5eFBac0t4NFBGbm16?=
 =?utf-8?B?WTZ4cFRtUTUrNWFtdklNdzR0OVhsd2RINHdFZWhoeC96TllpKzZmS05jNVFI?=
 =?utf-8?B?cTN5TTZlRkhlK3NmRk5QbCtPaDlGQUpBVGJDNGIrc0RmRVhFdTFMUjJrVm5I?=
 =?utf-8?B?S09RT0JFeUNmcjVGaDE2UFhjYlNOY1ZpeGV5Wk5aUXMzcnNLS2FnVzBhaVpO?=
 =?utf-8?B?QzE5UXd6TU56VEZKNllCNVBHMGppem5qcGJ5bjJqdFgyVUlPcTBFbWVHN0xX?=
 =?utf-8?B?YTBMSE53YUowVkJwLzJVTlNLRStvalBIeGx4b2w4MkdmcExwcmdIWGx0alY1?=
 =?utf-8?B?Sm9QTVJrM3ZlWlBlYjBTSDNMT2Yreld0VnRKc2dYVGVNaXhNOXJoUGNhNFBF?=
 =?utf-8?B?OGF5NExyTEdZUHN2OW5ySWN2QnNoelU1WStTZ3d6aGFHcnFScUI1dWtQVWVR?=
 =?utf-8?B?T3FUVnZ0NnBnSkdqL0Q0MkxPUFFFazNLak5xWC9rUnVYdzhRMmNhWEhLZGwv?=
 =?utf-8?B?eVNQdE04YUxhWUhBOU8va0RLNkNxVkVPQnJ6MVZnK2h2MWU0a3pRbzZkWmNZ?=
 =?utf-8?B?ZGVrSDlQajc2SlVXZDNNamZQK2dpRWp4RjNtQ1FXNXByMUE2K2Y4bmlnWnZP?=
 =?utf-8?B?Q1RRa2p1aFV4N2tHUHMxTnQxZlc2VU9qQjZlVHFydXB6YmNFam5tbEJncFFz?=
 =?utf-8?B?YnZsN2gzTUkxOGF1bWpaNy9PVUdjQVRBT05rSzdYc2RwRVM5ZjM3SCtLenNu?=
 =?utf-8?B?ckdjNnhuV3ZDMmQ4dFVHZUVkV0tocHZBZ2dlWDAzN1pjOXBDV1Zwbk41bEFK?=
 =?utf-8?B?amx2Ny9WbVBxeWZJWnlrRU5JMkZPcm1sTk5aOEpWL0dUb09lU0VpbnRORDE1?=
 =?utf-8?B?eFQycDA3QTd4VUxmZytkSXFQOGhiV1lKTTJRKzZDK2JhdHduVkI3L3J6QTJ1?=
 =?utf-8?B?dXVZT3BML2RiR0xBS1FRZ2cyYVdQQUtoTVJCemh5RENJZzdTQUhzMUlCZnMx?=
 =?utf-8?B?MFRPZDNLNWU4Yi8xcnV3cWxrbWZTUnVlTVhPOEd1NGNHQVVreW1aYUp6SWtW?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7467893DBB91C74CB72A3BF00080311D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c2b05b-3b96-41d0-5fff-08dacc20c317
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 00:30:31.0142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4a+zyY4D1c6FIQp2W/R+MMG2BECnxxDiz/sG+2Ouu+bNTQjnwuk/kRvpC4ctTn5uWzaMInNoXoyfp+2QwkpS2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5570
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTIxIGF0IDE1OjQ2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjAvMjIgMTY6MjYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBUaGUgTU1JTy94QVBJQyBp
bnRlcmZhY2UgaGFzIHNvbWUgcHJvYmxlbXMsIG1vc3Qgbm90YWJseSB0aGUgQVBJQyBMRUFLDQo+
ID4gWzFdLiAgVGhpcyBidWcgYWxsb3dzIGFuIGF0dGFja2VyIHRvIHVzZSB0aGUgQVBJQyBNTUlP
IGludGVyZmFjZSB0bw0KPiA+IGV4dHJhY3QgZGF0YSBmcm9tIHRoZSBTR1ggZW5jbGF2ZS4NCj4g
PiANCj4gPiBURFggaXMgbm90IGltbXVuZSBmcm9tIHRoaXMgZWl0aGVyLiAgRWFybHkgY2hlY2sg
WDJBUElDIGFuZCBkaXNhYmxlIFREWA0KPiA+IGlmIFgyQVBJQyBpcyBub3QgZW5hYmxlZCwgYW5k
IG1ha2UgSU5URUxfVERYX0hPU1QgZGVwZW5kIG9uIFg4Nl9YMkFQSUMuDQo+IA0KPiBUaGlzIG1h
a2VzIG5vIHNlbnNlLg0KPiANCj4gVGhpcyBpcyBURFggaG9zdCBjb2RlLiAgVERYIGhvc3RzIGFy
ZSB1bnRydXN0ZWQuICBaZXJvIG9mIHRoZSBURFgNCj4gc2VjdXJpdHkgZ3VhcmFudGVlcyBhcmUg
cHJvdmlkZWQgYnkgdGhlIGhvc3QuDQo+IA0KPiBXaGF0IGlzIHRoZSBiZW5lZml0IG9mIGRpc2Fi
bGluZyBURFggZnJvbSB0aGUgaG9zdCBpZiB4MkFQSUMgaXMgbm90DQo+IGVuYWJsZWQ/ICBJdCBj
YW4ndCBiZSBmb3Igc2VjdXJpdHkgcmVhc29ucyBzaW5jZSB0aGUgaG9zdCBkb2VzIG5vdCBoZWxw
DQo+IHByb3ZpZGUgVERYIHNlY3VyaXR5IGd1YXJhbnRlZXMuICBJdCBhbHNvIGNhbid0IGJlIGZv
ciBTR1ggYmVjYXVzZSBTR1gNCj4gZG9lc24ndCBkZXBlbmQgb24gdGhlIE9TIGRvaW5nIGFueXRo
aW5nIGluIG9yZGVyIHRvIGJlIHNlY3VyZS4NCg0KQWdyZWVkLiAgQWx0aG91Z2ggaW4gcHJhY3Rp
Y2UgSSB0aGluayBpZiB3ZSBkbyBzb21lIGhhcmRlbmluZyBpbiB0aGUga2VybmVsLCBpdA0Kd291
bGQgcmFpc2Ugc29tZSBhdHRhY2sgYmFyLg0KDQo+IA0KPiBTbywgdGhpcyBib2lscyBkb3duIHRv
IHRoZSBtb3N0IGZ1bmRhbWVudGFsIG9mIHF1ZXN0aW9ucyB5b3UgbmVlZCB0bw0KPiBhbnN3ZXIg
YWJvdXQgZXZlcnkgcGF0Y2g6DQo+IA0KPiBXaGF0IGRvZXMgdGhpcyBjb2RlIGRvPw0KPiANCj4g
V2hhdCBlbmQtdXNlci12aXNpYmxlIGVmZmVjdCBpcyB0aGVyZSBpZiB0aGlzIGNvZGUgaXMgbm90
IHByZXNlbnQ/DQoNCkNvbnNpZGVyaW5nIFREWCBob3N0IGNhbm5vdCBiZSB0cnVzdGVkIChpLmUu
IGNhbiBiZSBhdHRhY2tlZC9tb2RpZmllZCksIEkgYWdyZWUNCnRoZSBjaGVjayBpc24ndCBuZWVk
ZWQuDQoNCkkgd2FzIGZvbGxvd2luZyB5b3VyIHN1Z2dlc3Rpb24gaW4gdGhlIHBhdGNoIHdoaWNo
IGhhbmRsZXMgIngyYXBpYyBsb2NrZWQiIGNhc2U6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xrbWwvYmE4MGIzMDMtMzFiZi1kNDRhLWIwNWQtNWMwZjgzMDM4Nzk4QGludGVsLmNvbS8NCg0K
SSBndWVzcyBJIG1pc3VuZGVyc3Rvb2QgeW91ciBwb2ludC4NCg0KUmVhZGluZyB0aGF0IGRpc2N1
c3Npb24gYWdhaW4sIGlmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHksIHlvdSBqdXN0IHdhbnQgdG8g
bWFrZQ0KSU5URUxfVERYX0hPU1QgZGVwZW5kIG9uIFg4Nl9YMkFQSUM/DQoNCkhvdyBhYm91dCBz
dGlsbCBoYXZpbmcgYSBwYXRjaCB0byBtYWtlIElOVEVMX1REWF9IT1NUIGRlcGVuZCBvbiBYODZf
WDJBUElDIGJ1dA0Kd2l0aCBzb21ldGhpbmcgYmVsb3cgaW4gdGhlIGNoYW5nZWxvZz8NCg0KIg0K
VERYIGNhcGFibGUgcGxhdGZvcm1zIGFyZSBsb2NrZWQgdG8gWDJBUElDIG1vZGUgYW5kIGNhbm5v
dCBmYWxsIGJhY2sgdG8gdGhlDQpsZWdhY3kgeEFQSUMgbW9kZSB3aGVuIFREWCBpcyBlbmFibGVk
IGJ5IHRoZSBCSU9TLiAgIEl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0bw0KdHVybiBvbiBJTlRFTF9U
RFhfSE9TVCB3aGlsZSBYODZfWDJBUElDIGlzIG5vdCBlbmFibGVkLiAgTWFrZSBJTlRFTF9URFhf
SE9TVA0KZGVwZW5kIG9uIFg4Nl9YMkFQSUMuDQoiDQo=
