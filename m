Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B2E6F2020
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346500AbjD1VbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 17:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjD1VbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 17:31:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61362128
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 14:30:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFpId5lFuyhBdkbw0w/FNmT0shBMKlie2Pb1uRdQkb7AnSsahtDvnc/HzaWrEKkc5AcxNjc1DYloRHoADIAns/RY0LOSvMy6yECgLl50GocWaT5VmY2EVY4lB2zpUaoKjBoUPAMGSIFJJlZiboVqDUZ1RPwq8jCQjNlbgBu8iKUIrAZtxVTo/TawpMI+OCJjXWzM8HSFYY/a6+lhCjsQk9tTKAOo3i+Ia0TfhaUXCnCNE1ov18V9U7JaK6xeGcrJ4t60Dk4RDTkwWGRYDsliGgJVz2u7mjjYfpg5DEPUP/xoJplUchoDhIPnz7/RCGutA5y1rhunxDHWfGQZpt0Eog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuPLFuplqmzesVN7klGVPewueI5NELuXDjodxvotWcQ=;
 b=iaHWe6+dnsIALCBS5xiqdloX5cipJuIU4vO6ovxe3O5CjIx85obdb56a7cYnSYQ+nRFCW88NiKj89UlRqSu2ArWn18ZT8HY2FUBx0GT/2SMTKebgblanJqU/PCsIQpUAvuJQlDiDQHleoawZKtTVqpTagJ/BhtEp9H7Ectm/DNk/Qr/2sAI/tVysy2j2hn/mgQMoRDaNtKvXKUElqwM8EzH19jJxqMfOHvLGPet9ym8ZbEPw2iPqSw2IVs07mx52avtPzKLC42U2ueXhEvoN2uj7pkIe+kacukG1+Gzd1yLdxwATYwckTTiCcRU+d5P9xss3yNjp95bKuKe/c3vk8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuPLFuplqmzesVN7klGVPewueI5NELuXDjodxvotWcQ=;
 b=wt34O+C5UuU8ZASfC54WSgQbTNIxnuQJ6MBREUjmfCzEncV4OWjUhdWxAsUmaNHY+L6fg7lxGsyNQwewziIukZTvG+1X9B0dtVVh6SkmO+oFiPjDCs3I4maM8JoXVIC0hi+cn4XP/Mo5YkY4l/QF16yaPknxobC96DBVyoOHqbM=
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by BL0PR12MB4851.namprd12.prod.outlook.com (2603:10b6:208:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 21:30:55 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57ca:ec64:35da:a5b1]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57ca:ec64:35da:a5b1%7]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 21:30:54 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Maksim Davydov <davydov-max@yandex-team.ru>
CC:     "weijiang.yang@intel.com" <weijiang.yang@intel.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
        "paul@xen.org" <paul@xen.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "yang.zhong@intel.com" <yang.zhong@intel.com>,
        "jing2.liu@intel.com" <jing2.liu@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>
Subject: RE: [PATCH v3 2/7] target/i386: Add new EPYC CPU versions with
 updated cache_info
Thread-Topic: [PATCH v3 2/7] target/i386: Add new EPYC CPU versions with
 updated cache_info
Thread-Index: AQHZd3SiJO5iOT/Dm06W98EowUKkd688KFGAgAEcpICAA/okgA==
Date:   Fri, 28 Apr 2023 21:30:54 +0000
Message-ID: <MW3PR12MB4553A8B001C19846763AC339956B9@MW3PR12MB4553.namprd12.prod.outlook.com>
References: <20230424163401.23018-1-babu.moger@amd.com>
 <20230424163401.23018-3-babu.moger@amd.com>
 <2d5b21cb-7b09-f4e8-576f-31d9977aa70c@yandex-team.ru>
 <87b874ed-d6d6-4232-3214-b577ea929811@amd.com>
 <72506a15-47a5-3782-16aa-d43f27bd3489@yandex-team.ru>
