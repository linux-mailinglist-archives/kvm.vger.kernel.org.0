Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370A667D7D9
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjAZVii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjAZVih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:38:37 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275104A1F0;
        Thu, 26 Jan 2023 13:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674769112; x=1706305112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZI9qR3YLVBk9mi7fBfMQ0O/0bxJoCNU/ddy6/BCEAos=;
  b=BNUub/c6A1Kq/pjIbbk/yw5cboAlRtkM/vFWJOb0wiRGLZj4i15NlYYm
   k0ON/LSWdCR05TG0yNSVZldfyxLuYSFLvj4MvM7LS0hbhz8MY0nBjj+1M
   mxNETbnyoSVkAZ+tWG6EvyOv+QfbQM1TofyqUn9h7BUXfjBr3UXGzMpd1
   d2AV8zJPeZipL72+fWpzksKLc3n6AFphkWQQ6hC2DvPYQ5qaeKlyzHQ+Y
   zGeMnR0zOrUCrzb7CgEDAuvQEwjHCH4Bn5ooPYABxQFcG3Kq44O8v6NH0
   fICyXtUoLYCT4rmqVQ7XTo0DNOH0KNi5kZbRIM3ejxEOLqNO8R7lH4n87
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="324649174"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="324649174"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 13:38:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="663023625"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="663023625"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 26 Jan 2023 13:38:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 13:38:31 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 26 Jan 2023 13:38:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 26 Jan 2023 13:38:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 26 Jan 2023 13:37:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZXpf56ssUtcK+4ybn7VzZFAR95mgbf8VRCnjxz4hDUfUS2xzqIa30jJoMOgqTqPyWKUO+9SVDk1SmJzKxaqNpq6VvBr01uoL/EMsoFaw3oAJsXM6Y4BPK3CRDPehAcI/kkA1BAJBgO+JQGYpO8pkKrQZncBgEU8qbuZDMxbNoX15rSqti6U/lrCNp3Q1xDngkir0KyCh3JsBt/8XNcCYGmRamU8hKyvxpViYESspXBruSoEurCzt8toMy7m6vNDvrGTe5mw/ClscYanGRvn5WQzAD1OpCBcf8/BTkK8Ec6zdhzcETCmD8TQj8CoRODdH1JO1352IBuNYy9/twL2LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZI9qR3YLVBk9mi7fBfMQ0O/0bxJoCNU/ddy6/BCEAos=;
 b=M+mk0GEW6G+db89rJqR4f3Hyo1lFM4g0SXTZ+LWvl2f6RvQjyUpn5DXYAZIyRlDTQ44HJy1JaMCpiOfwqFSsdn2T70avmH0uLB9szl1lRB1Ni3I5XezEfn5foGfWUW/HIinL4DyL33zrtxuslx5X8ozadRlNPg7YjLQO9jrYnQM/011KjWV2e1aJN6gm1h5d6bmizSVNWn+ea+SxP0WbqJKHQE6v7ZjbJhOBjQ0QYHORVgsxtm4USncHsBH2rEA3H5XqX27SvSpIzlfmu+WmPlNq2trvUsh/n9p3wvkKMyBfuKhUDUGv1XiamdAdGhZVMJ/Vxhr+F6KoJq5nI+TiVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5807.namprd11.prod.outlook.com (2603:10b6:510:140::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 21:37:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 21:37:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Thread-Topic: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Thread-Index: AQHZJqV1Fh3JpFvqh0WhdDFjzbRE266u8GEAgACFbgCAAdmiAA==
Date:   Thu, 26 Jan 2023 21:37:23 +0000
Message-ID: <0be55c001aa1a538a02055aa244c655262228ce4.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
         <20230125112434.0000512a@gmail.com> <Y9Fj/vgPEzfU1eof@google.com>
In-Reply-To: <Y9Fj/vgPEzfU1eof@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5807:EE_
x-ms-office365-filtering-correlation-id: e2c941ce-6c8b-4bcb-582d-08daffe5832f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F9H13nz1bWy5vWGS7RWRmKMkxBbEwS1MBG6i9hVLAWSJnquBEKruLYkkEbojCigv1tpvILZIT1D4yNeM6LSd+mdaOTg671Ov25Xv37fTr4oGHJeFvF4XoS5YBs0EWHol+5MpssZQgwubBm1g+QLjHV8J1mpL3RUhBMUVnByiF7clyGgj9DefmbfpCyIPigPMJgIMtj8W9g3eH0pHFu/BwSexvwpE3VOF4piTo0bDXU6UcFmYHgHHLzXBih4VTXvIF63hN9Cy0PDppjLMuyL4YdtlBF9eTJl4C+rlpgwdFFaekItzMtXKlXF4L4/NiomsP62WSNRmM9onk1DKiAOZl5ZsMpODHZqSgHjHd8G8AP+xN3extrnvIMRvddtWyCBVWdWK6oDiuKBAWGQS7QjnfIU8QzqHApQ0JhScO9YNfOrmaU7mdSQR+9Jkc5eiCFnwc4aYaCOh4PeMsZlG5P8Vct4fwxQvAJgNw8L7iGjvnHnR8WzzfAN+/WioGBESwx7QZSgTnHU/dcrLJEeWY7YNb5nBXMcxA8AFkUR8zUXfArlvxlot0soqyQ9+4BZ+p6jQmbORTgAg1sf2ja9zNF8vq6amfLCRw6HTM1W1gXF1H60K4EQ+A4hBCv7eTsAWAGnal9N1zeE88DLV7HIb5A/4sKlHJCe41kC3V2xXP3FKyTksegxaWc6kM9H8QpZXxuJMtzxrJ760KWkkqvBMx34Ahw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199018)(76116006)(66476007)(4326008)(5660300002)(122000001)(2906002)(36756003)(82960400001)(66946007)(478600001)(91956017)(86362001)(2616005)(186003)(8676002)(53546011)(66556008)(64756008)(6486002)(71200400001)(38100700002)(110136005)(66446008)(83380400001)(26005)(6506007)(41300700001)(6512007)(38070700005)(8936002)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFR0cU5qdmIrdnNIeGFKUGNQMjhKOXRTWWplLzFEdUc2Q1dhMHZoWHdwZG1W?=
 =?utf-8?B?eFZtOUZ4L1F5bSt5b3UxSGpMbTRNaGo4bVhHK1ZncExqYW80N2pzbWpBSVFV?=
 =?utf-8?B?UmNEQ3BhdUYyMGhNaC9TZGxNdmUreldkVmNLZm9CK00xZERkbXBJMnlsNFEv?=
 =?utf-8?B?b3BDdDMvUzJtK2pkS2pnUDlDSTd5Y1NOR2RZbHVISjc2K3E5aWJQaVpyOWZz?=
 =?utf-8?B?N2c4TkEzVEZlN1dJZ2NZc2gxc09tNDlYUUJRdGtCVXQ4QkFLazBtQnZQWHdH?=
 =?utf-8?B?UmlVeDZ1MFlxWFkzck5kK2w5KzlNd3F6MTJsVVROeUFwa09HUWhqTlZzQnRP?=
 =?utf-8?B?UW9mV2k4eDhPOFJRcUxPZ2xzbDNac1J1a3N0TzdWL2hOcnlzdnYrWHg5RmlT?=
 =?utf-8?B?eVZHaHpKWG1tNm91Ly94NmVyYUNEN0NJa1dQVmI1MVBCSXdOTlJrNC9HbDgy?=
 =?utf-8?B?cVVCQnlxb0pVV2pCZGpCWG1NblB1UmpPYy9HSXJGZUtQZW16T2lzeER5bTcy?=
 =?utf-8?B?M25LR24rUmxKRTVmbEttS29jMFQzN0NYUUpxKzdNc3QvdEZzb1BZTWxuSTdD?=
 =?utf-8?B?aU1LSXl3N3ZDd3dUeW5saWIwbUtpaXROc1RDMzJpRUdoVUZPQ09GOEZZQ3FC?=
 =?utf-8?B?M1gzeUsrQU05T0dQSmI3TWpDNUxQeStmd21vM3RFcnBFeG9EeDFiVmg4djVw?=
 =?utf-8?B?NHVZaDJ5U3JzTVEwQkdrSG5OV2s1SVVyUy9SVForTEw1VExSZ0kwR3lDUTBx?=
 =?utf-8?B?UGlyK0hFNXd6QWRVSmRYYnVCZGlmOU5iVXF5TkxEYlRab3lyc1RZaHdMNE1s?=
 =?utf-8?B?NGpJc2VJdncrc0pmSW0zT01wS1poTndZaXJUaHdMU2FFaFE1ZkZGOEEwcXpl?=
 =?utf-8?B?NW5ob2E2aTFoeTVTSVU5a0dldkxBaWJYeCtwWGdPbTNWZzdtck9RY3EzR3Jm?=
 =?utf-8?B?NXg0TVFZdVRja1lyS254TEdqSU9WcUF4dG9rZTJpb3VidHRHTUxHaTB2UXlx?=
 =?utf-8?B?TjZ2YmdTc0lZRTVtZVkxVE5VZSs0RDdqd1o5OGJFbFl1MUdpZmlJeEtUMXdT?=
 =?utf-8?B?L28xUXF3dGdzOVpDTkY3SXgvKzV3Y2IwL3hMNVFObnllaHVnUnhNTDdCS0R1?=
 =?utf-8?B?Szl0bGJQdDlkeCs5Y3FRajlOQWQrRlphS2xMZC9lZ2xSMDVDT1l2cTFFK3NI?=
 =?utf-8?B?RThEVzlHanNWNUU4Q1YxS0xuNEI2TmhwUDByUFc2eTVRV0RqVTVJRlI0aXg1?=
 =?utf-8?B?SkFtbXg2NE1iQmJPNGE3K0NqSnIvV2RTL1hSbXlXcFNMZ1RIWGF6VGdHd1p1?=
 =?utf-8?B?Vk01b3Y5MEVSOFVZeGV4NndSQ1pEaTdVcGpMQW5abGlXK1k2YXE4QWhvT3Ba?=
 =?utf-8?B?U3hwK2dSZUgwRitucHNNM2NnTzlNR2dqM1VzWXhONi9uWnBmM0lPQ2V4cXlQ?=
 =?utf-8?B?Q2g5T05UWktkR1lYc2xlQVZMOXVpejJWQ3V2K0dmd3hBRWRhQzBNRXZHTW1Z?=
 =?utf-8?B?ZEowc2FEL2p6S0dCTkxrcG5TRnZZbkllaDV4QTc1TUVvMlEzMjBSYjltRDhS?=
 =?utf-8?B?R0JVT2NJSnVPTVprZlpRd09pNTcwTG9ZN3c5MkRtbkZvUmJKWTVZM2JoRERp?=
 =?utf-8?B?ZlhFZ2hFY1RsZm1wWFhLQ29BeXpUVUxtYTNuZDVzNlJJZjFkTUp4Tkw4TmdF?=
 =?utf-8?B?NkxJQnJkdXdOMTVGbURXUmY5Nm8rc2Vqa242VTRRY0xVdFoydmZkSDQ2RTEr?=
 =?utf-8?B?WndGWFNjdTVyS1ZWUFJsWXZQT29WaktkOVhuaW03c0QxTDhRT21pNmxiV2dw?=
 =?utf-8?B?NU9XdHZTZlYrUjd6WVFKbU1NdkdhZ3AvVjdYRlowQm8yQkNQTisyUkVaMURQ?=
 =?utf-8?B?blZjb0RMaGlsUi9PTFVxVTZjZHZaQkZuVDBjR0lGeHFWRXg0UHI0OHI0aG9G?=
 =?utf-8?B?WWZndjlvVTNZa0hLZDBNcFhGOGx3MHc4V08vTVpwSnYrR1BGM05oMGJlRlRH?=
 =?utf-8?B?QTZxcFA3N1BkNk8zd1J3SldHRU96L2NpdDQrSW1TZXIwd3dFOTlMbzJROHZl?=
 =?utf-8?B?bVlaYUFKUVZRVWZreEI2TW8wdzBIL2tFQUdoVGNuUVdKM0Rya3pIT0krZXlq?=
 =?utf-8?B?SnBsVTJaUjlRYktvOVNPczlsWmhRdkNmcnNrRnNndE9xWUd1V0lMeXdBb1Nx?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7458E7378963A841B3137803DC578F87@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c941ce-6c8b-4bcb-582d-08daffe5832f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 21:37:23.9702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /C/WCupTx1kQYsqX3UjNlzPwifdzl718qYehKbEaEmKpxmhIxtX40bknDBVtejNOeKKqdQOvZ3l4L9rCTE1Xzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTI1IGF0IDE3OjIyICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEphbiAyNSwgMjAyMywgWmhpIFdhbmcgd3JvdGU6DQo+ID4gT24gVGh1
