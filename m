Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2535958F1F8
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiHJRxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiHJRxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:53:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670731FCE5;
        Wed, 10 Aug 2022 10:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660153989; x=1691689989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VC34lASvZLdATXb8w7IzR+cOBD0CgQRxTHSePPx769c=;
  b=efEf67726wj/2MzTtL1RGBYkmVIomm6OG0WL26Hn8BDkzkboUNhpAnGn
   b/EIGgjdAcwu5eHeZHIU/XXbouSu5R+q09CmunWqO+1bCoqnT1k3a5Khe
   ZQTn7pPCLK/KSaJavpRtqSrwmz/S3n6G+otQmuVfg4QddauP8G4bkEdrB
   ZR0BqhsPqkc8hATFyht2VuSV9j0DDSYCN5rEYZQZ4Xp7jUtBcUbo7zjZ7
   lWQc06SyWd0dWmsPzPjnLcujROZCs+v6BK2hl6KWlJZnMef0P1zcNaTC4
   au1Y4fSaKVmKOv4rnSDA0rKTB63tiA8yAvy3gmXqxxnM6AZYh1Ey9wg/U
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="352889947"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="352889947"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 10:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="673378820"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 10 Aug 2022 10:53:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 10:53:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 10:53:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 10:53:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 10:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8mclmm9SliOAWyIPx6sYrzW280vH3TkVW7fmt91Af82sVVWwZM1vIbWkIzXY+a/8xLABGpcRw9vYo4mmhGoeb5/pB5TYBMSgE2R8BR3jXqtLYuvP3fVvYPAVQCGHeWogPDbOytppyQvV4U/6Z0pWuqSmicAIcrYBLHgAJk5CCzimQoIgY6mzvMTLfZAMUQFdVDGrlNAEexrjgzN57RLu6sVQDWGmUU05JPJ3oAkSg4bQ2KNp+wFtykWp8KjEzzxVnTCIwg6Fwg+//T6OZvcEDYFC5mQlqEcdZ1xwGB5jBhSc9aPiA1GOez0S11NyIO/IaLyXsaoxQO9AZaiEeDydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VC34lASvZLdATXb8w7IzR+cOBD0CgQRxTHSePPx769c=;
 b=gc74jeAfv8PRHB8NekjijS6hysCYOl9ssa86f8Wa3WTDymiAaZDjBbS9JgpHD+1bB8/Ia/3FF1/9qJ6MN4M9WtxuH38ILO/BQcPd2M1P94ntePw6H2swBo0wGxw7SwYJWz0q1tsyBmGmWXSSL2rN3VtaOP+NlVJLPlkP5Pj/W6QO98lEP2ekTGKDtlBNPO0YUQJoxzSgu7kQojrf5vfm7ve9QvX4av8qwyusS0YIgBvf8ZPuXNr7gLbv2+8Ld5HNRlo2LKR+TnYprDkl5lbmZ5vt1hqOeF0P4wCJME77jcwoBuzNT0Edthsdyt4KeVvFvFOA68/8CB4Gsjk+vBV4/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by SN6PR11MB3040.namprd11.prod.outlook.com (2603:10b6:805:db::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 17:53:05 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe%7]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 17:53:04 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Tomasz Nowicki" <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Topic: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Index: AQHYqQNV5DxKJST9sEC1NUps5Q8SMK2lqmdAgACFsACAANA2YIAAPbGAgAEmcOCAAAhjAIAAAu1w
Date:   Wed, 10 Aug 2022 17:53:04 +0000
Message-ID: <BL0PR11MB30423A9EE500C4081A281D078A659@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
 <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
 <c5d8f537-5695-42f0-88a9-de80e21f5f4c@semihalf.com>
 <BL0PR11MB304213273FA9FAC4EBC70FF88A629@BL0PR11MB3042.namprd11.prod.outlook.com>
 <ef9ffbde-445e-f00f-23c1-27e23b6cca4f@semihalf.com>
 <BL0PR11MB304290D4AACC3C1E2661C9668A659@BL0PR11MB3042.namprd11.prod.outlook.com>
 <f4b162a5-1da6-478f-fcab-d79cece32dde@semihalf.com>