In-Reply-To: <72506a15-47a5-3782-16aa-d43f27bd3489@yandex-team.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-04-28T21:30:53Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=45402393-0921-43a1-9d5d-a0004efab2c9;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2023-04-28T21:30:53Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 4349bc58-8eba-4b9f-810a-2862e219846b
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW3PR12MB4553:EE_|BL0PR12MB4851:EE_
x-ms-office365-filtering-correlation-id: e2345306-7ae8-4704-7730-08db482fd939
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YeK9uygaQlwxMMjcpKmQlclrqFg0HcMjzPWtITgR/wUKzrnKfht4YTdlxFZU8tpYwL/Z+HxhOvN6T1Uj2kQOVIfRmRpcEY6xzeDFeS09xcogmkFb5gGoXczl6o19pO2BR8E1KFEcj7LNFh2Mz0auO2StAA8sBIwzMAFjtEelFDdrShl6f1kf3lZh+7GzHm2hSQzljMUnBKbKicrNsnMCkmO6FQrc8WpepqCE1Zt223/jJaNJ+sGSlOYmc2O0c7vO6Z34gTiwNJRagnUpSjG66laeRTTIU7wMXBoRPiEZLyxv2VsuGn4m0e+8XG1GwR4pUWEltW0E1A56F/Z2BM/HIG17mR7ChPQWsE+jHWyR583WG/Ot8lyid5X09Imc4fYapV4PUabyG4Ju+a+O+b+2JJFIOhU0ylk2b5ICXirBcK6DveQw46sgJ62U87IACVo092N9MvOQeciNqX3HNmTrqxfpWeMpBGlLLzZYC6cv09Sxn2HBcc3sCE7ZOTHkcSZekjT24KcyoZKcKB4oA02e63daJci+boYSrzLtPxi2u78wobBuEM1g67CNQyD1N0ziYaqckeSxzjuxa6Yy4/k77cdhYtCi9Zni7DLfbnxNTt0yyqwQ/e4NXflmZwVmr1Uf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(15650500001)(6506007)(122000001)(55016003)(26005)(38100700002)(9686003)(38070700005)(8676002)(53546011)(186003)(83380400001)(52536014)(5660300002)(8936002)(2906002)(33656002)(7416002)(54906003)(86362001)(66446008)(4326008)(66556008)(478600001)(66946007)(7696005)(41300700001)(64756008)(6916009)(66476007)(76116006)(316002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2krcmc3MEFuTGZmY1oyU2p1SG0zY1dLbEdteCtUSStYUi9qS2JLVitRUUVK?=
 =?utf-8?B?UVkvdUVmelJsdG5CNmJoeGpHNDdtUENMNFF6c3BNN1ZKKzhIZmgwVTBDN3p1?=
 =?utf-8?B?S1doSzJ6Sys4RXlQb2t2WWpsNjVrbDlKeEQ1TFhpMXZsTkxJdVVPVDMrTCtU?=
 =?utf-8?B?OE43Z0dmZU81Uy9uVkd6YS9JV2JBZHlEZjFKOHdOWE4rYzc0eWVlanZvc09u?=
 =?utf-8?B?VWVOUmdxb2U5VXVwVXpJa1BLVXRQWDdyaHZHdWJvU3p4aXlyem82czVlc1Uy?=
 =?utf-8?B?ZTNmcjVpN0krU21KNkIzVkU2UXJXYjhaYlV0M3pMZWNiOUxjQjA0K0lMcWlI?=
 =?utf-8?B?and3WjlONzBQRlJSaHl3c21USHcwb3JLVzFoZS9wVW00S2kvTDhJUDViMDRD?=
 =?utf-8?B?cTFhUW1PaGM5WHQ1ejZRMU1hbHFtTVprNGt6M1ZqTEJvdXg0dnVrTjEvTVBR?=
 =?utf-8?B?RWoxSm5oQUZXdXduU3hyVG1ZT3QzdWxBK3BoVFgvSWhWZGRwUlFGUE10NUZw?=
 =?utf-8?B?SUdTck5Rcys0YUhrQTFaeFUycjJRbnc1RW51L1UwQ0tCWXhYRDJHQnhBRWhP?=
 =?utf-8?B?WWY3NU5EVVZ0RVZUa1gyS1VPcFRoK2w5cnJ6Q2pncDVPR0FQVEZMTlJaTFkv?=
 =?utf-8?B?bmVFdWZ5MGZna1JCUEJIL2d6cHoxZ0lxd1dyS1lMM2tEdnFJSlUyQkZjSnBP?=
 =?utf-8?B?dWd5bG5sY29aSnRQYUkvd3BrcnhKRW45Ym5YVVpIR0ovUlBiTW5NdHZtNngy?=
 =?utf-8?B?K0dTVTNTVTd4UzBWR2dvb1dYbzJrL2dIbUEyMnhYWWg1V3doelpQR2dNbCtW?=
 =?utf-8?B?SXhaR2NycHRSSGJuc2kxYnEwemdlWHZHR0ZhdHFYVGczUWFLdkNHNWRtWW5W?=
 =?utf-8?B?TC8rVWJoeDBqbTExNlNwMGhsclhXNGR0NTd3MzZ5a0pFcWlUTFRibWtsMkRU?=
 =?utf-8?B?Y3YrSGRadnozY0lDd1ZKeVVtcGR4eGVSb2R6U3VJYzBRL016ZXFROTRLaUJB?=
 =?utf-8?B?WDk3dGhSWkM4K25UU1M0cGJmaFpwdE1TTVhDNlRmVm40Um9lVHA2OUcxSUhr?=
 =?utf-8?B?aTBVUmM0YllTSnBmYkVQM0ozRmptYXVWZHBHVGFlenRSa2QwakJQT1JUR2Qr?=
 =?utf-8?B?V2xqa1pPUUU0cmJlQ3ZtK3JLSnU2NWdHM0R3V1lnNElnL0pIS0gvU1UzQXVr?=
 =?utf-8?B?a2hmazdJQzZGTU5PNHpIL25vTVljNzZCUWdMMXJERmNuZFZVcy9pYzYvVTBs?=
 =?utf-8?B?NXNmbGZaQ3Q2RHBCTjlDbER2dWIyV3N3R1JuOWM5K3RDUmhnTy9oZ0loY0d5?=
 =?utf-8?B?TUN5TVhzL3lFZHhZSHd3N0hzSHZJcnVhcWQ4aFRJdnhaL2lJUkRheTdsR2xO?=
 =?utf-8?B?TlZDNzZsRTliVHBwZzc3SWZyTStqWWlVTzY1ZERlUnJLYkdHajhTWCtUNXpN?=
 =?utf-8?B?ZDd4Ky9lenZ3K01XZWNLTXozMHhSckJ0OHB5NGxOY1kwSDN3a0VGT0Rra3JZ?=
 =?utf-8?B?eGdnTDlWcy9sSlk2TTBlOTEwbGNtNzR5QTNlelBTNkwycy84L1VTbmlBSjFx?=
 =?utf-8?B?TXZxdXJNMlVKdk1GdEhhcXEwbzJuWUQ3RVNjTXdnYkdRMWxGbDBWcGF4SW83?=
 =?utf-8?B?cXRpajNROWJaY29PdTl6VVdEWmRwZWt6cGZzQ3VyMFQxbkJCK0hESG9qOHJO?=
 =?utf-8?B?YUtpZW9sUnBPMlc4Z1pPYmpJb0NXellkWFB5VUpIYU9YMjhlMkdsb0xmL0xt?=
 =?utf-8?B?QjFzRG1yOUw1UDc0RDljVXllZGROM1VpT21UeWNVcGx6TmltK1VkNGMyVU4w?=
 =?utf-8?B?cFluSHBPWmxqTHVhVWhPbTMycGh6c3lCYW12V3IyOUJlc3VXUnhseVlOZFVR?=
 =?utf-8?B?OFRTZjQxUG9hc3dxckozZ2JwYXE1OWFBMVBaSHp0K3dZTHJQS1JZc3psazU0?=
 =?utf-8?B?aksxT3NaVmJTN0Q0REZ2R1pvTG10OG13eGJjeXQrQjcrT1V0TFJqd1JsR01X?=
 =?utf-8?B?UU1SZXVOQmduTitFNUR5QzNEaDkxUTBtbXJYVEdkckhUMllLRHYzeGQ0aEZw?=
 =?utf-8?B?OStFbmZyVVA3M3lsM1F0WFI0SXJSbnZSSi94Smo2dkYzNXV1eXpvZVFYZE5v?=
 =?utf-8?Q?ktEA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2345306-7ae8-4704-7730-08db482fd939
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 21:30:54.7925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YmkYojAKZJYTZRDNzN+OV132hfAenb6pin2JYYla0Te54StSm/VYb/saipBLhvcb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4851
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhpIE1ha3NpbSwNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYWtzaW0gRGF2eWRvdiA8ZGF2eWRvdi1t
YXhAeWFuZGV4LXRlYW0ucnU+DQo+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgMjYsIDIwMjMgMzoz
NSBBTQ0KPiBUbzogTW9nZXIsIEJhYnUgPEJhYnUuTW9nZXJAYW1kLmNvbT4NCj4gQ2M6IHdlaWpp
YW5nLnlhbmdAaW50ZWwuY29tOyBwaGlsbWRAbGluYXJvLm9yZzsgZHdtd0BhbWF6b24uY28udWs7
DQo+IHBhdWxAeGVuLm9yZzsgam9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbTsgcWVtdS1kZXZlbEBu
b25nbnUub3JnOw0KPiBtdG9zYXR0aUByZWRoYXQuY29tOyBrdm1Admdlci5rZXJuZWwub3JnOyBt
c3RAcmVkaGF0LmNvbTsNCj4gbWFyY2VsLmFwZmVsYmF1bUBnbWFpbC5jb207IHlhbmcuemhvbmdA
aW50ZWwuY29tOyBqaW5nMi5saXVAaW50ZWwuY29tOw0KPiB2a3V6bmV0c0ByZWRoYXQuY29tOyBS
b3RoLCBNaWNoYWVsIDxNaWNoYWVsLlJvdGhAYW1kLmNvbT47IEh1YW5nMiwgV2VpDQo+IDxXZWku
SHVhbmcyQGFtZC5jb20+OyBiZXJyYW5nZUByZWRoYXQuY29tOyBwYm9uemluaUByZWRoYXQuY29t
Ow0KPiByaWNoYXJkLmhlbmRlcnNvbkBsaW5hcm8ub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djMgMi83XSB0YXJnZXQvaTM4NjogQWRkIG5ldyBFUFlDIENQVSB2ZXJzaW9ucyB3aXRoDQo+IHVw
ZGF0ZWQgY2FjaGVfaW5mbw0KPiANCj4gDQo+IE9uIDQvMjUvMjMgMTg6MzUsIE1vZ2VyLCBCYWJ1
IHdyb3RlOg0KPiA+IEhpIE1ha3NpbSwNCj4gPg0KPiA+IE9uIDQvMjUvMjMgMDc6NTEsIE1ha3Np
bSBEYXZ5ZG92IHdyb3RlOg0KPiA+PiBPbiA0LzI0LzIzIDE5OjMzLCBCYWJ1IE1vZ2VyIHdyb3Rl
Og0KPiA+Pj4gRnJvbTogTWljaGFlbCBSb3RoIDxtaWNoYWVsLnJvdGhAYW1kLmNvbT4NCj4gPj4+
DQo+ID4+PiBJbnRyb2R1Y2UgbmV3IEVQWUMgY3B1IHZlcnNpb25zOiBFUFlDLXY0IGFuZCBFUFlD
LVJvbWUtdjMuDQo+ID4+PiBUaGUgb25seSBkaWZmZXJlbmNlIHZzLiBvbGRlciBtb2RlbHMgaXMg
YW4gdXBkYXRlZCBjYWNoZV9pbmZvIHdpdGgNCj4gPj4+IHRoZSAnY29tcGxleF9pbmRleGluZycg
Yml0IHVuc2V0LCBzaW5jZSB0aGlzIGJpdCBpcyBub3QgY3VycmVudGx5DQo+ID4+PiBkZWZpbmVk
IGZvciBBTUQgYW5kIG1heSBjYXVzZSBwcm9ibGVtcyBzaG91bGQgaXQgYmUgdXNlZCBmb3INCj4g
Pj4+IHNvbWV0aGluZyBlbHNlIGluIHRoZSBmdXR1cmUuIFNldHRpbmcgdGhpcyBiaXQgd2lsbCBh
bHNvIGNhdXNlIENQVUlEDQo+ID4+PiB2YWxpZGF0aW9uIGZhaWx1cmVzIHdoZW4gcnVubmluZyBT
RVYtU05QIGd1ZXN0cy4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFJvdGgg
PG1pY2hhZWwucm90aEBhbWQuY29tPg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogQmFidSBNb2dlciA8
YmFidS5tb2dlckBhbWQuY29tPg0KPiA+Pj4gQWNrZWQtYnk6IE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICDCoCB0YXJnZXQvaTM4Ni9jcHUuYyB8
IDExOA0KPiA+Pj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiA+Pj4gIMKgIDEgZmlsZSBjaGFuZ2VkLCAxMTggaW5zZXJ0aW9ucygrKQ0KPiA+Pj4NCj4g
Pj4+IGRpZmYgLS1naXQgYS90YXJnZXQvaTM4Ni9jcHUuYyBiL3RhcmdldC9pMzg2L2NwdS5jIGlu
ZGV4DQo+ID4+PiBlM2Q5ZWFhMzA3Li5jMWJjNDc2NjFkIDEwMDY0NA0KPiA+Pj4gLS0tIGEvdGFy
Z2V0L2kzODYvY3B1LmMNCj4gPj4+ICsrKyBiL3RhcmdldC9pMzg2L2NwdS5jDQo+ID4+PiBAQCAt
MTcwNyw2ICsxNzA3LDU2IEBAIHN0YXRpYyBjb25zdCBDUFVDYWNoZXMgZXB5Y19jYWNoZV9pbmZv
ID0gew0KPiA+Pj4gIMKgwqDCoMKgwqAgfSwNCj4gPj4+ICDCoCB9Ow0KPiA+Pj4gIMKgICtzdGF0
aWMgQ1BVQ2FjaGVzIGVweWNfdjRfY2FjaGVfaW5mbyA9IHsNCj4gPj4+ICvCoMKgwqAgLmwxZF9j
YWNoZSA9ICYoQ1BVQ2FjaGVJbmZvKSB7DQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnR5cGUgPSBE
QVRBX0NBQ0hFLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5sZXZlbCA9IDEsDQo+ID4+PiArwqDC
oMKgwqDCoMKgwqAgLnNpemUgPSAzMiAqIEtpQiwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAubGlu
ZV9zaXplID0gNjQsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLmFzc29jaWF0aXZpdHkgPSA4LA0K
PiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5wYXJ0aXRpb25zID0gMSwNCj4gPj4+ICvCoMKgwqDCoMKg
wqDCoCAuc2V0cyA9IDY0LA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5saW5lc19wZXJfdGFnID0g
MSwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAuc2VsZl9pbml0ID0gMSwNCj4gPj4+ICvCoMKgwqDC
oMKgwqDCoCAubm9faW52ZF9zaGFyaW5nID0gdHJ1ZSwNCj4gPj4+ICvCoMKgwqAgfSwNCj4gPj4+
ICvCoMKgwqAgLmwxaV9jYWNoZSA9ICYoQ1BVQ2FjaGVJbmZvKSB7DQo+ID4+PiArwqDCoMKgwqDC
oMKgwqAgLnR5cGUgPSBJTlNUUlVDVElPTl9DQUNIRSwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAu
bGV2ZWwgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zaXplID0gNjQgKiBLaUIsDQo+ID4+
PiArwqDCoMKgwqDCoMKgwqAgLmxpbmVfc2l6ZSA9IDY0LA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKg
IC5hc3NvY2lhdGl2aXR5ID0gNCwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAucGFydGl0aW9ucyA9
IDEsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnNldHMgPSAyNTYsDQo+ID4+PiArwqDCoMKgwqDC
oMKgwqAgLmxpbmVzX3Blcl90YWcgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zZWxmX2lu
aXQgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5ub19pbnZkX3NoYXJpbmcgPSB0cnVlLA0K
PiA+Pj4gK8KgwqDCoCB9LA0KPiA+Pj4gK8KgwqDCoCAubDJfY2FjaGUgPSAmKENQVUNhY2hlSW5m
bykgew0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC50eXBlID0gVU5JRklFRF9DQUNIRSwNCj4gPj4+
ICvCoMKgwqDCoMKgwqDCoCAubGV2ZWwgPSAyLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zaXpl
ID0gNTEyICogS2lCLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5saW5lX3NpemUgPSA2NCwNCj4g
Pj4+ICvCoMKgwqDCoMKgwqDCoCAuYXNzb2NpYXRpdml0eSA9IDgsDQo+ID4+PiArwqDCoMKgwqDC
oMKgwqAgLnBhcnRpdGlvbnMgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zZXRzID0gMTAy
NCwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAubGluZXNfcGVyX3RhZyA9IDEsDQo+ID4+PiArwqDC
oMKgIH0sDQo+ID4+PiArwqDCoMKgIC5sM19jYWNoZSA9ICYoQ1BVQ2FjaGVJbmZvKSB7DQo+ID4+
PiArwqDCoMKgwqDCoMKgwqAgLnR5cGUgPSBVTklGSUVEX0NBQ0hFLA0KPiA+Pj4gK8KgwqDCoMKg
wqDCoMKgIC5sZXZlbCA9IDMsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnNpemUgPSA4ICogTWlC
LA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5saW5lX3NpemUgPSA2NCwNCj4gPj4+ICvCoMKgwqDC
oMKgwqDCoCAuYXNzb2NpYXRpdml0eSA9IDE2LA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5wYXJ0
aXRpb25zID0gMSwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAuc2V0cyA9IDgxOTIsDQo+ID4+PiAr
wqDCoMKgwqDCoMKgwqAgLmxpbmVzX3Blcl90YWcgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKg
IC5zZWxmX2luaXQgPSB0cnVlLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5pbmNsdXNpdmUgPSB0
cnVlLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5jb21wbGV4X2luZGV4aW5nID0gZmFsc2UsDQo+
ID4+PiArwqDCoMKgIH0sDQo+ID4+PiArfTsNCj4gPj4+ICsNCj4gPj4+ICDCoCBzdGF0aWMgY29u
c3QgQ1BVQ2FjaGVzIGVweWNfcm9tZV9jYWNoZV9pbmZvID0gew0KPiA+Pj4gIMKgwqDCoMKgwqAg
LmwxZF9jYWNoZSA9ICYoQ1BVQ2FjaGVJbmZvKSB7DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
IC50eXBlID0gREFUQV9DQUNIRSwNCj4gPj4+IEBAIC0xNzU3LDYgKzE4MDcsNTYgQEAgc3RhdGlj
IGNvbnN0IENQVUNhY2hlcyBlcHljX3JvbWVfY2FjaGVfaW5mbw0KPiA9DQo+ID4+PiB7DQo+ID4+
PiAgwqDCoMKgwqDCoCB9LA0KPiA+Pj4gIMKgIH07DQo+ID4+PiAgwqAgK3N0YXRpYyBjb25zdCBD
UFVDYWNoZXMgZXB5Y19yb21lX3YzX2NhY2hlX2luZm8gPSB7DQo+ID4+PiArwqDCoMKgIC5sMWRf
Y2FjaGUgPSAmKENQVUNhY2hlSW5mbykgew0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC50eXBlID0g
REFUQV9DQUNIRSwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAubGV2ZWwgPSAxLA0KPiA+Pj4gK8Kg
wqDCoMKgwqDCoMKgIC5zaXplID0gMzIgKiBLaUIsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLmxp
bmVfc2l6ZSA9IDY0LA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5hc3NvY2lhdGl2aXR5ID0gOCwN
Cj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAucGFydGl0aW9ucyA9IDEsDQo+ID4+PiArwqDCoMKgwqDC
oMKgwqAgLnNldHMgPSA2NCwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAubGluZXNfcGVyX3RhZyA9
IDEsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnNlbGZfaW5pdCA9IDEsDQo+ID4+PiArwqDCoMKg
wqDCoMKgwqAgLm5vX2ludmRfc2hhcmluZyA9IHRydWUsDQo+ID4+PiArwqDCoMKgIH0sDQo+ID4+
PiArwqDCoMKgIC5sMWlfY2FjaGUgPSAmKENQVUNhY2hlSW5mbykgew0KPiA+Pj4gK8KgwqDCoMKg
wqDCoMKgIC50eXBlID0gSU5TVFJVQ1RJT05fQ0FDSEUsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAg
LmxldmVsID0gMSwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAuc2l6ZSA9IDMyICogS2lCLA0KPiA+
Pj4gK8KgwqDCoMKgwqDCoMKgIC5saW5lX3NpemUgPSA2NCwNCj4gPj4+ICvCoMKgwqDCoMKgwqDC
oCAuYXNzb2NpYXRpdml0eSA9IDgsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnBhcnRpdGlvbnMg
PSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zZXRzID0gNjQsDQo+ID4+PiArwqDCoMKgwqDC
oMKgwqAgLmxpbmVzX3Blcl90YWcgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zZWxmX2lu
aXQgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5ub19pbnZkX3NoYXJpbmcgPSB0cnVlLA0K
PiA+Pj4gK8KgwqDCoCB9LA0KPiA+Pj4gK8KgwqDCoCAubDJfY2FjaGUgPSAmKENQVUNhY2hlSW5m
bykgew0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC50eXBlID0gVU5JRklFRF9DQUNIRSwNCj4gPj4+
ICvCoMKgwqDCoMKgwqDCoCAubGV2ZWwgPSAyLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zaXpl
ID0gNTEyICogS2lCLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5saW5lX3NpemUgPSA2NCwNCj4g
Pj4+ICvCoMKgwqDCoMKgwqDCoCAuYXNzb2NpYXRpdml0eSA9IDgsDQo+ID4+PiArwqDCoMKgwqDC
oMKgwqAgLnBhcnRpdGlvbnMgPSAxLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgIC5zZXRzID0gMTAy
NCwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAubGluZXNfcGVyX3RhZyA9IDEsDQo+ID4+PiArwqDC
oMKgIH0sDQo+ID4+PiArwqDCoMKgIC5sM19jYWNoZSA9ICYoQ1BVQ2FjaGVJbmZvKSB7DQo+ID4+
PiArwqDCoMKgwqDCoMKgwqAgLnR5cGUgPSBVTklGSUVEX0NBQ0hFLA0KPiA+Pj4gK8KgwqDCoMKg
wqDCoMKgIC5sZXZlbCA9IDMsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnNpemUgPSAxNiAqIE1p
QiwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAubGluZV9zaXplID0gNjQsDQo+ID4+PiArwqDCoMKg
wqDCoMKgwqAgLmFzc29jaWF0aXZpdHkgPSAxNiwNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCAucGFy
dGl0aW9ucyA9IDEsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLnNldHMgPSAxNjM4NCwNCj4gPj4+
ICvCoMKgwqDCoMKgwqDCoCAubGluZXNfcGVyX3RhZyA9IDEsDQo+ID4+PiArwqDCoMKgwqDCoMKg
wqAgLnNlbGZfaW5pdCA9IHRydWUsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLmluY2x1c2l2ZSA9
IHRydWUsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqAgLmNvbXBsZXhfaW5kZXhpbmcgPSBmYWxzZSwN
Cj4gPj4+ICvCoMKgwqAgfSwNCj4gPj4+ICt9Ow0KPiA+Pj4gKw0KPiA+Pj4gIMKgIHN0YXRpYyBj
b25zdCBDUFVDYWNoZXMgZXB5Y19taWxhbl9jYWNoZV9pbmZvID0gew0KPiA+Pj4gIMKgwqDCoMKg
wqAgLmwxZF9jYWNoZSA9ICYoQ1BVQ2FjaGVJbmZvKSB7DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDC
oMKgIC50eXBlID0gREFUQV9DQUNIRSwNCj4gPj4+IEBAIC00MDkxLDYgKzQxOTEsMTUgQEAgc3Rh
dGljIGNvbnN0IFg4NkNQVURlZmluaXRpb24NCj4gPj4+IGJ1aWx0aW5feDg2X2RlZnNbXSA9IHsN
Cj4gPj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgeyAvKiBl
bmQgb2YgbGlzdCAqLyB9DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB9DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSwNCj4gPj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHsNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
LnZlcnNpb24gPSA0LA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAucHJv
cHMgPSAoUHJvcFZhbHVlW10pIHsNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB7ICJtb2RlbC1pZCIsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgICJBTUQgRVBZQy12NCBQcm9jZXNzb3IiIH0sDQo+ID4+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgeyAvKiBlbmQgb2YgbGlzdCAqLyB9
DQo+ID4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0sDQo+ID4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC5jYWNoZV9pbmZvID0gJmVweWNfdjRfY2FjaGVfaW5m
bw0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSwNCj4gPj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB7IC8qIGVuZCBvZiBsaXN0ICovIH0NCj4gPj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqAgfQ0KPiA+Pj4gIMKgwqDCoMKgwqAgfSwNCj4gPj4+IEBAIC00MjEwLDYgKzQzMTksMTUg
QEAgc3RhdGljIGNvbnN0IFg4NkNQVURlZmluaXRpb24NCj4gPj4+IGJ1aWx0aW5feDg2X2RlZnNb
XSA9IHsNCj4gPj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
eyAvKiBlbmQgb2YgbGlzdCAqLyB9DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB9DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSwNCj4gPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHsNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgLnZlcnNpb24gPSAzLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAucHJvcHMgPSAoUHJvcFZhbHVlW10pIHsNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB7ICJtb2RlbC1pZCIsDQo+ID4+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJBTUQgRVBZQy1Sb21lLXYzIFByb2Nlc3NvciIgfSwN
Cj4gPj4gV2hhdCBkbyB5b3UgdGhpbmsgYWJvdXQgYWRkaW5nIG1vcmUgaW5mb3JtYXRpb24gdG8g
dGhlIG1vZGVsIG5hbWUgdG8NCj4gPj4gcmV2ZWFsIGl0cyBrZXkgZmVhdHVyZT8gRm9yIGluc3Rh
bmNlLCBtb2RlbC1pZCBjYW4gYmUgIkVQWUMtUm9tZS12Mw0KPiA+PiAoTk8gSU5ERVhJTkcpIiwg
YmVjYXVzZSBvbmx5IGNhY2hlIGluZm8gd2FzIGFmZmVjdGVkLiBPciBhbGlhcyBjYW4gYmUNCj4g
Pj4gdXNlZCB0byBhY2hpZXZlIHRoZSBzYW1lIGVmZmVjdC4gSXQgd29ya3Mgd2VsbCBpbg0KPiA+
IEFjdHVhbGx5LCB3ZSBhbHJlYWR5IHRob3VnaHQgYWJvdXQgaXQuIEJ1dCBkZWNpZGVkIGFnYWlu
c3QgaXQuIFJlYXNvbg0KPiA+IGlzLCB3aGVuIHdlIGFkZCAiKE5PIElOREVYSU5HKSIgdG8gdjMs
IHdlIG5lZWQgdG8ga2VlcCB0ZXh0IGluIGFsbCB0aGUNCj4gPiBmdXR1cmUgcmV2aXNpb25zIHY0
IGV0YyBhbmQgb3RoZXIgY3B1IG1vZGVscy4gT3RoZXJ3aXNlIGl0IHdpbGwgZ2l2ZQ0KPiA+IHRo
ZSBpbXByZXNzaW9uIHRoYXQgbmV3ZXIgdmVyc2lvbnMgZG9lcyBub3Qgc3VwcG9ydCAiTk8gaW5k
ZXhpbmciLiBIb3BlIGl0DQo+IGhlbHBzLg0KPiA+DQo+IE1heWJlLCB0aGlzIGluZm9ybWF0aW9u
IGNhbiBiZSByZXZlYWxlZCBpbiB0aGUgbmFtZSBvZiBjYWNoZSBpbmZvIHN0cnVjdHVyZQ0KPiB0
aGF0IGRlc2NyaWJlcyB0aGUgbmV3IGNhY2hlLiBUaHVzIGl0IGNhbiBiZSByZXVzZWQgaW4gbmV3
ZXIgdmVyc2lvbnMgKHY0IGFuZA0KPiBldGMpIGFuZCBzaG93IGluZm8gYWJvdXQgY2hhbmdlcy4g
VGhpcywgb2YgY291cnNlLCB3aWxsIG5vdCB3b3JrIHdlbGwgZm9yIG5ldw0KPiBwcm9jZXNzb3Ig
bW9kZWxzLCBidXQgYXMgSSBzZWUsIHRoZSBuZXcgbW9kZWwgdGhlcmUgaXMgY3JlYXRlZCB3aXRo
IHVuc2V0DQo+IGNvbXBsZXhfaW5kZXhpbmcNCg0KQWRkaW5nIHNwZWNpYWwgYWxpYXNlcyBpcyBh
IHByb2JsZW0uIEl0IGNhdXNlcyBtb3JlIGNvbmZ1c2lvbiBhbmQgZnV0dXJlIG1haW50ZW5hbmNl
IGlzc3Vlcy4gV2UgZmVlbCBpdCBpcyBiZXR0ZXIgbm90IHRvIGFkZCBhbnkgc3BlY2lhbCBhbGlh
c2VzIGluIHRoaXMgY2FzZS4NCldpbGwgcGxhbiB0byBzZW5kIHY0IHdpdGggYWRkcmVzc2luZyBv
dGhlciBjb21tZW50cy4NClRoYW5rcw0KQmFidQ0K
