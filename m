Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B13670C36
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjAQWzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjAQWzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:55:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA2258995;
        Tue, 17 Jan 2023 13:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673991732; x=1705527732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7ix15nMC2U1zfELvP0lVrV1RJFnBb48TEaInAoltv4Q=;
  b=BlY2Ds3BlkgXNXIS3BeQnE9YwDA5eqrHnQQ2nBOvJjnx9o7fK1P84iSp
   JSGBSe24gJkw29OnEz2FHpOn0hHSr59OlU5futGGXp/hthqIdIQn3sErz
   Pvoy8KJlRGEvSZsxgDUIATD5tab6F0++EFI0chm0sLAgbAO+YBveDH8jP
   ipWMOjn8/36HgWWn3odfaN9C/R/ndQ7P++ju8E9KvnRtgHwEUOxhvnuzN
   lq0f5uPBNhS7sZ8d+JtZRU0jyCM+3PCzSmxVbhYw65zX2IZoP3j/9Tiie
   /fI9dcbqDVE6TENZwBm4P5p8GQSZ5lgQQBJGuqcLndA0rmTaGxbUq9KKn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="312697061"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="312697061"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 13:41:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="988286554"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="988286554"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jan 2023 13:41:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:41:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:41:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:41:32 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 13:41:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0CuDWKBT143Mq6X47PGJzuq0uON39Zj5ZqGN9QYzsXnhY8SHpGhJathdwxYdyjTDcsW/Qk/PchzKga0C3+QxW5SYAr5pLYBns1sbwkQJ2oAYvMHRFF0/YwEcyHIVJSHuxwb7VLMSWnCFiOkOiUh0rNfKwrpSWqBYTw/cLWebmSW53zpBF1d5lTuroc23JAz2DxuMfTGmzeC07+fUiuqjH/bc6Yh8VdTEOuTCUqWmaKrUQRNkCvEL69e4NGlz0AOLH7R86dhMGN16oBOwY3oqtF825QpALOlVVLGK4dH/e9eZFdYlUhc8CKGgij8RTguiVzc/v6cqnCJ1ihYYoVNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ix15nMC2U1zfELvP0lVrV1RJFnBb48TEaInAoltv4Q=;
 b=kIIdy1wEIKjSxwIWZXg4eYmV7v1WIZ4cOzuNEysFUzcgcE97QfKlf5dYJyGovuzJ4QaD+OrSQLUJGh41Ch9K5BXt3vDeRl7cI/ZJwoSG36RdNQz6Jr64qdLka5zHh5N4U5Xkuhm+opoyFSoL1UWLmVfAGGXnMdY1pwtmswoJwvYuMT73zQhf0Rul36Q09pa2bzH0Oq9uNI+KRUjP+C7so5AEk9I7y5QZXBqLDP9LpuKLUGKm+Muh5vQpafrggkcgSTHQraULiX3GqFHx3OPl4itsmULtLBU4Jsh2Jp5lPTApzh4NStko92X7IjzIimuZtri/I9/hWN5ppZ9b8jwsmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4786.namprd11.prod.outlook.com (2603:10b6:303:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 21:41:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Tue, 17 Jan 2023
 21:41:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v11 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZJqUCdrDuDjzxh0a6CQQT8apxmq6cSMQAgAaEbQCAAF5pAA==
Date:   Tue, 17 Jan 2023 21:41:27 +0000
Message-ID: <e29642ea59d25d60d35c082d5772f644b41692ff.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <60c842f347eaecdd0673bdc63acd95b82eeeda9c.1673539699.git.isaku.yamahata@intel.com>
         <20230113143158.00006ca5@gmail.com>
         <20230117160330.GA2959778@ls.amr.corp.intel.com>
In-Reply-To: <20230117160330.GA2959778@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4786:EE_
x-ms-office365-filtering-correlation-id: 8795a9f6-08d3-4f3f-58e3-08daf8d3967b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bsA3sYREH/40oygr00lNedVLJ35NnzD6t1VUO4Dx4gQjRaJZFZ8Um4iYbPFon8ignKb9XT9ZLUX2yc9KsK2ZlBAKLOJSajN0ODuEgusvbDgSMDF0E6N5aa971TiWaMTmF7mrStLUiJgCp2TVmxqu20N4ishUaycwV7w3A4hE2O/vEq61F/bIgGNeZ/mxNqUT2KLg+ubB2TLWMh/h0T2aE/o33TM8QrBO/sv08hry4TxB6SFEE9rmlx/asInqF18uVKZKGdIbpvgSPz5meg41v2Ga81Y1YiGyyuLz91LQdW7OX05v+ciQFxjBwzXcJOUnZTV6elxTKbVb99R1SjeCFiJBQ5hhoQOurrSxElB4Ats+aAowJltou4wdfOviSkYIKSwEbM08T8NBgLQJigjNjEOTqvamCWNwiCRMwjtQkJ2+rNzURPKoi0dJan1yBzKcofJxjdvhX3rZ0EIEkLNWnKUX7zEM1sPgHWeeUp69LnLA7OaUctqOcn6/ldps/c0brfBN5Q9DxjaMbcGO1yQeT4GPRuXHloz4ECp+1ZF0R6uBsBEGug8l5T25FOMvRwiF6SSbwd4qJMZjUTK4xTRLSeUnJdMEbH0eC8zQdBb9/1ChFFHjkEpMWzmJth+ouBe4+nTJBNciXP8iXAX+ui7NVZCJr3KOXyMTh8Qi3+ZMrUnxhYH0BhQbkc6hs0tH16cZ0Z5cVR0/RsvVFtuYaER3hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199015)(91956017)(64756008)(71200400001)(66946007)(66476007)(76116006)(6506007)(478600001)(186003)(83380400001)(6486002)(26005)(66556008)(6512007)(4326008)(41300700001)(8936002)(5660300002)(4744005)(2906002)(38100700002)(8676002)(66446008)(122000001)(36756003)(82960400001)(38070700005)(316002)(86362001)(2616005)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1Ayc3dEcUNuaU5rY3BNaXNWUmEwOCs2dldMMHJkUk1LdnRKMjNDL1BHcENI?=
 =?utf-8?B?S1JPVkF3OTlQYzJTblc1VDNuc3piTXdMV1lrRTFFTUxIL3Q5RDA3M1Y0TnBL?=
 =?utf-8?B?NWNjbVdLVEpsM1ErdXJVWEhGZ2d4RnN0eXBzd000bkNuOU1kcG9Hdm5kN1hX?=
 =?utf-8?B?YW1SaFI0ekJ2TnZCWEtJNGlSd0s4MCtLY1ZDbmtwUHJ6OXh6dUI0MHkvZGZr?=
 =?utf-8?B?ZDg4MERXQmVUcUNBUGtKWkxLWVcwb24ycVp6V003OTlHR3I1VjFra2h1STNy?=
 =?utf-8?B?ZS83QXpKL3pmQVk0a2U1M29yZ0t4ZGNVMDlQOVp0VllHWnNqMThjZ2hyT2ZD?=
 =?utf-8?B?TC9FRndvUEpIUHRjL0RPSEFjNTJidU4vMjBqSlMzWm9oUnNoem5XSDRCenJP?=
 =?utf-8?B?L0dSR3Q1VWtrT2c4RkV3THk0aHZaVVZzTW52RHBUbmRRN1lqYXBmVWRiMDJY?=
 =?utf-8?B?L1dZNElMMCtIVDhNSW1XYzBPdWw4RGZNTFVhc2RESWNUZ3NwOEFuc1dnc1p5?=
 =?utf-8?B?KzJTcmRvdEJyZEk0YlhQMUE2VjBqSDdOVzNIc3RkVFlteGIvZzlGTGVxWTJn?=
 =?utf-8?B?UGpPajVEWnpUTVdGazRzbEE4N294QUJaTFZVMHBjZkY2T0dFOC93OEhIc2dG?=
 =?utf-8?B?QWt5VlVnZmVNVlpmT2dkMmlvWHJjTWU2TlVNVko0V01MR3Jkc1VhQWx2NVhj?=
 =?utf-8?B?OXdwNzJkVktFR0ZkZm1qOVdVMEhXRHlseTJIbnJqc0JlcC9IM1M5WHgyS2dW?=
 =?utf-8?B?TXdjWm15R1pEcHl2M0dCUUtLT0E2Y0pjQnlzRjQ2ZnlPQjlFamJoU0V6aWxY?=
 =?utf-8?B?bTdIVW5OTEJKOUhNWVp0Ty9hbVRQSmI0NUxVbDZSNUlpK2NKNjdpbHFjb3hu?=
 =?utf-8?B?Y21MWlhOdDF0dUMwWktnUmp5UUM3OWxtemw0NnpHQXNFU2FuY3czZ2xsRTcx?=
 =?utf-8?B?bHFxYkw5Y1VDV0E5LzJmemJEYTFLVmZBS1p5MzRXZmhQVWFQV0NQL3FrM3Ry?=
 =?utf-8?B?QTd0WERPUjlYWmdrekprb0J6dGNFUEJQcUhxdlZKaU81RlVzZEpHb0RYZTBp?=
 =?utf-8?B?Mmo2NjFha1cxSGVaMEl6QTJYeUtyV3pnU3RIem12Tll5endXRVNxT2lReno4?=
 =?utf-8?B?VmJsSVNqVDduNVNhN3lKNlIzNFJXY1FsSE5FSjF6R0FlZ25yUXBQTzh1dzln?=
 =?utf-8?B?Z0R4L0c2VTM5c1o5MlBjSE85YlBtZEFubHJ2Z3MvaVhBRXJBb3lrWk1od0J3?=
 =?utf-8?B?ZFVETTRCUExzS0tBc1JUckRvbGFTS2pFL0VRckRWNnROSDYrNEJRTGVrcHQx?=
 =?utf-8?B?cUorblBZU2t4TEUvS1g5WVpjdDZYbG0zR3REeDZVSWNLVVZjTUZPbGVUeXlw?=
 =?utf-8?B?L0ttOHQ4Z2s1aWRIaHJzUlhLeG5VWS9rVWdubCtWcEdJREFVbXhuUmdmem52?=
 =?utf-8?B?NDFYajlHS2xBUE5zNVY4OWhUOFlVN2tTRlJ1YnZJMTVrU0pEUWI4RkZHZGFy?=
 =?utf-8?B?MlNsTGRENHV4VzVsNlBuLzFGZGZPVm9VVEE5VmVYS25FRm9QR3dGOVB4RzBi?=
 =?utf-8?B?cEg1cklDV2FUY1VWcE1kN0NhTE8vcFNaSFQvdVlKL0dzeVM3RDNKTDBYUDdZ?=
 =?utf-8?B?WnhYajJnc0FKYWozbEtiVG1jNWVTUERqRkg3c3NSbkxRWVE3WVJoQVRTTkdn?=
 =?utf-8?B?M0JCT1ViQ1dIUGZiVFdoRWhOajRIeHhTK1RqeGE3TStRRjVsc3NYQm5WSW5R?=
 =?utf-8?B?UGdwRlAxeml3QXlyTnE5Z0FhY2NwMlF3dFVoS1NER1VoUFp0YWw2UDJobU11?=
 =?utf-8?B?V2srd21vRXVkejFwc2R6WGhLc28wRnlyN0YzV09pWUszeUkva2JOeTJUSVpj?=
 =?utf-8?B?bit1VmFhanRNOHl0RksvcVBFSmpwWXRUcGlLbXRjaDN3T29iOFJWeWJ2bEE3?=
 =?utf-8?B?b1RObkRZSDgvTUQrdGZiQ0o4a3BybHJWV2VJZVdzeS9URmYxeStFTnlSc1hs?=
 =?utf-8?B?bC81QkFqSk9adFV3OEljM1JDYlFoTXc3MFc0ZTlPZWhUOUc4RE15V3RKQVVa?=
 =?utf-8?B?T2VGQUl1ZTFqTTFmZ0pxbkhDaU83M2pCMjAyMndGVVN5bkFIZjJwNzBOdzhi?=
 =?utf-8?B?YVlkY2FYdW5OeEx5R0k1MHFBNWZjcm4xRG00ZzQvaU9RZUJTV3hnRVNEN2F2?=
 =?utf-8?B?c1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F597F497A9DBC4B8AD55F91BE55D3C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8795a9f6-08d3-4f3f-58e3-08daf8d3967b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 21:41:27.2175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: erH3vcMVk/h34rpMxNGQi6vx8u+0ON6Rbj8iEKQfX/Xa0eFQ2zORS9JB9+AbpceKsivdLtozv/yD8NaKvorDbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4786
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTE3IGF0IDA4OjAzIC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBCZXR0ZXIgbWVudGlvbiB0aGUgdGR4X2VuYWJsZSgpIGlzIGltcGxlbWVudGVkIGluIGFu
b3RoZXIgcGF0Y2g/IEJ1dCBJIGd1ZXNzDQo+ID4gd2UgbmVlZCBhIHdyYXBwZXIgaGVyZSBzbyB0
aGF0IHRoZSBjb21waWxhdGlvbiB3b3VsZCBzdWNjZWVkLg0KPiANCj4gVGhlIGNvdmVybGV0dGVy
IG1lbnRpb25zIGl0LiBJJ2xsIG1ha2UgdGhlIGNvbW1pdCBtZXNzYWdlIG9mIHRoaXMgcGF0Y2gN
Cj4gbWVudGlvbiBpdCBhbnl3YXkuDQoNCldoZW4gdGhpcyBzZXJpZXMgaXMgbWVyZ2VkLCB0aGUg
VERYIGhvc3Qgc2VyaWVzIG11c3QgaGF2ZSBhbHJlYWR5IGJlZW4gbWVyZ2VkLg0KDQpZb3Ugb2J2
aW91c2x5IGRvbid0IG5lZWQgdG8gc2F5IHNvbWV0aGluZyBsaWtlICJ0ZHhfZW5hYmxlKCkgaXMg
aW1wbGVtZW50ZWQgaW4NCmFub3RoZXIgcGF0Y2gvc2VyaWVzIiBpbiBfY2hhbmdlbG9nXy4NCg==