LCAxMiBKYW4gMjAyMyAwODozMTozOCAtMDgwMA0KPiA+IGlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bSB3cm90ZToNCj4gPiANCj4gPiBUaGlzIHJlZmFjdG9yIHBhdGNoIGlzIHF1aXRlIGhhY2t5Lg0K
PiA+IA0KPiA+IFdoeSBub3QgY2hhbmdlIHRoZSBwdXJwb3NlIG9mIHZjcHUtPmFyY2gubW11X3No
YWRvd19wYWdlLmdmcF96ZXJvIGFuZCBsZXQgdGhlDQo+ID4gY2FsbGVycyByZXNwZWN0IHRoYXQg
dGhlIGluaXRpYWwgdmFsdWUgb2Ygc3B0ZSBjYW4gYmUgY29uZmlndXJhYmxlPyBJdCB3aWxsIGJl
DQo+ID4gZ2VuZXJpYyBhbmQgbm90IFREWC1zcGVjaWZpYywgdGhlbiBrdm1faW5pdF9zaGFkb3df
cGFnZSgpIGlzIG5vdCByZXF1aXJlZCwNCj4gPiBtbXVfdG9wdXBfc2hhZG93X3BhZ2VfY2FjaGUo
KSBjYW4gYmUgbGVmdCB1bi10b3VjaGVkIGFzIHRoZSByZWZhY3RvciBjYW4gY292ZXINCj4gPiBv
dGhlciBhcmNoaXRlY3R1cmVzLg0KPiA+IA0KPiA+IDEpIExldCBpdCBzdG9yZSB0aGUgZXhwZWN0
ZWQgbm9ucHJlc2VudCB2YWx1ZSBhbmQgcmVuYW1lIGl0IHRvIG5vbnByZXNlbnRfc3B0ZS4NCj4g
DQo+IA0KPiBJIGFncmVlIHRoYXQgaGFuZGxpbmcgdGhpcyBpbiB0aGUgY29tbW9uIGNvZGUgd291
bGQgYmUgY2xlYW5lciwgYnV0IHJlcHVycG9zaW5nDQo+IGdmcF96ZXJvIGdldHMga2x1ZGd5IGJl
Y2F1c2UgaXQgd291bGQgcmVxdWlyZSBhIG1hZ2ljIHZhbHVlIHRvIHNheSAiZG9uJ3QgaW5pdGlh
bGl6ZQ0KPiB0aGUgZGF0YSIsIGUuZy4geDg2J3MgbW11X3NoYWRvd2VkX2luZm9fY2FjaGUgaXNu
J3QgcHJlLWZpbGxlZC4NCj4gDQo+IEFuZCBzdXBwb3J0aW5nIGEgY3VzdG9tIDY0LWJpdCBpbml0
IHZhbHVlIGZvciBrbWVtX2NhY2hlLWJhY2tlZCBjYWNoZXMgd291bGQgcmVxdWlyZQ0KPiByZXN0
cmljdGluZyBzdWNoIGNhY2hlcyB0byBiZSBhIG11bHRpcGxlIG9mIDggYnl0ZXMgaW4gc2l6ZS4N
Cj4gDQo+IEhvdyBhYm91dCB0aGlzPyAgTGlnaHRseSB0ZXN0ZWQuDQo+IA0KPiBGcm9tOiBTZWFu
IENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gRGF0ZTogV2VkLCAyNSBKYW4g
MjAyMyAxNjo1NTowMSArMDAwMA0KPiBTdWJqZWN0OiBbUEFUQ0hdIEtWTTogQWxsb3cgcGFnZS1z
aXplZCBNTVUgY2FjaGVzIHRvIGJlIGluaXRpYWxpemVkIHdpdGgNCj4gIGN1c3RvbSA2NC1iaXQg
dmFsdWVzDQo+IA0KPiBBZGQgc3VwcG9ydCB0byBNTVUgY2FjaGVzIGZvciBpbml0aWFsaXppbmcg
YSBwYWdlIHdpdGggYSBjdXN0b20gNjQtYml0DQo+IHZhbHVlLCBlLmcuIHRvIHByZS1maWxsIGFu
IGVudGlyZSBwYWdlIHRhYmxlIHdpdGggbm9uLXplcm8gUFRFIHZhbHVlcy4NCj4gVGhlIGZ1bmN0
aW9uYWxpdHkgd2lsbCBiZSB1c2VkIGJ5IHg4NiB0byBzdXBwb3J0IEludGVsJ3MgVERYLCB3aGlj
aCBuZWVkcw0KPiB0byBzZXQgYml0IDYzIGluIGFsbCBub24tcHJlc2VudCBQVEVzIGluIG9yZGVy
IHRvIHByZXZlbnQgIVBSRVNFTlQgcGFnZQ0KPiBmYXVsdHMgZnJvbSBnZXR0aW5nIHJlZmxlY3Rl
ZCBpbnRvIHRoZSBndWVzdCAoSW50ZWwncyBFUFQgVmlvbGF0aW9uICNWRQ0KPiBhcmNoaXRlY3R1
cmUgbWFkZSB0aGUgbGVzcyB0aGFuIGJyaWxsaWFudCBkZWNpc2lvbiBvZiBoYXZpbmcgdGhlIHBl
ci1QVEUNCj4gYmVoYXZpb3IgYmUgb3B0LW91dCBpbnN0ZWFkIG9mIG9wdC1pbikuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4g
LS0tDQo+ICBpbmNsdWRlL2xpbnV4L2t2bV90eXBlcy5oIHwgIDEgKw0KPiAgdmlydC9rdm0va3Zt
X21haW4uYyAgICAgICB8IDE2ICsrKysrKysrKysrKysrLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwg
MTUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2t2bV90eXBlcy5oIGIvaW5jbHVkZS9saW51eC9rdm1fdHlwZXMuaA0KPiBpbmRl
eCA3NmRlMzZlNTZjZGYuLjY3OTcyZGIxN2I1NSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51
eC9rdm1fdHlwZXMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2t2bV90eXBlcy5oDQo+IEBAIC05
NCw2ICs5NCw3IEBAIHN0cnVjdCBrdm1fbW11X21lbW9yeV9jYWNoZSB7DQo+ICAJaW50IG5vYmpz
Ow0KPiAgCWdmcF90IGdmcF96ZXJvOw0KPiAgCWdmcF90IGdmcF9jdXN0b207DQo+ICsJdTY0IGlu
aXRfdmFsdWU7DQo+ICAJc3RydWN0IGttZW1fY2FjaGUgKmttZW1fY2FjaGU7DQo+ICAJaW50IGNh
cGFjaXR5Ow0KPiAgCXZvaWQgKipvYmplY3RzOw0KPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3Zt
X21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gaW5kZXggZDI1NTk2NGVjMzMxLi43OGYx
ZTQ5MTc5YTcgMTAwNjQ0DQo+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gKysrIGIvdmly
dC9rdm0va3ZtX21haW4uYw0KPiBAQCAtMzgwLDEyICszODAsMTcgQEAgc3RhdGljIHZvaWQga3Zt
X2ZsdXNoX3NoYWRvd19hbGwoc3RydWN0IGt2bSAqa3ZtKQ0KPiAgc3RhdGljIGlubGluZSB2b2lk
ICptbXVfbWVtb3J5X2NhY2hlX2FsbG9jX29iaihzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUg
Km1jLA0KPiAgCQkJCQkgICAgICAgZ2ZwX3QgZ2ZwX2ZsYWdzKQ0KPiAgew0KPiArCXZvaWQgKnBh
Z2U7DQo+ICsNCj4gIAlnZnBfZmxhZ3MgfD0gbWMtPmdmcF96ZXJvOw0KPiAgDQo+ICAJaWYgKG1j
LT5rbWVtX2NhY2hlKQ0KPiAgCQlyZXR1cm4ga21lbV9jYWNoZV9hbGxvYyhtYy0+a21lbV9jYWNo
ZSwgZ2ZwX2ZsYWdzKTsNCj4gLQllbHNlDQo+IC0JCXJldHVybiAodm9pZCAqKV9fZ2V0X2ZyZWVf
cGFnZShnZnBfZmxhZ3MpOw0KPiArDQo+ICsJcGFnZSA9ICh2b2lkICopX19nZXRfZnJlZV9wYWdl
KGdmcF9mbGFncyk7DQo+ICsJaWYgKHBhZ2UgJiYgbWMtPmluaXRfdmFsdWUpDQo+ICsJCW1lbXNl
dDY0KHBhZ2UsIG1jLT5pbml0X3ZhbHVlLCBQQUdFX1NJWkUgLyBzaXplb2YobWMtPmluaXRfdmFs
dWUpKTsNCj4gKwlyZXR1cm4gcGFnZTsNCj4gIH0NCj4gIA0KPiAgaW50IF9fa3ZtX21tdV90b3B1
cF9tZW1vcnlfY2FjaGUoc3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hlICptYywgaW50IGNhcGFj
aXR5LCBpbnQgbWluKQ0KPiBAQCAtNDAwLDYgKzQwNSwxMyBAQCBpbnQgX19rdm1fbW11X3RvcHVw
X21lbW9yeV9jYWNoZShzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUgKm1jLCBpbnQgY2FwYWNp
dHksDQo+ICAJCWlmIChXQVJOX09OX09OQ0UoIWNhcGFjaXR5KSkNCj4gIAkJCXJldHVybiAtRUlP
Ow0KPiAgDQo+ICsJCS8qDQo+ICsJCSAqIEN1c3RvbSBpbml0IHZhbHVlcyBjYW4gYmUgdXNlZCBv
bmx5IGZvciBwYWdlIGFsbG9jYXRpb25zLA0KPiArCQkgKiBhbmQgb2J2aW91c2x5IGNvbmZsaWN0
IHdpdGggX19HRlBfWkVSTy4NCj4gKwkJICovDQo+ICsJCWlmIChXQVJOX09OX09OQ0UobWMtPmlu
aXRfdmFsdWUgJiYgKG1jLT5rbWVtX2NhY2hlIHx8IG1jLT5nZnBfemVybykpKQ0KPiArCQkJcmV0
dXJuIC1FSU87DQo+ICsNCj4gIAkJbWMtPm9iamVjdHMgPSBrdm1hbGxvY19hcnJheShzaXplb2Yo
dm9pZCAqKSwgY2FwYWNpdHksIGdmcCk7DQo+ICAJCWlmICghbWMtPm9iamVjdHMpDQo+ICAJCQly
ZXR1cm4gLUVOT01FTTsNCj4gDQo+IGJhc2UtY29tbWl0OiA1MDNmMDMxNWM5NzczOWQzZjhlNjQ1
YzUwMGQ4MTc1N2RmYmY3NmJlDQoNCmluaXRfdmFsdWUgYW5kIGdmcF96b25lIGlzIGtpbmRhIHJl
ZHVuZGFudC4gIEhvdyBhYm91dCByZW1vdmluZyBnZnBfemVybw0KY29tcGxldGVseT8NCg0KCW1t
dV9tZW1vcnlfY2FjaGVfYWxsb2Nfb2JqKC4uLikNCgl7DQoJCS4uLg0KCQlpZiAoIW1jLT5pbml0
X3ZhbHVlKQ0KCQkJZ2ZwX2ZsYWdzIHw9IF9fR0ZQX1pFUk87DQoJCS4uLg0KCX0NCg0KQW5kIGlu
IGt2bV9tbXVfY3JlYXRlKCkgeW91IGluaXRpYWxpemUgYWxsIGNhY2hlcycgaW5pdF92YWx1ZSBl
eHBsaWNpdGx5Lg0K