In-Reply-To: <f4b162a5-1da6-478f-fcab-d79cece32dde@semihalf.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b136f6c-5539-48c3-9587-08da7af92d23
x-ms-traffictypediagnostic: SN6PR11MB3040:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qyT0Wje+KOPwdNFh10wEVDfqfciyV816+xB7JsUFwim3bnMrsJFt17bMFkecig93LHrjGfjd5M+Wgex2Q4siMIiT3XjarnQFEkS54EPnwsHoobJhb/5iDkV0a7AFXisNvWVPvy8CIlL7PES606G9bEXtIBGPnnuEJp7wBT/cNJAJAFiwhDsp7It+xnwgWSprYQ1c4DixT8eDIf9dC5KnqM7EJdhgUILInl2fou0nR3bcpfxXodHxhgqQiOhezMeqlSoYGQJBaNNKEAxJaykiGyRNHO7k5z+TH9ahQzosh31cv7rYk7p1CW4CNqIuEZINAHJGa6KNIBkPWGTRgolcN0bt7jzi/z69mw5fxoMxS/Ph8++VD070j/gBKq6Sn6vtTFuJ00jTF1yMUUzmorJMbhAap3KVq1/RO6D12j5u9jFAagjjyKfJYZF9Hxll8ey7DKHf9yoqErX8UeUX7zbnKT3ifjOQNNOLPiFTKwJSGVozRWDEn4uUoYccttapamjUirJcHCDYGRjTur1BipFZCBaS3gvL/W+WZMCb68pjmne+jvVAFXmEOLTPuFWScbqw5DuxNroxIt9ZIy6djM7POp2Uuim7EcMimxVaTiNabeKJAMOF57IufWig8AiXTtT0d5GbSVg57mLW629p0lqz9fyATr5VUxJZj3ARBdHLs+e8q/4nXl2sHerqOM4mT0QhC7INV/aTldzfPLxgWn7pZozUI11BVSAKonVx1KvmMVWFixh27Ek+Po9c9ORxhK8l+OeY7Ns5RvDOkezq4vo8gik9QogOU0faKbDEzUWo7vfBGTnPZ5qTWWgzSKBDpH+D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(136003)(376002)(39860400002)(55016003)(4326008)(66946007)(8676002)(66556008)(64756008)(5660300002)(66476007)(8936002)(7416002)(33656002)(110136005)(76116006)(66446008)(54906003)(316002)(478600001)(71200400001)(2906002)(38100700002)(38070700005)(122000001)(41300700001)(9686003)(7696005)(6506007)(53546011)(26005)(86362001)(82960400001)(52536014)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlVER3Y3TG9MNmxDZDdSTmloRzVzaE5mMGtTemlVZ25abk1QZHhDZlVEb1Y1?=
 =?utf-8?B?UEx0bXRFNyt1SldOeHR2UVNsdnUzeHNqT2QwZm1OaFJsQU96b3pjTTNoNTZl?=
 =?utf-8?B?dlRSR2xvbGxRYlJJOG9BdTVqVkhkdkZST0ZBTFdnQnJ4UjFFcDR2TUYwcmg4?=
 =?utf-8?B?WUE3MytoR0FlellrNWRDWm4wNzJyRXgrbWQyTWU4SVJCdVh1ZTRoc0ZnZ1k4?=
 =?utf-8?B?aHJJcHZsbEhyM2VCOHgwOUhDSDNjbDQzQ3h2TkxXTXZQYjZiSk9YUyt3aFRi?=
 =?utf-8?B?RXhKaEJWNzZaNFhKakhDL2pEeUpLNm1Td1BrR0FwaVVUeFBrZ1RXTnNUbmwx?=
 =?utf-8?B?ZjU0VU9FZ3F5ZkRhZEhVQXVLemtGNUFrOGd1TUdGQVg0WEtJUEhQS1VVd1Rs?=
 =?utf-8?B?bDJCbEg2WGZRMjUybHB4cEZEdHJRN2JUQURJU21Bek13SExqdDZTdDRLZkRn?=
 =?utf-8?B?czFUVmZvUGlGdDVtcGh1RUx6WVBVY0trbU43Y2xkMDNERUtCZENCZ0dYdkY4?=
 =?utf-8?B?aHMvdkN5YU1EOTdzTjlLc2pIZWFzcTE3Q2ViYnB5UzJ5Z09SbkQwTUpuQWJU?=
 =?utf-8?B?RkVZYVZ1UlErSENuRkxiWUFrSW9xcXpKOFgybkNIQ29yZUxpU2NhT0pkT3RF?=
 =?utf-8?B?VlpQMEtZdHlpS0dabGJFbUNpYisvZ0RYSkZnL0xRL1ZVV2ZPNXh6V3NmQUtL?=
 =?utf-8?B?ZmJ4UFRESHQrU0M1aFNuOG1lTDZ4V3ZGdnVoenVwNFB3NmhGNkh2elpiSm5E?=
 =?utf-8?B?Z0hJUHY5YnRRTFdGYTA3Uy82QTMweDMvSmZnV2UxNDJkbHZxWVg5RTF5Zktv?=
 =?utf-8?B?a1NuUlVJZ1NuenIxc3JNSDBmcVJVWmI0L1kyNTRVNS9UTnRtUGVxeVdEdERR?=
 =?utf-8?B?V0NpQS9kNHVlT1BIdlNEUlVad2VOZGlFcEVKUnpCMmw3OXFkbGduVXNUUldR?=
 =?utf-8?B?OFE1N2RDTFlONHpWQTdMcU1MWitTTU1Kc0E4eEpQdkVuQlJoREEzNTIxbkNw?=
 =?utf-8?B?bDB3cmp3RU5raVViMjgwZFZCTHRPbGQwYlY4TzZVRGd6bVNOYTRJK1dtZzZF?=
 =?utf-8?B?OUtVdGFuYm9VV1Q1aHNlcHdSRjJxcytpV3hBbTRGb1kyb1FnZXE3Z3RubFhT?=
 =?utf-8?B?ZWdYdmFtWDBXUWRGQ3lXZE40U3FPS0hrQ3JKMjJQMVRqczBGRURvalJ4MFBC?=
 =?utf-8?B?SDRrYVlGL2M1V3dkVXhidGVaTXEvZGxYbnB5V09UMDQ0OE9rSDFGZEdSeEJm?=
 =?utf-8?B?VitrRXhySXhmeFV6TzJ6WFVVR01zK2toVUJUTHlTR0EvUWJaTVlSWlJtRFYz?=
 =?utf-8?B?S25zd0xqWjlVaFRsZVZJeVNTSk9COHZvZUZiOVFaelFUbytlNkNmdkN5UnJW?=
 =?utf-8?B?azZITHBsVFJUcTkzRGNhTEdzbGhvS0Y5cVJ6NTNkWWxGSzlhSUtmRFduZE03?=
 =?utf-8?B?REY1QzRmNjQrNnFpeGh0aTVjc2pjOHFHY2pCcy9SOW5vYzk3bW9RSUdoUWwx?=
 =?utf-8?B?UWFyMW9uaVAwSDhOYXVnWXE1SEw1UlVBRGFRU2lqZXpWV0ptdktpQzB6U0Y4?=
 =?utf-8?B?NTNaSEVuejZPVnpxd1JHSHN0b2pxOVpXZDNMY2JOQ2JxRVVIcEV3UEc1TTRh?=
 =?utf-8?B?TXVRc0ljRGVpWlZQdVkvRU5rbzA2a0RDckJFYWxtV2ZDOE1lL2tpUW9PNzha?=
 =?utf-8?B?S1EwSC93NmFudnQyTjg2blFEYm4xYWF1QTIvb0pNOU1HajZacVE3WmVLekJP?=
 =?utf-8?B?RVZIM3o1Q1VNUEZjbVhVc2lLaXh1OWFlWjcrTEJ0eXNGellZM1d1a2t3RlBY?=
 =?utf-8?B?TUJBd0xZS2xDaXplOUhiY2wzTWczdS8xZk14eVNFUTU0SkZScnR3dGJHMjZY?=
 =?utf-8?B?cFVNZ25YMk1VTHh0NHNIL25qRkQzdHhFcXJTUXdsRXg1NFpEZnNna3NpNmln?=
 =?utf-8?B?OCtGRE5XZ3pjZ1l4dnVqUTJYc2V6SEE3aStkS0ZBNjlZOGVPY0M5RUkwZTd0?=
 =?utf-8?B?UHRPVkdJamVMWDBFVHRXNjd2UHBmRFB3Y3ZPd2tDWkRmNk03T0JRMm5RTmJP?=
 =?utf-8?B?U1FLVmRCQk5lU0pnaDhCTEZ0R1ovQnRjM2xzeStBcGM2MWN2RndaY0RCMVBz?=
 =?utf-8?Q?U4UHTaBYzzH3he9OcbB7dFWLe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b136f6c-5539-48c3-9587-08da7af92d23
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 17:53:04.8942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wq2JAZ0Fl7EJqH2CgvpNGc5pOabs8zZLTyz3MpUy4BurtyAUwt04Ae+LTGoqYfgGEpfsxY7S9W5nIcI0XvI/LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3040
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiA4LzEwLzIyIDc6MTcgUE0sIERvbmcsIEVkZGllIHdyb3RlOg0KPiA+Pj4NCj4gPj4+DQo+
ID4+Pj4gSG93ZXZlciwgd2l0aCBLVk0gKyB2ZmlvIChvciB3aGF0ZXZlciBpcyBsaXN0ZW5pbmcg
b24gdGhlDQo+ID4+Pj4gcmVzYW1wbGVmZCkgd2UgZG9uJ3QgY2hlY2sgdGhhdCB0aGUgaW50ZXJy
dXB0IGlzIHN0aWxsIG1hc2tlZCBpbg0KPiA+Pj4+IHRoZSBndWVzdCBhdCB0aGUgbW9tZW50DQo+
ID4+IG9mIEVPSS4NCj4gPj4+PiBSZXNhbXBsZWZkIGlzIG5vdGlmaWVkIHJlZ2FyZGxlc3MsIHNv
IHZmaW8gcHJlbWF0dXJlbHkgdW5tYXNrcyB0aGUNCj4gPj4+PiBob3N0IHBoeXNpY2FsIElSUSwg
dGh1cyBhIG5ldyAodW53YW50ZWQpIHBoeXNpY2FsIGludGVycnVwdCBpcw0KPiA+Pj4+IGdlbmVy
YXRlZCBpbiB0aGUgaG9zdCBhbmQgcXVldWVkIGZvciBpbmplY3Rpb24gdG8gdGhlIGd1ZXN0LiIN
Cj4gPj4+Pg0KPiA+Pj4NCj4gPj4+IEVtdWxhdGlvbiBvZiBsZXZlbCB0cmlnZ2VyZWQgSVJRIGlz
IGEgcGFpbiBwb2ludCDimLkgSSByZWFkIHdlIG5lZWQgdG8NCj4gPj4+IGVtdWxhdGUgdGhlICJs
ZXZlbCIgb2YgdGhlIElSUSBwaW4gKGNvbm5lY3RpbmcgZnJvbSBkZXZpY2UgdG8gSVJRY2hpcCwg
aS5lLg0KPiA+PiBpb2FwaWMgaGVyZSkuDQo+ID4+PiBUZWNobmljYWxseSwgdGhlIGd1ZXN0IGNh
biBjaGFuZ2UgdGhlIHBvbGFyaXR5IG9mIHZJT0FQSUMsIHdoaWNoDQo+ID4+PiB3aWxsIGxlYWQg
dG8gYSBuZXcgIHZpcnR1YWwgSVJRIGV2ZW4gdy9vIGhvc3Qgc2lkZSBpbnRlcnJ1cHQuDQo+ID4+
DQo+ID4+IFRoYW5rcywgaW50ZXJlc3RpbmcgcG9pbnQuIERvIHlvdSBtZWFuIHRoYXQgdGhpcyBi
ZWhhdmlvciAoYSBuZXcgdklSUQ0KPiA+PiBhcyBhIHJlc3VsdCBvZiBwb2xhcml0eSBjaGFuZ2Up
IG1heSBhbHJlYWR5IGhhcHBlbiB3aXRoIHRoZSBleGlzdGluZyBLVk0NCj4gY29kZT8NCj4gPj4N
Cj4gPj4gSXQgZG9lc24ndCBzZWVtIHNvIHRvIG1lLiBBRkFJQ1QsIEtWTSBjb21wbGV0ZWx5IGln
bm9yZXMgdGhlIHZJT0FQSUMNCj4gPj4gcG9sYXJpdHkgYml0LCBpbiBwYXJ0aWN1bGFyIGl0IGRv
ZXNuJ3QgaGFuZGxlIGNoYW5nZSBvZiB0aGUgcG9sYXJpdHkgYnkgdGhlIGd1ZXN0DQo+IChpLmUu
DQo+ID4+IGRvZXNuJ3QgdXBkYXRlIHRoZSB2aXJ0dWFsIElSUiByZWdpc3RlciwgYW5kIHNvIG9u
KSwgc28gaXQgc2hvdWxkbid0DQo+ID4+IHJlc3VsdCBpbiBhIG5ldyBpbnRlcnJ1cHQuDQo+ID4N
Cj4gPiBDb3JyZWN0LCBLVk0gZG9lc24ndCBoYW5kbGUgcG9sYXJpdHkgbm93LiBQcm9iYWJseSBi
ZWNhdXNlIHVubGlrZWx5DQo+ID4gdGhlIGNvbW1lcmNpYWwgT1NlcyB3aWxsIGNoYW5nZSBwb2xh
cml0eS4NCj4gPg0KPiA+Pg0KPiA+PiBTaW5jZSBjb21taXQgMTAwOTQzYzU0ZTA5ICgia3ZtOiB4
ODY6IGlnbm9yZSBpb2FwaWMgcG9sYXJpdHkiKSB0aGVyZQ0KPiA+PiBzZWVtcyB0byBiZSBhbiBh
c3N1bXB0aW9uIHRoYXQgS1ZNIGludGVycHJldGVzIHRoZSBJUlEgbGV2ZWwgdmFsdWUgYXMNCj4g
Pj4gYWN0aXZlIChhc3NlcnRlZCkgdnMgaW5hY3RpdmUgKGRlYXNzZXJ0ZWQpIHJhdGhlciB0aGFu
IGhpZ2ggdnMgbG93LCBpLmUuDQo+ID4NCj4gPiBBc3NlcnRlZC9kZWFzc2VydGVkIHZzLiBoaWdo
L2xvdyBpcyBzYW1lIHRvIG1lLCB0aG91Z2gNCj4gYXNzZXJ0ZWQvZGVhc3NlcnRlZCBoaW50cyBt
b3JlIGZvciBldmVudCByYXRoZXIgdGhhbiBzdGF0ZS4NCj4gPg0KPiA+PiB0aGUgcG9sYXJpdHkg
ZG9lc24ndCBtYXR0ZXIgdG8gS1ZNLg0KPiA+Pg0KPiA+PiBTbywgc2luY2UgYm90aCBzaWRlcyAo
S1ZNIGVtdWxhdGluZyB0aGUgSU9BUElDLCBhbmQgdmZpby93aGF0ZXZlcg0KPiA+PiBlbXVsYXRp
bmcgYW4gZXh0ZXJuYWwgaW50ZXJydXB0IHNvdXJjZSkgc2VlbSB0byBvcGVyYXRlIG9uIGEgbGV2
ZWwgb2YNCj4gPj4gYWJzdHJhY3Rpb24gb2YgImFzc2VydGVkIiB2cyAiZGUtYXNzZXJ0ZWQiIGlu
dGVycnVwdCBzdGF0ZSByZWdhcmRsZXNzDQo+ID4+IG9mIHRoZSBwb2xhcml0eSwgYW5kIHRoYXQg
c2VlbXMgbm90IGEgYnVnIGJ1dCBhIGZlYXR1cmUsIGl0IHNlZW1zDQo+ID4+IHRoYXQgd2UgZG9u
J3QgbmVlZCB0byBlbXVsYXRlIHRoZSBJUlEgbGV2ZWwgYXMgc3VjaC4gT3IgYW0gSSBtaXNzaW5n
DQo+IHNvbWV0aGluZz8NCj4gPg0KPiA+IFlFUywgSSBrbm93IGN1cnJlbnQgS1ZNIGRvZXNuJ3Qg
aGFuZGxlIGl0LiAgV2hldGhlciB3ZSBzaG91bGQgc3VwcG9ydCBpdCBpcw0KPiBhbm90aGVyIHN0
b3J5IHdoaWNoIEkgY2Fubm90IHNwZWFrIGZvci4NCj4gPiBQYW9sbyBhbmQgQWxleCBhcmUgdGhl
IHJpZ2h0IHBlcnNvbiDwn5iKDQo+ID4gVGhlIHJlYXNvbiBJIG1lbnRpb24gdGhpcyBpcyBiZWNh
dXNlIHRoZSBjb21wbGV4aXR5IHRvIGFkZGluZyBhIHBlbmRpbmcNCj4gZXZlbnQgdnMuIHN1cHBv
cnRpbmcgYSBpbnRlcnJ1cHQgcGluIHN0YXRlIGlzIHNhbWUuDQo+ID4gSSBhbSB3b25kZXJpbmcg
aWYgd2UgbmVlZCB0byByZXZpc2l0IGl0IG9yIG5vdC4gIEJlaGF2aW9yIGNsb3NpbmcgdG8gcmVh
bA0KPiBoYXJkd2FyZSBoZWxwcyB1cyB0byBhdm9pZCBwb3RlbnRpYWwgaXNzdWVzIElNTywgYnV0
IEkgYW0gZmluZSB0byBlaXRoZXIgY2hvaWNlLg0KPiANCj4gSSBndWVzcyB0aGF0IHdvdWxkIGlt
cGx5IHJldmlzaXRpbmcgS1ZNIGlycWZkIGludGVyZmFjZSwgc2luY2UgaXRzIGRlc2lnbiBpcyBi
YXNlZA0KPiByYXRoZXIgb24gZXZlbnRzIHRoYW4gc3RhdGVzLCBldmVuIGZvciBsZXZlbC10cmln
Z2VyZWQNCj4gaW50ZXJydXB0czoNCg0KV2UgY2FuIHJlYWQgMiBkaWZmZXJlbnQgZXZlbnRzOiAg
SVJRIGZpcmUvbm8tZmlyZSBldmVudCwgYW5kIHN0YXRlIGNoYW5nZSBldmVudCAoZm9yIGNvbnN1
bWVycyB0byBtYWludGFpbiBpbnRlcm5hbCBhc3NlcnQvZGVhc3NlcnQgc3RhdGUpLiANCklmIHdl
IHN3aXRjaCBmcm9tIHRoZSBmb3JtZXIgb25lIHRvIHRoZSBsYXRlciBvbmUuICBEbyB3ZSBuZWVk
IHRvIGNoYW5nZSB0aGUgaW50ZXJmYWNlPw0KDQpQcm9iYWJseSBuZWVkcyBQYW9sbyBhbmQgQWxl
eCB0byBnaXZlIGNsZWFyIGRpcmVjdGlvbiwgZ2l2ZW4gdGhhdCBBUk02NCBzaWRlIHNlZW1zIGhh
dmUgc2ltaWxhciBzdGF0ZSBjb25jZXB0IHRvby4NCg0KVGhhbmtzIERteXRybyENCg0KRWRkaWUN
Cg0KPiANCj4gLSB0cmlnZ2VyIGV2ZW50IChmcm9tIHZmaW8gdG8gS1ZNKSB0byBhc3NlcnQgYW4g
SVJRDQo+IC0gcmVzYW1wbGUgZXZlbnQgKGZyb20gS1ZNIHRvIHZmaW8pIHRvIGRlLWFzc2VydCBh
biBJUlENCj4gDQo+ID4NCj4gPj4NCj4gPj4gT1RPSCwgSSBndWVzcyB0aGlzIG1lYW5zIHRoYXQg
dGhlIGV4aXN0aW5nIEtWTSdzIGVtdWxhdGlvbiBvZg0KPiA+PiBsZXZlbC10cmlnZ2VyZWQgaW50
ZXJydXB0cyBpcyBzb21ld2hhdCBsaW1pdGVkIChhIGd1ZXN0IG1heQ0KPiA+PiBsZWdpdGltYXRl
bHkgZXhwZWN0IGFuIGludGVycnVwdCBmaXJlZCBhcyBhIHJlc3VsdCBvZiBwb2xhcml0eQ0KPiA+
PiBjaGFuZ2UsIGFuZCB0aGF0IGNhc2UgaXMgbm90IHN1cHBvcnRlZCBieSBLVk0pLiBCdXQgdGhh
dCBpcyByYXRoZXINCj4gPj4gb3V0IG9mIHNjb3BlIG9mIHRoZSBvbmVzaG90IGludGVycnVwdHMg
aXNzdWUgYWRkcmVzc2VkIGJ5IHRoaXMgcGF0Y2hzZXQuDQo+ID4NCj4gPiBBZ3JlZS4NCj4gPiBJ
IGRpZG4ndCBrbm93IGFueSBjb21tZXJjaWFsIE9TZXMgY2hhbmdlIHBvbGFyaXR5IGVpdGhlci4g
QnV0IEkga25vdyBYZW4NCj4gaHlwZXJ2aXNvciB1c2VzIHBvbGFyaXR5IHVuZGVyIGNlcnRhaW4g
Y29uZGl0aW9uLg0KPiA+IE9uZSBkYXksIHdlIG1heSBzZWUgdGhlIGlzc3VlIHdoZW4gcnVubmlu
ZyBYZW4gYXMgYSBMMSBoeXBlcnZpc29yLiAgQnV0IHRoaXMNCj4gaXMgbm90IHRoZSBjdXJyZW50
IHdvcnJ5Lg0KPiA+DQo+ID4NCj4gPj4NCj4gPj4+ICJwZW5kaW5nIiBmaWVsZCBvZiBrdm1fa2Vy
bmVsX2lycWZkX3Jlc2FtcGxlciBpbiBwYXRjaCAzIG1lYW5zIG1vcmUNCj4gPj4+IGFuDQo+ID4+
IGV2ZW50IHJhdGhlciB0aGFuIGFuIGludGVycnVwdCBsZXZlbC4NCj4gPg0KPiA+IEkga25vdy4g
IEkgYW0gZmluZSBlaXRoZXIuDQo+ID4NCj4gPiBUaGFua3MgRWRkaWUNCj4gPg0KPiA+Pj4NCj4g
Pj4+DQo=
